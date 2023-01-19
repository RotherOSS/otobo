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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars qw( $Self %Param );

# get YAML object
my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

my @Tests = (
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

for my $Test (@Tests) {

    my $YAML = $YAMLObject->Dump(
        Data => $Test->{Input},
    );

    $Self->IsDeeply(
        $YAML,
        $Test->{Result},
        $Test->{Name},
    );
}

@Tests = (
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
);

for my $Test (@Tests) {
    my $Perl = $YAMLObject->Load(
        Data => $Test->{InputLoad},
    );

    $Self->IsDeeply(
        scalar $Perl,
        scalar $Test->{Result},
        $Test->{Name},
    );
}

$Self->DoneTesting();
