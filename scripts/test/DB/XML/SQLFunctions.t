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

# get needed objects
my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# XML test 10 - SQL functions: LOWER(), UPPER()
# ------------------------------------------------------------ #
# test different sizes up to 3999.
# 4000 is a magic value, beyond which locator objects might be used
# and all bets regarding UPPER and LOWER are off
my $XML = '
<TableCreate Name="test_j">
    <Column Name="name_a" Required="true" Size="6"    Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60"   Type="VARCHAR"/>
    <Column Name="name_c" Required="true" Size="600"  Type="VARCHAR"/>
    <Column Name="name_d" Required="true" Size="3998" Type="VARCHAR"/>
</TableCreate>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my @SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

# as 'Ab' is two chars, multiply half the sizes from test_j
my @Values = map { 'Ab' x $_ } ( 3, 30, 300, 1999 );

# insert
my $Result = $DBObject->Do(
    SQL  => 'INSERT INTO test_j (name_a, name_b, name_c, name_d) VALUES ( ?, ?, ?, ? )',
    Bind => [ \(@Values) ],
);
$Self->True(
    $Result,
    "Do() INSERT",
);

my $SQL = 'SELECT LOWER(name_a), LOWER(name_b), LOWER(name_c), LOWER(name_d) FROM test_j';
$Result = $DBObject->Prepare(
    SQL   => $SQL,
    Limit => 1,
);
$Self->True(
    $Result,
    'Prepare() - LOWER() - SELECT',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Self->Is(
        scalar(@Row),
        scalar(@Values),
        "- LOWER() - Check number of fetched elements",
    );

    for my $Index ( 0 .. 3 ) {
        $Self->Is(
            $Row[$Index],
            lc( $Values[$Index] ),
            "#10.$Index - LOWER() - result",
        );
    }
}

$SQL    = 'SELECT UPPER(name_a), UPPER(name_b), UPPER(name_c), UPPER(name_d) FROM test_j';
$Result = $DBObject->Prepare(
    SQL   => $SQL,
    Limit => 1,
);
$Self->True(
    $Result,
    'Prepare() - UPPER() - SELECT',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Self->Is(
        scalar(@Row),
        scalar(@Values),
        "UPPER() - Check number of fetched elements",
    );

    for my $Index ( 0 .. 3 ) {
        $Self->Is(
            $Row[$Index],
            uc( $Values[$Index] ),
            "$Index - UPPER() - result",
        );
    }
}

$XML      = '<TableDrop Name="test_j"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() DROP TABLE ($SQL)",
    );
}

# cleanup cache is done by RestoreDatabase.

$Self->DoneTesting();
