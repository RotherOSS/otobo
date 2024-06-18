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

package Kernel::Modules::AgentTicketArticleContent;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get IDs
    my $TicketID        = $ParamObject->GetParam( Param => 'TicketID' );
    my $ArticleID       = $ParamObject->GetParam( Param => 'ArticleID' );
    my $VersionView     = $ParamObject->GetParam( Param => 'VersionView' )     || '';
    my $SourceArticleID = $ParamObject->GetParam( Param => 'SourceArticleID' ) || '';

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check params
    if ( !$ArticleID || !$TicketID ) {
        $LogObject->Log(
            Message  => 'TicketID and ArticleID are needed!',
            Priority => 'error',
        );

        return $LayoutObject->ErrorScreen();
    }

    my $TicketNumber = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup(
        TicketID => $TicketID,
    );

    my $ArticleShowStatus = $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures')->ShowDeletedArticles(
        TicketID  => $TicketID,
        UserID    => $Self->{UserID},
        GetStatus => 1
    );

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID            => $TicketID,
        ArticleID           => $ArticleID,
        ShowDeletedArticles => $ArticleShowStatus ? 1 : 0,
        VersionView         => $VersionView
    );

    # Check permissions.
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID        => $TicketID,
        ArticleID       => $ArticleID,
        DynamicFields   => 0,
        UserID          => $Self->{UserID},
        VersionView     => $VersionView,
        SourceArticleID => $SourceArticleID
    );

    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID},
    );
    if ( !$Access ) {
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    $Param{DeletedVersionID} = $ArticleShowStatus ? $Article{DeletedVersionID} : 0;

    my $ArticleStorage = $ConfigObject->Get('Ticket::Article::Backend::MIMEBase::ArticleStorage');

    # Render article content.
    my $ArticleContent = $LayoutObject->ArticlePreview(
        TicketID            => $TicketID,
        ArticleID           => $ArticleID,
        ShowDeletedArticles => $ArticleShowStatus ? 1 : 0,
        VersionView         => $VersionView,
        DeletedVersionID    => $Param{DeletedVersionID},
        ArticleStorage      => $ArticleStorage,
        SourceArticleID     => $SourceArticleID
    );

    if ( !$ArticleContent ) {
        $LogObject->Log(
            Message  => 'No such article!',
            Priority => 'error',
        );

        return $LayoutObject->ErrorScreen();
    }

    my $Content = $LayoutObject->Output(
        Template => '[% Data.HTML %]',
        Data     => {
            HTML => $ArticleContent,
        },
    );

    my %Data = (
        Content            => $Content,
        ContentAlternative => '',
        ContentID          => '',
        ContentType        => 'text/html; charset="utf-8"',
        Disposition        => 'inline',
    );

    # set download type to inline
    $ConfigObject->Set(
        Key   => 'AttachmentDownloadType',
        Value => 'inline'
    );

    # set filename for inline viewing
    $Data{Filename} = "Ticket-$TicketNumber-ArticleID-$Article{ArticleID}.html";

    # generate base url
    my $URL;

    if ( !$VersionView && !$Param{DeletedVersionID} ) {
        $URL = 'Action=AgentTicketAttachment;Subaction=HTMLView'
            . ";TicketID=$TicketID;ArticleID=$ArticleID;FileID=";
    }
    elsif ( $VersionView && !$Param{DeletedVersionID} ) {
        $URL = 'Action=AgentTicketAttachment;Subaction=HTMLView'
            . ";TicketID=$TicketID;ArticleID=$ArticleID;VersionView=1;SourceArticleID=$SourceArticleID;FileID=";
    }
    else {
        $URL = 'Action=AgentTicketAttachment;Subaction=HTMLView'
            . ";TicketID=$TicketID;ArticleID=$ArticleID;VersionView=0;SourceArticleID=$Param{DeletedVersionID};ArticleDeleted=$Param{DeletedVersionID};FileID=";
    }

    # replace links to inline images in html content
    my %AtmBox;

    if ( !$Param{DeletedVersionID} ) {
        %AtmBox = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID       => $ArticleID,
            SourceArticleID => $SourceArticleID,
            VersionView     => $VersionView || ''
        );
    }
    else {
        %AtmBox = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID       => $ArticleID,
            SourceArticleID => $Param{DeletedVersionID},
            ArticleDeleted  => 1,
            VersionView     => 1
        );
    }

    # Do not load external images if 'BlockLoadingRemoteContent' is enabled.
    my $LoadExternalImages;
    if ( $ConfigObject->Get('Ticket::Frontend::BlockLoadingRemoteContent') ) {
        $LoadExternalImages = 0;
    }
    else {
        $LoadExternalImages = $ParamObject->GetParam(
            Param => 'LoadExternalImages'
        ) || 0;

        # Safety check only on customer article.
        if ( !$LoadExternalImages && $Article{SenderType} ne 'customer' ) {
            $LoadExternalImages = 1;
        }
    }

    # reformat rich text document to have correct charset and links to
    # inline documents
    %Data = $LayoutObject->RichTextDocumentServe(
        Data               => \%Data,
        URL                => $URL,
        Attachments        => \%AtmBox,
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
        $Article{Body} = $LayoutObject->Ascii2Html(
            NewLine        => $ConfigObject->Get('DefaultViewNewLine'),
            Text           => $Article{Body},
            VMax           => $ConfigObject->Get('DefaultViewLines') || 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );

        # use the article body as content, because pgp was definitly descrypted if possible
        $Data{Content} = $Article{Body};
    }

    # return html attachment
    return $LayoutObject->Attachment(
        %Data,
        Sandbox => 1,
    );
}

1;
