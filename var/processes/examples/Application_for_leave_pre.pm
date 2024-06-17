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

package var::processes::examples::Application_for_leave_pre;
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

    # Dynamic fields definition
    my @DynamicFields = (
        {
            Name       => 'PreProcApplicationRecorded',
            Label      => 'Application Recorded',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'no'  => 'no',
                    'yes' => 'yes',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcDaysRemaining',
            Label      => 'Days Remaining',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
            },
        },
        {
            Name       => 'PreProcVacationStart',
            Label      => 'Vacation Start',
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            FieldOrder => 10002,
            Config     => {
                DateRestriction => 'DisablePastDates',
            },
        },
        {
            Name       => 'PreProcVacationEnd',
            Label      => 'Vacation End',
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            FieldOrder => 10003,
            Config     => {
                DateRestriction => 'DisablePastDates',
            },
        },
        {
            Name       => 'PreProcDaysUsed',
            Label      => 'Days Used',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10004,
            Config     => {
            },
        },
        {
            Name       => 'PreProcEmergencyTelephone',
            Label      => 'Emergency Telephone',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10005,
            Config     => {
            },
        },
        {
            Name       => 'PreProcRepresentationBy',
            Label      => 'Representation By',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            FieldOrder => 10006,
            Config     => {
                Rows => 10,
                Cols => 80,
            },
        },
        {
            Name       => 'PreProcProcessStatus',
            Label      => 'Process Status',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10007,
            Config     => {
            },
        },
        {
            Name       => 'PreProcApprovedSuperior',
            Label      => 'Approved Superior',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10008,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'no'  => 'no',
                    'yes' => 'yes',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcVacationInfo',
            Label      => 'Vacation Info',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            FieldOrder => 10009,
            Config     => {
                Rows => 10,
                Cols => 80,
            },
        },
    );

    %Response = $Self->DynamicFieldsAdd(
        DynamicFieldList => \@DynamicFields,
    );

    return %Response;
}

1;
