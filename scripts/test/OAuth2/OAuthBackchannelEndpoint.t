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
use URI::Escape qw(uri_escape_utf8);
use Kernel::System::Web::InterfaceOIDCLogout;

my $ValidClaims = {
    iss    => 'https://issuer.example/realms/test',
    aud    => 'otobo',
    jti    => 'logout-123',
    sid    => 'session-123',
    sub    => 'user-123',
    iat    => 1_800_000_000,
    exp    => 1_800_000_120,
    events => { 'http://schemas.openid.net/event/backchannel-logout' => {} },
};

sub Request {
    my (%Param)     = @_;
    my $Body        = $Param{Body} // '';
    my $Environment = {
        REQUEST_METHOD    => $Param{Method} // 'POST',
        SCRIPT_NAME       => '/otobo/oidc/backchannel-logout',
        PATH_INFO         => $Param{Path} // '/',
        REQUEST_URI       => '/otobo/oidc/backchannel-logout',
        QUERY_STRING      => $Param{Query}       // '',
        CONTENT_TYPE      => $Param{ContentType} // 'application/x-www-form-urlencoded',
        'psgi.input'      => Local::OIDC::PSGIInput->new( Content => $Body ),
        'psgi.url_scheme' => 'https',
        SERVER_NAME       => 'otobo.example',
        SERVER_PORT       => 443,
        SERVER_PROTOCOL   => 'HTTP/1.1',
    };
    $Environment->{CONTENT_LENGTH} = length $Body          if !exists $Param{ContentLength};
    $Environment->{CONTENT_LENGTH} = $Param{ContentLength} if exists $Param{ContentLength};
    $Environment->{HTTP_COOKIE}    = $Param{Cookie}        if defined $Param{Cookie};

    my %Config = (
        AuthModule                          => 'Kernel::System::Auth::DB',
        AuthModule1                         => 'Kernel::System::Auth::OpenIDConnect',
        'AuthModule::OpenIDConnect::Config' => {
            ClientSettings   => { ClientID => $Param{ClientID} // 'otobo' },
            ProviderSettings => { Issuer   => 'https://issuer.example/realms/test' },
            Misc             => {
                BackchannelLogout                 => $Param{Enabled} // 1,
                BackchannelLogoutSigningAlgorithm => 'RS256',
                Leeway                            => 3,
                RandTTL                           => 300,
            },
        },
        SessionMaxTime => 43_200,
    );
    $Config{AuthModule1} = 'Kernel::System::Auth::DB' if $Param{NoOIDCModule};

    my $ObjectManager = Local::OIDC::ObjectManager->new(
        Config  => \%Config,
        Token   => Local::OIDC::Token->new( Claims => $Param{Valid} ? $ValidClaims : undef ),
        Logout  => Local::OIDC::Logout->new( Success => $Param{RevokeSuccess} // 1 ),
        Session => Local::OIDC::Session->new(),
    );
    local $Kernel::OM = $ObjectManager;

    my $Application = Kernel::System::Web::InterfaceOIDCLogout->new()->to_app;
    my $Response    = $Application->($Environment);

    return ( $Response, $ObjectManager );
}

sub Form {
    my ($Token) = @_;
    return 'logout_token=' . uri_escape_utf8($Token);
}

sub Header {
    my ( $Response, $Name ) = @_;
    my $Headers = $Response->[1];
    for ( my $Index = 0; $Index < @{$Headers}; $Index += 2 ) {
        return $Headers->[ $Index + 1 ] if lc $Headers->[$Index] eq lc $Name;
    }
    return;
}

my ( $Response, $OM ) = Request(
    Body   => Form('signed-token'),
    Valid  => 1,
    Cookie => 'OTOBOSession=irrelevant'
);
is( $Response->[0],                            200,            'valid form token is accepted' );
is( Header( $Response, 'Cache-Control' ),      'no-store',     'response is not cached' );
is( $OM->{Logout}->{Calls},                    1,              'valid token reaches session revocation' );
is( $OM->{Logout}->{Param}->{ClientID},        'otobo',        'configured client is used for revocation' );
is( $OM->{Logout}->{Param}->{Claims},          $ValidClaims,   'verified token claims reach revocation' );
is( $OM->{Logout}->{Param}->{Retention},       86_706,         'retention covers session, state and clock leeway' );
is( $OM->{Logout}->{Param}->{SessionObject},   $OM->{Session}, 'session facade is passed to revocation service' );
is( $OM->{Logout}->{Param}->{Leeway},          3,              'logout revocation applies configured clock leeway' );
is( $OM->{Token}->{Param}->{ExpectedAudience}, 'otobo',        'configured client is validated as audience' );
is( $OM->{Token}->{Param}->{SigningAlgorithm}, 'RS256',        'configured signing algorithm is used' );
is( $OM->{Token}->{Param}->{Leeway},           3,              'configured clock leeway is used' );
is( $OM->{Token}->{Param}->{OpenIDConfig},     $OM->{ConfigValues}->{'AuthModule::OpenIDConnect::Config'}, 'provider configuration reaches validation' );

for my $Case (
    [
        disabled => { Enabled => 0 },
        404
    ],
    [
        no_provider => { NoOIDCModule => 1 },
        404
    ],
    [
        wrong_path => { Path => '/other' },
        404
    ],
    [
        wrong_method => { Method => 'GET' },
        405
    ],
    [
        content_type => { ContentType => 'text/plain' },
        400
    ],
    [
        no_body => { Body => '' },
        400
    ],
    [
        no_length => {
            Body          => Form('signed-token'),
            ContentLength => undef
        },
        400
    ],
    [
        too_large => {
            Body          => Form('signed-token'),
            ContentLength => 65_537
        },
        400
    ],
    [
        missing => { Body => 'other=value' },
        400
    ],
    [
        duplicate => { Body => Form('signed-token') . '&' . Form('signed-token') },
        400
    ],
    [
        invalid => {
            Body  => Form('bad-token'),
            Valid => 0
        },
        400
    ],
    [
        storage => {
            Body          => Form('signed-token'),
            Valid         => 1,
            RevokeSuccess => 0
        },
        400
    ],
    )
{
    my ( $Name, $Options, $ExpectedStatus ) = @{$Case};
    $Options->{Valid} = 1 if $Name ne 'invalid' && !exists $Options->{Valid};
    my ( $CaseResponse, $CaseOM ) = Request( %{$Options} );
    is( $CaseResponse->[0],                       $ExpectedStatus, "$Name request has expected status" );
    is( Header( $CaseResponse, 'Cache-Control' ), 'no-store',      "$Name response is not cached" );
    my $ExpectedRevokeCalls = $ExpectedStatus == 200 || $Name eq 'storage' ? 1 : 0;
    is( $CaseOM->{Logout}->{Calls} // 0, $ExpectedRevokeCalls, "$Name request revokes only after validation" );
}

my ( $QueryOnlyResponse, $QueryOnlyOM ) = Request(
    Query => 'logout_token=signed-token',
    Valid => 1
);
is( $QueryOnlyResponse->[0],             400, 'query parameter cannot supply the logout token' );
is( $QueryOnlyOM->{Token}->{Calls} // 0, 0,   'query token is never validated' );

my ( $DuplicateQueryResponse, $DuplicateQueryOM ) = Request(
    Query => 'logout_token=attacker-token',
    Body  => Form('signed-token'),
    Valid => 1,
);
is( $DuplicateQueryResponse->[0],                 200,            'query parameters do not override the body token' );
is( $DuplicateQueryOM->{Token}->{Param}->{Token}, 'signed-token', 'only body token reaches validation' );

done_testing;

package Local::OIDC::ObjectManager;

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        ConfigValues => $Param{Config},
        Token        => $Param{Token},
        Logout       => $Param{Logout},
        Session      => $Param{Session},
        Objects      => {
            'Kernel::Config'                                   => Local::OIDC::Config->new( Values => $Param{Config} ),
            'Kernel::System::OpenIDConnect::Token'             => $Param{Token},
            'Kernel::System::OpenIDConnect::BackchannelLogout' => $Param{Logout},
            'Kernel::System::AuthSession'                      => $Param{Session},
        },
        Session => $Param{Session},
    }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Objects}->{$Name};
}

package Local::OIDC::Config;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless { Values => $Param{Values} }, $Class;
}

sub Get {
    my ( $Self, $Name ) = @_;
    return $Self->{Values}->{$Name};
}

package Local::OIDC::Token;     ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        Claims => $Param{Claims},
        Calls  => 0
    }, $Class;
}

sub ValidateLogout {
    my ( $Self, %Param ) = @_;
    $Self->{Calls}++;
    $Self->{Param} = \%Param;
    return $Self->{Claims};
}

package Local::OIDC::Logout;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        Success => $Param{Success},
        Calls   => 0
    }, $Class;
}

sub Revoke {
    my ( $Self, %Param ) = @_;
    $Self->{Calls}++;
    $Self->{Param} = \%Param;
    return $Self->{Success};
}

package Local::OIDC::Session;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ($Class) = @_;
    return bless {}, $Class;
}

package Local::OIDC::PSGIInput;    ## no critic qw(Modules::ProhibitMultiplePackages)

sub new {
    my ( $Class, %Param ) = @_;
    return bless {
        Content  => $Param{Content},
        Position => 0
    }, $Class;
}

sub read {    ## no critic qw(OTOBO::RequireCamelCase Subroutines::ProhibitBuiltinHomonyms Subroutines::RequireArgUnpacking)
    my ($Self) = @_;
    my $Length = $_[2];
    my $Offset = $_[3];
    my $Chunk  = substr $Self->{Content}, $Self->{Position}, $Length;
    $Self->{Position} += length $Chunk;
    if ( defined $Offset ) {
        substr( $_[1], $Offset, length $_[1] ) = $Chunk;
    }
    else {
        $_[1] = $Chunk;
    }
    return length $Chunk;
}
