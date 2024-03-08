package PDF::API2::Resource::ColorSpace::Separation;

use base 'PDF::API2::Resource::ColorSpace';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

=head1 NAME

PDF::API2::Resource::ColorSpace::Separation - Support for color space separations

=head1 METHODS

=over

=item $cs = PDF::API2::Resource::ColorSpace::Separation->new $pdf, $key, %parameters

Returns a new colorspace object.

=cut

sub new {
    my ($class, $pdf, $key, $name, @clr) = @_;

    $class = ref($class) if ref($class);
    my $self = $class->SUPER::new($pdf, $key);
    $pdf->new_obj($self) unless $self->is_obj($pdf);
    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    my $fct = PDFDict();

    my $csname;
    $clr[0] = lc($clr[0]);
    $self->color(@clr);
    if ($clr[0] =~ /^[a-z\#\!]+/) {
        # colorname or #! specifier
        # with rgb target colorspace
        # namecolor returns always a RGB
        my ($r, $g, $b) = namecolor($clr[0]);
        $csname = 'DeviceRGB';

        $fct->{'FunctionType'} = PDFNum(0);
        $fct->{'Size'} = PDFArray(PDFNum(2));
        $fct->{'Range'} = PDFArray(map { PDFNum($_) } ($r, 1, $g, 1, $b, 1));
        $fct->{'Domain'} = PDFArray(PDFNum(0), PDFNum(1));
        $fct->{'BitsPerSample'} = PDFNum(8);
        $fct->{' stream'} = "\xff\xff\xff\x00\x00\x00";
    }
    elsif ($clr[0] =~ /^[\%]+/) {
        # % specifier
        # with cmyk target colorspace
        my ($c, $m, $y, $k) = namecolor_cmyk($clr[0]);
        $csname = 'DeviceCMYK';

        $fct->{'FunctionType'} = PDFNum(0);
        $fct->{'Size'} = PDFArray(PDFNum(2));
        $fct->{'Range'} = PDFArray(map { PDFNum($_) } (0, $c, 0, $m, 0, $y, 0, $k));
        $fct->{'Domain'} = PDFArray(PDFNum(0), PDFNum(1));
        $fct->{'BitsPerSample'} = PDFNum(8);
        $fct->{' stream'} = "\x00\x00\x00\x00\xff\xff\xff\xff";
    }
    elsif (@clr == 1) {
        # grey color spec.
        $clr[0] /= 255 while $clr[0] > 1;

        # adjusted for 8/16/32bit spec.
        my $g = $clr[0];
        $csname = 'DeviceGray';

        $fct->{'FunctionType'} = PDFNum(0);
        $fct->{'Size'} = PDFArray(PDFNum(2));
        $fct->{'Range'} = PDFArray(PDFNum(0), PDFNum($g));
        $fct->{'Domain'} = PDFArray(PDFNum(0), PDFNum(1));
        $fct->{'BitsPerSample'} = PDFNum(8);
        $fct->{' stream'} = "\xff\x00";
    }
    elsif (@clr == 3) {
        # legacy rgb color-spec (0 <= x <= 1)
        my ($r, $g, $b) = @clr;
        $csname = 'DeviceRGB';

        $fct->{'FunctionType'} = PDFNum(0);
        $fct->{'Size'} = PDFArray(PDFNum(2));
        $fct->{'Range'} = PDFArray(map { PDFNum($_) } ($r, 1, $g, 1, $b, 1));
        $fct->{'Domain'} = PDFArray(PDFNum(0), PDFNum(1));
        $fct->{'BitsPerSample'} = PDFNum(8);
        $fct->{' stream'} = "\xff\xff\xff\x00\x00\x00";
    }
    elsif (@clr == 4) {
        # legacy cmyk color-spec (0 <= x <= 1)
        my ($c, $m, $y, $k) = @clr;
        $csname='DeviceCMYK';

        $fct->{'FunctionType'} = PDFNum(0);
        $fct->{'Size'} = PDFArray(PDFNum(2));
        $fct->{'Range'} = PDFArray(map { PDFNum($_) } (0, $c, 0, $m, 0, $y, 0, $k));
        $fct->{'Domain'} = PDFArray(PDFNum(0), PDFNum(1));
        $fct->{'BitsPerSample'} = PDFNum(8);
        $fct->{' stream'} = "\x00\x00\x00\x00\xff\xff\xff\xff";
    }
    else {
        die 'invalid color specification.';
    }
    $self->type($csname);
    $pdf->new_obj($fct);
    $self->add_elements(PDFName('Separation'),
                        PDFName($name),
                        PDFName($csname),
                        $fct);
    $self->tintname($name);

    return $self;
}

=item @color = $res->color

Returns the base-color of the Separation-Colorspace.

=cut

sub color {
    my $self = shift();
    if (@_ and defined $_[0]) {
        $self->{' color'} = [@_];
    }
    return @{$self->{' color'}};
}

=item $tintname = $res->tintname $tintname

Returns the tint-name of the Separation-Colorspace.

=cut

sub tintname {
    my $self = shift();
    if (@_ and defined $_[0]) {
        $self->{' tintname'} = [@_];
    }
    return @{$self->{' tintname'}};
}


sub param {
    my $self = shift();
    return $_[0];
}

=back

=cut

1;
