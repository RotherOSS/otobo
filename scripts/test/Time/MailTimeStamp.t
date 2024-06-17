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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

my @Tests = (

    {
        Name          => 'UTC',
        TimeStampUTC  => '2014-01-10 11:12:13',
        OTOBOTimeZone => 'UTC',
        Result        => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        Name          => 'Europe/Berlin',
        TimeStampUTC  => '2014-01-10 11:12:13',
        OTOBOTimeZone => 'Europe/Berlin',
        Result        => 'Fri, 10 Jan 2014 12:12:13 +0100',
    },
    {
        Name          => 'America/Los_Angeles',
        TimeStampUTC  => '2014-01-10 11:12:13',
        OTOBOTimeZone => 'America/Los_Angeles',
        Result        => 'Fri, 10 Jan 2014 03:12:13 -0800',
    },
    {
        Name          => 'Australia/Sydney',
        TimeStampUTC  => '2014-01-10 11:12:13',
        OTOBOTimeZone => 'Australia/Sydney',
        Result        => 'Fri, 10 Jan 2014 22:12:13 +1100',
    },
    {
        Name          => 'Europe/London',
        TimeStampUTC  => '2014-01-10 11:12:13',
        OTOBOTimeZone => 'Europe/London',
        Result        => 'Fri, 10 Jan 2014 11:12:13 +0000',
    },
    {
        Name          => 'Europe/Berlin',
        TimeStampUTC  => '2014-08-03 02:03:04',
        OTOBOTimeZone => 'Europe/Berlin',
        Result        => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {

        Name          => 'America/Los_Angeles',
        TimeStampUTC  => '2014-08-03 02:03:04',
        OTOBOTimeZone => 'America/Los_Angeles',
        Result        => 'Sat, 2 Aug 2014 19:03:04 -0700',
    },
    {
        Name          => 'Australia/Sydney',
        TimeStampUTC  => '2014-08-03 02:03:04',
        OTOBOTimeZone => 'Australia/Sydney',
        Result        => 'Sun, 3 Aug 2014 12:03:04 +1000',
    },
    {
        Name          => 'Europe/London DST',
        TimeStampUTC  => '2014-08-03 02:03:04',
        OTOBOTimeZone => 'Europe/London',
        Result        => 'Sun, 3 Aug 2014 03:03:04 +0100',
    },
    {
        Name          => 'Europe/Berlin DST',
        TimeStampUTC  => '2014-08-03 02:03:04',
        OTOBOTimeZone => 'Europe/Berlin',
        Result        => 'Sun, 3 Aug 2014 04:03:04 +0200',
    },
    {
        Name          => 'Asia/Kathmandu, offset with minutes',
        TimeStampUTC  => '2014-08-03 02:03:04',
        OTOBOTimeZone => 'Asia/Kathmandu',
        Result        => 'Sun, 3 Aug 2014 07:48:04 +0545',
    },
);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

for my $Test (@Tests) {

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Test->{TimeStampUTC},
            TimeZone => 'UTC',
        },
    );

    # Set OTOBO time zone to matching one.
    $ConfigObject->Set(
        Key   => 'OTOBOTimeZone',
        Value => $Test->{OTOBOTimeZone},
    );

    FixedTimeSet($DateTimeObject);

    # Discard time object because of changed time zone
    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::System::Time', ],
    );
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    $DateTimeObject->ToTimeZone( TimeZone => $Test->{OTOBOTimeZone} );

    my $MailTimeStamp = $TimeObject->MailTimeStamp();

    $Self->Is(
        $MailTimeStamp,
        $Test->{Result},
        "$Test->{Name} ($Test->{OTOBOTimeZone}) Timestamp $Test->{TimeStampUTC}:",
    );

    FixedTimeUnset();
}

$Self->DoneTesting();
