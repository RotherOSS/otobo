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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminTemplate screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminTemplate");

        # Check overview screen.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );
        $Selenium->find_element( "#Filter",           'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'Add template'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminTemplate;Subaction=Add' )]")->VerifiedClick();

        for my $ID (
            qw(TemplateType Name IDs ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

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
        for my $BreadcrumbText ( 'Template Management', 'Add Template' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Create real test template.
        my $TemplateRandomID = "Template" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name",    'css' )->send_keys($TemplateRandomID);
        $Selenium->find_element( "#Comment", 'css' )->send_keys("Selenium template test");
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check overview screen for test template.
        $Self->True(
            $Selenium->execute_script("return \$('#Templates tbody tr:contains($TemplateRandomID)').length"),
            "Template $TemplateRandomID found on page",
        );

        # Test search filter.
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($TemplateRandomID);
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Templates tbody tr:visible').length === 1"
        );

        $Self->True(
            $Selenium->find_element( $TemplateRandomID, 'link_text' )->is_displayed(),
            "Template $TemplateRandomID found on screen",
        );

        # Check test template values.
        $Selenium->find_element( $TemplateRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $TemplateRandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#TemplateType', 'css' )->get_value(),
            "Answer",
            "#TemplateType stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "Selenium template test",
            "#Comment stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Template Management', 'Edit Template: ' . $TemplateRandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Edit test template.
        $Selenium->find_element( "#Comment", 'css' )->clear();

        $Selenium->InputFieldValueSet(
            Element => '#TemplateType',
            Value   => 'Create',
        );
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->InputFieldValueSet(
            Element => '#TemplateType',
            Value   => 'Create',
        );
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check is there notification after template is updated.
        my $Notification = 'Template updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Test search filter.
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($TemplateRandomID);
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#Templates tbody tr:visible').length === 1"
        );

        # Check class of invalid Template in the overview table.
        $Self->True(
            $Selenium->find_element( "tr.Invalid", 'css' ),
            "There is a class 'Invalid' for test Template",
        );

        # Check edited test template.
        $Selenium->find_element( $TemplateRandomID, 'link_text' )->VerifiedClick();

        $Self->Is(
            $Selenium->find_element( '#TemplateType', 'css' )->get_value(),
            "Create",
            "#TemplateType updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            "",
            "#Comment updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );

        # Go back to AdminTemplate overview screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminTemplate");

        # Test template delete button.
        my $TemplateID = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateLookup(
            StandardTemplate => $TemplateRandomID,
        );

        $Selenium->find_element("//a[contains(\@data-query-string, \'Subaction=Delete;ID=$TemplateID' )]")->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal #DialogButton1").length'
        );

        # Verify delete dialog message.
        my $DeleteMessage = "Do you really want to delete this template?";
        $Self->True(
            $Selenium->execute_script("return \$('#DeleteTemplateDialog:contains($DeleteMessage)').length"),
            "Delete message is found",
        );

        # Confirm delete action.
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # Check if template sits on overview page.
        $Self->True(
            $Selenium->execute_script("return !\$('#Templates tbody tr:contains($TemplateRandomID)').length"),
            "Template '$TemplateRandomID' is deleted"
        );
    }
);

$Self->DoneTesting();
