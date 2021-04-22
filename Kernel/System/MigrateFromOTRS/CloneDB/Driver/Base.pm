# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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
use List::Util qw(any none);
use Fcntl qw(:flock);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::MigrateFromOTRS::Base',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base - common functions for CloneDB drivers

=head1 SYNOPSIS

    # TODO

=head1 DESCRIPTION

A base module for drivers.

=head1 PUBLIC INTERFACE

=head2 new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::MigrateFromOTRS::CloneDB::Driver::Base' => {
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

=head2 SanityChecks()

check several sanity conditions of the source database.

=over 4

=item check whether the passed database object is supported

=item check whether the required L<DBD::*> module can be loaded

=item check whether a connection is possible

=item check whether there are tables

=item check whether row count of the tables can be determined, empty tables are OK

=back

    my $SanityCheck = $CloneDBBackendObject->SanityChecks(
        OTRSDBObject => $SourceDBObject,
        Message      => $Message,
    );

The returned value is a hash ref with the fields I<Message>, I<Comment>, and I<Successful>.

    my $SanityCheck = {
        Message    => $Self->{LanguageObject}->Translate("Try database connect and sanity checks."),
        Comment    => $Self->{LanguageObject}->Translate("Connect to OTRS database or sanity checks failed."),
        Successful => 0
    };

=cut

sub SanityChecks {
    my ( $Self, %Param ) = @_;

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    $Param{Message} ||= $Self->{LanguageObject}->Translate('Sanity checks for database.');

    # check needed stuff
    if ( !$Param{OTRSDBObject} ) {
        my $Comment = 'Need OTRSDBObject!';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Message} $Comment",
        );

        return {
            Message    => $Param{Message},
            Comment    => $Comment,
            Successful => 0,
        };
    }

    my $SourceDBObject = $Param{OTRSDBObject};

    # check whether the source database type is supported and whether the DBD module can be loaded
    my %DBDModule = (
        mysql      => 'DBD::mysql',
        postgresql => 'DBD::Pg',
        oracle     => 'DBD::Oracle',
    );

    my $DBType = $SourceDBObject->GetDatabaseFunction('Type') // '';
    my $Module = $DBDModule{$DBType};
    if ( !$Module ) {
        my $Comment = "The source database type $DBType is not supported";

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Message} $Comment",
        );

        return {
            Message    => $Param{Message},
            Comment    => $Comment,
            Successful => 0,
        };
    }

    my $MainObject        = $Kernel::OM->Get('Kernel::System::Main');
    my $ModuleIsInstalled = $MainObject->Require($Module);
    if ( !$ModuleIsInstalled ) {
        my $Comment = "The module $Module is not installed.";

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Message} $Comment",
        );

        return {
            Message    => $Param{Message},
            Comment    => $Comment,
            Successful => 0,
        };
    }

    # check connection
    my $DbHandle = $SourceDBObject->Connect();
    if ( !$DbHandle ) {
        my $Comment = 'Could not connect to the source database!';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Message} $Comment",
        );

        return {
            Message    => $Param{Message},
            Comment    => $Comment,
            Successful => 0,
        };
    }

    # get a list of tables on OTRS DB
    my @SourceTables = $SourceDBObject->ListTables();

    # no need to migrate when the source has no tables
    if ( !@SourceTables ) {
        my $Comment = 'No tables available in the  source database!';
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Message} $Comment",
        );

        return {
            Message    => $Param{Message},
            Comment    => $Comment,
            Successful => 0,
        };
    }

    # some table should not be migrated
    my %TableIsSkipped =
        map { $_ => 1 }
        $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base')->DBSkipTables;

    SOURCE_TABLE:
    for my $SourceTable (@SourceTables) {

        if ( $TableIsSkipped{$SourceTable} ) {
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
            my $Comment = "The table '$SourceTable' does not seem to exist in the OTRS database!";
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{Message} $Comment",
            );

            return {
                Message    => $Param{Message},
                Comment    => $Comment,
                Successful => 0,
            };
        }
    }

    # source database looks sane
    return {
        Message    => $Param{Message},
        Comment    => '',
        Successful => 1,
    };
}

=head2 RowCount()

Get the number of rows in a table.

=cut

sub RowCount {
    my ( $Self, %Param ) = @_;

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

    # This is a workaround for a very special case.
    # There can be OTRS 6 running on MySQL 8, where groups is a reserverd word.
    # See https://github.com/RotherOSS/otobo/issues/639
    my $Table = ( $Param{DBObject}->{'DB::Type'} eq 'mysql' && $Param{Table} eq 'groups' )
        ?
        q{`groups`}
        :
        $Param{Table};

    # execute counting statement, only a single row is returned
    my $RowCountSQL = sprintf qq{SELECT COUNT(*) FROM $Table};

    return unless $Param{DBObject}->Prepare(
        SQL => $RowCountSQL,
    );

    my ($NumRows) = $Param{DBObject}->FetchrowArray();

    # Log info to apache error log and OTOBO log (syslog or file)
    $MigrationBaseObject->MigrationLog(
        String   => "Count of entrys in Table $Param{Table}: $NumRows.",
        Priority => "debug",
    );

    return $NumRows;
}

=head2 DataTransfer()

Transfer the actual table data

=cut

sub DataTransfer {
    my ( $Self, %Param ) = @_;    # $Self is  the source db backend

    # check needed parameters
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

    # get objects
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    # get setup
    my %TableIsSkipped =
        map { $_ => 1 }
        $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base')->DBSkipTables;
    my %RenameTables = $MigrationBaseObject->DBRenameTables->%*;

    # Conversion of BLOBs is only relevant when DirectBlob settings are different.
    my %BlobConversionNeeded;

    # Because of InnodB max key size in MySQL 5.6 or earlier
    my $MaxLenghtShortenedColumns = 190;    # int( 767 / 4 ) - 1

    # Use a locking table for avoiding concurrent migrations.
    # Open for writing as the file usually does not exist yet.
    # This approach assumes that the the webserver processes are running on a single machine.
    my $LockFile = join '/', $ConfigObject->Get('Home'), 'var/tmp/migrate_from_otrs.lock';

    ## no critic qw(OTOBO::ProhibitLowPrecedenceOps OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)

    open my $LockFh, '>', $LockFile or do {
        $MigrationBaseObject->MigrationLog(
            String   => "Could not open lockfile $LockFile; $!",
            Priority => "error",
        );

        return;
    };

    # check whether another process has an exclusive lock on the lock file
    flock( $LockFh, LOCK_EX ) or do {
        $MigrationBaseObject->MigrationLog(
            String   => "Another migration process is active and has locked $LockFile: $!",
            Priority => "error",
        );

        return;
    };

    # looks good, there is no other concurrent process that wants to migrate tables
    # the lock will be released at the end of this sub

    # get a list of tables on OTRS DB
    my @SourceTables = $SourceDBObject->ListTables();

    # get a list of tables on OTOBO DB
    my %TargetTableExists = map { $_ => 1 } $TargetDBObject->ListTables();

    # Collect information about the OTRS tables.
    # Decide whether batch insert, or destructive table renaming, is possible for a table.
    # Trunkate the target OTOBO tables.
    # In the case of destructive table renaming, keep track of the foreign keys.
    my ( @SourceTablesToBeCopied, %SourceColumnsString );
    SOURCE_TABLE:
    for my $SourceTable (@SourceTables) {

        if ( $TableIsSkipped{$SourceTable} ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Skipping table $SourceTable, cause it is defined in SkipTables config...",
                Priority => "notice",
            );

            next SOURCE_TABLE;
        }

        my $TargetTable = $RenameTables{$SourceTable} // $SourceTable;

        # Do not migrate tables that are not needed on the target
        if ( !$TargetTableExists{$TargetTable} ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Table $SourceTable does not exist in OTOBO.",
                Priority => "notice",
            );

            next SOURCE_TABLE;
        }

        push @SourceTablesToBeCopied, $SourceTable;

        # The OTOBO table exists. So, either truncate or drop the table in OTOBO.
        # For destructive table copying drop the table but keep Track of foreign keys first.

        # In the target database schema some varchar columns have been shortened
        # to int( 767 / 4 ) = 191 characters
        # The reason was that in MySQL 5.6 or earlier the max key size was limited per default
        # to 767 characters. This max key size is relevant for the columns that make up the PRIMARY key
        # and for all columns with an UNIQUE index. With switching to the utf8mb4 character set.
        # the unique varchar columns may at most be int( 767 / 4) = 191 characters long.
        #
        # For the shortend columns we need to cut the values. In order to be on the safe
        # side we cut to $MaxLenghtShortenedColumns=190 characters.
        #
        # When we need to shorten then we can't do a batch insert.
        #
        # See also: https://dev.mysql.com/doc/refman/5.7/en/innodb-limits.html

        # We need the list of columns for checking about shortening
        my $SourceColumnsRef = $Self->ColumnsList(
            Table    => $SourceTable,
            DBName   => $Param{DBInfo}->{DBName},
            DBObject => $SourceDBObject,
        );

        if ( !$SourceColumnsRef || !$SourceColumnsRef->@* ) {
            $MigrationBaseObject->MigrationLog(
                String   => "Could not get columns of source table '$SourceTable'",
                Priority => "error",
            );

            return;    # bail out
        }

        # Columns might be shortened for any database type.
        {
            my @MaybeShortenedColumns;
            my $DoShorten;    # flag used for assembly of $SourceColumnsString
            SOURCE_COLUMN:
            for my $SourceColumn ( $SourceColumnsRef->@* ) {

                $DoShorten = 0;

                # Get Source (OTRS) column infos
                my $SourceColumnInfos = $Self->GetColumnInfos(
                    Table    => $SourceTable,
                    DBName   => $Param{DBInfo}->{DBName},
                    DBObject => $SourceDBObject,
                    Column   => $SourceColumn,
                );

                # shortening only for varchar (and the corresponding data types varchar2 and 'character varying')
                next SOURCE_COLUMN unless IsHashRefWithData($SourceColumnInfos);
                if ( none { $_ eq lc( $SourceColumnInfos->{DATA_TYPE} ) } ( 'varchar', 'character varying', 'varchar2' ) ) {
                    next SOURCE_COLUMN;
                }

                # Get target (OTOBO) column infos
                my $TargetColumnInfos = $TargetDBBackend->GetColumnInfos(
                    Table    => $TargetTable,
                    DBName   => $ConfigObject->Get('Database'),
                    DBObject => $TargetDBObject,
                    Column   => $SourceColumn,
                );

                next SOURCE_COLUMN unless IsHashRefWithData($TargetColumnInfos);

                # check whether to varchar column has been shorted
                next SOURCE_COLUMN unless $SourceColumnInfos->{LENGTH} > $TargetColumnInfos->{LENGTH};

                # We need to shorten that column in that table to 191 chars.
                $DoShorten = 1;

                # Log info to apache error log and OTOBO log (syslog or file)
                $MigrationBaseObject->MigrationLog(
                    String   => "Column $SourceColumn needs to cut to new length of $MaxLenghtShortenedColumns chars, cause utf8mb4.",
                    Priority => "notice",
                );
            }
            continue {
                # The source column might have to be shortened.
                # In that case add the SUBSTRING() function.
                push @MaybeShortenedColumns,
                    $DoShorten
                    ?
                    "SUBSTRING( $SourceColumn, 1, $MaxLenghtShortenedColumns )"
                    :
                    $SourceColumn;
            }

            # This string might contain some MySQL SUBSTRING() calls
            $SourceColumnsString{$SourceTable} = join ', ', @MaybeShortenedColumns;
        }

        # get a list of blob columns from OTRS DB
        $BlobConversionNeeded{$SourceTable} = {};
        if (
            $TargetDBObject->GetDatabaseFunction('DirectBlob')
            != $SourceDBObject->GetDatabaseFunction('DirectBlob')
            )
        {
            $BlobConversionNeeded{$SourceTable} = $Self->BlobColumnsList(
                Table    => $SourceTable,
                DBName   => $Param{DBInfo}->{DBName},
                DBObject => $Param{OTRSDBObject},
            ) || {};
        }

        # Truncate the target table in all cases.
        # The truncated table provides info about columns and foreign keys.
        # The SQL is driver dependent because PostgreSQL 11 does not honor
        # the deactivation of foreign key check with 'TRUNCATE TABLE'.
        {
            my $PurgeSQL = sprintf $TargetDBObject->GetDatabaseFunction('PurgeTable'), $TargetTable;
            my $Success  = $TargetDBObject->Do( SQL => $PurgeSQL );

            if ( !$Success ) {
                $MigrationBaseObject->MigrationLog(
                    String   => "Could not truncate target table '$TargetTable'",
                    Priority => 'error',
                );

                return;    # bail out
            }
        }
    }

    # do the actual data transfer for the relevant tables
    my ( $TotalNumTables, $CountTable ) = ( scalar @SourceTablesToBeCopied, 0 );
    SOURCE_TABLE:
    for my $SourceTable (@SourceTablesToBeCopied) {

        # Set cache object with taskinfo and starttime to show current state in frontend
        $CountTable++;
        my $ProgressMessage = "Copy table ($CountTable/$TotalNumTables): $SourceTable";
        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task      => 'OTOBODatabaseMigrate',
                SubTask   => $ProgressMessage,
                StartTime => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
            },
        );

        # Log info to apache error log and OTOBO log (syslog or file)
        $MigrationBaseObject->MigrationLog(
            String   => $ProgressMessage,
            Priority => 'notice',
        );

        # The target table may be renamed.
        my $TargetTable = $RenameTables{$SourceTable} // $SourceTable;

        # Get the list of columns of this table to be able to
        # inspect them and to generate SQL.
        my @SourceColumns;
        {
            my $SourceColumnRef = $Self->ColumnsList(
                Table    => $SourceTable,
                DBName   => $Param{DBInfo}->{DBName},
                DBObject => $SourceDBObject,
            ) || return;

            @SourceColumns = $SourceColumnRef->@*;
        }

        # List of columns for generating INSERT statements.
        # The $TargetColumnsString is simply the list of the column names.
        # Source and target columns can be different when there is column shortening.
        # In this case some source columns are wrapped in SUBSTRING calls.
        my $TargetColumnsString = join ', ', @SourceColumns;

        # If we have extra columns in OTRS table we need to add the column to OTOBO.
        {
            my $TargetColumnRef = $TargetDBBackend->ColumnsList(
                Table    => $TargetTable,
                DBName   => $ConfigObject->Get('Database'),
                DBObject => $TargetDBObject,
            ) || return;

            my %AlreadyExists = map { $_ => 1 } $TargetColumnRef->@*;

            for my $SourceColumn ( grep { !$AlreadyExists{$_} } @SourceColumns ) {

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

        {
            # assemble the relevant SQL
            my ( $SelectSQL, $InsertSQL );
            {
                my $BindString = join ', ', map {'?'} @SourceColumns;
                $InsertSQL = "INSERT INTO $TargetTable ($TargetColumnsString) VALUES ($BindString)";

                # This is a workaround for a very special case.
                # There can be OTRS 6 running on MySQL 8, where groups is a reserved word.
                # See https://github.com/RotherOSS/otobo/issues/639
                my $Table = ( $Param{OTRSDBObject}->{'DB::Type'} eq 'mysql' && $SourceTable eq 'groups' )
                    ?
                    q{`groups`}
                    :
                    $SourceTable;

                $SelectSQL = "SELECT $SourceColumnsString{$SourceTable} FROM $Table";
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

                # No need to shorten any columns, as that was already in the SELECT

                # If the two databases have different blob handling (base64),
                # convert columns that need conversion.
                if ( $BlobConversionNeeded{$SourceTable}->%* ) {
                    COLUMN:
                    for my $ColumnCounter ( 1 .. $#SourceColumns ) {
                        my $Column = $SourceColumns[$ColumnCounter];

                        next COLUMN unless $BlobConversionNeeded{$SourceTable}->{$Column};

                        if ( !$SourceDBObject->GetDatabaseFunction('DirectBlob') ) {
                            $Row[$ColumnCounter] = decode_base64( $Row[$ColumnCounter] );
                        }

                        if ( !$TargetDBObject->GetDatabaseFunction('DirectBlob') ) {
                            $EncodeObject->EncodeOutput( \$Row[$ColumnCounter] );
                            $Row[$ColumnCounter] = encode_base64( $Row[$ColumnCounter] );
                        }
                    }
                }

                my $Success = $TargetDBObject->Do(
                    SQL  => $InsertSQL,
                    Bind => [ \(@Row) ],    # reference to an array of references
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
