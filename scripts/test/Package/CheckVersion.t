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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get package object
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

my @Tests = (

    # test invalid type
    {
        VersionNew       => '1.0.1',
        VersionInstalled => '1.0.2',
        Type             => 'Something',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0.1',
        Type             => 'Something',
        ExternalPackage  => 0,
        Result           => 0,
    },

    # minimum tests
    {
        VersionNew       => '1.0.1',
        VersionInstalled => '1.0.2',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.1',
        VersionInstalled => '1.5.2.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.9.1',
        VersionInstalled => '1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.3.5',
        VersionInstalled => '1.3.4',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.3.99',
        VersionInstalled => '1.3.0',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '100.100.100',
        VersionInstalled => '99.100.100',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '999.1000.1000',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.999.1000',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.1000.999',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '9999.9999.9999.9999',
        VersionInstalled => '9999.9999.9999.9998',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.1.999',
        VersionInstalled => '1.0.1.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.0.999',
        VersionInstalled => '1.0.0.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.1.5',
        VersionInstalled => '1.1.4.1',
        Type             => 'Min',
        ExternalPackage  => 0,
        Result           => 0,
    },

    # maximum tests
    {
        VersionNew       => '1.0.1',
        VersionInstalled => '1.0.2',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.2',
        VersionInstalled => '1.0.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0',
        VersionInstalled => '1.0.2',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.1',
        VersionInstalled => '1.5.2.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 0,
    },
    {
        VersionNew       => '1.0.9.1',
        VersionInstalled => '1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.3.5',
        VersionInstalled => '1.3.4',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.3.99',
        VersionInstalled => '1.3.0',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '100.100.100',
        VersionInstalled => '99.100.100',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '999.1000.1000',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.999.1000',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1000.1000.1000',
        VersionInstalled => '1000.1000.999',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '9999.9999.9999.9999',
        VersionInstalled => '9999.9999.9999.9998',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.1.2',
        VersionInstalled => '1.0.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.1.999',
        VersionInstalled => '1.0.1.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.0.0.999',
        VersionInstalled => '1.0.0.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
    {
        VersionNew       => '1.1.5',
        VersionInstalled => '1.1.4.1',
        Type             => 'Max',
        ExternalPackage  => 0,
        Result           => 1,
    },
);

for my $Test (@Tests) {

    my $VersionCheck = $PackageObject->_CheckVersion(
        VersionNew       => $Test->{VersionNew},
        VersionInstalled => $Test->{VersionInstalled},
        Type             => $Test->{Type},
    );

    my $Name = "_CheckVersion() - $Test->{Type} ($Test->{VersionNew}:$Test->{VersionInstalled})";

    if ( $Test->{Result} ) {
        $Self->True(
            $VersionCheck,
            $Name,
        );
    }
    else {
        $Self->True(
            !$VersionCheck,
            $Name,
        );
    }
}

$Self->DoneTesting();
