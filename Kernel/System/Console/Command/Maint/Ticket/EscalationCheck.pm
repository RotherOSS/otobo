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

package Kernel::System::Console::Command::Maint::Ticket::EscalationCheck;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use List::Util qw(first);

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Trigger ticket escalation events and notification events for escalation.');

    return;
}

# =item Run()
#
# looks for the tickets which will escalate within the next five days.
# Then performs a search over the values on the TicketGet() result
# for checking if any of the escalations values are present. Then based
# on that the notification events for notifications and normal escalation
# events are triggered.
#
# NotificationEvents:
#     - NotificationEscalation
#     - NotificationEscalationNotifyBefore
#
# Escalation events:
#     - EscalationResponseTimeStart
#     - EscalationUpdateTimeStart
#     - EscalationSolutionTimeStart
#     - EscalationResponseTimeNotifyBefore
#     - EscalationUpdateTimeNotifyBefore
#     - EscalationSolutionTimeNotifyBefore
#
#
# NotificationEvents are alway triggered, and Escalation events just
# based on the 'OTOBOEscalationEvents::DecayTime'.
#
# =cut

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Processing ticket escalation events ...</yellow>\n");

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # the decay time is configured in minutes
    my $DecayTimeInSeconds = $Kernel::OM->Get('Kernel::Config')->Get('OTOBOEscalationEvents::DecayTime') || 0;
    $DecayTimeInSeconds *= 60;

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

    # Find all tickets which will escalate within the next five days.
    my @Tickets = $TicketObject->TicketSearch(
        Result                           => 'ARRAY',
        Limit                            => 1000,
        TicketEscalationTimeOlderMinutes => -( 5 * 24 * 60 ),    # 5 days
        Permission                       => 'rw',
        UserID                           => 1,
    );

    TICKET:
    for my $TicketID (@Tickets) {

        # get ticket data
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        # get used calendar
        my $Calendar = $TicketObject->TicketCalendarGet(
            %Ticket,
        );

        # check if it is during business hours, then send escalation info
        my $BusinessStartDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $BusinessStartDTObject->Subtract( Seconds => 10 * 60 );

        my $BusinessStopDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $CountedTime = $BusinessStartDTObject->Delta(
            DateTimeObject => $BusinessStopDTObject,
            ForWorkingTime => 1,
            Calendar       => $Calendar,
        );

        # don't trigger events if not counted time
        if ( !$CountedTime || !$CountedTime->{AbsoluteSeconds} ) {
            next TICKET;
        }

        # needed for deciding whether events should be triggered
        my @HistoryLines = $TicketObject->HistoryGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # check if it's a escalation of escalation notification
        # check escalation times
        my $EscalationType = 0;
        my @Events;
        TYPE:
        for my $Type (
            qw(FirstResponseTimeEscalation UpdateTimeEscalation SolutionTimeEscalation
            FirstResponseTimeNotification UpdateTimeNotification SolutionTimeNotification)
            )
        {
            next TYPE if !$Ticket{$Type};

            my @ReversedHistoryLines = reverse @HistoryLines;

            # get the last time this event was triggered
            # search in reverse order, as @HistoryLines sorted ascendingly by CreateTime
            if ($DecayTimeInSeconds) {

                my $PrevEventLine = first { $_->{HistoryType} eq $TicketAttr2Event{$Type} }
                    @ReversedHistoryLines;

                if ( $PrevEventLine && $PrevEventLine->{CreateTime} ) {
                    my $PrevEventTime = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $PrevEventLine->{CreateTime},
                        },
                    )->ToEpoch();

                    my $CurSysTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

                    my $TimeSincePrevEvent = $CurSysTime - $PrevEventTime;

                    next TYPE if $TimeSincePrevEvent <= $DecayTimeInSeconds;
                }
            }

            # emit the event
            push @Events, $TicketAttr2Event{$Type};

            if ( !$EscalationType ) {
                if ( $Type =~ /TimeEscalation$/ ) {
                    push @Events, 'NotificationEscalation';
                    $EscalationType = 1;
                }
                elsif ( $Type =~ /TimeNotification$/ ) {
                    push @Events, 'NotificationEscalationNotifyBefore';
                    $EscalationType = 1;
                }
            }
        }

        EVENT:
        for my $Event (@Events) {

            # trigger the event
            $TicketObject->EventHandler(
                Event  => $Event,
                UserID => 1,
                Data   => {
                    TicketID              => $TicketID,
                    CustomerMessageParams => {
                        TicketNumber => $Ticket{TicketNumber},
                    },
                },
                UserID => 1,
            );

            $Self->Print(
                "Ticket <yellow>$TicketID</yellow>: event <yellow>$Event</yellow>, processed.\n"
            );

            if ( $Event eq 'NotificationEscalation' || $Event eq 'NotificationEscalationNotifyBefore' ) {
                next EVENT;
            }

            # log the triggered event in the history
            $TicketObject->HistoryAdd(
                TicketID     => $TicketID,
                HistoryType  => $Event,
                Name         => "%%$Event%%triggered",
                CreateUserID => 1,
            );
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
