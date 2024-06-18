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
use LWP::UserAgent;
use CGI;
use Test2::V0;

# OTOBO modules
use Kernel::System::ObjectManager;
use Kernel::System::VariableCheck qw(IsHashRefWithData);

$Kernel::OM = Kernel::System::ObjectManager->new();

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my @Tests = (
    {
        Name             => 'HTTP request',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::Test',
                        MappingInbound => {
                            Type   => 'Test',
                            Config => {
                                TestOption => 'ToUpper',
                            }
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        RequestData => {
            A => 'A',
            b => 'b',
        },
        ResponseData => {
            A => 'A',
            b => 'B',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'HTTP request umlaut',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::Test',
                        MappingInbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        RequestData => {
            A => 'A',
            b => 'ö',
        },
        ResponseData => {
            A => 'A',
            b => 'ö',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'HTTP request Unicode',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::Test',
                        MappingInbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        RequestData => {
            A => 'A',
            b => '使用下列语言',
            c => 'Языковые',
            d => 'd',
        },
        ResponseData => {
            A => 'A',
            b => '使用下列语言',
            c => 'Языковые',
            d => 'd',
        },
        ResponseSuccess => 1,
    },
    {
        Name             => 'HTTP request without data',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::Test',
                        MappingInbound => {
                            Type => 'Test',
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        RequestData     => {},
        ResponseData    => {},
        ResponseSuccess => 0,
    },
    {
        Name             => 'HTTP request (invalid web service)',
        WebserviceConfig => {
            Debugger => {
                DebugThreshold => 'debug',
            },
            Provider => {
                Transport => {
                    Type   => 'HTTP::Test',
                    Config => {
                        Fail => 0,
                    },
                },
                Operation => {
                    test_operation => {
                        Type           => 'Test::Test',
                        MappingInbound => {
                            Type => 'Test',
                        },
                        MappingOutbound => {
                            Type => 'Test',
                        },
                    },
                },
            },
        },
        RequestData => {
            A => 'A',
            b => '使用下列语言',
            c => 'Языковые',
            d => 'd',
        },
        ResponseData      => {},
        ResponseSuccess   => 0,
        InvalidWebservice => 1,
    },
);

sub CreateQueryString {
    my %Param = @_;

    return '' unless IsHashRefWithData( $Param{Data} );

    my $QueryString = '';

    KEY:
    for my $Key ( sort keys %{ $Param{Data} } ) {
        if ($QueryString) {
            $QueryString .= ';';
        }
        $QueryString .= $Param{Encode} ? URI::Escape::uri_escape_utf8($Key) : $Key;

        next KEY if !$Param{Data}->{$Key};

        $QueryString
            .= '=' . ( $Param{Encode} ? URI::Escape::uri_escape_utf8( $Param{Data}->{$Key} ) : $Param{Data}->{$Key} );
    }

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$QueryString );

    return $QueryString;
}

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# create URL
my $ScriptAlias   = $ConfigObject->Get('ScriptAlias');
my $ApacheBaseURL = "http://$Host/${ScriptAlias}nph-genericinterface.pl/";
my $PlackBaseURL;
if ( $ConfigObject->Get('UnitTestPlackServerPort') ) {
    $PlackBaseURL = "http://localhost:"
        . $ConfigObject->Get('UnitTestPlackServerPort')
        . '/nph-genericinterface.pl/';
}

# get objects
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
my $ProviderObject   = $Kernel::OM->Get('Kernel::GenericInterface::Provider');
my $ValidObject      = $Kernel::OM->Get('Kernel::System::Valid');

my $InvalidID = $ValidObject->ValidLookup(
    Valid => 'invalid',
);

for my $Test (@Tests) {

    subtest "$Test->{Name} $RandomID" => sub {

        # add config
        my $WebserviceID = $WebserviceObject->WebserviceAdd(
            Config  => $Test->{WebserviceConfig},
            Name    => "$Test->{Name} $RandomID",
            ValidID => $Test->{InvalidWebservice} ? $InvalidID : 1,
            UserID  => 1,
        );

        ok( $WebserviceID, 'WebserviceAdd()' );

        my $WebserviceNameEncoded = URI::Escape::uri_escape_utf8("$Test->{Name} $RandomID");

        my %WebserviceAccess2PathInfo = (
            ID   => "WebserviceID/$WebserviceID",
            Name => "Webservice/$WebserviceNameEncoded"
        );

        # Test with IO redirection, no real HTTP request
        for my $RequestMethod (qw(get post)) {
            for my $WebserviceAccess ( sort keys %WebserviceAccess2PathInfo ) {
                my $PathInfo     = $WebserviceAccess2PathInfo{$WebserviceAccess};
                my $RequestData  = '';
                my $ResponseData = '';
                my $WebException;
                {
                    ## no critic (Perl::Critic::Policy::Variables::RequireLocalizedPunctuationVars)

                    # %ENV will be picked up in Kernel::System::Web::Request::new().
                    local %ENV;

                    if ( $RequestMethod eq 'post' ) {

                        # prepare CGI environment variables
                        $ENV{REQUEST_URI}    = "http://localhost/otobo/nph-genericinterface.pl/$PathInfo";
                        $ENV{REQUEST_METHOD} = 'POST';
                        $RequestData         = CreateQueryString(
                            Data   => $Test->{RequestData},
                            Encode => 0,
                        );
                        $ENV{CONTENT_LENGTH} = bytes::length($RequestData);
                    }
                    else {    # GET

                        my $QueryString = CreateQueryString(
                            Data   => $Test->{RequestData},
                            Encode => 1,
                        );

                        # prepare CGI environment variables
                        $ENV{REQUEST_URI}    = "http://localhost/otobo/nph-genericinterface.pl/$PathInfo?" . $QueryString;
                        $ENV{QUERY_STRING}   = $QueryString;
                        $ENV{REQUEST_METHOD} = 'GET';
                    }

                    $ENV{CONTENT_TYPE} = 'application/x-www-form-urlencoded; charset=utf-8;';

                    # redirect STDIN from String so that the transport layer will use this data
                    local *STDIN;
                    open STDIN, '<:encoding(UTF-8)', \$RequestData;    ## no critic qw(OTOBO::ProhibitOpen)

                    # force the ParamObject to use the new request params
                    CGI::initialize_globals();
                    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );
                    $Kernel::OM->ObjectParamAdd(
                        'Kernel::System::Web::Request' => {
                            WebRequest => CGI->new(),
                        }
                    );

                    eval {
                        $ResponseData = $ProviderObject->Content();
                    };
                    $WebException = $@;    # assign '' in case of success
                }

                ok( $WebException, 'always an exception' );
                isa_ok( $WebException, 'Kernel::System::Web::Exception' );
                if ( $Test->{ResponseSuccess} ) {

                    can_ok( $WebException, ['as_psgi'], 'sane exception' );

                    # status 200 is expected
                    my $PSGIResponse = $WebException->as_psgi();
                    ok( $PSGIResponse, 'got a PSGI response' );
                    ref_ok( $PSGIResponse, 'ARRAY', 'got array ref as PSGI response' );
                    is( $PSGIResponse->[0], 200, 'HTTP status 200' );
                    ref_ok( $PSGIResponse->[1], 'ARRAY', 'got array for the headers' );
                    ref_ok( $PSGIResponse->[2], 'ARRAY', 'got array for the body' );

                    my $Body = join '', $PSGIResponse->[2]->@*;
                    $Test->{ResponseData} //= {};
                    for my $Key ( sort keys $Test->{ResponseData}->%* ) {
                        my $QueryStringPart = URI::Escape::uri_escape_utf8($Key);
                        if ( $Test->{ResponseData}->{$Key} ) {
                            $QueryStringPart
                                .= '=' . URI::Escape::uri_escape_utf8( $Test->{ResponseData}->{$Key} );
                        }

                        ok(
                            index( $Body, $QueryStringPart ) > -1,
                            "$RequestMethod $PathInfo result body contains '$QueryStringPart'",
                        );
                    }
                }
                else {

                    ok( defined $WebException, 'exception when failure is expected' );
                    can_ok( $WebException, ['as_psgi'], 'sane exception when failure is expected' );

                    # status 500 is expected
                    my $PSGIResponse = $WebException->as_psgi();
                    ok( $PSGIResponse, 'got a PSGI response' );
                    ref_ok( $PSGIResponse, 'ARRAY', 'got array ref as PSGI response' );
                    is( $PSGIResponse->[0], 500, 'HTTP status 500' );
                }
            }
        }

        #
        # Test real HTTP request
        #
        for my $RequestMethod (qw(GET POST PATCH PUT)) {

            my @BaseURLs = ($ApacheBaseURL);
            if ($PlackBaseURL) {
                push @BaseURLs, $PlackBaseURL;
            }

            for my $BaseURL (@BaseURLs) {
                for my $WebserviceAccess ( sort keys %WebserviceAccess2PathInfo ) {
                    my $PathInfo = $WebserviceAccess2PathInfo{$WebserviceAccess};
                    my $URL      = $BaseURL . $PathInfo;
                    my $Response;
                    my $ResponseData;
                    my $QueryString = CreateQueryString(
                        Data   => $Test->{RequestData},
                        Encode => 1,
                    );

                    my $UserAgent = LWP::UserAgent->new;

                    if ( $RequestMethod eq 'GET' ) {
                        $URL .= "?$QueryString";
                        $Response = $UserAgent->get($URL);
                    }
                    elsif ( $RequestMethod eq 'POST' ) {
                        $Response = $UserAgent->post( $URL, Content => $QueryString );
                    }
                    else {    # PATCH, PUT

                        # LWP::UserAgent has no patch() or put() method, use the generic method request()
                        my $Request = HTTP::Request->new( $RequestMethod, $URL, [], $QueryString );
                        $Response = $UserAgent->request($Request);
                    }
                    chomp( $ResponseData = $Response->decoded_content() );

                    if ( $Test->{ResponseSuccess} ) {
                        for my $Key ( sort keys %{ $Test->{ResponseData} || {} } ) {
                            my $QueryStringPart = URI::Escape::uri_escape_utf8($Key);
                            if ( $Test->{ResponseData}->{$Key} ) {
                                $QueryStringPart
                                    .= '='
                                    . URI::Escape::uri_escape_utf8( $Test->{ResponseData}->{$Key} );
                            }

                            ok(
                                index( $ResponseData, $QueryStringPart ) > -1,
                                "$PathInfo real HTTP $RequestMethod request (needs configured and running webserver) result data contains $QueryStringPart ($URL)",
                            );
                        }

                        is(
                            $Response->code(),
                            200,
                            "$PathInfo real HTTP $RequestMethod request (needs configured and running webserver) result success status ($URL)",
                        );
                    }
                    else {
                        is(
                            $Response->code(),
                            500,
                            "$PathInfo real HTTP $RequestMethod request (needs configured and running webserver) result error status ($URL)",
                        );
                    }
                }
            }
        }

        # delete webservice
        my $Success = $WebserviceObject->WebserviceDelete(
            ID     => $WebserviceID,
            UserID => 1,
        );
        ok( $Success, "WebserviceDelete()" );
    };
}

# Test non existing web service
for my $RequestMethod (qw(get post)) {

    my $URL      = $ApacheBaseURL . 'undefined';
    my $Response = LWP::UserAgent->new()->$RequestMethod($URL);

    is(
        $Response->code(),
        500,
        "Non existing web service real HTTP $RequestMethod request result error status ($URL)",
    );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

done_testing();
