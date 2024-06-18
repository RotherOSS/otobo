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

package scripts::DBUpdateTo10_1::DBAddDataStorage;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo10_1::DBAddDataStorage - Adds new table data_storage.

=cut

use parent qw(scripts::DBUpdateTo10_1::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    my @XMLStrings = (

        # New table data_storage
        '<Table Name="data_storage">
            <Column Name="ds_type" Required="true" Type="VARCHAR" Size="191"/>
            <Column Name="ds_key" Required="true" Type="VARCHAR" Size="191"/>
            <Column Name="ds_value" Required="false" Type="LONGBLOB"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Column Name="create_by" Required="true" Type="INTEGER"/>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
            </ForeignKey>
        </Table>',
        '<Table Name="stats_report">
            <Column AutoIncrement="true" Name="id" PrimaryKey="true" Required="true" Type="INTEGER"></Column>
            <Column Name="name" Required="true" Size="200" Type="VARCHAR"></Column>
            <Column Name="config" Required="true" Type="LONGBLOB"></Column>
            <Column Name="config_md5" Required="true" Size="32" Type="VARCHAR"></Column>
            <Column Name="valid_id" Required="true" Type="SMALLINT"></Column>
            <Column Name="create_time" Required="true" Type="DATE"></Column>
            <Column Name="create_by" Required="true" Type="INTEGER"></Column>
            <Column Name="change_time" Required="true" Type="DATE"></Column>
            <Column Name="change_by" Required="true" Type="INTEGER"></Column>
            <Unique Name="stats_report_name">
                <UniqueColumn Name="name"/>
            </Unique>
            <Unique Name="stats_report_config_md5">
                <UniqueColumn Name="config_md5"/>
            </Unique>
            <ForeignKey ForeignTable="valid">
                <Reference Local="valid_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="users">
                <Reference Local="create_by" Foreign="id"/>
                <Reference Local="change_by" Foreign="id"/>
            </ForeignKey>
        </Table>',
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;
