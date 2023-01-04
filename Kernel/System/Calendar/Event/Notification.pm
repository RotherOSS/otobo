# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Calendar::Event::Notification;

use v5.24;
use strict;
use warnings;

use Data::ICal;
use Data::ICal::Entry::Event;
use Date::ICal;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Calendar',
    'Kernel::System::Calendar::Appointment',
    'Kernel::System::DateTime',
    'Kernel::System::Group',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::NotificationEvent',
    'Kernel::System::CalendarTemplateGenerator',
    'Kernel::System::Ticket',
    'Kernel::System::User',
    'Kernel::System::Calendar::Participation',
    'Kernel::System::CheckItem',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Event Data Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !$Param{Data}->{AppointmentID} && !$Param{Data}->{CalendarID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need either CalendarID or AppointmentID in Data!',
        );
        return;
    }

    # get notification event object
    my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');

    # check if event is affected
    my @IDs = $NotificationEventObject->NotificationEventCheck(
        Event => $Param{Event},
    );

    # return if no notification for event exists
    if ( !IsArrayRefWithData( \@IDs ) ) {

        # update the future tasks
        $Self->_FutureTaskUpdate();

        return 1;
    }
    # Prepare sending of ICS file (if needed).
    my %SendICSFileEvents = (
        AppointmentCreate   => 1,
        AppointmentUpdate   => 1,
        AppointmentDelete   => 1,
        ParticipationCreate => 1,
        ParticipationUpdate => 1,
        ParticipationDelete => 1,
    );
    my $SendICSFile = ( $SendICSFileEvents{ $Param{Event} } ) ? 1 : 0;

    my %OldAppointment;
    if ( $Param{Event} eq 'AppointmentUpdate' && IsHashRefWithData( $Param{Data}->{OldAppointment} ) ) {
        %OldAppointment = %{ $Param{Data}->{OldAppointment} };
    }

    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');

    my %Calendar;
    my %Appointment;

    if ( $Param{Data}->{AppointmentID} ) {
        %Appointment = $AppointmentObject->AppointmentGet(
            AppointmentID => $Param{Data}->{AppointmentID},
            DynamicFields => 1,
        );
        %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $Appointment{CalendarID} || $Param{Data}->{CalendarID},
        );
    }
    elsif ( $Param{Data}->{CalendarID} ) {
        %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $Param{Data}->{CalendarID},
        );
    }
    # Set current appointment data, if given.
    # In case of appointment deletion, a subsequent call to AppointmentGet()
    #   could return an empty hash, but maybe we need this data in the notification text.
    if ( IsHashRefWithData( $Param{Data}->{Appointment} ) ) {
        %Appointment = %{ $Param{Data}->{Appointment} };

        %Calendar = $CalendarObject->CalendarGet(
            CalendarID => $Appointment{CalendarID},
        );
    }
    return if !IsHashRefWithData( \%Appointment ) && !IsHashRefWithData( \%Calendar );

    # get dynamic fields
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Appointment'],
    );

    # create a dynamic field config lookup table
    my %DynamicFieldConfigLookup;
    for my $DynamicFieldConfig ( @{$DynamicFieldList} ) {
        $DynamicFieldConfigLookup{ $DynamicFieldConfig->{Name} } = $DynamicFieldConfig;
    }

    NOTIFICATIONID:
    for my $NotificationID (@IDs) {

        my %Notification = $NotificationEventObject->NotificationGet(
            ID => $NotificationID,
        );

        # verify appointment conditions
        my $PassFilter = $Self->_NotificationFilter(
            %Param,
            Appointment  => \%Appointment,
            Calendar     => \%Calendar,
            Notification => \%Notification,
            DynamicFieldConfigLookup => \%DynamicFieldConfigLookup,
        );

        next NOTIFICATIONID if !$PassFilter;

        # get recipients
        my @RecipientUsers = $Self->_RecipientsGet(
            %Param,
            Appointment  => \%Appointment,
            Calendar     => \%Calendar,
            Notification => \%Notification,
        );
        # Prepare ICS file sending.

        my %Recipients = map { $_->{UserID} => $_ } @RecipientUsers;

        if (
            $SendICSFile
            && IsArrayRefWithData( $Notification{Data}->{SendICSFile} )
            && $Notification{Data}->{SendICSFile}->[0]
            )
        {
            # Check for old recipients.
            my %OldRecipients;
            if ( IsHashRefWithData( \%OldAppointment ) ) {
                my @OldRecipientUsers = $Self->_RecipientsGet(
                    %Param,
                    Appointment  => \%OldAppointment,
                    Calendar     => \%Calendar,
                    Notification => \%Notification,
                );

                %OldRecipients = map { $_->{UserID} => $_ } @OldRecipientUsers;
            }

            # We do have two types of ICS files:
            #   - regular ICS file for all current recipients
            #   - ICS file with a cancellation for all former recipients

            # Determine old recipients for cancellation ICS file.
            if ( IsHashRefWithData( \%OldRecipients ) ) {

                OLDRECIPIENT:
                for my $OldRecipient ( sort keys %OldRecipients ) {

                    $OldRecipients{ $OldRecipient }->{ICSFileType} = 'Cancellation';
                    next OLDRECIPIENT if !$Recipients{ $OldRecipient };

                    delete $OldRecipients{ $OldRecipient };
                }
            }

            %Recipients = ( %Recipients, %OldRecipients );
        }

        my @NotificationBundle;

        # get template generator object;
        my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::CalendarTemplateGenerator');

        # parse all notification tags for each user
        for my $RecipientUserID ( sort keys %Recipients ) {

            my $Recipient = $Recipients{$RecipientUserID};

            my %ReplacedNotification = $TemplateGeneratorObject->NotificationEvent(
                AppointmentID => $Param{Data}->{AppointmentID},
                CalendarID    => $Param{Data}->{CalendarID},
                Recipient     => $Recipient,
                Notification  => \%Notification,
                UserID        => $Param{UserID},
                Appointment   => \%Appointment,
            );

            my $UserNotificationTransport = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $Recipient->{AppointmentNotificationTransport},
            );

            push @NotificationBundle, {
                Recipient                      => $Recipient,
                Notification                   => \%ReplacedNotification,
                RecipientNotificationTransport => $UserNotificationTransport,
            };
        }

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get notification transport config
        my %TransportConfig = %{ $ConfigObject->Get('AppointmentNotification::Transport') || {} };

        # remember already sent agent notifications
        my %AlreadySent;

        # loop over transports for each notification
        TRANSPORT:
        for my $Transport ( sort keys %TransportConfig ) {

            # only configured transports for this notification
            if ( !grep { $_ eq $Transport } @{ $Notification{Data}->{Transports} } ) {
                next TRANSPORT;
            }

            next TRANSPORT if !IsHashRefWithData( $TransportConfig{$Transport} );
            next TRANSPORT if !$TransportConfig{$Transport}->{Module};

            # get transport object
            my $TransportObject;
            eval {
                $TransportObject = $Kernel::OM->Get( $TransportConfig{$Transport}->{Module} );
            };

            if ( !$TransportObject ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not create a new $TransportConfig{$Transport}->{Module} object!",
                );

                next TRANSPORT;
            }

            if ( ref $TransportObject ne $TransportConfig{$Transport}->{Module} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$TransportConfig{$Transport}->{Module} object is invalid",
                );

                next TRANSPORT;
            }

            # check if transport is usable
            next TRANSPORT if !$TransportObject->IsUsable();

            BUNDLE:
            for my $Bundle (@NotificationBundle) {

                my $UserPreference = "Notification-$Notification{ID}-$Transport";

                # check if agent should get the notification
                my $AgentSendNotification = 0;
                if ( defined $Bundle->{RecipientNotificationTransport}->{$UserPreference} ) {
                    $AgentSendNotification = $Bundle->{RecipientNotificationTransport}->{$UserPreference};
                }
                elsif ( grep { $_ eq $Transport } @{ $Notification{Data}->{AgentEnabledByDefault} } ) {
                    $AgentSendNotification = 1;
                }
                elsif (
                    !IsArrayRefWithData( $Notification{Data}->{VisibleForAgent} )
                    || (
                        defined $Notification{Data}->{VisibleForAgent}->[0]
                        && !$Notification{Data}->{VisibleForAgent}->[0]
                    )
                    )
                {
                    $AgentSendNotification = 1;
                }

                # skip sending the notification if the agent has disable it in its preferences
                if (
                    IsArrayRefWithData( $Notification{Data}->{VisibleForAgent} )
                    && $Notification{Data}->{VisibleForAgent}->[0]
                    && $Bundle->{Recipient}->{Type} eq 'Agent'
                    && !$AgentSendNotification
                    )
                {
                    next BUNDLE;
                }

                my $Success = $Self->_SendRecipientNotification(
                    Appointment => \%Appointment,
                    SendICSFile => $SendICSFile,
                    AppointmentID         => $Appointment{AppointmentID} || '',
                    CalendarID            => $Calendar{CalendarID} || $Appointment{CalendarID} || '',
                    Notification          => $Bundle->{Notification},
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    Recipient             => $Bundle->{Recipient},
                    Event                 => $Param{Event},
                    Transport             => $Transport,
                    TransportObject       => $TransportObject,
                    UserID                => $Param{UserID},
                );

                # remember to have sent
                $AlreadySent{ $Bundle->{Recipient}->{UserID} } = 1;

            }

            # get special recipients specific for each transport
            my @TransportRecipients = $TransportObject->GetTransportRecipients(
                Notification => \%Notification,
            );

            # Send a mail to the customer that is concerned in the handled participation.
            # The mail address is either taken from the existing customer user or from
            # calendar_participation.participant_email.
            # Agents are not notified.
            # Note that the @TransportRecipients array is a bit abused here,
            # as these recipients are not specific for the transport configuration.
            if ( $Param{Event} =~ m/^Participation/ && $Param{Data}->{ParticipationID} ) {

                # Include only valid email recipients.
                my $ParticipationObject = $Kernel::OM->Get('Kernel::System::Calendar::Participation');
                my %Participation       = $ParticipationObject->ParticipationGet(
                    ParticipationID => $Param{Data}->{ParticipationID},
                    UserID          => $Param{UserID},
                );

                # The invitee could be a customer user
                my $CustomerUserID = $Participation{CustomerUserID};
                if ( $CustomerUserID ) {
                    my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                        User => $CustomerUserID,
                    );
                    if ( $CustomerUser{UserEmail} ) {
                        push @TransportRecipients, {
                            Realname             => '',
                            Type                 => 'Customer',
                            UserEmail            => $CustomerUser{UserEmail},
                            IsVisibleForCustomer => $Notification{Data}->{IsVisibleForCustomer},
                        };
                    }
                    else {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'info',
                            Message  => "Send no customer notification because of missing "
                                . "customer email (CustomerUserID=$CustomerUserID)!",
                        );
                    }
                }

                # Or the invitee could be an arbitrary email adress
                my $ParticipantEmail = $Participation{ParticipantEmail};
                if ( $ParticipantEmail && $ParticipantEmail =~ m/@/ ) {
                    push @TransportRecipients, {
                        Realname             => '',
                        Type                 => 'Customer',
                        UserEmail            => $ParticipantEmail,
                        IsVisibleForCustomer => $Notification{Data}->{IsVisibleForCustomer},
                    };
                }
            }

            next TRANSPORT if !@TransportRecipients;

            RECIPIENT:
            for my $Recipient (@TransportRecipients) {
                if ($SendICSFile) {
                    $Recipient->{ICSFileType}
                        = $Param{Event} eq 'AppointmentDelete'   ? 'Cancellation'
                        : $Param{Event} eq 'ParticipationDelete' ? 'Cancellation'
                        :                                          'Invitation';
                }

                # replace all notification tags for each special recipient
                my %ReplacedNotification = $TemplateGeneratorObject->NotificationEvent(
                    AppointmentID         => $Param{Data}->{AppointmentID},
                    Recipient             => $Recipient,
                    Notification          => \%Notification,
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    UserID                => $Param{UserID},
                    Appointment => \%Appointment,
                );

                my $Success = $Self->_SendRecipientNotification(
                    Appointment => \%Appointment,
                    SendICSFile => $SendICSFile,
                    AppointmentID         => $Appointment{AppointmentID} || '',
                    CalendarID            => $Calendar{CalendarID} || $Appointment{CalendarID} || '',
                    Notification          => \%ReplacedNotification,
                    CustomerMessageParams => $Param{Data}->{CustomerMessageParams} || {},
                    Recipient             => $Recipient,
                    Event                 => $Param{Event},
                    Transport             => $Transport,
                    TransportObject       => $TransportObject,
                    UserID                => $Param{UserID},
                );
            }
        }
    }

    # update appointment future tasks
    $Self->_FutureTaskUpdate();

    return 1;
}

sub _NotificationFilter {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Appointment Calendar Notification)) {
        return if !$Param{$Needed};
    }

    # set local values
    my %Notification = %{ $Param{Notification} };

    return if !IsHashRefWithData( $Notification{Data} );

    KEY:
    for my $Key ( sort keys %{ $Notification{Data} } ) {

        # ignore not appointment related attributes
        next KEY if $Key eq 'Recipients';
        next KEY if $Key eq 'SkipRecipients';
        next KEY if $Key eq 'RecipientAgents';
        next KEY if $Key eq 'RecipientGroups';
        next KEY if $Key eq 'RecipientRoles';
        next KEY if $Key eq 'TransportEmailTemplate';
        next KEY if $Key eq 'Events';
        next KEY if $Key eq 'ArticleTypeID';
        next KEY if $Key eq 'ArticleSenderTypeID';
        next KEY if $Key eq 'ArticleSubjectMatch';
        next KEY if $Key eq 'ArticleBodyMatch';
        next KEY if $Key eq 'ArticleAttachmentInclude';
        next KEY if $Key eq 'NotificationArticleTypeID';
        next KEY if $Key eq 'Transports';
        next KEY if $Key eq 'OncePerDay';
        next KEY if $Key eq 'VisibleForAgent';
        next KEY if $Key eq 'VisibleForAgentTooltip';
        next KEY if $Key eq 'LanguageID';
        next KEY if $Key eq 'SendOnOutOfOffice';
        next KEY if $Key eq 'AgentEnabledByDefault';
        next KEY if $Key eq 'NotificationType';
        next KEY if $Key eq 'SendICSFile';
        next KEY if $Key eq 'IsVisibleForCustomer';

        # check recipient fields from transport methods
        if ( $Key =~ m{\A Recipient}xms ) {
            next KEY;
        }

        # check appointment attributes
        next KEY if !$Notification{Data}->{$Key};
        next KEY if !@{ $Notification{Data}->{$Key} };
        next KEY if !$Notification{Data}->{$Key}->[0];

        my $Match = 0;

        VALUE:
        for my $Value ( @{ $Notification{Data}->{$Key} } ) {

            next VALUE if !$Value;

            if (
                $Key eq 'TeamID'
                || $Key eq 'ResourceID'
                )
            {
                # check for existing object ids in appointment
                next KEY if !IsArrayRefWithData( $Param{Appointment}->{$Key} );

                OBJECTID:
                for my $ObjectID ( @{ $Param{Appointment}->{$Key} } ) {

                    next OBJECTID if !$ObjectID;

                    if ( $Value eq $ObjectID ) {
                        $Match = 1;
                        last VALUE;
                    }
                }
            }
            elsif ( $Key eq 'Title' || $Key eq 'Location' ) {
                if ( defined $Param{Appointment}->{$Key} && $Param{Appointment}->{$Key} =~ m/$Value/i ) {
                    $Match = 1;
                    last VALUE;
                }
            }
            else {

                if ( defined $Param{Appointment}->{$Key} && $Value eq $Param{Appointment}->{$Key} ) {
                    $Match = 1;
                    last VALUE;
                }
            }
        }

        return if !$Match;
    }

    return 1;
}

sub _RecipientsGet {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Appointment Calendar Notification)) {
        return if !$Param{$Needed};
    }

    # set local values
    my %Notification = %{ $Param{Notification} };
    my %Appointment  = %{ $Param{Appointment} };

    # get needed objects
    my $AppointmentObject = $Kernel::OM->Get('Kernel::System::Calendar::Appointment');
    my $CalendarObject    = $Kernel::OM->Get('Kernel::System::Calendar');
    my $GroupObject       = $Kernel::OM->Get('Kernel::System::Group');
    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');

    my @RecipientUserIDs;
    my @RecipientUsers;

    # add pre-calculated recipient
    if ( IsArrayRefWithData( $Param{Data}->{Recipients} ) ) {
        push @RecipientUserIDs, @{ $Param{Data}->{Recipients} };
    }

    # remember pre-calculated user recipients for later comparisons
    my %PrecalculatedUserIDs = map { $_ => 1 } @RecipientUserIDs;

    # get recipients by Recipients
    if ( $Notification{Data}->{Recipients} ) {

        RECIPIENT:
        for my $Recipient ( @{ $Notification{Data}->{Recipients} } ) {

            if (
                $Recipient
                =~ /^Appointment(Agents|AgentReadPermissions|AgentWritePermissions)$/
                )
            {
                if ( $Recipient eq 'AppointmentAgents' ) {

                    RESOURCEID:
                    for my $ResourceID ( @{ $Appointment{ResourceID} } ) {

                        next RESOURCEID if !$ResourceID;

                        push @{ $Notification{Data}->{RecipientAgents} }, $ResourceID;
                    }
                }
                elsif ( $Recipient eq 'AppointmentAgentReadPermissions' ) {

                    # get calendar information
                    my %Calendar = $CalendarObject->CalendarGet(
                        CalendarID => $Appointment{CalendarID} || $Param{Calendar}->{CalendarID},
                        UserID     => 1,
                    );

                    # get a list of read access users for the related calendar
                    my %Users = $GroupObject->PermissionGroupGet(
                        GroupID => $Calendar{GroupID},
                        Type    => 'ro',
                    );

                    USERID:
                    for my $UserID ( sort keys %Users ) {

                        next USERID if !$UserID;

                        push @{ $Notification{Data}->{RecipientAgents} }, $UserID;
                    }
                }
                elsif ( $Recipient eq 'AppointmentAgentWritePermissions' ) {

                    # get calendar information
                    my %Calendar = $CalendarObject->CalendarGet(
                        CalendarID => $Appointment{CalendarID} || $Param{Calendar}->{CalendarID},
                        UserID     => 1,
                    );

                    # get a list of read access users for the related calendar
                    my %Users = $GroupObject->PermissionGroupGet(
                        GroupID => $Calendar{GroupID},
                        Type    => 'rw',
                    );

                    USERID:
                    for my $UserID ( sort keys %Users ) {

                        next USERID if !$UserID;

                        push @{ $Notification{Data}->{RecipientAgents} }, $UserID;
                    }
                }
            }
        }
    }

    # add recipient agents
    if ( IsArrayRefWithData( $Notification{Data}->{RecipientAgents} ) ) {
        push @RecipientUserIDs, @{ $Notification{Data}->{RecipientAgents} };
    }

    # hash to keep track which agents are already receiving this notification
    my %AgentUsed = map { $_ => 1 } @RecipientUserIDs;

    # get recipients by RecipientGroups
    if ( $Notification{Data}->{RecipientGroups} ) {

        RECIPIENT:
        for my $GroupID ( @{ $Notification{Data}->{RecipientGroups} } ) {

            my %GroupMemberList = $GroupObject->PermissionGroupUserGet(
                GroupID => $GroupID,
                Type    => 'ro',
            );

            GROUPMEMBER:
            for my $UserID ( sort keys %GroupMemberList ) {

                next GROUPMEMBER if $UserID == 1;
                next GROUPMEMBER if $AgentUsed{$UserID};

                $AgentUsed{$UserID} = 1;

                push @RecipientUserIDs, $UserID;
            }
        }
    }

    # get recipients by RecipientRoles
    if ( $Notification{Data}->{RecipientRoles} ) {

        RECIPIENT:
        for my $RoleID ( @{ $Notification{Data}->{RecipientRoles} } ) {

            my %RoleMemberList = $GroupObject->PermissionRoleUserGet(
                RoleID => $RoleID,
            );

            ROLEMEMBER:
            for my $UserID ( sort keys %RoleMemberList ) {

                next ROLEMEMBER if $UserID == 1;
                next ROLEMEMBER if $AgentUsed{$UserID};

                $AgentUsed{$UserID} = 1;

                push @RecipientUserIDs, $UserID;
            }
        }
    }

    # get needed objects
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my %SkipRecipients;
    if ( IsArrayRefWithData( $Param{Data}->{SkipRecipients} ) ) {
        %SkipRecipients = map { $_ => 1 } @{ $Param{Data}->{SkipRecipients} };
    }

    # agent 1 should not receive notifications
    $SkipRecipients{'1'} = 1;

    # remove recipients should not receive a notification
    @RecipientUserIDs = grep { !$SkipRecipients{$_} } @RecipientUserIDs;

    # get valid users list
    my %ValidUsersList = $UserObject->UserList(
        Type          => 'Short',
        Valid         => 1,
        NoOutOfOffice => 0,
    );

    # remove invalid users
    @RecipientUserIDs = grep { $ValidUsersList{$_} } @RecipientUserIDs;

    # remove duplicated
    my %TempRecipientUserIDs = map { $_ => 1 } @RecipientUserIDs;
    @RecipientUserIDs = sort keys %TempRecipientUserIDs;

    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # get all data for recipients as they should be needed by all notification transports
    RECIPIENT:
    for my $UserID (@RecipientUserIDs) {

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
            Valid  => 1,
        );
        next RECIPIENT if !%User;

        # skip user that triggers the event (it should not be notified) but only if it is not
        #   a pre-calculated recipient
        if (
            !$ConfigObject->Get('AgentSelfNotifyOnAction')
            && $User{UserID} == $Param{UserID}
            && !$PrecalculatedUserIDs{ $Param{UserID} }
            # Do not skip user that triggers the event,
            #   if ICS file sending is active.
            && (
                !IsArrayRefWithData( $Notification{Data}->{SendICSFile} )
                || (
                    IsArrayRefWithData( $Notification{Data}->{SendICSFile} )
                    && !$Notification{Data}->{SendICSFile}->[0]
                )
            )
            )
        {
            next RECIPIENT;
        }

        # skip users out of the office if configured
        if ( !$Notification{Data}->{SendOnOutOfOffice} && $User{OutOfOffice} ) {
            my $Start = sprintf(
                "%04d-%02d-%02d 00:00:00",
                $User{OutOfOfficeStartYear}, $User{OutOfOfficeStartMonth},
                $User{OutOfOfficeStartDay}
            );
            my $StartTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Start,
                },
            );

            my $End = sprintf(
                "%04d-%02d-%02d 23:59:59",
                $User{OutOfOfficeEndYear}, $User{OutOfOfficeEndMonth},
                $User{OutOfOfficeEndDay}
            );
            my $EndTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $End,
                },
            );

            next RECIPIENT if $StartTimeObject < $DateTimeObject && $EndTimeObject > $DateTimeObject;
        }

        # skip PostMasterUserID
        my $PostmasterUserID = $ConfigObject->Get('PostmasterUserID') || 1;
        next RECIPIENT if $User{UserID} == $PostmasterUserID;

        $User{Type} = 'Agent';
        if (
            IsArrayRefWithData( $Notification{Data}->{SendICSFile} )
            && $Notification{Data}->{SendICSFile}->[0]
            )
        {
            $User{ICSFileType} = ( $Param{Event} eq 'AppointmentDelete' ) ? 'Cancellation' : 'Invitation';
        }

        push @RecipientUsers, \%User;
    }

    return @RecipientUsers;
}

sub _SendRecipientNotification {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(UserID Notification Recipient Event Transport TransportObject)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
        }
    }

    # add an .ics attachment in the case of invitations
    if (
        $Param{SendICSFile}
        && $Param{Recipient}->{ICSFileType}
        && IsHashRefWithData( $Param{Appointment} )
        )
    {
        my %Calendar = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarGet(
            CalendarID => $Param{CalendarID},
            UserID     => $Param{UserID},
        );
        my $ICalCalendar = Data::ICal->new(
            calname => $Calendar{CalendarName},
        );

        # Export color for Apple calendar.
        $ICalCalendar->add_property(
            'x-apple-calendar-color' => $Calendar{Color},
        );

        my %Appointment = $Param{Appointment}->%*;

        # Calculate start time.
        my $StartTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Appointment{StartTime},
            },
        );
        my $ICalStartTime = Date::ICal->new(
            epoch => $StartTimeObject->ToEpoch(),
        );

        # Calculate end time.
        my $EndTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Appointment{EndTime},
            },
        );
        my $ICalEndTime = Date::ICal->new(
            epoch => $EndTimeObject->ToEpoch(),
        );

        # Recalculate for all day appointment, discard time data.
        if ( $Appointment{AllDay} ) {
            my $StartTimeSettings = $StartTimeObject->Get();
            $ICalStartTime = Date::ICal->new(
                year   => $StartTimeSettings->{Year},
                month  => $StartTimeSettings->{Month},
                day    => $StartTimeSettings->{Day},
                offset => 0,   # UTC, $ENV{TZ} is not used
            );

            my $EndTimeSettings = $EndTimeObject->Get();
            $ICalEndTime = Date::ICal->new(
                year   => $EndTimeSettings->{Year},
                month  => $EndTimeSettings->{Month},
                day    => $EndTimeSettings->{Day},
                offset => 0,   # UTC, $ENV{TZ} is not used
            );
        }

        # create iCalendar event entry
        my $ICalEvent = Data::ICal::Entry::Event->new();

        # optional and repeatable properties
        my (%ICalEventProperties, @ICalRepeatableProperties);

        if ( $Appointment{Description} ) {
            $ICalEventProperties{description} = $Appointment{Description};

            # Maybe use additional description as well.
            my $Template = $Calendar{Settings}->{AdditionalDescription} // '';

            if (
                IsStringWithData( $Template )
                && $Kernel::OM->Get('Kernel::Config')->Get('AppointmentCalendar::ICSFiles::UseAppointmentDescription')
            )
            {
                my $Text = $Template;

                # Do not call the calendar template generator if there are no tags.
                if ( $Text =~ m{\<OTOBO_.+?\>} ) {

                    $Text = $Kernel::OM->Get('Kernel::System::CalendarTemplateGenerator')->_Replace(
                        RichText      => 0,
                        Text          => $Text,
                        ReplaceValue  => '',
                        AppointmentID => $Appointment{AppointmentID},
                        CalendarID    => $Appointment{CalendarID},
                        UserID        => $Param{UserID},
                    );
                }

                # Sanitize.
                $Text =~ s{\<.+?\>}{}gs;
                $Text =~ s{^\s*}{}mg;

                $ICalEventProperties{description} .= "\n" . $Text;
            }

        }

        if ( $Appointment{Location} ) {
            $ICalEventProperties{location} = $Appointment{Location};
        }

        if ( $Appointment{Recurring} ) {
            my %ValueParams;

            if ( $Appointment{RecurrenceType} eq 'Daily' ) {
                $ValueParams{FREQ} = 'DAILY';
            }
            elsif ( $Appointment{RecurrenceType} eq 'Weekly' ) {
                $ValueParams{FREQ} = 'WEEKLY';
            }
            elsif ( $Appointment{RecurrenceType} eq 'Monthly' ) {
                $ValueParams{FREQ} = 'MONTHLY';
            }
            elsif ( $Appointment{RecurrenceType} eq 'Yearly' ) {
                $ValueParams{FREQ} = 'YEARLY';
            }
            elsif ( $Appointment{RecurrenceType} eq 'CustomDaily' ) {
                $ValueParams{FREQ}     = 'DAILY';
                $ValueParams{INTERVAL} = $Appointment{RecurrenceInterval};
            }
            elsif ( $Appointment{RecurrenceType} eq 'CustomWeekly' ) {
                $ValueParams{FREQ}     = 'WEEKLY';
                $ValueParams{INTERVAL} = $Appointment{RecurrenceInterval};

                if ( IsArrayRefWithData( $Appointment{RecurrenceFrequency} ) ) {
                    my @DayNames;
                    for my $Day ( $Appointment{RecurrenceFrequency}->@* ) {
                        if ( $Day == 1 ) {
                            push @DayNames, 'MO';
                        }
                        elsif ( $Day == 2 ) {
                            push @DayNames, 'TU';
                        }
                        elsif ( $Day == 3 ) {
                            push @DayNames, 'WE';
                        }
                        elsif ( $Day == 4 ) {
                            push @DayNames, 'TH';
                        }
                        elsif ( $Day == 5 ) {
                            push @DayNames, 'FR';
                        }
                        elsif ( $Day == 6 ) {
                            push @DayNames, 'SA';
                        }
                        elsif ( $Day == 7 ) {
                            push @DayNames, 'SU';
                        }
                    }

                    $ValueParams{BYDAY} = join ',', @DayNames;
                }
            }
            elsif ( $Appointment{RecurrenceType} eq 'CustomMonthly' ) {
                $ValueParams{FREQ}       = 'MONTHLY';
                $ValueParams{INTERVAL}   = $Appointment{RecurrenceInterval};
                $ValueParams{BYMONTHDAY} = join ',', $Appointment{RecurrenceFrequency}->@*;
            }
            elsif ( $Appointment{RecurrenceType} eq 'CustomYearly' ) {
                $ValueParams{FREQ}       = 'YEARLY';
                $ValueParams{INTERVAL}   = $Appointment{RecurrenceInterval};

                my $StartTimeSettings       = $StartTimeObject->Get();
                $ValueParams{BYMONTHDAY} = $StartTimeSettings->{Day};
                $ValueParams{BYMONTH}    = join ',', $Appointment{RecurrenceFrequency}->@*;
                # RRULE:FREQ=YEARLY;UNTIL=20200602T080000Z;INTERVAL=2;BYMONTHDAY=1;BYMONTH=4
            }

            if ( $Appointment{RecurrenceUntil} ) {
                my $RecurrenceUntilObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $Appointment{RecurrenceUntil},
                    },
                );
                my $ICalRecurrenceUntil = Date::ICal->new(
                    epoch => $RecurrenceUntilObject->ToEpoch(),
                );
                # TODO: why ???
                $ValueParams{UNTIL} = substr $ICalRecurrenceUntil->ical(), 0, -1;
            }
            elsif ( $Appointment{RecurrenceCount} ) {
                $ValueParams{COUNT} = $Appointment{RecurrenceCount};
            }

            # rrule has no property params, just a funny value
            if ( %ValueParams ) {
                my $Value = join ';',
                    map { "$_=$ValueParams{$_}" }
                    sort keys %ValueParams;
                $ICalEventProperties{rrule} = $Value;
            }

            # add the excluded dates as a repeatable property
            if ( $Appointment{RecurrenceExclude} ) {
                RECURRENCE_EXCLUDE:
                for my $RecurrenceExclude ( $Appointment{RecurrenceExclude}->@* ) {
                    next RECURRENCE_EXCLUDE unless $RecurrenceExclude;

                    my $RecurrenceExcludeObject = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $RecurrenceExclude,
                        },
                    );
                    my $ICalRecurrenceID = Date::ICal->new(
                        epoch => $RecurrenceExcludeObject->ToEpoch(),
                    );

                    # TODO: cut off the time part too?
                    push @ICalRepeatableProperties, {
                        Property => 'exdate',
                        Value    => $Appointment{AllDay}
                        ? substr( $ICalRecurrenceID->ical(), 0, -1 )
                        : $ICalRecurrenceID->ical(),
                    };
                }
            }
        }

        # Add the user that emitted the event as the organizer.
        # E.g. ORGANIZER;CN="Sally Example":mailto:sally@example.com
        {
            my $UserObject = $Kernel::OM->Get('Kernel::System::User');
            my %User = $UserObject->GetUserData(
                UserID => $Appointment{ChangeBy},
                Valid  => 1,
            );
            if ( $User{UserEmail} ) {
                my %PropertyParams;
                if ( $User{UserFullname} ) {
                    $PropertyParams{CN} = $User{UserFullname};
                }
                $ICalEventProperties{organizer} = [ "MAILTO:$User{UserEmail}", \%PropertyParams ];
            }
        }

        # Only add the user email as the attendee in order to not leak information to customers.
        if ( $Param{Recipient}->{UserEmail} ) {
            $ICalEventProperties{attendee} = [ "MAILTO:$Param{Recipient}->{UserEmail}", ];
        }

        # Calculate last modified time.
        my $ChangeTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Appointment{ChangeTime},
            },
        );
        my $ICalChangeTime = Date::ICal->new(
            epoch => $ChangeTimeObject->ToEpoch(),
        );

        # Add both required and optional properties.
        # Remove time zone flag for all day appointments.
        # TODO: cut off the time part too?
        $ICalEvent->add_properties(
            summary         => $Appointment{Title},
            dtstart         => $Appointment{AllDay} ? substr( $ICalStartTime->ical(), 0, -1 ) : $ICalStartTime->ical(),
            dtend           => $Appointment{AllDay} ? substr( $ICalEndTime->ical(), 0, -1 ) : $ICalEndTime->ical(),
            uid             => $Appointment{UniqueID},
            'last-modified' => $ICalChangeTime->ical(),
            %ICalEventProperties,
        );

        # Add repeatable properties.
        for my $Repeatable (@ICalRepeatableProperties) {
            $ICalEvent->add_properties(
                $Repeatable->{Property} => $Repeatable->{Value},
            );
        }

        $ICalCalendar->add_entry($ICalEvent);

        my $ICSContent = $ICalCalendar->as_string();

        # Set METHOD, STATUS, TRANSP + SEQUENCE.
        # TODO: why are these not added with add_properties() ???
        my %ICSFileParameter = (
            Invitation => {
                METHOD => 'REQUEST',
                STATUS => 'CONFIRMED',
                TRANSP => 'OPAQUE',
            },
            Cancellation => {
                METHOD => 'CANCEL',
                STATUS => 'CANCELLED',
                TRANSP => 'TRANSPARENT',
            },
        );
        my $Method   = $ICSFileParameter{ $Param{Recipient}->{ICSFileType} }->{METHOD};
        my $Status   = $ICSFileParameter{ $Param{Recipient}->{ICSFileType} }->{STATUS};
        my $Transp   = $ICSFileParameter{ $Param{Recipient}->{ICSFileType} }->{TRANSP};
        my $Sequence = $Appointment{DynamicField_AppointmentSequence};
        $ICSContent =~ s{(.*) (PRODID: [^\n]* ) (.*)}{$1$2\nMETHOD:${Method}$3}xms;
        $ICSContent =~ s{(.*) (DTEND: [^\n]* ) (.*)}{$1$2\nSTATUS:${Status}$3}xms;
        $ICSContent =~ s{(.*) (DTEND: [^\n]* ) (.*)}{$1$2\nTRANSP:${Transp}$3}xms;
        $ICSContent =~ s{(.*) (DTEND: [^\n]* ) (.*)}{$1$2\nSEQUENCE:${Sequence}$3}xms;

        $Kernel::OM->Get('Kernel::System::CheckItem')->StringClean(
            StringRef => \$ICSContent,
        );

        # Add the .ics file as an attachment to the mail.
        # The invitation must be the first attachment as this position is
        # checked for application/ics attachments when constructing the MIME messsage.
        # See https://devguide.calconnect.org/iMIP/iMIPBest-Practices?utm_source=pocket_saves
        # Apparently Exchange adds the MIME header "Content-Class: urn:content-classes:calendarmessage"
        # to the application/ics attachment. But this header is not added here,
        # as Kernel::System::Email::Send() does not support extra headers.
        $Param{Attachments} //= [];
        unshift $Param{Attachments}->@*,
            {
                Filename    => 'otobo_invite.ics', # the file name should have .ics extension, base name is arbitrary
                Content     => $ICSContent,
                ContentType => qq{application/ics; method=$Method; charset="UTF-8"; name="otobo_invite.ics"},
                Disposition => 'attachment',
            };
    }

    my $TransportObject = $Param{TransportObject};

    # send notification to each recipient
    my $Success = $TransportObject->SendNotification(
        AppointmentID         => $Param{AppointmentID},
        CalendarID            => $Param{CalendarID},
        UserID                => $Param{UserID},
        Notification          => $Param{Notification},
        CustomerMessageParams => $Param{CustomerMessageParams},
        Recipient             => $Param{Recipient},
        Event                 => $Param{Event},
        Attachments           => $Param{Attachments},
    );

    return if !$Success;

    my %EventData = %{ $TransportObject->GetTransportEventData() };

    return 1 if !%EventData;

    if ( !$EventData{Event} || !$EventData{Data} || !$EventData{UserID} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not trigger notification post send event",
        );

        return;
    }

    return 1;
}

sub _FutureTaskUpdate {
    my ( $Self, %Param ) = @_;

    # Get the next upcoming appointment.
    my $Success = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentFutureTasksUpdate();

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not update upcoming appointment data!',
        );
        return;
    }

    return 1;
}

{
    no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)

    # Include product name and version in product ID property for debugging purposes, by redefining
    #   external library method.
    sub Data::ICal::product_id { ## no critic 'OTOBO::RequireCamelCase'
        return 'OTOBO ' . $Kernel::OM->Get('Kernel::Config')->Get('Version');
    }
}

1;
