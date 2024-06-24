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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::ArticlesPerCommunicationChannel;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationChannel',
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('OTOBO') . '/' . Translatable('Articles Per Communication Channel');
}

sub Run {
    my $Self = shift;

    my @Channels = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelList();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Channel (@Channels) {
        $DBObject->Prepare(
            SQL  => 'SELECT count(*) FROM article WHERE communication_channel_id = ?',
            Bind => [ \$Channel->{ChannelID} ],
        );
        my $Count;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Count = $Row[0];
        }
        $Self->AddResultInformation(
            Identifier => $Channel->{ChannelName},
            Label      => $Channel->{DisplayName},
            Value      => $Count,
        );
    }

    return $Self->GetResults();
}

1;
