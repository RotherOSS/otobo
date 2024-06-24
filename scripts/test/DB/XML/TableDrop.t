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

# -------------------------------------------------------------------------------------------- #
# Test creating a table, then dropping it, and then adding a new table with the same old name
# -------------------------------------------------------------------------------------------- #
my $XML = '
<Table Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
    <Column Name="name" Required="false" Size="20" Type="VARCHAR" />
    <Unique Name="test_a_name">
        <UniqueColumn Name="name"/>
    </Unique>
</Table>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );

my @SQLARRAY = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQLARRAY[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQLARRAY) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

# add 2 values to table
my $SQL = "INSERT INTO test_a (name) VALUES ('Test1')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

$SQL = "INSERT INTO test_a (name) VALUES ('Test2')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# get the id from the second entry
$SQL = "SELECT id FROM test_a WHERE name = 'Test2'";
$Self->True(
    $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    ),
    "Prepare(): $SQL",
);

my $LastID;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $LastID = $Row[0];
}

$Self->True(
    $LastID,
    "Check that the last entry could be added (ID: $LastID)",
);

# drop table
$XML      = '<TableDrop Name="test_a"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQLARRAY = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQLARRAY[0],
    'SQLProcessor() DROP TABLE',
);

for my $SQL (@SQLARRAY) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() DROP TABLE ($SQL)",
    );
}

# add the same table again
$XML = '
<Table Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
    <Column Name="name" Required="false" Size="20" Type="VARCHAR" />
    <Unique Name="test_a_name">
        <UniqueColumn Name="name"/>
    </Unique>
</Table>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQLARRAY = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQLARRAY[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQLARRAY) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

# add 2 values to table
$SQL = "INSERT INTO test_a (name) VALUES ('Test1')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

$SQL = "INSERT INTO test_a (name) VALUES ('Test2')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# get the id from the second entry
$SQL = "SELECT id FROM test_a WHERE name = 'Test2'";
$Self->True(
    $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    ),
    "Prepare(): $SQL",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $LastID = $Row[0];
}

$Self->True(
    $LastID,
    "Check that the last entry could be added (ID: $LastID)",
);

# drop table
$XML      = '<TableDrop Name="test_a"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQLARRAY = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQLARRAY[0],
    'SQLProcessor() DROP TABLE',
);

for my $SQL (@SQLARRAY) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() DROP TABLE ($SQL)",
    );
}

# cleanup cache is done by RestoreDatabase.

$Self->DoneTesting();
