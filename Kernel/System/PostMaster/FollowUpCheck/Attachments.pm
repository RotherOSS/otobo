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

package Kernel::System::PostMaster::FollowUpCheck::Attachments;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Ignore all inline parts as these are actually part of the email body.
    my @Attachments = $Self->{ParserObject}->GetAttachments();
    @Attachments = grep { defined $_->{ContentDisposition} && $_->{ContentDisposition} ne 'inline' } @Attachments;

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Debug',
        Key           => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
        Value         => 'Searching for TicketNumber in email attachments.',
    );

    ATTACHMENT:
    for my $Attachment (@Attachments) {

        my $Tn = $TicketObject->GetTNByString( $Attachment->{Content} );
        next ATTACHMENT if !$Tn;

        my $TicketID = $TicketObject->TicketCheckNumber( Tn => $Tn );

        if ($TicketID) {

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Debug',
                Key           => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
                Value         =>
                    "Found valid TicketNumber '$Tn' (TicketID '$TicketID') in email attachment '$Attachment->{Filename}'.",
            );

            return $TicketID;
        }
    }

    return;
}

1;
