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

The constructor of the base object is usually called when the derived objects are created.
But there can be direct instances.

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

    # some table should not be migrated, thus the sanity check is not needed
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

        # table should exist
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
        String   => "Count of entries in Table $Param{Table}: $NumRows.",
        Priority => "debug",
    );

    return $NumRows;
}

=head2 DataTransfer()

Transfer data from the source database tables to the target database tables. The data is transferred row by row.

There are three possible return values.

=over 4

=item empty list

There was an unspecified error. Bailing out of the migration.

=item the number 1

The data transfer was successful.

=item a hashref with two keys.

C<Successful> indicates success or failure.
C<Messages> a list of messages, usually indicating the errors

=back

Altogether, there are five loops over the tables of the source database.

The first loop determines which source tables need to be copied. Source tables that are marked as to be skipped
and source tables that have no counterpart in the target database are not copied.

The second loop examines the to be copied tables of the source and target database and compiles basically
a list of the required actions.

The third loop checks for problematic NULL values in the source tables.
The data transfer is stopped when there are problematic cases.

The fourth loop purges the target tables.

The fifth loop actually copies the data from source table to the target table.

Progress messages are provided by the last two loops. These messages are shown in the web interface.

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

    # get objects needed for checking the lockfile
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    # Use a locking table for avoiding concurrent migrations.
    # Open for writing as the file usually does not exist yet.
    # This approach assumes that the the webserver processes are running on a single machine.
    my $LockFile = join '/', $ConfigObject->Get('Home'), 'var/tmp/migrate_from_otrs.lock';

    ## no critic qw(OTOBO::ProhibitLowPrecedenceOps OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)

    open my $LockFh, '>', $LockFile or do {
        $MigrationBaseObject->MigrationLog(
            String   => "Could not open lockfile $LockFile; $!",
            Priority => 'error',
        );

        return;
    };

    # check whether another process has an exclusive lock on the lock file
    # the lock will be released when $LockFh autocloses
    flock( $LockFh, LOCK_EX ) or do {
        $MigrationBaseObject->MigrationLog(
            String   => "Another migration process is active and has locked $LockFile: $!",
            Priority => "error",
        );

        return;
    };

    # looks good, there is no other concurrent process that wants to migrate tables
    # the lock will be released at the end of this sub

    # extract params needed in the first and the following loops
    my $SourceDBObject = $Param{OTRSDBObject};
    my $TargetDBObject = $Param{OTOBODBObject};

    # get setup
    my %RenameTables = $MigrationBaseObject->DBRenameTables->%*;

    # first loop: compile list of tables that should be copied
    my @SourceTablesToBeCopied;
    {
        # get a complete list of tables on OTRS DB
        my @AllSourceTables = $SourceDBObject->ListTables();

        # filter the tables that should be skipped
        my %TableIsSkipped = map { $_ => 1 } $MigrationBaseObject->DBSkipTables;

        # filter the tables that have no counterpart in the target database
        my %TargetTableExists = map { $_ => 1 } $TargetDBObject->ListTables();

        SOURCE_TABLE:
        for my $SourceTable (@AllSourceTables) {

            # skip the tables that should not be copied
            if ( $TableIsSkipped{$SourceTable} ) {

                # Log info to apache error log and OTOBO log (syslog or file)
                $MigrationBaseObject->MigrationLog(
                    String   => "Skipping table $SourceTable, because it is defined in SkipTables config...",
                    Priority => 'notice',
                );

                next SOURCE_TABLE;
            }

            # e.g. groups renamed to groups_table
            my $TargetTable = $RenameTables{$SourceTable} // $SourceTable;

            # Do not migrate tables that are not needed on the target
            if ( !$TargetTableExists{$TargetTable} ) {

                # Log info to apache error log and OTOBO log (syslog or file)
                $MigrationBaseObject->MigrationLog(
                    String   => "Table $SourceTable does not exist in OTOBO.",
                    Priority => 'notice',
                );

                next SOURCE_TABLE;
            }

            # take the not skipped tables
            push @SourceTablesToBeCopied, $SourceTable;
        }
    }

    # Keep track of table attributes which must be base64 encoded or decoded.
    # This conversion of BLOBs is only relevant when DirectBlob settings are different.
    my %BlobConversionNeeded;
    my %IsDirectBlobColumn;
    if ( $TargetDBObject->GetDatabaseFunction('DirectBlob') != $SourceDBObject->GetDatabaseFunction('DirectBlob') ) {
        for my $Setup ( $MigrationBaseObject->DBDirectBlobColumns ) {
            $IsDirectBlobColumn{ lc $Setup->{Table} } //= {};
            $IsDirectBlobColumn{ lc $Setup->{Table} }->{ lc $Setup->{Column} } = 1;
        }
    }

    # extract params needed in the second and the following loops
    my $SourceDBName    = $Param{DBInfo}->{DBName};
    my $TargetDBBackend = $Param{OTOBODBBackend};

    # Handle the OTOBO table columns which must be shortened.
    # Usually because of InnodB max key size in MySQL 5.6 or earlier.
    # Use a driver dependent SUBSTRING function because Oracle is not really conforming to the ANSI SQL standard.
    my $SubstringFunction         = $SourceDBObject->GetDatabaseFunction('Substring');
    my $MaxLengthShortenedColumns = 190;                                                 # int( 767 / 4 ) - 1

    my %SourceColumnsString;

    # Determine the columns where the source might contain NULLs that are not allowed in the target.
    my @CheckNullConstraints;

    # Second loop: collect information about the OTRS source tables.
    SOURCE_TABLE:
    for my $SourceTable (@SourceTablesToBeCopied) {

        my $TargetTable = $RenameTables{$SourceTable} // $SourceTable;

        # In the target database schema some varchar columns have been shortened
        # to int( 767 / 4 ) = 191 characters
        # The reason was that in MySQL 5.6 or earlier the max key size was limited per default
        # to 767 characters. This max key size is relevant for the columns that make up the PRIMARY key
        # and for all columns with an UNIQUE index. With switching to the utf8mb4 character set.
        # the unique varchar columns may at most be int( 767 / 4) = 191 characters long.
        #
        # For some columns we need to shorten the values. In order to be on the safe side
        # we cut to $MaxLengthShortenedColumns=190 characters.
        #
        # See also: https://dev.mysql.com/doc/refman/5.7/en/innodb-limits.html

        # We need the list of columns for checking about shortening
        my $SourceColumnsRef = $Self->ColumnsList(
            Table    => $SourceTable,
            DBName   => $SourceDBName,
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
        # NULL Checks might be required when the target is stricter than the source.
        {
            my @MaybeShortenedColumns;
            my $DoShorten;    # flag used for assembly of $SourceColumnsString
            my @NullAllowedColumns;
            SOURCE_COLUMN:
            for my $SourceColumn ( $SourceColumnsRef->@* ) {

                $DoShorten = 0;

                # Get Source (OTRS) column infos
                my $SourceColumnInfos = $Self->GetColumnInfos(
                    Table    => $SourceTable,
                    DBName   => $SourceDBName,
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

                # Whether the target column has stricter NULL checking.
                # Hoping that the usage of 'YES and 'NO' is standardized accross database systems.
                # NULLs are OK when the target column has a default value.
                if (
                    ( $TargetColumnInfos->{IS_NULLABLE} eq 'NO' && !defined $TargetColumnInfos->{COLUMN_DEFAULT} )
                    && $SourceColumnInfos->{IS_NULLABLE} eq 'YES'
                    )
                {
                    push @NullAllowedColumns, $SourceColumn;
                }

                next SOURCE_COLUMN unless IsHashRefWithData($TargetColumnInfos);

                # Check whether to varchar column has to be shortened.
                # Be careful to shorten only in the specific cases that related to switching to utf8mb4.
                # The magic number 255 is the max number where MySQL still uses VARCHAR(n).
                # Do not worry so much about migrations to MySQL, as MySQL shortens automatically.
                # TODO: catch the cases where MySQL has TEXT fields but PostgreSQL is still at VARCHAR(n).
                next SOURCE_COLUMN unless defined $SourceColumnInfos->{LENGTH};
                next SOURCE_COLUMN unless $SourceColumnInfos->{LENGTH} <= 255;
                next SOURCE_COLUMN unless defined $TargetColumnInfos->{LENGTH};
                next SOURCE_COLUMN unless $TargetColumnInfos->{LENGTH} <= 255;
                next SOURCE_COLUMN unless $SourceColumnInfos->{LENGTH} > $TargetColumnInfos->{LENGTH};

                # We need to shorten that column in that table to 191 chars.
                $DoShorten = 1;

                # Log info to apache error log and OTOBO log (syslog or file)
                $MigrationBaseObject->MigrationLog(
                    String   => "Column $SourceTable.$SourceColumn is shortened to $MaxLengthShortenedColumns chars",
                    Priority => 'notice',
                );
            }
            continue {
                # The source column might have to be shortened.
                # In that case add the SUBSTRING() function.
                push @MaybeShortenedColumns,
                    $DoShorten
                    ?
                    sprintf( $SubstringFunction, $SourceColumn, 1, $MaxLengthShortenedColumns )
                    :
                    $SourceColumn;

            }

            # we might have to check for NULL values in the source table
            if (@NullAllowedColumns) {
                push @CheckNullConstraints,
                    {
                        Table              => $SourceTable,
                        NullAllowedColumns => \@NullAllowedColumns,
                    };
            }

            # This string might contain some MySQL SUBSTRING() calls
            $SourceColumnsString{$SourceTable} = join ', ', @MaybeShortenedColumns;
        }

        # get a list of blob columns from OTRS DB,
        # only relevant when the DirectBlob settings are different and when there are any
        # DirectBlob fields for this table
        $BlobConversionNeeded{$SourceTable} = {};
        if ( $IsDirectBlobColumn{$SourceTable} ) {

            # get LONGBLOB fields of the source table as only those are candidates for base63 conversion o
            my $BlobColumnsList = $Self->BlobColumnsList(
                Table    => $SourceTable,
                DBName   => $SourceDBName,
                DBObject => $SourceDBObject,
            ) || {};

            # check whether the LONGBLOB fields are relevant for base64 conversion
            COLUMN:
            for my $Column ( sort keys $BlobColumnsList->%* ) {
                next COLUMN unless $IsDirectBlobColumn{$SourceTable}->{$Column};

                $BlobConversionNeeded{$SourceTable}->{$Column} = 1;
            }
        }

    }

    # needed for the progress messages emitted by the last two loops
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # third loop: check for NULL value violations,
    # that is cases where a source column has NULL values while the target column is set to NOT NULL
    {
        my $TotalNumConstraints = scalar @CheckNullConstraints;
        my $CountConstraint     = 0;
        my @ViolationMessages;
        for my $Constraint (@CheckNullConstraints) {

            my $SourceTable = $Constraint->{Table};

            # Set cache object with taskinfo and starttime to show current state in frontend
            $CountConstraint++;
            my $ProgressMessage = "Check for NULL values in table ($CountConstraint/$TotalNumConstraints): $SourceTable";
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

            my @Violations;
            SOURCE_COLUMN:
            for my $SourceColumn ( $Constraint->{NullAllowedColumns}->@* ) {

                $SourceDBObject->Prepare(
                    SQL => "SELECT COUNT(*) FROM $SourceTable WHERE $SourceColumn IS NULL"
                );
                my ($NumNulls) = $SourceDBObject->FetchrowArray();

                push @Violations, [ $SourceColumn, $NumNulls ] if $NumNulls;
            }

            # report the found violations
            for my $Violation (@Violations) {
                my ( $Column, $NumNulls ) = $Violation->@*;
                my $PluralS = $NumNulls == 1 ? '' : 's';
                my $Message = "$NumNulls NULL value$PluralS found in the column '$Column' of the source table '$SourceTable'.";
                push @ViolationMessages, $Message;

                $CacheObject->Set(
                    Type  => 'OTRSMigration',
                    Key   => 'MigrationState',
                    Value => {
                        Task      => 'OTOBODatabaseMigrate',
                        SubTask   => $Message,
                        StartTime => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
                    },
                );

                # Log info to apache error log and OTOBO log (syslog or file)
                $MigrationBaseObject->MigrationLog(
                    String   => $Message,
                    Priority => 'error',
                );
            }
        }

        # return an error when violations were detected
        if (@ViolationMessages) {
            return
                {
                    Successful => 0,
                    Messages   => \@ViolationMessages,
                };
        }
    }

    # Fourth loop.
    # Truncate the target table in all cases.
    SOURCE_TABLE:
    for my $SourceTable (@SourceTablesToBeCopied) {
        my $TargetTable = $RenameTables{$SourceTable} // $SourceTable;
        my $PurgeSQL    = sprintf $TargetDBObject->GetDatabaseFunction('PurgeTable'), $TargetTable;

        my $Success = $TargetDBObject->Do( SQL => $PurgeSQL );

        if ( !$Success ) {
            my $Message = "Could not truncate target table '$TargetTable'";
            $MigrationBaseObject->MigrationLog(
                String   => "Could not truncate target table '$TargetTable'",
                Priority => 'error',
            );

            return
                {
                    Successful => 0,
                    Messages   => [$Message],
                };
        }
    }

    # fifth loop: do the actual data transfer for the relevant tables
    my $CountTable     = 0;
    my $TotalNumTables = scalar @SourceTablesToBeCopied;
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
                DBName   => $SourceDBName,
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
                    DBName   => $SourceDBName,
                    DBObject => $SourceDBObject,
                    Column   => $SourceColumn,
                );

                # Translate the DATA_TYPE
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

                        # e.g. PostgreSQL to MySQL
                        if ( !$SourceDBObject->GetDatabaseFunction('DirectBlob') ) {
                            $Row[$ColumnCounter] = decode_base64( $Row[$ColumnCounter] );
                        }

                        # e.g. MySQL to PostgreSQL
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
                    my $Message = "Could not insert data: Table: $SourceTable - id:$Row[0].";
                    $MigrationBaseObject->MigrationLog(
                        String   => $Message,
                        Priority => "notice",
                    );

                    return
                        {
                            Successful => 0,
                            Messages   => [$Message],
                        };
                }
            }
        }

        # Reset the autoincrement fields when needed. Under PostgreSQL the appropriate term would be serial field.
        if (
            $TargetDBBackend->can('ResetAutoIncrementField')
            && any { lc($_) eq 'id' } @SourceColumns
            )
        {
            $TargetDBBackend->ResetAutoIncrementField(
                DBObject => $TargetDBObject,
                Table    => $TargetTable,
            );
        }
    }

    # TODO: will this be executed in the case of an exception ?
    if ( $TargetDBObject->{'DB::Type'} eq 'postgresql' ) {
        $TargetDBObject->Do( SQL => 'set session_replication_role to default;' );
    }

    return 1;
}

1;
