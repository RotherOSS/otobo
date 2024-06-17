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
        my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
        my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $RandomID = $Helper->GetRandomID();
        my @Groups;
        my @Queues;
        my @Users;
        my @Tickets;
        for my $Item ( 1 .. 2 ) {

            # Create test group.
            my $GroupName = "Group$Item-$RandomID";
            my $GroupID   = $GroupObject->GroupAdd(
                Name    => $GroupName,
                ValidID => 1,
                UserID  => 1,
            );

            $Self->True(
                $GroupID,
                "Test group $GroupName created",
            );

            push @Groups, {
                GroupID   => $GroupID,
                GroupName => $GroupName,
            };

            # Create test queue.
            my $QueueName = "Queue$Item-$RandomID";
            my $QueueID   = $QueueObject->QueueAdd(
                Name                => $QueueName,
                ValidID             => 1,
                GroupID             => $GroupID,
                FirstResponseTime   => 0,
                FirstResponseNotify => 0,
                UpdateTime          => 0,
                UpdateNotify        => 0,
                SolutionTime        => 0,
                SolutionNotify      => 0,
                SystemAddressID     => 1,
                SalutationID        => 1,
                SignatureID         => 1,
                Comment             => 'Some Comment',
                UserID              => 1,
            );

            $Self->True(
                $QueueID,
                "Test queue $QueueName created",
            );

            push @Queues, {
                QueueID   => $QueueID,
                QueueName => $QueueName,
            };

            # Create test user.
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users', $GroupName ],
            ) || die "Did not get test user $Item";

            my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $TestUserLogin,
            );

            push @Users, {
                TestUserLogin => $TestUserLogin,
                TestUserID    => $TestUserID,
            };

            # Create test ticket.
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN            => $TicketNumber,
                Title         => 'Selenium test ticket',
                Queue         => $QueueName,
                Lock          => 'lock',
                Priority      => '3 normal',
                State         => 'open',
                CustomerID    => 'SeleniumCustomerID',
                CustomerUser  => "test\@localhost.com",
                OwnerID       => $TestUserID,
                UserID        => 1,
                ResponsibleID => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID"
            );

            push @Tickets, {
                TicketID     => $TicketID,
                TicketNumber => $TicketNumber,
            };

        }

        $Selenium->Login(
            Type     => 'Agent',
            User     => $Users[0]->{TestUserLogin},
            Password => $Users[0]->{TestUserLogin},
        );

        # Refresh dashboard page.
        $Selenium->VerifiedRefresh();

        # Click on tool bar AgentTicketLockedView.
        $Selenium->find_element("//a[contains(\@title, \'Locked Tickets Total:\' )]")->VerifiedClick();

        # Verify that test is on the correct screen.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketLockedView";

        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar AgentTicketLockedView shortcut - success",
        );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketLockedView;Filter=All;View=Small;SortBy=Age;OrderBy=Up;ColumnFilterOwner=$Users[0]->{TestUserID}"
        );

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a.MasterActionLink').html().trim() == $Tickets[0]->{TicketNumber};"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('a.MasterActionLink').html().trim();"),
            $Tickets[0]->{TicketNumber},
            "Ticket $Tickets[0]->{TicketNumber} from $Queues[0]->{QueueName} is found",
        );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketLockedView;Filter=All;View=Small;SortBy=Age;OrderBy=Up;ColumnFilterOwner=$Users[1]->{TestUserID}"
        );

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#EmptyMessageSmall').length;"
        );

        $Self->True(
            index( $Selenium->get_current_url(), $Tickets[1]->{TicketNumber} ) == -1,
            "Ticket $Tickets[1]->{TicketNumber} from $Queues[1]->{QueueName} is not found",
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test tickets.
        for my $Ticket (@Tickets) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket->{TicketID},
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $Ticket->{TicketID},
                    UserID   => 1,
                );
            }

            $Self->True(
                $Success,
                "Ticket with ID $Ticket->{TicketID} is deleted!",
            );
        }

        # Delete queues.
        for my $Queue (@Queues) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM queue WHERE id = $Queue->{QueueID}",
            );
            $Self->True(
                $Success,
                "Queue with ID $Queue->{QueueID} is deleted!",
            );
        }

        # Delete group-user relations.
        for my $Group (@Groups) {
            my $Success = $DBObject->Do(
                SQL => "DELETE FROM group_user WHERE group_id = $Group->{GroupID}",
            );
            $Self->True(
                $Success,
                "GroupUserDelete for ID $Group->{GroupID}",
            );

            # Delete test group.
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM groups_table WHERE id = ?",
                Bind => [ \$Group->{GroupID} ],
            );
            $Self->True(
                $Success,
                "Deleted test group - $Group->{GroupID}"
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    }
);

$Self->DoneTesting();
