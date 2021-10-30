# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::GenericInterface::Invoker::Ticket::TicketUpdate;

use strict;
use warnings;

use Kernel::GenericInterface::Invoker::Ticket::Common;

# prevent 'Used once' warning for Kernel::OM
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::GenericInterface::Invoker::Ticket::TicketUpdate - GenericInterface TicketUpdate Invoker backend

=head1 DESCRIPTION

Contains functions for TicketUpdate.

=head1 PUBLIC INTERFACE

=head2 new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Invoker->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw( DebuggerObject WebserviceID Invoker )) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{TicketCommonObject} = Kernel::GenericInterface::Invoker::Ticket::Common->new( %{$Self} );

    return $Self;
}

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    return $Self->{TicketCommonObject}->PrepareRequest(%Param);
}

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    return $Self->{TicketCommonObject}->HandleResponse(%Param);
}

sub HandleError {
    my ( $Self, %Param ) = @_;

    return $Self->{TicketCommonObject}->HandleResponse(
        %Param,
        ResponseSuccess => 0,
    );
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
