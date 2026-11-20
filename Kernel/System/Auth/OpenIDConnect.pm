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

package Kernel::System::Auth::OpenIDConnect;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;

# core modules
use Digest::SHA  qw(sha256);
use List::Util   qw(none);
use MIME::Base64 qw(encode_base64);

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
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::OpenIDConnect',
    'Kernel::System::Storable',
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
        PreAuth => $Kernel::OM->Get('Kernel::Config')->Get('AuthModule::OpenIDConnect::AutoRedirect') // 1,
    );

    # return option
    return $Option{ $Param{What} };
}

sub Auth {
    my ( $Self, %Param ) = @_;

    delete $Self->{OIDCSession};

    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $ParamObject         = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $RequestConfig = $ConfigObject->Get('AuthModule::OpenIDConnect::AuthRequest');
    my $OpenIDConfig  = $ConfigObject->Get('AuthModule::OpenIDConnect::Config');
    my $Misc          = $OpenIDConfig->{Misc} // {};
    my $UsePKCE       = $Misc->{UsePKCE} ? 1 : 0;

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
    my $CookieCSRF = $ParamObject->GetCookie( Key => 'OIDCCSRF-' . $StateCSRF );
    my %StateCache = (
        Type => 'OpenIDConnect_State',
        Key  => $StateCSRF,
    );

    # the random string in the state has to be present in the browser cookie, as well as the cache
    my $StateData = $CacheObject->Get(%StateCache);
    if ( $StateCSRF eq $CookieCSRF && $StateData ) {
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

    my $StartedAt = ref $StateData eq 'HASH' ? $StateData->{StartedAt} : undef;
    if (
        ( $Misc->{BackchannelLogout} || $Misc->{UseIDTokenHint} || defined $StartedAt )
        && ( !defined $StartedAt || ref $StartedAt || $StartedAt !~ m{\A [0-9]+ \z}xms )
        )
    {
        $Self->{AuthError} = Translatable('Invalid response from the authentication server. Maybe the process took too long. Please retry once.');
        return;
    }

    my $StatePKCE = ref $StateData eq 'HASH'
        && ( exists $StateData->{UsePKCE} || exists $StateData->{CodeVerifier} );
    my $CodeVerifier;
    if ($StatePKCE) {
        $CodeVerifier = $StateData->{CodeVerifier};
        if ( !$StateData->{UsePKCE} || !_CodeVerifierIsValid($CodeVerifier) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'OpenID Connect authentication error: PKCE verifier is missing or invalid in state cache.',
            );
            $Self->{AuthError} = Translatable('Invalid response from the authentication server. Maybe the process took too long. Please retry once.');

            return;
        }
    }
    elsif ( $UsePKCE || ( !defined $StartedAt && ( ref $StateData || $StateData ne '1' ) ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'OpenID Connect authentication error: PKCE verifier is missing from state cache.',
        );
        $Self->{AuthError} = Translatable('Invalid response from the authentication server. Maybe the process took too long. Please retry once.');

        return;
    }

    if ( ( $UsePKCE || $StatePKCE ) && !grep { $_ eq 'code' } @{ $RequestConfig->{ResponseType} // [] } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'PKCE requires an authorization code response type.',
        );
        $Self->{AuthError} = Translatable('Authentication error. PKCE requires an authorization code response type.');

        return;
    }

    # if a code was requested it has to be present and we will use it
    if ( grep { $_ eq 'code' } @{ $RequestConfig->{ResponseType} // [] } ) {
        if ( !$GetParam{Code} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $UsePKCE || $StatePKCE
                ? 'No authorization code was returned for the PKCE response.'
                : 'No authorization code was transfered but it was expected!',
            );
            $Self->{AuthError} = Translatable('Authentication error. The authentication server did not return the authorization code required for PKCE.')
                if $UsePKCE || $StatePKCE;

            return;
        }

        $GetParam{IDToken} = $OpenIDConnectObject->RequestIDToken(
            AuthorizationCode => $GetParam{Code},
            CodeVerifier      => $CodeVerifier,
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

    my $OIDCSession;
    if ( $Misc->{BackchannelLogout} || $Misc->{UseIDTokenHint} ) {
        for my $Claim (qw(iss sub)) {
            return if !IsStringWithData( $TokenData->{$Claim} );
        }
        return if !defined $TokenData->{iat} || ref $TokenData->{iat}
            || $TokenData->{iat} !~ m{\A [0-9]+ (?: \.[0-9]+ )? \z}xms;
        return if exists $TokenData->{sid} && !IsStringWithData( $TokenData->{sid} );

        my $ClientID = $OpenIDConfig->{ClientSettings}{ClientID};
        return if !IsStringWithData($ClientID);
        my @Audience = ref $TokenData->{aud} eq 'ARRAY' ? @{ $TokenData->{aud} } : ( $TokenData->{aud} );
        return if !grep { IsStringWithData($_) && $_ eq $ClientID } @Audience;

        $OIDCSession = {
            Issuer    => $TokenData->{iss},
            ClientID  => $ClientID,
            Subject   => $TokenData->{sub},
            IssuedAt  => $TokenData->{iat},
            StartedAt => $StartedAt,
            ( exists $TokenData->{sid} ? ( SessionID => $TokenData->{sid} )  : () ),
            ( $Misc->{UseIDTokenHint}  ? ( IDToken   => $GetParam{IDToken} ) : () ),
        };

        # DB sessions store each serialized value in a VARCHAR(10000).
        if (
            $Misc->{UseIDTokenHint}
            && length( encode_base64( $Kernel::OM->Get('Kernel::System::Storable')->Serialize( Data => $OIDCSession ) ) ) > 10_000
            )
        {
            delete $OIDCSession->{IDToken};
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => 'OpenID Connect ID token exceeds session storage capacity. Logout will require provider confirmation.',
            );
        }
    }

    my $Debug = $ConfigObject->Get('AuthModule::OpenIDConnect::Debug');
    if ( $Debug && $Debug->{LogIDToken} ) {
        my $TokenString = $Kernel::OM->Get('Kernel::System::Main')->Dump($TokenData);

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Received Token: $TokenString",
        );
    }

    my $UserLookupPreference     = $ConfigObject->Get('AuthModule::OpenIDConnect::UserLookupPreference');
    my $UserLookupPreferenceMode = IsStringWithData($UserLookupPreference);
    my $Identifier               = $ConfigObject->Get('AuthModule::OpenIDConnect::UID');
    my $UserLogin                = $TokenData->{$Identifier};
    if ( $UserLookupPreferenceMode && !IsStringWithData($UserLogin) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Token UID '$Identifier' is not a string.",
        );

        return;
    }

    if ( !$UserLogin && !$UserLookupPreferenceMode ) {
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
    my %User;
    if ($UserLookupPreferenceMode) {
        my %Preferences = $UserObject->SearchPreferences(
            Key => $UserLookupPreference,
        );
        my @MatchingUserIDs = grep {
            IsString( $Preferences{$_} ) && $Preferences{$_} eq $UserLogin
        } keys %Preferences;

        if ( @MatchingUserIDs != 1 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "No unique user for preference '$UserLookupPreference'.",
            );

            return;
        }

        %User = $UserObject->GetUserData(
            UserID => $MatchingUserIDs[0],
            Valid  => 1,
        );
        if ( !$User{UserID} || !IsStringWithData( $User{UserLogin} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "No active user for preference '$UserLookupPreference'.",
            );

            return;
        }

        # Keep the stored password hash out of UserUpdate().
        delete $User{UserPw};
        $UserLogin = $User{UserLogin};
        delete $User{$UserLookupPreference};
    }
    else {
        %User = $UserObject->GetUserData( User => $UserLogin );
    }

    my $UserMap = $ConfigObject->Get('AuthModule::OpenIDConnect::UserMap');
    my $UserID;

    # create and edit users
    if ($UserMap) {
        my %UserData = map { $UserMap->{$_} => $TokenData->{$_} } keys %{$UserMap};

        # don't mess with some data here
        delete $UserData{UserID};
        delete $UserData{UserPw};
        delete $UserData{UserLogin}             if $UserLookupPreferenceMode;
        delete $UserData{$UserLookupPreference} if $UserLookupPreferenceMode;

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

    $Self->{OIDCSession} = $OIDCSession if $OIDCSession;

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
    my $UsePKCE       = $Misc->{UsePKCE} ? 1 : 0;

    if ( $UsePKCE && !grep { $_ eq 'code' } @{ $RequestConfig->{ResponseType} // [] } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'PKCE requires an authorization code response type.',
        );
        $Self->{AuthError} = Translatable('Authentication error. PKCE requires an authorization code response type.');

        return;
    }

    my $TTL = $Misc->{RandTTL} // 300;    # 60 * 5

    # set the state
    my $RandomString = $MainObject->GenerateRandomString(
        Length => $Misc->{RandLength} // $Self->{DefaultRandLength},
    );
    my $StateValue = 1;
    my $CodeChallenge;
    if ($UsePKCE) {
        my $CodeVerifier = $MainObject->GenerateRandomString(
            Length => 64,
        );
        if ( !_CodeVerifierIsValid($CodeVerifier) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not generate a valid PKCE verifier.',
            );
            $Self->{AuthError} = Translatable('Authentication error. Please contact the administrator.');

            return;
        }

        my $Digest = encode_base64( sha256($CodeVerifier), '' );
        $Digest =~ tr!+/!-_!;
        $Digest =~ s/=+\z//;
        $CodeChallenge = $Digest;
        $StateValue    = {
            UsePKCE      => 1,
            CodeVerifier => $CodeVerifier,
        };
    }

    if ( $Misc->{BackchannelLogout} || $Misc->{UseIDTokenHint} ) {
        $StateValue = {} if ref $StateValue ne 'HASH';
        $StateValue->{StartedAt} = time;
    }

    $CacheObject->Set(
        Type          => 'OpenIDConnect_State',
        Key           => $RandomString,
        Value         => $StateValue,
        TTL           => $TTL,
        CacheInMemory => 0,                       # important for distributed systems
    );

    my %Data = (
        State => $RandomString . ( $Param{RequestedURL} // '' ),
    );

    # store the RandomString as a CSRF cookie
    $LayoutObject->SetCookie(
        Key     => 'OIDCCSRF-' . $RandomString,
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

    my %RedirectParam = (
        AuthRequest => {
            %Data,
            %{$RequestConfig},
        },
        ClientSettings   => $OpenIDConfig->{ClientSettings},
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
    );
    $RedirectParam{CodeChallenge} = $CodeChallenge if defined $CodeChallenge;

    my $RedirectURL = $OpenIDConnectObject->BuildRedirectURL(%RedirectParam);

    return {
        RedirectURL => $RedirectURL,
    };
}

sub _CodeVerifierIsValid {
    my ($CodeVerifier) = @_;

    return if !IsStringWithData($CodeVerifier);
    return if $CodeVerifier !~ /\A[A-Za-z0-9\-._~]{43,128}\z/;

    return 1;
}

sub PostAuth {
    my ( $Self, %Param ) = @_;

    return if !$Self->{RequestedURL} && !$Self->{OIDCSession};

    return {
        RequestedURL => $Self->{RequestedURL},
        ( $Self->{OIDCSession} ? ( OIDCSession => $Self->{OIDCSession} ) : () ),
    };
}

sub Logout {
    my ( $Self, %Param ) = @_;

    my $OpenIDConfig        = $Kernel::OM->Get('Kernel::Config')->Get('AuthModule::OpenIDConnect::Config');
    my $OpenIDConnectObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect');

    my %LogoutParam = (
        ProviderSettings => $OpenIDConfig->{ProviderSettings},
        ClientSettings   => $OpenIDConfig->{ClientSettings},
    );
    if ( $OpenIDConfig->{Misc}{UseIDTokenHint} ) {
        my $OIDCSession = $Param{OIDCSession};

        # Password sessions must not log out an unrelated provider session.
        return if !IsHashRefWithData($OIDCSession);
        return if ( $OIDCSession->{ClientID} // '' ) ne ( $OpenIDConfig->{ClientSettings}{ClientID} // '' );

        # Sessions created before this option was enabled still require provider confirmation.
        if ( IsStringWithData( $OIDCSession->{IDToken} ) ) {
            $LogoutParam{IDTokenHint}   = $OIDCSession->{IDToken};
            $LogoutParam{IDTokenIssuer} = $OIDCSession->{Issuer};
        }
    }

    my $LogoutURL = $OpenIDConnectObject->GetLogoutURL(%LogoutParam);

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
