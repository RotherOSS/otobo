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

package Kernel::System::Console::Command::Admin::Package::FileSearch;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Find a file in an installed OTOBO package.');
    $Self->AddArgument(
        Name        => 'search-path',
        Description => "Filename or path to search for.",
        Required    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Searching in installed OTOBO packages...</yellow>\n");

    my $Hit      = 0;
    my $Filepath = $Self->GetArgument('search-path');

    PACKAGE:
    for my $Package ( $Kernel::OM->Get('Kernel::System::Package')->RepositoryList() ) {

        # Just show if PackageIsVisible flag is enabled.
        if (
            defined $Package->{PackageIsVisible}
            && !$Package->{PackageIsVisible}->{Content}
            )
        {
            next PACKAGE;
        }
        for my $File ( @{ $Package->{Filelist} } ) {
            if ( $File->{Location} =~ m{\Q$Filepath\E}smx ) {
                print
                    "+----------------------------------------------------------------------------+\n";
                print "| File:        $File->{Location}\n";
                print "| Name:        $Package->{Name}->{Content}\n";
                print "| Version:     $Package->{Version}->{Content}\n";
                print "| Vendor:      $Package->{Vendor}->{Content}\n";
                print "| URL:         $Package->{URL}->{Content}\n";
                print "| License:     $Package->{License}->{Content}\n";
                print
                    "+----------------------------------------------------------------------------+\n";
                $Hit++;
            }
        }
    }
    if ($Hit) {
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    $Self->PrintError("File $Filepath was not found in an installed OTOBO package.\n");
    return $Self->ExitCodeError();
}

1;
