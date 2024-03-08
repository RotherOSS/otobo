package PDF::API2::Resource::ColorSpace::Indexed;

use base 'PDF::API2::Resource::ColorSpace';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

sub new {
    my ($class, $pdf, $key, %opts) = @_;

    $class = ref($class) if ref($class);
    my $self = $class->SUPER::new($pdf, $key, %opts);
    $pdf->new_obj($self) unless $self->is_obj($pdf);
    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    $self->add_elements(PDFName('Indexed'));
    $self->type('Indexed');

    return $self;
}

sub enumColors {
    my $self = shift();
    my %col;
    my $stream = $self->{' csd'}->{' stream'};
    foreach my $n (0..255) {
        my $k = '#' . uc(unpack('H*', substr($stream, $n * 3, 3)));
        $col{$k} //= $n;
    }
    return %col;
}

sub nameColor {
    my ($self, $n) = @_;
    my %col;
    my $stream = $self->{' csd'}->{' stream'};
    my $k = '#' . uc(unpack('H*', substr($stream, $n * 3, 3)));
    return $k;
}

# r, g, b need to be 0-255
sub resolveNearestRGB {
    my ($self, $r, $g, $b) = @_;
    my $c = 0;
    my $w = 768 ** 2;
    my $stream = $self->{' csd'}->{' stream'};
    foreach my $n (0..255) {
        my @e = unpack('C*', substr($stream, $n * 3, 3));
        my $d = ($e[0] - $r) ** 2 + ($e[1] - $g) ** 2 + ($e[2] - $b) ** 2;
        if ($d < $w) {
            $c = $n;
            $w = $d;
        }
    }
    return $c;
}

1;
