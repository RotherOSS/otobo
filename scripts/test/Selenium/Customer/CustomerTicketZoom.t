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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Disable setting.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###CustomerZoomExpand',
            Value => 0,
        );

        # Disable check email address.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Change customer user first and last name.
        my $RandomID          = $Helper->GetRandomID();
        my $CustomerFirstName = 'FirstName';
        my $CustomerLastName  = 'LastName, test (12345)';
        $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUserLogin,
            UserCustomerID => $TestCustomerUserLogin,
            UserLogin      => $TestCustomerUserLogin,
            UserFirstname  => $CustomerFirstName,
            UserLastname   => $CustomerLastName,
            UserEmail      => "$RandomID\@localhost.com",
            ValidID        => 1,
            UserID         => 1,
        );

        # Create test ticket.
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
        ok( $TicketID, "Ticket is created - $TicketID" );

        # Create test article for test ticket.
        my $SubjectRandom = "Subject" . $Helper->GetRandomID();
        my $TextRandom    = "Text" . $Helper->GetRandomID();

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Phone',
        );

        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => $SubjectRandom,
            Body                 => $TextRandom,
            Charset              => 'charset=ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        ok( $ArticleID, "Article #1 is created - $ArticleID" );

        my $ArticleID2 = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => $SubjectRandom,
            Body                 => $TextRandom,
            Charset              => 'charset=ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        ok( $ArticleID2, "Article #2 is created - $ArticleID2" );

        # Account some time to the ticket.
        my $Success = $TicketObject->TicketAccountTime(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            TimeUnit  => '7',
            UserID    => 1,
        );
        ok( $Success, "Time accounted to the ticket" );

        # Login as test customer user.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=123123123");

        $Selenium->content_contains( 'No Permission', "No permission message for tickets the user may not see, even if they don't exist." );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=");

        $Selenium->content_contains( 'Need TicketID', "Error message for missing TicketID/TicketNumber." );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketOverview");

        # Search for new created ticket on CustomerTicketOverview screen.
        $Selenium->find_element_by_xpath_ok(
            "//a[contains(\@href, 'Action=CustomerTicketZoom;TicketNumber=$TicketNumber')]",
            "Ticket with ticket number $TicketNumber is found on screen"
        );

        # click on customer ticket zoom screen.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"
        )->VerifiedClick();

        # Check customer ticket zoom page.
        for my $Selector (
            q{//div[@class='oooWithSub']/h2[@title]},
            q{//li[@id='FollowUp']},
            q{//div[@id='oooNavigation']},
            )
        {
            $Selenium->WaitFor( ElementExists => $Selector );
            my $Element = $Selenium->find_element($Selector);
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check ticket data.
        $Selenium->content_contains( $TicketNumber,  "Ticket number is $TicketNumber" );
        $Selenium->content_contains( $SubjectRandom, "Subject is $SubjectRandom" );
        $Selenium->content_contains( $TextRandom,    "Article body is $TextRandom" );
        $Selenium->content_contains( 'Raw',          "Queue is Raw" );

        # Accounted time should not be displayed.
        $Selenium->content_lacks( q{<span class="ooo12g">Time:</span>}, "Accounted time is not displayed", );

        # Enable displaying accounted time.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###ZoomTimeDisplay',
            Value => 1
        );

        # Reload the page.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        my $NumberOfExpandedArticles = $Selenium->execute_script(
            'return $("li.Visible").length'
        );
        is( $NumberOfExpandedArticles, 1, 'Make sure that only one article is expanded.' );

        # Enable expanding.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###CustomerZoomExpand',
            Value => 1,
        );

        # Reload the page.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        $NumberOfExpandedArticles = $Selenium->execute_script(
            'return $("li.Visible").length'
        );
        is( $NumberOfExpandedArticles, 2, 'Make sure that all articles are expanded.' );

        # Accounted time should now be displayed.
        $Selenium->content_contains( q{<span class="ooo12g">Time:</span>}, "Accounted time is displayed", );

        # Check reply button.
        $Selenium->find_element(q{//button[@id='ReplyButton']})->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#FollowUp.Visible').length" );
        $Selenium->find_element( '#RichText', 'css' )->send_keys('TestBody');
        $Selenium->find_element("//button[contains(\@value, \'Submit' )]")->VerifiedClick();

        # Change the ticket state to 'merged'.
        my $Merged = $TicketObject->TicketStateSet(
            State    => 'merged',
            TicketID => $TicketID,
            UserID   => 1,
        );
        ok( $Merged, "Ticket state changed to 'merged'" );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        # Check if reply button is missing in merged ticket (bug#7301).
        is(
            $Selenium->execute_script('return $("a#ReplyButton").length'),
            0,
            "Reply button not found",
        );

        # Check if print button exists on the screen.
        is(
            $Selenium->execute_script(q{return $("a[href*='Action=CustomerTicketPrint']").length}),
            1,
            "Print button is found",
        );

        my $ArticleBackendObjectInternal = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Internal',
        );

        my $TestOriginalFrom = 'Agent Some Agent Some Agent' . $Helper->GetRandomID();

        # Add article from agent, with enabled IsVisibleForCustomer.
        my $ArticleID3 = $ArticleBackendObjectInternal->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 1,
            From                 => $TestOriginalFrom . ' <email@example.com>',
            Subject              => $SubjectRandom,
            Body                 => $TextRandom,
            Charset              => 'charset=ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        ok( $ArticleID2, "Article #2 is created - $ArticleID2" );

        # Use From field value.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DisplayNoteFrom',
            Value => 'FromField',
        );

        # Refresh the page.
        $Selenium->VerifiedRefresh();

        # Check From field.
        my $FromString = $Selenium->execute_script(q{return $('li.agent-1 div.MessageHeader h3.oooSender').text().trim();});
        is( $FromString, $TestOriginalFrom, "Test From content" );

        # Use default agent name setting.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DisplayNoteFrom',
            Value => 'DefaultAgentName',
        );

        my $TestDefaultAgentName = 'ADefaultValueForAgentName' . $Helper->GetRandomID();

        # Set a default value for agent.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DefaultAgentName',
            Value => $TestDefaultAgentName,
        );

        # Refresh the page.
        $Selenium->VerifiedRefresh();

        # Check From field value.
        $FromString = $Selenium->execute_script(q{return $('li.agent-1 div.MessageHeader h3.oooSender').text().trim();});
        is( $FromString, $TestDefaultAgentName, "Test From content", );

        # Login to Agent interface and verify customer name in answer article.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AgentTicketZoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        ok(
            $Selenium->execute_script(
                'return $("#ArticleTable a:contains(\'FirstName LastName, test (12345)\')").length;'
            ),
            "Customer name found in reply article",
        );

        # Clean up test data from the DB.
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
        ok( $Success, "Ticket is deleted - $TicketID" );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

done_testing();
