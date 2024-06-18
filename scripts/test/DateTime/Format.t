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

#
# Tests for formatting
#
my @TestConfigs = (
    {
        Date => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedStringByFormat => {
            '%Y-%m-%d %H:%M:%S'                               => '2016-02-28 14:59:00',
            '%Y-%m-%d %H:%M:%S %{time_zone_long_name}'        => '2016-02-28 14:59:00 Europe/Berlin',
            'On %Y-%m-%d at %H:%M we will have a phone call.' => 'On 2016-02-28 at 14:59 we will have a phone call.',
        },
    },
    {
        Date => {
            String   => '2014-01-01 00:07:45',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedStringByFormat => {
            '%Y-%m-%d %H:%M:%S'                               => '2014-01-01 00:07:45',
            '%Y-%m-%d %H:%M:%S %{time_zone_long_name}'        => '2014-01-01 00:07:45 Europe/Berlin',
            'On %Y-%m-%d at %H:%M we will have a phone call.' => 'On 2014-01-01 at 00:07 we will have a phone call.',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Date},
    );

    for my $Format ( sort keys %{ $TestConfig->{ExpectedStringByFormat} } ) {
        $Self->Is(
            $DateTimeObject->Format( Format => $Format ),
            $TestConfig->{ExpectedStringByFormat}->{$Format},
            'Formatted string for format "'
                . $Format
                . '" and date/time '
                . $DateTimeObject->ToString()
                . ' must match expected one.',
        );
    }

    $Self->Is(
        $DateTimeObject->ToString(),
        $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S' ),
        'ToString for date/time ' . $DateTimeObject->ToString() . ' must result in expected string.',
    );

    $Self->Is(
        $DateTimeObject->ToEpoch(),
        $DateTimeObject->Format( Format => '%{epoch}' ),
        'ToEpoch for date/time ' . $DateTimeObject->ToString() . ' must result in expected time stamp.',
    );
}

# Test for missing Format parameter
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

my $Result = $DateTimeObject->Format();
$Self->False(
    $Result,
    'Format() without parameter must fail.',
);

$Result = $DateTimeObject->Format( Formats => '' );
$Self->False(
    $Result,
    'Format() with wrong parameter name must fail.',
);

$Self->DoneTesting();
