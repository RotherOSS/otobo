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

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use File::Copy qw(move);

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig::Migration',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(<<'END_DESC');
Migrate XML configuration files from OTRS 6.0.x to OTOBO 10.0.x.
The original XML files will be saved with the extension .bak_otrs_6.
END_DESC
    $Self->AddOption(
        Name        => 'source-directory',
        Description => 'Directory which contains configuration XML files that needs to be migrated.',
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
    if ( $Directory && ! -d $Directory ) {
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

    FILE:
    for my $File (@Files) {

        my $BackupFile = $File . '.bak_otrs_6';
        if ( ! copy( $File, $BackupFile ) ) {
            die "Could not create the backup file $BackupFile: $!";
        }

        $Self->Print("copied $File -> $BackupFile");

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

        if ( ! $Result ) {
            $Self->Print("<red>Failed migration $File</red>\n");

            next FILE;
        }

        # Save result in the original file
        my $Success = $MainObject->FileWrite(
            Location => $File,
            Content  => \$Result,
            Mode     => 'utf8',
        );
        if ( ! $$Success ) {
            $Self->Print("<red>Failed. Could not overwrite $File.</red>\n");

            next FILE;
        }

        $Self->Print(" <green>Done.</green>\n");
    }

    $Self->Print("\n<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
