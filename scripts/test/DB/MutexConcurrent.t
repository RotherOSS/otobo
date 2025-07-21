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

use Kernel::System::ObjectManager;

my $MutexName = "unique_lock_name_PID_module_TID";

my $ChildPID = fork();

if ( !$ChildPID ) {

    # I Am the fork - I return 0 if all expectations have been met, or 1 otherwise

    # make sure we do not share the OM
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    # give the parent time to acquire the lock
    sleep 1;
    my $ExitCode = 1;

    my $MutexObject = $Kernel::OM->Get('Kernel::System::DB::Mutex');

    # assert the lock is taken
    my $IsMutexLocked1 = $MutexObject->IsMutexLocked( Name => $MutexName );
    exit $ExitCode unless $IsMutexLocked1;

    # but lock is not owned by this process
    my $IsMutexHeld1 = $MutexObject->IsMutexHeld( Name => $MutexName );
    exit $ExitCode if $IsMutexHeld1;

    # wait for the parent to release the lock
    my $GotLock1 = $MutexObject->WaitForMutex(
        Name    => $MutexName,
        Timeout => 5
    );
    exit $ExitCode unless $GotLock1;

    # hold on the lock for a while
    sleep 2;

    # destroys the OM and all the locks held implicitly
    exit 0;
}

eval {

    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $MutexObject = $Kernel::OM->Get('Kernel::System::DB::Mutex');

    # acquire the lock while the child sleeps
    my $GotLock1 = $MutexObject->AcquireMutex( Name => $MutexName );
    ok( $GotLock1, 'acquired the mutex' );

    # hold the lock for a while
    sleep 2;

    # release the lock
    my $ReleasedLock1 = $MutexObject->ReleaseMutex( Name => $MutexName );
    ok( $ReleasedLock1, 'released the mutex' );

    # give the child some time to acquire the lock
    sleep 1;

    # check the lock is now taken again
    my $IsMutexLocked1 = $MutexObject->IsMutexLocked( Name => $MutexName );
    ok( $IsMutexLocked1, 'mutex is taken' );

    # but the lock is held by the child, not by the parent
    my $GotLock2 = $MutexObject->AcquireMutex( Name => $MutexName );
    ok( !$GotLock2, 'cannot acquire mutex held by child' );

    # wait until the child has released the lock
    my $GotLock3 = $MutexObject->WaitForMutex(
        Name    => $MutexName,
        Timeout => 5
    );
    ok( $GotLock3, 'successfully waited for mutex after released by child using' );

    # doublecheck the mutex is locked
    my $IsMutexLocked2 = $MutexObject->IsMutexLocked( Name => $MutexName );
    ok( $IsMutexLocked2, 'mutex is taken' );

    # doublecheck the mutex is owned by us
    my $IsMutexHeld1 = $MutexObject->IsMutexHeld( Name => $MutexName );
    ok( $IsMutexHeld1, 'mutex is held by parent' );
};

if ($@) {
    print STDERR "$@\n";
    ok( 0, "should not throw." );
}

# wait for the child to exit
waitpid( $ChildPID, 0 );

# get the child exit code
my $ChildExitCode = $? >> 8;
ok( $ChildExitCode == 0, "all child expectations have been met." );

done_testing;
