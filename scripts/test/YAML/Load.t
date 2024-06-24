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

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get YAML object
my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

my @DumpTests = (
    {
        Input  => undef,
        Result => undef,
        Name   => 'YAML - undef test',
    },
    {
        Input  => '',
        Result => "--- ''\n",
        Name   => 'YAML - empty test',
    },
    {
        Input  => 'Some Text',
        Result => "--- Some Text\n",
        Name   => 'YAML - simple',
    },
    {
        Input  => 42,
        Result => "--- 42\n",
        Name   => 'YAML - simple',
    },
    {
        Input  => [ 1, 2, "3", "Foo", 5 ],
        Result => "---\n- 1\n- 2\n- '3'\n- Foo\n- 5\n",
        Name   => 'YAML - simple',
    },
    {
        Input => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        Result => "---\nKey1: Value1\nKey2: 42\nKey3: Another Value\n",
        Name   => 'YAML - simple',
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
            "---\n"
            . "- - 1\n"
            . "  - 2\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "- Key1: Something\n"
            . "  Key2:\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "  Key3:\n"
            . "    Foo: Bar\n"
            . "  Key4:\n"
            . "    Bar:\n"
            . "    - f\n"
            . "    - o\n"
            . "    - o\n",
        Name => 'YAM - complex structure',
    },
);

for my $Test (@DumpTests) {

    my $YAML = $YAMLObject->Dump(
        Data => $Test->{Input},
    );

    is(
        $YAML,
        $Test->{Result},
        $Test->{Name},
    );
}

my @LoadTests = (
    {
        Result    => undef,
        InputLoad => undef,
        Name      => 'YAML - undef test',
    },
    {
        Result    => undef,
        InputLoad => "--- Key: malformed\n - 1\n",
        Name      => 'YAML - malformed data test',
    },
    {
        Result    => 'Some Text',
        InputLoad => "--- Some Text\n",
        Name      => 'YAML - simple'
    },
    {
        Result    => 42,
        InputLoad => "--- 42\n",
        Name      => 'YAML - simple'
    },
    {
        Result    => [ 1, 2, "3", "Foo", 5 ],
        InputLoad => "---\n- 1\n- 2\n- '3'\n- Foo\n- 5\n",
        Name      => 'YAML - simple'
    },
    {
        Result => {
            Key1   => "Value1",
            Key2   => 42,
            "Key3" => "Another Value"
        },
        InputLoad => "---\nKey1: Value1\nKey2: 42\nKey3: Another Value\n",
        Name      => 'YAML - simple'
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
        InputLoad =>
            "---\n"
            . "- - 1\n"
            . "  - 2\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "- Key1: Something\n"
            . "  Key2:\n"
            . "  - Foo\n"
            . "  - Bar\n"
            . "  Key3:\n"
            . "    Foo: Bar\n"
            . "  Key4:\n"
            . "    Bar:\n"
            . "    - f\n"
            . "    - o\n"
            . "    - o\n",
        Name => 'YAML - complex structure'
    },
    {
        InputLoad => <<'END_YAML',
Description:
- Content: Defines the default front-end language. All the possible values are determined
    by the available language files on the system (see the next setting).
  Translatable: '1'
Name: DefaultLanguage
Navigation:
- Content: Frontend::Base
Required: '1'
Valid: '1'
Value:
- Item:
  - Content: en
    ValueRegex: ^(..|.._..)$
    ValueType: String
END_YAML
        Result => {
            Description => [
                {
                    Content =>
                        "Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).",
                    Translatable => 1,
                },
            ],
            Name       => "DefaultLanguage",
            Navigation => [ { Content => "Frontend::Base" } ],
            Required   => 1,
            Valid      => 1,
            Value      => [
                {
                    Item => [
                        {
                            Content    => "en",
                            ValueRegex => "^(..|.._..)\$",
                            ValueType  => "String"
                        },
                    ],
                },
            ],
        },
        Name => 'sample from sysconfig_default.xml_content_parsed'
    },
    {
        Result => {
            foo => 1,
            bar => 2
        },
        InputLoad => "--- Document 1 containing Text\n--- { foo: 1, bar: 2 }",
        Name      => 'YAML - two documents, last document is returned'
    },
);

for my $Test (@LoadTests) {
    my $Perl = $YAMLObject->Load(
        Data => $Test->{InputLoad},
    );

    is(
        $Perl,
        $Test->{Result},
        $Test->{Name},
    );
}

done_testing;
