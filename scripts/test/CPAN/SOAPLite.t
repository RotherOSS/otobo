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
use SOAP::Lite;
use Test2::V0;

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

pass('SOAP::Lite could be loaded');

# set up object params
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# get needed objects
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

ok( $Host, 'got the test hostname' );

# Create SOAP Object and use RPC interface to test SOAP Lite
my ( $SOAPUser, $SOAPPassword, $SOAPObject );
SKIP:
{
    skip "rpc.pl is no longer supported";

    # define SOAP variables
    my $RandomID     = $Helper->GetRandomID();
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

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Proxy        = $ConfigObject->Get('HttpType')
        . '://'
        . $Host
        . '/'
        . $ConfigObject->Get('ScriptAlias')
        . 'rpc.pl';
    note "SOAP::Lite proxy: $Proxy";

    my $URI = $ConfigObject->Get('HttpType')
        . '://'
        . $Host
        . '/OTOBO::RPC';
    note "SOAP::Lite uri: $URI";

    $SOAPObject = SOAP::Lite->new(
        proxy => $Proxy,
        uri   => $URI,
    );

    ok( $SOAPObject, 'got the SOAP object' );
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

SKIP:
for my $Test (@Tests) {
    skip "rpc.pl is no longer supported";

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
    is( $FaultString, undef, "$Test->{Name}: Message fault should be undefined" );

    # get result from SOAP message if any
    my $Result;
    if ( $SOAPMessage->result() ) {
        $Result = $SOAPMessage->result();
    }
    isnt( $Result, undef, "$Test->{Name}: Message result should have a value" );
}

# cleanup is done by RestoreDatabase()
done_testing();
