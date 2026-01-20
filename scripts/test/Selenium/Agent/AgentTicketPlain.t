# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
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

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Check to see tickets in plain view.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::PlainView',
            Value => 1
        );

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Selenium ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        ok( $TicketID, "Ticket is created - ID $TicketID" );

        # Create test email article.
        # ArticleCreate() doesn't store a plain version of the article in the database.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
            Subject              => 'Test ticket created by AgentTicketPlain.t',
            Body                 => 'This is the first article created by AgentTicketPlain.t',
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        ok( $ArticleID, "Article is created - ID $ArticleID" );

        # Write test sample email as article plain.
        # The sample mail contains German umlauts.
        my $Location   = $ConfigObject->Get('Home') . '/scripts/test/sample/AgentTicketPlain/UTF-8.box';
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'SCALAR',
        );

        my $WriteSuccess = $ArticleBackendObject->ArticleWritePlain(
            ArticleID => $ArticleID,
            Email     => $ContentRef->$*,
            UserID    => 1,
        );
        ok( $WriteSuccess, "ArticleWritePlain for article ID $ArticleID - success" );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Click to show ticket in plain view in a popup
        $Selenium->find_element(q{//a[contains(@href, 'Action=AgentTicketPlain' )]})->click;

        # Switch to plain window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # Check for values from the .box file in AgentTicketPlain screen.
        # The page source is a string with the UTF-8 flag active, containing some double encoded characters.
        my $PageSource = $Selenium->get_page_source;

        $Selenium->content_contains( 'Subject: Content in UTF-8', 'found subject in plain format email' );
        my @Lines = (
            'ä - U+000E4 - C3 A4 - LATIN SMALL LETTER A WITH DIAERESIS',
            'Ä - U+000C4 - C3 84 - LATIN CAPITAL LETTER A WITH DIAERESIS',
            'ऄ - U+00904 - E0 A4 84 - DEVANAGARI LETTER SHORT A',
            '⛄ - U+026C4 - E2 9B 84 - SNOWMAN WITHOUT SNOW',
            '𐡀 - U+10840 - F0 90 A1 80 - IMPERIAL ARAMAIC LETTER ALEPH',
        );
        for my $Line (@Lines) {

            # Within the AgentTicketPlain frontend the plain email is retrieved as binary.
            # That binary plain email is the UTF-8 encoded text file UTF-8.mbox that was stored above.
            # Somewhere along the template processing the text is double UTF-8 enconded,
            # resulting in a incorrectly displayed characters. This is hard to avoid
            # as Email may use all kinds of encodings mixed in a single text.
            #
            # For the test we implicitly double encode the expected string by removing the UTF-8 flag.
            # index() returns true even if it compares a string with UTF-flag set with a string
            # where the UTF-8 flag is not set. This is sensible as the UTF-8 should be transparent to the outside.
            my $OriginalLine = $Line;
            Encode::_utf8_off($Line);
            ok( index( $PageSource, $Line ) > -1, $OriginalLine );
        }

        # Close plain view window.
        $Selenium->find_element( '.CancelClosePopup', 'css' )->click;
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Delete created test ticket.
        my $DeleteSuccess = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$DeleteSuccess ) {
            sleep 3;
            $DeleteSuccess = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        ok( $DeleteSuccess, "Ticket with ticket ID $TicketID is deleted" );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

done_testing;
