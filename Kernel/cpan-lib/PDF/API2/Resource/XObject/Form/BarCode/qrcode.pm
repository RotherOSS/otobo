package PDF::API2::Resource::XObject::Form::BarCode::qrcode;

use base 'PDF::API2::Resource::XObject::Form::BarCode';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp;

our @CARP_NOT = qw(PDF::API2);

sub new {
    my ($class, $pdf, %options) = @_;
    my $self = $class->SUPER::new($pdf, %options);

    eval {
        require Text::QRCode;
    };
    if ($@) {
        croak "Error loading Text::QRCode: $@";
    }

    my $mode = $options{'mode'} // '8-bit';
    $mode = 'numerical'       if $mode eq 'numeric';
    $mode = 'alpha-numerical' if $mode eq 'alphanumeric';
    $mode = 'alpha-numerical' if $mode eq 'alpha-numeric';

    my $generator = Text::QRCode->new(
        level         => ($options{'error_correction'} // 'L'),
        version       => ($options{'version'}          // 0),
        mode          => $mode,
        casesensitive => ($options{'case_sensitive'}   // 1),
    );

    my $lines_ref = $generator->plot($options{'code'});
    my @lines = reverse map { join('', @$_) } @$lines_ref;

    $self->render(@lines);
    return $self;
}

sub render {
    my ($self, @lines) = @_;

    $self->fillcolor($self->{' color'});

    my $y = $self->{' quzn'};
    my $w = $self->{' mils'} / 1000 * 72;
    my $h = $self->{' zone'};
    foreach my $line (@lines) {
        my $x = $self->{' quzn'};
        foreach my $char (split m//, $line) {
            if ($char eq '*') {
                $self->rectangle($x, $y, $x + $w, $y + $h);
                $self->fill();
            }
            $x += $w;
        }
        $y += $h;
    }

    $self->{' w'} = 2 * $self->{' quzn'} + length($lines[0]) * $w;
    $self->{' h'} = 2 * $self->{' quzn'} + length($lines[0]) * $h;
    $self->bbox(0, 0, $self->{' w'}, $self->{' h'});

    return $self;
}

1;

__END__

=head1 NAME

PDF::API2::Resource::XObject::Form::BarCode::qrcode - Generate QR codes

=head1 SYNOPSIS

    use PDF::API2;

    my $pdf = PDF::API2->new();
    my $page = $pdf->page();

    # Create a QR Code object
    my $barcode = $pdf->barcode('qr', 'This is a test');

    # Calculate the scale needed for a desired size (72pt / inch)
    my $desired_inches = 2;
    my $scale = $desired_inches * 72 / $barcode->width();

    # Place the QR Code one inch (72pt) from the bottom left corner
    $page->object($barcode, 72, 72, $scale);

    $pdf->save('qr_test.pdf');

=head1 REQUIREMENTS

L<Text::QRCode> is used to encode QR codes.

=head1 OPTIONS

    my $barcode = $pdf->barcode('qr', $value, %options);

The following standard barcode options are supported, as described in
L<PDF::API2/barcode>:

=over

=item * bar_width (default: 1; unit is points)

=item * bar_height (default: bar width)

=item * quiet_zone (default: 4x bar width)

=item * color (default: black)

=back

The following options are specific to QR codes:

=over

=item * error_correction (default: L)

The QR Code Error Correction Level.  Higher levels of error correction generate
larger bar codes but remain scannable when parts of the code are damaged or
obscured.

In increasing order of error correction, the possible values are:

=over

=item * L (7%)

=item * M (15%)

=item * Q (25%)

=item * H (30%)

=back

=item * version (default: 0)

If you need a specific version of QR Code, enter it here.  Otherwise, the
minimum version will be used that can support the encoded value.

=item * mode (default: 8-bit)

You can generate smaller QR codes if you're using a restricted character set:

=over

=item * 8-bit (typically the ISO-8859-1 character set)

=item * kanji

=item * alphanumeric (digits, uppercase letters, space, or C<$ % * + - . / :>)

=item * numeric (digits)

=back

=item * case_sensitive (default: 1)

Whether 8-bit characters should be treated in a case-sensitive manner.

=back
