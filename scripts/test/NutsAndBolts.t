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

use 5.24.0;
use warnings;
use utf8;

=head1 NAME

NutsAndBolts.t - the most basic test script

=head1 SYNOPSIS

    # a test script that emits TAP

=head1 DESCRIPTION

Essentially just for checking whether the environment is sane.
Especially for checking whether C<Dev::UnitTest::Run> handles test scripts as expected.

=SEE ALSO

L<Test::Tutorial>

=cut

say '1..1';
say 1 + 1 == 2 ? 'ok 1' : 'not ok 1';
