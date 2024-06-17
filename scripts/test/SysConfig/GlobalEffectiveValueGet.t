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

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Hook',
    Value => 'Ticket###',
);

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::AgentTicketWatchView###SortBy::Default',
    Value => 'Queue',
);

my @Tests = (
    {
        Title          => 'Missing SettingName',
        Params         => {},
        ExpectedResult => undef,
    },
    {
        Title  => 'Setting with default EffectiveValue (defined in XML).',
        Params => {
            SettingName => 'ConfigLevel',
        },
        ExpectedResult => 100,
    },
    {
        Title  => 'Setting with EffectiveValue modified in the pm file.',
        Params => {
            SettingName => 'Ticket::Hook',
        },
        ExpectedResult => 'Ticket###',
    },
);

for my $Test (@Tests) {

    my $EffectiveValue = $SysConfigObject->GlobalEffectiveValueGet(
        %{ $Test->{Params} },
    );

    if ( defined $Test->{ExpectedResult} ) {
        $Self->IsDeeply(
            $EffectiveValue,
            $Test->{ExpectedResult},
            "$Test->{Title} - check expected result.",
        );
    }
    else {
        $Self->Is(
            $EffectiveValue,
            undef,
            "$Test->{Title} - check expected result.",
        );
    }
}

$Self->DoneTesting();
