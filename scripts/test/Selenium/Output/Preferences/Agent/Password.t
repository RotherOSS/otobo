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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self (unused) and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

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

        # Change test user password preference to a password with accents.
        # First input an incorrect current password.
        my $NewPw = "newáél" . $TestUserLogin;
        $Selenium->find_element( "#CurPw",  'css' )->send_keys('incorrect');
        $Selenium->find_element( "#NewPw",  'css' )->send_keys($NewPw);
        $Selenium->find_element( "#NewPw1", 'css' )->send_keys($NewPw);

        is(
            $Selenium->execute_script("return \$('#NewPw1').val()"),
            $NewPw,
            'NewPw field has been accepted',
        );

        $Selenium->execute_script(
            "\$('#NewPw1').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#NewPw1').closest('.WidgetSimple').find('.WidgetMessage.Error:visible').length"
        );
        is(
            $Selenium->execute_script(
                "return \$('#NewPw1').closest('.WidgetSimple').find('.WidgetMessage.Error').text()"
            ),
            "The current password is not correct. Please try again!",
            'Error message shows up correctly',
        );

        # change test user password preference, use the correct current password this time
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
        ok(
            $Selenium->find_element( 'a#LogoutButton', 'css' ),
            "Password change is successful"
        );
    }
);

done_testing();
