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

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Kernel::OM

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# added for OTOBOTicketInvoker
# Set fixed header blacklists.
for my $Type (qw(Invoker Operation)) {
    $ConfigObject->Set(
        Key   => 'GenericInterface::' . $Type . '::OutboundHeaderBlacklist',
        Value => [
            'Connection',
            'Content-Type',

            # Only for UnitTest on the client side
            'NotAllowed',
        ],
    );
}

# Skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# activate support for mirroring HTTP headers in the transport backends
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'GenericInterface::Transport::MirrorUnitTestHTTPHeaders',
    Value => 1,
);

# Add web service to be used (empty config).
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
isa_ok( $WebserviceObject, 'Kernel::System::GenericInterface::Webservice' );
my $WebserviceName = 'SOAP' . $Helper->GetRandomID();
my $WebserviceID   = $WebserviceObject->WebserviceAdd(
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
    UserID  => 1,
);
ok( $WebserviceID, 'Added Web service' );

# Get remote host with some precautions for certain unit test systems.
my $Host = $Helper->GetTestHTTPHostname();

# prepare web service config
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . 'nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my @BasicTests = (
    {
        Name           => 'Test 1',
        SuccessRequest => '0',
        RequestData    => {
            PriorityName => '5 very high',
            DataIn       => {
                Blah => 'Fasel',
            },
        },
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type => 'HTTP::SOAP',
                },
            },
        },
    },
    {
        Name             => 'Test 2',
        SuccessRequest   => '0',
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type => 'HTTP::SOAP',
                },
            },
        },
    },
    {
        Name           => 'Test 3',
        SuccessRequest => '0',
        RequestData    => {
            PriorityName => '5 very high',
            DataIn       => {
                Blah => 'Fasel',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityID => 'PriorityName',
                                    Data       => 'DataOut',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityName => {
                                        ValueMapExact => {
                                            1 => '1 sehr niedrig',
                                            2 => '2 niedrig',
                                            3 => '3 normal',
                                            4 => '4 hoch',
                                            5 => '5 sehr hoch',
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            }
                        },
                        Type => 'Test::Test',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 4',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => '5 very high',
            DataIn       => {
                Blah        => 'Fasel',
                Umlaut      => 'äöüßÄÖÜ€ис',
                InvalidXML1 => '<test>',
                InvalidXML2 => 'test&test',
            },
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                PriorityName => '5 sehr hoch',
                DataOut      => {
                    Blah        => 'Fasel',
                    Umlaut      => 'äöüßÄÖÜ€ис',
                    InvalidXML1 => '<test>',
                    InvalidXML2 => 'test&test',
                },
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityID => 'PriorityName',
                                    Data       => 'DataOut',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityName => {
                                        ValueMapExact => {
                                            1 => '1 sehr niedrig',
                                            2 => '2 niedrig',
                                            3 => '3 normal',
                                            4 => '4 hoch',
                                            5 => '5 sehr hoch',
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            }
                        },
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityName => 'PriorityID',
                                    DataIn       => 'Data',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityID => {
                                        ValueMapExact => {
                                            '1 very low'  => 1,
                                            '2 low'       => 2,
                                            '3 normal'    => 3,
                                            '4 high'      => 4,
                                            '5 very high' => 5,
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 5',
        SuccessRequest => '1',
        RequestData    => {},
        ExpectedReturn => {
            Success => 1,
            Data    => {},
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description =>
                'Test with empty data for provider and requester using SOAP transport backend.',
            Debugger => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityID => 'PriorityName',
                                    Data       => 'DataOut',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityName => {
                                        ValueMapExact => {
                                            1 => '1 sehr niedrig',
                                            2 => '2 niedrig',
                                            3 => '3 normal',
                                            4 => '4 hoch',
                                            5 => '5 sehr hoch',
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            }
                        },
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        MappingInbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapDefault => {
                                    MapType => 'Keep',
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        MappingOutbound => {
                            Type   => 'Simple',
                            Config => {
                                KeyMapExact => {
                                    PriorityName => 'PriorityID',
                                    DataIn       => 'Data',
                                },
                                KeyMapDefault => {
                                    MapType => 'Ignore',
                                },
                                ValueMap => {
                                    PriorityID => {
                                        ValueMapExact => {
                                            '1 very low'  => 1,
                                            '2 low'       => 2,
                                            '3 normal'    => 3,
                                            '4 high'      => 4,
                                            '5 very high' => 5,
                                        },
                                    },
                                },
                                ValueMapDefault => {
                                    MapType => 'Keep',
                                },
                            },
                        },
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 6',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => '5 very high',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                PriorityName => '5 very high',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 7',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => [ '5 very high', '4 high' ],
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                PriorityName => [ '5 very high', '4 high' ],
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 7',
        SuccessRequest => '1',
        RequestData    => {
            PriorityName => [
                '5 very high',
                Hash => {
                    Val => 1,
                },
            ],
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                PriorityName => [
                    '5 very high',
                    Hash => {
                        Val => 1,
                    },
                ],
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 7a',
        SuccessRequest => '1',
        RequestData    => {
            'Element1' => [
                'String1',
                {},
            ],
            'Element2' => {
                'String2' => {},
                'String3' => '',
            },
            'Element3' => {},
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                'Element1' => [
                    'String1',
                    '',
                ],
                'Element2' => {
                    'String2' => '',
                    'String3' => '',
                },
                'Element3' => '',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Basic test for provider and requester using SOAP transport backend.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 8',
        SuccessRequest => '0',
        RequestData    => {
            TestError => 123,
            ErrorData => {
                PriorityName => [ '5 very high', '4 high' ],
            },
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => 'faultcode: Server, faultstring: Error message for error code: 123',
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description =>
                'Operation handling errors test for provider and requester using SOAP transport backend.',
            Debugger => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 9',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Plain',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 10',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Response',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 11',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Test',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 12',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'PriorityIDNameResponse',
                        ResponseNameScheme   => 'Replace',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 13',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => '',
                        ResponseNameScheme   => 'Append',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 14',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Response',
                        ResponseNameScheme   => 'Append',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 15',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Name',
                        RequestNameScheme   => 'Append',
                        SOAPAction          => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 16',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        RequestNameFreeText  => 'Test',
                        RequestNameScheme    => 'Append',
                        ResponseNameFreeText => 'PriorityIDNameTestResponse',
                        ResponseNameScheme   => 'Replace',
                        SOAPAction           => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDNameTest => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 17',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => "No response data found for specified operation 'PriorityIDNameRequest' in soap response",
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otobo.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                        SOAPAction        => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDNameRequest => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 18',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength            => 10000000,
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Endpoint             => $RemoteSystem,
                        RequestNameScheme    => 'Request',
                        ResponseNameFreeText => 'PriorityIDNameRequestResponse',
                        ResponseNameScheme   => 'Replace',
                        SOAPAction           => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDNameRequest => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 19',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for provider request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otobo.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Plain',
                    },
                },
                Operation => {
                    PriorityIDNamePlain => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDNamePlain => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 20',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otobo.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameScheme   => 'Request',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 21',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength  => 10000000,
                        NameSpace  => 'http://otobo.org/SoapTestInterface/',
                        Endpoint   => $RemoteSystem,
                        SOAPAction => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameScheme   => 'Request',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 22a',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otobo.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Request',
                        RequestNameScheme   => 'Append',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 22b',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otobo.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'equest',
                        SOAPAction        => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Request',
                        RequestNameScheme   => 'Append',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 23',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester request element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength         => 10000000,
                        NameSpace         => 'http://otobo.org/SoapTestInterface/',
                        Endpoint          => $RemoteSystem,
                        RequestNameScheme => 'Request',
                        SOAPAction        => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Test',
                        RequestNameScheme   => 'Apppend',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 24',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Plain',
                        Timeout              => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 25',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'WillBeOverwritten',
                        ResponseNameScheme   => 'Response',
                        Timeout              => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 26',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Test',
                        ResponseNameScheme   => 'Replace',
                        Timeout              => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 27',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'PriorityIDNameResponse',
                        ResponseNameScheme   => 'Replace',
                        Timeout              => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 28',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => "No response data found for specified operation 'PriorityIDName' in soap response",
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => '',
                        ResponseNameScheme   => 'Append',
                        Timeout              => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 29',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Endpoint  => $RemoteSystem,
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        ResponseNameFreeText => 'Response',
                        ResponseNameScheme   => 'Append',
                        Timeout              => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 30',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage => 'faultcode: Server, faultstring: Got no OperationType!',
            Success      => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength  => 10000000,
                        NameSpace  => 'http://otobo.org/SoapTestInterface/',
                        Endpoint   => $RemoteSystem,
                        SOAPAction => 'No',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        RequestNameFreeText => 'Name',
                        RequestNameScheme   => 'Append',
                        SOAPAction          => 'Yes',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 31',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for requester response element name generation/validation.',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength  => 10000000,
                        NameSpace  => 'http://otobo.org/SoapTestInterface/',
                        Endpoint   => $RemoteSystem,
                        SOAPAction => 'No',
                    },
                },
                Operation => {
                    PriorityIDNameTest => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace            => 'http://otobo.org/SoapTestInterface/',
                        Encoding             => 'UTF-8',
                        Endpoint             => $RemoteSystem,
                        RequestNameFreeText  => 'Test',
                        RequestNameScheme    => 'Append',
                        ResponseNameFreeText => 'PriorityIDNameTestResponse',
                        ResponseNameScheme   => 'Replace',
                        SOAPAction           => 'Yes',
                        SOAPActionSeparator  => '#',
                        Timeout              => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 32',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (Fallback-Config Requester vs. Fallback-Config Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 33',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '#',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 34',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otobo.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result 'http://otobo.org/SoapTestInterface//PriorityIDName'",
            Success => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SOAPActionSeparator / Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 35',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otobo.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result '#PriorityIDName'",
            Success => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme SeparatorOperation Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '#',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 36',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otobo.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result 'PriorityIDName'",
            Success => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme Operation Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength        => 10000000,
                        NameSpace        => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 37',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'http://otobo.org/SoapTestInterface/#PriorityIDName' does not match "
                . "expected result 'SoapTestInterface'",
            Success => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme FreeText Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength          => 10000000,
                        NameSpace          => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                        Encoding  => 'UTF-8',
                        Endpoint  => $RemoteSystem,
                        Timeout   => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 38',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Requester 1).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 39',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Requester 2).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 40',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction '#PriorityIDName' does not match "
                . "expected result 'http://otobo.org/SoapTestInterface/#PriorityIDName'",
            Success => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme SeparatorOperation Requester).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '#',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 41',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'PriorityIDName' does not match "
                . "expected result 'http://otobo.org/SoapTestInterface/#PriorityIDName'",
            Success => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme Operation Requester).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace        => 'http://otobo.org/SoapTestInterface/',
                        Encoding         => 'UTF-8',
                        Endpoint         => $RemoteSystem,
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
                        Timeout          => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 42',
        SuccessRequest => '0',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Data         => undef,
            ErrorMessage =>
                "faultcode: Server, faultstring: "
                . "SOAPAction 'SoapTestInterface' does not match "
                . "expected result 'http://otobo.org/SoapTestInterface/#PriorityIDName'",
            Success => 0,
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme FreeText Requester).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength => 10000000,
                        NameSpace => 'http://otobo.org/SoapTestInterface/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace          => 'http://otobo.org/SoapTestInterface/',
                        Encoding           => 'UTF-8',
                        Endpoint           => $RemoteSystem,
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
                        Timeout            => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 43',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description =>
                'Test for SOAPAction validation (SoapActionScheme NameSpaceSeparatorOperation Requester&Provider).',
            Debugger => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 44',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme SeparatorOperation Requester&Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'SeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 45',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme Operation Requester&Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength        => 10000000,
                        NameSpace        => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace        => 'http://otobo.org/SoapTestInterface/',
                        Encoding         => 'UTF-8',
                        Endpoint         => $RemoteSystem,
                        SOAPAction       => 'Yes',
                        SOAPActionScheme => 'Operation',
                        Timeout          => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 46',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (SoapActionScheme FreeText Requester&Provider).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength          => 10000000,
                        NameSpace          => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace          => 'http://otobo.org/SoapTestInterface/',
                        Encoding           => 'UTF-8',
                        Endpoint           => $RemoteSystem,
                        SOAPAction         => 'Yes',
                        SOAPActionScheme   => 'FreeText',
                        SOAPActionFreeText => 'SoapTestInterface',
                        Timeout            => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Test 47',
        SuccessRequest => '1',
        RequestData    => {
            Key => 'Value',
        },
        ExpectedReturn => {
            Success => 1,
            Data    => {
                Key => 'Value',
            },
        },
        WebserviceConfig => {
            Name        => 'SOAPTest1',
            Description => 'Test for SOAPAction validation (NameSpace with vs. without trailing slash, see bug#12196).',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        MaxLength           => 10000000,
                        NameSpace           => 'http://otobo.org/SoapTestInterface/',
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                    },
                },
                Operation => {
                    PriorityIDName => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::SOAP',
                    Config => {
                        NameSpace           => 'http://otobo.org/SoapTestInterface',
                        Encoding            => 'UTF-8',
                        Endpoint            => $RemoteSystem,
                        SOAPAction          => 'Yes',
                        SOAPActionScheme    => 'NameSpaceSeparatorOperation',
                        SOAPActionSeparator => '/',
                        Timeout             => 60,
                    },
                },
                Invoker => {
                    PriorityIDName => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
);

# Create requester object.
my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
isa_ok( $RequesterObject, 'Kernel::GenericInterface::Requester' );

for my $Test (@BasicTests) {

    subtest $Test->{Name} => sub {

        # Update web service with real config.
        my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceName,
            Config  => $Test->{WebserviceConfig},
            ValidID => 1,
            UserID  => 1,
        );
        ok( $WebserviceUpdate, "Updated Web service $WebserviceID" );

        # start requester with our web service
        my ($InvokerName) = keys %{ $Test->{WebserviceConfig}->{Requester}->{Invoker} };
        my $RequesterResult = $RequesterObject->Run(
            WebserviceID => $WebserviceID,
            Invoker      => $InvokerName,
            Data         => $Test->{RequestData},
        );

        # check result
        ref_ok( $RequesterResult, 'HASH', "Requester result structure is valid" );

        # check success of result
        if ( $Test->{SuccessRequest} ) {
            ok( $RequesterResult->{Success}, 'request was successfull' );
        }
        else {
            ok( !$RequesterResult->{Success}, 'request was not successfull' );
        }

        # for example:
        # ExpectedReturn => {
        #     Success => 1,
        #     Data    => {
        #         Key => 'Value',
        #     },
        # },
        if ( $Test->{ExpectedReturn} ) {
            is(
                $RequesterResult,
                $Test->{ExpectedReturn},
                'request result'
            );
        }
        else {
            note('check of request result was skipped');
        }
    };
}

# adapted for OTOBOTicketInvoker
# Check operation request and response headers.
# The string $ResponseHeaderPrefix is 25 chars long. It marks the headers that should be returned by RequesterPerformRequest()
my $ResponseHeaderPrefix = 'Unittest' . $Helper->GetRandomNumber() . '-';
my %DefaultConfig        = (
    NameSpace       => 'http://otobo.org/SoapTestInterface/',
    Endpoint        => $RemoteSystem,
    SOAPAction      => 'No',
    Timeout         => 120,
    UnitTestHeaders => $ResponseHeaderPrefix,
);
my @CheckHeadersTests = (
    {
        Name   => 'Standard headers',
        Config => {
            %DefaultConfig,
        },
        ExpectedHeaders => {},
    },
    {
        Name   => 'Additional common headers',
        Config => {
            %DefaultConfig,
            OutboundHeaders => {
                Common => {
                    Key1           => 'Value1',
                    Key2           => 'Value2',
                    'Content-Type' => 'Invalid',    # should be filtered
                    NotAllowed     => 'Invalid',    # should be filtered
                },
            },
        },
        ExpectedHeaders => {
            Key1 => 'Value1',
            Key2 => 'Value2',
        },
    },
    {
        Name   => 'Additional operation specific headers',
        Config => {
            %DefaultConfig,
            OutboundHeaders => {
                Specific => {
                    PriorityIDName => {
                        Key1           => 'Value3',
                        Key2           => 'Value4',
                        'Content-Type' => 'Invalid',    # should be filtered
                        NotAllowed     => 'Invalid',    # should be filtered
                    },
                    OtherOperation => {                 # should be ignored
                        Key1 => 'Invalid',
                    },
                },
            },
        },
        ExpectedHeaders => {
            Key1 => 'Value3',
            Key2 => 'Value4',
        },
    },
    {
        Name   => 'Additional mixed headers',
        Config => {
            %DefaultConfig,
            OutboundHeaders => {
                Common => {
                    Key1           => 'Value5',
                    Key2           => 'Value6',
                    'Content-Type' => 'Invalid',    # should be filtered
                    NotAllowed     => 'Invalid',    # should be filtered
                },
                Specific => {
                    PriorityIDName => {
                        Key1         => 'Value7',     # should override common value
                        Key3         => 'Value8',
                        'Connection' => 'Invalid',    # should be filtered
                        NotAllowed   => 'Invalid',    # should be filtered
                    },
                    OtherOperation => {               # should be ignored
                        Key1 => 'Invalid',
                    },
                },
            },
        },
        ExpectedHeaders => {
            Key1 => 'Value7',
            Key2 => 'Value6',
            Key3 => 'Value8',
        },
    },
);

# Create debugger object.
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    CommunicationType => 'Provider',
    WebserviceID      => $WebserviceID,
);

for my $Test (@CheckHeadersTests) {

    subtest $Test->{Name} => sub {

        diag "Running check header test: $Test->{Name}";

        # Create HTTP::SOAP transport object with test configuration.
        my $TransportObject = Kernel::GenericInterface::Transport->new(
            DebuggerObject  => $DebuggerObject,
            TransportConfig => {
                Type   => 'HTTP::SOAP',
                Config => $Test->{Config},
            },
        );

        isa_ok( $TransportObject, 'Kernel::GenericInterface::Transport' );

        # check the result of a complete cycle
        {
            my $Result = $TransportObject->RequesterPerformRequest(
                Operation => 'PriorityIDName',
                Data      => {},
            );
            ok( $Result, 'Request result created' );
            is( ref $Result, 'HASH', 'Request result is a hashref' );

            # Retrieve the request headers that were mirrored in the response.
            my %MirroredHeaders = ( $Result->{UnitTestHeaders} // {} )->%*;

            # Ignore standard headers.
            # Note that CONNECTION is mirrored even though it is blacklisted.
            delete @MirroredHeaders{qw(CONNECTION ACCEPT HOST SOAPACTION TE USER-AGENT)};

            # Analyze headers.
            # Keys were uppercase by CGI::PSGI in nph-genericinterface.pl
            for my $Key ( sort keys $Test->{ExpectedHeaders}->%* ) {
                is(
                    delete $MirroredHeaders{ uc $Key },
                    $Test->{ExpectedHeaders}->{$Key},
                    "Found request header '$Key' with value '$Test->{ExpectedHeaders}->{$Key}'"
                );
            }

            ok( !%MirroredHeaders, 'Only expected request result headers have been found' );
        }

        # Create and check the PSGI response. The response is acutually thrown as an exception.
        {
            # Discard request object to prevent errors.
            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

            # Create response. The response is acutually thrown as an exception.
            eval {
                $TransportObject->ProviderGenerateResponse(
                    Success   => 1,
                    Data      => {},
                    Operation => 'PriorityIDName',
                );
            };
            my $WebException = $@;
            can_ok( $WebException, ['as_psgi'], 'exception with as_psgi() method' );
            my $PSGIResponse = $WebException->as_psgi();
            ref_ok( $PSGIResponse, 'ARRAY', 'PSGI response is an array ref' );

            # Retrieve all headers from response.
            my %ResponseHeaders = $PSGIResponse->[1]->@*;

            # Remove unused standard headers.
            delete @ResponseHeaders{qw(Connection Content-Type Content-Length)};

            # Analyze headers.
            for my $Key ( sort keys $Test->{ExpectedHeaders}->%* ) {
                is(
                    delete $ResponseHeaders{$Key},
                    $Test->{ExpectedHeaders}->{$Key},
                    "Found request header '$Key' with value '$Test->{ExpectedHeaders}->{$Key}'"
                );
            }

            ok( !%ResponseHeaders, 'Only expected response headers have been found' );
        }
    };
}

# Cleanup test web service.
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
ok( $WebserviceDelete, "Deleted Web service $WebserviceID" );

done_testing();
