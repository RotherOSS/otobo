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

package Kernel::System::Console::Command::Maint::Ticket::UnlockTicket;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Unlock a single ticket by force.');
    $Self->AddArgument(
        Name        => 'ticket-id',
        Description => "Ticket to be unlocked by force.",
        Required    => 1,
        ValueRegex  => qr/\d+/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketID = $Self->GetArgument('ticket-id');

    $Self->Print("<yellow>Unlocking ticket $TicketID...</yellow>\n");

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $TicketID,
        Silent   => 1,
    );

    if ( !%Ticket ) {
        $Self->PrintError("Could not find ticket $TicketID.");
        return $Self->ExitCodeError();
    }

    my $Unlock = $Kernel::OM->Get('Kernel::System::Ticket')->LockSet(
        TicketID => $TicketID,
        Lock     => 'unlock',
        UserID   => 1,
    );
    if ( !$Unlock ) {
        $Self->PrintError('Failed.');
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
