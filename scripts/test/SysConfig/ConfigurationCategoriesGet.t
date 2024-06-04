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

## nofilter(TidyAll::Plugin::OTOBO::Perl::TestSubs)
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

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
    <File Location="Kernel/Config/Files/XML/TestPackage1.xml" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otobo_package>
';

my $String2 = '<?xml version="1.0" encoding="utf-8" ?>
<otobo_package version="1.0">
  <Name>TestPackage2</Name>
  <Version>0.0.1</Version>
  <Vendor>Rother OSS GmbH</Vendor>
  <URL>https://otobo.io/</URL>
  <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
  <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
  <BuildDate>2005-11-10 21:17:16</BuildDate>
  <BuildHost>yourhost.example.com</BuildHost>
  <Filelist>
    <File Location="Kernel/Config/Files/XML/TestPackage2-1.xml" Permission="644" Encode="Base64">aGVsbG8K</File>
    <File Location="Kernel/Config/Files/XML/TestPackage2-2.xml" Permission="644" Encode="Base64">aGVsbG8K</File>
  </Filelist>
</otobo_package>
';

my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# Cleanup the system.
for my $PackageName (qw(TestPackage1 TestPackage2)) {
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackageRemove = $PackageObject->RepositoryRemove(
            Name    => $PackageName,
            Version => '0.0.1',
        );

        $Self->True(
            $PackageRemove,
            "RepositoryRemove() $PackageName",
        );
    }
}

my @Tests = (
    {
        Name                   => 'Initial',
        ExpectedResultsContain => {
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTOBO => {
                DisplayName => 'OTOBO',
                Files       => [
                    'Calendar.xml',          'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                    'ProcessManagement.xml', 'Ticket.xml'
                ],
            },
        },
        ExpectedResultsNotContain => [ 'TestPackage1', 'TestPackage2' ],
    },
    {
        Name          => 'TestPackage1 Installed',
        RepositoryAdd => {
            PackageName => 'TestPackage1',
            String      => $String,
        },
        ExpectedResultsContain => {
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTOBO => {
                DisplayName => 'OTOBO',
                Files       => [
                    'Calendar.xml',          'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                    'ProcessManagement.xml', 'Ticket.xml'
                ],
            },
            TestPackage1 => {
                DisplayName => 'TestPackage1',
                Files       => ['TestPackage1.xml'],
            },
        },
        ExpectedResultsNotContain => ['TestPackage2'],
    },
    {
        Name          => 'TestPackage1 and TestPackage2 Installed',
        RepositoryAdd => {
            PackageName => 'TestPackage2',
            String      => $String2,
        },
        ExpectedResultsContain => {
            All => {
                DisplayName => 'All Settings',
                Files       => [],
            },
            OTOBO => {
                DisplayName => 'OTOBO',
                Files       => [
                    'Calendar.xml',          'CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml',
                    'ProcessManagement.xml', 'Ticket.xml'
                ],
            },
            TestPackage1 => {
                DisplayName => 'TestPackage1',
                Files       => ['TestPackage1.xml'],
            },
            TestPackage2 => {
                DisplayName => 'TestPackage2',
                Files       => [ 'TestPackage2-1.xml', 'TestPackage2-2.xml' ],
            },
        },
    },
);

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

for my $Test (@Tests) {

    # cleanup cache
    $CacheObject->Delete(
        Type => 'SysConfig',
        Key  => 'ConfigurationCategoriesGet',
    );

    if ( $Test->{RepositoryAdd} ) {
        my $RepositoryAdd = $PackageObject->RepositoryAdd( String => $Test->{RepositoryAdd}->{String} );
        $Self->True(
            $RepositoryAdd,
            "RepositoryAdd() $Test->{RepositoryAdd}->{PackageName}",
        );

    }

    my %Result = $SysConfigObject->ConfigurationCategoriesGet();

    for my $Category ( @{ $Test->{ExpectedResultsNotContain} } ) {
        $Self->Is(
            $Result{$Category},
            undef,
            "$Test->{Name} ConfigurationCategoriesGet() - should not contain $Category",
        );
    }

    for my $Category ( sort keys %{ $Test->{ExpectedResultsContain} } ) {
        $Self->IsDeeply(
            $Result{$Category},
            $Test->{ExpectedResultsContain}->{$Category},
            "$Test->{Name} ConfigurationCategoriesGet() - $Category",
        );
    }
}

# Cleanup the system.
for my $PackageName (qw(TestPackage1 TestPackage2)) {
    if ( $PackageObject->PackageIsInstalled( Name => $PackageName ) ) {
        my $PackageRemove = $PackageObject->RepositoryRemove(
            Name    => $PackageName,
            Version => '0.0.1',
        );

        $Self->True(
            $PackageRemove,
            "RepositoryRemove() $PackageName",
        );
    }
}

$Self->DoneTesting();
