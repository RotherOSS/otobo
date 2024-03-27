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

package Kernel::Output::HTML::ArticleAction::AgentTicketArticleVersion;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Ticket::ArticleFeatures',
    'Kernel::System::User'
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub CheckAccess {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Ticket Article ChannelName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return if $Param{ChannelName} ne 'Internal';
    return if $Param{Article}->{IsVisibleForCustomer};
    return if $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::ArticleStorage') =~ m/ArticleStorageS3/;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my @MenuItems;
    my %ArticleVersions;
    my $Count = 1;

    my %ArticleVersionHistory = %{
        $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures')->VersionHistoryGet(
            ArticleID => $Param{Article}->{ArticleID},
            TicketID  => $Param{Ticket}->{TicketID},
        )
    };

    for my $Entry ( sort { $a <=> $b } keys %ArticleVersionHistory ) {
        my %VersionData = %{ $ArticleVersionHistory{$Entry} };

        my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID => $Param{UserID}
        );

        # create datetime object
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $VersionData{CreateTime}
            }
        );

        #Transform date to current user timezone
        if ( $User{UserTimeZone} ) {
            $DateTimeObject->ToTimeZone(
                TimeZone => $User{UserTimeZone}
            );
        }

        $ArticleVersions{$Entry} = $LayoutObject->{LanguageObject}->Translate('Version') . " $Count (" . $DateTimeObject->ToString() . " $VersionData{FullName})";
        $Count++;
    }

    if (%ArticleVersions) {
        my $ArticleVersionStrg = $LayoutObject->BuildSelection(
            Name         => 'ArticleVersion',
            ID           => 'ArticleVersion',
            Class        => 'Modernize',
            Data         => \%ArticleVersions,
            PossibleNone => 1,
            Sort         => 'NumericKey'
        );

        push @MenuItems, {
            ItemType           => 'Dropdown',
            DropdownType       => 'Version',
            ArticleVersionStrg => $ArticleVersionStrg,
            FormID             => 'Version' . $Param{Article}->{ArticleID},
            Class              => 'AsPopup PopupType_TicketAction',
            Action             => 'AgentTicketArticleEdit',
        };
    }

    return @MenuItems;
}

1;
