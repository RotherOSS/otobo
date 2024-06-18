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

# get needed objects
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

# get OTOBO Version
my $OTOBOVersion = $ConfigObject->Get('Version');

# leave only major and minor level versions
$OTOBOVersion =~ s{ (\d+ \. \d+) .+ }{$1}msx;

# add x as patch level version
$OTOBOVersion .= '.x';

# find out if it is an developer installation with files
# from the version control system.
my $DeveloperSystem = 0;
my $Home            = $ConfigObject->Get('Home');
my $Version         = $ConfigObject->Get('Version');
if (
    !-e $Home . '/ARCHIVE'
    && $Version =~ m{git}
    )
{
    $DeveloperSystem = 1;
}

# check #13 doesn't work on developer systems because there is no ARCHIVE file!
if ( !$DeveloperSystem ) {

    # install package normally
    my $String = '<?xml version="1.0" encoding="utf-8" ?>
    <otobo_package version="1.0">
      <Name>Test</Name>
      <Version>0.0.1</Version>
      <Vendor>Rother OSS GmbH</Vendor>
      <URL>https://otobo.io/</URL>
      <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
      <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
      <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
      <Description Lang="de">Ein Test Paket (some test &lt; &gt; &amp;).</Description>
      <ModuleRequired Version="1.112">Encode</ModuleRequired>
      <Framework>' . $OTOBOVersion . '</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otobo_package>
    ';
    my $PackageInstall = $PackageObject->PackageInstall( String => $String );

    # check that the package is installed and files exists
    $Self->True(
        $PackageInstall,
        'PackageInstall() - package installed with true',
    );
    for my $File (qw( Test var/Test )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->True(
            -e $RealFile,
            "FileExists - $RealFile with true",
        );
    }

    # modify the installed package including one framework file, this will simulate that the
    # package was installed before feature merge into the framework, the idea is that the package
    # will be uninstalled, the not framework files will be removed and the framework files will
    # remain
    $String = '<?xml version="1.0" encoding="utf-8" ?>
    <otobo_package version="1.0">
      <Name>Test</Name>
      <Version>0.0.1</Version>
      <Vendor>Rother OSS GmbH</Vendor>
      <URL>https://otobo.io/</URL>
      <License>GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007</License>
      <ChangeLog>2005-11-10 New package (some test &lt; &gt; &amp;).</ChangeLog>
      <Description Lang="en">A test package (some test &lt; &gt; &amp;).</Description>
      <Description Lang="de">Ein Test Paket (some test &lt; &gt; &amp;).</Description>
      <ModuleRequired Version="1.112">Encode</ModuleRequired>
      <Framework>' . $OTOBOVersion . '</Framework>
      <BuildDate>2005-11-10 21:17:16</BuildDate>
      <BuildHost>yourhost.example.com</BuildHost>
      <Filelist>
        <File Location="Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="var/Test" Permission="644" Encode="Base64">aGVsbG8K</File>
        <File Location="bin/otobo.CheckSum.pl" Permission="755" Encode="Base64">aGVsbG8K</File>
      </Filelist>
    </otobo_package>
    ';
    my $PackageName = 'Test';

    # the modifications has to be at DB level, otherwise a .save file will be generated for the
    # framework file, and we are trying to prevent it
    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE package_repository
            SET content = ?
            WHERE name = ?',
        Bind => [ \$String, \$PackageName ],
    );

    my $Content = 'Test 12345678';

    # now create an .save file for the framework file, content doesn't matter as it will be deleted
    my $Write = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $Home . '/bin/otobo.CheckSum.pl.save',
        Content    => \$Content,
        Mode       => 'binmode',
        Permission => '644',
    );
    $Self->True(
        $Write,
        '#FileWrite() - bin/otobo.CheckSum.pl.save',
    );

    # create PackageObject again to make sure cache is cleared
    my $PackageObject = Kernel::System::Package->new( %{$Self} );

    # run PackageUninstallMerged()
    my $Success = $PackageObject->_PackageUninstallMerged( Name => $PackageName );
    $Self->True(
        $Success,
        "_PackageUninstallMerged() - Executed with true",
    );

    # check that the original files from the package does not exist anymore
    # these files are suppose to be old files that are not required anymore by the merged package
    for my $File (qw( Test var/Test bin/otobo.CheckSum.pl.save )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->False(
            -e $RealFile,
            "FileExists - $RealFile with false",
        );
    }

    # check that the framework file still exists
    for my $File (qw( bin/otobo.CheckSum.pl )) {
        my $RealFile = $Home . '/' . $File;
        $RealFile =~ s/\/\//\//g;
        $Self->True(
            -e $RealFile,
            "FileExists - $RealFile with true",
        );
    }

    # check that the package is uninstalled
    my $PackageInstalled = $PackageObject->PackageIsInstalled(
        Name => $PackageName,
    );
    $Self->False(
        $PackageInstalled,
        'PackageIsInstalled() - with false',
    );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

$Self->DoneTesting();
