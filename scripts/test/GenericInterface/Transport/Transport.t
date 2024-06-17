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
use Kernel::GenericInterface::Transport;

# get encode object
my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

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
    CommunicationType => 'Provider',
    WebserviceID      => 1,
);

#
# failing backend
#

{
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type => 'HTTP::Nonexisting',
        },
    );

    $Self->Is(
        ref $TransportObject,
        'HASH',
        'TransportObject instantiated with an incorrect backend',
    );

    $Self->False(
        $TransportObject->{Success},
        'TransportObject instantiated with an incorrect backend, failure detected',
    );

    $Self->True(
        $TransportObject->{ErrorMessage},
        'TransportObject instantiated with an incorrect backend, error message provided',
    );
}

#
# test backend
#

for my $Fail ( 0 .. 1 ) {
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type   => 'HTTP::Test',
            Config => {
                Fail => $Fail,
            },
        },
    );

    $Self->Is(
        ref $TransportObject,
        'Kernel::GenericInterface::Transport',
        "TransportObject instantiated with testing backend (Fail $Fail)",
    );

    #
    # RequesterPerformRequest()
    #

    my @RPRTestData = (
        {
            Name      => "TransportObject (Fail $Fail) RequesterPerformRequest()",
            Operation => 'test_operation',
            Data      => {
                A => 'A',
                b => 'b',
            },
            ResultData    => 'A=A&b=b',
            ResultSuccess => 1,
        },
        {
            Name      => "TransportObject (Fail $Fail) RequesterPerformRequest() UTF-8 data",
            Operation => 'test_operation',
            Data      => {
                A                    => 'A',
                '使用下列语言' => 'معلومات',
            },
            ResultData =>
                '%E4%BD%BF%E7%94%A8%E4%B8%8B%E5%88%97%E8%AF%AD%E8%A8%80=%D9%85%D8%B9%D9%84%D9%88%D9%85%D8%A7%D8%AA&A=A',
            ResultSuccess => 1,
        },
        {
            Name => "TransportObject (Fail $Fail) RequesterPerformRequest() missing operation",
            Data => {
                A => 'A',
                b => 'b',
            },
            ResultSuccess => 0,
        },
        {
            Name          => "TransportObject (Fail $Fail) RequesterPerformRequest() missing data",
            Operation     => 'test_operation',
            ResultData    => '',
            ResultSuccess => 1,
        },
        {
            Name          => "TransportObject (Fail $Fail) RequesterPerformRequest() wrong data scalar",
            Operation     => 'test_operation',
            Data          => 'testdata',
            ResultSuccess => 0,
        },
        {
            Name          => "TransportObject (Fail $Fail) RequesterPerformRequest() wrong data listref",
            Operation     => 'test_operation',
            Data          => ['testdata'],
            ResultSuccess => 0,
        },
    );

    for my $TestEntry (@RPRTestData) {

        # discard Web::Request from OM to prevent errors
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

        my $Result = $TransportObject->RequesterPerformRequest(
            Operation => $TestEntry->{Operation},
            Data      => $TestEntry->{Data},
        );

        if ( !$Fail && $TestEntry->{ResultSuccess} ) {
            $Self->True(
                $Result->{Success},
                "$TestEntry->{Name} success",
            );

            for my $QueryStringPart ( split m{&}, $TestEntry->{ResultData} ) {
                $Self->True(
                    index( $Result->{Data}->{ResponseContent}, $QueryStringPart ) > -1,
                    "$TestEntry->{Name} result contains $QueryStringPart",
                );
            }
        }
        else {
            $Self->False(
                $Result->{Success},
                "$TestEntry->{Name} fail detected",
            );

            $Self->True(
                $Result->{ErrorMessage},
                "$TestEntry->{Name} error message found",
            );
        }
    }

    #
    # ProviderProcessRequest()
    #

    my @PPRTestData = (
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest()",
            RequestContent => 'A=A',
            ResultData     => {
                A => 'A',
            },
            Operation     => 'test_operation',
            ResultSuccess => 1,
        },
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest()",
            RequestContent => 'A=A&b=b',
            ResultData     => {
                A => 'A',
                b => 'b',
            },
            Operation     => 'test_operation',
            ResultSuccess => 1,
        },
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest() UTF-8 data",
            RequestContent => 'A=A&使用下列语言=معلومات',
            ResultData     => {
                A                    => 'A',
                '使用下列语言' => 'معلومات',
            },
            Operation     => 'test_operation',
            ResultSuccess => 1,
        },
        {
            Name           => "TransportObject (Fail $Fail) ProviderProcessRequest() empty request",
            RequestContent => '',
            ResultSuccess  => 0,
        },
    );

    for my $TestEntry (@PPRTestData) {

        my $Result;

        {

            # prepare CGI environment variables
            local $ENV{REQUEST_METHOD} = 'POST';
            local $ENV{CONTENT_LENGTH} = length( $TestEntry->{RequestContent} );
            local $ENV{CONTENT_TYPE}   = 'application/x-www-form-urlencoded; charset=utf-8;';

            $EncodeObject->EncodeOutput( \$TestEntry->{RequestContent} );

            # redirect STDIN from String so that the transport layer will use this data
            local *STDIN;
            open STDIN, '<:utf8', \$TestEntry->{RequestContent};    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)

            # reset CGI object from previous runs
            CGI::initialize_globals();

            # discard Web::Request from OM to prevent errors
            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

            $Result = $TransportObject->ProviderProcessRequest();
        }

        if ( !$Fail && $TestEntry->{ResultSuccess} ) {
            $Self->True(
                $Result->{Success},
                "$TestEntry->{Name} success",
            );

            $Self->Is(
                $Result->{Operation},
                $TestEntry->{Operation},
                "$TestEntry->{Name} operation",
            );

            $Self->IsDeeply(
                $Result->{Data},
                $TestEntry->{ResultData},
                "$TestEntry->{Name} data result",
            );
        }
        else {
            $Self->False(
                $Result->{Success},
                "$TestEntry->{Name} fail detected",
            );

            $Self->True(
                $Result->{ErrorMessage},
                "$TestEntry->{Name} error message found",
            );
        }
    }

    #
    # ProviderGenerateResponse()
    #

    my @PGRTestData = (
        {
            Name => "TransportObject (Fail $Fail) ProviderGenerateResponse()",
            Data => {
                A => 'A',
                b => 'b',
            },
            ResultData    => 'A=A&b=b',
            ResultSuccess => 1,
        },
        {
            Name => "TransportObject (Fail $Fail) ProviderGenerateResponse() UTF-8 data",
            Data => {
                A                    => 'A',
                '使用下列语言' => 'معلومات',
            },
            ResultData =>
                '%E4%BD%BF%E7%94%A8%E4%B8%8B%E5%88%97%E8%AF%AD%E8%A8%80=%D9%85%D8%B9%D9%84%D9%88%D9%85%D8%A7%D8%AA&A=A',
            ResultSuccess => 1,
        },
        {
            Name          => "TransportObject (Fail $Fail) ProviderGenerateResponse() missing data",
            ResultData    => '',
            ResultSuccess => 1,
        },
        {
            Name          => "TransportObject (Fail $Fail) ProviderGenerateResponse() wrong data scalar",
            Data          => 'testdata',
            ResultSuccess => 0,
        },
        {
            Name          => "TransportObject (Fail $Fail) ProviderGenerateResponse() wrong data listref",
            Data          => ['testdata'],
            ResultSuccess => 0,
        },
    );

    for my $OptionSuccess ( 0 .. 1 ) {
        for my $TestEntry (@PGRTestData) {
            my $ResultData = '';

            my $Result;
            {

                # redirect STDOUT from String so that the transport layer will write there
                local *STDOUT;
                open STDOUT, '>:utf8', \$ResultData;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireEncodingWithUTF8Layer)

                # discard Web::Request from OM to prevent errors
                $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

                $Result = $TransportObject->ProviderGenerateResponse(
                    Success      => $OptionSuccess,
                    ErrorMessage => 'Custom Test Error',
                    Data         => $TestEntry->{Data},
                );
            }

            if ( !$Fail && $TestEntry->{ResultSuccess} ) {
                $Self->True(
                    $Result->{Success},
                    "$TestEntry->{Name} success",
                );

                if ($OptionSuccess) {
                    $Self->True(
                        index( $ResultData, '200 OK' ) > -1,
                        "$TestEntry->{Name} result status 200",
                    );

                    for my $QueryStringPart ( split m{&}, $TestEntry->{ResultData} ) {
                        $Self->True(
                            index( $ResultData, $QueryStringPart ) > -1,
                            "$TestEntry->{Name} result",
                        );
                    }
                }
                else {
                    $Self->True(
                        index( $ResultData, '500 Custom Test Error' ) > -1,
                        "$TestEntry->{Name} result status 500",
                    );
                }
            }
            else {
                $Self->False(
                    $Result->{Success},
                    "$TestEntry->{Name} fail detected",
                );

                $Self->True(
                    $Result->{ErrorMessage},
                    "$TestEntry->{Name} error message found",
                );
            }
        }
    }
}

$Self->DoneTesting();
