# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $TestPackage = 'scripts::test::Main::Test';
my $TestPM      = 'scripts/test/Main/Test.pm';

ok( !exists $INC{$TestPM}, "$TestPackage not in %INC yet" );

is(
    $MainObject->Require($TestPackage),
    1,
    "$TestPackage loaded via Require()",
);

ok( $INC{$TestPM}, "$TestPackage is in %INC after Require()" );

is(
    scalar scripts::test::Main::Test::Test(),
    1,
    'Function Test() can be called in loaded package',
);

my %OldINC = %INC;

is(
    $MainObject->Require($TestPackage),
    1,
    "$TestPackage loaded via Require()",
);

is(
    \%INC,
    \%OldINC,
    '%INC hash unchanged by second load',
);

is(
    scalar $MainObject->Require( "${TestPackage}::Invalid", Silent => 1 ),
    undef,
    "${TestPackage}::Invalid cannot be loaded",
);

is(
    \%INC,
    \%OldINC,
    '%INC hash unchanged by invalid load',
);

done_testing;
