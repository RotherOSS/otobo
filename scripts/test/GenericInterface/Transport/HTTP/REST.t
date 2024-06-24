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
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

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
my $WebserviceName = 'REST' . $Helper->GetRandomID();
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
        Name           => 'Wrong Path Name Provider - Basic Transport Mapping',
        SuccessRequest => 0,
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Wrong',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Wrong Path Extra \'/\' Provider - Basic Transport Mapping',
        SuccessRequest => 0,
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Wrong HTTP method Provider - Basic Transport Mapping',
        SuccessRequest => 0,
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['GET'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Wrong Path Name Requester - Basic Transport Mapping',
        SuccessRequest => 0,
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Wrong',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Wrong Path Extra \'/\' Requester - Basic Transport Mapping',
        SuccessRequest => 0,
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Wrong HTTP command Requester - Basic Transport Mapping',
        SuccessRequest => 0,
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Correct Basic Transport Mapping POST',
        SuccessRequest => '1',
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Correct Basic Transport Mapping GET',
        SuccessRequest => '1',
        RequestData    => {
            Other  => 'Data',
            Other1 => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Other4 => 'Four',
        },
        ExpectedReturnData => {
            Other  => 'Data',
            Other1 => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Other4 => 'Four',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => [ 'GET', 'POST' ],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Correct Complex Transport Mapping URIParams 1 POST',
        SuccessRequest => '1',
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            URI     => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/:URI',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Correct Complex Transport Mapping URIParams POST 2',
        SuccessRequest => '1',
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            URI     => 'Data',
            URI2    => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/:URI/:URI2',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other/:Other1',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Correct Complex Transport Mapping URIParams QueryParams POST',
        SuccessRequest => '1',
        RequestData    => {
            Other   => 'Data',
            Other1  => 'One',
            Other2  => 'Two',
            Other3  => 'Three',
            Other4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        ExpectedReturnData => {
            Other   => 'Data',
            URI1    => 'One',
            URI2    => 'Two',
            Query3  => 'Three',
            Query4  => 'Four',
            Complex => {
                ComplexData => 'Data',
            },
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/:URI1/:URI2',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other1/:Other2?Query3=:Other3&Query4=:Other4',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'Correct Complex Transport Mapping URIParams QueryParams GET',
        SuccessRequest => '1',
        RequestData    => {
            Other  => 'Data',
            Other1 => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Other4 => 'Four',
        },
        ExpectedReturnData => {
            Other  => 'Data',
            URI1   => 'One',
            Other2 => 'Two',
            Other3 => 'Three',
            Query4 => 'Four',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['GET'],
                                Route         => '/Test/:URI1/',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/:Other1/?Query4=:Other4',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },

    # tests for bug #12049
    {
        Name           => 'UTF8 test GET',
        SuccessRequest => '1',
        RequestData    => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other => 'äöüß€ÄÖÜ',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['GET'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'UTF8 test POST',
        SuccessRequest => '1',
        RequestData    => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other => 'äöüß€ÄÖÜ',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'UTF8 test POST mixed with GET params',
        SuccessRequest => '1',
        RequestData    => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
        },
        ExpectedReturnData => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test?Other1=:Other1',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'UTF8 test GET with URI params',
        SuccessRequest => '1',
        RequestData    => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['GET'],
                                Route         => '/Test/:Other1',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'GET',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/ÄÖÜß€äöü',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
                        Type => 'Test::TestSimple',
                    },
                },
            },
        },
    },
    {
        Name           => 'UTF8 test POST with URI params',
        SuccessRequest => '1',
        RequestData    => {
            Other => 'äöüß€ÄÖÜ',
        },
        ExpectedReturnData => {
            Other  => 'äöüß€ÄÖÜ',
            Other1 => 'ÄÖÜß€äöü',
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => ['POST'],
                                Route         => '/Test/:Other1',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
            Requester => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        DefaultCommand           => 'POST',
                        Host                     => $RemoteSystem,
                        Timeout                  => 120,
                        InvokerControllerMapping => {
                            TestSimple => {
                                Controller => '/Test/ÄÖÜß€äöü',
                            },
                        },
                    },
                },
                Invoker => {
                    TestSimple => {
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

        diag "Running basic test: $Test->{Name}";

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
        my $RequesterResult = $RequesterObject->Run(
            WebserviceID => $WebserviceID,
            Invoker      => 'TestSimple',
            Data         => $Test->{RequestData},
        );

        # check result
        is( ref $RequesterResult, 'HASH', "Requester result structure is valid" );

        # check success of result
        if ( $Test->{SuccessRequest} ) {
            ok( $RequesterResult->{Success}, 'request was successfull' );
        }
        else {
            ok( !$RequesterResult->{Success}, 'request was not successfull' );
        }

        # for example:
        # ExpectedReturnData => {
        #     Other  => 'äöüß€ÄÖÜ',
        #     Other1 => 'ÄÖÜß€äöü',
        # },
        if ( $Test->{ExpectedReturnData} ) {

            # The RequestMethod is set when the request method is GET or when
            # the POST content is empty. For some reason the RequestMethod is not
            # set up in the expected data.
            delete $RequesterResult->{Data}->{RequestMethod};

            is(
                $RequesterResult->{Data},
                $Test->{ExpectedReturnData},
                'request result data'
            );
        }
        else {
            note('check of request result data was not set up');
        }
    };
}

# Check direct requests.
my @DirectTests = (
    {
        Name        => 'Correct Direct Request GET Special Chars',
        Success     => '1',
        RequestData => {
            Other1 => 'DataOne',
            Other2 => 'Data Two',
            Other3 => 'Data%20Tree',
            Other4 => 'Data+Four',
            Other5 => 'Data%2BFive'
        },
        ExpectedReturnData => {
            Other1 => 'DataOne',
            Other2 => 'Data Two',
            Other3 => 'Data Tree',
            Other4 => 'Data Four',
            Other5 => 'Data+Five'
        },
        WebserviceConfig => {
            Name        => 'TestSimple1',
            Description => '',
            Debugger    => {
                DebugThreshold => 'debug',
                TestMode       => 1,
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::REST',
                    Config => {
                        KeepAlive             => '',
                        MaxLength             => '100000000',
                        RouteOperationMapping => {
                            TestSimple => {
                                RequestMethod => [ 'GET', 'POST' ],
                                Route         => '/Test',
                            },
                        },
                    },
                },
                Operation => {
                    TestSimple => {
                        Type => 'Test::Test',
                    },
                },
            },
        },
    },
);

# Get JSON object.
my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

for my $Test (@DirectTests) {

    subtest $Test->{Name} => sub {

        diag "Running direct test: $Test->{Name}";

        # Update web service with real config.
        my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
            ID      => $WebserviceID,
            Name    => $WebserviceName,
            Config  => $Test->{WebserviceConfig},
            ValidID => 1,
            UserID  => 1,
        );
        ok( $WebserviceUpdate, "Updated Web service $WebserviceID" );

        my $RequestParams;
        for my $DataKey ( sort keys %{ $Test->{RequestData} } ) {
            $RequestParams .= "$DataKey=$Test->{RequestData}->{$DataKey}&";
        }

        # Perform request.
        my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
            Type => 'GET',
            URL  => $RemoteSystem
                . $Test->{WebserviceConfig}->{Provider}->{Transport}->{Config}->{RouteOperationMapping}->{TestSimple}
                ->{Route}
                . '?'
                . $RequestParams,
        );

        if ( !$Test->{Success} ) {

            # Check result.
            isnt(
                $Response{Status},
                '200 OK',
                "Response unsuccessful result"
            );

            return;
        }

        is(
            $Response{Status},
            '200 OK',
            "$Test->{Name} - Response successful result"
        );

        my $ReturnData = $JSONObject->Decode(
            Data => ${ $Response{Content} },
        );

        delete $ReturnData->{RequestMethod};

        is(
            $ReturnData,
            $Test->{ExpectedReturnData},
            "Response data (needs configured and running web server)"
        );
    };
}

# adapted for OTOBOTicketInvoker
# Check operation request and response headers.
# The string $ResponseHeaderPrefix is 25 chars long. It marks the headers that should be returned by RequesterPerformRequest()
my $ResponseHeaderPrefix = 'Unittest' . $Helper->GetRandomNumber() . '-';
my %DefaultConfig        = (
    DefaultCommand           => 'GET',
    Host                     => $RemoteSystem,
    Timeout                  => 120,
    InvokerControllerMapping => {
        TestSimple => {
            Controller => '/Test',
        },
    },
    UnitTestHeaders => $ResponseHeaderPrefix,
);
my @CheckHeadersTests = (
    {
        Name   => 'only standard headers',
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
                    TestSimple => {
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
                    TestSimple => {
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

        # Create HTTP::REST transport object with test configuration.
        my $TransportObject = Kernel::GenericInterface::Transport->new(
            DebuggerObject  => $DebuggerObject,
            TransportConfig => {
                Type   => 'HTTP::REST',
                Config => $Test->{Config},
            },
        );

        isa_ok( $TransportObject, 'Kernel::GenericInterface::Transport' );

        # check the result of a complete cycle
        {
            my $Result = $TransportObject->RequesterPerformRequest(
                Operation => 'TestSimple',
                Data      => {},
            );
            ok( $Result, 'Request result created' );
            is( ref $Result, 'HASH', 'Request result is a hashref' );

            # Retrieve the request headers that were mirrored in the response.
            my %MirroredHeaders = ( $Result->{UnitTestHeaders} // {} )->%*;

            # Ignore standard headers.
            # Note that CONNECTION is mirrored even though it is blacklisted.
            delete @MirroredHeaders{qw(CONNECTION HOST TE USER-AGENT)};

            # Analyze headers.
            # Keys were uppercase by CGI::PSGI in nph-genericinterface.pl
            for my $Key ( sort keys $Test->{ExpectedHeaders}->%* ) {
                is(
                    delete $MirroredHeaders{ uc $Key },
                    $Test->{ExpectedHeaders}->{$Key},
                    "Found request header '$Key' with value '$Test->{ExpectedHeaders}->{$Key}'"
                );
            }

            is( \%MirroredHeaders, {}, 'Only expected request result headers have been found' );
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
                    Operation => 'TestSimple',
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
