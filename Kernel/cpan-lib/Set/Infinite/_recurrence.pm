# Copyright (c) 2003 Flavio Soibelmann Glock. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Set::Infinite::_recurrence;

use strict;

use constant INFINITY     =>       100 ** 100 ** 100 ;
use constant NEG_INFINITY => -1 * (100 ** 100 ** 100);

use vars qw( @ISA $PRETTY_PRINT $max_iterate );

@ISA = qw( Set::Infinite );
use Set::Infinite 0.5502;

BEGIN {
    $PRETTY_PRINT = 1;   # enable Set::Infinite debug
    $max_iterate = 20;

    # TODO: inherit %Set::Infinite::_first / _last 
    #       in a more "object oriented" way

    $Set::Infinite::_first{_recurrence} = 
        sub {
            my $self = $_[0];
            my ($callback_next, $callback_previous) = @{ $self->{param} };
            my ($min, $min_open) = $self->{parent}->min_a;
            # my ($max, $max_open) = $self->{parent}->max_a;

            my ( $min1, $min2 );
            $min1 = $callback_next->( $min );
            if ( ! $min_open )
            {
                $min2 = $callback_previous->( $min1 );
                $min1 = $min2 if defined $min2 && $min == $min2;
            }

            my $start = $callback_next->( $min1 );
            my $end   = $self->{parent}->max;
            
            #print STDERR "set ";
            #print STDERR $start->datetime
            #   unless $start == INFINITY;
            #print STDERR " - " ;
            #print STDERR $end->datetime 
            #    unless $end == INFINITY;
            #print STDERR "\n";
            
            return ( $self->new( $min1 ), undef )
                if $start > $end;

            return ( $self->new( $min1 ),
                     $self->new( $start, $end )->
                     # $self->new( {a => $start, b => $end, open_end => $max_open} )->
                          _function( '_recurrence', @{ $self->{param} } ) );
        };
    $Set::Infinite::_last{_recurrence} =
        sub {
            my $self = $_[0];
            my ($callback_next, $callback_previous) = @{ $self->{param} };
            my ($max, $max_open) = $self->{parent}->max_a;

            my ( $max1, $max2 );
            $max1 = $callback_previous->( $max );
            if ( ! $max_open )
            {
                $max2 = $callback_next->( $max1 );
                $max1 = $max2 if $max == $max2;
            }

            return ( $self->new( $max1 ),
                     $self->new( $self->{parent}->min, 
                                 $callback_previous->( $max1 ) )->
                          _function( '_recurrence', @{ $self->{param} } ) );
        };
}

# $si->_recurrence(
#     \&callback_next, \&callback_previous )
#
# Generates "recurrences" from a callback.
# These recurrences are simple lists of dates.
#
# The recurrence generation is based on an idea from Dave Rolsky.
#

# use Data::Dumper;
# use Carp qw(cluck);

sub _recurrence { 
    my $set = shift;
    my ( $callback_next, $callback_previous, $delta ) = @_;

    $delta->{count} = 0 unless defined $delta->{delta};

    # warn "reusing delta: ". $delta->{count} if defined $delta->{delta};
    # warn Dumper( $delta );

    if ( $#{ $set->{list} } != 0 || $set->is_too_complex )
    {
        return $set->iterate( 
            sub { 
                $_[0]->_recurrence( 
                    $callback_next, $callback_previous, $delta ) 
            } );
    }
    # $set is a span
    my $result;
    if ($set->min != NEG_INFINITY && $set->max != INFINITY)
    {
        # print STDERR " finite set\n";
        my ($min, $min_open) = $set->min_a;
        my ($max, $max_open) = $set->max_a;

        my ( $min1, $min2 );
        $min1 = $callback_next->( $min );
        if ( ! $min_open )
        {
                $min2 = $callback_previous->( $min1 );
                $min1 = $min2 if defined $min2 && $min == $min2;
        }
        
        $result = $set->new();

        # get "delta" - abort if this will take too much time.

        unless ( defined $delta->{max_delta} )
        {
          for ( $delta->{count} .. 10 ) 
          {
            if ( $max_open )
            {
                return $result if $min1 >= $max;
            }
            else
            {
                return $result if $min1 > $max;
            }
            push @{ $result->{list} }, 
                 { a => $min1, b => $min1, open_begin => 0, open_end => 0 };
            $min2 = $callback_next->( $min1 );
            
            if ( $delta->{delta} ) 
            {
                $delta->{delta} += $min2 - $min1;
            }
            else
            {
                $delta->{delta} = $min2 - $min1;
            }
            $delta->{count}++;
            $min1 = $min2;
          }

          $delta->{max_delta} = $delta->{delta} * 40;
        }

        if ( $max < $min + $delta->{max_delta} ) 
        {
          for ( 1 .. 200 ) 
          {
            if ( $max_open )
            {
                return $result if $min1 >= $max;
            }
            else
            {
                return $result if $min1 > $max;
            }
            push @{ $result->{list} }, 
                 { a => $min1, b => $min1, open_begin => 0, open_end => 0 };
            $min1 = $callback_next->( $min1 );
          } 
        }

        # cluck "give up";
    }

    # return a "_function", such that we can backtrack later.
    my $func = $set->_function( '_recurrence', $callback_next, $callback_previous, $delta );
    
    # removed - returning $result doesn't help on speed
    ## return $func->_function2( 'union', $result ) if $result;

    return $func;
}

sub is_forever
{
    $#{ $_[0]->{list} } == 0 &&
    $_[0]->max == INFINITY &&
    $_[0]->min == NEG_INFINITY
}

sub _is_recurrence 
{
    exists $_[0]->{method}           && 
    $_[0]->{method} eq '_recurrence' &&
    $_[0]->{parent}->is_forever
}

sub intersects
{
    my ($s1, $s2) = (shift,shift);

    if ( exists $s1->{method} && $s1->{method} eq '_recurrence' )
    {
        # recurrence && span
        unless ( ref($s2) && exists $s2->{method} ) {
            my $intersection = $s1->intersection($s2, @_);
            my $min = $intersection->min;
            return 1 if defined $min && $min != NEG_INFINITY && $min != INFINITY;
            my $max = $intersection->max;
            return 1 if defined $max && $max != NEG_INFINITY && $max != INFINITY;
        }

        # recurrence && recurrence
        if ( $s1->{parent}->is_forever && 
            ref($s2) && _is_recurrence( $s2 ) )
        {
            my $intersection = $s1->intersection($s2, @_);
            my $min = $intersection->min;
            return 1 if defined $min && $min != NEG_INFINITY && $min != INFINITY;
            my $max = $intersection->max;
            return 1 if defined $max && $max != NEG_INFINITY && $max != INFINITY;
        }
    }
    return $s1->SUPER::intersects( $s2, @_ );
}

sub intersection
{
    my ($s1, $s2) = (shift,shift);

    if ( exists $s1->{method} && $s1->{method} eq '_recurrence' )
    {
        # optimize: recurrence && span
        return $s1->{parent}->
            intersection( $s2, @_ )->
            _recurrence( @{ $s1->{param} } )
                unless ref($s2) && exists $s2->{method};

        # optimize: recurrence && recurrence
        if ( $s1->{parent}->is_forever && 
            ref($s2) && _is_recurrence( $s2 ) )
        {
            my ( $next1, $previous1 ) = @{ $s1->{param} };
            my ( $next2, $previous2 ) = @{ $s2->{param} };
            return $s1->{parent}->_function( '_recurrence', 
                  sub {
                               # intersection of parent 'next' callbacks
                               my ($n1, $n2);
                               my $iterate = 0;
                               $n2 = $next2->( $_[0] );
                               while(1) { 
                                   $n1 = $next1->( $previous1->( $n2 ) );
                                   return $n1 if $n1 == $n2;
                                   $n2 = $next2->( $previous2->( $n1 ) );
                                   return if $iterate++ == $max_iterate;
                               }
                  },
                  sub {
                               # intersection of parent 'previous' callbacks
                               my ($p1, $p2);
                               my $iterate = 0;
                               $p2 = $previous2->( $_[0] );
                               while(1) { 
                                   $p1 = $previous1->( $next1->( $p2 ) );
                                   return $p1 if $p1 == $p2;
                                   $p2 = $previous2->( $next2->( $p1 ) ); 
                                   return if $iterate++ == $max_iterate;
                               }
                  },
               );
        }
    }
    return $s1->SUPER::intersection( $s2, @_ );
}

sub union
{
    my ($s1, $s2) = (shift,shift);
    if ( $s1->_is_recurrence &&
         ref($s2) && _is_recurrence( $s2 ) )
    {
        # optimize: recurrence || recurrence
        my ( $next1, $previous1 ) = @{ $s1->{param} };
        my ( $next2, $previous2 ) = @{ $s2->{param} };
        return $s1->{parent}->_function( '_recurrence',
                  sub {  # next
                               my $n1 = $next1->( $_[0] );
                               my $n2 = $next2->( $_[0] );
                               return $n1 < $n2 ? $n1 : $n2;
                  },
                  sub {  # previous
                               my $p1 = $previous1->( $_[0] );
                               my $p2 = $previous2->( $_[0] );
                               return $p1 > $p2 ? $p1 : $p2;
                  },
               );
    }
    return $s1->SUPER::union( $s2, @_ );
}

=head1 NAME

Set::Infinite::_recurrence - Extends Set::Infinite with recurrence functions

=head1 SYNOPSIS

    $recurrence = $base_set->_recurrence ( \&next, \&previous );

=head1 DESCRIPTION

This is an internal class used by the DateTime::Set module.
The API is subject to change.

It provides all functionality provided by Set::Infinite, plus the ability
to define recurrences with arbitrary objects, such as dates.

=head1 METHODS

=over 4

=item * _recurrence ( \&next, \&previous )

Creates a recurrence set. The set is defined inside a 'base set'.

   $recurrence = $base_set->_recurrence ( \&next, \&previous );

The recurrence functions take one argument, and return the 'next' or 
the 'previous' occurrence. 

Example: defines the set of all 'integer numbers':

    use strict;

    use Set::Infinite::_recurrence;
    use POSIX qw(floor);

    # define the recurrence span
    my $forever = Set::Infinite::_recurrence->new( 
        Set::Infinite::_recurrence::NEG_INFINITY, 
        Set::Infinite::_recurrence::INFINITY
    );

    my $recurrence = $forever->_recurrence(
        sub {   # next
                floor( $_[0] + 1 ) 
            },   
        sub {   # previous
                my $tmp = floor( $_[0] ); 
                $tmp < $_[0] ? $tmp : $_[0] - 1
            },   
    );

    print "sample recurrence ",
          $recurrence->intersection( -5, 5 ), "\n";
    # sample recurrence -5,-4,-3,-2,-1,0,1,2,3,4,5

    {
        my $x = 234.567;
        print "next occurrence after $x = ",
              $recurrence->{param}[0]->( $x ), "\n";  # 235
        print "previous occurrence before $x = ",
              $recurrence->{param}[2]->( $x ), "\n";  # 234
    }

    {
        my $x = 234;
        print "next occurrence after $x = ",
              $recurrence->{param}[0]->( $x ), "\n";  # 235
        print "previous occurrence before $x = ",
              $recurrence->{param}[2]->( $x ), "\n";  # 233
    }

=item * is_forever

Returns true if the set is a single span, 
ranging from -Infinity to Infinity.

=item * _is_recurrence

Returns true if the set is an unbounded recurrence, 
ranging from -Infinity to Infinity.

=back

=head1 CONSTANTS

=over 4

=item * INFINITY

The C<Infinity> value.

=item * NEG_INFINITY

The C<-Infinity> value.

=back

=head1 SUPPORT

Support is offered through the C<datetime@perl.org> mailing list.

Please report bugs using rt.cpan.org

=head1 AUTHOR

Flavio Soibelmann Glock <fglock@gmail.com>

The recurrence generation algorithm is based on an idea from Dave Rolsky.

=head1 COPYRIGHT

Copyright (c) 2003 Flavio Soibelmann Glock. All rights reserved.
This program is free software; you can distribute it and/or
modify it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file
included with this module.

=head1 SEE ALSO

Set::Infinite

DateTime::Set

For details on the Perl DateTime Suite project please see
L<http://datetime.perl.org>.

=cut

