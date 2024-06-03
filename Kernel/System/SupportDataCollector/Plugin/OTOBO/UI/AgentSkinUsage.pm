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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::UI::AgentSkinUsage;

use strict;
use warnings;

use parent qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::User',
);

sub GetDisplayPath {
    return Translatable('OTOBO') . '/' . Translatable('UI - Agent Skin Usage');
}

sub Run {
    my $Self = shift;

    # First get count of all agents. We avoid checking for Valid for performance reasons, as this
    #   would require fetching of all agent data to check for the preferences.
    my $DBObject              = $Kernel::OM->Get('Kernel::System::DB');
    my $AgentsWithDefaultSkin = 1;
    $DBObject->Prepare( SQL => 'SELECT count(*) FROM users' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $AgentsWithDefaultSkin = $Row[0];
    }

    my $DefaultSkin = $Kernel::OM->Get('Kernel::Config')->Get('Loader::Agent::DefaultSelectedSkin');

    my %SkinPreferences = $Kernel::OM->Get('Kernel::System::User')->SearchPreferences(
        Key => 'UserSkin',
    );

    my %SkinUsage;

    # Check how many agents have a skin preference configured, assume default skin for the rest.
    for my $UserID ( sort keys %SkinPreferences ) {
        $SkinUsage{ $SkinPreferences{$UserID} }++;
        $AgentsWithDefaultSkin--;
    }
    $SkinUsage{$DefaultSkin} += $AgentsWithDefaultSkin;

    for my $Skin ( sort keys %SkinUsage ) {

        $Self->AddResultInformation(
            Identifier => $Skin,
            Label      => $Skin,
            Value      => $SkinUsage{$Skin},
        );
    }

    return $Self->GetResults();
}

1;
