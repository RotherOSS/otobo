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

use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Version',
    Value => '5.0.21',
);

my @InstalledITSM5017 = (
    {
        Name    => 'ImportExport',
        Version => '5.0.17',
    },
    {
        Name    => 'GeneralCatalog',
        Version => '5.0.17',
    },
    {
        Name    => 'ITSMChangeManagement',
        Version => '5.0.17',
    },
    {
        Name    => 'ITSMConfigurationManagement',
        Version => '5.0.17',
    },
    {
        Name    => 'ITSMCore',
        Version => '5.0.17',
    },
    {
        Name    => 'ITSMIncidentProblemManagement',
        Version => '5.0.17',
    },
    {
        Name    => 'ITSMServiceLevelManagement',
        Version => '5.0.17',
    },
);

my @OnlineITSM5021 = (
    {
        Name    => 'ImportExport',
        Version => '5.0.21',
    },
    {
        Name    => 'GeneralCatalog',
        Version => '5.0.21',
    },
    {
        Name            => 'ITSMChangeManagement',
        Version         => '5.0.21',
        PackageRequired => [
            {
                Version => '5.0.21',
                Content => 'ITSMCore',
            },
        ],
    },
    {
        Name            => 'ITSMConfigurationManagement',
        Version         => '5.0.21',
        PackageRequired => [
            {
                Version => '5.0.21',
                Content => 'ITSMCore',
            },
        ],
    },
    {
        Name            => 'ITSMCore',
        Version         => '5.0.21',
        PackageRequired => [
            {
                Version => '5.0.21',
                Content => 'GeneralCatalog',
            },
        ],
    },
    {
        Name            => 'ITSMIncidentProblemManagement',
        Version         => '5.0.21',
        PackageRequired => [
            {
                Version => '5.0.21',
                Content => 'ITSMCore',
            },
        ],
    },
    {
        Name            => 'ITSMServiceLevelManagement',
        Version         => '5.0.21',
        PackageRequired => [
            {
                Version => '5.0.21',
                Content => 'ITSMCore',
            },
        ],
    },
);

my @InstalledPublic501 = (
    {
        Name    => 'FAQ',
        Version => '5.0.1',
    },
    {
        Name    => 'Fred',
        Version => '5.0.1',
    },
    {
        Name    => 'OTOBOAppointmentCalendar',
        Version => '5.0.1',
    },
    {
        Name    => 'OTOBOCloneDB',
        Version => '5.0.1',
    },
    {
        Name    => 'OTOBOCodePolicy',
        Version => '5.0.1',
    },
    {
        Name    => 'OTOBOMasterSlave',
        Version => '5.0.1',
    },
    {
        Name    => 'Survey',
        Version => '5.0.1',
    },
    {
        Name    => 'SystemMonitoring',
        Version => '5.0.1',
    },
    {
        Name    => 'TimeAccounting',
        Version => '5.0.1',
    }
);

my @OnlinePublic502 = (
    {
        Name    => 'FAQ',
        Version => '5.0.2',
    },
    {
        Name    => 'Fred',
        Version => '5.0.2'
    },
    {
        Name    => 'OTOBOAppointmentCalendar',
        Version => '5.0.2',
    },
    {
        Name    => 'OTOBOCloneDB',
        Version => '5.0.2',
    },
    {
        Name    => 'OTOBOCodePolicy',
        Version => '5.0.2',
    },
    {
        Name    => 'OTOBOMasterSlave',
        Version => '5.0.2',
    },
    {
        Name    => 'Survey',
        Version => '5.0.2',
    },
    {
        Name    => 'SystemMonitoring',
        Version => '5.0.2',
    },
    {
        Name    => 'TimeAccounting',
        Version => '5.0.2',
    }
);

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing InstalledPackages',
        Config => {
            OnlinePackages => [
                {
                    Name    => 'ImportExport',
                    Version => '5.0.21',
                },
            ],
        },
        Success => 0,
    },
    {
        Name   => 'Missing OnlinePackages',
        Config => {
            InstalledPackages => [
                {
                    Name    => 'ImportExport',
                    Version => '5.0.17',
                },
            ],
        },
        Success => 0,
    },
    {
        Name   => 'Wrong InstalledPackages',
        Config => {
            InstalledPackages => '',
            OnlinePackages    => [
                {
                    Name    => 'ImportExport',
                    Version => '5.0.21',
                },
            ],
        },
        Success => 0,
    },
    {
        Name   => 'Wrong OnlinePackages',
        Config => {
            InstalledPackages => [
                {
                    Name    => 'ImportExport',
                    Version => '5.0.17',
                },
            ],
            OnlinePackages => '',
        },
        Success => 0,
    },
    {
        Name   => 'ITSM 5.0.17 to 5.0.21',
        Config => {
            InstalledPackages => \@InstalledITSM5017,
            OnlinePackages    => \@OnlineITSM5021,
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                  => 1,
                GeneralCatalog                => 6,
                ITSMChangeManagement          => 1,
                ITSMConfigurationManagement   => 1,
                ITSMCore                      => 5,
                ITSMIncidentProblemManagement => 1,
                ITSMServiceLevelManagement    => 1,
            },
            Failed => {},
        },
    },
    {
        Name   => 'Public 5.0.1 to 5.0.2',
        Config => {
            InstalledPackages => \@InstalledPublic501,
            OnlinePackages    => \@OnlinePublic502,
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                FAQ                      => 1,
                Fred                     => 1,
                OTOBOAppointmentCalendar => 1,
                OTOBOCloneDB             => 1,
                OTOBOCodePolicy          => 1,
                OTOBOMasterSlave         => 1,
                Survey                   => 1,
                SystemMonitoring         => 1,
                TimeAccounting           => 1,
            },
            Failed => {},
        },
    },
    {
        Name   => 'OTOBOGenericInterfaceITSMConfigurationManagement',
        Config => {
            InstalledPackages => [
                @InstalledITSM5017,
                (
                    {
                        Name    => 'OTOBOGenericInterfaceITSMConfigurationManagement',
                        Version => '5.0.1',
                    },
                ),
            ],
            OnlinePackages => [
                @OnlineITSM5021,
                (
                    {
                        Name            => 'OTOBOGenericInterfaceITSMConfigurationManagement',
                        Version         => '5.0.21',
                        PackageRequired => [
                            {
                                Version => '5.0.21',
                                Content => 'ITSMConfigurationManagement',
                            },
                        ],
                    },
                ),

            ],
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                                     => 1,
                GeneralCatalog                                   => 7,
                ITSMChangeManagement                             => 1,
                ITSMConfigurationManagement                      => 2,
                ITSMCore                                         => 6,
                ITSMIncidentProblemManagement                    => 1,
                ITSMServiceLevelManagement                       => 1,
                OTOBOGenericInterfaceITSMConfigurationManagement => 1,
            },
            Failed => {},
        },
    },

    {
        Name   => 'OTOBOITSMConfigItemReference',
        Config => {
            InstalledPackages => [
                @InstalledITSM5017,
                (
                    {
                        Name    => 'OTOBOITSMConfigItemReference',
                        Version => '5.0.1',
                    },
                ),
            ],
            OnlinePackages => [
                @OnlineITSM5021,
                (
                    {
                        Name            => 'OTOBOITSMConfigItemReference',
                        Version         => '5.0.21',
                        PackageRequired => [
                            {
                                Version => '5.0.20',
                                Content => 'ITSMConfigurationManagement',
                            },
                            {
                                Version => '5.0.19',
                                Content => 'ImportExport',
                            },

                        ],
                    },
                ),

            ],
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                  => 2,
                GeneralCatalog                => 7,
                ITSMChangeManagement          => 1,
                ITSMConfigurationManagement   => 2,
                ITSMCore                      => 6,
                ITSMIncidentProblemManagement => 1,
                ITSMServiceLevelManagement    => 1,
                OTOBOITSMConfigItemReference  => 1,
            },
            Failed => {},
        },
    },

    {
        Name   => 'Not Found',
        Config => {
            InstalledPackages => [
                @InstalledITSM5017,
                (
                    {
                        Name    => 'OTOBOGenericInterfaceITSMConfigurationManagement',
                        Version => '5.0.1',
                    },
                ),
            ],
            OnlinePackages => \@OnlineITSM5021,
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                  => 1,
                GeneralCatalog                => 6,
                ITSMChangeManagement          => 1,
                ITSMConfigurationManagement   => 1,
                ITSMCore                      => 5,
                ITSMIncidentProblemManagement => 1,
                ITSMServiceLevelManagement    => 1,
            },
            Failed => {
                NotFound => {
                    OTOBOGenericInterfaceITSMConfigurationManagement => 1
                },
            },
        },
    },
    {
        Name   => 'WrongVersion',
        Config => {
            InstalledPackages => [
                @InstalledITSM5017,
                (
                    {
                        Name    => 'Test',
                        Version => '5.0.21',
                    },
                ),
            ],
            OnlinePackages => [
                @OnlineITSM5021,
                (
                    {
                        Name    => 'Test',
                        Version => '5.0.20',
                    },
                ),
            ],
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                  => 1,
                GeneralCatalog                => 6,
                ITSMChangeManagement          => 1,
                ITSMConfigurationManagement   => 1,
                ITSMCore                      => 5,
                ITSMIncidentProblemManagement => 1,
                ITSMServiceLevelManagement    => 1,
            },
            Failed => {
                WrongVersion => {
                    Test => 1,
                },
            },
        },
    },

    {
        Name   => 'WrongVersion Dependency',
        Config => {
            InstalledPackages => [
                @InstalledITSM5017,
                (
                    {
                        Name    => 'Test',
                        Version => '5.0.1',
                    },
                ),
            ],
            OnlinePackages => [
                @OnlineITSM5021,
                (
                    {
                        Name            => 'Test',
                        Version         => '5.0.21',
                        PackageRequired => [
                            {
                                Version => '5.0.22',
                                Content => 'ITSMConfigurationManagement',
                            },
                        ],
                    },
                ),
            ],
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                  => 1,
                GeneralCatalog                => 6,
                ITSMChangeManagement          => 1,
                ITSMConfigurationManagement   => 1,
                ITSMCore                      => 5,
                ITSMIncidentProblemManagement => 1,
                ITSMServiceLevelManagement    => 1,
            },
            Failed => {
                DependencyFail => {
                    Test => 1,
                },
                WrongVersion => {
                    ITSMConfigurationManagement => 1,
                },
            },
        },
    },
    {
        Name   => 'NotFound Dependency',
        Config => {
            InstalledPackages => [
                @InstalledITSM5017,
                (
                    {
                        Name    => 'Test',
                        Version => '5.0.1',
                    },
                ),
            ],
            OnlinePackages => [
                @OnlineITSM5021,
                (
                    {
                        Name            => 'Test',
                        Version         => '5.0.21',
                        PackageRequired => [
                            {
                                Version => '5.0.22',
                                Content => 'Test2',
                            },
                        ],
                    },
                ),

            ],
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                  => 1,
                GeneralCatalog                => 6,
                ITSMChangeManagement          => 1,
                ITSMConfigurationManagement   => 1,
                ITSMCore                      => 5,
                ITSMIncidentProblemManagement => 1,
                ITSMServiceLevelManagement    => 1,
            },
            Failed => {
                DependencyFail => {
                    Test => 1,
                },
                NotFound => {
                    Test2 => 1,
                },
            },
        },
    },
    {
        Name   => 'Cyclic Dependency',
        Config => {
            InstalledPackages => [
                @InstalledITSM5017,
                (
                    {
                        Name    => 'Test',
                        Version => '5.0.1',
                    },
                    {
                        Name    => 'Test2',
                        Version => '5.0.1',
                    },
                ),
            ],
            OnlinePackages => [
                @OnlineITSM5021,
                (
                    {
                        Name            => 'Test',
                        Version         => '5.0.21',
                        PackageRequired => [
                            {
                                Version => '5.0.21',
                                Content => 'Test2',
                            },
                        ],
                    },
                    {
                        Name            => 'Test2',
                        Version         => '5.0.21',
                        PackageRequired => [
                            {
                                Version => '5.0.21',
                                Content => 'Test',
                            },
                        ],
                    },
                ),
            ],
        },
        Success        => 1,
        ExpectedResult => {
            InstallOrder => {
                ImportExport                  => 1,
                GeneralCatalog                => 6,
                ITSMChangeManagement          => 1,
                ITSMConfigurationManagement   => 1,
                ITSMCore                      => 5,
                ITSMIncidentProblemManagement => 1,
                ITSMServiceLevelManagement    => 1,
            },
            Failed => {
                DependencyFail => {
                    Test  => 1,
                    Test2 => 1,
                },
                Cyclic => {
                    Test  => 1,
                    Test2 => 1,
                },
            },
        },
    },
);

TEST:
for my $Test (@Tests) {

    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Package'],
    );

    my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

    my %Result = $PackageObject->PackageInstallOrderListGet( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->IsDeeply(
            \%Result,
            {},
            "$Test->{Name} - PackageInstallOrderListGet()",
        );
        next TEST;
    }

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        "$Test->{Name} - PackageInstallOrderListGet()",
    );

}
continue {
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::Package'],
    );
}

$Self->DoneTesting();
