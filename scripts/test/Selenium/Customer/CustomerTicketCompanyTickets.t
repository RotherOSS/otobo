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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
        my $CustomerGroupObject   = $Kernel::OM->Get('Kernel::System::CustomerGroup');
        my $GroupObject           = $Kernel::OM->Get('Kernel::System::Group');
        my $QueueObject           = $Kernel::OM->Get('Kernel::System::Queue');
        my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $TestCustomerUserLogin,
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupAlwaysGroups',
            Value => [],
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupCompanyAlwaysGroups',
            Value => [],
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1,
        );
        my $PermissionContextDirect          = 'UnitTestPermission-direct';
        my $PermissionContextOtherCustomerID = 'UnitTestPermission-other-CustomerID';
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupPermissionContext',
            Value => {
                '001-CustomerID-same'  => { Value => $PermissionContextDirect },
                '100-CustomerID-other' => { Value => $PermissionContextOtherCustomerID },
            },
        );
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'CustomerGroupPermissionContext',
            Value => {
                '001-CustomerID-same'  => { Value => $PermissionContextDirect },
                '100-CustomerID-other' => { Value => $PermissionContextOtherCustomerID },
            },
        );

        my $CustomerCompanyID;

        # create two tickets and customer companies
        my ( @CustomerIDs, @GroupIDs, @QueueIDs, @TicketNumbers, @TicketIDs );
        for my $Count ( 1 .. 2 ) {
            $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
                CustomerID          => "$TestCustomerUserLogin-$Count",
                CustomerCompanyName => "$TestCustomerUserLogin-$Count",
                ValidID             => 1,
                UserID              => 1,
            );
            $Self->True(
                $CustomerCompanyID,
                "Created test customer company $CustomerCompanyID",
            );
            push @CustomerIDs, $CustomerCompanyID;

            # create test group
            my $GroupID = $GroupObject->GroupAdd(
                Name    => $CustomerCompanyID,
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $GroupID,
                "Created test group $CustomerCompanyID ($GroupID)",
            );
            push @GroupIDs, $GroupID;

            # add customer relations
            my $Success = $CustomerGroupObject->GroupCustomerAdd(
                GID        => $GroupID,
                CustomerID => $CustomerCompanyID,
                Permission => {
                    $PermissionContextDirect => {
                        ro => 1,
                    },
                },
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Added customer company to group $CustomerCompanyID ($GroupID)",
            );

            # create test queue
            my $QueueID = $QueueObject->QueueAdd(
                Name            => $CustomerCompanyID,
                ValidID         => 1,
                GroupID         => $GroupID,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                UserID          => 1,
            );
            $Self->True(
                $QueueID,
                "Created test queue $CustomerCompanyID ($QueueID)",
            );
            push @QueueIDs, $QueueID;

            # create test ticket
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => $CustomerCompanyID,
                Queue        => $CustomerCompanyID,
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerUser => '',                   # empty
                CustomerID   => $CustomerCompanyID,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Created test ticket $CustomerCompanyID ($TicketID)",
            );
            push @TicketNumbers, $TicketNumber;
            push @TicketIDs,     $TicketID;
        }

        # add customer user to first company
        my %CustomerUser = $CustomerUserObject->CustomerUserDataGet(
            User => $TestCustomerUserLogin,
        );
        my $CustomerUserUpdate = $CustomerUserObject->CustomerUserUpdate(
            ID             => $TestCustomerUserLogin,
            UserLogin      => $CustomerUser{UserLogin},
            UserFirstname  => $CustomerUser{UserFirstname},
            UserLastname   => $CustomerUser{UserLastname},
            UserEmail      => $CustomerUser{UserEmail},
            UserCustomerID => $CustomerIDs[0],
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $CustomerUserUpdate,
            "Added customer user to customer company $CustomerIDs[0]",
        );

        # add first customer company to second group
        my $Success = $CustomerGroupObject->GroupCustomerAdd(
            GID        => $GroupIDs[1],
            CustomerID => $CustomerIDs[0],
            Permission => {
                $PermissionContextOtherCustomerID => {
                    ro => 1,
                },
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Added customer company $CustomerIDs[0] to group $GroupIDs[1]",
        );

        # login test customer user
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketOverview;Subaction=CompanyTickets");

        # Wait until new screen has loaded.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#oooMainBox .oooTicketList a').length;" );

        # search for both tickets on Company Tickets screen (default filter is Open)
        for my $Count ( 0 .. 1 ) {
            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumbers[$Count]' )]"
                ),
                "Ticket with ticket number $TicketNumbers[$Count] is found on screen with Open filter",
            );
        }

        # check customer filter selection on Company Tickets screen
        # Looks like in the new customer interface there is no selection by customer
        #for my $Count ( 0 .. 1 ) {
        if (0) {
            my $Count = 0;

            $Selenium->execute_script('window.Core.App.PageLoadComplete = false;');

            # select customer company
            $Selenium->InputFieldValueSet(
                Element => '#CustomerIDs',
                Value   => $CustomerIDs[$Count],
            );

            # Wait until new screen has loaded.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
            );

            $Self->True(
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumbers[$Count]' )]"
                ),
                "Ticket with ticket number $TicketNumbers[$Count] is found on screen with $CustomerIDs[$Count] filter",
            );

            $Self->True(
                index( $Selenium->get_page_source(), "Action=CustomerTicketZoom;TicketNumber=$TicketNumbers[!$Count]" )
                    == -1,
                "Ticket with ticket number $TicketNumbers[!$Count] is not found on screen with $CustomerIDs[$Count] filter",
            );
        }

        # CustomerCompanyFilter resets on next page. See bug#14852.
        # Create many test tickets that don't fit on a single page.
        for ( 1 .. 35 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => $CustomerCompanyID,
                Queue        => $CustomerCompanyID,
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerUser => '',                   # empty
                CustomerID   => $CustomerCompanyID,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Created test ticket $CustomerCompanyID ($TicketID)",
            );

            push @TicketIDs, $TicketID;
        }

        # Go to Company tickets.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketOverview;Subaction=CompanyTickets");

        # Wait until new screen has loaded.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#oooMainBox .oooTicketList a').length" );

        $Selenium->execute_script('window.Core.App.PageLoadComplete = false;');

        # Select Company.
        # Looks like in the new customer interface there is no selection by customer
        #$Selenium->InputFieldValueSet(
        #    Element => '#CustomerIDs',
        #    Value   => $CustomerCompanyID,
        #);

        #$Selenium->WaitFor(
        #    Time => 20,
        #    JavaScript =>
        #        'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        #);

        # go to the second page
        $Selenium->find_element( '#CustomerTicketOverviewPage2', 'css' )->VerifiedClick();

        # Wait until new screen has loaded.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#CustomerTicketOverviewPage2.Selected').length" );

        # Check if on second page.
        $Self->Is(
            $Selenium->execute_script("return \$('#CustomerTicketOverviewPage2').hasClass('Selected')"),
            1,
            "Correct page is shown.",
        );

        # Check if company filter preserve previously selected company.
        # Looks like in the new customer interface there is no selection by customer
        #$Self->Is(
        #    $Selenium->execute_script("return \$('#CustomerIDs').val()[0];"),
        #    $CustomerCompanyID,
        #    "Correct CustomerCompanyID is selected in filter."
        #);

        # Looks like in the new customer interface there is no selection by customer
        #$Selenium->WaitFor( JavaScript => "return \$('#BottomActionRow a[href*=\"Filter=All\"]').length;" );

        # Set filter to All ticket by company.
        # Looks like in the new customer interface there is no selection by customer
        #$Selenium->find_element("//div[contains(\@id, \'BottomActionRow')]//ul//li//a[contains(\@href, 'Filter=All' )]")->VerifiedClick();

        # Wait until new screen has loaded.
        # Looks like in the new customer interface there is no selection by customer
        #$Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function';" );

        # Check if company filter preserve previously selected company.
        #$Self->Is(
        #    $Selenium->execute_script("return \$('#CustomerIDs').val()[0];"),
        #    $CustomerCompanyID,
        #    "Correct CustomerCompanyID is selected in filter."
        #);

        # clean up test data from the DB
        for my $TicketID (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "Ticket with ticket ID $TicketID is deleted",
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        for my $CustomerID (@CustomerIDs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_company WHERE customer_id = ?",
                Bind => [ \$CustomerID ],
            );
            $Self->True(
                $Success,
                "Deleted Customer - $CustomerID",
            );
        }

        for my $QueueID (@QueueIDs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$QueueID ],
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "Deleted Queue - $QueueID",
                );
            }
        }

        for my $GroupID (@GroupIDs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM group_customer WHERE group_id = ?",
                Bind => [ \$GroupID ],
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "Deleted Customer Group - $GroupID",
                );
            }

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM groups_table WHERE id = ?",
                Bind => [ \$GroupID ],
            );
            $Self->True(
                $Success,
                "Deleted Group - $GroupID",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # make sure the cache is correct
        for my $Cache (
            qw(Group CustomerGroup CustomerCompany Queue Ticket)
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

$Self->DoneTesting();
