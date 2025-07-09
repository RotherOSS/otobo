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

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();
$DBObject->BeginWork();

#
# main test
#

# wait for the fake authorization server to come up
sleep 1;

my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $TokenProvider     = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenProvider');
my $TokenRepository   = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');
my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
my $TokenObject       = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

# the OpenIDConfig we will use. This would normally come from SysConfig
my $OpenIDConfig = OAuthProviderMock::GetTestOpenIDConfig();

eval {

    $CacheObject->CleanUp();

    # make sure cache is clean for testing
    $OIDCConfiguration->GetProviderData(
        OpenIDConfig => $OpenIDConfig,
        NoCache      => 1,
    );
    Cleanup();

    #
    # Fetch a Token from token_endpoint and validate it
    #

    # patch sysconfig just for this process / request
    PrepareTestSysConfig(
        Resources => 'some_api',

        #        GrantType => 'password',
        #        Username => 'test'
    );

    # use TokenProvider to fetch a Token for the configured unit test account

    # 1) fetch a fresh token
    my $Result = $TokenProvider->Fetch(
        AccountName => '_UnitTest1',
    );

    ok( $Result->{Success},                 "Result is Success" );
    ok( $Result->{Origin} eq 'fresh_token', 'Origin is fresh_token.' );

    my $Token = $Result->{Token};

    # validate it, one last time
    $Result = $TokenObject->Validate(
        Token        => $Token,
        OpenIDConfig => $OpenIDConfig,
    );
    ok( $Result->{Success}, "Result is Success" );

    # 2) fetch again, now comes from cache
    $Result = $TokenProvider->Fetch(
        AccountName => '_UnitTest1',
    );

    ok( $Result->{Success},           "Result is Success" );
    ok( $Result->{Origin} eq 'cache', 'Origin is cache' );

    # 3) clean cache, now comes from DB
    CleanupCache();

    $Result = $TokenProvider->Fetch(
        AccountName => '_UnitTest1',
    );

    ok( $Result->{Success},        "Result is Success" );
    ok( $Result->{Origin} eq 'db', 'Origin is db.' );

    # 3) clean cache and DB, now using refresh_token
    CleanupCache();
    my $DeleteSuccess = $TokenRepository->DeleteToken(
        AccountName => '_UnitTest1',
        TokenType   => 'access_token',
    );
    ok( $DeleteSuccess, 'DELETE FAILED' );

    $Result = $TokenProvider->Fetch(
        AccountName => '_UnitTest1',
    );

    ok( $Result->{Success},                   "Result is Success" );
    ok( $Result->{Origin} eq 'refresh_token', 'Origin is refresh_token' );

    # 4) clean cache,DB and refresh_token -

    Cleanup();
    $Result = $TokenProvider->Fetch(
        AccountName => '_UnitTest1',
    );

    ok( $Result->{Success},                 "Result is Success" );
    ok( $Result->{Origin} eq 'fresh_token', 'Origin is fresh_token' );

    #
    # invalid credentials
    #

    Cleanup();
    $OpenIDConfig->{ClientSettings}->{ClientSecret} = 'murks';
    PrepareTestSysConfig(
        Resources => 'some_api',
    );

    $Result = $TokenProvider->Fetch(
        AccountName => '_UnitTest1',
    );

    ok( !$Result->{Success} );

    #
    # Test 4) - Assert on the spied Log of our fake server
    # here we can assert that parameters have been passed as
    # expected to the token_endpoint
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
                "endpoint" => "token",
                "content"  => "grant_type=client_credentials&resource=some_api&scope=openid"
            },
            {
                "endpoint" => "openid",
                "content"  => ""
            },
            {
                "endpoint" => "jwks",
                "content"  => ""
            },
            {
                "content"  => "grant_type=refresh_token&refresh_token=",
                "endpoint" => "token",
                operator   => 'match'
            },
            {
                "endpoint" => "openid",
                "content"  => ""
            },
            {
                "endpoint" => "jwks",
                "content"  => ""
            },
            {
                "endpoint" => "token",
                "content"  => "grant_type=client_credentials&resource=some_api&scope=openid"
            },
            {
                "endpoint" => "openid",
                "content"  => ""
            },
            {
                "endpoint" => "jwks",
                "content"  => ""
            },
            {
                "content"  => "grant_type=client_credentials&resource=some_api&scope=openid",
                "endpoint" => "token"
            },
        ]
    );
};
if ($@) {
    print STDERR "$@\n";
    ok( 0, "should not htow." );
}

# over and out
done_testing;

Cleanup();

$DBObject->Rollback();
$CacheObject->CleanUp();

# tear down fake server
kill( 'TERM', $OAuthProviderMock::ChildPID );
waitpid( $OAuthProviderMock::ChildPID, 0 );

# patch sysconfig just for this process / request

sub PrepareTestSysConfig {

    my %Param = @_;

    # create profile

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my $Valid = 1;

    $DBObject->Prepare(
        SQL => "SELECT id FROM oidc_functional_accounts WHERE name = '_UnitTest1' ",

        #            Bind  => [ \$OpenIDConfig->{ProviderSettings}->{Name} ],
        #            Limit => 1
    );

    my ($ID) = $DBObject->FetchrowArray();

    if ($ID) {
        $DBObject->Do( SQL => "DELETE FROM oauth2_token_storage WHERE oidc_functional_account_id = " . $ID );
    }
    $DBObject->Do( SQL => "DELETE FROM oidc_functional_accounts WHERE name = '_UnitTest1' " );
    $DBObject->Do( SQL => "DELETE FROM oidc_profiles WHERE name = '" . $OpenIDConfig->{ProviderSettings}->{Name} . "'" );

    $DBObject->Do(
        SQL => "INSERT INTO oidc_profiles
                ( name,client_id,client_Secret,redirect_uri,openid_config,
                ssl_options,misc,ttl,valid_id,
                create_time,create_by,change_time,change_by )
                VALUES (?, ?, ?, ?,?, ?, ?, ?, ?, current_timestamp, 1, current_timestamp, 1)",
        Bind => [
            \$OpenIDConfig->{ProviderSettings}->{Name},
            \$OpenIDConfig->{ClientSettings}->{ClientID},
            \$OpenIDConfig->{ClientSettings}->{ClientSecret},
            \$OpenIDConfig->{ClientSettings}->{RedirectURI} // '',
            \$OpenIDConfig->{ProviderSettings}->{OpenIDConfiguration},
            \$YAMLObject->Dump( Data => $OpenIDConfig->{ProviderSettings}->{SSLOptions} ),
            \$YAMLObject->Dump( Data => $OpenIDConfig->{Misc} // {} ),
            \$OpenIDConfig->{ProviderSettings}->{TTL},
            \$Valid,
        ],
    );

    $DBObject->Prepare(
        SQL  => "SELECT id FROM oidc_profiles WHERE name = ? ",
        Bind => [ \$OpenIDConfig->{ProviderSettings}->{Name} ],

        #            Limit => 1
    );

    ($ID) = $DBObject->FetchrowArray();

    # create functional account

    my $GrantType         = $Param{GrantType}         || 'client_credentials';
    my $Scope             = $Param{Scope}             || 'openid';
    my $Resources         = $Param{Resources}         || '';
    my $ResourceParamName = $Param{ResourceParamName} || 'resource';
    my $TokenType         = $Param{Token}             || 'access_token';

    $DBObject->Do(
        SQL => "INSERT INTO oidc_functional_accounts
                (name, oidc_profile_id,grant_type,scopes,resources,
                resource_param_name,username,passwd, token_type, valid_id,
                create_time,create_by,change_time,change_by )
                VALUES ( '_UnitTest1', ?, ?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, 1, current_timestamp, 1)",
        Bind => [
            \$ID,
            \$GrantType,
            \$Scope,
            \$Resources,
            \$ResourceParamName,
            \$Param{Username},
            \$Param{Password},
            \$TokenType,
            \$Valid,
        ],
    );

    return;
}

sub Cleanup {

    # cleanup cache and db
    $TokenRepository->DeleteToken(
        AccountName => '_UnitTest1',
    );

    CleanupCache();

    return;
}

sub CleanupCache {

    $TokenProvider->EmptyCache(
        AccountName => '_UnitTest1',
    );

    return;
}
