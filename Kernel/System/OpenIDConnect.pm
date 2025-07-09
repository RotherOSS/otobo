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

package Kernel::System::OpenIDConnect;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::OpenIDConnect::Configuration',
    'Kernel::System::OpenIDConnect::OAuth2',
    'Kernel::System::OpenIDConnect::Token',
);

=head1 NAME

Kernel::System::OpenIDConnect - methods for OpenIDConnect

=head1 SYNOPSIS

All functions for OpenID Connect

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 BuildRedirectURL()

Build the redirect url to the authorization endpoint of the OpenID provider

    my $RedirectURL = $OpenIDConnectObject->BuildRedirectURL(
        AuthRequest => {
            %Data,
            %{$RequestConfig},
        },
        ClientSettings   => $OpenIDConfig->{ClientSettings},
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );

=cut

sub BuildRedirectURL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AuthRequest ClientSettings ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{AuthRequest}{ResponseType} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ResponseType must be an array ref with data!",
        );

        return;
    }

    my $Scope = join( ' ', ( 'openid', @{ $Param{AuthRequest}{AdditionalScope} // [] } ) );

    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $AuthorizationEndpoint   = $OIDCConfigurationObject->GetAuthorizationEndpoint(
        OpenIDConfig => {
            ClientSettings   => $Param{ClientSettings},
            ProviderSettings => $Param{ProviderSettings},
        },
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $OAuth2Object = $Kernel::OM->Get('Kernel::System::OpenIDConnect::OAuth2');

    my $RandTTL = 60 * 5;

    my $RandTTLConfig = $ConfigObject->Get('AuthModule::OpenIDConnect::Config');
    if ( IsHashRefWithData($RandTTLConfig) && IsHashRefWithData( $RandTTLConfig->{Misc} ) ) {
        if ( $RandTTLConfig->{Misc}->{RandTTL} ) {
            $RandTTL = $RandTTLConfig->{Misc}->{RandTTL};
        }
    }

    my $AuthURL = $OAuth2Object->GetAuthURL(

        AuthorizationEndpoint => $AuthorizationEndpoint,
        ClientID              => $Param{ClientSettings}->{ClientID},
        ResponseType          => $Param{AuthRequest}->{ResponseType},
        Scope                 => $Scope,
        Nonce                 => $Param{AuthRequest}->{Nonce},
        RandTTL               => $Param{AuthRequest}->{$RandTTL} // $RandTTL,
        RedirectURL           => $Param{ClientSettings}{RedirectURI},
        State                 => $Param{AuthRequest}->{State},
    );

    return $AuthURL;
}

=head2 RequestIDToken()

Build the redirect url to the authorization endpoint of the OpenID provider

    my $IDToken = $OpenIDConnectObject->RequestIDToken(
        AuthorizationCode => $GetParam{Code},
        ProviderSettings  => $ProviderSettings,
        ClientSettings    => $ClientSettings,
    );

=cut

sub RequestIDToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AuthorizationCode ClientSettings ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Scope = join( ' ', ( 'openid', @{ $Param{AuthRequest}{AdditionalScope} // [] } ) );

    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $TokenEndpoint           = $OIDCConfigurationObject->GetTokenEndpoint(
        OpenIDConfig => {
            ClientSettings   => $Param{ClientSettings},
            ProviderSettings => $Param{ProviderSettings},
        },
    );

    my $OAuth2Object = $Kernel::OM->Get('Kernel::System::OpenIDConnect::OAuth2');

    my $TokenResult = $OAuth2Object->RequestToken(
        TokenEndpoint => $TokenEndpoint,
        ClientID      => $Param{ClientSettings}->{ClientID},
        ClientSecret  => $Param{ClientSettings}->{ClientSecret},
        GrantType     => 'authorization_code',
        Code          => $Param{AuthorizationCode},
        RedirectURL   => $Param{ClientSettings}{RedirectURI},
        SSLOptions    => $Param{ProviderSettings}{SSLOptions},
    );

    return if !$TokenResult->{Success};

    return if !$TokenResult->{DecodedContent};

    return $TokenResult->{DecodedContent}->{id_token};
}

=head2 ValidateIDToken()

Extracts IDToken data and validates it

    my $Return = $OpenIDConnectObject->ValidateIDToken(
        IDToken          => $IDToken,
        ProviderSettings => $ProviderSettings,
        ClientSettings   => $ClientSettings,
    );

=cut

sub ValidateIDToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/IDToken ProviderSettings ClientSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Return = { Success => 0 };

    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

    my $Result = $TokenObject->Validate(
        Token        => $Param{IDToken},
        OpenIDConfig => {
            ClientSettings   => $Param{ClientSettings},
            ProviderSettings => $Param{ProviderSettings},
        },
        ExpectedAudiences => $Param{ClientSettings}{ClientID},
        AuthorizedParty   => $Param{ClientSettings}{ClientID},
    );

    if ( !$Result->{Success} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Validation of OIDC token failed: $Result->{Error}!",
        );
    }

    return $Result;
}

=head2 GetLogoutURL()

Return the logout url of the OpenID provider

    my $RedirectURL = $OpenIDConnectObject->GetLogoutURL(
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );

=cut

sub GetLogoutURL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw/ProviderSettings/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $OpenIDProviderData      = $OIDCConfigurationObject->GetProviderData(
        OpenIDConfig => {
            ProviderSettings => $Param{ProviderSettings},
        },
    );

    return $OpenIDProviderData->{OpenIDConfiguration}{end_session_endpoint};
}

1;
