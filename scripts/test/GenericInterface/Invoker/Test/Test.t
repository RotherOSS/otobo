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

# create an Invoker instance
my $InvokerObject = Kernel::GenericInterface::Invoker->new(
    DebuggerObject => $DebuggerObject,
    Invoker        => 1,
    InvokerType    => 'Test::Test',
    WebserviceID   => 1,
);
$Self->Is(
    ref $InvokerObject,
    'Kernel::GenericInterface::Invoker',
    'InvokerObject was correctly instantiated',
);

# PrepareRequest Tests
my @InvokerPrepareRequestTests = (

    {
        Name          => 'Test no data',
        Data          => undef,
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name          => 'Test empty data',
        Data          => {},
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test wrong data',
        Data => {
            ASoWrongParameter => 'JustAValue',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test TicketNumber parameter empty value',
        Data => {
            TicketNumber => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test Action parameter empty value',
        Data => {
            Action => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test Action parameter without TicketNumber',
        Data => {
            Action => 'Add',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test correct call just TicketNumber',
        Data => {
            TicketNumber => '12345',
        },
        ResultData => {
            TicketNumber => '12345',
        },
        ResultSuccess => 1,
    },
    {
        Name => 'Test correct call TicketNumber and Action',
        Data => {
            TicketNumber => '12345',
            Action       => 'Add',
        },
        ResultData => {
            TicketNumber => '12345',
            Action       => 'AddTest',
        },
        ResultSuccess => 1,
    },

);

for my $Test (@InvokerPrepareRequestTests) {
    my $InvokerResult = $InvokerObject->PrepareRequest(
        Data => $Test->{Data},
    );

    # check if function return correct status
    $Self->Is(
        $InvokerResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $InvokerResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->False(
            $InvokerResult->{Success},
            $Test->{Name} . ' (Error Message: ' .
                $InvokerResult->{ErrorMessage} . ')',
        );
    }
    else {
        $Self->Is(
            ref $InvokerObject,
            'Kernel::GenericInterface::Invoker',
            $Test->{Name} . ' (Not Error Message).',
        );
    }
}

# HandleResponse Tests
my @InvokerHandleResponseTests = (

    {
        Name          => 'Test no data',
        Data          => undef,
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name          => 'Test empty data',
        Data          => {},
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test wrong data',
        Data => {
            ASoWrongParameter => 'JustAValue',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test TicketNumber parameter empty value',
        Data => {
            TicketNumber => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test TicketNumber parameter wrong value',
        Data => {
            TicketNumber => 'asdf0987opiu',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test Action parameter empty value',
        Data => {
            Action => '',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test Action parameter without TicketNumber',
        Data => {
            Action => 'Add',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test correct call just TicketNumber',
        Data => {
            TicketNumber => '12345',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test correct call without ResponseSuccess',
        Data => {
            TicketNumber => '12345',
            Action       => 'AddTest',
        },
        ResultData    => undef,
        ResultSuccess => 0,
    },
    {
        Name => 'Test just ResponseSucces param.',
        Data => {
            TicketNumber => '',
        },
        ResponseSuccess => '1',
        ResultData      => undef,
        ResultSuccess   => 0,
    },
    {
        Name => 'Test just ResponseErrorMessage param.',
        Data => {
            TicketNumber => '12345',
        },
        ResponseErrorMessage => 'Just an error message.',
        ResultData           => undef,
        ResultSuccess        => 0,
    },
    {
        Name => 'Test just correct params from Response',
        Data => {
            TicketNumber => '',
        },
        ResponseSuccess      => '1',
        ResponseErrorMessage => 'Just an error message.',
        ResultData           => undef,
        ResultSuccess        => 0,
    },
    {
        Name => 'Test correct call without Action',
        Data => {
            TicketNumber => '12345',
        },
        ResponseSuccess      => '1',
        ResponseErrorMessage => 'Just an error message.',
        ResultData           => {
            TicketNumber => '12345',
        },
        ResultSuccess => 1,
    },
    {
        Name => 'Test correct call with all params',
        Data => {
            TicketNumber => '12345',
            Action       => 'AddTest',
        },
        ResponseSuccess      => '1',
        ResponseErrorMessage => 'Just an error message.',
        ResultData           => {
            TicketNumber => '12345',
            Action       => 'Add',
        },
        ResultSuccess => 1,
    },

);

for my $Test (@InvokerHandleResponseTests) {
    my %InvokerParams = {};
    $InvokerParams{Data}                 = $Test->{Data}                 || undef;
    $InvokerParams{ResponseSuccess}      = $Test->{ResponseSuccess}      || undef;
    $InvokerParams{ResponseErrorMessage} = $Test->{ResponseErrorMessage} || undef;
    my $InvokerResult = $InvokerObject->HandleResponse(
        %InvokerParams,
    );

    # check if function return correct status
    $Self->Is(
        $InvokerResult->{Success},
        $Test->{ResultSuccess},
        $Test->{Name} . ' (Success).',
    );

    # check if function return correct data
    $Self->IsDeeply(
        $InvokerResult->{Data},
        $Test->{ResultData},
        $Test->{Name} . ' (Data Structure).',
    );

    if ( !$Test->{ResultSuccess} ) {
        $Self->True(
            $InvokerResult->{ErrorMessage},
            $Test->{Name} . ' error message',
        );
    }
}

# complete cycle

# PrepareRequest call
my $InvokerResult = $InvokerObject->PrepareRequest(
    Data => {
        TicketNumber => '12345',
        Action       => 'Add',
    },
);

# check invoker call success
$Self->True(
    $InvokerResult->{Success},
    '(Complete Cycle) Check PrepareRequest call success.',
);

# returned data should match with expected data
$Self->IsDeeply(
    \%{$InvokerResult},
    {
        'Data' => {
            'Action'       => 'AddTest',
            'TicketNumber' => '12345'
        },
        'Success' => 1
    },
    'Returned data should match with expected data.',
);

# HandleResponse call
$InvokerResult = $InvokerObject->HandleResponse(
    Data => {
        Action       => $InvokerResult->{Data}->{Action},
        TicketNumber => $InvokerResult->{Data}->{TicketNumber},
    },
    ResponseSuccess      => $InvokerResult->{Success},
    ResponseErrorMessage => $InvokerResult->{ErrorMessage},
);

# check HandleResponse call success
$Self->True(
    $InvokerResult->{Success},
    '(Complete Cycle) Check HandleResponse call success.',
);

# HandleResponse data should match the initial data
$Self->IsDeeply(
    \%{$InvokerResult},
    {
        'Data' => {
            'Action'       => 'Add',
            'TicketNumber' => '12345'
        },
        'Success' => 1
    },
    'Returned data should match with expected data.',
);

$Self->DoneTesting();
