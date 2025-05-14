package PDF::API2::Annotation;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp;
use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::Annotation - Add annotations to a PDF

=head1 SYNOPSIS

    my $pdf = PDF::API2->new();
    my $font = $pdf->font('Helvetica');
    my $page1 = $pdf->page();
    my $page2 = $pdf->page();

    my $content = $page1->text();
    my $message = 'Go to Page 2';
    my $size = 18;
    $content->distance(1 * 72, 9 * 72);
    $content->font($font, $size);
    $content->text($message);

    my $annotation = $page1->annotation();
    my $width = $content->text_width($message);
    $annotation->rect(1 * 72, 9 * 72, 1 * 72 + $width, 9 * 72 + $size);
    $annotation->link($page2);

    $pdf->save('sample.pdf');

=head1 METHODS

=cut

sub new {
    my $class = shift();
    my $self = $class->SUPER::new();
    $self->{'Type'}   = PDFName('Annot');
    $self->{'Border'} = PDFArray(PDFNum(0), PDFNum(0), PDFNum(0));
    return $self;
}

=head2 Annotation Types

=head3 link

    $annotation = $annotation->link($destination, $location, @args);

Link the annotation to another page in this PDF.  C<$location> and C<@args> are
optional and set which part of the page should be displayed, as defined in
L<PDF::API2::NamedDestination/"destination">.

C<$destination> can be either a L<PDF::API2::Page> object or the name of a named
destination defined elsewhere.

=cut

sub link {
    my $self = shift();
    my $destination = shift();

    my $location;
    my @args;

    # Deprecated options
    my %options;
    if ($_[0] and $_[0] =~ /^-/) {
        %options = @_;
    }
    else {
        $location = shift();
        @args = @_;
    }

    $self->{'Subtype'} = PDFName('Link');
    unless (ref($destination)) {
        $self->{'Dest'} = PDFStr($destination);
        return $self;
    }

    $self->{'A'} = PDFDict();
    $self->{'A'}->{'S'} = PDFName('GoTo');

    unless (%options) {
        $self->{'A'}->{'D'} = _destination($destination, $location, @args);
    }
    else {
        # Deprecated
        $self->dest($destination, %options);
        $self->rect(@{$options{'-rect'}})     if defined $options{'-rect'};
        $self->border(@{$options{'-border'}}) if defined $options{'-border'};
    }

    return $self;
}

sub _destination {
    require PDF::API2::NamedDestination;
    return PDF::API2::NamedDestination::_destination(@_);
}

=head3 url

    $annotation = $annotation->uri($uri);

Launch C<$uri> -- typically a web page -- when the annotation is selected.

=cut

# Deprecated (renamed)
sub url { return uri(@_) }

sub uri {
    my ($self, $uri, %options) = @_;

    $self->{'Subtype'}  = PDFName('Link');
    $self->{'A'}        = PDFDict();
    $self->{'A'}->{'S'} = PDFName('URI');
    $self->{'A'}->{'URI'} = PDFStr($uri);

    # Deprecated
    $self->rect(@{$options{'-rect'}})     if defined $options{'-rect'};
    $self->border(@{$options{'-border'}}) if defined $options{'-border'};

    return $self;
}

=head3 file

    $annotation = $annotation->launch($file);

Open C<$file> when the annotation is selected.

=cut

sub file { return launch(@_) }

sub launch {
    my ($self, $file, %options) = @_;
    $self->{'Subtype'}  = PDFName('Link');
    $self->{'A'}        = PDFDict();
    $self->{'A'}->{'S'} = PDFName('Launch');
    $self->{'A'}->{'F'} = PDFStr($file);

    # Deprecated
    $self->rect(@{$options{'-rect'}})     if defined $options{'-rect'};
    $self->border(@{$options{'-border'}}) if defined $options{'-border'};

    return $self;
}

=head3 pdf

    $annotation = $annotation->pdf($file, $page_number, $location, @args);

Open the PDF file located at C<$file> to the specified page number.
C<$location> and C<@args> are optional and set which part of the page should be
displayed, as defined in L<PDF::API2::NamedDestination/"destination">.

=cut

# Deprecated
sub pdfile   { return pdf_file(@_) }
sub pdf_file { return pdf(@_) }

sub pdf {
    my $self = shift();
    my $file = shift();
    my $page_number = shift();
    my $location;
    my @args;

    # Deprecated options
    my %options;
    if ($_[0] and $_[0] =~ /^-/) {
        %options = @_;
    }
    else {
        $location = shift();
        @args = @_;
    }

    $self->{'Subtype'}  = PDFName('Link');
    $self->{'A'}        = PDFDict();
    $self->{'A'}->{'S'} = PDFName('GoToR');
    $self->{'A'}->{'F'} = PDFStr($file);

    unless (%options) {
        my $destination = PDFNum($page_number);
        $self->{'A'}->{'D'} = _destination($destination, $location, @args);
    }
    else {
        # Deprecated
        $self->dest(PDFNum($page_number), %options);
        $self->rect(@{$options{'-rect'}})     if defined $options{'-rect'};
        $self->border(@{$options{'-border'}}) if defined $options{'-border'};
    }

    return $self;
}

=head3 text

    $annotation = $annotation->text($text);

Define the annotation as a text note with the specified content.

=cut

sub text {
    my ($self, $text, %options) = @_;
    $self->{'Subtype'} = PDFName('Text');
    $self->content($text);

    # Deprecated
    $self->rect(@{$options{'-rect'}}) if defined $options{'-rect'};
    $self->open($options{'-open'})    if defined $options{'-open'};

    return $self;
}

=head3 movie

    $annotation = $annotation->movie($filename, $content_type);

Embed and link to the movie located at $filename with the specified MIME type.

=cut

sub movie {
    my ($self, $file, $content_type, %options) = @_;
    $self->{'Subtype'}      = PDFName('Movie');
    $self->{'A'}            = PDFBool(1);
    $self->{'Movie'}        = PDFDict();
    $self->{'Movie'}->{'F'} = PDFDict();

    $self->{' apipdf'}->new_obj($self->{'Movie'}->{'F'});
    my $f = $self->{'Movie'}->{'F'};
    $f->{'Type'}          = PDFName('EmbeddedFile');
    $f->{'Subtype'}       = PDFName($content_type);
    $f->{' streamfile'} = $file;

    # Deprecated
    $self->rect(@{$options{'-rect'}}) if defined $options{'-rect'};

    return $self;
}

=head2 Common Annotation Attributes

=head3 rect

    $annotation = $annotation->rect($llx, $lly, $urx, $ury);

Define the rectangle around the annotation.

=cut

sub rect {
    my ($self, @coordinates) = @_;
    unless (scalar @coordinates == 4) {
        die "Incorrect number of parameters (expected four) for rectangle";
    }
    $self->{'Rect'} = PDFArray(map { PDFNum($_) } @coordinates);
    return $self;
}

=head3 border

    $annotation = $annotation->border($h_radius, $v_radius, $width);

Define the border style.  Defaults to 0, 0, 0 (no border).

=cut

sub border {
    my ($self, @attributes) = @_;
    unless (scalar @attributes == 3) {
        croak "Incorrect number of parameters (expected three) for border";
    }
    $self->{'Border'} = PDFArray(map { PDFNum($_) } @attributes);
    return $self;
}

=head3 content

    $annotation = $annotation->content(@lines);

Define the text content of the annotation, if applicable.

=cut

sub content {
    my ($self, @lines) = @_;
    my $text = join("\n", @lines);
    $self->{'Contents'} = PDFStr($text);
    return $self;
}

sub name {
    my ($self, $name) = @_;
    $self->{'Name'} = PDFName($name);
    return $self;
}

=head3 open

    $annotation = $annotation->open($boolean);

Set the annotation to initially be either open or closed.  Only relevant for
text annotations.

=cut

sub open {
    my ($self, $value) = @_;
    $self->{'Open'} = PDFBool($value ? 1 : 0);
    return $self;
}

sub dest {
    my ($self, $page, %options) = @_;

    unless (ref($page)) {
        $self->{'Dest'} = PDFStr($page);
        return $self;
    }

    $self->{'A'} //= PDFDict();
    $options{'-xyz'} = [undef, undef, undef] unless keys %options;

    if (defined $options{'-fit'}) {
        $self->{'A'}->{'D'} = _destination($page, 'fit');
    }
    elsif (defined $options{'-fith'}) {
        $self->{'A'}->{'D'} = _destination($page, 'fith', $options{'-fith'});
    }
    elsif (defined $options{'-fitb'}) {
        $self->{'A'}->{'D'} = _destination($page, 'fitb');
    }
    elsif (defined $options{'-fitbh'}) {
        $self->{'A'}->{'D'} = _destination($page, 'fitbh', $options{'-fitbh'});
    }
    elsif (defined $options{'-fitv'}) {
        $self->{'A'}->{'D'} = _destination($page, 'fitv', $options{'-fitv'});
    }
    elsif (defined $options{'-fitbv'}) {
        $self->{'A'}->{'D'} = _destination($page, 'fitbv', $options{'-fitbv'});
    }
    elsif (defined $options{'-fitr'}) {
        $self->{'A'}->{'D'} = _destination($page, 'fitr', @{$options{'-fitr'}});
    }
    elsif (defined $options{'-xyz'}) {
        $self->{'A'}->{'D'} = _destination($page, 'xyz', @{$options{'-xyz'}});
    }

    return $self;
}

1;
