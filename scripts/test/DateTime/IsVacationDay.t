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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

#
# Vacation day tests
#

# Remove certain vacation days from calendar 2
my $TimeVacationDays2 = $ConfigObject->Get('TimeVacationDays::Calendar2');
$TimeVacationDays2->{1}->{1} = undef;

my $TimeVacationDaysOneTime2 = $ConfigObject->Get('TimeVacationDaysOneTime::Calendar2');
$TimeVacationDaysOneTime2->{2004}->{1}->{1} = undef;

my @TestConfigs = (
    {
        Params => {
            Year  => 2005,
            Month => 1,
            Day   => 1,
        },
        ExpectedResult => 'New Year\'s Day',
    },
    {
        Params => {
            Year  => 2005,
            Month => '01',
            Day   => '01',
        },
        ExpectedResult => 'New Year\'s Day',
    },
    {
        Params => {
            Year  => 2005,
            Month => 12,
            Day   => 31,
        },
        ExpectedResult => 'New Year\'s Eve',
    },
    {
        Params => {
            Year  => 2005,
            Month => 2,
            Day   => 14,
        },
        ExpectedResult => 0,
    },
    {
        Params => {
            Year     => 2005,
            Month    => 1,
            Day      => 1,
            Calendar => 1,
        },
        ExpectedResult => 'New Year\'s Day',
    },
    {
        Params => {
            Year     => 2005,
            Month    => 1,
            Day      => 1,
            Calendar => 2,
        },
        ExpectedResult => 0,
    },
    {
        Params => {
            Year     => 2004,
            Month    => 1,
            Day      => 1,
            Calendar => 2,
        },
        ExpectedResult => 0,
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => $TestConfig->{Params},
    );

    my $CalendarStr = $TestConfig->{Params}->{Calendar} ? " Calendar: $TestConfig->{Params}->{Calendar}" : '';
    my $TestName    = "$TestConfig->{Params}->{Year}-$TestConfig->{Params}->{Month}-$TestConfig->{Params}->{Day}" . $CalendarStr;

    $Self->Is(
        $DateTimeObject->IsVacationDay(
            Calendar => $TestConfig->{Params}->{Calendar},
        ),
        $TestConfig->{ExpectedResult},
        "$TestName - Vacation day must match expected one.",
    );
}

$Self->DoneTesting();
