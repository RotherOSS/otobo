# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Znuny GmbH, https://znuny.org/
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

package scripts::DBUpdateTo11_0::UninstallMergedPackages;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use List::Util qw(uniq);

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
    # Get the complete list, irrespective of major or minor version
    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
    my @IntegratedPackages =
        uniq
        sort
        map { $_->@* }
        map { values $_->%* }                          # all minor versions
        map { values $_->%* }                          # all major versions
        ( $PackageObject->_GetIntegratedPackages );    # nested hashref

    PACKAGENAME:
    for my $PackageName (@IntegratedPackages) {
        my $Success = $PackageObject->_PackageUninstallMerged(
            Name => $PackageName,
        );

        if ( $PackageName eq 'Ayte-CustomTranslations' ) {

            # rename column 'import' to 'import_param'
            my @XMLStrings;
            push @XMLStrings, <<'END_XML';
<TableAlter Name="translation_item">
    <ColumnChange NameOld="import" NameNew="import_param" Required="false" Type="INTEGER" />
</TableAlter>
END_XML

            return unless $Self->ExecuteXMLDBArray(
                XMLArray => \@XMLStrings,
            );
        }

        next PACKAGENAME if $Success;

        print "\n    Error uninstalling package $PackageName\n\n";

        return;
    }

    return 1;
}

1;
