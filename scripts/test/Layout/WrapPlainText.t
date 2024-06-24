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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# get layout object
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

my @Tests = (
    {
        Name          => 'WrapPlainText() - #1 Check if already cleanly wrapped text is not changed.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        => "123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
",
        Result => "123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
",
        Type => 'Is',
    },
    {
        Name =>
            'WrapPlainText() - #2 Check if newline is added at EOL if a string does not end with it.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        =>
            "123456789_123456789_123456789_ 123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_",
        Result => "123456789_123456789_123456789_ 123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_
",
        Type => 'Is',
    },
    {
        Name          => 'WrapPlainText() - #3 Check if cited text does not get wrapped',
        Type          => 'Is',
        MaxCharacters => 80,
        String        =>
            "> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_",
        Result =>
            "> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
> 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
",
    },
    {
        Name =>
            'WrapPlainText() - #4 Check if regular text containing spaces gets wrapped after 80 chars.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        =>
            "123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_",
        Result => "123456789_123456789_123456789_123456789_
123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_
",
    },
    {
        Name =>
            'WrapPlainText() - #5 Check if a line that is longer than 80 chars containing no spaces does not get wrapped.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        =>
            "_123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_123456789_ 123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_ _123456789_123456789_123456789_",
        Result => "_123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_123456789_
123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_123456789_
_123456789_123456789_123456789_
",
    },
    {
        Name          => 'WrapPlainText() - #6 Check if undef does not get modified.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        => undef,
        Result        => undef,
    },
    {
        Name          => 'WrapPlainText() - #7 Check if empty strings do not get modified.',
        Type          => 'Is',
        MaxCharacters => 80,
        String        => '',
        Result        => '',
    },
    {
        Name          => 'WrapPlainText() - #8 Check if missing MaxCharacters raise an exception.',
        Type          => 'False',
        MaxCharacters => undef,
        String        => "123456789_123456789_123456789_ 123456789_123456789_",
    },
    {
        Name =>
            'WrapPlainText() - #9 Check if a submitting non-string variables raise an exception.',
        Type          => 'False',
        MaxCharacters => 80,
        String        => [ '12345', '12345', '12345', ]
    },
    {
        Name          => 'WrapPlainText() - #10 bug#110778 check that no additional newlines are produced.',
        Type          => 'Is',
        MaxCharacters => 78,
        String        =>
            "
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\r
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\r
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\r
",
        Result => "
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
",
    },
);

for my $Test (@Tests) {
    my $Result = $LayoutObject->WrapPlainText(
        PlainText     => $Test->{String},
        MaxCharacters => $Test->{MaxCharacters},
    );
    if ( $Test->{Type} eq 'Is' ) {
        $Self->Is(
            $Result,
            $Test->{Result},
            $Test->{Name},
        );
    }
    elsif ( $Test->{Type} eq 'False' ) {
        $Self->False(
            $Result,
            $Test->{Name},
        );
    }
}

$Self->DoneTesting();
