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

package Kernel::Output::HTML::Notification::CustomerAnnouncementCheck;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerDashboard::InfoTile',
    'Kernel::System::HTMLUtils',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject                    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerDashboardInfoTileObject = $Kernel::OM->Get('Kernel::System::CustomerDashboard::InfoTile');
    my $HTMLUtilsObject                 = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    my $Segregation    = $Param{Config}{Segregation} || '###';
    my $MarqueeContent = '';
    my $InfoTiles      = $CustomerDashboardInfoTileObject->InfoTileListGet(
        UserID => $Self->{UserID},
    );

    # Check if hash ref is defined
    if ( IsHashRefWithData($InfoTiles) ) {

        # sort info tiles, sorting order: config order, start date, changed date, created date
        my @Tiles       = values %{$InfoTiles};
        my @TilesSorted = $Self->_OrderTiles( Tiles => \@Tiles );

        my $CurrentDate = $Kernel::OM->Create('Kernel::System::DateTime');

        for my $InfoTileRef (@TilesSorted) {
            my %InfoTile = %{$InfoTileRef};
            my $StartDate;
            if ( $InfoTile{StartDateUsed} ) {
                $StartDate = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $InfoTile{StartDate}
                    }
                );
            }
            my $StopDate;
            if ( $InfoTile{StopDateUsed} ) {
                $StopDate = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $InfoTile{StopDate}
                    }
                );
            }

            if (
                ( ( $StartDate && $CurrentDate->Compare( DateTimeObject => $StartDate ) > 0 ) || !$StartDate )
                && ( ( $StopDate && $StopDate->Compare( DateTimeObject => $CurrentDate ) > 0 ) || !$StopDate )
                && $InfoTile{ValidID} eq '1'
                )
            {

                if ($MarqueeContent) {
                    $MarqueeContent .= ' ' . $Segregation . ' ' . $InfoTile{MarqueeContent};
                }
                else {
                    $MarqueeContent = $InfoTile{MarqueeContent};
                }
            }
        }
    }

    if ($MarqueeContent) {
        my $Content = $HTMLUtilsObject->DocumentComplete(
            String            => $MarqueeContent,
            CustomerInterface => 1,
        );

        return $LayoutObject->Notify(
            Priority  => $Param{Config}{NotifyPriority},
            Data      => $Content,
            Link      => $Param{Config}{UseMarquee} ? '#' : '',    # Workaround to use classes.
            LinkClass => 'oooMarquee'
        );
    }

    return '';
}

sub _OrderTiles {
    my ( $Self, %Param ) = @_;

    my @Tiles        = @{ $Param{Tiles} };
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $UsedTiles  = $ConfigObject->Get('CustomerDashboard::Tiles');
    my $TileConfig = $UsedTiles->{'InfoTile-01'}{Config};

    return () unless IsHashRefWithData($TileConfig);

    my %TileEntryOrder = %{ $TileConfig->{Order} };
    my @Result;
    my @DateSort;

    if (%TileEntryOrder) {
        for my $TileRef (@Tiles) {
            my %Tile = %{$TileRef};
            if ( $TileEntryOrder{ $Tile{Name} } ) {
                $Tile{Order} = $TileEntryOrder{ $Tile{Name} };
                push @Result, \%Tile;
            }
            else {
                push @DateSort, \%Tile;
            }
        }
    }
    else {
        @DateSort = @Tiles;
    }

    @Result   = sort { $a->{Order} cmp $b->{Order} } @Result;
    @DateSort = sort { $b->{StartDate} cmp $a->{StartDate} || $b->{Changed} cmp $a->{Changed} || $b->{Created} cmp $a->{Created} } @DateSort;

    push @Result, @DateSort;

    return @Result;

}

1;
