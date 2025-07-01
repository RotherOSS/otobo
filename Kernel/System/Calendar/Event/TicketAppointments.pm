# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::Calendar::Event::TicketAppointments;

use strict;
use warnings;

use parent qw(Kernel::System::AsynchronousExecutor);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Calendar',
);

=head1 NAME

Kernel::System::Calendar::Event::TicketAppointments - update the associated ticket when an appointment is updated

=head1 DESCRIPTION

When an appointment is updated then check whether the appointment is associated with a ticket.
If so then update the ticket if the configured rules apply.

What actually happens to the ticket is controlled by the SysConfig setting I<AppointmentCalendar::TicketAppointmentType>.
The standard use case is for appointments that have been created because the pending time is being approached.
Changing the time of such an automatically created appointment changes the pending time of the ticket.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    return bless {}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Event Data Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !$Param{Data}->{AppointmentID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need AppointmentID in Data!',
        );
        return;
    }

    # loop protection: prevent from running if update was triggered by the ticket update
    if (
        $Kernel::OM->Get('Kernel::System::Calendar')
        ->{'_TicketAppointments::TicketUpdate'}
        ->{ $Param{Data}->{AppointmentID} }++
        )
    {
        return;
    }

    # run only on ticket appointments (get ticket id)
    my $TicketID = $Kernel::OM->Get('Kernel::System::Calendar')->TicketAppointmentTicketID(
        AppointmentID => $Param{Data}->{AppointmentID},
    );

    return unless $TicketID;

    # update ticket in an asynchronous call
    return $Self->AsyncCall(
        ObjectName     => 'Kernel::System::Calendar',
        FunctionName   => 'TicketAppointmentUpdateTicket',
        FunctionParams => {
            AppointmentID => $Param{Data}->{AppointmentID},
            TicketID      => $TicketID,
        },
    );
}

1;
