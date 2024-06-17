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

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $TicketHookValue = 'abc';

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Hook',
            Value => $TicketHookValue,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###QueueSort',
            Value => {
                '7' => 2,
                '3' => 1,
            },
        );

        # Rebuild system configuration.
        my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Config::Rebuild');
        my $ExitCode      = $CommandObject->Execute('--cleanup');

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
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration;");

        # Wait until page is loaded with jstree content in sidebar.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#SysConfigSearch").length && $("#ConfigTree > ul:visible").length',
        );

        $Selenium->find_element( "#SysConfigSearch", "css" )->clear();
        $Selenium->find_element( "#SysConfigSearch", "css" )->send_keys('Ticket::Hook');
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$("#AJAXLoaderSysConfigSearch:visible").length'
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element( "button[type='submit']", "css" )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".fa-exclamation-triangle").length',
        );

        my $Message = $Selenium->execute_script("return \$('.fa-exclamation-triangle').attr('title');");
        like(
            $Message,
            qr/^This setting is currently being overridden in Kernel\/Config\/Files\/ZZZZUnitTest[A-Z]{2}\d+.pm and can't thus be changed here!$/,
            "Check if setting overridden message is present."
        );

        # Check if overridden Effective value is displayed.
        my $Value = $Selenium->find_element( "#Ticket\\:\\:Hook", "css" )->get_value();
        $Self->Is(
            $Value // '',
            $TicketHookValue,
            'Ticket::Hook value is rendered ok.',
        );

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Frontend::Agent::View::TicketQueue"
        );

        # Wait until page is loaded with jstree content in sidebar.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".fa-exclamation-triangle").length && $("#ConfigTree > ul:visible").length',
        );

        $Message = $Selenium->find_element( ".fa-exclamation-triangle", "css" )->get_attribute('title');
        like(
            $Message,
            qr/^This setting is currently being overridden in Kernel\/Config\/Files\/ZZZZUnitTest[A-Z]{2}\d+.pm and can't thus be changed here!$/,
            "Check if setting overridden message is present (when navigation is used)."
        );

        # Check if overridden Effective value is displayed.
        my $HashValue1 = $Selenium->find_element(
            "#Ticket\\:\\:Frontend\\:\\:AgentTicketQueue\\#\\#\\#QueueSort_Hash\\#\\#\\#3",
            "css"
        )->get_value();
        $Self->Is(
            $HashValue1 // '',
            '1',
            'Check first hash item value',
        );

        my $HashValue2 = $Selenium->find_element(
            "#Ticket\\:\\:Frontend\\:\\:AgentTicketQueue\\#\\#\\#QueueSort_Hash\\#\\#\\#7",
            "css"
        )->get_value();
        $Self->Is(
            $HashValue2 // '',
            '2',
            'Check second hash item value',
        );

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=Frontend%3A%3ACSSPath"
        );

        # Check if setting is overridden
        my $CSSPathOverridden = $Selenium->execute_script(
            'return $(".SettingsList .WidgetSimple i.fa-exclamation-triangle").length;'
        );
        $Self->False(
            $CSSPathOverridden,
            'Make sure that Frontend::CSSPath is not overridden.'
        );
    }
);

done_testing();
