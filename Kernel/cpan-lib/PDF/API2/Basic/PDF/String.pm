# Code in the PDF::API2::Basic::PDF namespace was originally copied from the
# Text::PDF distribution.
#
# Copyright Martin Hosken <Martin_Hosken@sil.org>
#
# Martin Hosken's code may be used under the terms of the MIT license.
# Subsequent versions of the code have the same license as PDF::API2.

package PDF::API2::Basic::PDF::String;

use base 'PDF::API2::Basic::PDF::Objind';

use strict;

our $VERSION = '2.045'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::String - Low-level PDF string object

=head1 METHODS

=cut

our %trans = (
    'n' => "\n",
    'r' => "\r",
    't' => "\t",
    'b' => "\b",
    'f' => "\f",
    "\\" => "\\",
    '(' => '(',
    ')' => ')',
);

our %out_trans = (
    "\n" => 'n',
    "\r" => 'r',
    "\t" => 't',
    "\b" => 'b',
    "\f" => 'f',
    "\\" => "\\",
    '(' => '(',
    ')' => ')',
);

=head2 PDF::API2::Basic::PDF::String->from_pdf($string)

Creates a new string object (not a full object yet) from a given
string.  The string is parsed according to input criteria with
escaping working.

=cut

sub from_pdf {
    my ($class, $str) = @_;
    my $self = {};

    bless $self, $class;
    $self->{'val'} = $self->convert($str);
    $self->{' realised'} = 1;
    return $self;
}

=head2 PDF::API2::Basic::PDF::String->new($string)

Creates a new string object (not a full object yet) from a given
string.  The string is parsed according to input criteria with
escaping working.

=cut

sub new {
    my ($class, $str) = @_;
    my $self = {};

    bless $self, $class;
    $self->{'val'} = $str;
    $self->{' realised'} = 1;
    return $self;
}

=head2 $s->convert($str)

Returns $str converted as per criteria for input from PDF file

=cut

sub convert {
    my ($self, $input) = @_;
    my $output = '';

    # Hexadecimal Strings (PDF 1.7 section 7.3.4.3)
    if ($input =~ m|^\s*\<|o) {
        $self->{' ishex'} = 1;
        $output = $input;

        # Remove any extraneous characters to simplify processing
        $output =~ s/[^0-9a-f]+//gio;
        $output = "<$output>";

        # Convert each sequence of two hexadecimal characters into a byte
        1 while $output =~ s/\<([0-9a-f]{2})/chr(hex($1)) . '<'/oige;

        # If a single hexadecimal character remains, append 0 and
        # convert it into a byte.
        $output =~ s/\<([0-9a-f])\>/chr(hex($1 . '0'))/oige;

        # Remove surrounding angle brackets
        $output =~ s/\<\>//og;
    }

    # Literal Strings (PDF 1.7 section 7.3.4.2)
    else {
        # Remove surrounding parentheses
        $input =~ s/^\s*\((.*)\)\s*$/$1/os;

        my $cr = '(?:\015\012|\015|\012)';
        my $prev_input;
        while ($input) {
            if (defined $prev_input and $input eq $prev_input) {
                die "Infinite loop while parsing literal string";
            }
            $prev_input = $input;

            # Convert bachslash followed by up to three octal digits
            # into that binary byte
            if ($input =~ /^\\([0-7]{1,3})(.*)/os) {
                $output .= chr(oct($1));
                $input = $2;
            }
            # Convert backslash followed by an escaped character into that
            # character
            elsif ($input =~ /^\\([nrtbf\\\(\)])(.*)/osi) {
                $output .= $trans{$1};
                $input = $2;
            }
            # Ignore backslash followed by an end-of-line marker
            elsif ($input =~ /^\\$cr(.*)/os) {
                $input = $1;
            }
            # Convert an unescaped end-of-line marker to a line-feed
            elsif ($input =~ /^\015\012?(.*)/os) {
                $output .= "\012";
                $input = $1;
            }
            # Check to see if there are any other special sequences
            elsif ($input =~ /^(.*?)((?:\\(?:[nrtbf\\\(\)0-7]|$cr)|\015\012?).*)/os) {
                $output .= $1;
                $input = $2;
            }
            else {
                $output .= $input;
                $input = undef;
            }
        }
    }

    return $output;
}


=head2 $s->val

Returns the value of this string (the string itself).

=cut

sub val {
    return $_[0]->{'val'};
}


=head2 $->as_pdf

Returns the string formatted for output as PDF for PDF File object $pdf.

=cut

sub as_pdf {
    my ($self) = @_;
    my $str = $self->{'val'};

    if ($self->{' ishex'}) { # imported as hex ?
        $str = unpack('H*', $str);
        return "<$str>";
    }
    elsif ($self->{' isutf'} or (utf8::is_utf8($str) and $str =~ /[^[:ascii:]]/)) {
        $str = join('', map { sprintf('%04X' , $_) } unpack('U*', $str) );
        return "<FEFF$str>";
    }
    else {
        if ($str =~ m/[^\n\r\t\b\f\040-\176\200-\377]/) {
            $str =~ s/(.)/sprintf('%02X', ord($1))/sge;
            return "<$str>";
        }
        else {
            $str =~ s/([\n\r\t\b\f\\()])/\\$out_trans{$1}/g;
            return "($str)";
        }
    }
}

=head2 $s->outobjdeep

Outputs the string in PDF format, complete with necessary conversions

=cut

sub outobjdeep {
    my ($self, $fh, $pdf) = @_;

    $fh->print($self->as_pdf($pdf));
}

1;
