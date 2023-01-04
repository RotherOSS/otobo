package DateTime::Set;

use strict;
use Carp;
use Params::Validate qw( validate SCALAR BOOLEAN OBJECT CODEREF ARRAYREF );
use DateTime 0.12;  # this is for version checking only
use DateTime::Duration;
use DateTime::Span;
use Set::Infinite 0.59;
use Set::Infinite::_recurrence;

use vars qw( $VERSION );

use constant INFINITY     =>       100 ** 100 ** 100 ;
use constant NEG_INFINITY => -1 * (100 ** 100 ** 100);

BEGIN {
    $VERSION = '0.3900';
}


sub _fix_datetime {
    # internal function -
    # (not a class method)
    #
    # checks that the parameter is an object, and
    # also protects the object against mutation
    
    return $_[0]
        unless defined $_[0];      # error
    return $_[0]->clone
        if ref( $_[0] );           # "immutable" datetime
    return DateTime::Infinite::Future->new 
        if $_[0] == INFINITY;      # Inf
    return DateTime::Infinite::Past->new
        if $_[0] == NEG_INFINITY;  # -Inf
    return $_[0];                  # error
}

sub _fix_return_datetime {
    my ( $dt, $dt_arg ) = @_;

    # internal function -
    # (not a class method)
    #
    # checks that the returned datetime has the same
    # time zone as the parameter

    # TODO: set locale

    return unless $dt;
    return unless $dt_arg;
    if ( $dt_arg->can('time_zone_long_name') &&
         !( $dt_arg->time_zone_long_name eq 'floating' ) )
    {
        $dt->set_time_zone( $dt_arg->time_zone );
    }
    return $dt;
}

sub iterate {
    # deprecated method - use map() or grep() instead
    my ( $self, $callback ) = @_;
    my $class = ref( $self );
    my $return = $class->empty_set;
    $return->{set} = $self->{set}->iterate( 
        sub {
            my $min = $_[0]->min;
            $callback->( $min->clone ) if ref($min);
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
            local $_ = $_[0]->min;
            next unless ref( $_ );
            $_ = $_->clone;
            my @list = $callback->();
            my $set = Set::Infinite::_recurrence->new();
            $set = $set->union( $_ ) for @list;
            return $set;
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
            local $_ = $_[0]->min;
            next unless ref( $_ );
            $_ = $_->clone;
            my $result = $callback->();
            return $_ if $result;
            return;
        }
    );
    $return;
}

sub add { return shift->add_duration( DateTime::Duration->new(@_) ) }

sub subtract { return shift->subtract_duration( DateTime::Duration->new(@_) ) }

sub subtract_duration { return $_[0]->add_duration( $_[1]->inverse ) }

sub add_duration {
    my ( $self, $dur ) = @_;
    $dur = $dur->clone;  # $dur must be "immutable"

    $self->{set} = $self->{set}->iterate(
        sub {
            my $min = $_[0]->min;
            $min->clone->add_duration( $dur ) if ref($min);
        },
        backtrack_callback => sub { 
            my ( $min, $max ) = ( $_[0]->min, $_[0]->max );
            if ( ref($min) )
            {
                $min = $min->clone;
                $min->subtract_duration( $dur );
            }
            if ( ref($max) )
            {
                $max = $max->clone;
                $max->subtract_duration( $dur );
            }
            return Set::Infinite::_recurrence->new( $min, $max );
        },
    );
    $self;
}

sub set_time_zone {
    my ( $self, $tz ) = @_;

    $self->{set} = $self->{set}->iterate(
        sub {
            my $min = $_[0]->min;
            $min->clone->set_time_zone( $tz ) if ref($min);
        },
        backtrack_callback => sub {
            my ( $min, $max ) = ( $_[0]->min, $_[0]->max );
            if ( ref($min) )
            {
                $min = $min->clone;
                $min->set_time_zone( $tz );
            }
            if ( ref($max) )
            {
                $max = $max->clone;
                $max->set_time_zone( $tz );
            }
            return Set::Infinite::_recurrence->new( $min, $max );
        },
    );
    $self;
}

sub set {
    my $self = shift;
    my %args = validate( @_,
                         { locale => { type => SCALAR | OBJECT,
                                       default => undef },
                         }
                       );
    $self->{set} = $self->{set}->iterate( 
        sub {
            my $min = $_[0]->min;
            $min->clone->set( %args ) if ref($min);
        },
    );
    $self;
}

sub from_recurrence {
    my $class = shift;

    my %args = @_;
    my %param;
    
    # Parameter renaming, such that we can use either
    #   recurrence => xxx   or   next => xxx, previous => xxx
    $param{next} = delete $args{recurrence} || delete $args{next};
    $param{previous} = delete $args{previous};

    $param{span} = delete $args{span};
    # they might be specifying a span using start / end
    $param{span} = DateTime::Span->new( %args ) if keys %args;

    my $self = {};
    
    die "Not enough arguments in from_recurrence()"
        unless $param{next} || $param{previous}; 

    if ( ! $param{previous} ) 
    {
        my $data = {};
        $param{previous} =
                sub {
                    _callback_previous ( _fix_datetime( $_[0] ), $param{next}, $data );
                }
    }
    else
    {
        my $previous = $param{previous};
        $param{previous} =
                sub {
                    $previous->( _fix_datetime( $_[0] ) );
                }
    }

    if ( ! $param{next} ) 
    {
        my $data = {};
        $param{next} =
                sub {
                    _callback_next ( _fix_datetime( $_[0] ), $param{previous}, $data );
                }
    }
    else
    {
        my $next = $param{next};
        $param{next} =
                sub {
                    $next->( _fix_datetime( $_[0] ) );
                }
    }

    my ( $min, $max );
    $max = $param{previous}->( DateTime::Infinite::Future->new );
    $min = $param{next}->( DateTime::Infinite::Past->new );
    $max = INFINITY if $max->is_infinite;
    $min = NEG_INFINITY if $min->is_infinite;
        
    my $base_set = Set::Infinite::_recurrence->new( $min, $max );
    $base_set = $base_set->intersection( $param{span}->{set} )
         if $param{span};
         
    # warn "base set is $base_set\n";

    my $data = {};
    $self->{set} = 
            $base_set->_recurrence(
                $param{next}, 
                $param{previous},
                $data,
        );
    bless $self, $class;
    
    return $self;
}

sub from_datetimes {
    my $class = shift;
    my %args = validate( @_,
                         { dates => 
                           { type => ARRAYREF,
                           },
                         }
                       );
    my $self = {};
    $self->{set} = Set::Infinite::_recurrence->new;
    # possible optimization: sort datetimes and use "push"
    for( @{ $args{dates} } ) 
    {
        # DateTime::Infinite objects are not welcome here,
        # but this is not enforced (it does't hurt)

        carp "The 'dates' argument to from_datetimes() must only contain ".
             "datetime objects"
            unless UNIVERSAL::can( $_, 'utc_rd_values' );

        $self->{set} = $self->{set}->union( $_->clone );
    }

    bless $self, $class;
    return $self;
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
    my $self = bless { %{ $_[0] } }, ref $_[0];
    $self->{set} = $_[0]->{set}->copy;
    return $self;
}

# default callback that returns the 
# "previous" value in a callback recurrence.
#
# This is used to simulate a 'previous' callback,
# when then 'previous' argument in 'from_recurrence' is missing.
#
sub _callback_previous {
    my ($value, $callback_next, $callback_info) = @_; 
    my $previous = $value->clone;

    return $value if $value->is_infinite;

    my $freq = $callback_info->{freq};
    unless (defined $freq) 
    { 
        # This is called just once, to setup the recurrence frequency
        my $previous = $callback_next->( $value );
        my $next =     $callback_next->( $previous );
        $freq = 2 * ( $previous - $next );
        # save it for future use with this same recurrence
        $callback_info->{freq} = $freq;
    }

    $previous->add_duration( $freq );  
    $previous = $callback_next->( $previous );
    if ($previous >= $value) 
    {
        # This error happens if the event frequency oscillates widely
        # (more than 100% of difference from one interval to next)
        my @freq = $freq->deltas;
        print STDERR "_callback_previous: Delta components are: @freq\n";
        warn "_callback_previous: iterator can't find a previous value, got ".
            $previous->ymd." after ".$value->ymd;
    }
    my $previous1;
    while (1) 
    {
        $previous1 = $previous->clone;
        $previous = $callback_next->( $previous );
        return $previous1 if $previous >= $value;
    }
}

# default callback that returns the 
# "next" value in a callback recurrence.
#
# This is used to simulate a 'next' callback,
# when then 'next' argument in 'from_recurrence' is missing.
#
sub _callback_next {
    my ($value, $callback_previous, $callback_info) = @_; 
    my $next = $value->clone;

    return $value if $value->is_infinite;

    my $freq = $callback_info->{freq};
    unless (defined $freq) 
    { 
        # This is called just once, to setup the recurrence frequency
        my $next =     $callback_previous->( $value );
        my $previous = $callback_previous->( $next );
        $freq = 2 * ( $next - $previous );
        # save it for future use with this same recurrence
        $callback_info->{freq} = $freq;
    }

    $next->add_duration( $freq );  
    $next = $callback_previous->( $next );
    if ($next <= $value) 
    {
        # This error happens if the event frequency oscillates widely
        # (more than 100% of difference from one interval to next)
        my @freq = $freq->deltas;
        print STDERR "_callback_next: Delta components are: @freq\n";
        warn "_callback_next: iterator can't find a previous value, got ".
            $next->ymd." before ".$value->ymd;
    }
    my $next1;
    while (1) 
    {
        $next1 = $next->clone;
        $next =  $callback_previous->( $next );
        return $next1 if $next >= $value;
    }
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
# next( $dt ) returns the next element after a datetime.
sub next {
    my $self = shift;
    return undef unless ref( $self->{set} );

    if ( @_ ) 
    {
        if ( $self->{set}->_is_recurrence )
        {
            return _fix_return_datetime(
                       $self->{set}->{param}[0]->( $_[0] ), $_[0] );
        }
        else 
        {
            my $span = DateTime::Span->from_datetimes( after => $_[0] );
            return _fix_return_datetime(
                        $self->intersection( $span )->next, $_[0] );
        }
    }

    my ($head, $tail) = $self->{set}->first;
    $self->{set} = $tail;
    return $head->min if defined $head;
    return $head;
}

# previous() gets the last element from an iterator()
# previous( $dt ) returns the previous element before a datetime.
sub previous {
    my $self = shift;
    return undef unless ref( $self->{set} );

    if ( @_ ) 
    {
        if ( $self->{set}->_is_recurrence ) 
        {
            return _fix_return_datetime(
                      $self->{set}->{param}[1]->( $_[0] ), $_[0] );
        }
        else 
        {
            my $span = DateTime::Span->from_datetimes( before => $_[0] );
            return _fix_return_datetime(
                      $self->intersection( $span )->previous, $_[0] );
        }
    }

    my ($head, $tail) = $self->{set}->last;
    $self->{set} = $tail;
    return $head->max if defined $head;
    return $head;
}

# "current" means less-or-equal to a datetime
sub current {
    my $self = shift;

    return undef unless ref( $self->{set} );

    if ( $self->{set}->_is_recurrence )
    {
        my $tmp = $self->next( $_[0] );
        return $self->previous( $tmp );
    }

    return $_[0] if $self->contains( $_[0] );
    $self->previous( $_[0] );
}

sub closest {
    my $self = shift;
    # return $_[0] if $self->contains( $_[0] );
    my $dt1 = $self->current( $_[0] );
    my $dt2 = $self->next( $_[0] );

    return $dt2 unless defined $dt1;
    return $dt1 unless defined $dt2;

    my $delta = $_[0] - $dt1;
    return $dt1 if ( $dt2 - $delta ) >= $_[0];

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

    return if $set->{set}->is_null;  # nothing = empty

    # Note: removing this line means we may end up in an infinite loop!
    ## return undef if $set->{set}->is_too_complex;  # undef = no start/end
 
    return undef
        if $set->max->is_infinite ||
           $set->min->is_infinite;

    my @result;
    my $next = $self->min;
    if ( $span ) {
        my $next1 = $span->min;
        $next = $next1 if $next1 && $next1 > $next;
        $next = $self->current( $next );
    }
    my $last = $self->max;
    if ( $span ) {
        my $last1 = $span->max;
        $last = $last1 if $last1 && $last1 < $last;
    }
    do {
        push @result, $next if !$span || $span->contains($next);
        $next = $self->next( $next );
    }
    while $next && $next <= $last;
    return @result;
}

sub intersection {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    my $tmp = $class->empty_set();
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = $class->from_datetimes( dates => [ $set2, @_ ] ) 
        unless $set2->can( 'union' );
    $tmp->{set} = $set1->{set}->intersection( $set2->{set} );
    return $tmp;
}

sub intersects {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    unless ( $set2->can( 'union' ) )
    {
        if ( $set1->{set}->_is_recurrence )
        {
            for ( $set2, @_ )
            {
                return 1 if $set1->current( $_ ) == $_;
            }
            return 0;
        }
        $set2 = $class->from_datetimes( dates => [ $set2, @_ ] )
    }
    return $set1->{set}->intersects( $set2->{set} );
}

sub contains {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    unless ( $set2->can( 'union' ) )
    {
        if ( $set1->{set}->_is_recurrence )
        {
            for ( $set2, @_ ) 
            {
                return 0 unless $set1->current( $_ ) == $_;
            }
            return 1;
        }
        $set2 = $class->from_datetimes( dates => [ $set2, @_ ] ) 
    }
    return $set1->{set}->contains( $set2->{set} );
}

sub union {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    my $tmp = $class->empty_set();
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = $class->from_datetimes( dates => [ $set2, @_ ] ) 
        unless $set2->can( 'union' );
    $tmp->{set} = $set1->{set}->union( $set2->{set} );
    bless $tmp, 'DateTime::SpanSet' 
        if $set2->isa('DateTime::Span') or $set2->isa('DateTime::SpanSet');
    return $tmp;
}

sub complement {
    my ($set1, $set2) = ( shift, shift );
    my $class = ref($set1);
    my $tmp = $class->empty_set();
    if (defined $set2) 
    {
        $set2 = $set2->as_set
            if $set2->can( 'as_set' );
        $set2 = $class->from_datetimes( dates => [ $set2, @_ ] ) 
            unless $set2->can( 'union' );
        # TODO: "compose complement";
        $tmp->{set} = $set1->{set}->complement( $set2->{set} );
    }
    else 
    {
        $tmp->{set} = $set1->{set}->complement;
        bless $tmp, 'DateTime::SpanSet';
    }
    return $tmp;
}

sub start {
    return _fix_datetime( $_[0]->{set}->min );
}

*min = \&start;

sub end { 
    return _fix_datetime( $_[0]->{set}->max );
}

*max = \&end;

# returns a DateTime::Span
sub span {
  my $set = $_[0]->{set}->span;
  my $self = bless { set => $set }, 'DateTime::Span';
  return $self;
}

sub count {
    my ($self) = shift;
    return undef unless ref( $self->{set} );

    my %args = @_;
    my $span;
    $span = delete $args{span};
    $span = DateTime::Span->new( %args ) if %args;

    my $set = $self->clone;
    $set = $set->intersection( $span ) if $span;

    return $set->{set}->count
        unless $set->{set}->is_too_complex;

    return undef
        if $set->max->is_infinite ||
           $set->min->is_infinite;

    my $count = 0;
    my $iter = $set->iterator;
    $count++ while $iter->next;
    return $count;
}

1;

__END__

=head1 NAME

DateTime::Set - Datetime sets and set math

=head1 SYNOPSIS

    use DateTime;
    use DateTime::Set;

    $date1 = DateTime->new( year => 2002, month => 3, day => 11 );
    $set1 = DateTime::Set->from_datetimes( dates => [ $date1 ] );
    #  set1 = 2002-03-11

    $date2 = DateTime->new( year => 2003, month => 4, day => 12 );
    $set2 = DateTime::Set->from_datetimes( dates => [ $date1, $date2 ] );
    #  set2 = 2002-03-11, and 2003-04-12

    $date3 = DateTime->new( year => 2003, month => 4, day => 1 );
    print $set2->next( $date3 )->ymd;      # 2003-04-12
    print $set2->previous( $date3 )->ymd;  # 2002-03-11
    print $set2->current( $date3 )->ymd;   # 2002-03-11
    print $set2->closest( $date3 )->ymd;   # 2003-04-12

    # a 'monthly' recurrence:
    $set = DateTime::Set->from_recurrence( 
        recurrence => sub {
            return $_[0] if $_[0]->is_infinite;
            return $_[0]->truncate( to => 'month' )->add( months => 1 )
        },
        span => $date_span1,    # optional span
    );

    $set = $set1->union( $set2 );         # like "OR", "insert", "both"
    $set = $set1->complement( $set2 );    # like "delete", "remove"
    $set = $set1->intersection( $set2 );  # like "AND", "while"
    $set = $set1->complement;             # like "NOT", "negate", "invert"

    if ( $set1->intersects( $set2 ) ) { ...  # like "touches", "interferes"
    if ( $set1->contains( $set2 ) ) { ...    # like "is-fully-inside"

    # data extraction 
    $date = $set1->min;           # first date of the set
    $date = $set1->max;           # last date of the set

    $iter = $set1->iterator;
    while ( $dt = $iter->next ) {
        print $dt->ymd;
    };

=head1 DESCRIPTION

DateTime::Set is a module for datetime sets.  It can be used to handle
two different types of sets.

The first is a fixed set of predefined datetime objects.  For example,
if we wanted to create a set of datetimes containing the birthdays of
people in our family for the current year.

The second type of set that it can handle is one based on a
recurrence, such as "every Wednesday", or "noon on the 15th day of
every month".  This type of set can have fixed starting and ending
datetimes, but neither is required.  So our "every Wednesday set"
could be "every Wednesday from the beginning of time until the end of
time", or "every Wednesday after 2003-03-05 until the end of time", or
"every Wednesday between 2003-03-05 and 2004-01-07".

This module also supports set math operations, so you do things like
create a new set from the union or difference of two sets, check
whether a datetime is a member of a given set, etc.

This is different from a C<DateTime::Span>, which handles a continuous
range as opposed to individual datetime points. There is also a module
C<DateTime::SpanSet> to handle sets of spans.

=head1 METHODS

=over 4

=item * from_datetimes

Creates a new set from a list of datetimes.

   $dates = DateTime::Set->from_datetimes( dates => [ $dt1, $dt2, $dt3 ] );

The datetimes can be objects from class C<DateTime>, or from a
C<DateTime::Calendar::*> class.

C<DateTime::Infinite::*> objects are not valid set members.

=item * from_recurrence

Creates a new set specified via a "recurrence" callback.

    $months = DateTime::Set->from_recurrence( 
        span => $dt_span_this_year,    # optional span
        recurrence => sub { 
            return $_[0]->truncate( to => 'month' )->add( months => 1 ) 
        }, 
    );

The C<span> parameter is optional. It must be a C<DateTime::Span> object.

The span can also be specified using C<start> / C<after> and C<end> /
C<before> parameters, as in the C<DateTime::Span> constructor.  In
this case, if there is a C<span> parameter it will be ignored.

    $months = DateTime::Set->from_recurrence(
        after => $dt_now,
        recurrence => sub {
            return $_[0]->truncate( to => 'month' )->add( months => 1 );
        },
    );

The recurrence function will be passed a single parameter, a datetime
object. The parameter can be an object from class C<DateTime>, or from
one of the C<DateTime::Calendar::*> classes.  The parameter can also
be a C<DateTime::Infinite::Future> or a C<DateTime::Infinite::Past>
object.

The recurrence must return the I<next> event after that object.  There
is no guarantee as to what the returned object will be set to, only
that it will be greater than the object passed to the recurrence.

If there are no more datetimes after the given parameter, then the
recurrence function should return C<DateTime::Infinite::Future>.

It is ok to modify the parameter C<$_[0]> inside the recurrence
function.  There are no side-effects.

For example, if you wanted a recurrence that generated datetimes in
increments of 30 seconds, it would look like this:

  sub every_30_seconds {
      my $dt = shift;
      if ( $dt->second < 30 ) {
          return $dt->truncate( to => 'minute' )->add( seconds => 30 );
      } else {
          return $dt->truncate( to => 'minute' )->add( minutes => 1 );
      }
  }

Note that this recurrence takes leap seconds into account.  Consider
using C<truncate()> in this manner to avoid complicated arithmetic
problems!

It is also possible to create a recurrence by specifying either or both
of 'next' and 'previous' callbacks.

The callbacks can return C<DateTime::Infinite::Future> and
C<DateTime::Infinite::Past> objects, in order to define I<bounded
recurrences>.  In this case, both 'next' and 'previous' callbacks must
be defined:

    # "monthly from $dt until forever"

    my $months = DateTime::Set->from_recurrence(
        next => sub {
            return $dt if $_[0] < $dt;
            $_[0]->truncate( to => 'month' );
            $_[0]->add( months => 1 );
            return $_[0];
        },
        previous => sub {
            my $param = $_[0]->clone;
            $_[0]->truncate( to => 'month' );
            $_[0]->subtract( months => 1 ) if $_[0] == $param;
            return $_[0] if $_[0] >= $dt;
            return DateTime::Infinite::Past->new;
        },
    );

Bounded recurrences are easier to write using C<span> parameters. See above.

See also C<DateTime::Event::Recurrence> and the other
C<DateTime::Event::*> factory modules for generating specialized
recurrences, such as sunrise and sunset times, and holidays.

=item * empty_set

Creates a new empty set.

    $set = DateTime::Set->empty_set;
    print "empty set" unless defined $set->max;

=item * is_empty_set

Returns true is the set is empty; false otherwise.

    print "nothing" if $set->is_empty_set;

=item * clone

This object method returns a replica of the given object.

C<clone> is useful if you want to apply a transformation to a set,
but you want to keep the previous value:

    $set2 = $set1->clone;
    $set2->add_duration( year => 1 );  # $set1 is unaltered

=item * add_duration( $duration )

This method adds the specified duration to every element of the set.

    $dt_dur = new DateTime::Duration( year => 1 );
    $set->add_duration( $dt_dur );

The original set is modified. If you want to keep the old values use:

    $new_set = $set->clone->add_duration( $dt_dur );

=item * add

This method is syntactic sugar around the C<add_duration()> method.

    $meetings_2004 = $meetings_2003->clone->add( years => 1 );

=item * subtract_duration( $duration_object )

When given a C<DateTime::Duration> object, this method simply calls
C<invert()> on that object and passes that new duration to the
C<add_duration> method.

=item * subtract( DateTime::Duration->new parameters )

Like C<add()>, this is syntactic sugar for the C<subtract_duration()>
method.

=item * set_time_zone( $tz )

This method will attempt to apply the C<set_time_zone> method to every 
datetime in the set.

=item * set( locale => .. )

This method can be used to change the C<locale> of a datetime set.


=item * start, min

=item * end, max

The first and last C<DateTime> in the set.

These methods may return C<undef> if the set is empty.

It is also possible that these methods
may return a C<DateTime::Infinite::Past> or C<DateTime::Infinite::Future> object.

These methods return just a I<copy> of the actual value.
If you modify the result, the set will not be modified.


=item * span

Returns the total span of the set, as a C<DateTime::Span> object.

=item * iterator / next / previous

These methods can be used to iterate over the datetimes in a set.

    $iter = $set1->iterator;
    while ( $dt = $iter->next ) {
        print $dt->ymd;
    }

    # iterate backwards
    $iter = $set1->iterator;
    while ( $dt = $iter->previous ) {
        print $dt->ymd;
    }

The boundaries of the iterator can be limited by passing it a C<span>
parameter.  This should be a C<DateTime::Span> object which delimits
the iterator's boundaries.  Optionally, instead of passing an object,
you can pass any parameters that would work for one of the
C<DateTime::Span> class's constructors, and an object will be created
for you.

Obviously, if the span you specify is not restricted both at the start
and end, then your iterator may iterate forever, depending on the
nature of your set.  User beware!

The C<next()> or C<previous()> method will return C<undef> when there
are no more datetimes in the iterator.

=item * as_list

Returns the set elements as a list of C<DateTime> objects.  Just as
with the C<iterator()> method, the C<as_list()> method can be limited
by a span.

  my @dt = $set->as_list( span => $span );

Applying C<as_list()> to a large recurrence set is a very expensive
operation, both in CPU time and in the memory used.  If you I<really>
need to extract elements from a large set, you can limit the set with
a shorter span:

    my @short_list = $large_set->as_list( span => $short_span );

For I<infinite> sets, C<as_list()> will return C<undef>.  Please note
that this is explicitly not an empty list, since an empty list is a
valid return value for empty sets!

=item * count

Returns a count of C<DateTime> objects in the set.  Just as with the
C<iterator()> method, the C<count()> method can be limited by a span.

  defined( my $n = $set->count) or die "can't count";

  my $n = $set->count( span => $span );
  die "can't count" unless defined $n;

Applying C<count()> to a large recurrence set is a very expensive
operation, both in CPU time and in the memory used.  If you I<really>
need to count elements from a large set, you can limit the set with a
shorter span:

    my $count = $large_set->count( span => $short_span );

For I<infinite> sets, C<count()> will return C<undef>.  Please note
that this is explicitly not a scalar zero, since a zero count is a
valid return value for empty sets!

=item * union

=item * intersection

=item * complement

These set operation methods can accept a C<DateTime> list, a
C<DateTime::Set>, a C<DateTime::Span>, or a C<DateTime::SpanSet>
object as an argument.

    $set = $set1->union( $set2 );         # like "OR", "insert", "both"
    $set = $set1->complement( $set2 );    # like "delete", "remove"
    $set = $set1->intersection( $set2 );  # like "AND", "while"
    $set = $set1->complement;             # like "NOT", "negate", "invert"

The C<union> of a C<DateTime::Set> with a C<DateTime::Span> or a
C<DateTime::SpanSet> object returns a C<DateTime::SpanSet> object.

If C<complement> is called without any arguments, then the result is a
C<DateTime::SpanSet> object representing the spans between each of the
set's elements.  If complement is given an argument, then the return
value is a C<DateTime::Set> object representing the I<set difference>
between the sets.

All other operations will always return a C<DateTime::Set>.

=item * intersects

=item * contains

These set operations result in a boolean value.

    if ( $set1->intersects( $set2 ) ) { ...  # like "touches", "interferes"
    if ( $set1->contains( $dt ) ) { ...    # like "is-fully-inside"

These methods can accept a C<DateTime> list, a C<DateTime::Set>, a
C<DateTime::Span>, or a C<DateTime::SpanSet> object as an argument.

intersects() returns 1 for true, and 0 for false. In a few cases
the algorithm can't decide if the sets intersect at all, and 
intersects() will return C<undef>.

=item * previous

=item * next

=item * current

=item * closest

  my $dt = $set->next( $dt );
  my $dt = $set->previous( $dt );
  my $dt = $set->current( $dt );
  my $dt = $set->closest( $dt );

These methods are used to find a set member relative to a given
datetime.

The C<current()> method returns C<$dt> if $dt is an event, otherwise
it returns the previous event.

The C<closest()> method returns C<$dt> if $dt is an event, otherwise
it returns the closest event (previous or next).

All of these methods may return C<undef> if there is no matching
datetime in the set.

These methods will try to set the returned value to the same time zone
as the argument, unless the argument has a 'floating' time zone.

=item * map ( sub { ... } )

    # example: remove the hour:minute:second information
    $set = $set2->map( 
        sub {
            return $_->truncate( to => day );
        }
    );

    # example: postpone or antecipate events which 
    #          match datetimes within another set
    $set = $set2->map(
        sub {
            return $_->add( days => 1 ) while $holidays->contains( $_ );
        }
    );

This method is the "set" version of Perl "map".

It evaluates a subroutine for each element of the set (locally setting
"$_" to each datetime) and returns the set composed of the results of
each such evaluation.

Like Perl "map", each element of the set may produce zero, one, or
more elements in the returned value.

Unlike Perl "map", changing "$_" does not change the original
set. This means that calling map in void context has no effect.

The callback subroutine may be called later in the program, due to
lazy evaluation.  So don't count on subroutine side-effects. For
example, a C<print> inside the subroutine may happen later than you
expect.

The callback return value is expected to be within the span of the
C<previous> and the C<next> element in the original set.  This is a
limitation of the backtracking algorithm used in the C<Set::Infinite>
library.

For example: given the set C<[ 2001, 2010, 2015 ]>, the callback
result for the value C<2010> is expected to be within the span C<[
2001 .. 2015 ]>.

=item * grep ( sub { ... } )

    # example: filter out any sundays
    $set = $set2->grep( 
        sub {
            return ( $_->day_of_week != 7 );
        }
    );

This method is the "set" version of Perl "grep".

It evaluates a subroutine for each element of the set (locally setting
"$_" to each datetime) and returns the set consisting of those
elements for which the expression evaluated to true.

Unlike Perl "grep", changing "$_" does not change the original
set. This means that calling grep in void context has no effect.

Changing "$_" does change the resulting set.

The callback subroutine may be called later in the program, due to
lazy evaluation.  So don't count on subroutine side-effects. For
example, a C<print> inside the subroutine may happen later than you
expect.

=item * iterate ( sub { ... } )

I<deprecated method - please use "map" or "grep" instead.>

=back

=head1 SUPPORT

Support is offered through the C<datetime@perl.org> mailing list.

Please report bugs using rt.cpan.org

=head1 AUTHOR

Flavio Soibelmann Glock <fglock@gmail.com>

The API was developed together with Dave Rolsky and the DateTime
Community.

=head1 COPYRIGHT

Copyright (c) 2003-2006 Flavio Soibelmann Glock. All rights reserved.
This program is free software; you can distribute it and/or modify it
under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

Set::Infinite

For details on the Perl DateTime Suite project please see
L<http://datetime.perl.org>.

=cut

