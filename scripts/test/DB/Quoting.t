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
# quoting tests
# ------------------------------------------------------------ #
$Self->Is(
    $DBObject->Quote( 0, 'Integer' ),
    0,
    'Quote() Integer - 0',
);
$Self->Is(
    $DBObject->Quote( 1, 'Integer' ),
    1,
    'Quote() Integer - 1',
);
$Self->Is(
    $DBObject->Quote( 123, 'Integer' ),
    123,
    'Quote() Integer - 123',
);
$Self->Is(
    $DBObject->Quote( 61712, 'Integer' ),
    61712,
    'Quote() Integer - 61712',
);
$Self->Is(
    $DBObject->Quote( -61712, 'Integer' ),
    -61712,
    'Quote() Integer - -61712',
);
$Self->Is(
    $DBObject->Quote( '+61712', 'Integer' ),
    '+61712',
    'Quote() Integer - +61712',
);
$Self->Is(
    $DBObject->Quote( '02', 'Integer' ),
    '02',
    'Quote() Integer - 02',
);
$Self->Is(
    $DBObject->Quote( '0000123', 'Integer' ),
    '0000123',
    'Quote() Integer - 0000123',
);

$Self->Is(
    $DBObject->Quote( 123.23, 'Number' ),
    123.23,
    'Quote() Number - 123.23',
);
$Self->Is(
    $DBObject->Quote( 0.23, 'Number' ),
    0.23,
    'Quote() Number - 0.23',
);
$Self->Is(
    $DBObject->Quote( '+123.23', 'Number' ),
    '+123.23',
    'Quote() Number - +123.23',
);
$Self->Is(
    $DBObject->Quote( '+0.23132', 'Number' ),
    '+0.23132',
    'Quote() Number - +0.23132',
);
$Self->Is(
    $DBObject->Quote( '+12323', 'Number' ),
    '+12323',
    'Quote() Number - +12323',
);
$Self->Is(
    $DBObject->Quote( -123.23, 'Number' ),
    -123.23,
    'Quote() Number - -123.23',
);
$Self->Is(
    $DBObject->Quote( -123, 'Number' ),
    -123,
    'Quote() Number - -123',
);
$Self->Is(
    $DBObject->Quote( -0.23, 'Number' ),
    -0.23,
    'Quote() Number - -0.23',
);

if (
    $DBObject->GetDatabaseFunction('Type') eq 'postgresql' ||
    $DBObject->GetDatabaseFunction('Type') eq 'oracle'     ||
    $DBObject->GetDatabaseFunction('Type') eq 'db2'        ||
    $DBObject->GetDatabaseFunction('Type') eq 'ingres'
    )
{
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l;',
        "Quote() String - Test\'l;",
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
elsif ( $DBObject->GetDatabaseFunction('Type') eq 'mssql' ) {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[[]12]Block[[]12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
else {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\\\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\\\'l\\;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}

$Self->DoneTesting();
