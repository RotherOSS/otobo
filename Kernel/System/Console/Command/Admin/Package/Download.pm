# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::Console::Command::Admin::Package::Download;

use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules
use File::Spec     ();
use File::Basename qw(dirname);
use Encode         ();

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Main',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Download all installed OTOBO packages.');

    $Self->AddOption(
        Name        => 'package-name',
        Description => '(Part of) package name to filter for. Omit to download  all installed packages.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/,
    );

    $Self->AddOption(
        Name        => 'path',
        Description => 'Path where the exported packages are saved.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Listing all installed packages...</yellow>\n");

    my @Packages = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList();

    if ( !@Packages ) {
        $Self->Print("<green>There are no packages installed.</green>\n");

        return $Self->ExitCodeOk();
    }

    my $PackageNameOption = $Self->GetOption('package-name');
    my $Path              = $Self->GetOption('path');

    # Get package object
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    PACKAGE:
    for my $PackageInstalled (@Packages) {

        if ( defined $PackageNameOption && length $PackageNameOption ) {
            my $PackageString = $PackageInstalled->{Name} . '-' . $PackageInstalled->{Version};

            next PACKAGE if $PackageString !~ m{$PackageNameOption}i;
        }

        # get package
        my $Package = $PackageObject->RepositoryGet(
            Name    => $PackageInstalled->{Name}->{Content},
            Version => $PackageInstalled->{Version}->{Content},
        );
        if ( !$Package ) {
            $Self->Print(
                "<red>Package $PackageInstalled->{Name}->{Content} Error:</red>" . "\n"
            );

            return;
        }

        my $FileName = $PackageInstalled->{Name}->{Content} . '-' . $PackageInstalled->{Version}->{Content} . '.opm';

        # If $Path is a directory, construct the full file path.
        # If $Path is already a complete file path, simply use $Path.
        my $TargetPath = File::Spec->catfile( $Path, $FileName );

        my ( $OK, $Err ) = $Self->_WriteBinaryFile(
            Path    => $TargetPath,
            Content => $Package,
        );

        if ( !$OK ) {
            $Self->Print(
                "<red>Package $PackageInstalled->{Name}->{Content} Error write file:</red>" . "\n"
            );

            return;
        }

        # Print MUSS vor dem return kommen, sonst läuft das nie.
        $Self->Print(
            '<yellow>Pck. Status:</yellow> ' . ( $PackageInstalled->{Name}->{Content} ? 'OK' : 'Not OK' ) . "\n"
        );
        $Self->Print(
            '<yellow>Saved to:</yellow> ' . $TargetPath . "\n"
        );
    }

    return $Self->ExitCodeOk();
}

sub _WriteBinaryFile {
    my ( $Self, %Param ) = @_;

    # Check required parameters.
    for my $Needed (qw(Path Content)) {
        if ( !defined $Param{$Needed} ) {
            return ( undef, "Missing param: $Needed" );
        }
    }

    my $FilePath = $Param{Path};

    # Ensure we write bytes, not Perl wide characters.
    # The content (e.g. OPM XML) can be a UTF-8 flagged string.
    my $Content = $Param{Content};
    if ( utf8::is_utf8($Content) ) {
        $Content = Encode::encode_utf8($Content);
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Ensure target directory exists.
    my $Dir = dirname($FilePath);
    if ( !-d $Dir ) {

        my $Success = $MainObject->DirectoryCreate(
            Directory => $Dir,
        );

        if ( !$Success ) {
            return ( undef, "Could not create directory '$Dir'." );
        }
    }

    # Write file content in binary mode (no encoding/line-ending conversions).
    my $Success = $MainObject->FileWrite(
        Location => $FilePath,
        Content  => \$Content,
        Mode     => 'binmode',
    );

    if ( !$Success ) {
        return ( undef, "Could not write file '$FilePath'." );
    }

    return ( 1, undef );
}

1;
