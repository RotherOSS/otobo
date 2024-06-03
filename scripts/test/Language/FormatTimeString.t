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

use vars (qw($Self %Param));

my @Tests = (
    {
        Name           => 'Default format',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 11:12:13',
        Result         => '11:12:13 - 10.01.2014',
    },
    {
        Name           => 'Default format, short',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 1,
        Time           => '2014-01-10 11:12:13',
        Result         => '11:12 - 10.01.2014',
    },
    {
        Name           => 'Default format, only date passed',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10',
        Result         => '2014-01-10',
    },
    {
        Name           => 'Default format, only time passed',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '22:12:06',
        Result         => '22:12:06',
    },
    {
        Name           => 'Default format, malformed date/time',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => 'INVALID',
        Result         => 'INVALID',
    },
    {
        Name           => 'Time zone on day border',
        UserTimeZone   => 'Europe/Berlin',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-09 23:34:05',
        Result         => '00:34:05 - 10.01.2014 (Europe/Berlin)',
    },
    {
        Name           => 'Time zone on day border for DateFormatShort (TimeZone not applied)',
        UserTimeZone   => 'Europe/Berlin',
        DateFormatName => 'DateFormatShort',
        DateFormat     => '%T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 00:00:00',
        Result         => '00:00:00 - 10.01.2014',
    },
    {
        Name           => 'All tags test',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%A %B %T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 11:12:13',
        Result         => 'Fr Jan 11:12:13 - 10.01.2014',
    },
    {
        Name           => 'All tags test, with timezone',
        UserTimeZone   => 'Europe/Berlin',
        DateFormatName => 'DateFormatLong',
        DateFormat     => '%A %B %T - %D.%M.%Y',
        Short          => 0,
        Time           => '2014-01-10 11:12:13',
        Result         => 'Fr Jan 12:12:13 - 10.01.2014 (Europe/Berlin)',
    },
);

for my $Test (@Tests) {

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'OTOBOTimeZone',
        Value => 'UTC',
    );

    # discard language object
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::Language'],
    );

    # get language object
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Language' => {
            UserTimeZone => $Test->{UserTimeZone},
            UserLanguage => 'de',
        },
    );

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    $LanguageObject->{ $Test->{DateFormatName} } = $Test->{DateFormat};

    my $Result = $LanguageObject->FormatTimeString(
        $Test->{Time},
        $Test->{DateFormatName},
        $Test->{Short}
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - return",
    );
}

$Self->DoneTesting();
