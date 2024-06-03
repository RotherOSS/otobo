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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

my $UserID = 1;

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
</otobo_config>
EOF
    ;

# Get parsed settings.
my @ParsedSettings = $Kernel::OM->Get('Kernel::System::SysConfig::XML')->SettingListParse(
    XMLInput    => $SetingsXML,
    XMLFilename => "UnitTestXML",
);

my $XMLContentParsed;
if (@ParsedSettings) {
    $XMLContentParsed = $ParsedSettings[0]->{XMLContentParsed};
}

my $Value = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
    Data => $XMLContentParsed->{Value},
);

my $EffectiveValue = $SysConfigObject->SettingEffectiveValueGet(
    Value => $Value,
);

my $RandomID    = $HelperObject->GetRandomID();
my $SettingName = "Test$RandomID";

# Get SysConfig DB object.
my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $DefaultID = $SysConfigDBObject->DefaultSettingAdd(
    Name                     => $SettingName,
    Description              => "Test.",
    Navigation               => "Core::Test",
    IsInvisible              => 0,
    IsReadonly               => 0,
    IsRequired               => 1,
    IsValid                  => 1,
    HasConfigLevel           => 0,
    XMLContentRaw            => $SetingsXML,
    XMLContentParsed         => $XMLContentParsed,
    EffectiveValue           => $EffectiveValue,
    XMLFilename              => 'Framework',
    UserModificationPossible => 0,
    UserModificationActive   => 0,
    UserID                   => 1,
);
$Self->True(
    $DefaultID,
    "DefaultSettingAdd() - Test",
);

my @TrackingHistory;

# Check setting history.
my @DefaultSettings = $SysConfigDBObject->DefaultSettingVersionListGet(
    Name => $SettingName,
);

my @ModifiedSettings = $SysConfigDBObject->DefaultSettingVersionListGet(
    DefaultID => $DefaultID,
);

my %DefaultSetting = %{ $DefaultSettings[0] };

@TrackingHistory = (
    {
        Default  => \%{ $DefaultSettings[0] },
        Modified => \%{ $ModifiedSettings[0] },
    },
);

my @SettingHistory = $SysConfigObject->SettingHistory(
    Name => $SettingName,
);

$Self->True(
    $SettingHistory[0]->{Modified}->{OnlyDefault},
    "History contains OnlyDefault (since there is no other modified version)",
);

delete $SettingHistory[0]->{Modified}->{OnlyDefault};

$Self->IsDeeply(
    \@TrackingHistory,
    \@SettingHistory,
    "Checking first step history.",
);

my @Tests = (

    {
        Description    => "First try should be a ModifiedSettingAdd",
        Name           => "Test1$RandomID",
        Type           => "Modified",
        EffectiveValue => 'ModifiedValue',
    },
    {
        Description => "Modififed the setting structure",
        Name        => "Test1$RandomID",
        Type        => "Default",
        Navigation  => "ASimple::Path::Structure",
    },
    {
        Description    => "Second try should be a ModifiedSettingAdd",
        Name           => "Test1$RandomID",
        Type           => "Modified",
        EffectiveValue => 'SecondModification',
    },
    {
        Description => "Change the default definition again",
        Name        => "Test1$RandomID",
        Type        => "Default",
        Navigation  => "Changing::The::Navigation::ForThis::Setting",
    },
    {
        Description    => "Third try should be a ModifiedSettingAdd",
        Name           => "Test1$RandomID",
        Type           => "Modified",
        EffectiveValue => 'ThirdModification',
    },
);

my @TrackingModifiedHistory;

TEST:
for my $Test (@Tests) {

    # Lock
    my $GuID = $SysConfigDBObject->DefaultSettingLock(
        DefaultID => $DefaultID,
        UserID    => 1,
    );

    $Self->True(
        $GuID,
        "Check if locked before update."
    );

    if ( $Test->{Type} eq 'Modified' ) {

        # Perform a change for modified
        $DefaultSetting{EffectiveValue} = $Test->{EffectiveValue};

        # Update item
        my %SettingUpdateResult = $SysConfigObject->SettingUpdate(
            %DefaultSetting,
            ExclusiveLockGUID => $GuID,
            UserID            => $UserID,
        );

        $Self->IsNot(
            $SettingUpdateResult{Success},
            undef,
            "SettingUpdate success.",
        );

        $DeploymentOnly->();
    }
    elsif ( $Test->{Type} eq 'Default' ) {

        # Perform a change for modified
        $DefaultSetting{Navigation} = $Test->{Navigation};

        # Update item
        my $DefaultSettingUpdateSuccess = $SysConfigDBObject->DefaultSettingUpdate(
            %DefaultSetting,
            ExclusiveLockGUID => $GuID,
            UserID            => $UserID,
        );
        $Self->True(
            $DefaultSettingUpdateSuccess,
            "Successful default update.",
        );
        next TEST;
    }

    # Re-construct the history.
    my %HistoryEntry;

    my @ModifiedSettingVersionList = $SysConfigDBObject->ModifiedSettingVersionListGet(
        Name => $SettingName,
    );

    my $ModifiedVersion = $ModifiedSettingVersionList[0];

    # Get corresponding default version
    my %DefaultSettingVersion = $SysConfigDBObject->DefaultSettingVersionGet(
        DefaultVersionID => $ModifiedVersion->{DefaultVersionID},
    );

    $HistoryEntry{Default} = \%DefaultSettingVersion;

    # Update setting attributes.
    ATTRIBUTE:
    for my $Attribute ( sort keys %DefaultSettingVersion ) {
        next ATTRIBUTE if defined $ModifiedVersion->{$Attribute};
        $ModifiedVersion->{$Attribute} = $DefaultSettingVersion{$Attribute};
    }
    $HistoryEntry{Modified} = $ModifiedVersion;

    unshift @TrackingModifiedHistory, \%HistoryEntry;

    my @SettingModifiedHistory = $SysConfigObject->SettingHistory(
        Name => $SettingName,
    );

    # Check results.
    $Self->IsDeeply(
        \@TrackingModifiedHistory,
        \@SettingModifiedHistory,
        $Test->{Description},
    );
}

$Self->DoneTesting();
