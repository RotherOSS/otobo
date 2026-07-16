# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# get needed objects
my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

my @Tests = (
    {
        Line        => __LINE__,
        Description => 'default validator active, valid value',
        Value       => 11,
        Key         => 'TicketID',
        Expected    => { Success => 1 },
    },
    {
        Line        => __LINE__,
        Description => 'default validator active, invalid value',
        Value       => -11,
        Key         => 'TicketID',
        Expected    => { Success => 0 },
    },
    {
        Line        => __LINE__,
        Description => 'default validator disabled',
        Value       => -11,
        Key         => 'TicketID',
        Validator   => 'anything',
        Expected    => { Success => 1 },
    },
);

for my $Test (@Tests) {
    my $Desc      = ( $Test->{Description} // 'no description' ) . " (Key=$Test->{Key}, Line=$Test->{Line})";
    my $Validator = $Test->{Validator} // $CheckItemObject->GetDefaultValidator( Key => $Test->{Key} )->{Check};

    my $Result = $CheckItemObject->Validate(
        Key       => $Test->{Key},
        Value     => $Test->{Value},
        Validator => $Validator,
    );
    like( $Result, $Test->{Expected}, $Desc );
}

done_testing;
