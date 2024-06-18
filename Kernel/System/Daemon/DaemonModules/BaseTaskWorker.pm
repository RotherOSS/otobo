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

package Kernel::System::Daemon::DaemonModules::BaseTaskWorker;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Email',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::BaseTaskWorker - scheduler task worker base class

=head1 DESCRIPTION

Base class for scheduler daemon task worker modules.

=head1 PUBLIC INTERFACE

=begin Internal:

=head2 _HandleError()

Creates a system error message and sends an email with the error messages form a task execution.

    my $Success = $TaskWorkerObject->_HandleError(
        TaskName     => 'some name',
        TaskType      => 'some type',
        LogMessage   => 'some message',       # message to set in the OTOBO error log
        ErrorMessage => 'some message',       # message to be sent as a body of the email, usually contains
                                              #     all messages from STDERR including tracebacks
    );

=cut

sub _HandleError {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Param{LogMessage},
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $From = $ConfigObject->Get('NotificationSenderName') . ' <'
        . $ConfigObject->Get('NotificationSenderEmail') . '>';

    my $To = $ConfigObject->Get('Daemon::SchedulerTaskWorker::NotificationRecipientEmail') || '';

    if ( $From && $To ) {

        my $Sent = $Kernel::OM->Get('Kernel::System::Email')->Send(
            From     => $From,
            To       => $To,
            Subject  => "OTOBO Scheduler Daemon $Param{TaskType}: $Param{TaskName}",
            Charset  => 'utf-8',
            MimeType => 'text/plain',
            Body     => $Param{ErrorMessage},
        );

        return 1 if $Sent->{Success};
        return;
    }

    return;
}

=head2 _CheckTaskParams()

Performs basic checks for common task parameters.

    my $Success = $TaskWorkerObject->_CheckTaskParams(
        TaskID               => 123,
        TaskName             => 'some name',                # optional
        Data                 => $TaskDataHasRef,
        NeededDataAttributes => ['Object', 'Function'],     # optional, list of attributes that task needs in Data hash
        DataParamsRef        => 'HASH',                     # optional, 'HASH' or 'ARRAY', kind of reference of Data->Params
    );

=cut

sub _CheckTaskParams {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TaskID Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed! - Task: $Param{TaskName}",
            );

            return;
        }
    }

    # Check data.
    if ( ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got no valid Data! - Task: $Param{TaskName}",
        );

        return;
    }

    # Check mandatory attributes in Data.
    if ( $Param{NeededDataAttributes} && ref $Param{NeededDataAttributes} eq 'ARRAY' ) {

        for my $Needed ( @{ $Param{NeededDataAttributes} } ) {
            if ( !$Param{Data}->{$Needed} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need Data->$Needed! - Task: $Param{TaskName}",
                );

                return;
            }
        }
    }

    # Check the structure of Data params.
    if ( $Param{DataParamsRef} ) {

        if ( $Param{Data}->{Params} && ref $Param{Data}->{Params} ne uc $Param{DataParamsRef} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Data->Params is invalid, reference is not $Param{DataParamsRef}! - Task: $Param{TaskName}",
            );

            return;
        }
    }

    return 1;
}

=end Internal:

=cut

1;
