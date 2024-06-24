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

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Enable ticket watcher feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Watcher',
            Value => 1,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Create test tickets.
        my @TicketIDs;
        for ( 1 .. 3 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium test ticket',
                Queue         => 'Raw',
                Lock          => 'unlock',
                Priority      => '3 normal',
                State         => 'open',
                CustomerID    => 'SeleniumCustomer',
                CustomerUser  => 'SeleniumCustomer@localhost.com',
                OwnerID       => 1,
                UserID        => 1,
                ResponsibleID => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs, $TicketID;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        for my $TicketID (@TicketIDs) {

            # Go to AgentTicketZoom screen.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("a[href*=\'Action=AgentTicketWatcher\']").length;'
            );

            # Check watcher feature - subscribe ticket to watch it.
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketWatcher\' )]")->VerifiedClick();

            $Self->True(
                $Selenium->execute_script(
                    "return \$('a[href*=\"Action=AgentTicketWatcher;Subaction=Unsubscribe\"]').length;"
                ),
                "TicketID $TicketID is subscribed",
            );
        }

        # Go to AgentTicketWatchView screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketWatchView");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("a[href*=\'Action=AgentTicketWatchView;SortBy=Age;OrderBy=Up;View=;Filter=All\']").length;'
        );

        $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicketWatchView;SortBy=Age;OrderBy=Up;View=;Filter=All\' )]"
        )->VerifiedClick();

        # Check different views for filters.
        for my $View (qw(Small Medium Preview)) {

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('a[href*=\"Action=AgentTicketWatchView;Filter=All;View=$View;\"]').length;"
            );

            # Click on viewer controller.
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketWatchView;Filter=All;View=$View;\' )]")->VerifiedClick();

            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("table tbody").length;'
            );

            # Verify that all tickets are present.
            for my $TicketID (@TicketIDs) {

                my $TicketNumber = $TicketObject->TicketNumberLookup(
                    TicketID => $TicketID,
                    UserID   => 1,
                );

                $Self->True(
                    index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                    "Ticket found on page - $TicketNumber ",
                ) || die "Ticket $TicketNumber not found on page";
            }
        }

        # Delete created test tickets.
        my $Success;
        for my $TicketID (@TicketIDs) {
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
            $Self->True(
                $Success,
                "Ticket is deleted - ID $TicketID"
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

$Self->DoneTesting();
