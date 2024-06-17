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
# Tests for adding durations to DateTime object
#
my @TestConfigs = (
    {
        From => {
            String   => '2016-02-29 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 29,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
        },
    },
    {
        From => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 29,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
        },
    },
    {
        From => {
            String   => '2016-03-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 31,
            DayOfWeek => 4,
            DayAbbr   => 'Thu',
        },
    },
    {
        From => {
            String   => '2015-02-02 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 28,
            DayOfWeek => 6,
            DayAbbr   => 'Sat',
        },
    },
    {
        From => {
            String   => '2012-04-02 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Day       => 30,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{From},
    );
    my $LastDayOfMonth = $DateTimeObject->LastDayOfMonthGet();

    $Self->IsDeeply(
        $LastDayOfMonth,
        $TestConfig->{ExpectedResult},
        'Last day of month for '
            . $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
            . ' must match the expected one.'
    );
}

$Self->DoneTesting();
