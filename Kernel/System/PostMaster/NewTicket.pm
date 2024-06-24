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

package Kernel::System::PostMaster::NewTicket;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::DateTime',
    'Kernel::System::Type',
    'Kernel::System::User',
    'Kernel::System::Service',
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
    for my $Needed (qw(InmailUserID GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Need $Needed!",
            );
            return;
        }
    }
    my %GetParam         = %{ $Param{GetParam} };
    my $Comment          = $Param{Comment}          || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # get queue id and name
    my $QueueID = $Param{QueueID} || die "need QueueID!";
    my $Queue   = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
        QueueID => $QueueID,
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get state
    my $State = $ConfigObject->Get('PostmasterDefaultState') || 'new';
    if ( $GetParam{'X-OTOBO-State'} ) {

        my $StateID = $Kernel::OM->Get('Kernel::System::State')->StateLookup(
            State => $GetParam{'X-OTOBO-State'},
        );

        if ($StateID) {
            $State = $GetParam{'X-OTOBO-State'};
        }
        else {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "State $GetParam{'X-OTOBO-State'} does not exist, falling back to $State!",
            );
        }
    }

    # get priority
    my $Priority = $ConfigObject->Get('PostmasterDefaultPriority') || '3 normal';

    if ( $GetParam{'X-OTOBO-Priority'} ) {

        my $PriorityID = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
            Priority => $GetParam{'X-OTOBO-Priority'},
        );

        if ($PriorityID) {
            $Priority = $GetParam{'X-OTOBO-Priority'};
        }
        else {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Priority $GetParam{'X-OTOBO-Priority'} does not exist, falling back to $Priority!",
            );
        }
    }

    my $TypeID;

    if ( $GetParam{'X-OTOBO-Type'} ) {

        # Check if type exists
        $TypeID = $Kernel::OM->Get('Kernel::System::Type')->TypeLookup( Type => $GetParam{'X-OTOBO-Type'} );

        if ( !$TypeID ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Type $GetParam{'X-OTOBO-Type'} does not exist, falling back to default type.",
            );
        }
    }

    # get sender email
    my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
        Line => $GetParam{From},
    );
    for my $Address (@EmailAddresses) {
        $GetParam{SenderEmailAddress} = $Self->{ParserObject}->GetEmailAddress(
            Email => $Address,
        );
    }

    $GetParam{SenderEmailAddress} //= '';

    # get customer id (sender email) if there is no customer id given
    if ( !$GetParam{'X-OTOBO-CustomerNo'} && $GetParam{'X-OTOBO-CustomerUser'} ) {

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # get customer user data form X-OTOBO-CustomerUser
        my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
            User => $GetParam{'X-OTOBO-CustomerUser'},
        );

        if (%CustomerData) {
            $GetParam{'X-OTOBO-CustomerNo'} = $CustomerData{UserCustomerID};
        }
    }

    # get customer user data form From: (sender address)
    if ( !$GetParam{'X-OTOBO-CustomerUser'} ) {

        my %CustomerData;
        if ( $GetParam{From} ) {

            my @EmailAddresses = $Self->{ParserObject}->SplitAddressLine(
                Line => $GetParam{From},
            );

            for my $Address (@EmailAddresses) {
                $GetParam{EmailFrom} = $Self->{ParserObject}->GetEmailAddress(
                    Email => $Address,
                );
            }

            if ( $GetParam{EmailFrom} ) {

                # get customer user object
                my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

                my %List = $CustomerUserObject->CustomerSearch(
                    PostMasterSearch => lc( $GetParam{EmailFrom} ),
                );

                for my $UserLogin ( sort keys %List ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        User => $UserLogin,
                    );
                }
            }
        }

        # take CustomerID from customer backend lookup or from from field
        if ( $CustomerData{UserLogin} && !$GetParam{'X-OTOBO-CustomerUser'} ) {
            $GetParam{'X-OTOBO-CustomerUser'} = $CustomerData{UserLogin};

            # notice that UserLogin is from customer source backend
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Take UserLogin ($CustomerData{UserLogin}) from "
                    . "customer source backend based on ($GetParam{'EmailFrom'}).",
            );
        }
        if ( $CustomerData{UserCustomerID} && !$GetParam{'X-OTOBO-CustomerNo'} ) {
            $GetParam{'X-OTOBO-CustomerNo'} = $CustomerData{UserCustomerID};

            # notice that UserCustomerID is from customer source backend
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Notice',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Take UserCustomerID ($CustomerData{UserCustomerID})"
                    . " from customer source backend based on ($GetParam{'EmailFrom'}).",
            );
        }
    }

    # if there is no customer id found!
    if (
        !$GetParam{'X-OTOBO-CustomerNo'}
        && $ConfigObject->Get('PostMaster::NewTicket::AutoAssignCustomerIDForUnknownCustomers')
        )
    {
        $GetParam{'X-OTOBO-CustomerNo'} = $GetParam{SenderEmailAddress};
    }

    # if there is no customer user found!
    if ( !$GetParam{'X-OTOBO-CustomerUser'} ) {
        $GetParam{'X-OTOBO-CustomerUser'} = $GetParam{SenderEmailAddress};
    }

    # get ticket owner
    my $OwnerID = $GetParam{'X-OTOBO-OwnerID'} || $Param{InmailUserID};
    if ( $GetParam{'X-OTOBO-Owner'} ) {

        my $TmpOwnerID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $GetParam{'X-OTOBO-Owner'},
        );

        $OwnerID = $TmpOwnerID || $OwnerID;
    }

    my %Opts;
    if ( $GetParam{'X-OTOBO-ResponsibleID'} ) {
        $Opts{ResponsibleID} = $GetParam{'X-OTOBO-ResponsibleID'};
    }

    if ( $GetParam{'X-OTOBO-Responsible'} ) {

        my $TmpResponsibleID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $GetParam{'X-OTOBO-Responsible'},
        );

        $Opts{ResponsibleID} = $TmpResponsibleID || $Opts{ResponsibleID};
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::NewTicket',
        Value         => "Going to create new ticket.",
    );

    if ( $GetParam{'X-OTOBO-Service'} ) {
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        # Check if service exists.
        my %ServiceData = $ServiceObject->ServiceGet(
            Name   => $GetParam{'X-OTOBO-Service'},
            UserID => $Param{InmailUserID},
        );

        # Get all service list filtering by KeepChildren SysConfig if available.
        my %ServiceList = $ServiceObject->ServiceList(
            Valid        => 1,
            KeepChildren => $ConfigObject->Get('Ticket::Service::KeepChildren') // 0,
            UserID       => $Param{InmailUserID},
        );

        if ( $ServiceData{ServiceID} ne '' && !$ServiceList{ $ServiceData{ServiceID} } ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         =>
                    "Service $GetParam{'X-OTOBO-Service'} does not exists or is invalid or is a child of invalid service.",
            );
            $GetParam{'X-OTOBO-Service'} = '';
        }
    }

    # create new ticket
    my $NewTn    = $TicketObject->TicketCreateNumber();
    my $TicketID = $TicketObject->TicketCreate(
        TN           => $NewTn,
        Title        => $GetParam{'X-OTOBO-Title'} || $GetParam{Subject},
        QueueID      => $QueueID,
        Lock         => $GetParam{'X-OTOBO-Lock'} || 'unlock',
        Priority     => $Priority,
        State        => $State,
        TypeID       => $TypeID,
        Service      => $GetParam{'X-OTOBO-Service'} || '',
        SLA          => $GetParam{'X-OTOBO-SLA'}     || '',
        CustomerID   => $GetParam{'X-OTOBO-CustomerNo'},
        CustomerUser => $GetParam{'X-OTOBO-CustomerUser'},
        OwnerID      => $OwnerID,
        UserID       => $Param{InmailUserID},
        %Opts,
    );

    if ( !$TicketID ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "Ticket could not be created!",
        );
        return;
    }

    my $TicketCreateMessage = <<"END_MESSAGE";
New Ticket created:

TicketNumber: $NewTn
TicketID: $TicketID
Priority: $Priority
State: $State
CustomerID: $GetParam{'X-OTOBO-CustomerNo'}
CustomerUser: $GetParam{'X-OTOBO-CustomerUser'}

END_MESSAGE

    for my $Value (qw(Type Service SLA Lock)) {

        if ( $GetParam{ 'X-OTOBO-' . $Value } ) {
            $TicketCreateMessage .= "$Value: " . $GetParam{ 'X-OTOBO-' . $Value } . "\n";
        }
    }

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::NewTicket',
        Value         => $TicketCreateMessage,
    );

    # set pending time
    if ( $GetParam{'X-OTOBO-State-PendingTime'} ) {

        # You can specify absolute dates like "2010-11-20 00:00:00" or relative dates, based on the arrival time of the email.
        # Use the form "+ $Number $Unit", where $Unit can be 's' (seconds), 'm' (minutes), 'h' (hours) or 'd' (days).
        # Only one unit can be specified. Examples of valid settings: "+50s" (pending in 50 seconds), "+30m" (30 minutes),
        # "+12d" (12 days). Note that settings like "+1d 12h" are not possible. You can specify "+36h" instead.

        my $TargetTimeStamp = $GetParam{'X-OTOBO-State-PendingTime'};

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

        my $Set = $TicketObject->TicketPendingTimeSet(
            String   => $TargetTimeStamp,
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         =>
                "Pending time update via 'X-OTOBO-State-PendingTime'! State-PendingTime: $GetParam{'X-OTOBO-State-PendingTime'}.",
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
        my $Key = 'X-OTOBO-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};

        if ( defined $GetParam{$Key} && length $GetParam{$Key} ) {

            # get dynamic field config
            my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet(
                ID => $DynamicFieldID,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldGet,
                ObjectID           => $TicketID,
                Value              => $GetParam{$Key},
                UserID             => $Param{InmailUserID},
            );

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "DynamicField update via '$Key'! Value: $GetParam{$Key}.",
            );
        }
    }

    # reverse dynamic field list
    my %DynamicFieldListReversed = reverse %{$DynamicFieldList};

    # set ticket free text
    # for backward compatibility (should be removed in a future version)
    my %Values =
        (
            'X-OTOBO-TicketKey'   => 'TicketFreeKey',
            'X-OTOBO-TicketValue' => 'TicketFreeText',
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
                        ObjectID           => $TicketID,
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::NewTicket',
                    Value         => "DynamicField (TicketKey$Count) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    # set ticket free time
    # for backward compatibility (should be removed in a future version)
    for my $Count ( 1 .. 6 ) {

        my $Key = 'X-OTOBO-TicketTime' . $Count;

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
                        ObjectID           => $TicketID,
                        Value              => $GetParam{$Key},
                        UserID             => $Param{InmailUserID},
                    );
                }

                $Self->{CommunicationLogObject}->ObjectLog(
                    ObjectLogType => 'Message',
                    Priority      => 'Debug',
                    Key           => 'Kernel::System::PostMaster::NewTicket',
                    Value         => "DynamicField (TicketTime$Count) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
    }

    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForChannel(
        ChannelName => 'Email',
    );

    my $IsVisibleForCustomer = 1;
    if ( length $GetParam{'X-OTOBO-IsVisibleForCustomer'} ) {
        $IsVisibleForCustomer = $GetParam{'X-OTOBO-IsVisibleForCustomer'};
    }

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::NewTicket',
        Value         => "Going to create new article for TicketID '$TicketID'.",
    );

    # Check if X-OTOBO-SenderType exists, if not set default 'customer'.
    if ( !$ArticleObject->ArticleSenderTypeLookup( SenderType => $GetParam{'X-OTOBO-SenderType'} ) )
    {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "Can't find valid SenderType '$GetParam{'X-OTOBO-SenderType'}' in DB, take 'customer'",
        );
        $GetParam{'X-OTOBO-SenderType'} = 'customer';
    }

    # Create email article.
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        SenderType           => $GetParam{'X-OTOBO-SenderType'},
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
        ContentDisposition   => $GetParam{'Content-Disposition'},
        Body                 => $GetParam{Body},
        UserID               => $Param{InmailUserID},
        HistoryType          => 'EmailCustomer',
        HistoryComment       => "\%\%$Comment",
        OrigHeader           => \%GetParam,
        AutoResponseType     => $AutoResponseType,
        Queue                => $Queue,
    );

    # close ticket if article create failed!
    if ( !$ArticleID ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "Can't process email with MessageID <$GetParam{'Message-ID'}>! "
                . "Please create a bug report with this email (From: $GetParam{From}, Located "
                . "under var/spool/problem-email*) on https://github.com/RotherOSS/otobo/issues/!",
        );

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "TicketID '$TicketID' will be deleted again!",
        );

        $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $Param{InmailUserID},
        );

        return;
    }

    for my $Flag (qw/Crypted CryptedOK Signed SignedOK/) {
        if ( $GetParam{$Flag} ) {
            my $Success = $ArticleObject->ArticleFlagSet(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                Key       => $Flag,
                Value     => $GetParam{$Flag},
                UserID    => 1,
            );
        }
    }

    $Self->{CommunicationLogObject}->ObjectLookupSet(
        ObjectLogType    => 'Message',
        TargetObjectType => 'Article',
        TargetObjectID   => $ArticleID,
    );

    if ( $Param{LinkToTicketID} ) {

        my $SourceKey = $Param{LinkToTicketID};
        my $TargetKey = $TicketID;

        $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $SourceKey,
            TargetObject => 'Ticket',
            TargetKey    => $TargetKey,
            Type         => 'Normal',
            State        => 'Valid',
            UserID       => $Param{InmailUserID},
        );
    }

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
            Key           => 'Kernel::System::PostMaster::NewTicket',
            Value         => "$Attribute: $Value",
        );
    }

    # dynamic fields
    $DynamicFieldList =
        $DynamicFieldObject->DynamicFieldList(
            Valid      => 1,
            ResultType => 'HASH',
            ObjectType => 'Article',
        );

    # set dynamic fields for Article object type
    DYNAMICFIELDID:
    for my $DynamicFieldID ( sort keys %{$DynamicFieldList} ) {
        next DYNAMICFIELDID if !$DynamicFieldID;
        next DYNAMICFIELDID if !$DynamicFieldList->{$DynamicFieldID};
        my $Key = 'X-OTOBO-DynamicField-' . $DynamicFieldList->{$DynamicFieldID};
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
                Key           => 'Kernel::System::PostMaster::NewTicket',
                Value         => "Article DynamicField update via '$Key'! Value: $GetParam{$Key}.",
            );
        }
    }

    # reverse dynamic field list
    %DynamicFieldListReversed = reverse %{$DynamicFieldList};

    # set free article text
    # for backward compatibility (should be removed in a future version)
    %Values =
        (
            'X-OTOBO-ArticleKey'   => 'ArticleFreeKey',
            'X-OTOBO-ArticleValue' => 'ArticleFreeText',
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
                    Key           => 'Kernel::System::PostMaster::NewTicket',
                    Value         => "Article DynamicField (ArticleKey) update via '$Key'! Value: $GetParam{$Key}.",
                );
            }
        }
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

    return $TicketID;
}

1;
