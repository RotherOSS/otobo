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
use v5.24;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use File::Copy qw(copy);

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
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
        my $Content = $ContentRef->$*;

        # sanity checks
        if ( $Content !~ m{<otrs_config} ) {
            $Self->Print("skipping $File as it has no element otrs_config");

            next FILE;
        }
        if ( $Content !~ m{<otrs_config.*?init="(.+?)"} ) {
            $Self->Print("skipping $File as the element otrs_config has no init attribute");

            next FILE;
        }

        if ( $Content !~ m{<otrs_config.*?version="2.0"} ) {
            $Self->Print("skipping $File as the element otrs_config is not version 2.0");

            next FILE;
        }

        # now the actual transformation
        $Content =~ s{^<otrs_config}{<otobo_config}gsmx;
        $Content =~ s{^</otrs_config}{</otobo_config}gsmx;

        # Save result in the original file
        my $SaveSuccess = $MainObject->FileWrite(
            Location => $File,
            Content  => \$Content,
            Mode     => 'utf8',
        );
        if ( ! $SaveSuccess ) {
            $Self->Print("<red>Failed. Could not overwrite $File.</red>\n");

            next FILE;
        }

        $Self->Print(" <green>Done with $File.</green>\n");
    }

    $Self->Print("\n<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
