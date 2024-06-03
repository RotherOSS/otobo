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

package Kernel::System::Console::Command::Admin::CommunicationChannel::Sync;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::CommunicationChannel',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Synchronize registered communication channels in the system.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Syncing communication channels...</yellow>\n");

    my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

    # Sync the channels.
    my %Result = $CommunicationChannelObject->ChannelSync(
        UserID => 1,
    );
    if (%Result) {
        if ( $Result{ChannelsAdded} ) {
            $Self->Print(
                sprintf( "<yellow>%s</yellow> channels were added.\n", scalar @{ $Result{ChannelsAdded} || [] } )
            );
        }
        if ( $Result{ChannelsUpdated} ) {
            $Self->Print(
                sprintf( "<yellow>%s</yellow> channels were updated.\n", scalar @{ $Result{ChannelsUpdated} || [] } )
            );
        }
        if ( $Result{ChannelsInvalid} ) {
            $Self->Print(
                sprintf( "<red>%s</red> channels are invalid.\n", scalar @{ $Result{ChannelsInvalid} || [] } )
            );
        }
    }
    else {
        $Self->Print("<yellow>All channels were already in sync with configuration.</yellow>\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
