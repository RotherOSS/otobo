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

package scripts::DBUpdateTo11_0::PackagePrepareITSMIncidentProblemManagement;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Package',
);

=head1 NAME

Updates ITSMIncidentProblemManagement to 11.0.0 containing no files, to prepare Upgrade of ITSMCore to the latest version

=cut

use parent qw(scripts::DBUpdateTo11_0::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    if ( !$PackageObject->PackageIsInstalled( Name => 'ITSMIncidentProblemManagement' ) ) {
        print "\t  ITSMIncidentProblemManagement is not installed - skipping.\n";
        return 1;
    }

    my $InstalledVersion;
    for my $Package ( $PackageObject->RepositoryList() ) {

        if ( $Package->{Name}->{Content} eq 'ITSMIncidentProblemManagement' ) {

            if ( $Package->{Status} =~ /^installed$/i ) {
                $InstalledVersion = $Package->{Version}->{Content};
            }
        }
    }

    $InstalledVersion =~ /^(\d+)\./;

    my $MajorVersion = $1;
    if ( !$MajorVersion ) {
        die "Could not determine major version of installed ITSMIncidentProblemManagement ($InstalledVersion)\n";
    }

    if ( $MajorVersion >= 11 ) {
        print "\t  ITSMIncidentProblemManagement version already is >= 11 - skipping.\n";
        return 1;
    }

    print "\t  Upgrading ITSMIncidentProblemManagement to temporary version 11.0.0.\n";

    return $PackageObject->PackageUpgrade(
        String => $Self->TemporaryPackageString(),
    );
}

sub TemporaryPackageString {
    my ( $Self, %Param ) = @_;

    return <<EOF
<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.0">
    <Name>ITSMIncidentProblemManagement</Name>
    <Version>11.0.0</Version>
    <Framework>11.0.x</Framework>
    <Vendor>Rother OSS GmbH</Vendor>
    <URL>https://otobo.io/</URL>
    <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
    <Description Lang="en">The OTOBO::ITSM Incident and Problem Management package.</Description>
</otobo_package>
EOF

}

1;
