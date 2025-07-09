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

package Kernel::System::OpenIDConnect::FunctionalAccounts;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::SysConfig',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::OpenIDConnect::Configuration',
    'Kernel::System::OpenIDConnect::ProfileRepository',
    'Kernel::System::OpenIDConnect::FunctionalAccountRepository',
    'Kernel::System::OpenIDConnect::TokenRepository',
);

=head1 NAME

Kernel::System::OpenIDConnect::FunctionalAccounts

=for stopwords OIDC

manage OAuth2/OIDC backed Functional Accounts.
Currently implemented are accounts for
Invokers and Providers. MailAccounts next.

=head1 SYNOPSIS

Functional account functions for OpenID Connect

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $FunctionalAccountsObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccounts');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 GetAccounts()

Returns the OAuth Functional accounts for Invokers from DB

    my $Accounts = $FunctionalAccountsObject->GetAccounts(
        Valid => 1 # optional
    );

    returns [
        {
            AccountID => database id,
            Name => $Name,
            OIDCProfileID,
            OpenIDConfig,
            OIDCProfile => {
                ProfileID => $ID,
                UID => $UID,
                Valid => $Valid,
                ClientSettings => {

                    ClientID  => $ClientID,
                    ClientSecret => $ClientSecret,
                    RedirectURI => $RedirectURI,
                },
                ProviderSettings => {
                    OpenIDConfiguration => $OpenIDConfig,
                    TTL => $TTL,
                    Name => $Name,
                    SSLOptions => $YAMLObject->Load( Data => $SSLOptions || {} ),
                },
                Misc => $YAMLObject->Load( Data => $Misc || {} ),
            },
            GrantType,
            Scope,
            Resources,
            ResourceParamName,
            TokenType,
            Valid
        }, ...
    ];
=cut

sub GetAccounts {

    my ( $Self, %Param ) = @_;

    my $FunctionalAccountRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccountRepository');
    my $ProfileRepository           = $Kernel::OM->Get('Kernel::System::OpenIDConnect::ProfileRepository');

    my $Valid = $Param{Valid};

    my $Accounts = $FunctionalAccountRepository->GetList();

    my @Result;

    for my $Account (@$Accounts) {
        if ( ( !defined $Valid ) || ( $Account->{Valid} == $Valid ) ) {

            my $OIDCProfile = $ProfileRepository->GetProfile( ProfileID => $Account->{OIDCProfileID} );

            $Account->{OIDCProfile} = $OIDCProfile;

            push @Result, $Account;
        }
    }

    return \@Result;
}

=head2 GetAccount()

Returns a named OAuth Functional accounts for Invokers from DB

    my $Account = $FunctionalAccountsObject->GetAccount(
        Name  => '<SomeAccountName>',
    );

    returns
    {
        AccountID => $ID,
        Valid => $Valid,
        Name => $Name,
        OIDCProfileID => $OIDCProfileID,
        OIDCProfile => {
            ProfileID => $ID,
            UID => $UID,
            Valid => $Valid,
            ClientSettings => {

                ClientID  => $ClientID,
                ClientSecret => $ClientSecret,
                RedirectURI => $RedirectURI,
            },
            ProviderSettings => {
                OpenIDConfiguration => $OpenIDConfig,
                TTL => $TTL,
                Name => $Name,
                SSLOptions => $YAMLObject->Load( Data => $SSLOptions || {} ),
            },
            Misc => $YAMLObject->Load( Data => $Misc || {} ),
        },
        GrantType => $GrantType,
        Scope => $Scope,
        Resources => $Resources,
        ResourceParamName => $ResourceParamName,
        TokenType => $TokenType,
    };

=cut

sub GetAccount {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Name/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $FunctionalAccountRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccountRepository');

    my $Account = $FunctionalAccountRepository->GetAccount( Name => $Param{Name} );
    return if !$Account;

    my $ProfileRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::ProfileRepository');
    my $OIDCProfile       = $ProfileRepository->GetProfile( ProfileID => $Account->{OIDCProfileID} );

    $Account->{OIDCProfile} = $OIDCProfile;
    return $Account;
}

=head2 SaveAccount()

Persists a Functional Account in DB. This implements Save-or-Update.

    my $Success = $FunctionalAccountsObject->SaveAccount(
        Name              => '<SomeAccountName>',
        OIDCProfileID     => $Param{ProviderName},
        GrantType         => $Param{GrantType},
        Scope             => $Param{InvokerScopes},
        Resources         => $Param{Resources},
        ResourceParamName => $Param{ResourceParam},
        Token             => $Param{TokenType},
        Username          => $Param{Username},
        Password          => $Param{Password},
        Valid             => 1,
        UserID            => # userid making changes
    );

=cut

sub SaveAccount {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Name OIDCProfileID GrantType UserID/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name = $Param{Name};

    my $FunctionalAccountRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccountRepository');

    my $Exists = $FunctionalAccountRepository->Exists( Name => $Name );
    if ($Exists) {

        return $FunctionalAccountRepository->UpdateAccount(%Param);
    }
    else {
        return $FunctionalAccountRepository->AddAccount(%Param);
    }
}

=head2 DeleteAccount()

Deletes an Functional accounts from DB. Deleting an Account will remove
and associated Tokens!

    my $Account = $FunctionalAccountsObject->DeleteAccount(
        Name  => '<SomeAccountName>',
        UserID     => # UserID making changes
    );

=cut

sub DeleteAccount {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/Name UserID/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name = $Param{Name};

    my $TokenRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');

    $TokenRepository->DeleteToken(
        AccountName => $Name,
    );

    my $FunctionalAccountRepository = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccountRepository');

    return $FunctionalAccountRepository->DeleteAccount( Name => $Name );
}

=head2 GetProviderData()

Returns the OpenId dynamic Provider Data for a Functional account for Invokers

    my $OpenIDProviderData = $FunctionalAccountsObject->GetProviderData(
        Name  => '<SomeAccountName>',
    );

=cut

sub GetProviderData {

    my ( $Self, %Param ) = @_;

    my $Account = $Self->GetAccount(%Param);

    my $OIDCProfile = $Account->{OIDCProfile};

    my $OIDCConfiguration  = $Kernel::OM->Get('Kernel::System::OpenIDConnect::Configuration');
    my $OpenIDProviderData = $OIDCConfiguration->GetProviderData(
        OpenIDConfig => $OIDCProfile
    );

    return $OpenIDProviderData;
}

=head2 GetIssuer()

=for stopwords iss

Returns the OpenId dynamic Provider Issuer value for a Functional account for Invokers.
This can be used to validate an 'iss' request parameter for incoming OAuth authorization_code callbacks.

    my $Issuer = $FunctionalAccountsObject->GetIssuer(
        Name  => '<SomeAccountName>',
    );

    this method returns a simple string.

=cut

sub GetIssuer {

    my ( $Self, %Param ) = @_;

    my $OpenIDProviderData = $Self->GetProviderData(%Param);
    return unless IsHashRefWithData($OpenIDProviderData);

    return $OpenIDProviderData->{OpenIDConfiguration}->{issuer};
}

=head2 GetTokenEndpoint()

Returns the token endpoint for this Functional Account.

    my $Issuer = $FunctionalAccountsObject->GetTokenEndpoint(
        Name  => '<SomeAccountName>',
     );

    this method returns a simple string.

=cut

sub GetTokenEndpoint {

    my ( $Self, %Param ) = @_;

    my $OpenIDProviderData = $Self->GetProviderData(%Param);

    return $OpenIDProviderData->{OpenIDConfiguration}->{token_endpoint};
}

=head2 GetAuthorizationEndpoint()

Returns the authorization (login) endpoint for this Functional Account.

    my $Issuer = $FunctionalAccountsObject->GetAuthorizationEndpoint(
        Name  => '<SomeAccountName>',
     );

    this method returns a simple string.

=cut

sub GetAuthorizationEndpoint {

    my ( $Self, %Param ) = @_;

    my $OpenIDProviderData = $Self->GetProviderData(%Param);

    return $OpenIDProviderData->{OpenIDConfiguration}->{authorization_endpoint};
}

=head2 ClearCache()

Clears the cached OIDC Provideer data for this functional account

    $FunctionalAccountsObject->ClearCache(
        Name  => '<SomeAccountName>',
     );

=cut

sub ClearCache {

    my ( $Self, %Param ) = @_;

    my $Account = $Self->GetAccount(%Param);

    my $OIDCProfile = $Account->{OIDCProfile};

    #    my $OpenIDConfig = $Self->GetOpenIDConfig(%Param);

    my $ProviderKey = 'ProviderData' . ( $OIDCProfile->{ProviderSettings}->{Name} // '' );

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'OpenIDConnect',
        Key  => $ProviderKey,
    );

    return;
}

1;
