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

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable all dashboard plugins
        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('DashboardBackend');
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'DashboardBackend',
            Value => \%$Config,
        );

        # reset TicketQueueOverview dashboard sysconfig
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0270-TicketQueueOverview',
            Value => {
                'Block'                => 'ContentLarge',
                'CacheTTLLocal'        => '0.5',
                'Default'              => '1',
                'Description'          => 'Provides a matrix overview of the tickets per state per queue.',
                'Group'                => '',
                'Module'               => 'Kernel::Output::HTML::Dashboard::TicketQueueOverview',
                'Permission'           => 'rw',
                'QueuePermissionGroup' => 'users',
                'Sort'                 => 'SortBy=Age;OrderBy=Up',
                'States'               => {
                    '1' => 'new',
                    '4' => 'open',
                    '6' => 'pending reminder'
                },
                'Title' => 'Ticket Queue Overview'
            },
        );

        # create test queue
        my $QueueName = "Queue" . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "Queue is created - ID $QueueID",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create two test tickets in different states
        my @TicketIDs;
        for my $TicketState (qw( new open )) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Test Ticket',
                QueueID      => $QueueID,
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => $TicketState,
                CustomerID   => '123465',
                CustomerUser => 'customer@example.com',
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID - state $TicketState",
            );

            push @TicketIDs, $TicketID;
        }

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # test if TicketQueueOverview shows correct links
        for my $TQOLinkState (qw(1 4)) {
            $Self->True(
                index( $Selenium->get_page_source(), "StateIDs=$TQOLinkState;QueueIDs=$QueueID;SortBy=Age;OrderBy=Up" )
                    > -1,
                "TicketQueueOverview dashboard plugin link - found for state - ID $TQOLinkState",
            );
        }

        # delete test tickets
        my $Success;
        for my $TicketDelete (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketDelete,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketDelete,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "Ticket is deleted - ID $TicketDelete"
            );
        }

        # delete test queue
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Queue is deleted - ID $QueueID",
        );

        # make sure cache is correct
        for my $Cache (qw( Ticket Queue Dashboard DashboardQueueOverview )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

$Self->DoneTesting();
