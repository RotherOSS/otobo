# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::Output::HTML::TicketZoom::AppointmentParticipation;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $UserObject          = $Kernel::OM->Get('Kernel::System::User');
    my $ParticipationObject = $Kernel::OM->Get('Kernel::System::Calendar::Participation');
    my $AppointmentObject   = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    my $CalendarObject      = $Kernel::OM->Get('Kernel::System::Calendar');
    my $DateTimeObject      = $Kernel::OM->Create('Kernel::System::DateTime');

    my $WidgetData = {
        Name        => '0050-AppointmentParticipation',
        Filter      => 'Today',
        WidgetTitle => 'Invitations',
        Config      => {},
    };

    my %Ticket = %{ $Param{Ticket} };

    # get a list of at least readable calendars
    my @CalendarList = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarList(
        UserID  => $Self->{UserID},
        ValidID => 1,
    );

    # collect calendar and appointment data
    # separate appointments to today, tomorrow
    # and the next five days (soon)
    my %Calendars;
    my %Participations;
    my %ParticipationsCount;

    CALENDAR:
    for my $Calendar (@CalendarList) {

        next CALENDAR if !$Calendar;
        next CALENDAR if !IsHashRefWithData($Calendar);
        next CALENDAR if $Calendars{ $Calendar->{CalendarID} };

        $Calendars{ $Calendar->{CalendarID} } = $Calendar;
    }

    # prepare calendar participations
    my %ParticipationsUnsorted;

    # consider the invitations from customers
    my @Participations = $ParticipationObject->TicketInvitationList(
        AgentUserID => $Self->{UserID},
        TicketID    => $Ticket{TicketID},
        UserID      => $Self->{UserID},
    );

    if (@Participations) {

        PARTICIPATION:
        for my $Participation (@Participations) {

            next PARTICIPATION if !$Participation;
            next PARTICIPATION if !IsHashRefWithData($Participation);

            # Save system time of StartTime.
            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Participation->{Appointment}->{StartTime},
                },
            );
            $Participation->{Appointment}->{SystemTimeStart} = $StartTimeObject->ToEpoch();

            # save appointment in new hash for later sorting
            $ParticipationsUnsorted{ $Participation->{ParticipationID} } = $Participation;
        }
    }

    # get datetime strings for the dates with related offsets
    # (today, tomorrow and soon - which means the next 5 days
    # except today and tomorrow counted from current timestamp)
    my %DateOffset = (
        Today    => 0,
        Tomorrow => 86400,
    );

    my %Dates;

    my $CurrentSystemTime = $DateTimeObject->ToEpoch();

    for my $DateOffsetKey ( sort keys %DateOffset ) {

        # Get date components with current offset.
        my $OffsetTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $CurrentSystemTime + $DateOffset{$DateOffsetKey},
            },
        );
        my $OffsetTimeSettings = $OffsetTimeObject->Get();

        $Dates{$DateOffsetKey} = sprintf(
            "%02d-%02d-%02d",
            $OffsetTimeSettings->{Year},
            $OffsetTimeSettings->{Month},
            $OffsetTimeSettings->{Day}
        );
    }

    $ParticipationsCount{Today}    = 0;
    $ParticipationsCount{Tomorrow} = 0;
    $ParticipationsCount{Soon}     = 0;

    PARTICIPATIONID:
    for my $ParticipationID ( sort keys %ParticipationsUnsorted ) {

        next PARTICIPATIONID unless $ParticipationID;
        next PARTICIPATIONID unless IsHashRefWithData( $ParticipationsUnsorted{$ParticipationID} );
        next PARTICIPATIONID unless $ParticipationsUnsorted{$ParticipationID}->{Appointment}->{StartTime};
        next PARTICIPATIONID unless $ParticipationsUnsorted{$ParticipationID}->{Appointment}->{EndTime};

        # Extract current date (without time).
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $ParticipationsUnsorted{$ParticipationID}->{Appointment}->{StartTime},
            },
        );
        my $StartTimeSettings = $StartTimeObject->Get();
        my $StartDate         = sprintf(
            "%02d-%02d-%02d",
            $StartTimeSettings->{Year},
            $StartTimeSettings->{Month},
            $StartTimeSettings->{Day}
        );

        my $EndTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $ParticipationsUnsorted{$ParticipationID}->{Appointment}->{EndTime},
            },
        );
        my $EndTimeSettings = $EndTimeObject->Get();
        my $EndDate         = sprintf(
            "%02d-%02d-%02d",
            $EndTimeSettings->{Year},
            $EndTimeSettings->{Month},
            $EndTimeSettings->{Day}
        );

        if ( $EndDate lt $Dates{Today} ) {

            # Do nothing
        }

        # today
        elsif ( $StartDate le $Dates{Today} ) {

            $ParticipationsCount{Today}++;

            if ( $Self->{Filter} eq 'Today' ) {
                $Participations{$ParticipationID} = $ParticipationsUnsorted{$ParticipationID};
            }
        }

        # tomorrow
        elsif ( $StartDate eq $Dates{Tomorrow} ) {

            $ParticipationsCount{Tomorrow}++;

            if ( $Self->{Filter} eq 'Tomorrow' ) {
                $Participations{$ParticipationID} = $ParticipationsUnsorted{$ParticipationID};
            }
        }

        # soon
        else {

            $ParticipationsCount{Soon}++;

            if ( $Self->{Filter} eq 'Soon' ) {
                $Participations{$ParticipationID} = $ParticipationsUnsorted{$ParticipationID};
            }

        }
    }

    my $AppointmentTableBlock = 'ContentSmallTable';

    # prepare appointments table
    $LayoutObject->Block(
        Name => 'ContentSmallTable',
    );

    my $Count = 0;
    my $Shown = 0;

    PARTICIPATIONID:
    for my $ParticipationID (
        sort {
            $Participations{$a}->{Appointment}->{SystemTimeStart} <=> $Participations{$b}->{Appointment}->{SystemTimeStart}
                || $Participations{$a}->{ParticipationID} <=> $Participations{$b}->{ParticipationID}
        } keys %Participations
        )
    {

        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Participations{$ParticipationID}->{Appointment}->{StartTime},
            },
        );

        # Convert time to user time zone.
        if ( $Self->{UserTimeZone} ) {
            $StartTimeObject->ToTimeZone(
                TimeZone => $Self->{UserTimeZone},
            );
        }

        my $StartTimeSettings = $StartTimeObject->Get();
        my $StartDate         = sprintf(
            "%02d-%02d-%02d",
            $StartTimeSettings->{Year},
            $StartTimeSettings->{Month},
            $StartTimeSettings->{Day}
        );

        my $DateTimeObject    = $Kernel::OM->Create('Kernel::System::DateTime');
        my $CurrentSystemTime = $DateTimeObject->ToEpoch();
        my $TodayTimeObject   = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $CurrentSystemTime,
            },
        );
        my $TodayTimeSettings = $TodayTimeObject->Get();
        my $TodayDate         = sprintf(
            "%02d-%02d-%02d",
            $TodayTimeSettings->{Year},
            $TodayTimeSettings->{Month},
            $TodayTimeSettings->{Day}
        );

        my $ActionString = $LayoutObject->BuildSelection(
            Data => {
                'AcceptInvitation'            => 'Accept',
                'TentativelyAcceptInvitation' => 'Accept Tentatively',
                'InstantDeclineInvitation'    => 'Decline',
            },
            Name         => 'CalendarParticipationAction_' . $ParticipationID,
            Multiple     => 0,
            Class        => 'Modernize W70pc CalendarParticipationAction',
            PossibleNone => 1,
            OnChange     => '',
        );

        my $StartTimeFormatted = $LayoutObject->{LanguageObject}->FormatTimeString( $Participations{$ParticipationID}->{Appointment}{StartTime} ) || '';
        my $EndTimeFormatted   = $LayoutObject->{LanguageObject}->FormatTimeString( $Participations{$ParticipationID}->{Appointment}{EndTime} )   || '';

        my $Description =
            length( $Participations{$ParticipationID}->{Appointment}{Description} ) > 250
            ? ( ( substr $Participations{$ParticipationID}->{Appointment}{Description}, 0, 250 ) . '...' )
            : $Participations{$ParticipationID}->{Appointment}{Description};

        my %Appointment = (
            Title              => $Participations{$ParticipationID}->{Appointment}{Title},
            Description        => $Description                                               || '',
            Location           => $Participations{$ParticipationID}->{Appointment}{Location} || '',
            StartTimeFormatted => $StartTimeFormatted,
            EndTimeFormatted   => $EndTimeFormatted,
        );

        # build hidden calendar selection
        my $CalendarSelectionString = $LayoutObject->BuildSelection(
            Data         => { map { $_->{CalendarID} => $_->{CalendarName} } @CalendarList },
            Name         => 'CalendarSelection_' . $ParticipationID,
            Multiple     => 0,
            Class        => 'Modernize Hidden CalendarSelection',
            PossibleNone => 0,
            SelectedID   => $Participations{$ParticipationID}->{Appointment}{CalendarID},
        );

        $LayoutObject->Block(
            Name => 'ContentSmallParticipationRow',
            Data => {
                AppointmentID           => $Participations{$ParticipationID}->{AppointmentID},
                Title                   => $Participations{$ParticipationID}->{Appointment}{Title},
                ActionString            => $ActionString,
                Appointment             => \%Appointment,
                CalendarSelectionString => $CalendarSelectionString,
            },
        );

        # increase shown item count
        $Shown++;
    }

    if ( !IsHashRefWithData( \%Participations ) ) {

        # show up message for no appointments
        $LayoutObject->Block(
            Name => 'ContentSmallParticipationNone',
        );
    }

    # set css class
    my %Summary;
    $Summary{ $WidgetData->{Filter} . '::Selected' } = 'Selected';

    # filter bar
    $LayoutObject->Block(
        Name => 'ContentSmallParticipationFilter',
        Data => {
            %{ $WidgetData->{Config} },
            %Summary,
            Name          => $WidgetData->{Name},
            TodayCount    => $ParticipationsCount{Today},
            TomorrowCount => $ParticipationsCount{Tomorrow},
            SoonCount     => $ParticipationsCount{Soon},
        },
    );

    my $NameHTML = $WidgetData->{Name};
    $NameHTML =~ s{-}{_}xmsg;

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'AppointmentParticipation',
        Value => {
            Name     => $WidgetData->{Name},
            NameHTML => $NameHTML,
        },
    );

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/AppointmentParticipation',
        Data         => {
            $WidgetData->%*,
            %Param,
        },
    );

    return {
        Output => $Output,
    };
}

1;
