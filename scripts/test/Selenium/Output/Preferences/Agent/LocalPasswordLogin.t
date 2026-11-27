# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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
use v5.24;
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
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
        my $Preference   = $ConfigObject->Get('PreferencesGroups')->{LocalPasswordLogin}
            || die 'LocalPasswordLogin preference is missing from the rebuilt XML configuration';

        is( $Preference->{PrefKey},         'UserAllowLocalPasswordLogin', 'XML preference key is loaded' );
        is( $Preference->{PreferenceGroup}, 'UserProfile',                 'XML preference is shown in the user profile' );
        is( $Preference->{Active},          0,                             'XML hides self-service editing' );
        is( $Preference->{DataSelected},    1,                             'XML default allows local password login' );
        is( $Preference->{ValidateRegex},   '\A[01]\z',                    'XML restricts values to 0 or 1' );

        my ( $SelfLogin, $SelfUserID ) = $Helper->TestUserCreate(
            Groups => ['users'],
        );
        my ( $TargetLogin, $TargetUserID ) = $Helper->TestUserCreate(
            Groups => ['users'],
        );
        my $AdminLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        my %TargetPreferences = $UserObject->GetPreferences( UserID => $TargetUserID );
        ok( !exists $TargetPreferences{UserAllowLocalPasswordLogin}, 'admin target has no saved preference yet' );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->Login(
            Type     => 'Agent',
            User     => $SelfLogin,
            Password => $SelfLogin,
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");
        is(
            $Selenium->execute_script("return document.querySelectorAll('#UserAllowLocalPasswordLogin').length;"),
            0,
            'agent cannot see the local password preference in their own profile',
        );

        my $ChallengeToken = $Selenium->execute_script("return Core.Config.Get('ChallengeToken');");
        die 'Could not read the browser challenge token' if !$ChallengeToken;

        ok(
            $UserObject->SetPreferences(
                UserID => $SelfUserID,
                Key    => 'UserAllowLocalPasswordLogin',
                Value  => 0,
            ),
            'disable local password login while the existing session remains active',
        );

        my $SelfUpdateResponse = $Selenium->execute_async_script(
            q{
                const Done = arguments[arguments.length - 1];
                const Body = new URLSearchParams();
                Body.append('Action', 'AgentPreferences');
                Body.append('Subaction', 'UpdateAJAXComplex');
                Body.append('Group', 'LocalPasswordLogin');
                Body.append('UserAllowLocalPasswordLogin', '1');
                Body.append('ChallengeToken', arguments[0]);
                fetch(window.location.pathname, {
                    method: 'POST',
                    credentials: 'same-origin',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                    body: Body.toString()
                }).then(Response => Response.text()).then(Done).catch(Error => Done('REQUEST_ERROR: ' + String(Error)));
            },
            $ChallengeToken,
        );
        my $SelfUpdateResult = $Kernel::OM->Get('Kernel::System::JSON')->Decode( Data => $SelfUpdateResponse );
        is( $SelfUpdateResult->{Priority}, 'Error', 'AJAX self-update is rejected' );
        like(
            $SelfUpdateResult->{Message},
            qr/not allowed to change this setting/i,
            'AJAX self-update reports the inactive setting guard',
        );

        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'User' );
        my %SelfPreferences = $UserObject->GetPreferences( UserID => $SelfUserID );
        is( $SelfPreferences{UserAllowLocalPasswordLogin}, 0, 'rejected AJAX update leaves local password login disabled' );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $AdminLogin,
            Password => $AdminLogin,
        );
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile;EditUserID=$TargetUserID"
        );

        my $Field = $Selenium->find_element( '#UserAllowLocalPasswordLogin', 'css' );
        is( $Field->get_value(), '1', 'admin sees the XML default for another agent' );
        is(
            $Selenium->execute_script(
                "return Array.from(document.querySelector('#UserAllowLocalPasswordLogin').options, Option => Option.value);"
            ),
            [ '0', '1' ],
            'admin can select only the XML values 0 and 1',
        );

        for my $Value (qw(0 1)) {
            $Selenium->InputFieldValueSet(
                Element => '#UserAllowLocalPasswordLogin',
                Value   => $Value,
            );
            $Selenium->execute_script(
                "\$('#UserAllowLocalPasswordLogin').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
            );
            $Selenium->WaitFor(
                JavaScript => "return \$('#UserAllowLocalPasswordLogin').closest('.WidgetSimple').find('.fa-check').length;"
            );
            $Selenium->WaitFor(
                JavaScript => "return !\$('#UserAllowLocalPasswordLogin').closest('.WidgetSimple').hasClass('HasOverlay');"
            );

            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'User' );
            %TargetPreferences = $UserObject->GetPreferences( UserID => $TargetUserID );
            is(
                $TargetPreferences{UserAllowLocalPasswordLogin},
                $Value,
                "admin can set another agent's local password preference to $Value",
            );
        }
    }
);

done_testing();
