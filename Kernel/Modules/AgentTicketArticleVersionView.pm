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

package Kernel::Modules::AgentTicketArticleVersionView;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

    my %GetParam;

    for my $Needed (qw(TicketID ArticleID SourceArticleID VersionID)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed ) || '';

        # Check needed stuff.
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable("Need $Needed!"),
            );
        }
    }

    # Check permissions.
    my $Access = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $GetParam{TicketID},
        UserID   => $Self->{UserID},
    );

    # No permission, do not show ticket.
    return $LayoutObject->NoPermission( WithHeader => 'yes' ) if !$Access;

    # Get ACL restrictions.
    my %PossibleActions = (
        1 => $Self->{Action},
    );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $GetParam{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # Check if ACL restrictions exist.
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # Show error screen if ACL prohibits this action.
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $GetParam{TicketID},
        DynamicFields => 1,
        UserID        => $Self->{UserID}
    );

    # generate output
    my $Output = $LayoutObject->Header(
        Value    => $Ticket{TicketNumber},
        TicketID => $Ticket{TicketID},
        Type     => 'Small'
    );

    # show right header
    $LayoutObject->Block(
        Name => 'Header' . $Self->{Action},
        Data => {
            %Ticket,
        },
    );

    my %UserPreferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( !defined $Self->{DoNotShowBrowserLinkMessage} ) {
        if ( $UserPreferences{UserAgentDoNotShowBrowserLinkMessage} ) {
            $Self->{DoNotShowBrowserLinkMessage} = 1;
        }
        else {
            $Self->{DoNotShowBrowserLinkMessage} = 0;
        }
    }

    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        TicketID            => $GetParam{TicketID},
        ArticleID           => $GetParam{SourceArticleID},
        ShowDeletedArticles => 1
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID            => $GetParam{TicketID},
        ArticleID           => $GetParam{ArticleID},
        RealNames           => 1,
        DynamicFields       => 0,
        UserID              => $Self->{UserID},
        ShowDeletedArticles => 1,
        VersionView         => 1
    );

    my %SourceArticle = $ArticleBackendObject->ArticleGet(
        TicketID      => $GetParam{TicketID},
        ArticleID     => $GetParam{SourceArticleID},
        RealNames     => 1,
        DynamicFields => 0,
        UserID        => $Self->{UserID}
    );

    # show article actions
    my @MenuItems;

    $GetParam{ArticleHTML} = $Self->_ArticleRender(
        TicketID               => $GetParam{TicketID},
        ArticleID              => $GetParam{ArticleID},
        VersionID              => $GetParam{VersionID},
        SourceArticleID        => $GetParam{SourceArticleID},
        UserID                 => $Self->{UserID},
        ShowBrowserLinkMessage => $Self->{DoNotShowBrowserLinkMessage} ? 0 : 1,
        Type                   => 'OnLoad',
        MenuItems              => \@MenuItems,
        ShowDeletedArticles    => 1,
        VersionView            => 1
    );

    $LayoutObject->Block(
        Name => 'Properties',
        Data => {
            ArticleID            => $GetParam{ArticleID},
            ArticleSubject       => $Article{Subject},
            VersionID            => $GetParam{VersionID},
            SourceArticleSubject => $SourceArticle{Subject},
            SourceArticleNumber  => $SourceArticle{ArticleNumber},
            %GetParam
        }
    );

    $LayoutObject->Block(
        Name => 'TicketBack',
        Data => {
            %Param,
            %Ticket,
        }
    );

    # return output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentTicketArticleVersionView',
        Data         => {},
    );

    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );

    return $Output;

}

sub _ArticleRender {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(TicketID ArticleID Type)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Get article data.
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    # Determine channel name for this Article.
    my $ChannelName = $ArticleBackendObject->ChannelNameGet();

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        "Kernel::Output::HTML::TicketZoom::Agent::$ChannelName",
    );
    return if !$Loaded;

    return $Kernel::OM->Get("Kernel::Output::HTML::TicketZoom::Agent::$ChannelName")->ArticleRender(
        %Param,
        ArticleActions => $Param{MenuItems},
        UserID         => 1
    );
}

1;
