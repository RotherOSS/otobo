# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::MigrateFromOTRS::CloneDB::Driver::oracle;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::CloneDB::Driver::oracle

=head1 SYNOPSIS

    # CloneDBs oracle Driver delegate

=head1 DESCRIPTION

This module implements the public interface of L<Kernel::System::MigrateFromOTRS::CloneDB::Driver>.
Please look there for a detailed reference of the functions.

=head1 PUBLIC INTERFACE

=cut

# create external db connection.
sub CreateOTRSDBConnection {
    my ( $Self, %Param ) = @_;

    # check OTRSDBSettings
    for my $Needed (
        qw(DBHost DBName DBUser DBPassword DBType)
        )
    {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed for external DB settings!",
            );

            return;
        }
    }

    # set default sid
    if ( !defined $Param{OTRSDatabaseSID} ) {
        $Param{OTRSDatabaseSID} = 'XE';
    }

    # set default sid
    if ( !defined $Param{OTRSDatabasePort} ) {
        $Param{OTRSDatabasePort} = '1521';
    }

    # include DSN for target DB
    $Param{OTRSDatabaseDSN} =
        "DBI:Oracle:sid=$Param{OTRSDatabaseSID};host=$Param{DBHost};port=$Param{OTRSDatabasePort};";

    # create target DB object
    my $OTRSDBObject = Kernel::System::DB->new(
        DatabaseDSN  => $Param{OTRSDatabaseDSN},
        DatabaseUser => $Param{DBUser},
        DatabasePw   => $Param{DBPassword},
        Type         => $Param{DBType},
    );

    if ( !$OTRSDBObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not connect to target DB!",
        );

        return;
    }

    return $OTRSDBObject;
}

#
# List all tables in the source database in alphabetical order.
#
sub TablesList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{DBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DBObject!",
        );

        return;
    }

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT table_name
            FROM user_tables
            ORDER BY table_name ASC",
    ) || return ();

    my @Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    return @Result;
}

#
# List all columns of a table in the order of their position.
#
sub ColumnsList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject Table)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL => "SELECT column_name
                FROM all_tab_columns
                WHERE table_name = ?",
        Bind => [
            \$Param{Table},
        ],
    ) || return [];

    my @Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    return \@Result;
}

#
# Reset the 'id' auto-increment field to the last one in the table.
#
sub ResetAutoIncrementField {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject Table)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT id
            FROM $Param{Table}
            ORDER BY id DESC",
        Limit => 1,
    ) || return;

    my $LastID;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $LastID = $Row[0];
    }

    # add one more to the last ID
    $LastID++;

    my $SEName = 'SE_' . uc $Param{Table};

    # we assume the sequence have a minimum value (0)
    # we will to increase it till the last entry on
    # if field we have

    # verify if the sequence exists
    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COUNT(*)
            FROM user_sequences
            WHERE sequence_name = ?",
        Limit => 1,
        Bind  => [
            \$SEName,
        ],
    ) || return;

    my $SequenceCount;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $SequenceCount = $Row[0];
    }

    if ($SequenceCount) {

        # set increment as last number on the id field, plus one
        my $SQL = "ALTER SEQUENCE $SEName INCREMENT BY $LastID";

        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || return;

        # get next value for sequence
        $SQL = "SELECT $SEName.nextval FROM dual";

        $Param{DBObject}->Prepare(
            SQL => $SQL,
        ) || return;

        my $ResultNextVal;
        while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
            $ResultNextVal = $Row[0];
        }

        # reset sequence to increment by 1 to 1
        $SQL = "ALTER SEQUENCE $SEName INCREMENT BY 1";

        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || return;
    }

    return 1;
}

#
#
# Get all binary columns and return table.column
#
sub BlobColumnsList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject DBName Table)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND DATA_TYPE = 'CLOB';",

        Bind => [
            \$Param{DBName}, \$Param{Table},
        ],
    ) || return {};

    my %Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        my $TCString = "$Param{Table}.$Row[0]";
        $Result{$TCString} = $Row[1];
    }
    return \%Result;
}

#
#
# Get column infos
# return DATA_TYPE

sub GetColumnInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject DBName Table Column)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
            FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_CATALOG = ?
            AND TABLE_NAME = ? AND COLUMN_NAME = ?",

        Bind => [
            \$Param{DBName}, \$Param{Table}, \$Param{Column},
        ],
    ) || return {};

    my %Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $Result{COLUMN}      = $Row[0];
        $Result{DATA_TYPE}   = $Row[1];
        $Result{LENGTH}      = $Row[2];
        $Result{IS_NULLABLE} = $Row[3];
    }
    return \%Result;
}

#
#
# Translate column infos
# return DATA_TYPE

sub TranslateColumnInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBType ColumnInfos)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %ColumnInfos = %{ $Param{ColumnInfos} };

    my %Result;

    if ( $Param{DBType} =~ /mysql/ ) {
        $Result{varchar}    = 'VARCHAR';
        $Result{int}        = 'INTEGER';
        $Result{datetime}   = 'DATETIME';
        $Result{smallint}   = 'SMALLINT';
        $Result{longblob}   = 'LONGBLOB';
        $Result{mediumtext} = 'MEDIUMTEXT';
    }
    elsif ( $Param{DBType} =~ /postgresql/ ) {
        $Result{VARCHAR}    = 'VARCHAR';
        $Result{INTEGER}    = 'INTEGER';
        $Result{DATETIME}   = 'timestamp';
        $Result{SMALLINT}   = 'SMALLINT';
        $Result{LONGBLOB}   = 'TEXT';
        $Result{mediumtext} = 'VARCHAR';
    }
    elsif ( $Param{DBType} =~ /oracle/ ) {
        $Result{VARCHAR}    = 'VARCHAR2';
        $Result{INTEGER}    = 'NUMBER';
        $Result{DATETIME}   = 'DATE';
        $Result{SMALLINT}   = 'NUMBER';
        $Result{LONGBLOB}   = 'CLOB';
        $Result{mediumtext} = 'CLOB';
    }
    $ColumnInfos{DATA_TYPE} = $Result{ $Param{ColumnInfos}->{DATA_TYPE} };

    return \%ColumnInfos;
}

#
#
# Alter table add column
#
sub AlterTableAddColumn {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(DBObject Table Column ColumnInfos)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %ColumnInfos = %{ $Param{ColumnInfos} };

    my $SQL = "ALTER TABLE $Param{Table} ADD $Param{Column} $ColumnInfos{DATA_TYPE}";

    if ( $ColumnInfos{LENGTH} ) {
        $SQL .= " \($ColumnInfos{LENGTH}\)";
    }

    if ( $ColumnInfos{IS_NULLABLE} =~ /no/ ) {
        $SQL .= " NOT NULL";
    }

    my $Success = $Param{DBObject}->Do(
        SQL => $SQL,
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not execute SQL statement: $SQL.",
        );
        return;
    }
    return 1;
}

1;
