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

package Kernel::Modules::CustomerTicketAttachment;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

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

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    my $TicketID  = $ParamObject->GetParam( Param => 'TicketID' );
    my $ArticleID = $ParamObject->GetParam( Param => 'ArticleID' );
    my $FileID    = $ParamObject->GetParam( Param => 'FileID' );

    # check params
    if ( !$FileID || !$ArticleID ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => Translatable('FileID and ArticleID are needed!'),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    if ( !$TicketID ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No TicketID for ArticleID (%s)!', $ArticleID ),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => "No TicketID for ArticleID ($ArticleID)!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    my @ArticleList = $ArticleObject->ArticleList(
        TicketID             => $TicketID,
        ArticleID            => $ArticleID,
        IsVisibleForCustomer => 1,
    );

    my $ArticleBackendObject;
    my %Article;

    ARTICLEMETADATA:
    for my $ArticleMetaData (@ArticleList) {

        next ARTICLEMETADATA if !$ArticleMetaData;
        next ARTICLEMETADATA if !IsHashRefWithData($ArticleMetaData);

        $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$ArticleMetaData} );

        %Article = $ArticleBackendObject->ArticleGet(
            TicketID      => $TicketID,
            ArticleID     => $ArticleMetaData->{ArticleID},
            DynamicFields => 0,
        );
    }

    # check permission
    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCustomerPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
    }

    # get attachment
    my %Data = $ArticleBackendObject->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID    => $FileID,
    );

    if ( !%Data ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'No such attachment (%s)!', $FileID ),
            Comment => Translatable('Please contact the administrator.'),
        );
        $LogObject->Log(
            Message  => "No such attachment ($FileID)! May be an attack!!!",
            Priority => 'error',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    # download it AttachmentDownloadType is configured
    return $LayoutObject->Attachment(
        %Data,
        Sandbox => 1,
    );
}

1;
