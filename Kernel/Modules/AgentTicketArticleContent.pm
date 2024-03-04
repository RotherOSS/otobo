# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
    my $TicketID  = $ParamObject->GetParam( Param => 'TicketID' );
    my $ArticleID = $ParamObject->GetParam( Param => 'ArticleID' );

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

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

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    # Check permissions.
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );

    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID},
    );
    if ( !$Access ) {
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # Render article content.
    my $ArticleContent = $LayoutObject->ArticlePreview(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # set download type to inline
    $ConfigObject->Set(
        Key   => 'AttachmentDownloadType',
        Value => 'inline'
    );

    # set filename for inline viewing
    $Data{Filename} = "Ticket-$TicketNumber-ArticleID-$Article{ArticleID}.html";

    # generate base url
    my $URL = 'Action=AgentTicketAttachment;Subaction=HTMLView'
        . ";TicketID=$TicketID;ArticleID=$ArticleID;FileID=";

    # replace links to inline images in html content
    my %AtmBox = $ArticleBackendObject->ArticleAttachmentIndex(
        ArticleID => $ArticleID,
    );

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
