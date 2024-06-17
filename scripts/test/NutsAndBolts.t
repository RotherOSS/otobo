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

=head1 NAME

NutsAndBolts.t - the most basic test script

=head1 SYNOPSIS

    # a test script that emits TAP without using Kernel::System::UnitTest::Driver
    prove --verbose scripts/test/NutsAndBolts.t

=head1 DESCRIPTION

Essentially just for checking whether the installation is sane.
Especially for checking whether C<Dev::UnitTest::Run> ignores test scripts that
do not use the L<Kernel::System::UnitTest> framework.

When the environment variable SKIP_NUTSANDBOLTS_TEST is set, then all test cases in the file
are skipped. This behavior is used in F<scripts/test/UnitTest/Blacklist.t>

=SEE ALSO

L<Test::Tutorial>

=cut

use strict;
use warnings;
use v5.24;
use utf8;

if ( $ENV{SKIP_NUTSANDBOLTS_TEST} ) {
    say 'NutsAndBolts.t: skip all tests as SKIP_NUTSANDBOLTS_TEST is set';

    exit 0;
}

# just a dummy test that succeeds
say '1..1';
say 'ok 1 - easy success in NutsAndBolts.t';
