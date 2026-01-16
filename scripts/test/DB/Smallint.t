# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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
use Data::Peek        qw(DDump);
use JSON::PP          ();
use Types::Serialiser ();

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# create database table for tests
# OTOBO does not use boolean attributes in the database tables. Test with a SMALLINT.
# SMALLINT has the range -32768 to 32767
my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => <<'END_XML' );
<Table Name="test_smallint_table">
    <Column Name="test_smallint"  Required="true" Type="SMALLINT"/>
</Table>
END_XML
my @SQL = $DBObject->SQLProcessor( Database => \@XMLArray );
for my $SQL (@SQL) {
    diag "SQL: $SQL";
    ok( $DBObject->Do( SQL => $SQL ) || 0, 'executed SQL' );
}

my @Tests = (
    {
        Name          => 'very large negative',
        Data          => -32769,
        InsertSuccess =>  0,
    },
    {
        Name => 'large negative',
        Data => -32768,
    },
    {
        Name => 'negative',
        Data => -3276,
    },
    {
        Name => 'minus one',
        Data => -1,
    },
    {
        Name => 'negative zero',
        Data => -0,
    },
    {
        Name => "zero",
        Data => 0,
    },
    {
        Name => 'positive one',
        Data => 1,
    },
    {
        Name => 'positive',
        Data => 3276,
    },
    {
        Name => 'large positive',
        Data => 32767,
    },
    {
        Name          => 'very large positive',
        Data          => 32768,
        InsertSuccess => 0,
    },

    # Booleans
    {
        Name          => '$JSON::PP::true',
        Data          => $JSON::PP::true,
        ExpectedValue => 1,
    },
    {
        Name          => 'JSON::PP::true()',
        Data          => JSON::PP::true(),
        ExpectedValue => 1,
    },
    {
        Name          => '$JSON::PP::false',
        Data          => $JSON::PP::false,
        ExpectedValue => 0,
    },
    {
        Name          => 'JSON::PP::false()',
        Data          => JSON::PP::false(),
        ExpectedValue => 0,
    },
    {
        Name          => '$Types::Serialiser::true',
        Data          => $Types::Serialiser::true,
        ExpectedValue => 1,
    },
    {
        Name          => 'Types::Serialiser::true()',
        Data          => Types::Serialiser::true(),
        ExpectedValue => 1,
    },
    {
        Name          => '$Types::Serialiser::false',
        Data          => $Types::Serialiser::false,
        ExpectedValue => 0,
    },
    {
        Name          => 'Types::Serialiser::false()',
        Data          => Types::Serialiser::false(),
        ExpectedValue => 0,
    },
);

for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        my @BindVariables = ( \$Test->{Data} );
        my $InsertSuccess = 0;
        my $InsertLives   = lives {
            $InsertSuccess = $DBObject->Do(
                SQL  => 'INSERT INTO test_smallint_table ( test_smallint ) VALUES ( ? )',
                Bind => \@BindVariables,
            );
        };
        ok( $InsertLives, 'Insert() did not throw an exception' );
        if ( $Test->{InsertSuccess} // 1 ) {
            ok( $InsertSuccess, 'INSERT successful' );
        }
        else {
            ok( !$InsertSuccess, 'INSERT failed' );

            return;    # no further checks
        }

        # Fetch without WHERE
        $DBObject->Prepare(
            SQL => 'SELECT test_smallint FROM test_smallint_table',
        );

        my $RowCount = 0;
        while ( my ($RetrievedSmallint) = $DBObject->FetchrowArray ) {
            diag 'RetrievedSmallint: ', scalar DDump $RetrievedSmallint;
            my $ExpectedSmallint = $Test->{ExpectedValue} // $Test->{Data};
            is( $RetrievedSmallint, $ExpectedSmallint, 'SELECT test_smallint' );
            $RowCount++;
        }
        is( $RowCount, 1, 'only one row found' );

        # Fetch one row with WHERE
        $DBObject->Prepare(
            SQL  => 'SELECT test_smallint FROM test_smallint_table WHERE test_smallint = ?',
            Bind => \@BindVariables,
        );

        $RowCount = 0;
        while ( my ($RetrievedSmallint) = $DBObject->FetchrowArray ) {
            my $ExpectedSmallint = $Test->{ExpectedValue} // $Test->{Data};
            is( $RetrievedSmallint, $ExpectedSmallint, "SELECT test_smallint with WHERE" );
            $RowCount++;
        }
        is( $RowCount, 1, 'only one row found with WHERE' );

        my $DeleteSuccess = $DBObject->Do(
            SQL => 'DELETE FROM test_smallint_table',
        );
        ok( $DeleteSuccess, "test_smallint_table cleared" );
    };
}

# cleanup
ok(
    $DBObject->Do( SQL => 'DROP TABLE test_smallint_table' ) || 0,
    'DROP TABLE',
);

done_testing;
