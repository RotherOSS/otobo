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

package scripts::DBUpdateTo11_1::DBUpdateTranslationLength;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

our @ObjectDependencies = (
);

=head1 NAME

scripts::DBUpdateTo11_1::DBUpdateTranslationLength - enlarge the length of content and translation in translation_item.

=head1 DESCRIPTION

In OTOBO 11.0.x the length was 600 characters. In OTOBO 11.1.x the length had been increased to 3800 characters.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my @XMLStrings = (

        # enlargen size of translation and content fields
        '<TableAlter Name="translation_item">
            <ColumnChange NameOld="content" NameNew="content" Required="true" Size="3800" Type="VARCHAR" />
            <ColumnChange NameOld="translation" NameNew="translation" Required="true" Size="3800" Type="VARCHAR" />
        </TableAlter>',

    );

    return unless $Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );
    return 1;
}

1;
