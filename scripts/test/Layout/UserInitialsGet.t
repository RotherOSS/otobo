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

use vars (qw($Self));

my @Tests = (
    {
        Name   => 'Empty request',
        Config => {},
        Result => 'O',
    },
    {
        Name   => 'Invalid name',
        Config => {
            Fullname => '~!@#$%^ &*()_+=',    # non-word characters only
        },
        Result => 'O',
    },
    {
        Name   => 'Generic - John Doe',
        Config => {
            Fullname => 'John Doe',
        },
        Result => 'JD',
    },
    {
        Name   => 'Capitalization - jOhN dOe',
        Config => {
            Fullname => 'John Doe',
        },
        Result => 'JD',
    },
    {
        Name   => 'Mixed - "John Doe"',
        Config => {
            Fullname => '"John Doe"',
        },
        Result => 'JD',
    },
    {
        Name   => 'With email - "John Doe" <jdoe@example.com>',
        Config => {
            Fullname => '"John Doe" <jdoe@example.com>',
        },
        Result => 'JD',
    },
    {
        Name   => 'With something in brackets - John Doe (jdoe)',
        Config => {
            Fullname => 'John Doe (jdoe)',
        },
        Result => 'JD',
    },
    {
        Name   => 'Only one name - Joe',
        Config => {
            Fullname => 'Joe',
        },
        Result => 'J',
    },
    {
        Name   => 'Cyrillic - Петар Петровић',
        Config => {
            Fullname => 'Петар Петровић',
        },
        Result => 'ПП',
    },
    {
        Name   => 'Chinese - 约翰·多伊',
        Config => {
            Fullname => '约翰·多伊',
        },
        Result => '约',
    },
);

my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

for my $Test (@Tests) {
    my $Result = $LayoutObject->UserInitialsGet(
        %{ $Test->{Config} },
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - Result"
    );
}

$Self->DoneTesting();
