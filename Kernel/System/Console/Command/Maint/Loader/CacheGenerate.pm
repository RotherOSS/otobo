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

package Kernel::System::Console::Command::Maint::Loader::CacheGenerate;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Loader',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate the CSS/JS loader cache.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Generating loader cache files...</yellow>\n");

    # Force loader also on development systems where it might be turned off.
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Loader::Enabled::JS',
        Value => 1,
    );
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Loader::Enabled::CSS',
        Value => 1,
    );
    my @FrontendModules = $Kernel::OM->Get('Kernel::System::Loader')->CacheGenerate();
    if ( !@FrontendModules ) {
        $Self->PrintError("Loader cache files could not be generated.");
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
