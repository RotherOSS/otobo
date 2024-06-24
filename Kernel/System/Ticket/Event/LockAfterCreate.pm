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

package Kernel::System::Ticket::Event::LockAfterCreate;

use strict;
use warnings;
our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }
    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID in Data!"
        );

        return;
    }

    # Only for frontend actions by agents.
    return 1 if $Param{UserID} eq 1;

    # Get action.
    my $Action = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Action' );
    return 1 if !$Action;

    # Check action against config.
    return 1 if $Action !~ m{$Param{Config}->{Action}};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => $Param{UserID},
        DynamicFields => 0,
    );

    # Disregard closed tickets.
    return 1 if ( $Ticket{StateType} eq 'closed' );

    # Disregard already locked tickets.
    return 1 if ( lc $Ticket{Lock} ne 'unlock' );

    # Set lock.
    $TicketObject->TicketLockSet(
        TicketID => $Param{Data}->{TicketID},
        Lock     => 'lock',
        UserID   => $Param{UserID},
    );
    return 1;
}

1;
