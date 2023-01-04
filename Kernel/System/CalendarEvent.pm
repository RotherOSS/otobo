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

# This file is based on https://github.com/znuny/Znuny/blob/rel-6_4-dev/Kernel/System/CalendarEvents.pm 17b1f88840be11f065bf8780dfa550805719d5c8.
# It was renamed from Kernel/System/CalendarEvents.pm to Kernel/System/CalendarEvent.pm
# as the OTOBO convention is to use singular in module names.

package Kernel::System::CalendarEvent;

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket::Article',
);

=head1 NAME

Kernel::System::CalendarEvent - to manage calendar events

=head1 DESCRIPTION

Global module for operations that bases on calendar events

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $CalendarEventObject = $Kernel::OM->Get('Kernel::System::CalendarEvent');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {%Param}, $Type;

    # some mappings that will be needed later
    $Self->{Regex4FileFormat} = {

        # multiple events in a single file will be found
        # extra surrounding content will be ignored
        iCalendar => qr{BEGIN:VCALENDAR.+?END:VCALENDAR}sm,
    };

    $Self->{ContentTypeIsSupported} = {
        'text/calendar'                 => 1,
        'application/hbs-vcs'           => 1,
        'application/vnd.swiftview-ics' => 1,
        'text/x-vcalendar'              => 1,
    };

    return $Self;
}

=head2 Parse()

Parses calendar events of specified data.

    my $CalendarEventData = $CalendarEventObject->Parse(
        TicketID    => $Param{TicketID},
        ArticleID   => $Param{ArticleID},
        String      => $ArticleContent, # parse specified text content
        Attachments => { # parse attachments
            Data => {
                '4' => {
                    'Disposition' => 'attachment',
                    'ContentType' => 'text/calendar; charset=UTF-8; name="Some calendar name.ics"',
                    'Filename'    => 'calendar.ics',
                    'FilesizeRaw' => '949'
                },
                '1' => {
                    'Disposition' => 'attachment',
                    'ContentType' => 'text/calendar; charset=UTF-8; name="Some calendar name1.ics"',
                    'Filename'    => 'calendar1.ics',
                    'FilesizeRaw' => '2967'
                },
            },
            Type => "Article", # specify type of attachments
        },
        ToTimeZone => $UserTimeZone,
    );

=cut

sub Parse {
    my ( $Self, %Param ) = @_;

    my $LogObject     = $Kernel::OM->Get('Kernel::System::Log');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $CacheObject   = $Kernel::OM->Get('Kernel::System::Cache');
    my $MainObject    = $Kernel::OM->Get('Kernel::System::Main');

    my %DataToParse;
    my %ParsedData;

    my $ToTimeZoneCacheKey = $Param{ToTimeZone} || 'Default';

    if (
        IsHashRefWithData( $Param{Attachments} )
        && $Param{Attachments}->{Type}
        && $Param{Attachments}->{Type} eq 'Article'
        )
    {
        NEEDED:
        for my $Needed (qw(TicketID ArticleID)) {
            next NEEDED if defined $Param{$Needed};

            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }

        my $ArticleBackendObject = $ArticleObject->BackendForArticle(
            TicketID  => $Param{TicketID},
            ArticleID => $Param{ArticleID}
        );
        my $AttachmentsData = $Param{Attachments}->{Data};

        # parse attachments
        if ( IsHashRefWithData $AttachmentsData) {

            ATTACHMENTINDEX:
            for my $AttachmentIndex ( sort keys $AttachmentsData->%* ) {
                my %Data = $ArticleBackendObject->ArticleAttachment(
                    ArticleID => $Param{ArticleID},
                    TicketID  => $Param{TicketID},
                    FileID    => $AttachmentIndex,
                );

                $Data{Index} = $AttachmentIndex;

                next ATTACHMENTINDEX unless $Data{Content};
                next ATTACHMENTINDEX unless $Data{ContentType};

                # only up to the first semicolon
                # TODO: is that cleanup required ?
                my ($ContentType) = split /;/, $Data{ContentType};

                next ATTACHMENTINDEX unless $Self->{ContentTypeIsSupported}->{$ContentType};

                # only the parsed attachments are cached
                my $CalendarEventAttachment = $CacheObject->Get(
                    Type => 'CalendarEventArticle',
                    Key  => "Attachment::$Param{TicketID}::$Param{ArticleID}::${AttachmentIndex}::${ToTimeZoneCacheKey}",
                );

                if ( IsHashRefWithData($CalendarEventAttachment) ) {
                    $ParsedData{Attachments} //= [];
                    push $ParsedData{Attachments}->@*, {
                        Data  => $CalendarEventAttachment,
                        Index => $AttachmentIndex,
                    };
                }
                else {
                    $DataToParse{Attachments} //= [];
                    push $DataToParse{Attachments}->@*, \%Data;
                }
            }
        }
    }

    if ( $Param{String} ) {
        $DataToParse{String} //= [];
        push $DataToParse{String}->@*, {
            Content => $Param{String}
        };
    }

    return if ( !%DataToParse && !IsArrayRefWithData( $ParsedData{Attachments} ) );

    # support for specified calendar extensions
    # select each occurances content
    my $CalendarEvents;
    if (%DataToParse) {
        $CalendarEvents = $Self->FindEvents(
            %DataToParse,
        );
    }

    return \%ParsedData unless IsHashRefWithData($CalendarEvents);

    FILE_FORMAT:
    for my $FileFormat ( sort keys $CalendarEvents->%* ) {

        next FILE_FORMAT unless IsArrayRefWithData( $CalendarEvents->{$FileFormat} );

        my $BackendModule = "Kernel::System::CalendarEvent::$FileFormat";

        # check module validity
        if ( !$MainObject->Require($BackendModule) ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Can't load $BackendModule.",
            );

            next FILE_FORMAT;
        }

        if ( !$BackendModule->can('Parse') ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Module $BackendModule is missing method 'Parse'.",
            );

            next FILE_FORMAT;
        }

        $BackendModule = $BackendModule->new();

        my $Counter = 0;

        # parse actual content of each data type
        DATA:
        for my $Data ( $CalendarEvents->{$FileFormat} ) {

            next DATA unless IsArrayRefWithData($Data);

            EVENTSDATA:
            for my $EventsData ( $Data->@* ) {
                next EVENTSDATA unless IsArrayRefWithData( $EventsData->{CalendarEvents} );
                next EVENTSDATA unless $EventsData->{Type};

                CONTENT:
                for my $Content ( $EventsData->{CalendarEvents}->@* ) {
                    my $Result = $BackendModule->Parse(
                        String     => $Content,
                        ToTimeZone => $Param{ToTimeZone},
                    );

                    next CONTENT unless $Result;

                    my $Index;
                    if (
                        $EventsData->{Type} eq 'Attachments'
                        && $EventsData->{Data}->{Index}
                        )
                    {
                        $Index = $EventsData->{Data}->{Index};
                        $CacheObject->Set(
                            Type  => 'CalendarEventsArticle',
                            Key   => "Attachment::$Param{TicketID}::$Param{ArticleID}::${Index}::${ToTimeZoneCacheKey}",
                            Value => $Result,
                            TTL   => 60 * 60,
                        );
                    }
                    else {
                        $Index = $Counter;
                        $Counter++;
                    }

                    push @{ $ParsedData{ $EventsData->{Type} } }, {
                        Data  => $Result,
                        Index => $Index,
                    };
                }
            }
        }
    }

    return \%ParsedData;
}

=head2 FindEvents()

Finds supported calendar event from the string.

    my $Result = $CalendarEventsObject->FindEvents(
        String => [
            {
                Content =>
                    "Hello! You've got an invitation for a meeting:
                    BEGIN:VCALENDAR
                    ..
                    END:VCALENDAR"
            }
        ],
        Attachments => [
            {
                Content =>
                    "Hello! You've got an invitation for a meeting:
                    BEGIN:VCALENDAR
                    ..
                    END:VCALENDAR"
            },
            {
                Content =>
                    "Hello! You've got an invitation for a meeting:
                    BEGIN:VCALENDAR
                    ..
                    END:VCALENDAR"
            },
            ..
        ],
    );

=cut

sub FindEvents {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    if (
        !$Param{String}
        && !$Param{Attachments}
        )
    {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need either parameter String or Attachments.',
        );
        return;
    }

    my $Regex4FileFormat = $Self->{Regex4FileFormat};
    my %Result;

    DATATYPE:
    for my $DataType (qw(String Attachments)) {

        next DATATYPE unless IsArrayRefWithData( $Param{$DataType} );

        DATA:
        for my $Data ( $Param{$DataType}->@* ) {
            next DATA unless IsHashRefWithData($Data);
            next DATA unless $Data->{Content};

            # search for each supported extension
            for my $FileFormat ( sort keys $Regex4FileFormat->%* ) {
                my $Regex       = $Regex4FileFormat->{$FileFormat};
                my @EventsFound = $Data->{Content} =~ m/$Regex/g;
                if (@EventsFound) {
                    $Result{$FileFormat} //= [];
                    push $Result{$FileFormat}->@*, {
                        CalendarEvents => \@EventsFound,
                        Type           => $DataType,
                        Data           => $Data,
                    };
                }
            }
        }
    }

    return \%Result;
}

=head2 BuildString()

Builds string for data output.

    my $OutputString = $CalendarEventsObject->BuildString(
        Data => {
          'Type'      => 'Recurrent', # required
          'Interval'  => '5',
          'ByDay'     => 'SU,TU,WE,TH,FR,SA',
          'AllDay'    => 1,
          'Frequency' => 'Weekly'
        },
        Type => 'Frequency',
    );

=cut

sub BuildString {
    my ( $Self, %Param ) = @_;

    my $LogObject      = $Kernel::OM->Get('Kernel::System::Log');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LanguageObject = $LayoutObject->{LanguageObject};

    # check needed stuff
    NEEDED:
    for my $Needed (qw(Data Type)) {
        next NEEDED if defined $Param{$Needed};

        $LogObject->Log(
            Priority => 'error',
            Message  => "Parameter '$Needed' is needed!",
        );
        return;
    }

    my %Data = %{ $Param{Data} };

    return if $Param{Type} ne 'Frequency';
    return unless $Data{Frequency};

    my $Interval = $Data{Interval} || 1;

    my $FrequencyMapping = $Self->_FrequencyStringMappingGet();
    my $MonthsMapping    = $Self->_MonthsMappingGet();
    my $DaysMapping      = $Self->_DaysMappingGet();
    my $DaysOrderMapping = $Self->_DaysOrderMappingGet();
    my $EveryType        = $Interval > 1 ? "Multiple" : "Single";
    my $EveryWhat        = $FrequencyMapping->{ $Data{Frequency} }->{$EveryType};

    my %Details = (
        BySecond   => '',
        ByMinute   => '',
        ByHour     => '',
        ByDay      => '',
        ByMonthDay => '',
        ByYearDay  => '',
        ByWeek     => '',
        ByMonth    => '',

        #               BySetPos   => '',
    );

    my $On;

    PROPERTY:
    for my $Property (qw(BySecond ByMinute ByHour ByMonthDay ByYearDay)) {
        next PROPERTY unless $Data{$Property};

        my @ByProperty = split /,/, $Data{$Property};
        next PROPERTY unless @ByProperty;

        $On = 1;
        $Details{$Property} .= join ', ', @ByProperty;
    }

    my $In;

    if ( $Data{ByMonth} ) {
        my @ByMonth = split /,/, $Data{ByMonth};
        if (@ByMonth) {
            $In = 1;

            my @MonthValues = map { $MonthsMapping->{$_} } @ByMonth;
            $Details{ByMonth} .= join ', ', @MonthValues;
        }
    }

    if ( $Data{ByDay} ) {
        my @ByDay = split /,/, $Data{ByDay};

        my @DayValues;

        BYDAY:
        for my $ByDay (@ByDay) {
            next BYDAY if $ByDay !~ m{(-*)(\d*)(\w{2})};

            if ( $1 && $2 ) {
                push @DayValues, $DaysOrderMapping->{ $1 . $2 } . ' ' . $DaysMapping->{$3};
            }
            elsif ($2) {
                push @DayValues, $DaysOrderMapping->{$2} . ' ' . $DaysMapping->{$3};
            }
            elsif ( !$1 && !$2 ) {
                push @DayValues, $DaysMapping->{$3};
            }
        }

        if (@DayValues) {
            $On = 1;
            $Details{ByDay} .= join ', ', @DayValues;
        }
    }

    my $FrequencyString =
        $LanguageObject->Translate("every") . " $Interval" . " " .
        $LanguageObject->Translate($EveryWhat);

    if ($In) {
        $FrequencyString .= " " . $LanguageObject->Translate("in") . " ";
        if ( $Details{ByMonth} ) {
            $FrequencyString .= $LanguageObject->Translate( $Details{ByMonth} );
        }
    }

    if ($On) {
        $FrequencyString .= " " . $LanguageObject->Translate("on") . " ";
        if ( $Details{ByYearDay} ) {
            $FrequencyString .= $LanguageObject->Translate("day") . " $Details{ByYearDay}"
                . $LanguageObject->Translate("of year")
                . ', ';
        }
        if ( $Details{ByMonthDay} ) {
            $FrequencyString .= $LanguageObject->Translate("day") . " $Details{ByMonthDay}"
                . $LanguageObject->Translate("of month")
                . ', ';
        }
        if ( $Details{ByHour} ) {
            $FrequencyString .= $LanguageObject->Translate("hour") . " $Details{ByHour}"
                . ', ';
        }
        if ( $Details{ByMinute} ) {
            $FrequencyString .= $LanguageObject->Translate("minute") . " $Details{ByMinute}"
                . ', ';
        }
        if ( $Details{BySecond} ) {
            $FrequencyString .= $LanguageObject->Translate("second") . " $Details{BySecond}"
                . ', ';
        }
        if ( $Details{ByDay} ) {
            if ( $Details{ByDay} =~ m{(\w+?) {1}(\w+)} ) {
                $FrequencyString .= $LanguageObject->Translate("$1") . " " .
                    $LanguageObject->Translate("$2")
                    . ', ';
            }
            else {
                $FrequencyString .= $LanguageObject->Translate("$Details{ByDay}")
                    . ', ';
            }
        }
        if ( $Data{AllDay} && $Param{OriginalTimeZone} ) {
            $FrequencyString .= $LanguageObject->Translate("all-day")
                . "(" . $LanguageObject->Translate( $Param{OriginalTimeZone} ) . ")"
                . ', ';
        }
        $FrequencyString = substr $FrequencyString, 0, -2;
    }
    else {
        if ( $Data{AllDay} && $Param{OriginalTimeZone} ) {
            $FrequencyString .= ', ' . $LanguageObject->Translate("all-day")
                . " (" . $LanguageObject->Translate( $Param{OriginalTimeZone} ) . ")";
        }
    }

    return $FrequencyString;
}

=head2 _FrequencyStringMappingGet()

Get frequency string mapping.

    my $FrequencyStringMapping = $CalendarEventsObject->_FrequencyStringMappingGet();

=cut

sub _FrequencyStringMappingGet {
    my ( $Self, %Param ) = @_;

    return {
        Yearly => {
            Single   => 'year',
            Multiple => 'years'
        },
        Monthly => {
            Single   => 'month',
            Multiple => 'months'
        },
        Weekly => {
            Single   => 'week',
            Multiple => 'weeks'
        },
        Daily => {
            Single   => 'day',
            Multiple => 'days'
        },
        Hourly => {
            Single   => 'hour',
            Multiple => 'hours'
        },
        Minutely => {
            Single   => 'minute',
            Multiple => 'minutes'
        },
        Secondely => {
            Single   => 'second',
            Multiple => 'seconds'
        }
    };
}

=head2 _MonthsMappingGet()

Get months mapping.

    my $MonthsMapping = $CalendarEventsObject->_MonthsMappingGet();

=cut

sub _MonthsMappingGet {
    my ( $Self, %Param ) = @_;

    return {
        1  => 'January',
        2  => 'February',
        3  => 'March',
        4  => 'April',
        5  => 'May',
        6  => 'June',
        7  => 'July',
        8  => 'August',
        9  => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December',
    };
}

=head2 _DaysMappingGet()

Get days mapping

    my $DaysMapping = $CalendarEventsObject->_DaysMappingGet();

=cut

sub _DaysMappingGet {
    my ( $Self, %Param ) = @_;

    return {
        MO => 'Monday',
        TU => 'Tuesday',
        WE => 'Wednesday',
        TH => 'Thursday',
        FR => 'Friday',
        SA => 'Saturday',
        SU => 'Sunday',
    };
}

=head2 _DaysOrderMappingGet()

Get days order mapping

    my $DaysOrderMapping = $CalendarEventsObject->_DaysOrderMappingGet();

=cut

sub _DaysOrderMappingGet {
    my ( $Self, %Param ) = @_;

    return {
        -1 => 'last',
        1  => 'first',
        2  => 'second',
        3  => 'third',
        4  => 'fourth',
    };
}

1;
