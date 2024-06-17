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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get ticket object
my $ColumnFilterObject = $Kernel::OM->Get('Kernel::System::Ticket::ColumnFilter');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Tests = (
    {
        Name   => 'No array',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => 1,
        },
        Result => undef,
    },
    {
        Name   => 'Single Integer',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [1],
        },
        Result => ' AND (  ticket.id IN (1)  ) ',
    },
    {
        Name   => 'Single Integer, default table',
        Params => {
            TicketIDs => [1],
        },
        Result => ' AND (  t.id IN (1)  ) ',
    },
    {
        Name   => 'Single Integer, no AND',
        Params => {
            TicketIDs  => [1],
            IncludeAdd => 0,
        },
        Result => ' t.id IN (1) ',
    },
    {
        Name   => 'Sorted values',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [ 2, 1, -1, 0 ],
        },
        Result => ' AND (  ticket.id IN (-1, 0, 1, 2)  ) ',
    },
    {
        Name   => 'Invalid value',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [1.1],
        },
        Result => undef,
    },
    {
        Name   => 'Mix of valid and invalid values',
        Params => {
            ColumnName => 'ticket.id',
            TicketIDs  => [ 1, 1.1 ],
        },
        Result => undef,
    },
);

for my $Test (@Tests) {
    $Self->Is(
        scalar $ColumnFilterObject->_TicketIDStringGet( %{ $Test->{Params} } ),
        $Test->{Result},
        "$Test->{Name} _TicketIDStringGet()"
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
