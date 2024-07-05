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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

my @Tests = (
    {
        Size   => 'abc',
        Result => undef,
    },
    {
        Result => undef,
    },
    {
        Size   => 0,
        Result => '0 B',
    },
    {
        Size   => 13,
        Result => '13 B',
    },
    {
        Size   => 1024,
        Result => '1 KB',
    },
    {
        Size   => 2500,
        Result => '2.4 KB',
    },
    {
        Size     => 2500,
        Result   => '2,4 KB',
        Language => 'sr_Latn',
    },
    {
        Size     => 2500,
        Result   => "\N{U+200E}2.4 كيلوبايت (KB)",
        Language => 'ar_SA',
    },
    {
        Size   => 46137344,
        Result => '44 MB',
    },
    {
        Size   => 58626123,
        Result => '55.9 MB',
    },
    {
        Size     => 58626123,
        Result   => '55,9 MB',
        Language => 'sr_Latn',
    },
    {
        Size     => 58626123,
        Result   => "\N{U+200E}55.9 ميغابايت (MB)",
        Language => 'ar_SA',
    },
    {
        Size   => 34359738368,
        Result => '32 GB',
    },
    {
        Size   => 64508675518,
        Result => '60.1 GB',
    },
    {
        Size     => 64508675518,
        Result   => '60,1 GB',
        Language => 'sr_Latn',
    },
    {
        Size     => 64508675518,
        Result   => "\N{U+200E}60.1 غيغابايت (GB)",
        Language => 'ar_SA',
    },
    {
        Size   => 238594023227392,
        Result => '217 TB',
    },
    {
        Size   => 498870572100000,
        Result => '453.7 TB',
    },
    {
        Size     => 498870572100000,
        Result   => '453,7 TB',
        Language => 'sr_Latn',
    },
    {
        Size     => 498870572100000,
        Result   => "\N{U+200E}453.7 تيرابايت (TB)",
        Language => 'ar_SA',
    },
);

for my $Test (@Tests) {

    # set default values for the test cases
    $Test->{Language} //= 'en';
    $Test->{Size}     //= 'undef';

    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::Output::HTML::Layout',
            'Kernel::Language',
        ],
    );
    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            Lang => $Test->{Language},
        },
    );

    my $Result = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->HumanReadableDataSize(
        Size => $Test->{Size},
    );

    is(
        $Result,
        $Test->{Result},
        "HumanReadableDataSize: Size => $Test->{Size}, Lang => $Test->{Language}",
    );
}

done_testing;
