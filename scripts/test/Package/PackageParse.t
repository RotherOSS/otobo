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

use Kernel::System::VariableCheck qw(:all);

# get package object
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# get OTOBO Version
my $OTOBOVersion = $Kernel::OM->Get('Kernel::Config')->Get('Version');

# leave only major and minor level versions
$OTOBOVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTOBOVersion .= '.x';

my @Tests = (
    {
        Name   => 'Wrong package content',
        String => 'Not a valid structure
for a package file.',
        Success => 0,
    },
    {
        Name   => 'Invalid package content',
        String => '
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
    "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <title>Page title</title>
  </head>
  <body>
    <div class="Main">
        <p>This is a invalid content.</p>
        <p>It can pass the XML parse.</p>
        <p>But is not possible to retrieve an structure from it.</p>
    </div>
  </body>
</html>
',
        Success => 0,
    },
    {
        Name   => 'Normal package content',
        String => '<?xml version="1.0" encoding="utf-8" ?>
    <otobo_package version="1.0">
      <Name>TestPackage</Name>
      <Version>1.0.1</Version>
      <Vendor>Rother OSS GmbH</Vendor>
      <URL>https://otobo.io/</URL>
      <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
      <ChangeLog>2013-08-14 New package (some test &lt; &gt; &amp;).</ChangeLog>
      <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
      <Description Lang="de">Ein Test Paket (some test &lt; &gt; &amp;).</Description>
      <ModuleRequired Version="1.112">Encode</ModuleRequired>
      <Framework>' . $OTOBOVersion . '</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="bin/otobo.CheckDB.pl" Permission="755" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otobo_package>
',
        Success => 1,
    },
);

for my $Test (@Tests) {

    my $ResultStructure = 1;
    my %Structure       = $PackageObject->PackageParse( String => $Test->{String} );
    $ResultStructure = 0 if !IsHashRefWithData( \%Structure );

    $Self->Is(
        $ResultStructure,
        $Test->{Success},
        "PackageParse() - $Test->{Name}",
    );

    if ( $Test->{Success} ) {

        $Self->Is(
            $Structure{Name}->{Content},
            'TestPackage',
            "PackageParse() - $Test->{Name} | Name",
        );

        $Self->Is(
            $Structure{Version}->{Content},
            '1.0.1',
            "PackageParse() - $Test->{Name} | Version",
        );

        $Self->Is(
            $Structure{Vendor}->{Content},
            'Rother OSS GmbH',
            "PackageParse() - $Test->{Name} | Vendor",
        );
    }
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

$Self->DoneTesting();
