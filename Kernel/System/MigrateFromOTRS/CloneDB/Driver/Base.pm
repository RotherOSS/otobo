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
use File::Basename    qw(fileparse);

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

=over 4

=cut

=item new()

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
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # Create function BlobColumnsList to get this info.
    # TODO: Remove after testing
#    for my $Needed (
#        qw(BlobColumns CheckEncodingColumns)
#        )
#    {
#        if ( !$Param{$Needed} ) {
#            $Kernel::OM->Get('Kernel::System::Log')->Log(
#                Priority => 'error',
#                Message  => "Got no $Needed!",
#            );
#            return;
#        }
#
#        $Self->{$Needed} = $Param{$Needed};
#    }

    return $Self;
}

#
# Some up-front sanity checks
#
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
    my $SkipTables = $MigrationBaseObject->DBSkipTables();

    # get OTOBO DB object
    my $TargetDBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get a list of tables on OTRS DB
    my @Tables = $Self->TablesList(
        DBObject => $Param{OTRSDBObject},
    );

    # Need to check if table empty, then a connect is not possible
    if ( !IsArrayRefWithData( \@Tables )) {
        return;
    }

    TABLES:
    for my $Table (@Tables) {

        if ( defined $SkipTables->{ lc $Table } && $SkipTables->{ lc $Table } ) {
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
    return $Result;
}

#
# Transfer the actual table data
#
sub DataTransfer {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(OTRSDBObject OTRSDBBackend DBInfo)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');
    my $SkipTables = $MigrationBaseObject->DBSkipTables();

    # file handle
    my $FH;

    # get OTOBO db object
    my $TargetDBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get a list of tables on OTRS DB
    my @Tables = $Self->TablesList(
        DBObject => $Param{OTRSDBObject},
    );

    # get a list of tables on OTOBO DB
    my @OTOBOTables = $Self->TablesList(
        DBObject => $TargetDBObject,
    );

    # We need to disable FOREIGN_KEY_CHECKS, cause we copy the data. TODO: Test on postgresql and oracle!
    if ( $TargetDBObject->{'DB::Type'} eq 'mysql' ) {
        $TargetDBObject->Do( SQL  => 'SET FOREIGN_KEY_CHECKS = 0' );

    } elsif ( $TargetDBObject->{'DB::Type'} eq 'postgresql' ) {
        $TargetDBObject->Do( SQL  => 'SET CONSTRAINTS ALL DEFERRED' );
    }
    elsif ( $TargetDBObject->{'DB::Type'} eq 'oracle' ) {
        # TODO: $TargetDBObject->Do( SQL  => 'SET FOREIGN_KEY_CHECKS = 0' );
    }
    # Delete OTOBO content from table
    OTRSTABLES:
    for my $OTRSTable (@Tables) {

        # check if OTOBO Table exists, if yes drop table
        my $TableExists = 0;
        OTOBOTABLES:
        for my $OTOBOTable (@OTOBOTables) {
            if ( $OTRSTable eq $OTOBOTable ) {
                $TableExists = 1;
            }
            if ( $TableExists == 1 ) {

                # Get info if this table is already migrated
                my $CacheValue = $CacheObject->Get(
                    Type  => 'OTRSMigration',
                    Key   => 'MigrationStateDB'.$OTOBOTable,
                );

                if ( $CacheValue ) {
                    last OTOBOTABLES;
                };

                $TargetDBObject->Do( SQL  => "TRUNCATE TABLE $OTRSTable");
                last OTOBOTABLES;
            } else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "Table $OTRSTable exists not in OTOBO, please copy this table later manualy.",
                );
            }
        }
    }

    TABLES:
    for my $Table (@Tables) {

        if ( defined $SkipTables->{ lc $Table } && $SkipTables->{ lc $Table } ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Skipping table $Table...",
            );
            next TABLES;
        }

        # Set cache object with taskinfo and starttime to show current state in frontend
        my $DateTimeObject = $Kernel::OM->Create( 'Kernel::System::DateTime');
        my $Epoch = $DateTimeObject->ToEpoch();

        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task        => 'OTOBODatabaseMigrate',
                SubTask     => "Copy table: $Table",
                StartTime   => $Epoch,
            },
        );

        # Get info if this table is already migrated
        my $CacheValue = $CacheObject->Get(
            Type  => 'OTRSMigration',
            Key   => 'MigrationStateDB'.$Table,
        );

        if ( $CacheValue ) {
            next TABLES;
        };

        # get a list of blob columns from OTOBO DB
        my $BlobColumnsRef = $Self->BlobColumnsList(
            Table    => $Table,
            DBName   => $Param{DBInfo}->{DBName},
            DBObject => $TargetDBObject,
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
        push (@Columns, @{$ColumnRef});


        my $ColumnsString = join( ', ', @Columns );
        my $BindString    = join ', ', map {'?'} @Columns;
        my $SQL           = "INSERT INTO $Table ($ColumnsString) VALUES ($BindString)";

        my $RowCount = $Self->RowCount(
            DBObject => $Param{OTRSDBObject},
            Table    => $Table,
        );
        my $Counter = 1;

        # Now fetch all the data and insert it to the target DB.
        $Param{OTRSDBObject}->Prepare(
            SQL => "SELECT $ColumnsString FROM $Table",
            Limit => 4_000_000_000,
        ) || return;

        # if needed, set pre-requisites
        if (
            $TargetDBObject->can('SetPreRequisites')
            && grep { lc($_) eq 'id' } @Columns
            )
        {

            $TargetDBObject->SetPreRequisites(
                DBObject => $TargetDBObject,
                Table    => $Table,
            );
        }

        # get encode object
        my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

        TABLEROW:
        while ( my @Row = $Param{OTRSDBObject}->FetchrowArray() ) {

            COLUMNVALUES:
            for my $ColumnCounter ( 1 .. $#Columns ) {
                my $Column = $Columns[$ColumnCounter];

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "Copy column: $Table.$Columns[$ColumnCounter].",
                );

                # get column value
                my $ColumnValue = $Row[$ColumnCounter];

                # verify if the string value have the utf8 flag enabled
                next COLUMNVALUES if !utf8::is_utf8($ColumnValue);

                # TODO Rother OSS: Verify if column is not a blob.
                #next COLUMNVALUES if !$Self->{BlobColumns}->{ lc "$Table.$Column" };
                next COLUMNVALUES if $BlobColumns{"$Table.$Column"};

                # check enconding for column value
                if ( !eval { Encode::is_utf8( $ColumnValue, 1 ) } ) {

                    # replace invalid characters with � (U+FFFD, Unicode replacement character)
                    # If it runs on good UTF-8 input, output should be identical to input
                    my $TmpResult = eval {
                        Encode::decode( 'UTF-8', $ColumnValue );
                    } || '';

                    # remove wrong characters
                    if ( $TmpResult =~ m{[\x{FFFD}]}xms ) {
                        $TmpResult =~ s{[\x{FFFD}]}{}xms;
                    }

                    # generate a log message with full info about error and replacement
#                    my $ReplacementMessage =
#                        "On table: $Table, column: $Column, id: $Row[0] - exists an invalid utf8 value. \n"
#                        .
#                        " $ColumnValue is replaced by : $TmpResult . \n\n";
#                    print STDERR $ReplacementMessage;
#                    $Kernel::OM->Get('Kernel::System::Log')->Log(
#                        Priority => 'error',
#                        Message  => "$ReplacementMessage",
#                    );
                    # set new value on Row result from DB
                    $Row[$ColumnCounter] = $TmpResult;

                }

                # Only for mysql
                if ( $Row[$ColumnCounter] && $TargetDBObject->{'DB::Type'} eq 'mysql' ) {

                    # Replace any unicode characters that need more then three bytes in UTF8
                    #   with the unicode replacement character. MySQL's utf8 encoding only
                    #   supports three bytes. In future we might want to use utf8mb4 (supported
                    #   since 5.5.3+).
                    # See also http://mathiasbynens.be/notes/mysql-utf8mb4.
                    $Row[$ColumnCounter] =~ s/([\x{10000}-\x{10FFFF}])/"\x{FFFD}"/eg;
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

            if ( $Counter % 1000 == 0 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "Inserting $Counter of $RowCount.",
                );
            }
            my $Success = $TargetDBObject->Do(
                SQL  => $SQL,
                Bind => \@Bind,
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not insert data: Table: $Table - id:$Row[0].",
                );
                return;
            }

            $Counter++;
        }

        # if needed, reset the auto-incremental field
        if (
            $TargetDBObject->can('ResetAutoIncrementField')
            && grep { lc($_) eq 'id' } @Columns
            )
        {

            $TargetDBObject->ResetAutoIncrementField(
                DBObject => $TargetDBObject,
                Table    => $Table,
            );
        }
        # Set cache object if table is already copied
        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationStateDB'.$Table,
            Value => '1',
        );
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
