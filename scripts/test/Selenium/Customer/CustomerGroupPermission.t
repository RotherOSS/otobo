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

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # enable customer group support
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerGroupSupport',
            Value => 1,
        );

        # create test customer
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # create test tickets
        my @TicketIDs;
        my @TicketNumbers;
        for my $TestTickets ( 1 .. 5 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Selenium Test Ticket',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => $TestCustomerUserLogin,
                CustomerUser => $TestCustomerUserLogin,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID, TN $TicketNumber ",
            );
            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;
        }

        # create test group
        my $GroupName = 'Group' . $Helper->GetRandomID();
        my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Group is created - $GroupName",
        );

        # Disable frontend service module.
        my $FrontendCustomerTicketOverview
            = $Kernel::OM->Get('Kernel::Config')->Get('CustomerFrontend::Navigation')->{CustomerTicketOverview}
            ->{'002-Ticket'};

        # Change the group for the CompanyTickets.
        for my $Item ( @{$FrontendCustomerTicketOverview} ) {
            if ( $Item->{Name} eq 'Company Tickets' ) {
                push @{ $Item->{Group} }, $GroupName;
            }
        }

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerFrontend::Navigation###CustomerTicketOverview###002-Ticket',
            Value => $FrontendCustomerTicketOverview,
        );

        # login test customer user
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to CompanyTickets subaction screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketOverview;Subaction=CompanyTickets");

        # check for customer user fatal error
        my $ExpectedMsg = 'Please contact the administrator.';
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedMsg ) > -1,
            "Customer fatal error message - found",
        );

        # set customer user in test group with rw and ro permissions
        my $Success = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberAdd(
            GID        => $GroupID,
            UID        => $TestCustomerUserLogin,
            Permission => {
                ro => 1,
                rw => 1,
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            "CustomerUser $TestCustomerUserLogin added to test group $GroupName with ro and rw rights"
        );

        # navigate to CompanyTickets subaction screen again
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketOverview;Subaction=CompanyTickets");

        # verify there is no more customer fatal message
        $Self->True(
            index( $Selenium->get_page_source(), $ExpectedMsg ) == -1,
            "Customer fatal error message - not found",
        );

        # check for test ticket numbers on search screen
        for my $CheckTicketNumbers (@TicketNumbers) {
            $Self->True(
                index( $Selenium->get_page_source(), $CheckTicketNumbers ) > -1,
                "TicketNumber $CheckTicketNumbers - found on screen"
            );
        }

        # delete test created group
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $Success = $DBObject->Do(
            SQL => "DELETE FROM group_customer_user WHERE group_id = $GroupID",
        );
        if ($Success) {
            $Self->True(
                $Success,
                "$GroupName - GroupCustomerUserDelete",
            );
        }

        $GroupName = $DBObject->Quote($GroupName);
        $Success   = $DBObject->Do(
            SQL  => "DELETE FROM groups_table WHERE name = ?",
            Bind => [ \$GroupName ],
        );
        $Self->True(
            $Success,
            "Delete group - $GroupName",
        );

        # delete created test tickets
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
                "Delete ticket - $TicketID"
            );
        }

        # make sure the cache is correct
        for my $Cache (
            qw (Ticket CustomerGroup Group )
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

$Self->DoneTesting();
