# Code in the PDF::API2::Basic::PDF namespace was originally copied from the
# Text::PDF distribution.
#
# Copyright Martin Hosken <Martin_Hosken@sil.org>
#
# Martin Hosken's code may be used under the terms of the MIT license.
# Subsequent versions of the code have the same license as PDF::API2.

package PDF::API2::Basic::PDF::Bool;

use base 'PDF::API2::Basic::PDF::String';

use strict;

our $VERSION = '2.045'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Bool - Low-level PDF boolean object
B<true> or B<false>

=head1 METHODS

=head2 $b->convert($str)

Converts a string into the string which will be stored.

=cut

sub convert {
    return $_[1] eq 'true';
}

=head2 as_pdf

Converts the value to a PDF output form

=cut

sub as_pdf {
    return $_[0]->{'val'} ? 'true' : 'false';
}

1;
