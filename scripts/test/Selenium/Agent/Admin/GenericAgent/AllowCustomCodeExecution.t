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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# Check if needed frontend module is registered in sysconfig.
skip_all("No AdminGenericAgent") unless $ConfigObject->Get('Frontend::Module')->{AdminGenericAgent};

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Allow custom script and module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 1,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check overview AdminGenericAgent.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        my $Element = $Selenium->find_element( "#Profile", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->True(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input found on page",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input found on page",
        );

        # Allow custom script and restrict module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 1,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->False(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input NOT found on page",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input NOT found on page",
        );

        # Restrict custom script and allow module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 0,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->True(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input NOT found on page",
        );
        $Self->False(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input NOT found on page",
        );

        # Restrict custom script and module execution.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomScriptExecution',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentAllowCustomModuleExecution',
            Value => 0,
        );

        # Navigate to AdminGenericAgent screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check add job page.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        # Toggle widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check that custom code elements.
        $Self->False(
            $Selenium->execute_script("return \$('#NewCMD').length === 1;"),
            "CMD input NOT found on page",
        );
        $Self->False(
            $Selenium->execute_script("return \$('#NewModule').length === 1;"),
            "CMD input NOT found on page",
        );

    },
);

$Self->DoneTesting();
