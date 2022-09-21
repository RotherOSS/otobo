# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

# core modules

# CPAN modules
use SOAP::Lite;

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

# set up object params
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# define SOAP variables
my $SOAPUser     = 'User' . $RandomID;
my $SOAPPassword = $RandomID;

# update sysconfig settings, but do not deploy them
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SOAP::User',
    Value => $SOAPUser,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SOAP::Password',
    Value => $SOAPPassword,
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# Create SOAP Object and use RPC interface to test SOAP Lite
my $SOAPObject;
{
    my $Proxy = $ConfigObject->Get('HttpType')
        . '://'
        . $Host
        . '/'
        . $ConfigObject->Get('ScriptAlias')
        . 'rpc.pl';
    my $URI = $ConfigObject->Get('HttpType')
        . '://'
        . $Host
        . '/OTOBO::RPC';
    $Self->Note( Note => "SOAP::Lite proxy: $Proxy" );
    $Self->Note( Note => "SOAP::Lite uri: $URI" );
    $SOAPObject = SOAP::Lite->new(
        proxy => $Proxy,
        uri   => $URI,
    );
}

# Tests for number of params in SOAP call
my @Tests = (
    {
        Name   => 'TimeObject::SystemTime() - No parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => undef,
    },
    {
        Name   => 'TimeObject::SystemTime() - 1 parameter',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 2 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 3 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
            Param3 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 4 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
            Param3 => 1,
            Param4 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 5 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
            Param3 => 1,
            Param4 => 1,
            Param5 => 1,
        },
    },
);

for my $Test (@Tests) {

    # send SOAP request
    my $SOAPMessage = $SOAPObject->Dispatch(
        $SOAPUser,
        $SOAPPassword,
        $Test->{Object},
        $Test->{Method},
        %{ $Test->{Config} },
    );

    # get fault from SOAP message if any
    my $FaultString;
    if ( IsHashRefWithData( $SOAPMessage->fault() ) ) {
        $FaultString = $SOAPMessage->fault()->{faultstring};
    }

    # get result from SOAP message if any
    my $Result;
    if ( $SOAPMessage->result() ) {
        $Result = $SOAPMessage->result();
    }

    $Self->Is(
        $FaultString,
        undef,
        "$Test->{Name}: Message fault should be undefined",
    );

    $Self->IsNot(
        $Result,
        undef,
        "$Test->{Name}: Message result should have a value",
    );
}

# cleanup is done by RestoreDatabase()
$Self->DoneTesting();
