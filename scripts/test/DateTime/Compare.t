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

#
# Tests for comparing DateTime objects
#
my @TestConfigs = (
    {
        Date1 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            Year     => 2018,
            Month    => 2,
            Day      => 14,
            Hour     => 14,
            Minute   => 54,
            Second   => 10,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => -1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 0,
    },
    {
        Date1 => {
            Year     => 2018,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Date2 => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 12,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => -1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 13,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 0,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 1,
            Day      => 26,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 12,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 15,
            Minute   => 0,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => -1,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 13,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 15,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 0,
    },
    {
        Date1 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 15,
            Minute   => 0,
            Second   => 0,
            TimeZone => 'UTC',
        },
        Date2 => {
            Year     => 2016,
            Month    => 6,
            Day      => 26,
            Hour     => 16,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        ExpectedComparisonResult => 1,
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

    # Compare
    my $Result = $DateTimeObject1->Compare( DateTimeObject => $DateTimeObject2 );
    $Self->Is(
        $Result,
        $TestConfig->{ExpectedComparisonResult},
        'Comparison of two DateTime objects ('
            . $DateTimeObject1->ToString() . ' and '
            . $DateTimeObject2->ToString()
            . ') via Compare must match expected result.',
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

# Compare
my $Result = $DateTimeObject->Compare( DateTimeObject => 'No DateTime object but a string' );
$Self->False(
    $Result,
    'Comparison with invalid DateTime object via Compare must fail.',
);

$Self->DoneTesting();
