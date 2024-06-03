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

package Kernel::System::SupportDataCollector::Plugin::OTOBO::UI::AgentThemeUsage;

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
    return Translatable('OTOBO') . '/' . Translatable('UI - Agent Theme Usage');
}

sub Run {
    my $Self = shift;

    # First get count of all agents. We avoid checking for Valid for performance reasons, as this
    #   would require fetching of all agent data to check for the preferences.
    my $DBObject               = $Kernel::OM->Get('Kernel::System::DB');
    my $AgentsWithDefaultTheme = 1;
    $DBObject->Prepare( SQL => 'SELECT count(*) FROM users' );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $AgentsWithDefaultTheme = $Row[0];
    }

    my $DefaultThem = $Kernel::OM->Get('Kernel::Config')->Get('DefaultTheme');

    my %ThemePreferences = $Kernel::OM->Get('Kernel::System::User')->SearchPreferences(
        Key => 'UserTheme',
    );

    my %ThemeUsage;

    # Check how many agents have a theme preference configured, assume default theme for the rest.
    for my $UserID ( sort keys %ThemePreferences ) {
        $ThemeUsage{ $ThemePreferences{$UserID} }++;
        $AgentsWithDefaultTheme--;
    }
    $ThemeUsage{$DefaultThem} += $AgentsWithDefaultTheme;

    for my $Theme ( sort keys %ThemeUsage ) {

        $Self->AddResultInformation(
            Identifier => $Theme,
            Label      => $Theme,
            Value      => $ThemeUsage{$Theme},
        );
    }

    return $Self->GetResults();
}

1;
