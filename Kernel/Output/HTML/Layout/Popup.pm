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

package Kernel::Output::HTML::Layout::Popup;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::Output::HTML::Layout::Popup - CSS/JavaScript

=head1 DESCRIPTION

All valid functions.

=head1 PUBLIC INTERFACE

=head2 PopupClose()

Generate a small HTML page which closes the pop-up window and
executes an action in the main window.

    # load specific URL in main window
    $LayoutObject->PopupClose(
        URL => "Action=AgentTicketZoom;TicketID=$TicketID"
    );

    or

    # reload main window
    $Self->{LayoutObject}->PopupClose(
        Reload => 1,
    );

=cut

sub PopupClose {
    my ( $Self, %Param ) = @_;

    if ( !$Param{URL} && !$Param{Reload} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need URL or Reload!'
        );
        return;
    }

    # Generate the call Header() and Footer(
    my $Output = $Self->Header( Type => 'Small' );

    if ( $Param{URL} ) {

        # add session if no cookies are enabled
        if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
            $Param{URL} .= ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
        }

        # send data to JS
        $Self->AddJSData(
            Key   => 'PopupClose',
            Value => 'LoadParentURLAndClose',
        );
        $Self->AddJSData(
            Key   => 'PopupURL',
            Value => $Param{URL},
        );
    }
    else {

        # send data to JS
        $Self->AddJSData(
            Key   => 'PopupClose',
            Value => 'ReloadParentAndClose',
        );
    }

    $Output .= $Self->Footer( Type => 'Small' );
    return $Output;
}

1;
