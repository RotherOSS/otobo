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
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $Home   = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Daemon = $Home . '/bin/otobo.Daemon.pl';

# get daemon status (stop if necessary)
my $PreviousDaemonStatus = `$^X $Daemon status`;

if ( !$PreviousDaemonStatus ) {
    fail("Could not determine current daemon status!");
    die "Could not determine current daemon status!";
}

if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    my $ResultMessage = system("$^X $Daemon stop");
}
else {
    pass("Daemon was already stopped.");
}

# Wait for slow systems
my $SleepTime = 120;
note "Waiting at most $SleepTime s until daemon stops";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $DaemonStatus = `$^X $Daemon status`;
    if ( $DaemonStatus =~ m{Daemon not running}i ) {
        last ACTIVESLEEP;
    }
    note "Sleeping for $Seconds seconds...";
    sleep 1;
}

my $CurrentDaemonStatus = `$^X $Daemon status`;
ok( $CurrentDaemonStatus =~ m{Daemon not running}i, "Daemon is not running" );

if ( $CurrentDaemonStatus !~ m{Daemon not running}i ) {
    fail "Daemon could not be stopped.";
    die "Daemon could not be stopped.";
}

my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

# Remove existing scheduled asynchronous tasks from DB, as they may interfere with tests run later.
my @AsyncTasks = $SchedulerDBObject->TaskList(
    Type => 'AsynchronousExecutor',
);
for my $AsyncTask (@AsyncTasks) {
    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => $AsyncTask->{TaskID},
    );
    ok( $Success, "TaskDelete - Removed scheduled asynchronous task $AsyncTask->{TaskID}" );
}

my @Tests = (
    {
        Name     => 'Synchronous Call',
        Function => 'Execute',
    },
    {
        Name     => 'ASynchronous Call',
        Function => 'ExecuteAsyc',
    },
    {
        Name     => 'ASynchronous Call With Object Name',
        Function => 'ExecuteAsycWithObjectName',
    },
);

# get worker object
my $WorkerObject = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');

# make sure there is no other pending task to be executed
my $Success = $WorkerObject->Run();

# Wait for slow systems
$SleepTime = 120;
note "Waiting at most $SleepTime s until tasks are executed";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my @List = $SchedulerDBObject->TaskList();
    last ACTIVESLEEP if !scalar @List;
    note "Sleeping for $Seconds seconds...";
    sleep 1;
    $WorkerObject->Run();
}

# get needed objects
my $AsynchronousExecutorObject = $Kernel::OM->Get('scripts::test::sample::AsynchronousExecutor::TestAsynchronousExecutor');

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my @FileRemember;
for my $Test (@Tests) {

    my $File = $Home . '/var/tmp/task_' . $Helper->GetRandomNumber();
    if ( -e $File ) {
        unlink $File;
    }
    push @FileRemember, $File;

    my $Function = $Test->{Function};

    $AsynchronousExecutorObject->$Function(
        File    => $File,
        Success => 1,
    );

    if ( $Function eq 'ExecuteAsyc' || $Function eq 'ExecuteAsycWithObjectName' ) {
        $WorkerObject->Run();

        # Wait for slow systems
        $SleepTime = 120;
        note "Waiting at most $SleepTime s until tasks are executed";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $SleepTime ) {
            my @List = $SchedulerDBObject->TaskList();
            last ACTIVESLEEP if !scalar @List;
            note "Sleeping for $Seconds seconds...";
            sleep 1;
            $WorkerObject->Run();
        }
    }

    ok( -e $File, "$Test->{Name} - $File exists" );

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $File,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    is(
        $ContentSCALARRef->$*,
        '123',
        "$Test->{Name} - $File content match",
    );
}

# perform cleanup
for my $File (@FileRemember) {
    if ( -e $File ) {
        unlink $File;
    }
    ok(
        !-e $File,
        "$File removed",
    );
}

# start daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("$^X $Daemon start");
}

done_testing;
