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

package var::processes::examples::Service_Transition_Release_And_Deployment_Management_pre;
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
            Name       => 'PreProcReleaseDeploymentManagementPurchaseRequestsIssued',
            Label      => 'Necessary Work Orders / Purchase Requests are issued',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10000,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-no'  => 'No, I still have to issue necessary Work Orders and Purchase Requests',
                    'otobo5s-yes' => 'Yes, all necessary Work Orders and Purchase Requests are issued',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReleaseDeploymentManagementReleaseComponentsDeployed',
            Label      => 'All Release components are deployed',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10001,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-no'  => 'No, 1 or more Release components are not deployed',
                    'otobo5s-yes' => 'Yes, all Release components are deployed',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReleaseDeploymentManagementReleaseUserDocumentationCreated',
            Label      => 'User documentation is created',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10002,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-no'  => 'No, 1 or more user documentation is not created',
                    'otobo5s-yes' => 'Yes, all required user documentation is created',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReleaseDeploymentManagementReleaseUserTrainingCompleted',
            Label      => 'User trainings are completed',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10003,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-no'  => 'No, 1 or more user trainings are not completed',
                    'otobo5s-yes' => 'Yes, all user trainings are completed',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReleaseDeploymentManagementReleaseErrorsFixed',
            Label      => 'All Release errors are fixed',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10004,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-invalid' => 'Release deployed without errors',
                    'otobo5s-no'      => 'No, 1 or more Release errors are not fixed',
                    'otobo5s-yes'     => 'Yes, all Release errors are fixed',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReleaseDeploymentManagementReleaseEarlyLifeCompleted',
            Label      => 'Early Life period completed',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10005,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-no'  => 'No, the Early Life period is not completed',
                    'otobo5s-yes' => 'Yes, the Early Life period is completed',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReleaseDeploymentManagementCMDBContentUpdated',
            Label      => 'CMS / CMDB content updated',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10006,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-no'  => 'No, 1 or more Configuration Items are not updated',
                    'otobo5s-yes' => 'Yes, all relevant Configuration Items are updated',
                },
                TranslatableValues => 0,
            },
        },
        {
            Name       => 'PreProcReleaseDeploymentManagementChangeRecordReferenced',
            Label      => 'Reference to Change Records added',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            FieldOrder => 10007,
            Config     => {
                DefaultValue   => '',
                PossibleValues => {
                    'otobo5s-no'  => 'No, I still have to reference (link) relevant Change Records',
                    'otobo5s-yes' => 'Yes, all relevant Change Records are referenced (linked)',
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
