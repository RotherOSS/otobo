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

package Kernel::System::ProcessManagement::TransitionAction::TicketOwnerSet;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketOwnerSet - A module to set a new ticket owner

=head1 DESCRIPTION

All TicketOwnerSet functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $TicketOwnerSetObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketOwnerSet');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Params()

Returns the configuration params for this transition action module

    my @Params = $Object->Params();

Each element is a hash reference that describes the config parameter.
Currently only the keys I<Key>, I<Value> and I<Optional> are used.

=cut

sub Params {
    my ($Self) = @_;

    my @Params = (
        {
            Key   => 'Owner',
            Value => 'a_user_login (required)',
        },
        {
            Key      => 'UserID',
            Value    => '1 (can overwrite the logged in user)',
            Optional => 1,
        },
    );

    return @Params;
}

=head2 Run()

    Run Data

    my $TicketOwnerSetResult = $TicketOwnerSetActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            Owner => 'root@localhost',
            # or
            OwnerID => 1,
            UserID  => 123,                     # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketOwnerSetResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # define a common message to output in case of any error
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        . " Transition: $Param{TransitionEntityID}"
        . " TransitionAction: $Param{TransitionActionEntityID} - ";

    # check for missing or wrong params
    my $Success = $Self->_CheckParams(
        %Param,
        CommonMessage => $CommonMessage,
    );
    return if !$Success;

    # override UserID if specified as a parameter in the TA config
    $Param{UserID} = $Self->_OverrideUserID(%Param);

    # use ticket attributes if needed
    $Self->_ReplaceTicketAttributes(%Param);
    $Self->_ReplaceAdditionalAttributes(%Param);

    if ( !$Param{Config}->{OwnerID} && !$Param{Config}->{Owner} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "No Owner or OwnerID configured!",
        );
        return;
    }

    $Success = 0;

    if (
        defined $Param{Config}->{Owner}
        && $Param{Config}->{Owner} ne $Param{Ticket}->{Owner}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketOwnerSet(
            TicketID => $Param{Ticket}->{TicketID},
            NewUser  => $Param{Config}->{Owner},
            UserID   => $Param{UserID},
        );
    }
    elsif (
        defined $Param{Config}->{OwnerID}
        && $Param{Config}->{OwnerID} ne $Param{Ticket}->{OwnerID}
        )
    {
        $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketOwnerSet(
            TicketID  => $Param{Ticket}->{TicketID},
            NewUserID => $Param{Config}->{OwnerID},
            UserID    => $Param{UserID},
        );
    }
    else {

        # data is the same as in ticket nothing to do
        $Success = 1;
    }

    if ( !$Success ) {
        my $CustomMessage;
        if ( defined $Param{Config}->{Owner} ) {
            $CustomMessage = "Owner: $Param{Config}->{Owner},";
        }
        else {
            $CustomMessage = "OwnerID: $Param{Config}->{OwnerID},";
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . 'Ticket owner could not be updated to '
                . $CustomMessage
                . ' for Ticket: '
                . $Param{Ticket}->{TicketID} . '!',
        );
        return;
    }
    return 1;
}

1;
