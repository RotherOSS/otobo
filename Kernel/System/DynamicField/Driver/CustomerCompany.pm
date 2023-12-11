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

package Kernel::System::DynamicField::Driver::CustomerCompany;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseReference);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::CustomerCompany',
);

=head1 NAME

Kernel::System::DynamicField::Driver::CustomerCompany - backend for the Reference dynamic field

=head1 DESCRIPTION

CustomerCompany plugin for the Reference dynamic field.

=head1 PUBLIC INTERFACE

=head2 new()

it is usually not necessary to explicitly create instances of dynamic field drivers.
Instances of the drivers are created in the constructor of the
dynamic field backend object C<Kernel::System::DynamicField::Backend>.

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # Some reference dynamic fields are stored in the database table attribute dynamic_field_value.value_text.
    $Self->{ValueType}      = 'Text';
    $Self->{ValueKey}       = 'ValueText';
    $Self->{TableAttribute} = 'value_text';

    # Used for declaring CSS classes
    $Self->{FieldCSSClass} = 'DynamicFieldReference';

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 1,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 1,
        'IsHiddenInTicketInformation'  => 0,
    };

    $Self->{ReferencedObjectType} = 'CustomerCompany';

    return $Self;
}

=head2 GetFieldTypeSettings()

Get field type settings that are specific to the referenced object type CustomerCompany.

=cut

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

    my @FieldTypeSettings = $Self->SUPER::GetFieldTypeSettings(
        %Param,
    );

    # Support reference filters
    push @FieldTypeSettings,
        {
            ConfigParamName => 'ReferenceFilterList',
        };

    return @FieldTypeSettings;
}

=head2 ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $BackendObject->ObjectPermission(
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectPermission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # TODO how should permissions on customercompanies be checked?
    return 1;
}

=head2 ObjectDescriptionGet()

return a hash of object descriptions.

    my %Description = $BackendObject->ObjectDescriptionGet(
        ObjectID => 123,
        UserID   => 1,
    );

Return

    %Description = (
        Normal => "Ticket# 1234455",
        Long   => "Ticket# 1234455: Need a sample ticket title",
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my %CustomerCompanyData = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
        CustomerID => $Param{ObjectID},
    );

    return if !%CustomerCompanyData;

    my $Link;

    # create description
    return (
        Normal => $CustomerCompanyData{CustomerCompanyName},
        Long   => $CustomerCompanyData{CustomerCompanyName},
        Link   => $Link,
    );

}

=head2 SearchObjects()

This is used in auto completion when searching for possible object IDs.

    my @ObjectIDs = $BackendObject->SearchObjects(
        DynamicFieldConfig => $DynamicFieldConfig,
        Term               => $Term,
        MaxResults         => $MaxResults,
        UserID             => 1,
    );

=cut

sub SearchObjects {
    my ( $Self, %Param ) = @_;

    $Param{Term} //= '';

    my $DynamicFieldConfig = $Param{DynamicFieldConfig};

    # Support restriction by ticket type when the Ticket::Type feature is activated.
    my %SearchParams;

    # incorporate referencefilterlist into search params
    if ( $DynamicFieldConfig->{Config}{ReferenceFilterList} ) {
        FILTERITEM:
        for my $FilterItem ( $DynamicFieldConfig->{Config}{ReferenceFilterList}->@* ) {

            # check filter config
            next FILTERITEM unless $FilterItem->{ReferenceObjectAttribute};
            next FILTERITEM unless ( $FilterItem->{EqualsObjectAttribute} || $FilterItem->{EqualsString} );

            if ( $FilterItem->{EqualsObjectAttribute} ) {

                # don't perform search if object attribute to search for is empty
                my $EqualsObjectAttribute = $Param{Object}{DynamicField}{ $FilterItem->{EqualsObjectAttribute} } // $Param{Object}{ $FilterItem->{EqualsObjectAttribute} };
                return unless $EqualsObjectAttribute;
                return if ( ref $EqualsObjectAttribute eq 'ARRAY' && !$EqualsObjectAttribute->@* );

                # config item attribute
                if ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Con}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = $EqualsObjectAttribute;
                }

                # dynamic field attribute
                elsif ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Dyn}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = {
                        Equals => $EqualsObjectAttribute,
                    };
                }

                # array attribute
                else {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = [$EqualsObjectAttribute];
                }
            }
            elsif ( $FilterItem->{EqualsString} ) {

                # config item attribute
                # TODO check if this has to be adapted for ticket search
                if ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Con}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = $FilterItem->{EqualsString};
                }

                # dynamic field attribute
                elsif ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Dyn}i ) {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = {
                        Equals => $FilterItem->{EqualsString},
                    };
                }

                # array attribute
                else {
                    $SearchParams{ $FilterItem->{ReferenceObjectAttribute} } = [ $FilterItem->{EqualsString} ];
                }
            }
        }
    }

    # search for customer id and customer name separately
    my $CompanyIDResult = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanySearchDetail(
        CustomerID => "*$Param{Term}*",
        Limit      => $Param{MaxResults},
        Result     => 'ARRAY',
        Valid      => 1,
        %SearchParams,
    );
    my %CompanyIDResultHash = map { $_ => 1 } $CompanyIDResult->@*;

    my $CompanyNameResult = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanySearchDetail(
        CustomerCompanyName => "*$Param{Term}*",
        Limit               => $Param{MaxResults},
        Result              => 'ARRAY',
        Valid               => 1,
        %SearchParams,
    );
    my %CompanyNameResultHash = map { $_ => 1 } $CompanyNameResult->@*;

    # prevent duplicated results
    my %MergeHash = (
        %CompanyIDResultHash,
        %CompanyNameResultHash,
    );

    # return a list of customercompany IDs
    return keys %MergeHash;
}

1;
