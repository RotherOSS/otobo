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

package Kernel::GenericInterface::Event::ObjectType::Article;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

=head1 NAME

Kernel::GenericInterface::Event::ObjectType::Article - GenericInterface event data handler

=head1 SYNOPSIS

This event handler gathers data from objects.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub DataGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my %IDs;
    $IDs{ArticleID} = $Param{Data}->{ArticleID};
    $IDs{TicketID}  = $Param{Data}->{TicketID};

    for my $Needed (qw(ArticleID TicketID)) {
        if ( !$IDs{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Get ticket data to be able to filtering conditions at article event (see bug#13708).
    my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{Data}->{TicketID},
        DynamicFields => 1,
        UserID        => 1,
    );

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%IDs);

    my %ObjectData = $ArticleBackendObject->ArticleGet(
        %IDs,
        DynamicFields => 1,
        RealNames     => 1,
        UserID        => 1,
    );

    return ( %TicketData, %ObjectData );

}

1;
