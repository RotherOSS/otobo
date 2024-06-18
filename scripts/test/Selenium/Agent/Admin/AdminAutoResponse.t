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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Defined user language for testing if message is being translated correctly.
        my $Language = 'de';

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminAutoResponse screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAutoResponse;IncludeInvalid=1");

        # Check overview AdminAutoResponse.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Selenium->find_element_ok( '.BreadCrumb', 'css', "Breadcrumb is found on Overview screen." );

        # Click 'Add auto response'.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminAutoResponse;Subaction=Add' )]")->VerifiedClick();

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Check breadcrumb on Add screen.
        my $Count;
        $Count = 1;
        for my $BreadcrumbText ( 'Auto Response Management', 'Add Auto Response' ) {
            is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $LanguageObject->Translate($BreadcrumbText),
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check page.
        for my $ID (
            qw(Name Subject RichText TypeID AddressID ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->send_keys("");

        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#Name.Error').length" );

        is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Check form action.
        ok(
            $Selenium->find_element( '#Submit', 'css' ),
            "Submit is found on Add screen.",
        );

        my $RandomNumber = $Helper->GetRandomNumber();
        my @AutoResponseNames;

        for my $Item (qw(First Second)) {

            # Navigate to 'Add auto response' screen in second case.
            if ( $Item eq 'Second' ) {
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAutoResponse;Subaction=Add");
            }

            my $AutoResponseName = $Item . 'AutoResponse' . $RandomNumber;
            my $Text             = "Selenium auto response text";

            $Selenium->find_element( "#Name",     'css' )->send_keys($AutoResponseName);
            $Selenium->find_element( "#Subject",  'css' )->send_keys($AutoResponseName);
            $Selenium->find_element( "#RichText", 'css' )->send_keys($Text);
            $Selenium->InputFieldValueSet(
                Element => '#TypeID',
                Value   => 1,
            );
            $Selenium->InputFieldValueSet(
                Element => '#AddressID',
                Value   => 1,
            );
            $Selenium->InputFieldValueSet(
                Element => '#ValidID',
                Value   => 1,
            );
            $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

            # Check if test auto response show on AdminAutoResponse screen.
            is(
                $Selenium->execute_script(
                    "return \$('table tbody tr td:contains($AutoResponseName)').length"
                ),
                1,
                "Auto response job '$AutoResponseName' is found in the table",
            );

            push @AutoResponseNames, $AutoResponseName;
        }

        # Edit test job and set it to invalid.
        $Selenium->find_element( $AutoResponseNames[0], 'link_text' )->VerifiedClick();

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText (
            $LanguageObject->Translate('Auto Response Management'),
            $LanguageObject->Translate('Edit Auto Response') . ': ' . $AutoResponseNames[0]
            )
        {
            is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check form actions.
        for my $Action (qw(Submit SubmitAndContinue)) {
            ok(
                $Selenium->find_element( "#$Action", 'css' ),
                "$Action is found on Edit screen.",
            );
        }

        $AutoResponseNames[0] = 'Update' . $AutoResponseNames[0];
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element( "#Name", 'css' )->send_keys( $AutoResponseNames[0] );
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check if edited auto response show on AdminAutoResponse.
        is(
            $Selenium->execute_script(
                "return \$('table tbody tr td:contains($AutoResponseNames[0])').length"
            ),
            1,
            "Auto response job '$AutoResponseNames[0]' is found in the table",
        );

        # Check class of invalid AutoResponse in the overview table.
        is(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($AutoResponseNames[0])').length"
            ),
            1,
            "There is a class 'Invalid' for auto response $AutoResponseNames[0]",
        );

        # Navigate to AdminAutoResponse screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminAutoResponse");

        # Filter auto responses.
        $Selenium->find_element( "#FilterAutoResponses", 'css' )->clear();
        $Selenium->find_element( "#FilterAutoResponses", 'css' )->send_keys( $AutoResponseNames[0], "\N{U+E007}" );

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('table tbody tr:visible').length === 1"
        );

        is(
            $Selenium->execute_script(
                "return \$('table tbody tr td:contains($AutoResponseNames[0])').parent().css('display')"
            ),
            'table-row',
            "Auto response '$AutoResponseNames[0]' is found in the table"
        );

        is(
            $Selenium->execute_script(
                "return \$('table tbody tr td:contains($AutoResponseNames[1])').parent().css('display')"
            ),
            'none',
            "Auto response '$AutoResponseNames[1]' is not found in the table"
        );

        $Count = 0;
        for my $ColumnName (qw(Name Type Comment Validity Changed Created)) {

            # Check if column name is translated.
            is(
                $Selenium->execute_script("return \$('#AutoResponses tr th:eq($Count)').text().trim()"),
                $LanguageObject->Translate($ColumnName),
                "Column name $ColumnName is translated",
            );
            $Count++;
        }

        # Cleanup
        # Since there are no tickets that rely on our test auto response,
        # we can remove them from the DB.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success;

        for my $TestARName (@AutoResponseNames) {
            $TestARName = $DBObject->Quote($TestARName);
            $Success    = $DBObject->Do(
                SQL  => "DELETE FROM auto_response WHERE name = ?",
                Bind => [ \$TestARName ],
            );
            ok(
                $Success,
                "Auto response '$TestARName' is deleted",
            );
        }
    }
);

done_testing();
