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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::AsynchronousExecutor;

our $Self;

# get helper object
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

ok( $Helper, 'Instance created' );

# testing GetRandomID()
my %SeenRandomIDs;
my $DuplicateIDFound;

LOOP:
for my $I ( 1 .. 1_000_000 ) {
    my $RandomID = $Helper->GetRandomID();
    if ( $SeenRandomIDs{$RandomID}++ ) {
        fail("GetRandomID iteration $I returned a duplicate RandomID $RandomID");
        $DuplicateIDFound++;

        last LOOP;
    }
}

ok( !$DuplicateIDFound, "GetRandomID() returned no duplicates" );

# testing GetRandomNumber()
my %SeenRandomNumbers;
my $DuplicateNumbersFound;

LOOP:
for my $I ( 1 .. 1_000_000 ) {
    my $RandomNumber = $Helper->GetRandomNumber();
    if ( $SeenRandomNumbers{$RandomNumber}++ ) {
        fail("GetRandomNumber iteration $I returned a duplicate RandomNumber $RandomNumber");
        $DuplicateNumbersFound++;

        last LOOP;
    }
}

ok( !$DuplicateNumbersFound, "GetRandomNumber() returned no duplicates" );

# Testing GetSequentialTwoLetterString()
{
    is( $Helper->GetSequentialTwoLetterString(), 'AA', 'initial value AA of the sequence' );
    is( $Helper->GetSequentialTwoLetterString(), 'AB', 'second value AA of the sequence' );
}

# Test transactions
$Helper->BeginWork();

my $TestUserLogin = $Helper->TestUserCreate();

ok( $TestUserLogin, 'Can create test user' );

$Helper->Rollback();
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);

$Self->False(
    $User{UserID},
    'Rollback worked',
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$Self->Is(
    scalar $ConfigObject->Get('nonexisting_dummy'),
    undef,
    "Config setting does not exist yet",
);

my $Home = $ConfigObject->Get('Home');
ok( -d $Home, "Home exists" );

my $Value = q$1'"$;

# This should use ZZZZUnitTestAC.pm, as AA and AB are already removed from the sequence
is(
    scalar [ glob "$Home/Kernel/Config/Files/ZZZZUnitTestAC*.pm" ]->@*,
    0,
    'ZZZZUnitTestAC*.pm does not exist yet'
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'nonexisting_dummy',
    Value => $Value,
);
$ConfigObject->SyncWithS3();
is(
    scalar [ glob "$Home/Kernel/Config/Files/ZZZZUnitTestAC*.pm" ]->@*,
    1,
    'ZZZZUnitTestAC*.pm was created'
);

$Self->Is(
    scalar $ConfigObject->Get('nonexisting_dummy'),
    $Value,
    "Runtime config updated",
);

# Kernel::Config is loaded because it was loaded by $Kernel::OM above.
my $NewConfigObject = Kernel::Config->new();
$Self->Is(
    scalar $NewConfigObject->Get('nonexisting_dummy'),
    $Value,
    "System config updated",
);

# Check custom code injection.
my $RandomNumber   = $Helper->GetRandomNumber();
my $PackageName    = "Kernel::Config::Files::ZZZZUnitTest$RandomNumber";
my $SubroutineName = "Sub$RandomNumber";
my $SubroutinePath = "${PackageName}::$SubroutineName";
$Self->False(
    defined &$SubroutinePath,
    "Subroutine $SubroutinePath() is not defined yet",
);

my $CustomCode = <<"EOS";
package $PackageName;
use strict;
use warnings;
## nofilter(TidyAll::Plugin::OTOBO::Perl::TestSubs)
sub Load {} # no-op, avoid warning logs
sub $SubroutineName {
    return 'Hello, world!';
}
1;
EOS
$Helper->CustomCodeActivate(
    Code       => $CustomCode,
    Identifier => $RandomNumber,
);
$ConfigObject->SyncWithS3();

# Require custom code file.
my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require($PackageName);
$Self->True(
    $Loaded,
    "Require - $PackageName",
);

$Self->True(
    defined &$SubroutinePath,
    "Subroutine $SubroutinePath() is now defined",
);

$Helper->CustomFileCleanup();

# Kernel::Config is loaded because it was loaded by $Kernel::OM above.
$NewConfigObject = Kernel::Config->new();
$Self->Is(
    scalar $NewConfigObject->Get('nonexisting_dummy'),
    undef,
    "System config reset",
);

$Self->Is(
    scalar $ConfigObject->Get('nonexisting_dummy'),
    $Value,
    "Runtime config still has the changed value, it will be destroyed at the end of every test",
);

# Disable scheduling of asynchronous executor tasks.
$Helper->DisableAsyncCalls();

# Create a new task for the scheduler daemon using AsyncCall method.
my $Success = Kernel::System::AsynchronousExecutor->AsyncCall(
    ObjectName               => 'scripts::test::sample::AsynchronousExecutor::TestAsynchronousExecutor',
    FunctionName             => 'Execute',
    FunctionParams           => {},
    MaximumParallelInstances => 1,
);
$Self->True(
    $Success,
    'Created an asynchronous task'
);

my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

# Check if scheduled asynchronous task is present in DB.
my @TaskIDs;
my @AllTasks = $SchedulerDBObject->TaskList(
    Type => 'AsynchronousExecutor',
);

# Filter test tasks only!
for my $Task (@AllTasks) {
    if ( $Task->{Name} eq 'scripts::test::sample::AsynchronousExecutor::TestAsynchronousExecutor-Execute()' ) {
        push @TaskIDs, $Task->{TaskID};
    }
}

# Our asynchronous task should not be present.
$Self->False(
    scalar @TaskIDs,
    'Asynchronous task not scheduled'
);

# The sequence holds 26*26 entries, count almost to the end
{
    try_ok {
        for my $Counter ( 4 .. ( 26 * 26 - 3 ) ) {
            $Helper->GetSequentialTwoLetterString();
        }
        is( $Helper->GetSequentialTwoLetterString(), 'ZY', 'next to last value ZY of the sequence' );
        is( $Helper->GetSequentialTwoLetterString(), 'ZZ', 'last value ZZ of the sequence' );
    }
    'Counting to ZZ';

    my $Exception = dies { $Helper->GetSequentialTwoLetterString() };
    like( $Exception, qr/\QThe sequence can't proceed post 'ZZ'\E/, 'sequence dies after ZZ' );
}

done_testing();
