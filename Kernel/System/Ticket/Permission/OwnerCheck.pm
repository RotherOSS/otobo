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

package Kernel::System::Ticket::Permission::OwnerCheck;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CheckItem',
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
    for (qw(TicketID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get ticket data
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    return if !%Ticket;
    return if !$Ticket{OwnerID};

    # get queue config
    my $Queues = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Permission::OwnerCheck::Queues');

    # check queues
    if ( $Queues && ref $Queues eq 'HASH' && %{$Queues} && $Ticket{Queue} ) {

        return if !$Queues->{ $Ticket{Queue} };

        # get check item object
        my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

        # extract permission list
        my @PermissionList = split /,/, $Queues->{ $Ticket{Queue} };

        my %PermissionList;
        STRING:
        for my $String (@PermissionList) {

            next STRING if !$String;

            # trim the string
            $CheckItemObject->StringClean(
                StringRef => \$String,
            );

            next STRING if !$String;

            $PermissionList{$String} = 1;
        }

        # if a permission like 'note' is given, the 'ro' permission is required to calculate the right permission
        $PermissionList{ro} = 1;

        return if !$PermissionList{rw} && !$PermissionList{ $Param{Type} };
    }

    # check ticket owner, return access if current user is ticket owner
    return 1 if $Ticket{OwnerID} eq $Param{UserID};

    # return no access
    return;
}

1;
