# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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
use Test2::V0;
use CGI;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport;

our $Self;

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

    note("RequesterPerformRequest() (Fail $Fail)");

    for my $TestEntry (@RPRTestData) {

        subtest "$TestEntry->{Name} (Fail $Fail)" => sub {

            # discard Web::Request from OM to prevent errors
            $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

            my $Result = $TransportObject->RequesterPerformRequest(
                Operation => $TestEntry->{Operation},
                Data      => $TestEntry->{Data},
            );

            if ( !$Fail && $TestEntry->{ResultSuccess} ) {
                $Self->True(
                    $Result->{Success},
                    "success",
                );

                for my $QueryStringPart ( split m{&}, $TestEntry->{ResultData} ) {
                    $Self->True(
                        index( $Result->{Data}->{ResponseContent}, $QueryStringPart ) > -1,
                        "result contains $QueryStringPart",
                    );
                }
            }
            else {
                $Self->False(
                    $Result->{Success},
                    "fail detected",
                );

                $Self->True(
                    $Result->{ErrorMessage},
                    "error message found",
                );
            }
        };
    }

    #
    # ProviderProcessRequest()
    #

    my @PPRTestData = (
        {
            Name           => "TransportObject ProviderProcessRequest()",
            RequestContent => 'A=A',
            ResultData     => {
                A => 'A',
            },
            Operation     => 'test_operation',
            ResultSuccess => 1,
        },
        {
            Name           => "TransportObject ProviderProcessRequest()",
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

            my ( $Result, $WebException );
            {
                # prepare CGI environment variables
                # %ENV will be picked up in CGI->new()
                local $ENV{REQUEST_METHOD} = 'POST';
                local $ENV{CONTENT_LENGTH} = length( $TestEntry->{RequestContent} );
                local $ENV{CONTENT_TYPE}   = 'application/x-www-form-urlencoded; charset=utf-8;';

                $EncodeObject->EncodeOutput( \$TestEntry->{RequestContent} );

                # redirect STDIN from String so that the transport layer will use this data
                local *STDIN;
                open STDIN, '<:encoding(UTF-8)', \$TestEntry->{RequestContent};    ## no critic qw(OTOBO::ProhibitOpen)

                # force the ParamObject to use the new request params
                CGI::initialize_globals();
                $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );
                $Kernel::OM->ObjectParamAdd(
                    'Kernel::System::Web::Request' => {
                        WebRequest => CGI->new(),
                    }
                );

                $Result = eval {
                    $TransportObject->ProviderProcessRequest();
                };
                $WebException = $@;
            }

            if ( !$Fail && $TestEntry->{ResultSuccess} ) {
                is( $WebException, '', 'no exception' );

                $Self->True(
                    $Result->{Success},
                    "success",
                );

                $Self->Is(
                    $Result->{Operation},
                    $TestEntry->{Operation},
                    "operation",
                );

                $Self->IsDeeply(
                    $Result->{Data},
                    $TestEntry->{ResultData},
                    "data result",
                );
            }
            else {
                $Self->False(
                    $Result->{Success},
                    "fail detected",
                );

                $Self->True(
                    $Result->{ErrorMessage},
                    "error message found",
                );
            }

            #use Data::Dumper;
            #warn Dumper( 'YYY', $WebException, $Result );
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
                my $Response = '';
                my $Result;
                my $WebException;
                my $CustomErrorMessage = 'this is a custom error message for HTTP::Test::ProviderGenerateResponse()';
                {
                    # discard Web::Request from OM to prevent errors
                    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );

                    $Result = eval {
                        $TransportObject->ProviderGenerateResponse(
                            Success      => $OptionSuccess,
                            ErrorMessage => $CustomErrorMessage,
                            Data         => $TestEntry->{Data},
                        );
                    };
                    $WebException = $@;
                    $Response     = delete $Result->{Output} if ref $Result eq 'HASH';
                }

                if ( !$Fail && $TestEntry->{ResultSuccess} ) {

                    if ($OptionSuccess) {
                        ok("success");

                        $Self->True(
                            index( $Response, '200 OK' ) > -1,
                            "result status 200",
                        );

                        for my $QueryStringPart ( split m{&}, $TestEntry->{ResultData} ) {
                            $Self->True(
                                index( $Response, $QueryStringPart ) > -1,
                                "result",
                            );
                        }
                    }
                    else {

                        # HTTP::Test::ProviderGenerateResponse() return a web exception
                        # when Success = 0 is passed
                        is( $Result, undef, 'no result as exception is thrown' );
                        my $PSGIResponse = $WebException->as_psgi;
                        is( $PSGIResponse->[0], 500,                   'HTTP status 500' );
                        is( $PSGIResponse->[2], [$CustomErrorMessage], 'custom error message' );
                    }
                }
                elsif ( $Fail && $TestEntry->{ResultSuccess} ) {

                    # HTTP::Test::ProviderGenerateResponse() return a web exception
                    # when Fail = 1 is set in the transporter config.
                    is( $Result, undef, 'no result as exception is thrown' );
                    my $PSGIResponse = $WebException->as_psgi;
                    is( $PSGIResponse->[0], 500,                                 'HTTP status 500' );
                    is( $PSGIResponse->[2], ['Test response generation failed'], 'error message for Fail = 1' );
                    use Data::Dumper;
                    warn Dumper( 'KKK', $Fail, $OptionSuccess, $TestEntry, $Result, $WebException );
                }
                else {
                    use Data::Dumper;
                    warn Dumper( 'LLL', $Fail, $OptionSuccess, $TestEntry, $Result, $WebException );
                    $Self->False(
                        $Result->{Success},
                        "fail detected",
                    );

                    $Self->True(
                        $Result->{ErrorMessage},
                        "error message found",
                    );
                }
            };
        }
    }
}

done_testing();
