# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# disable check email address
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $SetingsXML = << 'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otobo_config version="2.0" init="Framework">
    <Setting Name="Test0" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test</Item>
        </Value>
    </Setting>
</otobo_config>
EOF

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my @ParsedSettings = $Kernel::OM->Get('Kernel::System::SysConfig::XML')->SettingListParse(
    XMLInput    => $SetingsXML,
    XMLFilename => "UnitTestXML",
);

my @DefaultSettingAddParams;
for my $Setting (@ParsedSettings) {

    my $Value = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
        Data => $Setting->{XMLContentParsed}->{Value},
    );

    my $EffectiveValue = $SysConfigObject->SettingEffectiveValueGet(
        Value => $Value,
    );
    push @DefaultSettingAddParams, {
        XMLContentRaw    => $Setting->{XMLContentRaw},
        XMLContentParsed => $Setting->{XMLContentParsed},
        EffectiveValue   => $EffectiveValue,
    };
}

my $RandomID   = $HelperObject->GetRandomID();
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my $TestUserID1;
my $UserRand1 = 'example-user1' . $RandomID;
$TestUserID1 = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

my $TestUserID2;
my $UserRand2 = 'example-user2' . $RandomID;
$TestUserID2 = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test2',
    UserLastname  => 'Lastname Test2',
    UserLogin     => $UserRand2,
    UserEmail     => $UserRand2 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

my $SettingName = 'ProductName ' . $RandomID;

my %DefaultSettingAddTemplate = (
    Name           => $SettingName,
    Description    => "Test.",
    Navigation     => "Core::Test",
    IsInvisible    => 0,
    IsReadonly     => 0,
    IsRequired     => 1,
    IsValid        => 1,
    HasConfigLevel => 0,
    XMLFilename    => 'UnitTest.xml',
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DefaultSettingID = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
    %{ $DefaultSettingAddParams[0] },
);
$Self->IsNot(
    $DefaultSettingID,
    0,
    "DefaultSettingAdd() - Test0",
);

my %ModifiedSettingAddTemplate = (
    %DefaultSettingAddTemplate,
    DefaultID => $DefaultSettingID,
);

# Add global entry
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID,
    UserID    => 1,
    Force     => 1,
);
my $IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
    DefaultID => $DefaultSettingID,
);
$Self->True(
    $IsLock,
    'Default setting must be lock.',
);

my $ModifiedSettingID = $SysConfigDBObject->ModifiedSettingAdd(
    %ModifiedSettingAddTemplate,
    %{ $DefaultSettingAddParams[1] },
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);

my $Result = $ModifiedSettingID ? 1 : 0;
$Self->True(
    $Result,
    'ModifiedSettingAdd() - Testing global.',
);

# Add a couple of modified settings
my %UserSettings;

$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID,
    UserID    => $TestUserID1,
    Force     => 1,
);
$IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
    DefaultID => $DefaultSettingID,
);
$Self->True(
    $IsLock,
    'Default setting One must be lock.',
);

my $EffectiveValue = "Modified for user one.";

my $ModifiedSettingID1 = $SysConfigDBObject->ModifiedSettingAdd(
    %ModifiedSettingAddTemplate,
    %{ $DefaultSettingAddParams[0] },
    EffectiveValue    => $EffectiveValue,
    TargetUserID      => $TestUserID1,
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => $TestUserID1,
);

$Result = $ModifiedSettingID1 ? 1 : 0;
$Self->True(
    $Result,
    'ModifiedSettingAdd() - Testing One.',
);

# Store it for later.
$UserSettings{$TestUserID1} = $EffectiveValue;

$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID,
    UserID    => $TestUserID2,
    Force     => 1,
);
$IsLock = $SysConfigDBObject->DefaultSettingIsLocked(
    DefaultID => $DefaultSettingID,
);
$Self->True(
    $IsLock,
    'Default setting Two must be lock.',
);

$EffectiveValue = "Modified value for user two.";

my $ModifiedSettingID2 = $SysConfigDBObject->ModifiedSettingAdd(
    %ModifiedSettingAddTemplate,
    %{ $DefaultSettingAddParams[1] },
    EffectiveValue    => $EffectiveValue,
    TargetUserID      => $TestUserID2,
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => $TestUserID2,
);

$Result = $ModifiedSettingID1 ? 1 : 0;
$Self->True(
    $Result,
    'ModifiedSettingAdd() - Testing Two.',
);

# Store it for later.
$UserSettings{$TestUserID2} = $EffectiveValue;

my %Result = $SysConfigObject->UserSettingModifiedValueList( Name => $SettingName );

$Self->IsDeeply(
    \%UserSettings,
    \%Result,
    "ConfigurationUsersModifiedSettingList() - Match with expected result from modified settings, just by users.",
);

$Self->DoneTesting();
