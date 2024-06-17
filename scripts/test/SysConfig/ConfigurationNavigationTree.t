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

use vars (qw($Self));

use Kernel::Config;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

# Create a code scope to be able to redefine a function safely
{
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::SysConfig', 'Kernel::System::SysConfig::DB' ],
    );

    # Redefine ConfigurationCategoriesGet to be able to use fake category Sample, with this we don't
    #   need to delete the tables and we can use this category for the tests. this needs to be
    #   redefine only locally otherwise the rest of the test will be affected.
    local *Kernel::System::SysConfig::ConfigurationCategoriesGet = sub {
        return (
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTOBO => {
                DisplayName => 'OTOBO',
                Files       => [
                    'Calendar.xml',         'CloudServices.xml',     'Daemon.xml', 'Framework.xml',
                    'GenericInterface.xml', 'ProcessManagement.xml', 'Ticket.xml',
                ],
            },
            Sample => {
                DisplayName => 'Sample',
                Files       => ['Sample.xml'],
            },
        );
    };

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Load setting from sample XML file
    my $LoadSuccess = $SysConfigObject->ConfigurationXML2DB(
        UserID    => 1,
        Directory => "$ConfigObject->{Home}/scripts/test/sample/SysConfig/XML/",
    );
    $Self->True(
        $LoadSuccess,
        "Load settings from Sample.xml."
    );

    # Basic tests
    my @Tests = (
        {
            Description => 'Test #1',
            Config      => {
                Category => 'Sample',
            },
            ExpectedResult => {
                'Core' => {
                    'Count'    => 0,
                    'Subitems' => {
                        'Core::CustomerUser' => {
                            'Subitems' => {},
                            'Count'    => 4,
                        },
                        'Core::Ticket' => {
                            'Subitems' => {},
                            'Count'    => 3,
                        },
                    },
                },
                'Frontend' => {
                    'Count'    => 0,
                    'Subitems' => {
                        'Frontend::Agent' => {
                            'Count'    => 0,
                            'Subitems' => {
                                'Frontend::Agent::Dashboard' => {
                                    'Subitems' => {},
                                    'Count'    => 1,
                                },
                                'Frontend::Agent::ModuleRegistration' => {
                                    'Subitems' => {},
                                    'Count'    => 2,
                                },
                                'Frontend::Agent::Ticket' => {
                                    'Count'    => 0,
                                    'Subitems' => {
                                        'Frontend::Agent::Ticket::ViewPriority' => {
                                            'Subitems' => {},
                                            'Count'    => 3,
                                        },
                                        'Frontend::Agent::Ticket::ViewResponsible' => {
                                            'Subitems' => {},
                                            'Count'    => 1,
                                        },
                                    },
                                },
                            },
                        },
                        'Frontend::Agentß∂čćžšđ' => {
                            'Count'    => 0,
                            'Subitems' => {
                                'Frontend::Agentß∂čćžšđ::ModuleRegistration' => {
                                    'Subitems' => {},
                                    'Count'    => 1,
                                },
                            },
                        },
                    },
                },
            },
        },
        {
            Description => 'Test #2',
            Config      => {
                Category       => 'Sample',
                RootNavigation => 'Frontend::Agent',
            },
            ExpectedResult => {
                'Frontend::Agent::Dashboard' => {
                    'Subitems' => {},
                    'Count'    => 1,
                },
                'Frontend::Agent::ModuleRegistration' => {
                    'Subitems' => {},
                    'Count'    => 2,
                },
                'Frontend::Agent::Ticket' => {
                    'Count'    => 0,
                    'Subitems' => {
                        'Frontend::Agent::Ticket::ViewPriority' => {
                            'Subitems' => {},
                            'Count'    => 3,
                        },
                        'Frontend::Agent::Ticket::ViewResponsible' => {
                            'Subitems' => {},
                            'Count'    => 1,
                        },
                    },
                },
            },
        },
        {
            Description => 'Test #3',
            Config      => {
                Category       => 'Sample',
                RootNavigation => 'Frontend::Agentß∂čćžšđ',
            },
            ExpectedResult => {
                'Frontend::Agentß∂čćžšđ::ModuleRegistration' => {
                    'Subitems' => {},
                    'Count'    => 1,
                },
            },
        },
    );

    for my $Test (@Tests) {
        my %Result = $SysConfigObject->ConfigurationNavigationTree( %{ $Test->{Config} } );

        $Self->IsDeeply(
            \%Result,
            $Test->{ExpectedResult},
            $Test->{Description} . ': ConfigurationNavigationTree(): Result must match expected one.',
        );
    }
}

# Outside of the code scope be sure to discard affected objects, so they can load again normally
$Kernel::OM->ObjectsDiscard(
    Objects => [ 'Kernel::System::SysConfig', 'Kernel::System::SysConfig::DB' ],
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $String = '<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.0">
  <Name>TestPackage1</Name>
  <Version>0.0.1</Version>
  <Vendor>Rother OSS GmbH</Vendor>
  <URL>https://otobo.io/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
  <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="644" Encode="Base64">PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiID8+DQo8b3RvYm9fY29uZmlnIHZlcnNpb249IjIuMCIgaW5pdD0iQXBwbGljYXRpb24iPg0KICAgIDxTZXR0aW5nIE5hbWU9IlRlc3RQYWNrYWdlMTo6U2V0dGluZzEiIFJlcXVpcmVkPSIwIiBWYWxpZD0iMSI+DQogICAgICAgIDxEZXNjcmlwdGlvbiBUcmFuc2xhdGFibGU9IjEiPlRlc3QgU2V0dGluZy48L0Rlc2NyaXB0aW9uPg0KICAgICAgICA8TmF2aWdhdGlvbj5Db3JlOjpUZXN0UGFja2FnZTwvTmF2aWdhdGlvbj4NCiAgICAgICAgPFZhbHVlPg0KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJTdHJpbmciPjwvSXRlbT4NCiAgICAgICAgPC9WYWx1ZT4NCiAgICA8L1NldHRpbmc+DQogICAgPFNldHRpbmcgTmFtZT0iVGVzdFBhY2thZ2UxOjpTZXR0aW5nMiIgUmVxdWlyZWQ9IjAiIFZhbGlkPSIxIj4NCiAgICAgICAgPERlc2NyaXB0aW9uIFRyYW5zbGF0YWJsZT0iMSI+VGVzdCBTZXR0aW5nLjwvRGVzY3JpcHRpb24+DQogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlOjpPdGhlcjwvTmF2aWdhdGlvbj4NCiAgICAgICAgPFZhbHVlPg0KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJTdHJpbmciPjwvSXRlbT4NCiAgICAgICAgPC9WYWx1ZT4NCiAgICA8L1NldHRpbmc+DQogICAgPFNldHRpbmcgTmFtZT0iVGVzdFBhY2thZ2UxOjpTZXR0aW5nMyIgUmVxdWlyZWQ9IjEiIFZhbGlkPSIwIj4NCiAgICAgICAgPERlc2NyaXB0aW9uIFRyYW5zbGF0YWJsZT0iMSI+VGVzdCBTZXR0aW5nLjwvRGVzY3JpcHRpb24+DQogICAgICAgIDxOYXZpZ2F0aW9uPkNvcmU6OlRlc3RQYWNrYWdlOjpPdGhlcjwvTmF2aWdhdGlvbj4NCiAgICAgICAgPFZhbHVlPg0KICAgICAgICAgICAgPEl0ZW0gVmFsdWVUeXBlPSJFbnRpdHkiIFZhbHVlRW50aXR5VHlwZT0iVHlwZSIgVHJhbnNsYXRhYmxlPSIxIj5VbmNsYXNzaWZpZWQ8L0l0ZW0+DQogICAgICAgIDwvVmFsdWU+DQogICAgPC9TZXR0aW5nPg0KPC9vdG9ib19jb25maWc+DQo=</File>
  </Filelist>
</otobo_package>
';

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

my $PackageName = "TestPackage1";
if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
    my $PackagUninstall = $PackageObject->PackageUninstall( String => $String );

    $Self->True(
        $PackagUninstall,
        "$PackagUninstall() $PackageName",
    );
}

my $PackageInstall = $PackageObject->PackageInstall( String => $String );
$Self->True(
    $PackageInstall,
    "PackageInstall() $PackageName",
);

# tests after Package Installation
my @Tests = (
    {
        Description => "Test #P1 - Category $PackageName",
        Config      => {
            Category => $PackageName,
        },
        ExpectedResult => {
            'Core' => {
                'Count'    => 0,
                'Subitems' => {
                    'Core::TestPackage' => {
                        'Count'    => 1,
                        'Subitems' => {
                            'Core::TestPackage::Other' => {
                                'Subitems' => {},
                                'Count'    => 2,
                            },
                        },
                    },
                },
            },
        },
    },
    {
        Description => 'Test #P2 - IsValid=0',
        Config      => {
            Category => $PackageName,
            IsValid  => 0,
        },
        ExpectedResult => {
            'Core' => {
                'Count'    => 0,
                'Subitems' => {
                    'Core::TestPackage' => {
                        'Count'    => 0,
                        'Subitems' => {
                            'Core::TestPackage::Other' => {
                                'Subitems' => {},
                                'Count'    => 1,
                            },
                        },
                    },
                },
            },
        },
    },
);

for my $Test (@Tests) {
    my %Result = $SysConfigObject->ConfigurationNavigationTree( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \%Result,
        $Test->{ExpectedResult},
        $Test->{Description} . ': ConfigurationNavigationTree()',
    );
}

if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
    my $PackagUninstall = $PackageObject->PackageUninstall( String => $String );

    $Self->True(
        $PackagUninstall,
        "PackagUninstall() $PackageName",
    );
}

$Self->DoneTesting();
