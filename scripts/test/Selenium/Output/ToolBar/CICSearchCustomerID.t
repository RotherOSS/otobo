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

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # enable tool bar CICSearchCustomerID
        my %CICSearchCustomerID = (
            Block       => 'ToolBarCICSearchCustomerID',
            CSS         => 'Core.Agent.Toolbar.CICSearch.css',
            Description => 'CustomerID search',
            Module      => 'Kernel::Output::HTML::ToolBar::Generic',
            Name        => 'CustomerID search',
            Priority    => '1990030',
            Size        => '10',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Frontend::ToolBarModule###13-Ticket::CICSearchCustomerID',
            Value => \%CICSearchCustomerID,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###13-Ticket::CICSearchCustomerID',
            Value => \%CICSearchCustomerID,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test company
        my $TestCustomerID    = $Helper->GetRandomID() . 'CID';
        my $TestCompanyName   = 'Company' . $Helper->GetRandomID();
        my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID             => $TestCustomerID,
            CustomerCompanyName    => $TestCompanyName,
            CustomerCompanyStreet  => '5201 Blue Lagoon Drive',
            CustomerCompanyZIP     => '33126',
            CustomerCompanyCity    => 'Miami',
            CustomerCompanyCountry => 'USA',
            CustomerCompanyURL     => 'http://www.example.org',
            CustomerCompanyComment => 'some comment',
            ValidID                => 1,
            UserID                 => $TestUserID,
        );

        $Self->True(
            $CustomerCompanyID,
            "CustomerCompany is created - ID $CustomerCompanyID",
        );

        # create test customer
        my $TestCustomerLogin = 'Customer' . $Helper->GetRandomID();
        my $CustomerID        = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomerLogin,
            UserLastname   => $TestCustomerLogin,
            UserCustomerID => $TestCustomerID,
            UserLogin      => $TestCustomerLogin,
            UserEmail      => $TestCustomerLogin . '@localhost.com',
            ValidID        => 1,
            UserID         => $TestUserID,
        );

        $Self->True(
            $CustomerID,
            "CustomerUser is created - ID $CustomerID",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # input test user in search CustomerID
        $Selenium->find_element( "#ToolBarCICSearchCustomerID", 'css' )->send_keys($TestCustomerID);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomerID)').click()");

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' &&  \$('tbody a:contains($TestCustomerLogin)').length;"
        );

        $Self->True(
            $Selenium->execute_script("return \$('tbody a:contains($TestCustomerLogin)').length;"),
            "Search by CustomerID success - found $TestCustomerLogin",
        );

        $Self->True(
            $Selenium->find_element( '#CustomerInformationCenterHeading', 'css' ),
            "Check heading for CustomerInformationCenter",
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete test customer company
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
            Bind => [ \$CustomerCompanyID ],
        );
        $Self->True(
            $Success,
            "CustomerCompany is deleted - ID $CustomerCompanyID",
        );

        # delete test customer
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE customer_id = ?",
            Bind => [ \$CustomerID ],
        );
        $Self->True(
            $Success,
            "CustomerUser is deleted - ID $CustomerID",
        );

        # make sure the cache is correct
        for my $Cache (
            qw (CustomerCompany CustomerUser)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

$Self->DoneTesting();
