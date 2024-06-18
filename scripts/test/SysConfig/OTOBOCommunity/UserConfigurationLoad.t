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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $HelperObject->GetRandomID();

my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

my $RemoveDirtyFlags = sub {
    my $Success = $SysConfigDBObject->DefaultSettingDirtyCleanUp();
    $Success = $SysConfigDBObject->ModifiedSettingDirtyCleanUp();
};

$RemoveDirtyFlags->();

my $TestUserLogin = $HelperObject->TestUserCreate();
my $UserID        = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
    UserLogin => $TestUserLogin,
);

my @Tests = (
    {
        Name              => 'Full Load',
        ConfigurationPerl => {
            Default => {
                ProductName => {
                    EffectiveValue => 'Test Modified',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Default URL',
                        StyleHeight => '70px',
                    },
                },
            },
            Modified => {
                ProductName => {
                    EffectiveValue => 'Test Modified 2',
                },
                AgentLoginLogo => {
                    EffectiveValue => {
                        URL         => 'Test Modified URL 2',
                        StyleHeight => '70px',
                    },
                },
            },
            $TestUserLogin => {
                TimeInputFormat => {
                    EffectiveValue => 'Input',
                },
            },
            $TestUserLogin . 'NotExising' => {
                TimeInputFormat => {
                    EffectiveValue => 'Input',
                },
            },
        },
        Config => {
            UserID => 1,
        },
        ExpectedResults => {
            Modified => {
                ProductName    => 'Test Modified 2',
                AgentLoginLogo => {
                    URL         => 'Test Modified URL 2',
                    StyleHeight => '70px',
                },
            },
            $TestUserLogin => {
                TimeInputFormat => 'Input',
            },
            $TestUserLogin . 'NotExising' => {},
        },
        Success => 1,
    },
);

my $YAMLObject      = $Kernel::OM->Get('Kernel::System::YAML');
my $MainObject      = $Kernel::OM->Get('Kernel::System::Main');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $UserObject      = $Kernel::OM->Get('Kernel::System::User');

my $Home          = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my $FileBasePath  = 'Kernel/Config/Files/User/';
my $FileBaseClass = 'Kernel::Config::Files::User::';

TEST:
for my $Test (@Tests) {
    $RemoveDirtyFlags->();

    my $ConfigurationYAML = $YAMLObject->Dump(
        Data => $Test->{ConfigurationPerl},
    );

    my $Success = $SysConfigObject->ConfigurationLoad(
        %{ $Test->{Config} },
        ConfigurationYAML => $ConfigurationYAML,
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} ConfigurationLoad() - with false()",
        );
        next TEST;
    }

    $Self->True(
        $Success,
        "$Test->{Name} ConfigurationLoad() - with True()",
    );

    my @DefaultDirty = $SysConfigDBObject->DefaultSettingListGet(
        IsDirty => 1,
    );

    $Self->IsDeeply(
        \@DefaultDirty,
        [],
        "$Test->{Name} - Default Dirty",
    );

    my @ModifiedDirty = $SysConfigDBObject->ModifiedSettingListGet(
        IsDirty  => 1,
        IsGlobal => 1,
    );

    my %ModifiedDirtyResult = map { $_->{Name} => $_->{EffectiveValue} } @ModifiedDirty;

    $Self->IsDeeply(
        \%ModifiedDirtyResult,
        $Test->{ExpectedResults}->{Modified},
        "$Test->{Name} ExpectedResults - modified",
    );

    USERID:
    for my $UserLogin ( sort keys %{ $Test->{ExpectedResults} } ) {
        next USERID if $UserID eq 'Default';
        next USERID if $UserID eq 'Modified';

        my $UserID = $UserObject->UserLookup(
            UserLogin => $UserLogin,
            Silent    => 1,
        );

        $UserID //= 'Null';

        my $FilePath  = $Home . '/' . $FileBasePath . $UserID . '.pm';
        my $FileClass = $FileBaseClass . $UserID;

        # make sure that the user file is synced to the file system before trying to read it
        $Kernel::OM->Get('Kernel::Config')->SyncWithS3;

        my %UserConfigResult;
        if ( -e $FilePath ) {
            delete $INC{$FilePath};
            $MainObject->Require($FileClass);
            $FileClass->Load( \%UserConfigResult );
            unlink $FilePath;
        }

        if ( $UserID eq 'Null' ) {
            $Self->IsDeeply(
                \%UserConfigResult,
                {},
                "$Test->{Name} ExpectedResults - Not existing user from File",
            );

            next USERID;
        }

        delete $UserConfigResult{CurrentUserDeploymentID};

        $Self->IsDeeply(
            \%UserConfigResult,
            $Test->{ExpectedResults}->{$UserLogin},
            "$Test->{Name} ExpectedResults - $UserID from File",
        );

        my @ModifiedDirty = $SysConfigDBObject->ModifiedSettingListGet(
            TargetUserID => $UserID,
            UserID       => 1,
        );

        my %UserModifiedResult = map { $_->{Name} => $_->{EffectiveValue} } @ModifiedDirty;

        $Self->IsDeeply(
            \%UserModifiedResult,
            $Test->{ExpectedResults}->{$UserLogin},
            "$Test->{Name} ExpectedResults - $UserID from DB",
        );
    }
}

$Self->DoneTesting();
