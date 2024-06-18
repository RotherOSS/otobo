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

# core modules

# CPAN modules

# OTOBO modules

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# Without specific time zone
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

$Self->Is(
    ref $DateTimeObject,
    'Kernel::System::DateTime',
    'Creation of DateTime object must succeed.'
);

# WorkingTime tests
my @WorkingTimeTests = (
    {
        StartDateString         => '2005-10-20 10:00:00',
        StopDateString          => '2005-10-21 10:00:00',
        ExpectedAbsoluteSeconds => 13 * 60 * 60,
    },
    {
        StartDateString         => '2005-10-20 10:00:00',
        StopDateString          => '2005-10-24 10:00:00',
        ExpectedAbsoluteSeconds => 26 * 60 * 60,
    },
    {
        StartDateString         => '2005-10-20 10:00:00',
        StopDateString          => '2005-10-27 10:00:00',
        ExpectedAbsoluteSeconds => 65 * 60 * 60,
    },
    {
        StartDateString         => '2005-10-20 10:00:00',
        StopDateString          => '2005-11-03 10:00:00',
        ExpectedAbsoluteSeconds => 130 * 60 * 60,
    },
    {
        StartDateString         => '2005-12-21 10:00:00',
        StopDateString          => '2005-12-31 10:00:00',
        ExpectedAbsoluteSeconds => 89 * 60 * 60,
    },
    {
        StartDateString         => '2003-12-21 10:00:00',
        StopDateString          => '2003-12-31 10:00:00',
        ExpectedAbsoluteSeconds => 52 * 60 * 60,
    },
    {
        StartDateString         => '2005-10-23 10:00:00',
        StopDateString          => '2005-10-24 10:00:00',
        ExpectedAbsoluteSeconds => 2 * 60 * 60,
    },
    {
        StartDateString         => '2005-10-23 10:00:00',
        StopDateString          => '2005-10-25 13:00:00',
        ExpectedAbsoluteSeconds => 18 * 60 * 60,
    },
    {
        StartDateString         => '2005-10-23 10:00:00',
        StopDateString          => '2005-10-30 13:00:00',
        ExpectedAbsoluteSeconds => 65 * 60 * 60,
    },
    {
        StartDateString         => '2005-10-24 11:44:12',
        StopDateString          => '2005-10-24 16:13:31',
        ExpectedAbsoluteSeconds => 16159,                   # 16:13:31 - 11:44:12 => 4:29:19 = 4.4886...
    },
    {
        StartDateString         => '2006-12-05 22:57:34',
        StopDateString          => '2006-12-06 10:25:34',
        ExpectedAbsoluteSeconds => 8734,                    # 1 10:25:23 - 22:57:35 => 2:25:34 = 2,426...
    },
    {
        StartDateString         => '2006-12-06 07:50:00',
        StopDateString          => '2006-12-07 08:54:00',
        ExpectedAbsoluteSeconds => 13.9 * 60 * 60,
    },
    {
        StartDateString         => '2007-03-12 11:56:01',
        StopDateString          => '2007-03-12 13:56:01',
        ExpectedAbsoluteSeconds => 2 * 60 * 60,
    },
    {
        StartDateString         => '2010-01-28 22:00:02',
        StopDateString          => '2010-01-28 22:01:02',
        ExpectedAbsoluteSeconds => 0,
    },
);

for my $Test (@WorkingTimeTests) {

    my $StartSystemTime = $DateTimeObject->TimeStamp2SystemTime( String => $Test->{StartDateString} );
    my $StopSystemTime  = $DateTimeObject->TimeStamp2SystemTime( String => $Test->{StopDateString} );

    my $WorkingTime = $DateTimeObject->WorkingTime(
        StartTime => $StartSystemTime,
        StopTime  => $StopSystemTime,
    );

    # total seconds
    $Self->Is(
        $WorkingTime->{AbsoluteSeconds},
        $Test->{ExpectedAbsoluteSeconds},
        "Total Seconds of WorkingTime() between $Test->{StartDateString} and $Test->{StopDateString} must match expected ones.",
    );

    # hours
    $Self->Is(
        $WorkingTime->{Hours},
        int $Test->{ExpectedAbsoluteSeconds} / ( 60 * 60 ),
        "Hour part of WorkingTime() between $Test->{StartDateString} and $Test->{StopDateString} must match expected ones.",
    );

    # minutes
    $Self->Is(
        $WorkingTime->{Minutes},
        int( ( $Test->{ExpectedAbsoluteSeconds} % ( 60 * 60 ) ) / 60 ),
        "Minute part of WorkingTime() between $Test->{StartDateString} and $Test->{StopDateString} must match expected ones.",
    );

    # seconds
    $Self->Is(
        $WorkingTime->{Seconds},
        $Test->{ExpectedAbsoluteSeconds} % 60,
        "Second part of WorkingTime() between $Test->{StartDateString} and $Test->{StopDateString} must match expected ones.",
    );
}

$Self->DoneTesting();
