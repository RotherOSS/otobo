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

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Test for bug#11205 (http://bugs.otrs.org/show_bug.cgi?id=11205).
        # Check screen size to open popup according to available screen height.
        # Open popup with default height,
        # after that open popup with adjusted height.
        my $ParentWindowHeight = $Selenium->get_window_size()->{"height"};

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$.active == 0"
        );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script(
            '$("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );
        $Selenium->WaitFor( JavaScript => "return \$('#nav-Communication ul').css('opacity') == 1;" );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        my $PopupWindowHeight = $Selenium->execute_script(
            "return \$(window).height();"
        );

        # two sizes are acceptable, as under Chrome that is a message about remote control
        ok(
            ( $PopupWindowHeight == 700 || $PopupWindowHeight == 655 ),
            "Default popup window height, considering the remote control warning"
        );

        # Close note window.
        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );

        # Switch window back to agent ticket zoom view of created test ticket.
        $Selenium->switch_to_window( $Handles->[0] );

        # Now try to open a popup with a height larger than the screen height (1000).
        # Adjust PopupProfile for that.
        $Selenium->execute_script(
            "Core.UI.Popup.ProfileAdd('Default', { WindowURLParams: 'dependent=yes,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no', Left: 100, Top: 100, Width: 1040, Height: 1700 });"
        );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$.active == 0"
        );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script(
            '$("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );
        $Selenium->WaitFor( JavaScript => "return \$('#nav-Communication ul').css('opacity') == 1;" );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();
        $Selenium->WaitFor( WindowCount => 2 );

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        $PopupWindowHeight = $Selenium->execute_script(
            "return \$(window).height();"
        );

        $Self->True(
            $ParentWindowHeight - $PopupWindowHeight,
            "Popup window height ("
                . $PopupWindowHeight
                . "px) fits into screen height ("
                . $ParentWindowHeight
                . "px), even if defined larger"
        );

        # Delete created test tickets.
        my $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - ID $TicketID"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

done_testing();
