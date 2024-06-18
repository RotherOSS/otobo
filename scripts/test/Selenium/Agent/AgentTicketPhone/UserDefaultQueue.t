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

use vars (qw($Self));

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Define test cases.
        my @Queues = ( '', 'Raw', 'Postmaster', 'NotExsising123', '' );

        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        for my $Queue (@Queues) {

            # Enable or disable setting that will influence the new phone ticket initial screen
            if ($Queue) {
                $Helper->ConfigSettingChange(
                    Valid => 1,
                    Key   => 'Ticket::Frontend::UserDefaultQueue',
                    Value => $Queue,
                );
            }
            else {
                $Helper->ConfigSettingChange(
                    Valid => 0,
                    Key   => 'Ticket::Frontend::UserDefaultQueue',
                    Value => 'Raw',
                );
            }

            my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

            # Navigate to new phone ticket.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

            # Check page.
            for my $ID (
                qw(FromCustomer CustomerID Dest Subject RichText FileUpload
                NextStateID PriorityID submitRichText)
                )
            {
                my $Element = $Selenium->find_element( "#$ID", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # Depending on the test case check if the queue is preselected or not
            if ( $Queue && $Queue ne 'NotExsising123' ) {
                my $QueueID = $QueueObject->QueueLookup( Queue => $Queue );
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('#Dest').val()"
                    ),
                    "$QueueID||$Queue",
                    "$Queue is preselected",
                );
            }
            else {
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('#Dest').val()"
                    ),
                    '||-',
                    'No queue is preselected',
                );
            }
        }
    }
);

$Self->DoneTesting();
