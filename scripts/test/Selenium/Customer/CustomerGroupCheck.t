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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

# get selenium object
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
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
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

        # create two test customer companies
        my ( @CustomerIDs, @GroupIDs, @QueueIDs );
        for my $Count ( 1 .. 2 ) {
            my $CustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
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
                "Added customer company to group $CustomerCompanyID",
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

        # create test ticket and set it to second customer id
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => $CustomerIDs[1],
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $CustomerIDs[1],
            CustomerUser => '',                    # empty
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # login test customer user
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        $Self->True(
            index( $Selenium->get_page_source(), 'No Permission' ) > -1,
            'Customer does not have permission for test ticket',
        );

        # add first customer company to second group with RW permissions
        my $Success = $CustomerGroupObject->GroupCustomerAdd(
            GID        => $GroupIDs[1],
            CustomerID => $CustomerIDs[0],
            Permission => {
                $PermissionContextDirect => {
                    rw => 1,
                },
                $PermissionContextOtherCustomerID => {
                    rw => 1,
                },
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Added customer company $CustomerIDs[0] to group $GroupIDs[1]",
        );

        # refresh the page
        $Selenium->VerifiedRefresh();

        # check ticket data
        $Selenium->LogExecuteCommandActive(0);
        $Selenium->content_contains( $TicketNumber,       "Ticket number is $TicketNumber" );
        $Selenium->content_contains( 'Some Ticket Title', "Ticket title is 'Some Ticket Title'" );
        $Selenium->content_contains( $CustomerIDs[1],     "Queue is $CustomerIDs[1] in Ticket Information" );

        # check buttons
        $Selenium->find_element_by_xpath_ok(q{//div[@id='oooHeader']/button[@id='ReplyButton']});
        $Selenium->find_element_by_xpath_ok(q{//button[contains(@value, 'Submit' )]});
        $Selenium->LogExecuteCommandActive(1);

        # clean up test data from the DB
        $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - $TicketID",
        );

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
                SQL => "DELETE FROM queue WHERE id = $QueueID",
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
                SQL => "DELETE FROM group_customer WHERE group_id = $GroupID",
            );
            if ($Success) {
                $Self->True(
                    $Success,
                    "Deleted Customer Group - $GroupID",
                );
            }

            $Success = $DBObject->Do(
                SQL => "DELETE FROM groups_table WHERE id = $GroupID",
            );
            $Self->True(
                $Success,
                "Deleted Group - $GroupID",
            );
        }

        # make sure the cache is correct
        for my $Cache (
            qw(Group CustomerGroup CustomerCompany Queue Ticket)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => $Cache );
        }
    },
);

done_testing();
