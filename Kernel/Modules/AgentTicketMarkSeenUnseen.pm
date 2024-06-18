# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2023 Znuny GmbH, http://znuny.com/
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

package Kernel::Modules::AgentTicketMarkSeenUnseen;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Ticket',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

    my %GetParam;
    for my $Param (qw(TicketID ArticleID Subaction)) {
        $GetParam{$Param} = $ParamObject->GetParam( Param => $Param );
    }

    for my $RequiredParam (qw(TicketID Subaction)) {
        if ( !$GetParam{$RequiredParam} ) {
            $LayoutObject->FatalError(
                Message => "Need $RequiredParam!",
            );
        }
    }

    if ( !scalar grep { $GetParam{Subaction} eq $_ } qw( Seen Unseen ) ) {
        $LayoutObject->FatalError(
            Message => "Invalid value '$GetParam{Subaction}' for parameter 'Subaction'!",
        );
    }

    my @Articles = $ArticleObject->ArticleList(
        TicketID => $GetParam{TicketID},
    );

    my @ArticleIDs;
    if (@Articles) {
        @ArticleIDs = map { $_->{ArticleID} } @Articles;
    }

    if ( $GetParam{ArticleID} ) {
        if ( !scalar grep { $GetParam{ArticleID} eq $_ } @ArticleIDs ) {

            $LayoutObject->FatalError(
                Message => "Can't find ArticleID '$GetParam{ArticleID}' of ticket with TicketID '$GetParam{TicketID}'!",
            );
        }

        # reverse the ArticleIDs to get the correct index for the redirect URL
        @ArticleIDs = reverse @ArticleIDs;

        # remember article index for later replacement in redirect URL
        ( $GetParam{ArticleIndex} ) = grep { $ArticleIDs[$_] eq $GetParam{ArticleID} } 0 .. $#ArticleIDs;

        @ArticleIDs = ( $GetParam{ArticleID} );
    }

    # determine required function for subaction
    my $TicketActionFunction  = 'TicketFlagDelete';
    my $ArticleActionFunction = 'ArticleFlagDelete';

    if ( $GetParam{Subaction} eq 'Seen' ) {
        $TicketActionFunction  = 'TicketFlagSet';
        $ArticleActionFunction = 'ArticleFlagSet';
    }

    # perform action
    ARTICLE:
    for my $ArticleID ( sort @ArticleIDs ) {

        # article flag
        my $Success = $ArticleObject->$ArticleActionFunction(
            TicketID  => $GetParam{TicketID},
            ArticleID => $ArticleID,
            Key       => 'Seen',
            Value     => 1,                     # irrelevant in case of delete
            UserID    => $Self->{UserID},
        );

        next ARTICLE if $Success;

        $LayoutObject->FatalError(
            Message => "Error while setting article with ArticleID '$ArticleID' " .
                "of ticket with TicketID '$GetParam{TicketID}' as " .
                ( lc $GetParam{Subaction} ) .
                "!",
        );
    }

    # ticket flag
    my $Success = $TicketObject->$TicketActionFunction(
        TicketID => $GetParam{TicketID},
        Key      => 'Seen',
        Value    => 1,                     # irrelevant in case of delete
        UserID   => $Self->{UserID},
    );

    if ( !$Success ) {
        $LayoutObject->FatalError(
            Message => "Error while setting ticket with " .
                "TicketID '$GetParam{TicketID}' as " .
                ( lc $GetParam{Subaction} ) .
                "!",
        );
    }

    # get back to our last search result if the request came from a search view
    if ( $ParamObject->GetParam( Param => 'RedirectToSearch' ) ) {
        return $LayoutObject->Redirect(
            OP => 'Action=AgentTicketSearch;Subaction=Search;Profile=last-search;TakeLastSearch=1;',
        );
    }

    my %UserPreferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $RedirectURL = $UserPreferences{ 'UserMarkTicket' . $GetParam{Subaction} . 'RedirectURL' };
    $RedirectURL ||= $ConfigObject->Get( 'MarkTicket' . $GetParam{Subaction} . 'RedirectDefaultURL' );
    $RedirectURL ||= 'Action=AgentTicketZoom;TicketID=###TicketID###';

    REPLACE:
    for my $ReplaceParam (qw(TicketID ArticleID ArticleIndex)) {

        # make sure the placeholder gets replaced
        $GetParam{$ReplaceParam} ||= '';

        $RedirectURL =~ s{###$ReplaceParam###}{$GetParam{$ReplaceParam}}g;
    }

    return $LayoutObject->Redirect(
        OP => $RedirectURL,
    );
}

1;
