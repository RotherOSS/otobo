package DateTime::Format::ICal;

use strict;

use vars qw ($VERSION);

$VERSION = '0.09';

use DateTime;
use DateTime::Span;
use DateTime::Event::ICal;

use Params::Validate qw( validate_with SCALAR );

sub new
{
    my $class = shift;

    return bless {}, $class;
}

# key is string length
my %valid_formats =
    ( 15 =>
      { params => [ qw( year month day hour minute second ) ],
        regex  => qr/^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)$/,
      },
      13 =>
      { params => [ qw( year month day hour minute ) ],
        regex  => qr/^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)$/,
      },
      11 =>
      { params => [ qw( year month day hour ) ],
        regex  => qr/^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)$/,
      },
      8 =>
      { params => [ qw( year month day ) ],
        regex  => qr/^(\d\d\d\d)(\d\d)(\d\d)$/,
      },
    );

sub parse_datetime
{
    my ( $self, $date ) = @_;

    # save for error messages
    my $original = $date;

    my %p;
    if ( $date =~ s/^TZID=([^:]+):// )
    {
        $p{time_zone} = $1;
    }
    # Z at end means UTC
    elsif ( $date =~ s/Z$// )
    {
        $p{time_zone} = 'UTC';
    }
    else
    {
        $p{time_zone} = 'floating';
    }

    my $format = $valid_formats{ length $date }
        or die "Invalid iCal datetime string ($original)\n";

    @p{ @{ $format->{params} } } = $date =~ /$format->{regex}/;

    return DateTime->new(%p);
}

sub parse_duration
{
    my ( $self, $dur ) = @_;

    my @units = qw( weeks days hours minutes seconds );

    $dur =~ m{ ([\+\-])?         # Sign
               P                 # 'P' for period? This is our magic character)
               (?:
                   (?:(\d+)W)?   # Weeks
                   (?:(\d+)D)?   # Days
               )?
               (?: T             # Time prefix
                   (?:(\d+)H)?   # Hours
                   (?:(\d+)M)?   # Minutes
                   (?:(\d+)S)?   # Seconds
               )?
             }x;

    my $sign = $1;

    my %units;
    $units{weeks}   = $2 if defined $2;
    $units{days}    = $3 if defined $3;
    $units{hours}   = $4 if defined $4;
    $units{minutes} = $5 if defined $5;
    $units{seconds} = $6 if defined $6;

    die "Invalid ICal duration string ($dur)\n"
        unless %units;

    if ( defined $sign && $sign eq '-' )
    {
        # $_ *= -1 foreach values %units;  - does not work in 5.00503
        $units{$_} *= -1 foreach keys %units;
    }

    return DateTime::Duration->new(%units);
}

sub parse_period
{
    my ( $self, $period ) = @_;

    my ( $start, $end ) = $period =~ /^((?:TZID=[^:]+:)?.*?)\/(.*)/;

    die "Invalid ICal period string ($period)\n"
        unless $start && $end;

    $start = $self->parse_datetime( $start );

    if ( $end =~ /[\+\-]P/i ) {
        $end = $start + $self->parse_duration( $end );
    }
    else
    {
        $end = $self->parse_datetime( $end );
    }

    die "Invalid ICal period: end before start ($period)\n"
        if $start > $end;

    return DateTime::Span->new( start => $start, end => $end );
}

sub parse_recurrence
{
    my $self = shift;
    my %p = validate_with( params => \@_,
                           spec   => { recurrence => { type => SCALAR } },
                           allow_extra => 1,
                         );

    my $recurrence = delete $p{recurrence};

    # recurrence may start with RRULE:
    $recurrence =~ s/^(?:RRULE|EXRULE)://i;

    # parser: adapted from code written for Date::Set by jesse
    # RRULEs look like 'FREQ=foo;INTERVAL=bar;' etc.
    foreach ( split /;/, $recurrence )
    {
        my ( $name, $value ) = split /=/;

        $name  = lc $name;

        # BY<FOO> parameters should be arrays. everything else should be strings
        if ( $name eq 'until' )
        {
            $p{$name} = __PACKAGE__->parse_datetime( $value );
        }
        elsif ( $name =~ /^by/i )
        {
            $p{$name} = [ split /,/, lc( $value ) ];
        }
        else
        {
            $p{$name} = lc( $value );
        }
    }

    return DateTime::Event::ICal->recur(%p);
}

sub format_datetime
{
    my ( $self, $dt ) = @_;

    my $tz = $dt->time_zone;

    unless ( $tz->is_floating ||
             $tz->is_utc ||
             $tz->is_olson )
    {
        $dt = $dt->clone->set_time_zone('UTC');
        $tz = $dt->time_zone;
    }

    my $base =
        sprintf( '%04d%02d%02dT%02d%02d%02d',
                 $dt->year, $dt->month, $dt->day,
                 $dt->hour, $dt->minute, $dt->second );

    return $base if $tz->is_floating;

    return $base . 'Z' if $tz->is_utc;

    return 'TZID=' . $tz->name . ':' . $base;
}

sub format_duration
{
    my ( $self, $duration ) = @_;

    die "Cannot represent years or months in an iCal duration\n"
        if $duration->delta_months;

    # simple string for 0-length durations
    return '+PT0S'
        unless $duration->delta_days ||
               $duration->delta_minutes ||
               $duration->delta_seconds;

    my $ical = $duration->is_positive ? '+' : '-';
    $ical .= 'P';

    if ( $duration->delta_days )
    {
        $ical .= $duration->weeks . 'W' if $duration->weeks;
        $ical .= $duration->days  . 'D' if $duration->days;
    }

    if ( $duration->delta_minutes || $duration->delta_seconds )
    {
        $ical .= 'T';

        $ical .= $duration->hours   . 'H' if $duration->hours;
        $ical .= $duration->minutes . 'M' if $duration->minutes;
        $ical .= $duration->seconds . 'S' if $duration->seconds;
    }

    return $ical;
}


sub format_period
{
    my ( $self, $span ) = @_;

    return $self->format_datetime( $span->start ) . '/' .
           $self->format_datetime( $span->end ) ;
}

sub format_period_with_duration
{
    my ( $self, $span ) = @_;

    return $self->format_datetime( $span->start ) . '/' .
           $self->format_duration( $span->duration ) ;
}


sub _split_datetime_tz 
{
    my ( $self, $dt ) = @_;

    my $tz = $dt->time_zone;

    unless ( $tz->is_floating ||
             $tz->is_utc ||
             $tz->is_olson )
    {
        $dt = $dt->clone->set_time_zone('UTC');
        $tz = $dt->time_zone;
    }

    my $base =
        ( $dt->hour || $dt->min || $dt->sec ?
          sprintf( '%04d%02d%02dT%02d%02d%02d',
                   $dt->year, $dt->month, $dt->day,
                   $dt->hour, $dt->minute, $dt->second ) :
          sprintf( '%04d%02d%02d', $dt->year, $dt->month, $dt->day )
        );

    return ($base, '')    if $tz->is_floating;
    return ($base, 'UTC') if $tz->is_utc;
    return ($base, $tz->name);
}

sub format_recurrence
{
    my ( $self, $set, @more ) = @_;
    my @result;

    # normalize param to either DT::Set or DT::SpanSet
    # DT list =>       convert to DT::Set
    # DT::Span list => convert to DT::SpanSet

    if ( $set->isa('DateTime') )
    {
        $set = DateTime::Set->from_datetimes( dates => [ $set, @more ] );
    }
    elsif ( $set->isa('DateTime::Span') )
    {
        $set = DateTime::SpanSet->from_spans( spans => [ $set, @more ] );
    }

    # is it a recurrence?
    if ( $set->{set}->is_too_complex )
    {
        # DT::Set recurrence => DTSTART;timezone:date CRLF
        #                       RRULE:params CRLF
        #   note: add more lines if necessary:
        #             union =        more RRULE/RDATE lines
        #             complement =   more EXRULE/EXDATE lines
        #             intersection = ?
        #   note: timezone is specified by DTSTART only.

        # TODO: add support to DT::Event::Recurrence objects

        if ( $set->can( 'get_ical' ) && defined $set->get_ical )
        {
            my %ical = $set->get_ical;
            for ( @{ $ical{include} } )
            {
                next unless $_;
                if ( ref( $_ ) )
                {
                    push @result, $self->format_recurrence( $_ );
                }
                else
                {
                    push @result, $_;
                }
            }
            if ( $ical{exclude} )
            {
                my @exclude;
                for ( @{ $ical{exclude} } )
                {
                    next unless $_;
                    if ( ref( $_ ) )
                    {
			push @exclude, $self->format_recurrence( $_ );
                    }
                    else
                    {
			push @exclude, $_;
                    }
                }
                s/^RDATE/EXDATE/ for @exclude;
                s/^RRULE/EXRULE/ for @exclude;
                push @result, @exclude;
            }
        }
        else
        {
            die "format_recurrence() - Format not implemented for this unbounded set";
        }

        # end: format recurrence
    }
    else
    {
        # DT::Set  =>        RDATE:datetime,datetime,datetime CRLF
        # DT::SpanSet =>     RDATE;VALUE=PERIOD:period,period CRLF
        #
        # not supported =>   RDATE;VALUE=DATE:date,date,date CRLF
        #
        # DT::Set w/tz =>     RDATE;timezone:date,date CRLF
        # DT::SpanSet w/tz => RDATE;VALUE=PERIOD;timezone:period,period CRLF

        my $iterator = $set->iterator;
        my $last_type = 'DateTime';
        my $last_tz =   'invalid';
        my $item;

        while( $item = $iterator->next )
        {
            if( $item->isa('DateTime') )
            {
                my ($base,$tz) = $self->_split_datetime_tz( $item );
                if( $last_tz eq $tz &&
                    $last_type eq 'DateTime' )
                {
                    $result[-1] .= ',' . $base;
                    $result[-1] .= 'Z' if $tz eq 'UTC';
                }
                else
                {
                    push @result, 'RDATE';
                    $result[-1] .= ';TZID='.$tz if $tz ne '' && $tz ne 'UTC';
                    $result[-1] .= ':' . $base;
                    $result[-1] .= 'Z' if $tz eq 'UTC';
                    $last_tz =   $tz;
                    $last_type = 'DateTime';
                }
            }
            elsif( $item->isa('DateTime::Span') )
            {
                my $item_start = $item->start;
                my $item_end =   $item->end;
                if ( $item_start == $item_end )
                {
                    $item = $item_start;
                    # item looks like a datetime
                    redo;
                }
                my ($start,$tz) = $self->_split_datetime_tz( $item_start );
                $item_end->set_time_zone( $tz );
                my ($end,undef) = $self->_split_datetime_tz( $item_end );
                if( $last_tz eq $tz &&
                    $last_type eq 'DateTime::Span' )
                {
                    $result[-1] .= ',' . $start;
                    $result[-1] .= 'Z' if $tz eq 'UTC';
                    $result[-1] .= '/' . $end;
                    $result[-1] .= 'Z' if $tz eq 'UTC';
                }
                else
                {
                    push @result, 'RDATE;VALUE=PERIOD';
                    $result[-1] .= ';TZID='.$tz if $tz ne '' && $tz ne 'UTC';
                    $result[-1] .= ':' . $start;
                    $result[-1] .= 'Z' if $tz eq 'UTC';
                    $result[-1] .= '/' . $end;
                    $result[-1] .= 'Z' if $tz eq 'UTC';
                    $last_tz =   $tz;
                    $last_type = 'DateTime::Span';
                }
            }
            else
            {
                die 'unexpected data type "'.ref($item).'" in set';
            }
        }

        # end: format list of dates
    }
    return join( "\n", @result ) if ! wantarray;
    return @result;
}

1;

__END__

=head1 NAME

DateTime::Format::ICal - Parse and format iCal datetime and duration strings

=head1 SYNOPSIS

  use DateTime::Format::ICal;

  my $dt = DateTime::Format::ICal->parse_datetime( '20030117T032900Z' );

  my $dur = DateTime::Format::ICal->parse_duration( '+P3WT4H55S' );

  # 20030117T032900Z
  DateTime::Format::ICal->format_datetime($dt);

  # +P3WT4H55S
  DateTime::Format::ICal->format_duration($dur);

=head1 DESCRIPTION

This module understands the ICal date/time and duration formats, as
defined in RFC 2445.  It can be used to parse these formats in order
to create the appropriate objects.

=head1 METHODS

This class offers the following methods.

=over 4

=item * parse_datetime($string)

Given an iCal datetime string, this method will return a new
C<DateTime> object.

If given an improperly formatted string, this method may die.

=item * parse_duration($string)

Given an iCal duration string, this method will return a new
C<DateTime::Duration> object.

If given an improperly formatted string, this method may die.

=item * parse_period($string)

Given an iCal period string, this method will return a new
C<DateTime::Span> object.

If given an improperly formatted string, this method may die.

=item * parse_recurrence( recurrence => $string, ... )

Given an iCal recurrence description, this method uses
C<DateTime::Event::ICal> to create a C<DateTime::Set> object
representing that recurrence.  Any parameters given to this method
beside "recurrence" will be passed directly to the 
C<< DateTime::Event::ICal->recur >> method.

If given an improperly formatted string, this method may die.

This method accepts optional parameters "dtstart" and "dtend".
These parameters must be C<DateTime> objects.

The iCal spec requires that "dtstart" always be included in the
recurrence set, unless this is an "exrule" statement.  Since we don't
know what kind of statement is being parsed, we do not include
C<dtstart> in the recurrence set.

=item * format_datetime($datetime)

Given a C<DateTime> object, this methods returns an iCal datetime
string.

The iCal spec requires that datetimes be formatted either as floating
times (no time zone), UTC (with a 'Z' suffix) or with a time zone id
at the beginning ('TZID=America/Chicago;...').  If this method is
asked to format a C<DateTime> object that has an offset-only time
zone, then the object will be converted to the UTC time zone
internally before formatting.

For example, this code:

    my $dt = DateTime->new( year => 1900, hour => 15, time_zone => '-0100' );

    print $ical->format_datetime($dt);

will print the string "19000101T160000Z".

=item * format_duration($duration)

Given a C<DateTime::Duration> object, this methods returns an iCal
duration string.

The iCal standard does not allow for months or years in a duration, so
if a duration for which C<delta_months()> is not zero is given, then
this method will die.

=item * format_period($span)

Given a C<DateTime::Span> object, this methods returns an iCal
period string, using the format C<DateTime/DateTime>.

=item * format_period_with_duration($span)

Given a C<DateTime::Span> object, this methods returns an iCal
period string, using the format C<DateTime/Duration>.

=item * format_recurrence($arg [,$arg...] )

This method returns a list of strings containing ICal statements.
In scalar context it returns a single string which may contain
embedded newlines.

The argument can be a C<DateTime> list, a C<DateTime::Span> list, a
C<DateTime::Set>, or a C<DateTime::SpanSet>.

ICal C<DATE> values are not supported. Whenever a date value is found,
a C<DATE-TIME> is generated.

If a recurrence has an associated C<DTSTART> or C<DTEND>, those values
must be formatted using C<format_datetime()>.  The
C<format_recurrence()> method will not do this for you.

If a C<union> or C<complement> of recurrences is being formatted, they
are assumed to have the same C<DTSTART> value.

Only C<union> and C<complement> operations are supported for
recurrences.  This is a limitation of the ICal specification.

If given a set it cannot format, this method may die.

Only C<DateTime::Set::ICal> objects are formattable.  A set may change
class after some set operations:

    $recurrence = $recurrence->union( $dt_set );
    # Ok - $recurrence still is a DT::Set::ICal

    $recurrence = $dt_set->union( $recurrence );
    # Not Ok! - $recurrence is a DT::Set now

The only unbounded recurrences currently supported are the ones
generated by the C<DateTime::Event::ICal> module.

You can add ICal formatting support to a custom recurrence by using
the C<DateTime::Set::ICal> module:

    $custom_recurrence =
        DateTime::Set::ICal->from_recurrence
            ( recurrence =>
              sub { $_[0]->truncate( to => 'month' )->add( months => 1 ) }
            );
    $custom_recurrence->set_ical( include => [ 'FREQ=MONTHLY' ] );

=back

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list.  See http://lists.perl.org/ for more details.

=head1 AUTHORS

Dave Rolsky <autarch@urth.org> and Flavio Soibelmann Glock
<fglock@pucrs.br>

Some of the code in this module comes from Rich Bowen's C<Date::ICal>
module.

=head1 COPYRIGHT

Copyright (c) 2003 David Rolsky.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

The full text of the license can be found in the LICENSE file included
with this module.

=head1 SEE ALSO

datetime@perl.org mailing list

http://datetime.perl.org/

=cut
