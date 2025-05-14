package PDF::API2::NamedDestination;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp;
use Encode qw(:all);

use PDF::API2::Util;
use PDF::API2::Basic::PDF::Utils;

=head1 NAME

PDF::API2::NamedDestination - Add named destinations (views) to a PDF

=head1 METHODS

=head2 new

    $destination = PDF::API2::NamedDestination->new($pdf, ...);

Creates a new named destination object.  If any additional arguments are
present, they will be passed to C<destination()>.

=cut

sub new {
    my $class = shift();
    my $pdf = shift();
    $pdf = $pdf->{'pdf'} if $pdf->isa('PDF::API2');

    my $self = $class->SUPER::new($pdf);
    $pdf->new_obj($self);

    if (@_) {
        return $self->destination(@_);
    }

    return $self;
}

# Deprecated (warning added in 2.031)
sub new_api {
    my ($class, $api2) = @_;
    warnings::warnif('deprecated',
                     'Call to deprecated method new_api; replace with new');

    my $destination = $class->new($api2);
    return $destination;
}

=head2 destination

    $destination = $destination->destination($page, $location, @args);

A destination is a particular view of a PDF, consisting of a page object, the
location of the window on that page, and possible coordinate and zoom arguments.

    # The XYZ location takes three arguments
    my $dest1 = PDF::API2::NamedDestination->new($pdf);
    $dest->destination($pdf->open_page(1), 'xyz' => ($x, $y, $zoom));

    # The Fit location doesn't require any arguments
    my $dest2 = PDF::API2::NamedDestination->new($pdf);
    $dest->destination($pdf->open_page(2), 'fit');

The following locations are available:

=over

=item * xyz ($left, $top, $zoom)

Display the page with the coordinates (C<$left>, C<$top>) positioned at the
upper-left corner of the window and the contents of the page magnified by the
factor C<$zoom>. An C<undef> value for any of the arguments specifies that the
current value of that argument shall be retained unchanged.  A zoom factor of 0
has the same meaning as C<undef>.

=item * fit

Display the page with its contents magnified just enough to fit the entire page
within the window both horizontally and vertically. If the required horizontal
and vertical magnification factors are different, use the smaller of the two,
centering the page within the window in the other dimension.

=item * fith ($top)

Display the page with the vertical coordinate C<$top> positioned at the top edge
of the window and the contents of the page magnified just enough to fit the
entire width of the page within the window.  An C<undef> value for C<$top>
specifies that the current value of that argument shall be retained unchanged.

=item * fitv ($left)

Display the page with the horizontal coordinate C<$left> positioned at the left
edge of the window and the contents of the page magnified just enough to fit the
entire height of the page within the window.  An C<undef> value for C<$left>
specifies that the current value of that argument shall be retained unchanged.

=item * fitr ($left, $bottom, $right, $top)

Display the page with its contents magnified just enough to fit the rectangle
specified by the coordinates C<$left>, C<$bottom>, C<$right>, and C<$top>
entirely within the window both horizontally and vertically. If the required
horizontal and vertical magnification factors are different, use the smaller of
the two, centering the rectangle within the window in the other dimension.

=item * fitb

Display the page with its contents magnified just enough to fit its bounding box
entirely within the window both horizontally and vertically. If the required
horizontal and vertical magnification factors are different, use the smaller of
the two, centering the bounding box within the window in the other dimension.

=item * fitbh ($top)

Display the page with the vertical coordinate C<$top> positioned at the top edge
of the window and the contents of the page magnified just enough to fit the
entire width of its bounding box within the window.  An C<undef> value for
C<$top> specifies that the current value of that argument shall be retained
unchanged.

=item * fitbv ($left)

Display the page with the horizontal coordinate C<$left> positioned at the left
edge of the window and the contents of the page magnified just enough to fit the
entire height of its bounding box within the window.  An C<undef> value for
C<$left> specifies that the current value of that argument shall be retained
unchanged.

=back

=cut

sub _array {
    my $page = shift();
    my $location = shift();
    return PDFArray($page, PDFName($location),
                    map { defined($_) ? PDFNum($_) : PDFNull() } @_);
}

sub _destination {
    my ($page, $location, @args) = @_;
    return _array($page, 'XYZ', undef, undef, undef) unless $location;

    my %arg_counts = (
        xyz   => 3,
        fit   => 0,
        fith  => 1,
        fitv  => 1,
        fitr  => 4,
        fitb  => 0,
        fitbh => 1,
        fitbv => 1,
    );
    my $arg_count = $arg_counts{$location};
    croak "Invalid location $location" unless defined $arg_count;

    if ($arg_count == 0 and @args) {
        croak "$location doesn't take any arguments";
    }
    elsif ($arg_count == 1 and @args != 1) {
        croak "$location requires one argument";
    }
    elsif ($arg_count == 3 and @args != 3) {
        croak "$location requires three arguments";
    }
    elsif ($arg_count == 4 and @args != 4) {
        croak "$location requires four arguments";
    }

    return _array($page, 'XYZ', @args) if $location eq 'xyz';
    $location =~ s/^fit(.*)$/'Fit' . uc($1 or '')/e;
    return _array($page, $location, @args);
}

sub destination {
    my ($self, $page, $location, @args) = @_;
    $self->{'D'} = _destination($page, $location, @args);
    return $self;
}

# Deprecated; use destination instead, removing hyphen from location name
sub dest {
    my ($self, $page, %opts) = @_;

    if (ref($page)) {
        $opts{'-xyz'} = [undef, undef, undef] unless keys %opts;

        if (defined $opts{'-fit'}) {
            $self->{'D'} = _destination($page, 'fit');
        }
        elsif (defined $opts{'-fith'}) {
            $self->{'D'} = _destination($page, 'fith', $opts{'-fith'});
        }
        elsif (defined $opts{'-fitb'}) {
            $self->{'D'} = _destination($page, 'fitb');
        }
        elsif (defined $opts{'-fitbh'}) {
            $self->{'D'} = _destination($page, 'fitbh', $opts{'-fitbh'});
        }
        elsif (defined $opts{'-fitv'}) {
            $self->{'D'} = _destination($page, 'fitv', $opts{'-fitv'});
        }
        elsif (defined $opts{'-fitbv'}) {
            $self->{'D'} = _destination($page, 'fitbv', $opts{'-fitbv'});
        }
        elsif (defined $opts{'-fitr'}) {
            $self->{'D'} = _destination($page, 'fitr', @{$opts{'-fitr'}});
        }
        elsif (defined $opts{'-xyz'}) {
            $self->{'D'} = _destination($page, 'xyz', @{$opts{'-xyz'}});
        }
    }

    return $self;
}

=head2 goto

    $destination = $destination->goto($page, $location, @args);

A go-to action changes the view to a specified destination (page, location, and
magnification factor).

Parameters are as described in C<destination>.

=cut

sub goto {
    my $self = shift();
    $self->{'S'} = PDFName('GoTo');
    return $self->destination(@_);
}

# Deprecated; use goto instead, removing hyphen from location name
sub link {
    my $self = shift();
    $self->{'S'} = PDFName('GoTo');
    return $self->dest(@_);
}

=head2 uri

    $destination = $destination->uri($uri);

A URI action indicates that a URI -- typically a web page -- should be launched.

=cut

# Deprecated (renamed)
sub url { return uri(@_) }

sub uri {
    my ($self, $uri) = @_;

    $self->{'S'} = PDFName('URI');
    $self->{'URI'} = PDFStr($uri);

    return $self;
}

=head2 launch

    $destination = $destination->launch($file);

A launch action runs an application or opens or prints a document.

C<$file> contains the path to the application to be launched or the document to
be opened or printed.

=cut

# Deprecated (renamed)
sub file { return launch(@_) }

sub launch {
    my ($self, $file) = @_;

    $self->{'S'} = PDFName('Launch');
    $self->{'F'} = PDFStr($file);

    return $self;
}

=head2 pdf

    $destination = $destination->pdf($file, $page_number, $location, @args);

Similar to C<goto>, but the destination is in a different PDF file located at
C<$file>.  C<$page_number> is an integer rather than a page object, and the
other parameters are as described in C<destination>.

=cut

sub pdf {
    my ($self, $file, $page_number, $location, @args) = @_;

    $self->{'S'} = PDFName('GoToR');
    $self->{'F'} = PDFStr($file);

    return $self->destination(PDFNum($page_number), $location, @args);
}

# Deprecated; use pdf instead, removing hyphen from location name
sub pdfile {
    my ($self, $file, $page_number, @args) = @_;

    $self->{'S'} = PDFName('GoToR');
    $self->{'F'} = PDFStr($file);

    return $self->dest(PDFNum($page_number), @args);
}

1;
