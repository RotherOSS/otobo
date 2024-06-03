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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self (unused) and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ACLObject            = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # Import test ACL.
        $ACLObject->ACLImport(
            Content => <<"EOF",
- ChangeBy: root\@localhost
  ChangeTime: 2018-07-04 03:08:58
  Comment: ''
  ConfigChange:
    PossibleNot:
      Action:
        - AgentTicketEmail
  ConfigMatch:
    Properties:
      Ticket:
        State:
        - new
  CreateBy: root\@localhost
  CreateTime: 2018-07-04 02:55:35
  Description: ''
  ID: '1'
  Name: ThisIsAUnitTestACL-1
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2018-07-04 03:08:58
  Comment: ''
  ConfigChange:
    PossibleNot:
      Action:
        - AgentTicketPhone
  ConfigMatch:
    Properties:
      Ticket:
        State:
        - open
  CreateBy: root\@localhost
  CreateTime: 2018-07-04 02:55:35
  Description: ''
  ID: '2'
  Name: ThisIsAUnitTestACL-2
  StopAfterMatch: 0
  ValidID: '1'
EOF
            OverwriteExistingEntities => 1,
            UserID                    => 1,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => "customer1\@localhost.com",
            OwnerID      => 1,
            UserID       => 1,
        );
        ok( $TicketID, "TicketCreateID $TicketID is created" );

        # Create email article.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            From                 => 'Some Customer A <customer-a@example.com>',
            To                   => 'Some Agent <email@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Customer sent an email',
            UserID               => 1,
        );
        ok( $TicketID, "ArticleID $ArticleID is created" );

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # After login, we need to navigate to the ACL deployment to make the imported ACL work.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Selenium->content_lacks(
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
            'ACL deployment successful.'
        );

        # Navigate to AgentTicketZoom screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Click on the split action. First ACL is in action, expecting 'Phone Ticket' selection to be
        #   enabled and 'Email Ticket' selection to be disabled.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#SplitSubmit").length'
        );
        $Selenium->find_no_element_by_xpath_ok(
            q{//option[@value='SnailMailTicket']},
            q{Split option for 'SnailMail Ticket' not available},
        );
        $Selenium->find_element_by_xpath_ok(
            q{//option[@value='PhoneTicket']},
            "Split option for 'Phone Ticket' is enabled."
        );

        $Selenium->find_no_element_by_xpath_ok(
            q{//option[@value='EmailTicket']},
            q{Split option for 'Email Ticket' is disabled},
        );

        $Selenium->find_element( '.Close', 'css' )->click();

        # back in the main window
        # Update state to 'open' to trigger second test ACL.
        my $Success = $TicketObject->TicketStateSet(
            State    => 'open',
            TicketID => $TicketID,
            UserID   => 1,
        );
        ok( $Success, "TicketID $TicketID is set to 'open' state" );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Click on the split action. Second ACL is in action, expecting 'Phone Ticket' selection to be
        #   disabled and 'Email Ticket' selection to be enabled.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return $("#SplitSubmit").length'
        );
        $Selenium->LogExecuteCommandActive(0);
        $Selenium->find_no_element_by_xpath_ok(
            q{//option[@value='SnailMailTicket']},
            q{Split option for 'SnailMail Ticket' not available},
        );
        {
            $Selenium->find_no_element_by_xpath_ok(
                q{//option[@value='PhoneTicket']},
                q{Split option for 'Phone Ticket' is disabled},
            );
        }
        $Selenium->find_element_by_xpath_ok(
            q{//option[@value='EmailTicket']},
            "Split option for 'Email Ticket' is enabled.",
        );
        $Selenium->LogExecuteCommandActive(1);
        $Selenium->find_element( '.Close', 'css' )->click();

        # Delete test ACLs rules.
        for my $Count ( 1 .. 2 ) {
            my $ACLData = $ACLObject->ACLGet(
                Name   => 'ThisIsAUnitTestACL-' . $Count,
                UserID => 1,
            );

            my $Success = $ACLObject->ACLDelete(
                ID     => $ACLData->{ID},
                UserID => 1,
            );
            ok( $Success, "ACL with ID $ACLData->{ID} is deleted" );
        }

        # Deploy again after we deleted the test ACL.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Selenium->content_lacks(
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
            'ACL deployment successful.',
        );

        # Delete created test tickets.
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
        ok( $Success, "Ticket with ticket ID $TicketID is deleted" );
    },
);

done_testing();
