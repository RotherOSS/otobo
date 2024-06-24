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

package Kernel::Modules::AjaxAttachment;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get param object
    my $ParamObject       = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my $LayoutObject      = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' );

    if ( !$Self->{FormID} ) {
        return $LayoutObject->FatalError(
            Message => Translatable('Got no FormID.'),
        );
    }

    # challenge token check for write action
    $LayoutObject->ChallengeTokenCheck();

    if ( $Self->{Subaction} eq 'Upload' ) {

        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'Files',
        );

        $UploadCacheObject->FormIDAddFile(
            FormID      => $Self->{FormID},
            Disposition => 'attachment',
            %UploadStuff,
        );

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        my @AttachmentData;

        ATTACHMENT:
        for my $Attachment (@Attachments) {

            # Hide inline attachments from the display. Please see bug#13498 for more information.
            next ATTACHMENT if $Attachment->{Disposition} eq 'inline';

            # Add human readable data size.
            $Attachment->{HumanReadableDataSize} = $LayoutObject->HumanReadableDataSize(
                Size => $Attachment->{Filesize},
            );

            push @AttachmentData, $Attachment;
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json',
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => \@AttachmentData,
            ),
            Type    => 'inline',
            NoCache => 1,
        );
    }
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        my $Return;
        my $AttachmentFileID = $ParamObject->GetParam( Param => 'FileID' ) || '';

        if ( !$AttachmentFileID ) {
            $Return->{Message} = $LayoutObject->{LanguageObject}->Translate(
                'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).'
            );
        }
        else {

            my $DeleteAttachment = $UploadCacheObject->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $AttachmentFileID,
            );

            if ($DeleteAttachment) {

                my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
                    FormID => $Self->{FormID},
                );

                my @AttachmentData;

                ATTACHMENT:
                for my $Attachment (@Attachments) {

                    # Hide inline attachments from the display. Please see bug#13498 for more information.
                    next ATTACHMENT if $Attachment->{Disposition} eq 'inline';

                    push @AttachmentData, $Attachment;
                }

                $Return = {
                    Message => 'Success',
                    Data    => \@AttachmentData,
                };
            }
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json',
            Content     => $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => $Return,
            ),
            Type    => 'inline',
            NoCache => 1,
        );
    }
}

1;
