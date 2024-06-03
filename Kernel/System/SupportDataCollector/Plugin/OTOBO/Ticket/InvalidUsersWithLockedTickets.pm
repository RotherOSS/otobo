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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::Ticket::InvalidUsersWithLockedTickets;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('OTOBO');
}

sub Run {
    my $Self = shift;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $InvalidUsersTicketCount;
    $DBObject->Prepare(
        SQL => '
        SELECT COUNT(*) FROM ticket, users
        WHERE
            ticket.user_id = users.id
            AND ticket.ticket_lock_id = 2
            AND users.valid_id != 1
        ',
        Limit => 1,
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $InvalidUsersTicketCount = $Row[0];
    }

    if ($InvalidUsersTicketCount) {
        $Self->AddResultWarning(
            Label   => Translatable('Invalid Users with Locked Tickets'),
            Value   => $InvalidUsersTicketCount,
            Message => Translatable('There are invalid users with locked tickets.'),
        );
    }
    else {
        $Self->AddResultOk(
            Label => Translatable('Invalid Users with Locked Tickets'),
            Value => '0',
        );
    }

    return $Self->GetResults();
}

1;
