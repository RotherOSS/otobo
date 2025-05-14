package PDF::API2::Resource::XObject::Image::GIF;

use base 'PDF::API2::Resource::XObject::Image';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp;
use IO::File;
use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;
use Scalar::Util qw(weaken);

# GIF89a Specification:
# https://www.w3.org/Graphics/GIF/spec-gif89a.txt

# Originally from PDF::Create
# PDF::Image::GIFImage - GIF image support
# Author: Michael Gross <mdgrosse@sbox.tugraz.at>
sub unInterlace {
    my $self = shift;
    my $data = $self->{' stream'};
    my $row;
    my @result;
    my $width = $self->width();
    my $height = $self->height();
    my $idx = 0;

    # Pass 1 - every 8th row, starting with row 0
    $row = 0;
    while ($row < $height) {
        $result[$row] = substr($data, $idx * $width, $width);
        $row += 8;
        $idx++;
    }

    # Pass 2 - every 8th row, starting with row 4
    $row = 4;
    while ($row < $height) {
        $result[$row] = substr($data, $idx * $width, $width);
        $row += 8;
        $idx++;
    }

    # Pass 3 - every 4th row, starting with row 2
    $row = 2;
    while ($row < $height) {
        $result[$row] = substr($data, $idx * $width, $width);
        $row += 4;
        $idx++;
    }

    # Pass 4 - every 2th row, starting with row 1
    $row = 1;
    while ($row < $height) {
        $result[$row] = substr($data, $idx * $width, $width);
        $row += 2;
        $idx++;
    }

    $self->{' stream'} = join('', @result);
}

sub deGIF {
    my ($ibits, $stream) = @_;
    my $bits = $ibits;
    my $resetcode = 1 << ($ibits - 1);
    my $endcode = $resetcode + 1;
    my $nextcode = $endcode + 1;
    my $ptr = 0;
    my $maxptr = 8 * length($stream);
    my $tag;
    my $out = '';
    my $outptr = 0;

    my @d = map { chr($_) } (0 .. ($resetcode - 1));

    while (($ptr + $bits) <= $maxptr) {
        $tag = 0;
        foreach my $off (reverse 0 .. ($bits - 1)) {
            $tag <<= 1;
            $tag |= vec($stream, $ptr + $off, 1);
        }
        # foreach my $off (0..$bits-1) {
        #     $tag<<=1;
        #     $tag|=vec($stream,$ptr+$off,1);
        # }
        # print STDERR "ptr=$ptr,tag=$tag,bits=$bits,next=$nextcode\n";
        # print STDERR "tag to large\n" if($tag>$nextcode);
        $ptr += $bits;
        $bits++ if $nextcode == 1 << $bits and $bits < 12;
        if ($tag==$resetcode) {
            $bits = $ibits;
            $nextcode = $endcode + 1;
            next;
        }
        elsif ($tag == $endcode) {
            last;
        }
        elsif ($tag < $resetcode) {
            $d[$nextcode] = $d[$tag];
            $out .= $d[$nextcode];
            $nextcode++;
        }
        elsif ($tag > $endcode) {
            $d[$nextcode] = $d[$tag];
            $d[$nextcode] .= substr($d[$tag + 1], 0, 1);
            $out .= $d[$nextcode];
            $nextcode++;
        }
    }
    return $out;
}

sub new {
    my ($class, $pdf, $file, $name, %opts) = @_;
    my $self;
    my $interlaced = 0;

    $class = ref($class) if ref($class);

    $self = $class->SUPER::new($pdf, $name || 'Gx' . pdfkey());
    $pdf->new_obj($self) unless $self->is_obj($pdf);

    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};

    my $fh = IO::File->new();
    if (ref($file)) {
        $fh = $file;
    }
    else {
        open $fh, '<', $file or die "$!: $file";
    }
    binmode $fh, ':raw';
    my $buf;
    $fh->seek(0, 0);
    $fh->read($buf, 6); # signature
    unless ($buf =~ /^GIF[0-9][0-9][a-z]/) {
        die "Unknown image signature '$buf' -- not a GIF";
    }

    $fh->read($buf, 7); # logical screen descriptor
    my ($wg, $hg, $flags, $bgColorIndex, $aspect) = unpack('vvCCC', $buf);

    if ($flags & 0x80) {
        my $colSize = 2 ** (($flags & 0x7) + 1);
        my $dict = PDFDict();
        $pdf->new_obj($dict);
        $self->colorspace(PDFArray(PDFName('Indexed'),
                                   PDFName('DeviceRGB'),
                                   PDFNum($colSize-1),
                                   $dict));
        $fh->read($dict->{' stream'}, 3 * $colSize); # color table
    }

    until ($fh->eof()) {
        $fh->read($buf, 1); # tag.
        my $sep = unpack('C', $buf);
        if ($sep == 0x2C) {
            $fh->read($buf, 9); # image descriptor
            my ($left, $top, $w, $h, $flags) = unpack('vvvvC', $buf);

            $self->width($w || $wg);
            $self->height($h || $hg);
            $self->bpc(8);

            if ($flags & 0x80) { # local color table
                my $colSize = 2 ** (($flags & 0x7) + 1);
                my $dict = PDFDict();
                $pdf->new_obj($dict);
                $self->colorspace(PDFArray(PDFName('Indexed'),
                                           PDFName('DeviceRGB'),
                                           PDFNum($colSize-1),
                                           $dict));
                $fh->read($dict->{' stream'}, 3 * $colSize); # color table
            }
            if ($flags & 0x40) { # whether image is interlaced
                $interlaced = 1;
            }

            $fh->read($buf, 1); # image-lzw-start (should be 9).
            my ($sep) = unpack('C', $buf);

            $fh->read($buf, 1); # first chunk.
            my ($len) = unpack('C', $buf);
            my $stream = '';
            while ($len > 0) {
                $fh->read($buf, $len);
                $stream .= $buf;
                $fh->read($buf, 1);
                $len = unpack('C', $buf);
            }
            $self->{' stream'} = deGIF($sep + 1, $stream);
            $self->unInterlace() if $interlaced;
            last;
        }
        elsif ($sep == 0x3b) { # trailer
            last;
        }
        else { # extension
            $fh->read($buf, 1); # tag
            my $tag = unpack('C', $buf);
            $fh->read($buf, 1); # length
            my $len = unpack('C', $buf);
            my $stream = '';
            while ($len > 0) {
                $fh->read($buf, $len);
                $stream .= $buf;
                $fh->read($buf, 1);
                $len = unpack('C', $buf);
            }

            # Graphic Control Extension
            if ($sep == 0x21 and $tag == 0xF9) {
                my ($cFlags, $delay, $transIndex) = unpack('CvC', $stream);
                if (($cFlags & 0x01) and not $opts{'-notrans'}) {
                    $self->{'Mask'} = PDFArray(PDFNum($transIndex),
                                               PDFNum($transIndex));
                }
            }

            # Comment Extension
            elsif ($sep == 0x21 and $tag == 0xFE) {
                # NOOP: ignore
            }

            # Plain Text Extension
            elsif ($sep == 0x21 and $tag == 0x01) {
                # NOOP: ignore
            }

            elsif ($sep == 0x21) {
                carp "Ignoring unsupported GIF extension $tag";
            }
        }
    }
    $fh->close();

    $self->filters('FlateDecode');

    return $self;
}

1;
