# Copyright (c) 2003 Flavio Soibelmann Glock. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package DateTime::Span;

use strict;

use DateTime::Set;
use DateTime::SpanSet;

use Params::Validate qw( validate SCALAR BOOLEAN OBJECT CODEREF ARRAYREF );
use vars qw( $VERSION );

use constant INFINITY     => DateTime::INFINITY;
use constant NEG_INFINITY => DateTime::NEG_INFINITY;
$VERSION = $DateTime::Set::VERSION;

sub set_time_zone {
    my ( $self, $tz ) = @_;

    $self->{set} = $self->{set}->iterate( 
        sub {
            my %tmp = %{ $_[0]->{list}[0] };
            $tmp{a} = $tmp{a}->clone->set_time_zone( $tz ) if ref $tmp{a};
            $tmp{b} = $tmp{b}->clone->set_time_zone( $tz ) if ref $tmp{b};
            \%tmp;
        }
    );
    return $self;
}

# note: the constructor must clone its DateTime parameters, such that
# the set elements become immutable
sub from_datetimes {
    my $class = shift;
    my %args = validate( @_,
                         { start =>
                           { type => OBJECT,
                             optional => 1,
                           },
                           end =>
                           { type => OBJECT,
                             optional => 1,
                           },
                           after =>
                           { type => OBJECT,
                             optional => 1,
                           },
                           before =>
                           { type => OBJECT,
                             optional => 1,
                           },
                         }
                       );
    my $self = {};
    my $set;

    die "No arguments given to DateTime::Span->from_datetimes\n"
        unless keys %args;

    if ( exists $args{start} && exists $args{after} ) {
        die "Cannot give both start and after arguments to DateTime::Span->from_datetimes\n";
    }
    if ( exists $args{end} && exists $args{before} ) {
        die "Cannot give both end and before arguments to DateTime::Span->from_datetimes\n";
    }

    my ( $start, $open_start, $end, $open_end );
    ( $start, $open_start ) = ( NEG_INFINITY,  0 );
    ( $start, $open_start ) = ( $args{start},  0 ) if exists $args{start};
    ( $start, $open_start ) = ( $args{after},  1 ) if exists $args{after};
    ( $end,   $open_end   ) = ( INFINITY,      0 );
    ( $end,   $open_end   ) = ( $args{end},    0 ) if exists $args{end};
    ( $end,   $open_end   ) = ( $args{before}, 1 ) if exists $args{before};

    if ( $start > $end ) {
        die "Span cannot start after the end in DateTime::Span->from_datetimes\n";
    }
    $set = Set::Infinite::_recurrence->new( $start, $end );
    if ( $start != $end ) {
        # remove start, such that we have ">" instead of ">="
        $set = $set->complement( $start ) if $open_start;  
        # remove end, such that we have "<" instead of "<="
        $set = $set->complement( $end )   if $open_end;    
    }

    $self->{set} = $set;
    bless $self, $class;
    return $self;
}

sub from_datetime_and_duration {
    my $class = shift;
    my %args = @_;

    my $key;
    my $dt;
    # extract datetime parameters
    for ( qw( start end before after ) ) {
        if ( exists $args{$_} ) {
           $key = $_;
           $dt = delete $args{$_};
       }
    }

    # extract duration parameters
    my $dt_duration;
    if ( exists $args{duration} ) {
        $dt_duration = $args{duration};
    }
    else {
        $dt_duration = DateTime::Duration->new( %args );
    }
    # warn "Creating span from $key => ".$dt->datetime." and $dt_duration";
    my $other_date;
    my $other_key;
    if ( $dt_duration->is_positive ) {
        if ( $key eq 'end' || $key eq 'before' ) {
            $other_key = 'start';
            $other_date = $dt->clone->subtract_duration( $dt_duration );
        }
        else {
            $other_key = 'before';
            $other_date = $dt->clone->add_duration( $dt_duration );
        }
    }
    else {
        if ( $key eq 'end' || $key eq 'before' ) {
            $other_key = 'start';
            $other_date = $dt->clone->add_duration( $dt_duration );
        }
        else {
            $other_key = 'before';
            $other_date = $dt->clone->subtract_duration( $dt_duration );
        }
    }
    # warn "Creating span from $key => ".$dt->datetime." and ".$other_date->datetime;
    return $class->new( $key => $dt, $other_key => $other_date ); 
}

# This method is intentionally not documented.  It's really only for
# use by ::Set and ::SpanSet's as_list() and iterator() methods.
sub new {
    my $class = shift;
    my %args = @_;

    # If we find anything _not_ appropriate for from_datetimes, we
    # assume it must be for durations, and call this constructor.
    # This way, we don't need to hardcode the DateTime::Duration
    # parameters.
    foreach ( keys %args )
    {
        return $class->from_datetime_and_duration(%args)
            unless /^(?:before|after|start|end)$/;
    }

    return $class->from_datetimes(%args);
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

# Set::Infinite methods

sub intersection {
    my ($set1, $set2) = @_;
    my $class = ref($set1);
    my $tmp = {};  # $class->new();
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2 ] ) 
        unless $set2->can( 'union' );
    $tmp->{set} = $set1->{set}->intersection( $set2->{set} );

    # intersection() can generate something more complex than a span.
    bless $tmp, 'DateTime::SpanSet';

    return $tmp;
}

sub intersects {
    my ($set1, $set2) = @_;
    my $class = ref($set1);
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2 ] ) 
        unless $set2->can( 'union' );
    return $set1->{set}->intersects( $set2->{set} );
}

sub contains {
    my ($set1, $set2) = @_;
    my $class = ref($set1);
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2 ] ) 
        unless $set2->can( 'union' );
    return $set1->{set}->contains( $set2->{set} );
}

sub union {
    my ($set1, $set2) = @_;
    my $class = ref($set1);
    my $tmp = {};   # $class->new();
    $set2 = $set2->as_spanset
        if $set2->can( 'as_spanset' );
    $set2 = $set2->as_set
        if $set2->can( 'as_set' );
    $set2 = DateTime::Set->from_datetimes( dates => [ $set2 ] ) 
        unless $set2->can( 'union' );
    $tmp->{set} = $set1->{set}->union( $set2->{set} );
 
    # union() can generate something more complex than a span.
    bless $tmp, 'DateTime::SpanSet';

    # # We have to check it's internal structure to find out.
    # if ( $#{ $tmp->{set}->{list} } != 0 ) {
    #    bless $tmp, 'Date::SpanSet';
    # }

    return $tmp;
}

sub complement {
    my ($set1, $set2) = @_;
    my $class = ref($set1);
    my $tmp = {};   # $class->new;
    if (defined $set2) {
        $set2 = $set2->as_spanset
            if $set2->can( 'as_spanset' );
        $set2 = $set2->as_set
            if $set2->can( 'as_set' );
        $set2 = DateTime::Set->from_datetimes( dates => [ $set2 ] ) 
            unless $set2->can( 'union' );
        $tmp->{set} = $set1->{set}->complement( $set2->{set} );
    }
    else {
        $tmp->{set} = $set1->{set}->complement;
    }

    # complement() can generate something more complex than a span.
    bless $tmp, 'DateTime::SpanSet';

    # # We have to check it's internal structure to find out.
    # if ( $#{ $tmp->{set}->{list} } != 0 ) {
    #    bless $tmp, 'Date::SpanSet';
    # }

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

sub start_is_open {
    # min_a returns info about the set boundary 
    my ($min, $open) = $_[0]->{set}->min_a;
    return $open;
}

sub start_is_closed { $_[0]->start_is_open ? 0 : 1 }

sub end_is_open {
    # max_a returns info about the set boundary 
    my ($max, $open) = $_[0]->{set}->max_a;
    return $open;
}

sub end_is_closed { $_[0]->end_is_open ? 0 : 1 }


# span == $self
sub span { @_ }

sub duration { 
    my $dur;

    local $@;
    eval {
        local $SIG{__DIE__};   # don't want to trap this (rt ticket 5434)
        $dur = $_[0]->end->subtract_datetime_absolute( $_[0]->start )
    };
    
    return $dur if defined $dur;

    return DateTime::Infinite::Future->new -
           DateTime::Infinite::Past->new;
}
*size = \&duration;

1;

__END__

=head1 NAME

DateTime::Span - Datetime spans

=head1 SYNOPSIS

    use DateTime;
    use DateTime::Span;

    $date1 = DateTime->new( year => 2002, month => 3, day => 11 );
    $date2 = DateTime->new( year => 2003, month => 4, day => 12 );
    $set2 = DateTime::Span->from_datetimes( start => $date1, end => $date2 );
    #  set2 = 2002-03-11 until 2003-04-12

    $set = $set1->union( $set2 );         # like "OR", "insert", "both"
    $set = $set1->complement( $set2 );    # like "delete", "remove"
    $set = $set1->intersection( $set2 );  # like "AND", "while"
    $set = $set1->complement;             # like "NOT", "negate", "invert"

    if ( $set1->intersects( $set2 ) ) { ...  # like "touches", "interferes"
    if ( $set1->contains( $set2 ) ) { ...    # like "is-fully-inside"

    # data extraction 
    $date = $set1->start;           # first date of the span
    $date = $set1->end;             # last date of the span

=head1 DESCRIPTION

C<DateTime::Span> is a module for handling datetime spans, otherwise
known as ranges or periods ("from X to Y, inclusive of all datetimes
in between").

This is different from a C<DateTime::Set>, which is made of individual
datetime points as opposed to a range. There is also a module
C<DateTime::SpanSet> to handle sets of spans.

=head1 METHODS

=over 4

=item * from_datetimes

Creates a new span based on a starting and ending datetime.

A 'closed' span includes its end-dates:

   $span = DateTime::Span->from_datetimes( start => $dt1, end => $dt2 );

An 'open' span does not include its end-dates:

   $span = DateTime::Span->from_datetimes( after => $dt1, before => $dt2 );

A 'semi-open' span includes one of its end-dates:

   $span = DateTime::Span->from_datetimes( start => $dt1, before => $dt2 );
   $span = DateTime::Span->from_datetimes( after => $dt1, end => $dt2 );

A span might have just a starting date, or just an ending date.
These spans end, or start, in an imaginary 'forever' date:

   $span = DateTime::Span->from_datetimes( start => $dt1 );
   $span = DateTime::Span->from_datetimes( end => $dt2 );
   $span = DateTime::Span->from_datetimes( after => $dt1 );
   $span = DateTime::Span->from_datetimes( before => $dt2 );

You cannot give both a "start" and "after" argument, nor can you give
both an "end" and "before" argument.  Either of these conditions will
cause the C<from_datetimes()> method to die.

To summarize, a datetime passed as either "start" or "end" is included
in the span.  A datetime passed as either "after" or "before" is
excluded from the span.

=item * from_datetime_and_duration

Creates a new span.

   $span = DateTime::Span->from_datetime_and_duration( 
       start => $dt1, duration => $dt_dur1 );
   $span = DateTime::Span->from_datetime_and_duration( 
       after => $dt1, hours => 12 );

The new "end of the set" is I<open> by default.

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

=item * duration

The total size of the set, as a C<DateTime::Duration> object, or as a
scalar containing infinity.

Also available as C<size()>.

=item * start, min

=item * end, max

First or last dates in the span.

It is possible that the return value from these methods may be a
C<DateTime::Infinite::Future> or a C<DateTime::Infinite::Past>xs object.

If the set ends C<before> a date C<$dt>, it returns C<$dt>. Note that
in this case C<$dt> is not a set element - but it is a set boundary.

These methods return just a I<copy> of the actual boundary value.
If you modify the result, the set will not be modified.

=cut

# scalar containing either negative infinity
# or positive infinity.

=item * start_is_closed

=item * end_is_closed

Returns true if the first or last dates belong to the span ( start <= x <= end ).

=item * start_is_open

=item * end_is_open

Returns true if the first or last dates are excluded from the span ( start < x < end ).

=item * union

=item * intersection

=item * complement

Set operations may be performed not only with C<DateTime::Span>
objects, but also with C<DateTime::Set> and C<DateTime::SpanSet>
objects.  These set operations always return a C<DateTime::SpanSet>
object.

    $set = $span->union( $set2 );         # like "OR", "insert", "both"
    $set = $span->complement( $set2 );    # like "delete", "remove"
    $set = $span->intersection( $set2 );  # like "AND", "while"
    $set = $span->complement;             # like "NOT", "negate", "invert"

=item * intersects

=item * contains

These set functions return a boolean value.

    if ( $span->intersects( $set2 ) ) { ...  # like "touches", "interferes"
    if ( $span->contains( $dt ) ) { ...    # like "is-fully-inside"

These methods can accept a C<DateTime>, C<DateTime::Set>,
C<DateTime::Span>, or C<DateTime::SpanSet> object as an argument.

=back

=head1 SUPPORT

Support is offered through the C<datetime@perl.org> mailing list.

Please report bugs using rt.cpan.org

=head1 AUTHOR

Flavio Soibelmann Glock <fglock@gmail.com>

The API was developed together with Dave Rolsky and the DateTime Community.

=head1 COPYRIGHT

Copyright (c) 2003-2006 Flavio Soibelmann Glock. All rights reserved.
This program is free software; you can distribute it and/or modify it
under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file
included with this module.

=head1 SEE ALSO

Set::Infinite

For details on the Perl DateTime Suite project please see
L<http://datetime.perl.org>.

=cut

