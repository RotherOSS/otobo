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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM

my $ValidObject = $Kernel::OM->Get('Kernel::System::Valid');

ok(
    !$ValidObject->can('AutoloadTest'),
    'Valid object has no method AutoloadTest by default.',
);

my $StateObject = $Kernel::OM->Get('Kernel::System::State');

my $NonExistentState = 'dummy state for Autoload.t';

is(
    scalar $StateObject->StateLookup( State => $NonExistentState ),
    undef,
    'nonexistent state does not exist'
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'AutoloadPerlPackages###1000-Test',
    Value => ['Kernel::Autoload::Test'],
);

# Recreate config object, which calls the autoload.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Config'] );
$Kernel::OM->Get('Kernel::Config');

ok(
    $ValidObject->can('AutoloadTest'),
    'Valid object now has method AutoloadTest',
);
is(
    $ValidObject->AutoloadTest(),
    1,
    'Autoload correctly added a new function to Kernel::System::Valid',
);

is(
    scalar $StateObject->StateLookup( State => $NonExistentState ),
    'unknown state',
    "nonexistent state now has a default name",
);

done_testing();
