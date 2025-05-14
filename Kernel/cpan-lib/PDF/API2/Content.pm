package PDF::API2::Content;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp;
use Compress::Zlib ();
use Encode;
use Math::Trig;
use PDF::API2::Matrix;

use PDF::API2::Basic::PDF::Utils;
use PDF::API2::Util;

=head1 NAME

PDF::API2::Content - Methods for adding graphics and text to a PDF

=head1 SYNOPSIS

    # Start with a PDF page (new or opened)
    my $pdf = PDF::API2->new();
    my $page = $pdf->page();

    # Add a new content object
    my $content = $page->graphics();
    my $content = $page->text();

    # Then call the methods below to add graphics and text to the page.

=cut

sub new {
    my $class = shift();
    my $self = $class->SUPER::new();

    $self->{' stream'} = '';
    $self->{' poststream'} = '';
    $self->{' font'} = undef;
    $self->{' fontset'} = 0;
    $self->{' fontsize'} = 0;
    $self->{' charspace'} = 0;
    $self->{' hscale'} = 100;
    $self->{' wordspace'} = 0;
    $self->{' leading'} = 0;
    $self->{' rise'} = 0;
    $self->{' render'} = 0;
    $self->{' matrix'} = [1, 0, 0, 1, 0, 0];
    $self->{' textmatrix'} = [1, 0, 0, 1, 0, 0];
    $self->{' textlinematrix'} = [0, 0];
    $self->{' textlinestart'} = 0;
    $self->{' fillcolor'} = [0];
    $self->{' strokecolor'} = [0];
    $self->{' translate'} = [0, 0];
    $self->{' scale'} = [1, 1];
    $self->{' skew'} = [0, 0];
    $self->{' rotate'} = 0;
    $self->{' apiistext'} = 0;

    return $self;
}

sub outobjdeep {
    my $self = shift();
    $self->textend();
    if ($self->{'-docompress'} and $self->{'Filter'}) {
        $self->{' stream'} = Compress::Zlib::compress($self->{' stream'});
        $self->{' nofilt'} = 1;
        delete $self->{'-docompress'};
    }
    return $self->SUPER::outobjdeep(@_);
}

=head1 COORDINATE TRANSFORMATIONS

The methods in this section change the coordinate system for the current content
object relative to the rest of the document.

Changes to the coordinate system only affect subsequent paths or text.

A call to any of the methods in this section resets the coordinate system before
applying its changes, unless the C<relative> option is set.

=head2 translate

    $content = $content->translate($x, $y);

Moves the origin along the x and y axes.

=cut

sub _translate {
    my ($x, $y) = @_;
    return (1, 0, 0, 1, $x, $y);
}

sub translate {
    my ($self, $x, $y) = @_;
    $self->transform(translate => [$x, $y]);
}

=head2 rotate

    $content = $content->rotate($degrees);

Rotates the coordinate system counter-clockwise.

Use a negative argument to rotate clockwise.

=cut

sub _rotate {
    my $a = deg2rad(shift());
    return (cos($a), sin($a), -sin($a), cos($a), 0, 0);
}

sub rotate {
    my ($self, $a) = @_;
    $self->transform(rotate => $a);
}

=head2 scale

    $content = $content->scale($x, $y);

Scales (stretches) the coordinate systems along the x and y axes.  A value of 1
for either C<$x> or C<$y> represents 100% scale (i.e. no change).

=cut

sub _scale {
    my ($x, $y) = @_;
    return ($x, 0, 0, $y, 0, 0);
}

sub scale {
    my ($self, $sx, $sy) = @_;
    $self->transform(scale => [$sx, $sy]);
}

=head2 skew

    $content = $content->skew($a, $b);

Skews the coordinate system by C<$a> degrees (counter-clockwise) from the x axis
and C<$b> degrees (clockwise) from the y axis.

=cut

sub _skew {
    my $a = deg2rad(shift());
    my $b = deg2rad(shift());
    return (1, tan($a), tan($b), 1, 0, 0);
}

sub skew {
    my ($self, $a, $b) = @_;
    $self->transform(skew => [$a, $b]);
}

=head2 transform

    $content = $content->transform(
        translate => [$x, $y],
        rotate    => $degrees,
        scale     => [$x, $y],
        skew      => [$a, $b],
        repeat    => $boolean,
    );

Performs multiple coordinate transformations, in the order recommended by the
PDF specification (translate, rotate, scale, then skew).  Omitted options will
be unchanged.

If C<repeat> is true and if this is not the first call to a transformation
method, the previous transformation will be performed again, modified by any
other provided arguments.

=cut

sub _to_matrix {
    my @array = @_;
    return PDF::API2::Matrix->new([$array[0], $array[1], 0],
                                  [$array[2], $array[3], 0],
                                  [$array[4], $array[5], 1]);
}

sub _transform {
    my %opts = @_;
    my $m = PDF::API2::Matrix->new([1, 0, 0], [0, 1, 0], [0, 0, 1]);

    # Undocumented; only used by textpos()
    if (defined $opts{'-matrix'}) {
        $m = $m->multiply(_to_matrix(@{$opts{'-matrix'}}));
    }

    # Note that the transformations are applied in reverse order.  See PDF 1.7
    # specification section 8.3.4: Transformation Matrices.
    if (defined $opts{'skew'}) {
        $m = $m->multiply(_to_matrix(_skew(@{$opts{'skew'}})));
    }
    if (defined $opts{'scale'}) {
        $m = $m->multiply(_to_matrix(_scale(@{$opts{'scale'}})));
    }
    if (defined $opts{'rotate'}) {
        $m = $m->multiply(_to_matrix(_rotate($opts{'rotate'})));
    }
    if (defined $opts{'translate'}) {
        $m = $m->multiply(_to_matrix(_translate(@{$opts{'translate'}})));
    }

    # Undocumented; only used by textpos()
    if ($opts{'-point'}) {
        my $mp = PDF::API2::Matrix->new([$opts{'-point'}->[0],
                                         $opts{'-point'}->[1], 1]);
        $mp = $mp->multiply($m);
        return ($mp->[0][0], $mp->[0][1]);
    }

    return (
        $m->[0][0], $m->[0][1],
        $m->[1][0], $m->[1][1],
        $m->[2][0], $m->[2][1]
    );
}

# Transformations are described in the PDF 1.7 specification, section 8.3.3:
# Common Transformations.
sub transform {
    my ($self, %options) = @_;
    return $self->transform_rel(%options) if $options{'repeat'};

    # Deprecated (renamed to 'repeat' to avoid confusion)
    return $self->transform_rel(%options) if $options{'relative'};

    # Deprecated options (remove hyphens)
    foreach my $option (qw(translate rotate scale skew)) {
        if (exists $options{'-' . $option}) {
            $options{$option} //= delete $options{'-' . $option};
        }
    }

    # Apply the transformations
    $self->matrix(_transform(%options));

    # Store the transformations for lookup or future relative transformations
    $self->{' translate'} = $options{'translate'} // [0, 0];
    $self->{' rotate'}    = $options{'rotate'}    // 0;
    $self->{' scale'}     = $options{'scale'}     // [1, 1];
    $self->{' skew'}      = $options{'skew'}      // [0, 0];

    return $self;
}

sub transform_rel {
    my ($self, %options) = @_;

    # Deprecated options (remove hyphens)
    foreach my $option (qw(translate rotate scale skew)) {
        if (exists $options{'-' . $option}) {
            $options{$option} //= delete $options{'-' . $option};
        }
    }

    my ($sa1, $sb1) = @{$options{'skew'} ? $options{'skew'} : [0, 0]};
    my ($sa0, $sb0) = @{$self->{' skew'}};

    my ($sx1, $sy1) = @{$options{'scale'} ? $options{'scale'} : [1, 1]};
    my ($sx0, $sy0) = @{$self->{' scale'}};

    my $r1 = $options{'rotate'} // 0;
    my $r0 = $self->{' rotate'};

    my ($tx1, $ty1) = @{$options{'translate'} ? $options{'translate'} : [0, 0]};
    my ($tx0, $ty0) = @{$self->{' translate'}};

    $self->transform(
        skew      => [$sa0 + $sa1, $sb0 + $sb1],
        scale     => [$sx0 * $sx1, $sy0 * $sy1],
        rotate    => $r0 + $r1,
        translate => [$tx0 + $tx1, $ty0 + $ty1],
    );

    return $self;
}

=head2 matrix

    $graphics = $graphics->matrix($a, $b, $c, $d, $e, $f);

    ($a, $b, $c, $d, $e, $f) = $text->matrix($a, $b, $c, $d, $e, $f);

Sets the current transformation matrix manually.  Unless you have a particular
need to enter transformations manually, you should use the C<transform> method
instead.

The return value differs based on whether the caller is a graphics content
object or a text content object.

=cut

sub _matrix_text {
    my ($a, $b, $c, $d, $e, $f) = @_;
    return (floats($a, $b, $c, $d, $e, $f), 'Tm');
}

sub _matrix_gfx {
    my ($a, $b, $c, $d, $e, $f) = @_;
    return (floats($a, $b, $c, $d, $e, $f), 'cm');
}

sub matrix {
    my $self = shift();
    if (scalar(@_)) {
        my ($a, $b, $c, $d, $e, $f) = @_;
        if ($self->_in_text_object()) {
            $self->add(_matrix_text($a, $b, $c, $d, $e, $f));
            $self->{' textmatrix'} = [$a, $b, $c, $d, $e, $f];
            $self->{' textlinematrix'} = [0, 0];
        }
        else {
            $self->add(_matrix_gfx($a, $b, $c, $d, $e, $f));
        }
    }

    if ($self->_in_text_object()) {
        return @{$self->{' textmatrix'}};
    }
    else {
        return $self;
    }
}

sub matrix_update {
    my ($self, $tx, $ty) = @_;
    $self->{' textlinematrix'}->[0] += $tx;
    $self->{' textlinematrix'}->[1] += $ty;
    return $self;
}

=head1 GRAPHICS STATE

=head2 save

    $content = $content->save();

Saves the current graphics state on a stack.

=cut

sub _save {
    return 'q';
}

sub save {
    my $self = shift;
    if ($self->_in_text_object()) {
        carp 'Calling save from a text content object has no effect';
        return;
    }

    $self->add(_save());

    return $self;
}

=head2 restore

    $content = $content->restore();

Restores the most recently saved graphics state, removing it from the stack.

=cut

sub _restore {
    return 'Q';
}

sub restore {
    my $self = shift;
    if ($self->_in_text_object()) {
        carp 'Calling save from a text content object has no effect';
        return;
    }

    $self->add(_restore());

    return $self;
}

=head2 line_width

    $content = $content->line_width($points);

Sets the width of the stroke in points.

=cut

sub _linewidth {
    my $linewidth = shift();
    return ($linewidth, 'w');
}

# Deprecated (renamed)
sub linewidth { return line_width(@_) }

sub line_width {
    my ($self, $line_width) = @_;

    $self->add(_linewidth($line_width));

    return $self;
}

=head2 line_cap

    $content = $content->line_cap($style);

Sets the shape that will be used at the ends of open subpaths (and dashes, if
any) when they are stroked.

=over

=item * "butt" or 0 = Butt Cap, default

The stroke ends at the end of the path, with no projection.

=item * "round" or 1 = Round Cap)

An arc is drawn around the end of the path with a diameter equal to the line
width, and is filled in.

=item * "square" or 2 = Projecting Square Cap

The stroke continues past the end of the path for half the line width.

=back

=cut

sub _linecap {
    my $linecap = shift();
    return ($linecap, 'J');
}

# Deprecated (renamed)
sub linecap { return line_cap(@_) }

sub line_cap {
    my $self = shift();

    if ($self->{' graphics'} and not @_) {
        croak "Missing argument to line_cap";
    }

    my $style = shift() // 0;
    $style = 0 if $style eq 'butt';
    $style = 1 if $style eq 'round';
    $style = 2 if $style eq 'square';

    unless ($style >= 0 and $style <= 2) {
        if ($self->{' graphics'}) {
            croak "Unknown line cap style \"$style\"";
        }
        else {
            confess "Unknown line cap style \"$style\"";
        }
    }

    $self->add(_linecap($style));

    return $self;
}

=head2 line_join

    $content = $content->line_join($style);

Sets the style of join to be used at corners of a path.

=over

=item * "miter" or 0 = Miter Join, default

The outer edges of the stroke extend until they meet, up to the limit specified
below.  If the limit would be surpassed, a bevel join is used instead.

=item * "round" or 1 = Round Join

A circle with a diameter equal to the linewidth is drawn around the corner
point, producing a rounded corner.

=item * "bevel" or 2 = Bevel Join

A triangle is drawn to fill in the notch between the two strokes.

=back

=cut

sub _linejoin {
    my $linejoin = shift();
    return ($linejoin, 'j');
}

# Deprecated (renamed)
sub linejoin { return line_join(@_) }

sub line_join {
    my $self = shift();

    if ($self->{' graphics'} and not @_) {
        croak "Missing argument to line_join";
    }

    my $style = shift() // 0;
    $style = 0 if $style eq 'miter';
    $style = 1 if $style eq 'round';
    $style = 2 if $style eq 'bevel';

    unless ($style >= 0 and $style <= 2) {
        if ($self->{' graphics'}) {
            croak "Unknown line join style \"$style\"";
        }
        else {
            confess "Unknown line join style \"$style\"";
        }
    }

    $self->add(_linejoin($style));

    return $self;
}

=head2 miter_limit

    $content = $content->miter_limit($ratio);

Sets the miter limit when the line join style is a miter join.

The C<$ratio> is the maximum length of the miter (inner to outer corner) divided
by the line width. Any miter above this ratio will be converted to a bevel
join. The practical effect is that lines meeting at shallow angles are chopped
off instead of producing long pointed corners.

There is no documented default miter limit.

=cut

sub _miterlimit {
    my $limit = shift();
    return ($limit, 'M');
}

# Deprecated; miterlimit was originally named incorrectly
sub meterlimit { return miter_limit(@_) }

# Deprecated (renamed)
sub miterlimit { return miter_limit(@_) }

sub miter_limit {
    my ($self, $limit) = @_;

    $self->add(_miterlimit($limit));

    return $self;
}

=head2 line_dash_pattern

    # Solid line
    $content = $content->line_dash_pattern();

    # Equal length lines and gaps
    $content = $content->line_dash_pattern($length);

    # Specified line and gap lengths
    $content = $content->line_dash_pattern($line1, $gap1, $line2, $gap2, ...);

    # Offset the starting point
    $content = $content->line_dash_pattern(
        pattern => [$line1, $gap1, $line2, $gap2, ...],
        offset => $points,
    );

Sets the line dash pattern.

If called without any arguments, a solid line will be drawn.

If called with one argument, the dashes and gaps will have equal lengths.

If called with two or more arguments, the arguments represent alternating dash
and gap lengths.

If called with a hash of arguments, a dash phase may be set, which specifies the
distance into the pattern at which to start the dash.

=cut

sub _linedash {
    my @options = @_;

    unless (@options) {
        return ('[', ']', '0', 'd');
    }

    if ($options[0] =~ /^\d/) {
        return ('[', floats(@options), '] 0 d');
    }

    my %options = @options;

    # Deprecated option names
    if ($options{'-pattern'}) {
        $options{'pattern'} //= delete $options{'-pattern'};
    }
    if ($options{'-shift'}) {
        $options{'offset'} //= delete $options{'-shift'};
    }

    # Deprecated: the -full and -clear options will be removed in a future
    # release
    if (exists $options{'-full'} or exists $options{'-clear'}) {
        $options{'pattern'} //= [$options{'-full'} // 0, $options{'-clear'} // 0];
    }

    return ('[', floats(@{$options{'pattern'}}), ']',
            ($options{'offset'} || 0), 'd');
}

# Deprecated (renamed)
sub linedash { return line_dash_pattern(@_) }

sub line_dash_pattern {
    my ($self, @a) = @_;

    $self->add(_linedash(@a));

    return $self;
}

=head2 flatness_tolerance

    $content = $content->flatness_tolerance($tolerance);

Sets the maximum distance in device pixels between the mathematically correct
path for a curve and an approximation constructed from straight line segments.

C<$tolerance> is an integer between 0 and 100, where 0 represents the device's
default flatness tolerance.

=cut

sub _flatness {
    my $flatness = shift();
    return ($flatness, 'i');
}

# Deprecated (renamed)
sub flatness { return flatness_tolerance(@_) }

sub flatness_tolerance {
    my ($self, $flatness) = @_;

    $self->add(_flatness($flatness));

    return $self;
}

=head2 egstate

    $content = $content->egstate($object);

Adds a L<PDF::API2::Resource::ExtGState> object containing a set of graphics
state parameters.

=cut

sub egstate {
    my ($self, $egstate) = @_;
    $self->add('/' . $egstate->name(), 'gs');
    $self->resource('ExtGState', $egstate->name(), $egstate);
    return $self;
}

=head1 PATH CONSTRUCTION (DRAWING)

Note that paths will not appear until a path painting method is called
(L</"stroke">, L</"fill">, or L</"paint">).

=head2 move

    $content = $content->move($x, $y);

Starts a new path at the specified coordinates.

=cut

sub _move {
    my ($x, $y) =@_;
    return (floats($x, $y), 'm');
}

sub move {
    my $self = shift();
    my ($x, $y);
    while (defined($x = shift())) {
        $y = shift();
        if ($self->_in_text_object()) {
            $self->add_post(floats($x, $y), 'm');
        }
        else {
            $self->add(floats($x, $y), 'm');
        }
        $self->{' x'} = $self->{' mx'} = $x;
        $self->{' y'} = $self->{' my'} = $y;
    }
    return $self;
}

=head2 line

    $content = $content->line($x, $y);

Extends the path in a line from the current coordinates to the specified
coordinates.

=cut

sub _line {
    my ($x, $y) = @_;
    return (floats($x, $y), 'l');
}

sub line {
    my $self = shift();
    my ($x, $y);
    while (defined($x = shift())) {
        $y = shift();
        if ($self->_in_text_object()) {
            $self->add_post(floats($x, $y), 'l');
        }
        else {
            $self->add(floats($x, $y), 'l');
        }
        $self->{' x'} = $x;
        $self->{' y'} = $y;
    }
    return $self;
}

=head2 hline

    $content = $content->hline($x);

Extends the path in a horizontal line from the current position to the specified
x coordinate.

=cut

sub hline {
    my ($self, $x) = @_;
    $self->{' x'} = $x;
    if ($self->_in_text_object()) {
        $self->add_post(floats($x, $self->{' y'}), 'l');
    }
    else {
        $self->add(floats($x, $self->{' y'}), 'l');
    }
    return $self;
}

=head2 vline

    $content = $content->vline($x);

Extends the path in a vertical line from the current position to the specified y
coordinate.

=cut

sub vline {
    my ($self, $y) = @_;
    if ($self->_in_text_object()) {
        $self->add_post(floats($self->{' x'}, $y), 'l');
    }
    else {
        $self->add(floats($self->{' x'}, $y), 'l');
    }
    $self->{' y'} = $y;
    return $self;
}

=head2 polyline

    $content = $content->polyline($x1, $y1, $x2, $y2, ...);

Extends the path from the current position in one or more straight lines.

=cut

sub polyline {
    my $self = shift();
    unless (@_ % 2 == 0) {
        croak 'polyline requires pairs of coordinates';
    }

    while (@_) {
        my $x = shift();
        my $y = shift();
        $self->line($x, $y);
    }

    return $self;
}

# Deprecated; replace with move and polyline.  Deprecated because poly breaks
# the convention followed by every other path-drawing method (other than
# enclosed shapes) of extending the path from the current position.
sub poly {
    my $self = shift();
    my $x = shift();
    my $y = shift();
    $self->move($x, $y);
    $self->line(@_);
    return $self;
}

=head2 curve

    $content = $content->curve($cx1, $cy1, $cx2, $cy2, $x, $y);

Extends the path in a curve from the current point to C<($x, $y)>, using the two
specified points to create a cubic Bezier curve.

=cut

sub curve {
    my $self = shift();
    my ($x1, $y1, $x2, $y2, $x3, $y3);
    while (defined($x1 = shift())) {
        $y1 = shift();
        $x2 = shift();
        $y2 = shift();
        $x3 = shift();
        $y3 = shift();
        if ($self->_in_text_object()) {
            $self->add_post(floats($x1, $y1, $x2, $y2, $x3, $y3), 'c');
        }
        else {
            $self->add(floats($x1, $y1, $x2, $y2, $x3, $y3), 'c');
        }
        $self->{' x'} = $x3;
        $self->{' y'} = $y3;
    }
    return $self;
}

=head2 spline

    $content = $content->spline($cx1, $cy1, $x, $y);

Extends the path in a curve from the current point to C<($x, $y)>, using the two
specified points to create a spline.

=cut

sub spline {
    my $self = shift();

    while (scalar @_ >= 4) {
        my $cx = shift();
        my $cy = shift();
        my $x = shift();
        my $y = shift();
        my $c1x = (2 * $cx + $self->{' x'}) / 3;
        my $c1y = (2 * $cy + $self->{' y'}) / 3;
        my $c2x = (2 * $cx + $x) / 3;
        my $c2y = (2 * $cy + $y) / 3;
        $self->curve($c1x, $c1y, $c2x, $c2y, $x, $y);
    }
}

=head2 arc

    $content = $content->arc($x, $y, $major, $minor, $a, $b);

Extends the path along an arc of an ellipse centered at C<[$x, $y]>.  C<$major>
and C<$minor> represent the axes of the ellipse, and the arc moves from C<$a>
degrees to C<$b> degrees.

=cut

# Private
sub arctocurve {
    my ($a, $b, $alpha, $beta) = @_;
    if (abs($beta - $alpha) > 30) {
        return (
            arctocurve($a, $b, $alpha, ($beta + $alpha) / 2),
            arctocurve($a, $b, ($beta + $alpha) / 2, $beta)
        );
    }
    else {
        $alpha = ($alpha * pi / 180);
        $beta  = ($beta * pi / 180);

        my $bcp = (4.0 / 3 * (1 - cos(($beta - $alpha) / 2)) / sin(($beta - $alpha) / 2));
        my $sin_alpha = sin($alpha);
        my $sin_beta  = sin($beta);
        my $cos_alpha = cos($alpha);
        my $cos_beta  = cos($beta);

        my $p0_x = $a * $cos_alpha;
        my $p0_y = $b * $sin_alpha;
        my $p1_x = $a * ($cos_alpha - $bcp * $sin_alpha);
        my $p1_y = $b * ($sin_alpha + $bcp * $cos_alpha);
        my $p2_x = $a * ($cos_beta + $bcp * $sin_beta);
        my $p2_y = $b * ($sin_beta - $bcp * $cos_beta);
        my $p3_x = $a * $cos_beta;
        my $p3_y = $b * $sin_beta;

        return ($p0_x, $p0_y, $p1_x, $p1_y, $p2_x, $p2_y, $p3_x, $p3_y);
    }
}

sub arc {
    my ($self, $x, $y, $a, $b, $alpha, $beta, $move) = @_;
    my @points = arctocurve($a, $b, $alpha, $beta);
    my ($p0_x, $p0_y, $p1_x, $p1_y, $p2_x, $p2_y, $p3_x, $p3_y);

    $p0_x = $x + shift(@points);
    $p0_y = $y + shift(@points);

    # Deprecated
    $self->move($p0_x, $p0_y) if $move;

    while (scalar @points) {
        $p1_x = $x + shift(@points);
        $p1_y = $y + shift(@points);
        $p2_x = $x + shift(@points);
        $p2_y = $y + shift(@points);
        $p3_x = $x + shift(@points);
        $p3_y = $y + shift(@points);
        $self->curve($p1_x, $p1_y, $p2_x, $p2_y, $p3_x, $p3_y);
        shift(@points);
        shift(@points);
        $self->{' x'} = $p3_x;
        $self->{' y'} = $p3_y;
    }
    return $self;
}

# Extends the path along an arc of a circle of the specified radius from
# C<[x1,y1]> to C<[x2,y2]>.
#
# Set C<$move> to a true value if this arc is the beginning of a new path
# instead of the continuation of an existing path.
#
# Set C<$outer> to a true value to draw the larger arc between the two points
# instead of the smaller one.
#
# Set C<$reverse> to a true value to draw the mirror image of the specified arc.
#
# C<$radius * 2> cannot be smaller than the distance from C<[x1,y1]> to
# C<[x2,y2]>.

# Deprecated; recreate using arc (Bogen is German for arc)
sub bogen {
    my ($self, $x1, $y1, $x2, $y2, $r, $move, $larc, $spf) = @_;
    my ($p0_x, $p0_y, $p1_x, $p1_y, $p2_x, $p2_y, $p3_x, $p3_y);
    my $x = $x2 - $x1;
    my $y = $y2 - $y1;
    my $z = sqrt($x ** 2 + $y ** 2);
    my $alpha_rad = asin($y / $z);

    $alpha_rad += pi / 2 if $x < 0 and $y > 0;
    $alpha_rad -= pi / 2 if $x < 0 and $y < 0;

    my $alpha = rad2deg($alpha_rad);
    # use the complement angle for span
    $alpha -= 180 if $spf and $spf > 0;

    my $d = 2 * $r;
    my ($beta, $beta_rad, @points);

    $beta = rad2deg(2 * asin($z / $d));
    $beta = 360 - $beta if $larc and $larc > 0;

    $beta_rad = deg2rad($beta);

    @points = arctocurve($r, $r, 90 + $alpha + $beta / 2, 90 + $alpha - $beta / 2);

    if ($spf and $spf > 0) {
        my @pts = @points;
        @points = ();
        while ($y = pop(@pts)) {
            $x = pop(@pts);
            push(@points, $x, $y);
        }
    }

    $p0_x = shift(@points);
    $p0_y = shift(@points);
    $x = $x1 - $p0_x;
    $y = $y1 - $p0_y;

    $self->move($x1, $y1) if $move;

    while (scalar @points) {
        $p1_x = $x + shift(@points);
        $p1_y = $y + shift(@points);
        $p2_x = $x + shift(@points);
        $p2_y = $y + shift(@points);
        # if we run out of data points, use the end point instead
        if (scalar @points == 0) {
            $p3_x = $x2;
            $p3_y = $y2;
        }
        else {
            $p3_x = $x + shift(@points);
            $p3_y = $y + shift(@points);
        }
        $self->curve($p1_x, $p1_y, $p2_x, $p2_y, $p3_x, $p3_y);
        shift(@points);
        shift(@points);
    }
    return $self;
}

=head2 close

    $content = $content->close();

Closes the current path by extending a line from the current position to the
starting position.

=cut

sub close {
    my $self = shift();
    $self->add('h');
    $self->{' x'} = $self->{' mx'};
    $self->{' y'} = $self->{' my'};
    return $self;
}

=head2 end

    $content = $content->end();

Ends the current path without filling or stroking.

=cut

# Deprecated (renamed)
sub endpath { return end(@_) }

sub end {
    my $self = shift();
    $self->add('n');
    return $self;
}

=head1 SHAPE CONSTRUCTION (DRAWING)

The following are convenience methods for drawing closed paths.

Note that shapes will not appear until a path painting method is called
(L</"stroke">, L</"fill">, or L</"paint">).

=head2 rectangle

    $content = $content->rectangle($x1, $y1, $x2, $y2);

Creates a new rectangle-shaped path, between the two points C<[$x1, $y1]>
and C<[$x2, $y2]>.

=cut

sub rectangle {
    my ($self, $x1, $y1, $x2, $y2) = @_;

    # Ensure that x1,y1 is lower-left and x2,y2 is upper-right
    if ($x2 < $x1) {
        my $x = $x1;
        $x1 = $x2;
        $x2 = $x;
    }
    if ($y2 < $y1) {
        my $y = $y1;
        $y1 = $y2;
        $y2 = $y;
    }

    $self->add(floats($x1, $y1, ($x2 - $x1), ($y2 - $y1)), 're');
    $self->{' x'} = $x1;
    $self->{' y'} = $y1;

    return $self;
}

# Deprecated; replace with individual calls to rectangle
sub rect {
    my $self = shift();
    my ($x, $y, $w, $h);
    while (defined($x = shift())) {
        $y = shift();
        $w = shift();
        $h = shift();
        $self->add(floats($x, $y, $w, $h), 're');
    }
    $self->{' x'} = $x;
    $self->{' y'} = $y;
    return $self;
}

# Deprecated; replace with rectangle, converting x2/y2 to w/h.
sub rectxy {
    my ($self, $x, $y, $x2, $y2) = @_;
    $self->rect($x, $y, ($x2 - $x), ($y2 - $y));
    return $self;
}

=head2 circle

    $content = $content->circle($x, $y, $radius);

Creates a new circular path centered on C<[$x, $y]> with the specified radius.

=cut

sub circle {
    my ($self, $x, $y, $r) = @_;
    $self->arc($x, $y, $r, $r, 0, 360, 1);
    $self->close();
    return $self;
}

=head2 ellipse

    $content = $content->ellipse($x, $y, $major, $minor);

Creates a new elliptical path centered on C<[$x, $y]> with the specified major
and minor axes.

=cut

sub ellipse {
    my ($self, $x, $y, $a, $b) = @_;
    $self->arc($x, $y, $a, $b, 0, 360, 1);
    $self->close();
    return $self;
}

=head2 pie

    $content = $content->pie($x, $y, $major, $minor, $a, $b);

Creates a new wedge-shaped path from an ellipse centered on C<[$x, $y]> with the
specified major and minor axes, extending from C<$a> degrees to C<$b> degrees.

=cut

sub pie {
    my $self = shift();
    my ($x, $y, $a, $b, $alpha, $beta) = @_;
    my ($p0_x, $p0_y) = arctocurve($a, $b, $alpha, $beta);
    $self->move($x, $y);
    $self->line($p0_x + $x, $p0_y + $y);
    $self->arc($x, $y, $a, $b, $alpha, $beta);
    $self->close();
}

=head1 PATH PAINTING (DRAWING)

=head2 stroke_color

    $content = $content->stroke_color($color, @arguments);

Sets the stroke color, which is black by default.

    # Use a named color
    $content->stroke_color('blue');

    # Use an RGB color (start with '#')
    $content->stroke_color('#FF0000');

    # Use a CMYK color (start with '%')
    $content->stroke_color('%FF000000');

    # Use a spot color with 100% coverage.
    my $spot = $pdf->colorspace('spot', 'PANTONE Red 032 C', '#EF3340');
    $content->stroke_color($spot, 1.0);

RGB and CMYK colors can have one-byte, two-byte, three-byte, or four-byte values
for each color, depending on the level of precision needed.  For instance, cyan
can be given as C<%F000> or C<%FFFF000000000000>.

=head2 fill_color

    $content = $content->fill_color($color, @arguments);

Sets the fill color, which is black by default.  Arguments are the same as in
L</"stroke_color">.

=cut

# default colorspaces: rgb/hsv/named cmyk/hsl lab
#   ... only one text string
#
# pattern or shading space
#   ... only one object
#
# legacy greylevel
#   ... only one value
sub _makecolor {
    my ($self, $sf, @clr) = @_;

    if ($clr[0] =~ /^[a-z\#\!]+/) {
        # colorname or #! specifier
        # with rgb target colorspace
        # namecolor returns always a RGB
        return namecolor($clr[0]), ($sf ? 'rg' : 'RG');
    }
    elsif ($clr[0] =~ /^[\%]+/) {
        # % specifier
        # with cmyk target colorspace
        return namecolor_cmyk($clr[0]), ($sf ? 'k' : 'K');
    }
    elsif ($clr[0] =~ /^[\$\&]/) {
        # &$ specifier
        # with L*a*b target colorspace
        if (!defined $self->resource('ColorSpace', 'LabS')) {
            my $dc = PDFDict();
            my $cs = PDFArray(PDFName('Lab'), $dc);
            $dc->{'WhitePoint'} = PDFArray(map { PDFNum($_) } qw(1 1 1));
            $dc->{'Range'} = PDFArray(map { PDFNum($_) } qw(-128 127 -128 127));
            $dc->{'Gamma'} = PDFArray(map { PDFNum($_) } qw(2.2 2.2 2.2));
            $self->resource('ColorSpace', 'LabS', $cs);
        }
        return '/LabS', ($sf ? 'cs' : 'CS'), namecolor_lab($clr[0]), ($sf ? 'sc' : 'SC');
    }
    elsif (scalar @clr == 1 and ref($clr[0])) {
        # pattern or shading space
        return '/Pattern', ($sf ? 'cs' : 'CS'), '/' . ($clr[0]->name()), ($sf ? 'scn' : 'SCN');
    }
    elsif (scalar @clr == 1) {
        # grey color spec.
        return $clr[0], $sf ? 'g' : 'G';
    }
    elsif (scalar @clr > 1 and ref($clr[0])) {
        # indexed colorspace plus color-index
        # or custom colorspace plus param
        my $cs = shift(@clr);
        return '/' . $cs->name(), ($sf ? 'cs' : 'CS'), $cs->param(@clr), ($sf ? 'sc' : 'SC');
    }
    elsif (scalar @clr == 2) {
        # indexed colorspace plus color-index
        # or custom colorspace plus param
        return '/' . $clr[0]->name(), ($sf ? 'cs' : 'CS'), $clr[0]->param($clr[1]), ($sf ? 'sc' : 'SC');
    }
    elsif (scalar @clr == 3) {
        # legacy rgb color-spec (0 <= x <= 1)
        return floats($clr[0], $clr[1], $clr[2]), ($sf ? 'rg' : 'RG');
    }
    elsif (scalar @clr == 4) {
        # legacy cmyk color-spec (0 <= x <= 1)
        return floats($clr[0], $clr[1], $clr[2], $clr[3]), ($sf ? 'k' : 'K');
    }
    else {
        die 'invalid color specification.';
    }
}

sub _fillcolor {
    my ($self, @clrs) = @_;
    if (ref($clrs[0]) =~ m|^PDF::API2::Resource::ColorSpace|) {
        $self->resource('ColorSpace', $clrs[0]->name(), $clrs[0]);
    }
    elsif (ref($clrs[0]) =~ m|^PDF::API2::Resource::Pattern|) {
        $self->resource('Pattern', $clrs[0]->name(), $clrs[0]);
    }

    return $self->_makecolor(1, @clrs);
}

# Deprecated
sub fillcolor { return fill_color(@_) }

sub fill_color {
    my $self = shift();
    if (@_) {
        @{$self->{' fillcolor'}} = @_;
        $self->add($self->_fillcolor(@_));
    }
    return @{$self->{' fillcolor'}};
}

sub _strokecolor {
    my ($self, @clrs) = @_;
    if (ref($clrs[0]) =~ m|^PDF::API2::Resource::ColorSpace|) {
        $self->resource('ColorSpace', $clrs[0]->name(), $clrs[0]);
    }
    elsif (ref($clrs[0]) =~ m|^PDF::API2::Resource::Pattern|) {
        $self->resource('Pattern', $clrs[0]->name(), $clrs[0]);
    }
    return $self->_makecolor(0, @clrs);
}

# Deprecated
sub strokecolor { return stroke_color(@_) }

sub stroke_color {
    my $self = shift();
    if (@_) {
        @{$self->{' strokecolor'}} = @_;
        $self->add($self->_strokecolor(@_));
    }
    return @{$self->{' strokecolor'}};
}

=head2 stroke

    $content = $content->stroke();

Strokes the current path.

=cut

sub _stroke {
    return 'S';
}

sub stroke {
    my $self = shift();
    $self->add(_stroke());
    return $self;
}

=head2 fill

    $content = $content->fill(rule => $rule);

Fills the current path.

C<$rule> describes which areas are filled in when the path intersects with itself.

=over

=item * nonzero (default)

Use the nonzero winding number rule.  This tends to mean that the entire area
enclosed by the path is filled in, with some exceptions depending on the
direction of the path.

=item * even-odd

Use the even-odd rule.  This tends to mean that the presence of fill alternates
each time the path is intersected.

=back

See PDF specification 1.7 section 8.5.3.3, Filling, for more details.

=cut

sub fill {
    my $self = shift();

    my $even_odd;
    if (@_ == 2) {
        my %options = @_;
        if (($options{'rule'} // 'nonzero') eq 'even-odd') {
            $even_odd = 1;
        }
    }
    else {
        # Deprecated
        $even_odd = shift();
    }

    $self->add($even_odd ? 'f*' : 'f');

    return $self;
}

=head2 paint

    $content = $content->paint(rule => $rule);

Fills and strokes the current path.  C<$rule> is as described in L</"fill">.

=cut

# Deprecated (renamed)
sub fillstroke { return paint(@_) }

sub paint {
    my $self = shift();

    my $even_odd;
    if (@_ == 2) {
        my %options = @_;
        if (($options{'rule'} // 'nonzero') eq 'even-odd') {
            $even_odd = 1;
        }
    }
    else {
        # Deprecated
        $even_odd = shift();
    }

    $self->add($even_odd ? 'B*' : 'B');

    return $self;
}

=head2 clip

    $content = $content->clip(rule => $rule);

Modifies the current clipping path (initially the entire page) by intersecting
it with the current path following the next path-painting command.  C<$rule> is
as described in L</"fill">.

=cut

sub clip {
    my $self = shift();

    my $even_odd;
    if (@_ == 2) {
        my %options = @_;
        if (($options{'rule'} // 'nonzero') eq 'even-odd') {
            $even_odd = 1;
        }
    }
    else {
        # Deprecated
        $even_odd = shift();
    }

    $self->add($even_odd ? 'W*' : 'W');

    return $self;
}

sub shade {
    my ($self, $shade, @cord) = @_;

    my @tm = (
        $cord[2] - $cord[0], 0,
        0                  , $cord[3] - $cord[1],
        $cord[0]           , $cord[1],
    );

    $self->save();
    $self->matrix(@tm);
    $self->add('/' . $shade->name(), 'sh');
    $self->resource('Shading', $shade->name(), $shade);
    $self->restore();

    return $self;
}

=head1 EXTERNAL OBJECTS

=head2 object

    $content = $content->object($object, $x, $y, $scale_x, $scale_y);

Places an image or other external object (a.k.a. XObject) on the page in the
specified location.

If C<$x> and C<$y> are omitted, the object will be placed at C<[0, 0]>.

For images, C<$scale_x> and C<$scale_y> represent the width and height of the
image on the page in points.  If C<$scale_x> is omitted, it will default to 72
pixels per inch.  If C<$scale_y> is omitted, the image will be scaled
proportionally based on the image dimensions.

For other external objects, the scale is a multiplier, where 1 (the default)
represents 100% (i.e. no change).

If coordinate transformations have been made (see Coordinate Transformations
above), the position and scale will be relative to the updated coordinates.

If no coordinate transformations are needed, this method can be called directly
from the L<PDF::API2::Page> object instead.

=cut

# Behavior based on argument count
# 0: Place at 0, 0, 100%
# 2: Place at X, Y, 100%
# 3: Place at X, Y, scaled
# 4: Place at X, Y, scale_w, scale_h
sub object {
    my ($self, $object, $x, $y, $scale_x, $scale_y) = @_;
    $x //= 0;
    $y //= 0;
    if ($object->isa('PDF::API2::Resource::XObject::Image')) {
        $scale_x //= $object->width();
        $scale_y //= $object->height() * $scale_x / $object->width();
    }
    else {
        $scale_x //= 1;
        $scale_y //= $scale_x;
    }

    $self->save();
    $self->matrix($scale_x, 0, 0, $scale_y, $x, $y);
    $self->add('/' . $object->name(), 'Do');
    $self->restore();

    $self->resource('XObject', $object->name(), $object);

    return $self;
}

# Deprecated
sub image {
    my $self = shift;
    my $img = shift;
    my ($x, $y, $w, $h) = @_;
    if (defined $img->{'Metadata'}) {
        $self->metaStart('PPAM:PlacedImage', $img->{'Metadata'});
    }
    $self->save();
    unless (defined $w) {
        $h = $img->height();
        $w = $img->width();
    }
    elsif (not defined $h) {
        $h = $img->height() * $w;
        $w = $img->width() * $w;
    }
    $self->matrix($w, 0, 0, $h, $x, $y);
    $self->add('/' . $img->name(), 'Do');
    $self->restore();
    $self->{' x'} = $x;
    $self->{' y'} = $y;
    $self->resource('XObject', $img->name(), $img);
    if (defined $img->{'Metadata'}) {
        $self->metaEnd();
    }
    return $self;
}

# Deprecated
sub formimage {
    my ($self, $img, $x, $y, $s) = @_;
    $self->save();
    if (defined $s) {
        $self->matrix($s, 0, 0, $s, $x, $y);
    }
    else {
        $self->matrix(1, 0, 0, 1, $x, $y);
    }
    $self->add('/' . $img->name(), 'Do');
    $self->restore();
    $self->resource('XObject', $img->name(), $img);
    return $self;
}

=head1 TEXT STATE

All of the following parameters that take a size are applied before any scaling
takes place, so you don't need to adjust values to counteract scaling.

=head2 font

    $content = $content->font($font, $size);

Sets the font and font size.  C<$font> is an object created by calling
L<PDF::API2/"font"> to add the font to the document.

    my $pdf = PDF::API2->new();
    my $page = $pdf->page();
    my $text = $page->text();

    my $font = $pdf->font('Helvetica');
    $text->font($font, 24);
    $text->position(72, 720);
    $text->text('Hello, World!');

    $pdf->save('sample.pdf');

=cut

sub _font {
    my ($font, $size) = @_;
    if ($font->isvirtual()) {
        return('/' . $font->fontlist->[0]->name() . ' ' . float($size) . ' Tf');
    }
    else {
        return('/' . $font->name() . ' ' . float($size) . ' Tf');
    }
}
sub font {
    my ($self, $font, $size) = @_;
    unless ($size) {
        croak q{A font size is required};
    }
    $self->fontset($font, $size);
    $self->add(_font($font, $size));
    $self->{' fontset'} = 1;
    return $self;
}

sub fontset {
    my ($self, $font, $size) = @_;
    $self->{' font'} = $font;
    $self->{' fontsize'} = $size;
    $self->{' fontset'} = 0;

    if ($font->isvirtual()) {
        foreach my $f (@{$font->fontlist()}) {
            $self->resource('Font', $f->name(), $f);
        }
    }
    else {
        $self->resource('Font', $font->name(), $font);
    }

    return $self;
}

=head2 character_spacing

    $spacing = $content->character_spacing($spacing);

Sets the spacing between characters.  This is initially zero.

=cut

sub _charspace {
    my $spacing = shift();
    return float($spacing, 6) . ' Tc';
}

# Deprecated (renamed)
sub charspace { return character_spacing(@_) }

sub character_spacing {
    my ($self, $spacing) = @_;
    if (defined $spacing) {
        $self->{' charspace'} = $spacing;
        $self->add(_charspace($spacing));
    }
    return $self->{' charspace'};
}

=head2 word_spacing

    $spacing = $content->word_spacing($spacing);

Sets the spacing between words.  This is initially zero (i.e. just the width of
the space).

Word spacing might only affect simple fonts and composite fonts where the space
character is a single-byte code.  This is a limitation of the PDF specification
at least as of version 1.7 (see section 9.3.3).  It's possible that a later
version of the specification will support word spacing in fonts that use
multi-byte codes.

=cut

sub _wordspace {
    my $spacing = shift();
    return float($spacing, 6) . ' Tw';
}

# Deprecated (renamed)
sub wordspace { return word_spacing(@_) }

sub word_spacing {
    my ($self, $spacing) = @_;
    if (defined $spacing) {
        $self->{' wordspace'} = $spacing;
        $self->add(_wordspace($spacing));
    }
    return $self->{' wordspace'};
}

=head2 hscale

    $scale = $content->hscale($scale);

Sets/gets the percentage of horizontal text scaling.  Enter a scale greater than
100 to stretch text, less than 100 to squeeze text, or 100 to disable any
existing scaling.

=cut

sub _hscale {
    my $scale = shift();
    return float($scale, 6) . ' Tz';
}

sub hscale {
    my ($self, $scale) = @_;
    if (defined $scale) {
        $self->{' hscale'} = $scale;
        $self->add(_hscale($scale));
    }
    return $self->{' hscale'};
}

# Deprecated: hscale was originally named incorrectly (as hspace)
sub  hspace { return  hscale(@_) }
sub _hspace { return _hscale(@_) }

=head2 leading

    $leading = $content->leading($leading);

Sets/gets the text leading, which is the distance between baselines.  This is
initially zero (i.e. the lines will be printed on top of each other).

=cut

# Deprecated: leading is the correct name for this operator
sub _lead { return _leading(@_) }
sub  lead { return  leading(@_) }

sub _leading {
    my $leading = shift();
    return float($leading) . ' TL';
}
sub leading {
    my ($self, $leading) = @_;
    if (defined ($leading)) {
        $self->{' leading'} = $leading;
        $self->add(_leading($leading));
    }
    return $self->{' leading'};
}

=head2 render

    $mode = $content->render($mode);

Sets the text rendering mode.

=over

=item * 0 = Fill text

=item * 1 = Stroke text (outline)

=item * 2 = Fill, then stroke text

=item * 3 = Neither fill nor stroke text (invisible)

=item * 4 = Fill text and add to path for clipping

=item * 5 = Stroke text and add to path for clipping

=item * 6 = Fill, then stroke text and add to path for clipping

=item * 7 = Add text to path for clipping

=back

=cut

sub _render {
    my $mode = shift();
    return intg($mode) . ' Tr';
}

sub render {
    my ($self, $mode) = @_;
    if (defined ($mode)) {
        $self->{' render'} = $mode;
        $self->add(_render($mode));
    }
    return $self->{' render'};
}

=head2 rise

    $distance = $content->rise($distance);

Adjusts the baseline up or down from its current location.  This is initially
zero.

Use this to create superscripts or subscripts (usually with an adjustment to the
font size as well).

=cut

sub _rise {
    my $distance = shift();
    return float($distance) . ' Ts';
}

sub rise {
    my ($self, $distance) = @_;
    if (defined ($distance)) {
        $self->{' rise'} = $distance;
        $self->add(_rise($distance));
    }
    return $self->{' rise'};
}

# Formerly documented; still used internally
sub textstate {
    my $self = shift();
    my %state;
    if (@_) {
        %state = @_;
        foreach my $k (qw(charspace hscale wordspace leading rise render)) {
            next unless $state{$k};
            $self->can($k)->($self, $state{$k});
        }
        if ($state{'font'} and $state{'fontsize'}) {
            $self->font($state{'font'}, $state{'fontsize'});
        }
        if ($state{'textmatrix'}) {
            $self->matrix(@{$state{'textmatrix'}});
            @{$self->{' translate'}} = @{$state{'translate'}};
            $self->{' rotate'} = $state{'rotate'};
            @{$self->{' scale'}} = @{$state{'scale'}};
            @{$self->{' skew'}} = @{$state{'skew'}};
        }
        if ($state{'fillcolor'}) {
            $self->fillcolor(@{$state{'fillcolor'}});
        }
        if ($state{'strokecolor'}) {
            $self->strokecolor(@{$state{'strokecolor'}});
        }
        %state = ();
    }
    else {
        foreach my $k (qw(font fontsize charspace hscale wordspace leading rise render)) {
            $state{$k} = $self->{" $k"};
        }
        $state{'matrix'}         = [@{$self->{' matrix'}}];
        $state{'textmatrix'}     = [@{$self->{' textmatrix'}}];
        $state{'textlinematrix'} = [@{$self->{' textlinematrix'}}];
        $state{'rotate'}         = $self->{' rotate'};
        $state{'scale'}          = [@{$self->{' scale'}}];
        $state{'skew'}           = [@{$self->{' skew'}}];
        $state{'translate'}      = [@{$self->{' translate'}}];
        $state{'fillcolor'}      = [@{$self->{' fillcolor'}}];
        $state{'strokecolor'}    = [@{$self->{' strokecolor'}}];
    }
    return %state;
}

=head1 TEXT PLACEMENT

=head2 position

    # Set
    $content = $content->position($x, $y);

    # Get
    ($x, $y) = $content->position();

If called with arguments, moves to the start of the current line of text, offset
by C<$x> and C<$y>.

If called without arguments, returns the current position of the cursor (before
the effects of any coordinate transformation methods).

=cut

sub position {
    my ($self, $x, $y) = @_;

    if (defined $x and not defined $y) {
        croak 'position requires either 0 or 2 arguments';
    }

    if (defined $x) {
        $self->add(float($x), float($y), 'Td');
        $self->matrix_update($x, $y);
        $self->{' textlinematrix'}->[0] = $self->{' textlinestart'} + $x;
        $self->{' textlinestart'} = $self->{' textlinematrix'}->[0];
        return $self;
    }

    return @{$self->{' textlinematrix'}};
}

# Deprecated; replace with position
sub distance {
    my ($self, $dx, $dy) = @_;
    $self->add(float($dx), float($dy), 'Td');
    $self->matrix_update($dx, $dy);
    $self->{' textlinematrix'}->[0] = $self->{' textlinestart'} + $dx;
    $self->{' textlinestart'} = $self->{' textlinematrix'}->[0];
}

# Deprecated; use position (ignores leading) or crlf (uses leading) instead
sub cr {
    my ($self, $offset) = @_;
    if (defined $offset) {
        $self->add(0, float($offset), 'Td');
        $self->matrix_update(0, $offset);
    }
    else {
        $self->add('T*');
        $self->matrix_update(0, $self->leading() * -1);
    }

    $self->{' textlinematrix'}->[0] = $self->{' textlinestart'};
}

=head2 crlf

    $content = $content->crlf();

Moves to the start of the next line, based on the L</"leading"> setting.

If leading isn't set, a default distance of 120% of the font size will be used.

=cut

sub crlf {
    my $self = shift();
    my $leading = $self->leading();
    if ($leading or not $self->{' fontsize'}) {
        $self->add('T*');
    }
    else {
        $leading = $self->{' fontsize'} * 1.2;
        $self->add(0, float($leading * -1), 'Td');
    }

    $self->matrix_update(0, $leading * -1);
    $self->{' textlinematrix'}->[0] = $self->{' textlinestart'};
    return $self;
}

# Deprecated; replace with crlf
sub nl {
    my $self = shift();
    $self->add('T*');
    $self->matrix_update(0, $self->leading() * -1);
    $self->{' textlinematrix'}->[0] = $self->{' textlinestart'};
}

sub _textpos {
    my ($self, @xy) = @_;

    my ($x, $y) = (0, 0);
    while (@xy) {
        $x += shift(@xy);
        $y += shift(@xy);
    }
    my (@m) = _transform(
        -matrix => $self->{' textmatrix'},
        -point  => [$x, $y],
    );

    return ($m[0], $m[1]);
}

# Deprecated
sub textpos {
    my $self = shift();
    return $self->_textpos(@{$self->{' textlinematrix'}});
}

# Deprecated; replace with position (without arguments)
sub textpos2 {
    my $self = shift();
    return $self->position();
}

=head2 text

    my $width = $content->text($text, %options);

Places text on the page.  Returns the width of the text in points.

Options:

=over

=item * align

One of C<left> (default), C<center>, or C<right>.  Text will be placed such that
it begins, is centered on, or ends at the current text position, respectively.

In each case, the position will then be moved to the end of the text.

=item * indent

Indents the text by the number of points.

If C<align> is set to anything other than C<left>, this setting will be ignored.

=item * underline

Underlines the text.  The value may be one of the following:

=over

=item * auto

Determines the underline distance from the text based on the font and font size.

=item * $distance

Manually set the underline distance in points.  A positive distance moves the
line downward.

=item * [$distance, $thickness, ...]

Manually set both the underline distance and line thickness, both in points.

Repeat these arguments to include multiple underlines.

=back

=back

=cut

sub _text_underline {
    my ($self, $xy1, $xy2, $underline, $color) = @_;
    $color ||= 'black';

    my @underline;
    if (ref($underline) eq 'ARRAY') {
        @underline = @$underline;
    }
    else {
        @underline = ($underline, 1);
    }
    push @underline, 1 if @underline % 2;

    my $underlineposition = (-$self->{' font'}->underlineposition() * $self->{' fontsize'} / 1000 || 1);
    my $underlinethickness = ($self->{' font'}->underlinethickness() * $self->{' fontsize'} / 1000 || 1);
    my $pos = 1;

    while (@underline) {
        $self->add_post(_save());

        my $distance = shift(@underline);
        my $thickness = shift(@underline);
        my $scolor = $color;
        if (ref($thickness)) {
            ($thickness, $scolor) = @$thickness;
        }
        if ($distance eq 'auto') {
            $distance = $pos * $underlineposition;
        }
        if ($thickness eq 'auto') {
            $thickness = $underlinethickness;
        }

        my ($x1, $y1) = $self->_textpos(@$xy1, 0, -($distance + ($thickness / 2)));
        my ($x2, $y2) = $self->_textpos(@$xy2, 0, -($distance + ($thickness / 2)));

        $self->add_post($self->_strokecolor($scolor));
        $self->add_post(_linewidth($thickness));
        $self->add_post(_move($x1, $y1));
        $self->add_post(_line($x2, $y2));
        $self->add_post(_stroke());

        $self->add_post(_restore());
        $pos++;
    }
}

sub text {
    my ($self, $text, %opts) = @_;
    unless ($self->{' fontset'}) {
        unless (defined $self->{' font'} and $self->{' fontsize'}) {
            croak q{Can't add text without first setting a font and font size};
        }
        $self->font($self->{' font'}, $self->{' fontsize'});
        $self->{' fontset'} = 1;
    }

    # Deprecated options (remove hyphens)
    if (exists $opts{'-indent'}) {
        $opts{'indent'} //= delete $opts{'-indent'};
    }
    if (exists $opts{'-underline'}) {
        $opts{'underline'} //= delete $opts{'-underline'};
    }

    my $width = $self->text_width($text);

    if (defined $opts{'align'}) {
        if ($opts{'align'} eq 'left') {
            # NOOP
        }
        elsif ($opts{'align'} eq 'center') {
            $opts{'indent'} = -($width / 2);
        }
        elsif ($opts{'align'} eq 'right') {
            $opts{'indent'} = -$width;
        }
        else {
            croak 'Invalid alignment: ' . $opts{'align'};
        }
    }

    if (defined $opts{'indent'}) {
        $self->matrix_update($opts{'indent'}, 0);
    }

    my $underline_start = [$self->position()];

    if (defined $opts{'indent'}) {
        my $indent = -$opts{'indent'};
        $indent *= (1000 / $self->{' fontsize'}) * (100 / $self->hscale());
        $self->add($self->{' font'}->text($text, $self->{' fontsize'}, $indent));
    }
    else {
        $self->add($self->{' font'}->text($text, $self->{' fontsize'}));
    }

    $self->matrix_update($width, 0);

    my $underline_end = [$self->position()];

    if (defined $opts{'underline'}) {
        $self->_text_underline($underline_start, $underline_end,
                               $opts{'underline'},
                               $opts{'-strokecolor'});
    }

    return $width;
}

# Deprecated; replace with text($line, align => 'center')
sub text_center {
    my ($self, $text, @opts) = @_;
    my $width = $self->advancewidth($text);
    return $self->text($text, -indent => -($width / 2), @opts);
}

# Deprecated; replace with text($line, align => 'right')
sub text_right {
    my ($self, $text, @opts) = @_;
    my $width = $self->advancewidth($text);
    return $self->text($text, -indent => -$width, @opts);
}

=head2 text_justified

    my $width = $content->text_justified($text, $width, %options);

As C<text>, filling the specified width by adjusting the space between words.

=cut

sub text_justified {
    my ($self, $text, $width, %opts) = @_;
    my $initial_width = $self->text_width($text);
    my $space_count = (split /\s/, $text) - 1;
    my $ws = $self->wordspace();
    $self->wordspace(($width - $initial_width) / $space_count) if $space_count;
    $self->text($text, %opts);
    $self->wordspace($ws);
    return $width;
}

sub _text_fill_line {
    my ($self, $text, $width) = @_;
    my @words = split(/\x20/, $text);
    my @line = ();
    local $" = ' ';
    while (@words) {
         push @line, (shift @words);
         last if $self->advancewidth("@line") > $width;
    }
    if ((scalar @line > 1) and ($self->advancewidth("@line") > $width)) {
        unshift @words, pop @line;
    }
    my $ret = "@words";
    my $line = "@line";
    return $line, $ret;
}

sub text_fill_left {
    my ($self, $text, $width, %opts) = @_;
    my ($line, $ret) = $self->_text_fill_line($text, $width);
    $width = $self->text($line, %opts);
    return $width, $ret;
}

sub text_fill_center {
    my ($self, $text, $width, %opts) = @_;
    my ($line, $ret) = $self->_text_fill_line($text, $width);
    $width = $self->text_center($line, %opts);
    return $width, $ret;
}

sub text_fill_right {
    my ($self, $text, $width, %opts) = @_;
    my ($line, $ret) = $self->_text_fill_line($text, $width);
    $width = $self->text_right($line, %opts);
    return $width, $ret;
}

sub text_fill_justified {
    my ($self, $text, $width, %opts) = @_;
    my ($line, $ret) = $self->_text_fill_line($text, $width);
    my $ws = $self->wordspace();
    my $w = $self->advancewidth($line);
    my $space_count = (split /\s/, $line) - 1;

    # Normal Line
    if ($ret) {
        $self->wordspace(($width - $w) / $space_count) if $space_count;
        $width = $self->text($line, %opts, align => 'left');
        $self->wordspace($ws);
        return $width, $ret;
    }

    # Last Line
    if ($opts{'align-last'}) {
        unless ($opts{'align-last'} =~ /^(left|center|right|justified)$/) {
            croak 'Invalid align-last (must be left, center, right, or justified)';
        }
    }
    my $align_last = $opts{'align-last'} // 'left';
    if ($align_last eq 'left') {
        $width = $self->text($line, %opts, align => 'left');
    }
    elsif ($align_last eq 'center') {
        $width = $self->text($line, %opts, align => 'center');
    }
    elsif ($align_last eq 'right') {
        $width = $self->text($line, %opts, align => 'right');
    }
    else {
        $self->wordspace(($width - $w) / $space_count) if $space_count;
        $width = $self->text($line, %opts, align => 'left');
        $self->wordspace($ws);
    }
    return $width, $ret;
}

=head2 paragraph

    # Scalar context
    $overflow_text = $content->paragraph($text, $width, $height, %options);

    # Array context
    ($overflow, $height) = $content->paragraph($text, $width, $height, %options);

Fills the rectangle with as much of the provided text as will fit.

In array context, returns the remaining text (if any) of the positioned text and
the remaining (unused) height.  In scalar context, returns the remaining text
(if any).

Line spacing follows L</"leading">, if set, or 120% of the font size by default.

B<Options>

=over

=item * align

Specifies the alignment for each line of text.  May be set to C<left> (default),
C<center>, C<right>, or C<justified>.

=item * align-last

Specifies the alignment for the last line of justified text.  May be set to
C<left> (default), C<center>, C<right>, or C<justified>.

=item * underline

As described in L</"text">.

=back

=cut

sub paragraph {
    my ($self, $text, $width, $height, %opts) = @_;

    # Deprecated options (remove hyphens)
    if (exists $opts{'-align'}) {
        $opts{'align'} //= delete $opts{'-align'};
    }
    if (exists $opts{'-align-last'}) {
        $opts{'align-last'} //= delete $opts{'-align-last'};
    }
    if (exists $opts{'-underline'}) {
        $opts{'underline'} //= delete $opts{'-underline'};
    }

    my $leading = $self->leading();
    unless ($leading) {
        $leading = $self->{' fontsize'} * 1.2;
    }

    # If the text contains newlines, call paragraph on each line
    if ($text =~ /\n/) {
        my $overflow = '';
        foreach my $line (split /\n/, $text) {
            # If there's overflow, no more text can be placed.
            if (length($overflow)) {
                $overflow .= "\n" . $line;
                next;
            }

            # Place a blank line if there are consecutive newlines
            unless (length($line)) {
                $self->crlf();
                $height -= $leading;
                next;
            }

            ($line, $height) = $self->paragraph($line, $width, $height, %opts);
            $overflow .= $line if length($line);
        }

        return ($overflow, $height) if wantarray();
        return $overflow;
    }

    my $w;
    while (length($text) > 0) {
        $height -= $leading;
        last if $height < 0;

        my $align = $opts{'align'} // 'left';
        if ($align eq 'justified' or $align eq 'justify') {
            ($w, $text) = $self->text_fill_justified($text, $width, %opts);
        }
        elsif ($align eq 'right') {
            ($w, $text) = $self->text_fill_right($text, $width, %opts);
        }
        elsif ($align eq 'center') {
            ($w, $text) = $self->text_fill_center($text, $width, %opts);
        }
        else {
            ($w, $text) = $self->text_fill_left($text, $width, %opts);
        }
        $self->crlf();
    }

    return ($text, $height) if wantarray();
    return $text;
}

# Deprecated former name
sub section { return paragraphs(@_) }

# Deprecated; merged into paragraph
sub paragraphs { return paragraph(@_) }

sub textlabel {
    my ($self, $x, $y, $font, $size, $text, %opts, $wht) = @_;
    my %trans_opts = (-translate => [$x,$y]);
    my %text_state;
    $trans_opts{'-rotate'} = $opts{'-rotate'} if $opts{'-rotate'};

    my $wastext = $self->_in_text_object();
    if ($wastext) {
        %text_state = $self->textstate();
        $self->textend();
    }
    $self->save();
    $self->textstart();

    $self->transform(%trans_opts);

    if ($opts{'-color'}) {
        my $color = ref($opts{'-color'}) ? @{$opts{'-color'}} : $opts{'-color'};
        $self->fillcolor($color);
    }
    if ($opts{'-strokecolor'}) {
        my $color = (ref($opts{'-strokecolor'})
                     ? @{$opts{'-strokecolor'}}
                     : $opts{'-strokecolor'});
        $self->strokecolor($color);
    }

    $self->font($font, $size);

    $self->charspace($opts{'-charspace'}) if $opts{'-charspace'};
    $self->hscale($opts{'-hscale'})       if $opts{'-hscale'};
    $self->wordspace($opts{'-wordspace'}) if $opts{'-wordspace'};
    $self->render($opts{'-render'})       if $opts{'-render'};

    my $align = $opts{'-align'} // 'left';
    if ($opts{'-right'} or $align =~ /^r/i) {
        $wht = $self->text_right($text, %opts);
    }
    elsif ($opts{'-center'} or $align =~ /^c/i) {
        $wht = $self->text_center($text, %opts);
    }
    else {
        $wht = $self->text($text, %opts);
    }

    $self->textend();
    $self->restore();

    if ($wastext) {
        $self->textstart();
        $self->textstate(%text_state);
    }
    return $wht;
}

=head2 text_width

    my $width = $content->text_width($line, %overrides);

Returns the width of a line of text based on the current text state attributes.
These can optionally be overridden:

    my $width = $content->text_width($line,
        font => $font,
        size => $size,
        character_spacing => $spacing,
        word_spacing => $spacing,
        hscale => $scale,
    );

=cut

# Deprecated (renamed)
sub advancewidth { return text_width(@_) }

sub text_width {
    my ($self, $text, %opts) = @_;
    return 0 unless defined($text) and length($text);

    # Convert new names to old names
    if (exists $opts{'size'}) {
        $opts{'fontsize'} = delete $opts{'size'};
    }
    if (exists $opts{'character_spacing'}) {
        $opts{'charspace'} = delete $opts{'character_spacing'};
    }
    if (exists $opts{'word_spacing'}) {
        $opts{'charspace'} = delete $opts{'word_spacing'};
    }

    foreach my $k (qw(font fontsize wordspace charspace hscale)) {
        $opts{$k} = $self->{" $k"} unless defined $opts{$k};
    }

    # Width of glyphs
    my $width = $opts{'font'}->width($text) * $opts{'fontsize'};

    # Width of space characters
    my $space_count = $text =~ y/\x20/\x20/;
    $width += $opts{'wordspace'} * $space_count;

    # Width of space between characters
    my $char_count = length($text);
    $width += $opts{'charspace'} * ($char_count - 1);

    # Horizontal scale multiplier
    $width *= $opts{'hscale'} / 100;

    return $width;
}

sub metaStart {
    my ($self, $tag, $obj) = @_;
    $self->add("/$tag");
    if (defined $obj) {
        my $dict = PDFDict();
        $dict->{'Metadata'} = $obj;
        $self->resource('Properties', $obj->name(), $dict);
        $self->add('/' . $obj->name());
        $self->add('BDC');
    }
    else {
        $self->add('BMC');
    }
    return $self;
}

sub metaEnd {
    my $self = shift();
    $self->add('EMC');
    return $self;
}

sub add_post {
    my $self = shift();
    if (@_) {
        unless ($self->{' poststream'} =~ /\s$/) {
            $self->{' poststream'} .= ' ';
        }
        $self->{' poststream'} .= join(' ', @_) . ' ';
    }
    return $self;
}

sub add {
    my $self = shift();
    if (@_) {
        unless ($self->{' stream'} =~ /\s$/) {
            $self->{' stream'} .= ' ';
        }
        $self->{' stream'} .= encode('iso-8859-1', join(' ', @_) . ' ');
    }
    return $self;
}

# Shortcut method for determining if we're inside a text object
# (i.e. between BT and ET).  See textstart and textend.
sub _in_text_object {
    my $self = shift();
    return $self->{' apiistext'};
}

sub compressFlate {
    my $self = shift();
    $self->{'Filter'} = PDFArray(PDFName('FlateDecode'));
    $self->{'-docompress'} = 1;
    return $self;
}

sub textstart {
    my $self = shift();
    unless ($self->_in_text_object()) {
        $self->add(' BT ');
        $self->{' apiistext'} = 1;
        $self->{' font'} = undef;
        $self->{' fontset'} = 0;
        $self->{' fontsize'} = 0;
        $self->{' charspace'} = 0;
        $self->{' hscale'} = 100;
        $self->{' wordspace'} = 0;
        $self->{' leading'} = 0;
        $self->{' rise'} = 0;
        $self->{' render'} = 0;
        $self->{' textlinestart'} = 0;
        @{$self->{' matrix'}} = (1, 0, 0, 1, 0, 0);
        @{$self->{' textmatrix'}} = (1, 0, 0, 1, 0, 0);
        @{$self->{' textlinematrix'}} = (0, 0);
        @{$self->{' fillcolor'}} = 0;
        @{$self->{' strokecolor'}} = 0;
        @{$self->{' translate'}} = (0, 0);
        @{$self->{' scale'}} = (1, 1);
        @{$self->{' skew'}} = (0, 0);
        $self->{' rotate'} = 0;
    }
    return $self;
}

sub textend {
    my $self = shift();
    if ($self->_in_text_object()) {
        $self->add(' ET ', $self->{' poststream'});
        $self->{' apiistext'} = 0;
        $self->{' poststream'} = '';
    }
    return $self;
}

sub resource {
    my ($self, $type, $key, $obj, $force) = @_;
    if ($self->{' apipage'}) {
        # we are a content stream on a page.
        return $self->{' apipage'}->resource($type, $key, $obj, $force);
    }
    else {
        # we are a self-contained content stream.
        $self->{'Resources'} //= PDFDict();

        my $dict = $self->{'Resources'};
        $dict->realise() if ref($dict) =~ /Objind$/;

        $dict->{$type} ||= PDFDict();
        $dict->{$type}->realise() if ref($dict->{$type}) =~ /Objind$/;
        unless (defined $obj) {
            return $dict->{$type}->{$key};
        }
        else {
            if ($force) {
                $dict->{$type}->{$key} = $obj;
            }
            else {
                $dict->{$type}->{$key} //= $obj;
            }
            return $dict;
        }
    }
}

=head1 MIGRATION

See L<PDF::API2/"MIGRATION"> for an overview.

=over

=item transform(%hyphen_prefixed_options);

Remove hyphens from option names (C<-translate> becomes C<translate>, etc.).

=item transform_rel

Replace with L</"transform">, setting option C<repeat> to true.  Remove
hyphens from the names of other options.

=item linewidth

Replace with L</"line_width">.

=item linecap

Replace with L</"line_cap">.

=item linejoin

Replace with L</"line_join">.

=item meterlimit

=item miterlimit

Replace with L</"miter_limit">.

=item linedash

Replace with L</"line_dash_pattern">.  Remove hyphens from option names.  Rename
C<-shift> to C<offset>.

=item flatness

Replace with L</"flatness_tolerance">.

=item poly

Replace with L</"move"> (first two arguments) and L</"polyline"> (remaining
arguments).

=item endpath

Replace with L</"end">.

=item rect

Replace with L</"rectangle">, converting the C<$w> (third) and C<$h> (fourth)
arguments to the X and Y values of the upper-right corner:

    # Old
    $content->rect($x, $y, $w, $h);

    # New
    $content->rectangle($x, $y, $x + $w, $y + $h);

=item rectxy

Replace with L</"rectangle">.

=item fill(1)

Replace with C<$content-E<gt>fill(rule =E<gt> 'even-odd')>.

=item fillstroke

Replace with L</"paint">.

=item clip(1)

Replace with C<$content-E<gt>clip(rule =E<gt> 'even-odd')>.

=item image

=item formimage

Replace with L</"object">.

=item charspace

Replace with L</"character_spacing">.

=item wordspace

Replace with L</"word_spacing">.

=item hspace

Replace with L</"hscale">.

=item lead

Replace with L</"leading">.

=item distance

Replace with L</"position">.

=item cr

Replace with either L</"position"> (if called with arguments) or L</"crlf"> (if
called without arguments).

=item nl

Replace with L</"crlf">.

=item text(%hyphen_prefixed_options)

Remove initial hyphens from option names.

=item text_center

Replace with L</"text">, setting C<align> to C<center>.

=item text_right

Replace with L</"text">, setting C<align> to C<right>.

=item paragraph(%hyphen_prefixed_options)

Remove initial hyphens from option names.  C<-align-last> becomes C<align-last>.

=item section

=item paragraphs

Replace with L</"paragraph">.

=item advancewidth

Replace with L</"text_width">.

=back

=cut

1;
