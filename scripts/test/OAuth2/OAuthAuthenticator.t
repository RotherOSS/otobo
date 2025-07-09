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

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');
$MainObject->Require("$Bin/OAuthProviderMock");

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();
$DBObject->BeginWork();

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

# test user

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0
);

my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my $UserObject = $Kernel::OM->Get('Kernel::System::User');
$UserObject->UserAdd(
    UserFirstname => 'Manfred',
    UserLastname  => 'Huber',
    UserLogin     => '1f60c6d9-aaa4-4db1-aa8d-94091c8acc43',
    UserPassword  => 'some-pass',
    UserEmail     => 'test2@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

#
# main test
#

# wait for the fake authorization server to come up
sleep 1;

my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
my $Authenticator     = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Authenticator');

# the OpenIDConfig we will use. This would normally come from SysConfig
my $OpenIDConfig = OAuthProviderMock::GetTestOpenIDConfig();

eval {

    $CacheObject->CleanUp();

    # make sure cache is clean for testing
    $OIDCConfiguration->GetProviderData(
        OpenIDConfig => $OpenIDConfig,
        NoCache      => 1,
    );

    PrepareTestSysConfig();

    #
    # 1) Simple JWT
    #

    my $Token = encode_jwt(
        payload       => OAuthProviderMock::Payload(),
        alg           => 'RS256',
        key           => $OAuthProviderMock::PrivateKey,
        extra_headers => { kid => $OAuthProviderMock::KidID },
    );

    # now validate this token, which will talk to our fake authorization server
    # and fetch the public key to validate the signature

    my $Result = $Authenticator->Authenticate(
        Token => $Token,
    );

    ok( $Result->{Success}, 'Authenticated' );

    #
    # 2) Simple JWT with dedicated scopes
    #

    PrepareTestSysConfig(
        Scope => 'openid superduper',
    );

    $Token = encode_jwt(
        payload       => OAuthProviderMock::Payload( Scope => 'openid superduper' ),
        alg           => 'RS256',
        key           => $OAuthProviderMock::PrivateKey,
        extra_headers => { kid => $OAuthProviderMock::KidID },
    );

    # now validate this token, which will talk to our fake authorization server
    # and fetch the public key to validate the signature

    $Result = $Authenticator->Authenticate(
        Token => $Token,
    );

    ok( $Result->{Success}, 'Authenticated' );

    #
    # 3) Simple JWT with dedicated audience check
    #

    PrepareTestSysConfig(
        Audience => 'otobo',
    );

    $Token = encode_jwt(
        payload       => OAuthProviderMock::Payload( Audience => [ 'otobo', 'mammamia' ] ),
        alg           => 'RS256',
        key           => $OAuthProviderMock::PrivateKey,
        extra_headers => { kid => $OAuthProviderMock::KidID },
    );

    # now validate this token, which will talk to our fake authorization server
    # and fetch the public key to validate the signature

    $Result = $Authenticator->Authenticate(
        Token => $Token,
    );

    ok( $Result->{Success}, 'Authenticated' );

    #
    # 4) Simple JWT with Authorized Party check
    #

    PrepareTestSysConfig(
        AuthorizedParty => 'otobo',
    );

    $Token = encode_jwt(
        payload       => OAuthProviderMock::Payload(),
        alg           => 'RS256',
        key           => $OAuthProviderMock::PrivateKey,
        extra_headers => { kid => $OAuthProviderMock::KidID },
    );

    # now validate this token, which will talk to our fake authorization server
    # and fetch the public key to validate the signature

    $Result = $Authenticator->Authenticate(
        Token => $Token,
    );

    ok( $Result->{Success}, 'Authenticated' );

    #
    # assert on the spy log
    #

    OAuthProviderMock::AssertHttpCallLog(
        Expected => [
            {
                "endpoint" => "openid",
                "content"  => ""
            },
            {
                "endpoint" => "jwks",
                "content"  => ""
            },
        ]
    );
};
if ($@) {
    print STDERR "$@\n";
    ok( 0, "should not throw." );
}

$DBObject->Rollback();
$CacheObject->CleanUp();

# over and out
done_testing;

# tear down fake server
kill( 'TERM', $OAuthProviderMock::ChildPID );
waitpid( $OAuthProviderMock::ChildPID, 0 );

# patch sysconfig just for this process / request

sub PrepareTestSysConfig {

    my %Param = @_;

    # configure an OIDC Profile for the unit test
    $ConfigObject->Set(
        Key   => 'AuthModule::_UnitTest1::Config',
        Value => $OpenIDConfig,
    );

    $ConfigObject->Set(
        Key   => 'AuthModule',
        Value => 'Kernel::System::Auth::_UnitTest1',
    );

    return;
}
