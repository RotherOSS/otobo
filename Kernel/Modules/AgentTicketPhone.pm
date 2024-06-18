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

package Kernel::Modules::AgentTicketPhone;

use strict;
use warnings;

# core modules

# CPAN modules
use Mail::Address ();

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # frontend specific config
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get the dynamic fields for this screen
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Config->{DynamicField} || {},
    );

    my $Definition = $Kernel::OM->Get('Kernel::System::Ticket::Mask')->DefinitionGet(
        Mask => $Self->{Action},
    ) || {};

    $Self->{MaskDefinition} = $Definition->{Mask};
    $Self->{DynamicField}   = {};

    # align sysconfig and ticket mask data I
    for my $DynamicField ( @{ $DynamicFieldList // [] } ) {
        if ( exists $Definition->{DynamicFields}{ $DynamicField->{Name} } ) {
            my $Parameters = delete $Definition->{DynamicFields}{ $DynamicField->{Name} } // {};

            for my $Attribute ( keys $Parameters->%* ) {
                $DynamicField->{$Attribute} = $Parameters->{$Attribute};
            }
        }
        else {
            push $Self->{MaskDefinition}->@*, {
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
    for my $DynamicFieldName ( keys $Definition->{DynamicFields}->%* ) {
        $Self->{DynamicField}{$DynamicFieldName} = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicFieldName,
        );

        my $Parameters = $Definition->{DynamicFields}{$DynamicFieldName} // {};

        for my $Attribute ( keys $Parameters->%* ) {
            $Self->{DynamicField}{$DynamicFieldName}{$Attribute} = $Parameters->{$Attribute};
        }
    }

    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::FormCache')->PrepareFormID(
        ParamObject  => $Kernel::OM->Get('Kernel::System::Web::Request'),
        LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
    );

    # methods which are used to determine the possible values of the standard fields
    $Self->{FieldMethods} = [
        {
            FieldID => 'Dest',
            Method  => \&_GetTos
        },
        {
            FieldID => 'NewUserID',
            Method  => \&_GetUsers
        },
        {
            FieldID => 'NewResponsibleID',
            Method  => \&_GetResponsibles
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

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get params
    my %GetParam;
    for my $Key (
        qw(ArticleID LinkTicketID PriorityID NewUserID
        From Subject Body NextStateID TimeUnits
        Year Month Day Hour Minute
        NewResponsibleID ResponsibleAll OwnerAll TypeID ServiceID SLAID
        StandardTemplateID FromChatID Dest
        )
        )
    {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam;
    $ACLCompatGetParam{OwnerID} = $GetParam{NewUserID};

    # hash for check duplicated entries
    my %AddressesList;

    # MultipleCustomer From-field
    my @MultipleCustomer;
    my $CustomersNumber = $ParamObject->GetParam( Param => 'CustomerTicketCounterFromCustomer' ) || 0;
    my $Selected        = $ParamObject->GetParam( Param => 'CustomerSelected' )                  || '';

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    if ($CustomersNumber) {
        my $CustomerCounter = 1;
        for my $Count ( 1 ... $CustomersNumber ) {
            my $CustomerElement  = $ParamObject->GetParam( Param => 'CustomerTicketText_' . $Count );
            my $CustomerSelected = ( $Selected eq $Count ? 'checked ' : '' );
            my $CustomerKey      = $ParamObject->GetParam( Param => 'CustomerKey_' . $Count )
                || '';

            if ($CustomerElement) {

                my $CountAux         = $CustomerCounter++;
                my $CustomerError    = '';
                my $CustomerErrorMsg = 'CustomerGenericServerErrorMsg';
                my $CustomerDisabled = '';

                if ( $GetParam{From} ) {
                    $GetParam{From} .= ', ' . $CustomerElement;
                }
                else {
                    $GetParam{From} = $CustomerElement;
                }

                # check email address
                for my $Email ( Mail::Address->parse($CustomerElement) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                        $CustomerErrorMsg = $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $CustomerError = 'ServerError';
                    }
                }

                # check for duplicated entries
                if ( defined $AddressesList{$CustomerElement} && $CustomerError eq '' ) {
                    $CustomerErrorMsg = 'IsDuplicatedServerErrorMsg';
                    $CustomerError    = 'ServerError';
                }

                if ( $CustomerError ne '' ) {
                    $CustomerDisabled = 'disabled="disabled"';
                    $CountAux         = $Count . 'Error';
                }

                push @MultipleCustomer, {
                    Count            => $CountAux,
                    CustomerElement  => $CustomerElement,
                    CustomerSelected => $CustomerSelected,
                    CustomerKey      => $CustomerKey,
                    CustomerError    => $CustomerError,
                    CustomerErrorMsg => $CustomerErrorMsg,
                    CustomerDisabled => $CustomerDisabled,
                };
                $AddressesList{$CustomerElement} = 1;
            }
        }
    }

    # get Dynamic fields form ParamObject
    my %DynamicFieldValues;

    # get needed objects
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $LayoutObject              = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');
    my $CustomerUserObject        = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $UploadCacheObject         = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject               = $Kernel::OM->Get('Kernel::System::Queue');
    my $FieldRestrictionsObject   = $Kernel::OM->Get('Kernel::System::Ticket::FieldRestrictions');

    # frontend specific config
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value from the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
        );
    }

    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldACLParameters;
    DYNAMICFIELD:
    for my $DynamicField ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !defined $DynamicFieldValues{$DynamicField};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField } = $DynamicFieldValues{$DynamicField};
    }
    $GetParam{DynamicField} = \%DynamicFieldACLParameters;

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

    if ( $GetParam{FromChatID} ) {
        if ( !$ConfigObject->Get('ChatEngine::Active') ) {
            return $LayoutObject->FatalError(
                Message => Translatable('Chat is not active.'),
            );
        }

        # Ok, take the chat
        my %ChatParticipant = $Kernel::OM->Get('Kernel::System::Chat')->ChatParticipantCheck(
            ChatID        => $GetParam{FromChatID},
            ChatterType   => 'User',
            ChatterID     => $Self->{UserID},
            ChatterActive => 1,
        );

        if ( !%ChatParticipant ) {
            return $LayoutObject->FatalError(
                Message => Translatable('No permission.'),
            );
        }

        # Get permissions
        my $PermissionLevel = $Kernel::OM->Get('Kernel::System::Chat')->ChatPermissionLevelGet(
            ChatID => $GetParam{FromChatID},
            UserID => $Self->{UserID},
        );

        # Check if observer
        if ( $PermissionLevel ne 'Owner' && $PermissionLevel ne 'Participant' ) {
            return $LayoutObject->FatalError(
                Message => Translatable('No permission.'),
                Comment => $PermissionLevel,
            );
        }
    }

    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'Created' ) {
        my %Ticket;
        if ( $Self->{TicketID} ) {
            %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );
        }

        # header and navigation bar
        my $Output = join '',
            $LayoutObject->Header(),
            $LayoutObject->NavigationBar();

        # if there is no ticket id!
        if ( $Self->{TicketID} && $Self->{Subaction} eq 'Created' ) {

            # notify info
            $Output .= $LayoutObject->Notify(
                Info => $LayoutObject->{LanguageObject}->Translate(
                    'Ticket "%s" created!',
                    $Ticket{TicketNumber},
                ),
                Link => $LayoutObject->{Baselink}
                    . 'Action=AgentTicketZoom;TicketID='
                    . $Ticket{TicketID},
            );
        }

        # store last queue screen
        if (
            $Self->{LastScreenOverview}
            && $Self->{LastScreenOverview} !~ /Action=AgentTicketPhone/
            && $Self->{RequestedURL}       !~ /Action=AgentTicketPhone.*LinkTicketID=/
            )
        {
            $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastScreenOverview',
                Value     => $Self->{RequestedURL},
            );
        }

        # get split article if given
        # get ArticleID
        my %Article;
        my %CustomerData;
        my $ArticleFrom = '';
        my %SplitTicketData;
        if ( $GetParam{ArticleID} ) {

            my $Access = $TicketObject->TicketPermission(
                Type     => 'ro',
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $LayoutObject->NoPermission(
                    Message    => Translatable('You need ro permission!'),
                    WithHeader => 'yes',
                );
            }

            # Get information from original ticket (SplitTicket).
            %SplitTicketData = $TicketObject->TicketGet(
                TicketID      => $Self->{TicketID},
                DynamicFields => 1,
                UserID        => $Self->{UserID},
            );

            my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
                TicketID  => $Self->{TicketID},
                ArticleID => $GetParam{ArticleID},
            );

            %Article = $ArticleBackendObject->ArticleGet(
                TicketID  => $Self->{TicketID},
                ArticleID => $GetParam{ArticleID},
            );

            # check if article is from the same TicketID as we checked permissions for.
            if ( $Article{TicketID} ne $Self->{TicketID} ) {
                return $LayoutObject->ErrorScreen(
                    Message => $LayoutObject->{LanguageObject}->Translate(
                        'Article does not belong to ticket %s!', $Self->{TicketID}
                    ),
                );
            }

            $Article{Subject} = $TicketObject->TicketSubjectClean(
                TicketNumber => $Ticket{TicketNumber},
                Subject      => $Article{Subject} || '',
            );

            # save article from for addresses list
            $ArticleFrom = $Article{From};

            # if To is present
            # and is no a queue
            # and also is no a system address
            # set To as article from
            if ( IsStringWithData( $Article{To} ) ) {
                my %Queues = $QueueObject->QueueList();

                if ( $ConfigObject->{CustomerPanelOwnSelection} ) {
                    for my $Queue ( sort keys %{ $ConfigObject->{CustomerPanelOwnSelection} } ) {
                        my $Value = $ConfigObject->{CustomerPanelOwnSelection}->{$Queue};
                        $Queues{$Queue} = $Value;
                    }
                }

                my %QueueLookup         = reverse %Queues;
                my %SystemAddressLookup = reverse $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressList();
                my @ArticleFromAddress;
                my $SystemAddressEmail;

                if ($ArticleFrom) {
                    @ArticleFromAddress = Mail::Address->parse($ArticleFrom);
                    $SystemAddressEmail = $ArticleFromAddress[0]->address();
                }

                if ( !defined $QueueLookup{ $Article{To} } && defined $SystemAddressLookup{$SystemAddressEmail} ) {
                    $ArticleFrom = $Article{To};
                }
            }

            # body preparation for plain text processing
            $Article{Body} = $LayoutObject->ArticleQuote(
                TicketID           => $Article{TicketID},
                ArticleID          => $GetParam{ArticleID},
                FormID             => $Self->{FormID},
                UploadCacheObject  => $UploadCacheObject,
                AttachmentsInclude => 1,
            );
            if ( $LayoutObject->{BrowserRichText} ) {
                $Article{ContentType} = 'text/html';
            }
            else {
                $Article{ContentType} = 'text/plain';
            }

            my %SafetyCheckResult = $Kernel::OM->Get('Kernel::System::HTMLUtils')->Safety(
                String => $Article{Body},

                # Strip out external content if BlockLoadingRemoteContent is enabled.
                NoExtSrcLoad => $ConfigObject->Get('Ticket::Frontend::BlockLoadingRemoteContent'),

                # Disallow potentially unsafe content.
                NoApplet     => 1,
                NoObject     => 1,
                NoEmbed      => 1,
                NoSVG        => 1,
                NoJavaScript => 1,
            );
            $Article{Body} = $SafetyCheckResult{String};

            # show customer info
            if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoCompose') ) {
                if ( $SplitTicketData{CustomerUserID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        User => $SplitTicketData{CustomerUserID},
                    );
                }
                elsif ( $SplitTicketData{CustomerID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        CustomerID => $SplitTicketData{CustomerID},
                    );
                }
            }
            if ( $SplitTicketData{CustomerUserID} ) {
                my %CustomerUserList = $CustomerUserObject->CustomerSearch(
                    UserLogin => $SplitTicketData{CustomerUserID},
                );
                for my $KeyCustomerUserList ( sort keys %CustomerUserList ) {
                    $Article{From} = $CustomerUserList{$KeyCustomerUserList};
                }
            }
        }

        # multiple addresses list
        # check email address
        my $CountFrom = scalar @MultipleCustomer || 1;
        my %CustomerDataFrom;
        if ( $Article{CustomerUserID} ) {
            %CustomerDataFrom = $CustomerUserObject->CustomerUserDataGet(
                User => $Article{CustomerUserID},
            );
        }

        for my $Email ( Mail::Address->parse($ArticleFrom) ) {

            my $CountAux         = $CountFrom;
            my $CustomerError    = '';
            my $CustomerErrorMsg = 'CustomerGenericServerErrorMsg';
            my $CustomerDisabled = '';
            my $CustomerSelected = $CountFrom eq '1' ? 'checked ' : '';
            my $EmailAddress     = $Email->address();
            if ( !$CheckItemObject->CheckEmail( Address => $EmailAddress ) )
            {
                $CustomerErrorMsg = $CheckItemObject->CheckErrorType()
                    . 'ServerErrorMsg';
                $CustomerError = 'ServerError';
            }

            # check for duplicated entries
            if ( defined $AddressesList{$Email} && $CustomerError eq '' ) {
                $CustomerErrorMsg = 'IsDuplicatedServerErrorMsg';
                $CustomerError    = 'ServerError';
            }

            if ( $CustomerError ne '' ) {
                $CustomerDisabled = 'disabled="disabled"';
                $CountAux         = $CountFrom . 'Error';
            }

            my $Phrase = '';
            if ( $Email->phrase() ) {
                $Phrase = $Email->phrase();
            }

            my $CustomerKey = '';
            if (
                defined $CustomerDataFrom{UserEmail}
                && $CustomerDataFrom{UserEmail} eq $EmailAddress
                )
            {
                $CustomerKey = $Article{CustomerUserID};
            }
            elsif ($EmailAddress) {
                my %List = $CustomerUserObject->CustomerSearch(
                    PostMasterSearch => $EmailAddress,
                );

                for my $UserLogin ( sort keys %List ) {

                    # Set right one if there is more than one customer user with the same email address.
                    if ( $Phrase && $List{$UserLogin} =~ /$Phrase/ ) {
                        $CustomerKey = $UserLogin;
                    }
                }
            }

            my $CustomerElement = $EmailAddress;
            if ($Phrase) {
                $CustomerElement = $Phrase . " <$EmailAddress>";
            }

            if ( $CustomerSelected && $CustomerKey ) {
                %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                    User => $CustomerKey,
                );
            }

            push @MultipleCustomer, {
                Count            => $CountAux,
                CustomerElement  => $CustomerElement,
                CustomerSelected => $CustomerSelected,
                CustomerKey      => $CustomerKey,
                CustomerError    => $CustomerError,
                CustomerErrorMsg => $CustomerErrorMsg,
                CustomerDisabled => $CustomerDisabled,
            };
            $AddressesList{$EmailAddress} = 1;
            $CountFrom++;
        }

        # get user preferences
        my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID => $Self->{UserID},
        );

        my %SplitTicketParam;

        # in case of split a TicketID and ArticleID are always given, send the TicketID to calculate
        # ACLs based on parent information
        if ( $Self->{TicketID} && $Article{ArticleID} ) {
            $SplitTicketParam{TicketID} = $Self->{TicketID};
        }

        # fix to bug# 8068 Field & DynamicField preselection on TicketSplit
        # when splitting a ticket the selected attributes must remain in the new ticket screen
        # this information will be available in the SplitTicketParam hash
        if ( $SplitTicketParam{TicketID} ) {

            # get information from original ticket (SplitTicket)
            my %SplitTicketData = $TicketObject->TicketGet(
                TicketID      => $SplitTicketParam{TicketID},
                DynamicFields => 1,
                UserID        => $Self->{UserID},
            );

            # set simple IDs to pass them to the mask
            for my $SplitedParam (qw(TypeID ServiceID SLAID PriorityID)) {
                $SplitTicketParam{$SplitedParam} = $SplitTicketData{$SplitedParam};
            }

            # set StateID as NextStateID
            $SplitTicketParam{NextStateID} = $SplitTicketData{StateID};

            # set Owner and Responsible
            $SplitTicketParam{UserSelected}            = $SplitTicketData{OwnerID};
            $SplitTicketParam{ResponsibleUserSelected} = $SplitTicketData{ResponsibleID};

            # set additional information needed for Owner and Responsible
            if ( $SplitTicketData{QueueID} ) {
                $SplitTicketParam{QueueID} = $SplitTicketData{QueueID};
            }

            $GetParam{OwnerAll}       = 1;
            $GetParam{ResponsibleAll} = 1;

            # set the selected queue in format ID||Name
            $SplitTicketParam{ToSelected} = $SplitTicketData{QueueID} . '||' . $SplitTicketData{Queue};

            for my $Key ( sort keys %SplitTicketData ) {
                if ( $Key =~ /DynamicField\_(.*)/ ) {
                    $SplitTicketParam{DynamicField}{$1} = $SplitTicketData{$Key};
                    delete $SplitTicketParam{$Key};
                }
            }
        }

        # define selected values at the start

        # in case of ticket split set $Self->{QueueID} as the QueueID of the original ticket,
        # in order to set correct ACLs on page load (initial). See bug 8687.
        if (
            IsHashRefWithData( \%SplitTicketParam )
            && $SplitTicketParam{QueueID}
            && !$Self->{QueueID}
            )
        {
            $GetParam{QueueID} = $SplitTicketParam{QueueID};
            $GetParam{Dest}    = $SplitTicketParam{ToSelected};
        }

        # Get predefined QueueID (if no queue from split ticket is set).
        elsif ( !$Self->{QueueID} && $GetParam{Dest} ) {
            my @QueueParts = split( /\|\|/, $GetParam{Dest} );
            $GetParam{QueueID} = $QueueParts[0];
        }

        else {
            my $UserDefaultQueue = $ConfigObject->Get('Ticket::Frontend::UserDefaultQueue') || '';

            if ($UserDefaultQueue) {
                $GetParam{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $UserDefaultQueue );
                if ( $GetParam{QueueID} ) {
                    $GetParam{Dest} = "$GetParam{QueueID}||$UserDefaultQueue";
                }
            }
        }

        # don't use the split ticket state, just the default
        if ( $Config->{StateDefault} ) {
            my %NextStates;

            %NextStates = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
                %GetParam,
                QueueID => $GetParam{QueueID} || 1,
                Action  => $Self->{Action},
                UserID  => $Self->{UserID},
            );

            $GetParam{NextStateID} = { reverse %NextStates }->{ $Config->{StateDefault} } // '';
        }

        # split ticket info for the rest
        if ( $SplitTicketParam{UserSelected} ) {
            $GetParam{NewUserID} = $SplitTicketData{OwnerID};
        }
        if ( $SplitTicketParam{ResponsibleUserSelected} ) {
            $GetParam{NewResponsibleID} = $SplitTicketData{ResponsibleUserSelected};
        }
        for my $SplitedParam (qw(TypeID ServiceID SLAID PriorityID)) {
            $SplitTicketParam{$SplitedParam} = $SplitTicketData{$SplitedParam};
        }

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

            # to store dynamic field value from database (or undefined)
            my $Value;

            # in case of split a TicketID and ArticleID are always given, Get the value
            # from DB this cases
            if ( $Self->{TicketID} && $Article{ArticleID} ) {

                # select TicketID or ArticleID to get the value depending on dynamic field configuration
                my $ObjectID = $DynamicFieldConfig->{ObjectType} eq 'Ticket'
                    ? $Self->{TicketID}
                    : $Article{ArticleID};

                # get value stored on the database (split)
                $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $ObjectID,
                );
            }

            # otherwise (on a new ticket). Check if the user has a user specific default value for
            # the dynamic field, otherwise will use Dynamic Field default value
            elsif ( !$DynamicFieldConfig->{Readonly} ) {

                # get default value from dynamic field config (if any)
                $Value = $DynamicFieldConfig->{Config}->{DefaultValue} || '';

                # override the value from user preferences if is set
                if ( $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} } ) {
                    $Value = $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} };
                }
            }

            $GetParam{DynamicField}{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $Value;
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

        # track changing standard fields
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
                    Dest               => 'QueueID',
                    NewUserID          => 'NewUserID',
                    NewResponsibleID   => 'NewResponsibleID',
                    NextStateID        => 'NextStateID',
                    PriorityID         => 'PriorityID',
                    ServiceID          => 'ServiceID',
                    SLAID              => 'SLAID',
                    StandardTemplateID => 'StandardTemplateID',
                    TypeID             => 'TypeID',
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
                    next METHOD if !$Check{ $Field->{FieldID} };

                    # use $Check{ $Field->{FieldID} } for Dest=>QueueID
                    $StdFieldValues{ $Check{ $Field->{FieldID} } } = $Field->{Method}->(
                        $Self,
                        %GetParam,
                        OwnerID        => $GetParam{NewUserID},
                        CustomerUserID => $SplitTicketData{CustomerUserID} || '',
                        QueueID        => $GetParam{QueueID},
                        Services       => $StdFieldValues{ServiceID} || undef,      # needed for SLAID
                    );

                    # special stuff for QueueID/Dest: Dest is "QueueID||QueueName" => "QueueName";
                    if ( $Field->{FieldID} eq 'Dest' ) {
                        TOs:
                        for my $QueueID ( sort keys %{ $StdFieldValues{QueueID} } ) {
                            next TOs if ( $StdFieldValues{QueueID}{$QueueID} eq '-' );
                            $StdFieldValues{Dest}{"$QueueID||$StdFieldValues{QueueID}{ $QueueID }"} = $StdFieldValues{QueueID}{$QueueID};
                        }

                        # check current selection of QueueID (Dest will be done together with the other fields)
                        if ( $GetParam{QueueID} && !$StdFieldValues{Dest}{ $GetParam{Dest} } ) {
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
                    ChangedElements           => \%ChangedElements,                        # optional to reduce ACL evaluation
                    Action                    => $Self->{Action},
                    UserID                    => $Self->{UserID},
                    FormID                    => $Self->{FormID},
                    CustomerUser              => $SplitTicketData{CustomerUserID} || '',
                    GetParam                  => {
                        %GetParam,
                        OwnerID => $GetParam{NewUserID},
                    },
                    Autoselect      => $Autoselect,
                    ACLPreselection => $ACLPreselection,
                    LoopProtection  => \$LoopProtection,
                    InitialRun      => $InitialRun,
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

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # get and format default subject and body
        my $Subject = $Article{Subject};
        if ( !$Subject ) {
            $Subject = $LayoutObject->Output(
                Template => $Config->{Subject} || '',
            );
        }
        my $Body = $Article{Body} || '';
        if ( !$Body ) {
            $Body = $LayoutObject->Output(
                Template => $Config->{Body} || '',
            );
        }

        # make sure body is rich text (if body is based on config)
        if ( !$GetParam{ArticleID} && $LayoutObject->{BrowserRichText} ) {
            $Body = $LayoutObject->Ascii2RichText(
                String => $Body,
            );
        }

        $Output .= $Self->_MaskPhoneNew(
            %GetParam,
            NextState               => $GetParam{NextStateID} ? $StdFieldValues{NextStateID}{ $GetParam{NextStateID} } : '',
            ToSelected              => $GetParam{Dest},
            UserSelected            => $GetParam{NewUserID},
            ResponsibleUserSelected => $GetParam{NewResponsibleID},
            NextStates              => $StdFieldValues{NextStateID},
            Priorities              => $StdFieldValues{PriorityID},
            Types                   => $StdFieldValues{TypeID},
            Services                => $StdFieldValues{ServiceID},
            SLAs                    => $StdFieldValues{SLAID},
            StandardTemplates       => $StdFieldValues{StandardTemplateID},
            Users                   => $StdFieldValues{NewUserID},
            ResponsibleUsers        => $StdFieldValues{NewResponsibleID},
            To                      => $StdFieldValues{QueueID},
            From                    => $Article{From},
            Subject                 => $Subject,
            Body                    => $Body,
            CustomerUser            => $SplitTicketData{CustomerUserID},
            CustomerID              => $SplitTicketData{CustomerID},
            CustomerData            => \%CustomerData,
            Attachments             => \@Attachments,
            LinkTicketID            => $GetParam{LinkTicketID} || '',
            FromChatID              => $GetParam{FromChatID}   || '',
            MultipleCustomer        => \@MultipleCustomer,
            HideAutoselected        => $HideAutoselectedJSON,
            Visibility              => $DynFieldStates{Visibility},
            DFPossibleValues        => \%DynamicFieldPossibleValues,
            TimeUnits               => $Self->_GetTimeUnits(
                %GetParam,
                %SplitTicketParam,
                OwnerID   => $GetParam{NewUserID},
                ArticleID => $Article{ArticleID},
            ),
        );

        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # create new ticket and article
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {

        my %Error;
        my %StateData;
        if ( $GetParam{NextStateID} ) {
            %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
                ID => $GetParam{NextStateID},
            );
        }
        my $NextState = $StateData{Name}                          || '';
        my $Dest      = $ParamObject->GetParam( Param => 'Dest' ) || '';

        # see if only a name has been passed
        if ( $Dest && $Dest !~ m{ \A (\d+)? \| \| .+ \z }xms ) {

            # see if we can get an ID for this queue name
            my $DestID = $QueueObject->QueueLookup(
                Queue => $Dest,
            );

            if ($DestID) {
                $Dest = $DestID . '||' . $Dest;
            }
            else {
                $Dest = '';
            }
        }

        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        $GetParam{QueueID} = $NewQueueID;

        my $CustomerUser = $ParamObject->GetParam( Param => 'CustomerUser' )
            || $ParamObject->GetParam( Param => 'PreSelectedCustomerUser' )
            || $ParamObject->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $CustomerID           = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
        my $SelectedCustomerUser = $ParamObject->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $ExpandCustomerName = $ParamObject->GetParam( Param => 'ExpandCustomerName' )
            || 0;
        my %FromExternalCustomer;
        $FromExternalCustomer{Customer} = $ParamObject->GetParam( Param => 'PreSelectedCustomerUser' )
            || $ParamObject->GetParam( Param => 'CustomerUser' )
            || '';

        if ( $ParamObject->GetParam( Param => 'OwnerAllRefresh' ) ) {
            $GetParam{OwnerAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $ParamObject->GetParam( Param => 'ResponsibleAllRefresh' ) ) {
            $GetParam{ResponsibleAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $ParamObject->GetParam( Param => 'ClearFrom' ) ) {
            $GetParam{From} = '';
            $ExpandCustomerName = 3;
        }
        for my $Count ( 1 .. 2 ) {
            my $Item = $ParamObject->GetParam( Param => "ExpandCustomerName$Count" ) || 0;
            if ( $Count == 1 && $Item ) {
                $ExpandCustomerName = 1;
            }
            elsif ( $Count == 2 && $Item ) {
                $ExpandCustomerName = 2;
            }
        }

        # rewrap body if no rich text is used
        if ( $GetParam{Body} && !$LayoutObject->{BrowserRichText} ) {
            $GetParam{Body} = $LayoutObject->WrapPlainText(
                MaxCharacters => $ConfigObject->Get('Ticket::Frontend::TextAreaNote'),
                PlainText     => $GetParam{Body},
            );
        }

        # check pending date
        if ( !$ExpandCustomerName && $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {

            # create a datetime object based on pending date
            my $PendingDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    %GetParam,
                    Second => 0,
                },
            );

            # get current system epoch
            my $CurSystemDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            if ( !$PendingDateTimeObject || $PendingDateTimeObject < $CurSystemDateTimeObject ) {
                $Error{'DateInvalid'} = 'ServerError';
            }
        }

        # skip validation of hidden fields
        my %Visibility;

        # transform dynamic field data into DFName => DFName pair
        my %DynamicFieldAcl = map { $_ => $_ } keys $Self->{DynamicField}->%*;

        # call ticket ACLs for DynamicFields to check field visibility
        my $ACLResult = $TicketObject->TicketAcl(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            Action         => $Self->{Action},
            ReturnType     => 'Form',
            ReturnSubType  => '-',
            Data           => \%DynamicFieldAcl,
            UserID         => $Self->{UserID},
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

        # cycle through the activated Dynamic Fields for this screen
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
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        %GetParam,
                        CustomerUserID => $CustomerUser || '',
                        Action         => $Self->{Action},
                        ReturnType     => 'Ticket',
                        ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data           => \%AclData,
                        UserID         => $Self->{UserID},
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

            # do not validate on invisible fields
            if ( !$ExpandCustomerName && $Visibility{ 'DynamicField_' . $DynamicFieldConfig->{Name} } ) {

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
                            $LayoutObject->{LanguageObject}->Translate( 'Could not perform validation on field %s!', $DynamicFieldConfig->{Label} ),
                        Comment => Translatable('Please contact the administrator.'),
                    );
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} }                        = ' ServerError';
                    $DynamicFieldValidationResult{ $DynamicFieldConfig->{Name} } = $ValidationResult;
                }
            }
        }

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # expand customer name
        my %CustomerUserData;
        if ( $ExpandCustomerName == 1 ) {

            # search customer
            my %CustomerUserList;
            %CustomerUserList = $CustomerUserObject->CustomerSearch(
                Search           => $GetParam{From},
                CustomerUserOnly => 1,
            );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for my $KeyCustomerUser ( sort keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$KeyCustomerUser};
                $Param{CustomerUserListLastUser} = $KeyCustomerUser;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $GetParam{From}            = $Param{CustomerUserListLast};
                $Error{ExpandCustomerName} = 1;
                my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $CustomerID = $CustomerUserData{UserCustomerID};
                }
                if ( $CustomerUserData{UserLogin} ) {
                    $CustomerUser = $CustomerUserData{UserLogin};
                    $FromExternalCustomer{Customer} = $CustomerUserData{UserLogin};
                }
                if ( $FromExternalCustomer{Customer} ) {
                    my %ExternalCustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                        User => $FromExternalCustomer{Customer},
                    );
                    $FromExternalCustomer{Email} = $ExternalCustomerUserData{UserEmail};
                }
            }

            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {

                # don't check email syntax on multi customer select
                $ConfigObject->Set(
                    Key   => 'CheckEmailAddresses',
                    Value => 0
                );
                $CustomerID = '';

                # clear from if there is no customer found
                if ( !%CustomerUserList ) {
                    $GetParam{From} = '';
                }
                $Error{ExpandCustomerName} = 1;
            }
        }

        # get from and customer id if customer user is given
        # This is used by Kernel::Modules::AdminCustomerUser
        elsif ( $ExpandCustomerName == 2 ) {
            %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUser,
            );
            my %CustomerUserList = $CustomerUserObject->CustomerSearch(
                UserLogin => $CustomerUser,
            );
            for my $KeyCustomerUser ( sort keys %CustomerUserList ) {
                $GetParam{From} = $CustomerUserList{$KeyCustomerUser};
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $CustomerID = $CustomerUserData{UserCustomerID};
            }
            if ( $CustomerUserData{UserLogin} ) {
                $CustomerUser = $CustomerUserData{UserLogin};
            }
            if ( $FromExternalCustomer{Customer} ) {
                my %ExternalCustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $FromExternalCustomer{Customer},
                );
                $FromExternalCustomer{Email} = $ExternalCustomerUserData{UserMailString};
            }
            $Error{ExpandCustomerName} = 1;
        }

        # if a new destination queue is selected
        elsif ( $ExpandCustomerName == 3 ) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }

        # 'just' no submit
        elsif ( $ExpandCustomerName == 4 ) {
            $Error{NoSubmit} = 1;
        }

        # show customer info
        my %CustomerData;
        if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoCompose') ) {
            if ( $CustomerUser || $SelectedCustomerUser ) {
                %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                    User => $CustomerUser || $SelectedCustomerUser,
                );
            }
            elsif ($CustomerID) {
                %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }

        # check email address
        for my $Email ( Mail::Address->parse( $GetParam{From} ) ) {
            if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                $Error{ErrorType}   = $CheckItemObject->CheckErrorType() . 'ServerErrorMsg';
                $Error{FromInvalid} = ' ServerError';
            }
        }

        # if it is not a subaction about attachments, check for server errors
        if ( !$ExpandCustomerName ) {
            if ( !$GetParam{From} ) {
                $Error{'FromInvalid'} = ' ServerError';
            }
            if ( !$GetParam{Subject} ) {
                $Error{'SubjectInvalid'} = ' ServerError';
            }
            if ( !$NewQueueID ) {
                $Error{'DestinationInvalid'} = ' ServerError';
            }

            if (
                $ConfigObject->Get('Ticket::Service')
                && $GetParam{SLAID}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }

            # check mandatory service
            if (
                $ConfigObject->Get('Ticket::Service')
                && $Config->{ServiceMandatory}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }

            # check mandatory sla
            if (
                $ConfigObject->Get('Ticket::Service')
                && $Config->{SLAMandatory}
                && !$GetParam{SLAID}
                )
            {
                $Error{'SLAInvalid'} = ' ServerError';
            }

            if ( ( !$GetParam{TypeID} ) && ( $ConfigObject->Get('Ticket::Type') ) ) {
                $Error{'TypeIDInvalid'} = ' ServerError';
            }
            if ( !$GetParam{Body} ) {
                $Error{'RichTextInvalid'} = ' ServerError';
            }
            if (
                $ConfigObject->Get('Ticket::Frontend::AccountTime')
                && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                && $GetParam{TimeUnits} eq ''
                )
            {
                $Error{'TimeUnitsInvalid'} = ' ServerError';
            }
        }

        if (%Error) {

            # get and format default subject and body
            my $Subject = $LayoutObject->Output(
                Template => $Config->{Subject} || '',
            );

            my $Body = $LayoutObject->Output(
                Template => $Config->{Body} || '',
            );

            # make sure body is rich text
            if ( $LayoutObject->{BrowserRichText} ) {
                $Body = $LayoutObject->Ascii2RichText(
                    String => $Body,
                );
            }

            # set Body and Subject parameters for Output
            if ( !$GetParam{Subject} ) {
                $GetParam{Subject} = $Subject;
            }

            if ( !$GetParam{Body} ) {
                $GetParam{Body} = $Body;
            }

            # get services
            my $Services = $Self->_GetServices(
                %GetParam,
                %ACLCompatGetParam,
                CustomerUserID => $CustomerUser || '',
                QueueID        => $NewQueueID   || 1,
            );

            # reset previous ServiceID to reset SLA-List if no service is selected
            if ( !$GetParam{ServiceID} || !$Services->{ $GetParam{ServiceID} } ) {
                $GetParam{ServiceID} = '';
            }

            my $SLAs = $Self->_GetSLAs(
                %GetParam,
                %ACLCompatGetParam,
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                QueueID        => $NewQueueID   || 1,
                Services       => $Services,
            );

            # header and navigation bar
            my $Output = join '',
                $LayoutObject->Header(),
                $LayoutObject->NavigationBar();

            # html output
            $Output .= $Self->_MaskPhoneNew(
                QueueID => $Self->{QueueID},
                Users   => $Self->_GetUsers(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{OwnerAll}
                ),
                UserSelected     => $GetParam{NewUserID},
                ResponsibleUsers => $Self->_GetResponsibles(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{ResponsibleAll}
                ),
                ResponsibleUserSelected => $GetParam{NewResponsibleID},
                NextStates              => $Self->_GetNextStates(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                NextState  => $NextState,
                Priorities => $Self->_GetPriorities(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Types => $Self->_GetTypes(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Services          => $Services,
                SLAs              => $SLAs,
                StandardTemplates => $Self->_GetStandardTemplates(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID => $NewQueueID || '',
                ),
                CustomerID   => $LayoutObject->Ascii2Html( Text => $CustomerID ),
                CustomerUser => $CustomerUser,
                CustomerData => \%CustomerData,
                To           => $Self->_GetTos(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID => $NewQueueID
                ),
                ToSelected  => $Dest,
                Errors      => \%Error,
                Attachments => \@Attachments,
                %GetParam,
                MultipleCustomer     => \@MultipleCustomer,
                FromExternalCustomer => \%FromExternalCustomer,
                Visibility           => \%Visibility,
                DFPossibleValues     => \%DynamicFieldPossibleValues,
                DFErrors             => \%DynamicFieldValidationResult,
            );

            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # create new ticket, do db insert
        my $TicketID = $TicketObject->TicketCreate(
            Title        => $GetParam{Subject},
            QueueID      => $NewQueueID,
            Subject      => $GetParam{Subject},
            Lock         => 'unlock',
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            StateID      => $GetParam{NextStateID},
            PriorityID   => $GetParam{PriorityID},
            OwnerID      => 1,
            CustomerNo   => $CustomerID,
            CustomerUser => $SelectedCustomerUser,
            UserID       => $Self->{UserID},
        );

        # set ticket dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';
            next DYNAMICFIELD if !$Visibility{"DynamicField_$DynamicFieldConfig->{Name}"};
            next DYNAMICFIELD if $DynamicFieldConfig->{Readonly};

            # set the value
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # get pre loaded attachment
        my @AttachmentData = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        my $MimeType = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # remove unused inline images
            my @NewAttachmentData;
            ATTACHMENT:
            for my $Attachment (@AttachmentData) {
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
            @AttachmentData = @NewAttachmentData;

            # verify html document
            $GetParam{Body} = $LayoutObject->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        my $PlainBody = $GetParam{Body};

        if ( $LayoutObject->{BrowserRichText} ) {
            $PlainBody = $LayoutObject->RichText2Ascii( String => $GetParam{Body} );
        }

        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ( $GetParam{NewUserID} ) {
            $NoAgentNotify = 1;
        }
        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );
        my $ArticleID            = $ArticleBackendObject->ArticleCreate(
            NoAgentNotify        => $NoAgentNotify,
            TicketID             => $TicketID,
            SenderType           => $Config->{SenderType},
            IsVisibleForCustomer => $Config->{IsVisibleForCustomer},
            From                 => $GetParam{From},
            To                   => $To,
            Subject              => $GetParam{Subject},
            Body                 => $GetParam{Body},
            MimeType             => $MimeType,
            Charset              => $LayoutObject->{UserCharset},
            UserID               => $Self->{UserID},
            HistoryType          => $Config->{HistoryType},
            HistoryComment       => $Config->{HistoryComment} || '%%',
            AutoResponseType     => ( $ConfigObject->Get('AutoResponseForWebTickets') )
            ? 'auto reply'
            : '',
            OrigHeader => {
                From    => $GetParam{From},
                To      => $GetParam{To},
                Subject => $GetParam{Subject},
                Body    => $PlainBody,

            },
            Queue => $QueueObject->QueueLookup( QueueID => $NewQueueID ),
        );
        if ( !$ArticleID ) {
            return $LayoutObject->ErrorScreen();
        }

        # set article dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( values $Self->{DynamicField}->%* ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';
            next DYNAMICFIELD if !$Visibility{"DynamicField_$DynamicFieldConfig->{Name}"};
            next DYNAMICFIELD if $DynamicFieldConfig->{Readonly};

            # set the value
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ArticleID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # Permissions check were done earlier
        if ( $GetParam{FromChatID} ) {
            my $ChatObject = $Kernel::OM->Get('Kernel::System::Chat');
            my %Chat       = $ChatObject->ChatGet(
                ChatID => $GetParam{FromChatID},
            );
            my @ChatMessageList = $ChatObject->ChatMessageList(
                ChatID => $GetParam{FromChatID},
            );
            my $ChatArticleID;

            if (@ChatMessageList) {
                for my $Message (@ChatMessageList) {
                    $Message->{MessageText} = $LayoutObject->Ascii2Html(
                        Text        => $Message->{MessageText},
                        LinkFeature => 1,
                    );
                }

                my $ArticleChatBackend = $ArticleObject->BackendForChannel( ChannelName => 'Chat' );
                $ChatArticleID = $ArticleChatBackend->ArticleCreate(
                    TicketID             => $TicketID,
                    SenderType           => $Config->{SenderType},
                    ChatMessageList      => \@ChatMessageList,
                    IsVisibleForCustomer => $Config->{IsVisibleForCustomer},
                    UserID               => $Self->{UserID},
                    HistoryType          => $Config->{HistoryType},
                    HistoryComment       => $Config->{HistoryComment} || '%%',
                );
            }
            if ($ChatArticleID) {

                # check is customer actively present
                # it means customer has accepted this chat and not left it!
                my $CustomerPresent = $ChatObject->CustomerPresent(
                    ChatID => $GetParam{FromChatID},
                    Active => 1,
                );

                my $Success;

                # if there is no customer present in the chat
                # just remove the chat
                if ( !$CustomerPresent ) {
                    $Success = $ChatObject->ChatDelete(
                        ChatID => $GetParam{FromChatID},
                    );
                }

                # otherwise set chat status to closed and inform other agents
                else {
                    $Success = $ChatObject->ChatUpdate(
                        ChatID     => $GetParam{FromChatID},
                        Status     => 'closed',
                        Deprecated => 1,
                    );

                    # get user data
                    my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                        UserID => $Self->{UserID},
                    );

                    my $RequesterName = $User{UserFullname};
                    $RequesterName ||= $Self->{UserID};

                    my $LeaveMessage = $Kernel::OM->Get('Kernel::Language')->Translate(
                        "%s has left the chat.",
                        $RequesterName,
                    );

                    $Success = $ChatObject->ChatMessageAdd(
                        ChatID          => $GetParam{FromChatID},
                        ChatterID       => $Self->{UserID},
                        ChatterType     => 'User',
                        MessageText     => $LeaveMessage,
                        SystemGenerated => 1,
                    );

                    # time after chat will be removed
                    my $ChatTTL = $Kernel::OM->Get('Kernel::Config')->Get('ChatEngine::ChatTTL');

                    my $ChatClosedMessage = $Kernel::OM->Get('Kernel::Language')->Translate(
                        "This chat has been closed and will be removed in %s hours.",
                        $ChatTTL,
                    );

                    $Success = $ChatObject->ChatMessageAdd(
                        ChatID          => $GetParam{FromChatID},
                        ChatterID       => $Self->{UserID},
                        ChatterType     => 'User',
                        MessageText     => $ChatClosedMessage,
                        SystemGenerated => 1,
                    );

                    # remove all AGENT participants from chat
                    my @ParticipantsList = $ChatObject->ChatParticipantList(
                        ChatID => $GetParam{FromChatID},
                    );
                    CHATPARTICIPANT:
                    for my $ChatParticipant (@ParticipantsList) {

                        # skip it this participant is not agent
                        next CHATPARTICIPANT if $ChatParticipant->{ChatterType} ne 'User';

                        # remove this participants from the chat
                        $Success = $ChatObject->ChatParticipantRemove(
                            ChatID      => $GetParam{FromChatID},
                            ChatterID   => $ChatParticipant->{ChatterID},
                            ChatterType => 'User',
                        );
                    }
                }
            }
        }

        # set owner (if new user id is given)
        if ( $GetParam{NewUserID} ) {
            $TicketObject->TicketOwnerSet(
                TicketID  => $TicketID,
                NewUserID => $GetParam{NewUserID},
                UserID    => $Self->{UserID},
            );

            # set lock
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );
        }

        # else set owner to current agent but do not lock it
        else {
            $TicketObject->TicketOwnerSet(
                TicketID           => $TicketID,
                NewUserID          => $Self->{UserID},
                SendNoNotification => 1,
                UserID             => $Self->{UserID},
            );
        }

        # set responsible (if new user id is given)
        if ( $GetParam{NewResponsibleID} ) {
            $TicketObject->TicketResponsibleSet(
                TicketID  => $TicketID,
                NewUserID => $GetParam{NewResponsibleID},
                UserID    => $Self->{UserID},
            );
        }

        # time accounting
        if ( $GetParam{TimeUnits} ) {
            $TicketObject->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $GetParam{TimeUnits},
                UserID    => $Self->{UserID},
            );
        }

        # write attachments
        for my $Attachment (@AttachmentData) {
            $ArticleBackendObject->ArticleWriteAttachment(
                %{$Attachment},
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
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

        # link tickets
        if (
            $GetParam{LinkTicketID}
            && $Config->{SplitLinkType}
            && $Config->{SplitLinkType}->{LinkType}
            && $Config->{SplitLinkType}->{Direction}
            )
        {
            my $Access = $TicketObject->TicketPermission(
                Type     => 'ro',
                TicketID => $GetParam{LinkTicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $LayoutObject->NoPermission(
                    Message    => Translatable('You need ro permission!'),
                    WithHeader => 'yes',
                );
            }

            my $SourceKey = $GetParam{LinkTicketID};
            my $TargetKey = $TicketID;

            if ( $Config->{SplitLinkType}->{Direction} eq 'Source' ) {
                $SourceKey = $TicketID;
                $TargetKey = $GetParam{LinkTicketID};
            }

            # link the tickets
            $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
                SourceObject => 'Ticket',
                SourceKey    => $SourceKey,
                TargetObject => 'Ticket',
                TargetKey    => $TargetKey,
                Type         => $Config->{SplitLinkType}->{LinkType} || 'Normal',
                State        => 'Valid',
                UserID       => $Self->{UserID},
            );
        }

        # closed tickets get unlocked
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $TicketObject->TicketPendingTimeSet(
                UserID   => $Self->{UserID},
                TicketID => $TicketID,
                %GetParam,
            );
        }

        # get redirect screen
        my $NextScreen = $Self->{UserCreateNextMask} || 'AgentTicketPhone';

        # redirect
        return $LayoutObject->Redirect(
            OP => "Action=$NextScreen;Subaction=Created;TicketID=$TicketID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Dest           = $ParamObject->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser   = $ParamObject->GetParam( Param => 'SelectedCustomerUser' );
        my $ElementChanged = $ParamObject->GetParam( Param => 'ElementChanged' ) || '';
        my $QueueID        = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
        }
        $GetParam{Dest}    = $Dest;
        $GetParam{QueueID} = $QueueID;

        # get list type
        my $TreeView = 0;
        if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

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
        my %ChangedElements = $ElementChanged ? ( $ElementChanged => 1 ) : ();
        if ( $ChangedElements{ServiceID} ) {
            $ChangedElements{CustomerUserID} = 1;
            $ChangedElements{CustomerID}     = 1;

            if ( $GetParam{From} ) {
                my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                    User => $CustomerUser,
                );
                $GetParam{CustomerID} = $CustomerData{CustomerID};
            }
        }
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
                    Dest               => 'QueueID',
                    NewUserID          => 'NewUserID',
                    NewResponsibleID   => 'NewResponsibleID',
                    NextStateID        => 'NextStateID',
                    PriorityID         => 'PriorityID',
                    ServiceID          => 'ServiceID',
                    SLAID              => 'SLAID',
                    StandardTemplateID => 'StandardTemplateID',
                    TypeID             => 'TypeID',
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
                for my $Field ( @{ $Self->{FieldMethods} } ) {
                    next METHOD if !$Check{ $Field->{FieldID} };

                    # use $Check{ $Field->{FieldID} } for Dest=>QueueID
                    $StdFieldValues{ $Check{ $Field->{FieldID} } } = $Field->{Method}->(
                        $Self,
                        %GetParam,
                        OwnerID        => $GetParam{NewUserID},
                        CustomerUserID => $CustomerUser || '',
                        QueueID        => $GetParam{QueueID},
                        Services       => $StdFieldValues{ServiceID} || undef,    # needed for SLAID
                    );

                    # special stuff for QueueID/Dest: Dest is "QueueID||QueueName" => "QueueName";
                    if ( $Field->{FieldID} eq 'Dest' ) {
                        TOs:
                        for my $QueueID ( sort keys %{ $StdFieldValues{QueueID} } ) {
                            next TOs if ( $StdFieldValues{QueueID}{$QueueID} eq '-' );
                            $StdFieldValues{Dest}{"$QueueID||$StdFieldValues{QueueID}{ $QueueID }"} = $StdFieldValues{QueueID}{$QueueID};
                        }

                        # check current selection of QueueID (Dest will be done together with the other fields)
                        if ( $GetParam{QueueID} && !$StdFieldValues{Dest}{ $GetParam{Dest} } ) {
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
                    FormID                    => $Self->{FormID},
                    CustomerUser              => $CustomerUser || '',
                    GetParam                  => {
                        %GetParam,
                        OwnerID => $GetParam{NewUserID},
                    },
                    Autoselect      => $Autoselect,
                    ACLPreselection => $ACLPreselection,
                    LoopProtection  => \$LoopProtection,
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

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle through the activated Dynamic Fields for this screen
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
        for my $Field ( sort keys %StdFieldValues ) {
            push @StdFieldAJAX, {
                Name       => $Field,
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
                    TemplateID     => $GetParam{StandardTemplateID},
                    UserID         => $Self->{UserID},
                    CustomerUserID => $CustomerUser,
                );

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
                    Name => 'UseTemplateCreate',
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
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No Subaction!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    # use default Queue if none is provided
    $Param{QueueID} = $Param{QueueID} || 1;

    my %NextStates;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{OwnerAll} ) {
        my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(%Param);
        for my $KeyGroupMember ( sort keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $KeyGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$KeyGroupMember};
            }
        }
    }

    # show all system users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are owner or rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID        = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'owner',
        );
        for my $KeyMember ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$KeyMember} ) {
                $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
            }
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'Owner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetResponsibles {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{ResponsibleAll} ) {
        my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(%Param);
        for my $KeyGroupMember ( sort keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $KeyGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$KeyGroupMember};
            }
        }
    }

    # show all system users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are responsible or rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID        = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'responsible',
        );
        for my $KeyMember ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$KeyMember} ) {
                $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
            }
        }
    }

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

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # use default Queue if none is provided
    $Param{QueueID} = $Param{QueueID} || 1;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # use default Queue if none is provided
    $Param{QueueID} = $Param{QueueID} || 1;

    # get type
    my %Type;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # use default Queue if none is provided
    $Param{QueueID} = $Param{QueueID} || 1;

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
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # use default Queue if none is provided
    $Param{QueueID} = $Param{QueueID} || 1;

    # get services if they were not determined in an AJAX call
    if ( !defined $Param{Services} ) {
        $Param{Services} = $Self->_GetServices(%Param);
    }

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
                %Param,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
    }
    return \%SLA;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check own selection
    my %NewTos;
    if ( $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewTos = %{ $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
        if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Tos = $Kernel::OM->Get('Kernel::System::Ticket')->MoveList(
                %Param,
                Type    => 'create',
                Action  => $Self->{Action},
                QueueID => $Self->{QueueID},
                UserID  => $Self->{UserID},
            );
        }
        else {
            %Tos = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList();
        }

        # get create permission queues
        my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'create',
        );

        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

        # build selection string
        QUEUEID:
        for my $QueueID ( sort keys %Tos ) {

            my %QueueData = $QueueObject->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next QUEUEID if !$UserGroups{ $QueueData{GroupID} };

            my $String = $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;

            # remove trailing spaces
            if ( !$QueueData{Comment} ) {
                $String =~ s{\s+\z}{};
            }

            if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' ) {
                my %SystemAddressData = $SystemAddressObject->SystemAddressGet(
                    ID => $Tos{$QueueID},
                );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$QueueID} = $String;
        }
    }

    # add empty selection
    $NewTos{''} = '-';

    return \%NewTos;
}

sub _GetTimeUnits {
    my ( $Self, %Param ) = @_;

    my $AccountedTime = '';

    # Get accounted time if AccountTime config item is enabled.
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::AccountTime') && defined $Param{ArticleID} ) {
        $AccountedTime = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleAccountedTimeGet(
            ArticleID => $Param{ArticleID},
        );
    }

    return $AccountedTime ? $AccountedTime : '';
}

sub _GetStandardTemplates {
    my ( $Self, %Param ) = @_;

    my %Templates;
    my $QueueID = $Param{QueueID} || '';

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

    if ( !$QueueID ) {
        my $UserDefaultQueue = $ConfigObject->Get('Ticket::Frontend::UserDefaultQueue') || '';

        if ($UserDefaultQueue) {
            $QueueID = $QueueObject->QueueLookup( Queue => $UserDefaultQueue );
        }
    }

    # check needed
    return \%Templates if !$QueueID && !$Param{TicketID};

    if ( !$QueueID && $Param{TicketID} ) {

        # get QueueID from the ticket
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );
        $QueueID = $Ticket{QueueID} || '';
    }

    # fetch all std. templates
    my %StandardTemplates = $QueueObject->QueueStandardTemplateMemberList(
        QueueID       => $QueueID,
        TemplateTypes => 1,
    );

    # return empty hash if there are no templates for this screen
    return \%Templates if !IsHashRefWithData( $StandardTemplates{Create} );

    # return just the templates for this screen
    return $StandardTemplates{Create};
}

sub _MaskPhoneNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # set JS data
    $LayoutObject->AddJSData(
        Key   => 'CustomerSearch',
        Value => {
            ShowCustomerTickets => $ConfigObject->Get('Ticket::Frontend::ShowCustomerTickets'),
            AllowMultipleFrom   => $ConfigObject->Get('Ticket::Frontend::AgentTicketPhone::AllowMultipleFrom'),
        },
    );

    if ( $Param{HideAutoselected} ) {

        # add Autoselect JS
        $LayoutObject->AddJSOnDocumentComplete(
            Code => "Core.Form.InitHideAutoselected({ FieldIDs: $Param{HideAutoselected} });",
        );
    }

    # build string
    $Param{OptionStrg} = $LayoutObject->BuildSelection(
        Data         => $Param{Users},
        SelectedID   => $Param{UserSelected},
        Class        => 'Modernize FormUpdate',
        Translation  => 0,
        Name         => 'NewUserID',
        PossibleNone => 1,
    );

    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # build next states string
    $Param{NextStatesStrg} = $LayoutObject->BuildSelection(
        Data          => $Param{NextStates},
        Name          => 'NextStateID',
        Class         => 'Modernize FormUpdate',
        Translation   => 1,
        SelectedValue => $Param{NextState} || $Config->{StateDefault},
    );

    # build to string
    my %NewTo;
    if ( $Param{To} ) {
        for my $KeyTo ( sort keys %{ $Param{To} } ) {
            $NewTo{"$KeyTo||$Param{To}->{$KeyTo}"} = $Param{To}->{$KeyTo};
        }
    }
    if ( !$Param{ToSelected} ) {
        my $UserDefaultQueue = $ConfigObject->Get('Ticket::Frontend::UserDefaultQueue') || '';

        if ($UserDefaultQueue) {
            my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $UserDefaultQueue );
            if ($QueueID) {
                $Param{ToSelected} = "$QueueID||$UserDefaultQueue";
            }
        }
    }

    if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
        $Param{ToStrg} = $LayoutObject->AgentQueueListOption(
            Class          => 'Validate_Required Modernize FormUpdate',
            Data           => \%NewTo,
            Multiple       => 0,
            Size           => 0,
            Name           => 'Dest',
            TreeView       => $TreeView,
            SelectedID     => $Param{ToSelected},
            OnChangeSubmit => 0,
        );
    }
    else {
        $Param{ToStrg} = $LayoutObject->BuildSelection(
            Class       => 'Validate_Required Modernize FormUpdate',
            Data        => \%NewTo,
            Name        => 'Dest',
            TreeView    => $TreeView,
            SelectedID  => $Param{ToSelected},
            Translation => $TreeView,
        );
    }

    # customer info string
    if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoCompose') ) {
        $Param{CustomerTable} = $LayoutObject->AgentCustomerViewTable(
            Data => $Param{CustomerData},
            Max  => $ConfigObject->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );
        $LayoutObject->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $KeyError ( sort keys %{ $Param{Errors} } ) {
            $Param{$KeyError} = '* ' . $LayoutObject->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
        }
    }

    # From external
    my $ShowErrors = 1;
    if (
        defined $Param{FromExternalCustomer} &&
        defined $Param{FromExternalCustomer}->{Email} &&
        defined $Param{FromExternalCustomer}->{Customer}
        )
    {
        $ShowErrors = 0;
        $LayoutObject->AddJSData(
            Key   => 'FromExternalCustomerName',
            Value => $Param{FromExternalCustomer}->{Customer},
        );
        $LayoutObject->AddJSData(
            Key   => 'FromExternalCustomerEmail',
            Value => $Param{FromExternalCustomer}->{Email},
        );
    }
    my $CustomerCounter = 0;
    if ( $Param{MultipleCustomer} ) {
        for my $Item ( @{ $Param{MultipleCustomer} } ) {
            if ( !$ShowErrors ) {

                # set empty values for errors
                $Item->{CustomerError}    = '';
                $Item->{CustomerDisabled} = '';
                $Item->{CustomerErrorMsg} = 'CustomerGenericServerErrorMsg';
            }
            $LayoutObject->Block(
                Name => 'MultipleCustomer',
                Data => $Item,
            );
            $LayoutObject->Block(
                Name => $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $LayoutObject->Block(
                    Name => 'CustomerErrorExplantion',
                );
            }
            $CustomerCounter++;
        }
    }

    if ( !$CustomerCounter ) {
        $Param{CustomerHiddenContainer} = 'Hidden';
    }

    # set customer counter
    $LayoutObject->Block(
        Name => 'MultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounter++,
        },
    );

    if ( $Param{FromInvalid} && $Param{Errors} && !$Param{Errors}->{FromErrorType} ) {
        $LayoutObject->Block( Name => 'FromServerErrorMsg' );
    }
    if ( $Param{Errors}->{FromErrorType} || !$ShowErrors ) {
        $Param{FromInvalid} = '';
    }

    # build type string
    if ( $ConfigObject->Get('Ticket::Type') ) {
        $Param{TypeStrg} = $LayoutObject->BuildSelection(
            Class        => 'Modernize Validate_Required FormUpdate' . ( $Param{Errors}->{TypeIDInvalid} || ' ' ),
            Data         => $Param{Types},
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 1,
        );
        $LayoutObject->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # build service string
    if ( $ConfigObject->Get('Ticket::Service') ) {

        $Param{ServiceStrg} = $LayoutObject->BuildSelection(
            Data  => $Param{Services},
            Name  => 'ServiceID',
            Class => 'Modernize FormUpdate '
                . ( $Config->{ServiceMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{Errors}->{ServiceIDInvalid} || '' ),
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => $TreeView,
            Max          => 200,
        );
        $LayoutObject->Block(
            Name => 'TicketService',
            Data => {
                ServiceMandatory => $Config->{ServiceMandatory} || 0,
                %Param,
            },
        );

        $Param{SLAStrg} = $LayoutObject->BuildSelection(
            Data       => $Param{SLAs},
            Name       => 'SLAID',
            SelectedID => $Param{SLAID},
            Class      => 'Modernize FormUpdate '
                . ( $Config->{SLAMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{Errors}->{SLAInvalid} || '' ),
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 1,
            Max          => 200,
        );
        $LayoutObject->Block(
            Name => 'TicketSLA',
            Data => {
                SLAMandatory => $Config->{SLAMandatory} || 0,
                %Param
            },
        );
    }

    # check if exists create templates regardless the queue
    my %StandardTemplates = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList(
        Valid => 1,
        Type  => 'Create',
    );

    # build text template string
    if ( IsHashRefWithData( \%StandardTemplates ) ) {
        $Param{StandardTemplateStrg} = $LayoutObject->BuildSelection(
            Data         => $Param{StandardTemplates} || {},
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

    # build priority string
    if ( !$Param{PriorityID} ) {
        $Param{Priority} = $Config->{Priority};
    }
    $Param{PriorityStrg} = $LayoutObject->BuildSelection(
        Class         => 'Modernize FormUpdate',
        Data          => $Param{Priorities},
        Name          => 'PriorityID',
        SelectedID    => $Param{PriorityID},
        SelectedValue => $Param{Priority},
        Translation   => 1,
    );

    my $QuickDateButtons = $Config->{QuickDateButtons} // $ConfigObject->Get('Ticket::Frontend::DefaultQuickDateButtons');

    # pending data string
    $Param{PendingDateString} = $LayoutObject->BuildDateSelection(
        %Param,
        Format               => 'DateInputFormatLong',
        YearPeriodPast       => 0,
        YearPeriodFuture     => 5,
        DiffTime             => $ConfigObject->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Class                => $Param{Errors}->{DateInvalid},
        Validate             => 1,
        ValidateDateInFuture => 1,
        QuickDateButtons     => $QuickDateButtons,
    );

    # show owner selection
    if ( $ConfigObject->Get('Ticket::Frontend::NewOwnerSelection') ) {
        $LayoutObject->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
    }

    # show responsible selection
    if (
        $ConfigObject->Get('Ticket::Responsible')
        && $ConfigObject->Get('Ticket::Frontend::NewResponsibleSelection')
        )
    {
        $Param{ResponsibleUsers}->{''} = '-';
        $Param{ResponsibleOptionStrg} = $LayoutObject->BuildSelection(
            Data       => $Param{ResponsibleUsers},
            SelectedID => $Param{ResponsibleUserSelected},
            Name       => 'NewResponsibleID',
            Class      => 'Modernize FormUpdate',
        );
        $LayoutObject->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
    }

    # render dynamic fields
    $Param{DynamicFieldHTML} = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
        Content              => $Self->{MaskDefinition},
        DynamicFields        => $Self->{DynamicField},
        LayoutObject         => $LayoutObject,
        ParamObject          => $Kernel::OM->Get('Kernel::System::Web::Request'),
        DynamicFieldValues   => $Param{DynamicField},
        PossibleValuesFilter => $Param{DFPossibleValues},
        Errors               => $Param{DFErrors},
        Visibility           => $Param{Visibility},
        Object               => {
            CustomerID     => $Param{CustomerID},
            CustomerUserID => $Param{CustomerUser},
            UserID         => $Self->{UserID},
            $Param{DynamicField}->%*,
        },
    );

    # show time accounting box
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        if ( $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') ) {
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
            $Param{TimeUnitsRequired} = '';
        }
        $LayoutObject->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # show customer edit link
    my $OptionCustomer = $LayoutObject->Permission(
        Action => 'AdminCustomerUser',
        Type   => 'rw',
    );

    my $ShownOptionsBlock;

    if ($OptionCustomer) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $LayoutObject->Block(
                Name => 'TicketOptions',
                Data => {
                    %Param,
                },
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $LayoutObject->Block(
            Name => 'OptionCustomer',
            Data => {
                %Param,
            },
        );
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

    # Permissions have been checked before in Run()
    if ( $Param{FromChatID} ) {
        my @ChatMessages = $Kernel::OM->Get('Kernel::System::Chat')->ChatMessageList(
            ChatID => $Param{FromChatID},
        );

        for my $Message (@ChatMessages) {
            $Message->{MessageText} = $LayoutObject->Ascii2Html(
                Text        => $Message->{MessageText},
                LinkFeature => 1,
            );
        }

        $LayoutObject->Block(
            Name => 'ChatArticlePreview',
            Data => {
                ChatMessages => \@ChatMessages,
            },
        );
    }

    # get output back
    return $LayoutObject->Output(
        TemplateFile => 'AgentTicketPhone',
        Data         => \%Param,
    );
}

1;
