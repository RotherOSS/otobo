# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Invoker;

# create a Debugger instance
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => 1,
    CommunicationType => 'Requester',
);

my $InvokerObject;

# provide no objects
$InvokerObject = Kernel::GenericInterface::Invoker->new();
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, no arguments',
);

# correct call (without invoker info)
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => 1,
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, no InvokerType',
);

# correct call (without invoker type info)
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    Invoker        => 'Test',
    WebserviceID   => 1,
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, no InvokerType',
);

# provide incorrect invoker
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    Invoker        => 'Test',
    InvokerType    => 'ItShouldNotBeUsed::ItShouldNotBeUsed',
    WebserviceID   => 1,
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, wrong InvokerType',
);

# provide no WebserviceID
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    Invoker        => 'Test',
    InvokerType    => 'Test::Test',
);
$Self->IsNot(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'Invoker::new() constructor failure, wrong InvokerType',
);

# correct call
$InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    Invoker        => 'Test',
    InvokerType    => 'Test::Test',
    WebserviceID   => 1,
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'InvokerObject was correctly instantiated',
);

# PrepareRequest without data
my $ReturnData = $InvokerObject->PrepareRequest();
$Self->Is(
    ref $ReturnData,
    'HASH',
    'PrepareRequest call without arguments',
);
$Self->False(
    $ReturnData->{Success},
    'PrepareRequest call without arguments success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'PrepareRequest call without arguments error message',
);

# PrepareRequest with empty data
$ReturnData = $InvokerObject->PrepareRequest(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'PrepareRequest call empty data',
);
$Self->False(
    $ReturnData->{Success},
    'PrepareRequest call empty data success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'PrepareRequest call empty data error message',
);

# PrepareRequest with some data
$ReturnData = $InvokerObject->PrepareRequest(
    Data => {
        TicketNumber => '1',
    },
);
$Self->True(
    $ReturnData->{Success},
    'PrepareRequest call data provided',
);

# HandleResponse without data
$ReturnData = $InvokerObject->HandleResponse();
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse without arguments',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse call without arguments success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call without arguments error message',
);

# HandleResponse with empty data
$ReturnData = $InvokerObject->HandleResponse(
    Data => {},
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse empty data',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse call empty data success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call empty data error message',
);

# HandleResponse with some data
$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess => '0',
    Data            => {
        TicketNumber => '1345',
    },
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse response failure without error message',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse response failure without error message success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call response failure without error message error message',
);

$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess      => '0',
    ResponseErrorMessage => 'Just an error message.',
    Data                 => {
        TicketNumber => '123',
    },
);
$Self->Is(
    ref $ReturnData,
    'HASH',
    'HandleResponse response failure ',
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse response failure success',
);
$Self->True(
    $ReturnData->{ErrorMessage},
    'HandleResponse call response failure error message',
);

# HandleResponse with some data (Success)
$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess => '1',
    Data            => {
        TicketNumber => '234',
    },
);
$Self->True(
    $ReturnData->{Success},
    'HandleResponse call with response success',
);

# HandleResponse with array as response.
$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess => '0',
    Data            => ( '1', '2', '3' ),
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse response failure success (array as response)',
);
$Self->Is(
    $ReturnData->{ErrorMessage},
    'Got Data but it is not a hash or array ref in Invoker handler (HandleResponse)!',
    'HandleResponse call response failure error message (array as response)',
);

# HandleResponse with array ref as response.
$ReturnData = $InvokerObject->HandleResponse(
    ResponseSuccess      => '0',
    ResponseErrorMessage => 'Just an error message',
    Data                 => [ '1', '2', '3' ],
);
$Self->False(
    $ReturnData->{Success},
    'HandleResponse response failure success (array ref as response)',
);
$Self->Is(
    $ReturnData->{ErrorMessage},
    'Just an error message',
    'HandleResponse call response failure error message (array ref as response)',
);

$Self->DoneTesting();
