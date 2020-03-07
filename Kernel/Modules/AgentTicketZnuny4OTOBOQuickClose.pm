# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
# Copyright (C) (2014) (Denny Bresch) (dennybresch@gmail.com) (https://github.com/dennybresch)
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

package Kernel::Modules::AgentTicketZnuny4OTOBOQuickClose;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => 'close',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    $Self->_SetState();

    my $Config = $ConfigObject->Get('Znuny4OTOBOQuickClose');

    return $LayoutObject->Redirect( OP => $Self->{LastScreenOverview} ) if !$Config->{Article};

    my $ArticleID = $ArticleObject->ArticleCreate(
        ChannelName          => $Config->{CommunicationChannel} || 'Internal',
        TicketID             => $Self->{TicketID},
        SenderType           => $Config->{SenderType} || 'agent',
        Subject              => $Config->{Subject} || 'Ticket closed',
        Body                 => $Config->{Body} || 'Ticket closed',
        From                 => $LayoutObject->{UserFullname},
        ContentType          => $Config->{ContentType} || 'text/plain; charset=utf-8',
        HistoryType          => $Config->{HistoryType} || 'AddNote',
        HistoryComment       => $Config->{HistoryComment} || 'Ticket was closed',
        IsVisibleForCustomer => $Config->{IsVisibleForCustomer} || '0',
        UserID               => $Self->{UserID},
    );

    return $LayoutObject->Redirect( OP => $Self->{LastScreenOverview} );
}

sub _SetState {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $State = $ConfigObject->Get('Znuny4OTOBO::QuickClose::State');

    return if !$State;

    my $Success = $TicketObject->TicketStateSet(
        State    => $State,
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );

    return if !$Success;

    $TicketObject->TicketLockSet(
        TicketID => $Self->{TicketID},
        Lock     => 'unlock',
        UserID   => $Self->{UserID},
    );

    return 1;
}

1;
