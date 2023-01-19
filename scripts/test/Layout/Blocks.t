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

use vars (qw($Self));

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (

    # test 1
    {
        Input => '
[% RenderBlockStart("ConfigElementBlock") -%]
<b>test</b>
[% RenderBlockEnd("ConfigElementBlock") -%]',
        Result => '
<b>test</b>
',
        Block => [
            {
                Name => 'ConfigElementBlock',
                Data => {},
            },
        ],
        Name => 'Output() - test 1',
    },

    # test 2
    {
        Input => '
[% RenderBlockStart("ConfigElementBlock") -%]
<b>[% Data.Name | html %]</b>
[% RenderBlockEnd("ConfigElementBlock") -%]',
        Result => '
<b>test123</b>
<b>test1234</b>
',
        Block => [
            {
                Name => 'ConfigElementBlock',
                Data => { Name => 'test123' },
            },
            {
                Name => 'ConfigElementBlock',
                Data => { Name => 'test1234' },
            },
        ],
        Name => 'Output() - test 2',
    },

    # test 3
    {
        Input => '
[% RenderBlockStart("Block1") -%]
<b>[% Data.Name | html %]</b>
[% RenderBlockStart("Block11") -%]
    <b>[% Data.Name | html %]</b>
[% RenderBlockEnd("Block11") -%]
[% RenderBlockEnd("Block1") -%]
[% RenderBlockStart("Block2") -%]
<b>[% Data.Name | html %]</b>
[% RenderBlockEnd("Block2") -%]
',
        Result => '
<b>Block1_1</b>
    <b>Block11_1</b>
    <b>Block11_2</b>
<b>Block1_2</b>
<b>Block2_1</b>
',
        Block => [
            {
                Name => 'Block1',
                Data => { Name => 'Block1_1' },
            },
            {
                Name => 'Block11',
                Data => { Name => 'Block11_1' },
            },
            {
                Name => 'Block11',
                Data => { Name => 'Block11_2' },
            },
            {
                Name => 'Block1',
                Data => { Name => 'Block1_2' },
            },
            {
                Name => 'Block2',
                Data => { Name => 'Block2_1' },
            },
        ],
        Name => 'Output() - test 3',
    },

    # test 4
    {
        Input => '
[% RenderBlockStart("ConfigElementBlock1") -%]
<b>[% Data.Name1 | html %]</b>
[% RenderBlockStart("ConfigElementBlock2") -%]
<b>[% Data.Name2 | html %]</b>
[% RenderBlockEnd("ConfigElementBlock2") -%]
[% RenderBlockEnd("ConfigElementBlock1") -%]',

        Result => '
<b>test123</b>
<b>test1234</b>
',
        Block => [
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'test123' },
            },
            {
                Name => 'ConfigElementBlock2',
                Data => { Name2 => 'test1234' },
            },
        ],
        Name => 'Output() - test 4',
    },

    # test 5
    {
        Input => '
[% RenderBlockStart("ConfigElementBlock1") -%]
<b>[% Data.Name1 | html %]</b>
[% RenderBlockStart("ConfigElementBlock1A") -%]
<b>[% Data.Name1A | html %]</b>
[% RenderBlockEnd("ConfigElementBlock1A") -%]
[% RenderBlockEnd("ConfigElementBlock1") -%]
[% RenderBlockStart("ConfigElementBlock2") -%]
<b>[% Data.Name2 | html %]</b>
[% RenderBlockEnd("ConfigElementBlock2") -%]',

        Result => '
<b>AAA</b>
<b>BBB1</b>
<b>BBB2</b>
<b>XXX</b>
<b>YYY</b>
<b>CCC</b>
',
        Block => [
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'AAA' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB1' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB2' },
            },
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'XXX' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'YYY' },
            },
            {
                Name => 'ConfigElementBlock2',
                Data => { Name2 => 'CCC' },
            },
        ],
        Name => 'Output() - test 5',
    },

    # test 6
    {
        Input => '
[% RenderBlockStart("ConfigElementBlock2") -%]
<b>[% Data.Name2 | html %]</b>
[% RenderBlockEnd("ConfigElementBlock2") -%]
[% RenderBlockStart("ConfigElementBlock1") -%]
<b>[% Data.Name1 | html %]</b>
[% RenderBlockStart("ConfigElementBlock1A") -%]
<b>[% Data.Name1A | html %]</b>
[% RenderBlockEnd("ConfigElementBlock1A") -%]
[% RenderBlockEnd("ConfigElementBlock1") -%]',

        Result => '
<b>CCC</b>
<b>AAA</b>
<b>BBB1</b>
<b>BBB2</b>
<b>XXX</b>
<b>YYY</b>
',
        Block => [
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'AAA' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB1' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'BBB2' },
            },
            {
                Name => 'ConfigElementBlock1',
                Data => { Name1 => 'XXX' },
            },
            {
                Name => 'ConfigElementBlock1A',
                Data => { Name1A => 'YYY' },
            },
            {
                Name => 'ConfigElementBlock2',
                Data => { Name2 => 'CCC' },
            },
        ],
        Name => 'Output() - test 6',
    },

);

for my $Test (@Tests) {
    for my $Block ( @{ $Test->{Block} } ) {
        $LayoutObject->Block( %{$Block} );
    }
    my $Output = $LayoutObject->Output(
        Template => $Test->{Input},
        Data     => {},
    );
    $Self->Is(
        $Output,
        $Test->{Result},
        $Test->{Name},
    );
}

$Self->DoneTesting();
