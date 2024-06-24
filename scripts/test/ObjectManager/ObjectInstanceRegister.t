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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM
use Kernel::System::ObjectManager ();
use Kernel::System::Valid         ();

our $Self;

$Self->Is(
    $Kernel::OM->Get('Kernel::System::UnitTest::Driver'),
    $Self,
    "Global OM returns $Self as 'Kernel::System::UnitTest::Driver'",
);

local $Kernel::OM = Kernel::System::ObjectManager->new();

$Self->True( $Kernel::OM, 'Could build object manager' );

$Self->False(
    exists $Kernel::OM->{Objects}->{'Kernel::System::Valid'},
    'Kernel::System::Valid was not loaded yet',
);

my $ValidObject = Kernel::System::Valid->new();

$Self->True(
    $Kernel::OM->ObjectInstanceRegister(
        Package      => 'Kernel::System::Valid',
        Object       => $ValidObject,
        Dependencies => [],
    ),
    'Registered ValidObject',
);

$Self->Is(
    $Kernel::OM->Get('Kernel::System::Valid'),
    $ValidObject,
    "OM returns the original ValidObject",
);

$Kernel::OM->ObjectsDiscard();

$Self->True(
    $ValidObject,
    "ValidObject is still alive after ObjectsDiscard()",
);

$Self->IsNot(
    $Kernel::OM->Get('Kernel::System::Valid'),
    $ValidObject,
    "OM returns its own ValidObject",
);

$Self->DoneTesting();
