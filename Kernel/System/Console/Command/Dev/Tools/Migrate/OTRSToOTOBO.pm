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

package Kernel::System::Console::Command::Dev::Tools::Migrate::OTRSToOTOBO;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::FileTemp',
    'Kernel::System::MigrateFromOTRS::Base',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(<<'END_DESC');
Create clean OTOBO source files from OTRS source code or an OTRS OPM package.
Migrate XML configuration files from OTRS 6.0.x to OTOBO 10.0.x.
END_DESC

    $Self->AddOption(
        Name        => 'cleanpath',
        Description =>
            "Should we change the path and filename to OTOBO or otobo, if otrs or OTRS exists?",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'cleancontent',
        Description =>
            "Should we clean the file content from OTRS to OTOBO style?",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'cleanlicense',
        Description =>
            "Should we clean the file license information to OTOBO and Rother OSS?",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'cleanxmlconfig',
        Description =>
            "Should we adapt the XML config files?",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'cleanall',
        Description =>
            "Run all clean options together.",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'target',
        Description => "Specify the directory where the cleaned OTOBO code should be placed.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'source',
        Description =>
            "Specify the directory containing the OTRS sources or the path to an OTRS based opm package.",
        Required   => 1,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->GetArgument('source');

    if ( !-r ($Source) ) {
        die "File $Source does not exist / cannot be read.\n";
    }

    my $TargetDirectory = $Self->GetOption('target');
    if ( !-d $TargetDirectory ) {
        die "Directory $TargetDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');
    $Self->Print("<green>Read unclean code or opm package...</green>\n");

    my $Source = $Self->GetArgument('source');

    # If option cleanall is active, we execute all availible clean modules.
    my $CleanALL           = $Self->GetOption('cleanall');
    my $CleanPath          = $Self->GetOption('cleanpath')      || $CleanALL;
    my $CleanLicenseHeader = $Self->GetOption('cleanlicense')   || $CleanALL;
    my $CleanContent       = $Self->GetOption('cleancontent')   || $CleanALL;
    my $CleanXMLConfig     = $Self->GetOption('cleanxmlconfig') || $CleanALL;
    my $TargetDirectory    = $Self->GetOption('target');
    my $SourceIsOPMOrDir   = 'Dir';
    my $TmpDirectory;

    if ( -f $Source ) {

        # Source is a file, hope opm (Need to check?)...
        $SourceIsOPMOrDir = 'OPM';

        # Create tempdir if opm package given
        $TmpDirectory = $Kernel::OM->Get('Kernel::System::FileTemp')->TempDir();
    }

    # List of all dir and files
    my @UncleanDirAndFileList;

    # List of only files to edit in the next step
    my @UncleanFileList;

    # Ignore path list
    my @ParserIgnoreDirAndFile = $MigrationBaseObject->IgnorePathList();

    # We need to check if a opm package is given
    if ( $SourceIsOPMOrDir eq 'OPM' && -d $TargetDirectory ) {

        # OPM package is given, so we need to extract it to a tmp dir
        my $SOPMCreate = $MigrationBaseObject->CopyOPMtoSOPMAndClean(
            Source       => $Source,
            TmpDirectory => $TmpDirectory,
        );
        $Self->Print("<green>Copy .opm file to Package.sopm: Done.</green>\n");

        # Add $TempDir path to $Source, so we can go on
        $Source = $MigrationBaseObject->ExtractOPMPackage(
            Source       => $Source,
            TmpDirectory => $TmpDirectory,
        );
        $Self->Print("<green>Extract OPM package: Done.</green>\n");
    }

    if ( $Source && -d $TargetDirectory ) {
        @UncleanDirAndFileList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Source,
            Filter    => '*',
            Recursive => 1,
        );

        for my $File (@UncleanDirAndFileList) {

            # IF $Source we need to remove the tmppath
            my $RwPath = $File;
            if ( $SourceIsOPMOrDir eq 'OPM' ) {
                $RwPath =~ s/$TmpDirectory//g;
                $RwPath = $TargetDirectory . $RwPath;
            }

            # No TmpDirectory exists
            elsif ( $SourceIsOPMOrDir eq 'Dir' ) {
                $RwPath =~ s/$Source//g;
                $RwPath = $TargetDirectory . $RwPath;
            }

            # Write file to output directory
            $MigrationBaseObject->HandleFile(
                File            => $File,
                RwPath          => $RwPath,
                Target          => $TargetDirectory,
                UncleanFileList => \@UncleanFileList,
            );
            $Self->Print("<green>Write content to TargetDirectory $TargetDirectory: Done.</green>\n");
        }

        # Now we clean the existing files
        FILE:
        for my $File (@UncleanFileList) {

            # Check wich paths we should ignore
            my $ParseNot;
            TYPE:
            for my $Type (@ParserIgnoreDirAndFile) {
                if ( $File =~ $Type ) {
                    $ParseNot = 1;
                    last TYPE;
                }
            }

            if ($ParseNot) {
                $Self->Print(
                    "<yellow>Ignore directory setting for $File is active - please check if you need to add a new regexp.</yellow>\n"
                );
                next FILE;

            }

            # Clean content of files if $CleanContent option is defined
            if ($CleanContent) {
                $MigrationBaseObject->CleanOTRSFileToOTOBOStyle(
                    File   => $File,
                    UserID => 1,
                );
            }

            # Clean header and license in files
            if ($CleanLicenseHeader) {
                $MigrationBaseObject->CleanLicenseHeader(
                    File   => $File,
                    UserID => 1,
                );
            }

            # If option cleanpath is given, clean path and filename
            if ($CleanPath) {
                $MigrationBaseObject->ChangePathFileName(
                    File   => $File,
                    UserID => 1,
                );
            }

            # If option cleanxmlconfig is given, clean path and filename
            if ($CleanXMLConfig) {
                $MigrationBaseObject->MigrateXMLConfig(
                    File   => $File,
                    UserID => 1,
                );
            }
        }
    }
    else {
        $Self->PrintError("No valid source or target dir given, exit!\n");
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Change file content in OTOBO style: Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
