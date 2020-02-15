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


package Kernel::System::Console::Command::Dev::Tools::Migrate::DTL2TT;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::Output::Template::Provider',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Migrate DTL files to Template::Toolkit.');
    $Self->AddArgument(
        Name        => 'directory',
        Description => "Toplevel OTOBO or module directory where DTL files need to be converted.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ProviderObject = $Kernel::OM->Get('Kernel::Output::Template::Provider');

    my $Directory = $Self->GetArgument('directory');

    if ( !-d $Directory ) {
        $Self->PrintError("Please provide a directory. '$Directory' is not a valid directory.");
        return $Self->ExitCodeError();
    }

    my @FileList;

    # Regular DTLs
    if ( -d "$Directory/Kernel/Output/HTML/" ) {
        push @FileList, $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => "$Directory/Kernel/Output/HTML/",
            Filter    => "*.dtl",
            Recursive => 1,
        );
    }

    # Customized DTLs
    if ( -d "$Directory/Custom/Kernel/Output/HTML/" ) {
        push @FileList, $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => "$Directory/Custom/Kernel/Output/HTML/",
            Filter    => "*.dtl",
            Recursive => 1,
        );
    }

    # XML configuration files, may also contain DTL tags
    if ( -d "$Directory/Kernel/Config/Files/" ) {
        push @FileList, $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => "$Directory/Kernel/Config/Files/",
            Filter    => "*.xml",
            Recursive => 1,
        );
    }

    if ( !@FileList ) {
        $Self->PrintError("No affected files found in $Directory.");
        return $Self->ExitCodeError();
    }

    my $Success = 1;

    for my $File (@FileList) {
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $File,
            Mode     => 'utf8',
        );

        my $TTFile = $File;
        $TTFile =~ s{[.]dtl$}{.tt}smx;

        print "$File -> $TTFile\n";

        # Correct file name in header (*.dtl -> *.tt)
        ${$ContentRef} =~ s{(\A# --\n# [a-zA-Z0-9/]+[.])dtl[ ]}{$1tt };

        my $TTContent;
        eval {
            $TTContent = $ProviderObject->MigrateDTLtoTT( Content => ${$ContentRef} );
        };
        if ($@) {
            $Self->PrintError("There were errors processing this file:\n$@\n");
            $Success = 0;
        }

        if ( $TTContent ne ${$ContentRef} ) {
            $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
                Location => $TTFile,
                Content  => \$TTContent,
                Mode     => 'utf8',
            );
        }
    }

    if ( !$Success ) {
        $Self->PrintError("\nThere were errors converting the files, please see above!\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("\n<green>All files ok.</green>\n");
    return $Self->ExitCodeOk();
}

1;
