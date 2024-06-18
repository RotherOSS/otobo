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

package Kernel::System::UnitTest::RegisterOM;

=head1 NAME

Kernel::System::UnitTest::RegisterOM - set up C<$Kernel::OM> in test scripts

=head1 SYNOPSIS

    # Set up $Kernel::OM in test scripts.
    use Kernel::System::UnitTest::RegisterOM;

=head1 DESCRIPTION

This script provides support for running test scripts as standalone scripts.
It sets up the variable C<$Kernel::OM>.

Load this module in test scripts when the test driver C<$main::Self> is not needed.
When you need C<$main::Self> too, then you only need to load C<Kernel::System::UnitTest::RegisterDriver>
which loads this module implicitly.

Running a script, which loads this module, never emits the warning
"Name "Kernel::OM" used only once: possible typo". Even if the script has C<$Kernel::OM> only once.
This is because C<$Kernel::OM> is mentioned in this module. Also,  modules loaded by
C<Kernel::System::ObjectManager> mention C<$Kernel::OM>.

=cut

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager ();

our $ObjectManagerDisabled = 1;

sub import {    ## no critic qw(OTOBO::RequireCamelCase)

    # Kernel::System::UnitTest::RegisterOM is meant for test scripts,
    # meaning that each script runs it's own dedicated process.
    # This means that we don't have to localize $Kernel::OM.
    $Kernel::OM = Kernel::System::ObjectManager->new(

        # Log to an identifiable logfile.
        'Kernel::System::Log' => {
            LogPrefix => 'OTOBO-otobo.UnitTest',
        },
    );

    return;
}

1;
