package PDF::API2::Page;

use base 'PDF::API2::Basic::PDF::Pages';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp;
use POSIX qw(floor);
use Scalar::Util qw(looks_like_number weaken);

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Content;
use PDF::API2::Content::Text;
use PDF::API2::Util;

my $page_sizes = {
    # Metric A
    '4a0'     => [ 4760, 6716 ],
    '2a0'     => [ 3368, 4760 ],
    'a0'      => [ 2380, 3368 ],
    'a1'      => [ 1684, 2380 ],
    'a2'      => [ 1190, 1684 ],
    'a3'      => [  842, 1190 ],
    'a4'      => [  595,  842 ],
    'a5'      => [  421,  595 ],
    'a6'      => [  297,  421 ],

    # Metric B
    '4b0'     => [ 5656, 8000 ],
    '2b0'     => [ 4000, 5656 ],
    'b0'      => [ 2828, 4000 ],
    'b1'      => [ 2000, 2828 ],
    'b2'      => [ 1414, 2000 ],
    'b3'      => [ 1000, 1414 ],
    'b4'      => [  707, 1000 ],
    'b5'      => [  500,  707 ],
    'b6'      => [  353,  500 ],

    # US
    'letter'  => [  612,  792 ],
    'legal'   => [  612, 1008 ],
    'ledger'  => [ 1224,  792 ],
    'tabloid' => [  792, 1224 ],
};

=head1 NAME

PDF::API2::Page - Methods to interact with individual pages

=head1 SYNOPSIS

    my $pdf = PDF::API2->new();

    # Add a page to a new or existing PDF
    my $page = $pdf->page();

    # Set the page size
    $page->size('letter');

    # Set prepress page boundaries
    $page->boundaries(media => '12x18', trim => 0.5 * 72);

    # Add an image
    my $image = $pdf->image('/path/to/file.jpg');
    $page->object($image, $x, $y, $w, $h);

    # Add textual content
    my $text = $page->text();

    # Add graphical content (paths and shapes)
    my $canvas = $page->graphics();

=cut

sub new {
    my ($class, $pdf, $parent, $index) = @_;
    my $self = {};

    $class = ref($class) if ref($class);
    $self = $class->SUPER::new($pdf, $parent);
    $self->{'Type'} = PDFName('Page');
    $self->proc_set(qw( PDF Text ImageB ImageC ImageI ));
    delete $self->{'Count'};
    delete $self->{'Kids'};
    $parent->add_page($self, $index);
    return $self;
}

sub coerce {
    my ($class, $pdf, $page) = @_;
    my $self = $page;
    bless $self, $class;
    $self->{' apipdf'} = $pdf;
    weaken $self->{' apipdf'};
    return $self;
}

# Deprecated.  Marking the page as dirty should only be needed in rare cases
# when the page hash is being edited directly rather than through the API.  In
# that case, the out_obj call can be made manually.  There's no reason (that I
# can think of) to have a specific call just (and only) for Page objects.
sub update {
    my $self = shift();
    $self->{' apipdf'}->out_obj($self);
    return $self;
}

=head1 METHODS

=head2 size

    # Set the page size using a common name
    $page->size('letter');

    # Set the page size using coordinates in points (X1, Y1, X2, Y2)
    $page->size([0, 0, 612, 792]);

    # Get the page coordinates in points
    my @rectangle = $page->size();

Set the physical page size (a.k.a. media box) when called with an argument.
See L</"Page Sizes"> below for possible values.  Returns the C<$page> object.

Returns the coordinates of the rectangle enclosing the physical page size when
called without arguments.

The size method is a convenient shortcut for setting the PDF's media box when
print-related page boundaries aren't required.  It's equivalent to the
following:

    # Set
    $page = $page->boundaries(media => $size);

    # Get
    @rectangle = $page->boundaries->{'media'}->@*;

=cut

sub size {
    my $self = shift();

    # Set
    if (@_) {
        return $self->boundaries(media => @_);
    }

    # Get
    my %boundaries = $self->boundaries();
    return @{$boundaries{'media'}};
}

=head2 boundaries

    # Set
    $page->boundaries(
        media => '13x19',
        bleed => [0.75 * 72, 0.75 * 72, 12.25 * 72, 18.25 * 72],
        trim  => 0.25 * 72,
    );

    # Get
    %boundaries = $page->boundaries();
    ($x1, $y1, $x2, $y2) = $page->boundaries('trim');

Set or replace all prepress page boundaries when called with a hash containing
one or more page boundary definitions.  Returns the C<$page> object.

Returns the current page boundaries if called without arguments.  Returns the
coordinates for the specified page boundary if called with one argument.

=head3 Page Boundaries

PDF defines five page boundaries.  When creating PDFs for print shops, you'll
most commonly use just the media box and trim box.  Traditional print shops may
also use the bleed box when adding printer's marks and other information.

=over

=item * media

The media box defines the boundaries of the physical medium on which the page is
to be printed.  It may include any extended area surrounding the finished page
for bleed, printing marks, or other such purposes.  The default value is a US
letter page (8.5" x 11").

=item * crop

The crop box defines the region to which the contents of the page shall be
clipped (cropped) when displayed or printed.  The default value is the page's
media box.

This is a historical page boundary.  You'll likely want to set the bleed and/or
trim boxes instead.

=item * bleed

The bleed box defines the region to which the contents of the page shall be
clipped when output in a production environment.  This may include any extra
bleed area needed to accommodate the physical limitations of cutting, folding,
and trimming equipment.  The actual printed page (media box) may include
printing marks that fall outside the bleed box.  The default value is the page's
crop box.

=item * trim

The trim box defines the intended dimensions of the finished page after
trimming.  It may be smaller than the media box to allow for production-related
content, such as printing instructions, cut marks, or color bars.  The default
value is the page's crop box.

=item * art

The art box defines the extent of the page's meaningful content (including
potential white space) as intended by the page's creator.  The default value is
the page's crop box.

=back

=head3 Page Sizes

PDF page sizes are stored as rectangle coordinates.  For convenience, PDF::API2
also supports a number of aliases and shortcuts that are more human-friendly.

The following formats are available:

=over

=item * a standard paper size

    $page->boundaries(media => 'A4');

Aliases for the most common paper sizes are built in (case-insensitive).

US: Letter, Legal, Ledger, Tabloid

Metric: 4A0, 2A0, A0 - A6, 4B0, 2B0, and B0 - B6

=item * a "WxH" string in inches

    $page->boundaries(media => '8.5x11');

Many US paper sizes are commonly identified by their size in inches rather than
by a particular name.  These can be passed as strings with the width and height
separated by an C<x>.

Examples: C<4x6>, C<12x18>, C<8.5x11>

=item * a number (in points) representing a reduction from the next-larger box

    # Note: There are 72 points per inch
    $page->boundaries(media => '12x18', trim => 0.5 * 72);

    # Equivalent
    $page->boundaries(media => [0,        0,        12   * 72, 18   * 72],
                      trim  => [0.5 * 72, 0.5 * 72, 11.5 * 72, 17.5 * 72]);

This example shows a 12" x 18" physical sheet that will be reduced to a final
size of 11" x 17" by trimming 0.5" from each edge.  The smaller boundary is
assumed to be centered on the larger one.

The "next-larger box" follows this order, stopping at the first defined value:

    art -> trim -> bleed -> media

    crop -> media

This option isn't available for the media box since it is by definition the
largest boundary.

=item * [$width, $height] in points

    $page->boundaries(media => [8.5 * 72, 11 * 7.2]);

For other page or boundary sizes, the width and height (in points) can be given
directly as an array.

=item * [$x1, $y1, $x2, $y2] in points

    $page->boundaries(media => [0, 0, 8.5 * 72, 11 * 72]);

Finally, the raw coordinates of the bottom-left and top-right corners of a
rectangle can be specified.

=back

=cut

sub _to_rectangle {
    my $value = shift();

    # An array of two or four numbers in points
    if (ref($value) eq 'ARRAY') {
        if (@$value == 2) {
            return (0, 0, @$value);
        }
        elsif (@$value == 4) {
            return @$value;
        }
        croak "Page boundary array must contain two or four numbers";
    }

    # WxH in inches
    if ($value =~ /^([0-9.]+)\s*x\s*([0-9.]+)$/) {
        my ($w, $h) = ($1, $2);
        if (looks_like_number($w) and looks_like_number($h)) {
            return (0, 0, $w * 72, $h * 72);
        }
    }

    # Common names for page sizes
    if ($page_sizes->{lc $value}) {
        return (0, 0, @{$page_sizes->{lc $value}});
    }

    if (ref($value)) {
        croak "Unrecognized page size";
    }
    else {
        croak "Unrecognized page size: $value";
    }
}

sub boundaries {
    my $self = shift();

    # Get
    unless (@_) {
        my %boundaries;
        foreach my $box (qw(Media Crop Bleed Trim Art)) {
            $boundaries{lc($box)} = [$self->_bounding_box($box . 'Box')];
        }
        return %boundaries;
    }
    elsif (@_ == 1) {
        my $box = shift();
        my @coordinates = $self->_bounding_box(ucfirst($box) . 'Box');
        return @coordinates;
    }

    # Set
    my %boxes = @_;
    foreach my $box (qw(media crop bleed trim art)) {
        next unless exists $boxes{$box};

        # Special case: A single number as the value for anything other than
        # MediaBox means to take the next larger size and reduce it by this
        # amount in points on all four sides, provided the larger size was also
        # included.
        my $value = $boxes{$box};
        my @rectangle;
        if ($box ne 'media' and not ref($value) and looks_like_number($value)) {
            my $parent = ($box eq 'crop'  ? 'media' :
                          $box eq 'bleed' ? 'media' :
                          $box eq 'trim'  ? 'bleed' : 'trim');
            $parent = 'bleed' if $parent eq 'trim'  and not $boxes{'trim'};
            $parent = 'media' if $parent eq 'bleed' and not $boxes{'bleed'};
            $parent = 'media' if $parent eq 'bleed' and not $boxes{'bleed'};
            unless ($boxes{$parent}) {
                croak "Single-number argument for $box requires $parent";
            }

            @rectangle = @{$boxes{$parent}};
            $rectangle[0] += $value;
            $rectangle[1] += $value;
            $rectangle[2] -= $value;
            $rectangle[3] -= $value;
        }
        else {
            @rectangle = _to_rectangle($value);
        }

        my $box_name = ucfirst($box) . 'Box';
        $self->_bounding_box($box_name, @rectangle);
        $boxes{$box} = [@rectangle];
    }

    return $self;
}

sub _bounding_box {
    my $self = shift();
    my $type = shift();

    # Get
    unless (scalar @_) {
        my $box = $self->find_prop($type);
        unless ($box) {
            # Default to letter (for historical PDF::API2 reasons, not per the
            # PDF specification)
            return (0, 0, 612, 792) if $type eq 'MediaBox';

            # Use defaults per PDF 1.7 section 14.11.2 Page Boundaries
            return $self->_bounding_box('MediaBox') if $type eq 'CropBox';
            return $self->_bounding_box('CropBox');
        }
        return map { $_->val() } $box->elements();
    }

    # Set
    $self->{$type} = PDFArray(map { PDFNum(float($_)) } page_size(@_));
    return $self;
}

# Deprecated; use size(...) or boundaries('media', ...)
sub mediabox {
    my $self = shift();
    return $self->_bounding_box('MediaBox') unless @_;
    return $self->_bounding_box('MediaBox', page_size(@_));
}

# Deprecated
sub get_mediabox {
    my $self = shift();
    return $self->_bounding_box('MediaBox');
}

# Deprecated; use boundaries('crop', ...)
sub cropbox {
    my $self = shift();
    return $self->_bounding_box('CropBox') unless @_;
    return $self->_bounding_box('CropBox', page_size(@_));
}

# Deprecated
sub get_cropbox {
    my $self = shift();
    return $self->_bounding_box('CropBox');
}

# Deprecated; use boundaries('bleed', ...)
sub bleedbox {
    my $self = shift();
    return $self->_bounding_box('BleedBox') unless @_;
    return $self->_bounding_box('BleedBox', page_size(@_));
}

# Deprecated
sub get_bleedbox {
    my $self = shift();
    return $self->_bounding_box('BleedBox');
}

# Deprecated; use boundaries('trim', ...)
sub trimbox {
    my $self = shift();
    return $self->_bounding_box('TrimBox') unless @_;
    return $self->_bounding_box('TrimBox', page_size(@_));
}

# Deprecated
sub get_trimbox {
    my $self = shift();
    return $self->_bounding_box('TrimBox');
}

# Deprecated; use boundaries('art', ...)
sub artbox {
    my $self = shift();
    return $self->_bounding_box('ArtBox') unless @_;
    return $self->_bounding_box('ArtBox', page_size(@_));
}

# Deprecated
sub get_artbox {
    my $self = shift();
    return $self->_bounding_box('ArtBox');
}

=head2 rotation

    $page = $page->rotation($degrees);

Rotates the page clockwise when displayed or printed.  C<$degrees> must be a
multiple of 90 and may be negative for counter-clockwise rotation.

The coordinate system follows the page rotation.  In other words, after rotating
the page 180 degrees, [0, 0] will be in the top right corner of the page rather
than the bottom left, X will increase to the right, and Y will increase
downward.

To create a landscape page without moving the origin, use L</"size">.

=cut

# Deprecated (renamed to follow the pattern of using nouns instead of verbs)
sub rotate { return rotation(@_) }

sub rotation {
    my ($self, $degrees) = @_;
    $degrees //= 0;

    # Ignore rotation of 360 or more (in either direction)
    $degrees = $degrees % 360;

    unless (   $degrees ==   0
            or $degrees ==  90 or $degrees ==  -90
            or $degrees == 180 or $degrees == -180
            or $degrees == 270 or $degrees == -270) {
        croak "Rotation must be a multiple of 90 degrees";
    }

    $self->{'Rotate'} = PDFNum($degrees);

    return $self;
}

=head2 graphics

    my $canvas = $page->graphics(%options);

Returns a L<PDF::API2::Content> object for drawing paths and shapes.

The following options are available:

=over

=item * prepend (boolean)

If true, place the drawing at the beginning of the page's content stream instead
of the end.

=item * compress (boolean)

Manually specify whether the drawing instructions should be compressed.  If
unspecified, the PDF's compression setting will be used, which is on by default.

=back

=cut

sub fixcontents {
    my $self = shift();
    $self->{'Contents'} = $self->{'Contents'} || PDFArray();
    if (ref($self->{'Contents'}) =~ /Objind$/) {
        $self->{'Contents'}->realise();
    }
    if (ref($self->{'Contents'}) !~ /Array$/) {
        $self->{'Contents'} = PDFArray($self->{'Contents'});
    }
    return;
}

sub content {
    my ($self, $obj, $dir) = @_;
    if (defined($dir) and $dir > 0) {
        $self->precontent($obj);
    }
    else {
        $self->addcontent($obj);
    }
    $self->{' apipdf'}->new_obj($obj) unless $obj->is_obj($self->{' apipdf'});
    $obj->{' apipdf'} = $self->{' apipdf'};
    $obj->{' api'} = $self->{' api'};
    $obj->{' apipage'} = $self;

    weaken $obj->{' apipdf'};
    weaken $obj->{' api'};
    weaken $obj->{' apipage'};

    return $obj;
}

sub addcontent {
    my ($self, @objs) = @_;
    $self->fixcontents();
    $self->{'Contents'}->add_elements(@objs);
    return;
}

sub precontent {
    my ($self, @objs) = @_;
    $self->fixcontents();
    unshift @{$self->{'Contents'}->val()}, @objs;
    return;
}

# Deprecated; replace with graphics, which adds input validation
sub gfx {
    my ($self, $prepend) = @_;
    my $graphics = $self->graphics(prepend => $prepend);

    # Delete the input validation flag
    delete $graphics->{' graphics'};

    return $graphics;
}

sub graphics {
    my ($self, %options) = @_;
    my $graphics = PDF::API2::Content->new();
    $graphics->{' graphics'} = 1;

    $options{'compress'} //= $self->{' api'}->{'forcecompress'};
    $graphics->compressFlate() if $options{'compress'};

    if ($options{'prepend'}) {
        return $self->content($graphics, 1);
    }
    else {
        return $self->content($graphics);
    }
}

=head2 text

    my $text = $page->text(%options);

Returns a L<PDF::API2::Content> object for including textual content.

The options are the same as the L</"graphics"> method.

=cut

sub text {
    my $self = shift();

    my %options;
    if (@_ == 1) {
        # Deprecated
        $options{'prepend'} = shift();
    }
    else {
        %options = @_;
    }

    my $text = PDF::API2::Content::Text->new();

    $options{'compress'} //= $self->{' api'}->{'forcecompress'};
    $text->compressFlate() if $options{'compress'};

    if ($options{'prepend'}) {
        $self->content($text, 1);
    }
    else {
        $self->content($text);
    }

    return $text;
}

=head2 object

    $page = $page->object($object, $x, $y, $scale_x, $scale_y);

Places an image or other external object (a.k.a. XObject) on the page in the
specified location.

If C<$x> and C<$y> are omitted, the object will be placed at C<[0, 0]>.

For images, C<$scale_x> and C<$scale_y> represent the width and height of the
image on the page in points.  If C<$scale_x> is omitted, it will default to 72
pixels per inch.  If C<$scale_y> is omitted, the image will be scaled
proportionally based on the image dimensions.

For other external objects, the scale is a multiplier, where 1 (the default)
represents 100% (i.e. no change).

If the object to be placed depends on a coordinate transformation (e.g. rotation
or skew), first create a content object using L</"graphics">, then call
L<PDF::API2::Content/"object"> after making the appropriate transformations.

=cut

sub object {
    my $self = shift();
    $self->graphics->object(@_);
    return $self;
}

=head2 annotation

    my $annotation = $page->annotation();

Returns a new L<PDF::API2::Annotation> object.

=cut

sub annotation {
    my $self = shift();

    unless (exists $self->{'Annots'}) {
        $self->{'Annots'} = PDFArray();
        $self->{' apipdf'}->out_obj($self);
    }
    elsif (ref($self->{'Annots'}) =~ /Objind/) {
        $self->{'Annots'}->realise();
    }

    require PDF::API2::Annotation;
    my $ant = PDF::API2::Annotation->new();
    $self->{'Annots'}->add_elements($ant);
    $self->{' apipdf'}->new_obj($ant);
    $ant->{' apipdf'} = $self->{' apipdf'};
    $ant->{' apipage'} = $self;
    weaken $ant->{' apipdf'};
    weaken $ant->{' apipage'};

    if ($self->{'Annots'}->is_obj($self->{' apipdf'})) {
        $self->{' apipdf'}->out_obj($self->{'Annots'});
    }

    return $ant;
}

sub resource {
    my ($self, $type, $key, $obj, $force) = @_;
    my $dict = $self->find_prop('Resources');

    $dict = $dict || $self->{'Resources'} || PDFDict();

    $dict->realise() if ref($dict) =~ /Objind$/;

    $dict->{$type} = $dict->{$type} || PDFDict();
    $dict->{$type}->realise if ref($dict->{$type}) =~ /Objind$/;

    unless (defined $obj) {
        return $dict->{$type}->{$key} || undef;
    }
    else {
        if ($force) {
            $dict->{$type}->{$key} = $obj;
        }
        else {
            $dict->{$type}->{$key} = $dict->{$type}->{$key} || $obj;
        }

        $self->{' apipdf'}->out_obj($dict)          if $dict->is_obj($self->{' apipdf'});
        $self->{' apipdf'}->out_obj($dict->{$type}) if $dict->{$type}->is_obj($self->{' apipdf'});
        $self->{' apipdf'}->out_obj($obj)           if $obj->is_obj($self->{' apipdf'});
        $self->{' apipdf'}->out_obj($self);

        return $dict;
    }
}

sub ship_out {
    my ($self, $pdf) = @_;

    $pdf->ship_out($self);
    if (defined $self->{'Contents'}) {
        $pdf->ship_out($self->{'Contents'}->elements());
    }
    return $self;
}

=head1 MIGRATION

See L<PDF::API2/"MIGRATION"> for an overview.

=over

=item gfx

Replace with L</"graphics">.

=item rotate

Replace with L</"rotation">.

=item mediabox

=item get_mediabox

Replace with L</"size"> if not in a print shop environment or L</"boundaries">
if more complex page boundaries are needed.

If using page size aliases (e.g. "letter" or "A4"), check the Page Sizes section
to ensure that the alias you're using is still supported (you'll get an error if
it isn't).

=item cropbox

=item bleedbox

=item trimbox

=item artbox

=item get_cropbox

=item get_bleedbox

=item get_trimbox

=item get_artbox

Replace with L</"boundaries">.

=back

=cut

1;
