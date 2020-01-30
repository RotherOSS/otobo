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

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewArticleSearchIndexTable;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::NewArticleSearchIndexTable - Adds new table for article search index.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        # create new article search index table
        '<Table Name="article_search_index">
            <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
            <Column Name="ticket_id" Required="true" Type="BIGINT"/>
            <Column Name="article_id" Required="true" Type="BIGINT"/>
            <Column Name="article_key" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="article_value" Required="false" Size="1800000" Type="VARCHAR"/>
            <Index Name="article_search_index_ticket_id">
                <IndexColumn Name="ticket_id"/>
                <IndexColumn Name="article_key"/>
            </Index>
            <Index Name="article_search_index_article_id">
                <IndexColumn Name="article_id"/>
                <IndexColumn Name="article_key"/>
            </Index>
            <ForeignKey ForeignTable="ticket">
                <Reference Local="ticket_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKey>
        </Table>',

        # drop old article search table
        '<TableDrop Name="article_search"/>',
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
