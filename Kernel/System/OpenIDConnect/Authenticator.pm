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

package Kernel::System::OpenIDConnect::Authenticator;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::User',
    'Kernel::System::OpenIDConnect::Token',
    'Kernel::System::OpenIDConnect::UserImport',
);

=head1 NAME

Kernel::System::OpenIDConnect::Authenticator

=for stopwords OIDC

authenticate incoming OIDC OAuth2 Tokens

=head1 SYNOPSIS

authenticate incoming OIDC OAuth2 Tokens based on the Otobo AuthModules

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $AuthenticatorObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Authenticator');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Authenticate()

    Authenticates an incoming Bearer Token

    my $Result = $AuthenticatorObject->Authenticate(
        Token  => $Token,
        Leeway => $AllowedSecondsTimeDrift,    # optional
    );

    where

    my $Result = {
            Success   => 1,
            TokenData => $TokenData,
            UserData  => \%UserData,
    };

=cut

sub Authenticate {
    my ( $Self, %Param ) = @_;

    my $BearerToken = $Param{Token};

    my $Result = { Success => 0 };

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load auth modules
    COUNT:
    for my $Count ( '', 1 .. 10 ) {

        my $GenericModule = $ConfigObject->Get("AuthModule$Count");

        next COUNT if !$GenericModule;

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "Authenticate OAuth2 Token with AuthModule 'AuthModule$Count'",
        );

        $GenericModule =~ s/^Kernel::System::Auth:://;

        my $OpenIDConfig = $ConfigObject->Get( "AuthModule$Count" . "::" . $GenericModule . "::Config" );

        next COUNT if !IsHashRefWithData($OpenIDConfig);

        # validate the token
        my $TokenResult = $Self->_ValidateToken(
            AccountName  => "AuthModule$Count" . "::" . $GenericModule,
            OpenIDConfig => $OpenIDConfig,
            Token        => $BearerToken,
            ConfigObject => $ConfigObject,
            %Param,
        );

        # if token not validated, try next token
        if ( !$TokenResult->{Success} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Failed to authenticate OAuth2 Token with AuthModule 'AuthModule$Count: $TokenResult->{Error} ",
            );

            next COUNT;
        }

        # lookup the UserLogin from the Token data
        my $IDKey = $ConfigObject->Get( "AuthModule$Count" . "::" . $GenericModule . "::UID" ) || 'sub';

        my $UserLogin = $TokenResult->{TokenData}->{$IDKey};

        if ( !IsStringWithData($UserLogin) ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Failed to authenticate OAuth2 Token with AuthModule 'AuthModule$Count' - no UserLogin found.",
            );

            next COUNT;
        }

        # see if the user login matches the expected login
        my $WebserviceRestrictions = $ConfigObject->Get( "AuthModule$Count" . "::" . $GenericModule . '::Webservice::Restrictions' ) || {};

        if ( IsHashRefWithData($WebserviceRestrictions) && $WebserviceRestrictions->{UserLogin} ) {
            if ( $WebserviceRestrictions->{UserLogin} ne $UserLogin ) {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "Failed to authenticate OAuth2 Token with AuthModule 'AuthModule$Count' due to WebserviceRestriction.",
                );

                next COUNT;
            }
        }

        # resolve UserLogin from otobo user db table
        my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            User  => $UserLogin,
            Valid => 1,
        );

        # assert the user actually exists in database
        if ( !$UserData{UserID} ) {

            # try on-the-fly import
            my $UserImportObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::UserImport');
            my $Result           = $UserImportObject->ImportUser(
                TokenData        => $TokenResult->{TokenData},
                OpenIDConfigName => $GenericModule,
            );

            if ( !$Result->{Success} ) {

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "Failed to import User based on fresh OAuth2 Token with AuthModule 'AuthModule$Count': " . $Result->{Error},
                );

                next COUNT;
            }

            %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                User  => $UserLogin,
                Valid => 1,
            );
        }

        # report success!
        return {
            Success   => 1,
            TokenData => $TokenResult->{TokenData},
            UserData  => \%UserData,
        };
    }

    return $Result;
}

# validate

sub _ValidateToken {
    my ( $Self, %Param ) = @_;

    my $Return = { Success => 0 };

    for my $Needed (qw/Token OpenIDConfig AccountName/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return $Return;
        }
    }

    my $OpenIDConfig   = $Param{OpenIDConfig};
    my $AccountName    = $Param{AccountName};
    my $ConfigObject   = $Param{ConfigObject};
    my $ClientSettings = $OpenIDConfig->{ClientSettings};
    my $ValidateToken  = $OpenIDConfig->{Misc}->{ValidateToken} // 1;

    my $WebserviceRestrictions = $ConfigObject->Get( $AccountName . '::Webservice::Restrictions' ) || {};

    my $ExpectedAudience = $WebserviceRestrictions->{Audience} // $ClientSettings->{ClientID};
    my $AuthorizedParty  = $WebserviceRestrictions->{AuthorizedParty};
    my $ExpectedScopes   = $WebserviceRestrictions->{Scope};

    my $TokenObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Token');

    if ($ValidateToken) {

        my $Result = $TokenObject->Validate(
            Token            => $Param{Token},
            OpenIDConfig     => $OpenIDConfig,
            ExpectedAudience => $ExpectedAudience,
            AuthorizedParty  => $AuthorizedParty,
            ExpectedScopes   => $ExpectedScopes,
            Leeway           => $Param{Leeway} // $OpenIDConfig->{Misc}->{Leeway} // 2,
        );

        return $Result;
    }

    my $TokenData = $TokenObject->Inspect(
        Token  => $Param{Token},
        Leeway => $Param{Leeway} // $OpenIDConfig->{Misc}->{Leeway} // 2,
    );

    return {
        Success   => defined $TokenData ? 1 : 0,
        TokenData => $TokenData,
    };
}

1;
