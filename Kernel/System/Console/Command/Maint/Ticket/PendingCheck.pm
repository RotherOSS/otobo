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

package Kernel::System::Console::Command::Maint::Ticket::PendingCheck;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::User',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Process pending tickets that are past their pending time and send pending reminders.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Process pending tickets...</yellow>\n");

    # get needed objects
    my $StateObject  = $Kernel::OM->Get('Kernel::System::State');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my @TicketIDs;

    my @PendingAutoStateIDs = $StateObject->StateGetStatesByType(
        Type   => 'PendingAuto',
        Result => 'ID',
    );

    if (@PendingAutoStateIDs) {

        # do ticket auto jobs
        @TicketIDs = $TicketObject->TicketSearch(
            Result   => 'ARRAY',
            StateIDs => [@PendingAutoStateIDs],
            SortBy   => ['PendingTime'],
            OrderBy  => ['Up'],
            UserID   => 1,
        );

        my %States = %{ $Kernel::OM->Get('Kernel::Config')->Get('Ticket::StateAfterPending') };

        TICKETID:
        for my $TicketID (@TicketIDs) {

            # get ticket data
            my %Ticket = $TicketObject->TicketGet(
                TicketID      => $TicketID,
                UserID        => 1,
                DynamicFields => 0,
            );

            next TICKETID if $Ticket{UntilTime} >= 1;
            next TICKETID if !$States{ $Ticket{State} };

            $Self->Print(
                " Update ticket state for ticket $Ticket{TicketNumber} ($TicketID) to '$States{$Ticket{State}}'..."
            );

            # set new state
            my $Success = $TicketObject->StateSet(
                TicketID => $TicketID,
                State    => $States{ $Ticket{State} },
                UserID   => 1,
            );

            # error handling
            if ( !$Success ) {
                $Self->Print(" failed.\n");
                next TICKETID;
            }

            # get state type for new state
            my %State = $StateObject->StateGet(
                Name => $States{ $Ticket{State} },
            );
            if ( $State{TypeName} eq 'closed' ) {

                # set new ticket lock
                $TicketObject->LockSet(
                    TicketID     => $TicketID,
                    Lock         => 'unlock',
                    UserID       => 1,
                    Notification => 0,
                );
            }
            $Self->Print(" done.\n");
        }
    }
    else {

        $Self->Print(" No pending auto StateIDs found!\n");
    }

    # do ticket reminder notification jobs
    @TicketIDs = $TicketObject->TicketSearch(
        Result    => 'ARRAY',
        StateType => 'pending reminder',
        UserID    => 1,
    );

    TICKETID:
    for my $TicketID (@TicketIDs) {

        # get ticket data
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            UserID        => 1,
            DynamicFields => 0,
        );

        next TICKETID if $Ticket{UntilTime} >= 1;

        # get used calendar
        my $Calendar = $TicketObject->TicketCalendarGet(
            %Ticket,
        );

        # check if it is during business hours, then send reminder
        my $StopDTObject  = $Kernel::OM->Create('Kernel::System::DateTime');
        my $StartDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $StartDTObject->Subtract( Seconds => 10 * 60 );

        my $CountedTime = $StartDTObject->Delta(
            DateTimeObject => $StopDTObject,
            ForWorkingTime => 1,
            Calendar       => $Calendar,
        );

        # error handling
        if ( !$CountedTime || !$CountedTime->{AbsoluteSeconds} ) {
            next TICKETID;
        }

        # trigger notification event
        $TicketObject->EventHandler(
            Event => 'NotificationPendingReminder',
            Data  => {
                TicketID              => $Ticket{TicketID},
                CustomerMessageParams => {
                    TicketNumber => $Ticket{TicketNumber},
                },
            },
            UserID => 1,
        );

        $TicketObject->EventHandlerTransaction();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
