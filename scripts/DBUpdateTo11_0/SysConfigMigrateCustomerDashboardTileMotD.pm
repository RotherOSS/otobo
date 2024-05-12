# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package scripts::DBUpdateTo11_0::SysConfigMigrateCustomerDashboardTileMotD;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_0::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::Config',
    'Kernel::System::CustomerDashboard::InfoTile',
    'Kernel::System::Package',
);

=head1 NAME

scripts::DBUpdateTo11_0::SysConfigMigrateCustomerDashboardTileMotD - Try to find a solution for the old vs new info tile

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $TileConfigs = $Kernel::OM->Get('Kernel::Config')->Get('CustomerDashboard::Tiles');

    return if !$TileConfigs;

    # check whether we are on a system with a modified Core.Dashboard.Default.css
    my $ModifiedCSS;

    PACKAGE:
    for my $Package ( $Kernel::OM->Get('Kernel::System::Package')->RepositoryList() ) {

        FILEOLD:
        for my $FileOld ( @{ $Package->{Filelist} } ) {
            $FileOld->{Location} =~ s/\/\//\//g;

            next FILEOLD if $FileOld->{Location} ne 'var/httpd/htdocs/skins/Customer/default/css/Core.Dashboard.Default.css';

            $ModifiedCSS = 1;

            last PACKAGE;
        }
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %TileSetting;
    for my $Tile ( keys $TileConfigs->%* ) {
        $TileSetting{$Tile} = {
            $SysConfigObject->SettingGet(
                Name => 'CustomerDashboard::Tiles###' . $Tile,
            )
        };
    }

    # if the info tile is already modified in some way, return
    if ( $TileSetting{'InfoTile-01'}{IsModified} ) {
        print "\t  Info tile already modified - nothing to do.\n";

        return 1;
    }

    # deactivate the new info tile on highly customized systems
    if ($ModifiedCSS) {
        print "\t  Core.Dashboard.Default.css is part of a package - deactivating the new info tile to keep the dashboard unchanged.\n";

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $TileSetting{'InfoTile-01'}{DefaultID},
        );

        # Update setting with modified data
        my %Result = $SysConfigObject->SettingUpdate(
            Name              => 'CustomerDashboard::Tiles###InfoTile-01',
            IsValid           => 0,
            EffectiveValue    => $TileSetting{'InfoTile-01'}{EffectiveValue},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not deactivate setting CustomerDashboard::Tiles###InfoTile-01.',
            );

            return;
        }

        my $Success = $SysConfigObject->SettingUnlock(
            UserID    => 1,
            DefaultID => $TileSetting{'InfoTile-01'}{DefaultID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not unlock setting CustomerDashboard::Tiles###InfoTile-01.',
            );

            return;
        }

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments      => "UpgradeTo11 - Deactivate new Customer Dashboard InfoTile.",
            UserID        => 1,
            Force         => 1,
            DirtySettings => ['CustomerDashboard::Tiles###InfoTile-01'],
        );

        if ( !$DeploymentResult{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Deployment failed.",
            );

            return;
        }

        return 1;
    }

    my %ToDeactivate;
    TILE:
    for my $Tile ( $TileConfigs->%* ) {
        next TILE if !$TileSetting{$Tile}{IsValid};

        if ( $TileConfigs->{$Tile}{Order} == 4 || $TileConfigs->{$Tile}{Order} == 6 ) {
            $ToDeactivate{$Tile} = $TileSetting{$Tile};
        }
        elsif ( $TileConfigs->{$Tile}{Order} == 7 && $Tile ne 'InfoTile-01' ) {
            $ToDeactivate{$Tile} = $TileSetting{$Tile};
        }
    }

    if ( !%ToDeactivate ) {
        print "\t  No activated tiles of order 4, 6 or 7 - skipping.\n";

        return 1;
    }

    print "\t  Core.Dashboard.Default.css is not part of a package - change the sysconfig to align with the new customer dashboard layout.\n";

    # else - we will use the new Dashboard layout - copy the plaintext text and deactivate now unused tiles 04 and 06
    if ( $TileConfigs->{'PlainText-01'} ) {
        my $NewBody = $TileConfigs->{'PlainText-01'}{Config}{HeaderText} ? "<h3>$TileConfigs->{'PlainText-01'}{Config}{HeaderText}</h3>\n" : '';
        $NewBody .= $TileConfigs->{'PlainText-01'}{Config}{MainText} ? "<p>$TileConfigs->{'PlainText-01'}{Config}{MainText}</p>" : '';

        if ($NewBody) {
            my $InfoTileObject = $Kernel::OM->Get('Kernel::System::CustomerDashboard::InfoTile');

            print "\t  - copy the content of the tile PlainText-01 to the InfoTile (see Admin->Customer Info)\n";

            $Kernel::OM->Get('Kernel::System::CustomerDashboard::InfoTile')->InfoTileAdd(
                Name    => $TileConfigs->{'PlainText-01'}{Config}{HeaderText} // 'Auto added: PlainText-01 content',
                Content => $NewBody,
                ValidID => 1,
                UserID  => 1,
            );
        }
    }

    my @Dirty;

    TILE:
    for my $Tile ( keys %ToDeactivate ) {
        if ( $TileConfigs->{$Tile}{Order} == 7 ) {
            print "\t  - deactivate tile $Tile (duplicate tile order 7)\n";
        }
        else {
            print "\t  - deactivate tile $Tile (now unused order $TileConfigs->{$Tile}{Order})\n";
        }

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $ToDeactivate{$Tile}{DefaultID},
        );

        # Update setting with modified data
        my %Result = $SysConfigObject->SettingUpdate(
            Name              => 'CustomerDashboard::Tiles###' . $Tile,
            IsValid           => 0,
            EffectiveValue    => $ToDeactivate{$Tile}{EffectiveValue},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not update setting CustomerDashboard::Tiles###$Tile.",
            );

            return;
        }

        my $Success = $SysConfigObject->SettingUnlock(
            UserID    => 1,
            DefaultID => $ToDeactivate{$Tile}{DefaultID},
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not unlock setting CustomerDashboard::Tiles###$Tile.",
            );

            return;
        }

        push @Dirty, "CustomerDashboard::Tiles###$Tile";
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11 - Integrate new InfoTile to CustomerDashboard.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => [@Dirty],
    );

    if ( !$DeploymentResult{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Deployment failed.",
        );

        return;
    }

    return 1;
}

1;
