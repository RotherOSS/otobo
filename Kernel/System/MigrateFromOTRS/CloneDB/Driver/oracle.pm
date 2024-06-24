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

package Kernel::System::MigrateFromOTRS::CloneDB::Driver::oracle;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::DB ();

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::CloneDB::Driver::oracle

=head1 SYNOPSIS

    # CloneDBs oracle Driver delegate

=head1 DESCRIPTION

This module implements the public interface of L<Kernel::System::MigrateFromOTRS::CloneDB::Backend>.
Please look there for a detailed reference of the functions.

=head1 PUBLIC INTERFACE

=cut

# create external db connection.
# For oracle the connection is based on the DSN.
sub CreateOTRSDBConnection {
    my ( $Self, %Param ) = @_;

    # check OTRSDBSettings
    # in contrast to postgresql.pm and mysql.pm, DBDSN is used instead of DBHost and DBName
    for my $Needed (qw(DBDSN DBUser DBPassword DBType)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed for external DB settings!",
            );

            return;
        }
    }

    # for oracle the DSN must be passed in

    # create target DB object
    my $OTRSDBObject = Kernel::System::DB->new(
        DatabaseDSN             => $Param{DBDSN},
        DatabaseUser            => $Param{DBUser},
        DatabasePw              => $Param{DBPassword},
        Type                    => $Param{DBType},
        DisconnectOnDestruction => 1,
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

# List all columns of a table in the order of their position.
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

    # Internally OTOBO is using lower case table names.
    # But Oracle has upper case names.
    my $UcTable = uc $Param{Table};
    my $Rows    = $Param{DBObject}->SelectAll(
        SQL => <<'END_SQL',
SELECT column_name
  FROM user_tab_columns
  WHERE table_name = ?
END_SQL
        Bind => [ \$UcTable ],
    ) || return [];

    # only the first element of each row is needed
    return [ map { lc $_->[0] } $Rows->@* ];
}

# Reset the 'id' auto-increment field to the last one in the table.
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

    # the nextval from the sequence must be beyond the current max id
    # so $NextID would be better names as $MinNextID
    $Param{DBObject}->Prepare(
        SQL => "SELECT max(id)+1 FROM $Param{Table}"
    ) || return;

    my ($NextID) = $Param{DBObject}->FetchrowArray();

    # assume that sequences do not have to be quoted
    my $SequenceName = 'SE_' . uc $Param{Table};

    # we assume the sequence have a minimum value (0)
    # we will to increase it till the last entry on
    # if field we have

    # verify that the sequence exists
    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COUNT(*)
            FROM user_sequences
            WHERE sequence_name = ?",
        Limit => 1,
        Bind  => [
            \$SequenceName,
        ],
    ) || return;

    my $SequenceCount;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $SequenceCount = $Row[0];
    }

    if ($SequenceCount) {

        # advance the sequence by the lowest number that should be the next value
        # it does not matter when there are gaps
        my $SQL = "ALTER SEQUENCE $SequenceName INCREMENT BY $NextID";
        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || return;

        # actually advance the sequence
        $SQL = "SELECT $SequenceName.nextval FROM dual";
        $Param{DBObject}->Prepare(
            SQL => $SQL,
        ) || return;

        my $ResultNextVal;
        while ( my @Row = $Param{DBObject}->FetchrowArray() ) {

            # do nothing with the result
            $ResultNextVal = $Row[0];
        }

        # reset sequence to increment by 1 to 1
        $SQL = "ALTER SEQUENCE $SequenceName INCREMENT BY 1";

        $Param{DBObject}->Do(
            SQL => $SQL,
        ) || return;
    }

    return 1;
}

# Get the binary columns of table and return a lookup hash with the column name as key.
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

    # Internally OTOBO is using lower case table names.
    # But Oracle has upper case names.
    my $UcTable = uc $Param{Table};
    $Param{DBObject}->Prepare(
        SQL => <<'END_SQL',
SELECT COLUMN_NAME, DATA_TYPE
  FROM user_tab_columns
  WHERE TABLE_NAME = ?
    AND DATA_TYPE = 'CLOB'
END_SQL
        Bind => [ \$UcTable ],
    ) || return {};

    my %Result;
    while ( my ( $Column, $Type ) = $Param{DBObject}->FetchrowArray() ) {
        $Result{ lc $Column } = $Type;
    }

    return \%Result;
}

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

    # Internally OTOBO is using lower case table names.
    # But Oracle has upper case names.
    my $UcTable  = uc $Param{Table};
    my $UcColumn = uc $Param{Column};
    $Param{DBObject}->Prepare(
        SQL => <<'END_SQL',
SELECT column_name, data_type, char_length, nullable
  FROM user_tab_columns
  WHERE table_name = ?
    AND column_name = ?
END_SQL

        Bind => [ \$UcTable, \$UcColumn ],
    ) || return {};

    # collect the column info, actually we expect a single row
    my %Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $Result{COLUMN}      = $Row[0];
        $Result{DATA_TYPE}   = $Row[1];
        $Result{LENGTH}      = $Row[2];
        $Result{IS_NULLABLE} = ( $Row[3] eq 'N' ? 'NO' : 'YES' );
    }

    return \%Result;
}

# Translate column infos
# return a copy of the passed in ColumnInfo with a translated DATA_TYPE
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

    my %ColumnInfos = $Param{ColumnInfos}->%*;    # the copy will be returned, possibly modified

    # no translation is necessary for the same DBType
    return \%ColumnInfos if $Param{DBType} =~ m/oracle/;

    if ( $Param{DBType} =~ m/mysql/ ) {
        my %Result;
        $Result{VARCHAR} = 'VARCHAR2';
        $Result{TEXT}    = 'TEXT';

        $Result{DATE}      = 'DATE';
        $Result{DATETIME}  = 'DATETIME';
        $Result{TIMESTAMP} = 'DATETIME';

        $Result{TINYINT}            = 'SHORTINTEGER';
        $Result{SMALLINT}           = 'SHORTINTEGER';
        $Result{MEDIUMINT}          = 'INTEGER';
        $Result{INTEGER}            = 'INTEGER';
        $Result{INT}                = 'INTEGER';
        $Result{BIGINT}             = 'LONGINTEGER';
        $Result{DECIMAL}            = 'NUMBER';
        $Result{FLOAT}              = 'FLOAT';
        $Result{REAL}               = 'FLOAT';
        $Result{DOUBLE}             = 'FLOAT';
        $Result{'DOUBLE PRECISION'} = 'FLOAT';

        $ColumnInfos{DATA_TYPE} = $Result{ $Param{ColumnInfos}->{DATA_TYPE} };
    }
    elsif ( $Param{DBType} =~ m/postgresql/ ) {
        my %Result;
        $Result{VARCHAR}             = 'VARCHAR2';
        $Result{'CHARACTER VARYING'} = 'VARCHAR2';
        $Result{TEXT}                = 'TEXT';

        $Result{DATE}      = 'DATE';
        $Result{TIMESTAMP} = 'DATETIME';

        $Result{SMALLINT}           = 'SHORTINTEGER';
        $Result{INTEGER}            = 'INTEGER';
        $Result{BIGINT}             = 'LONGINTEGER';
        $Result{NUMERIC}            = 'NUMBER';
        $Result{DECIMAL}            = 'NUMBER';
        $Result{REAL}               = 'FLOAT';
        $Result{'DOUBLE PRECISION'} = 'FLOAT';

        $ColumnInfos{DATA_TYPE} = $Result{ $Param{ColumnInfos}->{DATA_TYPE} };
    }

    return \%ColumnInfos;
}

# Alter table add column
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
    my $SQL         = qq{ALTER TABLE $Param{Table} ADD $Param{Column} $ColumnInfos{DATA_TYPE}};

    if ( $ColumnInfos{LENGTH} ) {
        $SQL .= " \($ColumnInfos{LENGTH}\)";
    }

    # IS_NULLABLE is either YES or NO
    if ( $ColumnInfos{IS_NULLABLE} =~ m/no/i ) {
        $SQL .= ' NOT NULL';
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
