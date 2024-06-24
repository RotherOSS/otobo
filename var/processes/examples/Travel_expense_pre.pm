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

package var::processes::examples::Travel_expense_pre;
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

    # Dynamic fields definition
    my @DynamicFields = (
        {
            Name       => 'PreProcTravelPerDiem',
            Label      => 'Travel per diem',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
            },
        },
        {
            Name       => 'PreProcExpenseReceiptsRequired',
            Label      => 'Expense Receipts Required',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-No'  => 'No',
                    'otobo5s-Yes' => 'Yes',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcTravelExpensesProcessState',
            Label      => 'Travel Process State',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10002,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-BackToSpecifiedRecording'             => 'Hand Over from Approval',
                    'otobo5s-Detailed Travel Information Recorded' => 'Detailed Travel Information Recorded',
                    'otobo5s-General Travel Information Recorded'  => 'General Travel Information Recorded',
                    'otobo5s-Travel Information Approved'          => 'Travel information Approved',
                    'otobo5s-Travel information Not Approved'      => 'Travel information Not Approved',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcTravelApprovalYesNo',
            Label      => 'Travel Expenses Approved',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10003,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-Back' => 'Back to specification recording',
                    'otobo5s-No'   => 'Deny expenses and end process',
                    'otobo5s-Yes'  => 'Approve expenses and end process',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcFlightClass',
            Label      => 'Flight Class',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10004,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-Business' => 'Business',
                    'otobo5s-Economy'  => 'Economy',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcFlightDepartureLocationFromTo',
            Label      => 'Flight Departure Location (from/to)',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10005,
            Config     => {
            },
        },
        {
            Name       => 'PreProcFlightStopoverLocation',
            Label      => 'Flight Stopover Location',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10006,
            Config     => {
            },
        },
        {
            Name       => 'PreProcFlightReturnLocationFromTo',
            Label      => 'Flight Return Location (from/to)',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10007,
            Config     => {
            },
        },
        {
            Name       => 'PreProcFlightTotalCosts',
            Label      => 'Total Costs',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10008,
            Config     => {
            },
        },
        {
            Name       => 'PreProcLocalTravelReimbursementPerKm',
            Label      => 'Reimbursement per km',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10009,
            Config     => {
            },
        },
        {
            Name       => 'PreProcLocalDepartureLocationFromTo',
            Label      => 'Departure Location (from/to)',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10010,
            Config     => {
            },
        },
        {
            Name       => 'PreProcLocalReturnLocationFromTo',
            Label      => 'Return Location (from/to)',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10011,
            Config     => {
            },
        },
        {
            Name       => 'PreProcLocalTotalCosts',
            Label      => 'Total Costs',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10012,
            Config     => {
            },
        },
        {
            Name       => 'PreProcAccommodationDatesFrom',
            Label      => 'Accomodation From',
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            FieldOrder => 10013,
            Config     => {

            },
        },
        {
            Name       => 'PreProcAccommodationDatesTo',
            Label      => 'Accomodation To',
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            FieldOrder => 10014,
            Config     => {

            },
        },
        {
            Name       => 'PreProcAccomodationTotalCosts',
            Label      => 'Total Costs',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10015,
            Config     => {
            },
        },
        {
            Name       => 'PreProcTravelExpensesInformationComplete',
            Label      => 'Travel Expenses Information complete',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-No'  => 'No',
                    'otobo5s-Yes' => 'Yes',
                },
                TranslatableValues => 0,
            },
        },
    );

    my %Response = $Self->DynamicFieldsAdd(
        DynamicFieldList => \@DynamicFields,
    );

    return %Response;
}

1;
