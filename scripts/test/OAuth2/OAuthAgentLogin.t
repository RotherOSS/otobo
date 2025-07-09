# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use FindBin qw($Bin);

# CPAN modules
use Test2::V0;
use Crypt::JWT qw(encode_jwt decode_jwt);
use Crypt::PK::RSA;
use Plack::Runner;
use Plack::Request;
use Try::Tiny qw(try catch);
use JSON;
use URI::Escape qw(uri_escape_utf8);
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
$MainObject->Require("$Bin/OAuthProviderMock");

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0
);

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

$DBObject->BeginWork();

my $UserObject = $Kernel::OM->Get('Kernel::System::User');

$UserObject->UserAdd(
    UserFirstname => 'Manfred',
    UserLastname  => 'Müller',
    UserLogin     => 'test1@example.com',
    UserPassword  => 'some-pass',
    UserEmail     => 'test1@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

$UserObject->UserAdd(
    UserFirstname => 'Manfred',
    UserLastname  => 'Huber',
    UserLogin     => '1f60c6d9-aaa4-4db1-aa8d-94091c8acc43',
    UserPassword  => 'some-pass',
    UserEmail     => 'test2@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

my $BaseURL = 'http://localhost:2007/realms/master/protocol/openid-connect/auth';

my $TestCases = [
    {
        Config => {
            Scope => [
                qw/profile email roles/
            ]
        },
        Expectation => '1f60c6d9-aaa4-4db1-aa8d-94091c8acc43',
    },
    {
        Config => {
            Scope => [
            ]
        },
        Expectation => '1f60c6d9-aaa4-4db1-aa8d-94091c8acc43',
    },
    {
        Config => {
            Sub => 'email'
        },
        Expectation => 'test1@example.com',
    },
    {
        Config => {
            ClientSecret => 'wrong-secret'
        },
        Expectation => undef,
    },
    {
        Config => {
            Code  => 'wrong-code',
            Scope => [
                qw/profile email roles/
            ]
        },
        Expectation => undef,
    },
    {
        Config => {
            State => 'wrong-state',
            Scope => [
                qw/profile email roles/
            ]
        },
        Expectation => undef,
    },
];

eval {

    $CacheObject->CleanUp();

    for my $TestCase (@$TestCases) {

        PrepareTestSysConfig( $TestCase->{Config}->%* );

        my $BackendObject = $Kernel::OM->Get('Kernel::System::Auth::OpenIDConnect');

        # preauth will return redirect to OIDC provider
        my $PreAuthResult = $BackendObject->PreAuth();

        # simulate a login at the OIDC provider
        my $UA = LWP::UserAgent->new;
        $UA->agent("UnitTest/0.1 ");

        my $Req = HTTP::Request->new( Get => $PreAuthResult->{RedirectURL} );
        my $Res = $UA->request($Req);

        if ( $Res->code == '302' ) {
            ok( 1, "preauth req success" );
        }
        else {
            ok( 0, "preauth request fail" );
        }

        # on successful login, we will get another rediredt back to otobo

        my $Headers  = $Res->headers;
        my $Location = $Headers->{location};

        # parse the query parameters of the redirect url
        my $URI   = URI->new($Location);
        my %Query = $URI->query_form;

        my $State = $TestCase->{Config}->{State} || $Query{state};
        my $Code  = $TestCase->{Config}->{Code}  || $Query{code};

        # now prepare a unitest mock HTTP request that will be consumed
        # by $BackendObject->Auth()
        my $HTTPRequest = POST(
            $BaseURL,
            [
                grant_type   => 'authorization_code',
                code         => $Code,
                state        => $State,
                redirect_uri => $PreAuthResult->{RedirectURL},
            ],
            Cookie => "OIDCCSRF-$State=$State;",
        );

        # force the ParamObject to use the new request params
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Web::Request'] );
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::Web::Request' => { HTTPRequest => $HTTPRequest }
        );

        # finally do the auth
        my $AuthResult = $BackendObject->Auth();

        # on success, Auth() will return the UserLogin as per 'Sub' mapping
        if ( defined $TestCase->{Expectation} ) {

            ok( $AuthResult && $AuthResult eq $TestCase->{Expectation}, "user authenticated ($AuthResult)" );
        }
        else {

            ok( !defined $AuthResult, "user auth failed" );
        }
    }
};
if ($@) {
    print STDERR $@ . "\n";
    ok( 0, 'should not throw' );
}

ok( 1, "finished without exception" );

$DBObject->Rollback();
$CacheObject->CleanUp();

done_testing;

# tear down fake server
kill( 'TERM', $OAuthProviderMock::ChildPID );
waitpid( $OAuthProviderMock::ChildPID, 0 );

# patch sysconfig just for this process / request

sub PrepareTestSysConfig {

    my %Param = @_;

    my $Sub   = $Param{Sub}   || 'sub';
    my $Scope = $Param{Scope} || [
        qw/profile email roles/
    ];

    my $ClientSecret = $Param{ClientSecret};

    # create tmp OIDC config

    $ConfigObject->Set(
        Key   => 'AuthModule',
        Value => 'Kernel::System::Auth::OpenIDConnect'
    );
    $ConfigObject->Set(
        Key   => 'AuthModule::OpenIDConnect::AuthRequest',
        Value => {
            ResponseType    => ['code'],
            AdditionalScope => $Scope,
        }
    );

    my $OpenIDConfig = OAuthProviderMock::GetTestOpenIDConfig();
    if ($ClientSecret) {
        $OpenIDConfig->{ClientSettings}->{ClientSecret} = $ClientSecret;
    }

    $ConfigObject->Set(
        Key   => 'AuthModule::OpenIDConnect::Config',
        Value => $OpenIDConfig
    );

    $ConfigObject->Set(
        Key   => 'AuthModule::OpenIDConnect::UID',
        Value => $Sub
    );

    return;
}
