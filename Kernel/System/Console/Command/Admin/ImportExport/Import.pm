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

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::ImportExport',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('The tool for importing generic items');
    $Self->AddOption(
        Name        => 'template-number',
        Description => "Specify a template number to be impoerted.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/\d+/smx,
    );
    $Self->AddArgument(
        Name        => 'source',
        Description => "Specify the path to the file which contains the data for importing.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Self->GetArgument('source');
    if ( $SourcePath && !-r $SourcePath ) {
        die "File $SourcePath does not exist, can not be read.\n";
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

    if ( !$TemplateData->{TemplateID} ) {
        $Self->PrintError("Template $TemplateID not found!.\n");
        $Self->PrintError("Export aborted..\n");

        return $Self->ExitCodeError();
    }

    $Self->Print("<yellow>Importing config items...</yellow>\n");
    $Self->Print( "<yellow>" . ( '=' x 69 ) . "</yellow>\n" );

    my $SourceContent;
    my $SourceFile = $Self->GetArgument('source');

    if ($SourceFile) {

        $Self->Print("<yellow>Read File $SourceFile.</yellow>\n");

        # read source file
        $SourceContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $SourceFile,
            Result   => 'SCALAR',
            Mode     => 'binmode',
        );

        if ( !$SourceContent ) {
            $Self->PrintError("Can't read file $SourceFile.\nImport aborted.\n") if !$SourceContent;

            return $Self->ExitCodeError();
        }

    }

    # import data
    my $Result = $Kernel::OM->Get('Kernel::System::ImportExport')->Import(
        TemplateID    => $TemplateID,
        SourceContent => $SourceContent,
        UserID        => 1,
    );

    if ( !$Result ) {
        $Self->PrintError("\nError occurred. Import impossible! See the OTOBO log for details.\n");

        return $Self->ExitCodeError();
    }

    # print result
    $Self->Print("\n<green>Import of $Result->{Counter} $Result->{Object} records:</green>\n");
    $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );
    $Self->Print("<green>Success: $Result->{Success} succeeded</green>\n");
    if ( $Result->{Failed} ) {
        $Self->PrintError("$Result->{Failed} failed.\n");
    }
    else {
        $Self->Print("<green>Error: $Result->{Failed} failed.</green>\n");
    }

    for my $RetCode ( sort keys %{ $Result->{RetCode} } ) {
        my $Count = $Result->{RetCode}->{$RetCode} || 0;
        $Self->Print("<green>Import of $Result->{Counter} $Result->{Object} records: $Count $RetCode</green>\n");
    }
    if ( $Result->{Failed} ) {
        $Self->Print("<green>Last processed line number of import file: $Result->{Counter}</green>\n");
    }

    $Self->Print("<green>Import complete.</green>\n");
    $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
