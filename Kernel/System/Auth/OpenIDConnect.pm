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

package Kernel::System::Auth::OpenIDConnect;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;

# core modules
use List::Util qw(none);

# CPAN modules
use URI::Escape;

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::OpenIDConnect',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::Auth::OpenIDConnect - Auth via OpenID Connect

=head1 SYNOPSIS

All functions for Auth via OpenID Connect

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $BackendObject = $Kernel::OM->Get('Kernel::System::Auth::OpenIDConnect');

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

    my $RequestConfig = $ConfigObject->Get('AuthModule::OpenIDConnect::AuthRequest');
    my $OpenIDConfig  = $ConfigObject->Get('AuthModule::OpenIDConnect::Config');
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

    my $Debug = $ConfigObject->Get('AuthModule::OpenIDConnect::Debug');
    if ( $Debug && $Debug->{LogIDToken} ) {
        my $TokenString = $Kernel::OM->Get('Kernel::System::Main')->Dump($TokenData);

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Received Token: $TokenString",
        );
    }

    my $Identifier = $ConfigObject->Get('AuthModule::OpenIDConnect::UID');
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

    my %Roles;
    my $RoleMap = $ConfigObject->Get('AuthModule::OpenIDConnect::RoleMap');
    if ($RoleMap) {
        %Roles = $Self->_ExtractMap(
            Map  => $RoleMap,
            Data => $TokenData,
        );
    }

    # if OpenIDConnect is configured to provide authorization but the user has no rights return
    if ( $RoleMap && !%Roles ) {
        $Self->{AuthError} = 'You have no access to this application.';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Attempted unauthorized access by '$UserLogin'.",
        );

        return;
    }

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my %User       = $UserObject->GetUserData( User => $UserLogin );
    my $UserMap    = $ConfigObject->Get('AuthModule::OpenIDConnect::UserMap');
    my $UserID;

    # create and edit users
    if ($UserMap) {
        my %UserData = map { $UserMap->{$_} => $TokenData->{$_} } keys %{$UserMap};

        # don't mess with some data here
        delete $UserData{UserID};
        delete $UserData{UserPw};

        if ( !%User ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Adding '$UserLogin' as user agent.",
            );

            $UserID = $UserObject->UserAdd(
                UserFirstname => '-',
                UserLastname  => '-',
                %UserData,
                UserLogin    => $UserLogin,
                ValidID      => 1,
                ChangeUserID => 1,
            );
        }

        else {
            my $Update;
            KEY:
            for my $Key ( keys %UserData ) {
                if ( $UserData{$Key} ne $User{$Key} ) {
                    $Update = 1;

                    last KEY;
                }
            }

            if ($Update) {
                $UserObject->UserUpdate(
                    %User,
                    %UserData,
                    ChangeUserID => 1,
                );
            }
        }
    }

    $UserID //= $User{UserID};

    if ( !$UserID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No UserID for '$UserLogin'.",
        );

        return;
    }

    # successful return if no authorization has to be done
    return $UserLogin if !$RoleMap;

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    if ($RoleMap) {
        my %AllRoles = reverse $GroupObject->RoleList(
            Valid => 1,
        );

        # update user roles
        for my $RoleName ( keys %AllRoles ) {
            $GroupObject->PermissionRoleUserAdd(
                UID    => $UserID,
                RID    => $AllRoles{$RoleName},
                Active => $Roles{$RoleName} || 0,
                UserID => 1,
            );
        }
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

    my $RequestConfig = $ConfigObject->Get('AuthModule::OpenIDConnect::AuthRequest');
    my $OpenIDConfig  = $ConfigObject->Get('AuthModule::OpenIDConnect::Config');
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
        Key      => 'OIDCCSRF',
        Value    => $RandomString,
        Path     => $ConfigObject->Get('ScriptAlias'),
        Secure   => $ConfigObject->Get('HttpType') eq 'https' ? 1 : undef,
        HTTPOnly => 1,
        Expires  => '+' . $TTL . 's',
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

    my $OpenIDConfig        = $Kernel::OM->Get('Kernel::Config')->Get('AuthModule::OpenIDConnect::Config');
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');

    my $LogoutURL = $OpenIDConnectObject->GetLogoutURL(
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );

    return if !$LogoutURL;

    return {
        LogoutURL => $LogoutURL,
    };
}

sub _ExtractMap {
    my ( $Self, %Param ) = @_;
    my %Return = ();

    KEY:
    for my $Key ( keys %{ $Param{Map} } ) {
        if ( IsHashRefWithData( $Param{Map}{$Key} ) ) {
            next KEY unless defined $Param{Data}{$Key};

            %Return = (
                %Return,
                $Self->_ExtractMap(
                    Map  => $Param{Map}{$Key},
                    Data => $Param{Data}{$Key},
                ),
            );
        }

        next KEY if ref $Param{Map}{$Key};

        my @Data = IsArrayRefWithData( $Param{Data} ) ? @{ $Param{Data} } :
            !ref $Param{Data} ? ( $Param{Data} ) : ();

        for my $OpenIDAttribute (@Data) {
            my $OTOBOAttribute = $Param{Map}{$OpenIDAttribute};

            if ($OTOBOAttribute) {
                $Return{$OTOBOAttribute} = 1;
            }
        }
    }

    return %Return;
}

1;
