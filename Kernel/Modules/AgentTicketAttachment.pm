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

package Kernel::Modules::AgentTicketAttachment;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Print)

use strict;
use warnings;
use v5.24;

# core modules

# CPAN modules

# OTOBO modules

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get IDs
    my $TicketID  = $ParamObject->GetParam( Param => 'TicketID' );
    my $ArticleID = $ParamObject->GetParam( Param => 'ArticleID' );
    my $FileID    = $ParamObject->GetParam( Param => 'FileID' );

    my $VersionView     = $ParamObject->GetParam( Param => 'VersionView' )     || '';
    my $SourceArticleID = $ParamObject->GetParam( Param => 'SourceArticleID' ) || '';
    my $ArticleDeleted  = $ParamObject->GetParam( Param => 'ArticleDeleted' )  || '';

    # check params
    if ( !$FileID || !$ArticleID || !$TicketID ) {
        $LogObject->Log(
            Message  => 'FileID, TicketID and ArticleID are needed!',
            Priority => 'error',
        );

        return $LayoutObject->ErrorScreen();
    }

    my $TicketNumber = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup(
        TicketID => $TicketID,
    );

    # get needed objects
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID            => $TicketID,
        ArticleID           => $ArticleID,
        ShowDeletedArticles => 1,
        VersionView         => $VersionView
    );

    # check permissions
    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID        => $TicketID,
        ArticleID       => $ArticleID,
        DynamicFields   => 0,
        VersionView     => $VersionView,
        SourceArticleID => $SourceArticleID,
    );

    my $ArticleBackendObjectDB;

    if ( $Article{ArticleDeleted} ) {
        $ArticleBackendObjectDB = Kernel::System::Ticket::Article::Backend::MIMEBase->new(
            ArticleStorageModule => "Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB",
        );
    }

    # check permissions
    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID},
    );
    if ( !$Access ) {
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # Check whether potentially the content should be converted for in browser viewing
    my $ViewerActive = $ParamObject->GetParam( Param => 'Viewer' ) || 0;

    # In most cases we can handle IO-Handle like objects as content.
    # But require a string when the content is possible transformed by a viewer.
    # TODO: check for output filter on AgentTicketAttachment or on ALL
    my $ContentMayBeFilehandle = $ViewerActive ? 0 : 1;

    my %Data;
    my $ArticleStorage = $ConfigObject->Get('Ticket::Article::Backend::MIMEBase::ArticleStorage');

    # get an attachment
    if ( !$Article{ArticleDeleted} || $ArticleStorage eq 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS' ) {
        %Data = $ArticleBackendObject->ArticleAttachment(
            ArticleID              => $ArticleID,
            VersionView            => $VersionView,
            SourceArticleID        => $SourceArticleID,
            FileID                 => $FileID,
            ContentMayBeFilehandle => $ContentMayBeFilehandle,
            ShowDeletedArticles    => 1,
            ArticleDeleted         => $Article{ArticleDeleted}
        );
    }
    else {
        # get an attachment
        %Data = $ArticleBackendObjectDB->ArticleAttachment(
            ArticleID              => $ArticleID,
            VersionView            => 1,
            SourceArticleID        => $SourceArticleID,
            FileID                 => $FileID,
            ContentMayBeFilehandle => $ContentMayBeFilehandle,
            ShowDeletedArticles    => 1,
            ArticleDeleted         => 1
        );
    }

    if ( !%Data ) {
        $LogObject->Log(
            Message  => "No such attachment ($FileID).",
            Priority => 'error',
        );

        return $LayoutObject->ErrorScreen();
    }

    # find viewer for ContentType
    my $Viewer;
    if ($ViewerActive) {
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        if ( $ConfigObject->Get('MIME-Viewer') ) {
            for ( sort keys $ConfigObject->Get('MIME-Viewer')->%* ) {
                if ( $Data{ContentType} =~ m/^$_/i ) {
                    $Viewer = $ConfigObject->Get('MIME-Viewer')->{$_};
                    $Viewer =~ s/\<OTOBO_CONFIG_(.+?)\>/$ConfigObject->{$1}/g;
                }
            }
        }
    }

    # show with viewer
    if ($Viewer) {

        # Write temporary file for the HTML generating command.
        # The file will be cleaned up at the end of the current request.
        my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');
        my ( $FHContent, $FilenameContent ) = $FileTempObject->TempFile();
        print $FHContent $Data{Content};
        close $FHContent;

        # generate HTML
        # TODO: use Capture::Tiny
        my $GeneratedHTML = '';
        if ( open my $ViewerFH, '-|', "$Viewer $FilenameContent" ) {    ## no critic qw(OTOBO::ProhibitOpen)
            while (<$ViewerFH>) {
                $GeneratedHTML .= $_;
            }
            close $ViewerFH;
        }
        else {
            return $LayoutObject->FatalError(
                Message => "Can't open: $Viewer $FilenameContent: $!",
            );
        }

        # return the generated HTML
        return $LayoutObject->Attachment(
            %Data,
            ContentType => 'text/html',
            Content     => $GeneratedHTML,
            Type        => 'inline',
            Sandbox     => 1,
        );
    }

    # download it AttachmentDownloadType is configured
    return $LayoutObject->Attachment(
        %Data,
        Sandbox => 1,
    );
}

1;
