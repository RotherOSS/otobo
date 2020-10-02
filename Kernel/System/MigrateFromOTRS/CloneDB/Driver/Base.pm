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

use Encode;
use MIME::Base64;
use Kernel::System::VariableCheck qw(:all);
use File::Basename qw(fileparse);

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

# Some up-front sanity checks
sub SanityChecks {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OTRSDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBObject!",
        );
        return;
    }

    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    my $SkipTablesRef = $MigrationBaseObject->DBSkipTables();
    my %SkipTables    = %{$SkipTablesRef};

    # get OTOBO DB object
    my $TargetDBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get a list of tables on OTRS DB
    my @Tables = $Self->TablesList(
        DBObject => $Param{OTRSDBObject},
    );

    # Need to check if table empty, then a connect is not possible
    if ( !IsArrayRefWithData( \@Tables ) ) {
        return;
    }

    TABLES:
    for my $Table (@Tables) {

        if ( defined $SkipTables{ lc $Table } && $SkipTables{ lc $Table } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Skipping table $Table on SanityChecks.",
            );
            next TABLES;
        }

        # check how many rows exists on
        # OTRS DB for an specific table
        my $OTRSRowCount = $Self->RowCount(
            DBObject => $Param{OTRSDBObject},
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
    return 1;
}

#
# Get row count of a table.
#
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

    # execute counting statement
    $Param{DBObject}->Prepare(
        SQL => "
            SELECT COUNT(*)
            FROM $Param{Table}",
    ) || return;

    my $Result;
    while ( my @Row = $Param{DBObject}->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # Log info to apache error log and OTOBO log (syslog or file)
    $MigrationBaseObject->MigrationLog(
        String   => "Count of entrys in Table $Param{Table}: $Result.",
        Priority => "debug",
    );

    return $Result;
}

# Transfer the actual table data
sub DataTransfer {
    my ( $Self, %Param ) = @_;

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

    # get config object
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $CacheObject         = $Kernel::OM->Get('Kernel::System::Cache');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    my $SkipTablesRef = $MigrationBaseObject->DBSkipTables();
    my %SkipTables    = %{$SkipTablesRef};

    my $RenameTablesRef = $MigrationBaseObject->DBRenameTables();
    my %RenameTables    = %{$RenameTablesRef};

    # get OTOBO db object
    my $TargetDBObject = $Param{OTOBODBObject};

    # get a list of tables on OTRS DB
    my @Tables = $Self->TablesList(
        DBObject => $Param{OTRSDBObject},
    );

    # get a list of tables on OTOBO DB
    my @OTOBOTables = $Param{OTOBODBBackend}->TablesList(
        DBObject => $TargetDBObject,
    );

    # We need to disable FOREIGN_KEY_CHECKS, cause we copy the data. TODO: Test on postgresql and oracle!
    if ( $TargetDBObject->{'DB::Type'} eq 'mysql' ) {
        $TargetDBObject->Do( SQL => 'SET FOREIGN_KEY_CHECKS = 0' );

    } elsif ( $TargetDBObject->{'DB::Type'} eq 'postgresql' ) {
            $TargetDBObject->Do( SQL => 'set session_replication_role to replica;' );

    }

    # Delete OTOBO content from table
    OTRSTABLES:
    for my $OTRSTable (@Tables) {

        if ( defined $SkipTables{ lc $OTRSTable } && $SkipTables{ lc $OTRSTable } ) {

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
            $SkipTables{$OTRSTable} = 1;
        }
    }

    TABLES:
    for my $Table (@Tables) {

        if ( defined $SkipTables{ lc $Table } && $SkipTables{ lc $Table } ) {

            # Log info to apache error log and OTOBO log (syslog or file)
            $MigrationBaseObject->MigrationLog(
                String   => "Skipping table $Table...",
                Priority => "notice",
            );
            next TABLES;
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

        # get a list of blob columns from OTRS DB
        my $BlobColumnsRef = $Self->BlobColumnsList(
            Table    => $Table,
            DBName   => $Param{DBInfo}->{DBName},
            DBObject => $Param{OTRSDBObject},
        ) || {};

        my %BlobColumns = %{$BlobColumnsRef};

        # Get the list of columns of this table to be able to
        #   generate correct INSERT statements.
        my $ColumnRef = $Self->ColumnsList(
            Table    => $Table,
            DBName   => $Param{DBInfo}->{DBName},
            DBObject => $Param{OTRSDBObject},
        ) || return;

        my @Columns;
        push( @Columns, @{$ColumnRef} );

        # We need to check if column is varchar and > 191 character on OTRS side.
        my %ShortenColumn;
        for my $Column (@Columns) {

            # Get OTRS Column infos
            my $ColumnInfos = $Self->GetColumnInfos(
                Table    => $Table,
                DBName   => $Param{DBInfo}->{DBName},
                DBObject => $Param{OTRSDBObject},
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

        # We need to check if all columns exists in both tables
        my @ColumnsOTRS;
        push( @ColumnsOTRS, @{$ColumnRef} );

        my $ColumnRefOTOBO = $Param{OTOBODBBackend}->ColumnsList(
            Table    => $RenameTables{$Table} // $Table,
            DBName   => $ConfigObject->Get('Database'),
            DBObject => $TargetDBObject,
        ) || return;

        my @ColumnsOTOBO;
        push( @ColumnsOTOBO, @{$ColumnRefOTOBO} );

        # Remove all colums which in both systems exists.
        # First we create a hash
        my %TmpOTOBOHash = map { $_ => 1 } @ColumnsOTOBO;

        # Remove if not exist in hash
        @ColumnsOTRS = grep { !exists $TmpOTOBOHash{$_} } @ColumnsOTRS;

        # If true, we have more columns in OTRS table and we need to add the column to otobo
        if ( IsArrayRefWithData( \@ColumnsOTRS ) ) {

            for my $Column (@ColumnsOTRS) {

                my $ColumnInfos = $Self->GetColumnInfos(
                    Table    => $Table,
                    DBName   => $Param{DBInfo}->{DBName},
                    DBObject => $Param{OTRSDBObject},
                    Column   => $Column,
                );

                my $TranslatedColumnInfos = $Param{OTOBODBBackend}->TranslateColumnInfos(
                    ColumnInfos => $ColumnInfos,
                    DBType      => $Param{OTRSDBObject}->{'DB::Type'},
                );

                my $Result = $Param{OTOBODBBackend}->AlterTableAddColumn(
                    Table       => $RenameTables{$Table} // $Table,
                    DBObject    => $TargetDBObject,
                    Column      => $Column,
                    ColumnInfos => $TranslatedColumnInfos,
                );
            }
        }

        my $ColumnsString = join( ', ', @Columns );
        my $BindString    = join ', ', map {'?'} @Columns;
        my $OTOBOTable    = $RenameTables{$Table} // $Table;
        my $SQL           = "INSERT INTO $OTOBOTable ($ColumnsString) VALUES ($BindString)";

        # Now fetch all the data and insert it to the target DB.
        $Param{OTRSDBObject}->Prepare(
            SQL   => "SELECT $ColumnsString FROM $Table",
            Limit => 4_000_000_00,
        ) || return;

        # if needed, set pre-requisites
        if (
            $TargetDBObject->can('SetPreRequisites')
            && grep { lc($_) eq 'id' } @Columns
            )
        {

            $TargetDBObject->SetPreRequisites(
                DBObject => $TargetDBObject,
                Table    => $RenameTables{$Table} // $Table,
            );
        }

        # get encode object
        my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

        TABLEROW:
        while ( my @Row = $Param{OTRSDBObject}->FetchrowArray() ) {

            COLUMNVALUES:
            for my $ColumnCounter ( 1 .. $#Columns ) {
                my $Column = $Columns[$ColumnCounter];

                # Check if we need to cut the string, cause utf8mb4 only needs 191 chars.
                if ( IsHashRefWithData( \%ShortenColumn ) && $ShortenColumn{$Column} ) {
                    if ( $Row[$ColumnCounter] && length( $Row[$ColumnCounter] ) > 190 ) {
                        $Row[$ColumnCounter] = substr( $Row[$ColumnCounter], 0, 190 );
                    }
                }
            }

            # If the two databases have different blob handling (base64), convert
            #   columns that need it.
            if (
                $TargetDBObject->GetDatabaseFunction('DirectBlob')
                != $Param{OTRSDBObject}->GetDatabaseFunction('DirectBlob')
                )
            {
                COLUMN:
                for my $ColumnCounter ( 1 .. $#Columns ) {
                    my $Column = $Columns[$ColumnCounter];

                    next COLUMN if ( !$Self->{BlobColumns}->{ lc "$Table.$Column" } );

                    if ( !$Param{OTRSDBObject}->GetDatabaseFunction('DirectBlob') ) {
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
                SQL  => $SQL,
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

        # if needed, reset the auto-incremental field
        if (
            $TargetDBObject->can('ResetAutoIncrementField')
            && grep { lc($_) eq 'id' } @Columns
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
