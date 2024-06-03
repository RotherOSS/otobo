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

package Kernel::System::Console::Command::Admin::CommunicationChannel::Drop;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::CommunicationChannel',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description(
        'Drop a communication channel (with its data) that is no longer available in the system.'
    );
    $Self->AddOption(
        Name        => 'channel-id',
        Description => 'The ID of the communication channel to drop.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\A\d+\z/smx,
    );
    $Self->AddOption(
        Name        => 'channel-name',
        Description => 'The name of the communication channel to drop.',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/\A\w+\z/smx,
    );
    $Self->AddOption(
        Name        => 'force',
        Description => 'Force drop the channel even if there is existing article data, use with care.',
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $ChannelID   = $Self->GetOption('channel-id');
    my $ChannelName = $Self->GetOption('channel-name');

    if ( !$ChannelID && !$ChannelName ) {
        die "Please provide either --channel-id or --channel-name option.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Deleting communication channel...</yellow>\n");

    my $ChannelID   = $Self->GetOption('channel-id');
    my $ChannelName = $Self->GetOption('channel-name');

    my $CommunicationChannelObject = $Kernel::OM->Get('Kernel::System::CommunicationChannel');

    my %CommunicationChannel = $CommunicationChannelObject->ChannelGet(
        ChannelID   => $ChannelID,
        ChannelName => $ChannelName,
    );

    if ( !%CommunicationChannel ) {
        if ($ChannelID) {
            $Self->PrintError("Channel with the ID $ChannelID could not be found!");
        }
        else {
            $Self->PrintError("Channel '$ChannelName' could not be found!");
        }
        return $Self->ExitCodeError();
    }

    # Try to drop the channel.
    my $Success = $CommunicationChannelObject->ChannelDrop(
        ChannelID       => $ChannelID,
        ChannelName     => $ChannelName,
        DropArticleData => $Self->GetOption('force'),
    );
    if ( !$Success ) {
        $Self->PrintError('Could not drop a channel!');
        if ( !$Self->GetOption('force') ) {
            $Self->Print("<yellow>Channel might still have associated data in the system.</yellow>\n");
            $Self->Print("If you want to drop this data as well, please use the <green>--force</green> switch.\n");
        }
        else {
            $Self->Print("<yellow>Please note that only invalid channels can be dropped.</yellow>\n");
        }
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
