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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed object
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Ticket::Delete');
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');

$Kernel::OM->Get('Kernel::System::Cache')->Configure(
    CacheInMemory => 0,
);

my $CustomerUser = $Helper->GetRandomID() . '@example.com';

# create a new tickets
my @Tickets;
for ( 1 .. 4 ) {
    my $TicketNumber = $TicketObject->TicketCreateNumber();
    my $TicketID     = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
        TN           => $TicketNumber,
        Title        => 'Test ticket',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'open',
        CustomerNo   => '123465',
        CustomerUser => $CustomerUser,
        OwnerID      => 1,
        UserID       => 1,
    );

    $Self->True(
        $TicketID,
        "Ticket is created - $TicketID",
    );

    my %TicketHash = (
        TicketID => $TicketID,
        TN       => $TicketNumber,
    );
    push @Tickets, \%TicketHash;
}

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    1,
    "Maint::Ticket::Delete exit code without arguments.",
);

$ExitCode = $CommandObject->Execute( '--ticket-id', $Tickets[0]->{TicketID}, '--ticket-id', $Tickets[1]->{TicketID} );

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::Delete exit code - delete by --ticket-id options.",
);

my %TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    CustomerUserLogin => $CustomerUser,
    UserID            => 1,
);

$Self->False(
    $TicketIDs{ $Tickets[0]->{TicketID} },
    "Ticket is deleted - $Tickets[0]->{TicketID}",
);

$Self->False(
    $TicketIDs{ $Tickets[1]->{TicketID} },
    "Ticket is deleted - $Tickets[1]->{TicketID}",
);

$ExitCode = $CommandObject->Execute( '--ticket-number', $Tickets[2]->{TN}, '--ticket-number', $Tickets[3]->{TN} );

$Self->Is(
    $ExitCode,
    0,
    "Maint::Ticket::Delete exit code - delete by --ticket-number options.",
);

%TicketIDs = $TicketObject->TicketSearch(
    Result            => 'HASH',
    CustomerUserLogin => $CustomerUser,
    UserID            => 1,
);

$Self->False(
    $TicketIDs{ $Tickets[2]->{TicketID} },
    "Ticket is deleted - $Tickets[2]->{TicketID}",
);

$Self->False(
    $TicketIDs{ $Tickets[3]->{TicketID} },
    "Ticket is deleted - $Tickets[3]->{TicketID}",
);

$ExitCode = $CommandObject->Execute(
    '--ticket-id',     $Tickets[0]->{TicketID}, '--ticket-id',     $Tickets[1]->{TicketID},
    '--ticket-number', $Tickets[2]->{TN},       '--ticket-number', $Tickets[3]->{TN}
);

$Self->Is(
    $ExitCode,
    1,
    "Maint::Ticket::Delete exit code - try to delete with wrong ticket numbers and ticket IDs.",
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
