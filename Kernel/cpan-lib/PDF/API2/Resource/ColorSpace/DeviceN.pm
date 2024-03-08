package PDF::API2::Resource::ColorSpace::DeviceN;

use base 'PDF::API2::Resource::ColorSpace';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;
use Scalar::Util qw(weaken);

sub new {
    my ($class, $pdf, $key, $clrs) = @_;
    my $sampled = 2;

    $class = ref($class) if ref($class);
    my $self = $class->SUPER::new($pdf, $key);
    $pdf->new_obj($self) unless $self->is_obj($pdf);
    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    my $fct = PDFDict();

    # The base colorspace was formerly chosen based on the base colorspace of
    # the first color component, but since only DeviceCMYK has been implemented
    # (everything else throws an error), always use DeviceCMYK.
    #
    # my $csname = $clrs->[0]->type();
    my $csname = 'DeviceCMYK';

    my @xclr = map { $_->color() } @$clrs;
    my @xnam = map { $_->tintname() } @$clrs;
    if ($csname eq 'DeviceCMYK') {
        @xclr = map { [ namecolor_cmyk($_) ] } @xclr;

        $fct->{'FunctionType'} = PDFNum(0);
        $fct->{'Order'} = PDFNum(3);
        $fct->{'Range'} = PDFArray(map { PDFNum($_) } (0, 1, 0, 1, 0, 1, 0, 1));
        $fct->{'BitsPerSample'} = PDFNum(8);
        $fct->{'Domain'} = PDFArray();
        $fct->{'Size'} = PDFArray();
        foreach (@xclr) {
            $fct->{'Size'}->add_elements(PDFNum($sampled));
            $fct->{'Domain'}->add_elements(PDFNum(0), PDFNum(1));
        }
        my @spec;
        foreach my $xc (0 .. (scalar @xclr) - 1) {
            foreach my $n (0 .. ($sampled ** (scalar @xclr)) - 1) {
                $spec[$n] ||= [0, 0, 0, 0];
                my $factor = ($n / ($sampled ** $xc)) % $sampled;
                my @color = map { ($_ * $factor) / ($sampled - 1) } @{$xclr[$xc]};
                foreach my $s (0 .. 3) {
                    $spec[$n]->[$s] += $color[$s];
                }
                @{$spec[$n]} = map { $_ > 1 ? 1 : $_ } @{$spec[$n]};
            }
        }
        my @b;
        foreach my $s (@spec) {
            push @b, map { pack('C', $_ * 255) } @$s;
        }
        $fct->{' stream'} = join('', @b);
    }
    else {
        die "unsupported colorspace specification (=$csname).";
    }
    $fct->{'Filter'} = PDFArray(PDFName('ASCIIHexDecode'));
    $self->type($csname);
    $pdf->new_obj($fct);
    my $attr = PDFDict();
    foreach my $cs (@$clrs) {
        $attr->{$cs->tintname()} = $cs;
    }
    $self->add_elements(PDFName('DeviceN'),
                        PDFArray(map { PDFName($_) } @xnam),
                        PDFName($csname), $fct);

    return $self;
}

sub param {
    my $self = shift();
    return @_;
}

1;
