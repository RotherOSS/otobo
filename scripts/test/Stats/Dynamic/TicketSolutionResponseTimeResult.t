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
use Kernel::System::UnitTest::MockTime qw(
    FixedTimeAddSeconds
    FixedTimeSet
    FixedTimeUnset
);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::VariableCheck qw(:all);

our $Self;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Set some config options for the testing.
$ConfigObject->Set(
    Key   => 'OTOBOTimeZone',
    Value => 'UTC',
);

my $ArticleObject  = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $StatsObject    = $Kernel::OM->Get('Kernel::System::Stats');
my $QueueObject    = $Kernel::OM->Get('Kernel::System::Queue');
my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my @QueueNames;
my @QueueIDs;

for my $Count ( 1 .. 2 ) {

    my $QueueName = "Statistic-$Count-Queue-" . $RandomID;
    my $QueueID   = $QueueObject->QueueAdd(
        Name            => "Statistic-$Count-Queue-" . $RandomID,
        ValidID         => 1,
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
        "QueueAdd() successful for test - QueueID $QueueID",
    );

    push @QueueIDs,   $QueueID;
    push @QueueNames, $QueueName;
}

# Define the tickets for the statistic result tests, but at the moment only for the solution time.
my @Tickets = (

    # add the ticket in the first statistic queue
    {
        TimeStamp  => '2014-10-10 08:00:00',
        TicketData => {
            Title                 => 'Statistic Ticket Title',
            Queue                 => $QueueNames[0],
            Lock                  => 'unlock',
            Priority              => '3 normal',
            State                 => 'open',
            CustomerID            => 'example + test',
            CustomerUser          => 'customer1@example.com',
            OwnerID               => 1,
            UserID                => 1,
            AddSecondsBeforeClose => 360,
        },
    },
    {
        TimeStamp  => '2014-10-12 09:00:00',
        TicketData => {
            Title                 => 'Statistic Ticket Title',
            Queue                 => $QueueNames[0],
            Lock                  => 'unlock',
            Priority              => '3 normal',
            State                 => 'open',
            CustomerID            => 'example + test',
            CustomerUser          => 'customer1@example.com',
            OwnerID               => 1,
            UserID                => 1,
            AddSecondsBeforeClose => 960,
        },
    },
    {
        TimeStamp  => '2014-10-12 12:00:00',
        TicketData => {
            Title                 => 'Statistic Ticket Title',
            Queue                 => $QueueNames[0],
            Lock                  => 'unlock',
            Priority              => '3 normal',
            State                 => 'open',
            CustomerID            => 'example + test',
            CustomerUser          => 'customer1@example.com',
            OwnerID               => 1,
            UserID                => 1,
            AddSecondsBeforeClose => 1800,
        },
    },
    {
        TimeStamp  => '2014-10-14 08:00:00',
        TicketData => {
            Title                 => 'Statistic Ticket Title',
            Queue                 => $QueueNames[1],
            Lock                  => 'unlock',
            Priority              => '3 normal',
            State                 => 'open',
            CustomerID            => 'example + test',
            CustomerUser          => 'customer1@example.com',
            OwnerID               => 1,
            UserID                => 1,
            AddSecondsBeforeClose => 180,
        },
    },
    {
        TimeStamp  => '2014-10-11 08:00:00',
        TicketData => {
            Title        => 'Statistic Ticket Title',
            Queue        => $QueueNames[1],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => 'example + test',
            CustomerUser => 'customer1@example.com',
            OwnerID      => 1,
            UserID       => 1,
        },
    },
);

my @TicketIDs;

TICKET:
for my $Ticket (@Tickets) {

    # check TicketData attribute
    if ( !$Ticket->{TicketData} || ref $Ticket->{TicketData} ne 'HASH' ) {

        $Self->True(
            0,
            "No TicketData found for this test ticket.",
        );
        next TICKET;
    }

    my $SystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Ticket->{TimeStamp},
        }
    )->ToEpoch();

    # set the fixed time
    FixedTimeSet($SystemTime);

    # create the ticket
    my $TicketID = $TicketObject->TicketCreate(
        %{ $Ticket->{TicketData} },
    );

    # sanity check
    $Self->True(
        $TicketID,
        "TicketCreate() successful for test - TicketID $TicketID",
    );

    if ( $Ticket->{TicketData}->{AddSecondsBeforeClose} ) {

        FixedTimeAddSeconds( $Ticket->{TicketData}->{AddSecondsBeforeClose} );

        # Now close the ticket, because the statistic select only closed tickets.
        $TicketObject->TicketStateSet(
            TicketID => $TicketID,
            State    => 'closed successful',
            UserID   => 1,
        );
    }

    my %TicketData = $TicketObject->TicketGet(
        TicketID => $TicketID,
        UserID   => 1,
    );

    push @TicketIDs, \%TicketData;
}
continue {
    FixedTimeUnset();
}

my %StateList = $Kernel::OM->Get('Kernel::System::State')->StateList(
    UserID => 1,
);
my %LookupStateList = map { $StateList{$_} => $_ } sort keys %StateList;

# set the language to 'en' before the StatsRun
$Kernel::OM->ObjectParamAdd(
    'Kernel::Language' => {
        UserLanguage => 'en',
    },
);

# generate the TicketSolutionResponseTime test statistic
my $TicketSolutionResponseTimeStatID = $StatsObject->StatsAdd(
    UserID => 1,
);

# sanity check
$Self->True(
    $TicketSolutionResponseTimeStatID,
    'StatsAdd() TicketSolutionResponseTime successful - StatID $TicketSolutionResponseTimeStatID',
);

my $UpdateSuccess = $StatsObject->StatsUpdate(
    StatID => $TicketSolutionResponseTimeStatID,
    Hash   => {
        Title        => 'Title for result tests',
        Description  => 'some Description',
        Object       => 'TicketSolutionResponseTime',
        Format       => 'CSV',
        ObjectModule => 'Kernel::System::Stats::Dynamic::TicketSolutionResponseTime',
        StatType     => 'dynamic',
        Cache        => 1,
        Valid        => 1,
    },
    UserID => 1,
);

# sanity check
$Self->True(
    $UpdateSuccess,
    'StatsUpdate() TicketSolutionResponseTime successful - StatID $TicketSolutionResponseTimeStatID',
);

my $KindsOfReporting
    = $Kernel::OM->Get('Kernel::System::Stats::Dynamic::TicketSolutionResponseTime')->_KindsOfReporting();

my @Tests = (

    # Test with a relative time period and without a defined time zone
    # Fixed TimeStamp: '2014-10-15 12:00:00'
    # TimeZone: -
    # X-Axis: 'KindsOfReporting' with all values.
    # Y-Axis: 'QueueIDs' to select only the created tickets for the test.
    # Restrictions: -
    {
        Description => 'Test stat without a time zone (KindsOfReporting with all values).',
        TimeStamp   => '2014-10-15 12:00:00',
        StatsUpdate => {
            StatID => $TicketSolutionResponseTimeStatID,
            Hash   => {
                UseAsXvalue => [
                    {
                        Element        => 'KindsOfReporting',
                        Block          => 'Time',
                        Fixed          => 1,
                        Selected       => 1,
                        SelectedValues => [
                            'SolutionAverageAllOver',
                            'SolutionMinTimeAllOver',
                            'SolutionMaxTimeAllOver',
                            'NumberOfTicketsAllOver',
                            'SolutionAverage',
                            'SolutionMinTime',
                            'SolutionMaxTime',
                            'SolutionWorkingTimeAverage',
                            'SolutionMinWorkingTime',
                            'SolutionMaxWorkingTime',
                            'ResponseAverage',
                            'ResponseMinTime',
                            'ResponseMaxTime',
                            'ResponseWorkingTimeAverage',
                            'ResponseMinWorkingTime',
                            'ResponseMaxWorkingTime',
                            'NumberOfTickets',
                        ],
                    },
                ],
                UseAsValueSeries => [
                    {
                        'Element'        => 'QueueIDs',
                        'Block'          => 'MultiSelectField',
                        'Selected'       => 1,
                        'Fixed'          => 1,
                        'SelectedValues' => \@QueueIDs,
                    },
                ],
                UseAsRestriction => [],
            },
            UserID => 1,
        },
        ReferenceResultData => [
            [
                'Title for result tests',
            ],
            [
                'Queue',
                $KindsOfReporting->{SolutionAverageAllOver},
                $KindsOfReporting->{SolutionMinTimeAllOver},
                $KindsOfReporting->{SolutionMaxTimeAllOver},
                $KindsOfReporting->{NumberOfTicketsAllOver},
                $KindsOfReporting->{SolutionAverage},
                $KindsOfReporting->{SolutionMinTime},
                $KindsOfReporting->{SolutionMaxTime},
                $KindsOfReporting->{SolutionWorkingTimeAverage},
                $KindsOfReporting->{SolutionMinWorkingTime},
                $KindsOfReporting->{SolutionMaxWorkingTime},
                $KindsOfReporting->{ResponseAverage},
                $KindsOfReporting->{ResponseMinTime},
                $KindsOfReporting->{ResponseMaxTime},
                $KindsOfReporting->{ResponseWorkingTimeAverage},
                $KindsOfReporting->{ResponseMinWorkingTime},
                $KindsOfReporting->{ResponseMaxWorkingTime},
                $KindsOfReporting->{NumberOfTickets},
            ],
            [
                $QueueNames[0],
                '17 m',
                '6 m',
                '30 m',
                3,
                '17 m',
                '6 m',
                '30 m',
                '2 m',
                '0 m',
                '6 m',
                '0 m',
                '0 m',
                '0 m',
                '0 m',
                '0 m',
                '0 m',
                3,
            ],
            [
                $QueueNames[1],
                '3 m',
                '3 m',
                '3 m',
                1,
                '3 m',
                '3 m',
                '3 m',
                '3 m',
                '3 m',
                '3 m',
                '0 m',
                '0 m',
                '0 m',
                '0 m',
                '0 m',
                '0 m',
                1,
            ],
        ],
    },
);

# ------------------------------------------------------------ #
# run general result statistic tests
# ------------------------------------------------------------ #

# define test counter
my $TestCount = 1;

TEST:
for my $Test (@Tests) {

    # set the language for the test (for the translatable content)
    if ( $Test->{Language} ) {

        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::Language'],
        );

        $Kernel::OM->ObjectParamAdd(
            'Kernel::Language' => {
                UserLanguage => $Test->{Language},
            },
        );
    }

    # check ContractAdd attribute
    if ( !$Test->{StatsUpdate} || ref $Test->{StatsUpdate} ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: No StatsUpdate found for this test.",
        );

        next TEST;
    }

    # set the fixed time
    my $SystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Test->{TimeStamp},
        }
    )->ToEpoch();
    FixedTimeSet($SystemTime);

    # print test case description
    if ( $Test->{Description} ) {
        $Self->True(
            1,
            "Test $TestCount: $Test->{Description}",
        );
    }

    my $UpdateSuccess = $StatsObject->StatsUpdate(
        %{ $Test->{StatsUpdate} },
    );

    $Self->True(
        $UpdateSuccess,
        "Test $TestCount: StatsUpdate() - Update stat - success.",
    );

    my $Stat = $StatsObject->StatsGet( StatID => $Test->{StatsUpdate}->{StatID} );

    # Add the ExchangeAxis param to the stat hash, because this can only be changed at runtime.
    $Stat->{ExchangeAxis} = $Test->{StatsUpdate}->{Hash}->{ExchangeAxis};

    $Self->True(
        $Stat->{Title},
        "Test $TestCount: StatsGet() - Get the stat data - success.",
    );

    my $ResultData = $StatsObject->StatsRun(
        StatID   => $Test->{StatsUpdate}->{StatID},
        GetParam => $Stat,
        UserID   => 1,
    );

    $Self->IsDeeply(
        $ResultData,
        $Test->{ReferenceResultData},
        "Test $TestCount: StatsRun() - test the result",
    );
}
continue {

    FixedTimeUnset();

    $TestCount++;
}

# to get the system default language in the next test
$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::Language'],
);

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
