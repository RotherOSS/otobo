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
use utf8;

# core modules
use Digest::SHA qw(sha256_hex);
use FindBin     qw($Bin);

# CPAN modules
use Crypt::JWT qw(encode_jwt);
use JSON       qw(decode_json);
use LWP::UserAgent;
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
$MainObject->Require("$Bin/OAuthProviderMock");

$OAuthProviderMock::KidID || $OAuthProviderMock::PrivateKey || 0;    # prevent warnings

sleep 1;

my $CacheObject       = $Kernel::OM->Get('Kernel::System::Cache');
my $OIDCConfiguration = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
my $TokenObject       = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');
my $OpenIDConfig      = OAuthProviderMock::GetTestOpenIDConfig();

$OIDCConfiguration->GetProviderData(
    OpenIDConfig => $OpenIDConfig,
    NoCache      => 1,
);

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
$DBObject->Connect();
$DBObject->BeginWork();
$CacheObject->CleanUp();

my $LogoutEvent = 'http://schemas.openid.net/event/backchannel-logout';

sub MakeLogoutToken {
    my (%Param) = @_;

    my $Payload = OAuthProviderMock::Payload(
        Audience => $Param{Audience} // 'otobo',
    );
    $Payload->{exp}    = $CurrentTime + 120;
    $Payload->{iat}    = $CurrentTime;
    $Payload->{iss}    = 'http://localhost:2007/realms/master';
    $Payload->{sub}    = 'user-123';
    $Payload->{sid}    = 'session-123';
    $Payload->{jti}    = 'logout-123';
    $Payload->{events} = { $LogoutEvent => {} };

    for my $Claim ( keys %{ $Param{Claims} // {} } ) {
        if ( defined $Param{Claims}{$Claim} ) {
            $Payload->{$Claim} = $Param{Claims}{$Claim};
        }
        else {
            $Payload->{$Claim} = undef;
        }
    }
    delete $Payload->{$_} for @{ $Param{RemoveClaims} // [] };

    my %Header = (
        kid => $Param{Kid} // $OAuthProviderMock::KidID,
    );
    $Header{typ} = $Param{HeaderType} if exists $Param{HeaderType};
    $Header{typ} = 'logout+jwt'       if !exists $Param{HeaderType} && !$Param{OmitHeaderType};

    my %EncodeParam = (
        payload       => $Payload,
        alg           => $Param{Algorithm} // 'RS256',
        key           => $Param{Key}       // $OAuthProviderMock::PrivateKey,
        extra_headers => \%Header,
    );
    $EncodeParam{allow_none} = 1 if $EncodeParam{alg} eq 'none';

    return encode_jwt(%EncodeParam);
}

sub Validate {
    my (%Param) = @_;
    my $Token = $Param{Token} // MakeLogoutToken(%Param);
    return $TokenObject->ValidateLogout(
        Token            => $Token,
        OpenIDConfig     => $OpenIDConfig,
        ExpectedAudience => $Param{ExpectedAudience} // 'otobo',
        ( exists $Param{SigningAlgorithm} ? ( SigningAlgorithm => $Param{SigningAlgorithm} ) : () ),
        Leeway => 0,
    );
}

my $Claims = Validate();
ok( $Claims, 'valid signed logout token accepted' );
is( $Claims->{sid}, 'session-123', 'session claim returned' );

$Claims = Validate( RemoveClaims => ['sub'] );
ok( $Claims, 'sid-only token accepted' );

$Claims = Validate( RemoveClaims => ['sid'] );
ok( $Claims, 'sub-only token accepted' );

$Claims = Validate( Audience => [ 'account', 'otobo' ] );
ok( $Claims, 'audience array accepted' );

$Claims = Validate( HeaderType => 'JWT' );
ok( $Claims, 'legacy JWT typ accepted' );

$Claims = Validate( OmitHeaderType => 1 );
ok( $Claims, 'missing typ accepted' );

ok(
    Validate(
        Algorithm        => 'RS384',
        SigningAlgorithm => 'RS384'
    ),
    'explicitly configured signing algorithm accepted'
);
ok( !Validate( Algorithm => 'RS384' ), 'unconfigured signing algorithm rejected' );

my $UA = LWP::UserAgent->new( timeout => 10 );
GetMockHTTPLog();

my $BadSignatureToken = MakeLogoutToken();
my ( $Header, $Payload, $Signature ) = split /\./, $BadSignatureToken;
$Signature         = ( $Signature =~ /\AA/ ? 'B' : 'A' ) . substr( $Signature, 1 );
$BadSignatureToken = join '.', $Header, $Payload, $Signature;

my @Invalid = (
    [ 'wrong signature',                              { Token        => $BadSignatureToken } ],
    [ 'wrong issuer',                                 { Claims       => { iss => 'https://other.example/' } } ],
    [ 'audience substring does not match',            { Audience     => 'prefix-otobo-suffix' } ],
    [ 'wrong JOSE typ',                               { HeaderType   => 'id+jwt' } ],
    [ 'missing issuer',                               { RemoveClaims => ['iss'] } ],
    [ 'missing audience',                             { RemoveClaims => ['aud'] } ],
    [ 'missing issued-at',                            { RemoveClaims => ['iat'] } ],
    [ 'missing expiry',                               { RemoveClaims => ['exp'] } ],
    [ 'missing jti',                                  { RemoveClaims => ['jti'] } ],
    [ 'missing events',                               { RemoveClaims => ['events'] } ],
    [ 'missing sid and sub',                          { RemoveClaims => [ 'sid', 'sub' ] } ],
    [ 'empty jti',                                    { Claims       => { jti => '' } } ],
    [ 'malformed audience array',                     { Audience     => [ 'otobo', [] ] } ],
    [ 'wrong event URI',                              { Claims       => { events => { 'https://example.com/logout' => {} } } } ],
    [ 'event value is not an object',                 { Claims       => { events => { $LogoutEvent                 => [] } } } ],
    [ 'nonce is prohibited even when null',           { Claims       => { nonce  => undef } } ],
    [ 'empty sid is invalid when present',            { Claims       => { sid    => '' } } ],
    [ 'non-object sid is invalid',                    { Claims       => { sid    => [] } } ],
    [ 'non-numeric issued-at',                        { Claims       => { iat    => 'now' } } ],
    [ 'non-finite expiry encoding is rejected',       { Claims       => { exp    => '1e9999' } } ],
    [ 'expiry beyond safe numeric range is rejected', { Claims       => { exp    => 9_007_199_254_740_992 } } ],
    [ 'expired token',                                { Claims       => { exp    => $CurrentTime - 1 } } ],
    [ 'future issued-at',                             { Claims       => { iat    => $CurrentTime + 120 } } ],
    [
        'expiry must follow issued-at',
        {
            Claims => {
                iat => $CurrentTime + 60,
                exp => $CurrentTime + 60
            }
        }
    ],
    [ 'unsupported configured signing algorithm', { SigningAlgorithm => 'ES256K' } ],
    [
        'HMAC algorithm is rejected',
        {
            Algorithm => 'HS256',
            Key       => 'test-secret-that-is-long-enough-for-hmac256'
        }
    ],
    [
        'algorithm none is rejected',
        {
            Algorithm => 'none',
            Key       => ''
        }
    ],
    [ 'wrong expected audience', { ExpectedAudience => 'unknown-client' } ],
    [ 'untrusted header key id', { Kid              => 'unknown-key' } ],
);

for my $Test (@Invalid) {
    my ( $Name, $Param ) = @$Test;
    my $Result = Validate( %{$Param} );
    is( $Result, undef, $Name );
}

my $UnknownKeyRefreshLog = GetMockHTTPLog();
is(
    [ map { $_->{endpoint} } @{$UnknownKeyRefreshLog} ],
    [ 'openid', 'jwks' ],
    'unknown kid causes one discovery and JWKS refresh',
);

for my $Try ( 1 .. 8 ) {
    is( Validate( Kid   => "random-key-$Try" ),  undef, "random kid $Try rejected" );
    is( Validate( Token => $BadSignatureToken ), undef, "known kid bad signature $Try rejected" );
}

my $AmplificationLog = GetMockHTTPLog();
is( $AmplificationLog, [], 'random kids and bad signatures do not refresh JWKS during cooldown' );

$CacheObject->Delete(
    Type => 'OpenIDConnect',
    Key  => 'BackchannelLogoutJWKSRefresh::' . sha256_hex(
        join "\0", $OpenIDConfig->{ProviderSettings}{OpenIDConfiguration}, $OpenIDConfig->{ProviderSettings}{Name}
    ),
    CacheInMemory => 0,
);
my $RotateOnRefresh         = 1;
my $OriginalProviderDataGet = \&Kernel::System::OpenIDConnect::Configuration::GetProviderData;
{
    no warnings 'redefine';    ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
    local *Kernel::System::OpenIDConnect::Configuration::GetProviderData = sub {
        my ( $Self, %Param ) = @_;
        my $ProviderData = $OriginalProviderDataGet->( $Self, %Param );

        if ( $RotateOnRefresh && $Param{NoCache} ) {
            my $RotatedData = {
                %{$ProviderData},
                KeyData => {
                    %{ $ProviderData->{KeyData} },
                    keys => [
                        @{ $ProviderData->{KeyData}{keys} },
                        { %{ $ProviderData->{KeyData}{keys}[0] }, kid => 'rotated-key' },
                    ],
                },
            };
            $CacheObject->Set(
                Type          => 'OpenIDConnect',
                Key           => 'ProviderDataUnitTest',
                Value         => $RotatedData,
                TTL           => 1800,
                CacheInMemory => 0,
            );
            $RotateOnRefresh = 0;
            return $RotatedData;
        }

        return $ProviderData;
    };

    $Claims = Validate( Kid => 'rotated-key' );
    ok( $Claims, 'unknown kid is accepted after JWKS rotation refresh' );
}

my $RotationRefreshLog = GetMockHTTPLog();
is(
    [ map { $_->{endpoint} } @{$RotationRefreshLog} ],
    [ 'openid', 'jwks' ],
    'rotated kid refreshes discovery and JWKS once',
);

my $NamelessOpenIDConfig = {
    %{$OpenIDConfig},
    ProviderSettings => { %{ $OpenIDConfig->{ProviderSettings} } },
};
delete $NamelessOpenIDConfig->{ProviderSettings}{Name};
$OIDCConfiguration->GetProviderData(
    OpenIDConfig => $NamelessOpenIDConfig,
    NoCache      => 1,
);
GetMockHTTPLog();

my $NamelessToken = MakeLogoutToken( Kid => 'nameless-unknown-key' );
is(
    $TokenObject->ValidateLogout(
        Token            => $NamelessToken,
        OpenIDConfig     => $NamelessOpenIDConfig,
        ExpectedAudience => 'otobo',
    ),
    undef,
    'nameless provider still refreshes unknown keys',
);

my $NamelessRefreshLog = GetMockHTTPLog();
is(
    [ map { $_->{endpoint} } @{$NamelessRefreshLog} ],
    [ 'openid', 'jwks' ],
    'nameless provider performs one discovery and JWKS refresh',
);

for my $Try ( 1 .. 8 ) {
    my $Token = MakeLogoutToken( Kid => "nameless-random-key-$Try" );
    is(
        $TokenObject->ValidateLogout(
            Token            => $Token,
            OpenIDConfig     => $NamelessOpenIDConfig,
            ExpectedAudience => 'otobo',
        ),
        undef,
        "nameless provider random kid $Try rejected",
    );
}

my $NamelessAmplificationLog = GetMockHTTPLog();
is( $NamelessAmplificationLog, [], 'nameless provider cooldown bounds random kid refreshes' );

my $UnicodeNameOpenIDConfig = {
    %{$OpenIDConfig},
    ProviderSettings => {
        %{ $OpenIDConfig->{ProviderSettings} },
        Name => 'Dostawca Żółty',
    },
};
$OIDCConfiguration->GetProviderData(
    OpenIDConfig => $UnicodeNameOpenIDConfig,
    NoCache      => 1,
);
GetMockHTTPLog();

my $UnicodeNameToken = MakeLogoutToken( Kid => 'unicode-name-unknown-key' );
is(
    $TokenObject->ValidateLogout(
        Token            => $UnicodeNameToken,
        OpenIDConfig     => $UnicodeNameOpenIDConfig,
        ExpectedAudience => 'otobo',
    ),
    undef,
    'unicode provider name supports unknown kid refresh',
);
my $UnicodeNameRefreshLog = GetMockHTTPLog();
is(
    [ map { $_->{endpoint} } @{$UnicodeNameRefreshLog} ],
    [ 'openid', 'jwks' ],
    'unicode provider name gets its own bounded refresh key',
);

my $LogoutToken   = MakeLogoutToken();
my $IDTokenResult = $TokenObject->Validate(
    Token            => $LogoutToken,
    OpenIDConfig     => $OpenIDConfig,
    ExpectedAudience => 'otobo',
    AuthorizedParty  => 'otobo',
);
ok( !$IDTokenResult->{Success}, 'ID-token validation rejects a back-channel logout token' );
like( $IDTokenResult->{Error}, qr/back-channel logout event/, 'ID-token rejection identifies cross-use' );

done_testing;

END {
    local $? = $?;
    $DBObject->Rollback()   if $DBObject;
    $CacheObject->CleanUp() if $CacheObject;

    if ($OAuthProviderMock::ChildPID) {
        kill( 'TERM', $OAuthProviderMock::ChildPID );
        waitpid( $OAuthProviderMock::ChildPID, 0 );
        $OAuthProviderMock::ChildPID = undef;
    }
}

sub PrepareTestSysConfig {

    # no op
    return;
}

sub GetMockHTTPLog {
    my $Response = $UA->get('http://localhost:2007/realms/master/protocol/openid-connect/log');
    die 'OAuth provider mock log is unavailable' if !$Response->is_success;
    return decode_json( $Response->decoded_content );
}
