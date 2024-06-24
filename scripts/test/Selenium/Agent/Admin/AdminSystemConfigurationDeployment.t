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

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $ScriptAlias     = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Load sample XML file.
        my $Directory = $Kernel::OM->Get('Kernel::Config')->Get('Home')
            . '/scripts/test/sample/SysConfig/XML/AdminSystemConfiguration/Deployment';

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

        my $SettingName       = 'DeployTestCheckbox';
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => $SettingName,
            Force  => 1,
            UserID => 1,
        );
        $Self->True(
            $ExclusiveLockGUID,
            "Setting $SettingName is locked successfully.",
        );

        my $SettingReset = $SysConfigObject->SettingReset(
            Name              => $SettingName,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
        $Self->True(
            $SettingReset,
            "Setting $SettingName is resetted successfully.",
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

        # Navigate to 'DeployTestCheckbox' setting and check it.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration;Subaction=View;Setting=DeployTestCheckbox"
        );

        my $Prefix = "div[data-name=$SettingName]";

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('$Prefix div.Content').length;",
        );

        $Selenium->execute_script("\$(\"$Prefix div.Content\").mouseenter();");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('$Prefix button.CallForAction:visible').length;",
        );
        $Selenium->find_element( "$Prefix button.CallForAction", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && !\$('$Prefix .Overlay:visible').length;",
        );

        $Selenium->WaitFor(
            JavaScript => "return \$('#Checkbox_DeployTestCheckbox:visible').length;",
        );
        $Selenium->find_element( "#Checkbox_DeployTestCheckbox", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return \$('#Checkbox_DeployTestCheckbox:checked').length;",
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "$Prefix button.Update",
        );
        $Selenium->find_element( $Prefix . ' button.Update', 'css' )->click();

        $Selenium->WaitFor(
            ElementExists => '//a[contains(@href,"Subaction=Deployment")]',
        );
        $Selenium->find_element('//a[contains(@href,"Subaction=Deployment")]')->VerifiedClick();

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#DeploymentStart",
        );

        # Open the deployment dialog, exceeding its maximum length and check for the error.
        $Selenium->execute_script('window.Core.App.PageLoadComplete = false;');
        $Selenium->find_element( "#DeploymentStart", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('#DeploymentComment:visible').length == 1;",
        );
        $Selenium->find_element( "#DeploymentComment", 'css' )->send_keys( 'A' x 251 );

        $Selenium->WaitFor(
            JavaScript => "return \$('#DialogDeployment .Overlay.Preparing:visible').length == 0;",
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => ".ButtonsRegular #Deploy",
        );
        $Selenium->find_element( "#Deploy", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$('#DeploymentComment.Error').length;",
        );
        $Self->True(
            $Selenium->execute_script("return \$('#DeploymentComment.Error').length;"),
            "Deployment dialog contains the error class.",
        );

        # Delete a character, try again and check if deployment was successful.
        $Selenium->find_element( "#DeploymentComment", 'css' )->clear();
        $Selenium->find_element( "#DeploymentComment", 'css' )->send_keys( 'A' x 250 );
        $Selenium->find_element( "#Deploy",            'css' )->click();

        # Wait until redirect has been finished.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        # Verify setting is correctly deployed.
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );
        $Self->Is(
            $Setting{IsDirty},
            0,
            "$SettingName setting is changed and deployed successfully.",
        );
    }
);

$Self->DoneTesting();
