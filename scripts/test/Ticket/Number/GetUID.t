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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# Use AutoIncrement backend to have access to the base class functions.
my $TicketNumberBaseObject = $Kernel::OM->Get('Kernel::System::Ticket::Number::AutoIncrement');

# _GetUID tests
my %UIDs;
for my $Count ( 1 .. 10_000 ) {
    my $UID = $TicketNumberBaseObject->_GetUID();

    if ( $UIDs{$UID} ) {
        $Self->Is(
            $UIDs{$UID},
            undef,
            "_GetUID() $Count - $UID does not exist",
        );
    }
    $UIDs{$UID}++;
}
$Self->Is(
    scalar keys %UIDs,
    10_000,
    "_GetUID() generated all UIDs."
);

$Self->DoneTesting();
