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

package Kernel::System::DynamicField::Driver::Agent;

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
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Agent - backend for the Reference dynamic field

=head1 DESCRIPTION

Agent plugin for the Reference dynamic field.

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

    # Some reference dynamic fields are stored in the database table attribute dynamic_field_value.value_int.
    $Self->{ValueType}      = 'Integer';
    $Self->{ValueKey}       = 'ValueInt';
    $Self->{TableAttribute} = 'value_int';

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

    $Self->{ReferencedObjectType} = 'Agent';

    return $Self;
}

=head2 GetFieldTypeSettings()

Get field type settings that are specific to the referenced object type Agent.

=cut

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

    my @FieldTypeSettings = $Self->SUPER::GetFieldTypeSettings(
        %Param,
    );

    my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->GroupList(
        Valid => 1,
    );

    push @FieldTypeSettings,
        {
            ConfigParamName => 'Group',
            Label           => Translatable('Group of the agents'),
            Explanation     => Translatable('Select the group of the agents'),
            InputType       => 'Selection',
            SelectionData   => \%GroupList,
            PossibleNone    => 1,
            Multiple        => 1,
        };

    # Support configurable import search attribute
    push @FieldTypeSettings,
        {
            ConfigParamName => 'ImportSearchAttribute',
            Label           => Translatable('Attribute which will be searched on external value set'),
            Explanation     => Translatable('Select the attribute which agents will be searched by'),
            InputType       => 'Selection',
            SelectionData   => {
                'Login' => 'Login',
                'Email' => 'E-Mail',
            },
            PossibleNone => 1,
            Multiple     => 0,
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

    # TODO how should agent permissions be checked?
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
        Normal => "UserFirstName UserLastName",
        Long   => "UserFirstName UserLastName",
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

    my $UserName = $Kernel::OM->Get('Kernel::System::User')->UserName(
        UserID => $Param{ObjectID},
    );

    return unless $UserName;

    my $Link;

    # TODO where to link to for agents?
    # if ( $Param{Link} && $Param{LayoutObject}{SessionSource} ) {
    #     if ( $Param{LayoutObject}{SessionSource} eq 'AgentInterface' ) {

    #         # TODO: only show the link if the user $Param{UserID} has permissions
    #         $Link = $Param{LayoutObject}{Baselink} . "Action=AgentTicketZoom;TicketID=$Param{ObjectID}";
    #     }
    # }

    # create description
    return (
        Normal => $UserName,
        Long   => $UserName,
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

# TODO reference filter restrictions currently do not work with this field type
sub SearchObjects {
    my ( $Self, %Param ) = @_;

    $Param{Term} //= '*';

    my $DynamicFieldConfig = $Param{DynamicFieldConfig};

    my %SearchParams;

    if ( $Param{ObjectID} ) {
        my $UserLogin = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserID => $Param{ObjectID},
        );
        $SearchParams{UserLogin} = $UserLogin;
    }
    else {
        $SearchParams{Search} = "*$Param{Term}*";
    }

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

    my @Result;

    # NOTE: UserSearch() ignores every parameter besides UserLogin, Search, PostMasterSearch, Limit and Valid
    my %AgentSearchResult = $Kernel::OM->Get('Kernel::System::User')->UserSearch(
        %SearchParams,
        Valid => 1,
    );

    my $GroupFilter = $Param{DynamicFieldConfig}{Config}{Group};
    if ( IsArrayRefWithData($GroupFilter) ) {
        for my $GroupID ( $GroupFilter->@* ) {
            my %GroupAgents = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
                GroupID => $GroupID,
                Type    => 'ro',
            );

            for my $UserID ( keys %AgentSearchResult ) {
                if ( $GroupAgents{$UserID} && !( any { $_ eq $UserID } @Result ) ) {
                    push @Result, $UserID;
                }
            }
        }
    }
    else {
        @Result = keys %AgentSearchResult;
    }

    # return a list of user IDs
    return @Result;
}

1;
