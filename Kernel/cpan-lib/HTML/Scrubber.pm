package HTML::Scrubber;

# ABSTRACT: Perl extension for scrubbing/sanitizing HTML

=begin :prelude

=for stopwords html cpan callback homepage Perlbrew perltidy repository

=end :prelude

=head1 SYNOPSIS

    use HTML::Scrubber;

    my $scrubber = HTML::Scrubber->new( allow => [ qw[ p b i u hr br ] ] );
    print $scrubber->scrub('<p><b>bold</b> <em>missing</em></p>');
    # output is: <p><b>bold</b> </p>

    # more complex input
    my $html = q[
    <style type="text/css"> BAD { background: #666; color: #666;} </style>
    <script language="javascript"> alert("Hello, I am EVIL!");    </script>
    <HR>
        a   => <a href=1>link </a>
        br  => <br>
        b   => <B> bold </B>
        u   => <U> UNDERLINE </U>
    ];

    print $scrubber->scrub($html);

    $scrubber->deny( qw[ p b i u hr br ] );

    print $scrubber->scrub($html);


=head1 DESCRIPTION

If you want to "scrub" or "sanitize" html input in a reliable and flexible
fashion, then this module is for you.

I wasn't satisfied with L<HTML::Sanitizer> because it is based on
L<HTML::TreeBuilder>, so I thought I'd write something similar that works
directly with L<HTML::Parser>.

=head1 METHODS

First a note on documentation: just study the L<EXAMPLE|"EXAMPLE"> below. It's
all the documentation you could need.

Also, be sure to read all the comments as well as L<How does it work?|"How does
it work?">.

If you're new to perl, good luck to you.

=cut

use 5.008;    # enforce minimum perl version of 5.8
use strict;
use warnings;
use HTML::Parser 3.47 ();
use HTML::Entities;
use Scalar::Util ('weaken');
use List::Util 1.33 qw(any);

our ( @_scrub, @_scrub_fh );

our $VERSION = '0.20';
# AUTHORITY

# my my my my, these here to prevent foolishness like
# http://perlmonks.org/index.pl?node_id=251127#Stealing+Lexicals
(@_scrub)    = ( \&_scrub,    "self, event, tagname, attr, attrseq, text" );
(@_scrub_fh) = ( \&_scrub_fh, "self, event, tagname, attr, attrseq, text" );

=head2 new

    my $scrubber = HTML::Scrubber->new( allow => [ qw[ p b i u hr br ] ] );

Build a new L<HTML::Scrubber>.  The arguments are the initial values for the
following directives:-

=over 4

=item * default

=item * allow

=item * deny

=item * rules

=item * process

=item * comment

=item * preempt

=back


=cut

sub new {
    my $package = shift;

    my $p       = HTML::Parser->new(
        api_version             => 3,
        default_h               => \@_scrub,
        marked_sections         => 0,
        strict_comment          => 0,
        unbroken_text           => 1,
        case_sensitive          => 0,
        boolean_attribute_value => undef,
        empty_element_tags      => 1,
    );

    my $self = {
        _p                 => $p,
        _rules             => { '*' => 0, },
        _comment           => 0,
        _process           => 0,
        _r                 => "",
        _optimize          => 1,
        _script            => 0,
        _style             => 0,
        _preempt           => 0,
        _ignore_empty_end  => 0,
    };

    $p->{"\0_s"} = bless $self, $package;
    weaken( $p->{"\0_s"} );

    return $self unless @_;

    my (%args) = @_;

    for my $f (qw[ default allow deny rules process comment preempt ]) {
        next unless exists $args{$f};

        if ( $f eq 'preempt' && ref $args{$f} eq 'CODE' ) {
            $self->$f( $args{$f} );
        }
        elsif ( ref $args{$f} ) {
            $self->$f( @{ $args{$f} } );
        }
        else {
            $self->$f( $args{$f} );
        }
    }

    return $self;
}

=head2 comment

    warn "comments are  ", $p->comment ? 'allowed' : 'not allowed';
    $p->comment(0);  # off by default

=cut

sub comment {
    return $_[0]->{_comment}
        if @_ == 1;
    $_[0]->{_comment} = $_[1];
    return;
}

=head2 preempt

    $p->preempt(0);  # off by default

=cut

sub preempt {
    return $_[0]->{_preempt}
        if @_ == 1;
    $_[0]->{_preempt} = $_[1];
    return;
}

=head2 process

    warn "process instructions are  ", $p->process ? 'allowed' : 'not allowed';
    $p->process(0);  # off by default

=cut

sub process {
    return $_[0]->{_process}
        if @_ == 1;
    $_[0]->{_process} = $_[1];
    return;
}

=head2 script

    warn "script tags (and everything in between) are supressed"
        if $p->script;      # off by default
    $p->script( 0 || 1 );

B<**> Please note that this is implemented using L<HTML::Parser>'s
C<ignore_elements> function, so if C<script> is set to true, all script tags
encountered will be validated like all other tags.

=cut

sub script {
    return $_[0]->{_script}
        if @_ == 1;
    $_[0]->{_script} = $_[1];
    return;
}

=head2 style

    warn "style tags (and everything in between) are supressed"
        if $p->style;       # off by default
    $p->style( 0 || 1 );

B<**> Please note that this is implemented using L<HTML::Parser>'s
C<ignore_elements> function, so if C<style> is set to true, all style tags
encountered will be validated like all other tags.

=cut

sub style {
    return $_[0]->{_style}
        if @_ == 1;
    $_[0]->{_style} = $_[1];
    return;
}

=head2 allow

    $p->allow(qw[ t a g s ]);

=cut

sub allow {
    my $self = shift;
    for my $k (@_) {
        $self->{_rules}{ lc $k } = 1;
    }
    $self->{_optimize} = 1;    # each time a rule changes, reoptimize when parse

    return;
}

=head2 deny

    $p->deny(qw[ t a g s ]);

=cut

sub deny {
    my $self = shift;

    for my $k (@_) {
        $self->{_rules}{ lc $k } = 0;
    }

    $self->{_optimize} = 1;    # each time a rule changes, reoptimize when parse

    return;
}

=head2 rules

    $p->rules(
        img => {
            src => qr{^(?!http://)}i, # only relative image links allowed
            alt => 1,                 # alt attribute allowed
            '*' => 0,                 # deny all other attributes
        },
        a => {
            href => sub { ... },      # check or adjust with a callback
        },
        b => 1,
        ...
    );

Updates a set of attribute rules. Each rule can be 1/0, a regular expression or
a callback. Values longer than 1 char are treated as regexps. The callback is
called with the following arguments: the current object, tag name, attribute
name, and attribute value; the callback should return an empty list to drop the
attribute, C<undef> to keep it without a value, or a new scalar value.

=cut

sub rules {
    my $self = shift;
    my (%rules) = @_;
    for my $k ( keys %rules ) {
        $self->{_rules}{ lc $k } = $rules{$k};
    }

    $self->{_optimize} = 1;    # each time a rule changes, reoptimize when parse

    return;
}

=head2 default

    print "default is ", $p->default();
    $p->default(1);      # allow tags by default
    $p->default(
        undef,           # don't change
        {                # default attribute rules
            '*' => 1,    # allow attributes by default
        }
    );

=cut

sub default {
    return $_[0]->{_rules}{'*'}
        if @_ == 1;

    $_[0]->{_rules}{'*'} = $_[1] if defined $_[1];
    $_[0]->{_rules}{'_'} = $_[2] if defined $_[2] and ref $_[2];
    $_[0]->{_optimize} = 1;    # each time a rule changes, reoptimize when parse

    return;
}

=head2 scrub_file

    $html = $scrubber->scrub_file('foo.html');   ## returns giant string
    die "Eeek $!" unless defined $html;  ## opening foo.html may have failed
    $scrubber->scrub_file('foo.html', 'new.html') or die "Eeek $!";
    $scrubber->scrub_file('foo.html', *STDOUT)
        or die "Eeek $!"
            if fileno STDOUT;

=cut

sub scrub_file {
    if ( @_ > 2 ) {
        return unless defined $_[0]->_out( $_[2] );
    }
    else {
        $_[0]->{_p}->handler( default => @_scrub );
    }

    $_[0]->_optimize();    #if $_[0]->{_optimize};

    $_[0]->{_p}->parse_file( $_[1] );

    return delete $_[0]->{_r} unless exists $_[0]->{_out};
    print { $_[0]->{_out} } $_[0]->{_r} if length $_[0]->{_r};
    delete $_[0]->{_out};
    return 1;
}

=head2 scrub

    print $scrubber->scrub($html);  ## returns giant string
    $scrubber->scrub($html, 'new.html') or die "Eeek $!";
    $scrubber->scrub($html', *STDOUT)
        or die "Eeek $!"
            if fileno STDOUT;


=cut

sub scrub {
    if ( @_ > 2 ) {
        return unless defined $_[0]->_out( $_[2] );
    }
    else {
        $_[0]->{_p}->handler( default => @_scrub );
    }

    $_[0]->_optimize();    # if $_[0]->{_optimize};

    $_[0]->{_p}->parse( $_[1] ) if defined( $_[1] );
    $_[0]->{_p}->eof();

    return delete $_[0]->{_r} unless exists $_[0]->{_out};
    delete $_[0]->{_out};
    return 1;
}

=for comment _out
    $scrubber->_out(*STDOUT) if fileno STDOUT;
    $scrubber->_out('foo.html') or die "eeek $!";

=cut

sub _out {
    my ( $self, $o ) = @_;

    unless ( ref $o and ref \$o ne 'GLOB' ) {
        open my $F, '>', $o or return;
        binmode $F;
        $self->{_out} = $F;
    }
    else {
        $self->{_out} = $o;
    }

    $self->{_p}->handler( default => @_scrub_fh );

    return 1;
}

=for comment _validate
Uses $self->{_rules} to do attribute validation.
Takes tag, rule('_' || $tag), attrref, attrseq.

The rule indicator C<'_'> indicates that the default attribute rules should be used.

=cut

sub _validate {
    my ( $s, $t, $r, $a, $as ) = @_;

    return "<$t>" unless %$a;

    $r = $s->{_rules}->{$r};
    my %f;

    for my $k ( keys %$a ) {
        my $check = exists $r->{$k} ? $r->{$k} : exists $r->{'*'} ? $r->{'*'} : next;

        if ( ref $check eq 'CODE' ) {
            my @v = $check->( $s, $t, $k, $a->{$k}, $a, \%f );

            # empty list indicates that the attribute should be skipped.
            next unless @v;

            # use the value from the callback
            $f{$k} = shift @v;
        }
        elsif ( ref $check || length($check) > 1 ) {

            # keep the original value
            $f{$k} = $a->{$k} if $a->{$k} =~ m{$check};
        }
        elsif ($check) {

            # keep the original value
            $f{$k} = $a->{$k};
        }
    }

    if (%f) {
        my %seen;
        return "<$t $r>"
            if $r = join ' ', map {
            defined $f{$_}
                ? qq[$_="] . encode_entities( $f{$_} ) . q["]
                : $_;    # boolean attribute (TODO?)
            } grep { exists $f{$_} and !$seen{$_}++; } @$as;
    }

    return "<$t>";
}

=for comment _scrub_str

I<default> handler, used by both C<_scrub> and C<_scrub_fh>. Moved all the
common code (basically all of it) into a single routine for ease of
maintenance.

=cut

sub _scrub_str {
    my ( $p, $e, $t, $a, $as, $text ) = @_;

    my $s = $p->{"\0_s"};

    # premptive handling of an event might turn off the rule based handling
    if ( $s->{_preempt} && ref $s->{_preempt} eq 'CODE' ) {
        if ( $e eq 'end' && $text eq '' && $s->{_ignore_empty_end} ) {
            $s->{_ignore_empty_end} = 0;

            return '';
        }

        $s->{_ignore_empty_end} = 0;

        my @v = $s->{_preempt}->( $e, $t, $a, $as, $text);

        if (@v) {
            if ( $e eq 'start' ) {
                $s->{_ignore_empty_end} = 1;
            }

            return $v[0];
        }
    }

    my $outstr = '';

    if ( $e eq 'start' ) {
        if ( exists $s->{_rules}->{$t} )    # is there a specific rule
        {
            if ( ref $s->{_rules}->{$t} )    # is it complicated?(not simple;)
            {
                $outstr .= $s->_validate( $t, $t, $a, $as );
            }
            elsif ( $s->{_rules}->{$t} )     # validate using default attribute rule
            {
                $outstr .= $s->_validate( $t, '_', $a, $as );
            }
        }
        elsif ( $s->{_rules}->{'*'} )        # default allow tags
        {
            $outstr .= $s->_validate( $t, '_', $a, $as );
        }
    }
    elsif ( $e eq 'end' ) {

        # empty tags list taken from
        # https://developer.mozilla.org/en/docs/Glossary/empty_element
        my @empty_tags = qw(area base br col embed hr img input link meta param source track wbr);
        return "" if $text ne '' && any { $t eq $_ } @empty_tags;    # skip false closing empty tags

        my $place = 0;
        if ( exists $s->{_rules}->{$t} ) {
            $place = 1 if $s->{_rules}->{$t};
        }
        elsif ( $s->{_rules}->{'*'} ) {
            $place = 1;
        }
        if ($place) {
            if ( length $text ) {
                $outstr .= "</$t>";
            }
            else {

                # work because the previous start event set $s->{_r}
                substr $s->{_r}, -1, 0, ' /';
            }
        }
    }
    elsif ( $e eq 'comment' ) {
        if ( $s->{_comment} ) {

            # only copy comments through if they are well formed...
            $outstr .= $text if ( $text =~ m|^<!--.*-->$|ms );
        }
    }
    elsif ( $e eq 'process' ) {
        $outstr .= $text if $s->{_process};
    }
    elsif ( $e eq 'text' or $e eq 'default' ) {
        $text =~ s/</&lt;/g;    #https://rt.cpan.org/Public/Ticket/Attachment/83958/10332/scrubber.patch
        $text =~ s/>/&gt;/g;

        $outstr .= $text;
    }
    elsif ( $e eq 'start_document' ) {
        $outstr = "";
    }

    return $outstr;
}

=for comment _scrub_fh

I<default> handler, does the scrubbing if we're scrubbing out to a file. Now
calls C<_scrub_str> and pushes that out to a file.

=cut

sub _scrub_fh {
    my $self = $_[0]->{"\0_s"};
    print { $self->{_out} } $self->{'_r'} if length $self->{_r};
    $self->{'_r'} = _scrub_str(@_);
}

=for comment _scrub

I<default> handler, does the scrubbing if we're returning a giant string. Now
calls C<_scrub_str> and appends that to the output string.

=cut

sub _scrub {

    $_[0]->{"\0_s"}->{_r} .= _scrub_str(@_);
}

sub _optimize {
    my ($self) = @_;

    my (@ignore_elements) = grep { not $self->{"_$_"} } qw(script style);
    $self->{_p}->ignore_elements(@ignore_elements);    # if @ is empty, we reset ;)

    return unless $self->{_optimize};

    #sub allow
    #    return unless $self->{_optimize}; # till I figure it out (huh)

    if ( $self->{_rules}{'*'} ) {    # default allow
        $self->{_p}->report_tags();    # so clear it
    }
    else {

        my (@reports) =
            grep {                     # report only tags we want
            $self->{_rules}{$_}
            } keys %{ $self->{_rules} };

        $self->{_p}->report_tags(      # default deny, so optimize
            @reports
        ) if @reports;
    }

    # sub deny
    #    return unless $self->{_optimize}; # till I figure it out (huh)
    my (@ignores) =
        grep { not $self->{_rules}{$_} } grep { $_ ne '*' } keys %{ $self->{_rules} };

    $self->{_p}->ignore_tags(    # always ignore stuff we don't want
        @ignores
    ) if @ignores;

    $self->{_optimize} = 0;
    return;
}

1;

#print sprintf q[ '%-12s => %s,], "$_'", $h{$_} for sort keys %h;# perl!
#perl -ne"chomp;print $_;print qq'\t\t# test ', ++$a if /ok\(/;print $/" test.pl >test2.pl
#perl -ne"chomp;print $_;if( /ok\(/ ){s/\#test \d+$//;print qq'\t\t# test ', ++$a }print $/" test.pl >test2.pl
#perl -ne"chomp;if(/ok\(/){s/# test .*$//;print$_,qq'\t\t# test ',++$a}else{print$_}print$/" test.pl >test2.pl

=head1 How does it work?

When a tag is encountered, L<HTML::Scrubber> allows/denies the tag using the
explicit rule if one exists.

If no explicit rule exists, Scrubber applies the default rule.

If an explicit rule exists, but it's a simple rule(1), then the default
attribute rule is applied.

=head2 EXAMPLE

=for example begin

    #!/usr/bin/perl -w
    use HTML::Scrubber;
    use strict;

    my @allow = qw[ br hr b a ];

    my @rules = (
        script => 0,
        img    => {
            src => qr{^(?!http://)}i,    # only relative image links allowed
            alt => 1,                    # alt attribute allowed
            '*' => 0,                    # deny all other attributes
        },
    );

    my @default = (
        0 =>                             # default rule, deny all tags
            {
            '*'    => 1,                             # default rule, allow all attributes
            'href' => qr{^(?:http|https|ftp)://}i,
            'src'  => qr{^(?:http|https|ftp)://}i,

            #   If your perl doesn't have qr
            #   just use a string with length greater than 1
            'cite'        => '(?i-xsm:^(?:http|https|ftp):)',
            'language'    => 0,
            'name'        => 1,                                 # could be sneaky, but hey ;)
            'onblur'      => 0,
            'onchange'    => 0,
            'onclick'     => 0,
            'ondblclick'  => 0,
            'onerror'     => 0,
            'onfocus'     => 0,
            'onkeydown'   => 0,
            'onkeypress'  => 0,
            'onkeyup'     => 0,
            'onload'      => 0,
            'onmousedown' => 0,
            'onmousemove' => 0,
            'onmouseout'  => 0,
            'onmouseover' => 0,
            'onmouseup'   => 0,
            'onreset'     => 0,
            'onselect'    => 0,
            'onsubmit'    => 0,
            'onunload'    => 0,
            'src'         => 0,
            'type'        => 0,
            }
    );

    my $scrubber = HTML::Scrubber->new();
    $scrubber->allow(@allow);
    $scrubber->rules(@rules);    # key/value pairs
    $scrubber->default(@default);
    $scrubber->comment(1);       # 1 allow, 0 deny

    ## preferred way to create the same object
    $scrubber = HTML::Scrubber->new(
        allow   => \@allow,
        rules   => \@rules,
        default => \@default,
        comment => 1,
        process => 0,
    );

    require Data::Dumper, die Data::Dumper::Dumper($scrubber) if @ARGV;

    my $it = q[
        <?php   echo(" EVIL EVIL EVIL "); ?>    <!-- asdf -->
        <hr>
        <I FAKE="attribute" > IN ITALICS WITH FAKE="attribute" </I><br>
        <B> IN BOLD </B><br>
        <A NAME="evil">
            <A HREF="javascript:alert('die die die');">HREF=JAVA &lt;!&gt;</A>
            <br>
            <A HREF="image/bigone.jpg" ONMOUSEOVER="alert('die die die');">
                <IMG SRC="image/smallone.jpg" ALT="ONMOUSEOVER JAVASCRIPT">
            </A>
        </A> <br>
    ];

    print "#original text", $/, $it, $/;
    print
        "#scrubbed text (default ", $scrubber->default(),    # no arguments returns the current value
        " comment ", $scrubber->comment(), " process ", $scrubber->process(), " )", $/, $scrubber->scrub($it), $/;

    $scrubber->default(1);                                   # allow all tags by default
    $scrubber->comment(0);                                   # deny comments

    print
        "#scrubbed text (default ",
        $scrubber->default(),
        " comment ",
        $scrubber->comment(),
        " process ",
        $scrubber->process(),
        " )", $/,
        $scrubber->scrub($it),
        $/;

    $scrubber->process(1);    # allow process instructions (dangerous)
    $default[0] = 1;          # allow all tags by default
    $default[1]->{'*'} = 0;   # deny all attributes by default
    $scrubber->default(@default);    # set the default again

    print
        "#scrubbed text (default ",
        $scrubber->default(),
        " comment ",
        $scrubber->comment(),
        " process ",
        $scrubber->process(),
        " )", $/,
        $scrubber->scrub($it),
        $/;

=for example end


=head2 FUN

If you have L<Test::Inline> (and you've installed L<HTML::Scrubber>), try

    pod2test Scrubber.pm >scrubber.t
    perl scrubber.t

=head1 SEE ALSO

L<HTML::Parser>, L<Test::Inline>.

The L<HTML::Sanitizer> module is no longer available on CPAN.

=head1 VERSION REQUIREMENTS

As of version 0.14 I have added a perl minimum version requirement of 5.8. This
is basically due to failures on the smokers perl 5.6 installations - which
appears to be down to installation mechanisms and requirements.

Since I don't want to spend the time supporting a version that is so old (and
may not work for reasons on UTF support etc), I have added a C<use 5.008;> to
the main module.

If this is problematic I am very willing to accept patches to fix this up,
although I do not personally see a good reason to support a release that has
been obsolete for 13 years.

=head1 CONTRIBUTING

If you want to contribute to the development of this module, the code is on
L<GitHub|http://github.com/nigelm/html-scrubber>. You'll need a perl
environment with L<Dist::Zilla>, and if you're just getting started, there's
some documentation on using Vagrant and Perlbrew
L<here|http://mrcaron.github.io/2015/03/06/Perl-CPAN-Pull-Request.html>.

There is now a C<.perltidyrc> and a C<.tidyallrc> file within the repository
for the standard perltidy settings used - I will apply these before new
releases.  Please do not let formatting prevent you from sending in patches etc
- this can be sorted out as part of the release process.  Info on C<tidyall>
can be found at
L<https://metacpan.org/pod/distribution/Code-TidyAll/bin/tidyall>.

=cut
