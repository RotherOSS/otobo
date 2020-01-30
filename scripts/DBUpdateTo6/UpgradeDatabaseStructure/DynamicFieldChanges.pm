# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::DynamicFieldChanges;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = ();

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::DynamicFieldChanges - Adds a table for dyanmic field object names and creation of an index

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (
        '<Table Name="dynamic_field_obj_id_name">
            <Column Name="object_id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
            <Column Name="object_name" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="object_type" Required="true" Size="100" Type="VARCHAR"/>
            <Unique Name="dynamic_field_object_name">
                <UniqueColumn Name="object_name"/>
                <UniqueColumn Name="object_type"/>
            </Unique>
        </Table>',

        '<TableAlter Name="dynamic_field_value">
            <IndexCreate Name="dynamic_field_value_search_text">
                <IndexColumn Name="field_id"/>
                <IndexColumn Name="value_text" Size="150"/>
            </IndexCreate>
        </TableAlter>',

        '<TableAlter Name="dynamic_field">
            <ColumnChange NameOld="object_type" NameNew="object_type" Required="true" Type="VARCHAR" Size="100"/>
        </TableAlter>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
