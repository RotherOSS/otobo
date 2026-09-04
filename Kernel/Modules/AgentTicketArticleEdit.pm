# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Modules::AgentTicketArticleEdit;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

use parent qw( Kernel::Modules::AgentTicketActionCommon );

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # set ArticleEdit specific params
    $Self->{ArticleID} = $ParamObject->GetParam( Param => 'ArticleID' );

    if ( !$Self->{ArticleID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ArticleID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config       = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # prevent shenanigans
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID            => $Self->{TicketID},
        ArticleID           => $Self->{ArticleID},
        ShowDeletedArticles => 1,
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $Self->{TicketID},
        ArticleID => $Self->{ArticleID},
    );

    # show "no permission" error screen to give minimal info if TicketID and ArticleID do not match
    if ( !%Article ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
            WithHeader => 'yes',
        );
    }

    # check whether this article type is eligible for changing
    my $ChannelName   = $ArticleBackendObject->ChannelNameGet();
    my $ActionsConfig = $ConfigObject->Get("Ticket::Frontend::Article::Actions::$ChannelName");

    # NOTE sorting the keys enables overwriting existing items with packages
    my $ArticleActions = { map { $ActionsConfig->{$_}->%* } sort keys $ActionsConfig->%* };

    # call permission check of corresponding article action
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );
    my $ActionStrg = 'AgentTicketArticleEdit';
    if ( $Self->{Subaction} ) {
        if ( $Self->{Subaction} eq 'Delete' ) {
            $ActionStrg = 'AgentTicketArticleDelete';
        }
        elsif ( $Self->{Subaction} eq 'Restore' ) {
            $ActionStrg = 'AgentTicketArticleRestore';
        }
    }
    my $Access = $Kernel::OM->Get( 'Kernel::Output::HTML::ArticleAction::' . $ActionStrg )->CheckAccess(
        Ticket          => \%Ticket,
        Article         => \%Article,
        ChannelName     => $ChannelName,
        UserID          => $Self->{UserID},
        AclActionLookup => {
            $ActionStrg => 1,
        },
    );
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate('This action is not permitted on the article!'),
            WithHeader => 'yes',
        );
    }

    if ( $Self->{Subaction} eq 'ArticleDelete' ) {
        if ( !$ArticleActions->{'AgentTicketArticleDelete'} ) {
            return $LayoutObject->NoPermission(
                Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
                WithHeader => 'yes',
            );
        }

        return $Self->_ArticleDeletion(
            %Param,
            Config => $Config,
        );
    }

    elsif ( $Self->{Subaction} eq 'ArticleRestore' ) {
        if ( !$ArticleActions->{'AgentTicketArticleRestore'} ) {
            return $LayoutObject->NoPermission(
                Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
                WithHeader => 'yes',
            );
        }

        return $Self->_ArticleDeletion(
            %Param,
            Config  => $Config,
            Restore => 1,
        );
    }

    # else we are in normal edit mode
    elsif ( !$ArticleActions->{'AgentTicketArticleEdit'} ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
            WithHeader => 'yes',
        );
    }

    # check if calling this mask is allowed
    if (
        ( $Article{IsVisibleForCustomer} && !$Config->{ArticleCustomerVisible} )
        || ( $Article{SenderType} eq 'customer' && !$Config->{EditCustomerArticles} )
        )
    {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate('This article is not editable!'),
            WithHeader => 'yes',
        );
    }

    return $Self->SUPER::Run(%Param);
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ? 1 : 0;

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );

    # get config of frontend module
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # render ticket type dynamic fields
    my $TicketTypeDynamicFieldHTML = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
        Content              => $Self->{TicketMaskDefinition},
        DynamicFields        => $Self->{DynamicField},
        LayoutObject         => $LayoutObject,
        ParamObject          => $Kernel::OM->Get('Kernel::System::Web::Request'),
        DynamicFieldValues   => $Param{DynamicField},
        PossibleValuesFilter => $Param{DFPossibleValues},
        Errors               => $Param{DFErrors},
        Visibility           => $Param{Visibility},
        Object               => {
            CustomerID     => $Param{CustomerID},
            CustomerUserID => $Param{CustomerUserID},
            UserID         => $Self->{UserID},
            $Param{DynamicField}->%*,
        },
    );

    # Widget Ticket Actions
    if (
        ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} )
        ||
        ( $ConfigObject->Get('Ticket::Service') && $Config->{Service} )         ||
        ( $ConfigObject->Get('Ticket::Responsible') && $Config->{Responsible} ) ||
        $Config->{Title}                                                        ||
        $Config->{Queue}                                                        ||
        $Config->{Owner}                                                        ||
        $Config->{State}                                                        ||
        $Config->{Priority}                                                     ||
        any { $_->{ObjectType} eq 'Ticket' } values $Self->{DynamicField}->%*
        )
    {
        $LayoutObject->Block(
            Name => 'WidgetTicketActions',
            Data => {
                DynamicFieldHTML => $TicketTypeDynamicFieldHTML,
            },
        );
    }

    if ( $Config->{Title} ) {
        $LayoutObject->Block(
            Name => 'Title',
            Data => \%Param,
        );
    }

    if ( $Param{HideAutoselected} ) {

        # add Autoselect JS
        $LayoutObject->AddJSOnDocumentComplete(
            Code => "Core.Form.InitHideAutoselected({ FieldIDs: $Param{HideAutoselected} });",
        );
    }

    # types
    if ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} ) {
        my %Type = $TicketObject->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $LayoutObject->BuildSelection(
            Class        => 'Validate_Required Modernize FormUpdate ' . ( $Param{Errors}->{TypeIDInvalid} || '' ),
            Data         => \%Type,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 1,
        );
        $LayoutObject->Block(
            Name => 'Type',
            Data => {%Param},
        );
    }

    # services
    if ( $ConfigObject->Get('Ticket::Service') && $Config->{Service} ) {
        my $Services = $Self->_GetServices(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Ticket{CustomerUserID},
            UserID         => $Self->{UserID},
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !$Param{ServiceID} || !$Services->{ $Param{ServiceID} } ) {
            $Param{ServiceID} = '';
        }

        $Param{ServiceStrg} = $LayoutObject->BuildSelection(
            Data       => $Services,
            Name       => 'ServiceID',
            SelectedID => $Param{ServiceID},
            Class      => "Modernize FormUpdate "
                . ( $Config->{ServiceMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{ServiceInvalid} || '' ),
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => $TreeView,
            Max          => 200,
        );

        $LayoutObject->Block(
            Name => 'Service',
            Data => {
                ServiceMandatory => $Config->{ServiceMandatory} || 0,
                %Param,
            },
        );

        my %SLA = $TicketObject->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );

        $Param{SLAStrg} = $LayoutObject->BuildSelection(
            Data       => \%SLA,
            Name       => 'SLAID',
            SelectedID => $Param{SLAID},
            Class      => "Modernize FormUpdate "
                . ( $Config->{SLAMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{ServiceInvalid} || '' ),
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 1,
            Max          => 200,
        );

        $LayoutObject->Block(
            Name => 'SLA',
            Data => {
                SLAMandatory => $Config->{SLAMandatory},
                %Param,
            },
        );
    }

    if ( $Config->{Queue} ) {

        # fetch all queues
        my %MoveQueues = $TicketObject->TicketMoveList(
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
            Action   => $Self->{Action},
            Type     => 'move_into',
        );

        # set move queues
        $Param{QueuesStrg} = $LayoutObject->AgentQueueListOption(
            Data     => { %MoveQueues, '' => '-' },
            Multiple => 0,
            Size     => 0,
            Class    => 'NewQueueID Modernize FormUpdate '
                . ( $Config->{QueueMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewQueueInvalid} || '' ),
            Name           => 'NewQueueID',
            SelectedID     => $Param{NewQueueID},
            TreeView       => $TreeView,
            CurrentQueueID => $Param{QueueID},
            OnChangeSubmit => 0,
        );

        $LayoutObject->Block(
            Name => 'Queue',
            Data => {
                QueueMandatory => $Config->{QueueMandatory} || 0,
                %Param
            },
        );
    }

    # get needed objects
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my $UserObject  = $Kernel::OM->Get('Kernel::System::User');
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    if ( $Config->{Owner} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID        = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'owner',
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        my $ACL = $TicketObject->TicketAcl(
            %Ticket,
            Action        => $Self->{Action},
            ReturnType    => 'Ticket',
            ReturnSubType => 'NewOwner',
            Data          => \%ShownUsers,
            UserID        => $Self->{UserID},
        );

        if ($ACL) {
            %ShownUsers = $TicketObject->TicketAclData();
        }

        # get old owner
        my @OldUserInfo = $TicketObject->TicketOwnerList( TicketID => $Self->{TicketID} );
        my @OldOwners;
        my %OldOwnersShown;
        my %SeenOldOwner;
        if (@OldUserInfo) {
            my $Counter = 1;
            USER:
            for my $User ( reverse @OldUserInfo ) {

                # skip if old owner is already in the list
                next USER if $SeenOldOwner{ $User->{UserID} };
                $SeenOldOwner{ $User->{UserID} } = 1;
                my $Key   = $User->{UserID};
                my $Value = "$Counter: $User->{UserFullname}";
                push @OldOwners, {
                    Key   => $Key,
                    Value => $Value,
                };
                $OldOwnersShown{$Key} = $Value;
                $Counter++;
            }
        }

        my $OldOwnerSelectedID = '';
        if ( $Param{OldOwnerID} ) {
            $OldOwnerSelectedID = $Param{OldOwnerID};
        }
        elsif ( $OldUserInfo[0]->{UserID} ) {
            $OldOwnerSelectedID = $OldUserInfo[0]->{UserID} . '1';
        }

        my $OldOwnerACL = $TicketObject->TicketAcl(
            %Ticket,
            Action        => $Self->{Action},
            ReturnType    => 'Ticket',
            ReturnSubType => 'OldOwner',
            Data          => \%OldOwnersShown,
            UserID        => $Self->{UserID},
        );

        if ($OldOwnerACL) {
            %OldOwnersShown = $TicketObject->TicketAclData();
        }

        # build string
        $Param{OwnerStrg} = $LayoutObject->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => $Param{NewOwnerID},
            Name       => 'NewOwnerID',
            Class      => 'Modernize FormUpdate '
                . ( $Config->{OwnerMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewOwnerInvalid} || '' ),
            Size         => 1,
            PossibleNone => 1,
            Filters      => {
                OldOwners => {
                    Name   => $LayoutObject->{LanguageObject}->Translate('Previous Owner'),
                    Values => \%OldOwnersShown,
                },
            },
        );

        $LayoutObject->Block(
            Name => 'Owner',
            Data => {
                OwnerMandatory => $Config->{OwnerMandatory} || 0,
                %Param,
            },
        );
    }

    if ( $ConfigObject->Get('Ticket::Responsible') && $Config->{Responsible} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID        = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'responsible',
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        my $ACL = $TicketObject->TicketAcl(
            %Ticket,
            Action        => $Self->{Action},
            ReturnType    => 'Ticket',
            ReturnSubType => 'Responsible',
            Data          => \%ShownUsers,
            UserID        => $Self->{UserID},
        );

        if ($ACL) {
            %ShownUsers = $TicketObject->TicketAclData();
        }

        # get responsible
        $Param{ResponsibleStrg} = $LayoutObject->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => $Param{NewResponsibleID},
            Name       => 'NewResponsibleID',
            Class      => 'Modernize FormUpdate '
                . ( $Config->{ResponsibleMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewResponsibleInvalid} || '' ),
            PossibleNone => 1,
            Size         => 1,
        );
        $LayoutObject->Block(
            Name => 'Responsible',
            Data => {
                ResponsibleMandatory => $Config->{ResponsibleMandatory} || 0,
                %Param,
            },
        );

    }

    if ( $Config->{State} ) {

        my %State;
        my %StateList = $TicketObject->TicketStateList(
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );
        if ( !$Param{NewStateID} ) {
            if ( $Config->{StateDefault} ) {
                $State{SelectedValue} = $Config->{StateDefault};
            }
        }
        else {
            $State{SelectedID} = $Param{NewStateID};
        }

        # build next states string
        $Param{StateStrg} = $LayoutObject->BuildSelection(
            Data  => \%StateList,
            Name  => 'NewStateID',
            Class => 'Modernize FormUpdate '
                . ( $Config->{StateMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewStateInvalid} || '' ),
            PossibleNone => $Config->{StateDefault} ? 0 : 1,
            %State,
        );
        $LayoutObject->Block(
            Name => 'State',
            Data => {
                StateMandatory => $Config->{StateMandatory} || 0,
                %Param,
            },
        );

        if ( IsArrayRefWithData( $Config->{StateType} ) ) {

            STATETYPE:
            for my $StateType ( @{ $Config->{StateType} } ) {

                next STATETYPE if !$StateType;
                next STATETYPE if $StateType !~ /pending/i;

                # get used calendar
                my $Calendar = $TicketObject->TicketCalendarGet(
                    %Ticket,
                );

                my $QuickDateButtons = $Config->{QuickDateButtons} // $ConfigObject->Get('Ticket::Frontend::DefaultQuickDateButtons');

                $Param{DateString} = $LayoutObject->BuildDateSelection(
                    %Param,
                    Format           => 'DateInputFormatLong',
                    YearPeriodPast   => 0,
                    YearPeriodFuture => 5,
                    DiffTime         => $ConfigObject->Get('Ticket::Frontend::PendingDiffTime')
                        || 0,
                    Class                => $Param{DateInvalid} || ' ',
                    Validate             => 1,
                    ValidateDateInFuture => 1,
                    Calendar             => $Calendar,
                    QuickDateButtons     => $QuickDateButtons,
                );

                $LayoutObject->Block(
                    Name => 'StatePending',
                    Data => \%Param,
                );

                last STATETYPE;
            }
        }
    }

    # get priority
    if ( $Config->{Priority} ) {

        my %Priority;
        my %PriorityList = $TicketObject->TicketPriorityList(
            UserID   => $Self->{UserID},
            TicketID => $Self->{TicketID},
            Action   => $Self->{Action},
        );
        if ( !$Config->{PriorityDefault} ) {
            $PriorityList{''} = '-';
        }
        if ( !$Param{NewPriorityID} ) {
            if ( $Config->{PriorityDefault} ) {
                $Priority{SelectedValue} = $Config->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{NewPriorityID};
        }
        $Priority{SelectedID} ||= $Param{PriorityID};
        $Param{PriorityStrg} = $LayoutObject->BuildSelection(
            Data  => \%PriorityList,
            Name  => 'NewPriorityID',
            Class => 'Modernize FormUpdate',
            %Priority,
        );
        $LayoutObject->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # End Widget Ticket Actions

    # Widget Article
    my $ArticleEditingEnabled = 0;
    if ( $Config->{Article} ) {

        # if not given (e.g. in error case), fetch communication channel id by article id
        if ( !$Param{CommunicationChannelID} && $Self->{ArticleID} ) {
            my @BaseArticles = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
                TicketID  => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
            );
            if (@BaseArticles) {
                $Param{CommunicationChannelID} = $BaseArticles[0]->{CommunicationChannelID};
            }
        }

        my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
            ChannelID => $Param{CommunicationChannelID},
        );
        $ArticleEditingEnabled = $Self->_CheckArticleEditingEnabled(
            Article              => $Config->{Article},
            CommunicationChannel => $CommunicationChannel{ChannelName},
        );
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID  => $Self->{TicketID},
        ArticleID => $Self->{ArticleID},
    );
    my %ArticleData = $ArticleBackendObject->ArticleGet(
        TicketID  => $Self->{TicketID},
        ArticleID => $Self->{ArticleID},
    );

    if ($ArticleEditingEnabled) {
        $Param{WidgetStatus} = 'Expanded';

        $LayoutObject->Block(
            Name => 'WidgetArticle',
            Data => \%Param,
        );

        $Param{SubjectRequired} = 'Validate_Required';
        $Param{BodyRequired}    = 'Validate_Required';
    }

    # set customer visibility of this note to the same value as the article for whom this is the reply
    $Param{IsVisibleForCustomer} //= $ArticleData{IsVisibleForCustomer};
    if ( $Self->{ReplyToArticle} && !defined $Param{IsVisibleForCustomer} ) {
        $Param{IsVisibleForCustomer} = $Self->{ReplyToArticleContent}->{IsVisibleForCustomer};
    }
    elsif ( !defined $Param{IsVisibleForCustomer} ) {
        $Param{IsVisibleForCustomer} = $Config->{IsVisibleForCustomerDefault};
    }

    # show attachments
    if ($ArticleEditingEnabled) {
        ATTACHMENT:
        for my $Attachment ( @{ $Param{Attachments} } ) {
            if (
                $Attachment->{ContentID}
                && $LayoutObject->{BrowserRichText}
                && ( $Attachment->{ContentType} =~ /image/i )
                && ( $Attachment->{Disposition} eq 'inline' )
                )
            {
                next ATTACHMENT;
            }

            push @{ $Param{AttachmentList} }, $Attachment;
        }
    }

    # render article type dynamic fields
    $Param{DynamicFieldHTML} = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
        Content              => $Self->{ArticleMaskDefinition},
        DynamicFields        => $Self->{DynamicField},
        LayoutObject         => $LayoutObject,
        ParamObject          => $Kernel::OM->Get('Kernel::System::Web::Request'),
        DynamicFieldValues   => $Param{DynamicField},
        PossibleValuesFilter => $Param{DFPossibleValues},
        Errors               => $Param{DFErrors},
        Visibility           => $Param{Visibility},
        Object               => {
            CustomerID     => $Param{CustomerID},
            CustomerUserID => $Param{CustomerUserID},
            UserID         => $Self->{UserID},
            $Param{DynamicField}->%*,
        },
    );

    # get all user ids of agents, that can be shown in this dialog
    # based on queue rights
    my %ShownUsers;
    my %AllGroupsMembers = $UserObject->UserList(
        Type  => 'Long',
        Valid => 1,
    );
    my $GID        = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
    my %MemberList = $GroupObject->PermissionGroupGet(
        GroupID => $GID,
        Type    => 'note',
    );
    for my $UserID ( sort keys %MemberList ) {
        $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
    }

    # check and retrieve involved and informed agents of ReplyTo Note
    my @ReplyToUsers;
    my %ReplyToUsersHash;
    my %ReplyToUserIDs;
    if ( $Self->{ReplyToArticle} ) {

        # create email parser object
        my $EmailParserObject = Kernel::System::EmailParser->new();

        my @ReplyToParts = $EmailParserObject->SplitAddressLine(
            Line => $Self->{ReplyToArticleContent}->{To} || '',
        );

        REPLYTOPART:
        for my $SingleReplyToPart (@ReplyToParts) {
            my $ReplyToAddress = $EmailParserObject->GetEmailAddress(
                Email => $SingleReplyToPart,
            );

            next REPLYTOPART if !$ReplyToAddress;
            push @ReplyToUsers, $ReplyToAddress;
        }

        $ReplyToUsersHash{$_}++ for @ReplyToUsers;

        # get user ids of available users
        for my $UserID ( sort keys %ShownUsers ) {
            my %UserData = $UserObject->GetUserData(
                UserID => $UserID,
            );

            my $UserEmail = $UserData{UserEmail};
            if ( $ReplyToUsersHash{$UserEmail} ) {
                $ReplyToUserIDs{$UserID} = 1;
            }
        }

        # add original note sender to list of user ids
        for my $UserID ( sort @{ $Self->{ReplyToSenderUserID} } ) {

            # if sender replies to himself, do not include sender in list
            if ( $UserID ne $Self->{UserID} ) {
                $ReplyToUserIDs{$UserID} = 1;
            }
        }

        # remove user id of active user
        delete $ReplyToUserIDs{ $Self->{UserID} };
    }

    if ( $ArticleEditingEnabled && ( $Config->{InformAgent} || $Config->{InvolvedAgent} ) ) {
        $LayoutObject->Block(
            Name => 'InformAdditionalAgents',
        );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get all agents for "involved agents"
    if ( $ArticleEditingEnabled && $Config->{InvolvedAgent} ) {

        my @UserIDs = $TicketObject->TicketInvolvedAgentsList(
            TicketID => $Self->{TicketID},
        );

        my @InvolvedAgents;
        my $Counter = 1;

        my @InvolvedUserID = $ParamObject->GetArray( Param => 'InvolvedUserID' );

        my %AgentWithPermission = $GroupObject->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'ro',
        );

        USER:
        for my $User ( reverse @UserIDs ) {

            next USER if !defined $AgentWithPermission{ $User->{UserID} };

            my $Value = "$Counter: $User->{UserFullname}";
            if ( $User->{OutOfOfficeMessage} ) {
                $Value .= " $User->{OutOfOfficeMessage}";
            }

            push @InvolvedAgents, {
                Key   => $User->{UserID},
                Value => $Value,
            };
            $Counter++;

            # add involved user as selected entries, if available in ReplyToAddresses list
            if ( $Self->{ReplyToArticle} && $ReplyToUserIDs{ $User->{UserID} } ) {
                push @InvolvedUserID, $User->{UserID};
                delete $ReplyToUserIDs{ $User->{UserID} };
            }
        }

        my $InvolvedAgentSize = $ConfigObject->Get('Ticket::Frontend::InvolvedAgentMaxSize') || 3;
        $Param{InvolvedAgentStrg} = $LayoutObject->BuildSelection(
            Data       => \@InvolvedAgents,
            SelectedID => \@InvolvedUserID,
            Name       => 'InvolvedUserID',
            Class      => 'Modernize',
            Multiple   => 1,
            Size       => $InvolvedAgentSize,
        );

        # block is called below "inform agents"
    }

    # agent list
    if ( $ArticleEditingEnabled && $Config->{InformAgent} ) {

        # get inform user list
        my %InformAgents;
        my @InformUserID    = $ParamObject->GetArray( Param => 'InformUserID' );
        my %InformAgentList = $GroupObject->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'ro',
        );
        for my $UserID ( sort keys %InformAgentList ) {
            $InformAgents{$UserID} = $AllGroupsMembers{$UserID};
        }

        if ( $Self->{ReplyToArticle} ) {

            # get email address of all users and compare to replyto-addresses
            for my $UserID ( sort keys %InformAgents ) {
                if ( $ReplyToUserIDs{$UserID} ) {
                    push @InformUserID, $UserID;
                    delete $ReplyToUserIDs{$UserID};
                }
            }
        }

        my $InformAgentSize = $ConfigObject->Get('Ticket::Frontend::InformAgentMaxSize')
            || 3;
        $Param{OptionStrg} = $LayoutObject->BuildSelection(
            Data       => \%InformAgents,
            SelectedID => \@InformUserID,
            Name       => 'InformUserID',
            Class      => 'Modernize',
            Multiple   => 1,
            Size       => $InformAgentSize,
        );
        $LayoutObject->Block(
            Name => 'InformAgent',
            Data => \%Param,
        );
    }

    # get involved
    if ( $ArticleEditingEnabled && $Config->{InvolvedAgent} ) {

        $LayoutObject->Block(
            Name => 'InvolvedAgent',
            Data => \%Param,
        );
    }

    # show list of agents, that receive this note (ReplyToNote)
    # at least sender of original note and all recipients of the original note
    # that couldn't be selected with involved/inform agents
    if ( $Self->{ReplyToArticle} ) {

        my $UsersHashSize = keys %ReplyToUserIDs;
        my $Counter       = 0;
        $Param{UserListWithoutSelection} = join( ',', keys %ReplyToUserIDs );

        if ( $UsersHashSize > 0 ) {
            $LayoutObject->Block(
                Name => 'InformAgentsWithoutSelection',
                Data => \%Param,
            );

            for my $UserID ( sort keys %ReplyToUserIDs ) {
                $Counter++;

                my %UserData = $UserObject->GetUserData(
                    UserID => $UserID,
                );

                $LayoutObject->Block(
                    Name => 'InformAgentsWithoutSelectionSingleUser',
                    Data => \%UserData,
                );

                # output a separator (InformAgentsWithoutSelectionSingleUserSeparator),
                # if not last entry
                if ( $Counter < $UsersHashSize ) {
                    $LayoutObject->Block(
                        Name => 'InformAgentsWithoutSelectionSingleUserSeparator',
                        Data => \%UserData,
                    );
                }
            }
        }
    }

    if ($ArticleEditingEnabled) {
        $LayoutObject->Block(
            Name => 'Subject',
            Data => \%Param,
        );

        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );

        if ($ArticleEditingEnabled) {
            $LayoutObject->Block(
                Name => 'SubjectLabelMandatory',
            );
            $LayoutObject->Block(
                Name => 'RichTextLabelMandatory',
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'SubjectLabel',
            );
            $LayoutObject->Block(
                Name => 'RichTextLabel',
            );
        }

        $LayoutObject->Block(
            Name => 'Attachments',
            Data => \%Param,
        );
    }

    if ( $Config->{IsVisibleForCustomer} ) {
        $LayoutObject->Block(
            Name => 'IsVisibleForCustomer',
            Data => \%Param,
        );
    }

    # show time accounting box
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') && ( $Config->{TimeUnits} || $ArticleEditingEnabled ) ) {

        $LayoutObject->Block(
            Name => 'TimeUnitsWrapper',
            Data => \%Param,
        );

        if ( $ArticleEditingEnabled && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );

            $Param{TimeUnitsRequired} = 'Validate_Required';
        }
        else {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );

            $Param{TimeUnitsRequired} = ( $ArticleEditingEnabled && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') )
                ? 'Validate_DependingRequiredAND Validate_Depending_CreateArticle'
                : '';
        }
        $LayoutObject->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height defined for this screen
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;

        # set up rich text editor
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }

    # End Widget Article

    # explanatory message about asterisk
    if ( $ConfigObject->Get('Ticket::Frontend::AsteriskExplanation') ) {
        $LayoutObject->Block(
            Name => 'AsteriskExplanation',
        );
    }

    # get output back
    return $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => \%Param
    );
}

sub _ArticleDeletion {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => $Param{Config}{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Param{Config}{Permission} ),
            WithHeader => 'yes',
        );
    }

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ($ACL) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    $LayoutObject->ChallengeTokenCheck();

    my $Success;
    if ( $Param{Restore} ) {

        $Success = $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures')->ArticleRestore(
            ArticleID => $Self->{ArticleID},
            TicketID  => $Self->{TicketID},
            UserID    => $Self->{UserID},
            UserLogin => $Self->{UserLogin}
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Error trying to restore article id: ' . $Self->{ArticleID}
            );
        }
    }

    else {

        $Success = $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures')->ArticleDelete(
            ArticleID => $Self->{ArticleID},
            TicketID  => $Self->{TicketID},
            UserID    => $Self->{UserID},
            UserLogin => $Self->{UserLogin}
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Error trying to delete article id: ' . $Self->{ArticleID}
            );

            $TicketObject->_TicketCacheClear( TicketID => $Self->{TicketID} );
        }
    }

    # build JSON output
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Success
        },
    );

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _CheckArticleEditingEnabled {
    my ( $Self, %Param ) = @_;

    return unless $Param{CommunicationChannel};
    return unless $Param{Article};

    if ( $Param{CommunicationChannel} eq 'Phone' || $Param{CommunicationChannel} eq 'Internal' ) {
        if ( $Param{Article} eq 'Both' ) {
            return 1;
        }
        elsif ( $Param{Article} eq $Param{CommunicationChannel} ) {
            return 1;
        }
    }

    return 0;
}

1;
