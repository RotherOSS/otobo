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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Enable TicketOverViewPageShown preference.
        for my $View (qw( Small Medium Preview )) {

            my %TicketOverViewPageShown = (
                Active          => "1",
                PreferenceGroup => "Miscellaneous",
                DataSelected    => "25",
                Key             => "Ticket limit per page for Ticket Overview \"$View\"",
                Label           => "Ticket Overview \"$View\" Limit",
                Module          => "Kernel::Output::HTML::Preferences::Generic",
                PrefKey         => "UserTicketOverview" . $View . "PageShown",
                Prio            => "8000",
                Data            => {
                    "10" => "10",
                    "15" => "15",
                    "20" => "20",
                    "25" => "25",
                    "30" => "30",
                    "35" => "35",
                },
            );

            my $Key = "PreferencesGroups###TicketOverview" . $View . "PageShown";
            $Helper->ConfigSettingChange(
                Key   => $Key,
                Value => \%TicketOverViewPageShown,
            );

            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $Key,
                Value => \%TicketOverViewPageShown,
            );
        }

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to agent preferences.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=Miscellaneous");

        # Create test params.
        my @Tests = (
            {
                Name  => 'Overview Refresh Time',
                ID    => 'UserRefreshTime',
                Value => '5',
            },
            {
                Name  => 'Ticket Overview "Small" Limit',
                ID    => 'UserTicketOverviewSmallPageShown',
                Value => '10',
            },
            {
                Name  => 'Ticket Overview "Medium" Limit',
                ID    => 'UserTicketOverviewMediumPageShown',
                Value => '10',
            },
            {
                Name  => 'Ticket Overview "Preview" Limit',
                ID    => 'UserTicketOverviewPreviewPageShown',
                Value => '10',
            },
            {
                Name  => 'Screen after new ticket',
                ID    => 'UserCreateNextMask',
                Value => 'AgentTicketZoom',
            },

        );

        my $UpdateMessage = "Preferences updated successfully!";

        # Update generic preferences.
        for my $Test (@Tests) {

            $Selenium->InputFieldValueSet(
                Element => "#$Test->{ID}",
                Value   => $Test->{Value},
            );

            # Save the setting, wait for the ajax call to finish and check if success sign is shown.
            $Selenium->execute_script(
                "\$('#$Test->{ID}').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('#$Test->{ID}').closest('.WidgetSimple').hasClass('HasOverlay');"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('#$Test->{ID}').closest('.WidgetSimple').find('.fa-check').length;"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return !\$('#$Test->{ID}').closest('.WidgetSimple').hasClass('HasOverlay');"
            );

        }
    }
);

$Self->DoneTesting();
