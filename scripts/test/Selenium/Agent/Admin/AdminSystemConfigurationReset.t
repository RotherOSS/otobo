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

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AFrontend%3A%3AAgentTicketEscalationView%23%23%23Order%3A%3ADefault;"
        );

        # Hover
        my $SelectedItem = $Selenium->find_element( ".SettingEdit", "css" );
        $Selenium->mouse_move_to_location( element => $SelectedItem );

        # Lock setting.
        $Selenium->find_element( ".SettingEdit", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            Time       => 120,
            JavaScript => 'return $(".SettingsList .WidgetSimple:first").hasClass("HasOverlay") == 0',
        );

        # Change dropdown value do 'Down'.
        $Selenium->InputFieldValueSet(
            Element => '.SettingContent select',
            Value   => 'Down',
        );

        # Save.
        $Selenium->find_element( ".SettingUpdateBox button", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            Time       => 120,
            JavaScript => 'return $(".SettingsList .WidgetSimple:first").hasClass("HasOverlay") == 0',
        );

        # Make sure that it's saved properly.
        my %Setting = $SysConfigObject->SettingGet(
            Name => 'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
        );

        $Self->Is(
            $Setting{EffectiveValue},
            'Down',
            'Make sure setting is updated.',
        );

        # Expand header.
        $Selenium->find_element( ".SettingsList .WidgetSimple .Header", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            JavaScript => 'return $(".ResetSetting:visible").length',
        );

        # Click on reset.
        $Selenium->execute_script('$(".ResetSetting").click()');

        # Wait.
        $Selenium->WaitFor(
            JavaScript => 'return $("#ResetConfirm").length',
        );

        # Confirm.
        $Selenium->find_element( "#ResetConfirm", "css" )->click();

        # Wait.
        $Selenium->WaitFor(
            Time       => 120,
            JavaScript => 'return $(".SettingsList .WidgetSimple:first").hasClass("HasOverlay") == 0',
        );

        # Discard Cache object.
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Cache'],
        );

        # Make sure that setting is reset properly.
        %Setting = $SysConfigObject->SettingGet(
            Name => 'Ticket::Frontend::AgentTicketEscalationView###Order::Default',
        );

        $Self->Is(
            $Setting{EffectiveValue},
            'Up',
            'Make sure setting is reset.',
        );
    }
);

$Self->DoneTesting();
