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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my %Setting1 = $SysConfigObject->SettingGet(
    Name => 'Frontend::DebugMode',
);

my %Setting2 = $SysConfigObject->SettingGet(
    Name => 'SystemID',
);

# Lock 2 settings
my $GUID1 = $SysConfigObject->SettingLock(
    Name   => 'Frontend::DebugMode',
    UserID => 1,
);

$Self->True(
    $GUID1,
    'Frontend::DebugMode locked successfully.'
);

my $GUID2 = $SysConfigObject->SettingLock(
    Name   => 'SystemID',
    UserID => 1,
);

$Self->True(
    $GUID2,
    'SystemID locked successfully.'
);

my $UpdateSuccess = $SysConfigDBObject->DefaultSettingUpdate(
    %Setting1,
    ExclusiveLockGUID => $GUID1,
    EffectiveValue    => 'Updated setting',
    UserID            => 1,
);

$Self->True(
    $UpdateSuccess,
    'Setting Frontend::DebugMode updated successfully.',
);

# Since we updated 1 setting, we have 1 locked setting and 1 dirty setting.
my @LockedSettings = $SysConfigDBObject->DefaultSettingList(
    Locked => 1,
);

$Self->IsDeeply(
    \@LockedSettings,
    [
        {
            'DefaultID'         => $Setting2{DefaultID},
            'ExclusiveLockGUID' => $GUID2,
            'IsDirty'           => '0',
            'IsInvisible'       => '0',
            'Name'              => 'SystemID',
            'XMLContentRaw'     => '<Setting Name="SystemID" Required="1" Valid="1" ConfigLevel="200">
        <Description Translatable="1">Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTOBO).</Description>
        <Navigation>Core</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex="^\\d+$">10</Item>
        </Value>
    </Setting>',
            'XMLFilename' => 'Framework.xml',
        },
    ],
    'Check locked settings',
);

my @DirtySettings = $SysConfigDBObject->DefaultSettingList(
    IsDirty => 1,
);

$Self->IsDeeply(
    \@DirtySettings,
    [
        {
            'DefaultID'         => $Setting1{DefaultID},
            'ExclusiveLockGUID' => '0',
            'IsDirty'           => '1',
            'IsInvisible'       => '0',
            'Name'              => 'Frontend::DebugMode',
            'XMLContentRaw'     => '<Setting Name="Frontend::DebugMode" Required="0" Valid="1" ConfigLevel="100">
        <Description Translatable="1">Enables or disables the debug mode over frontend interface.</Description>
        <Navigation>Frontend::Base</Navigation>
        <Value>
            <Item ValueType="Checkbox">0</Item>
        </Value>
    </Setting>',
            'XMLFilename' => 'Framework.xml'
        },
    ],
    'Check dirty settings',
);

# We can't compare all settings, it depends on installed packages, but we know there are at least 1700 settings.
my @SettingList = $SysConfigDBObject->DefaultSettingList();

$Self->True(
    scalar @SettingList > 1700,
    'Make sure there are at least 1700 settings.',
);

# Make sure that Invisible settings are not included.
my $InvisibleFound = grep { $_->{Name} eq 'SystemConfiguration::MaximumDeployments' } @SettingList;

$Self->False(
    $InvisibleFound,
    'SystemConfiguration::MaximumDeployments is not present (Invisible).'
);

# Get all settings.
@SettingList = $SysConfigDBObject->DefaultSettingList(
    IncludeInvisible => 1,
);

$Self->True(
    scalar @SettingList > 1700,
    'Make sure there are at least 1700 settings.',
);

# Make sure that Invisible settings are not included.
$InvisibleFound = grep { $_->{Name} eq 'SystemConfiguration::MaximumDeployments' } @SettingList;

$Self->True(
    $InvisibleFound,
    'SystemConfiguration::MaximumDeployments is present (Invisible).'
);

$Self->DoneTesting();
