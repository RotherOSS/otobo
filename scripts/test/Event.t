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

our $Self;

# get event object
my $EventObject = $Kernel::OM->Get('Kernel::System::Event');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my %EventList = $EventObject->EventList();

$Self->Is(
    $EventList{Ticket}[0],
    'TicketCreate',
    "EventList() Ticket"
);

$Self->Is(
    $EventList{Article}[0],
    'ArticleCreate',
    "EventList() Article"
);

my %EventListTicket = $EventObject->EventList(
    ObjectTypes => ['Ticket'],
);

$Self->Is(
    $EventListTicket{Ticket}[0],
    'TicketCreate',
    "EventListTicket() Ticket"
);

$Self->Is(
    $EventListTicket{Article}[0],
    undef,
    "EventListTicket() Article"
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
