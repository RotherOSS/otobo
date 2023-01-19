# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

use Kernel::System::VariableCheck qw( IsHashRefWithData );

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Hook',
    Value => 'abc',
);
$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::AgentTicketQueue###QueueSort',
    Value => {
        '7' => 2,
        '3' => 1,
    },
);

my $ArchiveRestoreEffectiveValue = $ConfigObject->Get(
    'Ticket::EventModulePost'
)->{'2300-ArchiveRestore'};

$Self->True(
    $ArchiveRestoreEffectiveValue,
    'Setting Ticket::EventModulePost###2300-ArchiveRestore is active and has value set.',
);

my $ExpectedResultRegex = '^Kernel/Config/Files/ZZZZUnitTest[A-Z]{2}\d+\.pm$';

my @Tests = (
    {
        Name   => 'Missing name',
        Params => {
            EffectiveValue => 'Test',
            UserID         => 1,
        },
        ExpectedResultRegex => undef,
    },
    {
        Name   => 'Missing UserID',
        Params => {
            SettingName    => 'Ticket::Hook',
            EffectiveValue => 'Ticket#',
        },
        ExpectedResultRegex => undef,
    },
    {
        Name   => 'Updated Ticket::Hook',
        Params => {
            SettingName    => 'Ticket::Hook',
            EffectiveValue => 'Ticket#',        # it should be default value from XML
            UserID         => 1,
        },
        ExpectedResultRegex => $ExpectedResultRegex,
    },
    {
        Name   => 'Updated Ticket::Frontend::AgentTicketQueue###QueueSort',
        Params => {
            SettingName    => 'Ticket::Frontend::AgentTicketQueue###QueueSort',
            EffectiveValue => {                                                   # it should be default value from XML
                '7' => 1,
                '3' => 0,
            },
            UserID => 1,
        },
        ExpectedResultRegex => $ExpectedResultRegex,
    },
    {
        Name   => 'Setting Ticket::EventModulePost###2300-ArchiveRestore is not changed yet',
        Params => {
            SettingName    => 'Ticket::EventModulePost###2300-ArchiveRestore',
            EffectiveValue => $ArchiveRestoreEffectiveValue,
            UserID         => 1,
        },

        # ExpectedResultRegex => $ExpectedResultRegex,
    },
);

for my $Test (@Tests) {
    my $Result = $SysConfigObject->OverriddenFileNameGet(
        %{ $Test->{Params} },
    );

    if ( $Test->{ExpectedResultRegex} ) {

        # We can't compare real file name, since HelperObject uses random numbers to generate it.
        $Self->True(
            $Result =~ m{$Test->{ExpectedResultRegex}} // '',
            "OverriddenFileNameGet() - $Test->{Name} - Check expected result($Test->{ExpectedResultRegex})."
        );
    }
    else {
        $Self->False(
            $Result // '',
            "OverriddenFileNameGet() - $Test->{Name} - not found."
        );
    }
}

# Simulates delete statement.
$HelperObject->ConfigSettingChange(
    Valid => 0,
    Key   => 'Ticket::EventModulePost###2300-ArchiveRestore',
);

my $ArchiveRestoreEffectiveValue2 = $ConfigObject->Get(
    'Ticket::EventModulePost'
)->{'2300-ArchiveRestore'};

$Self->False(
    $ArchiveRestoreEffectiveValue2,
    'Setting Ticket::EventModulePost###2300-ArchiveRestore is not active.',
);

@Tests = (
    {
        Name   => 'Setting Ticket::EventModulePost###2300-ArchiveRestore is changed',
        Params => {
            SettingName    => 'Ticket::EventModulePost###2300-ArchiveRestore',
            EffectiveValue => $ArchiveRestoreEffectiveValue,
            UserID         => 1,
        },
        ExpectedResultRegex => $ExpectedResultRegex,
    },
);

for my $Test (@Tests) {
    my $Result = $SysConfigObject->OverriddenFileNameGet(
        %{ $Test->{Params} },
    );

    if ( $Test->{ExpectedResultRegex} ) {

        # We can't compare real file name, since HelperObject uses random numbers to generate it.
        $Self->True(
            $Result =~ m{$Test->{ExpectedResultRegex}} // '',
            "OverriddenFileNameGet() - $Test->{Name} - Check expected result($Test->{ExpectedResultRegex})."
        );
    }
    else {
        $Self->False(
            $Result // '',
            "OverriddenFileNameGet() - $Test->{Name} - not found."
        );
    }
}

$Self->DoneTesting();
