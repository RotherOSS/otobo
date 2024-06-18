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

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test customer users.
        my @CustomerUserLogins;
        for my $Count ( 1 .. 2 ) {
            my $CustomerUser   = "CustomerUser-$Count-$RandomID";
            my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => $CustomerUser,
                UserLastname   => $CustomerUser,
                UserCustomerID => $CustomerUser,
                UserLogin      => $CustomerUser,
                UserEmail      => "$CustomerUser\@localhost.com",
                ValidID        => 1,
                UserID         => 1,
            );
            $Self->True(
                $CustomerUserID,
                "CustomerUserID $CustomerUserID is created"
            );
            push @CustomerUserLogins, $CustomerUser;
        }

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketPhone screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # Type to match only the first customer user,
        # add a character to close autocomplete and check if input field entry is still there,
        # remove added character to autocomplete appers again and select matched entry.
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys("1-$RandomID");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys("A");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("li.ui-menu-item:visible").length' );

        $Self->Is(
            $Selenium->find_element( "#FromCustomer", 'css' )->get_value(),
            "1-${RandomID}A",
            "'FromCustomer' input field has correct value - 1-${RandomID}A",
        );

        # Use Backspace key to remove the last character 'A'.
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys("\N{U+E003}");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );

        # Use Down key to fill input field from autocomplete and then click Enter key.
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys("\N{U+E015}");
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys("\N{U+E007}");

        $Selenium->WaitFor(
            JavaScript => 'return $("#CustomerSelected_1").length && !$(".AJAXLoader:visible").length'
        );

        # Type to match only the second customer user,
        # add a character to close autocomplete and check if input field entry is still there.
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys("2-$RandomID");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys("A");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("li.ui-menu-item:visible").length' );

        $Self->Is(
            $Selenium->find_element( "#FromCustomer", 'css' )->get_value(),
            "2-${RandomID}A",
            "'FromCustomer' input field has correct value - 2-${RandomID}A",
        );

        # Delete created test customer user.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        for my $CustomerUser (@CustomerUserLogins) {
            $CustomerUser = $DBObject->Quote($CustomerUser);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$CustomerUser ],
            );
            $Self->True(
                $Success,
                "CustomerUser $CustomerUser is deleted",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'CustomerUser' );

    }
);

$Self->DoneTesting();
