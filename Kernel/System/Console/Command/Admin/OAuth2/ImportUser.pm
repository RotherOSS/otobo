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

package Kernel::System::Console::Command::Admin::OAuth2::ImportUser;

use strict;
use warnings;
use JSON;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::User',
    'Kernel::System::Group',
    'Kernel::System::OpenIDConnect::Configuration',
    'Kernel::System::OpenIDConnect::Token',
    'Kernel::System::OpenIDConnect::TokenProvider',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Import a Functional User Account from an OpenID Connect Provider.');
    $Self->AddOption(
        Name        => 'openid-config',
        Description =>
            "The name of OpenID Config to use. Defaults to 'AuthModule::OpenIDConnect' for using the default OIDC login provider if this system uses OIDC for login purposes. Otherwise use one of 'OpenIDConnect::UserMapping###Custom1' ... CustomN Keys. ",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'grant-type',
        Description => "Specify the OAuth2 grant-type (one of password|client_credentials).",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^(password)|(client_credentials)$/smx,
    );

    $Self->AddOption(
        Name        => 'username',
        Description => "Specify the OAuth2 username if grant-type is 'password'.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'password',
        Description => "Specify the OAuth2 password if grant-type is 'password'.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr//smx,
    );

    $Self->AddOption(
        Name        => 'scope',
        Description => "Specify the OAuth2 scope(s) as a space separated list. optional.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'resource',
        Description => "Specify the OAuth2 resource parameter as a space separated list. optional.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'resource-param-name',
        Description => "Specify the OAuth2 resource parameter name, that is the name of the parameter itself. optional, defaults to 'resource'",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'token-type',
        Description => "Specify the OAuth2 token type, can be 'access_token' or 'id_token'. defaults to 'id_token'.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^(access_token)|(id_token)$/smx,
    );

    $Self->AddOption(
        Name        => 'user-map',
        Description => "Specify the name of the UserMap system configuration setting. defaults to 'AuthModule::OpenIDConnect::UserMap'.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'role-map',
        Description => "Specify the name of the RoleMap system configuration setting. defaults to 'AuthModule::OpenIDConnect::RoleMap'.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'uid',
        Description => "Specify the name of jwt token claim to be mapped to the Otobo UserLogin. Defaults to 'sub'",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'dry-run',
        Description => "Simulate actions, do not actually add user",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr//smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<green>Importing Functional Account...</green>\n");

    if ( $Self->GetOption('dry-run') ) {

        $Self->Print("<yellow>dry-run mode: not performing any actual changes.</yellow>\n");
    }

    # gather parameter values
    my $OpenIDProfileName = $Self->GetOption('openid-config') || 'AuthModule::OpenIDConnect';
    my $OpenIDConfigName  = $OpenIDProfileName . '::Config';

    #    my $OIDCConfigurationObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $OpenIDConfig = $ConfigObject->Get($OpenIDConfigName);
    if ( !IsHashRefWithData($OpenIDConfig) ) {

        $Self->PrintError('Invalid OpenIDConfig!');
        return $Self->ExitCodeError();
    }

    my $GrantType = $Self->GetOption('grant-type');
    if ( $GrantType eq 'password' ) {
        if ( !$Self->GetOption('username') ) {

            $Self->PrintError("Need --username (and probably --password) for grant-type 'password'.");
            return $Self->ExitCodeError();
        }
    }

    my $TokenType = $Self->GetOption('token-type') || 'id_token';
    my $UID       = $Self->GetOption('uid')        || 'sub';
    my $UserMap   = $ConfigObject->Get( $Self->GetOption('user-map') || $OpenIDProfileName . '::UserMap' );
    my $RoleMap   = $ConfigObject->Get( $Self->GetOption('role-map') || $OpenIDProfileName . '::RoleMap' );

    # now use TokenProvider to do the Token fetching for us
    my $TokenProvider = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenProvider');

    my $Result = $TokenProvider->FetchTokenFromConfig(
        TokenType         => $Self->GetOption('token-type')          || 'access_token',
        ResourceParamName => $Self->GetOption('resource-param-name') || 'resource',
        Resources         => $Self->GetOption('resource'),
        Scope             => $Self->GetOption('scope'),
        OpenIDConfig      => $OpenIDConfig,
        GrantType         => $GrantType,
        Username          => $Self->GetOption('username'),
        Password          => $Self->GetOption('password'),
    );

    if ( !$Result->{Success} ) {
        $Self->PrintError( 'Error Fetching Token: ' . $Result->{Error} );
        return $Self->ExitCodeError();
    }

    my $Token = $Result->{DecodedContent}->{$TokenType};
    if ( !$Token ) {

        $Self->PrintError("Did not receive desired token type '$TokenType'.");
        return $Self->ExitCodeError();
    }

    # inspect the Token payload
    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');
    my $TokenData   = $TokenObject->Inspect( Token => $Token );

    $Self->Print( encode_json($TokenData) . "\n" );

    # determine jwt clain to otobo UserLogin mapping
    my $UserLogin = $TokenData->{$UID};
    if ( !$UserLogin ) {

        $Self->PrintError("Token received but UID was not provided in '$UID'.");
        return $Self->ExitCodeError();
    }

    # Roles
    my %Roles;
    if ($RoleMap) {
        %Roles = $Self->_ExtractMap(
            Map  => $RoleMap,
            Data => $TokenData,
        );
    }

    # if OpenIDConnect is configured to provide authorization but the user has no rights return
    if ( $RoleMap && !%Roles ) {

        $Self->PrintError("Unauthorized as per RoleMap.");
        return $Self->ExitCodeError();
    }

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my %User       = $UserObject->GetUserData( User => $UserLogin );
    my $UserID;

    # create and edit users
    if ($UserMap) {

        my %UserData = map { $UserMap->{$_} => $TokenData->{$_} } keys %{$UserMap};

        # don't mess with some data here
        delete $UserData{UserID};
        delete $UserData{UserPw};

        $UserData{UserFirstname} = $UserData{UserFirstname} || $TokenData->{azp}                || 'otobo';
        $UserData{UserLastname}  = $UserData{UserLastname}  || $TokenData->{preferred_username} || 'bot';
        $UserData{UserEmail}     = $TokenData->{email}      || $UserData{UserEmail}             || 'systemuser@otobo.local';

        if ( !%User ) {

            $Self->Print("<yellow>Adding User  $UserLogin </yellow>\n");

            for my $Key ( keys %UserData ) {
                $Self->Print( "    <yellow>$Key : " . $UserData{$Key} . "</yellow>\n" );
            }

            if ( !$Self->GetOption('dry-run') ) {
                $UserID = $UserObject->UserAdd(
                    UserFirstname => '-',
                    UserLastname  => '-',
                    %UserData,
                    UserLogin    => $UserLogin,
                    ValidID      => 1,
                    ChangeUserID => 1,
                );
            }
        }

        else {

            $Self->Print("<yellow>Updating User  $UserLogin </yellow>\n");

            for my $Key ( keys %UserData ) {
                $Self->Print( "    <yellow>$Key : " . $UserData{$Key} . "</yellow>\n" );
            }

            my $Update;
            KEY:
            for my $Key ( keys %UserData ) {
                if ( $UserData{$Key} ne $User{$Key} ) {
                    $Update = 1;

                    last KEY;
                }
            }

            if ( $Update && !$Self->GetOption('dry-run') ) {
                $UserObject->UserUpdate(
                    %User,
                    %UserData,
                    ChangeUserID => 1,
                );
            }
        }
    }

    $UserID //= $User{UserID};

    if ( !$UserID && $Self->GetOption('dry-run') != 1 ) {

        $Self->PrintError("No UserId for $UserLogin. Aborting.");
        return $Self->ExitCodeError();
    }
    if ($UserID) {
        $Self->Print("<yellow>\nUserID: $UserID\n</yellow>\n");
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

            $Self->Print("<yellow>  Check Role: $RoleName</yellow>\n");

            if ( !$Self->GetOption('dry-run') ) {
                $GroupObject->PermissionRoleUserAdd(
                    UID    => $UserID,
                    RID    => $AllRoles{$RoleName},
                    Active => $Roles{$RoleName} || 0,
                    UserID => 1,
                );
            }
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
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
