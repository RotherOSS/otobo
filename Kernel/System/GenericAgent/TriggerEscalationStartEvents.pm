# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::GenericAgent::TriggerEscalationStartEvents;

use strict;
use warnings;

use List::Util qw(first);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::SLA',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless $Self, $Type;

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data
    # the escalation properties are computed within TicketGet().
    my %Ticket = $TicketObject->TicketGet(
        %Param,
        DynamicFields => 0,
    );

    # get used calendar
    my $Calendar = $TicketObject->TicketCalendarGet(
        %Ticket,
    );

    # get time object
    my $StopDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # check if it is during business hours, then send escalation info
    my $StartDateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => $StopDateTimeObject->ToEpoch() - ( 10 * 60 ),
        }
    );

    my $CountedTime = $StartDateTimeObject->Delta(
        DateTimeObject => $StopDateTimeObject,
        ForWorkingTime => 1,
        Calendar       => $Calendar,
    );

    if ( !$CountedTime || !$CountedTime->{AbsoluteSeconds} ) {

        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  =>
                    "Send not escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because currently no working hours!",
            );
        }

        return 1;
    }

    # needed for deciding whether events should be triggered
    my @HistoryLines = $TicketObject->HistoryGet(
        TicketID => $Ticket{TicketID},
        UserID   => 1,
    );

    # check if it's a escalation or escalation notification
    # check escalation times
    my %TicketAttr2Event = (
        FirstResponseTimeEscalation   => 'EscalationResponseTimeStart',
        UpdateTimeEscalation          => 'EscalationUpdateTimeStart',
        SolutionTimeEscalation        => 'EscalationSolutionTimeStart',
        FirstResponseTimeNotification => 'EscalationResponseTimeNotifyBefore',
        UpdateTimeNotification        => 'EscalationUpdateTimeNotifyBefore',
        SolutionTimeNotification      => 'EscalationSolutionTimeNotifyBefore',
    );
    my @Events;

    # triggering summary events is currently (2010-12-03) disabled
    #my ( $FoundEscalation, $FoundNotifyBefore ) = ( 0, 0 );
    ATTR:
    for my $Attr ( grep { defined $Ticket{$_} } sort keys %TicketAttr2Event ) {

        # the decay time is configured in minutes
        my $DecayTimeInSeconds = $Kernel::OM->Get('Kernel::Config')->Get('OTOBOEscalationEvents::DecayTime') || 0;

        $DecayTimeInSeconds *= 60;

        # get the last time this event was triggered
        # search in reverse order, as @HistoryLines sorted ascendingly by CreateTime
        if ($DecayTimeInSeconds) {
            my $PrevEventLine = first { $_->{HistoryType} eq $TicketAttr2Event{$Attr} }
                reverse @HistoryLines;
            if ( $PrevEventLine && $PrevEventLine->{CreateTime} ) {

                my $PrevEventTime = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $PrevEventLine->{CreateTime},
                    },
                );
                $PrevEventTime = $PrevEventTime ? $PrevEventTime->ToEpoch() : 0;

                my $TimeSincePrevEvent = $StopDateTimeObject->ToEpoch() - $PrevEventTime;

                next ATTR if $TimeSincePrevEvent <= $DecayTimeInSeconds;
            }
        }

        # emit the event
        push @Events, $TicketAttr2Event{$Attr};
    }

    for my $Event (@Events) {

        # trigger the event
        $TicketObject->EventHandler(
            Event  => $Event,
            UserID => 1,
            Data   => {
                TicketID => $Param{TicketID},
            },
            UserID => 1,
        );

        # log the triggered event in the history
        $TicketObject->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => $Event,
            Name         => "%%$Event%%triggered",
            CreateUserID => 1,
        );
    }

    return 1;
}

1;
