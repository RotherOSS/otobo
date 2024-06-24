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

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# ------------------------------------------------------------ #
# Statement size checks (test 11)
# ------------------------------------------------------------ #
for my $QuerySize (
    100,   500,   1_000, 1_050,  2_000,   2_100, 3_000, 3_200,
    4_000, 4_400, 5_000, 10_000, 100_000, 1_000_000
    )
{
    my $SQL = 'SELECT' . ( ' ' x ( $QuerySize - 31 ) ) . '1 FROM valid WHERE id = 1';

    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#11 QuerySize check for size $QuerySize",
    );
}

my @Tests = (
    {
        Name   => 'empty',
        Data   => '',
        Result => '',
    },
    {
        Name   => 'string',
        Data   => '123 ( (( )) ) & && | ||',
        Result => '123 \( \(\( \)\) \) \& \&\& \| \|\|',
    },
);

for my $Test (@Tests) {
    my $Result = $DBObject->QueryStringEscape(
        QueryString => $Test->{Data}
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        'QueryStringEscape - ' . $Test->{Name}
    );
}

$Self->DoneTesting();
