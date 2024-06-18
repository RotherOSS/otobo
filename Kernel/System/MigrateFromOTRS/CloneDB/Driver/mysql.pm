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

package Kernel::System::MigrateFromOTRS::CloneDB::Driver::mysql;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::DB;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::CloneDB::Driver::mysql

=head1 SYNOPSIS

    # CloneDBs mysql Driver delegate

=head1 DESCRIPTION

This module implements the public interface of L<Kernel::System::MigrateFromOTRS::CloneDB::Backend>.
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

    # include DSN for target DB
    $Param{OTRSDatabaseDSN} =
        "DBI:mysql:database=$Param{DBName};host=$Param{DBHost};";

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

# List all columns of a table in the order of their position.
sub ColumnsList {
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
            SELECT column_name
            FROM information_schema.columns
            WHERE table_name = ? AND table_schema = ?
            ORDER BY ordinal_position ASC",
        Bind => [
            \$Param{Table}, \$Param{DBName},
        ],
    ) || return [];

    my @Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        push @Result, $Row[0];
    }

    return \@Result;
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

    $Param{DBObject}->Prepare(
        SQL => <<'END_SQL',
SELECT COLUMN_NAME, DATA_TYPE
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = ?
    AND TABLE_NAME = ?
    AND DATA_TYPE = 'longblob';
END_SQL
        Bind => [ \$Param{DBName}, \$Param{Table}, ],
    ) || return {};

    my %Result;
    while ( my ( $Column, $Type ) = $Param{DBObject}->FetchrowArray() ) {
        $Result{$Column} = $Type;
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

    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, COLUMN_DEFAULT, IS_NULLABLE
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND COLUMN_NAME = ?",

        Bind => [
            \$Param{DBName}, \$Param{Table}, \$Param{Column},
        ],
    ) || return {};

    # collect the column info, actually we expect a single row
    my %Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $Result{COLUMN}         = $Row[0];
        $Result{DATA_TYPE}      = $Row[1];
        $Result{LENGTH}         = $Row[2];
        $Result{COLUMN_DEFAULT} = $Row[3];
        $Result{IS_NULLABLE}    = $Row[4];
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
    return \%ColumnInfos if $Param{DBType} =~ m/mysql/;

    if ( $Param{DBType} =~ m/postgresql/ ) {
        my %Result;
        $Result{VARCHAR}             = 'VARCHAR';
        $Result{'CHARACTER VARYING'} = 'VARCHAR';
        $Result{TEXT}                = 'TEXT';

        $Result{DATE}      = 'DATE';
        $Result{TIME}      = 'TIME';
        $Result{TIMESTAMP} = 'TIMESTAMP';

        $Result{SMALLINT}           = 'SMALLINT';
        $Result{INTEGER}            = 'INT';
        $Result{BIGINT}             = 'BIGINT';
        $Result{NUMERIC}            = 'DECIMAL';
        $Result{DECIMAL}            = 'DECIMAL';
        $Result{REAL}               = 'FLOAT';
        $Result{'DOUBLE PRECISION'} = 'DOUBLE';

        $ColumnInfos{DATA_TYPE} = $Result{ uc( $Param{ColumnInfos}->{DATA_TYPE} ) };
    }
    elsif ( $Param{DBType} =~ m/oracle/ ) {
        my %Result;
        $Result{VARCHAR2} = 'VARCHAR';
        $Result{TEXT}     = 'TEXT';
        $Result{CLOB}     = 'MEDIUMTEXT';

        $Result{DATE}     = 'DATE';
        $Result{DATETIME} = 'DATETIME';

        $Result{SHORTINTEGER} = 'SMALLINT';
        $Result{INTEGER}      = 'INT';
        $Result{LONGINTEGER}  = 'BIGINT';
        $Result{SHORTDECIMAL} = 'DECIMAL';
        $Result{NUMBER}       = 'DECIMAL';

        $ColumnInfos{DATA_TYPE} = $Result{ uc( $Param{ColumnInfos}->{DATA_TYPE} ) };
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

    if ( $ColumnInfos{IS_NULLABLE} =~ m/no/ ) {
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
