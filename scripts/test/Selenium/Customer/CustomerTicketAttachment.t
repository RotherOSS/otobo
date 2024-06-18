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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM, $Self is not used
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # Set download type to inline.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'AttachmentDownloadType',
            Value => 'inline'
        );

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # Click on 'Issue a ticket'.
        $Selenium->find_element_by_css_ok('.oooTile_NewTicket');
        $Selenium->find_element( '.oooTile_NewTicket', 'css' )->VerifiedClick();

        # Set up needed variables.
        my $RandomID       = $Helper->GetRandomID();
        my $SubjectRandom  = 'Subject' . $RandomID;
        my $TextRandom     = 'Text' . $RandomID;
        my $AttachmentName = 'StdAttachment-Test1.txt';
        my $Location       = $Kernel::OM->Get('Kernel::Config')->Get('Home') . "/scripts/test/sample/StdAttachment/$AttachmentName";

        # Hide DnDUpload and show input field.
        $Selenium->execute_script(q{$('.DnDUpload').css('display', 'none')});
        $Selenium->execute_script(q{$('#FileUpload').css('display', 'block')});

        # Input fields and create ticket.
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => '2||Raw',
        );
        $Selenium->find_element( "#Subject",    'css' )->send_keys($SubjectRandom);
        $Selenium->find_element( "#RichText",   'css' )->send_keys($TextRandom);
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".AttachmentList").length' );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Get test created ticket ID and number.
        my ( $TicketID, $TicketNumber ) = $TicketObject->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomerUserLogin,
        );
        ok( $TicketNumber, 'Ticket was created and found' );

        # Click on test created ticket on CustomerTicketOverview screen.
        $Selenium->find_element_ok( $TicketNumber, 'partial_link_text' );
        $Selenium->find_element( $TicketNumber, 'partial_link_text' )->VerifiedClick();

        # Click on attachment to open it.
        # Initially the link is hidden. Click on the paperclip first, in order to show the link.
        # Per default Selenium interacts only with visible elements.
        $Selenium->LogExecuteCommandActive(0);
        try_ok {
            my $PaperclipSelector      = q{//div[@class='MessageHeader']/p/i[@class='fa fa-paperclip']};
            my $AttachmentLinkSelector = qq{//span[contains(\@title,'$AttachmentName')]/a};
            $Selenium->find_element_by_xpath_ok($PaperclipSelector);
            $Selenium->find_element_by_xpath_ok($AttachmentLinkSelector);
            $Selenium->click_element_ok($PaperclipSelector);
            $Selenium->click_element_ok($AttachmentLinkSelector);

            # Switch to another window.
            $Selenium->WaitFor( WindowCount => 2 );
            my $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Check if attachment is genuine.
            my $ExpectedAttachmentContent = "Some German Text with Umlaut";
            $Selenium->content_contains( $ExpectedAttachmentContent, "$AttachmentName opened successfully" );
        };
        $Selenium->LogExecuteCommandActive(1);

        # Clean up test data from the DB.
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
        ok( $Success, "Ticket with ticket number $TicketNumber is deleted" );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

done_testing();
