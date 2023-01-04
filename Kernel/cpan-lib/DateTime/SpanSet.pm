# Copyright (c) 2003 Flavio Soibelmann Glock. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package DateTime::SpanSet;

use strict;

use DateTime::Set;
use DateTime::Infinite;

use Carp;
use Params::Validate qw( validate SCALAR BOOLEAN OBJECT CODEREF ARRAYREF );
use vars qw( $VERSION );

use constant INFINITY     =>       100 ** 100 ** 100 ;
use constant NEG_INFINITY => -1 * (100 ** 100 ** 100);
$VERSION = $DateTime::Set::VERSION;

sub iterate {
    my ( $self, $callback ) = @_;
    my $class = ref( $self );
    my $return = $class->empty_set;
    $return->{set} = $self->{set}->iterate(
        sub {
            my $span = bless { set => $_[0] }, 'DateTime::Span';
            $callback->( $span->clone );
            $span = $span->{set} 
                if UNIVERSAL::can( $span, 'union' );
            return $span;
        }
    );
    $return;
}

sub map {
    my ( $self, $callback ) = @_;
    my $class = ref( $self );
    die "The callback parameter to map() must be a subroutine reference"
        unless ref( $callback ) eq 'CODE';
    my $return = $class->empty_set;
    $return->{set} = $self->{set}->iterate( 
        sub {
            local $_ = bless { set => $_[0]->clone }, 'DateTime::Span';
            my @list = $callback->();
            my $set = $class->empty_set;
            $set = $set->union( $_ ) for @list;
            return $set->{set};
        }
    );
    $return;
}

sub grep {
    my ( $self, $callback ) = @_;
    my $class = ref( $self );
    die "The callback parameter to grep() must be a subroutine reference"
        unless ref( $callback ) eq 'CODE';
    my $return = $class->empty_set;
    $return->{set} = $self->{set}->iterate( 
        sub {
            local $_ = bless { set => $_[0]->clone }, 'DateTime::Span';
            my $result = $callback->();
            return $_->{set} if $result && $_;
            return;
        }
    );
    $return;
}

sub set_time_zone {
    my ( $self, $tz ) = @_;

    # TODO - use iterate() instead 

    my $result = $self->{set}->iterate( 
        sub {
            my %tmp = %{ $_[0]->{list}[0] };
            $tmp{a} = $tmp{a}->clone->set_time_zone( $tz ) if ref $tmp{a};
            $tmp{b} = $tmp{b}->clone->set_time_zone( $tz ) if ref $tmp{b};
            \%tmp;
        },
        backtrack_callback => sub {
            my ( $min, $max ) = ( $_[0]->min, $_[0]->max );
            if ( ref($min) )
            {
                $min = $min->clone;
                $min->set_time_zone( 'floating' );
            }
            if ( ref($max) )
            {
                $max = $max->clone;
                $max->set_time_zone( 'floating' ); 
            }
            return Set::Infinite::_recurrence->new( $min, $max );
        },
    );

    ### this code enables 'subroutine method' behaviour
    $self->{set} = $result;
    return $self;
}

sub from_spans {
    my $class = shift;
    my %args = validate( @_,
                         { spans =>
                           { type => ARRAYREF,
                             optional => 1,
                           },
                         }
                       );
    my $self = {};
    my $set = Set::Infinite::_recurrence->new();
    $set = $set->union( $_->{set} ) for @{ $args{spans} };
    $self->{set} = $set;
    bless $self, $class;
    return $self;
}

sub from_set_and_duration {
    # set => $dt_set, days => 1
    my $class = shift;
    my %args = @_;
    my $set = delete $args{set} || 
        carp "from_set_and_duration needs a 'set' parameter";

    $set = $set->as_set
        if UNIVERSAL::can( $set, 'as_set' );
    unless ( UNIVERSAL::can( $set, 'union' ) ) {
        carp "'set' must be a set" };

    my $duration = delete $args{duration} ||
                   new DateTime::Duration( %args );
    my $end_set = $set->clone->add_duration( $duration );
    return $class->from_sets( start_set => $set, 
                              end_set =>   $end_set );
}

sub from_sets {
    my $class = shift;
    my %args = validate( @_,
                         { start_set =>
                           { # can => 'union',
                             optional => 0,
                           },
                           end_set =>
                           { # can => 'union',
                             optional => 0,
                           },
                         }
                       );
    my $start_set = delete $args{start_set};
    my $end_set   = delete $args{end_set};

    $start_set = $start_set->as_set
        if UNIVERSAL::can( $start_set, 'as_set' );
    $end_set = $end_set->as_set
        if UNIVERSAL::can( $end_set, 'as_set' );

    unless ( UNIVERSAL::can( $start_set, 'union' ) ) {
        carp "'start_set' must be a set" };
    unless ( UNIVERSAL::can( $end_set, 'union' ) ) {
        carp "'end_set' must be a set" };

    my $self;
    $self->{set} = $start_set->{set}->until( 
                   $end_set->{set} );
    bless $self, $class;
    return $self;
}

sub start_set {
    if ( exists $_[0]->{set}{method} &&
         $_[0]->{set}{method} eq 'until' )
    {
        return bless { set => $_[0]->{set}{parent}[0] }, 'DateTime::Set';
    }
    my $return = DateTime::Set->empty_set;
    $return->{set} = $_[0]->{set}->start_set;
    $return;
}

sub end_set {
    if ( exists $_[0]->{set}{method} &&
         $_[0]->{set}{method} eq 'until' )
    {
        return bless { set => $_[0]->{set}{parent}[1] }, 'DateTime::Set';
    }
    my $return = DateTime::Set->empty_set;
    $return->{set} = $_[0]->{set}->end_set;
    $return;
}

sub empty_set {
    my $class = shift;

    return bless { set => Set::Infinite::_recurrence->new }, $class;
}

sub is_empty_set {
    my $set = $_[0];
    $set->{set}->is_null;
}

sub clone { 
    bless { 
        set => $_[0]->{set}->copy,
        }, ref $_[0];
}


sub iterator {
    my $self = shift;

    my %args = @_;
    my $span;
    $span = delete $args{span};
    $span = DateTime::Span->new( %args ) if %args;

    return $self->intersection( $span ) if $span;
    return $self->clone;
}


# next() gets the next element from an iterator()
sub next {
    my ($self) = shift;

    # TODO: this is fixing an error from elsewhere
    # - find out what's going on! (with "sunset.pl")
    return undef unless ref $self->{set};

    if ( @_ )
    {
        my $max;
        $max = $_[0]->max if UNIVERSAL::can( $_[0], 'union' );
        $max = $_[0] if ! defined $max;

        return undef if ! ref( $max ) && $max == INFINITY;

        my $span = DateTime::Span->from_datetimes( start => $max );
        my $iterator = $self->intersection( $span );
        my $return = $iterator->next;

        return $return if ! defined $return;
        return $return if ! $return->intersects( $max );

        return $iterator->next;
    }

    my ($head, $tail) = $self->{set}->first;
    $self->{set} = $tail;
    return $head unless ref $head;
    my $return = {
        set => $head,
    };
    bless $return, 'DateTime::Span';
    return $return;
}

# previous() gets the last element from an iterator()
sub previous {
    my ($self) = shift;

    return undef unless ref $self->{set};

    if ( @_ )
    {
        my $min;
        $min = $_[0]->min if UNIVERSAL::can( $_[0], 'union' );
        $min = $_[0] if ! defined $min;

        return undef if ! ref( $min ) && $min == INFINITY;

        my $span = DateTime::Span->from_datetimes( end => $min );
        my $iterator = $self->intersection( $span );
        my $return = $iterator->previous;

        return $return if ! defined $return;
        return $return if ! $return->intersects( $min );

        return $iterator->previous;
    }

    my ($head, $tail) = $self->{set}->last;
    $self->{set} = $tail;
    return $head unless ref $head;
    my $return = {
        set => $head,
    };
    bless $return, 'DateTime::Span';
    return $return;
}

# "current" means less-or-equal to a DateTime
sub current {
    my $self = shift;

    my $previous;
    my $next;
    {
        my $min;
        $min = $_[0]->min if UNIVERSAL::can( $_[0], 'union' );
        $min = $_[0] if ! defined $min;
        return undef if ! ref( $min ) && $min == INFINITY;
        my $span = DateTime::Span->from_datetimes( end => $min );
        my $iterator = $self->intersection( $span );
        $previous = $iterator->previous;
        $span = DateTime::Span->from_datetimes( start => $min );
        $iterator = $self->intersection( $span );
        $next = $iterator->next;
    }
    return $previous unless defined $next;

    my $dt1 = defined $previous
        ? $next->union( $previous )
        : $next;

    my $return = $dt1->intersected_spans( $_[0] );

    $return = $previous
        if !defined $return->max;

    bless $return, 'DateTime::SpanSet'
        if defined $return;
    return $return;
}

sub closest {
    my $self = shift;
    my $dt = shift;

    my $dt1 = $self->current( $dt );
    my $dt2 = $self->next( $dt );
    bless $dt2, 'DateTime::SpanSet' 
        if defined $dt2;

    return $dt2 unless defined $dt1;
    return $dt1 unless defined $dt2;

    $dt = DateTime::Set->from_datetimes( dates => [ $dt ] )
        unless UNIVERSAL::can( $dt, 'union' );

    return $dt1 if $dt1->contains( $dt );

    my $delta = $dt->min - $dt1->max;
    return $dt1 if ( $dt2->min - $delta ) >= $dt->max;

    return $dt2;
}

sub as_list {
    my $self = shift;
    return undef unless ref( $self->{set} );

    my %args = @_;
    my $span;
    $span = delete $args{span};
    $span = DateTime::Span->new( %args ) if %args;

    my $set = $self->clone;
    $set = $set->intersection( $span ) if $span;

    # Note: removing this line means we may end up in an infinite loop!
    return undef if $set->{set}->is_too_complex;  # undef = no start/end

    # return if $set->{set}->is_null;  # nothing = empty
    my @result;
    # we should extract _copies_ of the set elements,
    # such that the user can't modify the set indirectly

    my $iter = $set->iterator;
    while ( my $dt = $iter->next )
    {
        push @result, $dt
            if ref( $dt );   # we don't want to return INFINITY value
    };

    return @result;
}

# Set::Infinite methods

sub intersection {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    my $tmp = $class->empty_set();
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2, @_ ] ) 
        unless $set2->can( 'union' );
    $tmp->{set} = $set1->{set}->intersection( $set2->{set} );
    return $tmp;
}

sub intersected_spans {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    my $tmp = $class->empty_set();
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2, @_ ] )
        unless $set2->can( 'union' );
    $tmp->{set} = $set1->{set}->intersected_spans( $set2->{set} );
    return $tmp;
}

sub intersects {
    my ($set1, $set2) = ( shift, shift );
    
    unless ( $set2->can( 'union' ) )
    {
        for ( $set2, @_ )
        {
            return 1 if $set1->contains( $_ );
        }
        return 0;
    }
    
    my $class = ref($set1);
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2, @_ ] ) 
        unless $set2->can( 'union' );
    return $set1->{set}->intersects( $set2->{set} );
}

sub contains {
    my ($set1, $set2) = ( shift, shift );
    
    unless ( $set2->can( 'union' ) )
    {
        if ( exists $set1->{set}{method} &&
             $set1->{set}{method} eq 'until' )
        {
            my $start_set = $set1->start_set;
            my $end_set =   $set1->end_set;

            for ( $set2, @_ )
            {
                my $start = $start_set->next( $set2 );
                my $end =   $end_set->next( $set2 );

                goto ABORT unless defined $start && defined $end;
            
                return 0 if $start < $end;
            }
            return 1;

            ABORT: ;
            # don't know 
        }
    }
    
    my $class = ref($set1);
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2, @_ ] ) 
        unless $set2->can( 'union' );
    return $set1->{set}->contains( $set2->{set} );
}

sub union {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    my $tmp = $class->empty_set();
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2, @_ ] ) 
        unless $set2->can( 'union' );
    $tmp->{set} = $set1->{set}->union( $set2->{set} );
    return $tmp;
}

sub complement {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    my $tmp = $class->empty_set();
    if (defined $set2) {
        $set2 = $set2->as_spanset
            if $set2->can( 'as_spanset' );
        $set2 = $set2->as_set
            if $set2->can( 'as_set' );
        $set2 = DateTime::Set->from_datetimes( dates => [ $set2, @_ ] ) 
            unless $set2->can( 'union' );
        $tmp->{set} = $set1->{set}->complement( $set2->{set} );
    }
    else {
        $tmp->{set} = $set1->{set}->complement;
    }
    return $tmp;
}

sub start {
    return DateTime::Set::_fix_datetime( $_[0]->{set}->min );
}

*min = \&start;

sub end { 
    return DateTime::Set::_fix_datetime( $_[0]->{set}->max );
}

*max = \&end;

# returns a DateTime::Span
sub span { 
    my $set = $_[0]->{set}->span;
    my $self = bless { set => $set }, 'DateTime::Span';
    return $self;
}

# returns a DateTime::Duration
sub duration { 
    my $dur; 

    return DateTime::Duration->new( seconds => 0 ) 
        if $_[0]->{set}->is_empty;

    local $@;
    eval { 
        local $SIG{__DIE__};   # don't want to trap this (rt ticket 5434)
        $dur = $_[0]->{set}->size 
    };

    return $dur if defined $dur && ref( $dur );
    return DateTime::Infinite::Future->new -
           DateTime::Infinite::Past->new;
    # return INFINITY;
}
*size = \&duration;

1;

__END__

=head1 NAME

DateTime::SpanSet - set of DateTime spans

=head1 SYNOPSIS

    $spanset = DateTime::SpanSet->from_spans( spans => [ $dt_span, $dt_span ] );

    $set = $spanset->union( $set2 );         # like "OR", "insert", "both"
    $set = $spanset->complement( $set2 );    # like "delete", "remove"
    $set = $spanset->intersection( $set2 );  # like "AND", "while"
    $set = $spanset->complement;             # like "NOT", "negate", "invert"

    if ( $spanset->intersects( $set2 ) ) { ...  # like "touches", "interferes"
    if ( $spanset->contains( $set2 ) ) { ...    # like "is-fully-inside"

    # data extraction 
    $date = $spanset->min;           # first date of the set
    $date = $spanset->max;           # last date of the set

    $iter = $spanset->iterator;
    while ( $dt = $iter->next ) {
        # $dt is a DateTime::Span
        print $dt->start->ymd;   # first date of span
        print $dt->end->ymd;     # last date of span
    };

=head1 DESCRIPTION

C<DateTime::SpanSet> is a class that represents sets of datetime
spans.  An example would be a recurring meeting that occurs from
13:00-15:00 every Friday.

This is different from a C<DateTime::Set>, which is made of individual
datetime points as opposed to ranges.

=head1 METHODS

=over 4

=item * from_spans

Creates a new span set from one or more C<DateTime::Span> objects.

   $spanset = DateTime::SpanSet->from_spans( spans => [ $dt_span ] );

=item * from_set_and_duration

Creates a new span set from one or more C<DateTime::Set> objects and a
duration.

The duration can be a C<DateTime::Duration> object, or the parameters
to create a new C<DateTime::Duration> object, such as "days",
"months", etc.

   $spanset =
       DateTime::SpanSet->from_set_and_duration
           ( set => $dt_set, days => 1 );

=item * from_sets

Creates a new span set from two C<DateTime::Set> objects.

One set defines the I<starting dates>, and the other defines the I<end
dates>.

   $spanset =
       DateTime::SpanSet->from_sets
           ( start_set => $dt_set1, end_set => $dt_set2 );

The spans have the starting date C<closed>, and the end date C<open>,
like in C<[$dt1, $dt2)>.

If an end date comes without a starting date before it, then it
defines a span like C<(-inf, $dt)>.

If a starting date comes without an end date after it, then it defines
a span like C<[$dt, inf)>.

=item * empty_set

Creates a new empty set.

=item * is_empty_set

Returns true is the set is empty; false otherwise.

    print "nothing" if $set->is_empty_set;

=item * clone

This object method returns a replica of the given object.

=item * set_time_zone( $tz )

This method accepts either a time zone object or a string that can be
passed as the "name" parameter to C<< DateTime::TimeZone->new() >>.
If the new time zone's offset is different from the old time zone,
then the I<local> time is adjusted accordingly.

If the old time zone was a floating time zone, then no adjustments to
the local time are made, except to account for leap seconds.  If the
new time zone is floating, then the I<UTC> time is adjusted in order
to leave the local time untouched.


=item * start, min

=item * end, max

First or last dates in the set.

It is possible that the return value from these methods may be a
C<DateTime::Infinite::Future> or a C<DateTime::Infinite::Past> object.

If the set ends C<before> a date C<$dt>, it returns C<$dt>. Note that
in this case C<$dt> is not a set element - but it is a set boundary.

These methods may return C<undef> if the set is empty.

These methods return just a I<copy> of the actual boundary value.
If you modify the result, the set will not be modified.


=item * duration

The total size of the set, as a C<DateTime::Duration> object.

The duration may be infinite.

Also available as C<size()>.

=item * span

The total span of the set, as a C<DateTime::Span> object.

=item * next 

  my $span = $set->next( $dt );

This method is used to find the next span in the set,
after a given datetime or span.

The return value is a C<DateTime::Span>, or C<undef> if there is no matching
span in the set.

=item * previous 

  my $span = $set->previous( $dt );

This method is used to find the previous span in the set,
before a given datetime or span.

The return value is a C<DateTime::Span>, or C<undef> if there is no matching
span in the set.


=item * current 

  my $span = $set->current( $dt );

This method is used to find the "current" span in the set,
that intersects a given datetime or span. If no current span
is found, then the "previous" span is returned.

The return value is a C<DateTime::SpanSet>, or C<undef> if there is no
matching span in the set.

If a span parameter is given, it may happen that "current" returns
more than one span.

See also: C<intersected_spans()> method.

=item * closest 

  my $span = $set->closest( $dt );

This method is used to find the "closest" span in the set, given a
datetime or span.

The return value is a C<DateTime::SpanSet>, or C<undef> if the set is
empty.

If a span parameter is given, it may happen that "closest" returns
more than one span.

=item * as_list

Returns a list of C<DateTime::Span> objects.

  my @dt_span = $set->as_list( span => $span );

Just as with the C<iterator()> method, the C<as_list()> method can be
limited by a span.

Applying C<as_list()> to a large recurring spanset is a very expensive
operation, both in CPU time and in the memory used.

For this reason, when C<as_list()> operates on large recurrence sets,
it will return at most approximately 200 spans. For larger sets, and
for I<infinite> sets, C<as_list()> will return C<undef>.

Please note that this is explicitly not an empty list, since an empty
list is a valid return value for empty sets!

If you I<really> need to extract spans from a large set, you can:

- limit the set with a shorter span:

    my @short_list = $large_set->as_list( span => $short_span );

- use an iterator:

    my @large_list;
    my $iter = $large_set->iterator;
    push @large_list, $dt while $dt = $iter->next;

=item * union

=item * intersection

=item * complement

Set operations may be performed not only with C<DateTime::SpanSet>
objects, but also with C<DateTime>, C<DateTime::Set> and
C<DateTime::Span> objects.  These set operations always return a
C<DateTime::SpanSet> object.

    $set = $spanset->union( $set2 );         # like "OR", "insert", "both"
    $set = $spanset->complement( $set2 );    # like "delete", "remove"
    $set = $spanset->intersection( $set2 );  # like "AND", "while"
    $set = $spanset->complement;             # like "NOT", "negate", "invert"

=item * intersected_spans

This method can accept a C<DateTime> list, a C<DateTime::Set>, a
C<DateTime::Span>, or a C<DateTime::SpanSet> object as an argument.

    $set = $set1->intersected_spans( $set2 );

The method always returns a C<DateTime::SpanSet> object, containing
all spans that are intersected by the given set.

Unlike the C<intersection> method, the spans are not modified.  See
diagram below:

               set1   [....]   [....]   [....]   [....]
               set2      [................]

       intersection      [.]   [....]   [.]

  intersected_spans   [....]   [....]   [....]

=item * intersects

=item * contains

These set functions return a boolean value.

    if ( $spanset->intersects( $set2 ) ) { ...  # like "touches", "interferes"
    if ( $spanset->contains( $dt ) ) { ...    # like "is-fully-inside"

These methods can accept a C<DateTime>, C<DateTime::Set>,
C<DateTime::Span>, or C<DateTime::SpanSet> object as an argument.

intersects() returns 1 for true, and 0 for false. In a few cases
the algorithm can't decide if the sets intersect at all, and 
intersects() will return C<undef>.

=item * iterator / next / previous

This method can be used to iterate over the spans in a set.

    $iter = $spanset->iterator;
    while ( $dt = $iter->next ) {
        # $dt is a DateTime::Span
        print $dt->min->ymd;   # first date of span
        print $dt->max->ymd;   # last date of span
    }

The boundaries of the iterator can be limited by passing it a C<span>
parameter.  This should be a C<DateTime::Span> object which delimits
the iterator's boundaries.  Optionally, instead of passing an object,
you can pass any parameters that would work for one of the
C<DateTime::Span> class's constructors, and an object will be created
for you.

Obviously, if the span you specify does is not restricted both at the
start and end, then your iterator may iterate forever, depending on
the nature of your set.  User beware!

The C<next()> or C<previous()> methods will return C<undef> when there
are no more spans in the iterator.

=item * start_set

=item * end_set

These methods do the inverse of the C<from_sets> method:

C<start_set> retrieves a DateTime::Set with the start datetime of each
span.

C<end_set> retrieves a DateTime::Set with the end datetime of each
span.

=item * map ( sub { ... } )

    # example: enlarge the spans
    $set = $set2->map( 
        sub {
            my $start = $_->start;
            my $end = $_->end;
            return DateTime::Span->from_datetimes(
                start => $start,
                before => $end,
            );
        }
    );

This method is the "set" version of Perl "map".

It evaluates a subroutine for each element of the set (locally setting
"$_" to each DateTime::Span) and returns the set composed of the
results of each such evaluation.

Like Perl "map", each element of the set may produce zero, one, or
more elements in the returned value.

Unlike Perl "map", changing "$_" does not change the original
set. This means that calling map in void context has no effect.

The callback subroutine may not be called immediately.  Don't count on
subroutine side-effects. For example, a C<print> inside the subroutine
may happen later than you expect.

The callback return value is expected to be within the span of the
C<previous> and the C<next> element in the original set.

For example: given the set C<[ 2001, 2010, 2015 ]>, the callback
result for the value C<2010> is expected to be within the span C<[
2001 .. 2015 ]>.

=item * grep ( sub { ... } )

    # example: filter out all spans happening today
    my $today = DateTime->today;
    $set = $set2->grep( 
        sub {
            return ( ! $_->contains( $today ) );
        }
    );

This method is the "set" version of Perl "grep".

It evaluates a subroutine for each element of the set (locally setting
"$_" to each DateTime::Span) and returns the set consisting of those
elements for which the expression evaluated to true.

Unlike Perl "grep", changing "$_" does not change the original
set. This means that calling grep in void context has no effect.

Changing "$_" does change the resulting set.

The callback subroutine may not be called immediately.  Don't count on
subroutine side-effects. For example, a C<print> inside the subroutine
may happen later than you expect.

=item * iterate

I<Internal method - use "map" or "grep" instead.>

This function apply a callback subroutine to all elements of a set and
returns the resulting set.

The parameter C<$_[0]> to the callback subroutine is a
C<DateTime::Span> object.

If the callback returns C<undef>, the datetime is removed from the
set:

    sub remove_sundays {
        $_[0] unless $_[0]->start->day_of_week == 7;
    }

The callback return value is expected to be within the span of the
C<previous> and the C<next> element in the original set.

For example: given the set C<[ 2001, 2010, 2015 ]>, the callback
result for the value C<2010> is expected to be within the span C<[
2001 .. 2015 ]>.

The callback subroutine may not be called immediately.  Don't count on
subroutine side-effects. For example, a C<print> inside the subroutine
may happen later than you expect.

=back

=head1 SUPPORT

Support is offered through the C<datetime@perl.org> mailing list.

Please report bugs using rt.cpan.org

=head1 AUTHOR

Flavio Soibelmann Glock <fglock@gmail.com>

The API was developed together with Dave Rolsky and the DateTime Community.

=head1 COPYRIGHT

Copyright (c) 2003 Flavio Soibelmann Glock. All rights reserved.
This program is free software; you can distribute it and/or
modify it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file
included with this module.

=head1 SEE ALSO

Set::Infinite

For details on the Perl DateTime Suite project please see
L<http://datetime.perl.org>.

=cut

