# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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
use Kernel::System::UnitTest::RegisterDriver;

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

our $Self;

my $MutexName = "unique_lock_name_PID_module_TID";

my $MutexObject = $Kernel::OM->Get('Kernel::System::DB::Mutex');
$MutexObject->{Interval} = 1;    # lower time until stale for testing

my $GotLock1 = $MutexObject->AcquireMutex( Name => $MutexName );
ok( $GotLock1, 'acquired the mutex' );

my $GotLock2 = $MutexObject->AcquireMutex( Name => $MutexName );
ok( $GotLock2, 'acquire lock is re-entrant' );

my $ReleasedLock1 = $MutexObject->ReleaseMutex( Name => $MutexName );
ok( $ReleasedLock1, 'released the mutex' );

my $IsMutexLocked1 = $MutexObject->IsMutexLocked( Name => $MutexName );
ok( !$IsMutexLocked1, 'mutex is taken' );

my $GotLock3 = $MutexObject->AcquireMutex( Name => $MutexName );
ok( $GotLock3, 'acquired the mutex after release' );

my $IsMutexLocked2 = $MutexObject->IsMutexLocked( Name => $MutexName );
ok( $IsMutexLocked2, 'mutex is taken' );

# simulate stale lock
sleep(2);

my $IsMutexLocked3 = $MutexObject->IsMutexLocked( Name => $MutexName );
ok( !$IsMutexLocked3, 'mutex is no longer taken' );

# simulate conflict

my $GotLock4 = $MutexObject->AcquireMutex( Name => $MutexName );
ok( $GotLock4, 'acquired the mutex' );

{
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $MutexObject = $Kernel::OM->Get('Kernel::System::DB::Mutex');
    $MutexObject->{Interval}  = 1;         # lower time until stale for testing
    $MutexObject->{ProcessID} = $$ + 1;    # pretend we are a different PID

    my $GotLock5 = $MutexObject->AcquireMutex( Name => $MutexName );
    ok( !$GotLock5, 'mutex already locked' );

    # simulate stale lock
    sleep(2);

    my $GotLock6 = $MutexObject->AcquireMutex( Name => $MutexName );
    ok( $GotLock6, 'mutex available after orphaned' );

    # local OM goes out of scope and will DESTROY any locks held
    # by the MutexObject implicitly
}

my $IsMutexLocked4 = $MutexObject->IsMutexLocked( Name => $MutexName );
ok( !$IsMutexLocked4, 'mutex is not taken' );

# test WaitForMutex

my $GotLock7 = $MutexObject->AcquireMutex( Name => $MutexName );
ok( $GotLock7, 'acquired the mutex' );

my $IsMutexLocked5 = $MutexObject->IsMutexLocked( Name => $MutexName );
ok( $IsMutexLocked5, 'mutex is taken' );

{
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $MutexObject = $Kernel::OM->Get('Kernel::System::DB::Mutex');
    $MutexObject->{Interval}  = 1;         # lower time until stale for testing
    $MutexObject->{ProcessID} = $$ + 1;    # pretend we are a different PID

    my $GotLock8 = $MutexObject->WaitForMutex(
        Name    => $MutexName,
        Timeout => 2
    );
    ok( $GotLock8, 'waited for mutex' );

    # local OM goes out of scope and will DESTROY any locks held
    # by the MutexObject implicitly
}

my $IsMutexLocked6 = $MutexObject->IsMutexLocked( Name => $MutexName );
ok( !$IsMutexLocked6, 'mutex is not held' );

$Self->DoneTesting();
