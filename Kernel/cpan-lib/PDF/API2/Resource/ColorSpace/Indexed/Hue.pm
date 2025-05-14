package PDF::API2::Resource::ColorSpace::Indexed::Hue;

use base 'PDF::API2::Resource::ColorSpace::Indexed';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

sub new {
    my ($class, $pdf) = @_;

    $class = ref($class) if ref($class);
    my $self = $class->SUPER::new($pdf, pdfkey());
    $pdf->new_obj($self) unless $self->is_obj($pdf);
    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    my $csd = PDFDict();
    $pdf->new_obj($csd);
    $csd->{'Filter'} = PDFArray(PDFName('FlateDecode'));

    my %cc;

    my $stream = '';
    foreach my $s (4, 3, 2, 1) {
        foreach my $v (4, 3) {
            foreach my $r (0..31) {
                $stream .= pack('CCC',
                                map { $_ * 255 }
                                namecolor(join('',
                                               '!',
                                               sprintf('%02X', $r * 255 / 31),
                                               sprintf('%02X', $s * 255 / 4),
                                               sprintf('%02X', $v * 255 / 4))));
            }
        }
    }
    $stream .= "\x00" x 768;
    $stream = substr($stream, 0, 768);
    $csd->{' stream'} = $stream;

    $self->add_elements(PDFName('DeviceRGB'), PDFNum(255), $csd);
    $self->{' csd'} = $csd;

    return $self;
}

1;
