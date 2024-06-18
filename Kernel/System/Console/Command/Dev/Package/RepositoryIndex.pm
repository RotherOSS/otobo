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

package Kernel::System::Console::Command::Dev::Package::RepositoryIndex;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate an index file (otobo.xml) for an OTOBO package repository.');
    $Self->AddArgument(
        Name        => 'source-directory',
        Description => "Specify the directory containing the OTOBO packages.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $SourceDirectory = $Self->GetArgument('source-directory');
    if ( $SourceDirectory && !-d $SourceDirectory ) {
        die "Directory $SourceDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Result = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
    $Result .= "<otobo_package_list version=\"1.0\">\n";
    my $SourceDirectory = $Self->GetArgument('source-directory');
    my @List            = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $SourceDirectory,
        Filter    => '*.opm',
        Recursive => 1,
    );
    for my $File (@List) {
        my $Content    = '';
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $File,
            Mode     => 'utf8',      # optional - binmode|utf8
            Result   => 'SCALAR',    # optional - SCALAR|ARRAY
        );
        if ( !$ContentRef ) {
            $Self->PrintError("Can't open $File: $!\n");
            return $Self->ExitCodeError();
        }
        my %Structure = $Kernel::OM->Get('Kernel::System::Package')->PackageParse( String => ${$ContentRef} );
        my $XML       = $Kernel::OM->Get('Kernel::System::Package')->PackageBuild( %Structure, Type => 'Index' );
        if ( !$XML ) {
            $Self->PrintError("Cannot generate index entry for $File.\n");
            return $Self->ExitCodeError();
        }
        $Result .= "<Package>\n";
        $Result .= $XML;
        my $RelativeFile = $File;
        $RelativeFile =~ s{^\Q$SourceDirectory\E}{}smx;
        $RelativeFile =~ s{^/}{}smx;
        $Result .= "  <File>$RelativeFile</File>\n";
        $Result .= "</Package>\n";
    }
    $Result .= "</otobo_package_list>\n";
    $Self->Print($Result);

    return $Self->ExitCodeOk();
}

1;
