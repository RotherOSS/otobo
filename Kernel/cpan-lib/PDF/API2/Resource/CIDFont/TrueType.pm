package PDF::API2::Resource::CIDFont::TrueType;

use base 'PDF::API2::Resource::CIDFont';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Resource::CIDFont::TrueType::FontFile;
use PDF::API2::Util;

=head1 NAME

PDF::API2::Resource::CIDFont::TrueType - TrueType font support

=head1 METHODS

=over

=item $font = PDF::API2::Resource::CIDFont::TrueType->new $pdf, $file, %options

Returns a font object.

Defined Options:

    -encode ... specify fonts encoding for non-utf8 text.

    -nosubset ... disables subsetting.

=cut

sub new {
    my ($class, $pdf, $file, %opts) = @_;
    $opts{'-encode'} //= 'latin1';

    my ($ff, $data) = PDF::API2::Resource::CIDFont::TrueType::FontFile->new($pdf, $file, %opts);

    $class = ref($class) if ref($class);
    my $self = $class->SUPER::new($pdf, $data->{'apiname'} . pdfkey() . '~' . time());
    $pdf->new_obj($self) if defined($pdf) and not $self->is_obj($pdf);

    $self->{' data'} = $data;

    $self->{'BaseFont'} = PDFName($self->fontname());

    my $des = $self->descrByData();
    my $de = $self->{' de'};

    $de->{'FontDescriptor'} = $des;
    $de->{'Subtype'} = PDFName($self->iscff() ? 'CIDFontType0' : 'CIDFontType2');
    $de->{'BaseFont'} = PDFName($self->fontname());
    $de->{'DW'} = PDFNum($self->missingwidth());
    if ($opts{'embed'}) {
    	$des->{$self->iscff() ? 'FontFile3' : 'FontFile2'} = $ff;
    }
    unless ($self->issymbol()) {
        $self->encodeByName($opts{'-encode'});
        $self->data->{encode} = $opts{'-encode'};
        $self->data->{decode} = 'ident';
    }

    if ($opts{'-nosubset'}) {
        $self->data->{'nosubset'} = 1;
    }

    $self->{' ff'} = $ff;
    $pdf->new_obj($ff);

    $self->{'-dokern'} = 1 if $opts{'-dokern'};

    return $self;
}

sub fontfile { return $_[0]->{' ff'}; }
sub fontobj  { return $_[0]->data->{'obj'}; }

sub wxByCId {
    my ($self, $g) = @_;
    my $t = $self->fontobj->{'hmtx'}->read->{'advance'}[$g];

    if (defined $t) {
        return int($t * 1000 / $self->data->{'upem'});
    }
    else {
        return $self->missingwidth();
    }
}

sub haveKernPairs {
    my $self = shift();
    return $self->fontfile->haveKernPairs();
}

sub kernPairCid {
    my ($self, $i1, $i2) = @_;
    return $self->fontfile->kernPairCid($i1, $i2);
}

sub subsetByCId {
    my ($self, $g) = @_;
    return if $self->iscff();
    return $self->fontfile->subsetByCId($g);
}

sub subvec {
    my ($self, $g) = @_;
    return 1 if $self->iscff();
    return $self->fontfile->subvec($g);
}

sub glyphNum { return $_[0]->fontfile->glyphNum() }

sub outobjdeep {
    my ($self, $fh, $pdf) = @_;

    my $notdefbefore = 1;

    my $wx = PDFArray();
    $self->{' de'}->{'W'} = $wx;
    my $ml;

    foreach my $w (0 .. (scalar @{$self->data->{'g2u'}} - 1)) {
        if ($self->subvec($w) and $notdefbefore) {
            $notdefbefore = 0;
            $ml = PDFArray();
            $wx->add_elements(PDFNum($w), $ml);
            $ml->add_elements(PDFNum($self->wxByCId($w)));
        }
        elsif ($self->subvec($w) and not $notdefbefore) {
            $ml->add_elements(PDFNum($self->wxByCId($w)));
        }
        else {
            $notdefbefore = 1;
        }
    }

    $self->SUPER::outobjdeep($fh, $pdf);
}

=back

=cut

1;
