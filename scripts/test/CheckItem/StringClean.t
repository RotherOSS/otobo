# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
use Encode();

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Email::Address::XS ();

# get needed objects
my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

# string clean tests
my $IdeographicSpace  = chr(0x3000);         # 　- U+03000 - E3 80 80 - IDEOGRAPHIC SPACE, covered by the \s character class
my @StringCleainTests = (
    {
        Line   => __LINE__,
        String => ' ',
        Params => {},
        Result => '',
    },
    {
        Line   => __LINE__,
        String => undef,
        Params => {},
        Result => undef,
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {},
        Result => "Test\n\r\t test\n\r\t Test",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 1,
            TrimRight => 0,
        },
        Result => "Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 0,
            TrimRight => 1,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft  => 0,
            TrimRight => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "Test\t test\t Test",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 0,
        },
        Result => "Test\n\r test\n\r Test",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 1,
            TrimRight         => 1,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 1,
        },
        Result => "Test\n\r\ttest\n\r\tTest",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 0,
        },
        Result => "\t Test\t test\t Test\t ",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 0,
        },
        Result => "\n\r Test\n\r test\n\r Test\n\r ",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 0,
            RemoveAllTabs     => 0,
            RemoveAllSpaces   => 1,
        },
        Result => "\n\r\tTest\n\r\ttest\n\r\tTest\n\r\t",
    },
    {
        Line   => __LINE__,
        String => "\n\r\t Test\n\r\t test\n\r\t Test\n\r\t ",
        Params => {
            TrimLeft          => 0,
            TrimRight         => 0,
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        },
        Result => "TesttestTest",
    },

    # strip invalid utf8 characters
    {
        Line   => __LINE__,
        String => 'aäöüß€z',
        Params => {},
        Result => 'aäöüß€z',
    },
    {
        Line   => __LINE__,
        String => eval { my $String = "a\372z"; Encode::_utf8_on($String); $String },    # iso-8859 string
        Params => {},
        Result => undef,
    },
    {
        Line   => __LINE__,
        String => eval {'aúz'},                                                          # utf-8 string
        Params => {},
        Result => 'aúz',
    },

    # Tests with non-latin1 white space
    {
        Line   => __LINE__,
        String => "$IdeographicSpace IdeographicSpace $IdeographicSpace",
        Params => {
            TrimLeft  => 0,
            TrimRight => 0,
        },
        Result => "$IdeographicSpace IdeographicSpace $IdeographicSpace",
    },
    {
        Line   => __LINE__,
        String => "$IdeographicSpace IdeographicSpace $IdeographicSpace",
        Params => {
            TrimLeft  => 1,
            TrimRight => 0,
        },
        Result => "IdeographicSpace $IdeographicSpace",
    },
    {
        Line   => __LINE__,
        String => "$IdeographicSpace IdeographicSpace $IdeographicSpace",
        Params => {
            TrimLeft  => 0,
            TrimRight => 1,
        },
        Result => "$IdeographicSpace IdeographicSpace",
    },
    {
        Line   => __LINE__,
        String => "$IdeographicSpace Ideographic $IdeographicSpace Space $IdeographicSpace",
        Params => {
            TrimLeft        => 0,
            TrimRight       => 0,
            RemoveAllSpaces => 1,
        },
        Result => "${IdeographicSpace}Ideographic${IdeographicSpace}Space${IdeographicSpace}",
    },

);

for my $Test (@StringCleainTests) {

    # copy string to leave the original untouched
    my $String = $Test->{String};

    # start string preparation
    my $StringRef = $CheckItemObject->StringClean(
        StringRef => \$String,
        %{ $Test->{Params} },
    );

    # check result
    is(
        ${$StringRef},
        $Test->{Result},
        "StringClean - line $Test->{Line}",
    );
}

done_testing;
