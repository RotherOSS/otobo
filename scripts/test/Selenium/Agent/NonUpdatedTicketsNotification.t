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
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ACLObject    = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

        my $RandomID = $Helper->GetRandomID();

        # Do not check email addresses.
        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Disable MX record check.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0,
        );

        # Create test user.
        my ( $UserLogin, $UserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        # Create test queues.
        my @Queues;
        for my $Count ( 1 .. 2 ) {
            my $QueueName = "Queue$Count-$RandomID";
            my $QueueID   = $QueueObject->QueueAdd(
                Name            => $QueueName,
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Selenium Queue',
                UserID          => $UserID,
            );
            $Self->True(
                $QueueID,
                "QueueID $QueueID is created"
            );
            push @Queues, {
                QueueID   => $QueueID,
                QueueName => $QueueName,
            };
        }

        my $ACLName = "ACL-$RandomID";

        # Import test ACL.
        $ACLObject->ACLImport(
            Content => <<"EOF",
- ChangeBy: $UserID
  ChangeTime: 2018-10-23 14:57:08
  Comment: ''
  ConfigChange:
    PossibleNot:
      Ticket:
        Queue:
        - $Queues[1]->{QueueName}
  ConfigMatch:
    Properties:
      Ticket:
        Priority:
        - '2 low'
  CreateBy: $UserID
  CreateTime: 2018-10-23 14:30:24
  Description: ''
  ID: '1'
  Name: $ACLName
  StopAfterMatch: 0
  ValidID: '1'
EOF
            OverwriteExistingEntities => 1,
            UserID                    => $UserID,
        );

        # Create test tickets.
        # The first will be matched by ACL because of priority '2 low' and second won't.
        my @Tickets;
        for my $Priority ( '2 low', '3 normal' ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Ticket',
                Queue        => $Queues[0]->{QueueName},
                Lock         => 'unlock',
                Priority     => $Priority,
                State        => 'open',
                CustomerID   => '123465',
                CustomerUser => "customer1\@localhost.com",
                OwnerID      => $UserID,
                UserID       => $UserID,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created",
            );

            my $TicketNumber = $TicketObject->TicketNumberLookup(
                TicketID => $TicketID,
            );
            push @Tickets, {
                TicketID     => $TicketID,
                TicketNumber => $TicketNumber,
            };
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $UserLogin,
            Password => $UserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # After login, we need to navigate to the ACL deployment to make the imported ACL work.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Self->False(
            index(
                $Selenium->get_page_source(),
                'ACL information from database is not in sync with the system configuration, please deploy all ACLs.'
                )
                > -1,
            "ACL deployment successful."
        );

        # Navigate to AgentTicketStatusView screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketStatusView"
        );

        # Verify test tickets exist.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#TicketID_$Tickets[0]->{TicketID}').length;"
            ),
            "TicketID $Tickets[0]->{TicketID} is found",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#TicketID_$Tickets[1]->{TicketID}').length;"
            ),
            "TicketID $Tickets[1]->{TicketID} is found",
        );

        # Navigate to AgentTicketBulk screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketBulk;TicketID=$Tickets[0]->{TicketID};TicketID=$Tickets[1]->{TicketID}"
        );

        # Change queue to the one from ACL.
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => $Queues[1]->{QueueID},
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Wait until notification is loaded.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.MessageBox.Notice:contains(\"The following tickets are not updated: $Tickets[0]->{TicketNumber}.\")').length;"
        );

        # Check notification about non-updated ticket.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.MessageBox.Notice:contains(\"The following tickets are not updated: $Tickets[0]->{TicketNumber}.\")').length;"
            ),
            "Non-updated tickets notification is found",
        );

        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
        $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Check ticket queues.
        my $Count = 0;
        for my $Ticket (@Tickets) {
            my %TicketData = $TicketObject->TicketGet(
                TicketID => $Ticket->{TicketID},
                UserID   => $UserID,
            );

            # Verify the first ticket queue is not changed (because of ACL) - it is still the old one.
            if ( $Count == 0 ) {
                $Self->Is(
                    $TicketData{QueueID},
                    $Queues[0]->{QueueID},
                    "Queue is not changed in TicketID $Ticket->{TicketID}",
                );
            }

            # Verify the second (the last) ticket queue is changed to the new value.
            else {
                $Self->Is(
                    $TicketData{QueueID},
                    $Queues[1]->{QueueID},
                    "Queue is changed in TicketID $Ticket->{TicketID}",
                );
            }

            $Count++;
        }

        my $Success;

        # Delete test ACL.
        my $ACLData = $ACLObject->ACLGet(
            Name   => $ACLName,
            UserID => $UserID,
        );

        $Success = $ACLObject->ACLDelete(
            ID     => $ACLData->{ID},
            UserID => $UserID,
        );
        $Self->True(
            $Success,
            "ACL '$ACLName' is deleted"
        );

        # After login, we need to navigate to the ACL deployment to make the imported ACL work.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Self->False(
            index(
                $Selenium->get_page_source(),
                'ACL information from database is not in sync with the system configuration, please deploy all ACLs.'
                )
                > -1,
            "ACL deployment successful."
        );

        # Delete test tickets.
        for my $Ticket (@Tickets) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket->{TicketID},
                UserID   => $UserID,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $Ticket->{TicketID},
                    UserID   => $UserID,
                );
            }
            $Self->True(
                $Success,
                "TicketID $Ticket->{TicketID} is deleted"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test queues.
        for my $Queue (@Queues) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$Queue->{QueueID} ],
            );
            $Self->True(
                $Success,
                "QueueID $Queue->{QueueID} is deleted",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(ACLEditor_ACL Queue Ticket)) {
            $CacheObject->CleanUp( Type => $Cache );
        }

    },
);

$Self->DoneTesting();
