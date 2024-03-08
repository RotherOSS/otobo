# Code in the PDF::API2::Basic::PDF namespace was originally copied from the
# Text::PDF distribution.
#
# Copyright Martin Hosken <Martin_Hosken@sil.org>
#
# Martin Hosken's code may be used under the terms of the MIT license.
# Subsequent versions of the code have the same license as PDF::API2.

package PDF::API2::Basic::PDF::Null;

use base 'PDF::API2::Basic::PDF::Objind';

use strict;

our $VERSION = '2.045'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Null - Low-level PDF null object

=head1 METHODS

=cut

# There is only one null object  (section 3.2.8).
my $null_obj = bless {}, 'PDF::API2::Basic::PDF::Null';

=head2 PDF::API2::Basic::PDF::Null->new

Returns the null object.  There is only one null object.

=cut

sub new {
    return $null_obj;
}

=head2 $s->realise

Pretends to finish reading the object.

=cut

sub realise {
    return $null_obj;
}

=head2 $s->outobjdeep

Output the object in PDF format.

=cut

sub outobjdeep {
    my ($self, $fh, $pdf) = @_;
    $fh->print('null');
}

=head2 $s->is_obj

Returns false because null is not a full object.

=cut

sub is_obj {
    return 0;
}

=head2 $s->copy

Another no-op.

=cut

sub copy {
    return $null_obj;
}

=head2 $s->val

Return undef.

=cut

sub val {
    return undef; ## no critic (undef is intentional)
}

1;
