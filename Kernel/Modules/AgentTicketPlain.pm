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

package Kernel::Modules::AgentTicketPlain;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketID  = $Self->{TicketID};
    my $ArticleID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ArticleID' );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( !$ArticleID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No ArticleID!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $TicketID,
    );

    # check permissions
    my $Access = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPermission(
        Type     => 'ro',
        TicketID => $TicketID,
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission();
    }

    my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForArticle(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );
    if ( $ArticleBackendObject->ChannelNameGet() ne 'Email' ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('This is not an email article.'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleID,
    );

    my $Plain = $ArticleBackendObject->ArticlePlain(
        TicketID  => $TicketID,
        ArticleID => $ArticleID
    );
    if ( !$Plain ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable(
                'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.'
            ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # Download email.
    if ( $Self->{Subaction} eq 'Download' ) {
        my $Filename = "Ticket-$Ticket{TicketNumber}-TicketID-$TicketID-ArticleID-$ArticleID.eml";
        return $LayoutObject->Attachment(
            Filename    => $Filename,
            ContentType => 'message/rfc822',
            Content     => $Plain,
            Type        => 'attachment',
        );
    }

    # Show plain emails.
    $Plain = $LayoutObject->Ascii2Html(
        Text           => $Plain,
        HTMLResultMode => 1,
    );

    # Do some highlightings.
    $Plain
        =~ s/^((From|To|Cc|Bcc|Subject|Reply-To|Organization|X-Company|Content-Type|Content-Transfer-Encoding):.*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^(Date:.*)/<span class="Error">$1<\/span>/m;
    $Plain
        =~ s/^((X-Mailer|User-Agent|X-OS):.*(Mozilla|Win?|Outlook|Microsoft|Internet Mail Service).*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^((Resent-.*):.*)/<span class="Error">$1<\/span>/gmi;
    $Plain =~ s/^(From .*)/<span class="Error">$1<\/span>/gm;
    $Plain =~ s/^(X-OTOBO.*)/<span class="Error">$1<\/span>/gmi;

    my $Output = $LayoutObject->Header(
        Type => 'Small',
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentTicketPlain',
        Data         => {
            Text => $Plain,
            %Ticket,
            %Article,
        },
    );
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );
    return $Output;
}

1;
