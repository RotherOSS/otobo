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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::GenericInterface::Debugger  ();
use Kernel::GenericInterface::Operation ();

our $Self;

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Provider',
);

# create a operation instance
my $OperationObject = Kernel::GenericInterface::Operation->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    Operation      => 'Test',
    OperationType  => 'Test::Test',
);
$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'OperationObject was correctly instantiated',
);

my @OperationTests = (
    {
        Data => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultData => {
            one   => 'one',
            two   => 'two',
            three => 'three',
            four  => 'four',
            five  => 'five',
        },
        ResultSuccess => 1,
    },
    {
        Data          => [],
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Data          => undef,
        ResultData    => undef,
        ResultSuccess => 1,
    },
    {
        Data          => {},
        ResultData    => {},
        ResultSuccess => 1,
    },
    {
        Data => {
            TestError => 123,
            ErrorData => {
                Value1 => 1,
                Value2 => 2,
                Value3 => 3,
            },
        },
        ResultData => {
            ErrorData => {
                Value1 => 1,
                Value2 => 2,
                Value3 => 3,
            },
        },
        ResultErrorMessage => 'Error message for error code: 123',
        ResultSuccess      => 0,
    },
);

my $Counter;
for my $Test (@OperationTests) {
    $Counter++;
    my $OperationResult = $OperationObject->Run(
        Data => $Test->{Data},
    );

    # check if function return correct status
    $Self->Is(
        $OperationResult->{Success},
        $Test->{ResultSuccess},
        'Test data set ' . $Counter . ' Test: Success.',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $OperationResult->{Data},
        $Test->{ResultData},
        'Test data set ' . $Counter . ' Test: Data Structure.',
    );

    if ( !$OperationResult->{Success} && $Test->{ResultErrorMessage} ) {
        $Self->Is(
            $OperationResult->{ErrorMessage},
            $Test->{ResultErrorMessage},
            'Test data set ' . $Counter . ' Test: Error Message.',
        );
    }
}

$Self->DoneTesting();
