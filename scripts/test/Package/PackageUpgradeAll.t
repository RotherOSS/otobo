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

# core modules

# CPAN modules
use Test2::V0;
use Test2::Tools::Compare qw(array D);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');    ## no critic qw(Variables::ProhibitUnusedVarsStricter)

my $Cleanup = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE from package_repository',
);
ok( $Cleanup, "Removed possibly pre-existing packages from the database (transaction)." );

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$ConfigObject->Set(
    Key   => 'Package::RepositoryList',
    Value => {
        local => 'local',
    },
);
$ConfigObject->Set(
    Key   => 'Package::RepositoryRoot',
    Value => [],
);
$ConfigObject->Set(
    Key   => 'Version',
    Value => '6.0.2',
);

my @OrigPackageInstalledList = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList(    # do not create object instance
    Result => 'short',
);
my %OrigInstalledList = map { $_->{Name} => $_->{Version} } @OrigPackageInstalledList;

my $Home     = $ConfigObject->Get('Home');
my $TestPath = "$Home/scripts/test/sample/PackageManager/PackageUpgradeAll";

my @Tests = (
    {
        Name            => 'ITSM 6.0.1 to 6.0.20',
        InstallPackages => [
            'TestGeneralCatalog-6.0.1.opm',
            'TestImportExport-6.0.1.opm',
            'TestITSMCore-6.0.1.opm',
            'TestITSMChangeManagement-6.0.1.opm',
            'TestITSMConfigurationManagement-6.0.1.opm',
            'TestITSMIncidentProblemManagement-6.0.1.opm',
            'TestITSMServiceLevelManagement-6.0.1.opm',
        ],
        RepositoryListBefore => {
            TestGeneralCatalog                => '6.0.1',
            TestImportExport                  => '6.0.1',
            TestITSMCore                      => '6.0.1',
            TestITSMIncidentProblemManagement => '6.0.1',
            TestITSMConfigurationManagement   => '6.0.1',
            TestITSMChangeManagement          => '6.0.1',
            TestITSMServiceLevelManagement    => '6.0.1',
        },
        PackageOnlineList => 'PackageOnlineListITSM620.asc',
        ExpectedResult    => {
            Success        => 1,
            AlreadyUpdated => {},
            Failed         => {},
            Installed      => {},
            Undeployed     => {},
            Updated        => {
                TestGeneralCatalog                => 1,
                TestImportExport                  => 1,
                TestITSMCore                      => 1,
                TestITSMIncidentProblemManagement => 1,
                TestITSMConfigurationManagement   => 1,
                TestITSMChangeManagement          => 1,
                TestITSMServiceLevelManagement    => 1,
            },
        },
        RepositoryListAfter => {
            TestGeneralCatalog                => '6.0.20',
            TestImportExport                  => '6.0.20',
            TestITSMCore                      => '6.0.20',
            TestITSMIncidentProblemManagement => '6.0.20',
            TestITSMConfigurationManagement   => '6.0.20',
            TestITSMChangeManagement          => '6.0.20',
            TestITSMServiceLevelManagement    => '6.0.20',
        },
    },
    {
        Name            => 'ITSM 6.0.1 to 6.0.20 (New dependencies)',
        InstallPackages => [
            'TestImportExport-6.0.1.opm',
            'TestITSMChangeManagement-NoDep-6.0.1.opm',
            'TestITSMConfigurationManagement-NoDep-6.0.1.opm',
            'TestITSMIncidentProblemManagement-NoDep-6.0.1.opm',
            'TestITSMServiceLevelManagement-NoDep-6.0.1.opm',
        ],
        RepositoryListBefore => {
            TestImportExport                  => '6.0.1',
            TestITSMIncidentProblemManagement => '6.0.1',
            TestITSMConfigurationManagement   => '6.0.1',
            TestITSMChangeManagement          => '6.0.1',
            TestITSMServiceLevelManagement    => '6.0.1',
        },
        PackageOnlineList => 'PackageOnlineListITSM620.asc',
        ExpectedResult    => {
            Success        => 1,
            AlreadyUpdated => {},
            Failed         => {},
            Installed      => {
                TestGeneralCatalog => 1,
                TestITSMCore       => 1,
            },
            Undeployed => {},
            Updated    => {
                TestImportExport                  => 1,
                TestITSMIncidentProblemManagement => 1,
                TestITSMConfigurationManagement   => 1,
                TestITSMChangeManagement          => 1,
                TestITSMServiceLevelManagement    => 1,
            },
        },
        RepositoryListAfter => {
            TestGeneralCatalog                => '6.0.20',
            TestImportExport                  => '6.0.20',
            TestITSMCore                      => '6.0.20',
            TestITSMIncidentProblemManagement => '6.0.20',
            TestITSMConfigurationManagement   => '6.0.20',
            TestITSMChangeManagement          => '6.0.20',
            TestITSMServiceLevelManagement    => '6.0.20',
        },
    },
    {
        Name            => 'ITSM 6.0.1 to 6.0.20 (Missing dependencies)',
        InstallPackages => [
            'TestGeneralCatalog-6.0.1.opm',
            'TestImportExport-6.0.1.opm',
            'TestITSMCore-6.0.1.opm',
            'TestITSMChangeManagement-6.0.1.opm',
            'TestITSMConfigurationManagement-6.0.1.opm',
            'TestITSMIncidentProblemManagement-6.0.1.opm',
            'TestITSMServiceLevelManagement-6.0.1.opm',
        ],
        RepositoryListBefore => {
            TestGeneralCatalog                => '6.0.1',
            TestImportExport                  => '6.0.1',
            TestITSMCore                      => '6.0.1',
            TestITSMIncidentProblemManagement => '6.0.1',
            TestITSMConfigurationManagement   => '6.0.1',
            TestITSMChangeManagement          => '6.0.1',
            TestITSMServiceLevelManagement    => '6.0.1',
        },
        PackageOnlineList => 'PackageOnlineListITSM620MissingITSMCore.asc',
        ExpectedResult    => {
            Success        => 0,
            AlreadyUpdated => {},
            Failed         => {
                NotFound => {
                    TestITSMCore => 1,
                },
                DependencyFail => {
                    TestITSMChangeManagement          => 1,
                    TestITSMConfigurationManagement   => 1,
                    TestITSMIncidentProblemManagement => 1,
                    TestITSMServiceLevelManagement    => 1,
                },
            },
            Installed  => {},
            Undeployed => {},
            Updated    => {
                TestGeneralCatalog => 1,
                TestImportExport   => 1,
            },
        },
        RepositoryListAfter => {
            TestGeneralCatalog                => '6.0.20',
            TestImportExport                  => '6.0.20',
            TestITSMCore                      => '6.0.1',
            TestITSMIncidentProblemManagement => '6.0.1',
            TestITSMConfigurationManagement   => '6.0.1',
            TestITSMChangeManagement          => '6.0.1',
            TestITSMServiceLevelManagement    => '6.0.1',
        },
    },
);

for my $Test (@Tests) {

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # Install base packages.
    PACKAGENAME:
    for my $PackageName ( @{ $Test->{InstallPackages} } ) {

        my $Location = "$TestPath/$PackageName";

        my $FileString;

        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'utf8',
            Result   => 'SCALAR',
        );
        if ($ContentRef) {
            $FileString = ${$ContentRef};
        }
        ok( $FileString, "FileRead() - for package $PackageName" );

        my $Success = $PackageObject->PackageInstall(
            String => $FileString,
            Force  => 1,
        );
        ok( $Success, "PackageInstall() - for package $PackageName" );
    }

    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Package'],
    );

    # Redefine key features to prevent real network communications and use local results for this test.
    no warnings qw(once redefine);    ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
    local *Kernel::System::Package::PackageOnlineList = sub {
        return do "$TestPath/$Test->{PackageOnlineList}";
    };
    local *Kernel::System::Package::PackageOnlineGet = sub {
        my ( $Self, %Param ) = @_;

        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => "$TestPath/$Param{File}",
            Mode     => 'utf8',
            Result   => 'SCALAR',
        );

        return ${$ContentRef};
    };
    use warnings;

    # Recreate objects with the redefined functions.
    $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    # Check current installed packages
    my @PackageInstalledList = $PackageObject->RepositoryList(
        Result => 'short',
    );
    my %InstalledList = map { $_->{Name} => $_->{Version} } grep { !defined $OrigInstalledList{ $_->{Name} } } @PackageInstalledList;
    is(
        \%InstalledList,
        $Test->{RepositoryListBefore},
        'RepositoryList() - before upgrade',
    );

    my %Result = $PackageObject->PackageUpgradeAll();
    is(
        \%Result,
        $Test->{ExpectedResult},
        'PackageUpgradeAll() - result',
    );

    # Check installed packages after upgrade
    @PackageInstalledList = $PackageObject->RepositoryList(
        Result => 'short',
    );
    %InstalledList = map { $_->{Name} => $_->{Version} } grep { !defined $OrigInstalledList{ $_->{Name} } } @PackageInstalledList;
    is(
        \%InstalledList,
        $Test->{RepositoryListAfter},
        'RepositoryList() - after upgrade',
    );

    # Here dependencies doesn't matter as we will remove all added packages
    for my $PackageName ( sort keys %{ $Test->{RepositoryListAfter} } ) {
        my $PackageVersion = $Test->{RepositoryListAfter}->{$PackageName};
        my $Success        = $PackageObject->RepositoryRemove(
            Name    => $PackageName,
            Version => $PackageVersion,
        );
        ok( $Success, "RepositoryRemove() - $PackageName $PackageVersion" );
    }

}
continue {
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Package'],
    );
}

# sanity test of the internal method _GetIntegratedPackages
my $IntegratedPackages = $Kernel::OM->Get('Kernel::System::Package')->_GetIntegratedPackages;
like(
    $IntegratedPackages,
    {
        11 => {
            0 => array { item D(); },    # at least one item, must be defined
        }
    },
    'list of integrated packages',
);

done_testing;
