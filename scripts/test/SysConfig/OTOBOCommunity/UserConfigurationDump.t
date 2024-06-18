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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# clear some tables
for my $Table (qw(sysconfig_modified_version sysconfig_modified sysconfig_default_version sysconfig_default)) {
    my $DoSuccess = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM $Table",
    );

    skip_all("cannot delete from $Table") unless $DoSuccess;
}

my $RandomID = $HelperObject->GetRandomID();

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Create new default settings.
my $DefaultID1 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => "Test1$RandomID",
    Description      => "Test.",
    Navigation       => "Test",
    XMLContentRaw    => '<>',
    XMLContentParsed => {
        Test => 'Test',
    },
    XMLFilename    => 'UnitTest.xml',
    EffectiveValue => 'Test',
    UserID         => 1,
);
$Self->IsNot(
    $DefaultID1,
    undef,
    "DefaultSettingAdd() for Test1$RandomID",
);
my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
    Name             => "Test2$RandomID",
    Description      => "Test.",
    Navigation       => "Test",
    XMLContentRaw    => '<>',
    XMLContentParsed => {
        Test => 'Test',
    },
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test',
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID2,
    undef,
    "DefaultSettingAdd() for Test2$RandomID",
);

# Create new modified settings.
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID1,
    Force     => 1,
    UserID    => 1,
);
my $ModifiedID1 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID1,
    Name              => "Test1$RandomID",
    EffectiveValue    => 'TestUpdate',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
my $Success = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID1,
);
$Self->IsNot(
    $ModifiedID1,
    undef,
    "ModifiedSettingAdd() for Test1$RandomID",
);
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID2,
    Force     => 1,
    UserID    => 1,
);
my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID2,
    Name              => "Test2$RandomID",
    EffectiveValue    => 'TestUpdate',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Success = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID2,
);
$Self->IsNot(
    $ModifiedID2,
    undef,
    "ModifiedSettingAdd() for Test2$RandomID",
);

# Create new users.
my $TestUserLogin1 = $HelperObject->TestUserCreate();
my $TestUserLogin2 = $HelperObject->TestUserCreate();

my $UserObject  = $Kernel::OM->Get('Kernel::System::User');
my $TestUserID1 = $UserObject->UserLookup( UserLogin => $TestUserLogin1 );
my $TestUserID2 = $UserObject->UserLookup( UserLogin => $TestUserLogin2 );

# Create new user settings.
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID2,
    Force     => 1,
    UserID    => $TestUserID1,
);
my $ModifiedUserID1 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID2,
    Name              => "Test2$RandomID",
    EffectiveValue    => 'TestUser',
    TargetUserID      => $TestUserID1,
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => $TestUserID1,
);
$Success = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID2,
);
$Self->IsNot(
    $ModifiedUserID1,
    undef,
    "ModifiedSettingAdd() for Test2$RandomID for user $TestUserLogin1",
);
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID2,
    Force     => 1,
    UserID    => $TestUserID2,
);
my $ModifiedUserID2 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID2,
    Name              => "Test2$RandomID",
    EffectiveValue    => 'TestUser',
    TargetUserID      => $TestUserID2,
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => $TestUserID2,
);
$Success = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID2,
);
$Self->IsNot(
    $ModifiedUserID2,
    undef,
    "ModifiedSettingAdd() for Test2$RandomID for user $TestUserLogin2",
);

# Get All Settings.
my %DefaultSetting1 = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID1,
);
my %DefaultSetting2 = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID2,
);
my %ModifiedSetting1 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID1,
);
my %ModifiedSetting2 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID2,
);
my %ModifiedUserSetting1 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedUserID1,
);
my %ModifiedUserSetting2 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedUserID2,
);

my @Tests = (
    {
        Name          => 'Full',
        Config        => {},
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
            "$TestUserLogin1" => {
                "Test2$RandomID" => \%ModifiedUserSetting1,
            },
            "$TestUserLogin2" => {
                "Test2$RandomID" => \%ModifiedUserSetting2,
            },
        },
    },
    {
        Name   => 'Skip Default',
        Config => {
            SkipDefaultSettings => 1,
        },
        ExpectedValue => {
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
            "$TestUserLogin1" => {
                "Test2$RandomID" => \%ModifiedUserSetting1,
            },
            "$TestUserLogin2" => {
                "Test2$RandomID" => \%ModifiedUserSetting2,
            },
        },
    },
    {
        Name   => 'Skip Modified',
        Config => {
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
            "$TestUserLogin1" => {
                "Test2$RandomID" => \%ModifiedUserSetting1,
            },
            "$TestUserLogin2" => {
                "Test2$RandomID" => \%ModifiedUserSetting2,
            },
        },
    },
    {
        Name   => 'Skip User',
        Config => {
            SkipUserSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
        },
    },
    {
        Name   => 'Skip All',
        Config => {
            SkipDefaultSettings  => 1,
            SkipModifiedSettings => 1,
            SkipUserSettings     => 1,
        },
        ExpectedValue => {},
    },
    {
        Name   => 'Only Default',
        Config => {
            SkipModifiedSettings => 1,
            SkipUserSettings     => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
            },
        },
    },
    {
        Name   => 'Only Modified',
        Config => {
            SkipDefaultSettings => 1,
            SkipUserSettings    => 1,
        },
        ExpectedValue => {
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
            },
        },
    },
    {
        Name   => 'Only User',
        Config => {
            SkipDefaultSettings  => 1,
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {
            "$TestUserLogin1" => {
                "Test2$RandomID" => \%ModifiedUserSetting1,
            },
            "$TestUserLogin2" => {
                "Test2$RandomID" => \%ModifiedUserSetting2,
            },
        },
    },

    {
        Name   => 'Full (Only Values)',
        Config => {
            OnlyValues => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => $DefaultSetting1{EffectiveValue},
                "Test2$RandomID" => $DefaultSetting2{EffectiveValue},
            },
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
            },
            "$TestUserLogin1" => {
                "Test2$RandomID" => $ModifiedUserSetting1{EffectiveValue},
            },
            "$TestUserLogin2" => {
                "Test2$RandomID" => $ModifiedUserSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip Default (Only Values)',
        Config => {
            OnlyValues          => 1,
            SkipDefaultSettings => 1,
        },
        ExpectedValue => {
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
            },
            "$TestUserLogin1" => {
                "Test2$RandomID" => $ModifiedUserSetting1{EffectiveValue},
            },
            "$TestUserLogin2" => {
                "Test2$RandomID" => $ModifiedUserSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip Modified (Only Values)',
        Config => {
            OnlyValues           => 1,
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => $DefaultSetting1{EffectiveValue},
                "Test2$RandomID" => $DefaultSetting2{EffectiveValue},
            },
            "$TestUserLogin1" => {
                "Test2$RandomID" => $ModifiedUserSetting1{EffectiveValue},
            },
            "$TestUserLogin2" => {
                "Test2$RandomID" => $ModifiedUserSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip User (Only Values)',
        Config => {
            OnlyValues       => 1,
            SkipUserSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => $DefaultSetting1{EffectiveValue},
                "Test2$RandomID" => $DefaultSetting2{EffectiveValue},
            },
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip All (Only Values)',
        Config => {
            OnlyValues           => 1,
            SkipDefaultSettings  => 1,
            SkipModifiedSettings => 1,
            SkipUserSettings     => 1,
        },
        ExpectedValue => {},
    },
);

my $YAMLObject      = $Kernel::OM->Get('Kernel::System::YAML');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

for my $Test (@Tests) {

    my $ConfigurationDumpYAML = $SysConfigObject->ConfigurationDump( %{ $Test->{Config} } );

    my $ConfigurationDumpPerl = $YAMLObject->Load(
        Data => $ConfigurationDumpYAML,
    );

    $Self->IsDeeply(
        $ConfigurationDumpPerl,
        $Test->{ExpectedValue},
        "$Test->{Name} ConfigurationDump() - Result",
    );
}

done_testing();
