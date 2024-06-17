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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Session::SessionCreate;

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify   => 1,
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# set user details
my ( $UserLogin, $UserID ) = $Helper->TestUserCreate();
my $UserPassword = $UserLogin;

# create web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

$Self->Is(
    'Kernel::System::GenericInterface::Webservice',
    ref $WebserviceObject,
    "Create web service object",
);

# set web service name
my $WebserviceName = '-Test-' . $RandomID;

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebserviceName,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => $UserID,
);
$Self->True(
    $WebserviceID,
    "Added web service",
);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
$Self->Is(
    ref $DebuggerObject,
    'Kernel::GenericInterface::Debugger',
    'DebuggerObject instantiate correctly',
);

# set customer user details
my $CustomerUserLogin    = $Helper->TestCustomerUserCreate();
my $CustomerUserPassword = $CustomerUserLogin;
my $CustomerUserID       = $CustomerUserLogin;

# Tests for CreateSessionID
my @Tests = (
    {
        Name    => 'Empty',
        Data    => {},
        Success => 0,
    },
    {
        Name => 'UserLogin No Password',
        Data => {
            UserLogin => $UserLogin,
        },
        Success => 0,
    },
    {
        Name => 'CustomerUserLogin No Password',
        Data => {
            CustomerUserLogin => $CustomerUserLogin,
        },
        Success => 0,
    },
    {
        Name => 'Password No UserLogin',
        Data => {
            Password => $UserPassword,
        },
        Success => 0,
    },
    {
        Name => 'UserLogin Invalid Password',
        Data => {
            UserLogin => $UserLogin,
            Password  => $RandomID,
        },
        Success => 0,
    },
    {
        Name => 'CustomerUserLogin Invalid Password',
        Data => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $RandomID,
        },
        Success => 0,
    },
    {
        Name => 'Invalid UserLogin Correct Password',
        Data => {
            UserLogin => $RandomID,
            Password  => $UserPassword,
        },
        Success => 0,
    },
    {
        Name => 'Invalid CustomerUserLogin Correct Password',
        Data => {
            CustomerUserLogin => $RandomID,
            Password          => $CustomerUserPassword,
        },
        Success => 0,
    },
    {
        Name => 'Correct UserLogin and Password',
        Data => {
            UserLogin => $UserLogin,
            Password  => $UserPassword,
        },
        Success => 1,
    },
    {
        Name => 'Correct CustomerUserLogin and Password',
        Data => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerUserPassword,
        },
        Success => 1,
    },
);

# use a session operation instance to get access to the common functions
my $OperationObject = Kernel::GenericInterface::Operation::Session::SessionCreate->new(
    DebuggerObject => $DebuggerObject,
    WebserviceID   => $WebserviceID,
);
$Self->Is(
    ref $OperationObject,
    'Kernel::GenericInterface::Operation::Session::SessionCreate',
    'CommonObject instantiate correctly',
);

for my $Test (@Tests) {
    my $SessionID = $OperationObject->CreateSessionID(
        Data => $Test->{Data},
    );

    if ( $Test->{Success} ) {
        $Self->IsNot(
            $SessionID,
            undef,
            "GerSessionID() - $Test->{Name}",
        );
    }

    else {
        $Self->Is(
            $SessionID,
            undef,
            "GerSessionID() - $Test->{Name}",
        );
    }
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
