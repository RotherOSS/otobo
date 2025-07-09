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

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
$MainObject->Require("$Bin/OAuthProviderMock");

$OAuthProviderMock::KidID || $OAuthProviderMock::PrivateKey || 0;    # prevent warnings

#
# main test
#

# wait for the fake authorization server to come up
sleep 1;

my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
my $TokenObject       = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

# the OpenIDConfig we will use. This would normally come from SysConfig
my $OpenIDConfig = OAuthProviderMock::GetTestOpenIDConfig();

# make sure cache is clean for testing
$OIDCConfiguration->GetProviderData(
    OpenIDConfig => $OpenIDConfig,
    NoCache      => 1,
);

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();
$DBObject->BeginWork();

$CacheObject->CleanUp();

#
# create a JWT to test, sign using our private RSA key from above
#

my $Token = encode_jwt(
    payload       => OAuthProviderMock::Payload(),
    alg           => 'RS256',
    key           => $OAuthProviderMock::PrivateKey,
    extra_headers => { kid => $OAuthProviderMock::KidID },
);

# now validate this token, which will talk to our fake authorization server
# and fetch the public key to validate the signature

my $Result = $TokenObject->Validate(
    Token        => $Token,
    OpenIDConfig => $OpenIDConfig,
);

ok( $Result->{Success}, 'Token valid.' );

$Result = $TokenObject->Validate(
    Token          => $Token,
    OpenIDConfig   => $OpenIDConfig,
    ExpectedScopes => 'openid',
);

ok( $Result->{Success}, 'Token scope includes openid' );

$Result = $TokenObject->Validate(
    Token          => $Token,
    OpenIDConfig   => $OpenIDConfig,
    ExpectedScopes => 'openid roles',
);

ok( $Result->{Success}, 'Token scope includes openid and roles' );

$Result = $TokenObject->Validate(
    Token          => $Token,
    OpenIDConfig   => $OpenIDConfig,
    ExpectedScopes => 'openid2',
);

ok( !$Result->{Success}, 'Token scope does not include openid2' );

$Result = $TokenObject->Validate(
    Token           => $Token,
    OpenIDConfig    => $OpenIDConfig,
    AuthorizedParty => 'otobo',
);

ok( $Result->{Success}, 'Authorized party is otobo' );

$Result = $TokenObject->Validate(
    Token           => $Token,
    OpenIDConfig    => $OpenIDConfig,
    AuthorizedParty => 'unknown',
);
ok( !$Result->{Success}, 'Aurhorized party is not unknown.' );

$Result = $TokenObject->Validate(
    Token            => $Token,
    OpenIDConfig     => $OpenIDConfig,
    ExpectedAudience => 'otobo',
);
ok( $Result->{Success}, 'AAudience includes otobo' );

$Result = $TokenObject->Validate(
    Token            => $Token,
    OpenIDConfig     => $OpenIDConfig,
    ExpectedAudience => 'otobo2',
);
ok( !$Result->{Success}, 'AAudience does not include otobo2' );

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

# over and out
done_testing;

$DBObject->Rollback();
$CacheObject->CleanUp();

# tear down fake server
kill( 'TERM', $OAuthProviderMock::ChildPID );
waitpid( $OAuthProviderMock::ChildPID, 0 );

# patch sysconfig just for this process / request

sub PrepareTestSysConfig {

    # no op
    return;
}
