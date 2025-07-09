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

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
$MainObject->Require("$Bin/OAuthProviderMock");

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();
$DBObject->BeginWork();

#
# main test
#

# wait for the fake authorization server to come up
sleep 1;

my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $TokenProvider     = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenProvider');
my $TokenRepository   = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');
my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');

# the OpenIDConfig we will use. This would normally come from SysConfig
my $OpenIDConfig = OAuthProviderMock::GetTestOpenIDConfig();

# Test Permutations
my @TestScopes = (
    '',
    'openid',
    'openid email profiles',
    'openid http://wild.scope.org',
);

my @TestResources = (
    '',
    'someapi',
    'someapi otherapi',
    'someapi http://wild.resource.org/',
);

my @TestResourceParamNames = (
    '',
    'resource',
    'resources',
    'resourceIds',
);

my @TokenType = (
    'access_token',
    'id_token',
);

# Main Test Cases
my $TestCases = [
    {
        GrantType => 'client_credentials',
        Expected  => [
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
                "content"  => "grant_type=client_credentials"
            },
        ]
    },
    {
        GrantType => 'password',
        Username  => 'test1@example.com',
        Password  => 'test',
        Expected  => [
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
                "content"  => "grant_type=password&username=test1%40example.com&password=test"
            },
        ]
    },
    {
        GrantType => 'authorization_code',
        Expected  => [

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
                "content"  => "grant_type=authorization_code&code=COFFFEEBABECOFFEE&redirect_uri=http%3A%2F%2Fsomewhere.com%2F"
            },
        ]
    },
];

eval {

    $CacheObject->CleanUp();

    # make sure cache is clean for testing
    $OIDCConfiguration->GetProviderData(
        OpenIDConfig => $OpenIDConfig,
        NoCache      => 1,
    );

    # OAuthProviderMock::AssertHttpCallLog( Expected => [

    #         {
    #             "endpoint" => "openid",
    #             "content"  => ""
    #         },
    #         {
    #             "endpoint" => "jwks",
    #             "content"  => ""
    #         },
    # ]);

    # iterate!
    for my $TestCase (@$TestCases) {
        for my $Resources (@TestResources) {
            for my $ResourceParamName (@TestResourceParamNames) {
                for my $Scope (@TestScopes) {
                    for my $TokenType (@TokenType) {

                        Cleanup();

                        # patch sysconfig just for this process / request
                        PrepareTestSysConfig(
                            %$TestCase,
                            Scope             => $Scope,
                            Resources         => $Resources,
                            ResourceParamName => $ResourceParamName,
                            Token             => $TokenType,
                        );

                        # use TokenProvider to fetch a Token for the configured unit test account

                        if ( $TestCase->{GrantType} ne 'authorization_code' ) {
                            my $Result = $TokenProvider->Fetch(
                                AccountName => '_UnitTest1',
                            );
                            ok( $Result->{Success},                 "Result is Success." );
                            ok( $Result->{Origin} eq 'fresh_token', "Origin is fresh_token." );
                        }
                        else {

                            # this is authorization_flow, initial token can only be fetched
                            # with the 'code' received through the brwoser flow
                            my $Result = $TokenProvider->FetchToken(
                                AccountName => '_UnitTest1',
                                Code        => 'COFFFEEBABECOFFEE',
                                RedirectURL => 'http://somewhere.com/'
                            );

                            ok( $Result->{Success} );
                            ok( $Result->{Origin} eq 'fresh_token' );

                            # once we have it, it can be retreived from cache as usual
                            $Result = $TokenProvider->Fetch(
                                AccountName => '_UnitTest1',
                            );
                            ok( $Result->{Success},           "Result is Success." );
                            ok( $Result->{Origin} eq 'cache', "Origin is cache" );
                        }

                        # patch up Expected Content dynamically with
                        # scope, resource parameters, for various
                        # 'resource parameter names'
                        my $ExpectedContent = '';

                        if ($Resources) {
                            my $ResourceParam = $ResourceParamName || 'resource';
                            $ExpectedContent .= "&$ResourceParam=" . uri_escape_utf8($Resources);
                        }
                        if ($Scope) {
                            $ExpectedContent .= "&scope=" . uri_escape_utf8($Scope);
                        }
                        else {
                            $ExpectedContent .= "&scope=openid";
                        }

                        # impl actually produces '+* instead of '%20', fix that
                        $ExpectedContent =~ s/%20/+/g;

                        # build an Expectation array from the TestCase template
                        # for this permutation
                        my @Expected;
                        for my $Expectation ( $TestCase->{Expected}->@* ) {
                            push @Expected, {
                                'content' => $Expectation->{endpoint} eq 'token'
                                ?
                                    $Expectation->{content} . $ExpectedContent
                                :
                                    $Expectation->{content},
                                'endpoint' => $Expectation->{endpoint},
                                'operator' => $Expectation->{operator},
                            };
                        }

                        OAuthProviderMock::AssertHttpCallLog( Expected => \@Expected );
                    }
                }
            }
        }
    }
};
if ($@) {
    print STDERR $@ . "\n";
    ok( 0, "should not throw." );
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

    # # configure an OIDC Profile for the unit test
    # $ConfigObject->Set(
    #     Key   => 'OpenIDConnect::OICDProvider::_UnitTest1',
    #     Value => $OpenIDConfig,
    # );

    # # configure a functional account that uses above config
    # $ConfigObject->Set(
    #     Key   => 'OpenIDConnect::FunctionalAccounts',
    #     Value => {
    #         '_UnitTest1' => {

    #             OpenIDConfig      => 'OpenIDConnect::OICDProvider::_UnitTest1',
    #             GrantType         => $Param{GrantType} || 'client_credentials',
    #             Scope             => $Param{Scope}     || 'openid',
    #             Resources         => $Param{Resources},
    #             ResourceParamName => $Param{ResourceParamName} || 'resource',
    #             Token             => $Param{Token}             || 'access_token',
    #             Username          => $Param{Username},
    #             Password          => $Param{Password},
    #         }
    #     },
    # );

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
