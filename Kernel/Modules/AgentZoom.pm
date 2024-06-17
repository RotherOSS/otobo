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

#
# LEGACY: This module redirects to AgentTicketZoom. It should be kept for a while
#   because existing legacy/upgraded systems have it in their notifications.
#   To drop it, existing notifications would have to be changed by the database
#   upgrading script.
#

package Kernel::Modules::AgentZoom;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # compat link
    my $Redirect = $ENV{REQUEST_URI};
    if ($Redirect) {
        $Redirect =~ s/AgentZoom/AgentTicketZoom/;
    }
    else {
        $Redirect = $LayoutObject->{Baselink}
            . 'Action=AgentTicketZoom;TicketID='
            . $Self->{TicketID};
    }
    return $LayoutObject->Redirect( OP => $Redirect );
}

1;
