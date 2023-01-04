# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Calendar::Event::Participation;

use v5.24;
use strict;
use warnings;

use parent qw(Kernel::System::AsynchronousExecutor);

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Calendar',
    'Kernel::System::Calendar::Appointment',
    'Kernel::System::Calendar::Participation',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    NEEDED:
    for my $Needed (qw(Event Data Config UserID)) {
        next NEEDED if $Param{$Needed};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed!",
        );

        return;
    }

    NEEDED:
    for my $Needed (qw(AppointmentID OldAppointment)) {
        next NEEDED if $Param{Data}->{$Needed};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed in Data!",
        );

        return;
    }

    my $AppointmentID = $Param{Data}->{AppointmentID};

    # loop protection: prevent from running if update was triggered by the ticket update
    if (
        $Kernel::OM->Get('Kernel::System::Calendar')
        ->{'_TicketIcalIntegration::AppointmentUpdate'}
        ->{$AppointmentID}++
        )
    {
        return;
    }

    # run only when there are participations for the appointment
    my @Participations = $Kernel::OM->Get('Kernel::System::Calendar::Participation')->ParticipationList(
        AppointmentIDs => [$AppointmentID],
    );

    return unless @Participations;

    # run only when the time has changed
    my %Appointment = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentGet(
        AppointmentID => $AppointmentID,
    );

    # Check agains the old appointment whether the time has changed. Only a changed
    # time leads to a reset of the participations.
    # String comparisons are sufficient as all times are in UTC.
    my $TimeHasChanged = any
    { $Appointment{$_} ne $Param{Data}->{OldAppointment}->{$_} }
    qw(StartTime EndTime);

    return unless $TimeHasChanged;

    # update ticket in an asynchronous call
    return $Self->AsyncCall(
        ObjectName     => 'Kernel::System::Calendar',
        FunctionName   => 'ResetParticipationStatus',
        FunctionParams => {
            AppointmentID => $AppointmentID,
        },
    );
}

1;
