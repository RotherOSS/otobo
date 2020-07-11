# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

# This test script does not work with Kernel::System::UnitTest::Driver.
# __SKIP_BY_KERNEL_SYSTEM_UNITTEST_DRIVER__

=head1 NAME

NutsAndBolts.t - the most basic test script

=head1 SYNOPSIS

    # a test script that emits TAP without using Kernel::System::UnitTest::Driver

=head1 DESCRIPTION

Essentially just for checking whether the environment is sane.
Especially for checking whether C<Dev::UnitTest::Run> ignores test scripts that
do not use the L<Kernel::System::UnitTest> framework.

=SEE ALSO

L<Test::Tutorial>

=cut

use v5.24;
use warnings;
use utf8;

# just a dummy test that succeeds
say '1..1';
say 'ok 1 - success';
