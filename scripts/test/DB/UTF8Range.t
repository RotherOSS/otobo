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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# create database table for tests
my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => <<'END_XML');
<Table Name="test_utf8_range">
    <Column Name="test_message" Required="true" Size="255" Type="VARCHAR"/>
</Table>
END_XML
my @SQL = $DBObject->SQLProcessor( Database => \@XMLArray );
for my $SQL (@SQL) {
    ok(
        $DBObject->Do( SQL => $SQL ) || 0,
        "executing SQL: $SQL",
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

    subtest $Test->{Name} => sub {
        my $InsertSuccess = $DBObject->Do(
            SQL => 'INSERT INTO test_utf8_range ( test_message )'
                . ' VALUES ( ? )',
            Bind => [ \$Test->{Data} ],
        );
        ok( $InsertSuccess, "INSERT" );

        my $ExpectedData = $Test->{Data};
        if ( $Test->{ExpectedDataOnMysql} && $DBObject->{Backend}->{'DB::Type'} eq 'mysql' ) {
            $ExpectedData = $Test->{ExpectedDataOnMysql};
        }

        # Fetch without WHERE
        $DBObject->Prepare(
            SQL   => 'SELECT test_message FROM test_utf8_range',
            Limit => 1,
        );

        my $RowCount = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            is( $Row[0], $ExpectedData, "SELECT row" );
            $RowCount++;
        }
        is( $RowCount, 1, 'only one row found' );

        # Fetch 1 with WHERE
        $DBObject->Prepare(
            SQL   => 'SELECT test_message FROM test_utf8_range WHERE test_message = ?',
            Bind  => [ \$Test->{Data}, ],
            Limit => 1,
        );

        $RowCount = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            is( $Row[0], $ExpectedData, "SELECT all with where", );
            $RowCount++;
        }
        is( $RowCount, 1, 'only one row found with WHERE' );

        my $DeleteSuccess = $DBObject->Do(
            SQL => 'DELETE FROM test_utf8_range',
        );

        ok( $DeleteSuccess, "test_utf8_range cleared" );
    };
}

# cleanup
ok(
    $DBObject->Do( SQL => 'DROP TABLE test_utf8_range' ) || 0,
    'DROP TABLE',
);

done_testing;
