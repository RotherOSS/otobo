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
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $TestPackage = 'scripts::test::Main::Test';
my $TestPM      = 'scripts/test/Main/Test.pm';

$Self->False(
    scalar $INC{$TestPM},
    "$TestPackage not in %INC yet",
);

$Self->Is(
    $MainObject->Require($TestPackage),
    1,
    "$TestPackage loaded via Require()",
);

$Self->True(
    scalar $INC{$TestPM},
    "$TestPackage in %INC",
);

$Self->Is(
    scalar scripts::test::Main::Test::Test(),
    1,
    "Function can be called in loaded package",
);

my %OldINC = %INC;

$Self->Is(
    $MainObject->Require($TestPackage),
    1,
    "$TestPackage loaded via Require()",
);

$Self->IsDeeply(
    \%INC,
    \%OldINC,
    '%INC hash unchanged by second load',
);

$Self->Is(
    scalar $MainObject->Require( "${TestPackage}::Invalid", Silent => 1 ),
    scalar undef,
    "${TestPackage}::Invalid cannot be loaded",
);

$Self->IsDeeply(
    \%INC,
    \%OldINC,
    '%INC hash unchanged by invalid load',
);

$Self->DoneTesting();
