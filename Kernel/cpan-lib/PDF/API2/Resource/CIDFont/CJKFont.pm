package PDF::API2::Resource::CIDFont::CJKFont;

use base 'PDF::API2::Resource::CIDFont';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

our $fonts = {};
our $cmap  = {};
our $alias;
our $subs;

=encoding UTF-8

=head1 NAME

PDF::API2::Resource::CIDFont::CJKFont - Deprecated base class for CJK fonts

=head1 DESCRIPTION

This is not the CJK font support you are looking for.  It dates back to the days
when Unicode was young and poorly supported.  PDFs created using this class are
not portable.

Instead, use a regular TrueType or OpenType font that includes Unicode support
and create your PDF normally:

    use PDF::API2;
    use utf8;

    my $pdf = PDF::API2->new();
    my $font = $pdf->font('/path/to/font.ttf');
    my $page = $pdf->page();
    my $content = $page->text();
    $content->font($font, 24);

    # Chinese
    $content->translate(72, 72 * 9);
    $content->text('你好');

    # Japanese
    $content->distance(0, -72);
    $content->text('こんにちは');

    # Korean
    $content->distance(0, -72);
    $content->text('안녕하세요');

    $pdf->save('hello.pdf');

Note: The maintainer is not familiar with CJK languages and has deprecated this
class based on his current understanding of Unicode and from reading many bug
reports.  If you are successfully using the CJK support from this class and
think it should not be deprecated, please contact him to discuss.

=head1 DEPRECATED METHODS

=over

=item $font = $class->new($pdf, $cjk_font_name, %options)

Returns a CJK font object.  The requested font will not be embedded in the PDF,
so it will only be readable on computers that have the font installed.

Available fonts:

=over

=item Chinese (Traditional)

Ming, Ming-Bold, Ming-Italic, and Ming-BoldItalic

=item Chinese (Simplified)

Song, Song-Bold, Song-Italic, and Song-BoldItalic

=item Korean

MyungJo, MyungJo-Bold, MyungJo-Italic, and MyungJo-BoldItalic

=item Japanese (Mincho Serif)

KozMin, KozMin-Bold, KozMin-Italic, and KozMin-BoldItalic

=item Japanese (Gothic Sans Serif)

KozGo, KozGo-Bold, KozGo-Italic, KozGo-BoldItalic

=back

If the text isn't UTF-8, include an C<-encode> option with the encoding to be
used.

=cut

sub _look_for_font {
    my $fname = lc(shift);
    $fname =~ s/[^a-z0-9]+//gi;
    $fname = $alias->{$fname} if defined $alias->{$fname};
    return { %{$fonts->{$fname}} } if defined $fonts->{$fname};

    if (defined $subs->{$fname}) {
        my $data = _look_for_font($subs->{$fname}->{'-alias'});
        foreach my $k (keys %{$subs->{$fname}}) {
            next if $k =~ /^\-/;
            if (substr($k, 0, 1) eq '+') {
                $data->{substr($k, 1)} .= $subs->{$fname}->{$k};
            }
            else {
                $data->{$k} = $subs->{$fname}->{$k};
            }
        }
        $fonts->{$fname} = $data;
        return { %$data };
    }

    eval "require 'PDF/API2/Resource/CIDFont/CJKFont/$fname.data'";
    unless ($@) {
        return { %{$fonts->{$fname}} };
    }
    else {
        die "requested font '$fname' not installed";
    }
}

sub _look_for_cmap {
    my $map = shift();
    my $filename = lc($map);
    $filename =~ s/[^a-z0-9]+//gi;
    return { %{$cmap->{$filename}} } if defined $cmap->{$filename};
    eval "require 'PDF/API2/Resource/CIDFont/CMap/$filename.cmap'";
    unless ($@) {
        return { %{$cmap->{$filename}} };
    }
    else {
        die "requested cmap '$map' not installed";
    }
}

sub new {
    my ($class, $pdf, $name, %opts) = @_;
    $opts{'-encode'} //= 'ident';

    my $data = _look_for_font($name);

    my $cmap = _look_for_cmap($data->{'cmap'});

    $data->{'u2g'} = { %{$cmap->{'u2g'}} };
    $data->{'g2u'} = [ @{$cmap->{'g2u'}} ];

    $class = ref($class) if ref($class);
    my $key = ($data->{'apiname'} // '') . pdfkey();
    my $self = $class->SUPER::new($pdf, $key);
    $pdf->new_obj($self) if defined($pdf) and not $self->is_obj($pdf);

    $self->{' data'} = $data;

    if (defined $opts{'-encode'} and $opts{'-encode'} ne 'ident') {
        $self->data->{'encode'} = $opts{'-encode'};
    }

    my $emap = {
        'reg' => 'Adobe',
        'ord' => 'Identity',
        'sup' =>  0,
        'map' => 'Identity',
        'dir' => 'H',
        'dec' => 'ident',
    };

    if (defined $cmap->{'ccs'}) {
        $emap->{'reg'} = $cmap->{'ccs'}->[0];
        $emap->{'ord'} = $cmap->{'ccs'}->[1];
        $emap->{'sup'} = $cmap->{'ccs'}->[2];
    }

    # if (defined $cmap->{'cmap'} and defined $cmap->{'cmap'}->{$opts{'-encode'}} ) {
    #     $emap->{'dec'} = $cmap->{'cmap'}->{$opts{'-encode'}}->[0];
    #     $emap->{'map'} = $cmap->{'cmap'}->{$opts{'-encode'}}->[1];
    # }
    # elsif (defined $cmap->{'cmap'} and defined $cmap->{'cmap'}->{'utf8'} ) {
    #     $emap->{'dec'} = $cmap->{'cmap'}->{'utf8'}->[0];
    #     $emap->{'map'} = $cmap->{'cmap'}->{'utf8'}->[1];
    # }

    $self->data->{'decode'} = $emap->{'dec'};

    $self->{'BaseFont'} = PDFName(join('-',
                                       $self->fontname(),
                                       $emap->{'map'},
                                       $emap->{'dir'}));
    $self->{'Encoding'} = PDFName($emap->{'map'} . '-' . $emap->{'dir'});

    my $des = $self->descrByData();
    my $de = $self->{' de'};

    $de->{'FontDescriptor'} = $des;
    $de->{'Subtype'} = PDFName('CIDFontType0');
    $de->{'BaseFont'} = PDFName($self->fontname());
    $de->{'DW'} = PDFNum($self->missingwidth());
    $de->{'CIDSystemInfo'}->{'Registry'} = PDFStr($emap->{'reg'});
    $de->{'CIDSystemInfo'}->{'Ordering'} = PDFStr($emap->{'ord'});
    $de->{'CIDSystemInfo'}->{'Supplement'} = PDFNum($emap->{'sup'});
    # $de->{'CIDToGIDMap'} = PDFName($emap->{'map'}); # ttf only

    return $self;
}

sub tounicodemap {
    my $self = shift();
    # noop since pdf knows its char-collection
    return $self;
}

sub glyphByCId {
    my ($self, $cid) = @_;
    my $uni = $self->uniByCId($cid);
    return nameByUni($uni);
}

sub outobjdeep {
    my ($self, $fh, $pdf) = @_;

    my $notdefbefore = 1;

    my $wx = PDFArray();
    $self->{' de'}->{'W'} = $wx;
    my $ml;

    foreach my $i (0 .. (scalar @{$self->data->{'g2u'}} - 1)) {
        if (ref($self->data->{'wx'}) eq 'ARRAY'
            and defined $self->data->{'wx'}->[$i]
            and $self->data->{'wx'}->[$i] != $self->missingwidth())
        {
            if ($notdefbefore) {
                $notdefbefore = 0;
                $ml = PDFArray();
                $wx->add_elements(PDFNum($i), $ml);
            }
            $ml->add_elements(PDFNum($self->data->{'wx'}->[$i]));
        }
        elsif (ref($self->data->{'wx'}) eq 'HASH'
               and defined $self->data->{'wx'}->{$i}
               and $self->data->{'wx'}->{$i} != $self->missingwidth())
        {
            if ($notdefbefore) {
                $notdefbefore = 0;
                $ml = PDFArray();
                $wx->add_elements(PDFNum($i), $ml);
            }
            $ml->add_elements(PDFNum($self->data->{'wx'}->{$i}));
        }
        else {
            $notdefbefore = 1;
        }
    }

    $self->SUPER::outobjdeep($fh, $pdf);
}

BEGIN {
    $alias = {
        'traditional'           => 'adobemingstdlightacro',
        'traditionalbold'       => 'mingbold',
        'traditionalitalic'     => 'mingitalic',
        'traditionalbolditalic' => 'mingbolditalic',
        'ming'                  => 'adobemingstdlightacro',

        'simplified'            => 'adobesongstdlightacro',
        'simplifiedbold'        => 'songbold',
        'simplifieditalic'      => 'songitalic',
        'simplifiedbolditalic'  => 'songbolditalic',
        'song'                  => 'adobesongstdlightacro',

        'korean'                => 'adobemyungjostdmediumacro',
        'koreanbold'            => 'myungjobold',
        'koreanitalic'          => 'myungjoitalic',
        'koreanbolditalic'      => 'myungjobolditalic',
        'myungjo'               => 'adobemyungjostdmediumacro',

        'japanese'              => 'kozminproregularacro',
        'japanesebold'          => 'kozminbold',
        'japaneseitalic'        => 'kozminitalic',
        'japanesebolditalic'    => 'kozminbolditalic',
        'kozmin'                => 'kozminproregularacro',
        'kozgo'                 => 'kozgopromediumacro',
    };

    $subs = {
        # Chinese Traditional (Taiwan) Fonts
        'mingitalic' => {
            '-alias'    => 'adobemingstdlightacro',
            '+fontname' => ',Italic',
        },
        'mingbold' => {
            '-alias'    => 'adobemingstdlightacro',
            '+fontname' => ',Bold',
        },
        'mingbolditalic' => {
            '-alias'    => 'adobemingstdlightacro',
            '+fontname' => ',BoldItalic',
        },

        # Chinese Simplified (Mainland China) Fonts
        'songitalic' => {
            '-alias'    => 'adobesongstdlightacro',
            '+fontname' => ',Italic',
        },
        'songbold' => {
            '-alias'    => 'adobesongstdlightacro',
            '+fontname' => ',Bold',
        },
        'songbolditalic' => {
            '-alias'    => 'adobesongstdlightacro',
            '+fontname' => ',BoldItalic',
        },

        # Japanese Gothic (sans serif) Fonts
        'kozgoitalic' => {
            '-alias'    => 'kozgopromediumacro',
            '+fontname' => ',Italic',
        },
        'kozgobold' => {
            '-alias'    => 'kozgopromediumacro',
            '+fontname' => ',Bold',
        },
        'kozgobolditalic' => {
            '-alias'    => 'kozgopromediumacro',
            '+fontname' => ',BoldItalic',
        },

        # Japanese Mincho (serif) Fonts
        'kozminitalic' => {
            '-alias'    => 'kozminproregularacro',
            '+fontname' => ',Italic',
        },
        'kozminbold' => {
            '-alias'    => 'kozminproregularacro',
            '+fontname' => ',Bold',
        },
        'kozminbolditalic' => {
            '-alias'    => 'kozminproregularacro',
            '+fontname' => ',BoldItalic',
        },

        # Korean Fonts
        'myungjoitalic' => {
            '-alias'    => 'adobemyungjostdmediumacro',
            '+fontname' => ',Italic',
        },
        'myungjobold' => {
            '-alias'    => 'adobemyungjostdmediumacro',
            '+fontname' => ',Bold',
        },
        'myungjobolditalic' => {
            '-alias'    => 'adobemyungjostdmediumacro',
            '+fontname' => ',BoldItalic',
        },
    };
}

=back

=cut

1;
