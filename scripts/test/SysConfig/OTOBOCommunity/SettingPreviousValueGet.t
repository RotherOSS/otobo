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

use vars (qw($Self));

use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $UserID = 1;

my %DefaultSettingAddTemplate = (
    Description    => "Test.",
    Navigation     => "Core::Test",
    IsInvisible    => 0,
    IsReadonly     => 0,
    IsRequired     => 1,
    IsValid        => 1,
    HasConfigLevel => 0,
    XMLFilename    => 'UnitTest.xml',
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
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test.</Description>
        <Navigation>Core::Test</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">DefaultValue</Item>
        </Value>
    </Setting>
</otobo_config>
EOF

    # Get SysConfig XML object.
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

my $RandomID = $HelperObject->GetRandomID();

my @DefaultIDs;

# Get SysConfig DB object.
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DefaultID0 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[0] },
    Name                     => "Test0$RandomID",
    UserModificationPossible => 0,
    UserModificationActive   => 0,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID0,
    0,
    "DefaultSettingAdd() - Test0",
);

push @DefaultIDs, $DefaultID0;

my $DefaultID1 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[1] },
    Name                     => "Test1$RandomID",
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID1,
    0,
    "DefaultSettingAdd() - Test1",
);

push @DefaultIDs, $DefaultID1;

my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => "Test1$RandomID",
);

my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
    %DefaultSettingAddTemplate,
    %{ $DefaultSettingAddParams[2] },
    Name                     => "Test2$RandomID",
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID2,
    0,
    "DefaultSettingAdd() - Test2",
);

push @DefaultIDs, $DefaultID2;

my %DefaultSetting2 = $SysConfigDBObject->DefaultSettingGet(
    Name => "Test2$RandomID",
);

# Lock
my $GuID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultID1,
);

$Self->True(
    $GuID,
    "Check if locked 1 before update."
);

my $GuID2 = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultID2,
);

$Self->True(
    $GuID2,
    "Check if locked 2 before update."
);

# Perform a change for modified
$DefaultSetting{EffectiveValue} = 'ModifiedValue';

# Update item
my $ModifiedID = $SysConfigDBObject->ModifiedSettingAdd(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    UserID            => 1,
);

$Self->IsNot(
    $ModifiedID,
    undef,
    "1st Modified 1 add success.",
);

my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    %DefaultSetting2,
    EffectiveValue    => 'ModifiedValue',
    ExclusiveLockGUID => $GuID2,
    UserID            => 1,
);

$Self->IsNot(
    $ModifiedID2,
    undef,
    "1st Modified 2 add success.",
);

my $DeploymentOnly = sub {

    my $SuccessDeploy = $SysConfigObject->ConfigurationDeploy(
        Comments     => "UnitTest",
        UserID       => $UserID,
        Force        => 1,
        AllSettings  => 1,
        NoValidation => 1,
    );

    $Self->True(
        $SuccessDeploy,
        'Deployment done.',
    );
};

$DeploymentOnly->();

# Lock
$GuID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultID1,
);

$Self->True(
    $GuID,
    "Check 1 if locked before update."
);

$GuID2 = $SysConfigDBObject->DefaultSettingLock(
    UserID    => 1,
    DefaultID => $DefaultID2,
);

$Self->True(
    $GuID2,
    "Check 2 if locked before update."
);

# Perform a change for modified
$DefaultSetting{EffectiveValue} = 'TheLastValue';

# Update item
my $UpdateResult = $SysConfigDBObject->ModifiedSettingUpdate(
    %DefaultSetting,
    ExclusiveLockGUID => $GuID,
    ModifiedID        => $ModifiedID,
    UserID            => 1,
);

$Self->IsNot(
    $UpdateResult,
    undef,
    "2nd Modified 1 add success.",
);

# reset to default
my $UpdateResult2 = $SysConfigObject->SettingReset(
    %DefaultSetting2,
    ExclusiveLockGUID => $GuID2,
    UserID            => 1,
);

$Self->IsNot(
    $UpdateResult2,
    undef,
    "2nd Modified 2 add success.",
);

$DeploymentOnly->();
my %LastDeployment = $SysConfigDBObject->DeploymentGetLast();

my $DeploymentID        = $LastDeployment{DeploymentID};
my %ModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
    DeploymentID => $DeploymentID,
);

my @ModifiedVersions = sort keys %ModifiedVersionList;

my $ModifiedVersionID  = $ModifiedVersions[0];
my $ModifiedVersionID2 = $ModifiedVersions[1];

my @Tests = (
    {
        Description => "No Name, and no CurrentModifiedVersionID",
        Success     => 0,
    },
    {
        Description       => "WrongName",
        Name              => 'AWrongSettingName',
        ModifiedVersionID => $ModifiedVersionID,
        Success           => 0,
    },
    {
        Description => "Correct name, no ModifiedVersionID",
        Name        => "Test0$RandomID",
        Success     => 0,
    },
    {
        Description       => "Correct Name,",
        Name              => "Test1$RandomID",
        ModifiedVersionID => $ModifiedVersionID,
        Success           => 1,
        ExpectedResult    => 'ModifiedValue',
    },
    {
        Description       => "Previous modified, but last was reset to default.",
        Name              => "Test2$RandomID",
        ModifiedVersionID => $ModifiedVersionID2,
        Success           => 1,
        ExpectedResult    => 'ModifiedValue',
    },
);

for my $Test (@Tests) {

    my %Result = $SysConfigObject->SettingPreviousValueGet(
        Name              => $Test->{Name}              || undef,
        ModifiedID        => $Test->{ModifiedID}        || undef,
        ModifiedVersionID => $Test->{ModifiedVersionID} || undef,
    );

    if ( $Test->{Success} ) {

        $Self->Is(
            $Result{EffectiveValue},
            $Test->{ExpectedResult},
            "Success - $Test->{Description}",
        );
    }
    else {

        $Self->False(
            IsHashRefWithData( \%Result ) ? 1 : 0,
            "Not success - $Test->{Description}",
        );
    }
}

$Self->DoneTesting();
