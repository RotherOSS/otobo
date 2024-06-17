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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Enable change owner to everyone feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::ChangeOwnerToEveryone',
            Value => 1,
        );

        # Enable ticket responsible feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::AgentTicketResponsible');
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketResponsible',
            Value => {
                %$Config,
                Note          => 1,
                NoteMandatory => 1,
            },
        );

        # Create test users.
        my @TestUser;
        for my $User ( 1 .. 2 ) {
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            ) || die "Did not get test user";

            push @TestUser, $TestUserLogin;
        }

        # Get test users ID.
        my @UserID;
        for my $UserID (@TestUser) {
            my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
                UserLogin => $UserID,
            );

            push @UserID, $TestUserID;
        }

        # Create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title         => 'Selenium Test Ticket',
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'new',
            CustomerID    => 'SeleniumCustomer',
            CustomerUser  => 'SeleniumCustomer@localhost.com',
            ResponsibleID => $UserID[0],
            OwnerID       => $UserID[0],
            UserID        => $UserID[0],
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # Login as the first created test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[0],
            Password => $TestUser[0],
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # Click on 'Responsible' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketResponsible;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Check page.
        for my $ID (
            qw(Title NewResponsibleID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        $Selenium->find_element( "#Subject",  'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Test');
        $Selenium->InputFieldValueSet(
            Element => '#NewResponsibleID',
            Value   => '',
        );
        $Selenium->find_element( "#submitRichText", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#NewResponsibleID.Error').length" );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#NewResponsibleID').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Reload screen to get a consistent state.
        $Selenium->VerifiedRefresh();

        $Selenium->find_element( "#Subject",  'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Test');

        # Change ticket user responsible.
        $Selenium->InputFieldValueSet(
            Element => '#NewResponsibleID',
            Value   => $UserID[1],
        );
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Switch window back.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length && $("div.TicketZoom").length;'
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );

        # Get ticket attributes.
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
            UserID   => $UserID[0],
        );

        $Self->Is(
            $Ticket{ResponsibleID},
            $UserID[1],
            'New responsible correctly set',
        ) || die 'New responsible not correctly set';

        # Delete created test tickets.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $UserID[0],
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $UserID[0],
            );
        }
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

$Self->DoneTesting();
