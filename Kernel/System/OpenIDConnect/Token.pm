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

package Kernel::System::OpenIDConnect::Token;

use strict;
use warnings;

# core modules
use MIME::Base64 qw(decode_base64);
use Digest::SHA  qw(sha256_hex);
use Encode       qw(encode_utf8);
use POSIX        qw(isfinite);
use Scalar::Util qw(looks_like_number);

# CPAN modules
use Crypt::JWT       qw(decode_jwt);
use Cpanel::JSON::XS qw(decode_json);

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::OpenIDConnect::Configuration',
);

=head1 NAME

Kernel::System::OpenIDConnect::Token - Inspect and Validate OAuth2 Tokens

=head1 DESCRIPTION

OAuth2 Tokens for OpenID Connect.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

=cut

sub new {
    my ($Type) = @_;

    return bless {}, $Type;
}

=head2 Inspect()

Inspect Token payload without validating the signature.

    my $TokenData = $TokenObject->Inspect(
        Token => $Token,
        Leeway => $AllowedSecondsTimeDrift,       # optional
    );

=cut

sub Inspect {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Token/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $TokenData;
    eval {
        $TokenData = decode_jwt(
            token            => $Param{Token},
            ignore_signature => 1,
            ignore_claims    => 1,
            leeway           => $Param{Leeway} // 2,
        );
    };
    if ($@) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Decoding JWT failed: $@",
        );

        return;
    }

    return $TokenData;
}

=head2 sub IsTokenStillValid()

Return true if a Token is still valid

    my $Boolean = $TokenObject->IsTokenStillValid( Token => $Token );

=cut

sub IsTokenStillValid {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Token/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $MinTimeTillExpired = $Param{MinTimeTillExpired} || 30;
    my $Token              = $Param{Token};

    my $TimeLeft = $Self->TimeLeft(
        Token => $Token,
    );

    if ( $TimeLeft > $MinTimeTillExpired ) {
        return $Token if $TimeLeft > $MinTimeTillExpired;
    }

    return;
}

=head2 TimeLeft()

Returns the time in seconds a token is still valid

    my $TimeLeft = $TokenProviderObject->TimeLeft(
        Token          => $Token,
    );

=cut

sub TimeLeft {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Token/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $TokenData = $Self->Inspect(%Param);
    if ( !$TokenData ) {
        return 0;
    }

    if ( !$TokenData->{exp} ) {
        return 600;    # offline_token has no expiry, use 10 minutes as default
    }

    # time window
    my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    return $TokenData->{exp} - $CurrentTime;
}

=head2 Validate()

Validates a Token

    my $Result = $TokenObject->Validate(
        Token             => $Token,
        OpenIDConfig      => $OpenIDConfig,
        ExpectedAudience  => <space separated list>, # defaults to OIDC client_id for id_tokens
        ExpectedScopes    => <space separated list>, # optional
        AuthorizedParty   => '<identifier>',         # optional
    );

returns

    { Success => 0, Error => 'msg' }

or

    { Success => 1, TokenData => {...} }

=cut

sub Validate {
    my ( $Self, %Param ) = @_;

    my $Return = { Success => 0 };
    for my $Needed (qw/Token OpenIDConfig/) {
        if ( !$Param{$Needed} ) {

            return {
                Success => 0,
                Error   => "Need $Needed!"
            };
        }
    }

    my $OpenIDConfig     = $Param{OpenIDConfig};
    my $ClientSettings   = $OpenIDConfig->{ClientSettings};
    my $ExpectedAudience = $Param{ExpectedAudience};
    my $AuthorizedParty  = $Param{AuthorizedParty};
    my $ExpectedScopes   = $Param{ExpectedScopes};
    my $Leeway           = $Param{Leeway} // $OpenIDConfig->{Misc}->{Leeway} // 2;

    my $TokenData = $Self->DecodeToken(
        Token        => $Param{Token},
        OpenIDConfig => $OpenIDConfig,
        Leeway       => $Leeway,
    );

    if ( !IsHashRefWithData($TokenData) ) {

        return {
            Success => 0,
            Error   => "Decode Token failed!."
        };
    }

    if ( IsHashRefWithData( $TokenData->{events} ) && exists $TokenData->{events}{'http://schemas.openid.net/event/backchannel-logout'} ) {

        return {
            Success => 0,
            Error   => 'Token invalid: back-channel logout event is not an ID token.',
        };
    }

    for my $Needed (qw/iss sub aud exp iat/) {

        if ( !$TokenData->{$Needed} ) {

            return {
                Success => 0,
                Error   => "Token invalid: <$Needed> not included."
            };
        }
    }

    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $OpenIDProviderData      = $OIDCConfigurationObject->GetProviderData(
        OpenIDConfig => $OpenIDConfig,
    );

    my $Issuer = $OpenIDProviderData->{OpenIDConfiguration}{issuer};

    # do the validation
    if ( $TokenData->{iss} ne $Issuer ) {

        return {
            Success => 0,
            Error   => "<iss> wrong. Token is issued by '$TokenData->{iss}', but '$Issuer' is required."
        };
    }

    my @Audience = ref $TokenData->{aud} ? @{ $TokenData->{aud} } : ( $TokenData->{aud} );

    if ($ExpectedAudience) {

        if ( !grep { $_ =~ m/\b$ExpectedAudience\b/ } @Audience ) {

            return {
                Success => 0,
                Error   => "<aud> wrong. Token is addressed to '@Audience' which does not contain '$ExpectedAudience'."
            };
        }
    }

    if ( ref $TokenData->{aud} && !$TokenData->{azp} ) {

        return {
            Success => 0,
            Error   => "<aud> is an array but <azp> not present."
        };
    }

    if ( $AuthorizedParty && $TokenData->{azp} && $AuthorizedParty !~ $TokenData->{azp} ) {

        return {
            Success => 0,
            Error   => "<azp> present and wrong. Authorized party is specified as '$TokenData->{azp}', we are '$AuthorizedParty'."
        };
    }

    if ( $ExpectedScopes && $TokenData->{scope} ) {

        my @Scopes = split / +/, $ExpectedScopes;
        for my $Scope (@Scopes) {
            my $Regex = qr/\b$Scope\b/;
            if ( $TokenData->{scope} !~ /$Regex/ ) {

                return {
                    Success => 0,
                    Error   => "<scope> invalid. '" . $TokenData->{scope} . "' does not include $Scope"
                };
            }
        }
    }

    my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
    if ( $TokenData->{iat} - $Leeway > $CurrentTime ) {

        return {
            Success => 0,
            Error   => "<iat> invalid. Token creation time is in the future. Token: $TokenData->{iat}; Current: $CurrentTime;"
        };
    }

    if ( $TokenData->{exp} + $Leeway <= $CurrentTime ) {

        return {
            Success => 0,
            Error   => "<exp> invalid. Token expired. Expiration Time: $TokenData->{exp}; Current: $CurrentTime;"
        };
    }

    if ( $Param{UseNonce} ) {
        if ( !$TokenData->{nonce} ) {

            return {
                Success => 0,
                Error   => "No nonce in Token."
            };
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        my %Nonce       = (
            Type => 'OpenIDConnect_Nonce',
            Key  => $TokenData->{nonce},
        );

        if ( $CacheObject->Get(%Nonce) ) {
            $CacheObject->Delete(%Nonce);
        }
        else {

            return {
                Success => 0,
                Error   => "<nonce> invalid."
            };
        }
    }

    return {
        Success   => 1,
        TokenData => $TokenData,
    };
}

=head2 ValidateLogout()

Validate an OIDC Back-Channel Logout Token and return its claims.

    my $TokenData = $TokenObject->ValidateLogout(
        Token            => $LogoutToken,
        OpenIDConfig     => $OpenIDConfig,
        ExpectedAudience => $ClientID,
        SigningAlgorithm => 'RS256', # optional, defaults to RS256
        Leeway           => 0,       # optional, defaults to 0
    );

=cut

sub ValidateLogout {
    my ( $Self, %Param ) = @_;

    return if !defined $Param{Token} || ref $Param{Token} || !length $Param{Token};
    return if !IsHashRefWithData( $Param{OpenIDConfig} );
    return if !defined $Param{ExpectedAudience} || ref $Param{ExpectedAudience} || !length $Param{ExpectedAudience};
    return if $Param{Token} !~ /\A[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\z/;

    my $SigningAlgorithm = $Param{SigningAlgorithm} // 'RS256';
    return if !defined $SigningAlgorithm || ref $SigningAlgorithm;

    my %AllowedAlgorithm = map { $_ => 1 } qw(
        RS256 RS384 RS512 PS256 PS384 PS512 ES256 ES384 ES512 EdDSA
    );
    return if !$AllowedAlgorithm{$SigningAlgorithm};

    my $Leeway = $Param{Leeway} // 0;
    return if ref $Leeway || !looks_like_number($Leeway) || !isfinite( 0 + $Leeway ) || $Leeway < 0 || $Leeway > 60;

    my ($HeaderPart) = split /\./, $Param{Token};
    return if !defined $HeaderPart || !length $HeaderPart || length $HeaderPart > 4096;
    $HeaderPart =~ tr{-_}{+/};
    $HeaderPart .= '=' x ( ( 4 - length($HeaderPart) % 4 ) % 4 );

    # Malformed public input must not be included in JSON parser log messages.
    my $UnverifiedHeader = eval { decode_json( decode_base64($HeaderPart) ) };
    return if !IsHashRefWithData($UnverifiedHeader);
    return if !defined $UnverifiedHeader->{alg} || $UnverifiedHeader->{alg} ne $SigningAlgorithm;
    if ( exists $UnverifiedHeader->{typ} ) {
        return if ref $UnverifiedHeader->{typ} || !defined $UnverifiedHeader->{typ};
        return if $UnverifiedHeader->{typ} ne 'logout+jwt' && $UnverifiedHeader->{typ} ne 'JWT';
    }
    return if !defined $UnverifiedHeader->{kid} || ref $UnverifiedHeader->{kid} || !length $UnverifiedHeader->{kid};

    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $OpenIDProviderData      = $OIDCConfigurationObject->GetProviderData(
        OpenIDConfig => $Param{OpenIDConfig},
    );
    return if !IsHashRefWithData($OpenIDProviderData);

    my $HasKid = sub {
        my ($ProviderData) = @_;
        return if !IsHashRefWithData( $ProviderData->{KeyData} );
        return if !IsArrayRefWithData( $ProviderData->{KeyData}{keys} );
        return scalar grep {
            IsHashRefWithData($_)
                && defined $_->{kid}
                && !ref $_->{kid}
                && $_->{kid} eq $UnverifiedHeader->{kid}
        } @{ $ProviderData->{KeyData}{keys} };
    };

    if ( !$HasKid->($OpenIDProviderData) ) {
        my $ProviderSettings = $Param{OpenIDConfig}{ProviderSettings};
        return if !IsHashRefWithData($ProviderSettings);

        my $DiscoveryURL = $ProviderSettings->{OpenIDConfiguration};
        return if !defined $DiscoveryURL || ref $DiscoveryURL || !length $DiscoveryURL;

        my $ProviderName = $ProviderSettings->{Name};
        return if defined $ProviderName && ref $ProviderName;

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        my $CacheKey    = 'BackchannelLogoutJWKSRefresh::' . sha256_hex(
            join "\0", encode_utf8($DiscoveryURL), encode_utf8( $ProviderName // '' ),
        );
        my $RefreshInCooldown = $CacheObject->Get(
            Type          => 'OpenIDConnect',
            Key           => $CacheKey,
            CacheInMemory => 0,
        );

        if ( !$RefreshInCooldown ) {
            my $CooldownSet = $CacheObject->Set(
                Type          => 'OpenIDConnect',
                Key           => $CacheKey,
                Value         => 1,
                TTL           => 30,
                CacheInMemory => 0,
            );
            return if !$CooldownSet;
            return if !$CacheObject->Get(
                Type          => 'OpenIDConnect',
                Key           => $CacheKey,
                CacheInMemory => 0,
            );

            $OpenIDProviderData = $OIDCConfigurationObject->GetProviderData(
                OpenIDConfig => $Param{OpenIDConfig},
                NoCache      => 1,
            );
            return if !IsHashRefWithData($OpenIDProviderData);
        }

        return if !$HasKid->($OpenIDProviderData);
    }

    my $Issuer = $OpenIDProviderData->{OpenIDConfiguration}{issuer};
    return if !defined $Issuer || !length $Issuer;

    my $DecodedToken = $Self->DecodeToken(
        Token             => $Param{Token},
        OpenIDConfig      => $Param{OpenIDConfig},
        AcceptedAlgorithm => $SigningAlgorithm,
        DecodeHeader      => 1,
        Leeway            => $Leeway,
        NoLog             => 1,
        NoRefresh         => 1,
    );
    return if !IsHashRefWithData($DecodedToken);

    my $Header    = $DecodedToken->{Header};
    my $TokenData = $DecodedToken->{TokenData};
    return if !IsHashRefWithData($Header) || !IsHashRefWithData($TokenData);

    return if !defined $Header->{alg} || $Header->{alg} ne $SigningAlgorithm;
    if ( exists $Header->{typ} ) {
        return if ref $Header->{typ} || !defined $Header->{typ};
        return if $Header->{typ} ne 'logout+jwt' && $Header->{typ} ne 'JWT';
    }

    return if !defined $TokenData->{iss} || ref $TokenData->{iss} || $TokenData->{iss} ne $Issuer;
    return if !defined $TokenData->{aud};

    my @Audience = ref $TokenData->{aud} eq 'ARRAY' ? @{ $TokenData->{aud} } : ( $TokenData->{aud} );
    return if !@Audience;
    for my $Audience (@Audience) {
        return if !defined $Audience || ref $Audience || !length $Audience;
    }
    return if !grep { $_ eq $Param{ExpectedAudience} } @Audience;

    for my $Needed (qw/iat exp jti events/) {
        return if !exists $TokenData->{$Needed};
    }

    return if exists $TokenData->{nonce};
    return if !defined $TokenData->{jti} || ref $TokenData->{jti} || !length $TokenData->{jti};

    my $NumericDatePattern = qr/\A(?:0|[1-9][0-9]*)(?:\.[0-9]+)?\z/;
    for my $Claim (qw/iat exp/) {
        my $Value = $TokenData->{$Claim};
        return if !defined $Value || ref $Value || !looks_like_number($Value) || "$Value" !~ $NumericDatePattern;
        return if !isfinite( 0 + $Value ) || $Value > 9_007_199_254_740_991;
    }

    return if $TokenData->{exp} <= $TokenData->{iat};

    my $CurrentTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
    return if $TokenData->{iat} - $Leeway > $CurrentTime;
    return if $TokenData->{exp} + $Leeway <= $CurrentTime;

    return if ref $TokenData->{events} ne 'HASH';
    return if ref $TokenData->{events}{'http://schemas.openid.net/event/backchannel-logout'} ne 'HASH';

    CLAIM:
    for my $Claim (qw/sid sub/) {
        next CLAIM if !exists $TokenData->{$Claim};
        return     if !defined $TokenData->{$Claim} || ref $TokenData->{$Claim} || !length $TokenData->{$Claim};
    }
    return if !length( $TokenData->{sid} // '' ) && !length( $TokenData->{sub} // '' );

    return $TokenData;
}

=head2 DecodeToken()

Returns the decoded token

    my $TokenData = $TokenObject->DecodeToken(
        Token          => $Token,
        OpenIDConfig   => $OpenIDConfig,
    );

=cut

sub DecodeToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Token OpenIDConfig/) {
        if ( !$Param{$Needed} ) {
            if ( !$Param{NoLog} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need $Needed!",
                );
            }
            return;
        }
    }

    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $Leeway                  = $Param{Leeway} // $Param{OpenIDConfig}->{Misc}->{Leeway} // 2;
    my $OpenIDProviderData      = $OIDCConfigurationObject->GetProviderData(
        OpenIDConfig => $Param{OpenIDConfig},
    );

    # get the OpenIDConfiguration and Keys
    my $Try = 0;

    # decode the token; retry once if it doesn't work for cached config
    my $TokenData;
    my $TokenHeader;
    my $MaxTry = $Param{NoRefresh} ? 1 : 2;
    while ( $Try++ < $MaxTry ) {
        my $Error;

        # decode id_token, check key
        eval {
            my %DecodeParam = (
                token    => $Param{Token},
                kid_keys => $OpenIDProviderData->{KeyData},
                leeway   => $Leeway,
            );
            $DecodeParam{accepted_alg}  = $Param{AcceptedAlgorithm} if $Param{AcceptedAlgorithm};
            $DecodeParam{decode_header} = 1                         if $Param{DecodeHeader};

            if ( $Param{DecodeHeader} ) {
                ( $TokenHeader, $TokenData ) = decode_jwt(%DecodeParam);
            }
            else {
                $TokenData = decode_jwt(%DecodeParam);
            }
            $TokenData //= {};
        };
        if ($@) {
            $TokenData = undef;
            $Error     = $@;
        }

        # check whether the token could be decoded and the issuer is correct - if not the cached data might just be outdated
        if ( IsHashRefWithData($TokenData) && $TokenData->{iss} && $TokenData->{iss} eq $OpenIDProviderData->{OpenIDConfiguration}{issuer} ) {
            $Try = 100;
        }

        # renew the provider data once
        elsif ( $Try < $MaxTry ) {
            $OpenIDProviderData = $OIDCConfigurationObject->GetProviderData(
                OpenIDConfig => $Param{OpenIDConfig},
                NoCache      => 1,
            );
        }

        else {
            $TokenData = undef;
            $Error //= IsHashRefWithData($TokenData) && $TokenData->{iss}
                ? "Wrong issuer! $TokenData->{iss} (Token); $OpenIDProviderData->{OpenIDConfiguration}{issuer} (Provider Config);"
                : 'Unknown Error.';

            if ( !$Param{NoLog} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Decoding JWT failed: $@",
                );
            }
        }
    }

    return {
        Header    => $TokenHeader,
        TokenData => $TokenData
    } if $Param{DecodeHeader}
        && $TokenData;

    return $TokenData;
}

1;
