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

package Kernel::System::ModuleRefresh;

use v5.24;
use strict;
use warnings;
use utf8;

use parent qw(Module::Refresh);

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::ModuleRefresh - refresh OTOBO Perl modules in long running processes

=head1 DESCRIPTION

This module is used for reloading modules. Use cases are changed modules in F<Kernel/Config/Files> and modules
changed by OTOBO package installation. Only modules in the namespace C<Kernel> and C<var::packagesetup> are meant to be refreshed.

This module inherits from L<Module::Refresh> and thus provides the same interface. One difference is the
method C<mtime> which provides the keys for the cache C<Module::Refresh::CACHE>. The overridden method only
gives back the modified time and the size of the relevant file. The original method also included the inode.
Using the inode of the module file caused frequent reloads on some systems that were the file system was located
on SSDs.

Another difference is that in the method C<new()> only modules in C<Kernel> and C<var::packagesetup> are cached.

=head1 DISCLAIMERS

The method C<refresh()> should not be used as it still works on the complete C<%INC>.

Using C<Kernel::System::ModuleRefresh> and C<Module::Refresh> in the same program is discouraged.

=head1 OVERRIDDEN METHODS

=head2 new()

Cache the modules in C<%INC> that are in the namespace C<Kernel>.

=cut

sub new {
    my ($Class) = @_;

    for my $Module ( grep {m[^(?:Kernel|var/packagesetup)/]} keys %INC ) {
        $Class->update_cache($Module);
    }

    return $Class;
}

=head2 mtime()

Generate a cache key based on the modified time and the file size.

=cut

sub mtime {
    my ( $Class, $Module ) = @_;

    return join ':', ( stat $Module )[ 7, 9 ];    # size and mtime
}

1;
