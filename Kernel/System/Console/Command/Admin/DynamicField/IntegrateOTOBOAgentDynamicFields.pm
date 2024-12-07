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

package Kernel::System::Console::Command::Admin::DynamicField::IntegrateOTOBOAgentDynamicFields;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Console::BaseCommand);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

# Inform the object manager about the hard dependencies.
# This module must be discarded when one of the hard dependencies has been discarded.
our @ObjectDependencies = (
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        "Integrate OTOBOAGents Dynamic Fields. \n" .
            "Migrates custom OTOBOAgents Dynamic Fields to rel-11_x standard Agent Reference fields. \n"
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require('scripts::DBUpdateTo11_0::DBUpdateOTOBOAgentsDF') ) {

        return $Self->ExitCodeError();
    }

    my $Success = $Kernel::OM->Create('scripts::DBUpdateTo11_0::DBUpdateOTOBOAgentsDF')->Run;

    if ( !$Success ) {
        return $Self->ExitCodeError();
    }

    return $Self->ExitCodeOk();
}

1;
