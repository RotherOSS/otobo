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

package Kernel::System::PostMaster::Filter::DetectAttachment;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject";

    # Get communication log object and MessageID.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(JobConfig GetParam)) {
        if ( !$Param{$Needed} ) {
            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::DetectAttachment',
                Value         => "Need $Needed!",
            );
            return;
        }
    }

    # Get attachments.
    my @Attachments = $Self->{ParserObject}->GetAttachments();

    my $AttachmentCount = 0;
    for my $Attachment (@Attachments) {

        # Do not flag inline images as attachments, see bug#14949 for more information.
        my $AttachmentInline = 0;
        if (
            defined $Attachment->{ContentID}
            && length $Attachment->{ContentID}
            )
        {
            my ($ImageID) = ( $Attachment->{ContentID} =~ m{^<(.*)>$}ixms );
            if ( grep { $_->{Content} =~ m{<img.*src=.*['|"]cid:\Q$ImageID\E['|"].*>}ixms } @Attachments ) {
                $AttachmentInline = 1;
            }
        }

        if (
            defined $Attachment->{ContentDisposition}
            && length $Attachment->{ContentDisposition}
            && !$AttachmentInline
            )
        {
            $AttachmentCount++;
        }
    }

    $Param{GetParam}->{'X-OTOBO-AttachmentExists'} = ( $AttachmentCount ? 'yes' : 'no' );
    $Param{GetParam}->{'X-OTOBO-AttachmentCount'}  = $AttachmentCount;

    return 1;
}

1;
