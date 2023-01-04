package Set::Infinite::Arithmetic;
# Copyright (c) 2001 Flavio Soibelmann Glock. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

use strict;
# use warnings;
require Exporter;
use Carp;
use Time::Local;
use POSIX qw(floor);

use vars qw( @EXPORT @EXPORT_OK $inf );

@EXPORT = qw();
@EXPORT_OK = qw();
# @EXPORT_OK = qw( %subs_offset2 %Offset_to_value %Value_to_offset %Init_quantizer );

$inf = 100**100**100;    # $Set::Infinite::inf;  doesn't work! (why?)

=head2 NAME

Set::Infinite::Arithmetic - Scalar operations used by quantize() and offset()

=head2 AUTHOR

Flavio Soibelmann Glock - fglock@pucrs.br

=cut

use vars qw( $day_size $hour_size $minute_size $second_size ); 
$day_size =    timegm(0,0,0,2,3,2001) - timegm(0,0,0,1,3,2001);
$hour_size =   $day_size / 24;
$minute_size = $hour_size / 60;
$second_size = $minute_size / 60;

use vars qw( %_MODE %subs_offset2 %Offset_to_value @week_start %Init_quantizer %Value_to_offset %Offset_to_value );

=head2 %_MODE hash of subs

    $a->offset ( value => [1,2], mode => 'offset', unit => 'days' );

    $a->offset ( value => [1,2, -5,-4], mode => 'offset', unit => 'days' );

note: if mode = circle, then "-5" counts from end (like a Perl negative array index).

    $a->offset ( value => [1,2], mode => 'offset', unit => 'days', strict => $a );

option 'strict' will return intersection($a,offset). Default: none.

=cut

# return value = ($this, $next, $cmp)
%_MODE = (
    circle => sub {
            if ($_[3] >= 0) {
                &{ $_[0] } ($_[1], $_[3], $_[4] ) 
            }
            else {
                &{ $_[0] } ($_[2], $_[3], $_[4] ) 
            }
    },
    begin =>  sub { &{ $_[0] } ($_[1], $_[3], $_[4] ) },
    end =>    sub { &{ $_[0] } ($_[2], $_[3], $_[4] ) },
    offset => sub {
            my ($this, undef) = &{ $_[0] } ($_[1], $_[3], $_[4] );
            my (undef, $next) = &{ $_[0] } ($_[2], $_[3], $_[4] );
            ($this, $next); 
    }
);


=head2 %subs_offset2($object, $offset1, $offset2)

    &{ $subs_offset2{$unit} } ($object, $offset1, $offset2);

A hash of functions that return:

    ($object+$offset1, $object+$offset2)

in $unit context.

Returned $object+$offset1, $object+$offset2 may be scalars or objects.

=cut

%subs_offset2 = (
    weekdays =>    sub {
        # offsets to week-day specified
        # 0 = first sunday from today (or today if today is sunday)
        # 1 = first monday from today (or today if today is monday)
        # 6 = first friday from today (or today if today is friday)
        # 13 = second friday from today 
        # -1 = last saturday from today (not today, even if today were saturday)
        # -2 = last friday
        my ($self, $index1, $index2) = @_;
        return ($self, $self) if $self == $inf;
        # my $class = ref($self);
        my @date = gmtime( $self ); 
        my $wday = $date[6];
        my ($tmp1, $tmp2);

        $tmp1 = $index1 - $wday;
        if ($index1 >= 0) { 
            $tmp1 += 7 if $tmp1 < 0; # it will only happen next week 
        }
        else {
            $tmp1 += 7 if $tmp1 < -7; # if will happen this week
        } 

        $tmp2 = $index2 - $wday;
        if ($index2 >= 0) { 
            $tmp2 += 7 if $tmp2 < 0; # it will only happen next week 
        }
        else {
            $tmp2 += 7 if $tmp2 < -7; # if will happen this week
        } 

        # print " [ OFS:weekday $self $tmp1 $tmp2 ] \n";
        # $date[3] += $tmp1;
        $tmp1 = $self + $tmp1 * $day_size;
        # $date[3] += $tmp2 - $tmp1;
        $tmp2 = $self + $tmp2 * $day_size;

        ($tmp1, $tmp2);
    },
    years =>     sub {
        my ($self, $index, $index2) = @_;
        return ($self, $self) if $self == $inf;
        # my $class = ref($self);
        # print " [ofs:year:$self -- $index]\n";
        my @date = gmtime( $self ); 
        $date[5] +=    1900 + $index;
        my $tmp = timegm(@date);

        $date[5] +=    $index2 - $index;
        my $tmp2 = timegm(@date);

        ($tmp, $tmp2);
    },
    months =>     sub {
        my ($self, $index, $index2) = @_;
        # carp " [ofs:month:$self -- $index -- $inf]";
        return ($self, $self) if $self == $inf;
        # my $class = ref($self);
        my @date = gmtime( $self );

        my $mon =     $date[4] + $index; 
        my $year =    $date[5] + 1900;
        # print " [OFS: month: from $year$mon ]\n";
        if (($mon > 11) or ($mon < 0)) {
            my $addyear = floor($mon / 12);
            $mon = $mon - 12 * $addyear;
            $year += $addyear;
        }

        my $mon2 =     $date[4] + $index2; 
        my $year2 =    $date[5] + 1900;
        if (($mon2 > 11) or ($mon2 < 0)) {
            my $addyear2 = floor($mon2 / 12);
            $mon2 = $mon2 - 12 * $addyear2;
            $year2 += $addyear2;
        }

        # print " [OFS: month: to $year $mon ]\n";

        $date[4] = $mon;
        $date[5] = $year;
        my $tmp = timegm(@date);

        $date[4] = $mon2;
        $date[5] = $year2;
        my $tmp2 = timegm(@date);

        ($tmp, $tmp2);
    },
    days =>     sub { 
        ( $_[0] + $_[1] * $day_size,
          $_[0] + $_[2] * $day_size,
        )
    },
    weeks =>    sub { 
        ( $_[0] + $_[1] * (7 * $day_size),
          $_[0] + $_[2] * (7 * $day_size),
        )
    },
    hours =>    sub { 
        # carp " [ $_[0]+$_[1] hour = ".( $_[0] + $_[1] * $hour_size )." mode=".($_[0]->{mode})." ]";
        ( $_[0] + $_[1] * $hour_size,
          $_[0] + $_[2] * $hour_size,
        )
    },
    minutes =>    sub { 
        ( $_[0] + $_[1] * $minute_size,
          $_[0] + $_[2] * $minute_size,
        )
    },
    seconds =>    sub { 
        ( $_[0] + $_[1] * $second_size, 
          $_[0] + $_[2] * $second_size, 
        )
    },
    one =>      sub { 
        ( $_[0] + $_[1], 
          $_[0] + $_[2], 
        )
    },
);


@week_start = ( 0, -1, -2, -3, 3, 2, 1, 0, -1, -2, -3, 3, 2, 1, 0 );

=head2 %Offset_to_value($object, $offset)

=head2 %Init_quantizer($object)

    $Offset_to_value{$unit} ($object, $offset);

    $Init_quantizer{$unit} ($object);

Maps an 'offset value' to a 'value'

A hash of functions that return ( int($object) + $offset ) in $unit context.

Init_quantizer subroutines must be called before using subs_offset1 functions.

int(object)+offset is a scalar.

Offset_to_value is optimized for calling it multiple times on the same object,
with different offsets. That's why there is a separate initialization
subroutine.

$self->{offset} is created on initialization. It is an index used 
by the memoization cache.

=cut

%Offset_to_value = (
    weekyears =>    sub {
        my ($self, $index) = @_;
        my $epoch = timegm( 0,0,0, 
            1,0,$self->{offset} + $self->{quant} * $index);
        my @time = gmtime($epoch);
        # print " [QT_D:weekyears:$self->{offset} + $self->{quant} * $index]\n";
        # year modulo week
        # print " [QT:weekyears: time = ",join(";", @time )," ]\n";
        $epoch += ( $week_start[$time[6] + 7 - $self->{wkst}] ) * $day_size;
        # print " [QT:weekyears: week=",join(";", gmtime($epoch) )," wkst=$self->{wkst} tbl[",$time[6] + 7 - $self->{wkst},"]=",$week_start[$time[6] + 7 - $self->{wkst}]," ]\n\n";

        my $epoch2 = timegm( 0,0,0,
            1,0,$self->{offset} + $self->{quant} * (1 + $index) );
        @time = gmtime($epoch2);
        $epoch2 += ( $week_start[$time[6] + 7 - $self->{wkst}] ) * $day_size;
        ( $epoch, $epoch2 );
    },
    years =>     sub {
        my $index = $_[0]->{offset} + $_[0]->{quant} * $_[1];
        ( timegm( 0,0,0, 1, 0, $index),
          timegm( 0,0,0, 1, 0, $index + $_[0]->{quant}) )
      },
    months =>     sub {
        my $mon = $_[0]->{offset} + $_[0]->{quant} * $_[1]; 
        my $year = int($mon / 12);
        $mon -= $year * 12;
        my $tmp = timegm( 0,0,0, 1, $mon, $year);

        $mon += $year * 12 + $_[0]->{quant};
        $year = int($mon / 12);
        $mon -= $year * 12;
        ( $tmp, timegm( 0,0,0, 1, $mon, $year) );
      },
    weeks =>    sub {
        my $tmp = 3 * $day_size + $_[0]->{quant} * ($_[0]->{offset} + $_[1]);
        ($tmp, $tmp + $_[0]->{quant})
      },
    days =>     sub {
        my $tmp = $_[0]->{quant} * ($_[0]->{offset} + $_[1]);
        ($tmp, $tmp + $_[0]->{quant})
      },
    hours =>    sub {
        my $tmp = $_[0]->{quant} * ($_[0]->{offset} + $_[1]);
        ($tmp, $tmp + $_[0]->{quant})
      },
    minutes =>    sub {
        my $tmp = $_[0]->{quant} * ($_[0]->{offset} + $_[1]);
        ($tmp, $tmp + $_[0]->{quant})
      },
    seconds =>    sub {
        my $tmp = $_[0]->{quant} * ($_[0]->{offset} + $_[1]);
        ($tmp, $tmp + $_[0]->{quant})
      },
    one =>       sub { 
        my $tmp = $_[0]->{quant} * ($_[0]->{offset} + $_[1]);
        ($tmp, $tmp + $_[0]->{quant})
      },
);


# Maps an 'offset value' to a 'value'

%Value_to_offset = (
    one =>      sub { floor( $_[1] / $_[0]{quant} ) },
    seconds =>  sub { floor( $_[1] / $_[0]{quant} ) },
    minutes =>  sub { floor( $_[1] / $_[0]{quant} ) },
    hours =>    sub { floor( $_[1] / $_[0]{quant} ) },
    days =>     sub { floor( $_[1] / $_[0]{quant} ) },
    weeks =>    sub { floor( ($_[1] - 3 * $day_size) / $_[0]{quant} ) },
    months =>   sub {
        my @date = gmtime( 0 + $_[1] );
        my $tmp = $date[4] + 12 * (1900 + $date[5]);
        floor( $tmp / $_[0]{quant} );
      },
    years =>    sub {
        my @date = gmtime( 0 + $_[1] );
        my $tmp = $date[5] + 1900;
        floor( $tmp / $_[0]{quant} );
      },
    weekyears =>    sub {

        my ($self, $value) = @_;
        my @date;

        # find out YEAR number
        @date = gmtime( 0 + $value );
        my $year = floor( $date[5] + 1900 / $self->{quant} );

        # what is the EPOCH for this week-year's begin ?
        my $begin_epoch = timegm( 0,0,0,  1,0,$year);
        @date = gmtime($begin_epoch);
        $begin_epoch += ( $week_start[$date[6] + 7 - $self->{wkst}] ) * $day_size;

        # what is the EPOCH for this week-year's end ?
        my $end_epoch = timegm( 0,0,0,  1,0,$year+1);
        @date = gmtime($end_epoch);
        $end_epoch += ( $week_start[$date[6] + 7 - $self->{wkst}] ) * $day_size;

        $year-- if $value <  $begin_epoch;
        $year++ if $value >= $end_epoch;

        # carp " value=$value offset=$year this_epoch=".$begin_epoch;
        # carp " next_epoch=".$end_epoch;

        $year;
      },
);

# Initialize quantizer

%Init_quantizer = (
    one =>       sub {},
    seconds =>   sub { $_[0]->{quant} *= $second_size },
    minutes =>   sub { $_[0]->{quant} *= $minute_size },
    hours =>     sub { $_[0]->{quant} *= $hour_size },
    days =>      sub { $_[0]->{quant} *= $day_size },
    weeks =>     sub { $_[0]->{quant} *= 7 * $day_size },
    months =>    sub {},
    years =>     sub {},
    weekyears => sub { 
        $_[0]->{wkst} = 1 unless defined $_[0]->{wkst};
        # select which 'cache' to use
        # $_[0]->{memo} .= $_[0]->{wkst};
    },
);


1;

