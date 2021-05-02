# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

use Kernel::Language;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Selenium->set_window_size( 600, 400 );

        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Language => $Language,
            Groups   => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentDashboard screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Wait until jquery is ready.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );

        # The mobile navigation toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            1,
            "Mobile navigation toggle should be visible"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            1,
            "Mobile sidebar toggle should be visible"
        );

        # Check for toolbar visibility.
        $Self->Is(
            $Selenium->execute_script("return parseInt(\$('#ToolBar').css('height'), 10)"),
            0,
            "Toolbar height should be 0"
        );

        # Expand navigation bar.
        $Selenium->find_element( "#ResponsiveNavigationHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('#NavigationContainer:visible').length"),
            1,
            "Navigation bar should be visible"
        );

        # Collapse navigation bar again.
        $Selenium->find_element( "#ResponsiveNavigationHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('#NavigationContainer:visible').length"),
            0,
            "Navigation bar should be hidden again"
        );

        # Expand sidebar.
        $Selenium->find_element( "#ResponsiveSidebarHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('.ResponsiveSidebarContainer:visible').length"),
            1,
            "Sidebar bar should be visible"
        );

        # Collapse sidebar again.
        $Selenium->find_element( "#ResponsiveSidebarHandle", "css" )->click();

        # Wait for animation has finished.
        sleep 2;

        $Self->Is(
            $Selenium->execute_script("return \$('.ResponsiveSidebarContainer:visible').length"),
            0,
            "Sidebar bar should be hidden again"
        );

        # Expand toolbar.
        $Selenium->find_element( "#Logo", "css" )->click();
        $Selenium->WaitFor( JavaScript => "return parseInt(\$('#ToolBar').css('height'), 10) > 0" );
        $Self->True(
            $Selenium->execute_script("return parseInt(\$('#ToolBar').css('height'), 10) > 0"),
            "Toolbar should be visible"
        );

        # Wait for animation has finished.
        sleep 2;

        # While the toolbar is expanded, navigation and sidebar toggle should be hidden.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            0,
            "Mobile navigation toggle should be hidden"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            0,
            "Mobile sidebar toggle should be hidden"
        );

        # Collapse toolbar again.
        $Selenium->find_element( "#Logo", "css" )->click();
        $Selenium->WaitFor( JavaScript => "return parseInt(\$('#ToolBar').css('height'), 10) === 0" );
        $Self->True(
            $Selenium->execute_script("return parseInt(\$('#ToolBar').css('height'), 10) == 0"),
            "Toolbar should be hidden again"
        );

        # Wait for animation has finished.
        sleep 2;

        # Now that the toolbar is collapsed again, navigation and sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            1,
            "Mobile navigation toggle should be visible"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            1,
            "Mobile sidebar toggle should be visible"
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Check for the viewmode switch.
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to desktop mode'
            ),
            'Check for mobile mode switch text',
        );

        # Toggle the switch.
        $Selenium->find_element( "#ViewModeSwitch", "css" )->click();

        # Wait until jquery is ready.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );
        sleep 1;

        # Check for the viewmode switch.
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to mobile mode'
            ),
            'Check for mobile mode switch text',
        );

        # We should now be in desktop mode, thus the toggles should be hidden.
        # While the toolbar is expanded, navigation and sidebar toggle should be hidden.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            0,
            "Mobile navigation toggle should be hidden"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            0,
            "Mobile sidebar toggle should be hidden"
        );

        # Toggle the switch again.
        $Selenium->find_element( "#ViewModeSwitch", "css" )->click();

        # Wait until jquery is ready.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function'" );
        sleep 1;

        # Check for the viewmode switch.
        $Self->Is(
            $Selenium->execute_script("return \$('#ViewModeSwitch > a').text();"),
            $LanguageObject->Translate(
                'Switch to desktop mode'
            ),
            'Check for mobile mode switch text',
        );

        # We should now be in desktop mode, thus the toggles should be hidden.
        # While the toolbar is expanded, navigation and sidebar toggle should be hidden.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveNavigationHandle:visible').length"),
            1,
            "Mobile navigation toggle should be visible"
        );

        # The mobile sidebar toggle should be visible.
        $Self->Is(
            $Selenium->execute_script("return \$('#ResponsiveSidebarHandle:visible').length"),
            1,
            "Mobile sidebar toggle should be visible"
        );
    }
);

$Self->DoneTesting();
