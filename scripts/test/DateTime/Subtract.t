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
# Tests for subtracting durations from DateTime object
#
my @TestConfigs = (
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2015,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 6,
            DayAbbr   => 'Sat',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2017,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 29,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Days => 1,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'America/New_York',
        },
        Subtract => {
            Days => 1,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'America/New_York',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 3,
            Day      => 13,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Weeks => 2,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2026,
            Month    => 5,
            Day      => 18,
            Hour     => 22,
            Minute   => 1,
            Second   => 1,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years   => 10,
            Months  => 2,
            Weeks   => 2,
            Days    => 5,
            Hours   => 4,
            Minutes => 121,
            Seconds => 61,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 29,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 1,
            DayAbbr   => 'Mon',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Years => 'invalid',
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Days => -5,    # results in adding 5 days
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 4,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 5,
            DayAbbr   => 'Fri',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year     => 2016,
            Month    => 2,
            Day      => 28,
            Hour     => 14,
            Minute   => 59,
            Second   => 0,
            TimeZone => 'Europe/Berlin',
        },
        Subtract => {
            Days   => -5,    # results in adding 5 days
            Years  => -1,    # results in adding 1 year
            Months => +3,    # results in substracting 3 months
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 12,
            MonthAbbr => 'Dec',
            Day       => 4,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            TimeZone  => 'Europe/Berlin',
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{From},
    );
    $DateTimeObject->Subtract( %{ $TestConfig->{Subtract} } );

    my @SubtractStrings;
    while ( my ( $Key, $Value ) = each %{ $TestConfig->{Subtract} } ) {
        push @SubtractStrings, "$Value $Key";
    }
    my $SubtractString = join ', ', sort @SubtractStrings;

    $Self->IsDeeply(
        $DateTimeObject->Get(),
        $TestConfig->{ExpectedResult},
        'Subtracting '
            . $SubtractString
            . ' from '
            . $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
            . ' must match the expected values.',
    );
}

# Tests for failing calls to Subtract()
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
@TestConfigs = (
    {
        Name   => 'without parameters',
        Params => {},
    },
    {
        Name   => 'with invalid seconds',
        Params => {
            Seconds => 'invalid',
        }
    },
    {
        Name   => 'with valid minutes and invalid days',
        Params => {
            Minutes => 4,
            Days    => 'invalid',
        },
    },
    {
        Name   => 'with unsupported parameter',
        Params => {
            UnsupportedParameter => 2,
        },
    },
    {
        Name   => 'with unsupported parameter and valid years',
        Params => {
            UnsupportedParameter => 2,
            Years                => 1,
        },
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObjectClone = $DateTimeObject->Clone();
    my $Result              = $DateTimeObjectClone->Subtract( %{ $TestConfig->{Params} } );
    $Self->False(
        $Result,
        "Subtract() $TestConfig->{Name} must fail.",
    );

    $Self->IsDeeply(
        $DateTimeObjectClone->Get(),
        $DateTimeObject->Get(),
        'DateTime object must be unchanged after failed Subtract().',
    );
}

$Self->DoneTesting();
