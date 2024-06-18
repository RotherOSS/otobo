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

package Kernel::System::Ticket::Acl::CloseParentAfterClosedChilds;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Config Acl)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check if child tickets are not closed
    return 1 if !$Param{TicketID} || !$Param{UserID};

    # link tickets
    my $Links = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkList(
        Object => 'Ticket',
        Key    => $Param{TicketID},
        State  => 'Valid',
        Type   => 'ParentChild',
        UserID => $Param{UserID},
    );

    return 1 if !$Links;
    return 1 if ref $Links ne 'HASH';
    return 1 if !$Links->{Ticket};
    return 1 if ref $Links->{Ticket} ne 'HASH';
    return 1 if !$Links->{Ticket}->{ParentChild};
    return 1 if ref $Links->{Ticket}->{ParentChild} ne 'HASH';
    return 1 if !$Links->{Ticket}->{ParentChild}->{Target};
    return 1 if ref $Links->{Ticket}->{ParentChild}->{Target} ne 'HASH';

    my $OpenSubTickets = 0;
    TICKETID:
    for my $TicketID ( sort keys %{ $Links->{Ticket}->{ParentChild}->{Target} } ) {

        # get ticket
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        if ( $Ticket{StateType} !~ m{ \A (close|merge|remove) }xms ) {
            $OpenSubTickets = 1;
            last TICKETID;
        }
    }

    # generate acl
    if ($OpenSubTickets) {

        $Param{Acl}->{CloseParentAfterClosedChilds} = {

            # match properties
            Properties => {

                # current ticket match properties
                Ticket => {
                    TicketID => [ $Param{TicketID} ],
                },
            },

            # return possible options (black list)
            PossibleNot => {

                # possible ticket options (black list)
                Ticket => {
                    State => $Param{Config}->{State},
                },
                Action => [ 'AgentTicketClose', 'AgentTicketQuickClose' ],
            },
        };
    }

    return 1;
}

1;
