package PDF::API2::Resource::CIDFont;

use base 'PDF::API2::Resource::BaseFont';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Encode qw(:all);

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

=head1 NAME

PDF::API2::Resource::CIDFont - Base class for CID fonts

=head1 METHODS

=over

=item $font = PDF::API2::Resource::CIDFont->new $pdf, $name

Returns a cid-font object. base class form all CID based fonts.

=cut

sub new {
    my ($class, $pdf, $name, %opts) = @_;
    $class = ref($class) if ref($class);

    my $self = $class->SUPER::new($pdf, $name);

    $pdf->new_obj($self) if defined $pdf and not $self->is_obj($pdf);

    $self->{'Type'}     = PDFName('Font');
    $self->{'Subtype'}  = PDFName('Type0');
    $self->{'Encoding'} = PDFName('Identity-H');

    my $de = PDFDict();
    $pdf->new_obj($de);
    $self->{'DescendantFonts'} = PDFArray($de);

    $de->{'Type'} = PDFName('Font');
    $de->{'CIDSystemInfo'} = PDFDict();
    $de->{'CIDSystemInfo'}->{'Registry'} = PDFStr('Adobe');
    $de->{'CIDSystemInfo'}->{'Ordering'} = PDFStr('Identity');
    $de->{'CIDSystemInfo'}->{'Supplement'} = PDFNum(0);
    $de->{'CIDToGIDMap'} = PDFName('Identity');

    $self->{' de'} = $de;

    return $self;
}

sub glyphByCId { return $_[0]->data->{'g2n'}->[$_[1]] }

sub uniByCId { return $_[0]->data->{'g2u'}->[$_[1]] }

sub cidByUni { return $_[0]->data->{'u2g'}->{$_[1]} }

sub cidByEnc { return $_[0]->data->{'e2g'}->[$_[1]] }

sub wxByCId {
    my ($self, $g) = @_;

    my $widths = $self->data->{'wx'};
    if (ref($widths) eq 'ARRAY') {
        return int($widths->[$g]) if defined $widths->[$g];
    }
    elsif (ref($widths) eq 'HASH') {
        return int($widths->{$g}) if defined $widths->{$g};
    }
    return $self->missingwidth();
}

sub wxByUni { return $_[0]->wxByCId($_[0]->data->{'u2g'}->{$_[1]}) }
sub wxByEnc { return $_[0]->wxByCId($_[0]->data->{'e2g'}->[$_[1]]) }

sub width {
    my ($self, $text) = @_;
    return $self->width_cid($self->cidsByStr($text));
}

sub width_cid {
    my ($self, $text) = @_;
    my $width = 0;
    my $lastglyph = 0;
    foreach my $n (unpack('n*', $text)) {
        $width += $self->wxByCId($n);
        if ($self->{'-dokern'} and $self->haveKernPairs()) {
            if ($self->kernPairCid($lastglyph, $n)) {
                $width -= $self->kernPairCid($lastglyph, $n);
            }
        }
        $lastglyph = $n;
    }
    $width /= 1000;
    return $width;
}

=item $cidstring = $font->cidsByStr $string

Returns the cid-string from string based on the fonts encoding map.

=cut

sub _cidsByStr {
    my ($self, $s) = @_;
    $s = pack('n*', map { $self->cidByEnc($_) } unpack('C*', $s));
    return $s;
}

sub cidsByStr {
    my ($self, $text) = @_;
    if (utf8::is_utf8($text)
        and defined $self->data->{'decode'}
        and $self->data->{'decode'} ne 'ident')
    {
        $text = encode($self->data->{'decode'}, $text);
    }
    elsif (utf8::is_utf8($text)
           and defined $self->data->{'decode'}
           and $self->data->{'decode'} eq 'ident')
    {
        $text = $self->cidsByUtf($text);
    }
    elsif (not utf8::is_utf8($text)
           and defined $self->data->{'encode'}
           and defined $self->data->{'decode'}
           and $self->data->{'decode'} eq 'ident')
    {
        $text = $self->cidsByUtf(decode($self->data->{'encode'}, $text));
    }
    elsif (not utf8::is_utf8($text)
           and $self->can('issymbol')
           and $self->issymbol()
           and defined $self->data->{'decode'}
           and $self->data->{'decode'} eq 'ident')
    {
        $text = pack('U*', map { $_ + 0xf000 } unpack('C*', $text));
        $text = $self->cidsByUtf($text);
    }
    else {
        $text = $self->_cidsByStr($text);
    }
    return $text;
}

=item $cidstring = $font->cidsByUtf $utf8string

Returns the cid-encoded string from utf8-string.

=cut

sub cidsByUtf {
    my ($self, $s) = @_;
    $s = pack('n*',
              map { $self->cidByUni($_) // 0 }
              map {
                  ($_ and $_ > 0x7f and $_ < 0xa0) ? uniByName(nameByUni($_)) : $_
              }
              unpack('U*', $s));
    utf8::downgrade($s);
    return $s;
}

sub textByStr {
    my ($self, $text) = @_;
    return $self->text_cid($self->cidsByStr($text));
}

sub textByStrKern {
    my ($self, $text, $size, $indent) = @_;
    return $self->text_cid_kern($self->cidsByStr($text), $size, $indent);
}

sub text {
    my ($self, $text, $size, $indent) = @_;
    my $newtext = $self->textByStr($text);
    if (defined $size and $self->{'-dokern'}) {
        $newtext = $self->textByStrKern($text, $size, $indent);
        return $newtext;
    }
    elsif (defined $size) {
        if (defined($indent) and $indent != 0) {
            return "[ $indent $newtext ] TJ";
        }
        else {
            return "$newtext Tj";
        }
    }
    else {
        return $newtext;
    }
}

sub text_cid {
    my ($self, $text, $size) = @_;
    if ($self->can('fontfile')) {
        foreach my $g (unpack('n*', $text)) {
            $self->fontfile->subsetByCId($g);
        }
    }
    my $newtext = unpack('H*', $text);
    if (defined $size) {
        return "<$newtext> Tj";
    }
    else {
        return "<$newtext>";
    }
}

sub text_cid_kern {
    my ($self, $text, $size, $indent) = @_;
    if ($self->can('fontfile')) {
        foreach my $g (unpack('n*', $text)) {
            $self->fontfile->subsetByCId($g);
        }
    }
    if (defined $size and $self->{'-dokern'} and $self->haveKernPairs()) {
        my $newtext = ' ';
        my $lastglyph = 0;
        my $tBefore = 0;
        foreach my $n (unpack('n*', $text)) {
            if ($self->kernPairCid($lastglyph, $n)) {
                $newtext .= '> ' if $tBefore;
                $newtext .= sprintf('%i ', $self->kernPairCid($lastglyph, $n));
                $tBefore = 0;
            }
            $lastglyph = $n;
            my $t = sprintf('%04X', $n);
            $newtext .= '<' unless $tBefore;
            $newtext .= $t;
            $tBefore = 1;
        }
        $newtext .= '> ' if $tBefore;
        if (defined $indent and $indent != 0) {
            return "[ $indent $newtext ] TJ";
        }
        else {
            return "[ $newtext ] TJ";
        }
    }
    elsif (defined $size) {
        my $newtext = unpack('H*', $text);
        if (defined($indent) and $indent != 0) {
            return "[ $indent <$newtext> ] TJ";
        }
        else {
            return "<$newtext> Tj";
        }
    }
    else {
        my $newtext = unpack('H*', $text);
        return "<$newtext>";
    }
}

sub kernPairCid {
    return 0;
}

sub haveKernPairs {
    return;
}

sub encodeByName {
    my ($self, $enc) = @_;
    return if $self->issymbol();

    if (defined $enc) {
        $self->data->{'e2u'} = [
            map { ($_ > 0x7f and $_ < 0xA0) ? uniByName(nameByUni($_)) : $_ }
            unpack('U*', decode($enc, pack('C*', 0 .. 255)))
        ];
    }
    $self->data->{'e2n'} = [
        map { $self->data->{'g2n'}->[$self->data->{'u2g'}->{$_} || 0] || '.notdef' }
        @{$self->data->{'e2u'}}
    ];
    $self->data->{'e2g'} = [
        map { $self->data->{'u2g'}->{$_} || 0 }
        @{$self->data->{'e2u'}}
    ];

    $self->data->{'u2e'} = {};
    foreach my $n (reverse 0 .. 255) {
        $self->data->{'u2e'}->{$self->data->{'e2u'}->[$n]} //= $n;
    }

    return $self;
}

sub subsetByCId {
    return 1;
}

sub subvec {
    return 1;
}

sub glyphNum {
    my $self = shift();
    if (defined $self->data->{'glyphs'}) {
        return $self->data->{'glyphs'};
    }
    return scalar @{$self->data->{'wx'}};
}

=back

=cut

1;
