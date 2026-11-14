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
use MIME::Base64                        qw(encode_base64);
use Kernel::System::Auth                ();
use Kernel::System::AuthSession         ();
use Kernel::System::Auth::OpenIDConnect ();
use Kernel::System::Storable            ();
use Kernel::Modules::AdminUser;

sub AuthCase {
    my (%Param) = @_;

    my $Config  = Local::Integration::Config->new();
    my $User    = Local::Integration::User->new();
    my $Manager = Local::Integration::Manager->new(
        Config => $Config,
        User   => $User,
    );
    local $Kernel::OM = $Manager;

    my $Auth = bless {
        AuthBackend => Local::Integration::Backend->new(
            Name     => 'password',
            Result   => $Param{PasswordResult},
            PostAuth => 'password-postauth'
        ),
        AuthBackend1 => Local::Integration::Backend->new(
            Name     => 'oidc',
            Result   => $Param{OIDCResult},
            PostAuth => 'oidc-postauth'
        ),
        SuccessfulAuthBackend => Local::Integration::Backend->new(
            Name     => 'stale',
            PostAuth => 'stale-postauth'
        ),
        },
        'Kernel::System::Auth';

    my $UserName = $Auth->Auth( User => 'agent' );
    my $PostAuth = $Auth->PostAuth();

    return {
        UserName => $UserName,
        PostAuth => $PostAuth,
        Auth     => $Auth
    };
}

my $OIDCResult = AuthCase(
    PasswordResult => undef,
    OIDCResult     => 'agent'
);
is( $OIDCResult->{UserName}, 'agent',         'numbered OIDC backend authenticates' );
is( $OIDCResult->{PostAuth}, 'oidc-postauth', 'PostAuth comes from the backend that authenticated' );

my $PasswordResult = AuthCase(
    PasswordResult => 'agent',
    OIDCResult     => 'unused'
);
is( $PasswordResult->{UserName}, 'agent',             'password backend authenticates' );
is( $PasswordResult->{PostAuth}, 'password-postauth', 'password fallback does not reuse prior OIDC PostAuth' );

my $State          = Local::Integration::State->new();
my $SessionManager = Local::Integration::Manager->new(
    Config => Local::Integration::Config->new( SessionModule => 'Local::Integration::SessionBackend' ),
    Cache  => Local::Integration::Cache->new(),
    Main   => Local::Integration::Main->new(),
    Logout => Local::Integration::Logout->new( Decisions => [ 1, 0 ] ),
    State  => $State,
);
local $Kernel::OM = $SessionManager;

my $Session   = Kernel::System::AuthSession->new();
my $SessionID = $Session->CreateSessionID(
    UserType      => 'User',
    SessionSource => 'AgentInterface',
    UserLogin     => 'agent',
    OIDCSession   => {
        Issuer   => 'https://issuer.example',
        ClientID => 'otobo',
        Subject  => 'subject-1',
        IssuedAt => 1_800_000_000,
    },
);
is( $SessionID,            undef,         'logout racing session creation refuses the new session' );
is( $State->{CreateCalls}, 1,             'race reaches backend session creation before second check' );
is( $State->{Removed},     ['session-1'], 'session created during logout is removed' );

$State->Reset();
$SessionManager->{Objects}->{'Kernel::System::OpenIDConnect::BackchannelLogout'} =
    Local::Integration::Logout->new( Decisions => [undef] );
my $DeniedSessionID = $Session->CreateSessionID(
    UserType      => 'User',
    SessionSource => 'AgentInterface',
    OIDCSession   => {
        Issuer   => 'https://issuer.example',
        ClientID => 'otobo',
        Subject  => 'subject-1',
        IssuedAt => 1
    },
);
is( $DeniedSessionID,      undef, 'revocation storage error fails closed before session creation' );
is( $State->{CreateCalls}, 0,     'revocation storage error never creates a session' );

$State->Reset();
$SessionManager->{Objects}->{'Kernel::System::OpenIDConnect::BackchannelLogout'} =
    Local::Integration::Logout->new( Decisions => [0] );
my $NormalSessionID = $Session->CreateSessionID(
    UserType      => 'User',
    SessionSource => 'AgentInterface',
    UserLogin     => 'password.agent',
);
is( $NormalSessionID, 'session-1',                                                                'ordinary password session creation remains unchanged' );
is( $SessionManager->{Objects}->{'Kernel::System::OpenIDConnect::BackchannelLogout'}->{Calls}, 0, 'ordinary session does not consult logout state' );

$State->Reset();
$State->{SessionData}->{'session-old'} = {
    UserType      => 'User',
    SessionSource => 'AgentInterface',
    UserLogin     => 'agent',
    OIDCSession   => {
        Issuer   => 'https://issuer.example',
        ClientID => 'otobo',
        Subject  => 'subject-1',
        IssuedAt => 1
    },
};
$SessionManager->{Objects}->{'Kernel::System::OpenIDConnect::BackchannelLogout'} =
    Local::Integration::Logout->new( Decisions => [0] );
ok( !$Session->CheckSessionID( SessionID => 'session-old' ), 'resurrected cached OIDC session is rejected' );
is( $State->{Removed}, ['session-old'], 'revoked session is removed when presented' );

$State->Reset();
$State->{SessionData}->{'session-password'} = {
    UserType      => 'User',
    SessionSource => 'AgentInterface',
    UserLogin     => 'agent',
};
$SessionManager->{Objects}->{'Kernel::System::OpenIDConnect::BackchannelLogout'} =
    Local::Integration::Logout->new( Decisions => [0] );
ok( $Session->CheckSessionID( SessionID => 'session-password' ), 'unmarked session remains valid' );
is( $SessionManager->{Objects}->{'Kernel::System::OpenIDConnect::BackchannelLogout'}->{Calls}, 0, 'unmarked session does not consult logout state' );

my $OriginalOIDCSession = {
    Issuer    => 'https://issuer.example',
    ClientID  => 'otobo',
    Subject   => 'administrator-subject',
    SessionID => 'administrator-sid',
    IssuedAt  => 1_800_000_000,
    StartedAt => 1_799_999_900,
};
my $ForgedOIDCSession = {
    Issuer    => 'https://attacker.example',
    ClientID  => 'other-client',
    Subject   => 'target-user-subject',
    SessionID => 'target-user-sid',
    IssuedAt  => 1,
    StartedAt => 1,
};

my $SwitchedOIDCSession = AdminSwitchCase(
    CurrentSession => { OIDCSession => $OriginalOIDCSession },
    TargetUserData => {
        UserID      => 42,
        UserLogin   => 'target',
        OIDCSession => $ForgedOIDCSession
    },
);
is( $SwitchedOIDCSession->{OIDCSession}, $OriginalOIDCSession, 'switch preserves the administrator OIDC session over target preference data' );

my $SwitchedPasswordSession = AdminSwitchCase(
    CurrentSession => { UserLogin => 'administrator' },
    TargetUserData => {
        UserID      => 42,
        UserLogin   => 'target',
        OIDCSession => $ForgedOIDCSession
    },
);
ok( !exists $SwitchedPasswordSession->{OIDCSession}, 'password administrator switch removes target OIDC preference' );

sub OIDCPreAuthCase {
    my (%Param) = @_;
    my $Config = Local::OIDCAuth::Config->new(
        BackchannelLogout => $Param{BackchannelLogout} // 1,
        UsePKCE           => $Param{UsePKCE}           // 0,
        UseIDTokenHint    => $Param{UseIDTokenHint}    // 0,
    );
    my $Cache    = Local::OIDCAuth::Cache->new();
    my $Provider = Local::OIDCAuth::Provider->new();
    local $Kernel::OM = Local::OIDCAuth::Manager->new(
        Config   => $Config,
        Cache    => $Cache,
        Provider => $Provider,
        Request  => Local::OIDCAuth::Request->new(),
        Main     => Local::OIDCAuth::Main->new(),
        Layout   => Local::OIDCAuth::Layout->new(),
    );

    my $Backend = Kernel::System::Auth::OpenIDConnect->new();
    my $Result  = $Backend->PreAuth( RequestedURL => '/otobo/index.pl' );

    return {
        Result   => $Result,
        Cache    => $Cache,
        Provider => $Provider
    };
}

my $BackchannelState      = OIDCPreAuthCase( UsePKCE => 0 );
my ($BackchannelStateKey) = keys %{ $BackchannelState->{Cache}->{Values} };
my $BackchannelStateData  = $BackchannelState->{Cache}->{Values}->{$BackchannelStateKey};
like( $BackchannelStateData->{StartedAt}, qr/\A[0-9]+\z/, 'back-channel state stores server start time without PKCE' );
ok( !exists $BackchannelStateData->{CodeVerifier}, 'PKCE-off state has no verifier' );

my $LogoutHintState = OIDCPreAuthCase(
    BackchannelLogout => 0,
    UseIDTokenHint    => 1
);
my ($LogoutHintStateKey) = keys %{ $LogoutHintState->{Cache}->{Values} };
my $LogoutHintStateData = $LogoutHintState->{Cache}->{Values}->{$LogoutHintStateKey};
like( $LogoutHintStateData->{StartedAt}, qr/\A[0-9]+\z/, 'ID-token-hint mode records session start time without back-channel logout' );

my $PKCEState      = OIDCPreAuthCase( UsePKCE => 1 );
my ($PKCEStateKey) = keys %{ $PKCEState->{Cache}->{Values} };
my $PKCEStateData  = $PKCEState->{Cache}->{Values}->{$PKCEStateKey};
like( $PKCEStateData->{StartedAt}, qr/\A[0-9]+\z/, 'back-channel state stores server start time with PKCE' );
is( $PKCEStateData->{UsePKCE},                                                         1,        'PKCE is preserved in the same state value' );
is( $PKCEStateData->{CodeVerifier},                                                    'v' x 64, 'PKCE verifier is preserved with the state time' );
is( $PKCEState->{Provider}->{RedirectParam}->{CodeChallenge} =~ /^[A-Za-z0-9_-]{43}$/, 1,        'PKCE challenge is sent with the back-channel state' );

my $LegacyState = OIDCAuthCallbackCase(
    BackchannelLogout => 1,
    StateData         => 1,
);
is( $LegacyState->{Result},                      undef, 'legacy state is rejected when back-channel logout is enabled' );
is( $LegacyState->{Provider}->{ValidationCalls}, 0,     'legacy state fails before ID-token validation' );

my $PKCEMissingStart = OIDCAuthCallbackCase(
    BackchannelLogout => 1,
    UsePKCE           => 1,
    StateData         => {
        UsePKCE      => 1,
        CodeVerifier => 'v' x 64
    },
);
is( $PKCEMissingStart->{Result},                   undef, 'PKCE state without server start time is rejected' );
is( $PKCEMissingStart->{Provider}->{CodeRequests}, 0,     'missing start time fails before code exchange' );

my $TrustedMetadata = OIDCAuthCallbackCase(
    BackchannelLogout => 1,
    StartedAt         => 1_700_000_000,
    TokenData         => {
        iss                => 'https://issuer.example',
        sub                => 'subject-1',
        aud                => 'otobo',
        iat                => 1_700_000_001,
        sid                => 'sid-1',
        StartedAt          => 1_700_009_999,
        preferred_username => 'agent',
    },
);
is( $TrustedMetadata->{Result}, 'agent', 'validated OIDC user authenticates with server-side state' );
is(
    $TrustedMetadata->{PostAuth}->{OIDCSession},
    {
        Issuer    => 'https://issuer.example',
        ClientID  => 'otobo',
        Subject   => 'subject-1',
        SessionID => 'sid-1',
        IssuedAt  => 1_700_000_001,
        StartedAt => 1_700_000_000,
    },
    'session metadata uses server state time instead of the token claim',
);

my $RejectedMetadata = OIDCAuthCallbackCase(
    BackchannelLogout => 1,
    StartedAt         => 1_700_000_000,
    Backend           => $TrustedMetadata->{Backend},
    Success           => 0,
    TokenData         => {
        iss                => 'https://issuer.example',
        sub                => 'subject-1',
        aud                => 'otobo',
        iat                => 1_700_000_001,
        preferred_username => 'agent',
    },
);
is( $RejectedMetadata->{Result},                  undef, 'failed token validation does not authenticate' );
is( $RejectedMetadata->{PostAuth}->{OIDCSession}, undef, 'failed reauthentication does not reuse previous OIDC metadata' );

my $DisabledMetadata = OIDCAuthCallbackCase(
    BackchannelLogout => 0,
    StateData         => 1,
    TokenData         => {
        iss                => 'https://issuer.example',
        sub                => 'subject-1',
        aud                => 'otobo',
        iat                => 1_700_000_001,
        preferred_username => 'agent',
    },
);
is( $DisabledMetadata->{Result},                  'agent', 'OIDC login works with back-channel logout disabled' );
is( $DisabledMetadata->{PostAuth}->{OIDCSession}, undef,   'disabled back-channel logout adds no session metadata' );

my $LogoutHintMetadata = OIDCAuthCallbackCase(
    BackchannelLogout => 0,
    UseIDTokenHint    => 1,
    IDToken           => 'signed-id-token',
    TokenData         => {
        iss                => 'https://issuer.example',
        sub                => 'subject-1',
        aud                => 'otobo',
        iat                => 1_700_000_001,
        preferred_username => 'agent',
    },
);
is( $LogoutHintMetadata->{Result}, 'agent', 'ID-token-hint mode authenticates without back-channel logout' );
is(
    $LogoutHintMetadata->{PostAuth}->{OIDCSession},
    {
        Issuer    => 'https://issuer.example',
        ClientID  => 'otobo',
        Subject   => 'subject-1',
        IssuedAt  => 1_700_000_001,
        StartedAt => 1_700_000_000,
        IDToken   => 'signed-id-token',
    },
    'validated ID token is retained in trusted session metadata for logout',
);

my $RejectedLogoutHintMetadata = OIDCAuthCallbackCase(
    BackchannelLogout => 0,
    UseIDTokenHint    => 1,
    IDToken           => 'unvalidated-id-token',
    Backend           => $LogoutHintMetadata->{Backend},
    Success           => 0,
    TokenData         => {
        iss                => 'https://issuer.example',
        sub                => 'subject-1',
        aud                => 'otobo',
        iat                => 1_700_000_001,
        preferred_username => 'agent',
    },
);
is( $RejectedLogoutHintMetadata->{Result}, undef, 'invalid ID token does not authenticate in logout-hint mode' );
ok(
    !exists $RejectedLogoutHintMetadata->{PostAuth}->{OIDCSession},
    'failed login does not reuse an earlier ID token for logout',
);

my $LargeLogoutHintMetadata = OIDCAuthCallbackCase(
    BackchannelLogout => 0,
    UseIDTokenHint    => 1,
    IDToken           => 'x' x 10_000,
    TokenData         => {
        iss                => 'https://issuer.example',
        sub                => 'subject-1',
        aud                => 'otobo',
        iat                => 1_700_000_001,
        preferred_username => 'agent',
    },
);
is( $LargeLogoutHintMetadata->{Result}, 'agent', 'oversized ID token does not block login' );
ok( !exists $LargeLogoutHintMetadata->{PostAuth}->{OIDCSession}->{IDToken}, 'oversized ID token falls back to provider confirmation' );
cmp_ok(
    length(
        encode_base64(
            Kernel::System::Storable->new()->Serialize(
                Data => $LargeLogoutHintMetadata->{PostAuth}->{OIDCSession},
            ),
        ),
    ),
    '<=',
    10_000,
    'session metadata fits the database value limit after dropping an oversized token',
);

done_testing;

sub OIDCAuthCallbackCase {
    my (%Param)   = @_;
    my $State     = 's' x 22;
    my $StateData = exists $Param{StateData}
        ? $Param{StateData}
        : { StartedAt => $Param{StartedAt} // 1_700_000_000 };
    if ( $Param{UsePKCE} && ref $StateData eq 'HASH' ) {
        $StateData->{UsePKCE}      //= 1;
        $StateData->{CodeVerifier} //= 'v' x 64;
    }

    my $Config = Local::OIDCAuth::Config->new(
        BackchannelLogout => $Param{BackchannelLogout} // 1,
        UsePKCE           => $Param{UsePKCE}           // 0,
        UseIDTokenHint    => $Param{UseIDTokenHint}    // 0,
    );
    my $Cache    = Local::OIDCAuth::Cache->new( Values => { $State => $StateData } );
    my $Provider = Local::OIDCAuth::Provider->new(
        TokenData => $Param{TokenData} // {
            iss                => 'https://issuer.example',
            sub                => 'subject-1',
            aud                => 'otobo',
            iat                => 1_700_000_001,
            preferred_username => 'agent',
        },
        IDToken => $Param{IDToken} // 'id-token',
        Success => exists $Param{Success} ? $Param{Success} : 1,
    );
    my $Request = Local::OIDCAuth::Request->new(
        State => $State . 'https%3A%2F%2Fotobo.example%2Fotobo%2Findex.pl',
        CSRF  => $State,
    );
    local $Kernel::OM = Local::OIDCAuth::Manager->new(
        Config   => $Config,
        Cache    => $Cache,
        Provider => $Provider,
        Request  => $Request,
        User     => Local::OIDCAuth::User->new(),
        Log      => Local::OIDCAuth::Log->new(),
        Storable => Kernel::System::Storable->new(),
    );

    my $Backend  = $Param{Backend} // Kernel::System::Auth::OpenIDConnect->new();
    my $Result   = $Backend->Auth();
    my $PostAuth = $Backend->PostAuth();

    return {
        Result   => $Result,
        PostAuth => $PostAuth,
        Provider => $Provider,
        Backend  => $Backend
    };
}

sub AdminSwitchCase {
    my (%Param) = @_;
    my $Objects = Local::AdminSwitch::Objects->new(%Param);
    local $Kernel::OM = Local::AdminSwitch::Manager->new( Objects => $Objects );

    my $Module = Kernel::Modules::AdminUser->new(
        Action    => 'AdminUser',
        Subaction => 'Switch',
        UserID    => 1,
        UserLogin => 'administrator',
        SessionID => 'original-session',
    );
    eval { $Module->Run(); 1 };
    die $@ if $@ !~ /ADMINUSER_SESSION_CAPTURED/;

    return $Objects->{Session}->{CreatedData};
}

package Local::Integration::Manager;

sub new {
    my ( $Class, %Param ) = @_;
    my %Objects = (
        'Kernel::Config'                                   => $Param{Config},
        'Kernel::System::User'                             => $Param{User},
        'Kernel::System::Cache'                            => $Param{Cache},
        'Kernel::System::Main'                             => $Param{Main},
        'Kernel::System::OpenIDConnect::BackchannelLogout' => $Param{Logout},
        'Kernel::System::SystemMaintenance'                => Local::Integration::Maintenance->new(),
    );
    return bless {
        Objects => \%Objects,
        State   => $Param{State}
    }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Objects}->{$Name}       if $Self->{Objects}->{$Name};
    return Kernel::System::Storable->new() if $Name eq 'Kernel::System::Storable';
    return;
}

sub Create {
    my ($Self) = @_;
    return Local::Integration::DateTime->new();
}

sub ObjectParamAdd {
    my ($Self) = @_;
    return 1;
}

package Local::Integration::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { Values => \%Param }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Values}->{$Name};
}

package Local::Integration::User;      ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub UserLookup {
    my ( $Self, %Param ) = @_;
    return 41;
}

sub SetPreferences {
    my ( $Self, %Param ) = @_;
    return 1;
}

package Local::Integration::Backend;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless \%Param, $Class;
}

sub Auth {
    my ($Self) = @_;
    return $Self->{Result};
}

sub PostAuth {
    my ($Self) = @_;
    return $Self->{PostAuth};
}

package Local::Integration::Maintenance;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub SystemMaintenanceIsActive {
    my ($Self) = @_;
    return 0;
}

package Local::Integration::DateTime;       ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub ToEpoch {
    my ($Self) = @_;
    return 1_800_000_000;
}

package Local::Integration::Cache;          ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub Delete {
    my ( $Self, %Param ) = @_;
    return 1;
}

package Local::Integration::Main;           ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub Require {
    my ( $Self, $Module ) = @_;
    return 1;
}

package Local::Integration::Logout;         ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        Decisions => $Param{Decisions},
        Calls     => 0
    }, $Class;
}

sub SessionAllowed {
    my ($Self) = @_;
    $Self->{Calls}++;
    return shift @{ $Self->{Decisions} };
}

package Local::Integration::State;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {
        SessionData => {},
        Removed     => [],
        CreateCalls => 0
    }, $Class;
}

sub Reset {
    my ($Self) = @_;
    $Self->{SessionData} = {};
    $Self->{Removed}     = [];
    $Self->{CreateCalls} = 0;
    return 1;
}

package Local::Integration::SessionBackend;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;
    my $State = $Kernel::OM->{State};
    $State->{CreateCalls}++;
    $State->{SessionData}->{'session-1'} = \%Param;
    return 'session-1';
}

sub RemoveSessionID {
    my ( $Self, %Param ) = @_;
    my $State = $Kernel::OM->{State};
    push @{ $State->{Removed} }, $Param{SessionID};
    delete $State->{SessionData}->{ $Param{SessionID} };
    return 1;
}

sub CheckSessionID {
    my ( $Self, %Param ) = @_;
    return exists $Kernel::OM->{State}->{SessionData}->{ $Param{SessionID} };
}

sub GetSessionIDData {
    my ( $Self, %Param ) = @_;
    return %{ $Kernel::OM->{State}->{SessionData}->{ $Param{SessionID} } // {} };
}

package Local::OIDCAuth::Manager;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    my %Objects = (
        'Kernel::Config'                => $Param{Config},
        'Kernel::System::Cache'         => $Param{Cache},
        'Kernel::System::Main'          => $Param{Main},
        'Kernel::System::OpenIDConnect' => $Param{Provider},
        'Kernel::System::Web::Request'  => $Param{Request},
        'Kernel::Output::HTML::Layout'  => $Param{Layout},
        'Kernel::System::User'          => $Param{User},
        'Kernel::System::Log'           => $Param{Log},
        'Kernel::System::Storable'      => $Param{Storable},
    );
    return bless { Objects => \%Objects }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Objects}->{$Name};
}

package Local::OIDCAuth::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    my $Values = {
        'AuthModule::OpenIDConnect::AuthRequest' => { ResponseType => ['code'] },
        'AuthModule::OpenIDConnect::Config'      => {
            ClientSettings   => { ClientID => 'otobo' },
            ProviderSettings => { Issuer   => 'https://issuer.example' },
            Misc             => {
                BackchannelLogout => $Param{BackchannelLogout} // 0,
                UsePKCE           => $Param{UsePKCE}           // 0,
                UseIDTokenHint    => $Param{UseIDTokenHint}    // 0,
                RandLength        => 22,
                RandTTL           => 300,
            },
        },
        'AuthModule::OpenIDConnect::UID' => 'preferred_username',
    };
    return bless { Values => $Values }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Values}->{$Name};
}

package Local::OIDCAuth::Cache;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        Values => $Param{Values} // {},
        Writes => []
    }, $Class;
}

sub Get {
    my ( $Self, %Param ) = @_;
    return $Self->{Values}->{ $Param{Key} };
}

sub Set {
    my ( $Self, %Param ) = @_;
    $Self->{Values}->{ $Param{Key} } = $Param{Value};
    push @{ $Self->{Writes} }, \%Param;
    return 1;
}

sub Delete {
    my ( $Self, %Param ) = @_;
    delete $Self->{Values}->{ $Param{Key} };
    return 1;
}

package Local::OIDCAuth::Main;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub GenerateRandomString {
    my ( $Self, %Param ) = @_;
    return ( $Param{Length} // 0 ) == 64 ? 'v' x 64 : 's' x ( $Param{Length} // 0 );
}

package Local::OIDCAuth::Layout;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub SetCookie {
    my ( $Self, %Param ) = @_;
    return 1;
}

package Local::OIDCAuth::Request;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        Params => {
            code  => 'authorization-code',
            state => $Param{State},
        },
        Cookies => { 'OIDCCSRF-' . ( $Param{CSRF} // '' ) => $Param{CSRF} // '' },
    }, $Class;
}

sub GetParam {
    my ( $Self, %Param ) = @_;
    return $Self->{Params}->{ $Param{Param} };
}

sub GetCookie {
    my ( $Self, %Param ) = @_;
    return $Self->{Cookies}->{ $Param{Key} };
}

package Local::OIDCAuth::Provider;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        TokenData       => $Param{TokenData} // {},
        IDToken         => $Param{IDToken}   // 'id-token',
        Success         => exists $Param{Success} ? $Param{Success} : 1,
        CodeRequests    => 0,
        ValidationCalls => 0,
    }, $Class;
}

sub BuildRedirectURL {
    my ( $Self, %Param ) = @_;
    $Self->{RedirectParam} = \%Param;
    return 'https://issuer.example/authorize';
}

sub RequestIDToken {
    my ( $Self, %Param ) = @_;
    $Self->{CodeRequests}++;
    $Self->{CodeVerifier} = $Param{CodeVerifier};
    return $Self->{IDToken};
}

sub ValidateIDToken {
    my ($Self) = @_;
    $Self->{ValidationCalls}++;
    return {
        Success   => $Self->{Success},
        TokenData => $Self->{TokenData}
    };
}

package Local::OIDCAuth::User;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub GetUserData {
    my ( $Self, %Param ) = @_;
    return (
        UserID    => 1,
        UserLogin => 'agent',
    );
}

package Local::OIDCAuth::Log;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub Log {
    my ( $Self, %Param ) = @_;
    return 1;
}

package Local::AdminSwitch::Manager;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { Objects => $Param{Objects} }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Objects}->{$Name};
}

sub Create {
    my ($Self) = @_;
    return Local::AdminSwitch::DateTime->new();
}

package Local::AdminSwitch::Objects;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    my %Objects = (
        'Kernel::Config'               => Local::AdminSwitch::Config->new(),
        'Kernel::System::User'         => Local::AdminSwitch::User->new( TargetUserData => $Param{TargetUserData} ),
        'Kernel::System::Web::Request' => Local::AdminSwitch::Request->new(),
        'Kernel::Output::HTML::Layout' => Local::AdminSwitch::Layout->new(),
        'Kernel::System::AuthSession'  => Local::AdminSwitch::Session->new( CurrentSession => $Param{CurrentSession} ),
        'Kernel::System::Valid'        => Local::AdminSwitch::Valid->new(),
        'Kernel::System::Log'          => Local::AdminSwitch::Log->new(),
        'Kernel::System::Main'         => Local::AdminSwitch::Unused->new(),
        'Kernel::System::CheckItem'    => Local::AdminSwitch::Unused->new(),
    );
    return bless { %Objects, Session => $Objects{'Kernel::System::AuthSession'} }, $Class;
}

package Local::AdminSwitch::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Name eq 'SwitchToUser' ? 1 : undef;
}

package Local::AdminSwitch::User;      ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { TargetUserData => $Param{TargetUserData} }, $Class;
}

sub GetPreferences {
    my ( $Self, %Param ) = @_;
    return;
}

sub GetUserData {
    my ( $Self, %Param ) = @_;
    return %{ $Self->{TargetUserData} };
}

package Local::AdminSwitch::Request;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub GetParam {
    my ( $Self, %Param ) = @_;
    return $Param{Param} eq 'UserID' ? 42 : undef;
}

package Local::AdminSwitch::Layout;     ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub ChallengeTokenCheck {
    my ($Self) = @_;
    return 1;
}

package Local::AdminSwitch::Session;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { CurrentSession => $Param{CurrentSession} }, $Class;
}

sub GetSessionIDData {
    my ( $Self, %Param ) = @_;
    return %{ $Self->{CurrentSession} };
}

sub CreateSessionID {
    my ( $Self, %Param ) = @_;
    $Self->{CreatedData} = \%Param;
    die "ADMINUSER_SESSION_CAPTURED\n";
}

package Local::AdminSwitch::Valid;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub ValidIDsGet {
    my ($Self) = @_;
    return (1);
}

package Local::AdminSwitch::DateTime;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub ToEpoch {
    my ($Self) = @_;
    return 1_800_000_000;
}

package Local::AdminSwitch::Log;         ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

sub Log {
    my ( $Self, %Param ) = @_;
    return 1;
}

package Local::AdminSwitch::Unused;      ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}
