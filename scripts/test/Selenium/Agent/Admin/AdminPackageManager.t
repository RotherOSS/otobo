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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');
my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

my @List = $PackageObject->RepositoryList(
    Result => 'short',
);
my $NumberOfPackagesInstalled = scalar @List;

# Skip the test if there is more then 8 packages installed (8 because of SaaS scenarios).
# TODO: fix the main issue with "unexpected alert open".
if ( $NumberOfPackagesInstalled > 8 ) {
    skip_all("Found $NumberOfPackagesInstalled packages installed, skipping test...");
}

# Make sure to enable cloud services.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CloudServices::Disabled',
    Value => 0,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Package::AllowNotVerifiedPackages',
    Value => 0,
);

# Override Request() from WebUserAgent to always return some test data without making any
# actual web service calls. This should prevent instability in case cloud services are
# unavailable at the exact moment of this test run.
# Furthermore there are other test scripts that use the trick of modifying
# The content is XML as expected in Module: Kernel::System::Package::PackageOnlineRepositories().
# the Kernel::System::WebUserAgent::Request() method. This means that these overrides
# might still be active in the running web server and we get very strange results.
my $RandomID = $Helper->GetRandomID();
my $XML      = <<'END_XML';
<?xml version="1.0" encoding="utf-8" ?>
<otrs_repository_list version="1.0">
<Repository>
    <Name>OTOBO Addons</Name>
    <URL>https://otobo.de/</URL>
</Repository>
</otrs_repository_list>
END_XML
my $CustomCode = sprintf <<'END_CODE', $RandomID, $XML;

# provide a  no-op Load() method as this is expected in Kernel::Config::Defaults
sub Kernel::Config::Files::ZZZZUnitTestAdminPackageManager%s::Load {}

use Kernel::System::WebUserAgent;

package Kernel::System::WebUserAgent;

use strict;
use warnings;

## nofilter(TidyAll::Plugin::OTOBO::Perl::TestSubs)
{
    no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)

    my $xml = q^%s^;

    sub Request {
        return (
            Status  => '200 OK',
            Content => \$xml,
        );
    }
}
1;
END_CODE

$Helper->CustomCodeActivate(
    Code       => $CustomCode,
    Identifier => 'AdminPackageManager' . $RandomID,
);

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

sub CheckBreadcrumb {
    my %Param = @_;

    my $BreadcrumbText = $Param{BreadcrumbText} || '';
    my $Count          = 1;

    for my $BreadcrumbText ( 'Package Manager', "$BreadcrumbText Test" ) {
        $Self->Is(
            $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
            $BreadcrumbText,
            "Breadcrumb text '$BreadcrumbText' is found on screen"
        );

        $Count++;
    }

    return;
}

sub NavigateToAdminPackageManager {

    # Wait until all AJAX calls finished.
    $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

    # Go back to overview.
    # Navigate to AdminPackageManager screen.
    my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
    $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPackageManager");
    $Selenium->WaitFor(
        Time       => 120,
        JavaScript =>
            'return typeof($) == "function" && $("#FileUpload").length;'
    );

    return;
}

sub ClickAction {
    my ($Selector) = @_;

    $Selenium->execute_script('window.Core.App.PageLoadComplete = false;');
    $Selenium->find_element($Selector)->click();
    $Selenium->WaitFor(
        Time       => 120,
        JavaScript =>
            'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
    );

    return;
}

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # For the sake of stability, check if test package is already installed.
        my $TestPackage = $PackageObject->RepositoryGet(
            Name            => 'Test',
            Version         => '0.0.1',
            DisableWarnings => 1,
        );

        # If test package is installed, remove it so we can install it again.
        if ($TestPackage) {
            my $PackageUninstall = $PackageObject->PackageUninstall( String => $TestPackage );
            $Self->True(
                $TestPackage,
                'Test package is uninstalled'
            );
        }

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die 'Did not get test user';

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPackageManager");

        # Check if needed frontend module is registered in sysconfig.
        if ( !$ConfigObject->Get('Frontend::Module')->{AdminPackageManager} ) {
            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    'Module Kernel::Modules::AdminPackageManager not registered in Kernel/Config.pm!'
                ) > 0,
                'Module AdminPackageManager is not registered in sysconfig, skipping test...'
            );

            return 1;
        }

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            'Breadcrumb is found on Overview screen'
        );

        # Check overview AdminPackageManager.
        my $Element = $Selenium->find_element( '#FileUpload', 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # Install test package.
        my $Location = $ConfigObject->Get('Home') . '/scripts/test/sample/PackageManager/TestPackage.opm';

        $Selenium->find_element( '#FileUpload', 'css' )->send_keys($Location);

        ClickAction("//button[contains(.,'Install Package')]");

        # Check breadcrumb on Install screen.
        CheckBreadcrumb(
            BreadcrumbText => 'Install Package:',
        );

        # Package is not verified, so it's not possible to continue with the installation.
        $Self->Is(
            $Selenium->execute_script("return \$('button[type=\"submit\"][value=\"Continue\"]').length"),
            '0',
            'Continue button not available because package is not verified'
        );

        $Self->True(
            index(
                $Selenium->get_page_source(),
                'The installation of packages which are not verified is disabled.'
            ) > 0,
            'Message for aborting installation of package is displayed'
        );

        # Continue with package installation.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Package::AllowNotVerifiedPackages',
            Value => 1,
        );

        NavigateToAdminPackageManager();

        # The notification PackageManagerCheckNotVerifiedPackages.pm no longer exists in OTOBO.
        # This means that there is no warning about unverified packages.
        #$Self->True(
        #    $Selenium->execute_script(
        #        'return $("div.MessageBox.Error p:contains(\'The installation of packages which are not verified by the OTOBO Team is activated. '
        #        . 'These packages could threaten your whole system! It is recommended not to use unverified packages.\')").length',
        #    ),
        #    'Install warning for not verified packages is displayed',
        #);

        $Selenium->find_element( '#FileUpload', 'css' )->send_keys($Location);

        $Selenium->execute_script('window.Core.App.PageLoadComplete = false;');
        $Selenium->find_element("//button[contains(.,'Install Package')]")->click();
        $Selenium->WaitFor(
            Time       => 120,
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        CheckBreadcrumb(
            BreadcrumbText => 'Install Package:',
        );

        ClickAction("//button[\@value='Continue'][\@type='submit']");

        my $PackageCheck = $PackageObject->PackageIsInstalled(
            Name => 'Test',
        );
        $Self->True(
            $PackageCheck,
            'Test package is installed'
        );

        NavigateToAdminPackageManager();

        # Load page with metadata of installed package.
        ClickAction("//a[contains(.,'Test')]");

        # Check breadcrumb on Package metadata screen.
        CheckBreadcrumb(
            BreadcrumbText => 'Package Information:',
        );

        NavigateToAdminPackageManager();

        # Uninstall package.
        ClickAction("//a[contains(\@href, \'Subaction=Uninstall;Name=Test' )]");

        # Check breadcrumb on uninstall screen.
        CheckBreadcrumb(
            BreadcrumbText => 'Uninstall Package:',
        );

        ClickAction("//button[\@value='Uninstall package'][\@type='submit']");

        # Check if test package is uninstalled.
        $Self->True(
            index( $Selenium->get_page_source(), 'Subaction=View;Name=Test' ) == -1,
            'Test package is uninstalled'
        );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminPackageManager;Subaction=View;Name=NonexistingPackage;Version=0.0.1"
        );

        $Selenium->find_element( 'div.ErrorScreen', 'css' );

        NavigateToAdminPackageManager();

        # Try to install incompatible test package.
        $Location = $ConfigObject->Get('Home') . '/scripts/test/sample/PackageManager/TestPackageIncompatible.opm';
        $Selenium->find_element( '#FileUpload', 'css' )->send_keys($Location);

        ClickAction("//button[contains(.,'Install Package')]");

        ClickAction("//button[\@value='Continue'][\@type='submit']");

        # Check if info for incompatible package is shown.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.WidgetSimple .Content h2:contains(\"Package installation requires a patch level update of OTOBO\")').length;"
            ),
            'Info for incompatible package is shown'
        );

        # Create a repository list with a broken URL, taking care that the OTOBO repository list is not used
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Package::RepositoryList',
            Value => {
                'ftp://ftp.example.com/pub/otobo/misc/packages/' => '[AdminPackageManager.t] ftp://ftp.example.com/'
            },
        );
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Package::RepositoryRoot',
        );

        # Try to load packages from the single entry in the repository list.
        # No packages should be loaded, as ftp.example.com isn't an OTOBO package repository.
        NavigateToAdminPackageManager();
        ClickAction("//button[\@name=\'GetRepositoryList']");

        # Check that there is a notification about no packages.
        my $Notification = 'No packages found in selected repository. Please check log for more info!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );
    }
);

# Do an implicit cleanup of the test package, in case it's still present in the system.
#   If Selenium Run() method above fails because of an error, it will not proceed to uninstall the test package in an
#   interactive way. Here we check for existence of the test package, and remove it only if it's found.
my $TestPackage = $PackageObject->RepositoryGet(
    Name            => 'Test',
    Version         => '0.0.1',
    DisableWarnings => 1,
);
if ($TestPackage) {
    my $PackageUninstall = $PackageObject->PackageUninstall( String => $TestPackage );
    $Self->True(
        $TestPackage,
        'Test package is cleaned up'
    );
}

done_testing();
