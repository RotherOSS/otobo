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

package Kernel::Modules::AgentTicketArticleEdit;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

use parent qw( Kernel::Modules::AgentTicketActionCommon );

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::Output::HTML::Layout
    Kernel::System::Log
    Kernel::System::Ticket
    Kernel::System::Ticket::Article
    Kernel::System::Ticket::ArticleFeatures
    Kernel::System::Web::Request
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # set ArticleEdit specific params
    $Self->{ArticleID} = $ParamObject->GetParam( Param => 'ArticleID' );

    if ( !$Self->{ArticleID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ArticleID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config       = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # prevent shenanigans
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
        TicketID            => $Self->{TicketID},
        ArticleID           => $Self->{ArticleID},
        ShowDeletedArticles => 1,
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $Self->{TicketID},
        ArticleID => $Self->{ArticleID},
    );

    # show "no permission" error screen to give minimal info if TicketID and ArticleID do not match
    if ( !%Article ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
            WithHeader => 'yes',
        );
    }

    # check whether this article type is eligible for changing
    my $ChannelName    = $ArticleBackendObject->ChannelNameGet();
    my $ArticleActions = $ConfigObject->Get("Ticket::Frontend::Article::Actions")->{$ChannelName};

    if ( $Self->{Subaction} eq 'ArticleDelete' ) {
        if ( !$ArticleActions->{'AgentTicketArticleDelete'} ) {
            return $LayoutObject->NoPermission(
                Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
                WithHeader => 'yes',
            );
        }

        return $Self->_ArticleDeletion(
            %Param,
            Config => $Config,
        );
    }

    elsif ( $Self->{Subaction} eq 'ArticleRestore' ) {
        if ( !$ArticleActions->{'AgentTicketArticleRestore'} ) {
            return $LayoutObject->NoPermission(
                Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
                WithHeader => 'yes',
            );
        }

        return $Self->_ArticleDeletion(
            %Param,
            Config  => $Config,
            Restore => 1,
        );
    }

    # else we are in normal edit mode
    elsif ( !$ArticleActions->{'AgentTicketArticleEdit'} ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
            WithHeader => 'yes',
        );
    }

    return $Self->SUPER::Run(%Param);
}

sub _ArticleDeletion {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => $Param{Config}{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Param{Config}{Permission} ),
            WithHeader => 'yes',
        );
    }

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ($ACL) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    $LayoutObject->ChallengeTokenCheck();

    my $Success;
    if ( $Param{Restore} ) {

        $Success = $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures')->ArticleRestore(
            ArticleID => $Self->{ArticleID},
            TicketID  => $Self->{TicketID},
            UserID    => $Self->{UserID},
            UserLogin => $Self->{UserLogin}
        );

        if (!$Success) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Error trying to restore article id: ' . $Self->{ArticleID}
            );
        }
    }

    else {

        $Success = $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures')->ArticleDelete(
            ArticleID => $Self->{ArticleID},
            TicketID  => $Self->{TicketID},
            UserID    => $Self->{UserID},
            UserLogin => $Self->{UserLogin}
        );

        if (!$Success) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Error trying to delete article id: ' . $Self->{ArticleID}
            );

            $TicketObject->_TicketCacheClear( TicketID => $Self->{TicketID} );
        }
    }

    # build JSON output
    my $JSON = $LayoutObject->JSONEncode(
        Data => {
            Success => $Success
        },
    );

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

1;
