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

package scripts::DBUpdateTo11_0::DBAddTranslationItem;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBAddTranslationItem - Adds new table translation_item.

=cut

use parent qw(scripts::DBUpdateTo11_0::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    my @XMLStrings = (

        # New table translation_item
        '<Table Name="translation_item">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
            <Column Name="language" Required="true" Size="50" Type="VARCHAR" />
            <Column Name="content" Required="true" Size="600" Type="VARCHAR" />
            <Column Name="translation" Required="true" Size="600" Type="VARCHAR" />
            <Column Name="flag" Required="true" Size="1" Type="VARCHAR" />
            <Column Name="create_by" Required="true" Type="INTEGER" />
            <Column Name="create_time" Required="true" Type="DATE" />
            <Column Name="change_by" Required="true" Type="INTEGER" />
            <Column Name="change_time" Required="true" Type="DATE" />
            <Column Name="import_param" Required="false" Type="SMALLINT" />
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id" />
                <Reference Local="change_by" Foreign="id" />
            </ForeignKey>
            <Index Name="translation_item_language">
                <IndexColumn Name="language" />
            </Index>
        </Table>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;
