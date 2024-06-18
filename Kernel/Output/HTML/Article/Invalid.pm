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

package Kernel::Output::HTML::Article::Invalid;

use strict;
use warnings;

use parent 'Kernel::Output::HTML::Article::Base';

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Log',
    'Kernel::System::Ticket::Article',
);

=head2 ArticleFields()

Returns common article fields for an invalid article.

    my %ArticleFields = $LayoutObject->ArticleFields(
        TicketID  => 123,   # (required)
        ArticleID => 123,   # (required)
    );

Returns:

    %ArticleFields = (
        Sender => {                     # mandatory
            Label => 'Sender',
            Value => 'PackageName',
            Prio  => 100,
        },
        Subject => {                    # mandatory
            Label => 'Subject',
            Value => 'Invalid article',
            Prio  => 200,
        },
        ...
    );

=cut

sub ArticleFields {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Article = $ArticleBackendObject->ArticleGet(%Param);

    # Get communication channel data.
    my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
        ChannelID => $Article{CommunicationChannelID},
    );

    my %Result = (
        Sender => {
            Label    => 'Sender',
            Value    => '-',
            Realname => '-',
            Prio     => 100,
        },
        Subject => {
            Label => 'Subject',
            Value => '-',
            Prio  => 200,
        },
    );

    return %Result;
}

=head2 ArticlePreview()

Returns article preview for an invalid article.

    $LayoutObject->ArticlePreview(
        TicketID   => 123,     # (required)
        ArticleID  => 123,     # (required)
        ResultType => 'plain', # (optional) plain|HTML. Default HTML.
        MaxLength  => 50,      # (optional) performs trimming (for plain result only)
    );

Returns article preview in scalar form:

    $ArticlePreview = 'Preview of this article is not possible because...';

=cut

sub ArticlePreview {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( $Param{MaxLength} && !IsPositiveInteger( $Param{MaxLength} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'MaxLength must be positive integer!',
        );

        return;
    }

    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(%Param);

    my %Article = $ArticleBackendObject->ArticleGet(%Param);

    # Get communication channel data.
    my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
        ChannelID => $Article{CommunicationChannelID},
    );

    my $Result = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'ArticleContent/Invalid',
        Data         => \%CommunicationChannel,
    );

    if ( $Param{ResultType} && $Param{ResultType} eq 'plain' ) {
        $Result = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Result,
        );

        $Result =~ s{\n\s*\n}{\n}g;    # Remove extra new lines.
        $Result =~ s/[^\S\n]+/ /g;     # Remove extra spaces.

        # Trim to length.
        if ( $Param{MaxLength} ) {
            $Result = substr( $Result, 0, $Param{MaxLength} );
        }
    }

    return $Result;
}

=head2 ArticleCustomerRecipientsGet()

Dummy function. Invalid channel always returns no recipients.

=cut

sub ArticleCustomerRecipientsGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID ArticleID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return;
}

1;
