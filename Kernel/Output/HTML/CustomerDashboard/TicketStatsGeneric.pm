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

package Kernel::Output::HTML::CustomerDashboard::TileStatsGeneric;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
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

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $OpenText       = $LayoutObject->{LanguageObject}->Translate('Open');
    my $ClosedText     = $LayoutObject->{LanguageObject}->Translate('Closed');

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $CountOpen = $TicketObject->TicketSearch(
        StateType => 'Open',
        OrderBy => 'Down',
        SortBy => 'Age',
        CustomerUserID => $Param{UserID},
        Result     => 'COUNT',
        # search with user permissions
        Permission => 'ro',
    ) || 0;
    $OpenText .= ' ('.$CountOpen.')';
    
    my $CountClosed = $TicketObject->TicketSearch(
        StateType => 'Closed',
        OrderBy => 'Down',
        SortBy => 'Age',
        CustomerUserID => $Param{UserID},
        Result     => 'COUNT',
        # search with user permissions
        Permission => 'ro',
    ) || 0;
    $ClosedText .= ' ('.$CountClosed.')';

   my $CountAll = $TicketObject->TicketSearch(
        OrderBy => 'Down',
        SortBy => 'Age',
        CustomerUserID => $Param{UserID},
        Result     => 'COUNT',
        # search with user permissions
        Permission => 'ro',
    ) || 0;


   my $State1 = '180';
   my $State2 = '360';
   if ($CountAll < '1') {
        $CountAll = '1';
   }
   my $MathTemp = (360 / $CountAll) * $CountClosed;

   if ($MathTemp < '180') {
        $State1 = $MathTemp;
        $State2 = '180';
   }
   if ($MathTemp > '180') {
        $State2 = $MathTemp;
   }

   my $Content = $LayoutObject->Output(
        TemplateFile => 'CustomerTicketStats',
        Data         => {
            TileID => $Param{TileID},
            State1 => $State1,
            State2 => $State2,
            OpenText => $OpenText,
            ClosedText => $ClosedText,
            %{ $Param{Config} },
        },
    );

    return $Content;
}

1;
