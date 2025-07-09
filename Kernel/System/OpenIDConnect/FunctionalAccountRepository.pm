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

package Kernel::System::OpenIDConnect::FunctionalAccountRepository;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

use namespace::autoclean;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::YAML',
    'Kernel::System::DateTime',

    #    'Kernel::System::OpenIDConnect::Token',
);

=head1 NAME

Kernel::System::OpenIDConnect::FunctionalAccountRepository - DB backend for OIDC Functional Account for Invokers (outgoing calls)

=for stopwords OIDC

=head1 SYNOPSIS

Functiona Accounts DB abstraction for OpenID Connect

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $FunctionalAccountRepositoryObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::FunctionalAccountRepository');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};

    bless( $Self, $Type );

    return $Self;
}

=head2 GetList()

Returns a list of OIDC Functional Accounts. Usage:

    my $List = $FunctionalAccountRepositoryObject->GetList();

    where

    my $List = [
        {
            AccountID => database id,
            Name => $Name,
            OIDCProfileID,
            GrantType,
            Scope,
            Resources,
            ResourceParamName,
            TokenType,
            Valid
        },
        ...
    ];

=cut

sub GetList {

    my ( $Self, %Param ) = @_;

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    $DBObject->Prepare(
        SQL => "SELECT id, valid_id, name, oidc_profile_id, grant_type,
                    scopes, resources, resource_param_name, token_type,
                    username, passwd
                    FROM oidc_functional_accounts ",
    );

    my @Result;
    while (
        my (
            $ID,       $Valid,     $Name, $OIDCProfileID, $GrantType,
            $Scope,    $Resources, $ResourceParamName, $TokenType,
            $Username, $Password
        ) = $DBObject->FetchrowArray
        )
    {

        my $Item = {
            AccountID         => $ID,
            Valid             => $Valid,
            Name              => $Name,
            OIDCProfileID     => $OIDCProfileID,
            GrantType         => $GrantType,
            Scope             => $Scope,
            Resources         => $Resources,
            ResourceParamName => $ResourceParamName,
            TokenType         => $TokenType,
            Username          => $Username,
            Password          => $Password,
        };

        push @Result, $Item;
    }

    return \@Result;
}

=head2 GetAccount()

Returns a specific OIDC Functional Account by name. Usage:

    my $Profile = $FunctionalAccountRepositoryObject->GetAccount( Name => '<FunctionalAccountName>' );

    where

    my $Profile = {
        AccountID => database id,
        Name => $Name,
        OIDCProfileID,
        GrantType,
        Scope,
        Resources,
        ResourceParamName,
        TokenType,
        Valid
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

    my $Name = $Param{Name};

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    $DBObject->Prepare(
        SQL => "SELECT id, valid_id, name, oidc_profile_id,
                    grant_type, scopes, resources, resource_param_name,
                    token_type, username, passwd
                    FROM oidc_functional_accounts WHERE name = ? ",
        Bind => [ \$Name ],
    );

    if (
        my (
            $ID,       $Valid,     $Name, $OIDCProfileID, $GrantType,
            $Scope,    $Resources, $ResourceParamName, $TokenType,
            $Username, $Password
        ) = $DBObject->FetchrowArray()
        )
    {

        my $Item = {
            AccountID         => $ID,
            Valid             => $Valid,
            Name              => $Name,
            OIDCProfileID     => $OIDCProfileID,
            GrantType         => $GrantType,
            Scope             => $Scope,
            Resources         => $Resources,
            ResourceParamName => $ResourceParamName,
            TokenType         => $TokenType,
            Username          => $Username,
            Password          => $Password,
        };

        return $Item;
    }

    return;
}

=head2 GetByID()

Returns a specific OIDC Functional Account by AccountID. Usage:

    my $Profile = $FunctionalAccountRepositoryObject->GetByID( AccountID => <FunctionalAccountID> );

    where

    my $Profile = {
        AccountID => database id,
        Name => $Name,
        OIDCProfileID,
        GrantType,
        Scope,
        Resources,
        ResourceParamName,
        TokenType,
        Valid
    };

=cut

sub GetByID {

    my ( $Self, %Param ) = @_;

    for my $Needed (qw/AccountID/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $AccountID = $Param{AccountID};

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    $DBObject->Prepare(
        SQL => "SELECT id, valid_id, name, oidc_profile_id,
                    grant_type, scopes, resources, resource_param_name,
                    token_type, username, passwd
                    FROM oidc_functional_accounts WHERE id = ? ",
        Bind => [ \$AccountID ],

        #            Limit => 1
    );

    if (
        my (
            $ID,       $Valid,     $Name, $OIDCProfileID, $GrantType,
            $Scope,    $Resources, $ResourceParamName, $TokenType,
            $Username, $Password
        ) = $DBObject->FetchrowArray
        )
    {

        my $Item = {
            AccountID         => $ID,
            Valid             => $Valid,
            Name              => $Name,
            OIDCProfileID     => $OIDCProfileID,
            GrantType         => $GrantType,
            Scope             => $Scope,
            Resources         => $Resources,
            ResourceParamName => $ResourceParamName,
            TokenType         => $TokenType,
            Username          => $Username,
            Password          => $Password,
        };

        return $Item;
    }

    return;
}

=head2 Exists()

    Checks whether a named Functional Account exists.

    my $Exists = $FunctionalAccountRepositoryObject->Exists( Name => $Name );

    returns a boolean

=cut

sub Exists {

    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Needed (qw/Name/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name = $Param{Name};

    $DBObject->Prepare(
        SQL  => "SELECT id FROM oidc_functional_accounts WHERE name = ? ",
        Bind => [ \$Name ],

        #            Limit => 1
    );

    if ( my ($ID) = $DBObject->FetchrowArray ) {
        return $ID;
    }

    return;
}

=head2 AddAccount()

    Insert a new Functional Account into DB.

    Note you need to give the OIDCProfileID as parameter.

    my $Success = $FunctionalAccountRepositoryObject->AddAccount(

        Name => $Name,
        OIDCProfileID,
        GrantType,
        Scope,
        Resources,
        ResourceParamName,
        TokenType,
        Valid,
        UserID,
        Username, # optional, grant_type password only
        Password, # optional, grant_type password only
    );

=cut

sub AddAccount {
    my ( $Self, %Param ) = @_;

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    for my $Needed (qw/Name OIDCProfileID GrantType UserID/) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name              = $Param{Name};
    my $OIDCProfileID     = $Param{OIDCProfileID};
    my $GrantType         = $Param{GrantType};
    my $Scope             = $Param{Scope}             || '';
    my $Resources         = $Param{Resources}         || '';
    my $ResourceParamName = $Param{ResourceParamName} || 'resource';
    my $TokenType         = $Param{TokenType}         || 'access_token';
    my $Valid             = $Param{Valid}             || 1;
    my $Username          = $Param{Username};
    my $Password          = $Param{Password};
    my $UserID            = $Param{UserID};

    my @Bind = (
        \$Name,      \$OIDCProfileID,     \$GrantType, \$Scope,
        \$Resources, \$ResourceParamName, \$TokenType, \$Valid,
        \$UserID,    \$UserID
    );

    my $SQL = "INSERT INTO oidc_functional_accounts
        ( name, oidc_profile_id, grant_type, scopes, resources, resource_param_name,
          token_type, valid_id, create_time, create_by, change_time, change_by ";

    if ($Username) {
        $SQL .= ", username, passwd ";
    }

    $SQL .= " ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ? ";

    if ($Username) {
        $SQL .= ", ?, ? ";
        push @Bind, \$Username;
        push @Bind, \$Password;
    }

    $SQL .= ") ";

    my $InsertSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return $InsertSuccess;
}

=head2 UpdateAccount()

    Update a Functional Account in the DB.

    Note you need to give the OIDCProfileID as parameter.

    my $Success = $FunctionalAccountRepositoryObject->UpdateAccount(

        Name => $Name,
        OIDCProfileID,
        GrantType,
        Scope,
        Resources,
        ResourceParamName,
        TokenType,
        Valid,
        UserID,
        Username, # optional, grant_type password only
        Password, # optional, grant_type password only
    );

=cut

sub UpdateAccount {
    my ( $Self, %Param ) = @_;

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

    for my $Needed (qw/Name OIDCProfileID GrantType UserID/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name              = $Param{Name};
    my $OIDCProfileID     = $Param{OIDCProfileID};
    my $GrantType         = $Param{GrantType};
    my $Scope             = $Param{Scope}             || '';
    my $Resources         = $Param{Resources}         || '';
    my $ResourceParamName = $Param{ResourceParamName} || 'resource';
    my $TokenType         = $Param{TokenType}         || 'access_token';
    my $Valid             = $Param{Valid}             || 1;
    my $Username          = $Param{Username};
    my $Password          = $Param{Password};

    my $UserID = $Param{UserID};

    my @Bind = (
        \$OIDCProfileID, \$GrantType, \$Scope,
        \$Resources,     \$ResourceParamName, \$TokenType, \$Valid,
        \$UserID
    );

    my $SQL = "UPDATE oidc_functional_accounts SET oidc_profile_id = ?,
        grant_type = ?, scopes = ?, resources = ?, resource_param_name = ?,
        token_type = ?, valid_id = ?, change_time = current_timestamp,
        change_by = ? ";

    if ($Username) {
        $SQL .= ", username = ?, passwd = ? ";
        push @Bind, \$Username;
        push @Bind, \$Password;
    }

    push @Bind, \$Name;
    $SQL .= " WHERE name = ? ";

    my $UpdateSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return $UpdateSuccess;
}

=head2 DeleteAccount()

    Delete a Functional Account from DB.

    my $Success = $FunctionalAccountRepositoryObject->DeleteAccount( Name => $Name );

=cut

sub DeleteAccount {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Needed (qw/Name/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $Name = $Param{Name};

    my $SQL  = "DELETE FROM oidc_functional_accounts WHERE name = ? ";
    my $Bind = [ \$Name, ];

    my $DeleteSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => $Bind,
    );

    return $DeleteSuccess;
}

1;
