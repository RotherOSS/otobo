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

# get needed objects
my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::Acl::Module',
    Value => {
        DummyModule => {
            Module        => 'scripts::test::Ticket::TicketACL::DummyModule',
            ReturnType    => 'Ticket',
            ReturnSubType => 'State',
            Checks        => ['Ticket'],
        },
    },
);

# set valid options
my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
%ValidList = reverse %ValidList;

# set user options
my ( $UserLogin, $UserID ) = $Helper->TestUserCreate(
    Groups => ['admin'],
);

my $RandomID = $Helper->GetRandomID();

# set queue options
my $QueueName = 'Queue_' . $RandomID;
my $QueueID   = $QueueObject->QueueAdd(
    Name            => $QueueName,
    ValidID         => $ValidList{'valid'},
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

# sanity check
$Self->True(
    $QueueID,
    "QueueAdd() ID ($QueueID) added successfully"
);

# set state options
my $StateName = 'State_' . $RandomID;
my $StateID   = $Kernel::OM->Get('Kernel::System::State')->StateAdd(
    Name    => $StateName,
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $StateID,
    "StateAdd() ID ($StateID) added successfully"
);

# set priority options
my $PriorityName = 'Priority_' . $RandomID;
my $PriorityID   = $Kernel::OM->Get('Kernel::System::Priority')->PriorityAdd(
    Name    => $PriorityName,
    ValidID => $ValidList{'valid'},
    UserID  => 1,
);

# sanity check
$Self->True(
    $PriorityID,
    "PriorityAdd() ID ($PriorityID) added successfully"
);

my $TicketID = $TicketObject->TicketCreate(
    Title      => 'Test Ticket for TicketACL Module tests',
    QueueID    => $QueueID,
    Lock       => 'lock',
    StateID    => $StateID,
    OwnerID    => $UserID,
    UserID     => 1,
    PriorityID => $PriorityID,
);

$Self->True(
    $TicketID,
    "Ticket ID ($TicketID) successfully created",
);

my $AclSuccess = $TicketObject->TicketAcl(
    TicketID      => $TicketID,
    ReturnType    => 'Ticket',
    ReturnSubType => 'State',
    UserID        => $UserID,
    Data          => {
        1 => 'new',
        2 => 'open',
    },
);

$Self->True(
    $AclSuccess,
    'ACL from module matched',
);

my %ACLData = $TicketObject->TicketAclData();

$Self->IsDeeply(
    \%ACLData,
    { 1 => 'new' },
    'AclData from module',
);

$AclSuccess = $TicketObject->TicketAcl(
    TicketID      => $TicketID,
    ReturnType    => 'Ticket',
    ReturnSubType => 'Service',
    UserID        => $UserID,
    Data          => {
        1 => 'new',
    },
);

$Self->False(
    $AclSuccess,
    'Non-matching ACL from module',
);

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
