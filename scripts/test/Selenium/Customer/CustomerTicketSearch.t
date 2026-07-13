# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'CustomerFrontend::Module###CustomerTicketSearch',
            Default => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerFrontend::Module###CustomerTicketSearch',
            Value => $Setting{EffectiveValue},
        );

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check Service.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # Do not check Type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test DynamicField field.
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldName   = 'DFText' . $RandomID;
        my $DynamicFieldID     = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => 'DFlabel' . $RandomID,
            FieldOrder => 9990,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => '',
                Link         => '',
            },
            Reorder => 1,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $DynamicFieldID,
            "DynamicFieldID $DynamicFieldID is created",
        );

        # Enable SearchOverviewDynamicField.
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::CustomerTicketSearch###SearchOverviewDynamicField',
            Valid => 1,
            Value => {
                $DynamicFieldName => 1,
            },
        );

        # new in rel-11_1: force pagination
        my $ShownTickets = $Kernel::OM->Get('Kernel::Config')->Get("CustomerPreferencesGroups")->{ShownTickets};
        $ShownTickets->{Data}         = [2];
        $ShownTickets->{DataSelected} = 2;
        $Helper->ConfigSettingChange(
            Key   => 'CustomerPreferencesGroups###ShownTickets',
            Valid => 1,
            Value => $ShownTickets,
        );

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Create test customer user.
        my $TestCustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $RandomID,
            UserLastname   => $RandomID,
            UserCustomerID => $RandomID,
            UserLogin      => 'CustomerUser (Example) ' . $RandomID,
            UserPassword   => $RandomID,
            UserEmail      => "$RandomID\@example.com",
            ValidID        => 1,
            UserID         => 1
        );
        $Self->True(
            $TestCustomerUserLogin,
            "CustomerUser $TestCustomerUserLogin is created",
        );

        my $Language = 'de';
        $CustomerUserObject->SetPreferences(
            UserID => $TestCustomerUserLogin,
            Key    => 'UserLanguage',
            Value  => $Language,
        );

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $RandomID,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to CustomerTicketSearch screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # Check overview screen.
        for my $ID (
            qw(Profile TicketNumber CustomerID MIMEBase_From MIMEBase_To MIMEBase_Cc MIMEBase_Subject MIMEBase_Body
            ServiceIDs TypeIDs PriorityIDs StateIDs
            NoTimeSet Date DateRange TicketCreateTimePointStart TicketCreateTimePoint TicketCreateTimePointFormat
            TicketCreateTimeStartMonth TicketCreateTimeStartDay TicketCreateTimeStartYear TicketCreateTimeStartDayDatepickerIcon
            TicketCreateTimeStopMonth TicketCreateTimeStopDay TicketCreateTimeStopYear TicketCreateTimeStopDayDatepickerIcon
            SaveProfile Submit ResultForm)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create ticket for test scenario.
        my $TitleRandom = 'Title' . $RandomID;
        my $TicketID    = $TicketObject->TicketCreate(
            Title        => $TitleRandom,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID - created",
        );

        my @TicketIDs = ($TicketID);

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # Add test article to the ticket.
        #   Make it not visible for the customer, but with the sender type of customer, in order to check if it's
        #   filtered out correctly.
        my $InternalArticleMessage = 'not for the customer';
        my $ArticleID              = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'customer',
            Subject              => $TitleRandom,
            Body                 => $InternalArticleMessage,
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID"
        );

        # Get test ticket number.
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );

        # Set DynamicField value.
        my $ValueText = 'DFV' . $RandomID;
        my $Success   = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
            FieldID    => $DynamicFieldID,
            ObjectType => 'Ticket',
            ObjectID   => $TicketID,
            Value      => [
                {
                    ValueText => $ValueText,
                },
            ],
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Value for DynamicFieldID $DynamicFieldID is set to TicketID $TicketID '$ValueText' successfully",
        );

        # Input ticket number as search parameter.
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys( $Ticket{TicketNumber} );
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # Check if internal article was not shown.
        $Self->True(
            index( $Selenium->get_page_source(), $InternalArticleMessage ) == -1,
            'Internal article not found on page'
        );

        # Verify translated 'Body' field label.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        #        obsolete? there is no DF output in CustomerTicketOverview.tt, which is now
        #        used to display results instead of CustomerTicketSearch.tt
        #        see https://github.com/RotherOSS/otobo/issues/5616
        #
        #        # Check if DynamicField value is available in CustomerTicketSearch result screen.
        #        # See https://bugs.otrs.org/show_bug.cgi?id=13818.
        #        $Self->True(
        #            index( $Selenium->get_page_source(), "$ValueText" ) > -1,
        #            "DynamicField value is found - $DynamicFieldName:$ValueText",
        #       );

        # Navigate to CustomerTicketSearch screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        my $SearchText = $LanguageObject->Translate('last-search');
        $Selenium->find_element( "#Profile_Search", 'css' )->click();
        $Selenium->execute_script("\$('a:contains(\"$SearchText\")').click()");
        $Selenium->execute_script("\$('button[name=\"SelectTamplate\"]').click();");

        # Input more search filters, result should be 'No data found'.
        $Selenium->find_element( "#TicketNumber", 'css' )->clear();
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys("123456789012345");
        $Selenium->InputFieldValueSet(
            Element => '#StateIDs',
            Value   => "[1, 4]",
        );
        $Selenium->InputFieldValueSet(
            Element => '#PriorityIDs',
            Value   => "[2, 3]",
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        my $EmptySearch = $LanguageObject->Translate('Nothing to show.');

        # Check for expected result.
        $Self->Is(
            $Selenium->execute_script("return \$('h3:contains(\"$EmptySearch\")').length;"),
            1,
            "Ticket is not found on page",
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        $Selenium->find_element( "#Profile_Search", 'css' )->click();
        $Selenium->execute_script("\$('a:contains(\"$SearchText\")').click()");
        $Selenium->execute_script("\$('button[name=\"SelectTemplate\"]').click();");

        sleep(2);

        $Self->Is(
            $Selenium->execute_script("return \$('#TicketNumber').val();"),
            "123456789012345",
            "Ticket Number was saved in last search"
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # Test without customer company ticket access for bug#12595.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerDisableCompanyTicketAccess',
            Value => 1,
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # Input ticket number as search parameter.
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys( $Ticket{TicketNumber} );
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # Check if pagination is shown correctly when search limit is used. See bug#14556.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::CustomerTicketSearch::SearchLimit',
            Value => 5,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::CustomerTicketSearch::SearchPageShown',
            Value => 2,
        );

        for my $Item ( 1 .. 4 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => "Title$Item$RandomID",
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerUser => $TestCustomerUserLogin,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket ID $TicketID - created",
            );
            push @TicketIDs, $TicketID;
        }

        # Navigate to CustomerTicketSearch screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # Search all tickets.
        $Selenium->find_element( "#TicketNumber", 'css' )->clear();
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys('*');
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # Check next result page.
        $Selenium->find_element( "#CustomerTicketOverviewPage2", 'css' )->VerifiedClick();

        # Check last result page.
        $Selenium->find_element( "#CustomerTicketOverviewPage3", 'css' )->VerifiedClick();

        for my $TicketID (@TicketIDs) {

            # Clean up test data from the DB.
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
                "TicketID $TicketID is deleted"
            );
        }

        # Delete test created DynamicField.
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        $Self->True(
            $DynamicFieldID,
            "DynamicFieldID $DynamicFieldID is deleted",
        );

        # Delete test created customer user.
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser $TestCustomerUserLogin is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw (Ticket CustomerUser)) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

$Self->DoneTesting();
