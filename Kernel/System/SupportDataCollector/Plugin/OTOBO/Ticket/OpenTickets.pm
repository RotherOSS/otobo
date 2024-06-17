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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::Ticket::OpenTickets;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Ticket',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    my $OpenTickets = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        Result     => 'COUNT',
        StateType  => 'Open',
        UserID     => 1,
        Permission => 'ro',
    ) || 0;

    if ( $OpenTickets > 8000 ) {
        $Self->AddResultWarning(
            Label   => Translatable('Open Tickets'),
            Value   => $OpenTickets,
            Message => Translatable('You should not have more than 8,000 open tickets in your system.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Open Tickets'),
            Value => $OpenTickets,
        );
    }

    return $Self->GetResults();
}

1;
