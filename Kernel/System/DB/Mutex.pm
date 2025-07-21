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

package Kernel::System::DB::Mutex;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::DB::Mutex - distributed lock

=head1 DESCRIPTION

A distributed mutex lock on the DB using a unique index.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $MutexObject = $Kernel::OM->Get('Kernel::System::DB::Mutex');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {
        Interval  => 180,    # time in seconds until lock is considered stale
        LocksHeld => {},
    };
    bless( $Self, $Type );

    # get fqdn
    $Self->{Host}      = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');
    $Self->{ProcessID} = $$;

    return $Self;
}

=head2 WaitForMutex()

try to acquire the named lock with a timeout

    $Success = $MutexObject->WaitForMutex(
        Name      => 'unique_name_for_the_mutex',
        Timeout   => 3,                            # timeout in seconds
        UserID    => 1,                            # optional
        ProcessID => $$,                           # optional for testing, defaults to $$
    ):

    returns 1 if successful acquired, 0 otherwise

=cut

sub WaitForMutex {
    my ( $Self, %Param ) = @_;

    my $UserID    = $Param{UserID}  // 1;
    my $Timeout   = $Param{Timeout} // 2;
    my $Name      = $Param{Name};
    my $ProcessID = $Param{ProcessID} // $Self->{ProcessID};

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );

    my $Success = $DateTimeObject->ToTimeZone(
        TimeZone => 'UTC'
    );

    my $Now   = $DateTimeObject->ToEpoch();
    my $Until = $Now + $Timeout;

    while ( $Now <= $Until ) {

        my $Result = $Self->AcquireMutex(
            Name      => $Name,
            UserID    => $UserID,
            ProcessID => $ProcessID,
        );

        if ($Result) {
            return 1;
        }

        $Now = $DateTimeObject->ToEpoch();
        sleep(1);
    }

    return 0;
}

=head2 AcquireMutex()

try to acquire the named lock.

    $Success = $MutexObject->AcquireMutex(
        Name      => 'unique_name_for_the_mutex',
        UserID    => 1,                            # optional
        ProcessID => $$,                           # for testing, defaults to current process ($$)
    ):

    returns 1 if successful acquired, 0 otherwise

=cut

sub AcquireMutex {
    my ( $Self, %Param ) = @_;

    my $UserID    = $Param{UserID} // 1;
    my $Name      = $Param{Name};
    my $ProcessID = $Param{ProcessID} // $Self->{ProcessID};

    # check needed stuff
    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return;
    }

    $Self->CleanOrphans();

    return 1 if $Self->IsMutexHeld(
        Name      => $Name,
        ProcessID => $ProcessID
    );

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );

    my $Success = $DateTimeObject->ToTimeZone(
        TimeZone => 'UTC'
    );

    my $Now = $DateTimeObject->ToString();

    my $ProcessHost = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    my $Result = 0;
    eval {
        $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => '
                INSERT INTO named_mutex
                (mutex_name, process_id, process_host, create_time, create_by)
                VALUES (?, ?, ?, ?, ?)',
            Bind    => [ \$Name, \$ProcessID, \$ProcessHost, \$Now, \$UserID ],
            MayFail => 1,
        );
    };
    if ($@) {

        # $Result is 0
    }

    if ( !$Result ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Failed to acquire mutex $Name!",
        );

        delete $Self->{LocksHeld}->{$Name};
    }
    else {
        $Self->{LocksHeld}->{$Name} = $DateTimeObject->ToEpoch();
    }

    return $Result ? 1 : 0;
}

=head2 ReleaseMutex()

release the named lock after use.

    $Success = $MutexObject->ReleaseMutex(
        Name   => 'unique_name_for_the_mutex',
    ):

    returns 1 if successful released, 0 otherwise

=cut

sub ReleaseMutex {
    my ( $Self, %Param ) = @_;

    my $Name = $Param{Name};

    # check needed stuff
    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return;
    }

    my $ProcessID   = $Param{ProcessID} // $Self->{ProcessID};
    my $ProcessHost = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    $Self->CleanOrphans();

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM named_mutex WHERE mutex_name = ? AND process_id = ? and process_host = ? ',
        Bind => [ \$Name, \$ProcessID, \$ProcessHost ],
    );

    delete $Self->{LocksHeld}->{$Name};

    return $Result ? 1 : 0;
}

=head2 IsMutexLocked()

Check if a lock is currently locked by someone.

    $MutexObject->IsMutexLocked(
        Name   => 'unique_name_for_the_mutex',
    );

=cut

sub IsMutexLocked {
    my ( $Self, %Param ) = @_;

    my $Name = $Param{Name};

    # check needed stuff
    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return 0;
    }

    $Self->CleanOrphans();

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL  => 'Select id FROM named_mutex WHERE mutex_name = ? ',
        Bind => [ \$Name ],
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {

        return 1;
    }

    return 0;
}

=head2 IsMutexHeld()

Check if a lock is currently held by this process/request.

    $Success = $MutexObject->IsMutexHeld(
        Name   => 'unique_name_for_the_mutex',
    );

    # returns 0|1

=cut

sub IsMutexHeld {
    my ( $Self, %Param ) = @_;

    my $Name      = $Param{Name};
    my $ProcessID = $Param{ProcessID} // $Self->{ProcessID};

    # check needed stuff
    if ( !$Name ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name'
        );
        return 0;
    }

    $Self->CleanOrphans();

    my $ProcessHost = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL  => 'Select id FROM named_mutex WHERE mutex_name = ? AND process_id = ? AND process_host = ? ',
        Bind => [ \$Name, \$ProcessID, \$ProcessHost ],
    );

    if ( my @Row = $DBObject->FetchrowArray() ) {

        return 1;
    }

    delete $Self->{LocksHeld}->{$Name};

    return 0;
}

=head2 CleanOrphans()

Delete stale locks.

    $MutexObject->CleanOrphans(
        Interval => 180,        # optional, max age for locks in seconds
    );

=cut

sub CleanOrphans {
    my ( $Self, %Param ) = @_;

    my $Interval = $Param{Interval} // $Self->{Interval} // 180;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
    );

    my $Success = $DateTimeObject->ToTimeZone(
        TimeZone => 'UTC'
    );

    my $Before = $DateTimeObject->ToEpoch() - $Interval;

    $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => $Before,
        }
    );

    my $Time = $DateTimeObject->ToString();

    # sql
    my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM named_mutex WHERE create_time < ? ',
        Bind => [ \$Time ],
    );

    for my $Lock ( keys $Self->{LocksHeld}->%* ) {
        if ( $Self->{LocksHeld}->{$Lock} < $Before ) {
            delete $Self->{LocksHeld}->{$Lock};
        }
    }

    return 1;
}

=head2 GetMutexList()

Dump a list of Mutexes (mainly for testing).

    $MutexList = $MutexObject->GetMutexList();

    # returns List of Mutexes in DB

=cut

sub GetMutexList {
    my ( $Self, %Param ) = @_;

    $Self->CleanOrphans();

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # sql
    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL => 'SELECT id, mutex_name,process_id,process_host,create_time,create_by
                FROM named_mutex ',
        Bind => [],
    );

    my @Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        push @Result, {
            ID          => $Row[0],
            Name        => $Row[1],
            ProcessID   => $Row[2],
            ProcessHost => $Row[3],
            Created     => $Row[4],
            CreatedBy   => $Row[5],
        };
    }

    return \@Result;
}

sub DESTROY {
    my $Self = shift;

    my $ProcessID   = $Self->{ProcessID};
    my $ProcessHost = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    $Self->CleanOrphans();

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Lock ( keys $Self->{LocksHeld}->%* ) {

        # sql
        my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => 'DELETE FROM named_mutex WHERE mutex_name = ? AND process_id = ? and process_host = ? ',
            Bind => [ \$Lock, \$ProcessID, \$ProcessHost ],
        );
    }

    return;
}

1;
