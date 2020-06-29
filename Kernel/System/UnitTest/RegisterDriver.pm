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

use 5.24.0;
use warnings;

use parent 'Exporter';
our @EXPORT = qw($Self);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

sub import {
    # RegisterDriver is meant for test scripts,
    # meaning that each sript has it's own process.
    # This means that we don't have to localize $Kernel::OM
    $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'OTOBO-otobo.UnitTest',
        },
    );

    $Kernel::System::UnitTest::RegisterDriver::Self = $Kernel::OM->Create(
        'Kernel::System::UnitTest::Driver',
        ObjectParams => {
            Verbose      => 10000000000000,
            ANSI         => 0,
        },
    );

    # Provide $Self as 'Kernel::System::UnitTest' for convenience.
    $Kernel::OM->ObjectInstanceRegister(
        Package      => 'Kernel::System::UnitTest::Driver',
        Object       => $Kernel::System::UnitTest::RegisterDriver::Self,
        Dependencies => [],
    );

    $Kernel::System::UnitTest::RegisterDriver::Self->{OutputBuffer} = '';

    # Exports $Self to the callers namespace.
    # @_ is usually empty.
    Kernel::System::UnitTest::RegisterDriver->export_to_level(1, @_);
}

1;
