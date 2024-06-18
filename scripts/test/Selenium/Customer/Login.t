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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable autocomplete in login form.
        $Helper->ConfigSettingChange(
            Key   => 'DisableLoginAutocomplete',
            Value => 1,
        );

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # first load the login page so we can delete any pre-existing cookies
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl");
        $Selenium->delete_all_cookies();

        # Check Secure::DisableBanner functionality.
        # This test is a leftover from the old costomer login page,
        # as in the current version there is no check for Secure::DisabledBanner.
        my %SourceChecks = (
            PoweredBy => qr{powered by.{5,30}https://otobo\.io}s,
        );
        my $Product = $Kernel::OM->Get('Kernel::Config')->Get('Product');
        my $Version = $Kernel::OM->Get('Kernel::Config')->Get('Version');

        for my $Disabled ( 1, 0 ) {
            $Helper->ConfigSettingChange(
                Key   => 'Secure::DisableBanner',
                Value => $Disabled,
            );
            $Selenium->VerifiedRefresh();

            my $PageSource = $Selenium->get_page_source();

            for my $CheckName ( sort keys %SourceChecks ) {
                like( $PageSource, $SourceChecks{$CheckName}, "$CheckName matches" );
            }

            # Prevent version information disclosure on login page.
            is(
                index( $PageSource, "$Product $Version" ),
                -1,
                "No version information disclosure ($Product $Version)",
            );
        }

        # Check if autocomplete is disabled in login form.
        ok(
            $Selenium->find_element("//input[\@name=\'User\'][\@autocomplete=\'off\']"),
            'Autocomplete for username input field is disabled.'
        );
        ok(
            $Selenium->find_element("//input[\@name=\'Password\'][\@autocomplete=\'off\']"),
            'Autocomplete for password input field is disabled.'
        );

        my $InputUser = $Selenium->find_element( 'input#User', 'css' );
        $InputUser->is_displayed();
        $InputUser->is_enabled();
        $InputUser->send_keys($TestCustomerUserLogin);

        my $InputPassword = $Selenium->find_element( 'input#Password', 'css' );
        $InputPassword->is_displayed();
        $InputPassword->is_enabled();
        $InputPassword->send_keys($TestCustomerUserLogin);

        # login
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # In the customer interface there is a data privacy blurb that must be accepted.
        # Note that find_element_by_xpath() does not throw exceptions.
        # The method returns 0 when the element is not found.
        {
            my $AcceptGDPRLink = $Selenium->find_element_by_xpath(q{//a[@id="AcceptGDPR"]});
            if ($AcceptGDPRLink) {
                $AcceptGDPRLink->click();
            }
        }

        # check if login is successful
        $Selenium->WaitFor(
            ElementExists => q{//div[@class='oooLogout']/a[@title='Logout']}
        );

        my $ButtonLogout = $Selenium->find_element_by_xpath(q{//a[@id='oooAvatar']});
        ok( $ButtonLogout, 'logout button found' );

        # Check for footer, even though it is not visible
        my $PageSource = $Selenium->get_page_source();
        for my $CheckName ( sort keys %SourceChecks ) {
            like( $PageSource, $SourceChecks{$CheckName}, "$CheckName matches" );
        }

        # Enable autocomplete in login form.
        $Helper->ConfigSettingChange(
            Key   => 'DisableLoginAutocomplete',
            Value => 0,
        );

        # logout again
        if ($ButtonLogout) {
            $ButtonLogout->VerifiedClick();
        }
        else {
            fail('Logout button is not available');
        }

        # Check if autocomplete is enabled in login form.
        ok(
            $Selenium->find_element_by_xpath("//input[\@name=\'User\'][\@autocomplete=\'username\']"),
            'Autocomplete for username input field is enabled.'
        );
        ok(
            $Selenium->find_element_by_xpath("//input[\@name=\'Password\'][\@autocomplete=\'current-password\']"),
            'Autocomplete for password input field is enabled.'
        );

        # check login page
        my $InputUser2 = $Selenium->find_element_by_css('input#User');
        ok( $InputUser2, 'user input field found' );
        if ($InputUser2) {
            $InputUser2->is_displayed();
            $InputUser2->is_enabled();
            $InputUser2->send_keys($TestCustomerUserLogin);
        }
    }
);

done_testing();
