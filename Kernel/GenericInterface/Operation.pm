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

package Kernel::GenericInterface::Operation;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsStringWithData);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation - GenericInterface Operation interface

=head1 DESCRIPTION

Operations are called by web service requests from remote
systems.

=head1 PUBLIC INTERFACE

=head2 new()

create an object.

    use Kernel::GenericInterface::Debugger;
    use Kernel::GenericInterface::Operation;

    my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
        DebuggerConfig   => {
            DebugThreshold => 'debug',
            TestMode       => 0,           # optional, in testing mode the data will not be written to the DB
            # ...
        },
        WebserviceID      => 12,
        CommunicationType => Provider, # Requester or Provider
        RemoteIP          => 192.168.1.1, # optional
    );

    my $OperationObject = Kernel::GenericInterface::Operation->new(
        DebuggerObject => $DebuggerObject,
        Operation      => 'TicketCreate',            # the name of the operation in the web service
        OperationType  => 'Ticket::TicketCreate',    # the local operation backend to use
        WebserviceID   => $WebserviceID,             # ID of the currently used web service
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {}, $Type;

    # Check needed objects.
    for my $Needed (qw(DebuggerObject Operation OperationType WebserviceID)) {
        if ( !$Param{$Needed} ) {

            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # Check operation.
    if ( !IsStringWithData( $Param{OperationType} ) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got no Operation with content!',
        );
    }

    # Load backend module.
    my $GenericModule = 'Kernel::GenericInterface::Operation::' . $Param{OperationType};
    $Kernel::OM = $Kernel::OM;    # avoid 'once' warning
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {

        return $Self->{DebuggerObject}->Error(
            Summary => "Can't load operation backend module $GenericModule!"
        );
    }
    $Self->{BackendObject} = $GenericModule->new(
        %{$Self},
    );

    # Pass back error message from backend if backend module could not be executed.
    return $Self->{BackendObject} if ref $Self->{BackendObject} ne $GenericModule;

    return $Self;
}

=head2 Run()

perform the selected Operation.

    my $Result = $OperationObject->Run(
        Data => {                               # data payload before Operation
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # result data payload after Operation
            ...
        },
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Start map on backend,
    return $Self->{BackendObject}->Run(%Param);
}

=head2 HandleError()

handle error data of the configured remote web service.

    my $Result = $OperationObject->HandleError(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleError {
    my ( $Self, %Param ) = @_;

    # Check data - only accept undef or hash ref
    if ( defined $Param{Data} && ref $Param{Data} ne 'HASH' ) {

        return $Self->{DebuggerObject}->Error(
            Summary => 'Got Data but it is not a hash ref in Operation handler (HandleResponse)!'
        );
    }

    return $Self->{BackendObject}->HandleError(%Param);

}

1;
