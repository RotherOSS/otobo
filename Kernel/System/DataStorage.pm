# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::DataStorage;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::JSON',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DataStorage - storage lib

=head1 DESCRIPTION

All functions to access data_storage. Functionality is similar to Kernel::System::Cache but persistent. WARNING: This module and the database table are subject to change! We will decide on how to store various data in the future and might just extend VirtualFS or find a completely separate solution. Be prepared to change any package based on this functionality!

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $DataStorageObject = $Kernel::OM->Get('Kernel::System::DataStorage');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Get()

fetch values from the storage.

    my $Value = $DataStorageObject->Get(
        Type => 'ObjectName',       # only [a-zA-Z0-9] chars usable
        Key  => 'SomeKey',
    );

or (not cached)

    my %Hash = $CacheObject->Get(
        Type => 'ObjectName',       # only [a-zA-Z0-9] chars usable
    );

=cut

sub Get {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Type} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type!",
        );
        return;
    }

    if ( $Param{Key} ) {

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        my $CachedData  = $CacheObject->Get(
            Type => 'DataStorage_' . $Param{Type},
            Key  => $Param{Key},
        );

        return $CachedData if $CachedData;

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $SQL = "SELECT ds_value FROM data_storage WHERE ds_type = ? AND ds_key = ?";

        return if !$DBObject->Prepare(
            SQL   => $SQL,
            Bind  => [ \$Param{Type}, \$Param{Key} ],
            Limit => 1,
        );

        my $Value;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Value = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $Row[0],
            );
        }

        return if !$Value;

        $CacheObject->Set(
            Type  => 'DataStorage_' . $Param{Type},
            Key   => $Param{Key},
            Value => $Value,
        );

        return $Value;
    }

    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    my $SQL = "SELECT ds_key, ds_value FROM data_storage WHERE ds_type = ?";

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => [ \$Param{Type} ],
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Data{ $Row[0] } = $JSONObject->Decode(
            Data => $Row[1],
        );
    }

    return %Data;
}

=head2 Set()

set a value in the storage.

    my $Success = $DataStorageObject->Set(
        Type   => 'ObjectName',       # only [a-zA-Z0-9] chars usable
        Key    => 'SomeKey',
        Value  => $Value,
        UserID => $UserID,            # optional
    );

=cut

sub Set {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key Value)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Enforce cache type restriction to make sure it works properly on all file systems.
    if ( $Param{Type} !~ m{ \A [a-zA-Z0-9]+ \z}smx ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "Cache Type '$Param{Type}' contains invalid characters, use [a-zA-Z0-9] only!",
        );
        return;
    }

    $Self->Delete(%Param);

    $Param{UserID} //= 1;

    my $JSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Value},
    );

    return if !$JSON;

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => "INSERT INTO data_storage (ds_type, ds_key, ds_value, create_time, create_by) VALUES (?, ?, ?, current_timestamp, ?)",
        Bind => [ \$Param{Type}, \$Param{Key}, \$JSON, \$Param{UserID} ],
    );

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        %Param,
        Type => 'DataStorage_' . $Param{Type},
    );

    return 1;
}

=head2 Delete()

delete values from the storage.

    my $Success = $DataStorageObject->Delete(
        Type   => 'ObjectName',       # only [a-zA-Z0-9] chars usable
        Key    => 'SomeKey',          # optional
    );

=cut

sub Delete {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Type} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type!",
        );
        return;
    }

    my $SQL  = 'DELETE FROM data_storage WHERE ds_type = ?';
    my @Bind = ( \$Param{Type} );

    if ( $Param{Key} ) {
        $SQL .= ' AND ds_key = ?';
        push @Bind, \$Param{Key};

        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            %Param,
            Type => 'DataStorage_' . $Param{Type},
        );
    }

    else {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'DataStorage_' . $Param{Type},
        );
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    return 1;
}

1;
