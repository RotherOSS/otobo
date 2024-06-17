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

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

        # Get sort attributes config params.
        my %SortOverview = (
            Age          => 1,
            Title        => 1,
            TicketNumber => 1,
        );

        # Defines from which ticket attributes the agent can select the result order.
        $Helper->ConfigSettingChange(
            Key   => 'TicketOverviewMenuSort###SortAttributes',
            Value => \%SortOverview,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TicketOverviewMenuSort###SortAttributes',
            Value => \%SortOverview,
        );

        # Override FirstnameLastnameOrder setting to check if it is taken into account
        #   (see bug#12554 for more information).
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'FirstnameLastnameOrder',
            Value => 3,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Get user data.
        my %TestUser = $UserObject->GetUserData(
            UserID => $TestUserID,
        );

        # Create test queue.
        my $QueueName = 'Queue' . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => $TestUserID,
        );
        $Self->True(
            $QueueID,
            "QueueAdd() successful for test $QueueName - ID $QueueID",
        );

        # Create test tickets.
        my @TicketIDs;
        my @TicketNumbers;
        for my $Ticket ( 1 .. 15 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Some Ticket Title',
                Queue        => $QueueName,
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => 'TestCustomer',
                CustomerUser => 'customer@example.com',
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID"
            );

            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;
        }
        my @SortTicketNumbers = sort @TicketNumbers;

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Go to queue ticket overview.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$QueueID;View=");

        # Switch to medium view.
        $Selenium->find_element( "a.Medium", 'css' )->VerifiedClick();

        # Check if owner name conforms to current FirstnameLastNameOrder setting.
        $Self->True(
            index( $Selenium->get_page_source(), $TestUser{UserFullname} ) > -1,
            "$TestUser{UserFullname} - found on screen"
        );

        # Sort by ticket number.
        $Selenium->InputFieldValueSet(
            Element => '#SortBy',
            Value   => 'TicketNumber|Up',
        );

        # Wait for page reload after changing sort param.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("a[href*=\'SortBy=TicketNumber;OrderBy=Up\']").length'
        );
        $Selenium->VerifiedRefresh();

        # Set 10 tickets per page.
        $Selenium->find_element( "a#ShowContextSettingsDialog", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $(".Dialog.Modal #UserTicketOverviewMediumPageShown").length'
        );
        $Selenium->InputFieldValueSet(
            Element => '#UserTicketOverviewMediumPageShown',
            Value   => '10',
        );
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return !$(".Dialog.Modal").length'
        );

        # Check for ticket with lowest ticket number on first 1st page and verify that ticket
        # with highest ticket number is not present.
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[0] ) > -1,
            "$SortTicketNumbers[0] - found on screen"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) == -1,
            "$SortTicketNumbers[14] - not found on screen"
        );

        # Switch to 2nd page to test pagination.
        $Selenium->find_element( "#AgentTicketQueuePage2", 'css' )->VerifiedClick();

        # Check for ticket with highest ticket number.
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) > -1,
            "$SortTicketNumbers[14] - found on screen"
        );

        # Check if settings are stored when switching between view.
        $Selenium->find_element( "a.Large",  'css' )->VerifiedClick();
        $Selenium->find_element( "a.Medium", 'css' )->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[0] ) > -1,
            "$SortTicketNumbers[0] - found on screen after changing views"
        );
        $Self->True(
            index( $Selenium->get_page_source(), $SortTicketNumbers[14] ) == -1,
            "$SortTicketNumbers[14] - not found on screen after changing views"
        );

        # Delete created test tickets.
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
            }
            $Self->True(
                $Success,
                "Delete ticket - $TicketID"
            );
        }

        # Delete created test queue.
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete queue - $QueueID",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw( Ticket Queue )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

$Self->DoneTesting();
