# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package scripts::DBUpdateTo11_0::UninstallMergedPackages;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Package',
);

=head1 NAME

scripts::DBUpdateTo11_0::UninstallMergedPackages - Uninstalls code that was merged from packages into OTOBO.

=cut

use parent qw(scripts::DBUpdateTo11_0::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    # Purge relevant caches before uninstalling to avoid errors because of inconsistent states.
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    for my $Type (qw(RepositoryList RepositoryGet XMLParse)) {
        $CacheObject->CleanUp(
            Type => $Type,
        );
    }

    # Uninstall, without running DatabaseUninstall and CodeUninstall
    my @MergedPackages = qw(
        Ayte-CustomTranslations
        ExtendedCDBInfoTile
        ImportExport
        LightAdmin
        MarkTicketSeenUnseen
        QuickDateButtons
        ResponseTemplatesStatePreselection
        RotherOSS-LightAdmin
        RotherOSS-InternalTransitionActions
    );
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    PACKAGENAME:
    for my $PackageName (@MergedPackages) {
        my $Success = $PackageObject->_PackageUninstallMerged(
            Name => $PackageName,
        );

        next PACKAGENAME if $Success;

        print "\n    Error uninstalling package $PackageName\n\n";

        return;
    }

    return 1;
}

1;
