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

package Kernel::System::Console::Command::Maint::Ticket::Delete;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Delete one or more tickets.');
    $Self->AddOption(
        Name        => 'ticket-number',
        Description => "Specify one or more ticket numbers of tickets to be deleted.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
        Multiple    => 1,
    );
    $Self->AddOption(
        Name        => 'ticket-id',
        Description => "Specify one or more ticket ids of tickets to be deleted.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d+/smx,
        Multiple    => 1,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my @TicketIDs     = @{ $Self->GetOption('ticket-id')     // [] };
    my @TicketNumbers = @{ $Self->GetOption('ticket-number') // [] };

    if ( !@TicketIDs && !@TicketNumbers ) {
        die "Please provide option --ticket-id or --ticket-number.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Deleting tickets...</yellow>\n");

    my @TicketIDs     = @{ $Self->GetOption('ticket-id')     // [] };
    my @TicketNumbers = @{ $Self->GetOption('ticket-number') // [] };

    my @DeleteTicketIDs;

    TICKETNUMBER:
    for my $TicketNumber (@TicketNumbers) {

        # lookup ticket id
        my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketIDLookup(
            TicketNumber => $TicketNumber,
            UserID       => 1,
        );

        # error handling
        if ( !$TicketID ) {
            $Self->PrintError("Unable to find ticket number $TicketNumber.\n");
            next TICKETNUMBER;
        }

        push @DeleteTicketIDs, $TicketID;
    }

    TICKETID:
    for my $TicketID (@TicketIDs) {

        # lookup ticket number
        my $TicketNumber = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # error handling
        if ( !$TicketNumber ) {
            $Self->PrintError("Unable to find ticket id $TicketID.\n");
            next TICKETID;
        }

        push @DeleteTicketIDs, $TicketID;
    }

    my $DeletedTicketCount = 0;

    TICKETID:
    for my $TicketID (@DeleteTicketIDs) {

        # delete the ticket
        my $True = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # error handling
        if ( !$True ) {
            $Self->PrintError("Unable to delete ticket with id $TicketID\n");
            next TICKETID;
        }

        $Self->Print("  $TicketID\n");

        # increase the deleted ticket count
        $DeletedTicketCount++;
    }

    if ( !$DeletedTicketCount ) {
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>$DeletedTicketCount tickets have been deleted.</green>\n");
    return $Self->ExitCodeOk();
}

1;
