package PDF::API2::Resource::Font::SynFont;

use base 'PDF::API2::Resource::Font';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Math::Trig;
use Unicode::UCD 'charinfo';

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::Resource::Font::SynFont - Module for creating synthetic Fonts.

=head1 SYNOPSIS

    my $pdf = PDF::API2->new();
    my $base_font = $pdf->font('Helvetica');

    # Create a condensed synthetic font
    my $condensed = $pdf->synthetic_font($base_font, hscale => 80);

    # Compare the two fonts
    my $text = $pdf->page->text();

    $text->font($base_font, 18);
    $text->distance(72, 720);
    $text->text('Hello World!');

    $text->font($condensed, 18);
    $text->distance(0, -36);
    $text->text('Hello World!');

    $pdf->save('sample.pdf');

=head1 DESCRIPTION

This module allows you to create a custom font based on an existing font,
adjusting the scale, stroke thickness, angle, and other properties of each
glyph.

=head1 FONT OPTIONS

=head2 hscale

A percentage to condense (less than 100) or expand (greater than 100) the glyphs
horizontally.

=head2 angle

A number of degrees to lean the glyphs to the left (negative angle) or to the
right (positive angle).

=head2 bold

A stroke width, in thousandths of a text unit, to add to the glyph's outline,
creating a bold effect.

=head2 smallcaps

Set to true to replace lower-case characters with small versions of their
upper-case glyphs.

=head2 space

Additional space, in thousandths of a text unit, to add between glyphs.

=cut

sub new {
    my ($class, $pdf, $font, %opts) = @_;
    my $first = 1;
    my $last = 255;

    # Deprecated options
    if (exists $opts{'-bold'}) {
        $opts{'bold'} //= (delete $opts{'-bold'}) * 10;
    }
    if (exists $opts{'-caps'}) {
        $opts{'smallcaps'} //= delete $opts{'-caps'};
    }
    if (exists $opts{'-oblique'}) {
        $opts{'angle'} //= delete $opts{'-oblique'};
    }
    if (exists $opts{'-slant'}) {
        $opts{'hscale'} //= (delete $opts{'-slant'}) * 100;
    }
    if (exists $opts{'-space'}) {
        $opts{'space'} //= delete $opts{'-space'};
    }

    my $angle  = $opts{'angle'} // 0;
    my $bold   = ($opts{'bold'} // 0);
    my $hscale = ($opts{'hscale'} // 100) / 100;
    my $space  = $opts{'space'} // 0;

    $font->encodeByName($opts{'-encode'}) if $opts{'-encode'};

    $class = ref($class) if ref($class);
    my $key = $opts{'name'} // 'Syn' . $font->name() . pdfkey();
    my $self = $class->SUPER::new($pdf, $key);
    $pdf->new_obj($self) unless $self->is_obj($pdf);
    $self->{' font'} = $font;
    $self->{' data'} = {
        'type' => 'Type3',
        'ascender' => $font->ascender(),
        'capheight' => $font->capheight(),
        'descender' => $font->descender(),
        'iscore' => '0',
        'isfixedpitch' => $font->isfixedpitch(),
        'italicangle' => $font->italicangle() + $angle,
        'missingwidth' => $font->missingwidth() * $hscale,
        'underlineposition' => $font->underlineposition(),
        'underlinethickness' => $font->underlinethickness(),
        'xheight' => $font->xheight(),
        'firstchar' => $first,
        'lastchar' => $last,
        'char' => [ '.notdef' ],
        'uni' => [ 0 ],
        'u2e' => { 0 => 0 },
        'fontbbox' => '',
        'wx' => { 'space' => '600' },
    };

    my $data = $self->data();
    if (ref($font->fontbbox())) {
        $data->{'fontbbox'} = [ @{$font->fontbbox()} ];
    }
    else {
        $data->{'fontbbox'} = [ $font->fontbbox() ];
    }
    $data->{'fontbbox'}->[0] *= $hscale;
    $data->{'fontbbox'}->[2] *= $hscale;

    $self->{'Subtype'} = PDFName('Type3');
    $self->{'FirstChar'} = PDFNum($first);
    $self->{'LastChar'} = PDFNum($last);
    $self->{'FontMatrix'} = PDFArray(map { PDFNum($_) } (0.001, 0, 0, 0.001, 0, 0));
    $self->{'FontBBox'} = PDFArray(map { PDFNum($_) } $self->fontbbox());

    my $procs = PDFDict();
    $pdf->new_obj($procs);
    $self->{'CharProcs'} = $procs;

    $self->{'Resources'} = PDFDict();
    $self->{'Resources'}->{'ProcSet'} = PDFArray(map { PDFName($_) }
                                                 qw(PDF Text ImageB ImageC ImageI));
    my $xo = PDFDict();
    $self->{'Resources'}->{'Font'} = $xo;
    $self->{'Resources'}->{'Font'}->{'FSN'} = $font;
    foreach my $w ($first .. $last) {
        $data->{'char'}->[$w] = $font->glyphByEnc($w);
        $data->{'uni'}->[$w] = uniByName($data->{'char'}->[$w]);
        if (defined $data->{'uni'}->[$w]) {
            $data->{'u2e'}->{$data->{'uni'}->[$w]} = $w;
        }
    }

    if ($font->isa('PDF::API2::Resource::CIDFont')) {
        $self->{'Encoding'} = PDFDict();
        $self->{'Encoding'}->{'Type'} = PDFName('Encoding');
        $self->{'Encoding'}->{'Differences'} = PDFArray();
        foreach my $w ($first .. $last) {
            my $char = $data->{'char'}->[$w];
            if (defined $char and $char ne '.notdef') {
                $self->{'Encoding'}->{'Differences'}->add_elements(PDFNum($w),
                                                                   PDFName($char));
            }
        }
    }
    else {
        $self->{'Encoding'} = $font->{'Encoding'};
    }

    my @widths;
    foreach my $w ($first .. $last) {
        if ($data->{'char'}->[$w] eq '.notdef') {
            push @widths, $self->missingwidth();
            next;
        }
        my $char = PDFDict();

        my $uni = $data->{'uni'}->[$w];
        my $wth = int($font->width(chr($uni)) * 1000 * $hscale + 2 * $space);

        $procs->{$font->glyphByEnc($w)} = $char;
        #$char->{'Filter'} = PDFArray(PDFName('FlateDecode'));
        $char->{' stream'} = $wth . ' 0 ' . join(' ', map { int($_) } $self->fontbbox()) . " d1\n";
        $char->{' stream'} .= "BT\n";
        if ($angle) {
            my @matrix = (1, 0, tan(deg2rad($angle)), 1, 0, 0);
            $char->{' stream'} .= join(' ', @matrix) . " Tm\n";
        }
        $char->{' stream'} .= "2 Tr " . $bold . " w\n" if $bold;
        my $ci = {};
        if ($data->{'uni'}->[$w] ne '') {
            $ci = charinfo($data->{'uni'}->[$w]);
        }
        if ($opts{'smallcaps'} and $ci->{'upper'}) {
            $char->{' stream'} .= "/FSN 800 Tf\n";
            $char->{' stream'} .= ($hscale * 110) . " Tz\n";
            $char->{' stream'} .= " [ -$space ] TJ\n" if $space;
            $wth = int($font->width(uc chr($uni)) * 800 * $hscale * 1.1 + 2 * $space);
            $char->{' stream'} .= $font->text(uc chr($uni));
        }
        else {
            $char->{' stream'} .= "/FSN 1000 Tf\n";
            $char->{' stream'} .= ($hscale * 100) . " Tz\n" if $hscale != 1;
            $char->{' stream'} .= " [ -$space ] TJ\n" if $space;
            $char->{' stream'} .= $font->text(chr($uni));
        }
        $char->{' stream'} .= " Tj\nET\n";
        push @widths, $wth;
        $data->{'wx'}->{$font->glyphByEnc($w)} = $wth;
        $pdf->new_obj($char);
    }

    $procs->{'.notdef'} = $procs->{$font->data->{'char'}->[32] // 0};
    $self->{'Widths'} = PDFArray(map { PDFNum($_) } @widths);
    $data->{'e2n'} = $data->{'char'};
    $data->{'e2u'} = $data->{'uni'};

    $data->{'u2c'} = {};
    $data->{'u2e'} = {};
    $data->{'u2n'} = {};
    $data->{'n2c'} = {};
    $data->{'n2e'} = {};
    $data->{'n2u'} = {};

    foreach my $n (reverse 0 .. 255) {
        $data->{'n2c'}->{$data->{'char'}->[$n] // '.notdef'} //= $n;
        $data->{'n2e'}->{$data->{'e2n'}->[$n] // '.notdef'} //= $n;

        $data->{'n2u'}->{$data->{'e2n'}->[$n] // '.notdef'} //= $data->{'e2u'}->[$n];
        $data->{'n2u'}->{$data->{'char'}->[$n] // '.notdef'} //= $data->{'uni'}->[$n];

        if (defined $data->{'uni'}->[$n]) {
            $data->{'u2c'}->{$data->{'uni'}->[$n]} //= $n;
        }
        if (defined $data->{'e2u'}->[$n]) {
            $data->{'u2e'}->{$data->{'e2u'}->[$n]} //= $n;

            my $value = ($data->{'e2n'}->[$n] // '.notdef');
            $data->{'u2n'}->{$data->{'e2u'}->[$n]} //= $value;
        }
        if (defined $data->{'uni'}->[$n]) {
            my $value = ($data->{'char'}->[$n] // '.notdef');
            $data->{'u2n'}->{$data->{'uni'}->[$n]} //= $value;
        }
    }

    return $self;
}

1;
