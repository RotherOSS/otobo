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

package Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;

# core modules
use Encode;
use MIME::Base64;
use List::Util qw(any);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::DateTime',
    'Kernel::System::MigrateFromOTRS::Base',
    'Kernel::System::Cache',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base - common backend functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=head2 new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base' => {
            BlobColumns => $BlobColumns,
            CheckEncodingColumns => $CheckEncodingColumns,
        },
    );
    my $CloneDBBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base');

=cut

sub new {
    my $Class = shift;

    # allocate new hash for object
    return bless {}, $Class;
}

# A single sanity check.
# Check whether the relevant tables exist in the source database.
sub SanityChecks {
    my $Self = shift;
    my %Param = @_;

    # check needed stuff
    if ( !$Param{OTRSDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBObject!",
        );

        return;
    }

    my $SourceDBObject = $Param{OTRSDBObject};

    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');
    my %TableIsSkipped = $MigrationBaseObject->DBSkipTables()->%*;

    # get OTOBO DB object
    my $TargetDBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get a list of tables on OTRS DB
    my @SourceTables = $Self->TablesList( DBObject => $SourceDBObject );

    # no need to migrate when the source has no tables
    return unless @SourceTables;

    SOURCE_TABLE:
    for my $SourceTable (@SourceTables) {

        if ( $TableIsSkipped{ lc $SourceTable } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Skipping table $SourceTable on SanityChecks.",
            );

            next SOURCE_TABLE;
        }

        # check how many rows exists on
        # OTRS DB for an specific table
        my $SourceRowCount = $Self->RowCount(
            DBObject => $SourceDBObject,
            Table    => $SourceTable,
        );

        # table should exists
        if ( !defined $SourceRowCount ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Required table '$SourceTable' does not seem to exist in the OTOBO database!",
            );

            return;
        }
    }

    # source database looks sane
    return 1;
}

#
# Get row count of a table.
#
sub RowCount {
    my $Self = shift;
    my %Param = @_;

    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

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

    # execute counting statement, only a single row is returned
    return unless $Param{DBObject}->Prepare(
        SQL => "SELECT COUNT(*) FROM $Param{Table}",
    );

    my ($NumRows) = $Param{DBObject}->FetchrowArray();

    # Log info to apache error log and OTOBO log (syslog or file)
    $MigrationBaseObject->MigrationLog(
        String   => "Count of entrys in Table $Param{Table}: $NumRows.",
        Priority => "debug",
    );

    return $NumRows;
}

# Transfer the actual table data
sub DataTransfer {
    my $Self = shift; # the source db backend
    my %Param = @_;

    # check needed stuff
    for my $Needed (qw(OTRSDBObject OTOBODBObject OTOBODBBackend DBInfo)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # extract params
    my $SourceDBObject  = $Param{OTRSDBObject};
    my $TargetDBObject  = $Param{OTOBODBObject};
    my $TargetDBBackend = $Param{OTOBODBBackend};

    # get config object
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    my %TableIsSkipped = $MigrationBaseObject->DBSkipTables()->%*;
    my %RenameTables   = $MigrationBaseObject->DBRenameTables()->%*;

    # get a list of tables on OTRS DB
    my @SourceTables = $Self->TablesList( DBObject => $SourceDBObject );

    # get a list of tables on OTOBO DB
    my %TargetTableExists = map { $_ => 1 } $TargetDBBackend->TablesList( DBObject => $TargetDBObject );

    # We need to disable FOREIGN_KEY_CHECKS, cause we copy the data.
    # TODO: Test on postgresql and oracle!
    if ( $TargetDBObject->{'DB::Type'} eq 'mysql' ) {
        $TargetDBObject->Do( SQL => 'SET FOREIGN_KEY_CHECKS = 0' );
    }
    elsif ( $TargetDBObject->{'DB::Type'} eq 'postgresql' ) {
        $TargetDBObject->Do( SQL => 'set session_replication_role to replica;' );
    }

    # TODO: put this into Driver/mysql.pm
    my ( $SourceSchema, $TargetSchema );
    {
        if ( $SourceDBObject->{'DB::Type'} eq 'mysql' ) {
            $SourceSchema = ( $SourceDBObject->SelectAll(
                SQL   => 'SELECT DATABASE()',
                Limit => 1,
            ) // [ [ 'unknown source database' ] ] )->[0]->[0];
        }

        if ( $TargetDBObject->{'DB::Type'} eq 'mysql' ) {
            $TargetSchema = ( $TargetDBObject->SelectAll(
                SQL   => 'SELECT DATABASE()',
                Limit => 1,
            ) // [ [ 'unknown target database' ] ] )->[0]->[0];
        }
    }

    # this is experimental
    my $BeDestructive = 1;

    # Delete OTOBO content from table.
    # In the case of destructive copy keep track of the foreign keys.
    # TODO: also keep track of the indexes, they are copied, but indexes might have been added
use Data::Dumper;
    my ( %SourceDropForeignKeys, %TargetAddForeignKeys );
    SOURCE_TABLE:
    for my $SourceTable (@SourceTables) {

        if ( $TableIsSkipped{ lc $SourceTable } ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Skipping table $SourceTable, cause it is defined in SkipTables config...",
                Priority => "notice",
            );

            next SOURCE_TABLE;
        }

        # check if OTOBO Table exists, if yes delete table content
        # Keep Track of foreign keys
        my $TargetTable = $RenameTables{$SourceTable} // $SourceTable;
        if ( $TargetTableExists{$TargetTable} ) {
            if ( $BeDestructive ) {

                # drop foreign keys in the source
                $SourceDropForeignKeys{$SourceTable} //= [];
                my $SourceForeignKeySth = $TargetDBObject->{dbh}->foreign_key_info(
                    undef, undef, undef,
                    undef, $SourceSchema, $SourceTable
                );

                ROW:
                while ( my @Row = $SourceForeignKeySth->fetchrow_array() ) {
                    my ($FKName) = $Row[11];

                    warn Dumper( [ 'AAA', $TargetSchema, $TargetTable, [ $FKName ], \@Row ] );

                    # skip cruft
                    next ROW unless $FKName;

                    # The OTOBO convention is that foreign key names start with 'FK_'.
                    # The check is relevant because primary keys have 'PRIMARY' as $FKName
                    next ROW unless $FKName =~ m/^FK_/;

                    push $SourceDropForeignKeys{$SourceTable}->@*,
                        "DROP FOREIGN KEY $FKName";
                }

                # readd foreign keys in the target
                $TargetAddForeignKeys{$TargetTable} //= [];
                my $TargetForeignKeySth = $TargetDBObject->{dbh}->foreign_key_info(
                    undef, undef, undef,
                    undef, $TargetSchema, $TargetTable
                );

                ROW:
                while ( my @Row = $TargetForeignKeySth->fetchrow_array() ) {
                    my ($PKTableName, $PKColumnName, $FKColumnName, $FKName) = @Row[2, 3, 7, 11];

                    warn Dumper( [ 'BBB', $TargetSchema, $TargetTable, [ $PKTableName, $PKColumnName, $FKColumnName, $FKName ], @Row ] );

                    # skip cruft
                    next ROW unless $PKTableName;
                    next ROW unless $PKColumnName;
                    next ROW unless $FKColumnName;
                    next ROW unless $FKName;

                    # The OTOBO convention is that foreign key names start with 'FK_'.
                    # The check is relevant because primary keys have 'PRIMARY' as $FKName
                    next ROW unless $FKName =~ m/^FK_/;

                    push $TargetAddForeignKeys{$TargetTable}->@*,
                        "ADD CONSTRAINT FOREIGN KEY $FKName ($FKColumnName) REFERENCES $PKTableName($PKColumnName)";
                }

                $TargetDBObject->Do( SQL => "DROP TABLE $TargetTable" );
            }
            else {
                $TargetDBObject->Do( SQL => "TRUNCATE TABLE $TargetTable" );
            }
        }
        else {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Table $SourceTable exist not in OTOBO.",
                Priority => "notice",
            );
            $TableIsSkipped{$SourceTable} = 1;
        }
    }

    SOURCE_TABLE:
    for my $SourceTable (@SourceTables) {

        if ( $TableIsSkipped{ lc $SourceTable } ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Skipping table $SourceTable...",
                Priority => "notice",
            );

            next SOURCE_TABLE;
        }

        # Set cache object with taskinfo and starttime to show current state in frontend
        my $Epoch          = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task      => 'OTOBODatabaseMigrate',
                SubTask   => "Copy table: $SourceTable",
                StartTime => $Epoch,
            },
        );

        # Log info to apache error log and OTOBO log (syslog or file)
        $MigrationBaseObject->MigrationLog(
            String   => "Copy table: $SourceTable\n",
            Priority => "notice",
        );

        my $TargetTable = $RenameTables{$SourceTable} // $SourceTable;

        # Get the list of columns of this table to be able to
        #   generate correct INSERT statements.
        my @SourceColumns;
        {
            my $SourceColumnRef = $Self->ColumnsList(
                Table    => $SourceTable,
                DBName   => $Param{DBInfo}->{DBName},
                DBObject => $SourceDBObject,
            ) || return;

            @SourceColumns = $SourceColumnRef->@*;
        }

        # We need to check if column is varchar and > 191 character on OTRS side.
        my %ShortenColumn;
        for my $SourceColumn (@SourceColumns) {

            # Get Source (OTRS) column infos
            my $SourceColumnInfos = $Self->GetColumnInfos(
                Table    => $SourceTable,
                DBName   => $Param{DBInfo}->{DBName},
                DBObject => $SourceDBObject,
                Column   => $SourceColumn,
            );

            # Get target (OTOBO) column infos
            my $TargetColumnInfos = $TargetDBBackend->GetColumnInfos(
                Table    => $TargetTable,
                DBName   => $ConfigObject->Get('Database'),
                DBObject => $TargetDBObject,
                Column   => $SourceColumn,
            );

            # First we need to check if the Table / Column exists in the OTOBO DB. If not,
            # we don´t need to cut the content I think.
            if ( IsHashRefWithData($TargetColumnInfos) && $TargetDBObject->{'DB::Type'} eq 'mysql' ) {
                if ( $SourceColumnInfos->{DATA_TYPE} eq 'varchar' && $SourceColumnInfos->{LENGTH} > $TargetColumnInfos->{LENGTH} ) {
                    $ShortenColumn{$SourceColumn} = $SourceColumn;

                    # Log info to apache error log and OTOBO log (syslog or file)
                    $MigrationBaseObject->MigrationLog(
                        String   => "Column $SourceColumn needs to cut to new length of 190 chars, cause utf8mb4.",
                        Priority => "notice",
                    );
                }
            }
        }

        # Check if there are extra columns in the source DB.
        # If we have extra columns in OTRS table we need to add the column to OTOBO
        if ( ! $BeDestructive ) {
            my $TargetColumnRef = $TargetDBBackend->ColumnsList(
                Table    => $TargetTable,
                DBName   => $ConfigObject->Get('Database'),
                DBObject => $TargetDBObject,
            ) || return;

            my %ColumnExistsInTarget = map { $_ => 1 } $TargetColumnRef->@*;
            my @ExtraSourceColumns = grep { ! $ColumnExistsInTarget{$_} } @SourceColumns;

            for my $SourceColumn (@ExtraSourceColumns) {

                my $SourceColumnInfos = $Self->GetColumnInfos(
                    Table    => $SourceTable,
                    DBName   => $Param{DBInfo}->{DBName},
                    DBObject => $SourceDBObject,
                    Column   => $SourceColumn,
                );

                my $TranslatedSourceColumnInfos = $TargetDBBackend->TranslateColumnInfos(
                    ColumnInfos => $SourceColumnInfos,
                    DBType      => $SourceDBObject->{'DB::Type'},
                );

                $TargetDBBackend->AlterTableAddColumn(
                    Table       => $TargetTable,
                    DBObject    => $TargetDBObject,
                    Column      => $SourceColumn,
                    ColumnInfos => $TranslatedSourceColumnInfos,
                );
            }
        }

        # We can speed up the data copying
        # when Source and Target database are on the same server.
        # The most important criterium is whether the database host are equal.
        # This is done by retrieving 'mysql_hostinfo'
        # Beware that there can be false negatives, e.g. when alternative IPs or hostnames are used.
        # Or when only one of the connections is via socket.
        # Be careful and also make some sanity additional sanity checks.
        # For now only 'mysql' is supported.
        # TODO: move parts of the check into the scpecic driver object
        my $DoBatchInsert = eval {

            # source and target must be the same database type
            return 0 unless $TargetDBObject->{'DB::Type'} eq $SourceDBObject->{'DB::Type'};

            my $DBType = $TargetDBObject->{'DB::Type'};

            # check whether it's the same host
            if ( $DBType eq 'mysql' ) {
                return 0 unless $TargetDBObject->{dbh}->{mysql_hostinfo} eq $SourceDBObject->{dbh}->{mysql_hostinfo};
            }
            else {
                return 0;
            }

            # sanity checking
            return 0 if %ShortenColumn;
            return 0 unless $TargetDBObject->GetDatabaseFunction('DirectBlob') == $SourceDBObject->GetDatabaseFunction('DirectBlob');

            # Let's try batch inserts
            return 1;
        };

        if ( $DoBatchInsert ) {

            my $ColumnsString   = join ', ', @SourceColumns;
            my $CopyTableSQL;
            if ( $BeDestructive ) {
                # OTOBO uses no triggers, otherwise they would need to be adapted
                # This requires the privs DROP and ALTER on the source database
                $CopyTableSQL  = <<"END_SQL";
ALTER TABLE $SourceSchema.$SourceTable
  RENAME $TargetSchema.$TargetTable
END_SQL
                # TODO: update the foreign key references
            }
            else {
                $CopyTableSQL  = <<"END_SQL";
INSERT INTO $TargetSchema.$TargetTable ($ColumnsString)
  SELECT $ColumnsString FROM $SourceSchema.$SourceTable;
END_SQL
            }

            my $Success = $TargetDBObject->Do(
                SQL  => $CopyTableSQL
            );

            if ( !$Success ) {

                # Log info to apache error log and OTOBO log (syslog or file)
                $MigrationBaseObject->MigrationLog(
                    String   => "Could not batch insert data: Table: $SourceTable",
                    Priority => "notice",
                );

                return;
            }
        }
        else {

            # assemble the relevant SQL
            my ( $SelectSQL, $InsertSQL );
            {
                my $ColumnsString = join ', ', @SourceColumns;
                my $BindString    = join ', ', map {'?'} @SourceColumns;
                $InsertSQL     = "INSERT INTO $TargetTable ($ColumnsString) VALUES ($BindString)";
                $SelectSQL     = "SELECT $ColumnsString FROM $SourceTable",
            }

            # Now fetch all the data and insert it to the target DB.
            $SourceDBObject->Prepare(
                SQL   => $SelectSQL,
                Limit => 4_000_000_00,
            ) || return;

            # get encode object
            my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

            TABLEROW:
            while ( my @Row = $SourceDBObject->FetchrowArray() ) {

                COLUMNVALUES:
                for my $ColumnCounter ( 1 .. $#SourceColumns ) {
                    my $Column = $SourceColumns[$ColumnCounter];

                    # Check if we need to cut the string, cause utf8mb4 only needs 191 chars.
                    if ( $ShortenColumn{$Column} ) {
                        if ( $Row[$ColumnCounter] && length( $Row[$ColumnCounter] ) > 190 ) {
                            $Row[$ColumnCounter] = substr( $Row[$ColumnCounter], 0, 190 );
                        }
                    }
                }

                # If the two databases have different blob handling (base64), convert
                #   columns that need it.
                if (
                    $TargetDBObject->GetDatabaseFunction('DirectBlob')
                    != $SourceDBObject->GetDatabaseFunction('DirectBlob')
                    )
                {
                    COLUMN:
                    for my $ColumnCounter ( 1 .. $#SourceColumns ) {
                        my $Column = $SourceColumns[$ColumnCounter];

                        next COLUMN unless $Self->{BlobColumns}->{ lc "$SourceTable.$Column" };

                        if ( !$SourceDBObject->GetDatabaseFunction('DirectBlob') ) {
                            $Row[$ColumnCounter] = decode_base64( $Row[$ColumnCounter] );
                        }

                        if ( !$TargetDBObject->GetDatabaseFunction('DirectBlob') ) {
                            $EncodeObject->EncodeOutput( \$Row[$ColumnCounter] );
                            $Row[$ColumnCounter] = encode_base64( $Row[$ColumnCounter] );
                        }
                    }
                }

                my @Bind = map { \$_ } @Row;
                my $Success = $TargetDBObject->Do(
                    SQL  => $InsertSQL,
                    Bind => \@Bind,
                );

                if ( !$Success ) {

                    # Log info to apache error log and OTOBO log (syslog or file)
                    $MigrationBaseObject->MigrationLog(
                        String   => "Could not insert data: Table: $SourceTable - id:$Row[0].",
                        Priority => "notice",
                    );

                    return;
                }
            }
        }

        # If needed, reset the auto-incremental field.
        # This is irrespective whether the table was polulated with a batch insert
        # or via many small inserts.
        if (
            $TargetDBObject->can('ResetAutoIncrementField')
            && any { lc($_) eq 'id' } @SourceColumns
        )
        {

            $TargetDBObject->ResetAutoIncrementField(
                DBObject => $TargetDBObject,
                Table    => $TargetTable,
            );
        }
    }

    if ( $TargetDBObject->{'DB::Type'} eq 'postgresql' ) {
        $TargetDBObject->Do( SQL => 'set session_replication_role to default;' );
    }

    return 1;
}

1;
