# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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

Kernel::System::UnitTest::RegisterDriver - another helper for unit tests

=head1 SYNOPSIS

    # Set up the test driver $Self when we are running as a standalone script.
    use if __PACKAGE__ ne 'Kernel::System::UnitTest::Driver', 'Kernel::System::UnitTest::RegisterDriver';

=head1 DESCRIPTION

Support for running test scripts as standalone scripts.

=cut

use 5.24.0;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

my $OriginalPID; # see the END block

sub import {

    # remember the id of the process that loaded this module.
    $OriginalPID = $$;

    # RegisterDriver is meant for test scripts,
    # meaning that each sript has it's own process.
    # This means that we don't have to localize $Kernel::OM.
    # This is good, we are in a subroutine that does not eval the test script.
    $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'OTOBO-otobo.UnitTest',
        },
    );

    # The Kernel::System::UnitTest::Driver should particpate in the regular object cleanup
    # The default DataDiffType is used.
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::UnitTest::Driver' => {
            Verbose      => 1,  # always verbose, as TAP consumer can create summaries
            ANSI         => 0,  # no coloring, as TAP consumers can do the presentation
        }
    );
    $main::Self = $Kernel::OM->Get( 'Kernel::System::UnitTest::Driver' );

    $main::Self->{OutputBuffer} = '';

    return;
}

END {
    # Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker, and maybe other modules, is forking processes.
    # But we want no cleanup in the child processes.
    if ( $$ == $OriginalPID ) {
        # trigger Kernel::System::UnitTest::Helper::DESTROY()
        # perform cleanup actions, including some tests, in Kernel::System::UnitTest::Helper::DESTROY
        $Kernel::OM->ObjectsDiscard(
            Objects            => ['Kernel::System::UnitTest::Helper'],
        );

        # print the plan
        my $Driver = $Kernel::OM->Get( 'Kernel::System::UnitTest::Driver' );
        $Driver->DoneTesting();
    }
}

1;
