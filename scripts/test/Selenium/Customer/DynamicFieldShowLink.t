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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # Get needed objects.
        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'Test Company',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        ok( $TicketID, "TicketID $TicketID is created" );

        # Create dynamic field.
        my $RandomNumber     = $Helper->GetRandomNumber();
        my $DynamicFieldName = 'DF' . $RandomNumber;
        my $DynamicFieldLink = "https://www.example.com";
        my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => $DynamicFieldName,
            FieldOrder => 9991,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                Link        => $DynamicFieldLink,
                LinkPreview => 'https://www.otobo.org',
            },
            ValidID => 1,
            UserID  => 1,
        );
        ok( $DynamicFieldID, "DynamicFieldID $DynamicFieldID is created" );

        # Set dynamic field value.
        my $ValueText = 'Click on Link' . $RandomNumber;
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
        ok( $Success, "DynamicFieldID $DynamicFieldID is set to '$ValueText' successfully" );

        # Set SysConfig to show dynamic field in CustomerTicketZoom screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketZoom###DynamicField',
            Value => { $DynamicFieldName => 1 },
        );

        # Login as test created customer.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");

        # Check existence of test dynamic field in 'Information' popup.
        $Selenium->LogExecuteCommandActive(0);
        $Selenium->find_element_by_xpath_ok(
            qq{//div[\@class="oooSection"]/p[\@class="ooo12"]/span[\@class="ooo12g"][contains(text(), "$DynamicFieldName")]}
        );
        $Selenium->LogExecuteCommandActive(1);
        is(
            $Selenium->execute_script(
                "return \$('div.oooSection p.ooo12 span.ooo12g:contains($DynamicFieldName)').siblings('a.DynamicFieldLink').length;"
            ),
            1,
            "Link for DynamicFieldName $DynamicFieldName is found in 'Information' popup",
        );

        # Check dynamic field text.
        my $ValueTextShortened = substr $ValueText, 0, 20;
        $ValueTextShortened .= '[...]';
        is(
            $Selenium->execute_script(
                "return \$('div.oooSection p.ooo12 span.ooo12g:contains($DynamicFieldName)').siblings('a.DynamicFieldLink').text();"
            ),
            $ValueTextShortened,
            "Dynamic field text '$ValueTextShortened' is correct",
        );

        # Check dynamic field link.
        is(
            $Selenium->execute_script(
                "return \$('div.oooSection p.ooo12 span.ooo12g:contains($DynamicFieldName)').siblings('a.DynamicFieldLink').attr('href');"
            ),
            $DynamicFieldLink,
            "Dynamic field link '$DynamicFieldLink' is correct",
        );

        # Hover dynamic field link.
        $Selenium->execute_script(
            "\$('div.oooSection p.ooo12 span.ooo12g:contains($DynamicFieldName)').siblings('a.DynamicFieldLink').mouseenter();"
        );

        # Wait for the floater to be fully visible.
        $Selenium->WaitFor(
            JavaScript => "return parseInt(\$('div.MetaFloater:visible').css('opacity'), 10) === 1;"
        );

        # Check if a floater is visible now.
        is(
            $Selenium->execute_script("return \$('div.MetaFloater:visible').length"),
            1,
            'Floater is visible',
        );

        # Delete test created ticket.
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
        ok( $Success, "TicketID $TicketID is deleted" );

        # Delete test created dynamic field.
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        ok( $Success, "DynamicFieldID $DynamicFieldID is deleted" );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }
);

done_testing();
