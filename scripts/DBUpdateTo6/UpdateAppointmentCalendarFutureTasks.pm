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

package scripts::DBUpdateTo6::UpdateAppointmentCalendarFutureTasks;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdateTo6::Base);

our @ObjectDependencies = (
    'Kernel::System::Calendar::Appointment',
);

=head1 NAME

scripts::DBUpdateTo6::UpdateAppointmentCalendarFutureTasks - Update AppointmentCalendar future tasks.

=head1 PUBLIC INTERFACE

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Update the future tasks.
    my $Success = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentFutureTasksUpdate();

    return $Success;
}

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    # Check if possible create required object,
    # that means the appointment calendar module
    # is in the system
    my $AppointmentCalendarObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    if ( !$AppointmentCalendarObject ) {
        print "\n    Error: Not possible to create appointment calendar object!\n\n";
        return;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.de/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
