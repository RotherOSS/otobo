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

package var::processes::examples::Start_RMA_pre;
## nofilter(TidyAll::Plugin::OTOBO::Perl::PerlCritic)

use strict;
use warnings;

use parent qw(var::processes::examples::Base);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
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

    # Dynamic fields definition
    my @DynamicFields = (
        {
            Name       => 'PreProcFailureDescription',
            Label      => 'Failure description',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
                Rows => 10,
                Cols => 56,
            },
        },
        {
            Name       => 'PreProcHostName',
            Label      => 'Host name',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
            },
        },
        {
            Name       => 'PreProcSerialNo',
            Label      => 'Serial Number',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10002,
            Config     => {
            },
        },
        {
            Name       => 'PreProcInvoiceNo',
            Label      => 'Invoice number',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10003,
            Config     => {
            },
        },
        {
            Name       => 'PreProcContactPerson',
            Label      => 'Contact person',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            FieldOrder => 10004,
            Config     => {
            },
        },
        {
            Name       => 'PreProcAvailability',
            Label      => 'Availability of contact person',
            FieldType  => 'TextArea',
            ObjectType => 'Ticket',
            FieldOrder => 10005,
            Config     => {
                Rows => 2,
                Cols => 56,
            },
        },
        {
            Name       => 'PreProcRMA',
            Label      => 'Valid RMA',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10006,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-no'  => 'no',
                    'otobo5s-yes' => 'yes',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcGatheringInformation',
            Label      => 'Necessary information gathered',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10007,
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    'otobo5s-approved' => 'approved by agent',
                    'otobo5s-waiting'  => 'waiting for customer',
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
