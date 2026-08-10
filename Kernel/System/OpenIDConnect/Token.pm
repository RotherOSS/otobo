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

# CPAN modules

use Crypt::JWT qw(decode_jwt);

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

Kernel::System::OpenIDConnect::Token

Inspect and Validate OAuth2 Tokens

=head1 SYNOPSIS

OAuth2 Tokens for OpenID Connect

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
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
        return 600;    # offline_token has not expiry
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
        ExpectedAudiences => <space separated list>, # defaults to OIDC client_id for id_tokens
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $Leeway                  = $Param{OpenIDConfig}->{Misc}->{Leeway} // 2;
    my $OpenIDProviderData      = $OIDCConfigurationObject->GetProviderData(
        OpenIDConfig => $Param{OpenIDConfig},
    );

    # get the OpenIDConfiguration and Keys
    my $Try = 0;

    # decode the token; retry once if it doesn't work for cached config
    my $TokenData;
    while ( $Try++ < 2 ) {
        my $Error;

        # decode id_token, check key
        eval {
            $TokenData = decode_jwt(
                token    => $Param{Token},
                kid_keys => $OpenIDProviderData->{KeyData},
                leeway   => $Leeway,
            ) // {};
        };
        if ($@) {
            $TokenData = undef;
            $Error     = $@;
        }

        # check whether the token could be decoded and the issuer is correct - if not the cached data might just be outdated
        if ( $TokenData && $TokenData->{iss} && $TokenData->{iss} eq $OpenIDProviderData->{OpenIDConfiguration}{issuer} ) {
            $Try = 100;
        }

        # renew the provider data once
        elsif ( $Try < 2 ) {
            $OpenIDProviderData = $OIDCConfigurationObject->GetProviderData(
                OpenIDConfig => $Param{OpenIDConfig},
                NoCache      => 1,
            );
        }

        else {
            $TokenData = undef;
            $Error //= $TokenData->{iss}
                ? "Wrong issuer! $TokenData->{iss} (Token); $OpenIDProviderData->{OpenIDConfiguration}{issuer} (Provider Config);"
                : 'Unknown Error.';

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Decoding JWT failed: $@",
            );
        }
    }

    return $TokenData;
}

1;
