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
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Tests = (
    {
        Age                     => 20 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '20 m',
        CustomerAgeLong         => '20 minute(s)',
        CustomerAgeInHoursShort => '20 m',
        CustomerAgeInHoursLong  => '20 minute(s)',
        Name                    => "20 minutes",
    },
    {
        Age                     => 60 * 60 + 60,
        Space                   => ' ',
        CustomerAgeShort        => '1 h 1 m',
        CustomerAgeLong         => '1 hour(s) 1 minute(s)',
        CustomerAgeInHoursShort => '1 h 1 m',
        CustomerAgeInHoursLong  => '1 hour(s) 1 minute(s)',
        Name                    => "1 hour 1 minute",
    },
    {
        Age                     => 2 * 60 * 60 + 2 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '2 h 2 m',
        CustomerAgeLong         => '2 hour(s) 2 minute(s)',
        CustomerAgeInHoursShort => '2 h 2 m',
        CustomerAgeInHoursLong  => '2 hour(s) 2 minute(s)',
        Name                    => "2 hours 2 minutes",
    },
    {
        Age                     => 3 * 24 * 60 * 60 + 3 * 60 * 60 + 3 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '3 d 3 h ',
        CustomerAgeLong         => '3 day(s) 3 hour(s) ',
        CustomerAgeInHoursShort => '75 h 3 m',
        CustomerAgeInHoursLong  => '75 hour(s) 3 minute(s)',
        Name                    => "3 days 3 hours",
    },
    {
        Age                     => 3 * 24 * 60 * 60 + 3 * 60 * 60 + 3 * 60,
        Space                   => ' ',
        CustomerAgeShort        => '3 d 3 h 3 m',
        CustomerAgeLong         => '3 day(s) 3 hour(s) 3 minute(s)',
        TimeShowAlwaysLong      => 1,
        CustomerAgeInHoursShort => '75 h 3 m',
        CustomerAgeInHoursLong  => '75 hour(s) 3 minute(s)',
        Name                    => "3 days 3 hours with AlwaysLong",
    },
);

for my $Test (@Tests) {
    $ConfigObject->Set(
        Key   => 'TimeShowCompleteDescription',
        Value => 0,
    );
    $ConfigObject->Set(
        Key   => 'TimeShowAlwaysLong',
        Value => $Test->{TimeShowAlwaysLong} // 0,
    );
    $Self->Is(
        $LayoutObject->CustomerAge(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeShort},
        "$Test->{Name} - CustomerAge - short",
    );
    $Self->Is(
        $LayoutObject->CustomerAgeInHours(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeInHoursShort},
        "$Test->{Name} - CustomerAgeInHours - short",
    );
    $ConfigObject->Set(
        Key   => 'TimeShowCompleteDescription',
        Value => 1,
    );
    $Self->Is(
        $LayoutObject->CustomerAge(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeLong},
        "$Test->{Name} - long",
    );
    $Self->Is(
        $LayoutObject->CustomerAgeInHours(
            Age   => $Test->{Age},
            Space => $Test->{Space},
        ),
        $Test->{CustomerAgeInHoursLong},
        "$Test->{Name} - CustomerAgeInHours - short",
    );
}

$Self->DoneTesting();
