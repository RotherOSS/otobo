# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Output::HTML::TicketZoom::SimilarTickets;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent 'Kernel::Output::HTML::Base';

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    my %Ticket    = $Param{Ticket}->%*;
    my %AclAction = $Param{AclAction}->%*;
    my $TicketID  = $Ticket{TicketID};
    my $ArticleID;

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my @Articles      = $ArticleObject->ArticleList(
        TicketID  => $TicketID,
        OnlyFirst => 1,
    );
    if (@Articles) {
        $ArticleID = $Articles[0]{ArticleID};
    }
    return '' if !$ArticleID;

    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    return '' if !$Article{Subject} && !$Article{Body};

    my $MoreLikeThis = ( $Article{Subject} // '' ) . "\n" . ( $Article{Body} // '' );

    # set display options
    $Param{WidgetTitle} = Translatable('Similar Tickets');

    # get zoom settings depending on ticket type
    $Self->{DisplaySettings} = $ConfigObject->Get("Ticket::Frontend::AgentTicketZoom");

    my $SimilarSearchSettings = $ConfigObject->Get("Elasticsearch::Settings::SimilarSearch");

    my $ESObject = $Kernel::OM->Get('Kernel::System::Elasticsearch');
    my $Result   = $ESObject->TicketSearch(
        Result       => 'FULL',
        UserID       => $Self->{UserID},
        Permission   => 'ro',
        MoreLikeThis => $MoreLikeThis,

        # one more than requested as we might remove ourself
        Limit   => $SimilarSearchSettings->{Limit} + 1,
        SortBy  => 'Score',
        OrderBy => 'Down',
    );

    # remove self if amongst result
    my @Data = grep { !exists $_->{$TicketID} } $Result->{Data}->@*;

    # limit result to max setting
    while ( scalar @Data > $SimilarSearchSettings->{Limit} ) {
        pop @Data;
    }

    $LayoutObject->Block(
        Name => 'SimilarTickets',
        Data => \@Data,
    );

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentTicketZoom/SimilarTickets',
        Data         => { %Param, %Ticket, %AclAction },
    );

    return {
        Output => $Output,
    };
}

1;
