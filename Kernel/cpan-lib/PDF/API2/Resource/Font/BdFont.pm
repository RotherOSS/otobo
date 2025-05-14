package PDF::API2::Resource::Font::BdFont;

use base 'PDF::API2::Resource::Font';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

our $BmpNum = 0;

=head1 NAME

PDF::API2::Resource::Font::BdFont - Module for using bitmapped Fonts.

=head1 SYNOPSIS

    #
    use PDF::API2;
    #
    $pdf = PDF::API2->new;
    $sft = $pdf->bdfont($file);
    #

=head1 METHODS

=over 4

=cut

=item $font = PDF::API2::Resource::Font::BdFont->new $pdf, $font, %options

Returns a BmpFont object.

=cut

=pod

Valid %options are:

I<-encode>
... changes the encoding of the font from its default.
See I<perl's Encode> for the supported values.

I<-pdfname> ... changes the reference-name of the font from its default.
The reference-name is normally generated automatically and can be
retrieved via $pdfname=$font->name.

=cut

sub new {
    my ($class, $pdf, $file, %opts) = @_;

    $class = ref($class) if ref($class);
    my $name = sprintf('%s+Bdf%02i', pdfkey(), ++$BmpNum) . '~' . time();
    my $self = $class->SUPER::new($pdf, $name);
    $pdf->new_obj($self) unless $self->is_obj($pdf);

    # Adobe Bitmap Distribution Font
    $self->{' data'} = $self->readBDF($file);

    my $first = 1;
    my $last = 255;

    $self->{'Subtype'} = PDFName('Type3');
    $self->{'FirstChar'} = PDFNum($first);
    $self->{'LastChar'} = PDFNum($last);
    $self->{'FontMatrix'} = PDFArray(map { PDFNum($_) } 0.001, 0, 0, 0.001, 0, 0);
    $self->{'FontBBox'} = PDFArray(map { PDFNum($_) } $self->fontbbox());

    my $xo = PDFDict();
    $self->{'Encoding'} = $xo;
    $xo->{'Type'} = PDFName('Encoding');
    $xo->{'BaseEncoding'} = PDFName('WinAnsiEncoding');
    $xo->{'Differences'} = PDFArray(PDFNum('0'),
                                    map { PDFName($_ or '.notdef') }
                                    @{$self->data->{'char'}});

    my $procs = PDFDict();
    $pdf->new_obj($procs);
    $self->{'CharProcs'} = $procs;

    $self->{'Resources'} = PDFDict();
    $self->{'Resources'}->{'ProcSet'} = PDFArray(map { PDFName($_) }
                                                 qw(PDF Text ImageB ImageC ImageI));
    foreach my $w ($first .. $last) {
        $self->data->{'uni'}->[$w] = uniByName($self->data->{'char'}->[$w]);
        $self->data->{'u2e'}->{$self->data->{'uni'}->[$w]} = $w;
    }
    my @widths;
    foreach my $w (@{$self->data->{'char2'}}) {
        $widths[$w->{'ENCODING'}] = $self->data->{'wx'}->{$w->{'NAME'}};
        my @bbx = @{$w->{'BBX'}};
        my $stream = pack('H*', $w->{'hex'});
        my $y = $bbx[1];
        my $char = PDFDict();
        $char->{'Filter'} = PDFArray(PDFName('FlateDecode'));
        # $char->{' stream'} = $widths[$w->{'ENCODING'}] . ' 0 ' . join(' ', map { int($_) } $self->fontbbox()) . " d1\n";
        $char->{' stream'} = $widths[$w->{'ENCODING'}] . " 0 d0\n";
        $char->{'Comment'} = PDFStr(join(' ',
                                         "N='" . $w->{'NAME'} . "'",
                                         "C=(" . $w->{'ENCODING'} . ")"));
        $procs->{$w->{'NAME'}} = $char;
        @bbx = map { $_ * 1000 / $self->data->{'upm'} } @bbx;
        if ($y == 0) {
            $char->{' stream'} .= "q Q\n";
        }
        else {
            my $x = 8 * length($stream) / $y; # q $x 0 0 $y 50 50 cm
            my $dict = join('',
                            "/Interpolate true",
                            "/Mask[0 0.1]",
                            "/Decode[1 0]",
                            "/H $y",
                            "/W $x",
                            "/BPC 1",
                            "/CS /G");
            my $img = qq|BI\n$dict\nID $stream\nEI\n|;
            $procs->{$self->data->{'char'}->[$w]} = $char;
            $char->{' stream'} .= "$bbx[0] 0 0 $bbx[1] $bbx[2] $bbx[3] cm\n";
            $char->{' stream'} .= $img . "\n";
        }
        $pdf->new_obj($char);
    }
    $procs->{'.notdef'} = $procs->{$self->data->{'char'}->[32]};
    delete $procs->{''};
    $self->{'Widths'} = PDFArray(map { PDFNum($widths[$_] or 0) }
                                 $first .. $last);
    $self->data->{'e2n'} = $self->data->{'char'};
    $self->data->{'e2u'} = $self->data->{'uni'};

    $self->data->{'u2c'} = {};
    $self->data->{'u2e'} = {};
    $self->data->{'u2n'} = {};
    $self->data->{'n2c'} = {};
    $self->data->{'n2e'} = {};
    $self->data->{'n2u'} = {};

    my $data = $self->data();
    foreach my $n (reverse 0 .. 255) {
        $data->{'n2c'}->{$data->{'char'}->[$n] or '.notdef'} //= $n;
        $data->{'n2e'}->{$data->{'e2n'}->[$n] or '.notdef'} //= $n;

        $data->{'n2u'}->{$data->{'e2n'}->[$n] or '.notdef'} //= $data->{'e2u'}->[$n];
        $data->{'n2u'}->{$data->{'char'}->[$n] or '.notdef'} //= $data->{'uni'}->[$n];

        $data->{'u2c'}->{$data->{'uni'}->[$n]} //= $n;
        $data->{'u2e'}->{$data->{'e2u'}->[$n]} //= $n;

        $data->{'u2n'}->{$data->{'e2u'}->[$n]} //= ($data->{'e2n'}->[$n] or '.notdef');
        $data->{'u2n'}->{$data->{'uni'}->[$n]} //= ($data->{char}->[$n] or '.notdef');
    }

    return $self;
}

sub readBDF {
    my ($self, $file) = @_;
    my $data = {};
    $data->{'char'} = [];
    $data->{'char2'} = [];
    $data->{'wx'} = {};

    die "file='$file' doesn't exist" unless -e $file;
    open(my $afmf, '<', $file) or die "Can't find the BDF file for $file";

    local $/ = "\n"; # ensure correct $INPUT_RECORD_SEPARATOR
    local $_ = undef;
    while ($_ = <$afmf>) {
        chomp($_);
        if (/^STARTCHAR/ .. /^ENDCHAR/) {
            if (/^STARTCHAR\s+(\S+)/) {
                my $name = $1;
                $name =~ s/^(\d+.*)$/X_$1/;
                push @{$data->{'char2'}}, { 'NAME' => $name };
            }
            elsif (/^BITMAP/ .. /^ENDCHAR/) {
                next if /^BITMAP/;
                if (/^ENDCHAR/) {
                    $data->{'char2'}->[-1]->{'NAME'} ||= 'E_' . $data->{'char2'}->[-1]->{'ENCODING'};
                    $data->{'char'}->[$data->{'char2'}->[-1]->{'ENCODING'}] = $data->{'char2'}->[-1]->{'NAME'};
                    ($data->{'wx'}->{$data->{'char2'}->[-1]->{'NAME'}}) = split(/\s+/, $data->{'char2'}->[-1]->{'SWIDTH'});
                    $data->{'char2'}->[-1]->{'BBX'} = [split(/\s+/, $data->{'char2'}->[-1]->{'BBX'})];
                }
                else {
                    $data->{'char2'}->[-1]->{'hex'} .= $_;
                }
            }
            else {
                m/^(\S+)\s+(.+)$/;
                $data->{'char2'}->[-1]->{uc($1)} .= $2;
            }
        # } elsif (/^STARTPROPERTIES/ .. /^ENDPROPERTIES/) {
        }
        else {
            m/^(\S+)\s+(.+)$/;
            $data->{uc($1)} .= $2;
        }
    }
    close($afmf);
    unless (exists $data->{'wx'}->{'.notdef'}) {
        $data->{'wx'}->{'.notdef'} = 0;
        $data->{'bbox'}{'.notdef'} = [0, 0, 0, 0];
    }

    $data->{'fontname'} = pdfkey() . pdfkey() . '~' . time();
    $data->{'apiname'} = $data->{'fontname'};
    $data->{'flags'} = 34;
    $data->{'fontbbox'} = [ split(/\s+/, $data->{'FONTBOUNDINGBOX'}) ];
    $data->{'upm'} = ($data->{'PIXEL_SIZE'}
                      or ($data->{'fontbbox'}->[1] - $data->{'fontbbox'}->[3]));
    @{$data->{'fontbbox'}} = (map { int($_ * 1000 / $data->{'upm'}) }
                              @{$data->{'fontbbox'}});

    foreach my $n (0 .. 255) {
        $data->{'char'}->[$n] ||= '.notdef';
        # $data->{'wx'}->{$data->{'char'}->[$n]}
        # = int($data->{'wx'}->{$data->{'char'}->[$n]} * 1000 / $data->{'upm'});
    }

    $data->{'uni'} ||= [];
    foreach my $n (0 .. 255) {
        $data->{'uni'}->[$n] = uniByName($data->{'char'}->[$n] or '.notdef') || 0;
    }
    $data->{'ascender'} = $data->{'RAW_ASCENT'}
        || int($data->{'FONT_ASCENT'} * 1000 / $data->{'upm'});
    $data->{'descender'} = $data->{'RAW_DESCENT'}
        || int($data->{'FONT_DESCENT'} * 1000 / $data->{'upm'});

    $data->{'type'} = 'Type3';
    $data->{'capheight'} = 1000;
    $data->{'iscore'} = 0;
    $data->{'issymbol'} = 0;
    $data->{'isfixedpitch'} = 0;
    $data->{'italicangle'} = 0;
    $data->{'missingwidth'} = $data->{'AVERAGE_WIDTH'}
        || int($data->{'FONT_AVERAGE_WIDTH'} * 1000 / $data->{'upm'})
        || $data->{'RAW_AVERAGE_WIDTH'}
        || 500;
    $data->{'underlineposition'} = -200;
    $data->{'underlinethickness'} = 10;
    $data->{'xheight'} = $data->{'RAW_XHEIGHT'}
        || int($data->{'FONT_XHEIGHT'} * 1000 / $data->{'upm'})
        || int($data->{'ascender'} / 2);
    $data->{'firstchar'} = 1;
    $data->{'lastchar'} = 255;

    delete $data->{'wx'}->{''};

    return $data;
}

=back

=cut

1;
