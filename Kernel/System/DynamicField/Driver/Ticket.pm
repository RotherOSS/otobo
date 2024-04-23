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

package Kernel::System::DynamicField::Driver::Ticket;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseReference);

# core modules
use List::Util qw(any none);

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::Ticket',
    'Kernel::System::Type',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Ticket - backend for the Reference dynamic field

=head1 DESCRIPTION

Ticket plugin for the Reference dynamic field.

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

    $Self->{ReferencedObjectType} = 'Ticket';

    return $Self;
}

=head2 GetFieldTypeSettings()

Get field type settings that are specific to the referenced object type Ticket.

=cut

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

    my @FieldTypeSettings = $Self->SUPER::GetFieldTypeSettings(
        %Param,
    );

    # Support restriction by ticket queue.
    my %QueueID2Name = $Kernel::OM->Get('Kernel::System::Queue')->QueueList;
    push @FieldTypeSettings,
        {
            ConfigParamName => 'Queue',
            Label           => Translatable('Queue of the ticket'),
            Explanation     => Translatable('Select the queue of the ticket'),
            InputType       => 'Selection',
            SelectionData   => \%QueueID2Name,
            PossibleNone    => 1,
            Multiple        => 1,
        };

    # Support restriction by ticket type when the Ticket::Type feature is activated.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    if ( $ConfigObject->Get('Ticket::Type') ) {
        my %TypeID2Name = $Kernel::OM->Get('Kernel::System::Type')->TypeList;
        push @FieldTypeSettings,
            {
                ConfigParamName => 'TicketType',
                Label           => Translatable('Type of the ticket'),
                Explanation     => Translatable('Select the type of the ticket'),
                InputType       => 'Selection',
                SelectionData   => \%TypeID2Name,
                PossibleNone    => 1,
                Multiple        => 1,
            };
    }

    # Support configurable search key
    push @FieldTypeSettings,
        {
            ConfigParamName => 'SearchAttribute',
            Label           => Translatable('Attribute which will be searched on autocomplete'),
            Explanation     => Translatable('Select the attribute which tickets will be searched by'),
            InputType       => 'Selection',
            SelectionData   => {
                'Number' => 'Number',
                'Title'  => 'Title',
            },
            PossibleNone => 1,
            Multiple     => 0,
        };

    # Support configurable import search attribute
    push @FieldTypeSettings,
        {
            ConfigParamName => 'ImportSearchAttribute',
            Label           => Translatable('Attribute which will be searched on external value set'),
            Explanation     => Translatable('Select the attribute which tickets will be searched by'),
            InputType       => 'Selection',
            SelectionData   => {
                'Number' => 'Number',
            },
            PossibleNone => 1,
            Multiple     => 0,
        };

    # Support various display options
    push @FieldTypeSettings,
        {
            ConfigParamName => 'DisplayType',
            Label           => Translatable('Attribute which is displayed for values'),
            Explanation     => Translatable('Select the type of display'),
            InputType       => 'Selection',
            SelectionData   => {
                'TicketNumber'      => 'Ticket#<Ticket Number>',
                'QueueTicketNumber' => '<Queue>: <Ticket Number>',
                'TicketNumberTitle' => '<Ticket Number>: <Ticket Title>',
            },
            PossibleNone => 1,
            Multiple     => 0,
        };

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

    return $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        TicketID => $Param{Key},
        UserID   => $Param{UserID},
        Type     => 'ro',
    );
}

=head2 ObjectDescriptionGet()

return a hash of object descriptions.

    my %Description = $BackendObject->ObjectDescriptionGet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => 123,
        UserID             => 1,
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

    # TODO: Discuss security considerations - not much is shown though
    my $UserID = 1;

    # get ticket
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Param{ObjectID},
        UserID        => $UserID,
        DynamicFields => 0,
    );

    return unless %Ticket;

    my %Descriptions;
    if ( $Param{DynamicFieldConfig} && $Param{DynamicFieldConfig}{Config}{DisplayType} ) {

        # prepare string as configured
        my $DisplayType = $Param{DynamicFieldConfig}{Config}{DisplayType};
        if ( $DisplayType eq 'TicketNumber' ) {
            $Descriptions{Normal} = "Ticket#$Ticket{TicketNumber}";
            $Descriptions{Long}   = "Ticket#$Ticket{TicketNumber}";
        }
        elsif ( $DisplayType eq 'QueueTicketNumber' ) {
            $Descriptions{Normal} = "$Ticket{Queue}: $Ticket{TicketNumber}";
            $Descriptions{Long}   = "$Ticket{Queue}: $Ticket{TicketNumber}";
        }
        elsif ( $DisplayType eq 'TicketNumberTitle' ) {
            $Descriptions{Normal} = "$Ticket{TicketNumber}: $Ticket{Title}";
            $Descriptions{Long}   = "$Ticket{TicketNumber}: $Ticket{Title}";
        }
    }
    else {

        # use ticket hook as default fallback
        my $ParamHook = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Hook')      || 'Ticket#';
        $ParamHook .= $Kernel::OM->Get('Kernel::Config')->Get('Ticket::HookDivider') || '';

        $Descriptions{Normal} = $ParamHook . "$Ticket{TicketNumber}";
        $Descriptions{Long}   = $ParamHook . "$Ticket{TicketNumber}: $Ticket{Title}";
    }

    my $Link;
    if ( $Param{Link} && $Param{LayoutObject}{SessionSource} ) {
        if ( $Param{LayoutObject}{SessionSource} eq 'AgentInterface' ) {

            # TODO: only show the link if the user $Param{UserID} has permissions
            $Link = $Param{LayoutObject}{Baselink} . "Action=AgentTicketZoom;TicketID=$Param{ObjectID}";
        }
    }

    # create description
    return (
        %Descriptions,
        Link => $Link,
    );
}

=head2 SearchObjects()

This is used in auto completion when searching for possible object IDs.

    my @ObjectIDs = $BackendObject->SearchObjects(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $ObjectID,                # (optional) if given, takes precedence over Term
        Term               => $Term,                    # (optional) defaults to wildcard search with empty string
        MaxResults         => $MaxResults,
        UserID             => $Self->{UserID},
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

    if ( $Param{ObjectID} ) {
        $SearchParams{TicketID} = $Param{ObjectID};
    }
    else {

        # include configured search param if present
        my $SearchAttribute
            = ( $Param{ExternalSource} ? $DynamicFieldConfig->{Config}{ImportSearchAttribute} : $DynamicFieldConfig->{Config}{SearchAttribute} ) || 'Title';

        $SearchParams{$SearchAttribute} = "*$Param{Term}*";
    }

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
    if ( IsArrayRefWithData( $DynamicFieldConfig->{Config}{ReferenceFilterList} ) ) {
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

    # Support restriction by ticket type when the Ticket::Type feature is activated.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    if ( $ConfigObject->Get('Ticket::Type') ) {
        if ( IsArrayRefWithData( $DynamicFieldConfig->{Config}{TicketType} ) ) {
            if ( $SearchParams{TypeIDs} || $SearchParams{Types} ) {
                my @TypeIDs;
                for my $TypeID ( $SearchParams{TypeIDs}->@* ) {
                    if ( any { $_ eq $TypeID } $DynamicFieldConfig->{Config}{TicketType}->@* ) {
                        push @TypeIDs, $TypeID;
                    }
                }

                TYPE:
                for my $Type ( $SearchParams{Types}->@* ) {
                    my $TypeID = $Kernel::OM->Get('Kernel::System::Type')->TypeLookup( Type => $Type );
                    next TYPE unless $TypeID;
                    if ( ( any { $_ eq $TypeID } $DynamicFieldConfig->{Config}{TicketType}->@* ) && ( none { $_ eq $TypeID } @TypeIDs ) ) {
                        push @TypeIDs, $TypeID;
                    }
                }

                return unless @TypeIDs;

                $SearchParams{TypeIDs} = \@TypeIDs;
                delete $SearchParams{Types};
            }
            else {
                $SearchParams{TypeIDs} = $DynamicFieldConfig->{Config}->{TicketType};
            }
        }
    }
    else {
        delete $SearchParams{TypeIDs};
        delete $SearchParams{Types};
    }

    # Support restriction by ticket type when the Ticket::Queue feature is activated.
    if ( IsArrayRefWithData( $DynamicFieldConfig->{Config}{Queue} ) ) {
        if ( $SearchParams{QueueIDs} || $SearchParams{Queues} ) {
            my @QueueIDs;
            for my $QueueID ( $SearchParams{QueueIDs}->@* ) {
                if ( any { $_ eq $QueueID } $DynamicFieldConfig->{Config}{Queue}->@* ) {
                    push @QueueIDs, $QueueID;
                }
            }

            QUEUE:
            for my $Queue ( $SearchParams{Queues}->@* ) {
                my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Queue );
                next QUEUE unless $QueueID;
                if ( ( any { $_ eq $QueueID } $DynamicFieldConfig->{Config}{Queue}->@* ) && ( none { $_ eq $QueueID } @QueueIDs ) ) {
                    push @QueueIDs, $QueueID;
                }
            }

            return unless @QueueIDs;

            $SearchParams{QueueIDs} = \@QueueIDs;
            delete $SearchParams{Queues};
        }
        else {
            $SearchParams{QueueIDs} = $DynamicFieldConfig->{Config}->{Queue};
        }
    }

    # return a list of ticket IDs
    return $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        Limit   => $Param{MaxResults},
        Result  => 'ARRAY',
        UserID  => 1,
        SortBy  => 'TicketNumber',
        OrderBy => 'Down',
        %SearchParams,
    );
}

1;
