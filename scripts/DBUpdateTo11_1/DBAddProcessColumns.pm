# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package scripts::DBUpdateTo11_1::DBAddProcessColumns;

use v5.26;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules

# CPAN modules
use List::Util qw(any);

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_1::DBAddProcessColumns - Add columns for namespace and process entity id to process element tables.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # one statement per column, so that an already existing column does not abort the update
    my @XMLStrings;

    for my $ElementTableName (qw(pm_activity pm_activity_dialog pm_transition pm_transition_action)) {

        # new column with the associated foreign key
        push @XMLStrings, <<~"END_XML";
            <TableAlter Name="$ElementTableName">
                <ColumnAdd Name="namespace" Type="VARCHAR" Size="80" />
                <ColumnAdd Name="process_entity_id" Type="VARCHAR" Size="50" />
                <ForeignKeyCreate ForeignTable="pm_process">
                    <Reference Local="process_entity_id" Foreign="entity_id"/>
                </ForeignKeyCreate>
            </TableAlter>
        END_XML
    }

    return unless $Self->ExecuteXMLDBArray( XMLArray => \@XMLStrings );
    return 1;
}

1;
