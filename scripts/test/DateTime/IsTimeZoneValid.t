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
# Tests for IsTimeZoneValid()
#
my @TestConfigs = (
    {
        TimeZone       => 'Europe/Berlin',
        ExpectedResult => 1,
    },
    {
        TimeZone       => 'Europe/BerTYPOlin',
        ExpectedResult => 0,
    },
    {
        TimeZone       => '+2',
        ExpectedResult => 0,
    },
    {
        TimeZone       => '-5',
        ExpectedResult => 0,
    },
    {
        TimeZone       => 0,
        ExpectedResult => 0,
    },
    {
        TimeZone       => 'UTC',
        ExpectedResult => 1,
    },
    {
        TimeZone       => 'Europe/New_York',
        ExpectedResult => 0,
    },
    {
        TimeZone       => 'America/Paris',
        ExpectedResult => 0,
    },
);

my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    $Self->Is(
        $DateTimeObject->IsTimeZoneValid( TimeZone => $TestConfig->{TimeZone} ),
        $TestConfig->{ExpectedResult},
        'Time zone '
            . $TestConfig->{TimeZone}
            . ' has to be recognized as '
            . ( $TestConfig->{ExpectedResult} ? '' : 'not ' )
            . 'valid.',
    );
}

$Self->DoneTesting();
