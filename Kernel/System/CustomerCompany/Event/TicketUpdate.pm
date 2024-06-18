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

package Kernel::System::CustomerCompany::Event::TicketUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
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
    for (qw( Data Event Config UserID )) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw( CustomerID OldCustomerID )) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    # only update if CustomerID has really changed
    return 1 if $Param{Data}->{CustomerID} eq $Param{Data}->{OldCustomerID};

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # create ticket object and perform search
    my @Tickets = $TicketObject->TicketSearch(
        Result        => 'ARRAY',
        Limit         => 100_000,
        CustomerIDRaw => $Param{Data}->{OldCustomerID},
        ArchiveFlags  => [ 'y', 'n' ],
        UserID        => 1,
    );

    # update the customer ID of tickets
    for my $TicketID (@Tickets) {
        $TicketObject->TicketCustomerSet(
            No       => $Param{Data}->{CustomerID},
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
    }

    return 1;
}

1;
