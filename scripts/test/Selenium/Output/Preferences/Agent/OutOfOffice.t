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

        # Set OTOBOTimeZone to UTC.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'OTOBOTimeZone',
            Value => 'UTC',
        );

        # Create and login test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to agent preferences.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#UserTimeZone',
            Event       => 'change',
        );

        # Change test user time zone preference to -5 hours. Displayed out of office date values
        #   should not be converted to local time zone, see bug#12471.
        $Selenium->InputFieldValueSet(
            Element => '#UserTimeZone',
            Value   => 'Pacific/Easter',
        );

        $Self->True(
            $Selenium->execute_script("return \$('#UserTimeZone').val() == 'Pacific/Easter';"),
            "UserTimeZone is set to 'Pacific/Easter'",
        );

        $Selenium->execute_script(
            "\$('#UserTimeZone').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserTimeZone').closest('.WidgetSimple').find('.fa-check').length;"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserTimeZone').closest('.WidgetSimple').hasClass('HasOverlay');"
        );

        # Reload the screen.
        $Selenium->VerifiedRefresh();

        # Get current date and time components.
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime'
        );
        my $Date = $DateTimeObject->Get();

        # Change test user out of office preference to current date.
        $Selenium->find_element( "#OutOfOfficeOn", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#OutOfOfficeOn:checked').length;"
        );

        for my $FieldGroup (qw(Start End)) {
            for my $FieldType (qw(Year Month Day)) {
                $Selenium->execute_script(
                    "\$('#OutOfOffice$FieldGroup$FieldType').val($Date->{$FieldType}).trigger('change');"
                );
                $Self->True(
                    $Selenium->execute_script(
                        "return \$('#OutOfOffice$FieldGroup$FieldType').val() == '$Date->{$FieldType}';"
                    ),
                    "OutOfOffice$FieldGroup$FieldType is set to '$Date->{$FieldType}'",
                );
            }
        }
        $Selenium->execute_script(
            "\$('#OutOfOfficeOn').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').find('.fa-check').length;"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#OutOfOfficeOn').closest('.WidgetSimple').hasClass('HasOverlay');"
        );

        # Reload the screen.
        $Selenium->VerifiedRefresh();

        # Check displayed date and time values.
        for my $FieldGroup (qw(Start End)) {
            for my $FieldType (qw(Year Month Day)) {
                $Self->Is(
                    int $Selenium->find_element( "#OutOfOffice$FieldGroup$FieldType", 'css' )->get_value(),
                    int $Date->{$FieldType},
                    "Shown OutOfOffice$FieldGroup$FieldType field value"
                );
            }
        }

        # Set start time after end time, see bug #8220.
        my $StartYear = $Date->{Year} + 2;
        $Selenium->execute_script(
            "\$('#OutOfOfficeStartYear').val('$StartYear').trigger('change');"
        );

        $Self->True(
            $Selenium->execute_script("return \$('#OutOfOfficeStartYear').val() == $StartYear;"),
            "OutOfOfficeStartYear is set to '$StartYear'",
        );

        $Selenium->execute_script(
            "\$('#OutOfOfficeOn').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').find('.WidgetMessage.Error:visible').length;"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#OutOfOfficeOn').closest('.WidgetSimple').find('.WidgetMessage.Error').text();"
            ),
            "Please specify an end date that is after the start date.",
            'Error message shows up correctly',
        );
    }
);

$Self->DoneTesting();
