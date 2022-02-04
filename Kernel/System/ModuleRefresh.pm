# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::ModuleRefresh;

use strict;
use warnings;

use parent qw(Module::Refresh);

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::ModuleRefresh - refreshing Perl modules in long running processes

=head1 DESCRIPTION

This module is used for reloading modules. Use cases are changed modules in F<Kernel/Config/Files> and modules
changed by OTOBO package installation.

This module inherits from L<Module::Refresh> and provided the same interface. The only difference is the
method C<mtime> which provided the keys for the cache C<Module::Refresh::CACHE>. The overridden method only
gives back the modified time and the size of the relevant file. The original method also included the inode.

Using the inode of the module file caused frequent reloads on some systems that were the file system was located
on SSDs.

=head1 OVERRIDDEN METHODS

=head2 mtime()

Generate a cache key based on the modified time and the file size.

=cut

sub mtime {
    my ( $Class, $Module ) = @_;

    return join ':', ( stat $Module )[ 7, 9 ];    # size and mtime
}

1;
