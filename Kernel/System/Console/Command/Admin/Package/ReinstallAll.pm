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

package Kernel::System::Console::Command::Admin::Package::ReinstallAll;

use strict;
use warnings;
use v5.24;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Reinstall all OTOBO packages that are not correctly deployed.');
    $Self->AddOption(
        Name        => 'force',
        Description => 'Force package reinstallation even if validation fails.',
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'hide-deployment-info',
        Description => 'Hide package and files status (package deployment info).',
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $HideDeploymentInfoOption = $Self->GetOption('hide-deployment-info') || 0;

    $Self->Print("<yellow>Reinstalling all OTOBO packages that are not correctly deployed...</yellow>\n");

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Enable in-memory cache to improve SysConfig performance, which is normally disabled for commands.
    $CacheObject->Configure(
        CacheInMemory => 1,
    );

    my @ReinstalledPackages;

    # loop all locally installed packages
    for my $Package ( $Kernel::OM->Get('Kernel::System::Package')->RepositoryList() ) {

        # do a deploy check to see if reinstallation is needed
        my $CorrectlyDeployed = $Kernel::OM->Get('Kernel::System::Package')->DeployCheck(
            Name    => $Package->{Name}->{Content},
            Version => $Package->{Version}->{Content},
            Log     => $HideDeploymentInfoOption ? 0 : 1,
        );

        if ( !$CorrectlyDeployed ) {

            push @ReinstalledPackages, $Package->{Name}->{Content};

            my $FileString = $Kernel::OM->Get('Kernel::System::Package')->RepositoryGet(
                Name    => $Package->{Name}->{Content},
                Version => $Package->{Version}->{Content},
            );

            my $Success = $Kernel::OM->Get('Kernel::System::Package')->PackageReinstall(
                String => $FileString,
                Force  => $Self->GetOption('force'),
            );

            if ( !$Success ) {
                $Self->PrintError("Package $Package->{Name}->{Content} could not be reinstalled.\n");
                return $Self->ExitCodeError();
            }
        }
    }

    if (@ReinstalledPackages) {
        $Self->Print( "<green>" . scalar(@ReinstalledPackages) . " package(s) reinstalled.</green>\n" );
    }
    else {
        $Self->Print("<green>No packages needed reinstallation.</green>\n");
    }

    # Disable in memory cache.
    $CacheObject->Configure(
        CacheInMemory => 0,
    );

    return $Self->ExitCodeOk();
}

1;
