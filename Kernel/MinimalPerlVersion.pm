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

package Kernel::MinimalPerlVersion;

use v5.26;    # requiring Perl 5.26 is the intent of this module
use warnings;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::MinimalPerlVersion - declare the minimal version of Perl for OTOBO

=head1 DESCRIPTION

This module only requires a minimal version of Perl for OTOBO.

=cut

1;
