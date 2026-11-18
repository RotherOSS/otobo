package MIME::Field::ParamVal;

use MIME::Words;

=head1 NAME

MIME::Field::ParamVal - subclass of Mail::Field, for structured MIME fields


=head1 SYNOPSIS

    # Create an object for a content-type field:
    $field = new Mail::Field 'Content-type';

    # Set some attributes:
    $field->param('_'        => 'text/html');
    $field->param('charset'  => 'us-ascii');
    $field->param('boundary' => '---ABC---');

    # Same:
    $field->set('_'        => 'text/html',
		'charset'  => 'us-ascii',
		'boundary' => '---ABC---');

    # Get an attribute, or undefined if not present:
    print "no id!"  if defined($field->param('id'));

    # Same, but use empty string for missing values:
    print "no id!"  if ($field->paramstr('id') eq '');

    # Output as string:
    print $field->stringify, "\n";


=head1 DESCRIPTION

This is an abstract superclass of most MIME fields.  It handles
fields with a general syntax like this:

    Content-Type: Message/Partial;
	number=2; total=3;
	id="oc=jpbe0M2Yt4s@thumper.bellcore.com"

Comments are supported I<between> items, like this:

    Content-Type: Message/Partial; (a comment)
	number=2  (another comment) ; (yet another comment) total=3;
	id="oc=jpbe0M2Yt4s@thumper.bellcore.com"


=head1 PUBLIC INTERFACE

=over 4

=cut

#------------------------------

require 5.001;

# Pragmas:
use strict;
use re 'taint';
use vars qw($VERSION @ISA);


# Other modules:
use Mail::Field;

# Kit modules:
use MIME::Tools qw(:config :msgs);

@ISA = qw(Mail::Field);


#------------------------------
#
# Public globals...
#
#------------------------------

# The package version, both in 1.23 style *and* usable by MakeMaker:
$VERSION = "5.522";


#------------------------------
#
# Private globals...
#
#------------------------------

# Pattern to match parameter names (like fieldnames, but = not allowed):
my $PARAMNAME = '[^\x00-\x1f\x80-\xff :;=()]+?';

# Pattern to match the first value on the line:
my $FIRST    = '[^\s\;"(\x00-\x1f\x80-\xff]*';

# Pattern to match an RFC 2045 token:
#
#      token      =  1*<any  (ASCII) CHAR except SPACE, CTLs, or tspecials>
#
my $TSPECIAL = '()<>@,;:\</[]?="';

#" Fix emacs highlighting...

my $TOKEN    = '[^ \x00-\x1f\x80-\xff' . "\Q$TSPECIAL\E" . ']+';

my $QUOTED_STRING = '"([^\\\\"]*(?:\\\\.(?:[^\\\\"]*))*)"';

# Encoded token:
my $ENCTOKEN = "=\\?[^?;\"]*\\?[A-Za-z]\\?[^?;\"]+\\?=";

# pattern to match comments
# (one that holds ; or " would hide a parameter from other readers)
my $COMMENT  = '\([^();"]*\)';

# Pattern to match spaces or comments:
my $SPCZ     = '(?:\s|' . $COMMENT . ')*';

# Pattern to match non-semicolon as fallback for broken MIME
# produced by some viruses
my $BADTOKEN = '[^;]+';

# Pattern to match whitespace allowed in header
my $WSP      = '[\t\ ]';

#------------------------------
#
# Class init...
#
#------------------------------

#------------------------------

=item set [\%PARAMHASH | KEY=>VAL,...,KEY=>VAL]

I<Instance method.>  Set this field.
The paramhash should contain parameter names
in I<all lowercase>, with the special C<"_"> parameter name
signifying the "default" (unnamed) parameter for the field:

   # Set up to be...
   #
   #     Content-type: Message/Partial; number=2; total=3; id="ocj=pbe0M2"
   #
   $conttype->set('_'       => 'Message/Partial',
		  'number'  => 2,
		  'total'   => 3,
		  'id'      => "ocj=pbe0M2");

Note that a single argument is taken to be a I<reference> to
a paramhash, while multiple args are taken to be the elements
of the paramhash themselves.

Supplying undef for a hashref, or an empty set of values, effectively
clears the object.

The self object is returned.

=cut

sub set {
    my $self = shift;
    my $params = ((@_ == 1) ? (shift || {}) : {@_});
    %$self = %$params;    # set 'em
    $self;
}

#------------------------------

=item parse_params STRING

I<Class/instance utility method.>
Extract parameter info from a structured field, and return
it as a hash reference.  For example, here is a field with parameters:

    Content-Type: Message/Partial;
	number=2; total=3;
	id="oc=jpbe0M2Yt4s@thumper.bellcore.com"

Here is how you'd extract them:

    $params = $class->parse_params('content-type');
    if ($$params{'_'} eq 'message/partial') {
	$number = $$params{'number'};
	$total  = $$params{'total'};
	$id     = $$params{'id'};
    }

Like field names, parameter names are coerced to lowercase.
The special '_' parameter means the default parameter for the
field.

B<NOTE:> This has been provided as a public method to support backwards
compatibility, but you probably shouldn't use it.

=cut

sub rfc2231decode {
    my($val) = @_;
    my($enc, $lang, $rest);

    local($1,$2,$3);
    if ($val =~ m/^([^']*)'([^']*)'(.*)\z/s) {
	$enc = $1;
	$lang = $2;
	$rest = $3;
    } elsif ($val =~ m/^([^']*)'([^']*)\z/s) {
	$enc = $1;
	$rest = $2;
    } else {
	$rest = $val;
	# $enc remains undefined when charset/language info is missing
    }
    return ($enc, $lang, $rest);
}

sub rfc2231percent {
    # Do percent-substitution
    my($str) = @_;
    local $1;
    $str =~ s/%([0-9a-fA-F]{2})/pack("C", hex($1))/ge;
    return $str;
}

sub parse_params {
    my ($self, $raw) = @_;
    my %params;
    my %dup_params;
    my %empty_params;
    my %rfc2231params;
    my %rfc2231encoding_is_used;
    my $param;
    my $val;
    my $part;

    # Get raw field, and unfold it:
    defined($raw) or $raw = '';
    $raw =~ s/\n//g;
    $raw =~ s/\s+\z//;              # Strip trailing whitespace

    local($1,$2,$3,$4,$5);
    # Extract special first parameter:
    $raw =~ m/\A$SPCZ($FIRST)$SPCZ/og or return {};    # nada!
    $params{'_'} = $1;

    my $boundary_leftover = 0;
    my $saw_semicolon= 0;

    # Extract subsequent parameters.
    # No, we can't just "split" on semicolons: they're legal in quoted strings!
    while (1) {                     # keep chopping away until done...
	$saw_semicolon = 0;
	$raw =~ m/\G([^;]*)(\;$SPCZ)+/ogc or last;             # skip leading separator
	my $leftover = $1;
	# a comment still open at this ";" hides it from other readers
	$params{'@unparsed_parameters'} = 1 if $leftover =~ /\([^)]*\z/;
	# an odd '"' here makes readers that count quotes split elsewhere
	$params{'@unparsed_parameters'} = 1 if ($leftover =~ tr/"//) % 2;
	$saw_semicolon = 1;

	# the previous param was 'boundary' and we had leftover data
	if (defined($leftover) && length($leftover) > 0 && defined($param) && $param eq 'boundary') {
	    $boundary_leftover = 1;
	}

	unless ($raw =~ m/\G($PARAMNAME)($COMMENT|$WSP)*=($COMMENT|$WSP)*/ogc) {
	    # give up if not a param, noting if a later parameter is lost
	    $params{'@unparsed_parameters'} = 1 if substr($raw, pos($raw)) =~ /=/;
	    last;
	}
	$param = lc($1);
	$raw =~ m/\G(?:$QUOTED_STRING|($ENCTOKEN)|($TOKEN)|($BADTOKEN)|())/gc or last;
	my ($qstr, $enctoken, $token, $badtoken, $empty_value) = ($1, $2, $3, $4, $5);
	if (defined($qstr)) {
	    # readers that count quotes take a final \" as escaped
	    $params{'@unparsed_parameters'} = 1 if $qstr =~ /\\\z/;
            # unescape
	    $qstr =~ s/\\(.)/$1/g;
	}
	if (defined($badtoken)) {
	    # Strip leading/trailing whitespace from badtoken
	    $badtoken =~ s/^$WSP+//;
	    $badtoken =~ s/$WSP+\z//;

	    # Only keep token parameters in badtoken;
	    # cut it off at the first non-token char.  CPAN RT #105455
	    my $old_badtoken = $badtoken;
	    $badtoken =~ /^($TOKEN)*/;
	    $badtoken = $1;
	    if (defined($badtoken)) {
		    # Cut it off at first whitespace too
		    $badtoken =~ s/\s.*//;
	    }

	    # there was a leftover after the last valid token
	    if ($param eq 'boundary') {
		$boundary_leftover = 1 if defined($badtoken) && $badtoken ne $old_badtoken;
		$boundary_leftover = 1 if !defined($badtoken) && length($old_badtoken) > 0;
	    }
	}
	$val = defined($qstr) ? $qstr :
	    (defined($enctoken) ? $enctoken :
	     (defined($badtoken) ? $badtoken :
              (defined($token) ? $token : $empty_value)));

	# Do RFC 2231 processing
	# Pick out the parts of the parameter
	if ($param =~ /\*/ &&
            $param =~ /^ ([^*]+) (?: \* ([^*]+) )? (\*)? \z/xs) {
	    # We have param*number* or param*number or param*
	    my($name, $num) = ($1, $2||0);
	    if (defined($3)) {
		# We have param*number* or param*
		# RFC 2231: Asterisks ("*") are reused to provide the
		# indicator that language and character set information
		# is present and encoding is being used
		$val = rfc2231percent($val);
		$rfc2231encoding_is_used{$name} = 1;
	    }
	    # A section number is digits, and "0" and "00" are the same section
	    if ($num !~ /\A[0-9]+\z/ || exists($rfc2231params{$name}{0 + $num})) {
	        $dup_params{$name} = 1;
	    }
	    $num = 0 + $num if $num =~ /\A[0-9]+\z/;
	    $rfc2231params{$name}{$num} .= $val;
	} else {
	    # Assign non-rfc2231 value directly.  If we
	    # did get a mix of rfc2231 and non-rfc2231 values,
            # the non-rfc2231 will be blown away in the
            # "extract reconstructed parameters" loop.
            if (defined($params{$param})) {
                $dup_params{$param} = 1;
            }
            $params{$param} = $val;
	}
        if (($val // '') eq '') {
            # Allow filename and name parameters to be empty
            if ($param ne 'name' && $param ne 'filename') {
                $empty_params{$param} = 1;
            }
        }
    }

    # the last field was 'boundary' and there were non separator characters left
    my $pos = pos($raw);
    if (($param // '') eq 'boundary' && defined($pos) && $pos < length($raw) && !$saw_semicolon) {
	$boundary_leftover = 1;
    }

    my $boundary_is_rfc2231 = 0;

    # Extract reconstructed parameters
    foreach $param (keys %rfc2231params) {
	# If we got any rfc-2231 parameters, then
        # blow away any potential non-rfc-2231 parameter.
        if (defined($params{$param})) {
            $dup_params{$param} = 1;
        }
	$params{$param} = '';
	# sections must run 0, 1, 2, ... or other readers join another value
	my @parts = sort { $a <=> $b } keys %{$rfc2231params{$param}};
	$dup_params{$param} = 1 if grep { $parts[$_] ne $_ } 0 .. $#parts;
	foreach $part (sort { $a <=> $b } keys %{$rfc2231params{$param}}) {
	    $params{$param} .= $rfc2231params{$param}{$part};
	}
	if ($rfc2231encoding_is_used{$param}) {
	    # there is no reason for the boundary to be encoded this way, since
	    # non-ascii characters are not allowed later anyway, so mark this
	    $boundary_is_rfc2231 = 1 if $param eq 'boundary';
	    my($enc, $lang, $val) = rfc2231decode($params{$param});
	    if (defined $enc) {
		# an empty or malformed charset is read as US-ASCII
		$enc = 'US-ASCII' unless $enc =~ /\A[A-Za-z0-9!#\$%&+^_`{}~-]+\z/;
		# re-encode as QP, preserving charset info
		$val =~ s{([=?_\x00-\x1F\x7F-\xFF])}
			 {sprintf("=%02X", ord($1))}eg;
		$val =~ tr/ /_/;
		$params{$param} = '=?' . $enc . '?Q?' . $val . '?=';
	    }
	}
        if ($params{$param} eq '') {
            # Allow filename and name parameters to be empty
            if ($param ne 'name' && $param ne 'filename') {
                $empty_params{$param} = 1;
            }
        }
	debug "   field param <$param> = <$params{$param}>";
    }

    # Check the boundary as multipart_boundary() sees it, after any
    # RFC 2231 continuations have been joined
    if (defined($params{'boundary'})) {
        # Mark parse ambiguous if boundary parameter is encoded, wholly
        # or in part, or has the "?= =?" that decode_mimewords() joins
        if ($params{'boundary'} =~ /^=\?.*\?[A-Z]\?.*\?=$/i ||
            $params{'boundary'} =~ /=\?[^?]*\?[A-Z]\?[^?]*\?=/i ||
            $params{'boundary'} =~ /\?=\s+=\?/) {
            $params{'@boundary_ambiguous'} = 1;
        }
        # multipart_boundary() strips trailing whitespace per RFC 2046,
        # so a verbatim parser sees a different boundary: mark ambiguous
        if ($params{'boundary'} =~ /\s+\z/) {
            $params{'@boundary_ambiguous'} = 1;
        }
    }

    # If there are any duplicate parameters, store them in the
    # special key '@duplicate_parameters' which should never be the
    # name of a real parameter
    if (%dup_params) {
        $params{'@duplicate_parameters'} = [ sort(keys(%dup_params)) ];
    }

    # If there are any empty parameters, store them in the
    # special key '@empty_parameters' which should never be the
    # name of a real parameter
    if (%empty_params) {
        $params{'@empty_parameters'} = [ sort(keys(%empty_params)) ];
    }

    if ($boundary_is_rfc2231 || $boundary_leftover) {
	$params{'@boundary_ambiguous'} = 1;
    }

    # Done:
    \%params;
}

#------------------------------

=item parse STRING

I<Class/instance method.>
Parse the string into the instance.  Any previous information is wiped.
The self object is returned.

May also be used as a constructor.

=cut

sub parse {
    my ($self, $string) = @_;

    # Allow use as constructor, for MIME::Head:
    ref($self) or $self = bless({}, $self);

    # Get params, and stuff them into the self object:
    $self->set($self->parse_params($string));
}

#------------------------------

=item param PARAMNAME,[VALUE]

I<Instance method.>
Return the given parameter, or undef if it isn't there.
With argument, set the parameter to that VALUE.
The PARAMNAME is case-insensitive.  A "_" refers to the "default" parameter.

=cut

sub param {
    my ($self, $paramname, $value) = @_;
    $paramname = lc($paramname);
    $self->{$paramname} = $value if (@_ > 2);
    $self->{$paramname}
}

#------------------------------

=item paramstr PARAMNAME,[VALUE]

I<Instance method.>
Like param(): return the given parameter, or I<empty> if it isn't there.
With argument, set the parameter to that VALUE.
The PARAMNAME is case-insensitive.  A "_" refers to the "default" parameter.

=cut

sub paramstr {
    my $val = shift->param(@_);
    (defined($val) ? $val : '');
}

#------------------------------

=item stringify

I<Instance method.>
Convert the field to a string, and return it.

=cut

sub stringify {
    my $self = shift;
    my ($key, $val);

    my $str = $self->{'_'};                   # default subfield
    foreach $key (sort keys %$self) {
	next if ($key !~ /^[a-z][a-z-_0-9]*$/);  # only lowercase ones!
	defined($val = $self->{$key}) or next;
        $val =~ s/(["\\])/\\$1/g;
	$str .= qq{; $key="$val"};
    }
    $str;
}

#------------------------------

=item tag

I<Instance method, abstract.>
Return the tag for this field.

=cut

sub tag { '' }

=back

=head1 SEE ALSO

L<Mail::Field>

=cut

#------------------------------
1;
