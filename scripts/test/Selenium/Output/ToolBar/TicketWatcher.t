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

        # Enable ticket watcher feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Watcher',
            Value => 1
        );

        my $RandomID = $Helper->GetRandomID();
        my @Groups;
        my @Queues;
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

        }

        # Create test user.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', $Groups[0]->{GroupName} ],
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN            => $TicketNumber,
            Title         => 'Selenium test ticket',
            Queue         => $Queues[0]->{QueueName},
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
        ) || die;

        # Refresh dashboard page.
        $Selenium->VerifiedRefresh();

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to AgentTicketZoom and check watcher feature - subscribe ticket to watch it
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketWatcher;Subaction=Subscribe;TicketID\' )]")
            ->VerifiedClick();

        # Click on tool bar AgentTicketWatchView
        $Selenium->find_element("//a[contains(\@title, \'Watched Tickets Total:\' )]")->VerifiedClick();

        # Verify that test is on the correct screen.
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketWatchView";

        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar AgentTicketWatcherView shortcut - success",
        );

        # Test ticket is watched.
        $Self->Is(
            $Selenium->execute_script("return \$('a.MasterActionLink').html().trim();"),
            $TicketNumber,
            "Ticket $TicketNumber from $Queues[0]->{QueueName} is found",
        );

        # Move ticket in such Queue, that user doesn't have permission.
        # User still should have access to the ticket, because of watcher feature.
        my $Success = $TicketObject->TicketQueueSet(
            QueueID  => $Queues[1]->{QueueID},
            TicketID => $TicketID,
            UserID   => 1,
        );

        $Self->True(
            $Success,
            "TicketQueueSet: TicketID: $TicketID move into $Queues[1]->{QueueName}",
        ) || die;

        # Refresh AgentTicketWatchView page.
        $Selenium->VerifiedRefresh();

        # If user don't have permission there will not be any tickets in watch list.
        $Self->False(
            $Selenium->execute_script("return \$('#EmptyMessageSmall').length;"),
            "There is watched ticket",
        );

        # User still have access to the ticket.
        $Self->Is(
            $Selenium->execute_script("return \$('a.MasterActionLink').html().trim();"),
            $TicketNumber,
            "Moved Ticket $TicketNumber in $Queues[1]->{QueueName} is found",
        ) || die;

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
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
            "Ticket with ID $TicketID is deleted!",
        );

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
