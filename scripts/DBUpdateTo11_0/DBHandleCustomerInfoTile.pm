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

package scripts::DBUpdateTo11_0::DBHandleCustomerInfoTile;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_0::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::CustomerDashboard::InfoTile',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBHandleCustomerInfoTile - create default tile entry if none is present on the system

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $CustomerInfoTileObject = $Kernel::OM->Get('Kernel::System::CustomerDashboard::InfoTile');

    my $Exists = $CustomerInfoTileObject->InfoTileListGet();

    if ( IsHashRefWithData($Exists) ) {
        return 1;
    }

    my $Success = $CustomerInfoTileObject->InfoTileAdd(
        UserID  => 1,
        Name    => 'DefaultTile',
        Content =>
            '<h1>Richtext Infokachel</h1><p>Diese Infokachel unterstützt Richtext und wird direkt über die Admin-Oberfläche konfiguriert.<br>Unterschiedliche Bereiche können eigene Abschnitte innerhalb der Kachel pflegen.<br>Außerdem gibt es ein zusätzliches Laufband für aktuelle Meldungen, das im gesamten Kundenbereich angezeigt wird.</p>',

    );

    return 1;
}

1;
