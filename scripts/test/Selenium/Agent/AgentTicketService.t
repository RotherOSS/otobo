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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # do not check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # enable ticket service feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get service object
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        # create two test services
        my ( @ServiceIDs, @ServiceNames );
        for my $Service (qw(Parent Child)) {
            my $ServiceName = $Service . 'Service' . $Helper->GetRandomID();
            my $ServiceID   = $ServiceObject->ServiceAdd(
                Name    => $ServiceName,
                ValidID => 1,
                Comment => 'Selenium Test',
                UserID  => 1,
            );
            ok( $ServiceID, "Service ID $ServiceID is created" );
            push @ServiceIDs,   $ServiceID;
            push @ServiceNames, $ServiceName;
        }

        # update second service to be child of first one
        my $Success = $ServiceObject->ServiceUpdate(
            ServiceID => $ServiceIDs[1],
            Name      => $ServiceNames[1],
            ParentID  => $ServiceIDs[0],
            ValidID   => 1,
            UserID    => 1,
        );
        ok( $Success, "Service ID $ServiceIDs[1] is now child service" );

        # update parent service to invalid status, bug #11816
        # test if child service are visible when parent is invalid
        $Success = $ServiceObject->ServiceUpdate(
            ServiceID => $ServiceIDs[0],
            Name      => $ServiceNames[0],
            ValidID   => 2,
            UserID    => 1,
        );
        ok( $Success, "Parent Service ID $ServiceIDs[0] is invalid" );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        for my $Lock (qw(lock unlock)) {
            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium Test Ticket',
                Queue         => 'Raw',
                Lock          => $Lock,
                Priority      => '3 normal',
                State         => 'open',
                ServiceID     => $ServiceIDs[1],
                CustomerID    => 'SeleniumCustomer',
                CustomerUser  => 'SeleniumCustomer@localhost.com',
                OwnerID       => 1,
                UserID        => 1,
                ResponsibleID => 1,
            );
            ok( $TicketID, "Ticket ID $TicketID is created" );
            push @TicketIDs, $TicketID;
        }

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentTicketService screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketService");

        # verify that there are no tickets with "My Services" filter
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketService;ServiceID=0;\' )]")->VerifiedClick();

        $Selenium->content_contains(
            'No ticket data found.',
            "No tickets found with 'My Services' filter",
        );

        # check for parent test service filter button and click on it
        my $Element = $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicketService;ServiceID=$ServiceIDs[0];\' )]"
        );
        $Element->is_enabled();
        $Element->is_displayed();
        $Element->VerifiedClick();

        # click on child service
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketService;ServiceID=$ServiceIDs[1];\' )]")->VerifiedClick();

        # check different views for filters
        for my $View (qw(Small Medium Preview)) {

            # go to default small view
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentTicketService;ServiceID=$ServiceIDs[1];View=Small"
            );

            # click on viewer controller
            $Selenium->find_element(
                "//a[contains(\@href, \'Filter=Unlocked;View=$View;ServiceID=$ServiceIDs[1];SortBy=Age;OrderBy=Up;View=Small;\' )]"
            )->VerifiedClick();

            # verify that all expected tickets are present
            for my $TicketID (@TicketIDs) {

                my %TicketData = $TicketObject->TicketGet(
                    TicketID => $TicketID,
                    UserID   => 1,
                );

                # check for locked and unlocked tickets
                if ( $TicketData{Lock} eq 'unlock' ) {

                    # click on 'Available ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceIDs[1];SortBy=Age;OrderBy=Up;View=$View;Filter=Unlocked\' )]"
                    )->VerifiedClick();

                    # check for unlocked tickets with 'Available tickets' filter on
                    $Selenium->content_contains(
                        $TicketData{TicketNumber},
                        "Ticket found on page with 'Available tickets' filter - $TicketData{TicketNumber} ",
                    );

                    # click on 'All ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceIDs[1];SortBy=Age;OrderBy=Up;View=$View;Filter=All\' )]"
                    )->VerifiedClick();

                    # check for unlocked tickets with 'All tickets' filter on
                    $Selenium->content_contains(
                        $TicketData{TicketNumber},
                        "Ticket found on page with 'All tickets' filter on - $TicketData{TicketNumber} ",
                    );
                }
                else {

                    # click on 'All ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceIDs[1];SortBy=Age;OrderBy=Up;View=$View;Filter=All\' )]"
                    )->VerifiedClick();

                    # check for locked tickets with  'All ticket' filter
                    $Selenium->content_contains(
                        $TicketData{TicketNumber},
                        "Locked Ticket found on page with 'All tickets' filter on - $TicketData{TicketNumber} ",
                    );

                    # click on 'Available ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceIDs[1];SortBy=Age;OrderBy=Up;View=$View;Filter=Unlocked\' )]"
                    )->VerifiedClick();

                    # check for locked tickets with 'Available tickets' filter on
                    $Selenium->content_lacks(
                        $TicketData{TicketNumber},
                        "Did not find locked ticket - $TicketData{TicketNumber} - with 'Available tickets' filter",
                    );
                }
            }
        }

        # delete created test tickets
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
            ok( $Success, "Ticket ID $TicketID is deleted" );
        }

        # delete created test service
        for my $ServiceDelete (@ServiceIDs) {
            $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => "DELETE FROM service WHERE id = $ServiceDelete",
            );
            ok( $Success, "Service ID $ServiceDelete is deleted", );
        }

        # make sure the cache is correct
        for my $Cache (qw (Ticket Service)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

done_testing;
