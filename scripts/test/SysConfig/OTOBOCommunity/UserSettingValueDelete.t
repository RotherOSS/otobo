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
my $UserID       = 1;

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
    ChangeUserID  => $UserID,
) || die "Could not create test user";

my $TestUserID2;
my $UserRand2 = 'example-user2' . $RandomID;
$TestUserID2 = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test2',
    UserLastname  => 'Lastname Test2',
    UserLogin     => $UserRand2,
    UserEmail     => $UserRand2 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => $UserID,
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
    UserID                   => $UserID,
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

my @Tests = (
    {
        Name   => 'Correct reset all with Global value',
        Params => {
            Name       => $SettingName,
            ModifiedID => 'All',
            UserID     => $UserID,
        },
        ExpectedResult => {
            Name                   => $SettingName,
            EffectiveValue         => 'Test',
            TargetUserID           => undef,
            DefaultID              => $DefaultSettingID,
            IsValid                => 1,
            IsDirty                => 1,
            ResetToDefault         => 1,
            UserModificationActive => 1
        },
        AddGlobal => 1,
        Success   => 1,
    },
    {
        Name   => 'Correct reset all',
        Params => {
            Name       => $SettingName,
            ModifiedID => 'All',
            UserID     => $UserID,
        },
        ExpectedResult => {
            Name                   => $SettingName,
            EffectiveValue         => 'Test',
            TargetUserID           => undef,
            DefaultID              => $DefaultSettingID,
            IsValid                => 1,
            IsDirty                => 1,
            ResetToDefault         => 1,
            UserModificationActive => 1
        },
        Success => 1,
    },
    {
        Name   => 'Correct reset individual with Global value',
        Params => {
            Name       => $SettingName,
            ModifiedID => 'CHANGEIT',
            UserID     => $UserID,
        },
        ExpectedResult => {
            Name                   => $SettingName,
            EffectiveValue         => 'Test',
            TargetUserID           => undef,
            DefaultID              => $DefaultSettingID,
            IsValid                => 1,
            IsDirty                => 1,
            ResetToDefault         => 1,
            UserModificationActive => 1
        },
        AddGlobal => 1,
        Success   => 1,
    },
    {
        Name   => 'Correct reset individual',
        Params => {
            Name       => $SettingName,
            ModifiedID => 'CHANGEIT',
            UserID     => $UserID,
        },
        ExpectedResult => {
            Name                   => $SettingName,
            EffectiveValue         => 'Test',
            TargetUserID           => undef,
            DefaultID              => $DefaultSettingID,
            IsValid                => 1,
            IsDirty                => 1,
            ResetToDefault         => 1,
            UserModificationActive => 1
        },
        Success => 1,
    },
    {
        Name   => 'Setting wrong name',
        Params => {
            Name       => 'AWrongName',
            ModifiedID => 'ADummyValue',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'No setting name',
        Params => {
            ModifiedID => 'ADummyValue',
            UserID     => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'Not UserID',
        Params => {
            Name       => 'AWrongName',
            ModifiedID => 'ADummyValue',
        },
        Success => 0,
    },
    {
        Name   => 'No modified id',
        Params => {
            Name   => 'AWrongName',
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name   => 'A wrong ModifiedID',    # should pass and return success due not elements to update found
        Params => {
            Name       => $SettingName,
            ModifiedID => 'ThisShouldPass',
            UserID     => $UserID,
        },
        Success => 1,
    },
);

TEST:
for my $Test (@Tests) {

    my @KeepSettingIDs;
    my @DeletedSettingIDs;

    my $Result;

    # Add some modified settings
    if ( $Test->{AddGlobal} ) {    # Add global entry
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
            EffectiveValue    => 'A Different Product Name',
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        $Result = $ModifiedSettingID ? 1 : 0;
        $Self->True(
            $Result,
            'ModifiedSettingAdd() - Testing global.',
        );

        # Not Result means next tests will fail any way
        # due not ModifiedSettingID available.
        next TEST if !$Result;

        # Store it for later.
        push @KeepSettingIDs, $ModifiedSettingID;
    }

    my $ModifiedSettingID1 = $SysConfigDBObject->ModifiedSettingAdd(
        %ModifiedSettingAddTemplate,
        %{ $DefaultSettingAddParams[0] },
        TargetUserID => $TestUserID1,
        UserID       => $TestUserID1,
    );

    $Result = $ModifiedSettingID1 ? 1 : 0;
    $Self->True(
        $Result,
        'ModifiedSettingAdd() - Testing One.',
    );

    # Not Result means next tests will fail any way
    # due not ModifiedSettingID available.
    next TEST if !$Result;

    if ( $Test->{Params}->{ModifiedID} ne 'All' ) {

        # Store it for later.
        push @KeepSettingIDs, $ModifiedSettingID1;
    }
    else {
        # Store it for later.
        push @DeletedSettingIDs, $ModifiedSettingID1;
    }

    my $ModifiedSettingID2 = $SysConfigDBObject->ModifiedSettingAdd(
        %ModifiedSettingAddTemplate,
        %{ $DefaultSettingAddParams[1] },
        TargetUserID => $TestUserID2,
        UserID       => $TestUserID2,
    );

    $Result = $ModifiedSettingID2 ? 1 : 0;
    $Self->True(
        $Result,
        'ModifiedSettingAdd() - Testing Two.',
    );

    # Not Result means next tests will fail any way
    # due not ModifiedSettingID available.
    next TEST if !$Result;

    if ( $Test->{Params}->{ModifiedID} ne 'All' ) {
        $Test->{Params}->{ModifiedID} = $ModifiedSettingID2;
    }

    if ( !$Test->{Success} ) {

        # Store it for later.
        push @KeepSettingIDs, $ModifiedSettingID2;
    }
    else {
        # Store it for later.
        push @DeletedSettingIDs, $ModifiedSettingID2;
    }

    # Store it for later.
    push @DeletedSettingIDs, $ModifiedSettingID2;

    my $Success = $SysConfigObject->UserSettingValueDelete(
        %{ $Test->{Params} },

        # ExclusiveLockGUID => $ExclusiveLockGUID,
    );

    if ( $Test->{Success} ) {

        # Deleted modified settings
        my @ModifiedSettingListGet = $SysConfigDBObject->ModifiedSettingListGet(
            Name => $SettingName,
        );

        my @ModifiedSettingListGetIDs = map { $_->{ModifiedID} } @ModifiedSettingListGet;

        $Self->IsDeeply(
            \@ModifiedSettingListGetIDs,
            \@KeepSettingIDs,
            "Check the remaining entries are correct.",
        );
    }

    for my $ModifiedID (@KeepSettingIDs) {

        # Deleted modified settings
        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            ModifiedID => $ModifiedID,
        );

        $Self->True(
            IsHashRefWithData( \%ModifiedSetting ) ? 1 : 0,
            "ModifiedSettingGet() must return the user setting: $ModifiedID.",
        );

        my $Result = $SysConfigDBObject->ModifiedSettingDelete( ModifiedID => $ModifiedID );
        $Self->True(
            $Result,
            'ModifiedSettingDelete() must succeed.',
        );

        # Delete modified settings
        %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            ModifiedID => $ModifiedID,
        );
        $Self->False(
            IsHashRefWithData( \%ModifiedSetting ) ? 1 : 0,
            "ModifiedSettingGet() user setting: $ModifiedID should be deleted.",
        );
    }

}

# cleanup system.
my $Home = $ConfigObject->Get('Home');
for my $UserID ( $TestUserID1, $TestUserID2 ) {
    my $File = "$Home/Kernel/Config/Files/User/$UserID.pm";
    if ( -e $File ) {
        unlink $File;
    }
}

$Self->DoneTesting();
