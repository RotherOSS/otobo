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

use Kernel::System::VariableCheck qw(:all);

# Get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject      = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my %Setting1 = (
    'Description'      => 'Test::Setting',
    'EffectiveValue'   => '3600',
    'IsValid'          => '1',
    'IsInvisible'      => '1',
    'Name'             => 'Test::Setting',
    'Navigation'       => 'Core',
    'XMLContentParsed' => {
        'Description' => [
            {
                'Content'      => 'Test::Setting',
                'Translatable' => '1',
            },
        ],
        'Name'       => 'Test::Setting',
        'Navigation' => [
            {
                'Content' => 'Core',
            },
        ],
        'Valid'     => '1',
        'Invisible' => '1',
        'Value'     => [
            {
                'Item' => [
                    {
                        'Content'    => '3600',
                        'ValueRegex' => '',
                        'ValueType'  => 'String'
                    },
                ],
            },
        ],
    },
    'XMLContentRaw' => '<Setting Name="Test::Setting" Valid="1" Invisible="1">
        <Description Translatable="1">Test::Setting</Description>
        <Navigation>Core/Navigation>
        <Value>
            <Item ValueType="String" ValueRegex="">3600</Item>
        </Value>
    </Setting>',
    XMLFilename => 'UnitTest.xml',
);

my %Setting2 = (
    'Description'      => 'Test::Setting2',
    'EffectiveValue'   => '3600',
    'IsValid'          => '1',
    'Name'             => 'Test::Setting2',
    'Navigation'       => 'Core',
    'XMLContentParsed' => {
        'Description' => [
            {
                'Content'      => 'Test::Setting2',
                'Translatable' => '1',
            },
        ],
        'Name'       => 'Test::Setting2',
        'Navigation' => [
            {
                'Content' => 'Core',
            },
        ],
        'Valid' => '1',
        'Value' => [
            {
                'Item' => [
                    {
                        'Content'    => '3600',
                        'ValueRegex' => '',
                        'ValueType'  => 'String'
                    },
                ],
            },
        ],
    },
    'XMLContentRaw' => '<Setting Name="Test::Setting2" Valid="1">
        <Description Translatable="1">Test::Setting2</Description>
        <Navigation>Core/Navigation>
        <Value>
            <Item ValueType="String" ValueRegex="">3600</Item>
        </Value>
    </Setting>',
    XMLFilename => 'UnitTest.xml',

);

my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
    %Setting2,
    UserID => 1,
);

$Self->True(
    $DefaultID2,
    "$Setting2{Name} added.",
);

my $ExclusiveLockGUID2 = $SysConfigDBObject->DefaultSettingLock(
    DefaultID => $DefaultID2,
    UserID    => 1,
);

my $ModifiedID2 = $SysConfigDBObject->ModifiedSettingAdd(
    %Setting2,
    DefaultID         => $DefaultID2,
    EffectiveValue    => '4000',
    ExclusiveLockGUID => $ExclusiveLockGUID2,
    UserID            => 1,
);
$Self->True(
    $ModifiedID2,
    "$Setting2{Name} modified.",
);

my %DefaultSettingsHash = ();

my @DefaultSettings = $SysConfigDBObject->DefaultSettingListGet();

for my $Setting (@DefaultSettings) {
    $DefaultSettingsHash{ $Setting->{Name} } = $Setting;
}

my @Tests = (
    {
        Description => '_DBCleanUp - missing Settings parameter',
        Config      => {
        },
        ExpectedResult => undef,
    },
    {
        Description => '_DBCleanUp - Settings not hash',
        Config      => {
            Settings => 'ok',
        },
        ExpectedResult => undef,
    },
    {
        Description => '_DBCleanUp - #2',
        Config      => {
            Settings => \%DefaultSettingsHash,
        },
        AddSettings => [
            \%Setting1,
        ],
        ExpectedResult => '1',
    },
);

for my $Test (@Tests) {
    if ( IsArrayRefWithData( $Test->{AddSettings} ) ) {
        for my $Setting ( @{ $Test->{AddSettings} } ) {
            my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
                %{$Setting},
                UserID => 1,
            );

            $Self->True(
                $DefaultID,
                "$Setting->{Name} added.",
            );

            my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
                DefaultID => $DefaultID,
                UserID    => 1,
            );

            my $ModifiedID1 = $SysConfigDBObject->ModifiedSettingAdd(
                %{$Setting},
                DefaultID         => $DefaultID,
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
            $Self->True(
                $ModifiedID1,
                "$Setting->{Name} modified.",
            );
        }
    }

    my $Result = $SysConfigObject->_DBCleanUp( %{ $Test->{Config} } );
    if ( $Test->{ExpectedResult} ) {
        $Self->True(
            $Result,
            "$Test->{Description} - Result OK."
        );
    }
    else {
        $Self->False(
            $Result,
            "$Test->{Description} - Result not OK."
        );
    }

    # Check if still exists
    if ( IsArrayRefWithData( $Test->{AddSettings} ) ) {
        for my $Setting ( @{ $Test->{AddSettings} } ) {
            my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
                Name => $Setting->{Name},
            );

            $Self->False(
                $DefaultSetting{DefaultID},
                "Default $Setting->{Name} missing after _DBCleanUp.",
            );

            my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
                Name => $Setting->{Name},
            );

            $Self->False(
                $ModifiedSetting{ModifiedID},
                "Modified $Setting->{Name} missing after _DBCleanUp.",
            );
        }
    }
}

# Check if 1st item exists after _DBCleanUp
my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
    Name => $Setting2{Name},
);

$Self->True(
    $DefaultSetting{DefaultID},
    "Default $Setting2{Name} still exists after _DBCleanUp.",
);

my %ModifiedSetting2 = $SysConfigDBObject->ModifiedSettingGet(
    Name => $Setting2{Name},
);

$Self->True(
    $ModifiedSetting2{ModifiedID},
    "Modified $Setting2{Name} still exists after _DBCleanUp.",
);

$Self->DoneTesting();
