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

package Kernel::Output::HTML::TicketZoom::LinkTable;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    # get linked objects
    my $LinkListWithData = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkListWithData(
        Object           => 'Ticket',
        Key              => $Param{Ticket}->{TicketID},
        State            => 'Valid',
        UserID           => $Self->{UserID},
        ObjectParameters => {
            Ticket => {
                IgnoreLinkedTicketStateTypes => 1,
            },
        },
    );

    # get link table view mode
    my $LinkTableViewMode =
        $Kernel::OM->Get('Kernel::Config')->Get('LinkObject::ViewMode');

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # create the link table
    my $LinkTableStrg = $LayoutObject->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithData,
        ViewMode         => $LinkTableViewMode,
        Object           => 'Ticket',
        Key              => $Param{Ticket}->{TicketID},
    );
    return if !$LinkTableStrg;

    my $Location = '';

    # output the simple link table
    if ( $LinkTableViewMode eq 'Simple' ) {
        $LayoutObject->Block(
            Name => 'LinkTableSimple',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
        $Location = 'Sidebar';
    }

    # output the complex link table
    if ( $LinkTableViewMode eq 'Complex' ) {
        $LayoutObject->Block(
            Name => 'LinkTableComplex',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
        $Location = 'Main';
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/LinkTable',
        Data         => {},
    );
    return {
        Location => $Location,
        Output   => $Output,
        Rank     => '0300',
    };
}

1;
