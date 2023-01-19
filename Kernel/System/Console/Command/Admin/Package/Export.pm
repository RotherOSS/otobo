# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Console::Command::Admin::Package::Export;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Export the contents of an OTOBO package to a directory.');
    $Self->AddOption(
        Name        => 'target-directory',
        Description => "Export contents of the package to the specified directory.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'source-path',
        Description => "Specify the path to an OTOBO package (opm) file that should be exported.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Self->GetArgument('source-path');
    if ( $SourcePath && !-r $SourcePath ) {
        die "File $SourcePath does not exist / can not be read.\n";
    }

    my $TargetDirectory = $Self->GetOption('target-directory');
    if ( $TargetDirectory && !-d $TargetDirectory ) {
        die "Directory $TargetDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Exporting package contents...</yellow>\n");

    my $SourcePath = $Self->GetArgument('source-path');

    my $FileString;
    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SourcePath,
        Mode     => 'utf8',        # optional - binmode|utf8
        Result   => 'SCALAR',      # optional - SCALAR|ARRAY
    );
    if ( !$ContentRef || ref $ContentRef ne 'SCALAR' ) {
        $Self->PrintError("File $SourcePath is empty / could not be read.");
        return $Self->ExitCodeError();
    }
    $FileString = ${$ContentRef};

    my %Structure = $Kernel::OM->Get('Kernel::System::Package')->PackageParse(
        String => $FileString,
    );

    my $TargetDirectory = $Self->GetOption('target-directory');
    my $Success         = $Kernel::OM->Get('Kernel::System::Package')->PackageExport(
        String => $FileString,
        Home   => $TargetDirectory,
    );

    if ($Success) {
        $Self->Print("<green>Exported files of package $SourcePath to $TargetDirectory.</green>\n");
        return $Self->ExitCodeOk();
    }

}

1;
