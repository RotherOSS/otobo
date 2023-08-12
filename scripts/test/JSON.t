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

# get needed objects
my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
isa_ok( $JSONObject, ['Kernel::System::JSON'], 'got a JSON object' );

# Tests for JSON encode method
my @EncodeTests = (
    {
        Input  => undef,
        Result => q{null},
        Name   => 'JSON - undef',
    },
    {
        Input  => [ 1, undef, "3", undef, 5 ],
        Result => q{[1,null,"3",null,5]},
        Name   => 'JSON - array containing two undefs'
    },
    {
        Input  => '',
        Result => '""',
        Name   => 'JSON - empty string',
    },
    {
        Input  => q{"},
        Result => q{"\""},
        Name   => 'JSON - double quote',
    },
    {
        Input  => q{'},
        Result => q{"'"},
        Name   => 'JSON - single quote',
    },
    {
        Input  => 'Some Text',
        Result => '"Some Text"',
        Name   => 'JSON - simple'
    },
    {
        Input  => q{🎋 - U+1F38B - TANABATA TREE},
        Result => q{"🎋 - U+1F38B - TANABATA TREE"},
        Name   => 'JSON - tanabata tree'
    },
    {
        Input  => 42,
        Result => '42',
        Name   => 'JSON - positive integer'
    },
    {
        Input  => -1_000_001,
        Result => '-1000001',
        Name   => 'JSON - negative integer'
    },
    {
        Input  => 0,
        Result => '0',
        Name   => 'JSON - integer zero'
    },
    {
        Input  => -0,
        Result => '0',
        Name   => 'JSON - negative integer zero'
    },
    {
        Input  => 0.000,
        Result => q{0.0},
        Name   => 'JSON - float zero'
    },
    {
        Input  => -0.000,
        Result => q{-0.0},
        Name   => 'JSON - negative float zero'
    },
    {
        Input  => 000 . 000,
        Result => q{"00"},
        Name   => 'JSON - strange octal float zero'
    },
    {
        Input  => -000 . 000,
        Result => q{"00"},
        Name   => 'JSON - negative strange octal float zero'
    },
    {
        Input  => '0',
        Result => '"0"',
        Name   => 'JSON - string zero'
    },
    {
        Input  => '-0',
        Result => '"-0"',
        Name   => 'JSON - string negative zero'
    },
    {
        Input  => [ 1, 2, "3", "Foo", 5 ],
        Result => '[1,2,"3","Foo",5]',
        Name   => 'JSON - simple array'
    },
    {
        Input => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        Result => '{"Key1":"Value1","Key2":42,"Key3":"Another Value"}',
        Name   => 'JSON - simple'
    },
    {
        Input  => $JSONObject->True(),
        Result => 'true',
        Name   => 'JSON - bool true'
    },
    {
        Input  => $JSONObject->False(),
        Result => 'false',
        Name   => 'JSON - bool false'
    },
    {
        Input  => $JSONObject->ToBoolean(),
        Result => 'false',
        Name   => 'ToBoolean() without arg',
    },
    {
        Input  => $JSONObject->ToBoolean(undef),
        Result => 'false',
        Name   => 'ToBoolean() with undef',
    },
    {
        Input  => $JSONObject->ToBoolean('0'),
        Result => 'false',
        Name   => 'ToBoolean() with string q{0}',
    },
    {
        Input  => $JSONObject->ToBoolean(''),
        Result => 'false',
        Name   => 'ToBoolean() with empty string',
    },
    {
        Input  => $JSONObject->ToBoolean(0),
        Result => 'false',
        Name   => 'ToBoolean() with number 0',
    },
    {
        Input  => $JSONObject->ToBoolean(0.0),
        Result => 'false',
        Name   => 'ToBoolean() with number 0.0',
    },
    {
        Input  => $JSONObject->ToBoolean(-0),
        Result => 'false',
        Name   => 'ToBoolean() with number -0',
    },
    {
        Input  => $JSONObject->ToBoolean( 4 < -4 ),
        Result => 'false',
        Name   => 'ToBoolean() with false expression',
    },
    {
        Input  => $JSONObject->ToBoolean( 0 + "0 but true" ),
        Result => 'false',
        Name   => 'ToBoolean() with number q{0 but true}',
    },
    {
        Input  => $JSONObject->ToBoolean(-0.00001),
        Result => 'true',
        Name   => 'ToBoolean() with non-zero number',
    },
    {
        Input  => $JSONObject->ToBoolean('0.0'),
        Result => 'true',
        Name   => 'ToBoolean() with string q{0.0}',
    },
    {
        Input  => $JSONObject->ToBoolean('⛄'),
        Result => 'true',
        Name   => 'ToBoolean() with arbitrary string',
    },
    {
        Input  => $JSONObject->ToBoolean( -4 < 4 ),
        Result => 'true',
        Name   => 'ToBoolean() with true expression',
    },
    {
        Input  => $JSONObject->ToBoolean("0 but true"),
        Result => 'true',
        Name   => 'ToBoolean() with string q{0 but true}',
    },
    {
        Input => [
            [ 1, 2, "Foo", "Bar" ],
            {
                Key1 => 'Something',
                Key2 => [ "Foo", "Bar" ],
                Key3 => {
                    Foo => 'Bar',
                },
                Key4 => {
                    Bar => [ "f", "o", "o" ]
                }
            },
        ],
        Result =>
            '[[1,2,"Foo","Bar"],{"Key1":"Something","Key2":["Foo","Bar"],"Key3":{"Foo":"Bar"},"Key4":{"Bar":["f","o","o"]}}]',
        Name => 'JSON - complex structure'
    },
    {
        Input  => "Some Text with Unicode Characters that  are not allowed\x{2029} in JavaScript",
        Result => '"Some Text with Unicode Characters that\u2028 are not allowed\u2029 in JavaScript"',
        Name   => 'JSON - Unicode Line Terminators are not allowed in JavaScript',
    },
    {
        Input => [
            [ 1, 2, "Foo", "Bar" ],
            {
                Key1 => 'Something',
                Key2 => [ "Foo", "Bar" ],
                Key3 => {
                    Foo => 'Bar',
                },
                Key4 => {
                    Bar => [ "f", "o", "o" ],
                }
            },
        ],
        Params => {
            Pretty => 1,
        },
        Result =>
            '[
   [
      1,
      2,
      "Foo",
      "Bar"
   ],
   {
      "Key1" : "Something",
      "Key2" : [
         "Foo",
         "Bar"
      ],
      "Key3" : {
         "Foo" : "Bar"
      },
      "Key4" : {
         "Bar" : [
            "f",
            "o",
            "o"
         ]
      }
   }
]
',
        Name => 'JSON - complex structure - pretty print'
    },
);

for my $Test (@EncodeTests) {

    my $JSON = $JSONObject->Encode(
        Data     => $Test->{Input},
        SortKeys => 1,
        %{ $Test->{Params} // {} },
    );

    is( $JSON, $Test->{Result}, "encode: $Test->{Name}" );
}

# Tests for JSON decode method
my @DecodeTests = (
    {
        Result      => undef,
        InputDecode => undef,
        Name        => 'JSON - undef test',
    },
    {
        Result      => undef,
        InputDecode => '" bla blubb',
        Name        => 'JSON - malformed data test',
    },
    {
        Result      => 'Some Text',
        InputDecode => '"Some Text"',
        Name        => 'JSON - simple text'
    },
    {
        Result      => 42,
        InputDecode => '42',
        Name        => 'JSON - simple number'
    },
    {
        Result      => [ 1, 2, "3", "Foo", 5 ],
        InputDecode => '[1,2,"3","Foo",5]',
        Name        => 'JSON - array with strings and numbers" '
    },
    {
        Result => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        InputDecode => '{"Key1":"Value1","Key2":42,"Key3":"Another Value"}',
        Name        => 'JSON - simple'
    },
    {
        Result => [
            [ 1, 2, "Foo", "Bar" ],
            {
                Key1 => 'Something',
                Key2 => [ "Foo", "Bar" ],
                Key3 => {
                    Foo => 'Bar',
                },
                Key4 => {
                    Bar => [ "f", "o", "o" ]
                }
            },
        ],
        InputDecode =>
            '[[1,2,"Foo","Bar"],{"Key1":"Something","Key2":["Foo","Bar"],"Key3":{"Foo":"Bar"},"Key4":{"Bar":["f","o","o"]}}]',
        Name => 'JSON - complex structure'
    },
    {
        Result      => 1,
        InputDecode =>
            'true',
        Name => 'JSON - boolean true'
    },
    {
        Result      => undef,
        InputDecode =>
            'false',
        Name => 'JSON - booleans2'
    },
    {
        Result => {
            Key1 => 1,
        },
        InputDecode =>
            '{"Key1" : true}',
        Name => 'JSON - hash containing booleans'
    },
    {
        Result => {
            Key1 => 0,
        },
        InputDecode =>
            '{"Key1" : false}',
        Name => 'JSON - hash containing booleans2'
    },
    {
        Result      => [ 1, 0, "3", "Foo", 1 ],
        InputDecode => '[1,false,"3","Foo",true]',
        Name        => 'JSON - array containing booleans'
    },
    {
        Result => [
            [ 1, 2, "Foo", "Bar" ],
            {
                Key1 => 0,
                Key2 => [ "Foo", "Bar" ],
                Key3 => {
                    Foo => 1,
                },
                Key4 => {
                    Bar => [ 0, "o", 1 ]
                }
            },
        ],
        InputDecode =>
            '[[true,2,"Foo","Bar"],{"Key1":false,"Key2":["Foo","Bar"],"Key3":{"Foo":true},"Key4":{"Bar":[false,"o",true]}}]',
        Name => 'JSON - complex structure containing booleans'
    },
);

for my $Test (@DecodeTests) {

    my $Thingy = $JSONObject->Decode(
        Data => $Test->{InputDecode},
    );

    is( $Thingy, $Test->{Result}, "decode: $Test->{Name}" );
}

done_testing;
