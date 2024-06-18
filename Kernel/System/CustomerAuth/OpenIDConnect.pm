# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::CustomerAuth::OpenIDConnect;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;

# core modules
use List::Util qw(none);

# CPAN modules
use URI::Escape qw(uri_unescape);

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::CustomerUser',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::OpenIDConnect',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::CustomerAuth::OpenIDConnect - Auth via OpenID Connect

=head1 SYNOPSIS

All functions for Auth via OpenID Connect

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $BackendObject = $Kernel::OM->Get('Kernel::System::CustomerAuth::OpenIDConnect');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {
        DefaultRandLength => 22,
        AuthError         => '',
    };
    bless( $Self, $Type );

    return $Self;
}

sub GetOption {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{What} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need What!",
        );
        return;
    }

    # module options
    my %Option = (
        PreAuth => 1,
    );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $ParamObject         = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $RequestConfig = $ConfigObject->Get('Customer::AuthModule::OpenIDConnect::AuthRequest');
    my $OpenIDConfig  = $ConfigObject->Get('Customer::AuthModule::OpenIDConnect::Config');
    my $Misc          = $OpenIDConfig->{Misc} // {};

    if ( !$RequestConfig || !$RequestConfig->{ResponseType} || !$OpenIDConfig ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "OpenIDConnect is ill configured!",
        );

        $Self->{AuthError} = Translatable('Authentication error. Please contact the administrator.');

        return;
    }

    my %GetParam = (
        Code    => $ParamObject->GetParam( Param => 'code' ),
        IDToken => $ParamObject->GetParam( Param => 'id_token' ),
        State   => $ParamObject->GetParam( Param => 'state' ),
        Error   => $ParamObject->GetParam( Param => 'error' ),
    );

    $Self->{AuthError} = Translatable('Authentication error.');

    if ( $GetParam{Error} ) {
        my $Message = $GetParam{Error};
        $Message .= $ParamObject->GetParam( Param => 'error_description' ) ? "\n" . $ParamObject->GetParam( Param => 'error_description' ) : '';
        $Message .= $ParamObject->GetParam( Param => 'error_uri' )         ? "\nsee " . $ParamObject->GetParam( Param => 'error_uri' )     : '';

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Message,
        );

        return;
    }

    # not a redirect from an OpenID provider
    return if none { $GetParam{$_} } qw(State Code IDToken);

    if ( !$GetParam{State} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need state!',
        );

        return;
    }

    # check the state
    my $RandLength = $OpenIDConfig->{Misc}{RandLength} // $Self->{DefaultRandLength};
    my $StateCSRF  = substr $GetParam{State}, 0, $RandLength;
    my $CookieCSRF = $ParamObject->GetCookie( Key => 'OIDCCSRF' );
    my %StateCache = (
        Type => 'OpenIDConnect_State',
        Key  => $StateCSRF,
    );

    # the random string in the state has to be present in the browser cookie, as well as the cache
    if ( $StateCSRF eq $CookieCSRF && $CacheObject->Get(%StateCache) ) {
        $CacheObject->Delete(%StateCache);
    }
    else {
        my $ErrorMessage = $StateCSRF eq $CookieCSRF ? 'Response state not found in cache.' : 'Response state does not match cookie.';

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => 'OpenID Connect authentication error: ' . $ErrorMessage,
        );
        $Self->{AuthError} = Translatable('Invalid response from the authentication server. Maybe the process took too long. Please retry once.');

        return;
    }

    # if a code was requested it has to be present and we will use it
    if ( grep { $_ eq 'code' } @{ $RequestConfig->{ResponseType} // [] } ) {
        if ( !$GetParam{Code} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'No authorization code was transfered but it was expected!',
            );

            return;
        }

        $GetParam{IDToken} = $OpenIDConnectObject->RequestIDToken(
            AuthorizationCode => $GetParam{Code},
            ProviderSettings  => $OpenIDConfig->{ProviderSettings},
            ClientSettings    => $OpenIDConfig->{ClientSettings},
        );
    }

    return if !$GetParam{IDToken};

    my $Return = $OpenIDConnectObject->ValidateIDToken(
        IDToken          => $GetParam{IDToken},
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
        ClientSettings   => $OpenIDConfig->{ClientSettings},
        UseNonce         => ( $Misc->{UseNonce} || grep { $_ eq 'id_token' } @{ $RequestConfig->{ResponseType} // [] } ) || 0,
        Leeway           => $Misc->{Leeway},
    );

    return if !$Return;

    if ( $Return->{Error} && $Return->{Error} eq 'nonce' ) {
        $Self->{AuthError} = 'Invalid response from the authentication server. Maybe the process took too long. Please retry once.';
    }

    return if !$Return->{Success};

    my $TokenData = $Return->{TokenData};

    my $Debug = $ConfigObject->Get('Customer::AuthModule::OpenIDConnect::Debug');
    if ( $Debug && $Debug->{LogIDToken} ) {
        my $TokenString = $Kernel::OM->Get('Kernel::System::Main')->Dump($TokenData);

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Received Token: $TokenString",
        );
    }

    my $Identifier = $ConfigObject->Get('Customer::AuthModule::OpenIDConnect::UID');
    my $UserLogin  = $TokenData->{$Identifier};
    if ( !$UserLogin ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Token received but UID was not provided in '$Identifier'.",
        );

        return;
    }

    # store originally requested URL to return it via PostAuth
    $Self->{RequestedURL} = uri_unescape( substr $GetParam{State}, $RandLength );

    my $UserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my %User       = $UserObject->CustomerUserDataGet( User => $UserLogin );

    if ( !$User{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No UserID for '$UserLogin'.",
        );

        return;
    }

    return $UserLogin;
}

sub PreAuth {
    my ( $Self, %Param ) = @_;

    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $MainObject          = $Kernel::OM->Get('Kernel::System::Main');
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $RequestConfig = $ConfigObject->Get('Customer::AuthModule::OpenIDConnect::AuthRequest');
    my $OpenIDConfig  = $ConfigObject->Get('Customer::AuthModule::OpenIDConnect::Config');
    my $Misc          = $OpenIDConfig->{Misc} // {};

    my $TTL = $Misc->{RandTTL} // 300;    # 60 * 5

    # set the state
    my $RandomString = $MainObject->GenerateRandomString(
        Length => $Misc->{RandLength} // $Self->{DefaultRandLength},
    );
    $CacheObject->Set(
        Type          => 'OpenIDConnect_State',
        Key           => $RandomString,
        Value         => 1,
        TTL           => $TTL,
        CacheInMemory => 0,                       # important for distributed systems
    );
    my %Data = (
        State => $RandomString . $LayoutObject->LinkEncode( $Param{RequestedURL} // '' ),
    );

    # store the RandomString as a CSRF cookie
    $LayoutObject->SetCookie(
        Key     => 'OIDCCSRF',
        Name    => 'OIDCCSRF',
        Value   => $RandomString,
        Expires => '+' . $TTL . 's',
    );

    # add a nonce if configured
    if ( $Misc->{UseNonce} || grep { $_ eq 'id_token' } @{ $RequestConfig->{ResponseType} // [] } ) {
        $RandomString = $MainObject->GenerateRandomString(
            Length => $Misc->{RandLength} // $Self->{DefaultRandLength},
        );
        $CacheObject->Set(
            Type          => 'OpenIDConnect_Nonce',
            Key           => $RandomString,
            Value         => 1,
            TTL           => $TTL,
            CacheInMemory => 0,                       # important for distributed systems
        );
        $Data{Nonce} = $RandomString;
    }

    my $RedirectURL = $OpenIDConnectObject->BuildRedirectURL(
        AuthRequest => {
            %Data,
            %{$RequestConfig},
        },
        ClientSettings   => $OpenIDConfig->{ClientSettings},
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );

    return {
        RedirectURL => $RedirectURL,
    };
}

sub PostAuth {
    my ( $Self, %Param ) = @_;

    return if !$Self->{RequestedURL};

    return {
        RequestedURL => $Self->{RequestedURL},
    };
}

sub Logout {
    my ( $Self, %Param ) = @_;

    my $OpenIDConfig        = $Kernel::OM->Get('Kernel::Config')->Get('Customer::AuthModule::OpenIDConnect::Config');
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');

    my $LogoutURL = $OpenIDConnectObject->GetLogoutURL(
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );

    return if !$LogoutURL;

    return {
        LogoutURL => $LogoutURL,
    };
}

1;
