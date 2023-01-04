use strict;

package DateTime::Set::ICal;

use vars qw(@ISA);
# use Carp;

# a "dt::set" with a symbolic string representation 
@ISA = qw( DateTime::Set );

sub set_ical { # include list, exclude list
    my $self = shift;
    # carp "set_ical $_[0] => @{$_[1]}" if @_;
    $self->{as_ical} = [ @_ ];
    $self; 
}

sub get_ical { 
    my $self = shift;
    return unless $self->{as_ical};
    return @{ $self->{as_ical} };  
}

sub clone {
    my $self = shift;
    my $new = $self->SUPER::clone( @_ );
    $new->set_ical( $self->get_ical );
    $new;
}

sub union {
    my $self = shift;
    my $new = $self->SUPER::union( @_ );

    # RFC2445 - op1, op2 must have no 'exclude'
    my (%op1, %op2);
    %op1 = ( $self->get_ical ) if ( UNIVERSAL::can( $self, 'get_ical' ) );
    %op2 = ( $_[0]->get_ical ) if ( UNIVERSAL::can( $_[0], 'get_ical' ) );
    return $new if ( ( exists $op1{exclude} ) ||
                     ( exists $op2{exclude} ) );

    bless $new, 'DateTime::Set::ICal';
    # warn " -- 1 isa @{[%op1]} -- 2 isa @{[%op2]} -- ";
    my @ical;
    @ical = exists $op1{include} ? 
            @{$op1{include}} : 
            $self;

    # push @ical, @{$op2{include}}, @_;
    if ( exists $op2{include} )
    {
        push @ical, @{$op2{include}};
    }
    else
    {
        push @ical, @_;  # whatever...
    }
    # warn "union: @ical";
    $new->set_ical( include => [ @ical ] ); 
    $new;
}

sub complement {
    my $self = shift;
    my $new = $self->SUPER::complement( @_ );
    return $new unless @_;

    # RFC2445 - op2 must have no 'exclude'
    my (%op1, %op2);
    %op1 = ( $self->get_ical ) if ( UNIVERSAL::can( $self, 'get_ical' ) );
    %op2 = ( $_[0]->get_ical ) if ( UNIVERSAL::can( $_[0], 'get_ical' ) );
    return $new if ( exists $op2{exclude} );

    bless $new, 'DateTime::Set::ICal';
    # warn " -- 1 isa @{[%op1]} -- 2 isa @{[%op2]} -- ";
    my ( @include, @exclude );
    @include = exists $op1{include} ?
               @{$op1{include}} :
               $self;

    @exclude = exists $op1{exclude} ?
               @{$op1{exclude}} :
               ();

    if ( exists $op2{include} )
    {
        push @exclude, @{$op2{include}};
    }
    else
    {
        push @exclude, @_;  # whatever...
    }

    # warn "complement: include @include exclude @exclude";
    $new->set_ical( include => [ @include ], exclude => [ @exclude ] ); 
    $new;
}

package DateTime::Event::Recurrence;

use strict;
use DateTime;
use DateTime::Set;
use DateTime::Span;
use Params::Validate qw(:all);
use vars qw( $VERSION );
$VERSION = '0.19';

use constant INFINITY     =>       100 ** 100 ** 100 ;
use constant NEG_INFINITY => -1 * (100 ** 100 ** 100);

# -------- BASE OPERATIONS

use vars qw( 
    %as_number

    %truncate 
    %next_unit 
    %previous_unit 
    
    %truncate_interval 
    %next_unit_interval 
    %previous_unit_interval 

    %weekdays 
    %weekdays_1 
    %weekdays_any
    
    %memoized_duration
    
    %ical_name
    %ical_days
    %limits
    @units
);

BEGIN {
    %weekdays =   qw(  mo 1   tu 2   we 3   th 4   fr 5   sa 6   su 7 );
    %weekdays_1 = qw( 1mo 1  1tu 2  1we 3  1th 4  1fr 5  1sa 6  1su 7 );
    %weekdays_any = ( %weekdays, %weekdays_1 );
    
    %ical_name =  qw( 
        months  BYMONTH   
        weeks   BYWEEKNO 
        days    BYMONTHDAY  
        hours   BYHOUR
        minutes BYMINUTE 
        seconds BYSECOND 
    );
    
    %ical_days =  qw( 
         1 MO  2 TU  3 WE  4 TH  5 FR  6 SA  7 SU 
        -7 MO -6 TU -5 WE -4 TH -3 FR -2 SA -1 SU 
    );
                      
    @units = qw( years months weeks days hours minutes seconds nanoseconds );
    
    %limits = qw(
        nanoseconds 1000000000
        seconds     61
        minutes     60
        hours       24
        months      12
        weeks       53
        days        366
    );

} # BEGIN


# memoization reduces 'duration' creation from >10000 to about 30 per run,
# in DT::E::ICal

sub _add {
    # datetime, unit, value
    my $dur = \$memoized_duration{$_[1]}{$_[2]};
    $$dur = new DateTime::Duration( $_[1] => $_[2] )
        unless defined $$dur;
    $_[0]->add_duration( $$dur );
}

# TODO: %as_number should use the "subtract" routines from DateTime

%as_number = (
    years => sub { 
        $_[0]->year 
    },
    months => sub {
        12 * $_[0]->year + $_[0]->month - 1
    },
    days => sub { 
        ( $_[0]->local_rd_values() )[0]
    },
    weeks => sub {
        # $_[1] is the "week start day", such as "1mo"
        use integer;
        return ( $as_number{days}->( $_[0] ) - $weekdays_any{ $_[1] } ) / 7;
    },
    hours => sub { 
        $as_number{days}->($_[0]) * 24 + $_[0]->hour 
    },
    minutes => sub { 
        $as_number{hours}->($_[0]) * 60 + $_[0]->minute 
    },
    seconds => sub { 
        $_[0]->local_rd_as_seconds
    },
    years_weekly => sub {
        # get the internal year number, in 'week' mode
        # $_[1] is the "week start day", such as "1mo"
        my $base = $_[0]->clone;
        $base = $truncate{years_weekly}->( $base, $_[1] )
            if $base->month > 11 || $base->month < 2;
        _add( $base, weeks => 1 );
        return $as_number{years}->( $base );
    },
    months_weekly => sub {
        # get the internal month number, in 'week' mode
        # $_[1] is the "week start day", such as "1mo"
        my $base = $_[0]->clone;
        $base = $truncate{months_weekly}->( $base, $_[1] )
            if $base->day > 20 || $base->day < 7;
        _add( $base, weeks => 1 );
        return $as_number{months}->( $base );
    },
);


%truncate = (
    # @_ = ( $datetime, $week_start_day )

    (
        map {
              my $name = $_; 
              $name =~ s/s$//;
              $_ => sub { 
                           my $tmp = $_[0]->clone; 
                           $tmp->truncate( to => $name ) 
                        } 
            } qw( years months days hours minutes seconds )
    ),

    weeks   => sub { 
        my $base = $_[0]->clone->truncate( to => 'day' );
        _add( $base, days => - $_[0]->day_of_week 
                             + $weekdays_any{ $_[1] } );
        while(1) {
            return $base if $base <= $_[0];
            _add( $base, weeks => -1 );
        }
    },

    months_weekly => sub {
        my $tmp;
        my $base = $_[0]->clone;
        _add( $base, days => 7 );
        $base->truncate( to => 'month' );
        my $val;
        my $diff;
        while(1) {
            $tmp = $base->clone;
            $val = $weekdays_1{ $_[1] };
            if ( $val ) 
            {
                $diff = $val - $base->day_of_week;
                $diff += 7 if $diff < 0;
            }
            else 
            {
                $diff = ( $weekdays{ $_[1] } - 
                          $base->day_of_week ) % 7;
                $diff -= 7 if $diff > 3;
            }
            _add( $tmp, days =>  $diff );
            return $tmp if $tmp <= $_[0];
            _add( $base, months => -1 );
        }
    },

    years_weekly => sub {
        my $tmp;
        my $base = $_[0]->clone;
        _add( $base, months => 1 );
        $base->truncate( to => 'year' );
        my $val;
        my $diff;
        # warn "wsd $_[1]\n";
        while(1) {
            $tmp = $base->clone;
            $val = $weekdays_1{ $_[1] };
            if ( $val ) 
            {
                $diff = $val - $base->day_of_week;
                $diff += 7 if $diff < 0;
            }
            else 
            {
                $diff = ( $weekdays{ $_[1] } - 
                          $base->day_of_week ) % 7;
                $diff -= 7 if $diff > 3;
            }
            _add( $tmp, days =>  $diff );
            return $tmp if $tmp <= $_[0];
            _add( $base, years => -1 );
        }
    },
);

%next_unit = (
    # @_ = ( $datetime, $week_start_day )

    (
        map { 
              my $names = $_;
              $_ => sub { 
                           _add( $_[0], $names => 1 ) 
                        } 
            } qw( years months weeks days hours minutes seconds )
    ),

    months_weekly => sub {
        my $base = $_[0]->clone;
        my $return;
        while(1) {
            _add( $base, days => 21 );
            $return = $truncate{months_weekly}->( $base, $_[1] );
            return $_[0] = $return if $return > $_[0];
        }
    },

    years_weekly => sub {
        my $base = $_[0]->clone;
        my $return;
        while(1) {
            _add( $base, months => 11 );
            $return = $truncate{years_weekly}->( $base, $_[1] );
            return $_[0] = $return if $return > $_[0];
        }
    },
);

%previous_unit = (
    # @_ = ( $datetime, $week_start_day )

    months_weekly => sub {
        my $base = $_[0]->clone;
        my $return;
        while(1) {
            $return = $truncate{months_weekly}->( $base, $_[1] );
            return $_[0] = $return if $return < $_[0];
            _add( $base, days => -21 );
        }
    },

    years_weekly => sub {
        my $base = $_[0]->clone;
        my $return;
        while(1) {
            $return = $truncate{years_weekly}->( $base, $_[1] );
            return $_[0] = $return if $return < $_[0];
            _add( $base, months => -11 );
        }
    },
);

# -------- "INTERVAL" OPERATIONS

%truncate_interval = (
    # @_ = ( $datetime, $args )

    (
        map { 
              my $names = $_;
              my $name = $_; 
              $name =~ s/s$//;
              $_ => sub { 
                           my $tmp = $_[0]->clone;
                           $tmp->truncate( to => $name );
                           _add( $tmp, $names => 
                                     $_[1]{offset} - 
                                     ( $as_number{$names}->($_[0]) %
                                       $_[1]{interval} 
                                     ) 
                               );
                        } 
            } qw( years months days hours minutes seconds )
    ),

    weeks   => sub { 
        my $tmp = $truncate{weeks}->( $_[0], $_[1]{week_start_day} );
        while ( $_[1]{offset} != 
                ( $as_number{weeks}->( 
                    $tmp, $_[1]{week_start_day} ) % 
                  $_[1]{interval} 
                ) 
              )
        {
            _add( $tmp, weeks => -1 );
        }
        return $tmp;
    },

    months_weekly => sub {
        my $tmp = $truncate{months_weekly}->( $_[0], $_[1]{week_start_day} );
        while ( $_[1]{offset} != 
                ( $as_number{months_weekly}->( 
                    $tmp, $_[1]{week_start_day} ) % 
                  $_[1]{interval} 
                )
              )
        {
            $previous_unit{months_weekly}->( $tmp, $_[1]{week_start_day} );
        }
        return $tmp;
    },

    years_weekly => sub {
        my $tmp = $truncate{years_weekly}->( $_[0], $_[1]{week_start_day} );
        while ( $_[1]{offset} != 
                ( $as_number{years_weekly}->( $tmp, $_[1]{week_start_day} ) % 
                    $_[1]{interval} 
                ) 
              ) 
        {
            $previous_unit{years_weekly}->( $tmp, $_[1]{week_start_day} );
        }
        return $tmp;
    },
);

%next_unit_interval = (
    (
        map {
              my $names = $_;
              $_ => sub { 
                           _add( $_[0], $names => $_[1]{interval} ) 
                        } 
            } qw( years months weeks days hours minutes seconds )
    ),

    months_weekly => sub {
        for ( 1 .. $_[1]{interval} )
        {
            $next_unit{months_weekly}->( $_[0], $_[1]{week_start_day} );
        }
    },

    years_weekly => sub {
        for ( 1 .. $_[1]{interval} ) 
        {
            $next_unit{years_weekly}->( $_[0], $_[1]{week_start_day} );
        }
    },
);

%previous_unit_interval = (
    ( 
        map { 
              my $names = $_;
              $_ => sub { 
                           _add( $_[0], $names => - $_[1]{interval} )
                        } 
            } qw( years months weeks days hours minutes seconds )  
    ),

    months_weekly => sub {
        for ( 1 .. $_[1]{interval} )
        {
            $previous_unit{months_weekly}->( $_[0], $_[1]{week_start_day} );
        }
    },

    years_weekly => sub {
        for ( 1 .. $_[1]{interval} )
        {
            $previous_unit{years_weekly}->( $_[0], $_[1]{week_start_day} );
        }
    },
);

# -------- CONSTRUCTORS

BEGIN {
    # setup all constructors: daily, ...

    for ( @units[ 0 .. $#units-1 ] ) 
    {
        my $name = $_;
        my $namely = $_;
        $namely =~ s/ys$/ily/;
        $namely =~ s/s$/ly/;
        
        no strict 'refs';
        *{__PACKAGE__ . "::$namely"} =
            sub { 
                    use strict 'refs';
                    my $class = shift;
                    return _create_recurrence( base => $name, @_ );
                };
    }
} # BEGIN


sub _create_recurrence {
    my %args = @_;

    # print "ARGS: "; 
    # for(@_){ print (( ref($_) eq "ARRAY" ) ? "[ @$_ ] " : "$_ ") }
    # print " \n";
    
    # --- FREQUENCY
    
    my $base = delete $args{base};
    my $namely = $base;
    $namely =~ s/ys$/ily/;
    $namely =~ s/s$/ly/;
    my $ical_string = uc( "RRULE:FREQ=$namely" );
    my $base_unit = $base;
    $base_unit = 'years_weekly' 
         if $base_unit eq 'years' &&
            exists $args{weeks} ;
    $base_unit = 'months_weekly'
         if $base_unit eq 'months' &&
            exists $args{weeks} ;

    # --- WEEK-START-DAY
    
    my $week_start_day = delete $args{week_start_day};
    $ical_string .= ";WKST=". uc($week_start_day)
        if $week_start_day;
    $week_start_day = ( $base eq 'years' ) ? 'mo' : '1mo'
        unless defined $week_start_day;
    die "$base: invalid week start day ($week_start_day)"
        unless $weekdays_any{ $week_start_day };
                   
    # --- INTERVAL, START, and OFFSET
            
    my $interval = delete $args{interval} || 1;
    die "invalid 'interval' specification ($interval)"
        if $interval < 1;
    $ical_string .= ";INTERVAL=$interval" 
        if $interval > 1;

    my $start = delete $args{start};
    undef $start 
        if defined $start && $start->is_infinite;
        
    my $offset = 0;
    $offset = $as_number{$base_unit}->( $start, $week_start_day ) % $interval
        if $start && $interval > 1;

    # --- DURATION LIST
    
    # check for invalid "units" arguments, such as "daily( years=> )"
    my @valid_units;
    for ( 0 .. $#units )
    {
        if ( $base eq $units[$_] )
        {
            @valid_units = @units[ $_+1 .. $#units ];
            last;
        }
    }
    die "can't have both 'months' and 'weeks' arguments" 
        if exists $args{weeks} && 
           exists $args{months};
    
    my $level = 1;
    my @duration =   ( [] );  
    my @level_unit = ( $base_unit );
    for my $unit ( @valid_units )
    {
            next unless exists $args{$unit};

            if ( ref( $args{$unit} ) eq 'ARRAY' )
            {
                $args{$unit} = [ @{ $args{$unit} } ] 
            }
            else    
            {
                $args{$unit} = [ $args{$unit} ] 
            }
                
            # TODO: sort _after_ normalization

            if ( $unit eq 'days' )
            {
                # map rfc2445 weekdays to numbers
                @{$args{$unit}} = 
                    map {
                          $_ =~ /[a-z]/ ? $weekdays{$_} : $_
                        } @{$args{$unit}};
            }

            # sort positive values first
            @{$args{$unit}} = 
                sort {
                       ( $a < 0 ) <=> ( $b < 0 ) || $a <=> $b
                     } @{$args{$unit}};


            # make the "ical" string
            if ( $unit eq 'nanoseconds' )
            {
                # there are no nanoseconds in ICal
            }
            elsif ( $base eq 'weeks' &&
                    $unit eq 'days' )
            {
                # weekdays have names
                $ical_string .= uc( ';' . 'BYDAY' . '=' . 
                    join(",", 
                        map { 
                              exists( $ical_days{$_} ) ? $ical_days{$_} : $_ 
                            } @{$args{$unit}} ) 
                  ) 
            }
            else
            {
                $ical_string .= uc( ';' . $ical_name{$unit} . '=' . 
                                join(",", @{$args{$unit}} ) ) 
            }
           
            if ( $unit eq 'months' ||
                 $unit eq 'weeks' ||
                 $unit eq 'days' ) 
            {
                # these units start in '1'
                for ( @{$args{$unit}} ) 
                {
                    die $unit . ' cannot be zero' 
                        unless $_;
                    $_-- if $_ > 0;
                }
            }
            
            @{$args{$unit}} =
                    grep { 
                           $_ < $limits{ $unit } && 
                           $_ >= - $limits{ $unit } 
                         } @{$args{$unit}};
            
            if ( $unit eq 'days' &&
                 ( $base_unit eq 'months' || 
                   $level_unit[-1] eq 'months' ) )
            {   # month day
                    @{$args{$unit}} = 
                        grep { 
                               $_ < 31 && $_ >= -31 
                             } @{$args{$unit}};
            }

            if ( $unit eq 'days' &&
                 ( $base_unit eq 'weeks' || 
                   $level_unit[-1] eq 'weeks' ) )
            {   # week day
                    
                    @{$args{$unit}} = 
                        grep { 
                               $_ < 7 && $_ >= -7 
                             } @{$args{$unit}};

                    for ( @{$args{$unit}} ) 
                    {
                        $_ = $_ - $weekdays_any{ $week_start_day } + 1;
                        $_ += 7 while $_ < 0;
                    }

                    @{$args{$unit}} = sort @{$args{$unit}};
            }

            return DateTime::Set::ICal->empty_set 
                unless @{$args{$unit}};  # there are no args left

            push @duration, $args{$unit};
            push @level_unit, $unit;

            delete $args{$unit};

            $level++;
    }

    # TODO: use $span for selecting elements (using intersection) 
    # note - this may change the documented behaviour - check the pod first
    # $span = delete $args{span};
    # $span = DateTime::Span->new( %args ) if %args;

    die "invalid argument '@{[ keys %args ]}'"
        if keys %args;
   
    # --- SPLIT NEGATIVE/POSITIVE DURATIONS

    my @args;
    push @args, \@duration;
    
    for ( my $i = 0; $i < @args; $i++ )
    {
        my $dur1 = $args[$i];
        for ( 1 .. $#{$dur1} )
        {
            my @negatives = grep { $_ <  0 } @{$dur1->[$_]};
            my @positives = grep { $_ >= 0 } @{$dur1->[$_]};
            if ( @positives && @negatives )
            {
                # split
                # TODO: check if it really needs splitting
                my $dur2 = [ @{$args[$i]} ];
                $dur2->[$_] = \@negatives;
                $dur1->[$_] = \@positives;
                push @args, $dur2;
            }
        }
    }

    # --- CREATE THE SET
    
    my $set;
    for ( @args )
    {
        my @duration = @$_;
        my $total_durations = 1;
        my @total_level;
        for ( my $i = $#duration; $i > 0; $i-- ) 
        {
            if ( $i == $#duration ) 
            {
                $total_level[$i] = 1;
            }
            else 
            {
                $total_level[$i] = $total_level[$i + 1] * 
                                   ( 1 + $#{ $duration[$i + 1] } );
            }
            $total_durations *= 1 + $#{ $duration[$i] };
        }

        my $args =  {
            truncate_interval =>      $truncate_interval{ $base_unit },
            previous_unit_interval => $previous_unit_interval{ $base_unit },
            next_unit_interval =>     $next_unit_interval{ $base_unit },
            
            duration =>        \@duration, 
            total_durations => $total_durations,
            level_unit =>      \@level_unit,
            total_level =>     \@total_level,
            
            interval =>        $interval,
            offset =>          $offset,
            week_start_day =>  $week_start_day,
        };
        
        my $tmp = DateTime::Set::ICal->from_recurrence(
                          next => sub { 
                              _get_next( $_[0], $args ); 
                          },
                          previous => sub { 
                              _get_previous( $_[0], $args ); 
                          },
        );
        
        $set = defined $set ? $set->union( $tmp ) : $tmp;
    }
    $set->set_ical( include => [ $ical_string ] ); 
    # warn "Creating set: ". $ical_string ." \n";
    
    return $set;
    
} # _create_recurrence


sub _get_occurrence_by_index {
    my ( $base, $occurrence, $args ) = @_;
    # TODO: memoize "occurrences" within an "INTERVAL" ???
    RETRY_OVERFLOW: for ( 0 .. 5 )  
    {
        return undef 
            if  $occurrence < 0;
        my $next = $base->clone;
        my $previous = $base;
        my @values = ( -1 );
        for my $j ( 1 .. $#{$args->{duration}} ) 
        {
            # decode the occurrence-number into a parameter-index
            my $i = int( $occurrence / $args->{total_level}[$j] );
            $occurrence -= $i * $args->{total_level}[$j];
            push @values, $i;
        
            if ( $args->{duration}[$j][$i] < 0 )
            {
                # warn "negative unit\n";
                $next_unit{ $args->{level_unit}[$j - 1] }->( 
                    $next, $args->{week_start_day} );
            }
            _add( $next, $args->{level_unit}[$j], $args->{duration}[$j][$i] );
            
            # overflow check
            if ( $as_number{ $args->{level_unit}[$j - 1] }->( 
                    $next, $args->{week_start_day} ) !=
                 $as_number{ $args->{level_unit}[$j - 1] }->( 
                    $previous, $args->{week_start_day} )
               )
            {
                # calculate the "previous" occurrence-number
                $occurrence = -1;
                for ( 1 .. $j ) 
                {
                    $occurrence += $values[$_] * $args->{total_level}[$_];
                }
                next RETRY_OVERFLOW;
            }
            $previous = $next->clone;
        }
        return $next;
    }
    return undef; 
}


sub _get_previous {
    my ( $self, $args ) = @_;

    return $self if $self->is_infinite;
    $self->set_time_zone( 'floating' );

    my $base = $args->{truncate_interval}->( $self, $args );
    my ( $next, $i, $start, $end );
    my $init = 0;
    my $retry = 30;

    INTERVAL: while(1) {
            $args->{previous_unit_interval}->( $base, $args ) if $init;
            $init = 1;

            # binary search
            $start = 0;
            $end = $args->{total_durations} - 1;
            while ( $retry-- ) {
                if ( $end - $start < 3 )
                {
                    for ( $i = $end; $i >= $start; $i-- ) 
                    {
                        $next = _get_occurrence_by_index ( $base, $i, $args );
                        next INTERVAL unless defined $next;
                        return $next if $next < $self;
                    }
                    next INTERVAL;
                }

                $i = int( $start + ( $end - $start ) / 2 );
                $next = _get_occurrence_by_index ( $base, $i, $args );
                next INTERVAL unless defined $next;

                if ( $next < $self ) 
                {
                    $start = $i;
                }
                else 
                {
                    $end = $i - 1;
                }
            }
            return undef; 
    }
}


sub _get_next {
    my ( $self, $args ) = @_;

    return $self if $self->is_infinite;
    $self->set_time_zone( 'floating' );

    my $base = $args->{truncate_interval}->( $self, $args );
    my ( $next, $i, $start, $end );
    my $init = 0;
    my $retry = 30;
    
    INTERVAL: while(1) {
            $args->{next_unit_interval}->( $base, $args ) if $init;
            $init = 1;

            # binary search
            $start = 0;
            $end = $args->{total_durations} - 1;
            while ( $retry-- ) {
                if ( $end - $start < 3 )
                {
                    for $i ( $start .. $end ) 
                    {
                        $next = _get_occurrence_by_index ( $base, $i, $args );
                        next INTERVAL unless defined $next;
                        return $next if $next > $self;
                    }
                    next INTERVAL;
                }

                $i = int( $start + ( $end - $start ) / 2 );
                $next = _get_occurrence_by_index ( $base, $i, $args );
                next INTERVAL unless defined $next;

                if ( $next > $self ) 
                {
                    $end = $i;
                }
                else 
                {
                    $start = $i + 1;
                }
            }
            return undef; 
    }
}

1;

__END__

=head1 NAME

DateTime::Event::Recurrence - DateTime::Set extension for create basic recurrence sets

=head1 SYNOPSIS

 use DateTime;
 use DateTime::Event::Recurrence;
 
 my $dt = DateTime->new( year   => 2000,
                         month  => 6,
                         day    => 20,
                       );

 my $daily_set = DateTime::Event::Recurrence->daily;

 my $dt_next = $daily_set->next( $dt );

 my $dt_previous = $daily_set->previous( $dt );

 my $bool = $daily_set->contains( $dt );

 my @days = $daily_set->as_list( start => $dt1, end => $dt2 );

 my $iter = $daily_set->iterator;

 while ( my $dt = $iter->next ) {
     print ' ', $dt->datetime;
 }

=head1 DESCRIPTION

This module provides convenience methods that let you easily create
C<DateTime::Set> objects for various recurrences, such as "once a
month" or "every day".  You can also create more complicated
recurrences, such as "every Monday, Wednesday and Thursday at 10:00 AM
and 2:00 PM".

=head1 USAGE

=over 4

=item * yearly monthly weekly daily hourly minutely secondly

These methods all return a new C<DateTime::Set> object representing
the given recurrence.

  my $daily_set = DateTime::Event::Recurrence->daily;

If no parameters are given, then the set members each occur at the
I<beginning> of the specified recurrence.

For example, by default, the C<monthly()> method returns a set
containing the first day of each month.

Without parameters, the C<weekly()> method returns a set containing
I<Mondays>.

However, you can pass in parameters to alter where these datetimes
fall.  The parameters are the same as those given to the
C<DateTime::Duration> constructor for specifying the length of a
duration.  For example, to create a set representing a daily
recurrence at 10:30 each day, we write this:

  my $daily_at_10_30_set =
      DateTime::Event::Recurrence->daily( hours => 10, minutes => 30 );

To represent every I<Tuesday> (second day of the week):

  my $weekly_on_tuesday_set =
      DateTime::Event::Recurrence->weekly( days => 2 );

A negative duration counts backwards from the end of the period.  This
is done in the same manner as is specified in RFC 2445 (iCal).

Negative durations are useful for creating recurrences such as the 
I<last day of each month>:

  my $last_day_of_month_set =
      DateTime::Event::Recurrence->monthly( days => -1 );

You can also provide multiple sets of duration arguments, such as
this:

    my $set = DateTime::Event::Recurrence->daily
                  ( hours =>   [ 10, 14,  -1 ],
                    minutes => [ 15, 30, -15 ],
                  );

This specifies a recurrence occurring every day at these 9 different
times:

  10:15,  10:30,  10:45,   # +10h         ( +15min / +30min / last 15min (-15) )
  14:15,  14:30,  14:45,   # +14h         ( +15min / +30min / last 15min (-15) )
  23:15,  23:30,  23:45,   # last 1h (-1) ( +15min / +30min / last 15min (-15) )

To create a set of recurrences occurring every thirty seconds, we could do this:

    my $every_30_seconds_set =
        DateTime::Event::Recurrence->minutely( seconds => [ 0, 30 ] );

The following is also valid. See the section on the "interval" parameter:
        
    my $every_30_seconds_set =
        DateTime::Event::Recurrence->secondly( interval => 30 );
        
=back

=head2 Invalid DateTimes

Invalid values are skipped at run time.

For example, when days are added to a month, the result is checked for
a nonexisting day (such as 31 or 30), and the invalid datetimes are skipped.

Another example of this would be creating a set via the
C<daily()> method and specifying C<< hours => 25 >>.

=head2 The "days" Parameter

The "days" parameter can be combined with yearly, monthly, and weekly
recurrences, resulting in six possible meanings:

    # tuesday of every week
    my $set = DateTime::Event::Recurrence->weekly( days => 2 );

    # 10th day of every month
    my $set = DateTime::Event::Recurrence->monthly( days => 10 );

    # second full week of every month, on tuesday
    my $set = DateTime::Event::Recurrence->monthly( weeks => 2, days => 2 );

    # 10th day of every year
    my $set = DateTime::Event::Recurrence->yearly( days => 10 );

    # 10th day of every december
    my $set = DateTime::Event::Recurrence->yearly( months => 12, days => 10 );

    # second week of every year, on tuesday
    my $set = DateTime::Event::Recurrence->yearly( weeks => 2, days => 2 );

Week days can also be called by name, as is specified in RFC 2445 (iCal):

  my $weekly_on_tuesday_set =
      DateTime::Event::Recurrence->weekly( days => 'tu' );
      
The "days" parameter defaults to "the first day".
See also the section on the "week_start_day" parameter.
    
    # second full week of every month, on monday
    my $set = DateTime::Event::Recurrence->monthly( weeks => 2 );

    # second tuesday of every month
    my $set = DateTime::Event::Recurrence->monthly( weeks => 2, days => "tu", week_start_day => "1tu" );


=head2 The "interval" and "start" Parameters

The "interval" parameter represents how often the recurrence rule repeats. 

The optional "start" parameter specifies where to start counting:

    my $dt_start = DateTime->new( year => 2003, month => 6, day => 15 );

    my $set = DateTime::Event::Recurrence->daily
                  ( interval => 11,
                    hours    => 10,
                    minutes  => 30,
                    start    => $dt_start,
                  );

This specifies a recurrence that happens at 10:30 on the day specified
by C<< start => $dt >>, and then every 11 days I<before and after>
C<$dt>.  So we get a set like this:

    ...
    2003-06-04T10:30:00,
    2003-06-15T10:30:00,
    2003-06-26T10:30:00,
    ...

In this case, the method is used to specify the unit, so C<daily()>
means that our unit is a day, and C<< interval => 11 >> specifies the
quantity of our unit.

The "start" parameter should have no time zone.

=head2 The "week_start_day" Parameter

The C<week_start_day> represents how the 'first week' of a period is
calculated:

"mo", "tu", "we", "th", "fr", "sa", "su" - The first week is one that starts
on this week-day, and has I<the most days> in this period.  Works for
C<weekly> and C<yearly> recurrences.

"1mo", "1tu", "1we", "1th", "1fr", "1sa", "1su" - The first week is one that
starts on this week-day, and has I<all days> in this period.  This
works for C<weekly()>, C<monthly()> and C<yearly()> recurrences.

The C<week_start_day> defaults to "1mo",
except in yearly (C<yearly()>) recurrences which default to "mo".

=head2 Time Zones

Recurrences are created in the 'floating' time zone, as specified in
the C<DateTime> module.

If you want to specify a time zone for a recurrence, you can do this
by calling C<set_time_zone()> on the returned set:

  my $daily = DateTime::Event::Recurrence->daily;
  $daily->set_time_zone( 'Europe/Berlin' );

You can also pass a C<DateTime.pm> object with a time zone to
the set's C<next()> and C<previous()> methods:

  my $dt = DateTime->today( time_zone => 'Europe/Berlin' );
  my $next = $daily->next($dt);

A recurrence can be affected DST changes, so it would be possible to
specify a recurrence that creates nonexistent datetimes.  Because
C<DateTime.pm> throws an exception if asked to create a non-existent
datetime, please be careful when setting a time zone for your
recurrence.

It might be preferable to always use "UTC" for your sets, and then
convert the returned object to the desired time zone.

=head2 Leap Seconds

There are no leap seconds, because the recurrences are created in the 
'floating' time zone.

The value C<60> for seconds (the leap second) is ignored.  If you
I<really> want the leap second, then specify the second as C<-1>.

=head1 AUTHOR

Flavio Soibelmann Glock
fglock@gmail.com

=head1 CREDITS

The API was developed with help from the people in the
datetime@perl.org list.

Special thanks to Dave Rolsky, 
Ron Hill and Matt Sisk for being around with ideas.

If you can understand what this module does by reading the docs, you
should thank Dave Rolsky.  If you can't understand it, yell at him.
He also helped removing weird idioms from the code.

Jerrad Pierce came with the idea to move "interval" from
DateTime::Event::ICal to here.

=head1 COPYRIGHT

Copyright (c) 2003 Flavio Soibelmann Glock.  
All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

datetime@perl.org mailing list

DateTime Web page at http://datetime.perl.org/

DateTime - date and time :)

DateTime::Set - for recurrence-set accessors docs.
You can use DateTime::Set to specify recurrences using callback subroutines.

DateTime::Event::ICal - if you need more complex recurrences.

DateTime::SpanSet - sets of intervals, including recurring sets of intervals.

=cut

