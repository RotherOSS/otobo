# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::CustomerNewTicket::QueueSelectionGeneric;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw( UserID SystemAddress)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

    # check if own selection is configured
    my %NewTos;
    if ( $ConfigObject->{CustomerPanelOwnSelection} ) {
        for my $Queue ( sort keys %{ $ConfigObject->{CustomerPanelOwnSelection} } ) {
            my $Value = $ConfigObject->{CustomerPanelOwnSelection}->{$Queue};
            if ( $Queue =~ /^\d+$/ ) {
                $NewTos{$Queue} = $Value;
            }
            else {
                if ( $QueueObject->QueueLookup( Queue => $Queue ) ) {
                    $NewTos{ $QueueObject->QueueLookup( Queue => $Queue ) } = $Value;
                }
                else {
                    $NewTos{$Queue} = $Value;
                }
            }
        }

        # check create permissions
        my %Queues = $TicketObject->MoveList(
            %{ $Param{ACLParams} },
            CustomerUserID => $Param{Env}->{UserID},
            Type           => 'create',
            Action         => $Param{Env}->{Action},
        );
        for my $QueueID ( sort keys %NewTos ) {
            if ( !$Queues{$QueueID} ) {
                delete $NewTos{$QueueID};
            }
        }
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
        if ( $ConfigObject->Get('CustomerPanelSelectionType') eq 'Queue' ) {
            %Tos = $TicketObject->MoveList(
                %{ $Param{ACLParams} },
                CustomerUserID => $Param{Env}->{UserID},
                Type           => 'create',
                Action         => $Param{Env}->{Action},
            );
        }
        else {
            my %Queues = $TicketObject->MoveList(
                %{ $Param{ACLParams} },
                CustomerUserID => $Param{Env}->{UserID},
                Type           => 'create',
                Action         => $Param{Env}->{Action},
            );
            my %SystemTos = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList();
            for my $QueueID ( sort keys %Queues ) {
                if ( $SystemTos{$QueueID} ) {
                    $Tos{$QueueID} = $Queues{$QueueID};
                }
            }
        }
        %NewTos = %Tos;

        # build selection string
        for my $QueueID ( sort keys %NewTos ) {
            my %QueueData = $QueueObject->QueueGet( ID => $QueueID );
            my $String    = $ConfigObject->Get('CustomerPanelSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $ConfigObject->Get('CustomerPanelSelectionType') ne 'Queue' ) {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet( ID => $QueueData{SystemAddressID} );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$QueueID} = $String;
        }
    }
    return %NewTos;
}

1;
