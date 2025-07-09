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

package Kernel::System::OpenIDConnect::UserImport;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::User',
    'Kernel::System::Group',
);

=head1 NAME

Kernel::System::OpenIDConnect::UserImport

=for stopwords OIDC

Import users into Otobo based on valid OpenID Connect Token.

=head1 SYNOPSIS


create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $UserImportObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::UserImport');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ImportUser()

Import an User into Otobo based on valid OIDC Token

    my $Success = $UserImportObject->ImportUser(
        Token => $Token,                        # Token with user details to map
        OpenIDConfigName => $OpenIDConfigName,  # OpenIDConfigName to lookup OIDC Auth Module from Config.pm
                                                # often 'AuthModule::OpenIDConnect::Config'
    );

=cut

sub ImportUser {

    my ( $Self, %Param ) = @_;

    my $TokenData        = $Param{TokenData};
    my $OpenIDConfigName = $Param{OpenIDConfigName};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if there is a specific User and RoleMap for this OIDC config,
    # otherwise see if there is a default one
    my $UID     = $ConfigObject->Get( $OpenIDConfigName . '::UID' )     || 'sub';
    my $UserMap = $ConfigObject->Get( $OpenIDConfigName . '::UserMap' ) || $ConfigObject->Get('AuthModule::OpenIDConnect::UserMap');
    my $RoleMap = $ConfigObject->Get( $OpenIDConfigName . '::RoleMap' ) || $ConfigObject->Get('AuthModule::OpenIDConnect::RoleMap');

    # determine jwt clain to otobo UserLogin mapping
    my $UserLogin = $TokenData->{$UID};
    if ( !$UserLogin ) {

        return {
            Success => 0,
            Error   => "Token received but UID was not provided in '$UID'.",
        };
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

        return {
            Success => 0,
            Error   => "Unauthorized as per RoleMap.",
        };
    }

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my %User = $UserObject->GetUserData( User => $UserLogin );
    my $UserID;

    # create and edit users
    if ($UserMap) {

        my %UserData = map { $UserMap->{$_} => $TokenData->{$_} } keys %{$UserMap};

        # don't mess with some data here
        delete $UserData{UserID};
        delete $UserData{UserPw};

        # userdata, with reasonable defaults
        $UserData{UserFirstname} = $UserData{UserFirstname} || $TokenData->{azp}                || 'otobo';
        $UserData{UserLastname}  = $UserData{UserLastname}  || $TokenData->{preferred_username} || 'bot';
        $UserData{UserEmail}     = $TokenData->{email}      || $UserData{UserEmail}             || 'systemuser@otobo.local';

        if ( !%User ) {

            # adduser
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

            # update existing user
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

        return {
            Success => 0,
            Error   => "No UserID for $UserLogin. Aborting.",
        };

    }

    # successful return if no authorization has to be done

    return return {
        Success   => 1,
        UserID    => $UserID,
        UserLogin => $UserLogin,
    } if !$RoleMap;

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

    return {
        Success   => 1,
        UserID    => $UserID,
        UserLogin => $UserLogin,
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
