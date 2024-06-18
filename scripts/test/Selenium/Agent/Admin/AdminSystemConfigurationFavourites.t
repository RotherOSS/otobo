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

        # Load sample XML file.
        my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . '/scripts/test/sample/SysConfig/XML/AdminSystemConfiguration';

        my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
            UserID    => 1,
            Directory => $Directory,
            Force     => 1,
            CleanUp   => 0,
        );

        $Self->True(
            $XMLLoaded,
            "ExampleComplex XML loaded.",
        );

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfigurationFavourites.t deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );

        $Self->True(
            $DeploymentResult{Success},
            "Deployment successful.",
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

        # Navigate to 'ExampleAoA' setting and add to favourites.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=ExampleAoA;"
        );

        $Selenium->execute_script("\$('div[data-name=ExampleAoA] > .Header .WidgetAction.Expand').trigger('click');");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('div[data-name=ExampleAoA] > div.WidgetMenu:visible').length;"
        );

        $Selenium->execute_script(
            "\$('div[data-name=ExampleAoA] > div.WidgetMenu:visible > .AddToFavourites').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('div[data-name=ExampleAoA] > div.WidgetMenu:visible > .RemoveFromFavourites').length;"
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=Favourites;");

        # Check if 'ExampleAoA' exists in Favourite settings.
        $Self->True(
            $Selenium->execute_script("return \$('.SettingsList li div[data-name=ExampleAoA]').length;"),
            "'ExampleAoA' exists in Favourite settings"
        );

        # Navigate to 'ExampleAoH' setting and add to favourites.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=ExampleAoH;"
        );

        $Selenium->execute_script("\$('div[data-name=ExampleAoH] > .Header .WidgetAction.Expand').trigger('click');");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('div[data-name=ExampleAoH] > div.WidgetMenu:visible').length;"
        );

        $Selenium->execute_script(
            "\$('div[data-name=ExampleAoH] > div.WidgetMenu:visible > .AddToFavourites').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('div[data-name=ExampleAoH] > div.WidgetMenu:visible > .RemoveFromFavourites').length;"
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=Favourites;");

        # Check if both 'ExampleAoA' and 'ExampleAoH' exist in Favourite settings.
        $Self->True(
            $Selenium->execute_script("return \$('.SettingsList li div[data-name=ExampleAoA]').length;"),
            "'ExampleAoA' exists in Favourite settings"
        );
        $Self->True(
            $Selenium->execute_script("return \$('.SettingsList li div[data-name=ExampleAoH]').length;"),
            "'ExampleAoH' exists in Favourite settings"
        );

        # Check if default strings are displayed correctly. See bug#14768.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=TestAgentTicketOwnerBody;"
        );
        $Selenium->find_element( ".Header .ActionMenu.Visible", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('div.WidgetMessage.Bottom:visible').length;" );
        $Selenium->find_element( ".Header .ActionMenu.Visible", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return !\$('div.WidgetMessage.Bottom:visible').length;" );

        $Self->Is(
            $Selenium->execute_script("return \$('div.WidgetMessage.Bottom:visible').length;"),
            "0",
            "Default setting is hidden successfully"
        );
    }
);

$Self->DoneTesting();
