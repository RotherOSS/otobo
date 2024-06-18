# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package var::processes::examples::Travel_expense_post;
## nofilter(TidyAll::Plugin::OTOBO::Perl::PerlCritic)

use strict;
use warnings;

use parent qw(var::processes::examples::Base);

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Response = (
        Success => 1,
    );

    my @Data = (
        {
            'Ticket::Frontend::AgentTicketZoom' => {
                'ProcessWidgetDynamicFieldGroups' => {
                    'Travel Expenses Accomodation Information' =>
                        'PreProcAccommodationDatesFrom, PreProcAccommodationDatesTo, PreProcAccomodationTotalCosts',
                    'Travel Expenses Approval Information' =>
                        'PreProcTravelApprovalYesNo',
                    'Travel Expenses Flight Information' =>
                        'PreProcFlightClass, PreProcFlightDepartureLocationFromTo, PreProcFlightStopoverLocation, ' .
                        'PreProcFlightReturnLocationFromTo, PreProcFlightTotalCosts',
                    'Travel Expenses General Information' =>
                        'PreProcTravelPerDiem, PreProcExpenseReceiptsRequired',
                    'Travel Expenses Local Travel Information' =>
                        'PreProcLocalTravelReimbursementPerKm, PreProcLocalDepartureLocationFromTo, ' .
                        'PreProcLocalReturnLocationFromTo, PreProcLocalTotalCosts',
                    'Travel Expenses Other Information' =>
                        'PreProcOtherTravelExpensesPublicTransport, PreProcOtherTravelExpensesPublicParking, ' .
                        'PreProcOtherTravelExpensesPublicTaxi, PreProcOtherTravelExpensesAllowableExpenses',
                    'Travel Expenses Process Information' =>
                        'PreProcTravelExpensesProcessState',
                },
                'ProcessWidgetDynamicField' => {
                    'PreProcTravelPerDiem'                 => '1',
                    'PreProcExpenseReceiptsRequired'       => '1',
                    'PreProcTravelExpensesProcessState'    => '1',
                    'PreProcTravelApprovalYesNo'           => '1',
                    'PreProcFlightClass'                   => '1',
                    'PreProcFlightDepartureLocationFromTo' => '1',
                    'PreProcFlightStopoverLocation'        => '1',
                    'PreProcFlightReturnLocationFromTo'    => '1',
                    'PreProcFlightTotalCosts'              => '1',
                    'PreProcLocalTravelReimbursementPerKm' => '1',
                    'PreProcLocalDepartureLocationFromTo'  => '1',
                    'PreProcLocalReturnLocationFromTo'     => '1',
                    'PreProcLocalTotalCosts'               => '1',
                    'PreProcAccommodationDatesFrom'        => '1',
                    'PreProcAccommodationDatesTo'          => '1',
                    'PreProcAccomodationTotalCosts'        => '1',
                },
            },
        },
    );

    $Response{Success} = $Self->SystemConfigurationUpdate(
        ProcessName => 'Travel Expense',
        Data        => \@Data,
    );

    return %Response;
}

1;
