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

package Kernel::System::PostMaster::FollowUp;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::DateTime',
    'Kernel::System::User',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # get parser object
    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID InmailUserID GetParam Tn AutoResponseType)) {
        if ( !$Param{$_} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::FollowUp',
                Value         => "Need $_!",
            );
            return;
        }
    }
    my %GetParam = %{ $Param{GetParam} };

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $OwnerID = $GetParam{'X-OTOBO-FollowUp-OwnerID'};
    if ( $GetParam{'X-OTOBO-FollowUp-Owner'} ) {

        my $TmpOwnerID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $GetParam{'X-OTOBO-FollowUp-Owner'},
        );

        $OwnerID = $TmpOwnerID || $OwnerID;
    }

    if ($OwnerID) {
        my $Success = $TicketObject->TicketOwnerSet(
            TicketID  => $Param{TicketID},
            NewUserID => $OwnerID,
            UserID    => $Param{InmailUserID},
        );
    }

    my $ResponsibleID = $GetParam{'X-OTOBO-FollowUp-ResponsibleID'};
    if ( $GetParam{'X-OTOBO-FollowUp-Responsible'} ) {

        my $TmpResponsibleID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $GetParam{'X-OTOBO-FollowUp-Responsible'},
        );

        $ResponsibleID = $TmpResponsibleID || $ResponsibleID;
    }

    if ($ResponsibleID) {
        my $Success = $TicketObject->TicketResponsibleSet(
            TicketID  => $Param{TicketID},
            NewUserID => $ResponsibleID,
            UserID    => $Param{InmailUserID},
        );
    }

    # get ticket data
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
    );

    my $Comment          = $Param{Comment}          || '';
    my $Lock             = $Param{Lock}             || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # Check if owner of ticket is still valid
    my %UserInfo = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
        UserID => $Ticket{OwnerID},
    );

    # 1) check user, out of office, unlock ticket
    if ( $UserInfo{OutOfOfficeMessage} ) {

        $TicketObject->TicketLockSet(
            TicketID => $Param{TicketID},
            Lock     => 'unlock',
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Notice',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         => "Ticket [$Param{Tn}] unlocked, current owner is out of office!",
        );
    }

    # 2) check user, just lock it if user is valid, not root@localhost and ticket was closed
    elsif ( $UserInfo{ValidID} eq 1 && $UserInfo{UserID} ne 1 ) {

        # set lock (if ticket should be locked on follow up)
        if ( $Lock && $Ticket{StateType} =~ /^close/i ) {

            $TicketObject->TicketLockSet(
                TicketID => $Param{TicketID},
                Lock     => 'lock',
                UserID   => $Param{InmailUserID},
            );

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::FollowUp',
                Value         => "Ticket [$Param{Tn}] still locked.",
            );
        }
    }

    # 3) Unlock ticket, because current user is set to invalid
    else {

        $TicketObject->TicketLockSet(
            TicketID => $Param{TicketID},
            Lock     => 'unlock',
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Notice',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         => "Ticket [$Param{Tn}] unlocked, current owner is invalid!",
        );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # set state
    my $State = $ConfigObject->Get('PostmasterFollowUpState') || 'open';
    if (
        $Ticket{StateType} =~ /^close/
        && $ConfigObject->Get('PostmasterFollowUpStateClosed')
        )
    {
        $State = $ConfigObject->Get('PostmasterFollowUpStateClosed');
    }
    if ( $GetParam{'X-OTOBO-FollowUp-State'} ) {
        $State = $GetParam{'X-OTOBO-FollowUp-State'};
    }

    my $KeepStateHeader = $ConfigObject->Get('KeepStateHeader') || 'X-OTOBO-FollowUp-State-Keep';
    if (
        ( $Ticket{StateType} !~ /^new/ || $GetParam{'X-OTOBO-FollowUp-State'} )
        && !$GetParam{$KeepStateHeader}
        )
    {
        $TicketObject->TicketStateSet(
            State    => $GetParam{'X-OTOBO-FollowUp-State'} || $State,
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         => "Ticket state will be left unchanged! State: $State.",
        );
    }

    # set pending time
    if ( $GetParam{'X-OTOBO-FollowUp-State-PendingTime'} ) {

        # You can specify absolute dates like "2010-11-20 00:00:00" or relative dates, based on the arrival time of the email.
        # Use the form "+ $Number $Unit", where $Unit can be 's' (seconds), 'm' (minutes), 'h' (hours) or 'd' (days).
        # Only one unit can be specified. Examples of valid settings: "+50s" (pending in 50 seconds), "+30m" (30 minutes),
        # "+12d" (12 days). Note that settings like "+1d 12h" are not possible. You can specify "+36h" instead.

        my $TargetTimeStamp = $GetParam{'X-OTOBO-FollowUp-State-PendingTime'};

        my ( $Sign, $Number, $Unit ) = $TargetTimeStamp =~ m{^\s*([+-]?)\s*(\d+)\s*([smhd]?)\s*$}smx;

        if ($Number) {
            $Sign ||= '+';
            $Unit ||= 's';

            my $Seconds = $Sign eq '-' ? ( $Number * -1 ) : $Number;

            my %UnitMultiplier = (
                s => 1,
                m => 60,
                h => 60 * 60,
                d => 60 * 60 * 24,
            );

            $Seconds = $Seconds * $UnitMultiplier{$Unit};

            # get datetime object
            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            $DateTimeObject->Add( Seconds => $Seconds );
            $TargetTimeStamp = $DateTimeObject->ToString();
        }

        my $Updated = $TicketObject->TicketPendingTimeSet(
            String   => $TargetTimeStamp,
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        # debug
        if ($Updated) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::FollowUp',
                Value         =>
                    "Pending time update via 'X-OTOBO-FollowUp-State-PendingTime'! State-PendingTime: $GetParam{'X-OTOBO-FollowUp-State-PendingTime'}.",
            );
        }
    }

    # set priority
    if ( $GetParam{'X-OTOBO-FollowUp-Priority'} ) {

        $TicketObject->TicketPrioritySet(
            TicketID => $Param{TicketID},
            Priority => $GetParam{'X-OTOBO-FollowUp-Priority'},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         =>
                "Priority update via 'X-OTOBO-FollowUp-Priority'! Priority: $GetParam{'X-OTOBO-FollowUp-Priority'}.",
        );
    }

    # set queue
    if ( $GetParam{'X-OTOBO-FollowUp-Queue'} ) {

        $TicketObject->TicketQueueSet(
            Queue    => $GetParam{'X-OTOBO-FollowUp-Queue'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         =>
                "Queue update via 'X-OTOBO-FollowUp-Queue'! Queue: $GetParam{'X-OTOBO-FollowUp-Queue'}.",
        );
    }

    # set lock if ticket does not belong to root@localhost
    if ( $GetParam{'X-OTOBO-FollowUp-Lock'} && $UserInfo{UserID} ne 1 ) {

        $TicketObject->TicketLockSet(
            Lock     => $GetParam{'X-OTOBO-FollowUp-Lock'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         =>
                "Lock update via 'X-OTOBO-FollowUp-Lock'! Lock: $GetParam{'X-OTOBO-FollowUp-Lock'}.",
        );
    }

    # set ticket type
    if ( $GetParam{'X-OTOBO-FollowUp-Type'} ) {

        $TicketObject->TicketTypeSet(
            Type     => $GetParam{'X-OTOBO-FollowUp-Type'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         =>
                "Type update via 'X-OTOBO-FollowUp-Type'! Type: $GetParam{'X-OTOBO-FollowUp-Type'}.",
        );
    }

    # set ticket service
    if ( $GetParam{'X-OTOBO-FollowUp-Service'} ) {

        $TicketObject->TicketServiceSet(
            Service  => $GetParam{'X-OTOBO-FollowUp-Service'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         =>
                "Services update via 'X-OTOBO-FollowUp-Service'! Service: $GetParam{'X-OTOBO-FollowUp-Service'}.",
        );
    }

    # set ticket sla
    if ( $GetParam{'X-OTOBO-FollowUp-SLA'} ) {

        $TicketObject->TicketSLASet(
            SLA      => $GetParam{'X-OTOBO-FollowUp-SLA'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         =>
                "SLA update via 'X-OTOBO-FollowUp-SLA'! SLA: $GetParam{'X-OTOBO-FollowUp-SLA'}.",
        );
    }

    # get dynamic field objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # dynamic fields
    my $DynamicFieldList =
        $DynamicFieldObject->DynamicFieldList(
            Valid      => 1,
            ResultType => 'HASH',
            ObjectType => 'Ticket',
        );

    # set dynamic fields for Ticket object type
    DYNAMICFIELDID:
    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        next DYNAMICFIELDID if !$DynamicFieldID;
        next DYNAMICFIELDID if !$DynamicFieldList->{$DynamicFieldID};
        my $Key = 'X-OTOBO-FollowUp-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};
        if ( defined $GetParam{$Key} && length $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFieldID,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $Param{TicketID},
                Value              => $GetParam{$Key},
                UserID             => $Param{InmailUserID},
            );

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::FollowUp',
                Value         =>
                    "DynamicField update via '$Key'! Value: $GetParam{$Key}.",
            );
        }
    }

    # reverse dynamic field list
    my %DynamicFieldListReversed = reverse %{$DynamicFieldList};

    # set ticket free text
    my %Values =
        (
            'X-OTOBO-FollowUp-TicketKey'   => 'TicketFreeKey',
            'X-OTOBO-FollowUp-TicketValue' => 'TicketFreeText',
        );
    for my $Item ( sort keys %Values ) {
        for my $Count ( 1 .. 16 ) {
            my $Key = $Item . $Count;
            if (
                defined $GetParam{$Key}
                && length $GetParam{$Key}
                && $DynamicFieldListReversed{ $Values{$Item} . $Count }
                )
            {
                # get dynamic field config
                my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ $Values{$Item} . $Count },
                );
                if ($DynamicFieldGet) {
                    my $Success = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $Param{TicketID},
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::FollowUp',
                    Value         =>
                        "DynamicField (TicketKey$Count) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    # set ticket free time
    for my $Count ( 1 .. 6 ) {

        my $Key = 'X-OTOBO-FollowUp-TicketTime' . $Count;

        if ( defined $GetParam{$Key} && length $GetParam{$Key} ) {

            # get datetime object
            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $GetParam{$Key}
                }
            );

            if ( $DateTimeObject && $DynamicFieldListReversed{ 'TicketFreeTime' . $Count } ) {

                # get dynamic field config
                my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ 'TicketFreeTime' . $Count },
                );

                if ($DynamicFieldGet) {
                    my $Success = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $Param{TicketID},
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::FollowUp',
                    Value         =>
                        "DynamicField (TicketTime$Count) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel(
        ChannelName => 'Email',
    );

    my $IsVisibleForCustomer = 1;
    if ( length $GetParam{'X-OTOBO-FollowUp-IsVisibleForCustomer'} ) {
        $IsVisibleForCustomer = $GetParam{'X-OTOBO-FollowUp-IsVisibleForCustomer'};
    }

    # Check if X-OTOBO-FollowUp-SenderType exists, if not set default 'customer'.
    if ( !$ArticleObject->ArticleSenderTypeLookup( SenderType => $GetParam{'X-OTOBO-FollowUp-SenderType'} ) )
    {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         => "Can't find valid SenderType '$GetParam{'X-OTOBO-FollowUp-SenderType'}' in DB, take 'customer'",
        );
        $GetParam{'X-OTOBO-SenderType'} = 'customer';
    }

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::FollowUp',
        Value         => "Going to create follow up for TicketID '$Param{TicketID}'.",
    );

    # do db insert
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $Param{TicketID},
        SenderType           => $GetParam{'X-OTOBO-FollowUp-SenderType'},
        IsVisibleForCustomer => $IsVisibleForCustomer,
        From                 => $GetParam{From},
        ReplyTo              => $GetParam{ReplyTo},
        To                   => $GetParam{To},
        Cc                   => $GetParam{Cc},
        Subject              => $GetParam{Subject},
        MessageID            => $GetParam{'Message-ID'},
        InReplyTo            => $GetParam{'In-Reply-To'},
        References           => $GetParam{'References'},
        ContentType          => $GetParam{'Content-Type'},
        Body                 => $GetParam{Body},
        UserID               => $Param{InmailUserID},
        HistoryType          => 'FollowUp',
        HistoryComment       => "\%\%$Param{Tn}\%\%$Comment",
        AutoResponseType     => $AutoResponseType,
        OrigHeader           => \%GetParam,
    );
    return if !$ArticleID;

    for my $Flag (qw/Crypted CryptedOK Signed SignedOK/) {
        if ( $GetParam{$Flag} ) {
            my $Success = $ArticleObject->ArticleFlagSet(
                TicketID  => $Param{TicketID},
                ArticleID => $ArticleID,
                Key       => $Flag,
                Value     => $GetParam{$Flag},
                UserID    => 1,
            );
        }
    }

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::FollowUp',
        Value         => "Follow up created for TicketID '$Param{TicketID}' (ArticleID: '$ArticleID')",
    );

    $Self->{CommunicationLogObject}->ObjectLookupSet(
        ObjectLogType    => 'Message',
        TargetObjectType => 'Article',
        TargetObjectID   => $ArticleID,
    );

    my %CommunicationLogSkipAttributes = (
        Body       => 1,
        Attachment => 1,
    );

    ATTRIBUTE:
    for my $Attribute ( sort keys %GetParam ) {
        next ATTRIBUTE if $CommunicationLogSkipAttributes{$Attribute};

        my $Value = $GetParam{$Attribute};
        next ATTRIBUTE if !( defined $Value ) || !( length $Value );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         => "$Attribute: $Value",
        );
    }

    # write plain email to the storage
    $ArticleBackendObject->ArticleWritePlain(
        ArticleID => $ArticleID,
        Email     => $Self->{ParserObject}->GetPlainEmail(),
        UserID    => $Param{InmailUserID},
    );

    # write attachments to the storage
    for my $Attachment ( $Self->{ParserObject}->GetAttachments() ) {
        $ArticleBackendObject->ArticleWriteAttachment(
            Filename           => $Attachment->{Filename},
            Content            => $Attachment->{Content},
            ContentType        => $Attachment->{ContentType},
            ContentID          => $Attachment->{ContentID},
            ContentAlternative => $Attachment->{ContentAlternative},
            Disposition        => $Attachment->{Disposition},
            ArticleID          => $ArticleID,
            UserID             => $Param{InmailUserID},
        );
    }

    # dynamic fields
    $DynamicFieldList =
        $DynamicFieldObject->DynamicFieldList(
            Valid      => 1,
            ResultType => 'HASH',
            ObjectType => 'Article'
        );

    # set dynamic fields for Article object type
    DYNAMICFIELDID:
    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        next DYNAMICFIELDID if !$DynamicFieldID;
        next DYNAMICFIELDID if !$DynamicFieldList->{$DynamicFieldID};
        my $Key = 'X-OTOBO-FollowUp-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};
        if ( defined $GetParam{$Key} && length $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFieldID,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $ArticleID,
                Value              => $GetParam{$Key},
                UserID             => $Param{InmailUserID},
            );

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::FollowUp',
                Value         => "Article DynamicField update via '$Key'! Value: $GetParam{$Key}.",
            );
        }
    }

    # reverse dynamic field list
    %DynamicFieldListReversed = reverse %{$DynamicFieldList};

    # set free article text
    %Values =
        (
            'X-OTOBO-FollowUp-ArticleKey'   => 'ArticleFreeKey',
            'X-OTOBO-FollowUp-ArticleValue' => 'ArticleFreeText',
        );
    for my $Item ( sort keys %Values ) {
        for my $Count ( 1 .. 16 ) {
            my $Key = $Item . $Count;
            if (
                defined $GetParam{$Key}
                && length $GetParam{$Key}
                && $DynamicFieldListReversed{ $Values{$Item} . $Count }
                )
            {
                # get dynamic field config
                my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                    ID => $DynamicFieldListReversed{ $Values{$Item} . $Count },
                );
                if ($DynamicFieldGet) {
                    my $Success = $DynamicFieldBackendObject->ValueSet(
                        DynamicFieldConfig => $DynamicFieldGet,
                        ObjectID           => $ArticleID,
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::FollowUp',
                    Value         =>
                        "Article DynamicField (ArticleKey) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    # set ticket title
    if ( $GetParam{'X-OTOBO-FollowUp-Title'} ) {

        $TicketObject->TicketTitleUpdate(
            Title    => $GetParam{'X-OTOBO-FollowUp-Title'},
            TicketID => $Param{TicketID},
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::FollowUp',
            Value         => "Title update via 'X-OTOBO-FollowUp-Title'! Value: $GetParam{'X-OTOBO-FollowUp-Title'}.",
        );
    }

    # write log
    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Notice',
        Key           => 'Kernel::System::PostMaster::FollowUp',
        Value         => "FollowUp Article to Ticket [$Param{Tn}] created "
            . "(TicketID=$Param{TicketID}, ArticleID=$ArticleID). $Comment,",
    );

    return 1;
}

1;
