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

package Kernel::System::CustomerUser::Event::TicketUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
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
    for (qw( Data Event Config UserID )) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }
    for (qw( UserLogin NewData OldData )) {
        if ( !$Param{Data}->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in Data!"
            );
            return;
        }
    }

    # only update if fields have really changed
    if (
        $Param{Data}->{OldData}->{UserCustomerID} ne $Param{Data}->{NewData}->{UserCustomerID}
        || $Param{Data}->{OldData}->{UserLogin} ne $Param{Data}->{NewData}->{UserLogin}
        )
    {

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # perform search
        my @Tickets = $TicketObject->TicketSearch(
            Result               => 'ARRAY',
            Limit                => 100_000,
            CustomerUserLoginRaw => $Param{Data}->{OldData}->{UserLogin},
            CustomerIDRaw        => $Param{Data}->{OldData}->{UserCustomerID},
            ArchiveFlags         => [ 'y', 'n' ],
            UserID               => 1,
        );

        # update the customer ID and login of tickets
        for my $TicketID (@Tickets) {
            $TicketObject->TicketCustomerSet(
                No       => $Param{Data}->{NewData}->{UserCustomerID},
                User     => $Param{Data}->{NewData}->{UserLogin},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
    }

    return 1;
}

1;
