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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AdminSystemConfiguration screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration"
        );

        if ( $Kernel::OM->Get('Kernel::Config')->Get('ConfigImportAllowed') ) {

            # Click on Import/Export button.
            $Selenium->find_element( '.fa-exchange', 'css' )->click();

            # Make sure that import button is on the page.
            $Selenium->find_element( '#ImportButton', 'css' );

            # Make sure that export button is on the page.
            $Selenium->find_element( '#ExportButton', 'css' );

            # Disable import.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'ConfigImportAllowed',
                Value => 0,
            );

            # Refresh the screen.
            $Selenium->VerifiedRefresh();

            # Make sure that export button is on the page.
            $Selenium->find_element( '#ExportButton', 'css' );

        }

        # Make sure that import button is not on the page.
        $Self->False(
            $Selenium->execute_script('return $("#ImportButton").length;') // 0,
            'Import button not found'
        );
    }
);

$Self->DoneTesting();
