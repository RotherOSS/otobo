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

package Kernel::Modules::AgentTicketActionCommon;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules
use Kernel::System::EmailParser   ();
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {%Param}, $Type;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Try to load draft if requested.
    if (
        $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}")->{FormDraft}
        && $ParamObject->GetParam( Param => 'LoadFormDraft' )
        && $ParamObject->GetParam( Param => 'FormDraftID' )
        )
    {
        $Self->{LoadedFormDraftID} = $ParamObject->LoadFormDraft(
            FormDraftID => $ParamObject->GetParam( Param => 'FormDraftID' ),
            UserID      => $Self->{UserID},
        );
    }

    # get article for whom this should be a reply, if available
    my $ReplyToArticle = $ParamObject->GetParam( Param => 'ReplyToArticle' ) || '';
    my $TicketID       = $ParamObject->GetParam( Param => 'TicketID' )       || '';

    # check if ReplyToArticle really belongs to the ticket
    my %ReplyToArticleContent;
    if ($ReplyToArticle) {

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
            TicketID  => $TicketID,
            ArticleID => $ReplyToArticle,
        );
        %ReplyToArticleContent = $ArticleBackendObject->ArticleGet(
            TicketID      => $TicketID,
            ArticleID     => $ReplyToArticle,
            DynamicFields => 0,
            UserID        => $Self->{UserID}
        );

        $Self->{ReplyToArticle}        = $ReplyToArticle;
        $Self->{ReplyToArticleContent} = \%ReplyToArticleContent;

        # get sender of original note (to inform sender about answer)
        if ( $ReplyToArticleContent{CreateBy} ) {
            my @ReplyToSenderID = ( $ReplyToArticleContent{CreateBy} );
            $Self->{ReplyToSenderUserID} = \@ReplyToSenderID;
        }

        # if article belongs to other ticket, don't use it as reply
        if ( $ReplyToArticleContent{TicketID} ne $Self->{TicketID} ) {
            $Self->{ReplyToArticle} = "";
        }

        # if article is not of type note-internal, don't use it as reply
        if (
            $ArticleBackendObject->ChannelNameGet() ne 'Internal'
            || (
                $ArticleBackendObject->ChannelNameGet() eq 'Internal'
                && $ReplyToArticleContent{SenderType} ne 'agent'
            )
            )
        {
            $Self->{ReplyToArticle} = "";
        }
    }

    # frontend specific config
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get the dynamic fields for this screen
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid => 1,

        # only screens that add notes can modify Article dynamic fields
        ObjectType  => $Config->{Note} ? [ 'Ticket', 'Article' ] : ['Ticket'],
        FieldFilter => $Config->{DynamicField} || {},
    );

    my $TicketDefinition = $Kernel::OM->Get('Kernel::System::Ticket::Mask')->DefinitionGet(
        Mask => $Self->{Action},
    ) || {};

    # definitions are splitted up because article is rendered separately
    $Self->{TicketMaskDefinition}  = $TicketDefinition->{Mask};
    $Self->{ArticleMaskDefinition} = [];
    $Self->{DynamicField}          = {};

    # align sysconfig and ticket mask data I
    for my $DynamicField ( @{ $DynamicFieldList // [] } ) {

        # separate ticket and article type dynamic fields
        if ( $DynamicField->{ObjectType} eq 'Ticket' ) {
            if ( exists $TicketDefinition->{DynamicFields}{ $DynamicField->{Name} } ) {
                my $Parameters = delete $TicketDefinition->{DynamicFields}{ $DynamicField->{Name} } // {};

                for my $Attribute ( keys $Parameters->%* ) {
                    $DynamicField->{$Attribute} = $Parameters->{$Attribute};
                }
            }
            else {
                push $Self->{TicketMaskDefinition}->@*, {
                    DF        => $DynamicField->{Name},
                    Mandatory => $Config->{DynamicField}{ $DynamicField->{Name} } == 2 ? 1 : 0,
                };

                if ( $Config->{DynamicField}{ $DynamicField->{Name} } == 2 ) {
                    $DynamicField->{Mandatory} = 1;
                }
            }
        }
        else {
            push $Self->{ArticleMaskDefinition}->@*, {
                DF        => $DynamicField->{Name},
                Mandatory => $Config->{DynamicField}{ $DynamicField->{Name} } == 2 ? 1 : 0,
            };

            if ( $Config->{DynamicField}{ $DynamicField->{Name} } == 2 ) {
                $DynamicField->{Mandatory} = 1;
            }
        }

        $Self->{DynamicField}{ $DynamicField->{Name} } = $DynamicField;
    }

    # align sysconfig and ticket mask data II
    for my $DynamicFieldName ( keys $TicketDefinition->{DynamicFields}->%* ) {
        $Self->{DynamicField}{$DynamicFieldName} = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicFieldName,
        );

        my $Parameters = $TicketDefinition->{DynamicFields}{$DynamicFieldName} // {};

        for my $Attribute ( keys $Parameters->%* ) {
            $Self->{DynamicField}{$DynamicFieldName}{$Attribute} = $Parameters->{$Attribute};
        }
    }

    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::FormCache')->PrepareFormID(
        ParamObject  => $ParamObject,
        LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
    );

    # methods which are used to determine the possible values of the standard fields
    $Self->{FieldMethods} = [
        {
            FieldID => 'Dest',
            Method  => \&_GetQueues
        },
        {
            FieldID => 'NewUserID',
            Method  => \&_GetOwners
        },
        {
            FieldID => 'NewResponsibleID',
            Method  => \&_GetResponsible
        },
        {
            FieldID => 'NextStateID',
            Method  => \&_GetNextStates
        },
        {
            FieldID => 'PriorityID',
            Method  => \&_GetPriorities
        },
        {
            FieldID => 'ServiceID',
            Method  => \&_GetServices
        },
        {
            FieldID => 'SLAID',
            Method  => \&_GetSLAs
        },
        {
            FieldID => 'StandardTemplateID',
            Method  => \&_GetStandardTemplates
        },
        {
            FieldID => 'TypeID',
            Method  => \&_GetTypes
        },
    ];

    # dependancies of standard fields which are not defined via ACLs
    $Self->{InternalDependancy} = {
        Dest => {
            NewUserID          => 1,
            NewResponsibleID   => 1,
            StandardTemplateID => 1,
        },
        ServiceID => {
            SLAID     => 1,
            ServiceID => 1,    #CustomerUser updates can be submitted as ElementChanged: ServiceID
        },
        CustomerUser => {
            ServiceID => 1,
        },
        OwnerAll => {
            NewUserID => 1,
        },
        ResponsibleAll => {
            NewResponsibleID => 1,
        },
    };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $LayoutObject            = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject            = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject             = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $FieldRestrictionsObject = $Kernel::OM->Get('Kernel::System::Ticket::FieldRestrictions');
    my $ArticleObject           = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get config of frontend module
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => $Config->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
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

    # Check for failed draft loading request.
    if (
        $ParamObject->GetParam( Param => 'LoadFormDraft' )
        && !$Self->{LoadedFormDraftID}
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Loading draft failed!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    my $LoadedFormDraft;
    if ( $Self->{LoadedFormDraftID} ) {
        $LoadedFormDraft = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftGet(
            FormDraftID => $Self->{LoadedFormDraftID},
            GetContent  => 0,
            UserID      => $Self->{UserID},
        );

        my @Articles = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
            TicketID => $Self->{TicketID},
            OnlyLast => 1,
        );

        if (@Articles) {
            my $LastArticle = $Articles[0];

            my $LastArticleSystemTime;
            if ( $LastArticle->{CreateTime} ) {
                my $LastArticleSystemTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $LastArticle->{CreateTime},
                    },
                );
                $LastArticleSystemTime = $LastArticleSystemTimeObject->ToEpoch();
            }

            my $FormDraftSystemTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $LoadedFormDraft->{ChangeTime},
                },
            );
            my $FormDraftSystemTime = $FormDraftSystemTimeObject->ToEpoch();

            if ( !$LastArticleSystemTime || $FormDraftSystemTime <= $LastArticleSystemTime ) {
                $Param{FormDraftOutdated} = 1;
            }
        }
    }

    if ( IsHashRefWithData($LoadedFormDraft) ) {

        $LoadedFormDraft->{ChangeByName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
            UserID => $LoadedFormDraft->{ChangeBy},
        );
    }

    my %GetParam;
    my @ArticleAttachments;
    my %ArticleData;

    # if we are editing an article
    if ( $Self->{ArticleID} && !$Self->{Subaction} ) {

        my %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );

        my $ArticleBackendObject = $ArticleObject->BackendForArticle(
            TicketID            => $Self->{TicketID},
            ArticleID           => $Self->{ArticleID},
            ShowDeletedArticles => 1
        );

        %ArticleData = $ArticleBackendObject->ArticleGet(
            TicketID      => $Self->{TicketID},
            ArticleID     => $Self->{ArticleID},
            DynamicFields => 1,
            RealNames     => 1,
            UserID        => $Self->{UserID}
        );

        if ( keys %ArticleData ) {
            @ArticleAttachments = $Self->_CopyArticleAttachmentsToUploadCache(
                ArticleID => $Self->{ArticleID}
            );

            %GetParam = $Self->_LoadArticleEdit(
                ArticleData          => \%ArticleData,
                Ticket               => \%Ticket,
                ArticleBackendObject => $ArticleBackendObject
            );
        }
    }

    $LayoutObject->Block(
        Name => 'Properties',
        Data => {
            FormDraft      => $Config->{FormDraft},
            FormDraftID    => $Self->{LoadedFormDraftID},
            FormDraftTitle => $LoadedFormDraft ? $LoadedFormDraft->{Title} : '',
            FormDraftMeta  => $LoadedFormDraft,
            FormID         => $Self->{FormID},
            ReplyToArticle => $Self->{ReplyToArticle},
            ArticleID      => $Self->{ArticleID} || '',
            %Ticket,
            %Param,
        },
    );

    # show right header
    $LayoutObject->Block(
        Name => 'Header' . $Self->{Action},
        Data => {
            %Ticket,
            ArticleTitle => $GetParam{Subject},
        },
    );

    # get lock state
    if ( $Config->{RequiredLock} ) {
        if ( !$TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {

            my $Lock = $TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );

            if ($Lock) {

                # Set new owner if ticket owner is different then logged user.
                if ( $Ticket{OwnerID} != $Self->{UserID} ) {

                    # Remember previous owner, which will be used to restore ticket owner on undo action.
                    $Param{PreviousOwner} = $Ticket{OwnerID};

                    $TicketObject->TicketOwnerSet(
                        TicketID  => $Self->{TicketID},
                        UserID    => $Self->{UserID},
                        NewUserID => $Self->{UserID},
                    );
                }

                # Show lock state.
                $LayoutObject->Block(
                    Name => 'PropertiesLock',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
        else {
            my $AccessOk = $TicketObject->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );

            if ( !$AccessOk ) {
                return join '',
                    $LayoutObject->Header(
                        Type      => 'Small',
                        Value     => $Ticket{Number},
                        BodyClass => 'Popup',
                    ),
                    $LayoutObject->Warning(
                        Message => Translatable('Sorry, you need to be the ticket owner to perform this action.'),
                        Comment => Translatable('Please change the owner first.'),
                    ),
                    $LayoutObject->Footer(
                        Type => 'Small',
                    );
            }

            # show back link when the owner check was ok
            $LayoutObject->Block(
                Name => 'TicketBack',
                Data => {
                    %Param,
                    TicketID => $Self->{TicketID},
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'TicketBack',
            Data => {
                %Param,
                %Ticket,
            },
        );
    }

    # get params
    PARAMETER:
    for my $Key (
        qw(
            NewStateID NewPriorityID TimeUnits IsVisibleForCustomer Title Body Subject NewQueueID
            Year Month Day Hour Minute NewOwnerID NewResponsibleID TypeID ServiceID SLAID
            ReplyToArticle StandardTemplateID CreateArticle FormDraftID Title
        )
        )
    {

        next PARAMETER if $Self->{ArticleID} && !$Self->{Subaction} && ( $Key eq 'Body' || $Key eq 'Subject' );

        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam = (
        StateID       => $GetParam{NewStateID},
        PriorityID    => $GetParam{NewPriorityID},
        QueueID       => $GetParam{NewQueueID},
        OwnerID       => $GetParam{NewOwnerID},
        ResponsibleID => $GetParam{NewResponsibleID},
    );

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # extract the dynamic field value from the web request
    my %DynamicFieldValues;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
        next DYNAMICFIELD unless IsHashRefWithData($DynamicFieldConfig);

        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
        );
    }

    # convert dynamic field values into a structure for ACLs
    {
        my %DynamicFieldACLParameters;
        DYNAMICFIELD:
        for my $DynamicFieldItem ( sort keys %DynamicFieldValues ) {
            next DYNAMICFIELD unless $DynamicFieldItem;
            next DYNAMICFIELD unless defined $DynamicFieldValues{$DynamicFieldItem};

            $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicFieldItem } = $DynamicFieldValues{$DynamicFieldItem};
        }
        $GetParam{DynamicField} = \%DynamicFieldACLParameters;
    }

    # transform pending time, time stamp based on user time zone
    if (
        defined $GetParam{Year}
        && defined $GetParam{Month}
        && defined $GetParam{Day}
        && defined $GetParam{Hour}
        && defined $GetParam{Minute}
        )
    {
        %GetParam = $LayoutObject->TransformDateSelection(
            %GetParam,
        );
    }

    # rewrap body if no rich text is used
    if ( $GetParam{Body} && !$LayoutObject->{BrowserRichText} ) {
        $GetParam{Body} = $LayoutObject->WrapPlainText(
            MaxCharacters => $ConfigObject->Get('Ticket::Frontend::TextAreaNote'),
            PlainText     => $GetParam{Body},
        );
    }

    # get upload cache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    if (
        $Self->{Subaction} eq 'Store'
        ||
        $Self->{LoadedFormDraftID}
        )
    {

        # challenge token check for write action
        if ( $Self->{Subaction} eq 'Store' ) {
            $LayoutObject->ChallengeTokenCheck();
        }

        $GetParam{IsVisibleForCustomer} //= 0;

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # Get and validate draft action.
        my $FormDraftAction = $ParamObject->GetParam( Param => 'FormDraftAction' );
        if ( $FormDraftAction && !$Config->{FormDraft} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('FormDraft functionality disabled!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        my %FormDraftResponse;

        # Check draft name.
        if (
            $FormDraftAction
            &&
            ( $FormDraftAction eq 'Add' || $FormDraftAction eq 'Update' )
            )
        {
            my $Title = $ParamObject->GetParam( Param => 'FormDraftTitle' );

            # A draft name is required.
            if ( !$Title ) {

                %FormDraftResponse = (
                    Success      => 0,
                    ErrorMessage => $Kernel::OM->Get('Kernel::Language')->Translate("Draft name is required!"),
                );
            }

            # Chosen draft name must be unique.
            else {
                my $FormDraftList = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftListGet(
                    ObjectType => 'Ticket',
                    ObjectID   => $Self->{TicketID},
                    Action     => $Self->{Action},
                    UserID     => $Self->{UserID},
                );
                DRAFT:
                for my $FormDraft ( @{$FormDraftList} ) {

                    # No existing draft with same name.
                    next DRAFT if $Title ne $FormDraft->{Title};

                    # Same name for update on existing draft.
                    if (
                        $GetParam{FormDraftID}
                        && $FormDraftAction eq 'Update'
                        && $GetParam{FormDraftID} eq $FormDraft->{FormDraftID}
                        )
                    {
                        next DRAFT;
                    }

                    # Another draft with the chosen name already exists.
                    %FormDraftResponse = (
                        Success      => 0,
                        ErrorMessage => $Kernel::OM->Get('Kernel::Language')->Translate( "FormDraft name %s is already in use!", $Title ),
                    );

                    last DRAFT;
                }
            }
        }

        # Perform draft action instead of saving form data in ticket/article.
        if ( $FormDraftAction && !%FormDraftResponse ) {

            # Reset FormDraftID to prevent updating existing draft.
            if ( $FormDraftAction eq 'Add' && $GetParam{FormDraftID} ) {

                # meddling with the innards of Kernel::System::Web::Request
                $ParamObject->SetArray(
                    Param  => 'FormDraftID',
                    Values => ['']
                );
            }

            my $FormDraftActionOk;
            if (
                $FormDraftAction eq 'Add'
                ||
                ( $FormDraftAction eq 'Update' && $GetParam{FormDraftID} )
                )
            {
                $FormDraftActionOk = $ParamObject->SaveFormDraft(
                    UserID         => $Self->{UserID},
                    ObjectType     => 'Ticket',
                    ObjectID       => $Self->{TicketID},
                    OverrideParams => {
                        ReplyToArticle => undef,
                    },
                );
            }

            if ($FormDraftActionOk) {
                $FormDraftResponse{Success} = 1;
            }
            else {
                %FormDraftResponse = (
                    Success      => 0,
                    ErrorMessage => 'Could not perform requested draft action!',
                );
            }
        }

        # Return JSON when there already is a response
        if (%FormDraftResponse) {
            return $LayoutObject->JSONReply(
                Data => \%FormDraftResponse
            );
        }

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        # store action
        my %Error;

        # check pending time
        if ( $GetParam{NewStateID} ) {
            my %StateData = $StateObject->StateGet(
                ID => $GetParam{NewStateID},
            );

            # check state type
            if ( $StateData{TypeName} =~ /^pending/i ) {

                # check needed stuff
                for my $Needed (qw(Year Month Day Hour Minute)) {
                    if ( !defined $GetParam{$Needed} ) {
                        $Error{'DateInvalid'} = 'ServerError';
                    }
                }

                # create datetime object
                my $PendingDateTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        %GetParam,
                        Second => 0,
                    },
                );

                # get current system epoch
                my $CurSystemDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

                # check date
                if (
                    !$PendingDateTimeObject
                    || $PendingDateTimeObject < $CurSystemDateTimeObject
                    )
                {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }
        }

        if ( $Config->{Note} && $Config->{NoteMandatory} ) {

            # check subject
            if ( !$GetParam{Subject} ) {
                $Error{'SubjectInvalid'} = 'ServerError';
            }

            # check body
            if ( !$GetParam{Body} ) {
                $Error{'BodyInvalid'} = 'ServerError';
            }
        }

        # check owner
        if ( $Config->{Owner} && $Config->{OwnerMandatory} ) {
            if ( !$GetParam{NewOwnerID} ) {
                $Error{'NewOwnerInvalid'} = 'ServerError';
            }
        }

        # check responsible
        if ( $Config->{Responsible} && $Config->{ResponsibleMandatory} ) {
            if ( !$GetParam{NewResponsibleID} ) {
                $Error{'NewResponsibleInvalid'} = 'ServerError';
            }
        }

        # check title
        if ( $Config->{Title} && !$GetParam{Title} ) {
            $Error{'TitleInvalid'} = 'ServerError';
        }

        # check type
        if (
            ( $ConfigObject->Get('Ticket::Type') )
            &&
            ( $Config->{TicketType} ) &&
            ( !$GetParam{TypeID} )
            )
        {
            $Error{'TypeIDInvalid'} = ' ServerError';
        }

        # check service
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{Service}
            && $GetParam{SLAID}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'ServiceInvalid'} = ' ServerError';
        }

        # check mandatory service
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{Service}
            && $Config->{ServiceMandatory}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'ServiceInvalid'} = ' ServerError';
        }

        # check mandatory sla
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{Service}
            && $Config->{SLAMandatory}
            && !$GetParam{SLAID}
            )
        {
            $Error{'SLAInvalid'} = ' ServerError';
        }

        # check mandatory queue
        if ( $Config->{Queue} && $Config->{QueueMandatory} ) {
            if ( !$GetParam{NewQueueID} ) {
                $Error{'NewQueueInvalid'} = 'ServerError';
            }
        }

        # check mandatory state
        if ( $Config->{State} && $Config->{StateMandatory} ) {
            if ( !$GetParam{NewStateID} ) {
                $Error{'NewStateInvalid'} = 'ServerError';
            }
        }

        # check time units, but only if the current screen has a note
        #   (accounted time can only be stored if and article is generated)
        if (
            $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{CreateArticle}
            && $GetParam{TimeUnits} eq ''
            )
        {
            $Error{'TimeUnitsInvalid'} = ' ServerError';
        }

        # skip validation of hidden fields
        my %Visibility;

        # transform dynamic field data into DFName => DFName pair
        my %DynamicFieldAcl = map { $_ => $_ } keys $Self->{DynamicField}->%*;

        # call ticket ACLs for DynamicFields to check field visibility
        my $ACLResult = $TicketObject->TicketAcl(
            %GetParam,
            Action        => $Self->{Action},
            ReturnType    => 'Form',
            ReturnSubType => '-',
            Data          => \%DynamicFieldAcl,
            UserID        => $Self->{UserID},
            TicketID      => $Self->{TicketID},
        );
        if ($ACLResult) {
            %Visibility = map { 'DynamicField_' . $_ => 0 } keys $Self->{DynamicField}->%*;
            my %AclData = $TicketObject->TicketAclData();
            for my $Field ( sort keys %AclData ) {
                $Visibility{ 'DynamicField_' . $Field } = 1;
            }
        }
        else {
            %Visibility = map { 'DynamicField_' . $_ => 1 } keys $Self->{DynamicField}->%*;
        }

        # remember dynamic field validation results if erroneous
        my %DynamicFieldValidationResult;
        my %DynamicFieldPossibleValues;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,

                    # TODO also pass object here?
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        %GetParam,
                        Action        => $Self->{Action},
                        TicketID      => $Self->{TicketID},
                        ReturnType    => 'Ticket',
                        ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data          => \%AclData,
                        UserID        => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $TicketObject->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            $DynamicFieldPossibleValues{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $PossibleValuesFilter;

            # Do not validate only if object type is Article and CreateArticle value is not defined, or Field is invisible.
            if (
                !( $DynamicFieldConfig->{ObjectType} eq 'Article' && !$GetParam{CreateArticle} )
                && $Visibility{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                )
            {

                my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $ParamObject,

                    # Mandatory is added to the configs by $Self->new
                    Mandatory => $DynamicFieldConfig->{Mandatory},
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    return $LayoutObject->ErrorScreen(
                        Message =>
                            $LayoutObject->{LanguageObject}->Translate(
                                'Could not perform validation on field %s!', $DynamicFieldConfig->{Label}
                            ),
                        Comment => Translatable('Please contact the administrator.'),
                    );
                }

                # Propagate validation error to the Error variable to be detected by the frontend.
                if ( $ValidationResult->{ServerError} )
                {
                    $Error{ $DynamicFieldConfig->{Name} }                        = ' ServerError';
                    $DynamicFieldValidationResult{ $DynamicFieldConfig->{Name} } = $ValidationResult;
                }
            }
        }

        # Make sure we don't save form if a draft was loaded.
        if ( $Self->{LoadedFormDraftID} ) {
            %Error = ( LoadedFormDraft => 1 );
        }

        # check errors
        if (%Error) {
            return join '',
                $LayoutObject->Header(
                    Type      => 'Small',
                    Value     => $Ticket{TicketNumber},
                    BodyClass => 'Popup',
                ),
                $Self->_Mask(
                    Attachments => \@Attachments,
                    %Ticket,
                    %GetParam,
                    %Error,
                    Visibility       => \%Visibility,
                    DFPossibleValues => \%DynamicFieldPossibleValues,
                    DFErrors         => \%DynamicFieldValidationResult,
                ),
                $LayoutObject->Footer(
                    Type => 'Small',
                );
        }

        # set new title
        if ( $Config->{Title} ) {
            if ( defined $GetParam{Title} ) {
                $TicketObject->TicketTitleUpdate(
                    Title    => $GetParam{Title},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new type
        if ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} ) {
            if ( $GetParam{TypeID} ) {
                $TicketObject->TicketTypeSet(
                    Action   => $Self->{Action},
                    TypeID   => $GetParam{TypeID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new service
        if ( $ConfigObject->Get('Ticket::Service') && $Config->{Service} ) {
            if ( defined $GetParam{ServiceID} ) {
                $TicketObject->TicketServiceSet(
                    %GetParam,
                    %ACLCompatGetParam,
                    Action         => $Self->{Action},
                    ServiceID      => $GetParam{ServiceID},
                    TicketID       => $Self->{TicketID},
                    CustomerUserID => $Ticket{CustomerUserID},
                    UserID         => $Self->{UserID},
                );
            }
            if ( defined $GetParam{SLAID} ) {
                $TicketObject->TicketSLASet(
                    %GetParam,
                    %ACLCompatGetParam,
                    Action   => $Self->{Action},
                    SLAID    => $GetParam{SLAID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        my $UnlockOnAway = 1;

        # move ticket to a new queue, but only if the queue was changed
        if (
            $Config->{Queue}
            && $GetParam{NewQueueID}
            && $GetParam{NewQueueID} ne $Ticket{QueueID}
            )
        {

            # move ticket (send notification if no new owner is selected)
            my $BodyAsText = '';
            if ( $LayoutObject->{BrowserRichText} ) {
                $BodyAsText = $LayoutObject->RichText2Ascii(
                    String => $GetParam{Body} || 0,
                );
            }
            else {
                $BodyAsText = $GetParam{Body} || 0;
            }
            my $Move = $TicketObject->TicketQueueSet(
                QueueID            => $GetParam{NewQueueID},
                UserID             => $Self->{UserID},
                TicketID           => $Self->{TicketID},
                SendNoNotification => $GetParam{NewUserID},
                Comment            => $BodyAsText,
                Action             => $Self->{Action},
            );
            if ( !$Move ) {
                return $LayoutObject->ErrorScreen();
            }
        }

        # set new owner
        my @NotifyDone;
        if ( $Config->{Owner} ) {
            my $BodyText = $LayoutObject->RichText2Ascii(
                String => $GetParam{Body} || '',
            );
            if ( $GetParam{NewOwnerID} ) {
                $TicketObject->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
                my $Success = $TicketObject->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewOwnerID},
                    Comment   => $BodyText,
                );
                $UnlockOnAway = 0;

                # remember to not notify owner twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewOwnerID};
                }
            }
        }

        # set new responsible
        if ( $ConfigObject->Get('Ticket::Responsible') && $Config->{Responsible} ) {
            if ( $GetParam{NewResponsibleID} ) {
                my $BodyText = $LayoutObject->RichText2Ascii(
                    String => $GetParam{Body} || '',
                );
                my $Success = $TicketObject->TicketResponsibleSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewResponsibleID},
                    Comment   => $BodyText,
                );

                # remember to not notify responsible twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewResponsibleID};
                }
            }
        }

        # add note
        my $ArticleID = '';
        my $ReturnURL;

        # set priority
        if ( $Config->{Priority} && $GetParam{NewPriorityID} ) {
            $TicketObject->TicketPrioritySet(
                TicketID   => $Self->{TicketID},
                PriorityID => $GetParam{NewPriorityID},
                UserID     => $Self->{UserID},
            );
        }

        # set state
        if ( $Config->{State} && $GetParam{NewStateID} ) {
            $TicketObject->TicketStateSet(
                TicketID     => $Self->{TicketID},
                StateID      => $GetParam{NewStateID},
                UserID       => $Self->{UserID},
                DynamicField => $GetParam{DynamicField},
            );

            # unlock the ticket after close
            my %StateData = $StateObject->StateGet(
                ID => $GetParam{NewStateID},
            );

            # set unlock on close state
            if ( $StateData{TypeName} =~ /^close/i ) {
                $TicketObject->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # set pending time on pending state
            elsif ( $StateData{TypeName} =~ /^pending/i ) {

                # set pending time
                $TicketObject->TicketPendingTimeSet(
                    UserID   => $Self->{UserID},
                    TicketID => $Self->{TicketID},
                    %GetParam,
                );
            }

            # redirect parent window to last screen overview on closed tickets
            if (
                $StateData{TypeName} =~ /^close/i
                && !$ConfigObject->Get('Ticket::Frontend::RedirectAfterCloseDisabled')
                )
            {
                $ReturnURL = $Self->{LastScreenOverview} || 'Action=AgentDashboard';
            }
        }

        if (
            $GetParam{CreateArticle}
            && $Config->{Note}
            && ( $GetParam{Subject} || $GetParam{Body} )
            )
        {

            if ( !$GetParam{Subject} ) {
                if ( $Config->{Subject} ) {
                    my $Subject = $LayoutObject->Output(
                        Template => $Config->{Subject},
                    );
                    $GetParam{Subject} = $Subject;
                }
                $GetParam{Subject} = $GetParam{Subject}
                    || $LayoutObject->{LanguageObject}->Translate('No subject');
            }

            # get pre loaded attachment
            my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
                FormID => $Self->{FormID},
            );

            # get submit attachment
            my %UploadStuff = $ParamObject->GetUploadAll(
                Param => 'FileUpload',
            );
            if (%UploadStuff) {
                push @Attachments, \%UploadStuff;
            }

            my $MimeType = 'text/plain';
            if ( $LayoutObject->{BrowserRichText} ) {
                $MimeType = 'text/html';

                # remove unused inline images
                my @NewAttachmentData;
                ATTACHMENT:
                for my $Attachment (@Attachments) {
                    my $ContentID = $Attachment->{ContentID};
                    if (
                        $ContentID
                        && ( $Attachment->{ContentType} =~ /image/i )
                        && ( $Attachment->{Disposition} eq 'inline' )
                        )
                    {
                        my $ContentIDHTMLQuote = $LayoutObject->Ascii2Html(
                            Text => $ContentID,
                        );

                        # workaround for link encode of rich text editor, see bug#5053
                        my $ContentIDLinkEncode = $LayoutObject->LinkEncode($ContentID);
                        $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                        # ignore attachment if not linked in body
                        next ATTACHMENT
                            if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                    }

                    # remember inline images and normal attachments
                    push @NewAttachmentData, \%{$Attachment};
                }
                @Attachments = @NewAttachmentData;

                # verify html document
                $GetParam{Body} = $LayoutObject->RichTextDocumentComplete(
                    String => $GetParam{Body},
                );
            }

            my $From = "\"$Self->{UserFullname}\" <$Self->{UserEmail}>";
            my @NotifyUserIDs;

            # get list of users that will be informed without selection in informed/involved list
            my @UserListWithoutSelection = split /,/, $ParamObject->GetParam( Param => 'UserListWithoutSelection' ) || "";

            # get inform user list
            my @InformUserID = $ParamObject->GetArray( Param => 'InformUserID' );

            # get involved user list
            my @InvolvedUserID = $ParamObject->GetArray( Param => 'InvolvedUserID' );

            if ( $Config->{InformAgent} ) {
                push @NotifyUserIDs, @InformUserID;
            }

            if ( $Config->{InvolvedAgent} ) {
                push @NotifyUserIDs, @InvolvedUserID;
            }

            if ( $Self->{ReplyToArticle} ) {
                push @NotifyUserIDs, @UserListWithoutSelection;
            }

            if ( $Self->{Action} eq 'AgentTicketEmailOutbound' ) {
                $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email')->ArticleSend(
                    TicketID                        => $Self->{TicketID},
                    SenderType                      => 'agent',
                    From                            => $From,
                    MimeType                        => $MimeType,
                    Charset                         => $LayoutObject->{UserCharset},
                    UserID                          => $Self->{UserID},
                    HistoryType                     => $Config->{HistoryType},
                    HistoryComment                  => $Config->{HistoryComment},
                    ForceNotificationToUserID       => \@NotifyUserIDs,
                    ExcludeMuteNotificationToUserID => \@NotifyDone,
                    UnlockOnAway                    => $UnlockOnAway,
                    Attachment                      => \@Attachments,
                    %GetParam,
                );
            }
            elsif ( $Self->{ArticleID} ) {
                $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleEdit(
                    TicketID                        => $Self->{TicketID},
                    ArticleID                       => $Self->{ArticleID},             #Include the original article id for article versioning
                    SenderType                      => 'agent',
                    From                            => $From,
                    MimeType                        => $MimeType,
                    Charset                         => $LayoutObject->{UserCharset},
                    UserID                          => $Self->{UserID},
                    HistoryType                     => $Config->{HistoryType},
                    HistoryComment                  => $Config->{HistoryComment},
                    ForceNotificationToUserID       => \@NotifyUserIDs,
                    ExcludeMuteNotificationToUserID => \@NotifyDone,
                    UnlockOnAway                    => $UnlockOnAway,
                    Attachment                      => \@Attachments,
                    UserLogin                       => $Self->{UserLogin},
                    %GetParam,
                );
            }
            else {
                $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleCreate(
                    TicketID                        => $Self->{TicketID},
                    SenderType                      => 'agent',
                    From                            => $From,
                    MimeType                        => $MimeType,
                    Charset                         => $LayoutObject->{UserCharset},
                    UserID                          => $Self->{UserID},
                    HistoryType                     => $Config->{HistoryType},
                    HistoryComment                  => $Config->{HistoryComment},
                    ForceNotificationToUserID       => \@NotifyUserIDs,
                    ExcludeMuteNotificationToUserID => \@NotifyDone,
                    UnlockOnAway                    => $UnlockOnAway,
                    Attachment                      => \@Attachments,
                    %GetParam,
                );
            }

            if ( !$ArticleID ) {
                return $LayoutObject->ErrorScreen();
            }

            # time accounting
            if ( $GetParam{TimeUnits} ) {
                $TicketObject->TicketAccountTime(
                    TicketID  => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    TimeUnit  => $GetParam{TimeUnits},
                    UserID    => $Self->{UserID},
                );
            }

            # remove all form data
            $Kernel::OM->Get('Kernel::System::Web::FormCache')->FormIDRemove( FormID => $Self->{FormID} );

            # delete hidden fields cache
            $Kernel::OM->Get('Kernel::System::Cache')->Delete(
                Type => 'HiddenFields',
                Key  => $Self->{FormID},
            );

        }

        # set dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !$Visibility{"DynamicField_$DynamicFieldConfig->{Name}"};
            next DYNAMICFIELD if $DynamicFieldConfig->{Readonly};

            # set the object ID (TicketID or ArticleID) depending on the field configration
            my $ObjectID = $DynamicFieldConfig->{ObjectType} eq 'Article'
                ? $Self->{ArticleID} || $ArticleID
                : $Self->{TicketID};

            # set the value which was taken from web request
            # TODO: for Reference and Lens, the order is relevant
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ObjectID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # If form was called based on a draft,
        #   delete draft since its content has now been used.
        if (
            $GetParam{FormDraftID}
            && !$Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftDelete(
                FormDraftID => $GetParam{FormDraftID},
                UserID      => $Self->{UserID},
            )
            )
        {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Could not delete draft!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # load new URL in parent window and close popup
        $ReturnURL ||= "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID";

        return $LayoutObject->PopupClose(
            URL => $ReturnURL,
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my %Ticket         = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );
        my $CustomerUser   = $Ticket{CustomerUserID};
        my $ElementChanged = $ParamObject->GetParam( Param => 'ElementChanged' ) || '';

        # use the FieldIDs, which are found in AgentTicketPhone/Email, and CustomerTicketMessage
        my %Uniformity = (
            NewQueueID    => 'Dest',
            NewOwnerID    => 'NewUserID',
            NewPriorityID => 'PriorityID',
            NewStateID    => 'NextStateID',
        );
        if ( $ElementChanged && $Uniformity{$ElementChanged} ) {
            $ElementChanged = $Uniformity{$ElementChanged};
        }

        # use ticket service value when it can't be changed
        elsif ( $ConfigObject->Get('Ticket::Service') && !$Config->{Service} ) {
            $GetParam{ServiceID} = $Ticket{ServiceID} || '';
        }

        # use the FieldIDs, which are found in AgentTicketPhone/Email, and CustomerTicketMessage; if needed, fill with ticket values
        $GetParam{QueueID}     = $GetParam{NewQueueID} || $Ticket{QueueID};
        $GetParam{Dest}        = $GetParam{QueueID};
        $GetParam{NextStateID} = $GetParam{NewStateID}    || $Ticket{StateID};
        $GetParam{NewUserID}   = $GetParam{NewOwnerID}    || '';
        $GetParam{PriorityID}  = $GetParam{NewPriorityID} || '';

        # get list type
        my $TreeView = $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ? 1 : 0;

        my $OldOwners = $Self->_GetOldOwners(
            %GetParam,
            QueueID  => $GetParam{QueueID},
            StateID  => $GetParam{NextStateID},
            AllUsers => $GetParam{OwnerAll},
        );

        my $Autoselect = $ConfigObject->Get('TicketACL::Autoselect') || undef;
        my $ACLPreselection;
        if ( $ConfigObject->Get('TicketACL::ACLPreselection') ) {

            # get cached preselection rules
            my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
            $ACLPreselection = $CacheObject->Get(
                Type => 'TicketACL',
                Key  => 'Preselection',
            );
            if ( !$ACLPreselection ) {
                $ACLPreselection = $FieldRestrictionsObject->SetACLPreselectionCache();
            }
        }

        my %Convergence = (
            StdFields => 0,
            Fields    => 0,
        );
        my %ChangedElements        = $ElementChanged ? ( $ElementChanged => 1 ) : ();
        my %ChangedElementsDFStart = %ChangedElements;
        my %ChangedStdFields       = $ElementChanged && $ElementChanged !~ /^DynamicField_/ ? %ChangedElements : ();

        my $LoopProtection = 100;
        my %StdFieldValues;
        my %DynFieldStates = (
            Visibility => {},
            Fields     => {},
            Sets       => {},
        );

        until ( $Convergence{Fields} ) {

            # determine standard field input
            until ( $Convergence{StdFields} ) {

                my %NewChangedElements;

                # which standard fields to check - FieldID => GetParamValue (neccessary for Dest)
                my %Check = (
                    Dest             => 'QueueID',
                    NewUserID        => 'NewUserID',
                    NewResponsibleID => 'NewResponsibleID',
                    NextStateID      => 'NextStateID',
                    PriorityID       => 'PriorityID',
                    ServiceID        => 'ServiceID',
                    SLAID            => 'SLAID',
                    TypeID           => 'TypeID',
                );
                if ($ACLPreselection) {
                    FIELD:
                    for my $FieldID ( sort keys %Check ) {
                        if ( !$ACLPreselection->{Fields}{$FieldID} ) {
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'debug',
                                Message  => "$FieldID not defined in TicketACL preselection rules!"
                            );
                            next FIELD;
                        }
                        if ( $Autoselect && $Autoselect->{$FieldID} && $ChangedElements{$FieldID} ) {
                            next FIELD;
                        }
                        for my $Element ( sort keys %ChangedElements ) {
                            if (
                                $ACLPreselection->{Rules}{Ticket}{$Element}{$FieldID}
                                || $Self->{InternalDependancy}{$Element}{$FieldID}
                                )
                            {
                                next FIELD;
                            }
                            if ( !$ACLPreselection->{Fields}{$Element} ) {
                                $Kernel::OM->Get('Kernel::System::Log')->Log(
                                    Priority => 'debug',
                                    Message  => "$Element not defined in TicketACL preselection rules!"
                                );
                                next FIELD;
                            }
                        }

                        # delete unaffected fields
                        delete $Check{$FieldID};
                    }
                }

                # for each standard field which has to be checked, run the defined method
                METHOD:
                for my $Field ( $Self->{FieldMethods}->@* ) {
                    next METHOD if !$Check{ $Field->{FieldID} };

                    # use $Check{ $Field->{FieldID} } for Dest=>QueueID
                    $StdFieldValues{ $Check{ $Field->{FieldID} } } = $Field->{Method}->(
                        $Self,
                        %GetParam,
                        TicketID       => $Self->{TicketID},
                        CustomerUserID => $CustomerUser || '',
                        StateID        => $GetParam{NextStateID},
                    );

                    # special stuff for QueueID/Dest: included for more similarity to AgentTicketPhone etc.;
                    if ( $Field->{FieldID} eq 'Dest' ) {
                        $StdFieldValues{Dest} = $StdFieldValues{QueueID};

                        # check current selection of QueueID (Dest will be done together with the other fields)
                        if ( $GetParam{QueueID} && !$StdFieldValues{QueueID}{ $GetParam{QueueID} } ) {
                            $GetParam{QueueID} = '';
                        }

                        # autoselect
                        elsif ( !$GetParam{QueueID} && $Autoselect && $Autoselect->{Dest} ) {
                            $GetParam{QueueID} = $FieldRestrictionsObject->Autoselect(
                                PossibleValues => $StdFieldValues{QueueID},
                            ) || '';
                        }
                    }

                    # check whether current selected value is still valid for the field
                    if (
                        $GetParam{ $Field->{FieldID} }
                        && !$StdFieldValues{ $Field->{FieldID} }{ $GetParam{ $Field->{FieldID} } }
                        )
                    {
                        # if not empty the field
                        $GetParam{ $Field->{FieldID} }           = '';
                        $NewChangedElements{ $Field->{FieldID} } = 1;
                        $ChangedStdFields{ $Field->{FieldID} }   = 1;
                    }

                    # autoselect
                    elsif ( !$GetParam{ $Field->{FieldID} } && $Autoselect && $Autoselect->{ $Field->{FieldID} } ) {
                        $GetParam{ $Field->{FieldID} } = $FieldRestrictionsObject->Autoselect(
                            PossibleValues => $StdFieldValues{ $Field->{FieldID} },
                        ) || '';
                        if ( $GetParam{ $Field->{FieldID} } ) {
                            $NewChangedElements{ $Field->{FieldID} } = 1;
                            $ChangedStdFields{ $Field->{FieldID} }   = 1;
                        }
                    }
                }

                if ( !%NewChangedElements ) {
                    $Convergence{StdFields} = 1;
                }
                else {
                    %ChangedElements = %NewChangedElements;
                }

                %ChangedElementsDFStart = (
                    %ChangedElementsDFStart,
                    %NewChangedElements,
                );

                if ( $LoopProtection-- < 1 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Ran into unresolvable loop!",
                    );

                    return;
                }

            }

            %ChangedElements        = %ChangedElementsDFStart;
            %ChangedElementsDFStart = ();

            # check dynamic fields
            my %CurFieldStates;
            if (%ChangedElements) {

                # get values and visibility of dynamic fields
                %CurFieldStates = $FieldRestrictionsObject->GetFieldStates(
                    TicketObject              => $TicketObject,
                    DynamicFields             => $Self->{DynamicField},
                    DynamicFieldBackendObject => $DynamicFieldBackendObject,
                    ChangedElements           => \%ChangedElements,            # optional to reduce ACL evaluation
                    Action                    => $Self->{Action},
                    UserID                    => $Self->{UserID},
                    TicketID                  => $Self->{TicketID},
                    FormID                    => $Self->{FormID},
                    CustomerUser              => $CustomerUser || '',
                    GetParam                  => \%GetParam,
                    Autoselect                => $Autoselect,
                    ACLPreselection           => $ACLPreselection,
                    LoopProtection            => \$LoopProtection,
                );

                # combine FieldStates
                $DynFieldStates{Fields} = {
                    %{ $DynFieldStates{Fields} },
                    %{ $CurFieldStates{Fields} },
                };
                $DynFieldStates{Visibility} = {
                    %{ $DynFieldStates{Visibility} },
                    %{ $CurFieldStates{Visibility} },
                };
                $DynFieldStates{Sets} = {
                    %{ $DynFieldStates{Sets} },
                    %{ $CurFieldStates{Sets} },
                };

                # store new values
                $GetParam{DynamicField} = {
                    %{ $GetParam{DynamicField} },
                    %{ $CurFieldStates{NewValues} },
                };
            }

            # if dynamic fields changed, check standard fields again
            if ( %CurFieldStates && IsHashRefWithData( $CurFieldStates{NewValues} ) ) {
                $Convergence{StdFields} = 0;
                %ChangedElements = map { $_ => 1 } keys %{ $CurFieldStates{NewValues} };
            }
            else {
                $Convergence{Fields} = 1;
            }

        }

        # build the AJAX return for the dynamic fields
        my @DynamicFieldAJAX;
        DYNAMICFIELD:
        for my $Name ( sort keys $DynFieldStates{Fields}->%* ) {
            my $DynamicFieldConfig = $Self->{DynamicField}{$Name};

            if ( $DynamicFieldConfig->{Config}{MultiValue} && ref $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"} eq 'ARRAY' ) {
                for my $i ( 0 .. $#{ $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"} } ) {
                    my $DataValues = $DynFieldStates{Fields}{$Name}{NotACLReducible}
                        ? $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"}[$i]
                        :
                        (
                            $DynamicFieldBackendObject->BuildSelectionDataGet(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                PossibleValues     => $DynFieldStates{Fields}{$Name}{PossibleValues},
                                Value              => [ $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"}[$i] ],
                            )
                            || $DynFieldStates{Fields}{$Name}{PossibleValues}
                        );

                    # add dynamic field to the list of fields to update
                    push @DynamicFieldAJAX, {
                        Name        => 'DynamicField_' . $DynamicFieldConfig->{Name} . "_$i",
                        Data        => $DataValues,
                        SelectedID  => $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"}[$i],
                        Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                        Max         => 100,
                    };
                }

                next DYNAMICFIELD;
            }

            my $DataValues = $DynFieldStates{Fields}{$Name}{NotACLReducible}
                ? $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"}
                :
                (
                    $DynamicFieldBackendObject->BuildSelectionDataGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        PossibleValues     => $DynFieldStates{Fields}{$Name}{PossibleValues},
                        Value              => $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"},
                    )
                    || $DynFieldStates{Fields}{$Name}{PossibleValues}
                );

            # add dynamic field to the list of fields to update
            push @DynamicFieldAJAX, {
                Name        => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data        => $DataValues,
                SelectedID  => $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"},
                Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                Max         => 100,
            };
        }

        for my $SetField ( values $DynFieldStates{Sets}->%* ) {
            my $DynamicFieldConfig = $SetField->{DynamicFieldConfig};

            # the frontend name is the name of the inner field including its index or the '_Template' suffix
            DYNAMICFIELD:
            for my $FrontendName ( keys $SetField->{FieldStates}->%* ) {

                if ( $DynamicFieldConfig->{Config}{MultiValue} && ref $SetField->{Values}{$FrontendName} eq 'ARRAY' ) {
                    for my $i ( 0 .. $#{ $SetField->{Values}{$FrontendName} } ) {
                        my $DataValues = $SetField->{FieldStates}{$FrontendName}{NotACLReducible}
                            ? $SetField->{Values}{$FrontendName}[$i]
                            :
                            (
                                $DynamicFieldBackendObject->BuildSelectionDataGet(
                                    DynamicFieldConfig => $DynamicFieldConfig,
                                    PossibleValues     => $SetField->{FieldStates}{$FrontendName}{PossibleValues},
                                    Value              => [ $SetField->{Values}{$FrontendName}[$i] ],
                                )
                                || $SetField->{FieldStates}{$FrontendName}{PossibleValues}
                            );

                        # add dynamic field to the list of fields to update
                        push @DynamicFieldAJAX, {
                            Name        => 'DynamicField_' . $FrontendName . "_$i",
                            Data        => $DataValues,
                            SelectedID  => $SetField->{Values}{$FrontendName}[$i],
                            Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                            Max         => 100,
                        };
                    }

                    next DYNAMICFIELD;
                }

                my $DataValues = $SetField->{FieldStates}{$FrontendName}{NotACLReducible}
                    ? $SetField->{Values}{$FrontendName}
                    :
                    (
                        $DynamicFieldBackendObject->BuildSelectionDataGet(
                            DynamicFieldConfig => $DynamicFieldConfig,
                            PossibleValues     => $SetField->{FieldStates}{$FrontendName}{PossibleValues},
                            Value              => $SetField->{Values}{$FrontendName},
                        )
                        || $SetField->{FieldStates}{$FrontendName}{PossibleValues}
                    );

                # add dynamic field to the list of fields to update
                push @DynamicFieldAJAX, {
                    Name        => 'DynamicField_' . $FrontendName,
                    Data        => $DataValues,
                    SelectedID  => $SetField->{Values}{$FrontendName},
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                };
            }
        }

        if ( IsHashRefWithData( $DynFieldStates{Visibility} ) ) {
            push @DynamicFieldAJAX, {
                Name => 'Restrictions_Visibility',
                Data => $DynFieldStates{Visibility},
            };
        }

        # build AJAX return for the standard fields
        my @StdFieldAJAX;
        my %Attributes = (
            Dest => {
                Translation  => $TreeView,
                PossibleNone => 1,
                TreeView     => $TreeView,
                Max          => 100,
            },
            NewUserID => {
                Translation  => 0,
                PossibleNone => 1,
                Max          => 100,
            },
            NewResponsibleID => {
                Translation  => 0,
                PossibleNone => 1,
                Max          => 100,
            },
            NextStateID => {
                Translation => 1,
                Max         => 100,
            },
            PriorityID => {
                Translation => 1,
                Max         => 100,
            },
            ServiceID => {
                PossibleNone => 1,
                Translation  => $TreeView,
                TreeView     => $TreeView,
                Max          => 100,
            },
            SLAID => {
                PossibleNone => 1,
                Translation  => 1,
                Max          => 100,
            },
            StandardTemplateID => {
                PossibleNone => 1,
                Translation  => 1,
                Max          => 100,
            },
            TypeID => {
                PossibleNone => 1,
                Translation  => 1,
                Max          => 100,
            }
        );
        delete $StdFieldValues{QueueID};
        my %Diversity = reverse %Uniformity;
        for my $Field ( sort keys %StdFieldValues ) {
            push @StdFieldAJAX, {
                Name       => $Diversity{$Field} || $Field,
                Data       => $StdFieldValues{$Field},
                SelectedID => $GetParam{$Field},
                %{ $Attributes{$Field} },
            };
        }

        my @TemplateAJAX;

        # update ticket body and attachements if needed.
        if ( $ChangedStdFields{StandardTemplateID} ) {
            my @TicketAttachments;
            my $TemplateText;

            # remove all attachments from the Upload cache
            my $RemoveSuccess = $UploadCacheObject->FormIDRemove(
                FormID => $Self->{FormID},
            );
            if ( !$RemoveSuccess ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Form attachments could not be deleted!",
                );
            }

            # get the template text and set new attachments if a template is selected
            if ( IsPositiveInteger( $GetParam{StandardTemplateID} ) ) {
                my $TemplateGenerator = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

                # set template text, replace smart tags (limited as ticket is not created)
                $TemplateText = $TemplateGenerator->Template(
                    TemplateID => $GetParam{StandardTemplateID},
                    TicketID   => $Self->{TicketID},
                    UserID     => $Self->{UserID},
                );

                # if ReplyToArticle is given, get this article to generate
                # the quoted article content
                if ( $Self->{ReplyToArticle} ) {

                    # get article to quote
                    my $Body = $LayoutObject->ArticleQuote(
                        TicketID          => $Self->{TicketID},
                        ArticleID         => $Self->{ReplyToArticle},
                        FormID            => $Self->{FormID},
                        UploadCacheObject => $UploadCacheObject,
                    );

                    # prepare quoted body content
                    $Body = $Self->_GetQuotedReplyBody(
                        %{ $Self->{ReplyToArticleContent} },
                        Body => $Body,
                    );

                    if ( $LayoutObject->{BrowserRichText} ) {
                        $TemplateText = $TemplateText . '<br><br>' . $Body;
                    }
                    else {
                        $TemplateText = $TemplateText . "\n\n" . $Body;
                    }
                }

                # create StdAttachmentObject
                my $StdAttachmentObject = $Kernel::OM->Get('Kernel::System::StdAttachment');

                # add std. attachments to ticket
                my %AllStdAttachments = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
                    StandardTemplateID => $GetParam{StandardTemplateID},
                );
                for ( sort keys %AllStdAttachments ) {
                    my %AttachmentsData = $StdAttachmentObject->StdAttachmentGet( ID => $_ );
                    $UploadCacheObject->FormIDAddFile(
                        FormID      => $Self->{FormID},
                        Disposition => 'attachment',
                        %AttachmentsData,
                    );
                }

                # send a list of attachments in the upload cache back to the clientside JavaScript
                # which renders then the list of currently uploaded attachments
                @TicketAttachments = $UploadCacheObject->FormIDGetAllFilesMeta(
                    FormID => $Self->{FormID},
                );

                for my $Attachment (@TicketAttachments) {
                    $Attachment->{Filesize} = $LayoutObject->HumanReadableDataSize(
                        Size => $Attachment->{Filesize},
                    );
                }
            }

            @TemplateAJAX = (
                {
                    Name => 'UseTemplateNote',
                    Data => '0',
                },
                {
                    Name => 'RichText',
                    Data => $TemplateText || '',
                },
                {
                    Name     => 'TicketAttachments',
                    Data     => \@TicketAttachments,
                    KeepData => 1,
                },
            );
        }

        my $JSON = $LayoutObject->BuildSelectionJSON(
            [
                @StdFieldAJAX,
                @DynamicFieldAJAX,
                @TemplateAJAX,
            ],
        );

        # can't use JSONReply here, as we already have JSON
        return $LayoutObject->Attachment(
            ContentType => 'application/json',
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {

        my $Body = '';

        # if ReplyToArticle is given, get this article to generate
        # the quoted article content
        if ( $Self->{ReplyToArticle} ) {

            # get article to quote
            $Body = $LayoutObject->ArticleQuote(
                TicketID          => $Self->{TicketID},
                ArticleID         => $Self->{ReplyToArticle},
                FormID            => $Self->{FormID},
                UploadCacheObject => $UploadCacheObject,
            );

            # prepare quoted body content
            $Body = $Self->_GetQuotedReplyBody(
                %{ $Self->{ReplyToArticleContent} },
                Body => $Body,
            );
        }

        # if a body content was pre defined, add this before the quoted article content
        if ( $GetParam{Body} ) {

            # make sure body is rich text
            if ( $LayoutObject->{BrowserRichText} && !$Self->{ArticleID} ) {
                $GetParam{Body} = $LayoutObject->Ascii2RichText(
                    String => $GetParam{Body},
                );
            }

            $Body = $GetParam{Body} . $Body;
        }

        # fillup configured default vars
        if ( $Body eq '' && $Config->{Body} ) {
            $Body = $LayoutObject->Output(
                Template => $Config->{Body},
            );

            # make sure body is rich text
            if ( $LayoutObject->{BrowserRichText} ) {
                $Body = $LayoutObject->Ascii2RichText(
                    String => $Body,
                );
            }
        }

        # set Body var to calculated content
        $GetParam{Body} = $Body;

        my %SafetyCheckResult = $Kernel::OM->Get('Kernel::System::HTMLUtils')->Safety(
            String => $GetParam{Body},

            # Strip out external content if BlockLoadingRemoteContent is enabled.
            NoExtSrcLoad => $ConfigObject->Get('Ticket::Frontend::BlockLoadingRemoteContent'),

            # Disallow potentially unsafe content.
            NoApplet     => 1,
            NoObject     => 1,
            NoEmbed      => 1,
            NoSVG        => 1,
            NoJavaScript => 1,
        );
        $GetParam{Body} = $SafetyCheckResult{String};

        if ( $Self->{ReplyToArticle} ) {
            my $TicketSubjectRe = $ConfigObject->Get('Ticket::SubjectRe') || 'Re';
            $GetParam{Subject} = $TicketSubjectRe . ': ' . $Self->{ReplyToArticleContent}{Subject};
        }
        elsif ( !defined $GetParam{Subject} && $Config->{Subject} ) {
            $GetParam{Subject} = $LayoutObject->Output(
                Template => $Config->{Subject},
            );
        }

        # use ticket values
        if ( $Config->{Queue} ) {
            $GetParam{QueueID} = $Ticket{QueueID} // '';
            $GetParam{Dest}    = $Ticket{QueueID} // '';
        }
        if ( $Config->{Service} ) {
            $GetParam{SLAID}     = $Ticket{SLAID}     // '';
            $GetParam{ServiceID} = $Ticket{ServiceID} // '';
        }
        if ( $Config->{TicketType} ) {
            $GetParam{TypeID} = $Ticket{TypeID} // '';
        }
        if ( $Config->{State} ) {
            $GetParam{NextStateID} = $Ticket{StateID} // '';
        }
        if ( $Config->{Priority} ) {
            $GetParam{PriorityID} = $Ticket{PriorityID} // '';
        }
        my $CustomerUser = $Ticket{CustomerUserID} // '';

        # Get values for Ticket fields and use default value for Article fields, if given (all screens based on
        # AgentTicketActionCommon generate a new article, then article fields will be always default value or
        # empty at the beginning).
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
            next DYNAMICFIELD unless IsHashRefWithData($DynamicFieldConfig);

            # This overwrites the values that might have been taken from the web request.
            # Note that there shouldn't be any values from the web request,
            # because submits, successful and unsuccessful have been handled already above.
            if ( $DynamicFieldConfig->{ObjectType} eq 'Ticket' ) {

                # Value is stored in the database from Ticket.
                $GetParam{DynamicField}{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
            }
            elsif ( $DynamicFieldConfig->{ObjectType} eq 'Article' ) {
                if ( $Self->{ArticleID} ) {

                    # if we are in edit mode take the db data of the article
                    $GetParam{DynamicField}{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $ArticleData{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
                }
                else {
                    $GetParam{DynamicField}{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $DynamicFieldConfig->{Config}->{DefaultValue} || '';
                }
            }
        }

        my $Autoselect = $ConfigObject->Get('TicketACL::Autoselect') || undef;

        # gather fields which are supposed to be hidden when autoselected
        my $HideAutoselectedJSON;
        if ($Autoselect) {
            my @HideAutoselected = grep { !ref( $Autoselect->{$_} ) && $Autoselect->{$_} == 2 } keys %{$Autoselect};
            if ( $Autoselect->{DynamicField} ) {
                push @HideAutoselected,
                    map { "DynamicField_" . $_ }
                    ( grep { $Autoselect->{DynamicField}{$_} == 2 } keys %{ $Autoselect->{DynamicField} } );
            }

            if (@HideAutoselected) {
                my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
                $HideAutoselectedJSON = $JSONObject->Encode(
                    Data => \@HideAutoselected,
                );
            }
        }

        my $ACLPreselection;
        if ( $ConfigObject->Get('TicketACL::ACLPreselection') ) {

            # get cached preselection rules
            my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
            $ACLPreselection = $CacheObject->Get(
                Type => 'TicketACL',
                Key  => 'Preselection',
            );
            if ( !$ACLPreselection ) {
                $ACLPreselection = $FieldRestrictionsObject->SetACLPreselectionCache();
            }
        }

        my %Convergence = (
            StdFields => 0,
            Fields    => 0,
        );
        my %ChangedElements;
        my %ChangedElementsDFStart;
        my %ChangedStdFields;

        my $LoopProtection = 100;
        my %StdFieldValues;
        my %DynFieldStates = (
            Visibility => {},
            Fields     => {},
        );

        my $InitialRun = 1;

        until ( $Convergence{Fields} ) {

            # determine standard field input
            until ( $Convergence{StdFields} ) {

                my %NewChangedElements;

                # which standard fields to check - FieldID => GetParamValue (neccessary for Dest)
                my %Check = (
                    Dest             => 'QueueID',
                    NewUserID        => 'NewUserID',
                    NewResponsibleID => 'NewResponsibleID',
                    NextStateID      => 'NextStateID',
                    PriorityID       => 'PriorityID',
                    ServiceID        => 'ServiceID',
                    SLAID            => 'SLAID',
                    TypeID           => 'TypeID',
                );
                if ( $ACLPreselection && !$InitialRun ) {
                    FIELD:
                    for my $FieldID ( sort keys %Check ) {
                        if ( !$ACLPreselection->{Fields}{$FieldID} ) {
                            $Kernel::OM->Get('Kernel::System::Log')->Log(
                                Priority => 'debug',
                                Message  => "$FieldID not defined in TicketACL preselection rules!"
                            );
                            next FIELD;
                        }
                        if ( $Autoselect && $Autoselect->{$FieldID} && $ChangedElements{$FieldID} ) {
                            next FIELD;
                        }
                        for my $Element ( sort keys %ChangedElements ) {
                            if (
                                $ACLPreselection->{Rules}{Ticket}{$Element}{$FieldID}
                                || $Self->{InternalDependancy}{$Element}{$FieldID}
                                )
                            {
                                next FIELD;
                            }
                            if ( !$ACLPreselection->{Fields}{$Element} ) {
                                $Kernel::OM->Get('Kernel::System::Log')->Log(
                                    Priority => 'debug',
                                    Message  => "$Element not defined in TicketACL preselection rules!"
                                );
                                next FIELD;
                            }
                        }

                        # delete unaffected fields
                        delete $Check{$FieldID};
                    }
                }

                # for each standard field which has to be checked, run the defined method
                METHOD:
                for my $Field ( @{ $Self->{FieldMethods} } ) {
                    next METHOD unless $Check{ $Field->{FieldID} };

                    # use $Check{ $Field->{FieldID} } for Dest=>QueueID
                    $StdFieldValues{ $Check{ $Field->{FieldID} } } = $Field->{Method}->(
                        $Self,
                        %GetParam,
                        TicketID       => $Self->{TicketID},
                        CustomerUserID => $CustomerUser || '',
                        StateID        => $GetParam{NextStateID},
                    );

                    # special stuff for QueueID/Dest: included for more similarity to AgentTicketPhone etc.;
                    if ( $Field->{FieldID} eq 'Dest' ) {
                        $StdFieldValues{Dest} = $StdFieldValues{QueueID};

                        # check current selection of QueueID (Dest will be done together with the other fields)
                        if ( $GetParam{QueueID} && !$StdFieldValues{QueueID}{ $GetParam{QueueID} } ) {
                            $GetParam{QueueID} = '';
                        }

                        # autoselect
                        elsif ( !$GetParam{QueueID} && $Autoselect && $Autoselect->{Dest} ) {
                            $GetParam{QueueID} = $FieldRestrictionsObject->Autoselect(
                                PossibleValues => $StdFieldValues{QueueID},
                            ) || '';
                        }
                    }

                    # check whether current selected value is still valid for the field
                    if (
                        $GetParam{ $Field->{FieldID} }
                        && !$StdFieldValues{ $Field->{FieldID} }{ $GetParam{ $Field->{FieldID} } }
                        )
                    {
                        # if not empty the field
                        $GetParam{ $Field->{FieldID} }           = '';
                        $NewChangedElements{ $Field->{FieldID} } = 1;
                        $ChangedStdFields{ $Field->{FieldID} }   = 1;
                    }

                    # autoselect
                    elsif ( !$GetParam{ $Field->{FieldID} } && $Autoselect && $Autoselect->{ $Field->{FieldID} } ) {
                        $GetParam{ $Field->{FieldID} } = $FieldRestrictionsObject->Autoselect(
                            PossibleValues => $StdFieldValues{ $Field->{FieldID} },
                        ) || '';
                        if ( $GetParam{ $Field->{FieldID} } ) {
                            $NewChangedElements{ $Field->{FieldID} } = 1;
                            $ChangedStdFields{ $Field->{FieldID} }   = 1;
                        }
                    }
                }

                if ( !%NewChangedElements ) {
                    $Convergence{StdFields} = 1;
                }
                else {
                    %ChangedElements = %NewChangedElements;
                }

                %ChangedElementsDFStart = (
                    %ChangedElementsDFStart,
                    %NewChangedElements,
                );

                if ( $LoopProtection-- < 1 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Ran into unresolvable loop!",
                    );

                    return;
                }

            }

            %ChangedElements        = %ChangedElementsDFStart;
            %ChangedElementsDFStart = ();

            # check dynamic fields
            my %CurFieldStates;
            if ( %ChangedElements || $InitialRun ) {

                # get values and visibility of dynamic fields
                %CurFieldStates = $FieldRestrictionsObject->GetFieldStates(
                    TicketObject              => $TicketObject,
                    DynamicFields             => $Self->{DynamicField},
                    DynamicFieldBackendObject => $DynamicFieldBackendObject,
                    ChangedElements           => \%ChangedElements,            # optional to reduce ACL evaluation
                    Action                    => $Self->{Action},
                    UserID                    => $Self->{UserID},
                    TicketID                  => $Self->{TicketID},
                    FormID                    => $Self->{FormID},
                    CustomerUser              => $CustomerUser || '',
                    GetParam                  => \%GetParam,
                    Autoselect                => $Autoselect,
                    ACLPreselection           => $ACLPreselection,
                    LoopProtection            => \$LoopProtection,
                    InitialRun                => $InitialRun,
                );

                # combine FieldStates
                $DynFieldStates{Fields} = {
                    %{ $DynFieldStates{Fields} },
                    %{ $CurFieldStates{Fields} },
                };
                $DynFieldStates{Visibility} = {
                    %{ $DynFieldStates{Visibility} },
                    %{ $CurFieldStates{Visibility} },
                };

                # store new values
                $GetParam{DynamicField} = {
                    %{ $GetParam{DynamicField} },
                    %{ $CurFieldStates{NewValues} },
                };
            }

            # if dynamic fields changed, check standard fields again
            if ( %CurFieldStates && IsHashRefWithData( $CurFieldStates{NewValues} ) ) {
                $Convergence{StdFields} = 0;
                %ChangedElements = map { $_ => 1 } keys %{ $CurFieldStates{NewValues} };
            }
            else {
                $Convergence{Fields} = 1;
            }

            $InitialRun = 0;
        }

        my %DynamicFieldPossibleValues = map {
            'DynamicField_' . $_ => defined $DynFieldStates{Fields}{$_}
                ? $DynFieldStates{Fields}{$_}{PossibleValues}
                : undef
        } ( keys $Self->{DynamicField}->%* );

        # print form ...
        return join '',
            $LayoutObject->Header(
                Type      => 'Small',
                Value     => $Ticket{TicketNumber},
                BodyClass => 'Popup',
            ),
            $Self->_Mask(
                %GetParam,
                %Ticket,
                NewQueueID       => $GetParam{QueueID},
                NewOwnerID       => $GetParam{NewUserID},
                NewStateID       => $GetParam{NextStateID},
                NewPriorityID    => $GetParam{PriorityID},
                SLAID            => $GetParam{SLAID},
                ServiceID        => $GetParam{ServiceID},
                TypeID           => $GetParam{TypeID},
                HideAutoselected => $HideAutoselectedJSON,
                Visibility       => $DynFieldStates{Visibility},
                DFPossibleValues => \%DynamicFieldPossibleValues,
                Attachments      => \@ArticleAttachments
            ),
            $LayoutObject->Footer(
                Type => 'Small',
            );
    }
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

                my $PendingTimeSettings = {};
                if ( $Ticket{RealTillTimeNotUsed} ) {
                    my $PendingTimeObj = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            Epoch => $Ticket{RealTillTimeNotUsed},
                        },
                    );
                    $PendingTimeSettings = $PendingTimeObj->Get();
                }

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
                    Prefix               => IsHashRefWithData($PendingTimeSettings) ? 'PendingTime' : undef,
                    Year                 => $PendingTimeSettings->{Year}|| undef,
                    Month                => $PendingTimeSettings->{Month} || undef,
                    Day                  => $PendingTimeSettings->{Day} || undef,
                    Hour                 => $PendingTimeSettings->{Hour} || undef,
                    Minute               => $PendingTimeSettings->{Minute} || undef,
                    Second               => $PendingTimeSettings->{Second} || undef,
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
    if ( $Config->{Note} ) {

        $Param{WidgetStatus} = 'Collapsed';

        if (
            $Config->{NoteMandatory}
            || $Self->{ReplyToArticle}
            || $Param{CreateArticle}
            )
        {
            $Param{WidgetStatus} = 'Expanded';
        }

        if ( $Config->{NoteMandatory} ) {
            $Param{SubjectRequired} = 'Validate_Required';
            $Param{BodyRequired}    = 'Validate_Required';
        }
        else {
            $Param{SubjectRequired} = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
            $Param{BodyRequired}    = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
        }

        # set customer visibility of this note to the same value as the article for whom this is the reply
        if ( $Self->{ReplyToArticle} && !defined $Param{IsVisibleForCustomer} ) {
            $Param{IsVisibleForCustomer} = $Self->{ReplyToArticleContent}->{IsVisibleForCustomer};
        }
        elsif ( !defined $Param{IsVisibleForCustomer} ) {
            $Param{IsVisibleForCustomer} = $Config->{IsVisibleForCustomerDefault};
        }

        # show attachments
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

        # render article type dynamic fields
        my $ArticleTypeDynamicFieldHTML = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
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

        $LayoutObject->Block(
            Name => 'WidgetArticle',
            Data => {
                %Param,
                DynamicFieldHTML => $ArticleTypeDynamicFieldHTML,
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

        # create email parser object
        my $EmailParserObject = Kernel::System::EmailParser->new(
            Mode  => 'Standalone',
            Debug => 0,
        );

        # check and retrieve involved and informed agents of ReplyTo Note
        my @ReplyToUsers;
        my %ReplyToUsersHash;
        my %ReplyToUserIDs;
        if ( $Self->{ReplyToArticle} ) {
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

        if ( $Config->{InformAgent} || $Config->{InvolvedAgent} ) {
            $LayoutObject->Block(
                Name => 'InformAdditionalAgents',
            );
        }

        # get param object
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        # get all agents for "involved agents"
        if ( $Config->{InvolvedAgent} ) {

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
        if ( $Config->{InformAgent} ) {

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
        if ( $Config->{InvolvedAgent} ) {

            $LayoutObject->Block(
                Name => 'InvolvedAgent',
                Data => \%Param,
            );
        }

        # show list of agents, that receive this note (ReplyToNote)
        # at least sender of original note and all recepients of the original note
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

        if ( $Config->{NoteMandatory} ) {
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

        # build text template string
        my %StandardTemplates = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList(
            Valid => 1,
            Type  => 'Note',
        );

        my $QueueStandardTemplates = $Self->_GetStandardTemplates(
            %Param,
            TicketID => $Self->{TicketID} || '',
        );

        if (
            IsHashRefWithData(
                $QueueStandardTemplates
                    || ( $Config->{Queue} && IsHashRefWithData( \%StandardTemplates ) )
            )
            )
        {
            $Param{StandardTemplateStrg} = $LayoutObject->BuildSelection(
                Data         => $QueueStandardTemplates || {},
                Name         => 'StandardTemplateID',
                SelectedID   => $Param{StandardTemplateID} || '',
                Class        => 'Modernize',
                PossibleNone => 1,
                Sort         => 'AlphanumericValue',
                Translation  => 1,
                Max          => 200,
            );
            $LayoutObject->Block(
                Name => 'StandardTemplate',
                Data => {%Param},
            );
        }

        # show time accounting box
        if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
            if ( $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') && $Config->{NoteMandatory} ) {
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

                $Param{TimeUnitsRequired} = $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_DependingRequiredAND Validate_Depending_CreateArticle'
                    : '';
            }
            $LayoutObject->Block(
                Name => 'TimeUnits',
                Data => \%Param,
            );
        }
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

        # set up rich text editor
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }

    # End Widget Article

    # get output back
    return $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => \%Param
    );
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
        TicketID => $Self->{TicketID},
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
        %Param,
    );

    return \%NextStates;
}

sub _GetResponsible {
    my ( $Self, %Param ) = @_;

    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with responsible or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{OwnerAll} ) {
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'responsible',
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'Responsible',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;
    return \%ShownUsers;
}

sub _GetOwners {
    my ( $Self, %Param ) = @_;

    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with owner or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{OwnerAll} ) {
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'owner',
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'NewOwner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;
    return \%ShownUsers;
}

sub _GetOldOwners {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my @OldUserInfo = $TicketObject->TicketOwnerList( TicketID => $Self->{TicketID} );
    my %UserHash;
    if (@OldUserInfo) {
        my $Counter = 1;
        USER:
        for my $User ( reverse @OldUserInfo ) {

            next USER if $UserHash{ $User->{UserID} };

            $UserHash{ $User->{UserID} } = "$Counter: $User->{UserFullname}";
            $Counter++;
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'OldOwner',
        Data          => \%UserHash,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;
    return \%UserHash;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
            %Param,
            TicketID => $Self->{TicketID},
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );
    }

    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # if non set customers can get default services then they should also be able to get the SLAs
    #  for those services (this works during ticket creation).
    # if no CustomerUserID is set, TicketSLAList will complain during AJAX updates as UserID is not
    #  passed. See bug 11147.

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    my %SLA;
    if ( $Param{ServiceID} ) {
        %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
            %Param,
            TicketID => $Self->{TicketID},
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );
    }

    return \%SLA;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
        %Param,
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
        TicketID => $Self->{TicketID},
    );

    # get config of frontend module
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    if ( !$Config->{PriorityDefault} ) {
        $Priorities{''} = '-';
    }

    return \%Priorities;
}

sub _GetQuotedReplyBody {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $LayoutObject->{BrowserRichText} ) {

        # rewrap body if exists
        if ( $Param{Body} ) {
            $Param{Body} =~ s/\t/ /g;
            my $Quote = $LayoutObject->Ascii2Html(
                Text           => $ConfigObject->Get('Ticket::Frontend::Quote') || '',
                HTMLResultMode => 1,
            );
            if ($Quote) {

                # quote text
                $Param{Body} = "<blockquote type=\"cite\">$Param{Body}</blockquote>\n";

                # cleanup not compat. tags
                $Param{Body} = $LayoutObject->RichTextDocumentCleanup(
                    String => $Param{Body},
                );

                my $ResponseFormat = $LayoutObject->{LanguageObject}->FormatTimeString( $Param{CreateTime}, 'DateFormat', 'NoSeconds' );
                $ResponseFormat .= ' - ' . $Param{From} . ' ';
                $ResponseFormat
                    .= $LayoutObject->{LanguageObject}->Translate('wrote') . ':';

                $Param{Body} = $ResponseFormat . $Param{Body};

            }
            else {
                $Param{Body} = "<br/>" . $Param{Body};

                if ( $Param{CreateTime} ) {
                    $Param{Body} = $LayoutObject->{LanguageObject}->Translate('Date') .
                        ": $Param{CreateTime}<br/>" . $Param{Body};
                }

                for (qw(Subject ReplyTo Reply-To Cc To From)) {
                    if ( $Param{$_} ) {
                        $Param{Body} = $LayoutObject->{LanguageObject}->Translate($_) .
                            ": $Param{$_}<br/>" . $Param{Body};
                    }
                }

                my $From = $LayoutObject->Ascii2RichText(
                    String => $Param{From},
                );

                my $MessageFrom = $LayoutObject->{LanguageObject}->Translate('Message from');
                my $EndMessage  = $LayoutObject->{LanguageObject}->Translate('End message');

                $Param{Body} = "<br/>---- $MessageFrom $From ---<br/><br/>" . $Param{Body};
                $Param{Body} .= "<br/>---- $EndMessage ---<br/>";
            }
        }
    }
    else {

        # prepare body, subject, ReplyTo ...
        # rewrap body if exists
        if ( $Param{Body} ) {
            $Param{Body} =~ s/\t/ /g;
            my $Quote = $ConfigObject->Get('Ticket::Frontend::Quote');
            if ($Quote) {
                $Param{Body} =~ s/\n/\n$Quote /g;
                $Param{Body} = "\n$Quote " . $Param{Body};

                my $ResponseFormat = $LayoutObject->{LanguageObject}->FormatTimeString( $Param{CreateTime}, 'DateFormat', 'NoSeconds' );
                $ResponseFormat .= ' - ' . $Param{From} . ' ';
                $ResponseFormat
                    .= $LayoutObject->{LanguageObject}->Translate('wrote') . ":\n";

                $Param{Body} = $ResponseFormat . $Param{Body};
            }
            else {
                $Param{Body} = "\n" . $Param{Body};
                if ( $Param{CreateTime} ) {
                    $Param{Body} = $LayoutObject->{LanguageObject}->Translate('Date') .
                        ": $Param{CreateTime}\n" . $Param{Body};
                }

                for (qw(Subject ReplyTo Reply-To Cc To From)) {
                    if ( $Param{$_} ) {
                        $Param{Body} = $LayoutObject->{LanguageObject}->Translate($_) .
                            ": $Param{$_}\n" . $Param{Body};
                    }
                }

                my $MessageFrom = $LayoutObject->{LanguageObject}->Translate('Message from');
                my $EndMessage  = $LayoutObject->{LanguageObject}->Translate('End message');

                $Param{Body} = "\n---- $MessageFrom $Param{From} ---\n\n" . $Param{Body};
                $Param{Body} .= "\n---- $EndMessage ---\n";
            }
        }
    }

    return $Param{Body};
}

sub _GetStandardTemplates {
    my ( $Self, %Param ) = @_;

    # either QueueID or TicketID is needed
    return {} if !$Param{QueueID} && !$Param{TicketID};

    my $QueueID = $Param{QueueID} || '';
    if ( !$Param{QueueID} && $Param{TicketID} ) {

        # get QueueID from the ticket
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );
        $QueueID = $Ticket{QueueID} || '';
    }

    # fetch all std. templates
    my %StandardTemplates = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberList(
        QueueID       => $QueueID,
        TemplateTypes => 1,
    );

    # return empty hash if there are no templates for this screen
    return {} unless IsHashRefWithData( $StandardTemplates{Note} );

    # return just the templates for this screen
    return $StandardTemplates{Note};
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # no types when a parameter is missing
    return {} unless ( $Param{QueueID} || $Param{TicketID} );

    # get ticket types with considering ACLs
    my %Type = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeList(
        %Param,
        TicketID => $Self->{TicketID},
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
    );

    return \%Type;
}

sub _GetQueues {
    my ( $Self, %Param ) = @_;

    # Get Queues.
    my %Queues = $Kernel::OM->Get('Kernel::System::Ticket')->TicketMoveList(
        %Param,
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
        Action   => $Self->{Action},
        Type     => 'move_into',
    );

    return \%Queues;
}

sub _LoadArticleEdit {
    my ( $Self, %Param ) = @_;

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    my %Ticket               = %{ $Param{Ticket} };
    my %ArticleData          = %{ $Param{ArticleData} };
    my $ArticleBackendObject = $Param{ArticleBackendObject};

    # Check if there is HTML body attachment.
    my %AttachmentIndexHTMLBody = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID    => $ArticleData{ArticleID},
        OnlyHTMLBody => 1,
    );
    ( $ArticleData{HTMLBodyAttachmentID} ) = sort keys %AttachmentIndexHTMLBody;

    if ( $ArticleData{HTMLBodyAttachmentID} ) {
        $ArticleData{MimeType} = 'text/html';

        # Render article content.
        $ArticleData{Body} = $LayoutObject->ArticlePreview(
            TicketID            => $Ticket{TicketID},
            ArticleID           => $ArticleData{ArticleID},
            ShowDeletedArticles => 1
        );
    }
    else {
        return %ArticleData;
    }

    my $Content = $LayoutObject->Output(
        Template => '[% Data.HTML %]',
        Data     => {
            HTML => $ArticleData{Body},
        },
    );

    my %Data = (
        Content            => $Content,
        ContentAlternative => '',
        ContentID          => '',
        ContentType        => 'text/html; charset="utf-8"',
        Disposition        => 'inline',
        FilesizeRaw        => bytes::length($Content),
    );

    # set download type to inline
    $ConfigObject->Set(
        Key   => 'AttachmentDownloadType',
        Value => 'inline'
    );

    # generate base url
    my $URL = "Action=PictureUpload;FormID=$Self->{FormID};ContentID=";

    # set filename for inline viewing
    $Data{Filename} = "Ticket-$Ticket{TicketNumber}-ArticleID-$ArticleData{ArticleID}.html";

    # replace links to inline images in html content
    my %AtmBox = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleData{ArticleID},
    );

    for my $FileID ( keys %AtmBox ) {
        my %FileData = $ArticleBackendObject->ArticleAttachment(
            ArticleID              => $ArticleData{ArticleID},
            FileID                 => $FileID,
            ContentMayBeFilehandle => 0,
        );

        if ( $FileData{Disposition} eq 'inline' && $FileData{Filename} ne 'file-2' ) {

            # add uploaded file to upload cache
            $UploadCacheObject->FormIDAddFile(
                FormID      => $Self->{FormID},
                Filename    => $FileData{Filename},
                Content     => $FileData{Content},
                ContentType => $FileData{ContentType} . '; name="' . $FileData{Filename} . '"',
                Disposition => $FileData{Disposition},
            );
        }
    }

    # get new content id
    my %ContentIDs;

    my @AttachmentMeta = $UploadCacheObject->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID}
    );

    for my $Attachment (@AttachmentMeta) {
        $ContentIDs{ $Attachment->{Filename} } = $Attachment->{ContentID};
    }

    # Do not load external images if 'BlockLoadingRemoteContent' is enabled.
    my $LoadExternalImages = 1;
    if ( $ConfigObject->Get('Ticket::Frontend::BlockLoadingRemoteContent') ) {
        $LoadExternalImages = 0;
    }

    # reformat rich text document to have correct charset and links to
    # inline documents
    %Data = $LayoutObject->RichTextDocumentServe(
        Data               => \%Data,
        URL                => $URL,
        Attachments        => \%AtmBox,
        ContentIDs         => \%ContentIDs,
        LoadExternalImages => $LoadExternalImages,
    );

    # if there is unexpectedly pgp decrypted content in the html email (OE),
    # we will use the article body (plain text) from the database as fall back
    # see bug#9672
    if (
        $Data{Content} =~ m{
        ^ .* -----BEGIN [ ] PGP [ ] MESSAGE-----  .* $      # grep PGP begin tag
        .+                                                  # PGP parts may be nested in html
        ^ .* -----END [ ] PGP [ ] MESSAGE-----  .* $        # grep PGP end tag
    }xms
        )
    {
        # html quoting
        my $HTMLBody = $LayoutObject->Ascii2Html(
            NewLine        => $ConfigObject->Get('DefaultViewNewLine'),
            Text           => $ArticleData{Body},
            VMax           => $ConfigObject->Get('DefaultViewLines') || 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );

        $Data{Content} = $HTMLBody;
    }

    $ArticleData{Body} = $Data{Content};
    delete $ArticleData{IsEdited};

    return %ArticleData;
}

sub _CopyArticleAttachmentsToUploadCache {
    my ( $Self, %Param ) = @_;

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my %GetParam;

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        TicketID  => $Self->{TicketID},
        ArticleID => $Param{ArticleID},
    );

    # define if rich text should be used
    $Self->{RichText} = $ConfigObject->Get('Ticket::Frontend::ZoomRichTextForce')
        || $LayoutObject->{BrowserRichText}
        || 0;

    # Always exclude plain text attachment, but exclude HTML body only if rich text is enabled.
    $Self->{ExcludeAttachments} = {
        ExcludePlainText => 1,
        ExcludeHTMLBody  => $Self->{RichText},
        ExcludeInline    => $Self->{RichText},
    };

    # Get attachment index (excluding body attachments).
    my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
        %{ $Self->{ExcludeAttachments} },
    );

    FILE:
    for my $FileID ( sort keys %AtmIndex ) {

        # get an attachment
        my %AttachmentData = $ArticleBackendObject->ArticleAttachment(
            ArticleID              => $Param{ArticleID},
            FileID                 => $FileID,
            ContentMayBeFilehandle => 0,
        );

        next FILE if !$AttachmentData{Content};

        # add attachment to the upload cache
        my $Success = $UploadCacheObject->FormIDAddFile(
            FormID      => $Self->{FormID},
            Disposition => 'attachment',
            Filename    => $AttachmentData{Filename},
            Content     => $AttachmentData{Content},
            ContentType => $AttachmentData{ContentType},
        );
    }

    # get pre loaded attachment
    my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
        FormID => $Self->{FormID},
    );

    # get submit attachment
    my %UploadStuff = $ParamObject->GetUploadAll(
        Param => 'FileUpload',
    );

    if (%UploadStuff) {
        push @Attachments, \%UploadStuff;
    }

    return @Attachments;
}

1;
