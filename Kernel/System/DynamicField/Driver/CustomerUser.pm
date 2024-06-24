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
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::Group',
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

    # Support configurable import search attribute
    push @FieldTypeSettings,
        {
            ConfigParamName => 'ImportSearchAttribute',
            Label           => Translatable('External-source key'),
            Explanation     => Translatable('When set via an external source (e.g. web service or import / export), the value will be interpreted as this attribute.'),
            InputType       => 'Selection',
            SelectionData   => {
                'UserLogin' => 'Login',
                'UserEmail' => 'E-Mail',
            },
            PossibleNone => 1,
            Multiple     => 0,
        };

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

    my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Param{ObjectID},
    );

    return unless %CustomerUserData;

    my $Link;

    # Add Link to CustomerUser
    if ( $Param{LayoutObject}{SessionSource} && $Param{LayoutObject}{SessionSource} eq 'AgentInterface' ) {

        # TODO: Why is the UserID not transferred here? I think UserID should be mandatory.
        # TODO: Does it make sense to get the UserID from the LayoutObject if it is not passed in $Param?
        my $FrontendModul = 'AdminCustomerUser';
        my $UserID        = $Param{LayoutObject}{UserID} || 1;

        $Link = $Self->_GetHTTPLink(
            FrontendModul => $FrontendModul,
            ObjectID      => $Param{LayoutObject}->LinkEncode( $CustomerUserData{UserLogin} ),
            UserID        => $UserID,
        );

    }

    # create description
    return (
        Normal => $CustomerUserData{UserMailString},
        Long   => $CustomerUserData{UserMailString},
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

    # prepare mapping of edit mask attribute names
    my %AttributeNameMapping = (
        CustomerUser => [

            # AgentTicketEmail
            'From',

            # AgentTicketPhone
            'To',
        ],
        ResponsibleID => [
            'NewResponsibleID',
        ],
        OwnerID => [
            'NewOwnerID',
            'NewUserID',
        ],
        QueueID => [
            'Dest',
            'NewQueueID',
        ],
        StateID => [
            'NewStateID',
            'NextStateID',
        ],
        PriorityID => [
            'NewPriorityID',
        ],
    );

    # incorporate referencefilterlist into search params
    if ( IsArrayRefWithData( $DynamicFieldConfig->{Config}{ReferenceFilterList} ) && !$Param{ExternalSource} ) {
        FILTERITEM:
        for my $FilterItem ( $DynamicFieldConfig->{Config}{ReferenceFilterList}->@* ) {

            # map ID to IDs if neccessary
            my $AttributeName = $FilterItem->{ReferenceObjectAttribute};
            if ( any { $_ eq $AttributeName } qw(QueueID TypeID StateID PriorityID ServiceID SLAID OwnerID ResponsibleID ) ) {
                $AttributeName .= 's';
            }

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

                        # match standard ticket attribute names with edit mask attribute names
                        my @ParamNames = $Param{ParamObject}->GetParamNames();

                        # check if attribute name itself is in params
                        # NOTE trying attribute itself is crucially important in case of QueueID
                        #   because AgentTicketPhone does not provide QueueID, but puts the id in
                        #   Dest, and AgentTicketEmail leaves Dest as a string but puts the id in QueueID
                        my ($ParamName) = grep { $_ eq $FilterItem->{EqualsObjectAttribute} } @ParamNames;

                        # if not, try to find a mapped attribute name
                        if ( !$ParamName ) {

                            # check if mapped attribute names exist at all
                            my $MappedAttributes = $AttributeNameMapping{ $FilterItem->{EqualsObjectAttribute} };
                            if ( ref $MappedAttributes eq 'ARRAY' ) {

                                MAPPEDATTRIBUTE:
                                for my $MappedAttribute ( $MappedAttributes->@* ) {
                                    ($ParamName) = grep { $_ eq $MappedAttribute } @ParamNames;

                                    last MAPPEDATTRIBUTE if $ParamName;
                                }
                            }
                        }

                        return unless $ParamName;

                        $EqualsObjectAttribute = $Param{ParamObject}->GetParam( Param => $ParamName );

                        # when called by AgentReferenceSearch, Dest is a string and we need to extract the QueueID
                        if ( $ParamName eq 'Dest' ) {
                            my $QueueID = '';
                            if ( $EqualsObjectAttribute =~ /^(\d{1,100})\|\|.+?$/ ) {
                                $QueueID = $1;
                            }
                            $EqualsObjectAttribute = $QueueID;
                        }
                    }
                }

                # ensure that for EqualsObjectAttribute UserID always $Self->{UserID} is used in the end
                if ( $FilterItem->{EqualsObjectAttribute} eq 'UserID' ) {
                    $EqualsObjectAttribute = $Param{UserID};
                }

                return unless $EqualsObjectAttribute;
                return if ( ref $EqualsObjectAttribute eq 'ARRAY' && !$EqualsObjectAttribute->@* );

                # config item attribute
                if ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Con}i ) {
                    $SearchParams{$AttributeName} = $EqualsObjectAttribute;
                }

                # dynamic field attribute
                elsif ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Dyn}i ) {
                    $SearchParams{$AttributeName} = {
                        Equals => $EqualsObjectAttribute,
                    };
                }

                # array attribute
                else {
                    $SearchParams{$AttributeName} = [$EqualsObjectAttribute];
                }
            }
            elsif ( $FilterItem->{EqualsString} ) {

                # config item attribute
                # TODO check if this has to be adapted for ticket search
                if ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Con}i ) {
                    $SearchParams{$AttributeName} = $FilterItem->{EqualsString};
                }

                # dynamic field attribute
                elsif ( $FilterItem->{ReferenceObjectAttribute} =~ m{^Dyn}i ) {
                    $SearchParams{$AttributeName} = {
                        Equals => $FilterItem->{EqualsString},
                    };
                }

                # array attribute
                else {
                    $SearchParams{$AttributeName} = [ $FilterItem->{EqualsString} ];
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
    elsif ( $Param{ExternalSource} ) {
        my $SearchAttribute = $DynamicFieldConfig->{Config}{ImportSearchAttribute} || 'UserLogin';

        $SearchParams{$SearchAttribute} = "$Param{Term}";
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

=head2 _GetHTTPLink()

return a HTTP link to the customer user edit mask, if permission is given.

    my $Link = $BackendObject->_GetHTTPLink(
        FrontendModul      => $FrontendModul,
        ObjectID   => $EncodedUserLogin
        UserID             => $UserID,
    );

Return

    $Link = 'index.pl?Action=AdminCustomerUser;Subaction=Change;ID=$customerid'

=cut

sub _GetHTTPLink {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID FrontendModul ObjectID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ModuleReg = $ConfigObject->Get('Frontend::Module')->{ $Param{FrontendModul} };
    my $Link;

    # module permission check for action
    if (
        ref $ModuleReg->{GroupRo} eq 'ARRAY'
        && !scalar @{ $ModuleReg->{GroupRo} }
        && ref $ModuleReg->{Group} eq 'ARRAY'
        && !scalar @{ $ModuleReg->{Group} }
        )
    {
        $Param{AccessRo} = 1;
        $Param{AccessRw} = 1;
    }
    else {
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

        PERMISSION:
        for my $Permission (qw(GroupRo Group)) {
            my $AccessOk = 0;
            my $Group    = $ModuleReg->{$Permission};
            next PERMISSION if !$Group;
            if ( ref $Group eq 'ARRAY' ) {
                INNER:
                for my $GroupName ( @{$Group} ) {
                    next INNER if !$GroupName;
                    next INNER if !$GroupObject->PermissionCheck(
                        UserID    => $Param{UserID},
                        GroupName => $GroupName,
                        Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',

                    );
                    $AccessOk = 1;
                    last INNER;
                }
            }
            else {
                my $HasPermission = $GroupObject->PermissionCheck(
                    UserID    => $Param{UserID},
                    GroupName => $Group,
                    Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',

                );
                if ($HasPermission) {
                    $AccessOk = 1;
                }
            }
            if ( $Permission eq 'Group' && $AccessOk ) {
                $Param{AccessRo} = 1;
                $Param{AccessRw} = 1;
            }
            elsif ( $Permission eq 'GroupRo' && $AccessOk ) {
                $Param{AccessRo} = 1;
            }
        }
        if ( $Param{AccessRo} || $Param{AccessRw} ) {

            $Link = 'index.pl?Action=' . $Param{FrontendModul} . ';Subaction=Change;';
            $Link .= 'ID=' . $Param{ObjectID};
            return $Link;
        }
        return;
    }

    # both GroupRo nor Group are empty arrayrefs
    return;
}

1;
