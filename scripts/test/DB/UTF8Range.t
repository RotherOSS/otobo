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

# create database table for tests
my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => <<'END_XML');
<Table Name="test_utf8_range">
    <Column Name="test_message_varchar"  Required="true" Size="255" Type="VARCHAR"/>
    <Column Name="test_message_longblob" Required="true" Type="LONGBLOB"/>
</Table>
END_XML
my @SQL = $DBObject->SQLProcessor( Database => \@XMLArray );
for my $SQL (@SQL) {
    diag "SQL: $SQL";
    ok( $DBObject->Do( SQL => $SQL ) || 0, 'executed SQL' );
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
        Name => "UTF8 4 byte",
        Data => '💩',          # PILE OF POO (f0 9f 92 a9)
    },
);

for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        # Because of 'use utf8;' the test data is initially considered as being UTF-8 encoded,
        # which does not imply that the UTF-8 flag is on.
        my $TestData = $Test->{Data};
        diag "Testing: $TestData";
        diag 'test data: ', scalar DDump $TestData;

        my $EncodedTestData = $TestData;
        utf8::encode($EncodedTestData);
        diag 'encoded test data: ', scalar DDump $EncodedTestData;

        my $InsertSuccess = $DBObject->Do(
            SQL  => 'INSERT INTO test_utf8_range ( test_message_varchar, test_message_longblob ) VALUES ( ?, ? )',
            Bind => [
                \$TestData,
                \$EncodedTestData,
            ],
        );
        ok( $InsertSuccess, 'INSERT' );

        # Fetch without WHERE
        $DBObject->Prepare(
            SQL   => 'SELECT test_message_varchar, test_message_longblob FROM test_utf8_range',
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
            SQL   => 'SELECT test_message_varchar, test_message_longblob FROM test_utf8_range WHERE test_message_varchar = ?',
            Bind  => [ \$TestData, ],
            Limit => 1,
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
