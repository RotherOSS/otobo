# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

package scripts::test::ModuleRefresh::Sample;

use v5.24;
use strict;
use warnings;

# a sample method
sub Method {
    my ( $Self, @Params ) = @_;

    return sprintf "%s::Method() called with @Params", __PACKAGE__;
}

# a sample function
sub Function {
    my ( $Self, @Params ) = @_;

    return sprintf "%s::Function() called with @Params", __PACKAGE__;
}

1;
