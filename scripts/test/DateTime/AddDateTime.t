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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

# Tests for adding durations to DateTime object
my @SuccessTestConfigs = (
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
        Add => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2017,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 1,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 3,
            DayAbbr   => 'Wed',
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
        Add => {
            Years => 1,
        },
        ExpectedResult => {
            Year      => 2017,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 2,
            DayAbbr   => 'Tue',
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
        Add => {
            Days => 1,
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
            TimeZone => 'America/New_York',
        },
        Add => {
            Days => 1,
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
            TimeZone  => 'America/New_York',
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
        Add => {
            Weeks => 2,
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 3,
            MonthAbbr => 'Mar',
            Day       => 13,
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
        Add => {
            Years   => 10,
            Months  => 2,
            Weeks   => 2,
            Days    => 5,
            Hours   => 4,
            Minutes => 121,
            Seconds => 61,
        },
        ExpectedResult => {
            Year      => 2026,
            Month     => 5,
            MonthAbbr => 'May',
            Day       => 18,
            Hour      => 22,
            Minute    => 1,
            Second    => 1,
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
        Add => {
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
        Add => {
            Days => -5,    # results in subtracting 5 days
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 23,
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 2,
            DayAbbr   => 'Tue',
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
        Add => {
            Days   => -5,    # results in subtracting 5 days
            Years  => -1,    # results in subtracting 1 year
            Months => +3,
        },
        ExpectedResult => {
            Year      => 2015,
            Month     => 5,
            MonthAbbr => 'May',
            Day       => 23,
            Hour      => 15,
            Minute    => 59,
            Second    => 0,
            DayOfWeek => 6,
            DayAbbr   => 'Sat',
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        From => {
            Year   => 2022,
            Month  => 9,
            Day    => 5,
            Hour   => 11,
            Minute => 14,
            Second => 11,

            # TimeZone => 'Europe/Berlin', considering the time zone takes a lot of computation
            TimeZone => 'UTC',    # effectively turn off time zone calculations
        },
        Add => {
            Minutes => 10_000_000 * 365.2422 * 24 * 60,    # very far in the future
        },
        ExpectedResult => {
            'MonthAbbr' => 'Jun',
            'Hour'      => 11,
            'Day'       => 19,
            'DayOfWeek' => 4,
            'Minute'    => 14,
            'Year'      => 10002014,
            'DayAbbr'   => 'Thu',
            'Month'     => 6,
            'TimeZone'  => 'UTC',
            'Second'    => 11
        },
    },
);

TESTCONFIG:
for my $TestConfig (@SuccessTestConfigs) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{From},
    );
    my $StartTimeFormatted = $DateTimeObject->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' );
    $DateTimeObject->Add( $TestConfig->{Add}->%* );

    my @AddStrings;
    while ( my ( $Key, $Value ) = each $TestConfig->{Add}->%* ) {
        push @AddStrings, "$Value $Key";
    }
    my $AddString = join ', ', sort @AddStrings;

    is(
        $DateTimeObject->Get(),
        $TestConfig->{ExpectedResult},
        "Adding $AddString to $StartTimeFormatted must match the expected values",
    );
}

# Tests for failing calls to Add()
my $DateTimeObject     = $Kernel::OM->Create('Kernel::System::DateTime');
my @FailingTestConfigs = (
    {
        Name   => 'without parameters',
        Params => {},
    },
    {
        Name   => 'with invalid seconds',
        Params => {
            Seconds => 'invalid',
        },
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

for my $TestConfig (@FailingTestConfigs) {
    my $DateTimeObjectClone = $DateTimeObject->Clone();
    my $AddSuccess          = $DateTimeObjectClone->Add( $TestConfig->{Params}->%* );
    ok( !$AddSuccess, "Add() $TestConfig->{Name} must fail." );

    is(
        $DateTimeObjectClone->Get(),
        $DateTimeObject->Get(),
        'DateTime object must be unchanged after failed Add().',
    );
}

done_testing();
