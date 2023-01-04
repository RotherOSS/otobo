package DateTime::Event::ICal;

use strict;
require Exporter;
use Carp;
use DateTime;
use DateTime::Set;
use DateTime::Span;
use DateTime::SpanSet;
use DateTime::Event::Recurrence 0.11;
use Params::Validate qw(:all);
use vars qw( $VERSION @ISA );
@ISA     = qw( Exporter );
$VERSION = '0.13';

use constant INFINITY     =>       100 ** 100 ** 100 ;
use constant NEG_INFINITY => -1 * (100 ** 100 ** 100);

my %weekdays = ( mo => 1, tu => 2, we => 3, th => 4,
                 fr => 5, sa => 6, su => 7 );

my %freqs = ( 
    secondly => { name => 'second', names => 'seconds' },
    minutely => { name => 'minute', names => 'minutes' },
    hourly =>   { name => 'hour',   names => 'hours' },
    daily =>    { name => 'day',    names => 'days' },
    monthly =>  { name => 'month',  names => 'months' },
    weekly =>   { name => 'week',   names => 'weeks' },
    yearly =>   { name => 'year',   names => 'years' },
);

# internal debugging method - formats the argument list for error messages
# the output from this routine is also used by DateTime::Format::ICal->format_recurrence()
sub _param_str {
    my %param = @_;
    my @str;
    for ( qw( freq interval count ), 
          qw( byyear bymonth byday ),
          sort keys %param ) 
    {
        next unless exists $param{$_};
        if ( ref( $param{$_} ) eq 'ARRAY' ) {
            push @str, "$_=". join( ',', @{$param{$_}} )
        }
        elsif ( UNIVERSAL::can( $param{$_}, 'datetime' ) ) {
            if ( $DateTime::Format::ICal::VERSION ) {
                push @str, "$_=" . DateTime::Format::ICal->format_datetime( $param{$_} );
            }
            else {
                push @str, "$_=". $param{$_}->datetime 
            }
        }
        elsif ( defined $param{$_} ) {
            push @str, "$_=". $param{$_} 
        }
        else {
            push @str, "$_=undef" 
        }
        delete $param{$_};
    }
    return join(';', @str);
}

# recurrence constructors

sub _secondly_recurrence {
    my ($dtstart, $argsref) = @_;
    my %by;
    my %args = %$argsref;
            $by{interval} = $args{interval} if exists $args{interval};
            $by{start} =    $dtstart;
    delete $$argsref{$_}
        for qw( interval );
    return DateTime::Event::Recurrence->secondly( %by );
}

sub _minutely_recurrence {
    my ($dtstart, $argsref) = @_;
    my %by;
    my %args = %$argsref;
            $by{interval} = $args{interval} if exists $args{interval};
            $by{start} =    $dtstart;
            $by{seconds} = $args{bysecond} if exists $args{bysecond};
            $by{seconds} = $dtstart->second unless exists $by{seconds};
    delete $$argsref{$_}
        for qw( interval bysecond );
    return DateTime::Event::Recurrence->minutely( %by );
}

sub _hourly_recurrence {
    my ($dtstart, $argsref) = @_;
    my %by;
    my %args = %$argsref;
            $by{interval} = $args{interval} if exists $args{interval};
            $by{start} =    $dtstart;
            $by{seconds} = $args{bysecond} if exists $args{bysecond};
            $by{seconds} = $dtstart->second unless exists $by{seconds};
            $by{minutes} = $args{byminute} if exists $args{byminute};
            $by{minutes} = $dtstart->minute unless exists $by{minutes};
    delete $$argsref{$_}
        for qw( interval byminute bysecond );
    return DateTime::Event::Recurrence->hourly( %by );
}

sub _daily_recurrence {
    my ($dtstart, $argsref) = @_;
    my %by;
    my %args = %$argsref;
            $by{interval} = $args{interval} if exists $args{interval};
            $by{start} =    $dtstart;
            $by{seconds} = $args{bysecond} if exists $args{bysecond};
            $by{seconds} = $dtstart->second unless exists $by{seconds};
            $by{minutes} = $args{byminute} if exists $args{byminute};
            $by{minutes} = $dtstart->minute unless exists $by{minutes};
            $by{hours} =   $args{byhour} if exists $args{byhour};
            $by{hours} =   $dtstart->hour unless exists $by{hours};
    delete $$argsref{$_}
        for qw( interval bysecond byminute byhour );
    # TODO: (maybe) - same thing if byweekno exists
    $$argsref{bymonthday} = [ 1 .. 31 ] 
        if exists $args{bymonth} && ! exists $args{bymonthday};
    return DateTime::Event::Recurrence->daily( %by );
}

sub _weekly_recurrence {
    my ($dtstart, $argsref) = @_;
    my %by;
    my %args = %$argsref;
            $by{interval} = $args{interval} if exists $args{interval};
            $by{start} =    $dtstart;
            $by{seconds} = $args{bysecond} if exists $args{bysecond};
            $by{seconds} = $dtstart->second unless exists $by{seconds};
            $by{minutes} = $args{byminute} if exists $args{byminute};
            $by{minutes} = $dtstart->minute unless exists $by{minutes};
            $by{hours} =   $args{byhour} if exists $args{byhour};
            $by{hours} =   $dtstart->hour unless exists $by{hours};

            $by{week_start_day} = $args{wkst} ?
                                  $args{wkst} : 'mo';

            # -1fr works too
            $by{days} = exists $args{byday} ?
                        [ map { $_ =~ s/[\-\+\d]+//; $weekdays{$_} } 
                              @{$args{byday}} 
                        ] :
                        $dtstart->day_of_week ;
    # warn "weekly:"._param_str(%by);

    delete $$argsref{$_}
        for qw( interval bysecond byminute byhour byday );
    return DateTime::Event::Recurrence->weekly( %by );
}

sub _monthly_recurrence {
    my ($dtstart, $argsref) = @_;
    my %by;
    my %args = %$argsref;
            $by{interval} = $args{interval} if exists $args{interval};
            $by{start} =    $dtstart;
            $by{seconds} =  $args{bysecond} if exists $args{bysecond};
            $by{seconds} =  $dtstart->second unless exists $by{seconds};
            $by{minutes} =  $args{byminute} if exists $args{byminute};
            $by{minutes} =  $dtstart->minute unless exists $by{minutes};
            $by{hours} =    $args{byhour} if exists $args{byhour};
            $by{hours} =    $dtstart->hour unless exists $by{hours};

            $by{week_start_day} = $args{wkst} ?
                                  $args{wkst} : '1mo';

    if ( exists $args{bymonthday} )
    {
                $by{days} =    $args{bymonthday};
    }
    elsif ( exists $args{byday} )
    {   
                $by{days} =    [ 1 .. 31 ];
    }
    else
    {
                $by{days} =    $dtstart->day unless exists $by{days};
    }

    my $set_byday;
    if ( exists $args{byday} )
    {
        my $freq = 'monthly';

        my %by;
            $by{seconds} = $args{bysecond} if exists $args{bysecond};
            $by{seconds} = $dtstart->second unless exists $by{seconds};
            $by{minutes} = $args{byminute} if exists $args{byminute};
            $by{minutes} = $dtstart->minute unless exists $by{minutes};
            $by{hours} =   $args{byhour} if exists $args{byhour};
            $by{hours} =   $dtstart->hour unless exists $by{hours};

        # process byday = "1FR" and "FR"
        $set_byday = _recur_1fr(
            %by, byday => $args{byday}, freq => $freq );
        delete $$argsref{$_}
            for qw( byday );
    }

    delete $$argsref{$_}
        for qw( interval bysecond byminute byhour bymonthday );
    return DateTime::Event::Recurrence->monthly( %by )->intersection( $set_byday
) if $set_byday;
    return DateTime::Event::Recurrence->monthly( %by );
}

sub _yearly_recurrence {
    my ($dtstart, $argsref) = @_;
    my %by;
    my %args = %$argsref;
            $by{interval} = $args{interval} if exists $args{interval};
            $by{start} =   $dtstart;
            $by{seconds} = $args{bysecond} if exists $args{bysecond};
            $by{seconds} = $dtstart->second unless exists $by{seconds};
            $by{minutes} = $args{byminute} if exists $args{byminute};
            $by{minutes} = $dtstart->minute unless exists $by{minutes};
            $by{hours} =   $args{byhour} if exists $args{byhour};
            $by{hours} =   $dtstart->hour unless exists $by{hours};

            $by{week_start_day} = $args{wkst} ?
                                  $args{wkst} : 'mo';
            # warn "wkst $by{week_start_day}";

    if ( exists $args{bymonth} )
    {
                $by{months} =  $args{bymonth};
                delete $$argsref{bymonth};

                $by{days} =    $args{bymonthday} if exists $args{bymonthday};
                $by{days} =    [ 1 .. 31 ] 
                    if ! exists $by{days} && 
                       exists $args{byday};
                $by{days} =    $dtstart->day unless exists $by{days};
                delete $$argsref{bymonthday};
    }
    elsif ( exists $args{byweekno} ) 
    {
                $by{weeks} =  $args{byweekno};
                delete $$argsref{byweekno};

                $by{days} =    $args{byday} if exists $args{byday};
                $by{days} =    $dtstart->day_of_week unless exists $by{days};
                delete $$argsref{byday};
    }
    elsif ( exists $args{byyearday} )
    {
                $by{days} =    $args{byyearday};
                delete $$argsref{byyearday};
    }
    elsif ( exists $args{byday} )
    {  
                $by{months} =  [ 1 .. 12 ];

                $by{days} =    $args{bymonthday} if exists $args{bymonthday};
                $by{days} =    [ 1 .. 31 ]
                    if ! exists $by{days};
                $by{days} =    $dtstart->day unless exists $by{days};
                delete $$argsref{bymonthday};
    }
    else 
    {
                $by{months} =  $dtstart->month;

                $by{days} =    $args{bymonthday} if exists $args{bymonthday};
                $by{days} =    $dtstart->day unless exists $by{days};
                delete $$argsref{bymonthday};
    }

    my $set_byday;
    if ( exists $args{byday} )
    {
        my $freq = 'yearly';
        $freq = 'monthly' if exists $args{bymonth};

        my %by;
            $by{seconds} = $args{bysecond} if exists $args{bysecond};
            $by{seconds} = $dtstart->second unless exists $by{seconds};
            $by{minutes} = $args{byminute} if exists $args{byminute};
            $by{minutes} = $dtstart->minute unless exists $by{minutes};
            $by{hours} =   $args{byhour} if exists $args{byhour};
            $by{hours} =   $dtstart->hour unless exists $by{hours};

        # process byday = "1FR" and "FR"
        $set_byday = _recur_1fr(
            %by, byday => $args{byday}, freq => $freq );
        delete $$argsref{$_}
            for qw( byday );
    }

    delete $$argsref{$_} 
        for qw( interval byday bysecond byminute byhour );
    return DateTime::Event::Recurrence->yearly( %by )->intersection( $set_byday ) if $set_byday;
    return DateTime::Event::Recurrence->yearly( %by );
}

# recurrence constructor for '1FR' specification

sub _recur_1fr {
    # ( freq , interval, dtstart, byday[ week_count . week_day ] )
    my %args = @_;
    my $base_set;
    my %days;
    my $base_duration;
    my @days_no_index;

    # parse byday
    $args{byday} = [ $args{byday} ] unless ref $args{byday} eq 'ARRAY';
    for ( @{$args{byday}} ) 
    {
        my ( $count, $day_name ) = $_ =~ /(.*)(\w\w)/;
        my $week_day = $weekdays{ $day_name };
        die "invalid week day ($day_name)" unless $week_day;
        if ( $count )
        {
            push @{$days{$day_name}}, $count;
        }
        else
        {
            # die "week count ($count) can't be zero" unless $count;
            push @days_no_index, $week_day;
        }
    }
    delete $args{byday};

    my $result;
    if ( @days_no_index )
    {
        my %_args = %args;
        $_args{days} = \@days_no_index;
        delete $_args{freq};
        $result = DateTime::Event::Recurrence->weekly( %_args );
    }
    for ( keys %days ) 
    {
        my %_args = %args;
        $_args{weeks} = $days{$_};
        $_args{week_start_day} = '1'.$_;
        # warn "creating set with $_ "._param_str( %_args );

        if ( $_args{freq} eq 'monthly' ) {
            $base_duration = 'months';
            delete $_args{freq};
            # warn "creating base set with "._param_str( %args );
            $base_set = DateTime::Event::Recurrence->monthly( %_args )
        }
        elsif ( $_args{freq} eq 'yearly' ) {
            $base_duration = 'years';
            delete $_args{freq};
            $base_set = DateTime::Event::Recurrence->yearly( %_args )
        }
        else {
            die "invalid freq ($_args{freq})";
        }

        $result = $result ?
                  $result->union( $base_set ) :
                  $base_set;
    }
    return $result;
}

# bysetpos constructor

sub _recur_bysetpos {
    # ( freq , interval, bysetpos, recurrence )
    my %args = @_;
    # my $names = $freqs{ $args{freq} }{names};
    # my $name =  $freqs{ $args{freq} }{name};
    no strict "refs";

    my $freq = $args{freq};

    my $base_set = DateTime::Event::Recurrence->$freq();

    # die "invalid freq parameter ($args{freq})" 
    #    unless exists $DateTime::Event::Recurrence::truncate_interval{ $names };
    #my $truncate_interval_sub = 
    #    $DateTime::Event::Recurrence::truncate_interval{ $names };
    #my $next_unit_sub =
    #    $DateTime::Event::Recurrence::next_unit{ $names };
    #my $previous_unit_sub =
    #    $DateTime::Event::Recurrence::previous_unit{ $names };

    $args{bysetpos} = [ $args{bysetpos} ]
        unless ref( $args{bysetpos} );
    # die "invalid bysetpos parameter [@{$args{bysetpos}}]" 
    #     unless @{$args{bysetpos}};
    # print STDERR "bysetpos:  [@{$args{bysetpos}}]\n";
    for ( @{$args{bysetpos}} ) { $_-- if $_ > 0 }

    return DateTime::Set->from_recurrence (
        next =>
        sub {

            return $_[0] if $_[0]->is_infinite;

            ## return undef unless defined $_[0];
            my $self = $_[0]->clone;
            # warn "bysetpos: next of ".$_[0]->datetime;
            # print STDERR "    list [@{$args{bysetpos}}] \n";
            # print STDERR "    previous: ".$base_set->current( $_[0] )->datetime."\n";
            my $start = $base_set->current( $_[0] );
            while(1) {
                my $end   = $base_set->next( $start->clone );
                if ( $#{$args{bysetpos}} == 0 ) {
                    # optimize by using 'next' instead of 'intersection'

                    my $pos = $args{bysetpos}[0];
                    if ( $pos >= 0 ) {
                        my $next = $start->clone;
                        $next->subtract( nanoseconds => 1 );
                        while ( $pos-- >= 0 ) { 
                            # print STDERR "    next: $pos ".$next->datetime."\n";
                            $next = $args{recurrence}->next( $next ) 
                        }
                        return $next if $next > $self;
                    }
                    else {
                        my $next = $end->clone;
                        while ( $pos++ < 0 ) { 
                            # print STDERR "    previous: $pos ".$next->datetime."\n";
                            $next = $args{recurrence}->previous( $next ) 
                        }
                        return $next if $next > $self;
                    }

                }
                else {
                    # print STDERR "    base: ".$start->datetime." ".$end->datetime."\n";
                    my $span = DateTime::Span->from_datetimes( 
                              start => $start,
                              before => $end );
                    # print STDERR "    done span\n";
                    my $subset = $args{recurrence}->intersection( $span );
                    my @list = $subset->as_list;
                    # print STDERR "    got list ".join(",", map{$_->datetime}@list)."\n";

                    # select
                    my @l = @list[ @{$args{bysetpos}} ];
                    @l = grep { defined $_ } @l;
                    @list = sort { $a <=> $b } @l;
                    ## @list = sort { $a <=> $b } @list[ @{$args{bysetpos}} ];

                    # print STDERR "    selected [@{$args{bysetpos}}]".join(",", map{$_->datetime}@list)."\n";
                    for ( @list ) {
                        # print STDERR "    choose: ".$_->datetime."\n" if $_ > $self;
                        return $_ if $_ > $self;
                    }
                }
                $start = $end;
            }  # /while
        },
        previous =>
        sub {

            return $_[0] if $_[0]->is_infinite;

            my $self = $_[0]->clone;
            # warn "bysetpos: previous of ".$_[0]->datetime;
            # print STDERR "    previous: ".$base_set->current( $_[0] )->datetime."\n";
            my $start = $base_set->current( $_[0] );
            my $end   = $base_set->next( $start->clone );
            my $count = 10;
            while(1) {
                # print STDERR "    base: ".$start->datetime." ".$end->datetime."\n";
                my $span = DateTime::Span->from_datetimes(
                          start => $start,
                          before => $end );
                # print STDERR "    done span\n";
                my $subset = $args{recurrence}->intersection( $span );
                my @list = $subset->as_list;
                # print STDERR "    got list ".join(",", map{$_->datetime}@list)."\n";

                # select
                my @l = @list[ @{$args{bysetpos}} ];
                @l = grep { defined $_ } @l;
                @list = sort { $b <=> $a } @l;
                ## @list = sort { $a <=> $b } @list[ @{$args{bysetpos}} ];

                # print STDERR "    selected [@{$args{bysetpos}}]".join(",", map{$_->datetime}@list)."\n";
                for ( @list ) {
                    return $_ if $_ < $self;
                }
                return undef unless $count--;
                $end = $start;
                $start = $base_set->previous( $start );
            }  # /while
        }
    );
}

# map frequencies to recurrence constructors
{
  my %frequencies = (
        secondly => \&_secondly_recurrence,
        minutely => \&_minutely_recurrence,
        hourly   => \&_hourly_recurrence,
        daily    => \&_daily_recurrence,
        monthly  => \&_monthly_recurrence,
        weekly   => \&_weekly_recurrence,
        yearly   => \&_yearly_recurrence,
       );

  sub _recur_by_freq {
    my ($freq,$dtstart,$args) = @_;

    return $frequencies{$freq}->($dtstart,$args)
      if exists $frequencies{$freq};

    return undef;
  }
}

# main recurrence constructor

sub recur {
    my $class = shift;
    my %args = @_;
    my %args_backup = @_;

    if ( exists $args{count} )
    {
        # count
        my $n = $args{count};
        delete $args{count};
        my $count_inf = $class->recur( %args )->{set}
                  ->select( count => $n );
        return bless { set => $count_inf }, 'DateTime::Set';
    }

    # warn "recur:"._param_str(%args);

    # stringify the argument list - will be used by format_recurrence !
    my %tmp_args = @_;
    delete $tmp_args{dtstart};
    delete $tmp_args{dtend};
    my $recur_str = _param_str(%tmp_args);

    # dtstart / dtend / until
    my $span = 
        exists $args{dtstart} ?
            DateTime::Span->from_datetimes( start => $args{dtstart} ) :
            DateTime::Set->empty_set->complement;

    $span = $span->complement( 
                DateTime::Span->from_datetimes( after => delete $args{dtend} )
            ) if exists $args{dtend};

    $span = $span->complement(
                DateTime::Span->from_datetimes( after => delete $args{until} )
            ) if exists $args{until};
    # warn 'SPAN '. $span->{set};

    $args{interval} = 1 unless $args{interval};

    # setup the "default time"
    my $dtstart = exists $args{dtstart} ?
            delete $args{dtstart} : 
            DateTime->new( year => 2000, month => 1, day => 1 );
    # warn 'DTSTART '. $dtstart->datetime;

    # rewrite: daily-bymonth to yearly-bymonth-bymonthday[1..31]
    if ( $args{freq} eq 'daily' ) {
        if ( exists $args{bymonth} &&
             $args{interval} == 1 ) 
        {
            $args{freq} = 'yearly';
            $args{bymonthday} = [ 1 .. 31 ] unless exists $args{bymonthday};
            # warn "rewrite recur:"._param_str(%args);
        }
    }

    my $base_set;
    my %by;

    $base_set = _recur_by_freq($args{freq},$dtstart,\%args);
    unless (defined $base_set) {
        die "invalid freq ($args{freq})";
    }

    delete $args{wkst};    # TODO: wkst

    # warn "\ncomplex recur:"._param_str(%args);

    %by = ();
    my $has_day = 0;

    my $by_year_day;
    if ( exists $args{byyearday} ) 
    {
        $by_year_day = _yearly_recurrence($dtstart, \%args);
    }

    my $by_month_day;
    if ( exists $args{bymonthday} ||
         exists $args{bymonth} ) 
    {
        my %by = %args;
        $by{byhour} = $args_backup{byhour} if $args_backup{byhour};
        $by{byhour} = [ 0 .. 23 ] if $args{freq} eq 'hourly';
        $by{byminute} = $args_backup{byminute} if $args_backup{byminute};
        $by{byminute} = [ 0 .. 59 ] if $args{freq} eq 'minutely';
        $by{bysecond} = $args_backup{bysecond} if $args_backup{bysecond};
        $by{bysecond} = [ 0 .. 59 ] if $args{freq} eq 'secondly';
        $by_month_day = _yearly_recurrence($dtstart, \%by);
        delete $args{bymonthday};
        delete $args{bymonth};
    }

    my $by_week_day;
    # TODO: byweekno without byday
    if ( exists $args{byday} ||
         exists $args{byweekno} ) 
    {
        my %by = %args;
        $by{byhour} = $args_backup{byhour} if $args_backup{byhour};
        $by{byhour} = [ 0 .. 23 ] if $args{freq} eq 'hourly';
        $by{byminute} = $args_backup{byminute} if $args_backup{byminute};
        $by{byminute} = [ 0 .. 59 ] if $args{freq} eq 'minutely';
        $by{bysecond} = $args_backup{bysecond} if $args_backup{bysecond};
        $by{bysecond} = [ 0 .. 59 ] if $args{freq} eq 'secondly';
        $by_week_day = _weekly_recurrence($dtstart, \%by);
        delete $args{byday};
        delete $args{byweekno};
    }

    my $by_hour;
    if ( exists $args{byhour} ) 
    {
        my %by = %args;
        $by{byminute} = $args_backup{byminute} if $args_backup{byminute};
        $by{byminute} = [ 0 .. 59 ] if $args{freq} eq 'minutely';
        $by{bysecond} = $args_backup{bysecond} if $args_backup{bysecond};
        $by{bysecond} = [ 0 .. 59 ] if $args{freq} eq 'secondly';
        $by_hour = _daily_recurrence($dtstart, \%by);
        delete $args{byhour};
    }

    # join the rules together

    $base_set = $base_set && $by_year_day ?
                $base_set->intersection( $by_year_day ) :
                ( $base_set ? $base_set : $by_year_day );
    $base_set = $base_set && $by_month_day ?
                $base_set->intersection( $by_month_day ) :
                ( $base_set ? $base_set : $by_month_day );
    $base_set = $base_set && $by_week_day ?
                $base_set->intersection( $by_week_day ) :
                ( $base_set ? $base_set : $by_week_day );
    $base_set = $base_set && $by_hour ?
                $base_set->intersection( $by_hour ) :
                ( $base_set ? $base_set : $by_hour );

    # TODO:
    # wkst
    # bysetpos

    if ( exists $args{bysetpos} ) {
        $base_set = _recur_bysetpos (
            freq => $args{freq},
            interval => $args{interval},
            bysetpos => $args{bysetpos},
            recurrence => $base_set );
        delete $args{bysetpos};
    }

    $base_set = $base_set->intersection( $span )
                if $span;

    # check for nonprocessed arguments
    delete $args{freq};
    my @args = %args;
    die "these arguments are not implemented: "._param_str(%args) if @args;

    bless $base_set, 'DateTime::Set::ICal';
    $base_set->set_ical( include => [ uc('rrule:'.$recur_str) ] ); 

    return $base_set;
}

__END__

=head1 NAME

DateTime::Event::ICal - Perl DateTime extension for computing rfc2445 recurrences.

=head1 SYNOPSIS

 use DateTime;
 use DateTime::Event::ICal;

 my $dt = DateTime->new( year   => 2000,
                         month  => 6,
                         day    => 20,
                       );

 my $set = DateTime::Event::ICal->recur( 
      dtstart => $dt,
      freq =>    'daily',
      bymonth => [ 10, 12 ],
      byhour =>  [ 10 ]
 );

 my $dt_next = $set->next( $dt );

 my $dt_previous = $set->previous( $dt );

 my $bool = $set->contains( $dt );

 my @days = $set->as_list( start => $dt1, end => $dt2 );

 my $iter = $set->iterator;

 while ( my $dt = $iter->next ) {
     print ' ', $dt->datetime;
 }

=head1 DESCRIPTION

This module provides convenience methods that let you easily create
C<DateTime::Set> objects for rfc2445 style recurrences.

=head1 USAGE

=over 4

=item recur

This method returns a L<DateTime::Set> object representing the
given recurrence.

  my $set = DateTime::Event::ICal->recur( %args );

This method takes parameters which correspond to the rule parts
specified in section 4.3.10 of RFC 2445.  Rather than rewrite that RFC
here, you are encouraged to read that first if you want to understand
what all these parameters represent.

=over 4

=item * dtstart

A L<DateTime> object, which is the start date.

This datetime is not included in the recurrence, unless it satisfies
the recurrence's rules.

A set can thus be used for creating exclusion rules (rfc2445
C<exrule>), which don't include C<dtstart>.

=item * until

A DateTime object which specifies the recurrence's end date.  Can also
be specified as "dtend".

=item * count

A positive number which indicate the total number of recurrences.
Giving both a "count" and an "until" parameter is pointless, though it
is currently allowed.

=item * freq

One of:

   "yearly", "monthly", "weekly", "daily",
   "hourly", "minutely", "secondly"

See the C<DateTime::Event::Recurrence> documentation for more details
on what these mean.

=item * interval

The interval between recurrences.  This is a multiplier for the value
specified by "freq".  It defaults to 1.

So if you specify a "freq" of "yearly" and an "interval" of 3, that
means a recurrence that occurs every three years.

=item * wkst

Week start day.  This can be one of: "mo", "tu", "we", "th", "fr",
"sa", "su".  The default is Monday ("mo").

B<Note: this parameter is not yet implemented>

=item * bysecond => [ list ], byminute => [ list ], byhour => [ list ]

This should be one or more positive or numbers, specified as a scalar
or array reference.  Each number represents a second/minute/hour.

See RFC 2445, section 4.3.10 for more details.

=item * byday => [ list ]

This should be a scalar or array reference containing days of the
week, specified as "mo", "tu", "we", "th", "fr", "sa", "su"

The day of week may have a prefix:

 "1tu",  # the first tuesday of month or year
 "-2we"  # the second to last wednesday of month or year

See RFC 2445, section 4.3.10 for more details.

=item * bymonthday => [ list ], byyearday => [ list ]

A scalar or array reference containing positive or negative numbers,
but not zero.  For "bymonthday", the allowed ranges are -31 to -1.
For "byyearday", the allowed ranges are -366 to -1, and 1 to 366.

Day -1 is last day of month or year.

See RFC 2445, section 4.3.10 for more details.

=item * byweekno => [ list ]

A scalar or array reference containing positive or negative numbers,
but not zero.  The allowed ranges are -53 to -1, and 1 to 53.

The first week of year is week 1.

The default week start day is Monday.

Week -1 is the last week of year.

See RFC 2445, section 4.3.10 for more details.

=item * bymonth => [ list ]

A scalar or array reference containing positive or negative numbers,
from -12 to -1 and 1 to 12.

Month -1 is December.

See RFC 2445, section 4.3.10 for more details.

=item * bysetpos => [ list ]

This can be either a scalar or an array reference of positive and
negative numbers from -366 to -1, and 1 to 366.  This parameter is
used in conjunction with one of the other "by..." parameters.

See RFC 2445, section 4.3.10 for more details.

=back

=back

=head1 AUTHOR

Flavio Soibelmann Glock
fglock@gmail.com

=head1 CREDITS

The API was developed with help from the people
in the datetime@perl.org list. 

=head1 COPYRIGHT

Copyright (c) 2003 Flavio Soibelmann Glock.  
All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

datetime@perl.org mailing list

L<DateTime Web page|http://datetime.perl.org/>

The L<DateTime> module.

L<DateTime::Event::Recurrence> - simple rule-based recurrences.

L<DateTime::Format::ICal> - can parse rfc2445 recurrences.

L<DateTime::Set> - recurrences defined by callback subroutines.

L<DateTime::Event::Cron> - recurrences defined by "cron" rules.

L<DateTime::SpanSet>

L<RFC2445|http://www.ietf.org/rfc/rfc2445.txt> -
Internet Calendaring and Scheduling Core Object Specification.

=cut


