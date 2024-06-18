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

#
# Tests for calculating delta between two DateTime objects
#
my @TestConfigs = (
    {
        Date1 => {
            String   => '2013-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            String   => '2015-02-15 14:54:10',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Years           => 1,
            Months          => 11,
            Weeks           => 2,
            Days            => 0,
            Hours           => 23,
            Minutes         => 55,
            Seconds         => 10,
            AbsoluteSeconds => 61948510,
        },
    },
    {
        Date1 => {
            String   => '2013-02-28 14:59:00',
            TimeZone => 'UTC',
        },
        Date2 => {
            String   => '2015-02-15 14:54:10',
            TimeZone => 'America/New_York',
        },
        ExpectedResult => {
            Years           => 1,
            Months          => 11,
            Weeks           => 2,
            Days            => 1,
            Hours           => 4,
            Minutes         => 55,
            Seconds         => 10,
            AbsoluteSeconds => 61966510,
        },
    },
    {
        Date1 => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            String   => '2016-02-28 13:54:10',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Years           => 0,
            Months          => 0,
            Weeks           => 0,
            Days            => 0,
            Hours           => 1,
            Minutes         => 4,
            Seconds         => 50,
            AbsoluteSeconds => 3890,
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject1 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Date1},
    );
    my $DateTimeObject2 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Date2},
    );

    my $Delta = $DateTimeObject1->Delta( DateTimeObject => $DateTimeObject2 );

    $Self->IsDeeply(
        $Delta,
        $TestConfig->{ExpectedResult},
        'Delta of two dates ('
            . $DateTimeObject1->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' ) . ' and '
            . $DateTimeObject2->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
            . ') must match expected one.',
    );
}

#
# Test with invalid DateTime object
#
my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2016-04-06 13:46:00',
    },
);

my $Delta = $DateTimeObject->Delta( DateTimeObject => 'No DateTime object but a string' );
$Self->False(
    $Delta,
    'Delta calculation with invalid DateTime object must fail.',
);

$Delta = $DateTimeObject->Delta( DateTimeObject => $Kernel::OM->Get('Kernel::System::Calendar') );
$Self->False(
    $Delta,
    'Delta calculation with invalid DateTime object must fail.',
);

$Self->DoneTesting();
