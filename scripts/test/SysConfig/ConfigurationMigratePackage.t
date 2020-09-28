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
use if __PACKAGE__ ne 'Kernel::System::UnitTest::Driver', 'Kernel::System::UnitTest::RegisterDriver';

use vars (qw($Self));

use File::Copy;
use Kernel::Config;
use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# get needed objects
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Package::AllowNotVerifiedPackages',
    Value => 1,
);

my $Home = $Kernel::OM->Get('Kernel::Config')->{Home};

my $TestFile              = 'ZZZAutoOTOBO5.pm';
my $TestPath              = $Home . '/scripts/test/sample/SysConfig/Migration/Package/';
my $TestLocation          = $TestPath . $TestFile;
my $OTOBO5ConfigFileClass = "Kernel::Config::Backups::ZZZAutoOTOBO5";
my $OTOBO5ConfigFile      = "$Home/Kernel/Config/Backups/ZZZAutoOTOBO5.pm";

# create backups directory if not existing
if ( !-d "$Home/Kernel/Config/Backups" ) {
    mkdir "$Home/Kernel/Config/Backups";
}

# copy ZZZAutoOTOBO5.pm to backup folder from where it is processed during package upgrade
copy( $TestLocation, $OTOBO5ConfigFile );

$Self->True(
    -e $OTOBO5ConfigFile,
    "TestFile '$OTOBO5ConfigFile' existing",
);

# check if ARCHIVE file exists, if not we create it
my $ArchiveFileCreated;
if ( !-e $Home . '/ARCHIVE' ) {

    # create an ARCHIVE file on developer systems to continue working
    my $ArchiveGeneratorTool = $Home . '/bin/otobo.CheckSum.pl';

    # if tool is not present we can't continue
    if ( !-e $ArchiveGeneratorTool ) {
        $Self->True(
            0,
            "$ArchiveGeneratorTool does not exist, we can't continue",
        );
        return;
    }

    # execute ARCHIVE generator tool
    my $Result = `$ArchiveGeneratorTool -a create`;

    # if archive file still does not exist or has zero length
    if ( !-e $Home . '/ARCHIVE' || -z $Home . '/ARCHIVE' ) {

        # if ARCHIVE file is not present we can't continue
        $Self->True(
            0,
            "ARCHIVE file is not generated, we can't continue",
        );
        return;
    }
    else {
        $Self->True(
            1,
            "ARCHIVE file is generated for UnitTest purpose",
        );

        # remeber that we created an ARCHIVE file so we can delete it again later
        $ArchiveFileCreated = 1;
    }
}

# First simulate a migration for the system and after that the package upgrade.
my $Success = $Kernel::OM->Get('Kernel::System::SysConfig::Migration')->MigrateConfigEffectiveValues(
    FileClass                    => $OTOBO5ConfigFileClass,
    FilePath                     => $OTOBO5ConfigFile,
    ReturnMigratedSettingsCounts => 1,
);

$Self->True(
    $Success,
    "Config was successfully migrated from otobo5 to 6."
);

# RebuildConfig
my $Rebuild = $SysConfigObject->ConfigurationDeploy(
    Comments => "UnitTest Configuration Rebuild",
    Force    => 1,
    UserID   => 1,
);

$Self->True(
    $Rebuild,
    "Setting Deploy was successfull."
);

# build a 5.0.1 version of the test package
my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Package::Build');
my $ExitCode      = $CommandObject->Execute(
    '--version', '5.0.1', '--module-directory',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/TestPackage.sopm', 'var/tmp/'
);

$Self->Is(
    $ExitCode,
    0,
    "Dev::Package::Build exit code",
);

# install the package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Install');
$ExitCode      = $CommandObject->Execute('var/tmp/TestPackage-5.0.1.opm');

$Self->Is(
    $ExitCode,
    0,
    "Admin::Package::Install exit code",
);

# list the installed packages
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::List');
$ExitCode      = $CommandObject->Execute();

# build a 6.0.1 version of the test package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Dev::Package::Build');
$ExitCode      = $CommandObject->Execute(
    '--version',
    '6.0.1',
    '--module-directory',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/',
    'scripts/test/sample/SysConfig/Migration/Package/TestPackage/TestPackage.sopm',
    'var/tmp/',
);

$Self->Is(
    $ExitCode,
    0,
    "Dev::Package::Build exit code",
);

# upgrade the package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Upgrade');
$ExitCode      = $CommandObject->Execute('var/tmp/TestPackage-6.0.1.opm');

$Self->Is(
    $ExitCode,
    0,
    "Admin::Package::Upgrade exit code",
);

# list the installed packages
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::List');
$ExitCode      = $CommandObject->Execute();

my @Tests = (
    {
        Name           => 'Ticket::Hook',
        EffectiveValue => 'TicketTestMigrated#',
    },
    {
        Name           => 'Frontend::Module###AgentTicketQueue',
        EffectiveValue => {
            'Description' => 'Overview of all open Tickets. Migrated.',
            'Group'       => [
                'admin'
            ],
            'GroupRo'    => [],
            'NavBarName' => 'Ticket',
            'Title'      => 'QueueView',
        },
    },
    {
        Name           => 'Frontend::Navigation###AgentTicketQueue###002-Ticket',
        EffectiveValue => [
            {
                'AccessKey'   => 'o',
                'Block'       => '',
                'Description' => 'Overview of all open Tickets. Migrated.',
                'Group'       => [
                    'admin',
                ],
                'GroupRo'    => [],
                'Link'       => 'Action=AgentTicketQueue',
                'LinkOption' => '',
                'Name'       => 'Queue view',
                'NavBar'     => 'Ticket',
                'Prio'       => '100',
                'Type'       => '',
            },
            {
                'AccessKey'   => 't',
                'Block'       => 'ItemArea',
                'Description' => 'Test Migrated',
                'Group'       => [
                    'admin',
                ],
                'GroupRo'    => [],
                'Link'       => 'Action=AgentTicketQueue',
                'LinkOption' => '',
                'Name'       => 'Tickets',
                'NavBar'     => 'Ticket',
                'Prio'       => '200',
                'Type'       => 'Menu',
            },
        ],
    },
    {
        Name           => 'Frontend::Navigation###AgentTicketProcess###002-ProcessManagement',
        EffectiveValue => [
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Create New process ticket.',
                'Group'       => [],
                'GroupRo'     => [],
                'Link'        => 'Action=AgentTicketProcess',
                'LinkOption'  => '',
                'Name'        => 'New process ticket',
                'NavBar'      => 'Ticket',
                'Prio'        => '220',
                'Type'        => ''
            },
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start new vacation process.',
                'Group'       => [
                    'users',
                ],
                'GroupRo'    => [],
                'Link'       => 'Action=AgentTicketProcess;Process=111',
                'LinkOption' => '',
                'Name'       => 'Start new vacation process',
                'NavBar'     => 'Ticket',
                'Prio'       => '230',
                'Type'       => ''
            },
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start sick process.',
                'Group'       => [],
                'GroupRo'     => [
                    'users',
                ],
                'Link'       => 'Action=AgentTicketProcess;Process=999',
                'LinkOption' => '',
                'Name'       => 'Start sick process',
                'NavBar'     => 'Ticket',
                'Prio'       => '240',
                'Type'       => ''
            },
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start special process.',
                'Group'       => [],
                'GroupRo'     => [],
                'Link'        => 'Action=AgentTicketProcess;Process=555',
                'LinkOption'  => '',
                'Name'        => 'Start special process',
                'NavBar'      => 'Ticket',
                'Prio'        => '250',
                'Type'        => ''
            },
        ],
    },
    {
        Name           => 'Frontend::Navigation###AgentTicketProcess###003-TestPackage',
        EffectiveValue => [
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start new vacation process.',
                'Group'       => [
                    'users',
                ],
                'GroupRo'    => [],
                'Link'       => 'Action=AgentTicketProcess;Process=111',
                'LinkOption' => '',
                'Name'       => 'Start new vacation process',
                'NavBar'     => 'Ticket',
                'Prio'       => '230',
                'Type'       => ''
            },
            {
                'AccessKey'   => 'p',
                'Block'       => '',
                'Description' => 'Start new application for leave process.',
                'Group'       => [],
                'GroupRo'     => [
                    'users',
                ],
                'Link'       => 'Action=AgentTicketProcess;Process=999',
                'LinkOption' => '',
                'Name'       => 'Start new application for leave process',
                'NavBar'     => 'Ticket',
                'Prio'       => '240',
                'Type'       => ''
            },
        ],
    },
    {
        Name           => 'PostMaster::PreFilterModule###1-TestPackage-Match',
        EffectiveValue => {
            Match => {
                From => 'noreply@',
            },
            Module => 'Kernel::System::PostMaster::Filter::Match',
            Set    => {
                'X-OTOBO-IsVisibleForCustomer'          => '0',
                'X-OTOBO-FollowUp-IsVisibleForCustomer' => '1',
                'X-OTOBO-Ignore'                        => 'yes',
            },
        },
    },
    {
        Name           => 'PostMaster::PreCreateFilterModule###000-TestPackage-FollowUpArticleVisibilityCheck',
        EffectiveValue => {
            'Module'                       => 'Kernel::System::PostMaster::Filter::FollowUpArticleVisibilityCheck',
            'IsVisibleForCustomer'         => '0',
            'SenderType'                   => 'customer',
            'X-OTOBO-IsVisibleForCustomer' => '0',
            'X-OTOBO-FollowUp-IsVisibleForCustomer' => '1',
        },
    },
    {
        Name           => 'PostMaster::CheckFollowUpModule###0100-TestPackage-Subject',
        EffectiveValue => {
            'Module'                                => 'Kernel::System::PostMaster::FollowUpCheck::Subject',
            'IsVisibleForCustomer'                  => '1',
            'SenderType'                            => 'customer',
            'X-OTOBO-IsVisibleForCustomer'          => '0',
            'X-OTOBO-FollowUp-IsVisibleForCustomer' => '1',
        },
    },
);

for my $Test (@Tests) {

    # get sysconfig setting
    my %OTOBO6Setting = $SysConfigObject->SettingGet(
        Name => $Test->{Name},
    );

    # handle string setings
    if ( IsString( $Test->{EffectiveValue} ) ) {

        # check effective value
        $Self->Is(
            $OTOBO6Setting{EffectiveValue},
            $Test->{EffectiveValue},
            "Check migrated setting for config setting '$Test->{Name}'",
        );
    }

    # handle complex data structure settings
    else {

        # check effective value
        $Self->IsDeeply(
            $OTOBO6Setting{EffectiveValue},
            $Test->{EffectiveValue},
            "Check migrated setting for config setting '$Test->{Name}'",
        );
    }
}

# uninstall the package
$CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Admin::Package::Uninstall');
$ExitCode      = $CommandObject->Execute('TestPackage');

$Self->Is(
    $ExitCode,
    0,
    "Admin::Package::Uninstall exit code",
);

# cleanup ARCHIVE file
if ($ArchiveFileCreated) {
    my $Success = unlink $Home . '/ARCHIVE';
    $Self->True(
        $Success,
        "UnitTest ARCHIVE file is deleted",
    );
}

# cleanup otobo 5 config file
unlink $OTOBO5ConfigFile;

$Self->False(
    -e $OTOBO5ConfigFile,
    "UnitTest OTOBO5Config file is deleted",
);


