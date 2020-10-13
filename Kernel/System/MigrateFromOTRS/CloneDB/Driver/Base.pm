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
use File::Basename qw(fileparse);

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

    TABLE:
    for my $Table (@SourceTables) {

        if ( $TableIsSkipped{ lc $Table } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Skipping table $Table on SanityChecks.",
            );

            next TABLE;
        }

        # check how many rows exists on
        # OTRS DB for an specific table
        my $OTRSRowCount = $Self->RowCount(
            DBObject => $SourceDBObject,
            Table    => $Table,
        );

        # table should exists
        if ( !defined $OTRSRowCount ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Required table '$Table' does not seem to exist in the OTOBO database!",
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
    my $Self = shift;
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

    my $SourceDBObject = $Param{OTRSDBObject};

    # get config object
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    my %TableIsSkipped = $MigrationBaseObject->DBSkipTables()->%*;
    my %RenameTables   = $MigrationBaseObject->DBRenameTables()->%*;

    # get OTOBO db object
    my $TargetDBObject = $Param{OTOBODBObject};

    # get a list of tables on OTRS DB
    my @SourceTables = $Self->TablesList( DBObject => $SourceDBObject );

    # get a list of tables on OTOBO DB
    my @OTOBOTables = $Param{OTOBODBBackend}->TablesList( DBObject => $TargetDBObject );

    # We need to disable FOREIGN_KEY_CHECKS, cause we copy the data.
    # TODO: Test on postgresql and oracle!
    if ( $TargetDBObject->{'DB::Type'} eq 'mysql' ) {
        $TargetDBObject->Do( SQL => 'SET FOREIGN_KEY_CHECKS = 0' );
    }
    elsif ( $TargetDBObject->{'DB::Type'} eq 'postgresql' ) {
        $TargetDBObject->Do( SQL => 'set session_replication_role to replica;' );
    }

    # Delete OTOBO content from table
    OTRSTABLES:
    for my $OTRSTable (@SourceTables) {

        if ( $TableIsSkipped{ lc $OTRSTable } ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Skipping table $OTRSTable, cause it is defined in SkipTables config...",
                Priority => "notice",
            );

            next OTRSTABLES;
        }

        # check if OTOBO Table exists, if yes delete table content
        my $TableExists   = 0;
        my $OTOBOTableNew = '';

        OTOBOTABLES:
        for my $OTOBOTable (@OTOBOTables) {

            # check if it´s a RenameTable.
            if ( $RenameTables{$OTRSTable} ) {
                $OTOBOTableNew = $RenameTables{$OTRSTable};
            }

            if ( $OTRSTable eq $OTOBOTable ) {

                $TargetDBObject->Do( SQL => "TRUNCATE TABLE $OTOBOTable" );
                $TableExists = 1;

                last OTOBOTABLES;
            }
            elsif ( $OTOBOTableNew eq $OTOBOTable ) {

                $TargetDBObject->Do( SQL => "TRUNCATE TABLE $OTOBOTableNew" );
                $TableExists = 1;

                last OTOBOTABLES;
            }
        }

        if ( $TableExists == 0 ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Table $OTRSTable exist not in OTOBO.",
                Priority => "notice",
            );
            $TableIsSkipped{$OTRSTable} = 1;
        }
    }

    TABLE:
    for my $Table (@SourceTables) {

        if ( $TableIsSkipped{ lc $Table } ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Skipping table $Table...",
                Priority => "notice",
            );

            next TABLE;
        }

        # Set cache object with taskinfo and starttime to show current state in frontend
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        my $Epoch          = $DateTimeObject->ToEpoch();

        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task      => 'OTOBODatabaseMigrate',
                SubTask   => "Copy table: $Table",
                StartTime => $Epoch,
            },
        );

        # Log info to apache error log and OTOBO log (syslog or file)
        $MigrationBaseObject->MigrationLog(
            String   => "Copy table: $Table\n",
            Priority => "notice",
        );

        # Get the list of columns of this table to be able to
        #   generate correct INSERT statements.
        my @OTRSColumns;
        {
            my $OTRSColumnRef = $Self->ColumnsList(
                Table    => $Table,
                DBName   => $Param{DBInfo}->{DBName},
                DBObject => $SourceDBObject,
            ) || return;

            @OTRSColumns = $OTRSColumnRef->@*;
        }

        # We need to check if column is varchar and > 191 character on OTRS side.
        my %ShortenColumn;
        for my $Column (@OTRSColumns) {

            # Get OTRS Column infos
            my $ColumnInfos = $Self->GetColumnInfos(
                Table    => $Table,
                DBName   => $Param{DBInfo}->{DBName},
                DBObject => $SourceDBObject,
                Column   => $Column,
            );

            # Get OTOBO Column infos
            my $ColumnOTOBOInfos = $Param{OTOBODBBackend}->GetColumnInfos(
                Table    => $RenameTables{$Table} // $Table,
                DBName   => $ConfigObject->Get('Database'),
                DBObject => $TargetDBObject,
                Column   => $Column,
            );

            # First we need to check if the Table / Column exists in the OTOBO DB. If not,
            # we don´t need to cut the content I think.
            if ( IsHashRefWithData($ColumnOTOBOInfos) && $TargetDBObject->{'DB::Type'} eq 'mysql' ) {
                if ( $ColumnInfos->{DATA_TYPE} eq 'varchar' && $ColumnInfos->{LENGTH} > $ColumnOTOBOInfos->{LENGTH} ) {
                    $ShortenColumn{$Column} = $Column;

                    # Log info to apache error log and OTOBO log (syslog or file)
                    $MigrationBaseObject->MigrationLog(
                        String   => "Column $Column needs to cut to new length of 190 chars, cause utf8mb4.",
                        Priority => "notice",
                    );
                }
            }
        }

        # Check if there are extra columns in the source DB
        # If we have extra columns in OTRS table we need to add the column to OTOBO
        {
            my $OTOBOColumnRef = $Param{OTOBODBBackend}->ColumnsList(
                Table    => $RenameTables{$Table} // $Table,
                DBName   => $ConfigObject->Get('Database'),
                DBObject => $TargetDBObject,
            ) || return;

            my %ColumnExistsInOTOBO = map { $_ => 1 } $OTOBOColumnRef->@*;
            my @ExtraOTRSColumns = grep { ! $ColumnExistsInOTOBO{$_} } @OTRSColumns;

            for my $Column (@ExtraOTRSColumns) {

                my $ColumnInfos = $Self->GetColumnInfos(
                    Table    => $Table,
                    DBName   => $Param{DBInfo}->{DBName},
                    DBObject => $SourceDBObject,
                    Column   => $Column,
                );

                my $TranslatedColumnInfos = $Param{OTOBODBBackend}->TranslateColumnInfos(
                    ColumnInfos => $ColumnInfos,
                    DBType      => $SourceDBObject->{'DB::Type'},
                );

                $Param{OTOBODBBackend}->AlterTableAddColumn(
                    Table       => $RenameTables{$Table} // $Table,
                    DBObject    => $TargetDBObject,
                    Column      => $Column,
                    ColumnInfos => $TranslatedColumnInfos,
                );
            }
        }

        # We can speed up the data copying
        # when Source and Target database are on the same server.
        # Be careful and also make some sanity checks.
        my $DoBatchInsert = eval {
            return 0 if %ShortenColumn;
            return 0 if $TargetDBObject->{'DB::Type'} ne $SourceDBObject->{'DB::Type'};
            return 0 if $TargetDBObject->GetDatabaseFunction('DirectBlob') != $SourceDBObject->GetDatabaseFunction('DirectBlob');
            return 0; # because batch is not yet implemented
        };

        # assemble the relevant SQL
        # TODO: make direct insert in mysql
        my ( $SelectSQL, $InsertSQL );
        {
            my $ColumnsString = join ', ', @OTRSColumns;
            my $BindString    = join ', ', map {'?'} @OTRSColumns;
            my $OTOBOTable    = $RenameTables{$Table} // $Table;
            $InsertSQL     = "INSERT INTO $OTOBOTable ($ColumnsString) VALUES ($BindString)";
            $SelectSQL     = "SELECT $ColumnsString FROM $Table",
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
            for my $ColumnCounter ( 1 .. $#OTRSColumns ) {
                my $Column = $OTRSColumns[$ColumnCounter];

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
                for my $ColumnCounter ( 1 .. $#OTRSColumns ) {
                    my $Column = $OTRSColumns[$ColumnCounter];

                    next COLUMN unless $Self->{BlobColumns}->{ lc "$Table.$Column" };

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
                    String   => "Could not insert data: Table: $Table - id:$Row[0].",
                    Priority => "notice",
                );

                return;
            }
        }

        # If needed, reset the auto-incremental field.
        # This is irrespective whether the table was polulated with a batch insert
        # or via many small inserts.
        if (
            $TargetDBObject->can('ResetAutoIncrementField')
            && grep { lc($_) eq 'id' } @OTRSColumns
            )
        {

            $TargetDBObject->ResetAutoIncrementField(
                DBObject => $TargetDBObject,
                Table    => $RenameTables{$Table} // $Table,
            );
        }
    }

    if ( $TargetDBObject->{'DB::Type'} eq 'postgresql' ) {
        $TargetDBObject->Do( SQL => 'set session_replication_role to default;' );
    }

    return 1;
}

1;
