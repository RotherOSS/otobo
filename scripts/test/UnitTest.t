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
use Test2::API qw(intercept);

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Driver ();

# Testing Kernel::System::UnitTest::Driver.
# See https://metacpan.org/pod/Test2::Manual::Tooling::Testing.
my $UnitTestObject = Kernel::System::UnitTest::Driver->new;

note('Testing True() and False()');

my @TestTrueFalse = (
    {
        Name   => 'true value (1)',
        Value  => 1,
        Result => 1,
    },
    {
        Name   => 'true value (" ")',
        Value  => " ",
        Result => 1,
    },
    {
        Name   => 'false value (0)',
        Value  => 0,
        Result => 0,
    },
    {
        Name   => 'false value ("")',
        Value  => '',
        Result => 0,
    },
    {
        Name   => 'false value (undef)',
        Value  => undef,
        Result => 0,
    },
);

for my $Test (@TestTrueFalse) {
    my $Events = intercept {
        $UnitTestObject->True( $Test->{Value}, $Test->{Name} );
        $UnitTestObject->False( $Test->{Value}, $Test->{Name} );
    };

    if ( $Test->{Result} ) {
        isa_ok( $Events->[0], ['Test2::Event::Pass'], "True() - $Test->{Name}" );
        isa_ok( $Events->[1], ['Test2::Event::Fail'], "False() - $Test->{Name}" );
    }
    else {
        isa_ok( $Events->[0], ['Test2::Event::Fail'], "True() - $Test->{Name}" );
        isa_ok( $Events->[1], ['Test2::Event::Pass'], "False() - $Test->{Name}" );
    }
}

note('Testing Is() and IsNot()');

my @TestIsIsNot = (
    {
        Name   => 'Is (1:1)',
        ValueX => 1,
        ValueY => 1,
        Result => 'Is',
    },
    {
        Name   => 'Is (a:a)',
        ValueX => 'a',
        ValueY => 'a',
        Result => 'Is',
    },
    {
        Name   => 'Is (undef:undef)',
        ValueX => undef,
        ValueY => undef,
        Result => 'Is',
    },
    {
        Name   => 'Is (0:0)',
        ValueX => 0,
        ValueY => 0,
        Result => 'Is',
    },
    {
        Name   => 'IsNot (1:0)',
        ValueX => 1,
        ValueY => 0,
        Result => 'IsNot',
    },
    {
        Name   => 'Is (a:b)',
        ValueX => 'a',
        ValueY => 'b',
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (1:undef)',
        ValueX => 1,
        ValueY => undef,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (undef:1)',
        ValueX => undef,
        ValueY => 1,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (0:undef)',
        ValueX => 0,
        ValueY => undef,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (undef:0)',
        ValueX => undef,
        ValueY => 0,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot ("":undef)',
        ValueX => '',
        ValueY => undef,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (undef:"")',
        ValueX => undef,
        ValueY => '',
        Result => 'IsNot',
    },
);

for my $Test (@TestIsIsNot) {
    my $Events = intercept {
        $UnitTestObject->Is( $Test->{ValueX}, $Test->{ValueY}, $Test->{Name} );
        $UnitTestObject->IsNot( $Test->{ValueX}, $Test->{ValueY}, $Test->{Name} );
    };

    if ( $Test->{Result} eq 'Is' ) {
        isa_ok( $Events->[0], ['Test2::Event::Pass'], "Is() - $Test->{Name}" );
        isa_ok( $Events->[1], ['Test2::Event::Fail'], "IsNot() - $Test->{Name}" );
    }
    else {
        isa_ok( $Events->[0], ['Test2::Event::Fail'], "Is() - $Test->{Name}" );
        isa_ok( $Events->[1], ['Test2::Event::Pass'], "IsNot() - $Test->{Name}" );
    }
}

note('Testing IsDeeply() and IsNotDeeply()');

{
    my %Hash1 = (
        key1 => '1',
        key2 => '2',
        key3 => {
            test  => 2,
            test2 => [
                1, 2, 3,
            ],
        },
        key4 => undef,
    );

    my %Hash2 = %Hash1;
    $Hash2{AdditionalKey} = 1;

    # This is a case that was encountered when converting
    # scripts/test/DynamicField/ObjectType/Article/ObjectDataGet.t to Test2::V0
    my %Hash3 = %Hash1;
    $Hash3{AdditionalKeyWithUndefinedValue} = undef;

    my @List1 = ( 1, 2, 3, );
    my @List2 = (
        1,
        2,
        4,
        [ 1, 2, 3 ],
        {
            test => 'test',
        },
    );

    my $Scalar1 = 1;
    my $Scalar2 = {
        test => [ 1, 2, 3 ],
    };

    # loop over the cross product of the values
    my @Values = ( \%Hash1, \%Hash2, \%Hash3, \@List1, \@List2, \$Scalar1, \$Scalar2 );
    my $Count1 = 0;
    for my $Value1 (@Values) {

        $Count1++;

        # compare each data structures with each other data structure
        my $Count2 = 0;
        for my $Value2 (@Values) {
            $Count2++;

            my $Events = intercept {
                $UnitTestObject->IsDeeply( $Value1, $Value2, "IsDeeply $Count1:$Count2" );
                $UnitTestObject->IsNotDeeply( $Value1, $Value2, "IsNotDeeply $Count1:$Count2" );
            };

            if ( $Value2 == $Value1 ) {
                isa_ok( $Events->[0], ['Test2::Event::Pass'], "IsDeeply - same $Count1:$Count2" );
                isa_ok( $Events->[1], ['Test2::Event::Fail'], "IsNotDeeply - same $Count1:$Count2" );
            }
            else {
                isa_ok( $Events->[0], ['Test2::Event::Fail'], "IsDeeply() - not same $Count1:$Count2" );
                isa_ok( $Events->[1], ['Test2::Event::Pass'], "IsNotDeeply - not same $Count1:$Count2" );
            }
        }
    }
}

done_testing;
