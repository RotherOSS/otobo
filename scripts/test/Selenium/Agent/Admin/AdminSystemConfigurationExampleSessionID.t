# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

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
        # XMLNoCookie will initially not be checked.
        my $Directory = $Config->Get('Home') . '/scripts/test/sample/SysConfig/XMLNoCookie';
        my $XMLLoaded = $SysConfigObject->ConfigurationXML2DB(
            UserID    => 1,
            Directory => $Directory,
            Force     => 1,
            CleanUp   => 0,
        );
        ok( $XMLLoaded, "Example XML loaded." );

        # Deploy changes.
        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments    => "AdminSystemConfigurationExampleSessionID.t deployment",
            UserID      => 1,
            Force       => 1,
            AllSettings => 1,
        );
        ok( $DeploymentResult{Success}, "Deployment successful." );

        # Initial login in this process.
        # There should be a redirect to the login page. After providing the credentials
        # another redirect to the admin page.
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

        # verify the deploy notification is faded in
        $Selenium->WaitFor(
            ElementExists => '//a[contains(@href,"Subaction=Deployment")]',
        );

        # verify that the deploy notification does not contain the session cookie
        $Selenium->find_no_element_ok('//a[contains(@href,"Subaction=Deployment")][contains(@href,"OTOBOAgentInterface")]');

        # do the deployment, authenticated with the session cookie in the URL
        $Selenium->find_element('//a[contains(@href,"Subaction=Deployment")]')->VerifiedClick();
        is(
            $Selenium->execute_script("return \$('#DeploymentStart').length > 0"),
            '1',
            "The deployment link not redirecting to login.",
        );

        # There is no redirect to the login page as support for SessionUseCookie = 1
        # had been removed for OTOBO 11.1.x
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=NoCookieCheckbox"
        );
        $Selenium->find_no_element_ok( "#User",        'css' );
        $Selenium->find_no_element_ok( '#Password',    'css' );
        $Selenium->find_no_element_ok( '#LoginButton', 'css' );

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

done_testing;
