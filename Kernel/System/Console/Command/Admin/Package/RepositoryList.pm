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

package Kernel::System::Console::Command::Admin::Package::RepositoryList;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List all known OTOBO package repsitories.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Listing OTOBO package repositories...</yellow>\n");

    my $Count = 0;
    my %List;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Package::RepositoryList') ) {
        %List = %{ $Kernel::OM->Get('Kernel::Config')->Get('Package::RepositoryList') };
    }
    %List = ( %List, $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineRepositories() );

    if ( !%List ) {
        $Self->PrintError("No package repositories configured.");
        return $Self->ExitCodeError();
    }

    for my $URL ( sort { $List{$a} cmp $List{$b} } keys %List ) {
        $Count++;
        print "+----------------------------------------------------------------------------+\n";
        print "| $Count) Name: $List{$URL}\n";
        print "|    URL:  $URL\n";
    }
    print "+----------------------------------------------------------------------------+\n";
    print "\n";

    $Self->Print("<yellow>Listing OTOBO package repository contents...</yellow>\n");

    for my $URL ( sort { $List{$a} cmp $List{$b} } keys %List ) {
        print
            "+----------------------------------------------------------------------------+\n";
        print "| Package Overview for Repository $List{$URL}:\n";
        my @Packages = $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineList(
            URL  => $URL,
            Lang => $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage'),
        );
        my $PackageCount = 0;
        PACKAGE:
        for my $Package (@Packages) {

            # Just show if PackageIsVisible flag is enabled.
            if (
                defined $Package->{PackageIsVisible}
                && !$Package->{PackageIsVisible}->{Content}
                )
            {
                next PACKAGE;
            }
            $PackageCount++;
            print
                "+----------------------------------------------------------------------------+\n";
            print "| $PackageCount) Name:        $Package->{Name}\n";
            print "|    Version:     $Package->{Version}\n";
            print "|    Vendor:      $Package->{Vendor}\n";
            print "|    URL:         $Package->{URL}\n";
            print "|    License:     $Package->{License}\n";
            print "|    Description: $Package->{Description}\n";
            print "|    Install:     $URL:$Package->{File}\n";
        }
        print
            "+----------------------------------------------------------------------------+\n";
        print "\n";
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
