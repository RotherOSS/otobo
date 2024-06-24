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

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # disable frontend AdminCustomerCompany module
        my $AdminCustomerCompany = $ConfigObject->Get('Frontend::Module')->{AdminCustomerCompany};
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Frontend::Module###AdminCustomerCompany',
            Value => {},
        );

        # check for NavBarCustomerCompany button when frontend AdminCustomerCompany module is disabled
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");
        $Self->True(
            index( $Selenium->get_page_source(), 'AdminCustomerCompany;Nav=Agent' ) == -1,
            "NavBar 'Customer Administration' button NOT available when frontend AdminCustomerCompany module is disabled",
        );

        # enable frontend AdminCustomerCompany module
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::Module###AdminCustomerCompany',
            Value => $AdminCustomerCompany,
        );

        # check for NavBarCustomerCompany button when frontend AdminCustomerCompany module is enabled
        $Selenium->VerifiedRefresh();
        $Self->True(
            index( $Selenium->get_page_source(), 'AdminCustomerCompany;Nav=Agent' ) > -1,
            "NavBar 'Customer Administration' button IS available when frontend AdminCustomerCompany module is enable",
        );
    }
);

$Self->DoneTesting();
