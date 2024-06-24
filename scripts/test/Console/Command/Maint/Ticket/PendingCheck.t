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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::PendingCheck');
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent A',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'pending auto close+',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

$Self->True(
    $TicketID,
    "Ticket created",
);

my $Success = $TicketObject->TicketPendingTimeSet(
    String   => '2014-01-03 00:00:00',
    TicketID => $TicketID,
    UserID   => 1,
);

$Self->True(
    $TicketID,
    "Set pending time",
);

# test the pending auto close, with a time before the pending time
my $SystemTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2014-01-01 12:00:00',
    },
)->ToEpoch();

# set the fixed time
FixedTimeSet($SystemTime);

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::PendingCheck exit code",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->Is(
    $Ticket{State},
    'pending auto close+',
    "Ticket pending auto close time not reached",
);

# test the pending auto close, for a reached pending time
$SystemTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2014-01-03 03:00:00',
    },
)->ToEpoch();

# set the fixed time
FixedTimeSet($SystemTime);

$ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::PendingCheck exit code",
);

%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->Is(
    $Ticket{State},
    'closed successful',
    "Ticket pending auto closed time reached",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
