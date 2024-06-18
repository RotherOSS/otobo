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
use Test2::V0;

# OTOBO modules
use Kernel::System::ObjectManager;

# TimeStamp2SystemTime tests
# See the command: date -d"2005-10-20T10:00:00Z" +%s
my @TimeStamp2SystemTimeTests = (
    {
        Description    => 'Zulu time',
        String         => '2005-10-20T10:00:00Z',
        ExpectedResult => 1129802400,
    },
    {
        Description    => 'UTC with offset +00:00',
        String         => '2005-10-20T10:00:00+00:00',
        ExpectedResult => 1129802400,
    },
    {
        Description    => 'UTC with offset -00:00',
        String         => '2005-10-20T10:00:00-00:00',
        ExpectedResult => 1129802400,
    },
    {
        Description    => 'UTC with offset -00',
        String         => '2005-10-20T10:00:00-00',
        ExpectedResult => 1129802400,
    },
    {
        Description    => 'UTC with offset +0',
        String         => '2005-10-20T10:00:00+0',
        ExpectedResult => 1129802400,
    },
    {
        Description    => 'Europe/Belgrade in funny format',
        String         => '20-10-2005 10:00:00',
        ExpectedResult => 1129795200,
    },
    {
        Description    => 'Europe/Belgrade in ISO-8601, with space as separator',
        String         => '2005-10-20 10:00:00',
        ExpectedResult => 1129795200,
    },
    {
        Description    => 'Europe/Belgrade in ISO-8601, with T as separator',
        String         => '2005-10-20T10:00:00',
        ExpectedResult => 1129795200,
    },
    {
        Description    => 'Nepal',
        String         => '2020-08-25T10:00:00+5:45',
        ExpectedResult => 1598328900,
    },
    {
        Description    => 'Newfoundland',
        String         => '2020-08-25T00:45:00-3:30',
        ExpectedResult => 1598328900,
    },
);

plan( scalar @TimeStamp2SystemTimeTests + 1 );

# with specific time zone
$Kernel::OM = Kernel::System::ObjectManager->new();

my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        TimeZone => 'Europe/Belgrade',
    }
);

isa_ok( $DateTimeObject, ['Kernel::System::DateTime'], 'creation of DateTime object.' );

for my $Test (@TimeStamp2SystemTimeTests) {
    my $SystemTime  = $DateTimeObject->TimeStamp2SystemTime( String => $Test->{String} );
    my $Description = 'TimeStamp2SystemTime(): ' . ( $Test->{Description} // 'system time matches' );

    is( $SystemTime, $Test->{ExpectedResult}, $Description );
}
