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

use v5.24;
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
my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Selenium->RunTest(
    sub {

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );
        ok( $TestUserLogin, 'test user created' );

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Note that the customer and customer users do not exist in the DB
        my @TestTickets = (
            {
                TN           => $TicketObject->TicketCreateNumber(),
                CustomerUser => $Helper->GetRandomID() . '@first.com',
            },
            {
                TN           => $TicketObject->TicketCreateNumber(),
                CustomerUser => $Helper->GetRandomID() . '@second.com',
            },
            {
                TN           => $TicketObject->TicketCreateNumber(),
                CustomerUser => $Helper->GetRandomID() . '@third.com',
                CustomerID   => 'CustomerCompany' . $Helper->GetRandomID() . '(#)',
            },
            {
                TN           => $TicketObject->TicketCreateNumber(),
                CustomerUser => $Helper->GetRandomID() . '@fourth.com',
                CustomerID   => 'CustomerCompany#%' . $Helper->GetRandomID() . '(#)',
            },
        );

        # Create test tickets.
        my @Tickets;
        for my $Test (@TestTickets) {
            state $Cnt = 0;
            my $TicketID = $TicketObject->TicketCreate(
                TN           => $Test->{TN},
                Title        => 'Selenium Test Ticket',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => $Test->{CustomerID} || 'SomeCustomer',
                CustomerUser => $Test->{CustomerUser},
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );
            ok( $TicketID, "Ticket $Cnt TN: $Test->{TN} ID: $TicketID - created" );
            $Cnt++;

            push @Tickets, {
                TicketID     => $TicketID,
                TN           => $Test->{TN},
                CustomerUser => $Test->{CustomerUser},
                CustomerID   => $Test->{CustomerID}
            };
        }

        # Login test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # Turn on the 'Customer User ID' column by default.
        my $Config = $ConfigObject->Get('DashboardBackend')->{'0120-TicketNew'};
        $Config->{DefaultColumns}->{CustomerUserID} = '2';
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0120-TicketNew',
            Value => $Config,
        );

        # Refresh dashboard screen and clean it's cache.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Dashboard',
        );

        try_ok {
            $Selenium->VerifiedRefresh();

            # Navigate to dashboard screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?");

            # Verify that 'Customer User ID' filter for TicketNew dashboard is set.
            $Selenium->find_element_ok(
                "//a[contains(\@title, \'Customer User ID\' )]",
                'xpath',
                "'Customer User ID' filter for TicketNew dashboard is set",
            );

            # Wait for auto-complete action that filter the list of new tickets.  Explicitly we wait till the second test ticket
            # is no longer shown in the list. Be aware that the second test ticket could be shown in some other
            # location, i.e. in the lastchanged tickets widget. Therefore that XPath selector must be limited
            # to the relevant div: <div id="Dashboard0120-TicketNew">
            my $JQuerySelectorTemplate = q{div[id='Dashboard0120-TicketNew'] a[href*='TicketID=%s']};
            my $XPathSelectorTemplate  = q{//div[@id='Dashboard0120-TicketNew']//a[text()='%s']};
            {
                # Click on column setting filter for the first customer in TicketNew generic dashboard overview.
                $Selenium->find_element("//a[contains(\@title, \'Customer User ID\' )]")->click();
                $Selenium->WaitFor(
                    JavaScript =>
                        'return $("div.ColumnSettingsBox").length'
                );

                # Select the first test 'Customer User ID' as filter for TicketNew generic dashboard overview.
                my $ParentElement = $Selenium->find_element( "div.ColumnSettingsBox", 'css' );
                $Selenium->find_child_element( $ParentElement, "./input" )->send_keys( $Tickets[0]->{CustomerUser} );
                sleep 1;

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
                );

                # Choose the value.
                $Selenium->execute_script(
                    "\$('#ColumnFilterCustomerUserID0120-TicketNew').val('$Tickets[0]->{CustomerUser}').trigger('change');"
                );

                $Selenium->WaitFor(
                    JavaScript => sprintf(
                        q{return typeof($) === "function" && !$("%s").length},
                        sprintf( $JQuerySelectorTemplate, $Tickets[1]->{TicketID} ),
                    ),
                );

                # Verify that the first test ticket is found after filtering with the first customer that is not in DB.
                $Selenium->find_element_ok(
                    sprintf( $XPathSelectorTemplate, $Tickets[0]->{TN} ),
                    'xpath',
                    "Test ticket 0 with TN $Tickets[0]->{TN} - found on screen after filtering with customer - $Tickets[0]->{CustomerUser}",
                );

                # Verify the second test ticket is not found after filtering with the first customer that is not in DB.
                $Selenium->find_no_element_ok(
                    sprintf( $XPathSelectorTemplate, $Tickets[1]->{TN} ),
                    'xpath',
                    "Test ticket 1 with TN $Tickets[1]->{TN} - not found on screen after filtering with customer - $Tickets[0]->{CustomerUser}",
                );

                # Click on column setting filter for 'Customer User ID' in TicketNew generic dashboard overview.
                $Selenium->find_element("//a[contains(\@title, \'Customer User ID\' )]")->click();

                # clicking on a.DeleteFilter only works after a little sleep
                sleep 1;

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
                );

                # Delete the current filter.
                $Selenium->find_element( "a.DeleteFilter", 'css' )->click();

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("#Dashboard0120-TicketNew-box.Loading").length'
                );

                # Click on column setting filter for 'Customer User ID' in TicketNew generic dashboard overview.
                $Selenium->find_element("//a[contains(\@title, \'Customer User ID\' )]")->click();
                $Selenium->WaitFor(
                    JavaScript => 'return $("div.ColumnSettingsBox").length'
                );

                # Select test 'Customer User ID' as filter for TicketNew generic dashboard overview.
                $ParentElement = $Selenium->find_element( "div.ColumnSettingsBox", 'css' );
                $Selenium->find_child_element( $ParentElement, "./input" )->send_keys( $Tickets[1]->{CustomerUser} );
                sleep 1;

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
                );

                # Choose the value.
                $Selenium->execute_script(
                    "\$('#ColumnFilterCustomerUserID0120-TicketNew').val('$Tickets[1]->{CustomerUser}').trigger('change');"
                );

                # Wait for auto-complete action, the first ticket should no longer be shown
                $Selenium->WaitFor(
                    JavaScript => sprintf(
                        q{return typeof($) === "function" && !$("%s").length},
                        sprintf( $JQuerySelectorTemplate, $Tickets[0]->{TicketID} ),
                    ),
                );

                # Verify the first test ticket is not found after filtering with the second customer that is not in DB.
                $Selenium->find_no_element_ok(
                    sprintf( $XPathSelectorTemplate, $Tickets[0]->{TN} ),
                    'xpath',
                    "Test ticket with TN $Tickets[0]->{TN} - not found on screen after filtering with customer - $Tickets[1]->{CustomerUser}",
                );

                # Verify that the second test ticket is found after filtering with the second customer that is not in DB.
                $Selenium->find_element_ok(
                    sprintf( $XPathSelectorTemplate, $Tickets[1]->{TN} ),
                    'xpath',
                    "Test ticket with TN $Tickets[1]->{TN} - found on screen after filtering with customer - $Tickets[1]->{CustomerUser}",
                );

                # Cleanup
                # Click on column setting filter for 'Customer User ID' in TicketNew generic dashboard overview.
                $Selenium->find_element("//a[contains(\@title, \'Customer User ID\' )]")->click();

                # clicking on a.DeleteFilter only works after a little sleep
                sleep 1;

                # wait for AJAX to finish
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
                );

                # Delete the current filter.
                $Selenium->find_element( "a.DeleteFilter", 'css' )->click();

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && !$("#Dashboard0120-TicketNew-box.Loading").length'
                );
            }

            # Update configuration.
            $Config                                     = $ConfigObject->Get('DashboardBackend')->{'0120-TicketNew'};
            $Config->{DefaultColumns}->{CustomerUserID} = '0';
            $Config->{DefaultColumns}->{CustomerID}     = '2';
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'DashboardBackend###0120-TicketNew',
                Value => $Config,
            );

            # Refresh dashboard screen and clean it's cache.
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => 'Dashboard',
            );

            $Selenium->VerifiedRefresh();

            # Navigate to dashboard screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?");

            # Check if 'Customer ID' filter for TicketNew dashboard is set.
            eval {
                $Self->True(
                    $Selenium->find_element("//a[contains(\@title, \'Customer ID\' )]"),
                    "'Customer ID' filter for TicketNew dashboard is set",
                );
            };
            if ($@) {
                $Self->True(
                    $@,
                    "'Customer ID' filter for TicketNew dashboard is not set",
                );
            }
            else {

                # Click on column setting filter for the first customer in TicketNew generic dashboard overview.
                $Selenium->find_element("//a[contains(\@title, \'Customer ID\' )]")->click();
                $Selenium->WaitFor(
                    JavaScript =>
                        'return $("div.ColumnSettingsBox").length'
                );

                # Select the third test Customer ID as filter for TicketNew generic dashboard overview.
                my $ParentElement = $Selenium->find_element( "div.ColumnSettingsBox", 'css' );
                $Selenium->find_child_element( $ParentElement, "./input" )->send_keys( $Tickets[2]->{CustomerID} );
                sleep 1;

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
                );

                # Choose the value.
                $Selenium->execute_script(
                    "\$('#ColumnFilterCustomerID0120-TicketNew').val('$Tickets[2]->{CustomerID}').trigger('change');"
                );

                # Wait for auto-complete action.
                $Selenium->WaitFor(
                    JavaScript => sprintf(
                        q{return typeof($) === "function" && !$("%s").length},
                        sprintf( $JQuerySelectorTemplate, $Tickets[1]->{TicketID} ),
                    ),
                );

                # Verify the third test ticket is found  by filtering with the  customer that is not in DB.
                $Selenium->find_element_ok(
                    sprintf( $XPathSelectorTemplate, $Tickets[2]->{TN} ),
                    'xpath',
                    "Test ticket with TN $Tickets[2]->{TN} - found on screen after filtering with customer - $Tickets[2]->{CustomerID}",
                );

                # Verify the second test ticket is not found by filtering with the first customer that is not in DB.
                $Selenium->find_no_element_ok(
                    sprintf( $XPathSelectorTemplate, $Tickets[1]->{TN} ),
                    'xpath',
                    "Test ticket with TN $Tickets[1]->{TN} - not found on screen after filtering with customer - $Tickets[1]->{CustomerID}",
                );

                # Click on column setting filter for CustomerID in TicketNew generic dashboard overview.
                $Selenium->find_element("//a[contains(\@title, \'Customer ID\' )]")->click();

                # clicking on a.DeleteFilter only works after a little sleep
                sleep 1;

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
                );

                # Delete the current filter.
                $Selenium->find_element( "a.DeleteFilter", 'css' )->click();

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && !$("#Dashboard0120-TicketNew-box.Loading").length'
                );

                # Verify if CustomerID containing special characters is filtered correctly. See bug#14982.
                $Selenium->find_element("//a[contains(\@title, \'Customer ID\' )]")->click();
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('.CustomerIDAutoComplete:visible').length;"
                );

                $Selenium->find_element( ".CustomerIDAutoComplete", 'css' )->send_keys( $Tickets[3]->{CustomerID} );

                # Wait for AJAX to finish.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
                );

                # Choose the value.
                $Selenium->execute_script(
                    "\$('#ColumnFilterCustomerID0120-TicketNew').val('$Tickets[3]->{CustomerID}').trigger('change');"
                );

                # Wait for autocomplete action.
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('td div[title=\"$Tickets[3]->{CustomerID}\"]').length == 1;"
                );

                # Verify CustomerID containing special characters is found.
                $Selenium->find_element_ok(
                    sprintf( $XPathSelectorTemplate, $Tickets[3]->{TN} ),
                    'xpath',
                    "Test ticket with TN $Tickets[3]->{TN} - found on screen after filtering with customer - $Tickets[3]->{CustomerID}",
                );
            }
        };

        # Delete test tickets.
        for my $Ticket (@Tickets) {
            state $Cnt = 0;
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
            ok( $Success, "Ticket $Cnt ID $Ticket->{TicketID} - deleted" );
            $Cnt++;
        }

        # Make sure cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

done_testing();
