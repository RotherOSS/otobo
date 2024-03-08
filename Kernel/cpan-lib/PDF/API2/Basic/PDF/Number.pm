# Code in the PDF::API2::Basic::PDF namespace was originally copied from the
# Text::PDF distribution.
#
# Copyright Martin Hosken <Martin_Hosken@sil.org>
#
# Martin Hosken's code may be used under the terms of the MIT license.
# Subsequent versions of the code have the same license as PDF::API2.

package PDF::API2::Basic::PDF::Number;

use base 'PDF::API2::Basic::PDF::String';

use strict;

our $VERSION = '2.045'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Number - Low-level PDF numeric object

=head1 METHODS

=head2 $n->convert($str)

Converts a string from PDF to internal, by doing nothing

=cut

sub convert {
    return $_[1];
}

=head2 $n->as_pdf

Converts a number to PDF format

=cut

sub as_pdf {
    return $_[0]->{'val'};
}

1;
