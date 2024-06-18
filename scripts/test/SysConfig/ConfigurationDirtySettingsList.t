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
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $RandomID    = $HelperObject->GetRandomID();
my $SettingName = "Test$RandomID";
my $UserID      = 1;
my @SettingDirtyNames;

# Make sure all settings are not dirty.
my $ModifiedCleanup = $SysConfigDBObject->ModifiedSettingDirtyCleanUp();
$Self->True(
    $ModifiedCleanup,
    "ModifiedSettingDirtyCleanUp() - with true",
);

my $DefaultCleanup = $SysConfigDBObject->DefaultSettingDirtyCleanUp();
$Self->True(
    $DefaultCleanup,
    "DefaultSettingDirtyCleanUp() - with true",
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $DeployAndCheck = sub {

    my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => $UserID,
        Force  => 1,
    );

    my $EffectiveValueStrg = 'Test';

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'UnitTest',
        EffectiveValueStrg  => \$EffectiveValueStrg,
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        UserID              => $UserID,
        DeploymentTimeStamp => '1977-12-12 12:00:00',
    );
    $Self->IsNot(
        $DeploymentID,
        undef,
        'DeploymentAdd()',
    );

    my $DefaultCleanup  = $SysConfigDBObject->DefaultSettingDirtyCleanUp();
    my $ModifiedCleanup = $SysConfigDBObject->ModifiedSettingDirtyCleanUp();

    # Configuration should not be dirty
    my $Result = $SysConfigObject->ConfigurationIsDirtyCheck();
    $Self->Is(
        $Result,
        0,
        'ConfigurationIsDirtyCheck() after deployment',
    );

    my $Success = $SysConfigDBObject->DeploymentUnlock(
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => $UserID,
    );
    $Self->Is(
        $Success,
        1,
        "DeploymentUnlock(). for DeploymentGetLast()",
    );
};

my $XMLContentRaw = <<'EOF',
<Setting Name="UnitTest" Required="1" Valid="1" ConfigLevel="200">
<Description Translatable="1">Test.</Description>
<Navigation>Core</Navigation>
<Value>
    <Item ValueType="String" ValueRegex="">OTOBO 10</Item>
</Value>
</Setting>
EOF

    my $XMLContentParsed = {
        Name        => 'UnitTest',
        Required    => '1',
        Valid       => '1',
        ConfigLevel => '200',
        Description => [
            {
                Translatable => '1',
                Content      => 'Test.',
            },
        ],
        Navigation => [
            {
                Content => 'Core',
            },
        ],
        Value => [
            {
                Item => [
                    {
                        ValueType  => 'String',
                        Content    => 'OTOBO 10',
                        ValueRegex => '',
                    },
                ],
            },
        ],
    };

my $DefaultID1 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => $SettingName . '1',
    Description      => "Defines the name of the application ...",
    Valid            => 1,
    HasConfigLevel   => 200,
    Required         => 1,
    Navigation       => "Core",
    XMLContentRaw    => $XMLContentRaw,
    XMLContentParsed => $XMLContentParsed,
    XMLFilename      => 'UnitTest.xml',
    EffectiveValue   => 'OTOBO 10',
    UserID           => $UserID,
);
$Self->IsNot(
    $DefaultID1,
    undef,
    'DefaultSettingAdd()',
);

$DeployAndCheck->();

# Provoke dirty configuration by adding a new default.
my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => $SettingName . '2',
    Description      => "Defines the name of the application ...",
    Valid            => 1,
    HasConfigLevel   => 200,
    Required         => 1,
    Navigation       => "Core",
    XMLContentRaw    => $XMLContentRaw,
    XMLContentParsed => $XMLContentParsed,
    XMLFilename      => 'UnitTest.xml',
    EffectiveValue   => 'OTOBO 10',
    UserID           => $UserID,
);
$Self->IsNot(
    $DefaultID2,
    undef,
    'DefaultSettingAdd()',
);

# Save the Name to use it in the next test
push @SettingDirtyNames, $SettingName . '2';

# Lock setting (so it can be updated).
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => $UserID,
    Force     => 1,
    DefaultID => $DefaultID1,
);

$Self->True(
    $ExclusiveLockGUID,
    "DefaultSettingLock",
);

my %Result = $SysConfigObject->SettingUpdate(
    DefaultID         => $DefaultID1,
    Name              => $SettingName . '1',
    EffectiveValue    => 'Test Update',
    UserID            => $UserID,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);

$Self->True(
    $Result{Success},
    "SettingUpdate()",
);

# Save the Name to use it in the next test
push @SettingDirtyNames, $SettingName . '1';

# Check for dirty settings
my @SettingDirtyList = $SysConfigObject->ConfigurationDirtySettingsList();

$Self->Is(
    scalar @SettingDirtyNames,
    scalar @SettingDirtyList,
    "ConfigurationDirtySettingsList() - Should be the same as settings added during testing.",
);

for my $IsDirty (@SettingDirtyNames) {
    my $InList = 0;
    if ( grep {/^$IsDirty/} @SettingDirtyList ) {
        $InList = 1;
    }
    $Self->Is(
        $InList,
        1,
        "ConfigurationDirtySettingsList() - $IsDirty: $InList",
    );
}

$DeployAndCheck->();

# Check for dirty settings
@SettingDirtyList = $SysConfigObject->ConfigurationDirtySettingsList();

$Self->Is(
    scalar @SettingDirtyList,
    0,
    "ConfigurationDirtySettingsList() - Should be empty.",
);

$Self->DoneTesting();
