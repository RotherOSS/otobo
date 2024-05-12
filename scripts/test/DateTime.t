# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use DateTime ();
use Test2::V0;

# OTOBO modueles
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::DateTime ();

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Tests for DateTime object with current date and time

# Without specific time zone
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

isa_ok( $DateTimeObject, ['Kernel::System::DateTime'], 'DateTime object without specific time zone' );

my $Values = $DateTimeObject->Get;

is(
    $Values->{TimeZone},
    $DateTimeObject->OTOBOTimeZoneGet(),
    'Time zone of DateTime object must match the one configured for data storage.'
);

# With invalid time zone
$DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        TimeZone => '+2',
    },
);

ok(
    !$DateTimeObject,
    'Creation of DateTime object must fail for invalid time zone.'
);

# With specific time zone
$DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        TimeZone => 'Europe/Berlin',
    },
);

isa_ok( $DateTimeObject, ['Kernel::System::DateTime'], 'DateTime object with specific time zone' );

$Values = $DateTimeObject->Get;

is(
    $Values->{TimeZone},
    'Europe/Berlin',
    'Time zone of DateTime object must match the one configured for data storage.'
);

# Test for ToOTOBODateTimeZone
$DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        Year     => 2016,
        Month    => 1,
        Day      => 28,
        Hour     => 17,
        Minute   => 51,
        Second   => 0,
        TimeZone => 'Europe/Berlin',
    },
);

my $OriginalOTOBOTimeZone = $DateTimeObject->OTOBOTimeZoneGet();

# set specific time zone for data storage
$ConfigObject->Set(
    Key   => 'OTOBOTimeZone',
    Value => 'UTC',
);

my $OTOBOTimeZone = $DateTimeObject->OTOBOTimeZoneGet();

$DateTimeObject->ToOTOBOTimeZone();
my $DateTimeValues         = $DateTimeObject->Get();
my $ExpectedDateTimeValues = {
    Year      => 2016,
    Month     => 1,
    MonthAbbr => 'Jan',
    Day       => 28,
    DayOfWeek => 4,
    DayAbbr   => 'Thu',
    Hour      => 16,
    Minute    => 51,
    Second    => 0,
    TimeZone  => 'UTC',
};

is(
    $DateTimeValues,
    $ExpectedDateTimeValues,
    'Date and time after call to ToOTOBOTimeZone must match expected values.'
);

#
# Tests for creating DateTime objects with given date and time
#
my @DateTimeTestConfigs = (
    {
        Params => {
            Year  => 2016,
            Month => 1,
            Day   => 22,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2016,
            Month => 2,
            Day   => 29,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2015,
            Month => 2,
            Day   => 29,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 12,
            Day   => 31,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2015,
            Month => 4,
            Day   => 31,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 15,
            Month => 4,
            Day   => 30,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year  => 2015,
            Month => 13,
            Day   => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year => 2015,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 13,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year => 2015,
            Day  => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 'test',
            Month => 4,
            Day   => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 'test',
            Day   => 30,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year  => 2015,
            Month => 4,
            Day   => 'test',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 23,
            Minute => 59,
            Second => 59,
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 24,
            Minute => 59,
            Second => 59,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 23,
            Minute => 60,
            Second => 59,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year   => 2015,
            Month  => 4,
            Day    => 30,
            Hour   => 23,
            Minute => 59,
            Second => 60,
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2015,
            Month    => 4,
            Day      => 30,
            Hour     => 23,
            Minute   => 59,
            Second   => 23,
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2015,
            Month    => 4,
            Day      => 30,
            Hour     => 23,
            Minute   => 59,
            Second   => 23,
            TimeZone => 'NoValidTimeZone',
        },
        SuccessExpected => 0,
    },
);

for my $TestConfig (@DateTimeTestConfigs) {
    state $TestCount = 0;
    $TestCount++;

    subtest "DateTime test $TestCount" => sub {

        # Create DateTime object
        $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => $TestConfig->{Params},
        );

        is(
            ref $DateTimeObject eq 'Kernel::System::DateTime' ? 1 : 0,
            $TestConfig->{SuccessExpected},
            'Creation of DateTime object must ' . ( $TestConfig->{SuccessExpected} ? '' : 'not ' ) . 'succeed.',
        );

        return unless $DateTimeObject;

        # Check values of created DateTime object
        my $Values      = $DateTimeObject->Get();
        my $ValuesMatch = 1;

        VALUENAME:
        for my $ValueName (qw ( Year Month Day Hour Minute Second TimeZone )) {

            my $ExpectedValue = $TestConfig->{Params}->{$ValueName} || 0;
            if ( !$ExpectedValue && $ValueName eq 'TimeZone' ) {
                $ExpectedValue = $DateTimeObject->OTOBOTimeZoneGet();
            }

            if ( !defined $Values->{$ValueName} || $Values->{$ValueName} ne $ExpectedValue ) {
                $ValuesMatch = 0;

                last VALUENAME;
            }
        }

        ok( $ValuesMatch, 'DateTime values must match those of creation.' );
    };
}

# Tests for creating and setting DateTime object via string
my @StringTestConfigs = (
    {
        Data => {
            String => '2016-02-28 14:59:00',
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            TimeZone  => $OTOBOTimeZone,
        },
    },
    {
        Data => {
            String => '2014-01-01 00:07:45',
        },
        ExpectedResult => {
            Year      => 2014,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 1,
            DayOfWeek => 3,
            DayAbbr   => 'Wed',
            Hour      => 0,
            Minute    => 7,
            Second    => 45,
            TimeZone  => $OTOBOTimeZone,
        },
    },
    {
        Data => {
            String   => '2016-02-28 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Year      => 2016,
            Month     => 2,
            MonthAbbr => 'Feb',
            Day       => 28,
            DayOfWeek => 7,
            DayAbbr   => 'Sun',
            Hour      => 14,
            Minute    => 59,
            Second    => 0,
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        Data => {
            String   => '2014-01-01 00:07:45',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => {
            Year      => 2014,
            Month     => 1,
            MonthAbbr => 'Jan',
            Day       => 1,
            DayOfWeek => 3,
            DayAbbr   => 'Wed',
            Hour      => 0,
            Minute    => 7,
            Second    => 45,
            TimeZone  => 'Europe/Berlin',
        },
    },
    {
        Data => {
            String   => '2014-01-INVALID01 00:07:45',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResult => undef,
    },
);

for my $TestConfig (@StringTestConfigs) {
    state $TestCount = 0;
    $TestCount++;

    subtest "string test $TestCount" => sub {
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => $TestConfig->{Data},
        );

        if ($DateTimeObject) {
            my $DateTimeValues = $DateTimeObject->Get();

            is(
                $DateTimeObject->Get(),
                $TestConfig->{ExpectedResult},
                'Creation of DateTime object must have expected result.',
            );
        }
        else {
            is(
                $DateTimeObject,
                $TestConfig->{ExpectedResult},
                'Creation of DateTime object via string must have expected result.',
            );
        }

        $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        if ( defined $TestConfig->{Data}->{TimeZone} ) {
            $DateTimeObject->ToTimeZone( TimeZone => $TestConfig->{Data}->{TimeZone} );
        }

        my $Result = $DateTimeObject->Set( String => $TestConfig->{Data}->{String} );

        if ( ref $TestConfig->{ExpectedResult} ) {
            is(
                $DateTimeObject->Get(),
                $TestConfig->{ExpectedResult},
                'Setting values of DateTimeObject via string must have expected result.'
            );
        }
        else {
            is(
                $Result,
                $TestConfig->{ExpectedResult},
                'Setting values of DateTimeObject via string must have expected result.'
            );
        }
    };
}

# Tests for creating and setting DateTime object via a CPAN DateTime object
{
    my $CPANDateTimeObject = DateTime->from_epoch( epoch => 1677867509 );
    my %ExpectedResult     = (
        Year      => 2023,
        Month     => 3,
        MonthAbbr => 'Mar',
        Day       => 3,
        DayOfWeek => 5,
        DayAbbr   => 'Fri',
        Hour      => 18,
        Minute    => 18,
        Second    => 29,
        TimeZone  => 'UTC',
    );
    my $Description = 'epoch from 2023-03-03';

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            CPANDateTimeObject => $CPANDateTimeObject,
        },
    );

    is(
        $DateTimeObject->Get(),
        \%ExpectedResult,
        "$Description: Creation of DateTime",
    );

    $CPANDateTimeObject->set( year => 2000 );

    is(
        $DateTimeObject->Get(),
        \%ExpectedResult,
        "$Description: after changing the year in the source",
    );
}

#
# Tests for SystemTimeZoneGet()
#
my $ExpectedSystemTimeZone = 'Europe/Berlin';
local $ENV{TZ} = $ExpectedSystemTimeZone;
my $SystemTimeZone = Kernel::System::DateTime->SystemTimeZoneGet();

is(
    $SystemTimeZone,
    $ExpectedSystemTimeZone,
    'System time zone must match expected one.'
);

done_testing;
