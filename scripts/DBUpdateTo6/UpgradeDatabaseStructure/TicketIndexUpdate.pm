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

package scripts::DBUpdateTo6::UpgradeDatabaseStructure::TicketIndexUpdate;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo6::UpgradeDatabaseStructure::TicketIndexUpdate - recreate table to have the ticket's create_time instead of create_time_unix

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;

    my @XMLStrings = (

        '<TableDrop Name="ticket_index"/>',
        '<TableCreate Name="ticket_index">
            <Column Name="ticket_id" Required="true" Type="BIGINT"/>
            <Column Name="queue_id" Required="true" Type="INTEGER"/>
            <Column Name="queue" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="group_id" Required="true" Type="INTEGER"/>
            <Column Name="s_lock" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="s_state" Required="true" Size="200" Type="VARCHAR"/>
            <Column Name="create_time" Required="true" Type="DATE"/>
            <Index Name="ticket_index_ticket_id">
                <IndexColumn Name="ticket_id"/>
            </Index>
            <Index Name="ticket_index_queue_id">
                <IndexColumn Name="queue_id"/>
            </Index>
            <Index Name="ticket_index_group_id">
                <IndexColumn Name="group_id"/>
            </Index>
            <ForeignKey ForeignTable="ticket">
                <Reference Local="ticket_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="queue">
                <Reference Local="queue_id" Foreign="id"/>
            </ForeignKey>
            <ForeignKey ForeignTable="groups">
                <Reference Local="group_id" Foreign="id"/>
            </ForeignKey>
        </TableCreate>',
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
