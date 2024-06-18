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

package Kernel::System::Console::Command::Maint::Database::MySQL::UTF8MB4Migration;

use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::PID',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        'Convert all columns in MySQL database tables to utf8mb4. Please use only this script if columns were created incorrectly with utf8 or utf8mb3 charset and in any case make a backup of the database beforehand.'
    );
    $Self->AddOption(
        Name        => 'force',
        Description => "Actually do the migration now.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'force-pid',
        Description => "Start even if another process is still registered in the database.",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} ne 'mysql' ) {
        die "This script can only be run on mysql databases.\n";
    }

    my $PIDCreated = $Kernel::OM->Get('Kernel::System::PID')->PIDCreate(
        Name  => $Self->Name(),
        Force => $Self->GetOption('force-pid'),
        TTL   => 60 * 60 * 24 * 3,
    );
    if ( !$PIDCreated ) {
        my $Error = "Unable to register the process in the database. Is another instance still running?\n";
        $Error .= "You can use --force-pid to override this check.\n";
        die $Error;
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Force = $Self->GetOption('force');
    if ($Force) {
        $Self->Print("<yellow>Converting all database columns to utf8mb4...</yellow>\n");
    }
    else {
        $Self->Print("<yellow>Checking for tables that need to be converted to utf8mb4...</yellow>\n");
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get all columns != utf8mb4
    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL =>
            "select table_name, column_name, data_type, CHARACTER_MAXIMUM_LENGTH , IS_NULLABLE, character_set_name, collation_name from information_schema.columns where table_schema = \""
            . $ConfigObject->Get('Database')
            . "\" and CHARACTER_SET_NAME is not null AND CHARACTER_SET_NAME <> 'utf8mb4'",
    );

    my @Tables;
    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {

        my %Column;
        $Column{"table_name"}               = $Row[0];
        $Column{"column_name"}              = $Row[1];
        $Column{"data_type"}                = $Row[2];
        $Column{"CHARACTER_MAXIMUM_LENGTH"} = $Row[3];
        $Column{"IS_NULLABLE"}              = $Row[4];
        $Column{"collation_name"}           = $Row[5];
        push @Tables, \%Column;
    }

    if ( !$Force ) {
        if (@Tables) {
            for my $TableColumn (@Tables) {
                $Self->Print(
                    "Dry run: We need to change the following column <red>$TableColumn->{column_name}</red> from table <red>$TableColumn->{table_name}</red> to utf8mb4...\n"
                );
                $Self->Print("You can re-run this script with <green>--force</green> to start the migration.\n");
            }
            return $Self->ExitCodeOk();
        }
        else {

            $Self->Print("No need to run this script!\n");
            return $Self->ExitCodeOk();
        }
    }

    # Now convert the tables.
    for my $TableColumn (@Tables) {
        $Self->Print(
            "Change column <yellow>$TableColumn->{column_name} $TableColumn->{data_type} $TableColumn->{CHARACTER_MAXIMUM_LENGTH} $TableColumn->{IS_NULLABLE}</yellow> from table <yellow>$TableColumn->{table_name}</yellow> to utf8mb4...\n"
        );

        my $SQL;
        $SQL
            = "ALTER TABLE " . $TableColumn->{table_name} . " DEFAULT CHARACTER SET utf8mb4, MODIFY " . $TableColumn->{column_name} . " " . $TableColumn->{"data_type"};

        if ( $TableColumn->{"data_type"} =~ /varchar/i ) {
            $SQL .= '(' . $TableColumn->{"CHARACTER_MAXIMUM_LENGTH"} . ')';
        }

        if ( $TableColumn->{"IS_NULLABLE"} eq 'NO' ) {
            $SQL .= ' NOT NULL,';
        }
        else {
            $SQL .= ' NULL,';
        }

        $SQL .= ' CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci';

        my $Result = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => $SQL,
        );
        if ( !$Result ) {
            $Self->PrintError("Could not convert $TableColumn->{table_name} - $TableColumn->{column_name} .");
            return $Self->ExitCodeError();
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::PID')->PIDDelete( Name => $Self->Name() );
}

1;
