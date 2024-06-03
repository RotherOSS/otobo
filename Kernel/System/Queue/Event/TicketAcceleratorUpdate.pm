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

package Kernel::System::Queue::Event::TicketAcceleratorUpdate;
use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket::IndexAccelerator::StaticDB',
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
    for my $Needed (qw( Data Event Config UserID )) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }

    # Only run for StaticDB IndexModule.
    my $IndexModule = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::IndexModule');
    return 1 if $IndexModule ne 'Kernel::System::Ticket::IndexAccelerator::StaticDB';

    # only run if we have the correct data
    for my $Needed (qw(Queue OldQueue)) {
        if ( !IsHashRefWithData( $Param{Data}->{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Needed in Data is missing or invalid!"
            );

            return;
        }
    }

    # only update if Queue has really changed
    return 1 if $Param{Data}->{Queue}->{Name} eq $Param{Data}->{OldQueue}->{Name};

    # update ticket_index
    return $Kernel::OM->Get('Kernel::System::Ticket::IndexAccelerator::StaticDB')->TicketAcceleratorUpdateOnQueueUpdate(
        NewQueueName => $Param{Data}->{Queue}->{Name},
        OldQueueName => $Param{Data}->{OldQueue}->{Name},
    );
}

1;
