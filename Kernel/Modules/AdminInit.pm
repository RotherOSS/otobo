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

package Kernel::Modules::AdminInit;

use strict;
use warnings;

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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Return to admin screen.
    if ( $Self->{Subaction} eq 'Done' ) {
        return $LayoutObject->Redirect( OP => 'Action=Admin' );
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Load all XML settings into the DB.
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            UserID  => 1,
            Force   => 1,
            CleanUp => 1,
        )
        )
    {
        return $LayoutObject->ErrorScreen();
    }

    # Create initial deployment (write ZZZAAuto file).
    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments    => "Deployed by AdminInit",
        AllSettings => 1,
        UserID      => 1,
        Force       => 1,
    );

    if ( !$DeploymentResult{Success} ) {
        return $LayoutObject->ErrorScreen();
    }

    # Install included packages.
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::System::Package') ) {
        my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
        if ($PackageObject) {
            $PackageObject->PackageInstallDefaultFiles();
        }
    }

    return $LayoutObject->Redirect( OP => 'Action=AdminInit;Subaction=Done' );
}

1;
