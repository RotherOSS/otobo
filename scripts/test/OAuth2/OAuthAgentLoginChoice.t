# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

use FindBin qw($Bin);
use lib "$Bin/../../..";

use Digest::SHA           qw(sha256);
use HTTP::Request::Common qw(GET POST);
use JSON                  qw(decode_json);
use LWP::UserAgent;
use MIME::Base64 qw(encode_base64);
use Plack::Middleware::HTTPExceptions;
use Plack::Test qw(test_psgi);
use Test2::V0;
use URI;
use URI::Escape qw(uri_escape_utf8 uri_unescape);
use Kernel::System::Auth;
use Kernel::System::Auth::OpenIDConnect;
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM
use Kernel::System::Web::InterfaceAgent ();

{
    my $StateRandom  = 's' x 22;
    my $CodeVerifier = 'v' x 64;
    my $NonceRandom  = 'n' x 22;
    my $RequestedURL = 'Action=AgentDashboard';

    my $ConfigObject = bless {
        Values => {
            'AuthModule::OpenIDConnect::AuthRequest' => {
                ResponseType    => ['code'],
                AdditionalScope => ['profile'],
            },
            'AuthModule::OpenIDConnect::Config' => {
                ProviderSettings => {},
                ClientSettings   => {},
                Misc             => {
                    UseNonce   => 1,
                    UsePKCE    => 1,
                    RandLength => 22,
                },
            },
        },
        },
        'Local::OIDC::LoginChoice::Config';
    my $CacheObject = bless { Values => {} }, 'Local::OIDC::LoginChoice::Cache';
    my $MainObject  = bless {
        RandomStrings => [ $StateRandom, $CodeVerifier, $NonceRandom ],
        Lengths       => []
        },
        'Local::OIDC::LoginChoice::Main';
    my $LayoutObject = bless { Cookies => {} }, 'Local::OIDC::LoginChoice::Layout';
    my $OIDCObject   = bless {}, 'Local::OIDC::LoginChoice::Provider';
    my $LogObject    = bless {}, 'Local::OIDC::LoginChoice::Log';

    local $Kernel::OM = bless {
        Objects => {
            'Kernel::Config'                => $ConfigObject,
            'Kernel::System::Cache'         => $CacheObject,
            'Kernel::System::Main'          => $MainObject,
            'Kernel::Output::HTML::Layout'  => $LayoutObject,
            'Kernel::System::OpenIDConnect' => $OIDCObject,
            'Kernel::System::Log'           => $LogObject,
        },
        },
        'Local::OIDC::LoginChoice::ObjectManager';

    my $Backend = Kernel::System::Auth::OpenIDConnect->new();

    is( $Backend->GetOption( What => 'PreAuth' ), 1, 'automatic redirect remains enabled when unset' );

    $ConfigObject->{Values}->{'AuthModule::OpenIDConnect::AutoRedirect'} = 0;
    is( $Backend->GetOption( What => 'PreAuth' ), 0, 'automatic redirect can be disabled for a login choice' );

    my $PreAuth = $Backend->PreAuth( RequestedURL => $RequestedURL );
    ok( $PreAuth->{RedirectURL}, 'explicit OIDC pre-auth remains available when automatic redirect is disabled' );

    my %AuthorizationParams = URI->new( $PreAuth->{RedirectURL} )->query_form;
    is( $AuthorizationParams{state}, $StateRandom . $RequestedURL, 'requested destination remains in OIDC state' );
    is( $AuthorizationParams{nonce}, $NonceRandom,                 'OIDC nonce is still generated for the manual login choice' );
    is(
        $CacheObject->{Values}->{OpenIDConnect_State}->{$StateRandom},
        {
            UsePKCE      => 1,
            CodeVerifier => $CodeVerifier
        },
        'manual login choice stores the PKCE verifier in OIDC state',
    );
    is(
        $AuthorizationParams{code_challenge},
        do {
            my $Challenge = encode_base64( sha256($CodeVerifier), '' );
            $Challenge =~ tr!+/!-_!;
            $Challenge =~ s/=+\z//;
            $Challenge;
        },
        'manual login choice still creates an S256 PKCE challenge',
    );
    is( $AuthorizationParams{code_challenge_method},              'S256',         'authorization request uses the S256 challenge method' );
    is( $LayoutObject->{Cookies}->{ 'OIDCCSRF-' . $StateRandom }, $StateRandom,   'manual login choice sets the CSRF cookie' );
    is( $MainObject->{Lengths},                                   [ 22, 64, 22 ], 'manual login choice generates state, PKCE verifier and nonce' );

    $ConfigObject->{Values}->{'AuthModule::OpenIDConnect::AuthRequest'}->{ResponseType} = ['id_token'];
    my $InvalidPreAuth = $Backend->PreAuth();
    is( $InvalidPreAuth, undef, 'invalid PKCE response configuration does not start login' );
    like( $Backend->{AuthError}, qr/PKCE requires an authorization code response type/, 'invalid PKCE response config keeps its authentication error' );

    $ConfigObject->{Values}->{'AuthModule::OpenIDConnect::AutoRedirect'} = 1;
    is( $Backend->GetOption( What => 'PreAuth' ), 1, 'automatic redirect can be re-enabled' );
}

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
$MainObject->Require("$Bin/OAuthProviderMock");

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $CacheObject  = $Kernel::OM->Get('Kernel::System::Cache');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();
$CacheObject->CleanUp();

my @ConfigKeys = qw(
    AuthModule
    AuthModule1
    AuthModule::OpenIDConnect::AutoRedirect
    AuthModule::OpenIDConnect::AuthRequest
    AuthModule::OpenIDConnect::Config
    AuthModule::OpenIDConnect::UID
);
my %OriginalConfig = map { $_ => $ConfigObject->Get($_) } @ConfigKeys;

my $OpenIDConfig = OAuthProviderMock::GetTestOpenIDConfig();
$OpenIDConfig->{Misc} = {
    UseNonce   => 1,
    UsePKCE    => 1,
    RandLength => 22,
};

$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::AutoRedirect',
    Value => 0
);
$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::Config',
    Value => $OpenIDConfig
);
$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::UID',
    Value => 'sub'
);
$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::AuthRequest',
    Value => {
        ResponseType    => ['code'],
        AdditionalScope => ['profile'],
    },
);

my $AgentApp = Plack::Middleware::HTTPExceptions->new(
    app => Kernel::System::Web::InterfaceAgent->new()->to_app,
)->to_app;
my $AgentURL = 'http://localhost/' . $ConfigObject->Get('ScriptAlias') . 'index.pl';

$ConfigObject->Set(
    Key   => 'AuthModule',
    Value => 'Kernel::System::Auth::OpenIDConnect'
);
$ConfigObject->Set(
    Key   => 'AuthModule1',
    Value => 'Kernel::System::Auth::DB'
);
$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::AutoRedirect',
    Value => 1
);
my $Response = RequestAgent(
    App     => $AgentApp,
    Request => GET($AgentURL),
);
is( $Response->code, 302, 'automatic OIDC redirect remains enabled on the main login entry point' );
like( $Response->header('Location'), qr{\Ahttp://localhost:2007/}, 'automatic redirect uses the configured provider URL' );

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my ($TestUserLogin) = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
my %TestUserData  = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User  => $TestUserLogin,
    Valid => 1,
);
my $SessionNow = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
my $SessionID  = $SessionObject->CreateSessionID(
    %TestUserData,
    UserSessionStart => $SessionNow,
    UserLastRequest  => $SessionNow,
    UserType         => 'User',
    SessionSource    => 'AgentInterface',
);
ok( $SessionID, 'create an existing agent session for navigation coverage' );
my $DashboardURI = URI->new($AgentURL);
$DashboardURI->query_form( Action => 'AgentDashboard' );
my $SessionName = $ConfigObject->Get('SessionName') || 'SessionID';
$Response = RequestAgent(
    App     => $AgentApp,
    Request => GET(
        $DashboardURI->as_string(),
        Cookie => "$SessionName=$SessionID",
    ),
);
is( $Response->code, 200, 'an existing agent session opens the dashboard while OIDC is primary' );
like( $Response->decoded_content, qr/value="AgentDashboard"/, 'dashboard content is rendered for the existing session' );
$SessionObject->RemoveSessionID( SessionID => $SessionID );
$SessionID = undef;

$ConfigObject->Set(
    Key   => 'AuthModule',
    Value => 'Kernel::System::Auth::DB'
);
$ConfigObject->Set(
    Key   => 'AuthModule1',
    Value => 'Kernel::System::Auth::OpenIDConnect'
);
$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::AutoRedirect',
    Value => 0
);
$Response = RequestAgent(
    App     => $AgentApp,
    Request => POST( $AgentURL, [ Action => 'LoginOIDC' ] ),
);
is( $Response->code, 200, 'LoginOIDC on a DB primary backend returns the login page' );
like( $Response->decoded_content, qr/Authentication error\./, 'LoginOIDC rejects an OIDC secondary backend' );

$ConfigObject->Set(
    Key   => 'AuthModule',
    Value => 'Kernel::System::Auth::OpenIDConnect'
);
$ConfigObject->Set(
    Key   => 'AuthModule1',
    Value => 'Kernel::System::Auth::DB'
);
$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::AuthRequest',
    Value => { ResponseType => ['id_token'] },
);

my $RequestedURL = 'Action=AgentTicketQueue;QueueID=45';
$Response = RequestAgent(
    App     => $AgentApp,
    Request => POST(
        $AgentURL,
        [
            Action       => 'LoginOIDC',
            RequestedURL => $RequestedURL,
        ],
    ),
);
is( $Response->code, 200, 'failed OIDC pre-auth returns the login form' );
my $FailurePage = $Response->decoded_content;
like( $FailurePage, qr/Authentication error\./, 'failed OIDC pre-auth shows an error' );
my ($FormRequestedURL) = $FailurePage =~ /name="RequestedURL" value="([^"]*)"/;
is( $FormRequestedURL, $RequestedURL, 'failed OIDC pre-auth keeps the raw deep-link for retry' );
like( $FailurePage, qr/id="OIDCLoginButton"/, 'OIDC retry button remains available after pre-auth failure' );

$ConfigObject->Set(
    Key   => 'AuthModule::OpenIDConnect::AuthRequest',
    Value => {
        ResponseType    => ['code'],
        AdditionalScope => ['profile'],
    },
);

$Response = RequestAgent(
    App     => $AgentApp,
    Request => POST(
        $AgentURL,
        [
            Action       => 'LoginOIDC',
            RequestedURL => $FormRequestedURL,
        ],
    ),
);
is( $Response->code, 302, 'explicit OIDC action starts the provider redirect with auto-redirect disabled' );

my $AuthorizationURL    = $Response->header('Location');
my %AuthorizationParams = URI->new($AuthorizationURL)->query_form;
my $StatePrefix         = substr $AuthorizationParams{state}, 0, 22;
is(
    substr( $AuthorizationParams{state}, 22 ),
    uri_escape_utf8($RequestedURL),
    'retry encodes the original deep-link once in state',
);
ok( $AuthorizationParams{nonce}, 'manual redirect includes an OIDC nonce' );
is( $AuthorizationParams{code_challenge_method}, 'S256', 'manual redirect uses the S256 PKCE method' );
ok( $AuthorizationParams{code_challenge}, 'manual redirect includes a PKCE challenge' );
my @SetCookies = $Response->headers->header('Set-Cookie');
ok(
    scalar grep { index( $_, "OIDCCSRF-$StatePrefix=$StatePrefix" ) > -1 } @SetCookies,
    'manual redirect sets the matching OIDC CSRF cookie',
);

my $MissingCodeURI = URI->new($AgentURL);
$MissingCodeURI->query_form(
    Action => 'Login',
    state  => $AuthorizationParams{state},
);
$Response = RequestAgent(
    App     => $AgentApp,
    Request => GET(
        $MissingCodeURI->as_string(),
        Cookie => "OIDCCSRF-$StatePrefix=$StatePrefix",
    ),
);
like(
    $Response->decoded_content,
    qr/did not return the authorization code required for PKCE/,
    'callback with valid state but missing code keeps the authentication error',
);

my $InvalidStateURI = URI->new($AgentURL);
$InvalidStateURI->query_form(
    Action => 'Login',
    code   => 'callback-with-invalid-state',
    state  => 'invalid-state',
);
$Response = RequestAgent(
    App     => $AgentApp,
    Request => GET( $InvalidStateURI->as_string() ),
);
like(
    $Response->decoded_content,
    qr/Invalid response from the authentication server/,
    'callback with invalid state keeps the authentication error',
);

$Response = RequestAgent(
    App     => $AgentApp,
    Request => POST(
        $AgentURL,
        [
            Action       => 'LoginOIDC',
            RequestedURL => $RequestedURL,
        ],
    ),
);
is( $Response->code, 302, 'a new OIDC login choice creates a fresh callback flow' );
$AuthorizationURL    = $Response->header('Location');
%AuthorizationParams = URI->new($AuthorizationURL)->query_form;
$StatePrefix         = substr $AuthorizationParams{state}, 0, 22;

my $ProviderUA = LWP::UserAgent->new();
$ProviderUA->max_redirect(0);
my $ProviderResponse = $ProviderUA->get($AuthorizationURL);
is( $ProviderResponse->code, 302, 'mock OIDC provider returns the callback' );
my $CallbackURI    = URI->new( $ProviderResponse->header('Location') );
my %CallbackParams = $CallbackURI->query_form;

# OAuthProviderMock appends its decoded state to the callback URI without URL-encoding it again.
# Rebuild the callback with the original state value to model a compliant provider response.
is( $CallbackParams{state}, uri_unescape( $AuthorizationParams{state} ), 'mock provider returns the original state after decoding it' );
$CallbackParams{state} = $AuthorizationParams{state};
$CallbackURI->query_form(%CallbackParams);

$Response = RequestAgent(
    App     => $AgentApp,
    Request => GET(
        $CallbackURI->as_string(),
        Cookie => "OIDCCSRF-$StatePrefix=$StatePrefix",
    ),
);
is( $Response->code, 200, 'callback is handled by the agent interface' );
my $CallbackPage = $Response->decoded_content;
like( $CallbackPage, qr/Authentication error\./, 'callback without a mapped local account remains a failed login' );
my ($ReturnedRequestedURL) = $CallbackPage =~ /name="RequestedURL" value="([^"]*)"/;
is( $ReturnedRequestedURL, $RequestedURL, 'validated callback restores the original deep-link' );

my $ProviderLogResponse = $ProviderUA->get('http://localhost:2007/realms/master/protocol/openid-connect/log');
my $ProviderCalls       = decode_json( $ProviderLogResponse->decoded_content );
my ($TokenCall)         = grep { $_->{endpoint} eq 'token' } @{$ProviderCalls};
ok( $TokenCall && $TokenCall->{content} =~ /code_verifier=/, 'provider accepted the callback PKCE verifier' );

$CacheObject->CleanUp();
for my $Key (@ConfigKeys) {
    $ConfigObject->Set(
        Key   => $Key,
        Value => $OriginalConfig{$Key},
    );
}

done_testing();

# Tear down the mock provider after Test2 has finalized the test status.
kill( 'TERM', $OAuthProviderMock::ChildPID );
waitpid( $OAuthProviderMock::ChildPID, 0 );

sub RequestAgent {
    my (%Param) = @_;

    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Web::Request', 'Kernel::System::Web::Response' ],
    );

    my $Response;
    test_psgi(
        app    => $Param{App},
        client => sub {
            my $CB = shift;
            $Response = $CB->( $Param{Request} );
        },
    );

    return $Response;
}

package Local::OIDC::LoginChoice::Config;

sub Get {
    my ( $Self, $Key ) = @_;
    return $Self->{Values}->{$Key};
}

package Local::OIDC::LoginChoice::ObjectManager;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub Get {
    my ( $Self, $Key ) = @_;
    return $Self->{Objects}->{$Key};
}

package Local::OIDC::LoginChoice::Cache;            ## no critic qw(Modules::ProhibitMultiplePackages)

sub Set {
    my ( $Self, %Param ) = @_;
    $Self->{Values}->{ $Param{Type} }->{ $Param{Key} } = $Param{Value};
    return 1;
}

package Local::OIDC::LoginChoice::Main;             ## no critic qw(Modules::ProhibitMultiplePackages)

sub GenerateRandomString {
    my ( $Self, %Param ) = @_;
    push @{ $Self->{Lengths} }, $Param{Length};
    return shift @{ $Self->{RandomStrings} };
}

package Local::OIDC::LoginChoice::Layout;           ## no critic qw(Modules::ProhibitMultiplePackages)

sub SetCookie {
    my ( $Self, %Param ) = @_;
    $Self->{Cookies}->{ $Param{Key} } = $Param{Value};
    return 1;
}

package Local::OIDC::LoginChoice::Provider;         ## no critic qw(Modules::ProhibitMultiplePackages)

sub BuildRedirectURL {
    my ( $Self, %Param ) = @_;
    $Self->{LastRedirectParam} = \%Param;

    my $URL   = URI->new('https://idp.example/authorize');
    my %Query = (
        state                 => $Param{AuthRequest}->{State},
        nonce                 => $Param{AuthRequest}->{Nonce},
        code_challenge        => $Param{CodeChallenge},
        code_challenge_method => 'S256',
    );
    $URL->query_form(%Query);
    return $URL->as_string();
}

package Local::OIDC::LoginChoice::Log;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub Log { return 1 }
