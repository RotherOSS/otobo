package PDF::API2::Resource::XObject::Image::PNM;

# For spec details, see man pages pam(5), pbm(5), pgm(5), pnm(5),
# ppm(5), which were pasted into the __END__ of this file in an
# earlier revision.

use base 'PDF::API2::Resource::XObject::Image';

use strict;

our $VERSION = '2.045'; # VERSION

use Carp;
use IO::File;
use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;
use Scalar::Util qw(weaken);

sub new {
    my ($class, $pdf, $file, %opts) = @_;
    my $self;

    $class = ref($class) if ref($class);

    $self = $class->SUPER::new($pdf, 'Nx' . pdfkey());
    $pdf->new_obj($self) unless $self->is_obj($pdf);

    $self->read_pnm($pdf, $file);

    if ($opts{'-compress'}) {
        $self->filters('FlateDecode');
    }
    else {
        $self->filters('ASCIIHexDecode');
    }

    return $self;
}

# Originally from Image::PBMLib by Elijah Griffin (28 Feb 2003)
sub _read_header {
    my $fh = shift();
    my $in;
    my $no_comments;
    my %info;
    my $rc;
    $info{'error'} = undef;

    $rc = read($fh, $in, 3);

    if (!defined($rc) or $rc != 3) {
        $info{'error'} = 'Read error or EOF';
        return \%info;
    }

    unless ($in =~ /^P([123456])\s/) {
        $info{'error'} = 'Wrong magic number';
        return \%info;
    }

    $info{'type'} = $1;
    if ($info{'type'} > 3) {
        $info{'raw'} = 1;
    }
    else {
        $info{'raw'} = 0;
    }

    if ($info{'type'} == 1 or $info{'type'} == 4) {
        $info{'max'} = 1;
        $info{'bgp'} = 'b';
    }
    elsif ($info{'type'} == 2 or $info{'type'} == 5) {
        $info{'bgp'} = 'g';
    }
    else {
        $info{'bgp'} = 'p';
    }

    while (1) {
        $rc = read($fh, $in, 1, length($in));
        if (!defined($rc) or $rc != 1) {
            $info{'error'} = 'Read error or EOF';
            return \%info;
        }

        $no_comments = $in;
        $info{'comments'} = '';
        while ($no_comments =~ /#.*\n/) {
            $no_comments =~ s/#(.*\n)/ /;
            $info{'comments'} .= $1;
        }

        if ($info{'bgp'} eq 'b') {
            if ($no_comments =~ /^P\d\s+(\d+)\s+(\d+)\s/) {
                $info{'width'}  = $1;
                $info{'height'} = $2;
                last;
            }
        }
        else {
            if ($no_comments =~ /^P\d\s+(\d+)\s+(\d+)\s+(\d+)\s/) {
                $info{'width'}  = $1;
                $info{'height'} = $2;
                $info{'max'}    = $3;
                last;
            }
        }
    } # while reading header

    $info{'fullheader'} = $in;

    return \%info;
}

sub read_pnm {
    my ($self, $pdf, $file) = @_;

    my ($buf, $t, $scale, $line);
    my $bpc;
    my $cs;

    my $fh;
    if (ref($file)) {
        $fh = $file;
    }
    else {
        open $fh, '<', $file or die "$!: $file";
    }
    binmode($fh, ':raw');
    $fh->seek(0, 0);

    my $info = _read_header($fh);
    if ($info->{'type'} == 1) { # ASCII PBM
        $bpc = 1;
        $cs = 'DeviceGray';
        $self->{'Decode'} = PDFArray(PDFNum(1), PDFNum(0));

        # Read the remainder of the file
        local $/ = undef;
        my $plain = <$fh>;

        # Discard everything other than ASCII 1 and 0
        $plain =~ s/[^01]+//g;

        # Check length
        my $size = $info->{'width'} * $info->{'height'};
        croak "Incomplete ASCII PBM" if length($plain) < $size;

        # Discard any additional bits
        $plain = substr($plain, 0, $size) if length($plain) > $size;

        # Pad with zeroes
        $plain .= '0' x (8 - (length($plain) % 8));

        # Convert to binary
        $self->{' stream'} = pack('B*', $plain);
    }
    elsif ($info->{'type'} == 2) { # ASCII PGM
        $cs = 'DeviceGray';

        # Read the remainder of the file
        local $/ = undef;
        my $plain = <$fh>;

        # Discard everything other than digits and whitespace
        $plain =~ s/[^\d\s]+//gs;
        $plain =~ s/^\s+//;

        # Convert to an array of integers
        my @raster = split m/\s+/, $plain;

        # Check length
        my $size = $info->{'width'} * $info->{'height'};
        croak "Incomplete ASCII PGM" if scalar(@raster) < $size;

        # Discard any additional integers
        splice @raster, $size if scalar(@raster) > $size;

        # Scale
        $scale = 1;
        if ($info->{'max'} <= 255) {
            $bpc = 8;
            $scale = 255 / $info->{'max'} unless $info->{'max'} == 255;
        }
        else {
            $bpc = 16;
            $scale = 65535 / $info->{'max'} unless $info->{'max'} == 65535;
        }
        @raster = map { $_ * $scale } @raster;

        # Convert to bytes
        if ($bpc == 8) {
            $self->{' stream'} = pack('C*', @raster);
        }
        else {
            $self->{' stream'} = pack('S*', @raster);
        }
    }
    elsif ($info->{'type'} == 3) { # ASCII PPM
        $cs = 'DeviceRGB';

        # Read the remainder of the file
        local $/ = undef;
        my $plain = <$fh>;

        # Discard everything other than digits and whitespace
        $plain =~ s/[^\d\s]+//gs;
        $plain =~ s/^\s+//;

        # Convert to an array of integers
        my @raster = split m/\s+/, $plain;

        # Check length
        my $size = $info->{'width'} * $info->{'height'};
        croak "Incomplete ASCII PGM" if scalar(@raster) < $size * 3;

        # Discard any additional integers
        splice @raster, $size if scalar(@raster) > $size * 3;

        # Scale
        $scale = 1;
        if ($info->{'max'} <= 255) {
            $bpc = 8;
            $scale = 255 / $info->{'max'} unless $info->{'max'} == 255;
        }
        else {
            $bpc = 16;
            $scale = 65535 / $info->{'max'} unless $info->{'max'} == 65535;
        }
        @raster = map { $_ * $scale } @raster;

        # Convert to bytes
        if ($bpc == 8) {
            $self->{' stream'} = pack('C*', @raster);
        }
        else {
            $self->{' stream'} = pack('S*', @raster);
        }
    }
    elsif ($info->{'type'} == 4) { # Raw PBM
        $cs = 'DeviceGray';
        $bpc = 1;
        $self->{'Decode'} = PDFArray(PDFNum(1), PDFNum(0));
        read($fh, $self->{' stream'}, ($info->{'width'} * $info->{'height'} / 8));
    }
    elsif ($info->{'type'} == 5) { # Raw PGM
        $cs = 'DeviceGray';
        $bpc = $info->{'max'} <= 255 ? 8 : 16;

        if ($info->{'max'} == 255 or $info->{'max'} == 65535) {
            $scale = 1;
        }
        else {
            $scale = ($bpc == 8 ? 255 : 65535) / $info->{'max'};
        }

        my $size = $info->{'width'} * $info->{'height'};
        if ($scale == 1) {
            read($fh, $self->{' stream'}, $size * ($bpc / 8));
        }
        else {
            for (1 .. $size) {
                read($fh, $buf, $bpc / 8);
                if ($bpc == 8) {
                    $self->{' stream'} .= pack('C', (unpack('C', $buf) * $scale));
                }
                else {
                    $self->{' stream'} .= pack('S', (unpack('S', $buf) * $scale));
                }
            }
        }
    }
    elsif ($info->{'type'} == 6) { # Raw PPM
        $cs = 'DeviceRGB';
        $bpc = $info->{'max'} <= 255 ? 8 : 16;

        if ($info->{'max'} == 255 or $info->{'max'} == 65535) {
            $scale = 1;
        }
        else {
            $scale = ($bpc == 8 ? 255 : 65535) / $info->{'max'};
        }

        my $size = $info->{'width'} * $info->{'height'};
        if ($scale == 1) {
            read($fh, $self->{' stream'}, $size * ($bpc / 8) * 3);
        }
        else {
            for (1 .. ($size * 3)) {
                read($fh, $buf, $bpc / 8);
                if ($bpc == 8) {
                    $self->{' stream'} .= pack('C', (unpack('C', $buf) * $scale));
                }
                else {
                    $self->{' stream'} .= pack('S', (unpack('S', $buf) * $scale));
                }
            }
        }
    }
    close $fh;

    $self->width($info->{'width'});
    $self->height($info->{'height'});

    $self->bits_per_component($bpc);

    $self->colorspace($cs);

    return $self;
}

1;
