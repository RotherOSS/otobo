# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2022 Rother OSS GmbH, https://otobo.de/
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

package Kernel::Output::HTML::Notification::AgentParticipation;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Calendar::Participation',
);

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Fetch participations
    # TODO Add possibility to only fetch participation count
    my @Participations = $Kernel::OM->Get('Kernel::System::Calendar::Participation')->ParticipationList(
        AgentUserID         => $Self->{UserID},
        ParticipationStatus => ['NEEDS-ACTION'],
    );

    return '' unless @Participations;

    my $Message = 'You have %s open appointment participation' . ( scalar @Participations != 1 ? 's.' : '.' );

    return $LayoutObject->Notify(
        Priority => 'Info',
        Link     => $LayoutObject->{Baselink} . 'Action=AgentParticipation',
        Data     => $LayoutObject->{LanguageObject}->Translate(
            $Message,
            scalar @Participations,
        ),
    );
}

1;
