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

package Kernel::Modules::CustomerDashboardContent;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject                    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerDashboardInfoTileObject = $Kernel::OM->Get('Kernel::System::CustomerDashboard::InfoTile');
    my $HTMLUtilsObject                 = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    if ( $Self->{Subaction} eq 'InfoTile' ) {

        my $InfoTileContent = '';
        my $InfoTiles       = $CustomerDashboardInfoTileObject->InfoTileListGet(
            UserID => $Self->{UserID},
        );

        if ( IsHashRefWithData($InfoTiles) ) {

            # sort info tiles, sorting order: config order, start date, changed date, created date
            my @Tiles       = values %{$InfoTiles};
            my @TilesSorted = $Self->_OrderTiles( Tiles => \@Tiles );

            my $CurrentDate = $Kernel::OM->Create('Kernel::System::DateTime');

            ENTRY:
            for my $InfoTileRef (@TilesSorted) {
                my %InfoTile = %{$InfoTileRef};

                next ENTRY if $InfoTile{ValidID} ne 1;

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
                    ( !$StartDate || $CurrentDate->Compare( DateTimeObject => $StartDate ) > 0 )
                    && ( !$StopDate || $StopDate->Compare( DateTimeObject => $CurrentDate ) > 0 )
                    )
                {
                    if ($InfoTileContent) {
                        $InfoTileContent .= '<br><br>';
                    }

                    $InfoTileContent .= $InfoTile{Content};
                }
            }
        }

        my $Content = $HTMLUtilsObject->DocumentComplete(
            String            => $InfoTileContent,
            CustomerInterface => 1,
        );

        return $LayoutObject->Attachment(
            Type        => 'inline',
            ContentType => 'text/html',
            Content     => $Content,
        );
    }
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
