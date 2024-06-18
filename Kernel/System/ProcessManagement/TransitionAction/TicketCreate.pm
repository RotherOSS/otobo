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

package Kernel::System::ProcessManagement::TransitionAction::TicketCreate;

use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::DateTime',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::ProcessManagement::TransitionAction::TicketCreate - A module to create a ticket

=head1 DESCRIPTION

All TicketCreate functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $TicketCreateObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::TransitionAction::TicketCreate');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 Params()

Returns the configuration params for this transition action module

    my @Params = $Object->Params();

Each element is a hash reference that describes the config parameter.
Currently only the keys I<Key>, I<Value> and I<Optional> are used.

=cut

sub Params {
    my ($Self) = @_;

    my @Params = (
        {
            Key   => 'Title',
            Value => 'A title (required)',
        },
        {
            Key   => 'CommunicationChannel',
            Value => 'Email|Phone|Internal (required)',
        },
        {
            Key      => 'From',
            Value    => 'agent@example.tld',
            Optional => 1,
        },
        {
            Key      => 'To',
            Value    => 'customer@example.tld',
            Optional => 1,
        },
        {
            Key   => 'Subject',
            Value => 'A subject (required)',
        },
        {
            Key   => 'Body',
            Value => 'A text for the article (required)',
        },
        {
            Key   => 'ContentType',
            Value => 'text/html; charset=utf-8 (required)',
        },
        {
            Key      => 'CustomerID',
            Value    => '12345',
            Optional => 1,
        },
        {
            Key      => 'CustomerUser',
            Value    => 'customer@example.tld',
            Optional => 1,
        },
        {
            Key   => 'IsVisibleForCustomer',
            Value => '0|1 (required)',
        },
        {
            Key      => 'DynamicField_<Name> (replace <Name>)',
            Value    => 'A value',
            Optional => 1,
        },
        {
            Key      => 'Attachments',
            Value    => '...',
            Optional => 1,
        },
        {
            Key   => 'State',
            Value => 'open (required)',
        },
        {
            Key   => 'Lock',
            Value => 'lock|unlock (required)',
        },
        {
            Key   => 'Owner',
            Value => 'ownerlogin (required)',
        },
        {
            Key   => 'Priority',
            Value => '3 normal (required)',
        },
        {
            Key   => 'Queue',
            Value => 'Misc (required)',
        },
        {
            Key      => 'Type',
            Value    => 'A type',
            Optional => 1,
        },
        {
            Key      => 'Service',
            Value    => 'ServiceName',
            Optional => 1,
        },
        {
            Key      => 'SLA',
            Value    => 'SLA-Name',
            Optional => 1,
        },
        {
            Key      => 'Responsible',
            Value    => 'responsiblelogin',
            Optional => 1,
        },
        {
            Key      => 'TimeUnit',
            Value    => '15',
            Optional => 1,
        },
        {
            Key   => 'HistoryType',
            Value => 'EmailCustomer|AddNote|WebRequestCustomer|... (required)',
        },
        {
            Key   => 'HistoryComment',
            Value => 'Article created (required)',
        },
        {
            Key   => 'SenderType',
            Value => 'agent|customer|system (required)',
        },
        {
            Key      => 'PendingTime',
            Value    => '2022-19-21 14:25:00',
            Optional => 1,
        },
        {
            Key      => 'PendingTimeDiff',
            Value    => 'diff in minutes',
            Optional => 1,
        },
        {
            Key      => 'LinkAs',
            Value    => 'Normal|Parent|Child|...',
            Optional => 1,
        },
        {
            Key      => 'ArchiveFlag',
            Value    => 'y|n',
            Optional => 1,
        },
        {
            Key      => 'UserID',
            Value    => '1 (can overwrite the logged in user)',
            Optional => 1,
        },
        {
            Key      => 'StoreTicketIDDynamicField',
            Value    => 'NameX (name of DynamicField holding the id of the created ticket in the original ticket)',
            Optional => 1,
        },
    );

    return @Params;
}

=head2 Run()

    Run Data

    my $TicketCreateResult = $TicketCreateActionObject->Run(
        UserID                   => 123,
        Ticket                   => \%Ticket,   # required
        ProcessEntityID          => 'P123',
        ActivityEntityID         => 'A123',
        TransitionEntityID       => 'T123',
        TransitionActionEntityID => 'TA123',
        Config                   => {
            # ticket required:
            Title         => 'Some Ticket Title',
            Queue         => 'Raw',              # or QueueID => 123,
            Lock          => 'unlock',
            Priority      => '3 normal',         # or PriorityID => 2,
            State         => 'new',              # or StateID => 5,
            CustomerID    => '123465',
            CustomerUser  => 'customer@example.com',
            Owner         => 'someuserlogin',    # or OwnerID => 123

            # ticket optional:
            TN              => $TicketObject->TicketCreateNumber(), # optional
            Type            => 'Incident',            # or TypeID => 1, not required
            Service         => 'Service A',           # or ServiceID => 1, not required
            SLA             => 'SLA A',               # or SLAID => 1, not required
            ResponsibleID   => 123,                   # not required
            ArchiveFlag     => 'y',                   # (y|n) not required
            PendingTime     => '2011-12-23 23:05:00', # optional (for pending states)
            PendingTimeDiff => 123 ,                  # optional (for pending states)

            # article required: (if one of them is not present, article will not be created without any error message)
            SenderType           => 'agent',                            # agent|system|customer
            IsVisibleForCustomer => 1,                                  # required
            CommunicationChannel => 'Internal',                         # Internal|Phone|Email|..., default: Internal

            %DataPayload,                                               # some parameters depending of each communication channel

            # article optional:
            TimeUnit => 123

            # other:
            DynamicField_NameX => $Value,
            LinkAs => $LinkType,                                        # Normal, Parent, Child, etc. (respective original ticket)
            UserID => 123,                                              # optional, to override the UserID from the logged user
        }
    );
    Ticket contains the result of TicketGet including DynamicFields
    Config is the Config Hash stored in a Process::TransitionAction's  Config key
    Returns:

    $TicketCreateResult = 1; # 0

    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # define a common message to output in case of any error
    my $CommonMessage = "Process: $Param{ProcessEntityID} Activity: $Param{ActivityEntityID}"
        . " Transition: $Param{TransitionEntityID}"
        . " TransitionAction: $Param{TransitionActionEntityID} - ";

    # check for missing or wrong params
    my $Success = $Self->_CheckParams(
        %Param,
        CommonMessage => $CommonMessage,
    );
    return if !$Success;

    # override UserID if specified as a parameter in the TA config
    $Param{UserID} = $Self->_OverrideUserID(%Param);

    # use ticket attributes if needed
    $Self->_ReplaceTicketAttributes(%Param);
    $Self->_ReplaceAdditionalAttributes(%Param);

    # convert scalar items into array references
    for my $Attribute (
        qw(ForceNotificationToUserID ExcludeNotificationToUserID
        ExcludeMuteNotificationToUserID
        )
        )
    {
        if ( IsStringWithData( $Param{Config}->{$Attribute} ) ) {
            $Param{Config}->{$Attribute} = $Self->_ConvertScalar2ArrayRef(
                Data => $Param{Config}->{$Attribute},
            );
        }
    }

    # collect ticket params
    my %TicketParam;
    for my $Attribute (
        qw( Title Queue QueueID Lock LockID Priority PriorityID State StateID
        CustomerID CustomerUser Owner OwnerID TN Type TypeID Service ServiceID SLA SLAID
        Responsible ResponsibleID ArchiveFlag
        )
        )
    {
        if ( defined $Param{Config}->{$Attribute} ) {
            $TicketParam{$Attribute} = $Param{Config}->{$Attribute};
        }
    }

    # get default values from system configuration
    for my $Attribute (qw(Queue State Lock Priority)) {

        if ( !$TicketParam{$Attribute} && !$TicketParam{ $Attribute . "ID" } ) {
            $TicketParam{$Attribute} = $Kernel::OM->Get('Kernel::Config')->Get("Process::Default$Attribute") || '';
        }
    }

    # Get OwnerID from Owner
    if ( $TicketParam{Owner} && !$TicketParam{OwnerID} ) {
        $TicketParam{OwnerID} = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TicketParam{Owner},
        );
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # create ticket
    my $TicketID = $TicketObject->TicketCreate(
        %TicketParam,
        UserID => $Param{UserID},
    );
    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage
                . "Couldn't create New Ticket from Ticket: "
                . $Param{Ticket}->{TicketID} . '!',
        );
        return;
    }

    # get state information
    my %StateData;
    if ( $TicketParam{StateID} ) {
        %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            ID => $TicketParam{StateID},
        );
    }
    else {
        %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
            Name => $TicketParam{State},
        );
    }

    # closed tickets get unlocked
    if ( $StateData{TypeName} =~ /^close/i ) {

        # set lock
        $TicketObject->TicketLockSet(
            TicketID => $TicketID,
            Lock     => 'unlock',
            UserID   => $Param{UserID},
        );
    }

    # set pending time
    elsif ( $StateData{TypeName} =~ /^pending/i ) {

        if ( $Param{Config}->{PendingTime} ) {

            # get datetime object
            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Param{Config}->{PendingTime}
                }
            );
            my $TimeStamp = $DateTimeObject->ToString();

            # set pending time
            $TicketObject->TicketPendingTimeSet(
                UserID   => $Param{UserID},
                TicketID => $TicketID,
                String   => $TimeStamp,
            );
        }
        elsif ( $Param{Config}->{PendingTimeDiff} ) {

            # set pending time
            $TicketObject->TicketPendingTimeSet(
                UserID   => $Param{UserID},
                TicketID => $TicketID,
                Diff     => $Param{Config}->{PendingTimeDiff},
            );
        }
    }

    $Param{Config}->{CommunicationChannel} ||= 'Internal';

    # check if article can be created
    my $ArticleCreate = 1;
    for my $Needed (qw(SenderType IsVisibleForCustomer)) {
        if ( !defined $Param{Config}->{$Needed} ) {
            $ArticleCreate = 0;
        }
    }

    my $ArticleID;

    if ($ArticleCreate) {

        # If "From" is not set and MIME based article is to be created.
        if (
            !$Param{Config}->{From}
            && $Param{Config}->{CommunicationChannel} =~ m{\AEmail|Internal|Phone\z}msxi
            )
        {

            # Get current user data.
            my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $Param{UserID},
            );

            # Set "From" field according to user - UserFullname <UserEmail>.
            $Param{Config}->{From} = $User{UserFullname} . ' <' . $User{UserEmail} . '>';
        }

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => $Param{Config}->{CommunicationChannel},
        );

        # Create article for the new ticket.
        $ArticleID = $ArticleBackendObject->ArticleCreate(
            %{ $Param{Config} },
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );

        if ( !$ArticleID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Couldn't create Article on Ticket: $TicketID from Ticket: "
                    . $Param{Ticket}->{TicketID} . '!',
            );
        }
        else {

            # set time units
            if ( $Param{Config}->{TimeUnit} ) {
                $TicketObject->TicketAccountTime(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    TimeUnit  => $Param{Config}->{TimeUnit},
                    UserID    => $Param{UserID},
                );
            }
        }
    }

    # set dynamic fields for ticket and article

    # set a field filter (all valid dynamic fields have to have set to 1 like NameX => 1)
    my %FieldFilter;
    for my $Attribute ( sort keys %{ $Param{Config} } ) {
        if ( $Attribute =~ m{\A DynamicField_ ( [a-zA-Z0-9\-]+ ) \z}msx ) {
            $FieldFilter{$1} = 1;
        }
    }

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get the dynamic fields for ticket
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => \%FieldFilter,
    );

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldList} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $ObjectID = $TicketID;
        if ( $DynamicFieldConfig->{ObjectType} ne 'Ticket' ) {

            # skip article dynamic fields if Article was not created
            next DYNAMICFIELD if !$ArticleCreate || !$ArticleID;

            $ObjectID = $ArticleID;
        }

        # set the value
        my $Success = $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $ObjectID,
            Value              => $Param{Config}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            UserID             => $Param{UserID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Couldn't set DynamicField Value on $DynamicFieldConfig->{ObjectType}:"
                    . " $ObjectID from Ticket: "
                    . $Param{Ticket}->{TicketID} . '!',
            );
            return;
        }
    }

    # store created ticket id
    if ( $Param{Config}->{StoreTicketIDDynamicField} ) {
        my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{Config}->{StoreTicketIDDynamicField},
        );

        if ( !$DynamicFieldConfig || !IsHashRefWithData($DynamicFieldConfig) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Couldn't get DynamicField $Param{Config}->{StoreTicketIDDynamicField} for Ticket $Param{Ticket}->{TicketID}."
            );

            return;
        }

        # set the value
        my $Success = $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{Ticket}->{TicketID},
            Value              => $TicketID,
            UserID             => $Param{UserID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Couldn't set DynamicField Value on $DynamicFieldConfig->{ObjectType}:"
                    . " for Ticket: $Param{Ticket}->{TicketID}!",
            );

            return;
        }
    }

    # link ticket
    if ( $Param{Config}->{LinkAs} ) {

        # get link object
        my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

        # get config of all types
        my %ConfiguredTypes = $LinkObject->TypeList(
            UserID => 1,
        );

        my $SelectedType;
        my $SelectedDirection;

        TYPE:
        for my $Type ( sort keys %ConfiguredTypes ) {
            if (
                $Param{Config}->{LinkAs} ne $ConfiguredTypes{$Type}->{SourceName}
                && $Param{Config}->{LinkAs} ne $ConfiguredTypes{$Type}->{TargetName}
                )
            {
                next TYPE;
            }
            $SelectedType      = $Type;
            $SelectedDirection = 'Source';
            if ( $Param{Config}->{LinkAs} eq $ConfiguredTypes{$Type}->{TargetName} ) {
                $SelectedDirection = 'Target';
            }
            last TYPE;
        }

        if ( !$SelectedType ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "LinkAs $Param{Config}->{LinkAs} is invalid!"
            );
            return;
        }

        my $SourceObjectID = $TicketID;
        my $TargetObjectID = $Param{Ticket}->{TicketID};
        if ( $SelectedDirection eq 'Target' ) {
            $SourceObjectID = $Param{Ticket}->{TicketID};
            $TargetObjectID = $TicketID;
        }

        my $Success = $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $SourceObjectID,
            TargetObject => 'Ticket',
            TargetKey    => $TargetObjectID,
            Type         => $SelectedType,
            State        => 'Valid',
            UserID       => $Param{UserID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $CommonMessage
                    . "Couldn't Link Tickets $SourceObjectID with $TargetObjectID as $Param{Config}->{LinkAs}!",
            );
            return;
        }
    }

    return 1;
}

1;
