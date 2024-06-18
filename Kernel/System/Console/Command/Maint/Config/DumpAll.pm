# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::Console::Command::Maint::Config::DumpAll;

use v5.24;
use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::JSON',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Dump all configuration settings in JSON format.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Cpanel::JSON::XS does not accept blessed references per default. So let's unbless
    # the config object before dumping it. This should work because usually there are no
    # other blessed references deep in the data structure.
    my $UnblessedConfig = { $Kernel::OM->Get('Kernel::Config')->%* };
    print $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data     => $UnblessedConfig,
        SortKeys => 1,
        Pretty   => 1,
    );

    return $Self->ExitCodeOk();
}

1;
