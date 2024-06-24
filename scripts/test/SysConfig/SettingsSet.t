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

my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

# NOTE: This test script uses SettingsSet and thus creates
# own deployments. Therefore we must handle DB Restore on our own.
# This is because we need to do a deployment after DB is restored.
my $StartedTransaction = $HelperObject->BeginWork();
$Self->True(
    $StartedTransaction,
    'Started database transaction.',
);

# Ticket::SubjectFwd
# Ticket::SubjectRe

my @Tests = (
    {
        Title  => 'SettingsSet() without UserID',
        Params => {
            Settings => [
                {
                    Name           => 'Ticket::SubjectFwd',
                    EffectiveValue => 'FORWARD###',
                },
                {
                    Name           => 'Ticket::SubjectRe',
                    EffectiveValue => 'RE###',
                },
            ],
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'SettingsSet() without Settings',
        Params => {
            UserID => 1,
        },
        ExpectedResult => undef,
    },
    {
        Title  => 'SettingsSet() pass',
        Params => {
            UserID   => 1,
            Settings => [
                {
                    Name           => 'Ticket::SubjectFwd',
                    EffectiveValue => 'FORWARD###',
                },
                {
                    Name           => 'Ticket::SubjectRe',
                    EffectiveValue => 'RE###',
                },
            ],
        },
        ExpectedResult => 1,
    },
);

for my $Test (@Tests) {

    # Note that SettingsSet forces an deployment
    my $Success = $SysConfigObject->SettingsSet(
        %{ $Test->{Params} },
    );

    $Self->Is(
        $Success,
        $Test->{ExpectedResult},
        $Test->{Title},
    );
}

# Check values
my %SettingForward = $SysConfigObject->SettingGet(
    Name     => 'Ticket::SubjectFwd',
    Deployed => 1,
);

$Self->Is(
    $SettingForward{EffectiveValue},
    'FORWARD###',
    'Check deployed EffectiveValue for Ticket::SubjectFwd.',
);
my %SettingRe = $SysConfigObject->SettingGet(
    Name     => 'Ticket::SubjectRe',
    Deployed => 1,
);

$Self->Is(
    $SettingRe{EffectiveValue},
    'RE###',
    'Check deployed EffectiveValue for Ticket::SubjectRe.',
);

my $RollbackSuccess = $HelperObject->Rollback();
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
$Self->True(
    $RollbackSuccess,
    'Rolled back all database changes and cleaned up the cache.',
);

# The SysConfig tables are rolled back. Thus ConfigurationDeploy() takes
# ZZZAAuto.pm back to the state before the test script started.
my %Result = $SysConfigObject->ConfigurationDeploy(
    Comments    => 'Revert changes.',
    UserID      => 1,
    Force       => 1,
    AllSettings => 1,
);

$Self->True(
    $Result{Success},
    'Configuration restored.',
);

$Self->DoneTesting();
