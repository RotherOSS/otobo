# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use Data::Peek qw(DDump);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Start on a clean slate when the test table already exists
$DBObject->Do( SQL => 'DROP TABLE test_utf8_range' );

# create database table for tests
my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => <<'END_XML' );
<Table Name="test_utf8_range">
    <Column Name="counter"               Required="true" Type="INTEGER"/>
    <Column Name="test_message_varchar"  Required="true" Size="255" Type="VARCHAR"/>
    <Column Name="test_message_longblob" Required="true" Type="LONGBLOB"/>
</Table>
END_XML
my @SQL = $DBObject->SQLProcessor( Database => \@XMLArray );
for my $SQL (@SQL) {
    ok( $DBObject->Do( SQL => $SQL ) || 0, 'executed SQL' );
}

my @Tests = (
    {
        Name => 'UTF8 1 byte, single byte in ASCII and latin1',
        Data => 'a',                                              # a - U+00061 - 61 - LATIN SMALL LETTER A
    },
    {
        Name => 'UTF8 2 byte, single byte in latin1',
        Data => 'ö',                                             # ö - U+000F6 - C3 B6 - LATIN SMALL LETTER O WITH DIAERESIS
    },
    {
        Name => 'UTF8 3 byte',
        Data => 'ऄ',                                            # ऄ - U+00904 - E0 A4 84 - DEVANAGARI LETTER SHORT A
    },
    {
        Name => 'UTF8 4 byte',
        Data => '𐡀',                                           # 𐡀 - U+10840 - F0 90 A1 80 - IMPERIAL ARAMAIC LETTER ALEPH
    },
    {
        Name => 'all of the above concatenated',
        Data => 'aöऄ𐡀',
    },
);

my $Counter = 0;
for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        # Because of 'use utf8;' the test data is initially considered as being UTF-8 encoded.
        # This happens to result in 'a' not having the UTF-8 Flag and 'ö' having the UTF-8 flag.
        # It is not obvious whether this is guaranteed behavior.
        #
        # This test script does not consider the DirectBlob attribute. This means that the
        # binary transfer to the database is verified even for the database backends
        # which Base64 encode the LONGBLOB columns.
        my $TestData        = $Test->{Data};
        my $EncodedTestData = $TestData;
        utf8::encode($EncodedTestData);    # this effectively removes the UTF-8 flag
        diag "Testing: $TestData";
        diag 'test data:',              "\n", scalar DDump $TestData;
        diag 'UTF8 encoded test data:', "\n", scalar DDump $EncodedTestData;

        my $InsertSuccess = $DBObject->Do(
            SQL  => 'INSERT INTO test_utf8_range ( counter, test_message_varchar, test_message_longblob ) VALUES ( ?, ?, ? )',
            Bind => [
                \$Counter,
                \$TestData,
                \$EncodedTestData,
            ],
            BindAsBinary => [
                0,
                0,
                1,
            ],
        );
        ok( $InsertSuccess, 'INSERT' );

        $Counter++;

        # Fetch without WHERE, get the latest inserted row
        $DBObject->Prepare(
            SQL => <<'END_SQL',
SELECT test_message_varchar, test_message_longblob
  FROM test_utf8_range
  ORDER BY counter DESC
END_SQL
            Limit => 1,
        );

        my $RowCount = 0;
        while ( my ( $MessageVarchar, $MessageLongblob ) = $DBObject->FetchrowArray ) {
            diag 'MessageVarchar: ', scalar DDump $MessageVarchar;
            is( $MessageVarchar, $TestData, "SELECT test_message_varchar" );
            diag 'MessageLongblob: ', scalar DDump $MessageLongblob;
            is( $MessageLongblob, $TestData, "SELECT test_message_longblob, TestData" );
            if ( utf8::is_utf8($TestData) ) {
                isnt( $MessageLongblob, $EncodedTestData, "SELECT test_message_longblob, EncodedTestData" );
            }
            else {

                # When the test data has no high bytes then encoded and decoded strings are the same.
                is( $MessageLongblob, $EncodedTestData, "SELECT test_message_longblob, EncodedTestData, ASCII" );
            }
            $RowCount++;
        }
        is( $RowCount, 1, 'only one row found' );

        # Fetch 1 with WHERE
        $DBObject->Prepare(
            SQL  => 'SELECT test_message_varchar, test_message_longblob FROM test_utf8_range WHERE test_message_varchar = ?',
            Bind => [ \$TestData, ],
        );

        $RowCount = 0;
        while ( my ( $MessageVarchar, $MessageLongblob ) = $DBObject->FetchrowArray ) {
            is( $MessageVarchar,  $TestData, "SELECT test_message_varchar with WHERE" );
            is( $MessageLongblob, $TestData, "SELECT test_message_longblob with WHERE, TestData" );

            if ( utf8::is_utf8($TestData) ) {
                isnt( $MessageLongblob, $EncodedTestData, "SELECT test_message_longblob with WHERE, EncodedTestData" );
            }
            else {

                # When the test data has no high bytes then encoded and decoded strings are the same.
                is( $MessageLongblob, $EncodedTestData, "SELECT test_message_longblob with WHERE, EncodedTestData, ASCII" );
            }
            $RowCount++;
        }
        is( $RowCount, 1, 'only one row found with WHERE' );
    };
}

# cleanup, comment out the block for inspection after the script has run
ok(
    $DBObject->Do( SQL => 'DROP TABLE test_utf8_range' ) || 0,
    'DROP TABLE test_utf8_range',
);

done_testing;
