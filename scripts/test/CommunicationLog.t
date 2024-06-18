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
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::VariableCheck qw(:all);

our $Self;

# get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

    FixedTimeSet();

    #
    # CommunicationLog object create
    #
    # Create an object, representing a new communication:
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => $Test->{Create}->{Transport},
            Direction => $Test->{Create}->{Direction},
        }
    );

    $Self->Is(
        ref $CommunicationLogObject,
        'Kernel::System::CommunicationLog',
        "$Test->{Name} - Object create - New communication object.",
    );

    my $GeneratedCommunicationID = $CommunicationLogObject->CommunicationIDGet();

    $Self->True(
        $GeneratedCommunicationID,
        "$Test->{Name} - Object create - Generated CommunicationID.",
    );

    my $Transport = $CommunicationLogObject->TransportGet();

    $Self->True(
        $Transport,
        "$Test->{Name} - Object create - Receive transport.",
    );

    $Self->Is(
        $Transport,
        $Test->{Create}->{Transport},
        "$Test->{Name} - Object create - Created and received transports equal.",
    );

    my $Direction = $CommunicationLogObject->DirectionGet();

    $Self->True(
        $Direction,
        "$Test->{Name} - Object create - Receive direction.",
    );

    $Self->Is(
        $Direction,
        $Test->{Create}->{Direction},
        "$Test->{Name} - Object create - Created and received directions equal.",
    );

    my $Status = $CommunicationLogObject->StatusGet();
    $Self->Is(
        $Status,
        $Test->{Start}->{Status},
        "$Test->{Name} - Object create - Created and received status equal.",
    );

    #
    # CommunicationLog recreate object
    #
    $CommunicationLogObject = undef;
    $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            CommunicationID => $GeneratedCommunicationID,
        },
    );

    $Self->Is(
        ref $CommunicationLogObject,
        'Kernel::System::CommunicationLog',
        "$Test->{Name} - Object recreate - Recreate communication object.",
    );

    my $RecreatedCommunicationID = $CommunicationLogObject->CommunicationIDGet();

    $Self->True(
        $RecreatedCommunicationID,
        "$Test->{Name} - Object recreate - Recreated CommunicationID.",
    );

    $Self->Is(
        $RecreatedCommunicationID,
        $GeneratedCommunicationID,
        "$Test->{Name} - Object recreate - Generated and recreated CommunicationIDs equal.",
    );

    $Transport = $CommunicationLogObject->TransportGet();

    $Self->True(
        $Transport,
        "$Test->{Name} - Object recreate - Receive transport.",
    );

    $Self->Is(
        $Transport,
        $Test->{Create}->{Transport},
        "$Test->{Name} - Object recreate - Created and received transports equal.",
    );

    $Direction = $CommunicationLogObject->DirectionGet();

    $Self->True(
        $Direction,
        "$Test->{Name} - Object recreate - Receive direction.",
    );

    $Self->Is(
        $Direction,
        $Test->{Create}->{Direction},
        "$Test->{Name} - Object recreate - Created and received directions equal.",
    );

    $Status = $CommunicationLogObject->StatusGet();

    $Self->Is(
        $Status,
        $Test->{Start}->{Status},
        "$Test->{Name} - Object recreate - Receive status.",
    );

    #
    # Communication stop
    #
    my $Success = $CommunicationLogObject->CommunicationStop(
        Status => $Test->{Stop}->{Status},
    );

    if ( $Test->{Stop}->{Result} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - Communication stop - stop result should be true.",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} - Communication stop - stop result should be false.",
        );
    }

    $Status = $CommunicationLogObject->StatusGet();

    $Self->Is(
        $Status,
        $Test->{ExpectedResult}->{Status},
        "$Test->{Name} - Communication stop - Status.",
    );

    #
    # CommunicationLog recreate closed object
    #
    $CommunicationLogObject = undef;
    $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            CommunicationID => $GeneratedCommunicationID,
        },
    );

    $Self->False(
        $CommunicationLogObject,
        "$Test->{Name} - Object already closed couldn't be recreated.",
    );
}

$Self->DoneTesting();
