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
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminType screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminType");

        # Check overview screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Check for error message notification.
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"div.MessageBox.Error a[href*='Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AType']\").length;",
            ),
            'Error MessageBox is found',
        );

        # click 'add new type' link.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminType;Subaction=Add' )]")->VerifiedClick();

        # check add page.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#ValidID", 'css' );

        # Check for error message notification.
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"div.MessageBox.Error a[href*='Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AType']\").length;",
            ),
            'Error MessageBox is found',
        );

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name.Error').length" );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'Type Management', 'Add Type' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check form action.
        $Self->True(
            $Selenium->find_element( '#Submit', 'css' ),
            "Submit is found on Add screen.",
        );

        # Create a real test type.
        my $TypeRandomID = "Type" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($TypeRandomID);
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $TypeRandomID ) > -1,
            "$TypeRandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check for error message notification.
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"div.MessageBox.Error a[href*='Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AType']\").length;",
            ),
            'Error MessageBox is found',
        );

        # Go to new type again.
        $Selenium->find_element( $TypeRandomID, 'link_text' )->VerifiedClick();

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Type Management', 'Edit Type: ' . $TypeRandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check form actions.
        for my $Action (qw(Submit SubmitAndContinue)) {
            $Self->True(
                $Selenium->find_element( "#$Action", 'css' ),
                "$Action is found on Edit screen.",
            );
        }

        # Check new type values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $TypeRandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # Check for error message notification.
        $Self->True(
            $Selenium->execute_script(
                "return \$(\"div.MessageBox.Error a[href*='Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AType']\").length;",
            ),
            'Error MessageBox is found',
        );

        # Get current value of Ticket::Type::Default.
        my $DefaultTicketType = $ConfigObject->Get('Ticket::Type::Default');

        # Set test Type as a default ticket type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type::Default',
            Value => $TypeRandomID
        );

        # Try to set test type to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Default ticket type cannot be set to invalid.
        $Selenium->content_contains(
            "The ticket type is set as a default ticket type, so it cannot be set to invalid!",
            "$TypeRandomID ticket type is set as a default ticket type, so it cannot be set to invalid!",
        );

        # Reset default ticket type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type::Default',
            Value => $DefaultTicketType
        );

        # Set test type to invalid.
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->send_keys($TypeRandomID);
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check class of invalid Type in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($TypeRandomID)').length"
            ),
            "There is a class 'Invalid' for test Type",
        );

        # Check overview page.
        $Self->True(
            index( $Selenium->get_page_source(), $TypeRandomID ) > -1,
            "$TypeRandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Go to new type again.
        $Selenium->find_element( $TypeRandomID, 'link_text' )->VerifiedClick();

        # Check new type values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $TypeRandomID,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );

        # Since there are no tickets that rely on our test types, we can remove them again
        # from the DB.
        if ($TypeRandomID) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $TypeRandomID = $DBObject->Quote($TypeRandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM ticket_type WHERE name = ?",
                Bind => [ \$TypeRandomID ],
            );
            $Self->True(
                $Success,
                "TypeDelete - $TypeRandomID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Type',
        );

    }
);

$Self->DoneTesting();
