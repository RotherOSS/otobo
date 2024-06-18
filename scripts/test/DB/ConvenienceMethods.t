# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

=head1 NAME

ConvenienceMethods.t - test some select methods of Kernel::System::DB

=head1 SYNOPSIS

    bin/otobo.Console.pl Dev::UnitTest::Run --verbose --merge scripts/test/DB/ConvenienceMethods.t

=head1 DESCRIPTION

Set up some test data in the table B<test_countries> and perform some SELECTS on that data.

The tested methods are:

=over 4

=item SelectAll

=item SelectRowArray

=item SelectColArray

=item Prepare

=back

=cut

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

# set up test data
my $XML = <<'END_XML';
<TableCreate Name="test_countries">
    <Column Name="country_en" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="country_de" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="country_si" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="is_country" Required="true" Type="SMALLINT"/>
</TableCreate>
END_XML

my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my ($CreateTableSQL) = $DBObject->SQLProcessor( Database => \@XMLARRAY );
like( $CreateTableSQL, qr/CREATE TABLE/, 'SQL was generated' );
ok( $DBObject->Do( SQL => $CreateTableSQL ), 'table created' );

# country translations, sorted by the English name
my @Countries = (
    [ 'Austria',  'Österreich', 'ඔස්ට්රියාව',    1 ],
    [ 'Colombia', 'Kolumbien',   'කොලොම්බියාව', 1 ],
    [ 'Germany',  'Deutschland', 'ජර්මනිය',             1 ],
);

# Insert the values.
# is_country is inserted as a scalar, will be set for all rows
my $NumInserted = $DBObject->DoArray(
    SQL  => 'INSERT INTO test_countries (country_en, country_de, country_si, is_country) VALUES (?, ?, ?, ?)',
    Bind => [
        [ map { $_->[0] } @Countries ],
        [ map { $_->[1] } @Countries ],
        [ map { $_->[2] } @Countries ],
        1,
    ],
);
is( $NumInserted, scalar(@Countries), 'insert countries with column bind' );

# Add more countries with ArrayTupleFetch.
my @MoreCountries = (
    [ 'Malawi',    'Malawi',    'මලාවි',              1 ],
    [ 'Sri Lanka', 'Sri Lanka', 'ශ්රී ලංකාව', 1 ],
);
push @Countries, @MoreCountries;

my $FetchMoreCountries = sub {
    state $Index = -1;

    $Index++;

    return if $Index >= scalar @MoreCountries;
    return $MoreCountries[$Index];
};

my $NumMoreInserted = $DBObject->DoArray(
    SQL             => 'INSERT INTO test_countries (country_en, country_de, country_si, is_country) VALUES (?, ?, ?, ?)',
    ArrayTupleFetch => $FetchMoreCountries,
);

is( $NumMoreInserted, scalar(@MoreCountries), 'insert more countries with ArrayTupleFetch' );

subtest 'SelectAll' => sub {

    my @Tests = (
        {
            Name  => 'all, order by country_en',
            Param => {
                SQL => 'SELECT * FROM test_countries ORDER BY country_en',
            },
            Expected => \@Countries,
        },
        {
            Name  => 'the two last countries',
            Param => {
                SQL   => 'SELECT * FROM test_countries ORDER BY country_en DESC',
                Limit => 2,
            },
            Expected => [ @Countries[ -1, -2 ] ],
        },
        {
            Name  => 'only Sinhala',
            Param => {
                SQL => 'SELECT country_si FROM test_countries ORDER BY country_en',
            },
            Expected => [ map { [ $_->[-2] ] } @Countries ],
        },
        {
            Name  => 'SelectAll with binds',
            Param => {
                SQL  => 'SELECT country_en, is_country FROM test_countries WHERE country_si IN ( ?, ?, ?) ORDER BY country_en DESC',
                Bind => [ \'මලාවි', \'⛄', \'ශ්රී ලංකාව' ],
            },
            Expected => [ [ 'Sri Lanka', 1 ], [ 'Malawi', 1 ] ],
        },
    );

    for my $Test (@Tests) {
        subtest $Test->{Name} => sub {
            my $Matrix = $DBObject->SelectAll( $Test->{Param}->%* );
            is( $Matrix, $Test->{Expected}, 'got expected matrix' );

            my @AnotherRow = $DBObject->FetchrowArray;
            is( \@AnotherRow, [], "no further row" );
        };
    }
};

subtest 'SelectRowArray' => sub {

    my @Tests = (
        {
            Name  => 'all order by country_en, effectively the first row',
            Param => {
                SQL => 'SELECT * FROM test_countries ORDER BY country_en',
            },
            Expected => $Countries[0],
        },
        {
            Name  => 'the two last countries, effectively the last row',
            Param => {
                SQL   => 'SELECT * FROM test_countries ORDER BY country_en DESC',
                Limit => 2,
            },
            Expected => $Countries[-1],
        },
        {
            Name  => 'only Sinhala, effectively Sinhala of the first row',
            Param => {
                SQL => 'SELECT country_si FROM test_countries ORDER BY country_en',
            },
            Expected => [ $Countries[0]->[-2] ],
        },
        {
            Name  => 'SelectRowArray with binds',
            Param => {
                SQL  => 'SELECT country_en, is_country FROM test_countries WHERE country_si IN ( ?, ?, ?) ORDER BY country_en DESC',
                Bind => [ \'මලාවි', \'⛄', \'ශ්රී ලංකාව' ],
            },
            Expected => [ 'Sri Lanka', 1 ],
        },
    );

    for my $Test (@Tests) {
        subtest $Test->{Name} => sub {
            my @Row = $DBObject->SelectRowArray( $Test->{Param}->%* );
            is( \@Row, $Test->{Expected}, 'got expected row' );

            my @AnotherRow = $DBObject->FetchrowArray;
            is( \@AnotherRow, [], "no further row" );
        };
    }
};

subtest 'SelectColArray' => sub {

    my @Tests = (
        {
            Name  => 'the first column of the all countries',
            Param => {
                SQL => 'SELECT * FROM test_countries ORDER BY country_en',
            },
            Expected => [ map { $_->[0] } @Countries ],
        },
        {
            Name  => 'the first column from the last two countries',
            Param => {
                SQL   => 'SELECT * FROM test_countries ORDER BY country_en DESC',
                Limit => 2,
            },
            Expected => [ map { $_->[0] } @Countries[ -1, -2 ] ],
        },
        {
            Name  => 'only the Sinhala column',
            Param => {
                SQL => 'SELECT country_si FROM test_countries ORDER BY country_en',
            },
            Expected => [ map { $_->[-2] } @Countries ],
        },
        {
            Name  => 'only the is_country column',
            Param => {
                SQL => 'SELECT is_country FROM test_countries ORDER BY country_en',
            },
            Expected => [ map { $_->[-1] } @Countries ],
        },
        {
            Name  => 'SelectColArray with binds',
            Param => {
                SQL  => 'SELECT country_en FROM test_countries WHERE country_si IN ( ?, ?, ?) ORDER BY country_en DESC',
                Bind => [ \'මලාවි', \'⛄', \'ශ්රී ලංකාව' ],
            },
            Expected => [ 'Sri Lanka', 'Malawi' ],
        },
    );

    for my $Test (@Tests) {
        subtest $Test->{Name} => sub {
            my @Col = $DBObject->SelectColArray( $Test->{Param}->%* );
            is( \@Col, $Test->{Expected}, 'got expected column' );

            my @AnotherRow = $DBObject->FetchrowArray;
            is( \@AnotherRow, [], "no further row" );
        };
    }
};

subtest 'SelectMapping' => sub {
    my @Tests = (
        {
            Name  => 'English to German for all countries',
            Param => {
                SQL => 'SELECT * FROM test_countries ORDER BY country_en',
            },
            Expected => { map { $_->[0] => $_->[1] } @Countries },
        },
        {
            Name  => 'English to German for last two countries',
            Param => {
                SQL   => 'SELECT * FROM test_countries ORDER BY country_en DESC',
                Limit => 2,
            },
            Expected => { map { $_->[0] => $_->[1] } @Countries[ -1, -2 ] },
        },
        {
            Name  => 'Sinhala to German for all countries',
            Param => {
                SQL => 'SELECT country_si, country_de FROM test_countries ORDER BY country_en',
            },
            Expected => { map { $_->[2] => $_->[1] } @Countries },
        },
        {
            Name  => 'SelectMapping with binds',
            Param => {
                SQL  => 'SELECT country_en, is_country FROM test_countries WHERE country_si IN ( ?, ?, ?) ORDER BY country_en DESC',
                Bind => [ \'මලාවි', \'⛄', \'ශ්රී ලංකාව' ],
            },
            Expected => {
                'Sri Lanka' => 1,
                'Malawi'    => 1
            },
        },
    );

    for my $Test (@Tests) {
        subtest $Test->{Name} => sub {
            my %Mapping = $DBObject->SelectMapping( $Test->{Param}->%* );
            is( \%Mapping, $Test->{Expected}, 'got expected mapping' );

            my @AnotherRow = $DBObject->FetchrowArray;
            is( \@AnotherRow, [], "no further row" );
        };
    }
};

subtest 'Prepare' => sub {
    my @Tests = (
        {
            Name  => 'Prepare without bind variable',
            Param => {
                SQL => 'SELECT country_en, is_country FROM test_countries ORDER BY country_en DESC',
            },
            Expected => [],
        },
        {
            Name  => 'Prepare with a single bind variable',
            Param => {
                SQL  => 'SELECT country_en, is_country FROM test_countries WHERE country_si = ? ORDER BY country_en DESC',
                Bind => [ \'🙈' ]
            },
            Expected => ['🙈'],
        },
        {
            Name  => 'Prepare with three bind variables',
            Param => {
                SQL  => 'SELECT country_en, is_country FROM test_countries WHERE country_si IN (?, ?, ?) ORDER BY country_en DESC',
                Bind => [ \'🙈', \'🙉', \'🙊' ],
            },
            Expected => [ '🙈', '🙉', '🙊' ],
        },
        {
            Name  => 'invalid parameter',
            Param => {
                noSQL => 'SELECT country_en, is_country FROM test_countries WHERE country_si IN (?, ?, ?) ORDER BY country_en DESC',
                Bind  => [ \'🙈', \'🙉', \'🙊' ],
            },
            Expected => undef,
        },
    );

    for my $Test (@Tests) {
        subtest $Test->{Name} => sub {
            my $BindVariables = $DBObject->Prepare( $Test->{Param}->%*, Execute => 0 );
            is( $BindVariables, $Test->{Expected}, 'got expected bind variables' );
        };
    }
};

# cleanup
my $CleanupSuccess = $DBObject->Do(
    SQL => 'DROP TABLE test_countries',
);
ok( $CleanupSuccess, 'test_countries dropped' );

done_testing;
