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

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# create database for tests
my $XML = '
<Table Name="test_utf8_range">
    <Column Name="test_message" Required="true" Size="255" Type="VARCHAR"/>
</Table>
';
my @XMLARRAY = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );
my @SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "CREATE TABLE ($SQL)",
    );
}

my @Tests = (
    {
        Name => "Ascii / UTF8 1 byte",
        Data => 'aou',
    },
    {
        Name => "UTF8 2 byte",
        Data => 'äöü',
    },
    {
        Name => "UTF8 3 byte",
        Data => 'ऄ',           # DEVANAGARI LETTER SHORT A (e0 a4 84)
    },
    {
        Name                => "UTF8 4 byte",
        Data                => '💩',          # PILE OF POO (f0 9f 92 a9)
        ExpectedDataOnMysql => '💩',
    },
);

for my $Test (@Tests) {

    my $Success = $DBObject->Do(
        SQL => 'INSERT INTO test_utf8_range ( test_message )'
            . ' VALUES ( ? )',
        Bind => [ \$Test->{Data} ],
    );

    $Self->True(
        $Success,
        "$Test->{Name} - INSERT",
    );

    my $ExpectedData = $Test->{Data};
    if ( $Test->{ExpectedDataOnMysql} && $DBObject->{Backend}->{'DB::Type'} eq 'mysql' ) {
        $ExpectedData = $Test->{ExpectedDataOnMysql};
    }

    # Fetch withouth WHERE
    $DBObject->Prepare(
        SQL   => 'SELECT test_message FROM test_utf8_range',
        Limit => 1,
    );

    my $RowCount = 0;

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->Is(
            $Row[0],
            $ExpectedData,
            "$Test->{Name} - SELECT all",
        );
        $RowCount++;
    }

    $Self->Is(
        $RowCount,
        1,
        "$Test->{Name} - SELECT all row count",
    );

    # Fetch 1 with WHERE
    $DBObject->Prepare(
        SQL => '
            SELECT test_message
            FROM test_utf8_range
            WHERE test_message = ?',
        Bind  => [ \$Test->{Data}, ],
        Limit => 1,
    );

    $RowCount = 0;

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->Is(
            $Row[0],
            $ExpectedData,
            "$Test->{Name} - SELECT all",
        );
        $RowCount++;
    }

    $Self->Is(
        $RowCount,
        1,
        "$Test->{Name} - SELECT all row count",
    );

    $Success = $DBObject->Do(
        SQL => 'DELETE FROM test_utf8_range',
    );

    $Self->True(
        $Success,
        "$Test->{Name} - DELETE",
    );
}

# cleanup
$Self->True(
    $DBObject->Do( SQL => 'DROP TABLE test_utf8_range' ) || 0,
    "DROP TABLE",
);

$Self->DoneTesting();
