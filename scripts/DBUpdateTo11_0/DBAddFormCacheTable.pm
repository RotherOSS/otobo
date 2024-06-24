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

package scripts::DBUpdateTo11_0::DBAddFormCacheTable;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBAddFormCacheTable

=cut

use parent qw(scripts::DBUpdateTo11_0::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    my @XMLStrings = (

        # form_cache
        '<Table Name="form_cache">
            <Column Name="session_id" Required="true" Size="100" Type="VARCHAR"/>
            <Column Name="form_id" Required="true" Size="100" Type="VARCHAR"/>
            <Column Name="cache_key" Required="true" Size="382" Type="VARCHAR"/>
            <Column Name="cache_value" Required="false" Type="LONGBLOB"/>
            <Column Name="serialized" Required="false" Type="SMALLINT"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Index Name="session_id_form_id">
                <IndexColumn Name="session_id" Size="32"/>
                <IndexColumn Name="form_id" Size="32"/>
            </Index>
        </Table>',

        # align form_id size in web_upload_cache
        '<TableAlter Name="web_upload_cache">
            <ColumnChange NameOld="form_id" NameNew="form_id" Required="false" Type="VARCHAR" Size="100" />
        </TableAlter>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;
