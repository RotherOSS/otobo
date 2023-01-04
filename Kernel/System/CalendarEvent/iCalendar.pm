# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2021-2022 Znuny GmbH, https://znuny.org/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

# This file is based on https://github.com/znuny/Znuny/blob/rel-6_4-dev/Kernel/System/CalendarEvents/ICS.pm e856762c0d5221825ac4876d19cc21897a0b28fb
# It was renamed from Kernel/System/CalendarEvents/ICS.pm to Kernel/System/CalendarEvent/iCalendar.pm
# as the OTOBO convention is to use singular in module names and the name of the file format is iCalendar.

package Kernel::System::CalendarEvent::iCalendar;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules
use Scalar::Util qw(reftype);

# CPAN modules
use Data::ICal 0.22;
use DateTime::TimeZone 2.18;
use DateTime::TimeZone::ICal 0.04;
use DateTime::Format::ICal;

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);
use Kernel::System::DateTime;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::HTMLUtils',
    'Kernel::System::DateTime',
    'Kernel::System::Encode',
);

=head1 NAME

Kernel::System::CalendarEvent::iCalendar - to parse i Calendar event files, aka ics files

=head1 DESCRIPTION

Global module for operations on file in the i Calendar format.
See RFC 5545 https://www.rfc-editor.org/rfc/rfc5545.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ICalendarObject = $Kernel::OM->Get('Kernel::System::CalendarEvent::iCalendar');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {%Param}, $Type;

    $Self->{GlobalPropertiesMap} = {
        Events => {
            DESCRIPTION => 'Description',
            SUMMARY     => 'Title',
            LOCATION    => 'Location',
            ATTENDEE    => 'Attendee',
            ORGANIZER   => 'Organizer',
        }
    };

    $Self->{DetailsPropertiesMap} = {
        Keys => {
            FREQ       => "Frequency",
            UNTIL      => "Until",
            INTERVAL   => "Interval",
            BYSECOND   => "BySecond",
            BYMINUTE   => "ByMinute",
            BYHOUR     => "ByHour",
            BYDAY      => "ByDay",
            BYMONTHDAY => "ByMonthDay",
            BYYEARDAY  => "ByYearDay",
            BYWEEKNO   => "ByWeek",
            BYMONTH    => "ByMonth",
            BYSETPOS   => "BySetPos",
            WKST       => "WeekDay",
            TYPE       => "Type",
        },
        Values => {
            YEARLY    => "Yearly",
            MONTHLY   => "Monthly",
            WEEKLY    => "Weekly",
            DAILY     => "Daily",
            HOURLY    => "Hourly",
            MINUTELY  => "Minutely",
            SECONDELY => "Secondely",
            SPAN      => "Span",
            RECURRENT => "Recurrent",
        }
    };

    return $Self;
}

=head2 Parse()

Parses i Calendar string.

    my $Result = $ICalendarObject->Parse(
        String =>
            "BEGIN:VCALENDAR
            ..
            END:VCALENDAR",
    );

=cut

sub Parse {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    NEEDED:
    for my $Needed (qw(String)) {
        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );

        return;
    }

    my $StringData = $Self->_PreProcess(
        String => $Param{String},
    );

    return unless IsHashRefWithData($StringData);

    my $String = $StringData->{Value};

    return unless IsStringWithData($String);

    my $Calendar;
    eval {
        $Calendar = Data::ICal->new( data => $String );
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "There was an error on initializing iCalendar event: $@"
        );

        return;
    }

    return unless $Calendar;

    my $Result = $Self->_PrepareData(
        Calendar       => $Calendar,
        AdditionalData => $StringData->{AdditionalData}
    );

    return $Result;
}

=head2 _PrepareData()

Standardizes/post-processes data hash from parsed data.

    my $Result = $ICalendarObject->_PrepareData(
        Calendar => $Calendar,              # a Data::ICal object
        TimeZone => 'Antarctica/Rothera',
    );

=cut

sub _PrepareData {
    my ( $Self, %Param ) = @_;

    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $EncodeObject    = $Kernel::OM->Get('Kernel::System::Encode');

    return unless reftype( $Param{Calendar} ) eq 'HASH';

    my $Calendar = $Param{Calendar};

    return unless $Calendar->isa('Data::ICal');
    return unless $Calendar->ical_entry_type eq 'VCALENDAR';

    # there is only one calendar, which is $Param{Calendar} itself
    my %Result = (
        Calendars => [],
        Events    => [],
    );

    # Explicit support for the custome properties X-WR-CALNAME and X-WR-TIMEZONE,
    # because the alternative parser iCal::Parser supports those.
    # The list of declared time zones is only informational. Let's keep track of the time zone
    # declared in X-WR-TIMEZONE and the time zones from the VTIMEZONE entries.
    # Do not trust Data::ICal::product_id(), see https://github.com/bestpractical/data-ical/issues/4.
    # There is only a single calendar.
    {
        my @TimeZones;
        if ( $Calendar->property('x-wr-timezone') ) {
            push @TimeZones,
                map { $_->value }
                $Calendar->property('x-wr-timezone')->@*;
        }

        push $Result{Calendars}->@*, {
            Name      => ( $Calendar->property('x-wr-calname') ? $Calendar->property('x-wr-calname')->[0]->value : undef ),
            ProdID    => ( $Calendar->property('prodid')       ? $Calendar->property('prodid')->[0]->value       : undef ),
            TimeZones => \@TimeZones,
        };
    }

    my $Entries = $Calendar->entries;

    return \%Result unless IsArrayRefWithData($Entries);

    my %UIDSeen;
    my %EventResult;
    my $TimeZone;
    my $AllDay;
    my $Dfmt = DateTime::Format::ICal->new;

    # First collect the declared time zones
    # A VTIMEZONE entry declares a time zone that can be used in DTSTART and DTEND of events that follow.
    # It does not declare a default time zone.
    my %DeclaredTimeZone;
    ENTRY:
    for my $Entry ( $Entries->@* ) {
        next ENTRY unless $Entry->ical_entry_type eq 'VTIMEZONE';

        my $TimeZone = DateTime::TimeZone::ICal->from_ical_entry($Entry);
        $DeclaredTimeZone{ $TimeZone->name } = $TimeZone;

        # only a single calendar is supported
        push $Result{Calendars}->[0]->{TimeZones}->@*, $TimeZone->name;
    }

    # Now we can use this dictionary of time zones elsewhere.
    # Handle everything else. Entry type is one of: VEVENT. VTODO, VJOURNAL, VFREEBUSY, VAVAILABILITY, VALARM
    ENTRY:
    for my $Event ( $Entries->@* ) {
        next ENTRY if $Event->ical_entry_type eq 'VTIMEZONE';

        # extract the range
        my %Range;
        for my $Boundary (qw(Start End)) {
            my $Tag = lc "dt$Boundary";    # 'dtstart' or 'dtend'

            # DTSTART and DTEND are mandatory amd single valued
            my $Property = $Event->property($Tag)->[0];

            # A time zone might have been specified. It is illegal to set both a UTC time
            # and a TZID, so we don't have to wory about it here.
            # If there is a TZID declared then we trick the DateTime::Format::ICal parser into
            # accepting this information. There is no need to escape double quotes in the
            # time zone as iCalendar does not allow double quotes in parameters.
            my $TZID = $Property->parameters->{TZID};

            # parsing the value gives either a floating or an UTC time
            my $CPANDateTime = $Dfmt->parse_datetime( $Property->value );

            # set the time zone for the floating time
            if ( $TZID && $DeclaredTimeZone{$TZID} ) {
                $CPANDateTime->set_time_zone( $DeclaredTimeZone{$TZID} );
            }

            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    _CPANDateTimeObject => $CPANDateTime,
                }
            );

            # Start and End times may have to be converted.
            my $OTOBOTimeZone    = $DateTimeObject->OTOBOTimeZoneGet();
            my $TimeZoneWasMoved = 0;
            my $OriginalTimeZone = $CPANDateTime->time_zone_long_name;

            if ( defined $OTOBOTimeZone && $OriginalTimeZone ne $OTOBOTimeZone ) {
                $DateTimeObject->ToTimeZone( TimeZone => $OTOBOTimeZone );
                $TimeZoneWasMoved = 1;
            }

            # TODO: keep the object
            $Range{$Boundary} = $DateTimeObject->Get();
            $Range{$Boundary}->{String} = $DateTimeObject->ToString();
            if ($TimeZoneWasMoved) {
                $Range{$Boundary}->{OriginalTimeZone} = $OriginalTimeZone;
            }
        }

        # TODO:
        if ( $Event->property('allday') ) {
            $AllDay = 1;
        }

        my $UID = $Event->property('uid')->[0]->value;

        push $EventResult{$UID}->{Dates}->@*, \%Range;

        # for multiple events this data is the same
        # no need to save multiple times
        next ENTRY if $UIDSeen{$UID};

        $UIDSeen{$UID} = 1;

        if ( IsArrayRefWithData( $Param{AdditionalData}->{$UID}->{Description} ) ) {

            DATATOINJECT:
            for my $DataToInject ( @{ $Param{AdditionalData}->{$UID}->{Description} } ) {
                next DATATOINJECT if $DataToInject->{DataType} ne 'base64';
                next DATATOINJECT unless $DataToInject->{InlineImage};
                next DATATOINJECT unless $DataToInject->{ContentType};

                push @{ $EventResult{$UID}->{AdditionalData}->{Description}->{Images} }, {
                    ContentType => $DataToInject->{ContentType},
                    DataType    => 'base64',
                    Content     => $DataToInject->{Content},
                };
            }
        }

        if ( $Event->property('organizer') ) {

            # TODO: maybe fall back to CAL-ADDRESS
            my $CommonName = $Event->property('organizer')->[0]->parameters->{CN};
            if ($CommonName) {
                my %Safety = $HTMLUtilsObject->Safety(
                    String       => $CommonName,
                    NoApplet     => 1,
                    NoObject     => 1,
                    NoEmbed      => 1,
                    NoSVG        => 1,
                    NoImg        => 1,
                    NoIntSrcLoad => 1,
                    NoExtSrcLoad => 1,
                    NoJavaScript => 1,
                );
                $EncodeObject->EncodeInput( \$Safety{String} );

                $EventResult{$UID}->{ $Self->{GlobalPropertiesMap}->{Events}->{ORGANIZER} } = $Safety{String};
            }
        }

        if ( $Event->property('attendee') ) {
            my @AttendeeSafety;
            for my $SingleAttendee ( $Event->property('attendee')->@* ) {
                my $CommonName = $SingleAttendee->parameters->{CN} // 'dummy CN';
                my %Safety     = $HTMLUtilsObject->Safety(
                    String       => $CommonName,
                    NoApplet     => 1,
                    NoObject     => 1,
                    NoEmbed      => 1,
                    NoSVG        => 1,
                    NoImg        => 1,
                    NoIntSrcLoad => 1,
                    NoExtSrcLoad => 1,
                    NoJavaScript => 1,
                );
                $EncodeObject->EncodeInput( \$Safety{String} );
                push @AttendeeSafety, $Safety{String};
            }
            $EventResult{$UID}->{ $Self->{GlobalPropertiesMap}->{Events}->{ATTENDEE} }
                = \@AttendeeSafety;
        }

        for my $Tag (qw(DESCRIPTION SUMMARY LOCATION)) {
            my $Value = '';
            if ( $Event->property($Tag) ) {
                $Value = $Event->property($Tag)->[0]->value;
                $Value =~ s{\\n}{\n}g;
                $Value =~ s{\\r}{\r}g;
                $Value =~ s{&nbsp}{ }g;

                if ( $Value ne '' ) {
                    my %Safety = $HTMLUtilsObject->Safety(
                        String       => $Value,
                        NoApplet     => 1,
                        NoObject     => 1,
                        NoEmbed      => 1,
                        NoSVG        => 1,
                        NoImg        => 0,
                        NoIntSrcLoad => 0,
                        NoExtSrcLoad => 1,
                        NoJavaScript => 1,
                    );

                    $Value = $Safety{String};
                    $EncodeObject->EncodeInput( \$Value );
                }
            }
            $EventResult{$UID}->{ $Self->{GlobalPropertiesMap}->{Events}->{$Tag} } = $Value;
        }

        if ( IsHashRefWithData( $Param{AdditionalData}->{$UID}->{Details} ) ) {
            my %Details = $Param{AdditionalData}->{$UID}->{Details}->%*;
            for my $Detail ( sort keys %Details ) {
                my $Key   = $Self->{DetailsPropertiesMap}->{Keys}->{$Detail}               || $Detail;
                my $Value = $Self->{DetailsPropertiesMap}->{Values}->{ $Details{$Detail} } || $Details{$Detail};
                $EventResult{$UID}->{Details}->{$Key} = $Value;
            }
        }

        $EventResult{$UID}->{Details}->{AllDay} = $AllDay;
    }

    return \%Result unless %EventResult;

    for my $EventID ( sort keys %EventResult ) {
        push @{ $Result{Events} }, {
            UID => $EventID,
            %{ $EventResult{$EventID} }
        };
    }

    return \%Result;
}

=head2 _PreProcess()

Pre-processes an i Calendar string.

    my $Result = $ICalendarObject->_PreProcess(
        String =>
            "BEGIN:VCALENDAR
            PRODID:-//Microsoft Corporation//Outlook 16.0 MIMEDIR//EN
            VERSION:2.0
            METHOD:REQUEST
            .."
    );

=cut

sub _PreProcess {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    NEEDED:
    for my $Needed (qw(String)) {
        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );

        return;
    }

    my %Result;
    my $String      = $Param{String};
    my @EventsFound = $String =~ m{BEGIN:VEVENT.*?END:VEVENT}gsm;

    # for Google Calendar
    $String =~ m{BEGIN:VTIMEZONE.+?TZID:(.*?)(\n|\r).+?END:VTIMEZONE}sm;
    my $TimeZone = $1;

    $String =~ m{PRODID:(.+?)(\n|\r)}sm;
    my $ProdID = $1 // '';    # for specific handling of some clients

    EVENT:
    for my $Event (@EventsFound) {
        $Event =~ m/.*?UID:(.*?)[\n*\r*]/sm;
        my $UID = $1;

        # clean long base64 from parser
        while ( $Event =~ m/(.*?DESCRIPTION.*?)%3Cimg.*?src\%3D\%22data%3A(.*?)%3B(.*?)%2C(.*?)\%22(.*)/gsm ) {
            next EVENT if ( !$1 || !$2 || !$3 || !$4 || !$5 );
            next EVENT if $3 ne 'base64';

            my $EventTemp   = $1 . $5;
            my $ContentType = URI::Escape::uri_unescape($2);

            my $Content = $4;
            $Content =~ s{ *\r*\n*}{}gsm;
            $Content = URI::Escape::uri_unescape($Content);

            $String =~ s{$Event}{$EventTemp};
            $Event = $EventTemp;

            $Result{AdditionalData}                        //= {};
            $Result{AdditionalData}->{$UID}                //= {};
            $Result{AdditionalData}->{$UID}->{Description} //= [];
            push $Result{AdditionalData}->{$UID}->{Description}->@*, {
                ContentType => $ContentType,
                Content     => $Content,
                DataType    => 'base64',
                InlineImage => 1,
            };
        }

        my %Details;

        # recurrent event with daily repeat will be treated as span events
        # as there is no difference between them
        if ( $Event =~ m{RRULE:(.*)\n*\r*} ) {
            my $RecurrenceString = $1;
            $Details{TYPE} = 'RECURRENT';

            for my $Property ( split /;/, $RecurrenceString ) {
                my @SplitProperty = split /=/, $Property;
                $Details{ $SplitProperty[0] } = $SplitProperty[1];
            }
        }
        else {
            $Details{TYPE} = 'SPAN';
            $Details{FREQ} = 'DAILY';
        }

        $Result{AdditionalData}->{$UID}->{Details} = \%Details;

        if ( $ProdID =~ m{Google Inc\/\/Google Calendar} ) {

            # clean unwanted google calendar description string
            if ( $Event =~ m{DESCRIPTION.*?(-\s*:\s*:\s*~\s*.+~\s*:\s*:\s*-)}sm ) {
                my $DescriptionPartToClean = $1;

                # on single meeting, google won't send timezone in tag, but only in link in the URL
                if ( !$TimeZone ) {
                    my $DescriptionToSearch = $DescriptionPartToClean;
                    $DescriptionToSearch =~ s{ *\n*\r*}{}gsm;
                    $DescriptionToSearch =~ m{https:\/\/.+?calendar.+?tz=(.*?)&.+?\.}sm;
                    if ($1) {
                        $TimeZone = URI::Escape::uri_unescape($1);
                    }

                    # TODO: inject the TimeZone so that Data::ICal can parse it
                }

                $String =~ s{\Q$DescriptionPartToClean\E}{}sm;
            }
        }
    }

    if ( !$TimeZone ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Could not determine timezone for the calendar event!',
        );
        return;
    }

    # decode from URL
    $String = URI::Escape::uri_unescape($String);

    $Result{Value} = $String;

    # do not return data if it's too big for parser to process
    return if length $Result{Value} > 150000;

    return \%Result;
}

1;
