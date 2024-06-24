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

# get needed objects
my $QueueObject   = $Kernel::OM->Get('Kernel::System::Queue');
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
my $SLAObject     = $Kernel::OM->Get('Kernel::System::SLA');
my $StateObject   = $Kernel::OM->Get('Kernel::System::State');
my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $TypeObject    = $Kernel::OM->Get('Kernel::System::Type');
my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set fixed time
FixedTimeSet();

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

# try to get a non-existant ticket
my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID + 1,
);
$Self->False(
    $Ticket{Title},
    'TicketGet() (Title) is empty',
);

my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
    Groups => [ 'users', ],
);

my $TicketIDCreatedBy = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => $TestUserID,
);

my %CheckCreatedBy = $TicketObject->TicketGet(
    TicketID => $TicketIDCreatedBy,
    UserID   => $TestUserID,
);

$Self->Is(
    $CheckCreatedBy{ChangeBy},
    $TestUserID,
    'TicketGet() (ChangeBy - not system ID 1 user)',
);

$Self->Is(
    $CheckCreatedBy{CreateBy},
    $TestUserID,
    'TicketGet() (CreateBy - not system ID 1 user)',
);

$TicketObject->TicketOwnerSet(
    TicketID  => $TicketIDCreatedBy,
    NewUserID => $TestUserID,
    UserID    => 1,
);

%CheckCreatedBy = $TicketObject->TicketGet(
    TicketID => $TicketIDCreatedBy,
    UserID   => $TestUserID,
);

$Self->Is(
    $CheckCreatedBy{CreateBy},
    $TestUserID,
    'TicketGet() (CreateBy - still the same after OwnerSet)',
);

$Self->Is(
    $CheckCreatedBy{OwnerID},
    $TestUserID,
    'TicketOwnerSet()',
);

$Self->Is(
    $CheckCreatedBy{ChangeBy},
    1,
    'TicketOwnerSet() (ChangeBy - System ID 1 now)',
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
