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

#
# Tests for comparing DateTime objects via operators
#
my @TestConfigs = (
    {
        DateTime1 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        DateTime2 => {
            String   => '2018-02-14 14:54:10',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResults => {
            '>'  => 0,
            '<'  => 1,
            '>=' => 0,
            '<=' => 1,
            '==' => 0,
            '!=' => 1,
        },
    },
    {
        DateTime1 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        DateTime2 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResults => {
            '>'  => 0,
            '<'  => 0,
            '>=' => 1,
            '<=' => 1,
            '==' => 1,
            '!=' => 0,
        },
    },
    {
        DateTime1 => {
            String   => '2018-02-14 14:54:10',
            TimeZone => 'Europe/Berlin',
        },
        DateTime2 => {
            String   => '2016-02-18 14:59:00',
            TimeZone => 'Europe/Berlin',
        },
        ExpectedResults => {
            '>'  => 1,
            '<'  => 0,
            '>=' => 1,
            '<=' => 0,
            '==' => 0,
            '!=' => 1,
        },
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $DateTimeObject1 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{DateTime1},
    );
    my $DateTimeObject2 = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{DateTime2},
    );

    for my $Operator ( sort keys %{ $TestConfig->{ExpectedResults} } ) {
        $Self->Is(
            eval( '$DateTimeObject1 ' . $Operator . ' $DateTimeObject2' ),    ## no critic qw(BuiltinFunctions::ProhibitStringyEval)
            $TestConfig->{ExpectedResults}->{$Operator},
            $DateTimeObject1->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
                . " $Operator "
                . $DateTimeObject2->Format( Format => '%Y-%m-%d %H:%M:%S %{time_zone_long_name}' )
                . ' must have expected result.',
        );
    }
}

#
# Test with invalid DateTime object
#
my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2016-04-06 13:46:00',
    },
);

for my $Operator ( '>', '<', '>=', '<=', '==', '!=' ) {

    $Self->False(
        eval( '$DateTimeObject ' . $Operator . ' 2' ),    ## no critic qw(BuiltinFunctions::ProhibitStringyEval)
        'Comparison via ' . $Operator . ' with integer instead of DateTime object must fail',
    );

    $Self->False(
        eval( '$DateTimeObject ' . $Operator . ' undef' ),    ## no critic qw(BuiltinFunctions::ProhibitStringyEval)
        'Comparison via ' . $Operator . ' with undef instead of DateTime object must fail',
    );

    $Self->False(
        eval( '$DateTimeObject ' . $Operator . ' $Kernel::OM->Create("Kernel::System::Calendar")' ),    ## no critic qw(BuiltinFunctions::ProhibitStringyEval)
        'Comparison via ' . $Operator . ' with Calendar object instead of DateTime object must fail',
    );
}

$Self->DoneTesting();
