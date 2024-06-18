# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
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

use Test2::V0;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

use Kernel::System::VariableCheck qw(:all);

plan(6);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

# for this script activate the default EscalationSuspendStates
$ConfigObject->Set(
    Key   => 'EscalationSuspendStates',
    Value => [
        'pending auto close+',
        'pending auto close-',
        'pending reminder',
    ],
);

# Disable transaction mode for escalation index ticket event module
my $TicketEventModulePostConfig = $ConfigObject->Get('Ticket::EventModulePost');
my $EscalationIndexName         = '9990-EscalationIndex';

$Self->True(
    $TicketEventModulePostConfig->{$EscalationIndexName},
    "Ticket::EventModulePost $EscalationIndexName exists",
);

$TicketEventModulePostConfig->{$EscalationIndexName}->{Transaction} = 0;
$ConfigObject->Set(
    Key   => 'Ticket::EventModulePost',
    Value => $TicketEventModulePostConfig,
);

$TicketEventModulePostConfig = $ConfigObject->Get('Ticket::EventModulePost');

$Self->IsDeeply(
    $TicketEventModulePostConfig->{$EscalationIndexName},
    {
        'Transaction' => 0,
        'Event'       =>
            'TicketSLAUpdate|TicketQueueUpdate|TicketStateUpdate|TicketCreate|ArticleCreate|TicketDynamicFieldUpdate|TicketTypeUpdate|TicketServiceUpdate|TicketCustomerUpdate|TicketPriorityUpdate|TicketMerge',
        'Module' => 'Kernel::System::Ticket::Event::TicketEscalationIndex'
    },
    "Disable transaction mode for $EscalationIndexName Ticket::EventModulePost",
);

my $RandomID = $HelperObject->GetRandomID();

my $QueueID = $QueueObject->QueueAdd(
    Name              => 'UnitTest' . $RandomID,
    ValidID           => 1,
    GroupID           => 1,
    FirstResponseTime => 4 * 60,                   # 4h
    UpdateTime        => 0,
    SolutionTime      => 24 * 60,                  # 24h
    UnlockTimeout     => 0,
    FollowUpId        => 1,
    FollowUpLock      => 1,
    SystemAddressID   => 1,
    SalutationID      => 1,
    SignatureID       => 1,
    Comment           => 'UnitTest' . $RandomID,
    UserID            => 1,
);

$ConfigObject->Set(
    Key   => 'TimeWorkingHours',
    Value => {
        'Mon' => [ 8 .. 18 ],    # 11 h, from 8:00 to 18:59:59
        'Tue' => [ 8 .. 18 ],
        'Wed' => [ 8 .. 18 ],
        'Thu' => [ 8 .. 18 ],
        'Fri' => [ 8 .. 15 ],    # 8 h
        'Sat' => [],
        'Sun' => [],
    },
);

# Ticket creation
# Solution time is 24 h after ticket creation.
# Tuesday:   02:09:52 h
# Wednesday: 11:00:00 h
# Thursday : 10:50:08 h
# sum:       24:00:00 h
# Solution time: Thursday 08:00 + 10:50:08 h = 2016-04-14 18:50:08
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-04-12 16:50:08',
        },
    )
);    # Tuesday
my $TicketID = $TicketObject->TicketCreate(
    UserID   => 1,
    State    => 'new',         # or StateID => 5,
    Lock     => 'unlock',
    Priority => '3 normal',    # or PriorityID => 2,
    QueueID  => $QueueID,
    OwnerID  => 1,
);

{
    # Rebuild escalation index and test result
    $TicketObject->TicketEscalationIndexBuild(
        TicketID => $TicketID,
        UserID   => 1,
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # Solution time is 2016-04-15 08:01:17
    my $SolutionTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-04-14 18:50:08'
        }
    )->ToEpoch();

    $Self->Is(
        $Ticket{SolutionTimeDestinationTime},
        $SolutionTime,
        'SolutionTimeDestinationTime calculated correctly'
    );
    $Self->Note( Note => "expected solution time: " . localtime($SolutionTime) );
    $Self->Note( Note => "computed solution time: " . localtime( $Ticket{SolutionTimeDestinationTime} ) );
}

# Set pending reminder
# TicketEscalationSuspendCalculate will add 4 minutes to prevent escalation
# pending reminder is configured as suspend state
# solution time is then 2016-04-14 18:54:08
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-04-12 16:52:53',
        },
    )
);    # Tuesday
$TicketObject->TicketStateSet(
    State    => 'pending reminder',
    TicketID => $TicketID,
    UserID   => 1,
);
$TicketObject->TicketPendingTimeSet(
    String   => '2016-04-15 16:52:00',    # Friday
    TicketID => $TicketID,
    UserID   => 1,
);

{
    # Rebuild escalation index and test result
    $TicketObject->TicketEscalationIndexBuild(
        TicketID => $TicketID,
        UserID   => 1,
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # Solution time is 2016-04-15 08:01:17
    my $SolutionTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-04-14 18:54:08'
        },
    )->ToEpoch();

    $Self->Is(
        $Ticket{SolutionTimeDestinationTime},
        $SolutionTime,
        'SolutionTimeDestinationTime calculated correctly'
    );
    $Self->Note( Note => "expected solution time: " . localtime($SolutionTime) );
    $Self->Note( Note => "computed solution time: " . localtime( $Ticket{SolutionTimeDestinationTime} ) );
}

# Set status "open"
# This leads to +3:09 minutes because 16:52:53 from above + 4 minutes (see above)
# = 16:56:53 and 17:00:02 - 16:56:53 = 3:09
# open is not configured as suspend state, meaning, the new solution time
# solution time is then 2016-04-14 18:57:17
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-04-12 17:00:02',
        },
    )
);    # Tuesday
$TicketObject->TicketStateSet(
    State    => 'open',
    TicketID => $TicketID,
    UserID   => 1,
);
$TicketObject->TicketPendingTimeSet(
    String   => '0000-00-00 00:00:00',
    TicketID => $TicketID,
    UserID   => 1,
);

{
    # Rebuild escalation index and test result
    $TicketObject->TicketEscalationIndexBuild(
        TicketID => $TicketID,
        UserID   => 1,
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # Solution time is 2016-04-15 08:01:17
    my $SolutionTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-04-14 18:57:17'
        },
    )->ToEpoch();

    $Self->Is(
        $Ticket{SolutionTimeDestinationTime},
        $SolutionTime,
        'SolutionTimeDestinationTime calculated correctly'
    );
    $Self->Note( Note => "expected solution time: " . localtime($SolutionTime) );
    $Self->Note( Note => "computed solution time: " . localtime( $Ticket{SolutionTimeDestinationTime} ) );
}

# Set pending reminder
# this adds another 4 minutes to the solution time
# new solution time: Friday 2016-04-15 08:01:17
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-05-31 08:37:10',
        },
    )
);    # Tuesday
$TicketObject->TicketStateSet(
    State    => 'pending reminder',
    TicketID => $TicketID,
    UserID   => 1,
);
$TicketObject->TicketPendingTimeSet(
    String   => '2016-06-19 08:34:00',    # Sunday
    TicketID => $TicketID,
    UserID   => 1,
);

{
    # Rebuild escalation index and test result
    $TicketObject->TicketEscalationIndexBuild(
        TicketID => $TicketID,
        UserID   => 1,
    );

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # Solution time is 2016-04-15 08:01:17
    my $SolutionTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2016-04-15 08:01:17'
        },
    )->ToEpoch();

    $Self->Is(
        $Ticket{SolutionTimeDestinationTime},
        $SolutionTime,
        'SolutionTimeDestinationTime calculated correctly'
    );
    $Self->Note( Note => "expected solution time: " . localtime($SolutionTime) );
    $Self->Note( Note => "computed solution time: " . localtime( $Ticket{SolutionTimeDestinationTime} ) );
}

FixedTimeUnset();
