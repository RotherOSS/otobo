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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# clear some tables
for my $Table (qw(sysconfig_modified_version sysconfig_modified sysconfig_default_version sysconfig_default)) {
    my $DoSuccess = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM $Table",
    );

    skip_all("cannot delete from $Table") unless $DoSuccess;
}

#
# Prepare valid config XML and Perl
#
my $ValidSettingXML = <<'EOF',
<?xml version="1.0" encoding="utf-8" ?>
<otobo_config version="2.0" init="Framework">
    <Setting Name="Test1" Required="1" Valid="1">
        <Description Translatable="1">Test 1.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="String" ValueRegex=".*">Test setting 1</Item>
        </Value>
    </Setting>
    <Setting Name="Test2" Required="1" Valid="1">
        <Description Translatable="1">Test 2.</Description>
        <Navigation>Core::Ticket</Navigation>
        <Value>
            <Item ValueType="File">/usr/bin/gpg</Item>
        </Value>
    </Setting>
</otobo_config>
EOF

    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');

my @DefaultSettingAddParams = $SysConfigXMLObject->SettingListParse(
    XMLInput => $ValidSettingXML,
);

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Add default setting s
my $SettingName1      = 'ProductName ' . $Helper->GetRandomNumber() . 1;
my $DefaultSettingID1 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName1,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 1',
    UserID                   => 1,
);

my $SettingName2      = 'ProductName ' . $Helper->GetRandomNumber() . 2;
my $DefaultSettingID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName2,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 2',
    UserID                   => 1,
);

my $SettingName3      = 'ProductName ' . $Helper->GetRandomNumber() . 3;
my $DefaultSettingID3 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName3,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 3',
    UserID                   => 1,
);

my $SettingName4      = 'ProductName ' . $Helper->GetRandomNumber() . 4;
my $DefaultSettingID4 = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName4,
    Description              => 'Defines the name of the application ...',
    Navigation               => 'ASimple::Path::Structure',
    IsInvisible              => 1,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 200,
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    XMLContentRaw            => $DefaultSettingAddParams[0]->{XMLContentRaw},
    XMLContentParsed         => $DefaultSettingAddParams[0]->{XMLContentParsed},
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test setting 4',
    UserID                   => 1,
);

my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    LockAll => 1,
    Force   => 1,
    UserID  => 1,
);

# Create a effective user modified setting
my $ModifiedIDUser = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID1,
    Name              => $SettingName1,
    IsValid           => 1,
    EffectiveValue    => 'User setting 1',
    TargetUserID      => 1,
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);

$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    LockAll => 1,
    Force   => 1,
    UserID  => 1,
);
my $ModifiedID1 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID1,
    Name              => $SettingName1,
    IsValid           => 1,
    EffectiveValue    => 'Modified setting 1',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);

my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID2,
    Name              => $SettingName2,
    IsValid           => 1,
    EffectiveValue    => 'Modified setting 2',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);

my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate();

my $ExclusiveLockGUID2 = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultSettingID3,
    Force     => 1,
    UserID    => $UserID,
);
my $ModifiedID3 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultSettingID3,
    Name              => $SettingName3,
    IsValid           => 1,
    EffectiveValue    => 'Modified setting 3',
    ExclusiveLockGUID => $ExclusiveLockGUID2,
    UserID            => $UserID,
);

my @Tests = (
    {
        Name   => "Invalid TargetUserID",
        Config => {
            TargetUserID => $TestUserLogin,
        },
    },
    {
        Name   => "Invalid ModifiedIDs",
        Config => {
            ModifiedIDs => $TestUserLogin,
        },
    },
    {
        Name   => "Empty ModifiedIDs",
        Config => {
            ModifiedIDs => [],
        },
    },
    {
        Name   => "Wrong TargetUserID",
        Config => {
            TargetUserID => $UserID,
        },
        ExpectedResults => [ $ModifiedIDUser, $ModifiedID1, $ModifiedID2, $ModifiedID3 ],
        Success         => 1,
    },
    {
        Name   => "Clean settings for user 1",
        Config => {
            TargetUserID => 1,
        },
        ExpectedResults => [ $ModifiedID1, $ModifiedID2, $ModifiedID3 ],
        Success         => 1,
    },
    {
        Name   => "Global for ModifiedID1",
        Config => {
            ModifiedIDs => [$ModifiedID1],
        },
        ExpectedResults => [ $ModifiedID2, $ModifiedID3 ],
        Success         => 1,
    },
    {
        Name            => "Global All",
        Config          => {},
        ExpectedResults => [],
        Success         => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my $Success = $SysConfigDBObject->ModifiedSettingDirtyCleanUp( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} ModifiedSettingDirtyCleanUp() with False",
        );

        next TEST;
    }

    $Self->True(
        $Success,
        "$Test->{Name} ModifiedSettingDirtyCleanUp() with Success",
    );

    my @List = $SysConfigDBObject->ModifiedSettingListGet(
        IsDirty => 1,
    );

    my @SettingIDs = map { $_->{ModifiedID} } @List;

    $Self->IsDeeply(
        \@SettingIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} Settings List after ModifiedSettingDirtyCleanUp()",
    );

}

$Self->DoneTesting();
