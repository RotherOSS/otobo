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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Setting the window size such that the button 'Priorität', German for 'Priority',
        # is visible and clickable.  Note that with a width of 600 px,
        # only a part of the buttin is visible, but that shouldn't matter.
        $Selenium->set_window_size( 600, 600 );

        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Language => $Language,
            Groups   => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Create test ticket.
        my $TitleRandom  = 'Partly sunny ⛅ ' . $Helper->GetRandomID;
        my $TicketNumber = $TicketObject->TicketCreateNumber;
        my $TicketID     = $TicketObject->TicketCreate(
            TN         => $TicketNumber,
            Title      => $TitleRandom,
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => 'SeleniumCustomer',
            OwnerID    => 1,
            UserID     => 1,
        );
        ok( $TicketID, "Ticket is created - ID $TicketID" );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Verify its right screen.
        $Selenium->content_contains( $TitleRandom, "Ticket $TitleRandom found on page" );

        my $Element = $Selenium->find_element(q{//a[contains(@href, 'Action=AgentTicketPriority')]});
        ok(
            ( $Element->is_enabled && $Element->is_displayed ),
            'Link for priority popup is displayed and enabled',
        );

        $Selenium->find_element(q{//a[contains(@href, 'Action=AgentTicketPriority')]})->click;

        $Selenium->SwitchToFrame(
            FrameSelector => '.PopupIframe',
            WaitForLoad   => 1,
        );

        # As long as the overlay is opened, elements below it should not be usable, e.g. the mobile navigation toggle.
        my $Success;
        eval {
            $Success = $Selenium->find_element( "#ResponsiveNavigationHandle", "css" )->click();
            sleep 2;
        };

        ok( !$Success, "Mobile navigation button should not be clickable." );

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
        ok( $Success, "Ticket is deleted - ID $TicketID" );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

done_testing;
