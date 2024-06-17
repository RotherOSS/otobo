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
        my $Config          = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias     = $Config->Get('ScriptAlias');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Load sample XML file.
        my $Directory = $Config->Get('Home') . '/scripts/test/sample/SysConfig/XMLNoCookie';
        my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
            UserID    => 1,
            Directory => $Directory,
            Force     => 1,
            CleanUp   => 0,
        );
        $Self->True(
            $XMLLoaded,
            "Example XML loaded.",
        );

        # Deploy changes.
        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfigurationExampleSessionID.t deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );
        $Self->True(
            $DeploymentResult{Success},
            "Deployment successful.",
        );

        # Disable cookies.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionUseCookie',
            Value => 0,
        );

        # Log in after redirect without a session ID.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=NoCookieCheckbox"
        );
        $Selenium->find_element( "#User",        'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( '#Password',    'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( '#LoginButton', 'css' )->VerifiedClick();

        # Open the checkbox for editing.
        my $Prefix = ".WidgetSimple[data-name='NoCookieCheckbox']";

        $Selenium->execute_script("\$(\"$Prefix div.Content\").mouseenter();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("'
                . "$Prefix button.CallForAction"
                . ':visible").length',
        );
        $Selenium->find_element( "$Prefix button.CallForAction", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && ! $("' . "$Prefix .Overlay" . ':visible").length',
        );

        # Set the checkbox value to true and save it.
        $Selenium->find_element( '#Checkbox_NoCookieCheckbox', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Checkbox_NoCookieCheckbox:checked").length',
        );
        $Selenium->find_element( $Prefix . ' button.Update', 'css' )->click();

        # Verify the deploy link click.
        $Selenium->WaitFor(
            ElementExists => '//a[contains(@href,"Subaction=Deployment")]',
        );
        $Selenium->find_element('//a[contains(@href,"Subaction=Deployment")]')->VerifiedClick();
        $Self->Is(
            $Selenium->execute_script("return \$('#DeploymentStart').length > 0"),
            "1",
            "The deployment link not redirecting to login.",
        );

        # Log in after redirect without a session ID.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=NoCookieCheckbox"
        );
        $Selenium->find_element( "#User",        'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( '#Password',    'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( '#LoginButton', 'css' )->VerifiedClick();

        # Open the checkbox for editing.
        $Selenium->execute_script("\$(\"$Prefix div.Content\").mouseenter();");
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("'
                . "$Prefix button.CallForAction"
                . ':visible").length',
        );
        $Selenium->find_element( "$Prefix button.CallForAction", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && ! $("' . "$Prefix .Overlay" . ':visible").length',
        );

        # Set the checkbox value to false and save it.
        $Selenium->find_element( '#Checkbox_NoCookieCheckbox', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && ! $("#Checkbox_NoCookieCheckbox:checked").length',
        );
        $Selenium->find_element( $Prefix . ' button.Update', 'css' )->click();
    }
);

$Self->DoneTesting();
