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

package Kernel::System::Console::Command::Admin::ImportExport::Export;

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
    'Kernel::System::Main',
    'Kernel::System::ImportExport',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('This is a tool for exporting items. The specifics are defined in an ImportExport template.');
    $Self->AddOption(
        Name        => 'template-number',
        Description => 'The number of the ImportExport template that specifies the export.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/,
    );
    $Self->AddArgument(
        Name        => 'destination',
        Description => "Specify the path to a file where config item data should be exported.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

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

    $Self->Print("<yellow>Exporting config items...</yellow>\n");
    $Self->Print( "<yellow>" . ( '=' x 69 ) . "</yellow>\n" );

    # export data
    my $Result = $Kernel::OM->Get('Kernel::System::ImportExport')->Export(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    if ( !$Result ) {
        $Self->PrintError("Error occurred. Export impossible! See Syslog for details.\n");

        return $Self->ExitCodeError();
    }

    $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );
    $Self->Print("<green>Success: $Result->{Success} succeeded</green>\n");
    if ( $Result->{Failed} ) {
        $Self->PrintError("$Result->{Failed} failed.\n");
    }
    else {
        $Self->Print("<green>Error: $Result->{Failed} failed.</green>\n");
    }

    my $DestinationFile = $Self->GetArgument('destination');

    if ($DestinationFile) {

        # Make sure that there is a line break after the last line.
        # This unconfuses `wc -l`.
        my $FileContent = join '', map { $_ . "\n" } $Result->{DestinationContent}->@*;

        # save destination content to file
        my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $DestinationFile,
            Content  => \$FileContent,
        );

        if ( !$Success ) {
            $Self->PrintError("Can't write file $DestinationFile.\nExport aborted.\n");

            return $Self->ExitCodeError();
        }

        $Self->Print("<green>File $DestinationFile saved.</green>\n");

    }

    $Self->Print("<green>Export complete.</green>\n");
    $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
