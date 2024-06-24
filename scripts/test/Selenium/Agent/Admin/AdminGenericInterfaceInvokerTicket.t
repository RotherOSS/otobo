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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and $Self
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AdminGenericInterfaceWebservice screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericInterfaceWebservice;Subaction=Add");

        my $RandomID = $Helper->GetRandomID();

        # Write name.
        $Selenium->find_element( '#Name', 'css' )->send_keys("Test web service $RandomID");

        # Save.
        $Selenium->find_element( '#Submit', 'css' )->VerifiedClick();

        # Select TicketCreate.
        $Selenium->InputFieldValueSet(
            Element => '#InvokerList',
            Value   => 'Ticket::TicketCreate',
        );

        # Wait until screen is loaded.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        ) || die "OTOBO API verification failed after page load.";

        # Write invoker name.
        $Selenium->find_element( '#Invoker', 'css' )->send_keys("Invoker $RandomID");

        # Save.
        $Selenium->find_element( '.Primary', 'css' )->VerifiedClick();

        # Add Event HistoryAdd.
        $Selenium->execute_script(
            '$("#TicketEvent").val("HistoryAdd");',
        );
        $Selenium->find_element( '#AddEvent', 'css' )->VerifiedClick();

        # Make sure that Events table contains HistoryAdd.
        $Selenium->find_element('//tbody/tr/td[text()="HistoryAdd"]');

        # Make sure that Events table have Condition and Edit button
        $Selenium->find_element('//thead/tr/th[text()="Condition"]');

        # Change event type to Article.
        $Selenium->execute_script(
            '$("#EventType").val("Article");',
        );

        # Add Event ArticleCreate.
        $Selenium->execute_script(
            '$("#ArticleEvent").val("ArticleCreate");',
        );
        $Selenium->find_element( '#AddEvent', 'css' )->VerifiedClick();

        # Make sure that Events table contains ArticleCreate.
        $Selenium->find_element('//tbody/tr/td[text()="ArticleCreate"]');

        # Delete Event ArticleCreate.
        $Selenium->find_element( '#DeleteEventArticleCreate', 'css' )->click();

        # Confirm delete.
        $Selenium->WaitFor(
            JavaScript => 'return $("#DialogButton2:visible").length;',
        );
        $Selenium->find_element( '#DialogButton2', 'css' )->VerifiedClick();

        my $ArticleCreateMissing = $Selenium->WaitFor(
            JavaScript => 'return $("#EventsTable tbody tr td:contains(\'ArticleCreate\')").length == 0;',
        );

        $Self->True(
            $ArticleCreateMissing,
            'ArticleCreate is deleted properly.',
        );

        # Make sure that Events table contains HistoryAdd.
        $Selenium->find_element('//tbody/tr/td[text()="HistoryAdd"]');

        # Select TicketCreate.
        $Selenium->InputFieldValueSet(
            Element => '#MappingOutbound',
            Value   => 'Simple',
        );

        # Select TicketCreate.
        $Selenium->InputFieldValueSet(
            Element => '#MappingInbound',
            Value   => 'XSLT',
        );

        # Save.
        $Selenium->find_element( '.Primary', 'css' )->VerifiedClick();

        # Click on configure outbound button.
        $Selenium->find_element( '#MappingOutboundConfigureButton', 'css' )->VerifiedClick();

        # Check if page was redirected to AdminGenericInterfaceMappingSimple.
        my $URL = $Selenium->execute_script(
            'return window.location.href;',
        );
        $Self->True(
            $URL =~ m{Action=AdminGenericInterfaceMappingSimple} ? 1 : 0,
            'Check if page was redirected properly to AdminGenericInterfaceMappingSimple',
        );

        # Cancel, go to previous screen(this screen shouldn't be tested in this package).
        $Selenium->find_element('//a/span[text()="Cancel"]')->VerifiedClick();

        # Click on configure inbound button.
        $Selenium->find_element( '#MappingInboundConfigureButton', 'css' )->VerifiedClick();

        # Check if page was redirected to AdminGenericInterfaceMappingXSLT.
        $URL = $Selenium->execute_script(
            'return window.location.href;',
        );
        $Self->True(
            $URL =~ m{Action=AdminGenericInterfaceMappingXSLT} ? 1 : 0,
            'Check if page was redirected properly to AdminGenericInterfaceMappingXSLT',
        );

        # Cancel, go to previous screen(this screen shouldn't be tested in this package).
        $Selenium->find_element('//a/span[text()="Cancel"]')->VerifiedClick();

        # Cleanup.

        # Cancel, go to previous screen.
        $Selenium->find_element('//a/span[text()="Cancel"]')->VerifiedClick();

        $Selenium->find_element( '#DeleteButton', 'css' )->click();

        # Confirm delete.
        $Selenium->WaitFor(
            JavaScript => 'return $("#DialogButton2:visible").length;',
        );
        $Selenium->find_element( '#DialogButton2', 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return $("#WebserviceTable").length',
        );
    }
);

done_testing();
