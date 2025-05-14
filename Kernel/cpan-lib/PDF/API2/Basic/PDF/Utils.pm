# Code in the PDF::API2::Basic::PDF namespace was originally copied from the
# Text::PDF distribution.
#
# Copyright Martin Hosken <Martin_Hosken@sil.org>
#
# Martin Hosken's code may be used under the terms of the MIT license.
# Subsequent versions of the code have the same license as PDF::API2.

package PDF::API2::Basic::PDF::Utils;

use strict;

our $VERSION = '2.045'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Utils - Convenience functions for creating low-level PDF
objects

=head1 DESCRIPTION

A set of utility functions to save the fingers of the PDF library users!

=head1 FUNCTIONS

=cut

use PDF::API2::Basic::PDF::Array;
use PDF::API2::Basic::PDF::Bool;
use PDF::API2::Basic::PDF::Dict;
use PDF::API2::Basic::PDF::Name;
use PDF::API2::Basic::PDF::Null;
use PDF::API2::Basic::PDF::Number;
use PDF::API2::Basic::PDF::String;
use PDF::API2::Basic::PDF::Literal;

use Exporter;
use vars qw(@EXPORT @ISA);
@ISA = qw(Exporter);
@EXPORT = qw(PDFBool PDFArray PDFDict PDFName PDFNull
             PDFNum PDFStr PDFStrHex PDFUtf);

=head2 PDFBool

Creates a Bool via PDF::API2::Basic::PDF::Bool->new

=cut

sub PDFBool {
    return PDF::API2::Basic::PDF::Bool->new(@_);
}

=head2 PDFArray

Creates an array via PDF::API2::Basic::PDF::Array->new

=cut

sub PDFArray {
    return PDF::API2::Basic::PDF::Array->new(@_);
}

=head2 PDFDict

Creates a dict via PDF::API2::Basic::PDF::Dict->new

=cut

sub PDFDict {
    return PDF::API2::Basic::PDF::Dict->new(@_);
}

=head2 PDFName

Creates a name via PDF::API2::Basic::PDF::Name->new

=cut

sub PDFName {
    return PDF::API2::Basic::PDF::Name->new(@_);
}

=head2 PDFNull

Creates a null via PDF::API2::Basic::PDF::Null->new

=cut

sub PDFNull {
    return PDF::API2::Basic::PDF::Null->new(@_);
}

=head2 PDFNum

Creates a number via PDF::API2::Basic::PDF::Number->new

=cut

sub PDFNum {
    return PDF::API2::Basic::PDF::Number->new(@_);
}

=head2 PDFStr

Creates a string via PDF::API2::Basic::PDF::String->new

=cut

sub PDFStr {
    return PDF::API2::Basic::PDF::String->new(@_);
}

# Deprecated
sub PDFUtf { return PDFStr(@_) }

=head2 PDFStrHex

Creates a hex-string via PDF::API2::Basic::PDF::String->new

=cut

sub PDFStrHex {
    my $string = PDF::API2::Basic::PDF::String->new(@_);
    $string->{' ishex'} = 1;
    return $string;
}

1;
