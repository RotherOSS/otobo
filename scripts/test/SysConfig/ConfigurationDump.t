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

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

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
ok( $DefaultID1, "DefaultSettingAdd() for Test1$RandomID" );

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
ok( $DefaultID2, "DefaultSettingAdd() for Test2$RandomID" );

my $DefaultID3 = $SysConfigDBObject->DefaultSettingAdd(
    Name          => "Test3$RandomID",
    Description   => "Test.",
    Navigation    => "Test",
    XMLContentRaw => <<'END_XML',
    <Setting Name="Large::Colored::Circles" Required="0" Valid="0">
        <Description Translatable="1">Define possible namespaces for dynamic fields.</Description>
        <Navigation>Core::DynamicFields</Navigation>
        <Value>
            <Array>
                <Item>🟠 - U+1F7E0 - LARGE ORANGE CIRCLE</Item>
                <Item>🟡 - U+1F7E1 - LARGE YELLOW CIRCLE</Item>
                <Item>🟢 - U+1F7E2 - LARGE GREEN CIRCLE</Item>
                <Item>🟣 - U+1F7E3 - LARGE PURPLE CIRCLE</Item>
                <Item>🟤 - U+1F7E4 - LARGE BROWN CIRCLE</Item>
            </Array>
        </Value>
    </Setting>
END_XML
    XMLContentParsed => [
        '🟠 - U+1F7E0 - LARGE ORANGE CIRCLE',
        '🟡 - U+1F7E1 - LARGE YELLOW CIRCLE',
        '🟢 - U+1F7E2 - LARGE GREEN CIRCLE',
        '🟣 - U+1F7E3 - LARGE PURPLE CIRCLE',
        '🟤 - U+1F7E4 - LARGE BROWN CIRCLE',
    ],
    XMLFilename              => 'UnitTest.xml',
    EffectiveValue           => 'Test',
    UserModificationPossible => 1,
    UserModificationActive   => 1,
    UserID                   => 1,
);
ok( $DefaultID2, "DefaultSettingAdd() for Test3$RandomID" );

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
ok( $ModifiedID1, "ModifiedSettingAdd() for Test1$RandomID" );

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
ok( $ModifiedID2, "ModifiedSettingAdd() for Test2$RandomID" );

$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID3,
    Force     => 1,
    UserID    => 1,
);
my $ModifiedID3 = $SysConfigDBObject->ModifiedSettingAdd(
    DefaultID         => $DefaultID3,
    Name              => "Test3$RandomID",
    EffectiveValue    => 'TestUpdate',
    ExclusiveLockGUID => $ExclusiveLockGUID,
    UserID            => 1,
);
$Success = $SysConfigDBObject->DefaultSettingUnlock(
    DefaultID => $DefaultID3,
);
ok( $ModifiedID3, "ModifiedSettingAdd() for Test3$RandomID" );

# Get All Settings.
my %DefaultSetting1 = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID1,
);
my %DefaultSetting2 = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID2,
);
my %DefaultSetting3 = $SysConfigDBObject->DefaultSettingGet(
    DefaultID => $DefaultID3,
);
my %ModifiedSetting1 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID1,
);
my %ModifiedSetting2 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID2,
);
my %ModifiedSetting3 = $SysConfigDBObject->ModifiedSettingGet(
    ModifiedID => $ModifiedID3,
);

my @Tests = (
    {
        Name          => 'Full',
        Config        => {},
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
                "Test3$RandomID" => \%DefaultSetting3,
            },
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
                "Test3$RandomID" => \%ModifiedSetting3,
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
                "Test3$RandomID" => \%ModifiedSetting3,
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
                "Test3$RandomID" => \%DefaultSetting3,
            },
        },
    },
    {
        Name          => 'Skip User',
        Config        => {},
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
                "Test3$RandomID" => \%DefaultSetting3,
            },
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
                "Test3$RandomID" => \%ModifiedSetting3,
            },
        },
    },
    {
        Name   => 'Skip All',
        Config => {
            SkipDefaultSettings  => 1,
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {},
    },
    {
        Name   => 'Only Default',
        Config => {
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => \%DefaultSetting1,
                "Test2$RandomID" => \%DefaultSetting2,
                "Test3$RandomID" => \%DefaultSetting3,
            },
        },
    },
    {
        Name   => 'Only Modified',
        Config => {
            SkipDefaultSettings => 1,
        },
        ExpectedValue => {
            Modified => {
                "Test1$RandomID" => \%ModifiedSetting1,
                "Test2$RandomID" => \%ModifiedSetting2,
                "Test3$RandomID" => \%ModifiedSetting3,
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
                "Test3$RandomID" => $DefaultSetting3{EffectiveValue},
            },
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
                "Test3$RandomID" => $ModifiedSetting3{EffectiveValue},
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
                "Test3$RandomID" => $ModifiedSetting3{EffectiveValue},
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
                "Test3$RandomID" => $DefaultSetting3{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip User (Only Values)',
        Config => {
            OnlyValues => 1,
        },
        ExpectedValue => {
            Default => {
                "Test1$RandomID" => $DefaultSetting1{EffectiveValue},
                "Test2$RandomID" => $DefaultSetting2{EffectiveValue},
                "Test3$RandomID" => $DefaultSetting3{EffectiveValue},
            },
            Modified => {
                "Test1$RandomID" => $ModifiedSetting1{EffectiveValue},
                "Test2$RandomID" => $ModifiedSetting2{EffectiveValue},
                "Test3$RandomID" => $ModifiedSetting3{EffectiveValue},
            },
        },
    },
    {
        Name   => 'Skip All (Only Values)',
        Config => {
            OnlyValues           => 1,
            SkipDefaultSettings  => 1,
            SkipModifiedSettings => 1,
        },
        ExpectedValue => {},
    },
);

my $YAMLObject      = $Kernel::OM->Get('Kernel::System::YAML');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $Cnt = 0;
for my $Test (@Tests) {
    $Cnt++;

    my $ConfigurationDumpYAML = $SysConfigObject->ConfigurationDump( $Test->{Config}->%* );

    my $ConfigurationDumpPerl = $YAMLObject->Load(
        Data => $ConfigurationDumpYAML,
    );

    is(
        $ConfigurationDumpPerl,
        $Test->{ExpectedValue},
        "$Test->{Name} ConfigurationDump() - Result",
    );
}

done_testing;
