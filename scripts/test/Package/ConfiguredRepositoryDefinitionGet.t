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

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Make sure repository root setting is set to default for duration of the test.
my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
    Name    => 'Package::RepositoryRoot',
    Default => 1,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Package::RepositoryRoot',
    Value => $Setting{DefaultValue},
);

my @FrameworkVersionParts = split /\./, $Kernel::OM->Get('Kernel::Config')->Get('Version');
my $FrameworkVersion      = $FrameworkVersionParts[0];

my @Tests = (
    {
        Name           => 'No Repositories',
        ConfigSet      => {},
        Success        => 1,
        ExpectedResult => {
            'http://ftp.otobo.org/pub/otobo/packages/' => 'OTOBO Addons'
        },
    },
);

my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $ConfigKey     = 'Package::RepositoryList';

for my $Test (@Tests) {
    if ( $Test->{ConfigSet} ) {
        my $Success = $ConfigObject->Set(
            Key   => $ConfigKey,
            Value => $Test->{ConfigSet},
        );
        $Self->True(
            $Success,
            "$Test->{Name} configuration set in run time",
        );
    }

    my %RepositoryList = $PackageObject->_ConfiguredRepositoryDefinitionGet();

    $Self->IsDeeply(
        \%RepositoryList,
        $Test->{ExpectedResult},
        "$Test->{Name} _ConfiguredRepositoryDefinitionGet()",
    );
}


$Self->DoneTesting();


