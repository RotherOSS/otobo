# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

        # Enable toolbar TicketSearchProfile.
        my %TicketSearchProfile = (
            Block       => 'ToolBarSearchProfile',
            Description => 'Search template',
            MaxWidth    => '40',
            Module      => 'Kernel::Output::HTML::ToolBar::TicketSearchProfile',
            Name        => 'Search template',
            Priority    => '1990010',
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###11-Ticket::TicketSearchProfile',
            Value => \%TicketSearchProfile
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
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN            => $TicketNumber,
            Title         => 'Selenium test ticket',
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomerID',
            CustomerUser  => 'test@localhost.com',
            OwnerID       => $TestUserID,
            UserID        => 1,
            ResponsibleID => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID"
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Wait until search element has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#GlobalSearchNav").length' );

        # Click on search.
        $Selenium->find_element( "#GlobalSearchNav", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfileNew').length" );

        # Create new template search.
        my $SearchProfileName = "SeleniumTest";
        $Selenium->find_element( "#SearchProfileNew", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfileAddName').length" );

        $Selenium->find_element( "#SearchProfileAddName",   'css' )->send_keys($SearchProfileName);
        $Selenium->find_element( "#SearchProfileAddAction", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').val() === '$SearchProfileName'"
        );

        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'TicketNumber',
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#SearchInsert input[name=\"TicketNumber\"]').length"
        );

        $Selenium->find_element("//input[\@name='TicketNumber']")->send_keys("$TicketNumber");
        $Selenium->find_element( "#SearchFormSubmit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && !\$('.Dialog.Modal').length" );
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # Verify search.
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Found on screen, Ticket Number - $TicketNumber",
        );

        # Return to dashboard screen.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl");
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#ToolBarSearchProfile').length" );

        # Click on test search profile.
        $Selenium->InputFieldValueSet(
            Element => '#ToolBarSearchProfile',
            Value   => 'SeleniumTest',
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a:contains(\"$TicketNumber\")').length && \$('#TicketSearch').length"
        );

        # Verify search profile.
        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Found on screen using search profile, Ticket Number - $TicketNumber",
        );

        # Check for search profile name.
        my $SearchText = "Change search options ($SearchProfileName)";
        $Self->True(
            index( $Selenium->get_page_source(), $SearchText ) > -1,
            "Found search profile name on screen - $SearchProfileName",
        );

        # Delete search profile from DB.
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM search_profile WHERE profile_name = ?",
            Bind => [ \$SearchProfileName ],
        );
        $Self->True(
            $Success,
            "Deleted test search profile",
        );

        # Delete test ticket.
        $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - $TicketID"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

$Self->DoneTesting();
