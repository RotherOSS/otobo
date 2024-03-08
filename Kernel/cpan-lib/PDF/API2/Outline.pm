package PDF::API2::Outline;

use base 'PDF::API2::Basic::PDF::Dict';

use strict;
use warnings;

our $VERSION = '2.045'; # VERSION

use Carp qw(croak);
use PDF::API2::Basic::PDF::Utils;
use Scalar::Util qw(weaken);

=head1 NAME

PDF::API2::Outline - Manage PDF outlines (a.k.a. bookmarks)

=head1 SYNOPSIS

    # Get/create the top-level outline tree
    my $outline = $pdf->outline();

    # Add an entry
    my $item = $outline->outline();
    $item->title('First Page');
    $item->destination($pdf->open_page(1));

=head1 METHODS

=cut

sub new {
    my ($class, $api, $parent, $prev) = @_;
    my $self = $class->SUPER::new();
    $self->{'Parent'} = $parent if defined $parent;
    $self->{'Prev'}   = $prev   if defined $prev;
    $self->{' api'}   = $api;
    weaken $self->{' api'};
    weaken $self->{'Parent'};
    return $self;
}

=head2 Examine the Outline Tree

=head3 has_children

    my $boolean = $outline->has_children();

Return true if the current outline item has child items.

=cut

sub has_children {
    my $self = shift();

    # Opened by PDF::API2
    return 1 if exists $self->{'First'};

    # Created by PDF::API2
    return @{$self->{' children'}} > 0 if exists $self->{' children'};

    return;
}

=head3 count

    my $integer = $outline->count();

Return the number of descendants that are visible when the current outline item
is open (expanded).

=cut

sub count {
    my $self = shift();

    # Set count to the number of descendant items that will be visible when the
    # current item is open.
    my $count = 0;
    if ($self->has_children()) {
        $self->_load_children() unless exists $self->{' children'};
        $count += @{$self->{' children'}};
        foreach my $child (@{$self->{' children'}}) {
            next unless $child->has_children();
            next unless $child->is_open();
            $count += $child->count();
        }
    }

    if ($count) {
        $self->{'Count'} = PDFNum($self->is_open() ? $count : -$count);
    }

    return $count;
}

sub _load_children {
    my $self = shift();
    my $item = $self->{'First'};
    return unless $item;
    $item->realise();
    bless $item, __PACKAGE__;

    push @{$self->{' children'}}, $item;
    while ($item->next()) {
        $item = $item->next();
        $item->realise();
        bless $item, __PACKAGE__;
        push @{$self->{' children'}}, $item;
    }
    return $self;
}

=head3 first

    my $child = $outline->first();

Return the first child of the current outline level, if one exists.

=cut

sub first {
    my $self = shift();
    if (defined $self->{' children'} and defined $self->{' children'}->[0]) {
        $self->{'First'} = $self->{' children'}->[0];
    }
    return $self->{'First'};
}

=head3 last

    my $child = $outline->last();

Return the last child of the current outline level, if one exists.

=cut

sub last {
    my $self = shift();
    if (defined $self->{' children'} and defined $self->{' children'}->[-1]) {
        $self->{'Last'} = $self->{' children'}->[-1];
    }
    return $self->{'Last'};
}

=head3 parent

    my $parent = $outline->parent();

Return the parent of the current item, if not at the top level of the outline
tree.

=cut

sub parent {
    my $self = shift();
    $self->{'Parent'} = shift() if defined $_[0];
    return $self->{'Parent'};
}

=head3 prev

    my $sibling = $outline->prev();

Return the previous item of the current level of the outline tree.

=cut

sub prev {
    my $self = shift();
    $self->{'Prev'} = shift() if defined $_[0];
    return $self->{'Prev'};
}

=head3 next

    my $sibling = $outline->next();

Return the next item of the current level of the outline tree.

=cut

sub next {
    my $self = shift();
    $self->{'Next'} = shift() if defined $_[0];
    return $self->{'Next'};
}

=head2 Modify the Outline Tree

=head3 outline

    my $child = $outline->outline();

Add an outline item at the end of the current outline's list of children.

=cut

sub outline {
    my $self = shift();

    my $child = PDF::API2::Outline->new($self->{' api'}, $self);
    $self->{' children'} //= [];
    $child->prev($self->{' children'}->[-1]) if @{$self->{' children'}};
    $self->{' children'}->[-1]->next($child) if @{$self->{' children'}};
    push @{$self->{' children'}}, $child;
    unless ($child->is_obj($self->{' api'}->{'pdf'})) {
        $self->{' api'}->{'pdf'}->new_obj($child);
    }

    return $child;
}

=head3 insert_after

    my $sibling = $outline->insert_after();

Add an outline item immediately following the current item.

=cut

sub insert_after {
    my $self = shift();

    my $sibling = PDF::API2::Outline->new($self->{' api'}, $self->parent());
    $sibling->next($self->next());
    $self->next->prev($sibling) if $self->next();
    $self->next($sibling);
    $sibling->prev($self);
    unless ($sibling->is_obj($self->{' api'}->{'pdf'})) {
        $self->{' api'}->{'pdf'}->new_obj($sibling);
    }
    $self->parent->_reset_children();
    return $sibling;
}

=head3 insert_before

    $sibling = $outline->insert_before();

Add an outline item immediately preceding the current item.

=cut

sub insert_before {
    my $self = shift();

    my $sibling = PDF::API2::Outline->new($self->{' api'}, $self->parent());
    $sibling->prev($self->prev());
    $self->prev->next($sibling) if $self->prev();
    $self->prev($sibling);
    $sibling->next($self);
    unless ($sibling->is_obj($self->{' api'}->{'pdf'})) {
        $self->{' api'}->{'pdf'}->new_obj($sibling);
    }
    $self->parent->_reset_children();
    return $sibling;
}

sub _reset_children {
    my $self = shift();
    my $item = $self->first();
    $self->{' children'} = [];
    return unless $item;

    push @{$self->{' children'}}, $item;
    while ($item->next()) {
        $item = $item->next();
        push @{$self->{' children'}}, $item;
    }
    return $self;
}

=head3 delete

    $outline->delete();

Remove the current outline item from the outline tree.  If the item has any
children, they will effectively be deleted as well since they will no longer be
linked.

=cut

sub delete {
    my $self = shift();

    my $prev = $self->prev();
    my $next = $self->next();
    $prev->next($next) if defined $prev;
    $next->prev($prev) if defined $next;

    my $siblings = $self->parent->{' children'};
    @$siblings = grep { $_ ne $self } @$siblings;
    delete $self->parent->{' children'} unless $self->parent->has_children();

    return;
}

=head3 is_open

    # Get
    my $boolean = $outline->is_open();

    # Set
    my $outline = $outline->is_open($boolean);

Get/set whether the outline is expanded or collapsed.

=cut

sub is_open {
    my $self = shift();

    # Get
    unless (@_) {
        # Created by PDF::API2
        return $self->{' closed'} ? 0 : 1 if exists $self->{' closed'};

        # Opened by PDF::API2
        return $self->{'Count'}->val() > 0 if exists $self->{'Count'};

        # Default
        return 1;
    }

    # Set
    my $is_open = shift();
    $self->{' closed'} = (not $is_open);

    return $self;
}

# Deprecated
sub open {
    my $self = shift();
    return $self->is_open(1);
}

# Deprecated
sub closed {
    my $self = shift();
    return $self->is_open(0);
}

=head2 Set Outline Attributes

=head3 title

    # Get
    my $title = $outline->title();

    # Set
    $outline = $outline->title($text);

Get/set the title of the outline item.

=cut

sub title {
    my $self = shift();

    # Get
    unless (@_) {
        return unless $self->{'Title'};
        return $self->{'Title'}->val();
    }

    # Set
    my $text = shift();
    $self->{'Title'} = PDFStr($text);
    return $self;
}

=head3 destination

    $outline = $outline->destination($destination, $location, @args);

Set the destination page and optional position of the outline.  C<$location> and
C<@args> are as defined in L<PDF::API2::NamedDestination/"destination">.

C<$destination> can optionally be the name of a named destination defined
elsewhere.

=cut

sub _destination {
    require PDF::API2::NamedDestination;
    return PDF::API2::NamedDestination::_destination(@_);
}

sub destination {
    my ($self, $destination, $location, @args) = @_;

    # Remove an existing action dictionary
    delete $self->{'A'};

    if (ref($destination)) {
        # Page Destination
        $self->{'Dest'} = _destination($destination, $location, @args);
    }
    else {
        # Named Destination
        $self->{'Dest'} = PDFStr($destination);
    }

    return $self;
}

# Deprecated: Use destination with the indicated changes
sub dest {
    my ($self, $destination, $location, @args) = @_;

    # Replace -fit => 1 or -fitb => 1 with just the location
    if (defined $location) {
        @args = () if $location eq '-fit' or $location eq '-fitb';
    }

    # Convert args from arrayref to array
    @args = @{$args[0]} if @args and ref($args[0]) eq 'ARRAY';

    # Remove hyphen prefix from location
    $location =~ s/^-// if defined $location;

    return $self->destination($destination, $location, @args);
}

=head3 uri

    $outline = $outline->uri($uri);

Launch a URI -- typically a web page -- when the outline item is activated.

=cut

# Deprecated (renamed)
sub url { return uri(@_) }

sub uri {
    my ($self, $uri) = @_;
    delete $self->{'Dest'};

    $self->{'A'}          = PDFDict();
    $self->{'A'}->{'S'}   = PDFName('URI');
    $self->{'A'}->{'URI'} = PDFStr($uri);

    return $self;
}

=head3 launch

    $outline->launch($file);

Launch an application or file when the outline item is activated.

=cut

# Deprecated (renamed)
sub file { return launch(@_) }

sub launch {
    my ($self, $file) = @_;
    delete $self->{'Dest'};

    $self->{'A'}        = PDFDict();
    $self->{'A'}->{'S'} = PDFName('Launch');
    $self->{'A'}->{'F'} = PDFStr($file);

    return $self;
}

=head3 pdf

    $outline = $outline->pdf($filename, $page_number, $location, @args);

Open another PDF file to a particular page number (first page is zero, which is
also the default).  The page can optionally be positioned at a particular
location if C<$location> and C<@args> are set -- see
L<PDF::API2::NamedDestination/"destination"> for possible settings.

=cut

# Deprecated (renamed)
sub pdfile { return pdf_file(@_) }

# Deprecated; use pdf instead, with the indicated changes
sub pdf_file {
    my ($self, $file, $page_number, $location, @args);

    # Replace -fit => 1 or -fitb => 1 with just the location
    if (defined $location) {
        @args = () if $location eq '-fit' or $location eq '-fitb';
    }

    # Convert args from arrayref to array
    @args = @{$args[0]} if @args and ref($args[0]) eq 'ARRAY';

    # Remove hyphen prefix from location
    $location =~ s/^-// if defined $location;

    return $self->pdf($file, $page_number, $location, @args);
}

sub pdf {
    my ($self, $file, $page_number, $location, @args) = @_;
    $page_number //= 0;
    delete $self->{'Dest'};

    $self->{'A'}        = PDFDict();
    $self->{'A'}->{'S'} = PDFName('GoToR');
    $self->{'A'}->{'F'} = PDFStr($file);

    $self->{'A'}->{'D'} = _destination(PDFNum($page_number), $location, @args);

    return $self;
}

sub fix_outline {
    my $self = shift();
    $self->first();
    $self->last();
    $self->count();
}

sub outobjdeep {
    my $self = shift();
    $self->fix_outline();
    return $self->SUPER::outobjdeep(@_);
}

1;
