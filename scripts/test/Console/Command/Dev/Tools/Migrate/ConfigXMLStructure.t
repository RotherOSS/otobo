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
use v5.24;
use utf8;

# core modules
use File::Copy;

# CPAN modules
use Test2::V0;
use Path::Class qw(dir file);

# OTOBO modules
use Kernel::System::ObjectManager;

plan( tests => 6 );

$Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-otobo.UnitTest',
    },
);

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Tools::Migrate::ConfigXMLStructure');
my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# error with non-existent dir
{
    my ($ExitCode, $Result);
    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( "--source-directory", "$Home/Kernel/Config/Files/NotExisting/" );
    }
    note( $Result );

    # exit code 1 indicates failure
    is( $ExitCode, 1, 'Dev::Tools::Migrate::ConfigXMLStructure exit code not existing directory' );
}

# actual migration
{
    # copy a sample file to a testdir
    my $TestDir = dir($Home)->subdir('tmp/Test/Migrate/ConfigXMLStructure');
    $TestDir->mkpath();

    # copy the sample file to the test dir, the workfile will be modified later
    my $SampleFile  = dir($Home)->file('scripts/test/sample/SysConfig/ConfigurationMigrateXMLStructure.xml');
    my $WorkFile    = $SampleFile->copy_to( $TestDir->file('ConfigurationMigrateXMLStructure.xml') );

    my ($ExitCode, $Result);
    {
        local *STDOUT;
        open STDOUT, '>:encoding(UTF-8)', \$Result;
        $ExitCode = $CommandObject->Execute( "--source-directory", $TestDir->stringify );
    }
    note( $Result );

    # exit code 0 indicates success
    is( $ExitCode, 0, 'Dev::Tools::Migrate::ConfigXMLStructure success' );

    # check whether the backup file exists
    my $BackupFile = $TestDir->file('ConfigurationMigrateXMLStructure.xml.bak_otrs_6');
    ok( -e $BackupFile, "$BackupFile exists" );

    # Content of the backupfile
    is(
        [ $BackupFile->slurp ],
        [ $SampleFile->slurp ],
        "Content of $BackupFile"
    );

    # check whether to migrated file exists
    ok( -e $WorkFile, "$WorkFile exists" );

    # Content of the migrated file
    my $ExpectedResultFile = dir($Home)->file('scripts/test/sample/SysConfig/ConfigurationMigrateXMLStructureResult.xml');
    is(
        [ $WorkFile->slurp ],
        [ $ExpectedResultFile->slurp ],
        "Content of $WorkFile"
    );
}
