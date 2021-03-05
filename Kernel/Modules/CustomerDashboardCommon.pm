# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Modules::CustomerDashboardCommon;
## nofilter(TidyAll::Plugin::OTOBO::Perl::DBObject)

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

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

    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # the tiles used on the dashboard
    my $UsedTiles = $ConfigObject->Get('CustomerDashboard::Tiles');

    my $Output = $LayoutObject->CustomerHeader();

    my $TileHTML;

    # generate the html of the individual tiles
    my %OrderUsed;
    for my $Tile ( sort { $UsedTiles->{$a}{Order} <=> $UsedTiles->{$b}{Order} } keys %{$UsedTiles} ) {

        # check if the registration for each tile is valid
        if ( !$UsedTiles->{$Tile}{Module} ) {
            if ( !$UsedTiles->{$Tile}{Template} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "Registration for tile $Tile of CustomerDashboard is invalid! Either Module or Template needed.",
                );
                return;
            }

            $UsedTiles->{$Tile}{Module} = "Kernel::Output::HTML::CustomerDashboard::TileCommon";
        }

        # set the backend file
        my $BackendModule = $UsedTiles->{$Tile}{Module};

        # check if backend field exists
        if ( !$MainObject->Require($BackendModule) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't load the module for tile $Tile!",
            );
            return;
        }

        # create a backend object
        my $BackendObject = $BackendModule->new();

        # check if the Order is an unique number
        my $TileID = sprintf( "%02d", $UsedTiles->{$Tile}{Order} );
        if ( $TileID !~ /^\d+$/ || ++$OrderUsed{$TileID} > 1 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Registration for tile $Tile of CustomerDashboard is invalid! Order needs to be a unique number.",
            );
            return;
        }

        # get the HTML
        $TileHTML .= $BackendObject->Run(
            TileID   => $TileID,
            Template => $UsedTiles->{$Tile}{Template} || '',
            Config   => $UsedTiles->{$Tile}{Config}   || {},
            UserID   => $Self->{UserID},
        );
    }

    # get the real name
    my $HeaderText = $ConfigObject->Get('CustomerDashboard::Configuration::Text');
    for my $Subst (qw/UserTitle UserFirstname UserLastname UserEmail UserLogin/) {
        my $Value = $Self->{$Subst} || '';
        $HeaderText->{Name} =~ s/$Subst/$Value/g;
    }

    # AddJSData for ES
    my $ESActive = $ConfigObject->Get('Elasticsearch::Active');

    $LayoutObject->AddJSData(
        Key   => 'ESActive',
        Value => $ESActive,
    );

    my $NewTicketAccessKey = $ConfigObject->Get('CustomerFrontend::Navigation')->{'CustomerTicketMessage'}{'002-Ticket'}[0]{'AccessKey'}
        || '';

    $Output .= $LayoutObject->Output(
        TemplateFile => 'CustomerDashboard',
        Data         => {
            WelcomeText => $HeaderText->{WelcomeText},
            Name        => $HeaderText->{Name},
            SubText     => $HeaderText->{SubText},
            AccessKey   => $NewTicketAccessKey,
            TileHTML    => $TileHTML,
        },
    );
    $Output .= $LayoutObject->CustomerNavigationBar();
    $Output .= $LayoutObject->CustomerFooter();

    return $Output;

}

1;
