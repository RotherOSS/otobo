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

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get needed objects
my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
isa_ok( $JSONObject, ['Kernel::System::JSON'], 'got a JSON object' );

# Tests for JSON encode method
my $Twelve      = 12;
my @EncodeTests = (
    {
        Input  => undef,
        Result => q{null},
        Name   => 'undef',
    },
    {
        Input  => [ 1, undef, "3", undef, 5 ],
        Result => q{[1,null,"3",null,5]},
        Name   => 'array containing two undefs'
    },
    {
        Input  => '',
        Result => '""',
        Name   => 'empty string',
    },
    {
        Input  => q{"},
        Result => q{"\""},
        Name   => 'double quote',
    },
    {
        Input  => q{'},
        Result => q{"'"},
        Name   => 'single quote',
    },
    {
        Input  => 'Some Text',
        Result => '"Some Text"',
        Name   => 'simple'
    },
    {
        Input  => q{🎋 - U+1F38B - TANABATA TREE},
        Result => q{"🎋 - U+1F38B - TANABATA TREE"},
        Name   => 'tanabata tree'
    },
    {
        Input  => 42,
        Result => '42',
        Name   => 'positive integer'
    },
    {
        Input  => $Twelve,
        Result => '12',
        Name   => 'positive integer from the variable $Twelve'
    },
    {
        Input  => -1_000_001,
        Result => '-1000001',
        Name   => 'negative integer'
    },
    {
        Input  => 0,
        Result => '0',
        Name   => 'integer zero'
    },

    # stringification and numification
    {
        Input  => 288 . "",
        Result => '"288"',
        Name   => 'stringified by concatenating an empty string'
    },
    {
        Input  => "$Twelve",
        Result => '"12"',
        Name   => 'stringified by putting in double quotes'
    },
    {
        Input  => "$Twelve" + 0,
        Result => '12',
        Name   => '"$Twelve" numified by adding zero, IV internally',
    },
    {
        Input  => "$Twelve asdf" + 0,
        Result => '12.0',
        Name   => '"$Twelve asdf" numified by adding zero, NV internally',
    },
    {
        Input  => "asdf" + 6,
        Result => '6.0',
        Name   => 'non-numeral string plus six, NV internally',
    },
    {
        Input  => "-2_000" + 6,
        Result => '4.0',
        Name   => 'negative non-numeral string plus six, NV internally',
    },
    {
        Input  => "-2000" + 6,
        Result => '-1994',
        Name   => 'negative numeral string plus six, IV internally',
    },
    {
        Input  => "$Twelve" * 1,
        Result => '12',
        Name   => '"$Twelve" numified by multiplying by 1, IV internally',
    },
    {
        Input  => "$Twelve asdf" * 1,
        Result => '12.0',
        Name   => '"$Twelve asdf" numified by multiplying by 1, NV internally',
    },

    # TypeAllString
    # These tests were meant for Cpanel::JSON::XS
    #    {
    #        Input  => -12,
    #        Result => '"-12"',
    #        Name   => 'TypeAllString with -12',
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input  => 12,
    #        Result => '"12"',
    #        Name   => 'TypeAllString with 12',
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input  => +12,
    #        Result => '"12"',
    #        Name   => 'TypeAllString with +12',
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input  => 0,
    #        Result => '"0"',
    #        Name   => 'TypeAllString with number zero',
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input  => "0",
    #        Result => '"0"',
    #        Name   => 'TypeAllString with string containing the digit zero',
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input  => "Çe pa un niméro",
    #        Result => '"Çe pa un niméro"',
    #        Name   => 'TypeAllString with Kouri-Vini',
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input => {
    #            AAA => "Çe pa un niméro",
    #            BBB => 0,
    #            CCC => "0",
    #            DDD => -12,
    #            EEE => "-12",
    #            FFF => [ "Çe pa un niméro", 0, "0", -12, "-12" ],
    #        },
    #        Result => <<'END_JSON',
    #{
    #   "AAA" : "Çe pa un niméro",
    #   "BBB" : "0",
    #   "CCC" : "0",
    #   "DDD" : "-12",
    #   "EEE" : "-12",
    #   "FFF" : [
    #      "Çe pa un niméro",
    #      "0",
    #      "0",
    #      "-12",
    #      "-12"
    #   ]
    #}
    #END_JSON
    #        Name   => 'TypeAllString with nested data',
    #        Params => {
    #            Pretty        => 1,
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input  => $JSONObject->True(),
    #        Result => '"true"',
    #        Name   => q{TypeAllString bool true, don't do this in production},
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },
    #    {
    #        Input  => $JSONObject->False(),
    #        Result => '"false"',
    #        Name   => q{TypeAllString bool false, don't do this in production},
    #        Params => {
    #            TypeAllString => 1,
    #        },
    #    },

    # more about zero
    {
        Input  => -0,
        Result => '0',
        Name   => 'negative integer zero'
    },
    {
        Input  => 0.000,
        Result => q{0.0},        # NV is preserved
        Name   => 'float zero'
    },
    {
        Input  => -0.000,
        Result => q{-0.0},                # NV is preserved
        Name   => 'negative float zero'
    },
    {
        Input  => 000 . 000,
        Result => q{"00"},
        Name   => 'strange octal float zero'
    },
    {
        Input  => -000 . 000,
        Result => q{"00"},
        Name   => 'negative strange octal float zero'
    },
    {
        Input  => '0',
        Result => '"0"',
        Name   => 'string zero'
    },
    {
        Input  => '-0',
        Result => '"-0"',
        Name   => 'string negative zero'
    },

    # more data structures
    {
        Input  => [ 1, 2, "3", "Foo", 5 ],
        Result => '[1,2,"3","Foo",5]',
        Name   => 'simple array'
    },
    {
        Input => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        Result => '{"Key1":"Value1","Key2":42,"Key3":"Another Value"}',
        Name   => 'simple'
    },

    # Booleans
    {
        Input  => $JSONObject->True(),
        Result => 'true',
        Name   => 'bool true'
    },
    {
        Input  => $JSONObject->False(),
        Result => 'false',
        Name   => 'bool false'
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

    # still more data structures
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
        Name => 'complex structure'
    },
    {
        Input  => "Some Text with Unicode Characters that  are not allowed\x{2029} in JavaScript",
        Result => '"Some Text with Unicode Characters that\u2028 are not allowed\u2029 in JavaScript"',
        Name   => 'Unicode Line Terminators are not allowed in JavaScript',
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
        Name => 'complex structure - pretty print'
    },
);

for my $Test (@EncodeTests) {

    my $JSON = $JSONObject->Encode(
        Data     => $Test->{Input},
        SortKeys => 1,
        %{ $Test->{Params} // {} },
    );

    is( $JSON, $Test->{Result}, "JSON Encode: $Test->{Name}" );
}

# Tests for JSON decode method
my @DecodeTests = (
    {
        Result      => undef,
        InputDecode => undef,
        Name        => 'undef test',
    },
    {
        Result      => undef,
        InputDecode => '" bla blubb',
        Name        => 'malformed data test',
    },
    {
        Result      => 'Some Text',
        InputDecode => '"Some Text"',
        Name        => 'simple text'
    },
    {
        Result      => 42,
        InputDecode => '42',
        Name        => 'simple number'
    },
    {
        Result      => [ 1, 2, "3", "Foo", 5 ],
        InputDecode => '[1,2,"3","Foo",5]',
        Name        => 'array with strings and numbers" '
    },
    {
        Result => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        InputDecode => '{"Key1":"Value1","Key2":42,"Key3":"Another Value"}',
        Name        => 'simple hash'
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
        Name => 'complex structure'
    },
    {
        Result       => 1,
        VerifyScalar => 1,
        InputDecode  => 'true',
        Name         => 'boolean true'
    },
    {
        Result       => 0,
        VerifyScalar => 1,
        InputDecode  => 'false',
        Name         => 'boolean false'
    },
    {
        Result      => undef,
        InputDecode => 'null',
        Name        => 'null'
    },
    {
        Result      => [ undef, undef, undef ],
        InputDecode => '[null, null, null]',
        Name        => 'array with three undefined values'
    },
    {
        Result => {
            Key1 => 1,
        },
        InputDecode => '{"Key1" : true}',
        Name        => 'hash containing booleans'
    },
    {
        Result => {
            Key1 => 0,
        },
        InputDecode => '{"Key1" : false}',
        Name        => 'hash containing booleans2'
    },
    {
        Result      => [ 1, 0, "3", "Foo", 1 ],
        InputDecode => '[1,false,"3","Foo",true]',
        Name        => 'array containing booleans'
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
        Name => 'complex structure containing booleans'
    },
);

for my $Test (@DecodeTests) {

    my $Thingy = $JSONObject->Decode(
        Data => $Test->{InputDecode},
    );
    is( $Thingy, $Test->{Result}, "Decode: $Test->{Name}" );

    # double check because 'is()' does not complain about instances JSON::PP::Boolean
    if ( $Test->{VerifyScalar} ) {
        is( ref $Thingy, '', "Decode: $Test->{Name}, result is not a reference" );
    }
}

# Testing IsBool()
subtest 'IsBool() for non-Booleans' => sub {
    is( $JSONObject->IsBool(),      undef, 'no argument' );
    is( $JSONObject->IsBool(undef), undef, 'explicit undef' );
    is( $JSONObject->IsBool(''),    undef, 'empty string' );
    is( $JSONObject->IsBool(1),     undef, 'integer 1' );
    is( $JSONObject->IsBool(2),     undef, 'integer 2' );

    # not sure why these return an empty string instead of undef
    is( $JSONObject->IsBool('true'),                 '', 'string "true"' );
    is( $JSONObject->IsBool('⊨ - U+022A8 - TRUE'), '', 'a string' );
};

subtest 'IsBool() for Booleans' => sub {
    is( $JSONObject->IsBool( $JSONObject->True ),             1, 'true' );
    is( $JSONObject->IsBool( $JSONObject->False ),            1, 'false' );
    is( $JSONObject->IsBool( $JSONObject->ToBoolean(undef) ), 1, 'unded boolified' );
    is( $JSONObject->IsBool( $JSONObject->ToBoolean(0) ),     1, '0 boolified' );
    is( $JSONObject->IsBool( $JSONObject->ToBoolean(1) ),     1, '1 boolified' );
    is( $JSONObject->IsBool( $JSONObject->ToBoolean(' ') ),   1, 'single space boolified' );
};

subtest '_BooleansProcess' => sub {
    is(
        $JSONObject->_BooleansProcess( JSON => $JSONObject->True ),
        1,
        'true'
    );
    is(
        $JSONObject->_BooleansProcess( JSON => $JSONObject->False ),
        0,
        'false'
    );
    is(
        $JSONObject->_BooleansProcess( JSON => [ 'blubber', '🍏', 0, 1, $JSONObject->False, $JSONObject->True ] ),
        [ 'blubber', '🍏', 0, 1, 0, 1 ],
        'arrayref'
    );
    is(
        $JSONObject->_BooleansProcess(
            JSON => {
                'Ⓐ ' => 'blubber',
                'Ⓑ'  => '🍏',
                'Ⓒ'  => 0,
                'Ⓓ'  => 1,
                'Ⓔ'  => $JSONObject->False,
                'Ⓕ'  => $JSONObject->True
            }
        ),
        {
            'Ⓐ ' => 'blubber',
            'Ⓑ'  => '🍏',
            'Ⓒ'  => 0,
            'Ⓓ'  => 1,
            'Ⓔ'  => 0,
            'Ⓕ'  => 1
        },
        'hashref'
    );
    is(
        $JSONObject->_BooleansProcess(
            JSON =>
                [
                    'A',
                    [ 'B', { 'C' => [ [ 'blubber', '🍏', 0, 1, $JSONObject->False, $JSONObject->True ] ] } ],
                    {
                        'D' => {
                            'E' => {
                                'Ⓐ' => 'blubber',
                                'Ⓑ' => '🍏',
                                'Ⓒ' => 0,
                                'Ⓓ' => 1,
                                'Ⓔ' => $JSONObject->False,
                                'Ⓕ' => $JSONObject->True
                            }
                        }
                    },
                ]
        ),
        [
            'A',
            [ 'B', { 'C' => [ [ 'blubber', '🍏', 0, 1, 0, 1 ] ] } ],
            {
                'D' => {
                    'E' => {
                        'Ⓐ' => 'blubber',
                        'Ⓑ' => '🍏',
                        'Ⓒ' => 0,
                        'Ⓓ' => 1,
                        'Ⓔ' => 0,
                        'Ⓕ' => 1
                    }
                }
            },
        ],
        'nested'
    );
};

done_testing;
