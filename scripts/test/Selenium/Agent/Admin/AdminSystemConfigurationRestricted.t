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

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'ConfigLevel',
            Value => '300',
        );

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
                'return typeof($) === "function" && $("#SysConfigSearch").length && $("#ConfigTree > ul:visible").length;',
        );

        $Selenium->find_element( "#SysConfigSearch", "css" )->clear();
        $Selenium->find_element( "#SysConfigSearch", "css" )->send_keys('LoginURL');
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$("#AJAXLoaderSysConfigSearch:visible").length;'
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;' );
        $Selenium->find_element( "button[type='submit']", "css" )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".fa-exclamation-triangle").length;',
        );

        my $Message = $Selenium->find_element( ".fa-exclamation-triangle", "css" )->get_attribute('title');
        $Kernel::OM->Get('Kernel::System::Log')->Dumper( '$Message', $Message );
        $Self->Is(
            'Changing this setting is only available in a higher config level!',
            $Message,
            "Check if setting restriction message is present."
        );

        # Navigate to AdminSysConfig screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfigurationGroup;RootNavigation=Frontend::Agent::View::TicketQueue"
        );

        # Wait until page is loaded with jstree content in sidebar.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".fa-exclamation-triangle").length && $("#ConfigTree > ul:visible").length;',
        );

        $Message = $Selenium->find_element( ".fa-exclamation-triangle", "css" )->get_attribute('title');
        $Self->Is(
            'Changing this setting is only available in a higher config level!',
            $Message,
            "Check if setting restriction message is present."
        );
    }
);

$Self->DoneTesting();
