# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        # change test user password preference, input incorrect current password
        my $NewPw = "newáél" . $TestUserLogin;
        $Selenium->find_element( "#CurPw",  'css' )->send_keys("incorrect");
        $Selenium->find_element( "#NewPw",  'css' )->send_keys($NewPw);
        $Selenium->find_element( "#NewPw1", 'css' )->send_keys($NewPw);

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#NewPw1').val()"
            ),
            $NewPw,
            'NewPw field has accepted accentuated letters',
        );

        $Selenium->execute_script(
            "\$('#NewPw1').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#NewPw1').closest('.WidgetSimple').find('.WidgetMessage.Error:visible').length"
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#NewPw1').closest('.WidgetSimple').find('.WidgetMessage.Error').text()"
            ),
            "The current password is not correct. Please try again!",
            'Error message shows up correctly',
        );

        # change test user password preference, correct input
        $Selenium->find_element( "#CurPw",  'css' )->send_keys($TestUserLogin);
        $Selenium->find_element( "#NewPw",  'css' )->send_keys($NewPw);
        $Selenium->find_element( "#NewPw1", 'css' )->send_keys($NewPw);

        $Selenium->execute_script(
            "\$('#NewPw1').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#NewPw1').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # Verify password change is successful.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $NewPw,
        );
        $Self->True(
            $Selenium->find_element( 'a#LogoutButton', 'css' ),
            "Password change is successful"
        );
    }
);


$Self->DoneTesting();


