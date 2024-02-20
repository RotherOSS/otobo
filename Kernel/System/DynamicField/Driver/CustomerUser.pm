# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::DynamicField::Driver::CustomerUser;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseReference);

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);
use Kernel::Language              qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::CustomerUser - backend for the CustomerUser dynamic field

=head1 DESCRIPTION

Driver for the CustomerUser dynamic field class. Based on C<BaseReference>.

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
        'IsReferenceField'             => 1,
        'IsSetCapable'                 => 1,
        'SetsDynamicContent'           => 1,
    };

    $Self->{ReferencedObjectType} = 'CustomerUser';

    return $Self;
}

sub PossibleValuesGet {

    # this field makes no use of PossibleValuesGet for performance purpose - instead, values are checked via CustomerUserDataGet
    # nevertheless, function needs to be overwritten to make sure that the call doesn't reach PossibleValuesGet in BaseSelect
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Prioritiy => 'error',
        Message   => 'Method PossibleValuesGet is per design not implemented for CustomerUser dynamic fields and should never be called.',
    );

    return;
}

=head2 GetFieldTypeSettings()

Get field type settings that are specific to the referenced object type CustomerUser.

=cut

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

    # setting independent from the referenced object
    my @FieldTypeSettings;

    # For reference dynamic fields we want to display the referenced object type,
    # but the user should not be able to easily change that.
    # The select field can't be simply disabled as this would prevent that the info
    # is passed to the backend. Therefore we set up a list with a single element.
    {
        push @FieldTypeSettings,
            {
                ConfigParamName => 'ReferencedObjectType',
                Label           => Translatable('Referenced object type'),
                Explanation     => Translatable('Select the type of the referenced object'),
                InputType       => 'Selection',
                SelectionData   => { $Self->{ReferencedObjectType} => $Self->{ReferencedObjectType} },
                PossibleNone    => 0,
                Mandatory       => 1,
            };
    }

    # set up the edit field mode selection
    {
        push @FieldTypeSettings,
            {
                ConfigParamName => 'EditFieldMode',
                Label           => Translatable('Input mode of edit field'),
                Explanation     => Translatable('Select the input mode for the edit field.'),
                InputType       => 'Selection',
                SelectionData   => {
                    'AutoComplete' => 'AutoComplete',
                },
                PossibleNone => 0,
            };
    }

    # This dynamic field support multiple values.
    {
        my %MultiValueSelectionData = (
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        );

        push @FieldTypeSettings,
            {
                ConfigParamName => 'MultiValue',
                Label           => Translatable('Multiple Values'),
                Explanation     => Translatable('Activate this option to allow multiple values for this field.'),
                InputType       => 'Selection',
                SelectionData   => \%MultiValueSelectionData,
                PossibleNone    => 0,
            };
    }

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

    # TODO how should permissions for customeruser be handled?
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

    my $CustomerUserName = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
        UserLogin => $Param{ObjectID},
    );

    return unless $CustomerUserName;

    my $Link;

    # create description
    return (
        Normal => $CustomerUserName,
        Long   => $CustomerUserName,
        Link   => $Link,
    );
}

=head2 SearchObjects()

This is used in auto completion when searching for possible object IDs.

    my @ObjectIDs = $BackendObject->SearchObjects(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $ObjectID,                # (optional) if given, takes precedence over Term
        Term               => $Term,                    # (optional) defaults to wildcard search with empty string
        MaxResults         => $MaxResults,
        UserID             => 1,
        Object             => {
            %Data,
        },
        ParamObject        => $ParamObject,
    );

=cut

sub SearchObjects {
    my ( $Self, %Param ) = @_;

    $Param{Term} //= '';

    my $DynamicFieldConfig = $Param{DynamicFieldConfig};

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
                my $EqualsObjectAttribute;
                if ( IsHashRefWithData( $Param{Object} ) ) {
                    $EqualsObjectAttribute = $Param{Object}{DynamicField}{ $FilterItem->{EqualsObjectAttribute} } // $Param{Object}{ $FilterItem->{EqualsObjectAttribute} };
                }
                elsif ( defined $Param{ParamObject} ) {
                    if ( $FilterItem->{EqualsObjectAttribute} =~ /^DynamicField_(?<DFName>\S+)/ ) {
                        my $FilterItemDFConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                            Name => $+{DFName},
                        );
                        next FILTERITEM unless IsHashRefWithData($FilterItemDFConfig);
                        $EqualsObjectAttribute = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->EditFieldValueGet(
                            ParamObject        => $Param{ParamObject},
                            DynamicFieldConfig => $FilterItemDFConfig,
                            TransformDates     => 0,
                        );
                    }
                    else {
                        $EqualsObjectAttribute = $Param{ParamObject}->GetParam( Param => $FilterItem->{EqualsObjectAttribute} );
                    }
                }
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

    if ( $Param{ObjectID} ) {

        # use customer user data to check against restrictions
        my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Param{ObjectID},
        );

        # check if customer user matches search params
        for my $ParamName ( keys %SearchParams ) {

            # value is either scalar, array ref or hash ref with Equals => 'Value'
            my $ParamValue;
            if ( ref $SearchParams{$ParamName} eq 'HASH' ) {
                $ParamValue = $SearchParams{$ParamName}{Equals};
            }
            else {
                $ParamValue = $SearchParams{$ParamName};
            }

            if ( ref $ParamValue eq 'ARRAY' ) {
                for my $Element ( $ParamValue->@* ) {
                    if ( ref $CustomerUserData{$ParamName} eq 'ARRAY' ) {
                        return () unless any { $_ eq $Element } $CustomerUserData{$ParamName}->@*;
                    }
                    else {
                        return () unless $CustomerUserData{$ParamName} eq $Element;
                    }
                }
            }
            else {
                if ( ref $CustomerUserData{$ParamName} eq 'ARRAY' ) {
                    return () unless any { $_ eq $ParamValue } $CustomerUserData{$ParamName}->@*;
                }
                else {
                    return () unless $CustomerUserData{$ParamName} eq $ParamValue;
                }
            }
        }
        return ( $CustomerUserData{UserLogin} );
    }
    else {
        $SearchParams{Search} = "*$Param{Term}*";
    }

    # return a list of customeruser IDs
    my %Result = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerSearch(
        Limit  => $Param{MaxResults},
        Result => 'ARRAY',
        Valid  => 1,
        %SearchParams,
    );

    return keys %Result;
}

1;
