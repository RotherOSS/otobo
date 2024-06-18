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

my @Tests = (

    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'UTC',
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Fri, 10 Jan 2014 12:12:13 +0100',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'America/Los_Angeles',
        Result       => 'Fri, 10 Jan 2014 03:12:13 -0800',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Australia/Sydney',
        Result       => 'Fri, 10 Jan 2014 22:12:13 +1100',
    },
    {
        TimeStampUTC => '2014-01-10 11:12:13',
        TimeZone     => 'Europe/London',
        Result       => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {

        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'America/Los_Angeles',
        Result       => 'Sat, 2 Aug 2014 19:03:04 -0700',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Australia/Sydney',
        Result       => 'Sun, 3 Aug 2014 12:03:04 +1000',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/London',
        Result       => 'Sun, 3 Aug 2014 03:03:04 +0100',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Europe/Berlin',
        Result       => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {
        TimeStampUTC => '2014-08-03 02:03:04',
        TimeZone     => 'Asia/Kathmandu',
        Result       => 'Sun, 3 Aug 2014 07:48:04 +0545',
    },
);

for my $Test (@Tests) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Test->{TimeStampUTC},
            TimeZone => 'UTC',
        },
    );

    $DateTimeObject->ToTimeZone( TimeZone => $Test->{TimeZone} );

    my $EmailTimeStamp = $DateTimeObject->ToEmailTimeStamp();

    $Self->Is(
        $EmailTimeStamp,
        $Test->{Result},
        "$Test->{TimeStampUTC} (UTC) to $Test->{TimeZone} email time stamp must match expected one.",
    );
}

$Self->DoneTesting();
