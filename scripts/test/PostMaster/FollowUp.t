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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
FixedTimeSet();

my $AgentAddress    = 'agent@example.com';
my $CustomerAddress = 'external@example.com';

my $QueueID = $QueueObject->QueueAdd(
    Name            => 'NewTestQueue',
    ValidID         => 1,
    GroupID         => 1,
    UnlockTimeout   => 480,
    FollowUpID      => 3,                # create new ticket
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
$Self->True(
    $QueueID,
    "Queue created."
);

my @Tests = (
    {
        TicketState     => 'new',
        QueueFollowUpID => 1,       # possible (1), reject (2) or new ticket (3) (optional, default 0)
        ExpectedResult  => 2,       # 0 = error (also false)
                                    # 1 = new ticket created
                                    # 2 = follow up / open/reopen
                                    # 3 = follow up / close -> new ticket
                                    # 4 = follow up / close -> reject
                                    # 5 = ignored (because of X-OTOBO-Ignore header)
    },
    {
        TicketState     => 'open',
        QueueFollowUpID => 1,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'closed successful',
        QueueFollowUpID => 1,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'closed unsuccessful',
        QueueFollowUpID => 1,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'pending reminder',
        QueueFollowUpID => 1,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'removed',
        QueueFollowUpID => 1,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'merged',
        QueueFollowUpID => 1,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'new',
        QueueFollowUpID => 2,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'open',
        QueueFollowUpID => 2,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'closed successful',
        QueueFollowUpID => 2,
        ExpectedResult  => 4,
    },
    {
        TicketState     => 'closed unsuccessful',
        QueueFollowUpID => 2,
        ExpectedResult  => 4,
    },
    {
        TicketState     => 'pending reminder',
        QueueFollowUpID => 2,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'removed',
        QueueFollowUpID => 2,
        ExpectedResult  => 4,
    },
    {
        TicketState     => 'merged',
        QueueFollowUpID => 2,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'new',
        QueueFollowUpID => 3,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'open',
        QueueFollowUpID => 3,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'closed successful',
        QueueFollowUpID => 3,
        ExpectedResult  => 3,
    },
    {
        TicketState     => 'closed unsuccessful',
        QueueFollowUpID => 3,
        ExpectedResult  => 3,
    },
    {
        TicketState     => 'pending reminder',
        QueueFollowUpID => 3,
        ExpectedResult  => 2,
    },
    {
        TicketState     => 'removed',
        QueueFollowUpID => 3,
        ExpectedResult  => 3,
    },
    {
        TicketState     => 'merged',
        QueueFollowUpID => 3,
        ExpectedResult  => 2,
    },
);

# create a new ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'My ticket created by Agent',
    Queue        => 'NewTestQueue',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'removed',
    CustomerUser => 'external@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$TicketID //= '';

$Self->True(
    $TicketID,
    "Ticket created - TicketID=$TicketID."
);

my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 0,
    UserID        => 1,
    Silent        => 0,
);

for my $Test (@Tests) {

    my @Return;

    # update Queue (FollowUpID)
    my $QueueUpdated = $QueueObject->QueueUpdate(
        QueueID         => $QueueID,
        Name            => 'NewTestQueue',
        ValidID         => 1,
        GroupID         => 1,
        UnlockTimeout   => 480,
        FollowUpID      => $Test->{QueueFollowUpID},
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Some comment',
        UserID          => 1,
    );
    $Self->True(
        $QueueUpdated,
        "Queue updated."
    );

    my $TicketUpdated = $TicketObject->TicketStateSet(
        State    => $Test->{TicketState},
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $TicketUpdated,
        "TicketStateSet updated."
    );

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

    my $PostMasterObject = Kernel::System::PostMaster->new(
        CommunicationLogObject => $CommunicationLogObject,
        Email                  => "From: Provider <$CustomerAddress>
To: Agent <$AgentAddress>
Subject: FollowUp Ticket#$Ticket{TicketNumber}

Some Content in Body",
    );

    @Return = $PostMasterObject->Run();

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Message',
        Status        => 'Successful',
    );
    $CommunicationLogObject->CommunicationStop(
        Status => 'Successful',
    );

    $Self->Is(
        $Return[0] || 0,
        $Test->{ExpectedResult},
        "Check result (State=$Test->{TicketState}, FollowUpID=$Test->{QueueFollowUpID}).",
    );
}

$Self->DoneTesting();
