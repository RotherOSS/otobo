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

# create object with false options
my $OperationObject;

# provide no objects
$OperationObject = Kernel::GenericInterface::Operation->new();
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, no arguments',
);

# provide empty operation
$OperationObject = Kernel::GenericInterface::Operation->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    OperationType  => {},
);
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, no OperationType',
);

# provide incorrect operation
$OperationObject = Kernel::GenericInterface::Operation->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    OperationType  => 'Test::ThisIsCertainlyNotBeingUsed',
);
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, wrong OperationType',
);

# provide no WebserviceID
$OperationObject = Kernel::GenericInterface::Operation->new(
    DebuggerObject => $DebuggerObject,
    OperationType  => 'Test::Test',
);
$Self->IsNot(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() fail check, no WebserviceID',
);

# create object
$OperationObject = Kernel::GenericInterface::Operation->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
    Operation      => 'Test',
    OperationType  => 'Test::Test',
);
$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation',
    'Operation::new() success',
);

# run without data
my $ReturnData = $OperationObject->Run();
$Self->Is(
    ref $ReturnData,
    'HASH',
    'OperationObject call response',
);
$Self->True(
    $ReturnData->{Success},
    'OperationObject call no data provided',
);

# run with empty data
$ReturnData = $OperationObject->Run(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'OperationObject call response',
);
$Self->True(
    $ReturnData->{Success},
    'OperationObject call empty data provided',
);

# run with invalid data
$ReturnData = $OperationObject->Run(
    Data => [],
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'OperationObject call response',
);
$Self->False(
    $ReturnData->{Success},
    'OperationObject call invalid data provided',
);

# run with some data
$ReturnData = $OperationObject->Run(
    Data => {
        'from' => 'to',
    },
);
$Self->True(
    $ReturnData->{Success},
    'OperationObject call data provided',
);

$Self->DoneTesting();
