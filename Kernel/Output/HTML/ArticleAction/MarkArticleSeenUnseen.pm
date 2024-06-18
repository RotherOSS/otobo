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

package Kernel::Output::HTML::ArticleAction::MarkArticleSeenUnseen;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub CheckAccess {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # Check needed stuff.
    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return if !$ConfigObject->Get('Frontend::Module')->{AgentTicketMarkSeenUnseen};

    my $TicketPermission = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $Param{Ticket}->{TicketID},
        UserID   => $Param{UserID},
        LogNo    => 1,
    );
    return if !$TicketPermission;

    return 1;
}

sub GetConfig {
    my ( $Self, %Param ) = @_;

    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    for my $Needed (qw(Ticket Article UserID)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %MenuItem = (
        ItemType    => 'Link',
        Description => Translatable('Mark article as unseen'),
        Name        => Translatable('Mark as unseen'),
        Class       => 'AgentTicketMarkSeenUnseenArticle',
        Link        =>
            "Action=AgentTicketMarkSeenUnseen;Subaction=Unseen;TicketID=$Param{Ticket}->{TicketID};ArticleID=$Param{Article}->{ArticleID}",
    );

    return ( \%MenuItem );
}

1;
