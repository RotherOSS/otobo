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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::CommunicationLog;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CommunicationLog',
    'Kernel::System::CommunicationLog::DB',
);

sub GetDisplayPath {
    return Translatable('OTOBO') . '/' . Translatable('Communication Log');
}

sub Run {
    my $Self = shift;

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my @CommunicationList     = @{ $CommunicationLogDBObj->CommunicationList() || [] };

    my %CommunicationData = (
        All        => 0,
        Successful => 0,
        Processing => 0,
        Failed     => 0,
        Incoming   => 0,
        Outgoing   => 0,
    );
    for my $Communication (@CommunicationList) {
        $CommunicationData{All}++;
        $CommunicationData{ $Communication->{Status} }++;
        $CommunicationData{ $Communication->{Direction} }++;
    }

    my $CommunicationAverageSeconds = $CommunicationLogDBObj->CommunicationList( Result => 'AVERAGE' );

    $Self->AddResultInformation(
        Identifier => 'Incoming',
        Label      => Translatable('Incoming communications'),
        Value      => $CommunicationData{Incoming},
    );
    $Self->AddResultInformation(
        Identifier => 'Outgoing',
        Label      => Translatable('Outgoing communications'),
        Value      => $CommunicationData{Outgoing},
    );
    $Self->AddResultInformation(
        Identifier => 'Failed',
        Label      => Translatable('Failed communications'),
        Value      => $CommunicationData{Failed}
    );

    my $Mask = "%.0f";
    if ( $CommunicationAverageSeconds < 10 ) {
        $Mask = "%.1f";
    }
    $Self->AddResultInformation(
        Identifier => 'AverageProcessingTime',
        Label      => Translatable('Average processing time of communications (s)'),
        Value      => sprintf( $Mask, $CommunicationAverageSeconds ),
    );

    return $Self->GetResults();
}

1;
