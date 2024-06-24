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

package Kernel::Modules::AgentTicketPrint;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Check needed stuff.
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need TicketID!'),
        );
    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Check permissions.
    my $Access = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
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
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # Check if ACL restrictions exist.
    if ($ACL) {

        my %AclActionLookup = reverse %AclAction;

        # Show error screen if ACL prohibits this action.
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    # Get content.
    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );

    # Assemble file name.
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

    if ( $Self->{UserTimeZone} ) {
        $DateTimeObject->ToTimeZone( TimeZone => $Self->{UserTimeZone} );
    }
    my $Filename = 'Ticket_' . $Ticket{TicketNumber} . '_';
    $Filename .= $DateTimeObject->Format( Format => '%Y-%m-%d_%H:%M' );
    $Filename .= '.pdf';

    my $CleanedFilename = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
        Filename => $Filename,
        Type     => 'Attachment',
    );

    # Return the PDF document.
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $PDFString   = $Kernel::OM->Get('Kernel::Output::PDF::Ticket')->GeneratePDF(
        TicketID      => $Self->{TicketID},
        UserID        => $Self->{UserID},
        ArticleID     => $ParamObject->GetParam( Param => 'ArticleID' ),
        ArticleNumber => $ParamObject->GetParam( Param => 'ArticleNumber' ),
        Interface     => 'Agent',
    );

    return $LayoutObject->Attachment(
        Filename    => $CleanedFilename,
        ContentType => "application/pdf",
        Content     => $PDFString,
        Type        => 'inline',
    );
}

1;
