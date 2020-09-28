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

use v5.24;
use warnings;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

sub import {

    # RegisterDriver is meant for test scripts,
    # meaning that each sript has it's own process.
    # This means that we don't have to localize $Kernel::OM.
    # This is good, we are in a subroutine that does not eval the test script.
    $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'OTOBO-otobo.UnitTest',
        },
    );

    # provide $Self in the test scripts
    $main::Self = $Kernel::OM->Get( 'Kernel::System::UnitTest::Driver' );

    return;
}

# NOTE: it is not obvious whether this is still needed
{
    # remember the id of the process that loaded this module.
    my $OriginalPID = $$;

    END {
        # Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker, and maybe other modules, is forking processes.
        # But we want no cleanup in the child processes.
        if ( $$ == $OriginalPID ) {
            # trigger Kernel::System::UnitTest::Helper::DESTROY()
            # perform cleanup actions, including some tests, in Kernel::System::UnitTest::Helper::DESTROY
            $Kernel::OM->ObjectsDiscard(
                Objects            => ['Kernel::System::UnitTest::Helper'],
            );
        }
    }
}

1;
