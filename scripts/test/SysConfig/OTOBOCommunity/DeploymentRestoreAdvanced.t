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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
FixedTimeSet();

my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $Location = "$Home/Kernel/Config/Files/ZZZAAuto.pm";

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $ContentSCALARRef = $MainObject->FileRead(
    Location        => $Location,
    Mode            => 'utf8',
    Result          => 'SCALAR',
    DisableWarnings => 1,
);

my $RandomID = $HelperObject->GetRandomID();

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $CleanUp = sub {
    my %Param = @_;

    # Delete sysconfig_modified_version
    return if !$DBObject->Do(
        SQL => 'DELETE FROM sysconfig_modified_version',
    );

    # Delete sysconfig_modified
    return if !$DBObject->Do(
        SQL => 'DELETE FROM sysconfig_modified',
    );

    # Delete sysconfig_default_version
    return if !$DBObject->Do(
        SQL => 'DELETE FROM sysconfig_default_version',
    );

    # Delete sysconfig_default
    return if !$DBObject->Do(
        SQL => 'DELETE FROM sysconfig_default',
    );

    # delete cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

};

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my @DeploymentIDs;

my $SetupSystem = sub {

    @DeploymentIDs = ();

    # Create a new default settings (all with value 0).
    for my $Count ( 1 .. 10 ) {
        my $SettingName = "UnitTest-$Count-$RandomID";
        my $DefaultID   = $SysConfigDBObject->DefaultSettingAdd(
            Name                     => $SettingName,
            Description              => 'UnitTest',
            Navigation               => "UnitTest::Core",
            IsInvisible              => 0,
            IsReadonly               => 0,
            IsRequired               => 0,
            IsValid                  => 1,
            HasConfigLevel           => 0,
            UserModificationPossible => 0,
            UserModificationActive   => 0,
            XMLContentRaw            => <<"EOF",
<Setting Name="$SettingName" Required="0" Valid="0">
    <Description Translatable="1">Just for testing.</Description>
    <Navigation>UnitTest::Core</Navigation>
    <Value>
        <Item>0</Item>
    </Value>
</Setting>
EOF
            XMLContentParsed => {
                Name        => $SettingName,
                Required    => '0',
                Valid       => '1',
                Description => [
                    {
                        Content      => 'Just for testing.',
                        Translatable => '1',
                    },
                ],
                Navigation => [
                    {
                        Content => 'UnitTest::Core',
                    },
                ],
                Value => [
                    {
                        Item => [
                            {
                                Content => '0',
                            },
                        ],
                    },
                ],
            },
            XMLFilename    => 'UnitTest.xml',
            EffectiveValue => '0',
            UserID         => 1,
        );
        $Self->IsNot(
            $DefaultID,
            undef,
            "DefaultSettingAdd() - $SettingName DefaultID",
        );
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $Success = $SysConfigObject->ConfigurationDeploy(
        Comments     => "UnitTest",
        UserID       => 1,
        Force        => 1,
        AllSettings  => 1,
        NoValidation => 1,
    );
    $Self->True(
        $Success,
        "ConfigurationDeploy() Initial Deployment",
    );
    my %LastDeployment = $SysConfigDBObject->DeploymentGetLast();
    push @DeploymentIDs, $LastDeployment{DeploymentID};
    FixedTimeAddSeconds(5);

    my $UpdateSettings = sub {
        my %Param = @_;

        for my $Count ( @{ $Param{Settings} } ) {
            my $SettingName = "UnitTest-$Count-$RandomID";

            my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                Name   => $SettingName,
                Force  => 1,
                UserID => 1,
            );

            my %Result = $SysConfigObject->SettingUpdate(
                Name              => $SettingName,
                EffectiveValue    => $Param{EffectiveValue},
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
            $Self->True(
                $Result{Success},
                "SettingUpdate() - $SettingName with true",
            );

            my $Success = $SysConfigObject->SettingUnlock(
                Name => $SettingName,
            );

            my %Setting = $SysConfigObject->SettingGet(
                Name => $SettingName,
            );
            $Self->Is(
                $Setting{EffectiveValue},
                $Param{EffectiveValue},
                "SettingGet() - $SettingName EffectiveValue",
            );
        }
        FixedTimeAddSeconds(5);
    };

    my @Updates = (
        {
            Settings       => [ 2, 4 ],
            EffectiveValue => 1,
        },
        {
            Settings       => [ 1, 3, 5 ],
            EffectiveValue => 2,
        },
        {
            Settings       => [ 3, 4, 5, 6 ],
            EffectiveValue => 3,
        },
        {
            Settings       => [7],
            EffectiveValue => 4,
        },
        {
            Settings       => [ 3, 8 ],
            EffectiveValue => 5,
        },

    );

    for my $Update (@Updates) {

        $UpdateSettings->( %{$Update} );

        my $Success = $SysConfigObject->ConfigurationDeploy(
            Comments     => "UnitTest",
            UserID       => 1,
            Force        => 1,
            AllSettings  => 1,
            NoValidation => 1,
        );
        $Self->True(
            $Success,
            "ConfigurationDeploy() Deployment $Update->{EffectiveValue}",
        );
        my %LastDeployment = $SysConfigDBObject->DeploymentGetLast();
        push @DeploymentIDs, $LastDeployment{DeploymentID};
    }
};

# Deployments Table
# Setting | D0 | D1 | D2 | D3 | D4 | D5 |
#       1 |  0 |  - |  2 |  - |  - |  - |
#       2 |  0 |  1 |  - |  - |  - |  - |
#       3 |  0 |  - |  2 |  3 |  - |  5 |
#       4 |  0 |  1 |  - |  3 |  - |  - |
#       5 |  0 |  - |  2 |  3 |  - |  - |
#       6 |  0 |  - |  - |  3 |  - |  - |
#       7 |  0 |  - |  - |  - |  4 |  - |
#       8 |  0 |  - |  - |  - |  - |  5 |
#       9 |  0 |  - |  - |  - |  - |  - |
#      10 |  0 |  - |  - |  - |  - |  - |

# Deployments Restore Table
# Setting | D0 | D1 | D2 | D3 | D4 | D5 |
#       1 |  0 |  0 |  2 |  2 |  2 |  2 |
#       2 |  0 |  1 |  1 |  1 |  1 |  1 |
#       3 |  0 |  0 |  2 |  3 |  3 |  5 |
#       4 |  0 |  1 |  1 |  3 |  3 |  3 |
#       5 |  0 |  0 |  2 |  3 |  3 |  3 |
#       6 |  0 |  0 |  0 |  3 |  3 |  3 |
#       7 |  0 |  0 |  0 |  0 |  4 |  4 |
#       8 |  0 |  0 |  0 |  0 |  0 |  5 |
#       9 |  0 |  0 |  0 |  0 |  0 |  0 |
#      10 |  0 |  0 |  0 |  0 |  0 |  0 |

my @Tests = (
    {
        DeploymentIndex => 1,
        ExpectedResult  => {
            1  => 0,
            2  => 1,
            3  => 0,
            4  => 1,
            5  => 0,
            6  => 0,
            7  => 0,
            8  => 0,
            9  => 0,
            10 => 0,
        },
    },
    {
        DeploymentIndex => 2,
        ExpectedResult  => {
            1  => 2,
            2  => 1,
            3  => 2,
            4  => 1,
            5  => 2,
            6  => 0,
            7  => 0,
            8  => 0,
            9  => 0,
            10 => 0,
        },
    },
    {
        DeploymentIndex => 3,
        ExpectedResult  => {
            1  => 2,
            2  => 1,
            3  => 3,
            4  => 3,
            5  => 3,
            6  => 3,
            7  => 0,
            8  => 0,
            9  => 0,
            10 => 0,
        },
    },
    {
        DeploymentIndex => 4,
        ExpectedResult  => {
            1  => 2,
            2  => 1,
            3  => 3,
            4  => 3,
            5  => 3,
            6  => 3,
            7  => 4,
            8  => 0,
            9  => 0,
            10 => 0,
        },
    },
    {
        DeploymentIndex => 5,
        ExpectedResult  => {
            1  => 2,
            2  => 1,
            3  => 5,
            4  => 3,
            5  => 3,
            6  => 3,
            7  => 4,
            8  => 5,
            9  => 0,
            10 => 0,
        },
    },
);

my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

for my $Test (@Tests) {
    $CleanUp->();
    $SetupSystem->();

    my $Result = $SysConfigObject->ConfigurationDeployRestore(
        DeploymentID => $DeploymentIDs[ $Test->{DeploymentIndex} ],
        UserID       => 1,
    );

    my %Results;

    for my $Count ( 1 .. 10 ) {
        my $SettingName = "UnitTest-$Count-$RandomID";
        my %Setting     = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        $Results{$Count} = $Setting{EffectiveValue};
    }

    $Self->IsDeeply(
        \%Results,
        $Test->{ExpectedResult},
        "ConfigurationDeployRestore Deployment $Test->{DeploymentIndex}",
    );
}

my $FileLocation = $MainObject->FileWrite(
    Location   => $Location,
    Content    => $ContentSCALARRef,
    Mode       => 'utf8',
    Permission => '644',
);
$Self->IsNot(
    $FileLocation,
    undef,
    "Restored original ZZZAAuto file",
);

$Self->DoneTesting();
