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

package Kernel::Output::HTML::CustomerDashboard::TileTicketList;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::Output::HTML::TicketOverview::CustomerList',
    'Kernel::System::CustomerGroup',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
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

    # check needed CustomerUserID
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return '';
    }

    my $ConfigObject     = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject     = $Kernel::OM->Get('Kernel::System::Ticket');
    my $TicketListObject = $Kernel::OM->Get('Kernel::Output::HTML::TicketOverview::CustomerList');

    my %Filter = (
        CustomerUserID => $Param{UserID},
        StateType      => $Param{Config}{StateType} || '',
        SortBy         => $Param{Config}{SortBy}    || 'Age',
        OrderBy        => $Param{Config}{OrderBy}   || 'Down',
        Permission     => 'ro',
    );

    if ( $Param{Config}{CompanyTickets} ) {

        # check if output of customer company tickets is disabled
        if ( $ConfigObject->Get('Ticket::Frontend::CustomerDisableCompanyTicketAccess') ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    'Company Tickets can not be shown with Ticket::Frontend::CustomerDisableCompanyTicketAccess set!',
            );
            return '';
        }

        my %AccessibleCustomers = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupContextCustomers(
            CustomerUserID => $Param{UserID},
        );

        $Filter{CustomerIDRaw} = [ sort keys %AccessibleCustomers ];

    }
    else {
        $Filter{CustomerUserLoginRaw} = $Param{UserID};
    }

    # get the viewable tickets
    my @ViewableTickets = $TicketObject->TicketSearch(
        %Filter,
        Result => 'ARRAY',
    );

    my $TicketListHTML;
    if ( scalar @ViewableTickets == 0 ) {

        # check if the CustomerUser has tickets at all
        my @AllTickets = $TicketObject->TicketSearch(
            Result               => 'ARRAY',
            CustomerUserID       => $Param{UserID},
            CustomerUserLoginRaw => $Param{UserID},
            Permission           => 'ro',
            Limit                => 1,
        );

        # generate appropriate message
        if ( !@AllTickets ) {
            my $CustomTexts = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverviewCustomEmptyText');
            $TicketListHTML = $TicketListObject->Run(
                TicketIDs   => [],
                NoAllTotal  => 1,
                CustomTexts => ( ref $CustomTexts eq 'HASH' ) ? $CustomTexts : 0,
            );
        }
        else {
            $TicketListHTML = $TicketListObject->Run(
                TicketIDs => [],
            );
        }

    }
    else {

        if ( $Param{Config}{MaxTickets} && $Param{Config}{MaxTickets} - 1 < $#ViewableTickets ) {
            @ViewableTickets = @ViewableTickets[ 0 .. $Param{Config}{MaxTickets} - 1 ];
        }

        $TicketListHTML = $TicketListObject->Run(
            TicketIDs => \@ViewableTickets,
        );

    }

    my $Content = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'Dashboard/TileTicketList',
        Data         => {
            TileID         => $Param{TileID},
            TicketListHTML => $TicketListHTML,
            %{ $Param{Config} },
        },
    );

    return $Content;
}

1;
