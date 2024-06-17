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

package Kernel::System::Console::Command::Maint::Ticket::Dump;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Print a ticket and its articles to the console.');
    $Self->AddOption(
        Name        => 'article-limit',
        Description => "Maximum number of articles to print.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\d+/smx,
    );
    $Self->AddArgument(
        Name        => 'ticket-id',
        Description => "ID of the ticket to be printed.",
        Required    => 1,
        ValueRegex  => qr/\d+/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID      => $Self->GetArgument('ticket-id'),
        DynamicFields => 0,
    );

    if ( !%Ticket ) {
        $Self->PrintError("Could not find ticket.");
        return $Self->ExitCodeError();
    }

    $Self->Print( "<green>" . ( '=' x 69 ) . "</green>\n" );

    KEY:
    for my $Key (qw(TicketNumber TicketID Title Created Queue State Priority Lock CustomerID CustomerUserID)) {
        next KEY if !$Ticket{$Key};
        $Self->Print( sprintf( "<yellow>%-20s</yellow> %s\n", "$Key:", $Ticket{$Key} ) );
    }

    $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # get article index
    my @MetaArticles = $ArticleObject->ArticleList(
        TicketID => $Self->GetArgument('ticket-id'),
    );

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Layout' => {
            UserID => 1,
        },
    );
    ## nofilter(TidyAll::Plugin::OTOBO::Perl::LayoutObject)
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Counter      = 1;
    my $ArticleLimit = $Self->GetOption('article-limit');
    META_ARTICLE:
    for my $MetaArticle (@MetaArticles) {

        last META_ARTICLE if defined $ArticleLimit && $ArticleLimit < $Counter;

        # get article data
        my %Article = $ArticleObject->BackendForArticle( %{$MetaArticle} )->ArticleGet(
            %{$MetaArticle},
            DynamicFields => 0,
        );

        next META_ARTICLE if !%Article;

        my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
            ChannelID => $Article{CommunicationChannelID},
        );
        $Article{Channel} = $CommunicationChannel{ChannelName};

        KEY:
        for my $Key (qw(ArticleID CreateTime SenderType Channel)) {
            next KEY if !$Article{$Key};
            $Self->Print( sprintf( "<yellow>%-20s</yellow> %s\n", "$Key:", $Article{$Key} ) );
        }

        my %ArticleFields = $LayoutObject->ArticleFields(%Article);

        for my $ArticleFieldKey (
            sort { $ArticleFields{$a}->{Prio} <=> $ArticleFields{$b}->{Prio} }
            keys %ArticleFields
            )
        {
            my %ArticleField = %{ $ArticleFields{$ArticleFieldKey} // {} };
            $Self->Print( sprintf( "<yellow>%-20s</yellow> %s\n", "$ArticleField{Label}:", $ArticleField{Value} ) );
        }

        $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );

        my $ArticlePreview = $LayoutObject->ArticlePreview(
            %Article,
            ResultType => 'plain',
        );
        $Self->Print("$ArticlePreview\n");

        $Self->Print( "<green>" . ( '-' x 69 ) . "</green>\n" );
    }
    continue {
        $Counter++;
    }

    return $Self->ExitCodeOk();
}

1;
