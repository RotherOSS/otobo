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
# XML test 1 (XML:TableCreate, SQL:Insert, SQL:Select, SQL:Delete,  XML:TableDrop)
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_a">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
    <Index Name="index_test_name_a">
        <IndexColumn Name="name_a"/>
    </Index>
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

$Self->True(
    $DBObject->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some\', \'Lalala\')',
        )
        || 0,
    'Do() INSERT',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    'Prepare() SELECT - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT',
);

# rename table
$XML      = '<TableAlter NameOld="test_a" NameNew="test_aa"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() ALTER TABLE',
);
for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() ALTER TABLE ($SQL)",
    );
}

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_aa WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    'Prepare() SELECT - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT DISTINCT * FROM test_aa WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    'Prepare() SELECT DISTINCT - Limit - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT DISTINCT - Limit',
);

$Self->True(
    $DBObject->Do(
        SQL => 'DELETE FROM valid WHERE name = \'Some\'',
        )
        || 0,
    'Do() DELETE',
);

$XML      = '<TableDrop Name="test_aa"/>';
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
