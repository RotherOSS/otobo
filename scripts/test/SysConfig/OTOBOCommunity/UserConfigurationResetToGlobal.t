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
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $UserObject      = $Kernel::OM->Get('Kernel::System::User');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

## --
# Create user
## --
my $Home     = $ConfigObject->Get('Home');
my $RandomID = $HelperObject->GetRandomID();

my $TestUserID1;
my $UserRand1 = 'example-user1' . $RandomID;
$TestUserID1 = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

## --
# Basic checks
## --
my @Tests = (
    {
        Title  => 'Missing Settings',
        Params => {
            UserID => $TestUserID1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'Missing UserID',
        Params => {
            Settings => [
                'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            ],
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'Settings param is not array',
        Params => {
            Settings => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            UserID   => $TestUserID1,
        },
        ExpectedResult => undef,
    },
);

for my $Test (@Tests) {
    my $Success = $SysConfigObject->UserConfigurationResetToGlobal(
        %{ $Test->{Params} },
    );

    $Self->Is(
        $Success,
        $Test->{ExpectedResult},
        "Check expected value - $Test->{Title}",
    );
}

## --
# Functionality test
## --

# Update user setting.
my %Result = $SysConfigObject->SettingUpdate(
    Name           => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
    IsValid        => 1,
    EffectiveValue => 'Queue',
    TargetUserID   => $TestUserID1,
    UserID         => 1,
);

$Self->IsDeeply(
    \%Result,
    {
        Success => 1,
    },
    'User value set (Queue) #1.'
);

# Deploy user setting.
my $Success = $SysConfigObject->UserConfigurationDeploy(
    Comments     => "Some comments",
    TargetUserID => $TestUserID1,
);

$Self->True(
    $Success,
    'Deploy user settings #1.'
);

# Check user value.
my %Setting = $SysConfigObject->SettingGet(
    Name         => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
    TargetUserID => $TestUserID1,
);

$Self->Is(
    $Setting{EffectiveValue},
    'Queue',
    'Check user value #1.'
);

$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::SysConfig',
    ],
);

# Change global value.
$Success = $SysConfigObject->SettingsSet(
    UserID   => 1,
    Comments => 'Deployment comment',
    Settings => [
        {
            Name           => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            EffectiveValue => 'Priority',
            IsValid        => 1,
        },
    ],
);

$Self->True(
    $Success,
    'Global setting deploy (Priority) #1.',
);

# Check user value.
%Setting = $SysConfigObject->SettingGet(
    Name         => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
    TargetUserID => $TestUserID1,
);

$Self->Is(
    $Setting{EffectiveValue},
    'Queue',
    'Check user value #2.'
);

# Change global value.
$Success = $SysConfigObject->SettingsSet(
    UserID   => 1,
    Comments => 'Deployment comment',
    Settings => [
        {
            Name           => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            EffectiveValue => 'Queue',
            IsValid        => 1,
        },
    ],
);

$Self->True(
    $Success,
    'Deploy changes (Queue) #2.'
);

# Check deployed value.
%Setting = $SysConfigObject->SettingGet(
    Name     => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
    Deployed => 1,
);

$Self->Is(
    $Setting{EffectiveValue},
    'Queue',
    'Check deployed value.'
);

# Check user value.
%Setting = $SysConfigObject->SettingGet(
    Name         => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
    TargetUserID => $TestUserID1,
);

$Self->Is(
    $Setting{EffectiveValue},
    'Queue',
    'Check user value #3.'
);

# Change global value.
$Success = $SysConfigObject->SettingsSet(
    UserID   => 1,
    Comments => 'Deployment comment',
    Settings => [
        {
            Name           => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            EffectiveValue => 'Priority',
            IsValid        => 1,
        },
    ],
);

$Self->True(
    $Success,
    'Deploy changes (Priority) #3.'
);

# Check deployed value.
%Setting = $SysConfigObject->SettingGet(
    Name     => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
    Deployed => 1,
);

$Self->Is(
    $Setting{EffectiveValue},
    'Priority',
    'Check deployed value.'
);

# Check user value.
%Setting = $SysConfigObject->SettingGet(
    Name         => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
    TargetUserID => $TestUserID1,
);

$Self->Is(
    $Setting{EffectiveValue},
    'Priority',
    'Check user value #4.'
);

## --
# Cleanup system.
## --

my $File = "$Home/Kernel/Config/Files/User/$TestUserID1.pm";
if ( -e $File ) {
    unlink $File;
}

# Change global value.
$Success = $SysConfigObject->SettingsSet(
    UserID   => 1,
    Comments => 'Deployment comment',
    Settings => [
        {
            Name           => 'Ticket::Frontend::AgentTicketEscalationView###SortBy::Default',
            EffectiveValue => 'EscalationTime',
            IsValid        => 1,
        },
    ],
);

$Self->True(
    $Success,
    'Revert changes.'
);

$Self->DoneTesting();
