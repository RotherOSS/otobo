# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::UnitTest::RegisterDriver;

=head1 NAME

Kernel::System::UnitTest::RegisterDriver - set up C<$Kernel::OM> and C<$main::Self> in test scripts

=head1 SYNOPSIS

    # Set up the test driver $main::Self and $Kernel::OM in test scripts.
    use Kernel::System::UnitTest::RegisterDriver;

=head1 DESCRIPTION

This script provides support for running test scripts as standalone scripts.
It sets up the variables C<$main::Self> and C<$Kernel::OM>.
Setting up C<$Kernel::OM> is done implicitly by loading C<Kernel::System::UnitTest::RegisterOM>.

=cut

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

our $ObjectManagerDisabled = 1;

sub import {    ## no critic qw(OTOBO::RequireCamelCase)

    # Provide $main::Self in the test script.
    # $Self is primarily used for methods like $Self->Is() or $Self->True().
    $main::Self = $Kernel::OM->Get('Kernel::System::UnitTest::Driver');

    return;
}

1;
