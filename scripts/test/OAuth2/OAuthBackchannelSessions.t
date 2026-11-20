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

use Test2::V0;
use Kernel::System::AuthSession::FS;
use Kernel::System::ObjectManager ();
use Kernel::System::UnitTest::RegisterOM;
use Kernel::System::OpenIDConnect::BackchannelLogout;

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();
$DBObject->BeginWork();

my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
my $LogoutObject      = $Kernel::OM->Get('Kernel::System::OpenIDConnect::BackchannelLogout');
my $MainObject        = $Kernel::OM->Get('Kernel::System::Main');

$ConfigObject->Set(
    Key   => 'AgentSessionLimit',
    Value => 1000,
);
$ConfigObject->Set(
    Key   => 'AgentSessionPerUserLimit',
    Value => 1000,
);

sub SessionCreate {
    my (%Param) = @_;

    my $SkipRevocationCheck = delete $Param{SkipRevocationCheck};
    my %SessionData         = (
        UserID          => 1,
        UserLogin       => $Param{Login} || 'oidc.test',
        UserLastRequest => time,
        UserType        => 'User',
        SessionSource   => 'AgentInterface',
    );
    $SessionData{OIDCSession} = $Param{OIDCSession} if defined $Param{OIDCSession};

    return $SkipRevocationCheck
        ? $AuthSessionObject->{Backend}->CreateSessionID(%SessionData)
        : $AuthSessionObject->CreateSessionID(%SessionData);
}

sub SessionExists {
    my ($SessionID) = @_;

    my %Data = $AuthSessionObject->GetSessionIDData(
        SessionID => $SessionID,
    );

    return %Data ? 1 : 0;
}

sub OIDCData {
    my (%Param) = @_;

    return {
        Issuer    => $Param{Issuer}   || 'https://issuer.example/realm',
        ClientID  => $Param{ClientID} || 'otobo',
        Subject   => $Param{Subject}  || 'user-1',
        SessionID => $Param{SessionID},
        IssuedAt  => $Param{IssuedAt},
        StartedAt => $Param{StartedAt} // $Param{IssuedAt},
    };
}

my $Now    = time;
my $Issuer = 'https://issuer.example/realm';

my $TargetSessionID = SessionCreate(
    OIDCSession => OIDCData(
        SessionID => 'op-session-a',
        IssuedAt  => $Now - 10,
    ),
);
my $OtherSessionID = SessionCreate(
    OIDCSession => OIDCData(
        SessionID => 'op-session-b',
        IssuedAt  => $Now - 10,
    ),
);
my $OtherClientSessionID = SessionCreate(
    OIDCSession => OIDCData(
        ClientID  => 'other-client',
        SessionID => 'op-session-a',
        IssuedAt  => $Now - 10,
    ),
);
my $OtherSubjectSessionID = SessionCreate(
    OIDCSession => OIDCData(
        Subject   => 'user-2',
        SessionID => 'op-session-a',
        IssuedAt  => $Now - 10,
    ),
);
my $OtherIssuerSessionID = SessionCreate(
    OIDCSession => OIDCData(
        Issuer    => 'https://other.example/realm',
        SessionID => 'op-session-a',
        IssuedAt  => $Now - 10,
    ),
);
my $RefreshedSameSIDSessionID = SessionCreate(
    OIDCSession => OIDCData(
        SessionID => 'op-session-a',
        IssuedAt  => $Now,
        StartedAt => $Now - 10,
    ),
);
my $NewerSessionID = SessionCreate(
    OIDCSession => OIDCData(
        SessionID => 'op-session-new',
        IssuedAt  => $Now,
    ),
);
my $PasswordSessionID = $AuthSessionObject->CreateSessionID(
    UserID        => 1,
    UserLogin     => 'oidc.test',
    UserType      => 'User',
    SessionSource => 'AgentInterface',
);

for my $CreatedSessionID (
    $TargetSessionID,
    $OtherSessionID,
    $OtherClientSessionID,
    $OtherSubjectSessionID,
    $OtherIssuerSessionID,
    $RefreshedSameSIDSessionID,
    $NewerSessionID,
    $PasswordSessionID,
    )
{
    ok( $CreatedSessionID, 'created session fixture' );
}

my $LogoutClaims = {
    iss => $Issuer,
    aud => 'otobo',
    sub => 'user-1',
    sid => 'op-session-a',
    iat => $Now - 5,
    exp => $Now + 120,
    jti => $MainObject->GenerateRandomString( Length => 32 ),
};

ok(
    $LogoutObject->Revoke(
        Claims        => $LogoutClaims,
        ClientID      => 'otobo',
        SessionObject => $AuthSessionObject,
    ),
    'stored sid logout marker and removed matching sessions',
);

ok( !SessionExists($TargetSessionID),           'removed old session with matching sid, subject and client' );
ok( !SessionExists($RefreshedSameSIDSessionID), 'removed same-sid session despite its newer ID token' );
ok( SessionExists($OtherSessionID),             'preserved session with a different sid' );
ok( SessionExists($OtherClientSessionID),       'preserved session for a different client' );
ok( SessionExists($OtherSubjectSessionID),      'preserved session for a different subject' );
ok( SessionExists($OtherIssuerSessionID),       'preserved session for a different issuer' );
ok( SessionExists($NewerSessionID),             'preserved newer session with the same sid' );
ok( SessionExists($PasswordSessionID),          'preserved password session for the same OTOBO user' );

is(
    $LogoutObject->SessionAllowed(
        Session => OIDCData(
            SessionID => 'op-session-a',
            IssuedAt  => $Now - 10,
        ),
    ),
    0,
    'rejects an OIDC callback that completes after the logout scan',
);
is(
    $LogoutObject->SessionAllowed(
        Session => OIDCData(
            SessionID => 'op-session-new',
            IssuedAt  => $Now,
            StartedAt => $Now,
        ),
    ),
    1,
    'allows a newer OIDC session after logout',
);
is(
    $LogoutObject->SessionAllowed(
        Session => OIDCData(
            SessionID => 'op-session-a',
            IssuedAt  => $Now,
            StartedAt => $Now - 10,
        ),
    ),
    0,
    'sid logout rejects a delayed callback with a newer token issuance time',
);

my $DelayedCallbackID = SessionCreate(
    SkipRevocationCheck => 1,
    OIDCSession         => OIDCData(
        SessionID => 'op-session-a',
        IssuedAt  => $Now,
        StartedAt => $Now - 10,
    ),
);
is(
    $LogoutObject->SessionAllowed(
        Session => OIDCData(
            SessionID => 'op-session-a',
            IssuedAt  => $Now,
            StartedAt => $Now - 10,
        ),
    ),
    0,
    'durable marker rejects a delayed callback session created after logout',
);
ok(
    $LogoutObject->Revoke(
        Claims        => $LogoutClaims,
        ClientID      => 'otobo',
        SessionObject => $AuthSessionObject,
    ),
    'same verified logout is idempotent',
);
ok( !SessionExists($DelayedCallbackID), 'retry removed a delayed callback session after partial processing' );

my $SubOnlySessionID = SessionCreate(
    OIDCSession => OIDCData(
        SessionID => 'op-session-c',
        IssuedAt  => $Now - 10,
    ),
);
my $SubOnlyNewerSessionID = SessionCreate(
    OIDCSession => OIDCData(
        SessionID => 'op-session-d',
        IssuedAt  => $Now,
    ),
);
my $SubOnlyClaims = {
    iss => $Issuer,
    aud => 'otobo',
    sub => 'user-1',
    iat => $Now - 4,
    exp => $Now + 120,
    jti => $MainObject->GenerateRandomString( Length => 32 ),
};

ok(
    $LogoutObject->Revoke(
        Claims        => $SubOnlyClaims,
        ClientID      => 'otobo',
        Leeway        => 3,
        SessionObject => $AuthSessionObject,
    ),
    'stored sub-only logout marker',
);
ok( !SessionExists($SubOnlySessionID),     'sub-only logout removed matching old sessions across OP sessions' );
ok( SessionExists($SubOnlyNewerSessionID), 'sub-only logout preserved a newer session' );

my $DelayedSubCallbackID = SessionCreate(
    SkipRevocationCheck => 1,
    OIDCSession         => OIDCData(
        SessionID => 'op-session-e',
        IssuedAt  => $Now,
        StartedAt => $Now - 10,
    ),
);
is(
    $LogoutObject->SessionAllowed(
        Session => OIDCData(
            SessionID => 'op-session-e',
            IssuedAt  => $Now,
            StartedAt => $Now - 10,
        ),
    ),
    0,
    'sub-only logout rejects delayed callback despite its newer ID token',
);
ok(
    $LogoutObject->Revoke(
        Claims        => $SubOnlyClaims,
        ClientID      => 'otobo',
        Leeway        => 3,
        SessionObject => $AuthSessionObject,
    ),
    'replayed sub-only logout removes delayed callback session',
);
ok( !SessionExists($DelayedSubCallbackID), 'removed delayed sub-only callback session' );

my $UnicodeSessionID = SessionCreate(
    OIDCSession => OIDCData(
        Subject   => 'użytkownik-ąć',
        SessionID => 'sesja-ż',
        IssuedAt  => $Now - 10,
    ),
);
my $UnicodeClaims = {
    iss => $Issuer,
    aud => 'otobo',
    sub => 'użytkownik-ąć',
    sid => 'sesja-ż',
    iat => $Now - 5,
    exp => $Now + 120,
    jti => 'logout-ż-1',
};
ok(
    $LogoutObject->Revoke(
        Claims        => $UnicodeClaims,
        ClientID      => 'otobo',
        SessionObject => $AuthSessionObject,
    ),
    'stored a logout marker with Unicode claims',
);
ok( !SessionExists($UnicodeSessionID), 'matched and removed a session with Unicode claims' );

# A separate FS session object simulates an in-flight request with a cached copy.
my $OriginalSessionModule = $ConfigObject->Get('SessionModule') || 'Kernel::System::AuthSession::DB';
$ConfigObject->Set(
    Key   => 'SessionModule',
    Value => 'Kernel::System::AuthSession::FS',
);
$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::System::AuthSession'],
);
$AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

my $FSSessionID = SessionCreate(
    OIDCSession => OIDCData(
        Subject   => 'fs-user',
        SessionID => 'op-session-fs',
        IssuedAt  => $Now - 10,
    ),
);
my $StaleFSBackend   = Kernel::System::AuthSession::FS->new();
my %StaleSessionData = $StaleFSBackend->GetSessionIDData(
    SessionID => $FSSessionID,
);
ok( $StaleSessionData{OIDCSession},                                  'cached an in-flight filesystem session copy' );
ok( $AuthSessionObject->CheckSessionID( SessionID => $FSSessionID ), 'filesystem session is valid before logout' );

my $FSToken = {
    %{$LogoutClaims},
    sub => 'fs-user',
    sid => 'op-session-fs',
    jti => $MainObject->GenerateRandomString( Length => 32 ),
};
ok(
    $LogoutObject->Revoke(
        Claims        => $FSToken,
        ClientID      => 'otobo',
        SessionObject => $AuthSessionObject,
    ),
    'revoked filesystem session',
);
$StaleFSBackend->DESTROY();

my %ResurrectedSession = $AuthSessionObject->GetSessionIDData(
    SessionID => $FSSessionID,
    NoCache   => 1,
);
ok( $ResurrectedSession{OIDCSession}, 'stale in-flight request rewrote the deleted session' );
is(
    $LogoutObject->SessionAllowed( Session => $ResurrectedSession{OIDCSession} ),
    0,
    'durable marker rejects the rewritten filesystem session',
);
ok(
    !$AuthSessionObject->CheckSessionID( SessionID => $FSSessionID ),
    'rejected a filesystem session rewritten by a stale request',
);
ok(
    !$AuthSessionObject->GetSessionIDData( SessionID => $FSSessionID ),
    'removed the rewritten filesystem session after the revocation check',
);

$AuthSessionObject->RemoveSessionID( SessionID => $SubOnlyNewerSessionID );
$AuthSessionObject->RemoveSessionID( SessionID => $NewerSessionID );
$AuthSessionObject->RemoveSessionID( SessionID => $PasswordSessionID );
$AuthSessionObject->RemoveSessionID( SessionID => $FSSessionID );
$ConfigObject->Set(
    Key   => 'SessionModule',
    Value => $OriginalSessionModule,
);
$Kernel::OM->ObjectsDiscard(
    Objects => ['Kernel::System::AuthSession'],
);

my $ExpiredKey = $LogoutObject->_TombstoneKey(
    Issuer     => $Issuer,
    ClientID   => 'expiry-test',
    TargetType => 'sub',
    Target     => 'expiry-subject',
    JTI        => 'expired-marker',
);
ok(
    $LogoutObject->_TombstoneStore(
        Key   => $ExpiredKey,
        Value => {
            IssuedAt => time,
            Expires  => time - 1
        },
    ),
    'created an expired marker fixture',
);
is(
    $LogoutObject->SessionAllowed(
        Session => OIDCData(
            ClientID => 'expiry-test',
            Subject  => 'expiry-subject',
            IssuedAt => time - 10
        ),
    ),
    1,
    'expired marker no longer revokes sessions',
);
ok( $LogoutObject->_ExpiredTombstonesRemove(), 'expired marker cleanup succeeds' );
is( $LogoutObject->_RowsGet( Key => $ExpiredKey ), [], 'cleanup removes expired marker' );
isnt(
    $LogoutObject->_RowsGet( Prefix => 'OIDCLogout::' ),
    [],
    'cleanup preserves live markers',
);

{
    my $MockDB = mock $DBObject => ( override => [ Do => sub {return} ] );
    ok(
        !$LogoutObject->_TombstoneStore(
            Key   => $ExpiredKey,
            Value => {
                IssuedAt => time,
                Expires  => time + 120
            },
        ),
        'failed insert without an existing duplicate cannot report success',
    );
}

$DBObject->Rollback();

{
    my $MockDB = mock $DBObject => (
        override => [
            Prepare       => sub { return 1 },
            FetchrowArray => sub {return},
            Error         => sub { return 'simulated fetch failure' },
        ],
    );
    is( $LogoutObject->SessionAllowed( Session => OIDCData( IssuedAt => time ) ), undef, 'row-fetch failure cannot allow a session' );
}

{
    my $MockDB = mock $DBObject => (
        override => [ Prepare => sub {return} ],
    );
    is( $LogoutObject->SessionAllowed( Session => OIDCData( IssuedAt => time ) ), undef, 'query failure cannot allow a session' );
}

my $CrossProcessClaims = {
    iss => 'https://fork-' . $MainObject->GenerateRandomString( Length => 16 ) . '.example/realm',
    aud => 'otobo-fork-test',
    sub => 'cross-process-user',
    sid => 'cross-process-session',
    iat => time,
    exp => time + 120,
    jti => 'cross-' . $MainObject->GenerateRandomString( Length => 24 ),
};
my $CrossProcessKey = $LogoutObject->_TombstoneKey(
    Issuer     => $CrossProcessClaims->{iss},
    ClientID   => $CrossProcessClaims->{aud},
    TargetType => 'sid',
    Target     => $CrossProcessClaims->{sid},
    JTI        => $CrossProcessClaims->{jti},
);
ok(
    $LogoutObject->Revoke(
        Claims        => $CrossProcessClaims,
        ClientID      => $CrossProcessClaims->{aud},
        SessionObject => Kernel::System::AuthSession->new(),
    ),
    'committed a unique logout marker for cross-process visibility test',
);

$DBObject->Disconnect();
my $ChildPID = fork();
if ( !defined $ChildPID ) {
    ok( 0, 'forked a second process for durable marker check' );
}
elsif ( !$ChildPID ) {
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ChildDB           = $Kernel::OM->Get('Kernel::System::DB');
    my $Connected         = $ChildDB->Connect();
    my $ChildLogoutObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::BackchannelLogout');
    my $ChildSession      = {
        Issuer    => $CrossProcessClaims->{iss},
        ClientID  => $CrossProcessClaims->{aud},
        Subject   => $CrossProcessClaims->{sub},
        SessionID => $CrossProcessClaims->{sid},
        IssuedAt  => $CrossProcessClaims->{iat},
        StartedAt => $CrossProcessClaims->{iat},
    };
    my $Revoked           = $Connected && !$ChildLogoutObject->SessionAllowed( Session => $ChildSession );
    my $DuplicateAccepted = $Revoked   && $ChildLogoutObject->Revoke(
        Claims        => $CrossProcessClaims,
        ClientID      => $CrossProcessClaims->{aud},
        SessionObject => $Kernel::OM->Get('Kernel::System::AuthSession'),
    );
    exit( $DuplicateAccepted ? 0 : 1 );
}
else {
    waitpid( $ChildPID, 0 );
    is( $? >> 8, 0, 'second process observed durable revocation and accepted duplicate delivery' );
}

$DBObject->Connect();
ok(
    $DBObject->Do(
        SQL  => 'DELETE FROM system_data WHERE data_key = ?',
        Bind => [ \$CrossProcessKey ],
    ),
    'removed the exact cross-process test marker',
);

done_testing;
