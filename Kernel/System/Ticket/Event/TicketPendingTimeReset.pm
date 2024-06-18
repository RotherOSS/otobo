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

package Kernel::System::Ticket::Event::TicketPendingTimeReset;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
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
    for (qw(Data Event Config)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw(TicketID)) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # read pending state types from config
    my $PendingReminderStateType =
        $ConfigObject->Get('Ticket::PendingReminderStateType:') || 'pending reminder';

    my $PendingAutoStateType =
        $ConfigObject->Get('Ticket::PendingAutoStateType:') || 'pending auto';

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        UserID        => 1,
        DynamicFields => 0,
    );
    return if !%Ticket;

    # only set the pending time to 0 if it's actually set
    return 1 if !$Ticket{UntilTime};

    # only set the pending time to 0 if the new state is NOT a pending state
    return 1 if $Ticket{StateType} eq $PendingReminderStateType;
    return 1 if $Ticket{StateType} eq $PendingAutoStateType;

    # reset pending date/time
    return if !$TicketObject->TicketPendingTimeSet(
        TicketID => $Param{Data}->{TicketID},
        UserID   => $Param{UserID},
        String   => '0000-00-00 00:00:00',
    );

    return 1;
}

1;
