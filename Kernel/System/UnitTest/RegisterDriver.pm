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

Kernel::System::UnitTest::RegisterDriver - setup for test scripts

=head1 SYNOPSIS

    # Set up the test driver $Self and $Kernel::OM in test scripts.
    use Kernel::System::UnitTest::RegisterDriver;

=head1 DESCRIPTION

This script provides support for running test scripts as standalone scripts.
It sets up the variables C<$main::Self> and C<$Kernel::OM>.

=cut

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

sub import {    ## no critic qw(OTOBO::RequireCamelCase)

    # RegisterDriver is meant for test scripts,
    # meaning that each script runs it's own dedicated process.
    # This means that we don't have to localize $Kernel::OM.
    # This is a good thing, as OTOBO no longer has a subroutine that wraps the test script.
    $Kernel::OM = Kernel::System::ObjectManager->new(

        # Log to an identifiable logfile.
        'Kernel::System::Log' => {
            LogPrefix => 'OTOBO-otobo.UnitTest',
        },
    );

    # Provide $Self in the test script.
    # $Self is primarily used for methods like $Self->Is() or $Self->True().
    $main::Self = $Kernel::OM->Get('Kernel::System::UnitTest::Driver');

    return;
}

END {

    # trigger Kernel::System::UnitTest::Helper::DESTROY()
    # perform cleanup actions, including some tests, in Kernel::System::UnitTest::Helper::DESTROY
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::System::UnitTest::Helper'],
    );
}

1;
