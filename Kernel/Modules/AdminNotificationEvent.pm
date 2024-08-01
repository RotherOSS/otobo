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

package Kernel::Modules::AdminNotificationEvent;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    if ( !$Param{AccessRw} && $Param{AccessRo} ) {
        $Self->{LightAdmin} = 1;
    }

    # set pref for columns key
    $Self->{PrefKeyIncludeInvalid} = 'IncludeInvalid' . '-' . $Self->{Action};

    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    $Self->{IncludeInvalid} = $Preferences{ $Self->{PrefKeyIncludeInvalid} };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
    my $RichText     = $ConfigObject->Get('Frontend::RichText');
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    # filter out lens fields
    if ( IsArrayRefWithData($DynamicField) ) {
        $DynamicField = [ grep { $_->{FieldType} ne 'Lens' } $DynamicField->@* ];
    }

    if ( $RichText && !$ConfigObject->Get("Frontend::Admin::$Self->{Action}")->{RichText} ) {
        $RichText = 0;
    }

    # set type for notifications
    my $ContentType = 'text/plain';
    if ($RichText) {
        $ContentType = 'text/html';
    }

    my $ParamObject             = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject            = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
    my $BackendObject           = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $MainObject              = $Kernel::OM->Get('Kernel::System::Main');
    my $Notification            = $ParamObject->GetParam( Param => 'Notification' );

    $Param{IncludeInvalid} = $ParamObject->GetParam( Param => 'IncludeInvalid' );

    if ( defined $Param{IncludeInvalid} ) {
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $Self->{UserID},
            Key    => $Self->{PrefKeyIncludeInvalid},
            Value  => $Param{IncludeInvalid},
        );

        $Self->{IncludeInvalid} = $Param{IncludeInvalid};
    }

    # get the search article fields to retrieve values for
    my %ArticleSearchableFields     = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchableFieldsList();
    my @ArticleSearchableFieldsKeys = sort keys %ArticleSearchableFields;

    # get registered transport layers
    my %RegisteredTransports = %{ $Kernel::OM->Get('Kernel::Config')->Get('Notification::Transport') || {} };

    # Get permission level.
    my $Permission = $Self->{LightAdmin} ? '' : 'rw';

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        # get notification id
        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';

        # get notification data
        my %Data = $NotificationEventObject->NotificationGet(
            ID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        if ( $Self->{LightAdmin} ) {
            $Data{Permission} = $QueueObject->QueueListPermission(
                QueueIDs => $Data{Data}{QueueID},
                UserID   => $Self->{UserID},
            );

            # No permission for the notification.
            if ( !$Data{Permission} ) {
                %Data = ();
            }
            elsif ( $Data{Permission} eq 'ro' ) {
                $Output .= $LayoutObject->Notify(
                    Priority => 'Notice',
                    Data     => $LayoutObject->{LanguageObject}->Translate('No permission to edit this ticket notification.'),
                );
            }
        }

        $Output .= $LayoutObject->Notify( Info => Translatable('Notification updated!') )
            if ( $Notification && $Notification eq 'Update' );
        $Self->_Edit(
            %Data,
            Action             => 'Change',
            RichText           => $RichText,
            DynamicFieldValues => $Data{Data},
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminNotificationEvent',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # TODO:
        # Events, IsVisibleForCustomer, ArticleSenderTypeID, ArticleIsVisibleForCustomer,
        # ArticleCommunicationChannelID, Transports are used twice! Why? See below.
        # The same is done in the other subactions.
        # Also check each transport (Email, SMS, Webview) template file for duplicate ids like IsVisibleForCustomer!

        my %GetParam;
        for my $Parameter (
            @ArticleSearchableFieldsKeys,
            qw(ID Name Comment ValidID Events IsVisibleForCustomer
            ArticleSenderTypeID ArticleIsVisibleForCustomer ArticleCommunicationChannelID
            Transports)
            )
        {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }
        PARAMETER:
        for my $Parameter (
            @ArticleSearchableFieldsKeys,
            qw(Recipients RecipientAgents RecipientGroups RecipientRoles
            Events StateID QueueID PriorityID LockID TypeID ServiceID SLAID
            CustomerID CustomerUserID IsVisibleForCustomer ArticleAttachmentInclude
            ArticleSenderTypeID ArticleIsVisibleForCustomer ArticleCommunicationChannelID
            Transports OncePerDay SendOnOutOfOffice CalendarFilter VisibleForAgent
            VisibleForAgentTooltip LanguageID AgentEnabledByDefault)
            )
        {
            my @Data = $ParamObject->GetArray( Param => $Parameter );
            next PARAMETER if !@Data;
            $GetParam{Data}->{$Parameter} = \@Data;
        }

        my $Error;

        # get the subject and body for all languages
        for my $LanguageID ( @{ $GetParam{Data}->{LanguageID} } ) {

            my $Subject = $ParamObject->GetParam( Param => $LanguageID . '_Subject' ) || '';
            my $Body    = $ParamObject->GetParam( Param => $LanguageID . '_Body' )    || '';

            $GetParam{Message}->{$LanguageID} = {
                Subject     => $Subject,
                Body        => $Body,
                ContentType => $ContentType,
            };

            my $Check = $NotificationEventObject->NotificationBodyCheck(
                Content => $Body,
                UserID  => $Self->{UserID},
            );

            # set server error flag if field is empty
            if ( !$Subject ) {
                $GetParam{ $LanguageID . '_SubjectServerError' } = "ServerError";
                $Error = 1;
            }
            if ( !$Body || !$Check ) {
                $GetParam{ $LanguageID . '_BodyServerError' } = "ServerError";
                $Error = 1;
            }
        }

        if ( $Self->{LightAdmin} ) {
            $Permission = $QueueObject->QueueListPermission(
                QueueIDs => $GetParam{Data}->{QueueID},
                UserID   => $Self->{UserID},
            );

            # Queue is mandatory and can only contain queues with 'rw' permission.
            if ( !$GetParam{Data}->{QueueID} || $Permission ne 'rw' ) {
                $GetParam{QueueIDServerError} = "ServerError";
                $Error = 1;
            }
        }

        # to store dynamic fields profile data
        my %DynamicFieldValues;

        # get Dynamic fields for search from web request
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # extract the dynamic field value from the web request
            my $DynamicFieldValue = $BackendObject->SearchFieldValueGet(
                DynamicFieldConfig     => $DynamicFieldConfig,
                ParamObject            => $ParamObject,
                ReturnProfileStructure => 1,
                LayoutObject           => $LayoutObject,
            );

            # set the complete value structure in GetParam to store it later in the Notification Item
            if ( IsHashRefWithData($DynamicFieldValue) ) {

                # set search structure for display
                %DynamicFieldValues = ( %DynamicFieldValues, %{$DynamicFieldValue} );

                #make all values array refs
                for my $FieldName ( sort keys %{$DynamicFieldValue} ) {
                    if ( ref $DynamicFieldValue->{$FieldName} ne 'ARRAY' ) {
                        $DynamicFieldValue->{$FieldName} = [ $DynamicFieldValue->{$FieldName} ];
                    }
                }

                # store special structure for match
                $GetParam{Data} = { %{ $GetParam{Data} }, %{$DynamicFieldValue} };
            }
        }

        # get transport settings values
        if ( IsHashRefWithData( \%RegisteredTransports ) ) {

            TRANSPORT:
            for my $Transport ( sort keys %RegisteredTransports ) {

                next TRANSPORT if !IsHashRefWithData( $RegisteredTransports{$Transport} );
                next TRANSPORT if !$RegisteredTransports{$Transport}->{Module};

                if ( !$MainObject->Require( $RegisteredTransports{$Transport}->{Module}, Silent => 1 ) ) {
                    next TRANSPORT;
                }

                # get transport settings string from transport object
                $Kernel::OM->Get( $RegisteredTransports{$Transport}->{Module} )->TransportParamSettingsGet(
                    GetParam => \%GetParam,
                );
            }
        }

        # Check for 'Additional recipient' field value length.
        if ( $GetParam{Data}->{RecipientEmail} && length $GetParam{Data}->{RecipientEmail} > 200 ) {
            $GetParam{RecipientEmailServerError} = "ServerError";
            $Error = 1;
        }

        # update
        my $Ok;
        my $ArticleFilterMissing;

        # checking if article filter exist if necessary
        if (
            grep { $_ eq 'ArticleCreate' || $_ eq 'ArticleSend' }
            @{ $GetParam{Data}->{Events} || [] }
            )
        {
            my $ArticleFilterValueSet = 0;
            for my $ArticleFilter (qw(ArticleSenderTypeID ArticleIsVisibleForCustomer ArticleCommunicationChannelID)) {
                if ( $GetParam{$ArticleFilter} ) {
                    $ArticleFilterValueSet = 1;
                }
            }

            ARTICLEFIELDKEY:
            for my $ArticleFieldKey (@ArticleSearchableFieldsKeys) {

                last ARTICLEFIELDKEY if $ArticleFilterValueSet;
                next ARTICLEFIELDKEY if !$GetParam{$ArticleFieldKey};

                $ArticleFilterValueSet = 1;

                last ARTICLEFIELDKEY;
            }

            $ArticleFilterMissing = 1 if !$ArticleFilterValueSet;
        }

        # required Article filter only on ArticleCreate and ArticleSend event
        # if isn't selected at least one of the article filter fields, notification isn't updated
        if ( !$ArticleFilterMissing && !$Error ) {

            $Ok = $NotificationEventObject->NotificationUpdate(
                %GetParam,
                UserID => $Self->{UserID},
            );
        }

        if ($Ok) {

            # if the user would like to continue editing the notification event, just redirect to the edit screen
            if (
                defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
                && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
                )
            {
                my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
                return $LayoutObject->Redirect(
                    OP => "Action=$Self->{Action};Subaction=Change;ID=$ID;Notification=Update",
                );
            }
            else {

                # otherwise return to overview
                return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
            }
        }
        else {
            for my $Needed (qw(Name Events Transports)) {
                $GetParam{ $Needed . "ServerError" } = "";
                if ( $GetParam{$Needed} eq '' ) {
                    $GetParam{ $Needed . "ServerError" } = "ServerError";
                }
            }

            # define ServerError Class attribute if necessary
            $GetParam{ArticleSenderTypeIDServerError} = "";

            if ($ArticleFilterMissing) {

                $GetParam{ArticleSenderTypeIDServerError} = "ServerError";

                for my $ArticleField (@ArticleSearchableFieldsKeys) {
                    $GetParam{ $ArticleField . 'ServerError' } = "ServerError";
                }
            }

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Notify( Priority => 'Error' );
            $Self->_Edit(
                %GetParam,
                Action             => 'Change',
                RichText           => $RichText,
                DynamicFieldValues => \%DynamicFieldValues,
            );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminNotificationEvent',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action   => 'Add',
            RichText => $RichText,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminNotificationEvent',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %GetParam;
        for my $Parameter (
            @ArticleSearchableFieldsKeys,
            qw(Name Comment ValidID Events IsVisibleForCustomer
            ArticleSenderTypeID ArticleIsVisibleForCustomer ArticleCommunicationChannelID
            Transports)
            )
        {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }
        PARAMETER:
        for my $Parameter (
            @ArticleSearchableFieldsKeys,
            qw(Recipients RecipientAgents RecipientRoles RecipientGroups Events StateID QueueID
            PriorityID LockID TypeID ServiceID SLAID CustomerID CustomerUserID
            IsVisibleForCustomer ArticleAttachmentInclude
            ArticleSenderTypeID ArticleIsVisibleForCustomer ArticleCommunicationChannelID
            Transports OncePerDay SendOnOutOfOffice CalendarFilter VisibleForAgent
            VisibleForAgentTooltip LanguageID AgentEnabledByDefault)
            )
        {
            my @Data = $ParamObject->GetArray( Param => $Parameter );
            next PARAMETER if !@Data;
            $GetParam{Data}->{$Parameter} = \@Data;
        }

        my $Error;

        # get the subject and body for all languages
        for my $LanguageID ( @{ $GetParam{Data}->{LanguageID} } ) {

            my $Subject = $ParamObject->GetParam( Param => $LanguageID . '_Subject' ) || '';
            my $Body    = $ParamObject->GetParam( Param => $LanguageID . '_Body' )    || '';

            $GetParam{Message}->{$LanguageID} = {
                Subject     => $Subject,
                Body        => $Body,
                ContentType => $ContentType,
            };

            my $Check = $NotificationEventObject->NotificationBodyCheck(
                Content => $Body,
                UserID  => $Self->{UserID},
            );

            # set server error flag if field is empty
            if ( !$Subject ) {
                $GetParam{ $LanguageID . '_SubjectServerError' } = "ServerError";
                $Error = 1;
            }
            if ( !$Body || !$Check ) {
                $GetParam{ $LanguageID . '_BodyServerError' } = "ServerError";
                $Error = 1;
            }
        }

        if ( $Self->{LightAdmin} ) {
            $Permission = $QueueObject->QueueListPermission(
                QueueIDs => $GetParam{Data}->{QueueID},
                UserID   => $Self->{UserID},
            );

            # Queue is mandatory and can only contain queues with 'rw' permission.
            if ( !$GetParam{Data}->{QueueID} || $Permission ne 'rw' ) {
                $GetParam{QueueIDServerError} = "ServerError";
                $Error = 1;
            }
        }

        # to store dynamic fields profile data
        my %DynamicFieldValues;

        # get Dynamic fields for search from web request
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # extract the dynamic field value from the web request
            my $DynamicFieldValue = $BackendObject->SearchFieldValueGet(
                DynamicFieldConfig     => $DynamicFieldConfig,
                ParamObject            => $ParamObject,
                ReturnProfileStructure => 1,
                LayoutObject           => $LayoutObject,
            );

            # set the complete value structure in GetParam to store it later in the Generic Agent Job
            if ( IsHashRefWithData($DynamicFieldValue) ) {

                # set search structure for display
                %DynamicFieldValues = ( %DynamicFieldValues, %{$DynamicFieldValue} );

                #make all values array refs
                for my $FieldName ( sort keys %{$DynamicFieldValue} ) {
                    if ( ref $DynamicFieldValue->{$FieldName} ne 'ARRAY' ) {
                        $DynamicFieldValue->{$FieldName} = [ $DynamicFieldValue->{$FieldName} ];
                    }
                }

                # store special structure for match
                $GetParam{Data} = { %{ $GetParam{Data} }, %{$DynamicFieldValue} };
            }
        }

        # get transport settings values
        if ( IsHashRefWithData( \%RegisteredTransports ) ) {

            TRANSPORT:
            for my $Transport ( sort keys %RegisteredTransports ) {

                next TRANSPORT if !IsHashRefWithData( $RegisteredTransports{$Transport} );
                next TRANSPORT if !$RegisteredTransports{$Transport}->{Module};

                if ( !$MainObject->Require( $RegisteredTransports{$Transport}->{Module}, Silent => 1 ) ) {
                    next TRANSPORT;
                }

                # get transport settings string from transport object
                $Kernel::OM->Get( $RegisteredTransports{$Transport}->{Module} )->TransportParamSettingsGet(
                    GetParam => \%GetParam,
                );
            }
        }

        # Check for 'Additional recipient' field value length.
        if ( $GetParam{Data}->{RecipientEmail} && length $GetParam{Data}->{RecipientEmail} > 200 ) {
            $GetParam{RecipientEmailServerError} = "ServerError";
            $Error = 1;
        }

        # add
        my $ID;
        my $ArticleFilterMissing;

        # define ServerError Message if necessary
        if (
            grep { $_ eq 'ArticleCreate' || $_ eq 'ArticleSend' }
            @{ $GetParam{Data}->{Events} || [] }
            )
        {
            my $ArticleFilterValueSet = 0;
            for my $ArticleFilter (qw(ArticleSenderTypeID ArticleIsVisibleForCustomer ArticleCommunicationChannelID)) {
                if ( $GetParam{$ArticleFilter} ) {
                    $ArticleFilterValueSet = 1;
                }
            }

            ARTICLEFIELDKEY:
            for my $ArticleFieldKey (@ArticleSearchableFieldsKeys) {

                last ARTICLEFIELDKEY if $ArticleFilterValueSet;
                next ARTICLEFIELDKEY if !$GetParam{$ArticleFieldKey};

                $ArticleFilterValueSet = 1;

                last ARTICLEFIELDKEY;
            }

            $ArticleFilterMissing = 1 if !$ArticleFilterValueSet;
        }

        # required Article filter only on ArticleCreate and Article Send event
        # if isn't selected at least one of the article filter fields, notification isn't added
        if ( !$ArticleFilterMissing && !$Error ) {
            $ID = $NotificationEventObject->NotificationAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );
        }

        if ( !$GetParam{Data}->{Transports} ) {
            $GetParam{TransportServerError} = "ServerError";
        }

        if ($ID) {
            $Self->_Overview();
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Notify( Info => Translatable('Notification added!') );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminNotificationEvent',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }
        else {
            for my $Needed (qw(Name Events Transports)) {
                $GetParam{ $Needed . "ServerError" } = "";
                if ( $GetParam{$Needed} eq '' ) {
                    $GetParam{ $Needed . "ServerError" } = "ServerError";
                }
            }

            # checking if article filter exist if necessary
            $GetParam{ArticleSenderTypeIDServerError} = "";

            if ($ArticleFilterMissing) {

                $GetParam{ArticleSenderTypeIDServerError} = "ServerError";

                for my $ArticleField (@ArticleSearchableFieldsKeys) {
                    $GetParam{ $ArticleField . 'ServerError' } = "ServerError";
                }
            }

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Notify( Priority => 'Error' );
            $Self->_Edit(
                %GetParam,
                Action             => 'Add',
                RichText           => $RichText,
                DynamicFieldValues => \%DynamicFieldValues,
            );
            $Output .= $LayoutObject->Output(
                TemplateFile => 'AdminNotificationEvent',
                Data         => \%Param,
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %GetParam;
        for my $Parameter (qw(ID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        if ( $Self->{LightAdmin} ) {
            my %Notification = $NotificationEventObject->NotificationGet(
                ID     => $GetParam{ID},
                UserID => $Self->{UserID},
            );

            $Permission = $QueueObject->QueueListPermission(
                QueueIDs => $Notification{Data}{QueueID},
                UserID   => $Self->{UserID},
            );
        }

        # No permission to delete the notification.
        if ( $Permission ne 'rw' ) {
            return $LayoutObject->ErrorScreen();
        }

        my $Delete = $NotificationEventObject->NotificationDelete(
            ID     => $GetParam{ID},
            UserID => $Self->{UserID},
        );
        if ( !$Delete ) {
            return $LayoutObject->ErrorScreen();
        }

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # NotificationExport
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'NotificationExport' ) {

        my $NotificationID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my $NotificationData;
        my %NotificationSingleData;
        my $Filename = 'Export_Notification.yml';

        if ($NotificationID) {

            %NotificationSingleData = $NotificationEventObject->NotificationGet(
                ID     => $NotificationID,
                UserID => $Self->{UserID},
            );

            if ( $Self->{LightAdmin} ) {
                $Permission = $QueueObject->QueueListPermission(
                    QueueIDs => $NotificationSingleData{Data}{QueueID},
                    UserID   => $Self->{UserID},
                );
            }

            if ( !IsHashRefWithData( \%NotificationSingleData ) || $Permission ne 'rw' ) {
                return $LayoutObject->ErrorScreen(
                    Message => $LayoutObject->{LanguageObject}->Translate( 'There was an error getting data for Notification with ID:%s!', $NotificationID ),
                );
            }

            my $NotificationName = $NotificationSingleData{Name};
            $NotificationName =~ s{[^a-zA-Z0-9-_]}{_}xmsg;    # cleanup name for saving

            $Filename         = 'Export_Notification_' . $NotificationName . '.yml';
            $NotificationData = [ \%NotificationSingleData ];
        }
        else {

            my %Notificationdetails = $NotificationEventObject->NotificationList(
                UserID  => $Self->{UserID},
                Details => 1,
            );

            my @Data;
            for my $ItemID ( sort keys %Notificationdetails ) {

                # filter out notifications without rw permission on all queues.
                $Permission = $Self->{LightAdmin} ? '' : 'rw';
                if ( $Self->{LightAdmin} ) {
                    $Permission = $QueueObject->QueueListPermission(
                        QueueIDs => $Notificationdetails{$ItemID}{Data}{QueueID},
                        UserID   => $Self->{UserID},
                    );
                }
                if ( $Permission eq 'rw' ) {
                    push @Data, $Notificationdetails{$ItemID};
                }
            }
            $NotificationData = \@Data;
        }

        # convert the Notification data hash to string
        my $NotificationDataYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $NotificationData );

        # send the result to the browser
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $NotificationDataYAML,
            Type        => 'attachment',
            Filename    => $Filename,
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # NotificationCopy
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'NotificationCopy' ) {

        my $NotificationID = $ParamObject->GetParam( Param => 'ID' ) || '';

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get Notification data
        my %NotificationData = $NotificationEventObject->NotificationGet(
            ID     => $NotificationID,
            UserID => $Self->{UserID},
        );

        if ( $Self->{LightAdmin} ) {
            $Permission = $QueueObject->QueueListPermission(
                QueueIDs => $NotificationData{Data}{QueueID},
                UserID   => $Self->{UserID},
            );
        }
        if ( !IsHashRefWithData( \%NotificationData ) || $Permission ne 'rw' ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Unknown Notification %s!', $NotificationID ),
            );
        }

        # create new Notification name
        my $NotificationName = $LayoutObject->{LanguageObject}->Translate( '%s (copy)', $NotificationData{Name} );

        # otherwise save configuration and return to overview screen
        my $NewNotificationID = $NotificationEventObject->NotificationAdd(
            %NotificationData,
            Name   => $NotificationName,
            UserID => $Self->{UserID},
        );

        # show error if can't create
        if ( !$NewNotificationID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable("There was an error creating the Notification"),
            );
        }

        # return to overview
        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # NotificationImport
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'NotificationImport' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $FormID      = $ParamObject->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        # import only works if user has 'rw' permission on all queues.
        if ( $Self->{LightAdmin} ) {
            my $Notifications = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $UploadStuff{Content} );

            my $NoPermission;
            NOTIFICATION:
            for my $Notification ( @{$Notifications} ) {
                $Permission = $QueueObject->QueueListPermission(
                    QueueIDs => $Notification->{Data}->{QueueID},
                    UserID   => $Self->{UserID},
                );
                if ( $Permission ne 'rw' ) {
                    $NoPermission = 1;
                    last NOTIFICATION;
                }
            }
            if ($NoPermission) {
                my $Message = $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', 'rw' );
                return $LayoutObject->ErrorScreen(
                    Message => $Message,
                );
            }
        }

        my $OverwriteExistingNotifications = $ParamObject->GetParam( Param => 'OverwriteExistingNotifications' ) || '';

        my $NotificationImport = $NotificationEventObject->NotificationImport(
            Content                        => $UploadStuff{Content},
            OverwriteExistingNotifications => $OverwriteExistingNotifications,
            UserID                         => $Self->{UserID},
        );

        if ( !$NotificationImport->{Success} ) {
            my $Message = $NotificationImport->{Message}
                || Translatable(
                    'Notifications could not be Imported due to a unknown error, please check OTOBO logs for more information'
                );
            return $LayoutObject->ErrorScreen(
                Message => $Message,
            );
        }

        if ( $NotificationImport->{AddedNotifications} ) {
            push @{ $Param{NotifyData} }, {
                Info => $LayoutObject->{LanguageObject}->Translate(
                    'The following Notifications have been added successfully: %s',
                    $NotificationImport->{AddedNotifications}
                ),
            };
        }
        if ( $NotificationImport->{UpdatedNotifications} ) {
            push @{ $Param{NotifyData} }, {
                Info => $LayoutObject->{LanguageObject}->Translate(
                    'The following Notifications have been updated successfully: %s',
                    $NotificationImport->{UpdatedNotifications}
                ),
            };
        }
        if ( $NotificationImport->{NotificationErrors} ) {
            push @{ $Param{NotifyData} }, {
                Priority => 'Error',
                Info     => $LayoutObject->{LanguageObject}->Translate(
                    'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.',
                    $NotificationImport->{NotificationErrors}
                ),
            };
        }

        $Self->_Overview();
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # show notifications if any
        if ( $Param{NotifyData} ) {
            for my $Notification ( @{ $Param{NotifyData} } ) {
                $Output .= $LayoutObject->Notify(
                    %{$Notification},
                );
            }
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminNotificationEvent',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Info => Translatable('Notification updated!') )
            if ( $Notification && $Notification eq 'Update' );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminNotificationEvent',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    return;
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    $Param{RecipientsStrg} = $LayoutObject->BuildSelection(
        Data => {
            AgentCreateBy             => Translatable('Agent who created the ticket'),
            AgentOwner                => Translatable('Agent who owns the ticket'),
            AgentResponsible          => Translatable('Agent who is responsible for the ticket'),
            AgentWatcher              => Translatable('All agents watching the ticket'),
            AgentWritePermissions     => Translatable('All agents with write permission for the ticket'),
            AgentMyQueues             => Translatable('All agents subscribed to the ticket\'s queue'),
            AgentMyServices           => Translatable('All agents subscribed to the ticket\'s service'),
            AgentMyQueuesMyServices   => Translatable('All agents subscribed to both the ticket\'s queue and service'),
            Customer                  => Translatable('Customer user of the ticket'),
            AllRecipientsFirstArticle => Translatable('All recipients of the first article'),
            AllRecipientsLastArticle  => Translatable('All recipients of the last article'),
        },
        Name       => 'Recipients',
        Multiple   => 1,
        Size       => 8,
        SelectedID => $Param{Data}->{Recipients},
        Class      => 'Modernize W75pc',
    );

    my %AllAgents = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );
    $Param{RecipientAgentsStrg} = $LayoutObject->BuildSelection(
        Data       => \%AllAgents,
        Name       => 'RecipientAgents',
        Multiple   => 1,
        Size       => 4,
        SelectedID => $Param{Data}->{RecipientAgents},
        Class      => 'Modernize W75pc',
    );

    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    $Param{RecipientGroupsStrg} = $LayoutObject->BuildSelection(
        Data       => { $GroupObject->GroupList( Valid => 1 ) },
        Size       => 6,
        Name       => 'RecipientGroups',
        Multiple   => 1,
        SelectedID => $Param{Data}->{RecipientGroups},
        Class      => 'Modernize W75pc',
    );
    $Param{RecipientRolesStrg} = $LayoutObject->BuildSelection(
        Data       => { $GroupObject->RoleList( Valid => 1 ) },
        Size       => 6,
        Name       => 'RecipientRoles',
        Multiple   => 1,
        SelectedID => $Param{Data}->{RecipientRoles},
        Class      => 'Modernize W75pc',
    );

    # Set class name for event string...
    my $EventClass = 'Validate_Required';
    if ( $Param{EventsServerError} ) {
        $EventClass .= ' ' . $Param{EventsServerError};
    }

    # Set class name for article sender type...
    my $ArticleSenderTypeIDClass = '';
    if ( $Param{ArticleSenderTypeIDServerError} ) {
        $ArticleSenderTypeIDClass .= ' ' . $Param{ArticleSenderTypeIDServerError};
    }

    my %RegisteredEvents = $Kernel::OM->Get('Kernel::System::Event')->EventList(
        ObjectTypes => [ 'Ticket', 'Article', ],
    );

    my @Events;
    for my $ObjectType ( sort keys %RegisteredEvents ) {
        push @Events, @{ $RegisteredEvents{$ObjectType} || [] };
    }

    # Suppress these events because of danger of endless loops.
    my %EventBlacklist = (
        ArticleAgentNotification    => 1,
        ArticleCustomerNotification => 1,
    );

    @Events = grep { !$EventBlacklist{$_} } @Events;

    # Build the list...
    $Param{EventsStrg} = $LayoutObject->BuildSelection(
        Data       => \@Events,
        Name       => 'Events',
        Multiple   => 1,
        Size       => 10,
        Class      => $EventClass . ' Modernize W75pc',
        SelectedID => $Param{Data}->{Events},
    );

    $Param{StatesStrg} = $LayoutObject->BuildSelection(
        Data => {
            $Kernel::OM->Get('Kernel::System::State')->StateList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'StateID',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{Data}->{StateID},
        Class      => 'Modernize W75pc',
    );

    $Param{QueuesStrg} = $LayoutObject->AgentQueueListOption(
        Data               => { $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues(), },
        Size               => 5,
        Multiple           => 1,
        Name               => 'QueueID',
        TreeView           => $TreeView,
        SelectedIDRefArray => $Param{Data}->{QueueID},
        OnChangeSubmit     => 0,
        Class              => 'Modernize W75pc',
    );

    if ( $Self->{LightAdmin} ) {

        # Make the queue field mandatory.
        $Param{LightAdmin} = 1;

        my %RoQueues = $QueueObject->GetAllQueues( UserID => $Self->{UserID} );
        my %RwQueues = $QueueObject->GetAllQueues(
            UserID => $Self->{UserID},
            Type   => 'rw',
        );

        # Add disabled queues
        my @DisabledQueues;
        my @VisibleSelected;
        if ( IsArrayRefWithData( $Param{Data}->{QueueID} ) ) {
            for my $QueueID ( @{ $Param{Data}->{QueueID} } ) {
                if ( $RwQueues{$QueueID} ) {
                    push @VisibleSelected, $QueueID;
                }

                elsif ( $RoQueues{$QueueID} ) {

                    # show the queue but disable it
                    $RwQueues{$QueueID} = $RoQueues{$QueueID};

                    # this can have the sideeffect that if the agent has rw on queue X::Y, but queue X gets added here,
                    # X::Y will be disabled as part of the branch, too, but the agent cannot alter this notification anyways
                    push @DisabledQueues,  $QueueID;
                    push @VisibleSelected, $QueueID;
                }

                # else -> don't show queues you have no ro access
            }
        }

        $Param{QueuesStrg} = $LayoutObject->BuildSelection(
            Data           => \%RwQueues,
            Size           => 5,
            Multiple       => 1,
            Name           => 'QueueID',
            TreeView       => $TreeView,
            SelectedID     => \@VisibleSelected,
            DisabledBranch => \@DisabledQueues,
            Class          => 'Modernize W75pc Validate_Required',
        );
    }

    $Param{PrioritiesStrg} = $LayoutObject->BuildSelection(
        Data => {
            $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'PriorityID',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{Data}->{PriorityID},
        Class      => 'Modernize W75pc',
    );

    $Param{LocksStrg} = $LayoutObject->BuildSelection(
        Data => {
            $Kernel::OM->Get('Kernel::System::Lock')->LockList(
                UserID => 1,
                Action => $Self->{Action},
            ),
        },
        Name       => 'LockID',
        Multiple   => 1,
        Size       => 3,
        SelectedID => $Param{Data}->{LockID},
        Class      => 'Modernize W75pc',
    );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize W50pc',
    );
    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # build type string
    if ( $ConfigObject->Get('Ticket::Type') ) {
        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
            UserID => $Self->{UserID},
        );
        $Param{TypesStrg} = $LayoutObject->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeID',
            SelectedID  => $Param{Data}->{TypeID},
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
            Class       => 'Modernize W75pc',
        );
        $LayoutObject->Block(
            Name => 'OverviewUpdateType',
            Data => \%Param,
        );
    }

    # build service string
    if ( $ConfigObject->Get('Ticket::Service') ) {

        # get list type
        my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            Valid        => 1,
            KeepChildren => $ConfigObject->Get('Ticket::Service::KeepChildren') // 0,
            UserID       => $Self->{UserID},
        );
        $Param{ServicesStrg} = $LayoutObject->BuildSelection(
            Data        => \%Service,
            Name        => 'ServiceID',
            SelectedID  => $Param{Data}->{ServiceID},
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
            TreeView    => $TreeView,
            Class       => 'Modernize W75pc',
        );
        my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            UserID => $Self->{UserID},
        );
        $Param{SLAsStrg} = $LayoutObject->BuildSelection(
            Data        => \%SLA,
            Name        => 'SLAID',
            SelectedID  => $Param{Data}->{SLAID},
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize W75pc',
        );
        $LayoutObject->Block(
            Name => 'OverviewUpdateService',
            Data => \%Param,
        );
    }

    $Param{CalendarFilterStrg} = $LayoutObject->BuildSelection(
        Data => {
            SendWithinHours  => Translatable('Only send within working hours'),
            SendOutsideHours => Translatable('Only send outside working hours'),
        },
        Name         => 'CalendarFilter',
        SelectedID   => $Param{Data}->{CalendarFilter},
        Class        => 'Modernize W75pc',
        Translation  => 1,
        PossibleNone => 1,
    );

    # create dynamic field HTML for set with historical data options
    my $PrintDynamicFieldsSearchHeader = 1;

    # cycle trough the activated Dynamic Fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip all dynamic fields that are not designed to be notification triggers
        my $IsNotificationEventCondition = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsNotificationEventCondition',
        );

        next DYNAMICFIELD if !$IsNotificationEventCondition;

        # get field HTML
        my $DynamicFieldHTML = $BackendObject->SearchFieldRender(
            DynamicFieldConfig     => $DynamicFieldConfig,
            Profile                => $Param{DynamicFieldValues} || {},
            LayoutObject           => $LayoutObject,
            ConfirmationCheckboxes => 1,
            UseLabelHints          => 0,
        );

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldHTML);

        if ($PrintDynamicFieldsSearchHeader) {
            $LayoutObject->Block( Name => 'DynamicField' );
            $PrintDynamicFieldsSearchHeader = 0;
        }

        # output dynamic field
        $LayoutObject->Block(
            Name => 'DynamicFieldElement',
            Data => {
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );
    }

    # add rich text editor
    if ( $Param{RichText} ) {

        # use height/width defined for this screen
        my $Config = $ConfigObject->Get("Frontend::Admin::$Self->{Action}");
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

        # set up rich text editor
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }

    # get names of languages in English
    my %DefaultUsedLanguages = %{ $ConfigObject->Get('DefaultUsedLanguages') || {} };

    # get language ids from message parameter, use English if no message is given
    # make sure English is the first language
    my @LanguageIDs;
    if ( IsHashRefWithData( $Param{Message} ) ) {
        if ( $Param{Message}->{en} ) {
            push @LanguageIDs, 'en';
        }
        LANGUAGEID:
        for my $LanguageID ( sort keys %{ $Param{Message} } ) {
            next LANGUAGEID if $LanguageID eq 'en';
            push @LanguageIDs, $LanguageID;
        }
    }
    elsif ( $DefaultUsedLanguages{en} ) {
        push @LanguageIDs, 'en';
    }
    else {
        push @LanguageIDs, ( sort keys %DefaultUsedLanguages )[0];
    }

    # for the selection list
    my %Languages = $LayoutObject->{LanguageObject}->LanguageList;

    # copy original list of languages which will be used for rebuilding language selection
    my %OriginalDefaultUsedLanguages = %Languages;

    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    for my $LanguageID (@LanguageIDs) {

        # format the content according to the content type
        if ( $Param{RichText} ) {

            # make sure body is rich text (if body is based on config)
            if (
                $Param{Message}->{$LanguageID}->{ContentType}
                && $Param{Message}->{$LanguageID}->{ContentType} =~ m{text\/plain}xmsi
                )
            {
                $Param{Message}->{$LanguageID}->{Body} = $HTMLUtilsObject->ToHTML(
                    String => $Param{Message}->{$LanguageID}->{Body},
                );
            }
        }
        else {

            # reformat from HTML to plain
            if (
                $Param{Message}->{$LanguageID}->{ContentType}
                && $Param{Message}->{$LanguageID}->{ContentType} =~ m{text\/html}xmsi
                && $Param{Message}->{$LanguageID}->{Body}
                )
            {
                $Param{Message}->{$LanguageID}->{Body} = $HTMLUtilsObject->ToAscii(
                    String => $Param{Message}->{$LanguageID}->{Body},
                );
            }
        }

        # show the notification for this language
        $LayoutObject->Block(
            Name => 'NotificationLanguage',
            Data => {
                %Param,
                Subject            => $Param{Message}->{$LanguageID}->{Subject} || '',
                Body               => $Param{Message}->{$LanguageID}->{Body}    || '',
                LanguageID         => $LanguageID,
                Language           => $Languages{$LanguageID},
                SubjectServerError => $Param{ $LanguageID . '_SubjectServerError' } || '',
                BodyServerError    => $Param{ $LanguageID . '_BodyServerError' }    || '',
            },
        );

        $LayoutObject->Block(
            Name => 'NotificationLanguageRemoveButton',
            Data => {
                %Param,
                LanguageID => $LanguageID,
            },
        );

        # delete language from drop-down list because it is already shown
        delete $Languages{$LanguageID};
    }

    $Param{LanguageStrg} = $LayoutObject->BuildSelection(
        Data         => \%Languages,
        Name         => 'Language',
        Class        => 'Modernize W50pc LanguageAdd',
        Translation  => 1,
        PossibleNone => 1,
        HTMLQuote    => 0,
    );
    $Param{LanguageOrigStrg} = $LayoutObject->BuildSelection(
        Data         => \%OriginalDefaultUsedLanguages,
        Name         => 'LanguageOrig',
        Translation  => 1,
        PossibleNone => 1,
        HTMLQuote    => 0,
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    $Param{ArticleSenderTypesStrg} = $LayoutObject->BuildSelection(
        Data        => { $ArticleObject->ArticleSenderTypeList(), },
        Name        => 'ArticleSenderTypeID',
        SelectedID  => $Param{Data}->{ArticleSenderTypeID},
        Class       => $ArticleSenderTypeIDClass . ' Modernize W75pc',
        Size        => 5,
        Multiple    => 1,
        Translation => 1,
        Max         => 200,
    );

    $Param{ArticleCustomerVisibilityStrg} = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('Invisible to customer'),
            1 => Translatable('Visible to customer'),
        },
        Name         => 'ArticleIsVisibleForCustomer',
        SelectedID   => $Param{Data}->{ArticleIsVisibleForCustomer},
        Class        => 'Modernize W75pc',
        Translation  => 1,
        PossibleNone => 1,
    );

    my @CommunicationChannelList = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelList();
    my %CommunicationChannels    = map { $_->{ChannelID} => $_->{DisplayName} } @CommunicationChannelList;

    $Param{ArticleCommunicationChannelStrg} = $LayoutObject->BuildSelection(
        Data        => \%CommunicationChannels,
        Name        => 'ArticleCommunicationChannelID',
        SelectedID  => $Param{Data}->{ArticleCommunicationChannelID},
        Class       => 'Modernize W75pc',
        Multiple    => 1,
        Size        => 5,
        Translation => 1,
    );

    $Param{ArticleAttachmentIncludeStrg} = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        Name        => 'ArticleAttachmentInclude',
        SelectedID  => $Param{Data}->{ArticleAttachmentInclude} || 0,
        Translation => 1,
        Max         => 200,
        Class       => 'Modernize W75pc',
    );

    # get all searchable article field definitions
    my %ArticleSearchableFields = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchableFieldsList();

    for my $ArticleFieldKey ( sort keys %ArticleSearchableFields ) {

        my $Value = '';

        if ( IsArrayRefWithData( $Param{Data}->{$ArticleFieldKey} ) ) {
            $Value = $Param{Data}->{$ArticleFieldKey}->[0];
        }

        $LayoutObject->Block(
            Name => 'BackendArticleField',
            Data => {
                Label => Translatable( $ArticleSearchableFields{$ArticleFieldKey}->{Label} ),
                Key   => $ArticleSearchableFields{$ArticleFieldKey}->{Key},
                Value => $Value,
            },
        );
    }

    # take over data fields
    KEY:
    for my $Key (
        qw(VisibleForAgent VisibleForAgentTooltip CustomerID CustomerUserID)
        )
    {
        next KEY if !$Param{Data}->{$Key};
        next KEY if !defined $Param{Data}->{$Key}->[0];
        $Param{$Key} = $Param{Data}->{$Key}->[0];
    }

    # set send on out of office checked value
    $Param{SendOnOutOfOfficeChecked} = ( $Param{Data}->{SendOnOutOfOffice} ? 'checked ' : '' );

    # set once per day checked value
    $Param{OncePerDayChecked} = ( $Param{Data}->{OncePerDay} ? 'checked ' : '' );

    $Param{VisibleForAgentStrg} = $LayoutObject->BuildSelection(
        Data => [
            {
                Key   => '0',
                Value => Translatable('No'),
            },
            {
                Key   => '1',
                Value => Translatable('Yes'),
            },
        ],
        Name       => 'VisibleForAgent',
        Sort       => 'NumericKey',
        Size       => 1,
        SelectedID => $Param{VisibleForAgent},
        Class      => 'Modernize W50pc',
    );

    # include read-only attribute
    if ( !$Param{VisibleForAgent} ) {
        $Param{VisibleForAgentTooltipReadonly} = 'readonly';
    }

    # get registered transport layers
    my %RegisteredTransports = %{ $Kernel::OM->Get('Kernel::Config')->Get('Notification::Transport') || {} };

    if ( IsHashRefWithData( \%RegisteredTransports ) ) {

        my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

        TRANSPORT:
        for my $Transport (
            sort { $RegisteredTransports{$a}->{Prio} <=> $RegisteredTransports{$b}->{Prio} }
            keys %RegisteredTransports
            )
        {

            next TRANSPORT if !IsHashRefWithData( $RegisteredTransports{$Transport} );
            next TRANSPORT if !$RegisteredTransports{$Transport}->{Module};

            # transport
            $LayoutObject->Block(
                Name => 'TransportRow',
                Data => {
                    Transport     => $Transport,
                    TransportName => $RegisteredTransports{$Transport}->{Name},
                },
            );

            if ( !$MainObject->Require( $RegisteredTransports{$Transport}->{Module}, Silent => 1 ) ) {

                # backend for this transport is not available
                $LayoutObject->Block(
                    Name => 'TransportRowDisabled',
                    Data => {
                        Transport     => $Transport,
                        TransportName => $RegisteredTransports{$Transport}->{Name},
                    },
                );

                next TRANSPORT;
            }
            else {

                my $TransportObject = $Kernel::OM->Get( $RegisteredTransports{$Transport}->{Module} );

                my $IsActive = 1;

                # Check only if function is available due backwards compatibility.
                if ( $TransportObject->can('IsActive') ) {
                    $IsActive = $TransportObject->IsActive();
                }

                if ($IsActive) {

                    my $TransportChecked = '';
                    if ( grep { $_ eq $Transport } @{ $Param{Data}->{Transports} } ) {
                        $TransportChecked = 'checked ';
                    }

                    # set Email transport selected on add screen
                    if ( $Transport eq 'Email' && !$Param{ID} ) {
                        $TransportChecked = 'checked ';
                    }

                    # get transport settings string from transport object
                    my $TransportSettings =
                        $TransportObject->TransportSettingsDisplayGet(
                            %Param,
                        );

                    # it should decide if the default value for the
                    # notification on AgentPreferences is enabled or not
                    my $AgentEnabledByDefault = 0;
                    if ( grep { $_ eq $Transport } @{ $Param{Data}->{AgentEnabledByDefault} } ) {
                        $AgentEnabledByDefault = 1;
                    }
                    elsif ( !$Param{ID} && defined $RegisteredTransports{$Transport}->{AgentEnabledByDefault} ) {
                        $AgentEnabledByDefault = $RegisteredTransports{$Transport}->{AgentEnabledByDefault};
                    }
                    my $AgentEnabledByDefaultChecked = $AgentEnabledByDefault ? 'checked ' : '';

                    # transport
                    $LayoutObject->Block(
                        Name => 'TransportRowEnabled',
                        Data => {
                            Transport                    => $Transport,
                            TransportName                => $RegisteredTransports{$Transport}->{Name},
                            TransportChecked             => $TransportChecked,
                            SettingsString               => $TransportSettings,
                            AgentEnabledByDefaultChecked => $AgentEnabledByDefaultChecked,
                            TransportsServerError        => $Param{TransportsServerError},
                        },
                    );
                }
                else {

                    # This trasnport needs to be active before use it.
                    $LayoutObject->Block(
                        Name => 'TransportRowNotActive',
                        Data => {
                            Transport     => $Transport,
                            TransportName => $RegisteredTransports{$Transport}->{Name},
                        },
                    );
                }

            }

        }
    }
    else {

        # no transports
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgTransport',
        );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $Param{IncludeInvalidChecked} = $Self->{IncludeInvalid} ? 'checked' : '';
    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'ActionImport' );
    $LayoutObject->Block(
        Name => 'IncludeInvalid',
        Data => {
            IncludeInvalid        => $Self->{IncludeInvalid},
            IncludeInvalidChecked => $Self->{IncludeInvalid} ? 'checked' : '',
        },
    );
    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    my %ValidList   = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidLookup = reverse %ValidList;
    my @ValidIDs    = ( $ValidLookup{'valid'}, $ValidLookup{'invalid-temporarily'} );
    if ( $Self->{IncludeInvalid} ) {
        push @ValidIDs, $ValidLookup{'invalid'};
    }

    my %List = $NotificationEventObject->NotificationList(
        ValidIDs => \@ValidIDs,
    );

    # if there are any notifications, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        ID:
        for my $NotificationID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $NotificationEventObject->NotificationGet(
                ID => $NotificationID,
            );

            if ( $Self->{LightAdmin} ) {
                $Data{Permission} = $Kernel::OM->Get('Kernel::System::Queue')->QueueListPermission(
                    QueueIDs => $Data{Data}{QueueID},
                    UserID   => $Self->{UserID},
                );

                next ID if !$Data{Permission};
            }

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                },
            );
        }
    }

    # otherwise a no data found message is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    return 1;
}

1;
