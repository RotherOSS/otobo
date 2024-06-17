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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $UserID = 1;

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# clear some tables
for my $Table (qw(sysconfig_modified_version sysconfig_modified sysconfig_deployment)) {
    my $DoSuccess = $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => "DELETE FROM $Table",
    );

    skip_all("cannot delete from $Table") unless $DoSuccess;
}

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
</otobo_config>
EOF

    # Get SysConfig XML object.
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# Make sure the system is clean (and no other dirty settings will be deployed)
my $DeploySuccess = $SysConfigObject->ConfigurationDeploy(
    Comments    => "Unit Test",
    AllSettings => 1,
    UserID      => 1,
    Force       => 1,
);
$Self->True(
    $DeploySuccess,
    "Cleanup Deployment success with true",
);

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
    UserModificationPossible => 1,
    UserID                   => 1,
);
$Self->IsNot(
    $DefaultID1,
    0,
    "DefaultSettingAdd() - Test1",
);

push @DefaultIDs, $DefaultID1;

# Lock setting (so it can be updated).
my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => $UserID,
    Force     => 1,
    DefaultID => $DefaultID0,
);

$Self->True(
    $ExclusiveLockGUID,
    "DefaultSettingLock Zero",
);

my %Result = $SysConfigObject->SettingUpdate(
    DefaultID         => $DefaultID0,
    Name              => "Test0$RandomID",
    EffectiveValue    => 'Test Update 0',
    UserID            => $UserID,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);

$Self->True(
    $Result{Success},
    "SettingUpdate() - Zero",
);

# Lock setting (so it can be updated).
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => $UserID,
    Force     => 1,
    DefaultID => $DefaultID1,
);

$Self->True(
    $ExclusiveLockGUID,
    "DefaultSettingLock One",
);

%Result = $SysConfigObject->SettingUpdate(
    DefaultID         => $DefaultID1,
    Name              => "Test1$RandomID",
    EffectiveValue    => 'Test Update 1',
    UserID            => $UserID,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);

$Self->True(
    $Result{Success},
    "SettingUpdate() - One",
);

my $PrepareLockTests = sub {
    my %Param = @_;

    my $Test = $Param{Test};

    my $ExclusiveLockGUID;
    if ( $Test->{Lock} ) {
        $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
            UserID => 1,
        );
        $Self->IsNot(
            $ExclusiveLockGUID,
            undef,
            "$Test->{Name} - DeploymentLock()",
        );
    }

    if ( $Test->{Unlock} ) {
        if ( $Test->{Unlock} ne 'All' && !$ExclusiveLockGUID ) {
            my $Success = $SysConfigDBObject->DeploymentUnlock(
                All => 1,
            );
            $Self->True(
                0,
                "$Test->{Name} - EXCEPTION - Unlock call without previous ExclusiveLockGUID, skipping test",
            );
            next TEST;
        }
        elsif ($ExclusiveLockGUID) {
            my $Success = $SysConfigDBObject->DeploymentUnlock(
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
            $Self->IsNot(
                $Success,
                undef,
                "$Test->{Name} - DeploymentUnlock() user",
            );
        }
        elsif ($ExclusiveLockGUID) {
            my $Success = $SysConfigDBObject->DeploymentUnlock(
                All => 1,
            );
            $Self->IsNot(
                $Success,
                undef,
                "$Test->{Name} - DeploymentUnlock() user",
            );
        }
    }

    if ( $Test->{AddSeconds} ) {
        FixedTimeAddSeconds( $Test->{AddSeconds} );
    }

    return $ExclusiveLockGUID;
};

my %LockingSettings = (
    Name    => 'Deployment UnitTest',
    Lock    => 1,
    Success => 1,
);
$ExclusiveLockGUID = $PrepareLockTests->( Test => \%LockingSettings );

my $EffectiveValueStrgFile = <<"EOF";
# OTOBO config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZAAuto;
use strict;
use warnings;
no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
use utf8;

 sub Load {
    \$Self->{Test0$RandomID} = 'Test Update 0';
    \$Self->{Test1$RandomID} = 'Test Update 1';
}
1;
EOF

# Get system time stamp (string formated).
my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime'
);
my $TimeStamp = $DateTimeObject->ToString();

my $SysConfigObjectDB = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

# Get all dirty modified settings.
my @DirtyModifiedList = $SysConfigObjectDB->ModifiedSettingListGet(
    IsGlobal => 1,
    IsDirty  => 1,
);

# Create a new version for the modified settings.
SETTING:
for my $Setting (@DirtyModifiedList) {
    my %DefaultSettingVersionGetLast = $SysConfigDBObject->DefaultSettingVersionGetLast(
        DefaultID => $Setting->{DefaultID},
    );
    my $ModifiedVersionID = $SysConfigObjectDB->ModifiedSettingVersionAdd(
        %{$Setting},
        DefaultVersionID    => $DefaultSettingVersionGetLast{DefaultVersionID},
        DeploymentTimeStamp => $TimeStamp,
        UserID              => 1,
    );
}

my $DeploymentID0 = $SysConfigDBObject->DeploymentAdd(
    Comments            => 'UnitTest',
    EffectiveValueStrg  => \$EffectiveValueStrgFile,
    ExclusiveLockGUID   => $ExclusiveLockGUID,
    DeploymentTimeStamp => $TimeStamp,
    UserID              => 1,
);

$Self->IsNot(
    $DeploymentID0,
    undef,
    "Initial DeploymentAdd()",
);

# Check if deployment exists
my %ModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
    DeploymentID => $DeploymentID0,
);

my @ModifiedVersions = sort keys %ModifiedVersionList;

# Be sure we have an ordered list.
@DefaultIDs = sort @DefaultIDs;

for my $ModifiedVersionID ( sort @ModifiedVersions ) {

    my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
        ModifiedVersionID => $ModifiedVersionID,
    );

    my @IsPresent = grep { $_ eq $ModifiedSettingVersion{DefaultID} } @DefaultIDs;

    $Self->True(
        scalar @IsPresent,
        "DeploymentModifiedVersionList is present on ModifiedSettingVersionGet - $ModifiedVersionID",
    );

}

# Make sure there is no deployment lock.
my $Success = $SysConfigDBObject->DeploymentUnlock(
    All => 1,
);
$Self->True(
    $Success,
    "DeploymentUnlock() call with true",
);

for my $ModifiedVersionID ( sort @ModifiedVersions ) {

    my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
        ModifiedVersionID => $ModifiedVersionID,
    );

    my @Tests = (
        {
            Description       => "Good Values",
            Name              => $ModifiedSettingVersion{Name},
            ModifiedVersionID => $ModifiedVersionID,
            UserID            => 1,
            Success           => 1,
        },
        {
            Description       => "Wrong name of Version",
            Name              => 'Klaus',
            ModifiedVersionID => $ModifiedVersionID,
            UserID            => 1,
            Success           => 0,
        },
        {
            Description       => "No name",
            ModifiedVersionID => $ModifiedVersionID,
            UserID            => 1,
            Success           => 0,
        },
    );

    TESTS:
    for my $Test (@Tests) {

        my %Settings;
        for my $Key (qw(Name ModifiedVersionID UserID)) {
            if ( $Test->{$Key} ) {
                $Settings{$Key} = $Test->{$Key};
            }
        }

        my $Return = $SysConfigObject->SettingRevertHistoricalValue(
            %Settings,
        );

        if ( $Test->{Success} ) {
            $Self->True(
                $Return,
                $Test->{Description} . ' was OK',
            );
        }
        else {
            $Self->False(
                $Return,
                $Test->{Description} . ' went wrong as expected',
            );
        }
    }

}

# Create a new deployment to be able to go into deployment history
# Lock setting (so it can be updated).
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => $UserID,
    Force     => 1,
    DefaultID => $DefaultID0,
);

$Self->True(
    $ExclusiveLockGUID,
    "DefaultSettingLock Zero - For second deployment",
);

%Result = $SysConfigObject->SettingUpdate(
    DefaultID         => $DefaultID0,
    Name              => "Test0$RandomID",
    EffectiveValue    => 'Test Update 0 - Modified',
    UserID            => $UserID,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);

$Self->True(
    $Result{Success},
    "SettingUpdate() - Zero",
);

# Lock setting (so it can be updated).
$ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
    UserID    => $UserID,
    Force     => 1,
    DefaultID => $DefaultID1,
);

$Self->True(
    $ExclusiveLockGUID,
    "DefaultSettingLock One",
);

%Result = $SysConfigObject->SettingUpdate(
    DefaultID         => $DefaultID1,
    Name              => "Test1$RandomID",
    EffectiveValue    => 'Test Update 1 - Modified',
    UserID            => $UserID,
    ExclusiveLockGUID => $ExclusiveLockGUID,
);

$Self->True(
    $Result{Success},
    "SettingUpdate() - One",
);

my $Index = 0;
for my $ModifiedVersionID ( sort @ModifiedVersions ) {

    my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
        Name => "Test$Index$RandomID",
    );
    $Self->Is(
        $ModifiedSetting{EffectiveValue},
        "Test Update $Index - Modified",
        "Second Update for $ModifiedVersionID - Modified",
    );

    $Index++;
}

my $DeployRestored = $SysConfigObject->ConfigurationDeployRestore(
    DeploymentID => $DeploymentID0,    # the deployment id will be reverted
    UserID       => $UserID,           # the user should have locked the deployment
                                       # DryRun       => 1,
);
$Self->Is(
    $DeployRestored,
    1,
    "The deployment $DeploymentID0 has been restored.",
);

$Index = 0;
for my $ModifiedVersionID ( sort @ModifiedVersions ) {

    my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
        Name => "Test$Index$RandomID",
    );
    $Self->Is(
        $ModifiedSetting{EffectiveValue},
        "Test Update $Index",
        "Second Update for $ModifiedVersionID",
    );

    $Index++;
}

# Tests for IncludePrevious deployments
{
    my $DefaultID2 = $SysConfigDBObject->DefaultSettingAdd(
        %DefaultSettingAddTemplate,
        %{ $DefaultSettingAddParams[0] },
        Name                     => "Test2$RandomID",
        UserModificationPossible => 0,
        UserModificationActive   => 0,
        UserID                   => 1,
    );
    $Self->IsNot(
        $DefaultID0,
        0,
        "DefaultSettingAdd() - Test2",
    );

    push @DefaultIDs, $DefaultID2;

    # Lock setting (so it can be updated).
    $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        UserID    => $UserID,
        Force     => 1,
        DefaultID => $DefaultID2,
    );

    $Self->True(
        $ExclusiveLockGUID,
        "DefaultSettingLock Two",
    );

    %Result = $SysConfigObject->SettingUpdate(
        DefaultID         => $DefaultID2,
        Name              => "Test2$RandomID",
        EffectiveValue    => 'Test Update 2',
        UserID            => $UserID,
        ExclusiveLockGUID => $ExclusiveLockGUID,
    );

    $Self->True(
        $Result{Success},
        "SettingUpdate() - Two",
    );

    # Get all dirty modified settings.
    @DirtyModifiedList = $SysConfigObjectDB->ModifiedSettingListGet(
        IsGlobal => 1,
        IsDirty  => 1,
    );

    # Create a new version for the modified settings.
    SETTING:
    for my $Setting (@DirtyModifiedList) {
        my %DefaultSettingVersionGetLast = $SysConfigDBObject->DefaultSettingVersionGetLast(
            DefaultID => $Setting->{DefaultID},
        );
        my $ModifiedVersionID = $SysConfigObjectDB->ModifiedSettingVersionAdd(
            %{$Setting},
            DefaultVersionID    => $DefaultSettingVersionGetLast{DefaultVersionID},
            DeploymentTimeStamp => $TimeStamp,
            UserID              => 1,
        );
    }

    my $Success = $SysConfigDBObject->DefaultSettingUnlock(
        UnlockAll => 1,
    );

    $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
        UserID => 1,
    );
    $Self->IsNot(
        $ExclusiveLockGUID,
        undef,
        "DeploymentLock()",
    );

    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => 'UnitTest',
        EffectiveValueStrg  => \$EffectiveValueStrgFile,
        ExclusiveLockGUID   => $ExclusiveLockGUID,
        DeploymentTimeStamp => $TimeStamp,
        UserID              => 1,
    );

    $Self->IsNot(
        $DeploymentID,
        undef,
        "DeploymentAdd() for IncludePrevious",
    );

    # Check if deployment exists
    %ModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
        DeploymentID => $DeploymentID,
        Mode         => 'SmallerThanEquals',
    );
    @ModifiedVersions = sort keys %ModifiedVersionList;

    use Data::Dumper;
    print STDERR "Debug - ModuleName - ModifiedVersions = "
        . Dumper( \%ModifiedVersionList )
        . "\n";    # TODO: Delete developer comment

    # Be sure we have an ordered list.
    @DefaultIDs = sort @DefaultIDs;

    for my $ModifiedVersionID ( sort @ModifiedVersions ) {

        my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
            ModifiedVersionID => $ModifiedVersionID,
        );

        my @IsPresent = grep { $_ eq $ModifiedSettingVersion{DefaultID} } @DefaultIDs;

        $Self->True(
            scalar @IsPresent,
            "DeploymentModifiedVersionList is present on ModifiedSettingVersionGet - $ModifiedVersionID",
        );

    }

    $Success = $SysConfigDBObject->DeploymentUnlock(
        All => 1,
    );
    $Self->IsNot(
        $Success,
        undef,
        "DeploymentUnlock() user",
    );

    FixedTimeAddSeconds(5);

    # Lock setting (so it can be updated).
    $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        UserID  => $UserID,
        Force   => 1,
        LockAll => 1,
    );

    $Self->True(
        $ExclusiveLockGUID,
        "DefaultSettingLock Three",
    );

    %Result = $SysConfigObject->SettingUpdate(
        DefaultID         => $DefaultID0,
        Name              => "Test0$RandomID",
        EffectiveValue    => 'Test Update 0 - Modified',
        UserID            => $UserID,
        ExclusiveLockGUID => $ExclusiveLockGUID,
    );

    $Self->True(
        $Result{Success},
        "SettingUpdate() - Zero",
    );

    %Result = $SysConfigObject->SettingUpdate(
        DefaultID         => $DefaultID1,
        Name              => "Test1$RandomID",
        EffectiveValue    => 'Test Update 1 - Modified',
        UserID            => $UserID,
        ExclusiveLockGUID => $ExclusiveLockGUID,
    );

    $Self->True(
        $Result{Success},
        "SettingUpdate() - One",
    );

    %Result = $SysConfigObject->SettingUpdate(
        DefaultID         => $DefaultID2,
        Name              => "Test2$RandomID",
        EffectiveValue    => 'Test Update 2 - Modified',
        UserID            => $UserID,
        ExclusiveLockGUID => $ExclusiveLockGUID,
    );

    $Self->True(
        $Result{Success},
        "SettingUpdate() - Two",
    );

    $Index = 0;
    for my $ModifiedVersionID ( sort @ModifiedVersions ) {

        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            Name => "Test$Index$RandomID",
        );
        $Self->Is(
            $ModifiedSetting{EffectiveValue},
            "Test Update $Index - Modified",
            "New Update for $ModifiedVersionID - Modified",
        );

        $Index++;
    }

    $DeployRestored = $SysConfigObject->ConfigurationDeployRestore(
        DeploymentID => $DeploymentID,    # the deployment id will be reverted
        UserID       => $UserID,          # the user should have locked the deployment
                                          # DryRun       => 1,
    );
    $Self->Is(
        $DeployRestored,
        1,
        "The deployment $DeploymentID has been restored.",
    );

    $Index = 0;
    for my $ModifiedVersionID ( sort @ModifiedVersions ) {

        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            Name => "Test$Index$RandomID",
        );
        $Self->Is(
            $ModifiedSetting{EffectiveValue},
            "Test Update $Index",
            "Restored value for $ModifiedVersionID",
        );

        $Index++;
    }
}

done_testing();
