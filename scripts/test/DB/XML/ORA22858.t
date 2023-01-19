# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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
# XML test 12 (XML:TableCreate, XML:TableAlter,
# SQL:Insert (size check),  XML:TableDrop)
# Fix/Workaround for ORA-22858: invalid alteration of datatype
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="SMALLINT"/>
    <Column Name="name_a" Required="false" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="false" Size="60" Type="VARCHAR"/>
</TableCreate>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my @SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#12 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#12 Do() CREATE TABLE ($SQL)",
    );
}

# all values have the exact maximum size
my $ValueA = 'A';
my $ValueB = 'B';

# adding valid values in each column
$Self->True(
    $DBObject->Do(
        SQL =>
            'INSERT INTO test_a (name_a, name_b) VALUES (?, ?)',
        Bind => [ \$ValueA, \$ValueB ],
        )
        || 0,
    '#12 Do() SQL INSERT before column size change',
);

$XML = '
<TableAlter Name="test_a">
    <ColumnChange NameOld="name_a" NameNew="name_a" Type="VARCHAR" Size="1800000" Required="false"/>
    <ColumnChange NameOld="name_b" NameNew="name_b" Type="VARCHAR" Size="1800000" Required="false"/>
</TableAlter>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#12 SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#12 Do() ALTER TABLE ($SQL)",
    );
}

# all values have the exact maximum size
$ValueA = 'A' x 1800000;
$ValueB = 'B' x 1800000;

# adding valid values in each column
$Self->True(
    $DBObject->Do(
        SQL =>
            'INSERT INTO test_a (name_a, name_b) VALUES (?, ?)',
        Bind => [ \$ValueA, \$ValueB ],
        )
        || 0,
    '#12 Do() SQL INSERT after column size change',
);

$XML      = '<TableDrop Name="test_a"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#12 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#12 Do() DROP TABLE ($SQL)",
    );
}

# cleanup cache is done by RestoreDatabase.

$Self->DoneTesting();
