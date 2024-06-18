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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;
use HTTP::Request ();

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::GenericInterface::Debugger  ();
use Kernel::GenericInterface::Transport ();

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

note('failing backend');

subtest 'TransportObject instantiated with an incorrect backend' => sub {
    my $TransportObject = Kernel::GenericInterface::Transport->new(
        DebuggerObject  => $DebuggerObject,
        TransportConfig => {
            Type => 'HTTP::Nonexisting',
        },
    );

    ref_ok( $TransportObject, 'HASH', 'got a hash reference' );
    ok( !$TransportObject->{Success},     'failure detected' );
    ok( $TransportObject->{ErrorMessage}, 'error message provided' );
};

# test backend
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

    isa_ok(
        $TransportObject,
        ['Kernel::GenericInterface::Transport'],
        "TransportObject instantiated with testing backend (Fail $Fail)",
    );

    #
    # RequesterPerformRequest()
    #

    my @RPRTestData = (
        {
            Name      => "TransportObject RequesterPerformRequest()",
            Operation => 'test_operation',
            Data      => {
                A => 'A',
                b => 'b',
            },
            ResultData    => 'A=A&b=b',
            ResultSuccess => 1,
        },
        {
            Name      => "TransportObject RequesterPerformRequest() UTF-8 data",
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
            Name => "TransportObject RequesterPerformRequest() missing operation",
            Data => {
                A => 'A',
                b => 'b',
            },
            ResultSuccess => 0,
        },
        {
            Name          => "TransportObject RequesterPerformRequest() missing data",
            Operation     => 'test_operation',
            ResultData    => '',
            ResultSuccess => 1,
        },
        {
            Name          => "TransportObject RequesterPerformRequest() wrong data scalar",
            Operation     => 'test_operation',
            Data          => 'testdata',
            ResultSuccess => 0,
        },
        {
            Name          => "TransportObject RequesterPerformRequest() wrong data listref",
            Operation     => 'test_operation',
            Data          => ['testdata'],
            ResultSuccess => 0,
        },
    );

    note("RequesterPerformRequest() (Fail: $Fail)");

    for my $TestEntry (@RPRTestData) {

        subtest "$TestEntry->{Name} (Fail: $Fail)" => sub {

            # discard Web::Request from OM to prevent errors
            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

            my $Result = $TransportObject->RequesterPerformRequest(
                Operation => $TestEntry->{Operation},
                Data      => $TestEntry->{Data},
            );

            if ( !$Fail && $TestEntry->{ResultSuccess} ) {
                ok( $Result->{Success}, "success" );

                for my $QueryStringPart ( split m{&}, $TestEntry->{ResultData} ) {
                    ok(
                        index( $Result->{Data}->{ResponseContent}, $QueryStringPart ) > -1,
                        "result contains $QueryStringPart",
                    );
                }
            }
            else {
                ok( !$Result->{Success},     'fail detected' );
                ok( $Result->{ErrorMessage}, 'error message found' );
            }
        };
    }

    #
    # ProviderProcessRequest()
    #

    my @PPRTestData = (
        {
            Name           => "TransportObject ProviderProcessRequest() single param",
            RequestContent => 'A=A',
            ResultData     => {
                A => 'A',
            },
            Operation     => 'test_operation',
            ResultSuccess => 1,
        },
        {
            Name           => "TransportObject ProviderProcessRequest() two params",
            RequestContent => 'A=A&b=b',
            ResultData     => {
                A => 'A',
                b => 'b',
            },
            Operation     => 'test_operation',
            ResultSuccess => 1,
        },
        {
            Name           => "TransportObject ProviderProcessRequest() UTF-8 data",
            RequestContent => 'A=A&使用下列语言=معلومات',
            ResultData     => {
                A                    => 'A',
                '使用下列语言' => 'معلومات',
            },
            Operation     => 'test_operation',
            ResultSuccess => 1,
        },
        {
            Name           => "TransportObject ProviderProcessRequest() empty request",
            RequestContent => '',
            ResultSuccess  => 0,
        },
    );

    note("ProviderProcessRequest() (Fail $Fail)");

    for my $TestEntry (@PPRTestData) {

        subtest "$TestEntry->{Name} (Fail $Fail)" => sub {

            # process the request with the dummy HTTP::Test transport object
            my ( $Result, $WebException );
            {
                # prepare the test request
                $EncodeObject->EncodeOutput( \$TestEntry->{RequestContent} );
                my $HTTPRequest = HTTP::Request->new(
                    'POST',
                    'http://www.example.com',
                    [ 'Content-Type' => 'application/x-www-form-urlencoded; charset=utf-8;' ],
                    $TestEntry->{RequestContent},
                );
                $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );
                $Kernel::OM->ObjectParamAdd(
                    'Kernel::System::Web::Request' => { HTTPRequest => $HTTPRequest }
                );

                # process
                $Result = eval {
                    $TransportObject->ProviderProcessRequest();
                };
                $WebException = $@;
            }

            if ( !$Fail && $TestEntry->{ResultSuccess} ) {
                is( $WebException, '', 'no exception' );
                ok( $Result->{Success}, 'success' );
                is( $Result->{Operation}, $TestEntry->{Operation},  "operation" );
                is( $Result->{Data},      $TestEntry->{ResultData}, "data result" );
            }
            else {
                ok( !$Result->{Success},     'fail detected' );
                ok( $Result->{ErrorMessage}, 'error message found' );
            }

            #can_ok( $WebException, [ 'as_psgi' ], 'exception with as_psgi() method' );
            #my $PSGIResponse = $WebException->as_psgi();
            #ref_ok( $PSGIResponse, 'ARRAY', 'PSGI response is an array ref' );
            #
            #ok( $PSGIResponse->[2], "error message found" );
        };
    }

    # ProviderGenerateResponse()
    my @PGRTestEntries = (
        {
            Name => "TransportObject ProviderGenerateResponse()",
            Data => {
                A => 'A',
                b => 'b',
            },
            ResultData    => 'A=A&b=b',
            ResultSuccess => 1,
        },
        {
            Name => "TransportObject ProviderGenerateResponse() UTF-8 data",
            Data => {
                A                    => 'A',
                '使用下列语言' => 'معلومات',
            },
            ResultData =>
                '%E4%BD%BF%E7%94%A8%E4%B8%8B%E5%88%97%E8%AF%AD%E8%A8%80=%D9%85%D8%B9%D9%84%D9%88%D9%85%D8%A7%D8%AA&A=A',
            ResultSuccess => 1,
        },
        {
            Name          => "TransportObject ProviderGenerateResponse() missing data",
            ResultData    => '',
            ResultSuccess => 1,
        },
        {
            Name          => "TransportObject ProviderGenerateResponse() wrong data scalar",
            Data          => 'testdata',
            ResultSuccess => 0,
        },
        {
            Name          => "TransportObject ProviderGenerateResponse() wrong data listref",
            Data          => ['testdata'],
            ResultSuccess => 0,
        },
    );

    for my $OptionSuccess ( 0 .. 1 ) {

        note("ProviderGenerateResponse() (Fail $Fail) (success $OptionSuccess)");

        for my $TestEntry (@PGRTestEntries) {

            subtest "$TestEntry->{Name} (Fail $Fail) (success $OptionSuccess)" => sub {
                my $WebException;
                my $CustomErrorMessage = 'this is a custom error message for HTTP::Test::ProviderGenerateResponse()';
                {
                    # discard Web::Request from OM to prevent errors
                    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

                    eval {
                        $TransportObject->ProviderGenerateResponse(
                            Success      => $OptionSuccess,
                            ErrorMessage => $CustomErrorMessage,
                            Data         => $TestEntry->{Data},
                        );
                    };
                    $WebException = $@;
                }

                ok( $WebException, 'always an exception on success' );
                isa_ok( $WebException, 'Kernel::System::Web::Exception' );
                can_ok( $WebException, ['as_psgi'], 'sane exception' );

                # the payload of the exception is a PSGI response
                my $PSGIResponse = $WebException->as_psgi();
                ok( $PSGIResponse, 'got a PSGI response' );
                ref_ok( $PSGIResponse,      'ARRAY', 'got array ref as PSGI response' );
                ref_ok( $PSGIResponse->[1], 'ARRAY', 'got array for the headers' );
                ref_ok( $PSGIResponse->[2], 'ARRAY', 'got array for the body' );

                if ( !$Fail && $TestEntry->{ResultSuccess} ) {

                    if ($OptionSuccess) {

                        # HTTP status 200 is expected
                        note('expecting a successful response');
                        is( $PSGIResponse->[0], 200, 'HTTP status 200' );

                        my $Body = join '', $PSGIResponse->[2]->@*;
                        $TestEntry->{ResponseData} //= {};

                        for my $QueryStringPart ( split /&/, $TestEntry->{ResultData} ) {
                            ok(
                                index( $Body, $QueryStringPart ) > -1,
                                "result body contains '$QueryStringPart'",
                            );
                        }
                    }
                    else {
                        # HTTP status 500 is expected
                        note('expecting a failing response');
                        is( $PSGIResponse->[0], 500,                   'HTTP status 500' );
                        is( $PSGIResponse->[2], [$CustomErrorMessage], 'custom error message' );
                    }
                }
                elsif ( $Fail && $TestEntry->{ResultSuccess} ) {

                    # HTTP::Test::ProviderGenerateResponse() return a web exception
                    # when Fail = 1 is set in the transporter config.

                    # HTTP status 500 is expected
                    note('expecting a failing response');
                    is( $PSGIResponse->[0], 500,                                 'HTTP status 500' );
                    is( $PSGIResponse->[2], ['Test response generation failed'], 'error message for Fail = 1' );
                }
                else {
                    # no success expected
                    isnt( $PSGIResponse->[0], 200, 'HTTP status is not 200' );
                    ok( scalar $PSGIResponse->[2]->@*, "error message found" );
                }
            };
        }
    }
}

done_testing();
