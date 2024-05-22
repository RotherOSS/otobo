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
    'Kernel::Config',
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
            Label           => Translatable('External-source key'),
            Explanation     => Translatable('When set via an external source (e.g. web service or import / export), the value will be interpreted as this attribute.'),
            InputType       => 'Selection',
            SelectionData   => {
                'UserLogin'        => 'Login',
                'PostMasterSearch' => 'E-Mail',
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

    # get preferences
    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences( UserID => $Param{ObjectID} );

    if ( $Preferences{UserEmail} ) {
        $UserName = qq{"$UserName" <$Preferences{UserEmail}>};
    }

    my $Link;

    # Add Link to CustomerUser
    if ( $Param{LayoutObject}{SessionSource} && $Param{LayoutObject}{SessionSource} eq 'AgentInterface' ) {

        # TODO: Why is the UserID not transferred here? I think UserID should be mandatory.
        # TODO: Does it make sense to get the UserID from the LayoutObject if it is not passed in $Param?
        # TODO where to link to for agents?
        my $FrontendModul = 'AdminUser';
        my $UserID        = $Param{LayoutObject}{UserID} || 1;

        $Link = $Self->_GetHTTPLink(
            FrontendModul => $FrontendModul,
            ObjectID      => $Param{LayoutObject}->LinkEncode( $Param{ObjectID} ),
            UserID        => $UserID,
        );

    }

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
    elsif ( $Param{ExternalSource} ) {
        my $SearchAttribute = $DynamicFieldConfig->{Config}{ImportSearchAttribute} || 'Search';
        $SearchParams{$SearchAttribute} = "$Param{Term}";
    }
    else {
        $SearchParams{Search} = "*$Param{Term}*";
    }

    # incorporate referencefilterlist into search params
    if ( $DynamicFieldConfig->{Config}{ReferenceFilterList} && !$Param{ExternalSource} ) {
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
    if ( IsArrayRefWithData($GroupFilter) && !$Param{ExternalSource} ) {
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

=head2 _GetHTTPLink()

return a HTTP link to the agent edit mask, if permission is given.

    my $Link = $BackendObject->_GetHTTPLink(
        FrontendModul      => $FrontendModul,
        ObjectID   => $EncodedUserLogin
        UserID             => $UserID,
    );

Return

    $Link = "https://fqdn.otobo.de/otobo/index.pl?Action=AdminUser;Subaction=Change;ID=$UserID

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
