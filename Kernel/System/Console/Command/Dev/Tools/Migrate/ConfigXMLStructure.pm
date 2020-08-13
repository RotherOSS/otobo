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

package Kernel::System::Console::Command::Dev::Tools::Migrate::ConfigXMLStructure;

use strict;
use warnings;

use File::Basename;
use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig::Migration',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Migrate XML configuration files from OTOBO 5 to OTOBO 10.');
    $Self->AddOption(
        Name        => 'source-directory',
        Description => "Directory which contains configuration XML files that needs to be migrated.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # Perform any custom validations here. Command execution can be stopped with die().
    my $Directory = $Self->GetOption('source-directory');
    if ( $Directory && !-d $Directory ) {
        die "Directory $Directory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Migrating configuration XML files...</yellow>\n");

    # needed objects
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Directory = $Self->GetOption('source-directory');
    my @Files     = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.xml',
    );

    if ( !@Files ) {
        $Self->PrintError("No XML files found in $Directory.");
        return $Self->ExitCodeError();
    }

    if ( !-d "$Directory/XML" ) {

        # Create XML directory
        mkdir "$Directory/XML";
    }

    FILE:
    for my $File (@Files) {

        my $TargetPath = "$Directory/XML/" . basename($File);

        $Self->Print("$File -> $TargetPath...");

        # Read XML file
        my $ContentRef = $MainObject->FileRead(
            Location => $File,
            Mode     => 'utf8',
        );

        # Get file name without extension
        my $FileName = $File;
        $FileName =~ s{^.*/(.*?)\..*$}{$1}gsmx;

        # Migrate
        my $Result = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateXMLStructure(
            Content => $$ContentRef,
            Name    => $FileName,
        );

        if ( !$Result ) {
            $Self->Print("<red>Failed.</red>\n");
            next FILE;
        }

        # Save result
        my $Success = $MainObject->FileWrite(
            Location => $TargetPath,
            Content  => \$Result,
            Mode     => 'utf8',
        );

        $Self->Print(" <green>Done.</green>\n");
    }

    $Self->Print("\n<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
