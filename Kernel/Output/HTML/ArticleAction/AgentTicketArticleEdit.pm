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

package Kernel::Output::HTML::ArticleAction::AgentTicketArticleEdit;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

# optional AclActionLookup
sub CheckAccess {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return if $Param{ChannelName} ne 'Internal';
    return if $Param{Article}->{IsVisibleForCustomer};
    return if $ConfigObject->Get('Ticket::Article::Backend::MIMEBase::ArticleStorage') =~ m/ArticleStorageS3/;

    # check if module is registered
    return if !$ConfigObject->Get('Frontend::Module')->{AgentTicketArticleEdit};

    # check Acl
    return if !$Param{AclActionLookup}->{AgentTicketArticleEdit};

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketArticleEdit');
    if ( $Config->{Permission} ) {
        my $Ok = $TicketObject->TicketPermission(
            Type     => $Config->{Permission},
            TicketID => $Param{Ticket}->{TicketID},
            UserID   => $Param{UserID},
            LogNo    => 1,
        );
        return if !$Ok;
    }
    if ( $Config->{RequiredLock} ) {
        my $Locked = $TicketObject->TicketLockGet(
            TicketID => $Param{Ticket}->{TicketID}
        );
        if ($Locked) {
            my $AccessOk = $TicketObject->OwnerCheck(
                TicketID => $Param{Ticket}->{TicketID},
                OwnerID  => $Param{UserID},
            );
            return if !$AccessOk;
        }
    }

    return 1;
}

sub GetConfig {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Ticket Article UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return if $Param{Article}->{DeletedVersionID};

    my %MenuItem = (
        ItemType    => 'Link',
        Description => Translatable('Edit this article'),
        Name        => Translatable('Edit'),
        Class       => 'AsPopup PopupType_TicketAction',
        Link        =>
            "Action=AgentTicketArticleEdit;TicketID=$Param{Ticket}->{TicketID};ArticleID=$Param{Article}->{ArticleID}",
    );

    return ( \%MenuItem );
}

1;
