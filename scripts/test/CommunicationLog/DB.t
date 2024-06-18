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

use Kernel::System::UnitTest::MockTime qw(:all);

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM
use Kernel::System::VariableCheck qw(:all);

our $Self;

sub TestObjectLogDelete {
    my %Param = @_;

    my $CommunicationLogDBObj  = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );

    my $Result;

    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key',
        Value         => 'Value',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $Result = $CommunicationLogDBObj->ObjectLogDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
        ObjectLogStatus => 'Successful'
    );

    $Self->True( $Result, "Communication Log Delete by Status." );

    $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key1',
        Value         => 'Value1',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key2',
        Value         => 'Value2',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $Result = $CommunicationLogDBObj->ObjectLogDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );

    $Self->True( $Result, "Communication Log Delete by CommunicationID" );

    return;
}

sub TestObjectLogGet {
    my %Param = @_;

    my $GetRandomPriority = sub {
        my $Idx        = int( rand(4) );                      ## no critic qw(OTOBO::ProhibitRandInTests)
        my @Priorities = qw( Error Warn Info Debug Trace );
        return $Priorities[$Idx];
    };

    my $CommunicationLogDBObj  = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    # Insert some logs
    my %Counters = (
        Total    => 0,
        Priority => {},
    );
    for my $Idx ( 0 .. 9 ) {
        my $Priority = $GetRandomPriority->();
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Key           => 'Key-' . $Idx,
            Value         => 'Value for Key-' . $Idx,
            Priority      => $Priority,
        );

        $Counters{Total} += 1;

        my $PriorityCounter = $Counters{Priority}->{$Priority} || 0;
        $Counters{Priority}->{$Priority} = $PriorityCounter + 1;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    my $Result;

    $Result = $CommunicationLogDBObj->ObjectLogGet(
        ObjectLogID => $ObjectID,
    );
    $Self->True(
        ( $Result && scalar %{$Result} ),
        "Get communication logging for ObjectLogID '$ObjectID'",
    );

    return;
}

sub TestObjectLogEntryList {
    my %Param = @_;

    my $GetRandomPriority = sub {
        my $Idx        = int( rand(4) );                      ## no critic qw(OTOBO::ProhibitRandInTests)
        my @Priorities = qw( Error Warn Info Debug Trace );
        return $Priorities[$Idx];
    };

    my $CommunicationLogDBObj  = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    # Insert some logs
    my %Counters = (
        Total    => 0,
        Priority => {},
    );
    for my $Idx ( 0 .. 9 ) {
        my $Priority = $GetRandomPriority->();
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Key           => 'Key-' . $Idx,
            Value         => 'Value for Key-' . $Idx,
            Priority      => $Priority,
        );

        $Counters{Total} += 1;

        my $PriorityCounter = $Counters{Priority}->{$Priority} || 0;
        $Counters{Priority}->{$Priority} = $PriorityCounter + 1;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    my $Result;

    # Tes:t get all the data.
    $Result = $CommunicationLogDBObj->ObjectLogEntryList(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );
    $Self->True(
        $Result && scalar @{$Result} == $Counters{Total},
        'List communication logging.',
    );

    # Test: get all $Priority.
    {
        my $Priority = $GetRandomPriority->();
        $Result = $CommunicationLogDBObj->ObjectLogEntryList(
            CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
            LogPriority     => $Priority,
        );
        $Self->True(
            $Result && scalar @{$Result} == ( $Counters{Priority}->{$Priority} || 0 ),
            qq{List communication logging with priority '${ Priority }'},
        );
    }

    # Test: get all for message object type
    $Result = $CommunicationLogDBObj->ObjectLogEntryList(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
        ObjectLogType   => 'Message',
    );
    $Self->True(
        $Result && scalar @{$Result} == 0,
        'List communication logging for object type "Message"',
    );

    # Test: get all for Connection and Key
    $Result = $CommunicationLogDBObj->ObjectLogEntryList(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
        ObjectLogType   => 'Connection',
        LogKey          => 'Key-0',
    );
    $Self->True(
        $Result && scalar @{$Result} == 1,
        'List communication logging for object type "Connection" and key "Key-0"',
    );

    # Delete the communication.
    $Result = $CommunicationLogDBObj->CommunicationDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );
    $Self->True(
        $Result,
        sprintf(
            "Communication '%s' deleted",
            $CommunicationLogObject->CommunicationIDGet(),
        ),
    );

    return;
}

my @Test = (
    {
        Name   => 'Test1',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test2',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test3',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Failed',
        },
    },
    {
        Name   => 'Test4',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Failed',
        },
    },
    {
        Name   => 'Test5',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test6',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test7',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Failed',
        },
    },
    {
        Name   => 'Test8',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Failed',
        },
    },
);

for my $Test (@Test) {

    subtest "CommunicationLog $Test->{Name}" => sub {

        FixedTimeSet();

        # Create an object, representing a new communication:
        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => $Test->{Create}->{Transport},
                Direction => $Test->{Create}->{Direction},
            },
        );

        my $GeneratedCommunicationID = $CommunicationLogObject->CommunicationIDGet();
        my $CommunicationDBObject    = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
        my $CommunicationData        = $CommunicationDBObject->CommunicationGet();
        my $Existing                 = IsHashRefWithData($CommunicationData);
        $Self->False(
            $Existing,
            "Object create - Communication Get (without CommunicationID).",
        );

        $CommunicationData = $CommunicationDBObject->CommunicationGet(
            CommunicationID => $GeneratedCommunicationID,
        );
        $Existing = IsHashRefWithData($CommunicationData);
        $Self->True(
            $Existing,
            "Object create - Communication Get (given CommunicationID).",
        );

        $Self->Is(
            $CommunicationData->{CommunicationID},
            $GeneratedCommunicationID,
            "Communication start - Generated and stored CommunicationIDs equal.",
        );
        $Self->Is(
            $CommunicationData->{Transport},
            $Test->{Create}->{Transport},
            "Communication start - Created and stored transports equal.",
        );
        $Self->Is(
            $CommunicationData->{Direction},
            $Test->{Create}->{Direction},
            "Communication start - Created and stored directions equal.",
        );
        $Self->Is(
            $CommunicationData->{Status},
            $Test->{Start}->{Status},
            "Communication start - Created and stored status equal.",
        );

        # Communication list
        my $CommunicationList = $CommunicationDBObject->CommunicationList(
            Transport => $Test->{Create}->{Transport},
            Direction => $Test->{Create}->{Direction},
            Status    => $Test->{Start}->{Status},
        );

        $Existing = IsArrayRefWithData($CommunicationList);

        $Self->True(
            $Existing,
            "Communication list - Communication list result.",
        );

        $Self->Is(
            $CommunicationList->[0]->{CommunicationID},
            $GeneratedCommunicationID,
            "Communication list - CommunicationID.",
        );

        $Self->Is(
            $CommunicationList->[0]->{Transport},
            $Test->{Create}->{Transport},
            "Communication list - Transport.",
        );

        $Self->Is(
            $CommunicationList->[0]->{Direction},
            $Test->{Create}->{Direction},
            "Communication list - Direction.",
        );

        $Self->Is(
            $CommunicationList->[0]->{Status},
            $Test->{Start}->{Status},
            "Communication list - Status.",
        );

        $Self->True(
            $CommunicationList->[0]->{StartTime},
            "Communication list - StartTime.",
        );

        $Self->False(
            $CommunicationList->[0]->{EndTime},
            "Communication list - EndTime.",
        );

        $Self->False(
            $CommunicationList->[0]->{Duration},
            "Communication list - Duration.",
        );

        FixedTimeAddSeconds(1);

        #
        # Communication Stop
        #

        my $Success = $CommunicationLogObject->CommunicationStop(
            Status => $Test->{Stop}->{Status},
        );

        my $CommunicationListAfterStop = $CommunicationDBObject->CommunicationList(
            Transport => $Test->{Create}->{Transport},
            Direction => $Test->{Create}->{Direction},
            Status    => $Test->{Stop}->{Status},
        );

        $Existing = IsArrayRefWithData($CommunicationListAfterStop);

        $Self->True(
            $Existing,
            "Communication stop - Communication list result.",
        );

        $Self->Is(
            $CommunicationListAfterStop->[0]->{CommunicationID},
            $GeneratedCommunicationID,
            "Communication stop - CommunicationID.",
        );

        $Self->Is(
            $CommunicationListAfterStop->[0]->{Transport},
            $Test->{ExpectedResult}->{Transport},
            "Communication stop - Transport.",
        );

        $Self->Is(
            $CommunicationListAfterStop->[0]->{Direction},
            $Test->{ExpectedResult}->{Direction},
            "Communication stop - Direction.",
        );

        $Self->Is(
            $CommunicationListAfterStop->[0]->{Status},
            $Test->{ExpectedResult}->{Status},
            "Communication stop - Status.",
        );

        $Self->True(
            $CommunicationListAfterStop->[0]->{StartTime},
            "Communication stop - StartTime.",
        );

        $Self->True(
            $CommunicationListAfterStop->[0]->{EndTime},
            "Communication stop - EndTime.",
        );

        $Self->True(
            $CommunicationListAfterStop->[0]->{Duration},    # 1 second
            "Communication stop - Duration.",
        );

        # Communication delete

        my $Result = $CommunicationDBObject->CommunicationDelete(
            CommunicationID => $GeneratedCommunicationID,
        );

        $Self->True(
            $Result,
            "Communication delete. - Given CommunicationID.",
        );

        $CommunicationData = $CommunicationDBObject->CommunicationGet(
            CommunicationID => $GeneratedCommunicationID,
        );

        $Existing = IsHashRefWithData($CommunicationData);

        $Self->False(
            $Existing,
            "Communication delete - Communication existing after delete (given CommunicationID).",
        );
    };
}

subtest 'LogDelete'    => \&TestObjectLogDelete;
subtest 'LogGet'       => \&TestObjectLogGet;
subtest 'LogEntryList' => \&TestObjectLogEntryList;

done_testing();
