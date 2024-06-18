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

package scripts::DBUpdateTo11_0::DBAddImportExportTables;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_0::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBAddImportExportTables - create tables for the ImportExport feature

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my @CreateTableXMLStrings;
    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="imexport_template">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
    <Column Name="imexport_object" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="imexport_format" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="name" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="valid_id" Required="true" Type="SMALLINT" />
    <Column Name="comments" Required="false" Size="200" Type="VARCHAR" />
    <Column Name="create_time" Required="false" Type="DATE" />
    <Column Name="create_by" Required="false" Type="INTEGER" />
    <Column Name="change_time" Required="false" Type="DATE" />
    <Column Name="change_by" Required="false" Type="INTEGER" />
    <ForeignKey ForeignTable="users">
        <Reference Local="create_by" Foreign="id" />
        <Reference Local="change_by" Foreign="id" />
    </ForeignKey>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="imexport_object">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
    <Column Name="template_id" Required="true" Type="BIGINT" />
    <Column Name="data_key" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="data_value" Required="true" Size="200" Type="VARCHAR" />
    <Index Name="imexport_object_template_id">
        <IndexColumn Name="template_id" />
    </Index>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="imexport_format">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
    <Column Name="template_id" Required="true" Type="BIGINT" />
    <Column Name="data_key" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="data_value" Required="true" Size="200" Type="VARCHAR" />
    <Index Name="imexport_format_template_id">
        <IndexColumn Name="template_id" />
    </Index>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="imexport_mapping">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
    <Column Name="template_id" Required="true" Type="BIGINT" />
    <Column Name="position" Required="true" Type="INTEGER" />
    <Index Name="imexport_mapping_template_id">
        <IndexColumn Name="template_id" />
    </Index>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="imexport_mapping_object">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
    <Column Name="mapping_id" Required="true" Type="BIGINT" />
    <Column Name="data_key" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="data_value" Required="true" Size="200" Type="VARCHAR" />
    <Index Name="imexport_mapping_object_mapping_id">
        <IndexColumn Name="mapping_id" />
    </Index>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="imexport_mapping_format">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
    <Column Name="mapping_id" Required="true" Type="BIGINT" />
    <Column Name="data_key" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="data_value" Required="true" Size="200" Type="VARCHAR" />
    <Index Name="imexport_mapping_format_mapping_id">
        <IndexColumn Name="mapping_id" />
    </Index>
</Table>
END_SQL

    push @CreateTableXMLStrings, <<'END_SQL';
<Table Name="imexport_search">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT" />
    <Column Name="template_id" Required="true" Type="BIGINT" />
    <Column Name="data_key" Required="true" Size="100" Type="VARCHAR" />
    <Column Name="data_value" Required="true" Size="200" Type="VARCHAR" />
    <Index Name="imexport_search_template_id">
        <IndexColumn Name="template_id" />
    </Index>
</Table>
END_SQL

    # The table structure has not changed.
    # So the tables can simply be kept when they already existed in the source system.
    return unless $Self->ExecuteXMLDBArray(
        XMLArray => \@CreateTableXMLStrings,
    );

    return 1;
}

1;
