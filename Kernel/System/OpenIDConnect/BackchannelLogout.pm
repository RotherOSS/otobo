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

package Kernel::System::OpenIDConnect::BackchannelLogout;

use v5.24;
use strict;
use warnings;

# core modules
use Digest::SHA  qw(sha256_hex);
use Encode       qw(encode_utf8);
use Scalar::Util qw(looks_like_number);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::JSON',
);

=head1 NAME

Kernel::System::OpenIDConnect::BackchannelLogout - revoke OIDC agent sessions

=head1 DESCRIPTION

Stores durable logout markers and removes matching OIDC agent sessions.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {}, $Type;

    return $Self;
}

=head2 Revoke()

Store a verified logout marker before removing matching sessions.

    my $Success = $Object->Revoke(
        Claims    => $Claims,
        ClientID  => 'otobo',
        Retention => 86400,
        Leeway    => 0,
    );

=cut

sub Revoke {
    my ( $Self, %Param ) = @_;

    my $Claims            = $Param{Claims};
    my $ClientID          = $Param{ClientID};
    my $AuthSessionObject = $Param{SessionObject};

    return if ref $Claims ne 'HASH';
    return if !ref $AuthSessionObject || !$AuthSessionObject->can('GetAllSessionIDs');
    return if !$Self->_StringValid( $Claims->{iss} );
    return if !$Self->_StringValid($ClientID);
    return if !$Self->_StringValid( $Claims->{jti} );
    return if !$Self->_NumberValid( $Claims->{iat} );
    return if !$Self->_NumberValid( $Claims->{exp} );
    return if $Claims->{exp} <= $Claims->{iat};
    return if !$Self->_StringValid( $Claims->{sid} ) && !$Self->_StringValid( $Claims->{sub} );

    my $Retention = $Param{Retention} // 86400;
    my $Leeway    = $Param{Leeway}    // 0;
    return if !$Self->_NumberValid($Retention) || $Retention < 0;
    return if !$Self->_NumberValid($Leeway)    || $Leeway < 0;

    my $Now         = time;
    my $Expires     = $Now + $Retention;
    my $TokenExpiry = $Claims->{exp} + $Leeway;
    $Expires = $TokenExpiry if $TokenExpiry > $Expires;
    my $RevokedBefore = $Claims->{iat} + $Leeway;

    my $SessionID   = $Claims->{sid};
    my $Subject     = $Claims->{sub};
    my $TargetType  = $Self->_StringValid($SessionID) ? 'sid'      : 'sub';
    my $TargetValue = $TargetType eq 'sid'            ? $SessionID : $Subject;

    my $SubjectHash = $Self->_StringValid($Subject) ? sha256_hex( encode_utf8($Subject) ) : undef;
    my $Key         = $Self->_TombstoneKey(
        Issuer     => $Claims->{iss},
        ClientID   => $ClientID,
        TargetType => $TargetType,
        Target     => $TargetValue,
        JTI        => $Claims->{jti},
    );

    # Expired rows are removed before adding the new marker to keep this namespace bounded.
    return if !$Self->_ExpiredTombstonesRemove();

    my $Value = {
        IssuedAt    => $RevokedBefore,
        SubjectHash => $SubjectHash,
        Expires     => $Expires,
    };

    my $Stored = $Self->_TombstoneStore(
        Key   => $Key,
        Value => $Value,
    );
    return if !$Stored;

    my @SessionIDs = $AuthSessionObject->GetAllSessionIDs();

    SESSIONID:
    for my $SessionID (@SessionIDs) {

        next SESSIONID if !$SessionID;

        my %SessionData = $AuthSessionObject->GetSessionIDData(
            SessionID => $SessionID,
            NoCache   => 1,
        );

        next SESSIONID if !$Self->_SessionMatches(
            SessionData => \%SessionData,
            Claims      => $Claims,
            ClientID    => $ClientID,
            Leeway      => $Leeway,
        );

        my $Removed = $AuthSessionObject->RemoveSessionID(
            SessionID => $SessionID,
        );
        next SESSIONID if $Removed;

        return;
    }

    return 1;
}

=head2 SessionAllowed()

Check whether verified OIDC session metadata is covered by a logout marker.

    my $Allowed = $Object->SessionAllowed(
        Session => $SessionData{OIDCSession},
    );

Returns 1 when allowed, 0 when revoked or malformed, and undef on storage failure.

=cut

sub SessionAllowed {
    my ( $Self, %Param ) = @_;

    my $Session = $Param{Session};
    return 1 if !defined $Session;
    return 0 if ref $Session ne 'HASH';
    return 0 if !$Self->_StringValid( $Session->{Issuer} );
    return 0 if !$Self->_StringValid( $Session->{ClientID} );
    return 0 if !$Self->_StringValid( $Session->{Subject} ) && !$Self->_StringValid( $Session->{SessionID} );
    return 0 if !$Self->_NumberValid( $Session->{IssuedAt} );
    return 0 if !$Self->_NumberValid( $Session->{StartedAt} );

    my @Scopes;
    if ( $Self->_StringValid( $Session->{SessionID} ) ) {
        push @Scopes, {
            TargetType => 'sid',
            Target     => $Session->{SessionID},
        };
    }
    if ( $Self->_StringValid( $Session->{Subject} ) ) {
        push @Scopes, {
            TargetType => 'sub',
            Target     => $Session->{Subject},
        };
    }

    for my $Scope (@Scopes) {

        my $Prefix = $Self->_TombstonePrefix(
            Issuer     => $Session->{Issuer},
            ClientID   => $Session->{ClientID},
            TargetType => $Scope->{TargetType},
            Target     => $Scope->{Target},
        );

        my $Rows = $Self->_RowsGet( Prefix => $Prefix );
        return if !defined $Rows;

        ROW:
        for my $Row ( @{$Rows} ) {

            my $Marker = $Self->_MarkerDecode( $Row->{Value} );
            return   if !$Marker;
            next ROW if $Marker->{Expires} <= time;
            next ROW if $Scope->{TargetType} eq 'sub' && $Session->{StartedAt} > $Marker->{IssuedAt};

            if ( defined $Marker->{SubjectHash} ) {
                next ROW if !$Self->_StringValid( $Session->{Subject} );
                next ROW if sha256_hex( encode_utf8( $Session->{Subject} ) ) ne $Marker->{SubjectHash};
            }

            return 0;
        }
    }

    return 1;
}

sub _SessionMatches {
    my ( $Self, %Param ) = @_;

    my $SessionData = $Param{SessionData};
    my $Claims      = $Param{Claims};
    my $OIDCSession = $SessionData->{OIDCSession};

    return if ref $OIDCSession ne 'HASH';
    return if ( $SessionData->{UserType}      // '' ) ne 'User';
    return if ( $SessionData->{SessionSource} // '' ) ne 'AgentInterface';
    return if ( $OIDCSession->{Issuer}        // '' ) ne $Claims->{iss};
    return if ( $OIDCSession->{ClientID}      // '' ) ne $Param{ClientID};
    return if !$Self->_NumberValid( $OIDCSession->{IssuedAt} );
    return if !$Self->_NumberValid( $OIDCSession->{StartedAt} );

    if ( $Self->_StringValid( $Claims->{sid} ) ) {
        return if ( $OIDCSession->{SessionID} // '' ) ne $Claims->{sid};
        return if $Self->_StringValid( $Claims->{sub} ) && ( $OIDCSession->{Subject} // '' ) ne $Claims->{sub};
    }
    else {
        return if ( $OIDCSession->{Subject} // '' ) ne $Claims->{sub};
        my $Leeway = $Param{Leeway} // 0;
        return if $OIDCSession->{StartedAt} > $Claims->{iat} + $Leeway;
    }

    return 1;
}

sub _TombstoneKey {
    my ( $Self, %Param ) = @_;

    return $Self->_TombstonePrefix(%Param) . sha256_hex( encode_utf8( $Param{JTI} ) );
}

sub _TombstonePrefix {
    my ( $Self, %Param ) = @_;

    my $Scope = join "\0",
        'v1',
        $Param{Issuer},
        $Param{ClientID},
        $Param{TargetType},
        $Param{Target};
    my $ScopeHash = sha256_hex( encode_utf8($Scope) );

    return 'OIDCLogout::' . $ScopeHash . '::';
}

sub _TombstoneStore {
    my ( $Self, %Param ) = @_;

    my $Existing = $Self->_RowsGet( Key => $Param{Key} );
    return                                                                 if !defined $Existing;
    return $Self->_MarkerMatches( $Existing->[0]->{Value}, $Param{Value} ) if @{$Existing};

    my $JSONValue = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data     => $Param{Value},
        SortKeys => 1,
    );
    return if !defined $JSONValue;

    my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO system_data
                (data_key, data_value, create_time, create_by, change_time, change_by)
            VALUES (?, ?, current_timestamp, 1, current_timestamp, 1)
            ',
        Bind => [ \$Param{Key}, \$JSONValue ],
    );
    return 1 if $Success;

    # A racing duplicate is safe only when a fresh read confirms the same immutable marker.
    my $AfterInsert = $Self->_RowsGet( Key => $Param{Key} );
    return if !defined $AfterInsert || !@{$AfterInsert};

    return $Self->_MarkerMatches( $AfterInsert->[0]->{Value}, $Param{Value} );
}

sub _MarkerMatches {
    my ( $Self, $JSONValue, $Expected ) = @_;

    my $Marker = $Self->_MarkerDecode($JSONValue);
    return if !$Marker;
    return if $Marker->{IssuedAt} != $Expected->{IssuedAt};
    return if ( $Marker->{SubjectHash} // '' ) ne ( $Expected->{SubjectHash} // '' );

    return 1;
}

sub _MarkerDecode {
    my ( $Self, $JSONValue ) = @_;

    return if !defined $JSONValue;

    my $Marker = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $JSONValue,
    );
    return if ref $Marker ne 'HASH';
    return if !$Self->_NumberValid( $Marker->{IssuedAt} );
    return if !$Self->_NumberValid( $Marker->{Expires} );
    return if defined $Marker->{SubjectHash} && $Marker->{SubjectHash} !~ m{\A[a-f0-9]{64}\z};

    return $Marker;
}

sub _ExpiredTombstonesRemove {
    my $Self = shift;

    my $Rows = $Self->_RowsGet( Prefix => 'OIDCLogout::' );
    return if !defined $Rows;

    my $Now = time;
    ROW:
    for my $Row ( @{$Rows} ) {

        my $Marker = $Self->_MarkerDecode( $Row->{Value} );
        return   if !$Marker;
        next ROW if $Marker->{Expires} > $Now;

        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => 'DELETE FROM system_data WHERE data_key = ?',
            Bind => [ \$Row->{Key} ],
        );
    }

    return 1;
}

sub _RowsGet {
    my ( $Self, %Param ) = @_;

    # Revocation decisions must not use a potentially lagging database mirror.
    local $Kernel::System::DB::UseMirrorDB = 0;
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Success;
    if ( defined $Param{Key} ) {
        $Success = $DBObject->Prepare(
            SQL   => 'SELECT data_value FROM system_data WHERE data_key = ?',
            Bind  => [ \$Param{Key} ],
            Limit => 1,
        );
    }
    elsif ( defined $Param{Prefix} ) {
        my $Pattern = $Param{Prefix} . '%';
        $Success = $DBObject->Prepare(
            SQL  => 'SELECT data_key, data_value FROM system_data WHERE data_key LIKE ?',
            Bind => [ \$Pattern ],
        );
    }
    else {
        return;
    }
    return if !$Success;

    my @Rows;
    while ( my @Row = $DBObject->FetchrowArray() ) {

        if ( defined $Param{Key} ) {
            push @Rows,
                {
                    Key   => $Param{Key},
                    Value => $Row[0]
                };
        }
        else {
            push @Rows,
                {
                    Key   => $Row[0],
                    Value => $Row[1]
                };
        }
    }

    return if $DBObject->Error();

    return \@Rows;
}

sub _StringValid {
    my ( $Self, $Value ) = @_;

    return defined $Value && !ref $Value && length $Value;
}

sub _NumberValid {
    my ( $Self, $Value ) = @_;

    return 0 if !defined $Value || ref $Value || !looks_like_number($Value);
    return $Value =~ m{\A-?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?\z};
}

1;
