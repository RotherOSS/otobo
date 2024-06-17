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

# Tests for validating DateTime object values
my @TestConfigs = (
    {
        Params => {
            Year     => 2016,
            Month    => '01',
            Day      => 22,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2016,
            Month    => '02',
            Day      => 29,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2016,
            Month    => '02',
            Day      => 30,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2015,
            Month    => '02',
            Day      => 29,
            Hour     => '01',
            Minute   => '01',
            Second   => '01',
            TimeZone => 'Europe/Berlin',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => '00',
            Minute   => '00',
            Second   => '00',
            TimeZone => 'UTC',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => '00',
            Minute   => '00',
            Second   => '00',
            TimeZone => 'NoValidTimeZone',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 24,
            Minute   => '00',
            Second   => '00',
            TimeZone => 'UTC',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 14,
            Minute   => 60,
            Second   => '00',
            TimeZone => 'UTC',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 60,
            TimeZone => 'UTC',
        },
        SuccessExpected => 0,
    },
    {
        Params => {
            Year     => 2016,
            Month    => 12,
            Day      => 29,
            Hour     => 14,
            Minute   => 59,
            Second   => 59,
            TimeZone => 'UTC',
        },
        SuccessExpected => 1,
    },
    {
        Params => {
            Year     => 'invalid',
            Month    => 12,
            Day      => 'invalid',
            Hour     => 14,
            Minute   => 590,
            Second   => 59,
            TimeZone => 'invalid',
        },
        SuccessExpected => 0,
    },
);

TESTCONFIG:
for my $TestConfig (@TestConfigs) {

    my $Params = $TestConfig->{Params};

    my $DateTimeObject      = $Kernel::OM->Create('Kernel::System::DateTime');
    my $DateTimeValuesValid = $DateTimeObject->Validate( %{$Params} );

    $Self->Is(
        $DateTimeValuesValid ? 1 : 0,
        $TestConfig->{SuccessExpected},
        "'$Params->{Year}-$Params->{Month}-$Params->{Day} $Params->{Hour}:$Params->{Minute}:$Params->{Second} $Params->{TimeZone}' must be validated as "
            . ( $TestConfig->{SuccessExpected} ? 'valid' : 'invalid ' ) . '.',
    );
}

# Tests for failing calls to Validate() due to missing or unsupported parameters
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
@TestConfigs = (
    {
        Name   => 'without parameters',
        Params => {},
    },
    {
        Name   => 'with invalid year',
        Params => {
            Year => 'invalid',
        },
    },
    {
        Name   => 'with valid year and invalid month',
        Params => {
            Year  => 2016,
            Month => 'invalid',
        },
    },
    {
        Name   => 'with unsupported parameter',
        Params => {
            UnsupportedParameter => 2,
        },
    },
    {
        Name   => 'with unsupported parameter and valid year',
        Params => {
            UnsupportedParameter => 2,
            Year                 => 2016,
        },
    },
);

for my $TestConfig (@TestConfigs) {
    my $DateTimeObjectClone = $DateTimeObject->Clone();
    my $Result              = $DateTimeObjectClone->Validate( %{ $TestConfig->{Params} } );
    $Self->False(
        $Result,
        "Validate() $TestConfig->{Name} must fail.",
    );

    $Self->IsDeeply(
        $DateTimeObjectClone->Get(),
        $DateTimeObject->Get(),
        'DateTime object must be unchanged after failed Validate().',
    );
}

$Self->DoneTesting();
