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

package Kernel::System::Console::Command::Admin::ImportExport::Import;

use v5.24;
use strict;
use warnings;
use utf8;
use re '/aa';

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::ImportExport',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('This is a tool for importing items. The specifics are defined in an ImportExport template.');
    $Self->AddOption(
        Name        => 'template-number',
        Description => 'Specify a template number to be imported.',
        Description => 'the number of the ImportExport template that specifies the import',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/,
    );
    $Self->AddOption(
        Name        => 'prefix',
        Description => 'Prefix of the import files when a directory was passed as source',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\w+$/,    # "\w" matches the 63 characters [a-zA-Z0-9_] as the "/a" modifier is in effect
    );
    $Self->AddArgument(
        Name        => 'source',
        Description => "Specify the path to the file or directory which contains the data for importing.",
        Required    => 1,
        ValueRegex  => qr/.*/,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->GetArgument('source');
    if ( !$Source ) {

        # source is optional, even if an import without source is unsatisfying
    }
    elsif ( -d $Source ) {

        # a directory is fine
    }
    elsif ( -r $Source ) {

        # a readable file is fine
    }
    else {
        die "The source $Source does not exist or can not be read.";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TemplateID = $Self->GetOption('template-number');

    # get template data
    my $TemplateData = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    if ( ref $TemplateData ne 'HASH' || !$TemplateData->{TemplateID} ) {
        $Self->PrintError("Template $TemplateID not found!.\n");
        $Self->PrintError("Import aborted..\n");

        return $Self->ExitCodeError;
    }

    $Self->Print("<yellow>Importing items...</yellow>\n");
    $Self->Print( "<yellow>" . ( '=' x 69 ) . "</yellow>\n" );

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my ( @SourceFiles, $IsChunked );
    {
        my $Source = $Self->GetArgument('source');
        if ( -d $Source ) {
            my $Prefix = $Self->GetOption('prefix') // '';
            @SourceFiles = $MainObject->DirectoryRead(
                Directory => $Source,
                Filter    => "${Prefix}[0-9][0-9][0-9][0-9][0-9][0-9].csv",    # a fancy glob pattern
            );
            $IsChunked = 1;
        }
        else {

            # the source is a single file
            push @SourceFiles, $Source;
        }
    }

    # for summing up the chunks
    my %Total = (
        Success => 0,
        Failed  => 0,
    );

    # importing
    SOURCE_FILE:
    for my $SourceFile (@SourceFiles) {

        next SOURCE_FILE unless $SourceFile;

        $Self->PrintWarning("Reading file $SourceFile.");

        # read source file
        my $SourceContent = $MainObject->FileRead(
            Location => $SourceFile,
            Result   => 'SCALAR',
            Mode     => 'binmode',
        );

        # bail out when a file is not readable
        # even though other files might already have been imported
        if ( !$SourceContent ) {
            $Self->PrintError("Can't read file $SourceFile.\nImport aborted.\n");

            return $Self->ExitCodeError;
        }

        # import data
        my $Result = $Kernel::OM->Get('Kernel::System::ImportExport')->Import(
            TemplateID    => $TemplateID,
            SourceContent => $SourceContent,
            UserID        => 1,
        );

        if ( !$Result ) {
            $Self->PrintError("\nError occurred. Import impossible! See the OTOBO log for details.\n");

            return $Self->ExitCodeError;
        }

        # print result
        $Self->PrintOk("\nImport of $Result->{Counter} $Result->{Object} records:");
        $Self->Print( ( '-' x 69 ) . "\n" );
        $Self->PrintOk("Success: $Result->{Success} succeeded");
        if ( $Result->{Failed} ) {
            $Self->PrintError("$Result->{Failed} failed.\n");
        }
        else {
            $Self->PrintOk("Error: $Result->{Failed} failed.");
        }

        # sum up the total
        $Total{Success} += $Result->{Success} // 0;
        $Total{Failed}  += $Result->{Failed}  // 0;

        for my $RetCode ( sort keys %{ $Result->{RetCode} } ) {
            my $Count = $Result->{RetCode}->{$RetCode} || 0;
            $Self->Print("<green>Import of $Result->{Counter} $Result->{Object} records: $Count $RetCode</green>\n");
        }
        if ( $Result->{Failed} ) {
            $Self->Print("<green>Last processed line number of import file: $Result->{Counter}</green>\n");
        }

        $Self->Print("<green>Import complete.</green>\n");
        $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );
    }

    # report the total
    if ($IsChunked) {
        my $ChunkCounter = @SourceFiles;
        $Self->Print(
            join '',
            "\n",
            "Total after importing $ChunkCounter chunk(s):\n",
            "Success: $Total{Success}\n",
            "Failed : $Total{Failed}\n",
            "\n"
        );
    }

    $Self->PrintOk('Done.');

    return $Self->ExitCodeOk;
}

1;
