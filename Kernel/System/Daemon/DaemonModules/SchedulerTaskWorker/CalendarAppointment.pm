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

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::CalendarAppointment;

use strict;
use warnings;

use parent qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Calendar::Appointment',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::CalendarAppointment - Scheduler daemon task handler module for CalendarAppointment

=head1 DESCRIPTION

This task handler executes calendar appointment jobs.

=head1 PUBLIC INTERFACE

=head2 new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TaskHandlerObject = $Kernel::OM-Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::CalendarAppointment');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug}      = $Param{Debug};
    $Self->{WorkerName} = 'Worker: CalendarAppointment';

    return $Self;
}

=head2 Run()

performs the selected task.

    my $Result = $TaskHandlerObject->Run(
        TaskID   => 123,
        TaskName => 'some name',    # optional
        Data     => {               # appointment id as got from Kernel::System::Calendar::Appointment::AppointmentGet()
            NotifyTime => '2016-08-02 03:59:00',
        },
    );

Returns:

    $Result = 1; # or fail in case of an error

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check task params
    my $CheckResult = $Self->_CheckTaskParams(
        %Param,
        NeededDataAttributes => ['NotifyTime'],
    );

    # stop execution if an error in params is detected
    return if !$CheckResult;

    if ( $Self->{Debug} ) {
        print "    $Self->{WorkerName} executes task: $Param{TaskName}\n";
    }

    # trigger the appointment notification
    my $Success = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentNotification( %{ $Param{Data} } );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not trigger appointment notification for AppointmentID $Param{Data}->{AppointmentID}!",
        );
    }

    return $Success;
}

1;
