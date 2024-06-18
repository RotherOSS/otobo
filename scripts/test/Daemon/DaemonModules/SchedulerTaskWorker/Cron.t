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
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# prevent mails send
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

my @Tests = (
    {
        Name   => 'Empty',
        Config => {},
        Result => 0,
    },
    {
        Name   => 'Missing TaskID',
        Config => {
            TaskName => 'UnitTest',
            Data     => {
                Module => 'Kernel::System::Console::Command::Maint::Ticket::Test',
                Params => ['-h'],
            },
        },
        Result => 0,
    },
    {
        Name   => 'Missing Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => 1,
        },
        Result => 0,
    },
    {
        Name   => 'Empty Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {},
        },
        Result => 0,
    },
    {
        Name   => 'Missing Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Params => ['-h'],
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Console Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Maint::Ticket::Test',
                Function => 'Execute',
                Params   => ['-h'],
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Console Module Function',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Admin::Group::Add',
                Function => 'Test',
                Params   => ['--no-ansi'],
            },
        },
        Result => 0,
    },
    {
        Name   => 'Correct Console Module Params -h',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Admin::Group::Add',
                Function => 'Execute',
                Params   => ['-h'],
            },
        },
        Result => 1,
    },
    {
        Name   => 'Wrong Console Module Params --hahaha',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Admin::Group::Add',
                Function => 'Execute',
                Params   => ['--hahaha'],
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Core Module Function',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Priority',
                Function => 'Test',
                Params   => [ 'PriorityID', '1' ],
            },
        },
        Result => 0,
    },
    {
        Name   => 'Wrong Core Module Params',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Priority',
                Function => 'PriorityLookup',
                Params   => [ 'TicketID', '1' ],
            },
        },
        Result => 0,
    },
    {
        Name   => 'Console Command Module (wrong params format)',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Maint::Ticket::Dump',
                Function => 'Execute',
                Params   => '--article-limit 2 1',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Core Module (wrong params format)',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Priority',
                Function => 'PriorityLookup',
                Params   => 'PriorityID 1',
            },
        },
        Result => 0,
    },
    {
        Name   => 'Console Command Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Console::Command::Maint::Ticket::Dump',
                Function => 'Execute',
                Params   => [ '--article-limit', '2', '1' ],
            },
        },
        Result => 1,
    },
    {
        Name   => 'Core Module',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
            Data     => {
                Module   => 'Kernel::System::Priority',
                Function => 'PriorityLookup',
                Params   => [ 'PriorityID', '1' ],
            },
        },
        Result => 1,
    },
);

# get task handler object
my $TaskHandlerObject = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron');

for my $Test (@Tests) {

    # result task
    my $Result = $TaskHandlerObject->Run( %{ $Test->{Config} } );

    $Self->Is(
        $Result || 0,
        $Test->{Result},
        "$Test->{Name} - execution result",
    );
}

# cleanup cache is done by RestoreDatabase.

$Self->DoneTesting();
