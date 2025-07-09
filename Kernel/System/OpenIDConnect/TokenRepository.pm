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

package Kernel::System::OpenIDConnect::TokenRepository;

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
    'Kernel::System::DateTime',
    'Kernel::System::OpenIDConnect::Token',
);

=head1 NAME

Kernel::System::OpenIDConnect::TokenRepository - DB backend for TokenStorage

=head1 SYNOPSIS

Functional account functions for OpenID Connect

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TokenRepositoryObject = $Kernel::OM->Get('Kernel::System::OpenIDConnect::TokenRepository');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};

    bless( $Self, $Type );

    return $Self;
}

=head2 SaveToken()

    Persist a Token in DB

    my $Success = $TokenRepositoryObject->SaveToken(
        AccountID  => <FunctionalAccountID>,    # FunctionalAccount id
        TokenType  => 'refresh',                # access_token|id_token|refresh_token
        Token      => '<Token>',                # as received from token endpoint
        ExpiresAt  => '<seconds epoch>',        # expires at UNIX epoch timestamp. can be null for offline_access tokens
    );

=cut

sub SaveToken {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Needed (qw/AccountID TokenType Token/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Self->DeleteToken(%Param);

    my $AccountID = $Param{AccountID};
    my $TokenType = $Param{TokenType};
    my $Token     = $Param{Token};
    my $ExpiresAt = $Param{ExpiresAt};

    my $InsertSuccess = $DBObject->Do(
        SQL  => "INSERT INTO oauth2_token_storage (oidc_functional_account_id, token_type, token, expires_at) VALUES (?, ?, ?, ?)",
        Bind => [ \$AccountID, \$TokenType, \$Token, \$ExpiresAt ],
    );

    return $InsertSuccess;
}

=head2 DeleteToken()

    Delete a Token record in DB.

    my $Success = $TokenRepositoryObject->DeleteToken(
        AccountID   => <FunctionalAccountID>,
        TokenType   => 'refresh',              # optional
    );

    or

    my $Success = $TokenRepositoryObject->DeleteToken(
        AccountName => <FunctionalAccountID>,
        TokenType   => 'refresh',              # optional
    );

    or

    my $Success = $TokenRepositoryObject->DeleteToken(
        TokenID => <id>
    );

=cut

sub DeleteToken {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{TokenID} ) {

        my $TokenID = $Param{TokenID};

        my $DeleteSuccess = $DBObject->Do(
            SQL  => "DELETE FROM oauth2_token_storage WHERE id = ?",
            Bind => [ \$TokenID ],
        );

        return $DeleteSuccess;
    }

    if ( $Param{AccountName} ) {

        my $AccountName = $Param{AccountName};

        $DBObject->Prepare(
            SQL   => "SELECT id FROM oidc_functional_accounts WHERE name = ?  ",
            Bind  => [ \$AccountName ],
            Limit => 1
        );

        if ( my ($AccountID) = $DBObject->FetchrowArray ) {

            my $SQL  = "DELETE FROM oauth2_token_storage WHERE oidc_functional_account_id = ? ";
            my $Bind = [ \$AccountID ];

            my $TokenType = $Param{TokenType};
            if ($TokenType) {
                $SQL .= " AND token_type = ? ";
                push @$Bind, \$TokenType;
            }

            my $DeleteSuccess = $DBObject->Do(
                SQL  => $SQL,
                Bind => $Bind,
            );

            return $DeleteSuccess;
        }
        return;
    }

    for my $Needed (qw/AccountID/) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $TokenType = $Param{TokenType};

    if ( $TokenType && !$Self->ValidateTokenType(%Param) ) {
        return;
    }

    my $AccountID = $Param{AccountID};

    my $SQL  = "DELETE FROM oauth2_token_storage WHERE oidc_functional_account_id = ? ";
    my $Bind = [ \$AccountID, ];

    if ($TokenType) {
        $SQL .= "AND token_type = ? ";
        push @$Bind, \$TokenType;
    }

    my $DeleteSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => $Bind,
    );

    return $DeleteSuccess;
}

=head2 Cleanup()

    This purges any expired Tokens from DB.

    my $Success = $TokenRepositoryObject->Cleanup();

=cut

sub Cleanup {

    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );

    $DateTimeObject->ToTimeZone(
        TimeZone => 'UTC'
    );

    my $Epoch = $DateTimeObject->ToEpoch();

    my $SQL  = "DELETE FROM oauth2_token_storage WHERE expires_at IS NOT NULL and expires_at != 0 AND expires_at < ? ";
    my $Bind = [ \$Epoch ];

    my $DeleteSuccess = $DBObject->Do(
        SQL  => $SQL,
        Bind => $Bind,
    );

    return $DeleteSuccess;
}

=head2 GetToken()

    Retrive a Token record from DB.

    my $TokenData = $TokenRepositoryObject->GetToken(
        AccountID  => <FunctionalAccountID>,
        TokenType  => 'refresh',
    );

    or

    my $TokenData = $TokenRepositoryObject->GetToken(
        AccountName  => <FunctionalAccountID>,
        TokenType    => 'refresh',
    );

    or

    my $TokenData = $TokenRepositoryObject->GetToken(
        TokenID => <id>
    );

    where:

    $TokenData = {
        TokenID => <id>,
        AccountID => '<AccountID>',
        TokenType => 'refresh_token',
        Token => '<Token>',
        ExpiresAt => 1234, # unix epoch ts
    };

=cut

sub GetToken {
    my ( $Self, %Param ) = @_;

    $Self->Cleanup();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Param{TokenID} ) {

        my $TokenID = $Param{TokenID};

        $DBObject->Prepare(
            SQL => "SELECT id, oidc_functional_account_id, token_type, token, expires_at
                      FROM oauth2_token_storage WHERE id = ?  ",
            Bind  => [ \$TokenID ],
            Limit => 1
        );
    }
    elsif ( $Param{AccountName} ) {

        my $AccountName = $Param{AccountName};
        my $TokenType   = $Param{TokenType};

        my $SQL = "SELECT ots.id, ots.oidc_functional_account_id, ots.token_type, ots.token, ots.expires_at
                    FROM oauth2_token_storage ots
                    LEFT JOIN oidc_functional_accounts ofa
                    ON ots.oidc_functional_account_id = ofa.id
                    WHERE ofa.name = ?  ";

        my $Bind = [ \$AccountName ];

        if ($TokenType) {
            $SQL .= " AND ots.token_type = ? ";
            push @$Bind, \$TokenType;
        }

        $DBObject->Prepare(
            SQL   => $SQL,
            Bind  => $Bind,
            Limit => 1
        );
    }
    else {

        for my $Needed (qw/AccountID TokenType/) {
            if ( !$Param{$Needed} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need $Needed!",
                );

                return;
            }
        }

        if ( !$Self->ValidateTokenType(%Param) ) {
            return;
        }

        my $AccountID = $Param{AccountID};
        my $TokenType = $Param{TokenType};

        $DBObject->Prepare(
            SQL => "SELECT id, oidc_functional_account_id, token_type, token, expires_at
                      FROM oauth2_token_storage
                      WHERE oidc_functional_account_id = ? AND token_type = ? ",
            Bind  => [ \$AccountID, \$TokenType ],
            Limit => 1
        );
    }

    if ( my ( $TokenID, $AccountID, $TokenType, $Token, $ExpiresAt ) = $DBObject->FetchrowArray ) {

        return {
            TokenID   => $TokenID,
            AccountID => $AccountID,
            TokenType => $TokenType,
            Token     => $Token,
            ExpiresAt => $ExpiresAt,
        };
    }

    return;
}

=head2 GetList()

    Get a list of Tokens for Display.

    my $Tokens = $TokenRepositoryObject->GetList(
        ExpiresAfter => Unix epoch timestamp, # optional
        TokenType    => 'refresh_token',      # optional, defaults to 'refresh_token',
                                              # can be 'refresh_token' or 'access_token'
                                              # or 'id_token' or 'all'
    );

    where:

    my $Tokens = [
        {
            TokenID    => 1,
            AccountID  => <FunctionalAccoungtID>,
            TokenType  => 'refresh_token',
            Token      => <TokenData>,
            ExpiresAt  => UNIX epoch timestamp,
        },
        ...
    ];

=cut

sub GetList {

    my ( $Self, %Param ) = @_;

    $Self->Cleanup();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $ExpiresAfter = $Param{ExpiresAfter};
    my $TokenType    = $Param{TokenType} || 'refresh_token';

    my $SQL  = "SELECT id, oidc_functional_account_id, token_type, token, expires_at FROM oauth2_token_storage WHERE 1=1 ";
    my $Bind = [];

    if ( $TokenType ne 'all' ) {
        $SQL .= "AND token_type = ? ";
        push @$Bind, \$TokenType;
    }

    if ($ExpiresAfter) {

        $SQL .= "AND expires_at IS NULL OR expires_at = 0 OR expires_at < ? ";
        push @$Bind, \$ExpiresAfter;
    }

    $SQL .= "ORDER BY oidc_functional_account_id, expires_at ";

    $DBObject->Prepare(
        SQL  => $SQL,
        Bind => $Bind,
    );

    my @Result;
    while ( my ( $TokenID, $AccountID, $TokenType, $Token, $ExpiresAt ) = $DBObject->FetchrowArray ) {

        push @Result, {
            TokenID   => $TokenID,
            AccountID => $AccountID,
            TokenType => $TokenType,
            Token     => $Token,
            ExpiresAt => $ExpiresAt,
        };
    }

    return \@Result;
}

=head2 ValidateTokenType()

    Validate TokenType value.

    my $Boolean = $TokenRepositoryObject->ValidateTokenType( TokenType => 'refresh_token' );

    returns true if TokenType is one of access_token|id_token|refresh_token, false otherwise.

=cut

sub ValidateTokenType {
    my ( $Self, %Param ) = @_;

    if (
        $Param{TokenType} ne 'access_token' &&
        $Param{TokenType} ne 'id_token'     &&
        $Param{TokenType} ne 'refresh_token'
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "TokenType must be one of 'access_token,id_token,refresh_token', but was '$Param{TokenType}'.\n",
        );

        return 0;
    }

    return 1;
}

1;
