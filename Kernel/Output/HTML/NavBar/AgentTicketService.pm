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

package Kernel::Output::HTML::NavBar::AgentTicketService;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check if frontend module is registered (otherwise return)
    my $Config     = $ConfigObject->Get('Frontend::Module')->{AgentTicketService};
    my $Navigation = $ConfigObject->Get('Frontend::Navigation')->{AgentTicketService};

    return if !IsHashRefWithData($Config);
    return if !IsHashRefWithData($Navigation);
    return if !IsArrayRefWithData( $Navigation->{'002-Ticket'} );

    # check if ticket service feature is enabled, in such case there is nothing to do
    return if $ConfigObject->Get('Ticket::Service');

    # frontend module is enabled but not ticket service, then remove the menu entry
    my $NavBarName = $Config->{NavBarName};
    my $Priority   = sprintf( '%07d', $Navigation->{'002-Ticket'}->[0]->{Prio} );

    my %Return = %{ $Param{NavBar}->{Sub} };

    # remove AgentTicketService from the TicketMenu
    delete $Return{$NavBarName}->{$Priority};

    return ( Sub => \%Return );
}

1;
