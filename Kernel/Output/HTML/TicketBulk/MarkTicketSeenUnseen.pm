# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Output::HTML::TicketBulk::MarkTicketSeenUnseen;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

=head1 NAME

Kernel::Output::HTML::TicketBulk::MarkTicketSeenUnseen - ticket bulk module to mark tickets as seen or unseen via bulk action

=head1 DESCRIPTION

Ticket bulk module MarkTicketSeenUnseen.

=head1 PUBLIC INTERFACE

=head2 new()

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {%Param}, $Type;
    return $Self;
}

=head2 Display()

Generates the required HTML to display new fields in ticket bulk screen. It requires to get the value from the web request (e.g. in case of an error to re-display the field content).

    my $ModuleContent = $ModuleObject->Display(
        Errors       => $ErrorsHashRef,             # created in ticket bulk and updated by Validate()
        UserID       => $123,
    );

Returns:

    $ModuleContent = $HMLContent;                   # HTML content of the field

Override this method in your modules.

=cut

sub Display {
    my ( $Self, %Param ) = @_;

    my %ParamLabel = (
        MarkTicketsAsSeen   => "Mark tickets as seen",
        MarkTicketsAsUnseen => "Mark tickets as unseen",
    );

    my $HTML;

    PARAM:
    for my $CurrentParam (qw( MarkTicketsAsSeen MarkTicketsAsUnseen )) {

        my $CurrentParamValue = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $CurrentParam );

        my $SelectHTML = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
            Class => 'Modernize W50pc',
            Data  => {
                0 => Translatable('No'),
                1 => Translatable('Yes'),
            },
            Name       => $CurrentParam,
            SelectedID => $CurrentParamValue || 0,
        );

        my $CurrentParamTranslation = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}
            ->Translate( $ParamLabel{$CurrentParam} );
        $HTML .= <<"HTML";
                        <label for="$CurrentParam">$CurrentParamTranslation:</label>
                        <div class="Field">
                        $SelectHTML
                        </div>
                        <div class="Clear"></div>
HTML
    }

    return $HTML;
}

=head2 Store()

Stores the values of the ticket bulk module. It requires to get the values from the web request.

    my @Success = $ModuleObject->Store(
        TicketID => 123,
        UserID   => 123,
    );

Returns:

    $Success = 1,       # or false in case of an error;

Override this method in your modules.

=cut

sub Store {
    my ( $Self, %Param ) = @_;

    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %ParamFlagMapping = (
        MarkTicketsAsSeen   => 'Seen',
        MarkTicketsAsUnseen => 'Unseen',
    );

    my @TicketIDs;
    PARAM:
    for my $CurrentParam (qw(MarkTicketsAsUnseen MarkTicketsAsSeen)) {

        next PARAM if !$ParamObject->GetParam( Param => $CurrentParam );

        # determine required function for subaction
        my $TicketActionFunction  = 'TicketFlagDelete';
        my $ArticleActionFunction = 'ArticleFlagDelete';

        if ( $CurrentParam eq 'MarkTicketsAsSeen' ) {
            $TicketActionFunction  = 'TicketFlagSet';
            $ArticleActionFunction = 'ArticleFlagSet';
        }

        # get involved tickets if not present, filtering empty TicketIDs
        if ( !@TicketIDs ) {
            @TicketIDs = grep {$_}
                $ParamObject->GetArray( Param => 'TicketID' );
        }

        # end loop if no ticket should get edited (?!)
        last PARAM if !scalar @TicketIDs;

        TICKET:
        for my $TicketID ( sort @TicketIDs ) {

            my @Articles = $ArticleObject->ArticleList(
                TicketID => $TicketID,
            );
            my @ArticleIDs = map { $_->{ArticleID} } @Articles;

            ARTICLE:
            for my $ArticleID ( sort @ArticleIDs ) {

                # article flag
                my $Success = $ArticleObject->$ArticleActionFunction(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    Key       => 'Seen',
                    Value     => 1,                # irrelevant in case of delete
                    UserID    => $Param{UserID},
                );

                next ARTICLE if $Success;

                $LayoutObject->FatalError(
                    Message => "Error while setting article with ArticleID '$ArticleID' " .
                        "of ticket with TicketID '$TicketID' as " .
                        ( lc $ParamFlagMapping{$CurrentParam} ) .
                        "!",
                );
            }

            # ticket flag
            my $Success = $TicketObject->$TicketActionFunction(
                TicketID => $TicketID,
                Key      => 'Seen',
                Value    => 1,                # irrelevant in case of delete
                UserID   => $Param{UserID},
            );

            if ( !$Success ) {
                $LayoutObject->FatalError(
                    Message => "Error while setting ticket with TicketID '$TicketID' as " .
                        ( lc $ParamFlagMapping{$CurrentParam} ) .
                        "!",
                );
            }
        }

        # only one action is logical
        last PARAM;
    }

    return;
}

1;
