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

package scripts::DBUpdateTo11_0::DBUpdateDynamicFieldValue;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_0::DBUpdateDynamicFieldValue - Update dynamic_field_value to include set and value indices and use BIGINT as id

=cut

use parent qw(scripts::DBUpdateTo11_0::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    # one statement per column, so that an already existing column does not abort the update
    my @XMLStrings;

    # new column
    push @XMLStrings, <<'END_XML';
<TableAlter Name="dynamic_field_value">
  <ColumnAdd Name="index_value" Required="false" Type="SMALLINT" />
</TableAlter>
END_XML

    # new column
    push @XMLStrings, <<'END_XML';
<TableAlter Name="dynamic_field_value">
  <ColumnAdd Name="index_set" Required="false" Type="SMALLINT" />
</TableAlter>
END_XML

    # column type changed from INT to BIGINT
    push @XMLStrings, <<'END_XML';
<TableAlter Name="dynamic_field_value">
  <ColumnChange NameOld="id" NameNew="id" Required="true" NoDefault="true" AutoIncrement="true" Type="BIGINT" />
</TableAlter>
END_XML

    return unless $Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;
