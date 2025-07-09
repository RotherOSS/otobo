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

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
$MainObject->Require("$Bin/OAuthProviderMock");

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();

my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $TokenProvider     = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenProvider');
my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');

$DBObject->BeginWork();

my $BaseURL     = 'http://localhost:2007/realms/master/protocol/openid-connect/auth';
my $RedirectURI = 'https://your.otobo.url/otobo/index.pl?Action=AdminOAuthTokenStore&Subaction=OAuth';

my $TestCases = [
    {
        Config => {
        },
        Expectation => '?response_type=code&scope=openid&client_id=otobo&state=',
    },
    {
        Config => {
            Scope => 'openid email profile http://weirdscope.com',
        },
        Expectation => '?response_type=code&scope=openid%20email%20profile%20http%3A%2F%2Fweirdscope.com&client_id=otobo&state=',
    },
    {
        Config => {
            Resources => 'someapi http://weirdresource.com',
        },
        Expectation => '?response_type=code&scope=openid&client_id=otobo&resource=someapi%20http%3A%2F%2Fweirdresource.com&state=',
    },
    {
        Config => {
            Token => 'id_token',
        },
        Expectation => '?response_type=code&scope=openid&client_id=otobo&state=',
    },
    {
        Config => {
            Login => 'someone@somedomain.com',
        },
        Expectation => '?response_type=code&scope=openid&client_id=otobo&login_hint=someone%40somedomain.com&state=',
    },
    {
        Config => {
            Prompt => 1,
        },
        Expectation => '?response_type=code&scope=openid&client_id=otobo&prompt=login&state=',
    },
];

my $OpenIDConfig = OAuthProviderMock::GetTestOpenIDConfig();

eval {

    $CacheObject->CleanUp();

    for my $TestCase (@$TestCases) {

        PrepareTestSysConfig( $TestCase->{Config}->%* );

        my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
            Length => 22
        );

        my $Expected = $BaseURL . $TestCase->{Expectation};
        $Expected .= $RandomString;
        $Expected .= '&redirect_uri=';
        $Expected .= uri_escape_utf8($RedirectURI);

        my $AuthURL = $TokenProvider->GetAuthURL(
            AccountName => '_UnitTest1',
            RedirectURI => $RedirectURI,
            State       => $RandomString,
            Login       => $TestCase->{Config}->{Login},
            Prompt      => $TestCase->{Config}->{Prompt},
        );

        ok( $AuthURL eq $Expected, "$AuthURL eq $Expected" );

    }
};
if ($@) {
    print STDERR $@ . "\n";
    ok( 0, 'should not throw' );
}

$DBObject->Rollback();
$CacheObject->CleanUp();

done_testing;

# tear down fake server
kill( 'TERM', $OAuthProviderMock::ChildPID );
waitpid( $OAuthProviderMock::ChildPID, 0 );

# patch sysconfig just for this process / request

sub PrepareTestSysConfig {

    my %Param = @_;

    # create profile

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    my $Valid = 1;

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

    my ($ID) = $DBObject->FetchrowArray();

    # create functional account

    my $GrantType         = $Param{GrantType}         || 'authorization_code';
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
    #             GrantType         => $Param{GrantType}         || 'authorization_code',
    #             Scope             => $Param{Scope}             || 'openid',
    #             Resources         => $Param{Resources}         || '',
    #             ResourceParamName => $Param{ResourceParamName} || 'resource',
    #             Token             => $Param{Token}             || 'access_token',
    #             Username          => $Param{Username},
    #             Password          => $Param{Password},
    #         }
    #     },
    # );

    return;
}
