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

use Test2::V0;
use URI;

use Kernel::System::Auth::OpenIDConnect;
use Kernel::System::OpenIDConnect;
use Kernel::System::OpenIDConnect::Configuration;
use Kernel::System::Web::InterfaceAgent ();
use Kernel::Output::HTML::Layout        ();

my $Issuer       = 'https://issuer.example/realms/support';
my $ClientID     = 'otobo';
my $RedirectURI  = 'https://otobo.example/otobo/index.pl?Action=Login&source=logout';
my $OpenIDConfig = {
    ProviderSettings => { Name => 'test' },
    ClientSettings   => {
        ClientID              => $ClientID,
        PostLogoutRedirectURI => $RedirectURI,
    },
    Misc => { UseIDTokenHint => 0 },
};
my $ProviderData = {
    OpenIDConfiguration => {
        issuer               => $Issuer,
        end_session_endpoint => 'https://issuer.example/realms/support/logout?ui_locales=pl&client_hint=existing',
    },
};
local *Kernel::System::OpenIDConnect::Configuration::GetProviderData = sub { return $ProviderData };

local $Kernel::OM = Local::OIDC::Logout::Manager->new(
    Config => Local::OIDC::Logout::Config->new(
        Values => { 'AuthModule::OpenIDConnect::Config' => $OpenIDConfig },
    ),
);
my $Object = Kernel::System::OpenIDConnect->new();

my $LegacyURL = $Object->GetLogoutURL(
    ProviderSettings => { Name => 'test' },
);
is(
    $LegacyURL,
    $ProviderData->{OpenIDConfiguration}{end_session_endpoint},
    'default logout keeps the provider confirmation endpoint unchanged',
);

my $IDTokenHint = 'header.payload/signature+value=';
my $RedirectURL = $Object->GetLogoutURL(
    ProviderSettings => { Name => 'test' },
    ClientSettings   => {
        ClientID              => 'otobo',
        PostLogoutRedirectURI => $RedirectURI,
    },
    IDTokenHint   => $IDTokenHint,
    IDTokenIssuer => $Issuer,
);
my %RedirectQuery = URI->new($RedirectURL)->query_form;
is( $RedirectQuery{ui_locales},               'pl',         'existing provider query parameters survive' );
is( $RedirectQuery{client_hint},              'existing',   'existing unrelated query values survive' );
is( $RedirectQuery{id_token_hint},            $IDTokenHint, 'ID token hint is URI encoded and round trips exactly' );
is( $RedirectQuery{post_logout_redirect_uri}, $RedirectURI, 'configured post-logout URI is URI encoded' );
is( $RedirectQuery{client_id},                'otobo',      'configured client identifies the post-logout URI' );
ok( !exists $RedirectQuery{client_secret}, 'client secret is never sent to the logout endpoint' );

my $AuthBackend = Kernel::System::Auth::OpenIDConnect->new();
my $HintSession = {
    ClientID => $ClientID,
    Issuer   => $Issuer,
    IDToken  => $IDTokenHint,
};
my $DefaultLogout = $AuthBackend->Logout( OIDCSession => $HintSession );
my %DefaultQuery  = URI->new( $DefaultLogout->{LogoutURL} )->query_form;
ok( !exists $DefaultQuery{id_token_hint}, 'ID-token-hint mode stays opt-in' );
is( $DefaultQuery{post_logout_redirect_uri}, $RedirectURI, 'configured return URI works with provider confirmation mode' );

$OpenIDConfig->{Misc}->{UseIDTokenHint} = 1;
ok( !$AuthBackend->Logout(), 'password sessions do not trigger an OIDC logout' );
ok(
    !$AuthBackend->Logout( OIDCSession => { %{$HintSession}, ClientID => 'other-client' } ),
    'session for another client is not sent to the OIDC provider',
);
my $HintLogout = $AuthBackend->Logout( OIDCSession => $HintSession );
my %HintQuery  = URI->new( $HintLogout->{LogoutURL} )->query_form;
is( $HintQuery{id_token_hint},            $IDTokenHint, 'trusted OIDC session supplies its ID token when the option is enabled' );
is( $HintQuery{post_logout_redirect_uri}, $RedirectURI, 'enabled logout keeps the configured return URI' );

my $OldSessionLogout = $AuthBackend->Logout(
    OIDCSession => {
        ClientID => $ClientID,
        Issuer   => $Issuer,
    },
);
my %OldSessionQuery = URI->new( $OldSessionLogout->{LogoutURL} )->query_form;
ok( !exists $OldSessionQuery{id_token_hint}, 'older OIDC sessions use provider confirmation without a retained token' );
is( $OldSessionQuery{post_logout_redirect_uri}, $RedirectURI, 'older sessions still return to the configured URI' );

my $MismatchedSessionIssuerLogout = $AuthBackend->Logout(
    OIDCSession => {
        %{$HintSession},
        Issuer => 'https://untrusted.example/realms/other',
    },
);
ok( !$MismatchedSessionIssuerLogout, 'retained token from another issuer is rejected' );

my $ConfirmedRedirectURL = $Object->GetLogoutURL(
    ProviderSettings => { Name => 'test' },
    ClientSettings   => {
        ClientID              => 'otobo',
        PostLogoutRedirectURI => $RedirectURI,
    },
);
my %ConfirmedRedirectQuery = URI->new($ConfirmedRedirectURL)->query_form;
is( $ConfirmedRedirectQuery{post_logout_redirect_uri}, $RedirectURI, 'redirect-only mode supports provider confirmation' );
is( $ConfirmedRedirectQuery{client_id},                'otobo',      'redirect-only mode includes the trusted client ID' );
ok( !exists $ConfirmedRedirectQuery{id_token_hint}, 'redirect-only mode does not include an ID token hint' );

my $NoRedirectURL = $Object->GetLogoutURL(
    ProviderSettings => { Name     => 'test' },
    ClientSettings   => { ClientID => 'otobo' },
    IDTokenHint      => $IDTokenHint,
    IDTokenIssuer    => $Issuer,
);
my %NoRedirectQuery = URI->new($NoRedirectURL)->query_form;
is( $NoRedirectQuery{id_token_hint}, $IDTokenHint, 'ID token hint works without a return URI' );
ok( !exists $NoRedirectQuery{post_logout_redirect_uri}, 'return URI stays optional' );

my $MismatchedIssuerURL = $Object->GetLogoutURL(
    ProviderSettings => { Name     => 'test' },
    ClientSettings   => { ClientID => 'otobo' },
    IDTokenHint      => $IDTokenHint,
    IDTokenIssuer    => 'https://untrusted.example/realms/other',
);
ok( !$MismatchedIssuerURL, 'ID token from another issuer is rejected' );

my $TrustedInterfaceSession = {
    Issuer    => $Issuer,
    ClientID  => $ClientID,
    Subject   => 'agent-subject',
    IssuedAt  => 1_700_000_000,
    StartedAt => 1_699_999_900,
    IDToken   => $IDTokenHint,
};
my $InterfaceLogout = RunInterfaceLogoutCase( SessionData => { OIDCSession => $TrustedInterfaceSession } );
is( $InterfaceLogout->{AuthCalls}->[0]->{OIDCSession}, $TrustedInterfaceSession, 'agent logout passes its server-side OIDC session to the auth backend' );
is( $InterfaceLogout->{Events},                        [qw(challenge remove auth redirect)], 'CSRF check and local session removal precede provider logout' );
is( $InterfaceLogout->{RedirectURL},                   'https://issuer.example/logout',      'agent logout uses the OIDC backend redirect' );

my $InjectedRequestParams = RunInterfaceLogoutCase(
    SessionData   => { OIDCSession => $TrustedInterfaceSession },
    RequestParams => {
        id_token_hint            => 'attacker-controlled-token',
        post_logout_redirect_uri => 'https://attacker.example/callback',
    },
);
is(
    $InjectedRequestParams->{AuthCalls}->[0]->{OIDCSession},
    $TrustedInterfaceSession,
    'logout identity comes from the server-side session, not request parameters',
);
ok( !exists $InjectedRequestParams->{AuthCalls}->[0]->{IDTokenHint},           'request cannot inject an ID token hint' );
ok( !exists $InjectedRequestParams->{AuthCalls}->[0]->{PostLogoutRedirectURI}, 'request cannot inject a post-logout redirect' );

my $GlobalLogoutOverride = RunInterfaceLogoutCase(
    LogoutURL   => 'https://legacy.example/logout',
    SessionData => { OIDCSession => $TrustedInterfaceSession },
);
is( $GlobalLogoutOverride->{RedirectURL}, 'https://legacy.example/logout', 'global LogoutURL keeps precedence over the auth backend' );
is( $GlobalLogoutOverride->{AuthCalls},   [],                              'global LogoutURL override skips backend logout' );

my $RejectedInterfaceLogout = RunInterfaceLogoutCase(
    RejectChallenge => 1,
    SessionData     => { OIDCSession => $TrustedInterfaceSession },
);
like( $RejectedInterfaceLogout->{Error}, qr/CSRF rejection/, 'CSRF failure is returned before any logout side effect' );
is( $RejectedInterfaceLogout->{RemoveCalls}, 0,  'CSRF failure retains the local session' );
is( $RejectedInterfaceLogout->{AuthCalls},   [], 'CSRF failure does not call the OIDC logout backend' );

done_testing;

package Local::OIDC::Logout::Manager;

sub new {
    my ( $Class, %Param ) = @_;
    return bless { Config => $Param{Config} }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Config}                      if $Name eq 'Kernel::Config';
    return Kernel::System::OpenIDConnect->new() if $Name eq 'Kernel::System::OpenIDConnect';
    return bless {}, 'Local::OIDC::Logout::Log' if $Name eq 'Kernel::System::Log';
    return Kernel::System::OpenIDConnect::Configuration->new()
        if $Name eq 'Kernel::System::OpenIDConnect::Configuration';
    return;
}

package Local::OIDC::Logout::Log;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub Log { return 1 }

package Local::OIDC::Logout::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless \%Param, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Values}->{$Name};
}

package Local::OIDC::Logout::State;     ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        Data            => $Param{Data},
        Events          => [],
        AuthCalls       => [],
        RedirectURL     => undef,
        RemoveCalls     => 0,
        RejectChallenge => $Param{RejectChallenge},
    }, $Class;
}

package Local::OIDC::Logout::InterfaceManager;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    my $State = $Param{State};
    return bless {
        State   => $State,
        Config  => Local::OIDC::Logout::InterfaceConfig->new( LogoutURL => $Param{LogoutURL} // '' ),
        Request => Local::OIDC::Logout::Request->new( Params => $Param{RequestParams} ),
        Session => Local::OIDC::Logout::Session->new( State  => $State ),
        Layout  => Local::OIDC::Logout::Layout->new( State => $State ),
        Auth    => Local::OIDC::Logout::Auth->new( State => $State ),
    }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Config}                          if $Name eq 'Kernel::Config';
    return $Self->{Request}                         if $Name eq 'Kernel::System::Web::Request';
    return bless( {}, 'Local::OIDC::Logout::DB' )   if $Name eq 'Kernel::System::DB';
    return $Self->{Session}                         if $Name eq 'Kernel::System::AuthSession';
    return bless( {}, 'Local::OIDC::Logout::User' ) if $Name eq 'Kernel::System::User';
    return $Self->{Layout}                          if $Name eq 'Kernel::Output::HTML::Layout';
    return $Self->{Auth}                            if $Name eq 'Kernel::System::Auth';
    return;
}

sub ObjectParamAdd { return 1 }
sub ObjectsDiscard { return 1 }

package Local::OIDC::Logout::InterfaceConfig;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless \%Param, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return 'SessionID'        if $Name eq 'SessionName';
    return {}                 if $Name eq 'Frontend::CommonParam';
    return $Self->{LogoutURL} if $Name eq 'LogoutURL';
    return;
}

package Local::OIDC::Logout::Request;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { Params => $Param{Params} // {} }, $Class;
}

sub GetParam {
    my ( $Self, %Param ) = @_;
    return 'Logout' if $Param{Param} eq 'Action';
    return $Self->{Params}->{ $Param{Param} };
}
sub GetCookie   { return 'session-1' }
sub QueryString { return 'Action=Logout' }
sub Error       {return}

package Local::OIDC::Logout::DB;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub Connect { return 1 }

package Local::OIDC::Logout::Session;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { State => $Param{State} }, $Class;
}

sub CheckSessionID   { return 1 }
sub GetSessionIDData { my ( $Self, %Param ) = @_; return ( %{ $Self->{State}->{Data} }, UserTimeZone => 'UTC' ) }

sub RemoveSessionID {
    my ($Self) = @_;
    $Self->{State}->{RemoveCalls}++;
    push @{ $Self->{State}->{Events} }, 'remove';
    return 1;
}

package Local::OIDC::Logout::User;    ## no critic qw(Modules::ProhibitMultiplePackages)

package Local::OIDC::Logout::Layout;  ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { State => $Param{State} }, $Class;
}

sub ChallengeTokenCheck {
    my ($Self) = @_;
    push @{ $Self->{State}->{Events} }, 'challenge';
    die 'CSRF rejection' if $Self->{State}->{RejectChallenge};
    return 1;
}

sub Redirect {
    my ( $Self, %Param ) = @_;
    $Self->{State}->{RedirectURL} = $Param{ExtURL};
    push @{ $Self->{State}->{Events} }, 'redirect';
    die 'Expected logout redirect';
}

package Local::OIDC::Logout::Auth;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { State => $Param{State} }, $Class;
}

sub Logout {
    my ( $Self, %Param ) = @_;
    push @{ $Self->{State}->{Events} },    'auth';
    push @{ $Self->{State}->{AuthCalls} }, \%Param;
    return { LogoutURL => 'https://issuer.example/logout' };
}

package main;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub RunInterfaceLogoutCase {
    my (%Param) = @_;
    my $State = Local::OIDC::Logout::State->new(
        Data            => $Param{SessionData},
        RejectChallenge => $Param{RejectChallenge},
    );
    local $Kernel::OM = Local::OIDC::Logout::InterfaceManager->new(
        State     => $State,
        LogoutURL => $Param{LogoutURL},
    );
    {
        no warnings 'redefine';    ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
        local *Kernel::Output::HTML::Layout::SetCookie   = sub { return 1 };
        local *Kernel::System::DateTime::IsTimeZoneValid = sub { return 1 };
        eval { Kernel::System::Web::InterfaceAgent::_Content() };
    }
    return {
        Error       => $@,
        Events      => $State->{Events},
        AuthCalls   => $State->{AuthCalls},
        RedirectURL => $State->{RedirectURL},
        RemoveCalls => $State->{RemoveCalls},
    };
}
