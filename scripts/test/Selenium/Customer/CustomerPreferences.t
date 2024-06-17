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

# Note that the frontend module CustomerPreferences is not supported yet.
# See https://github.com/RotherOSS/otobo/issues/693

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self (unused) and $Kernel::OM
use Kernel::Language;
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(

    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable google authenticator shared secret preference
        my $SharedSecretConfig = $Kernel::OM->Get('Kernel::Config')->Get('CustomerPreferencesGroups')->{'GoogleAuthenticatorSecretKey'};
        $SharedSecretConfig->{Active} = 1;
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CustomerPreferencesGroups###GoogleAuthenticatorSecretKey',
            Value => $SharedSecretConfig,
        );

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to CustomerPreference screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        # Check the CustomerPreferences screen.
        # Some elements are off screen, but can be scrolled to. Don't check is_displayed_ok() for these elements.
        my %IsOnScreen = map { $_ => 1 } qw(CurPw NewPw NewPw1 UserGoogleAuthenticatorSecretKey);
        for my $ID (qw(CurPw NewPw NewPw1 UserGoogleAuthenticatorSecretKey UserLanguage UserShowTickets UserRefreshTime)) {
            my $Element = $Selenium->find_element_by_id($ID);    # throws no exception when no element is found
            ok( $Element, "element with id $ID was found" );
            $Element->is_enabled_ok();
            if ( $IsOnScreen{$ID} ) {
                $Element->is_displayed_ok();
            }
        }

        # check CustomerPreferences default values
        is(
            $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
            'en',
            '#UserLanguage stored value',
        );
        is(
            $Selenium->find_element( '#UserRefreshTime', 'css' )->get_value(),
            "0",
            "#UserRefreshTime stored value",
        );
        is(
            $Selenium->find_element( '#UserShowTickets', 'css' )->get_value(),
            "25",
            "#UserShowTickets stored value",
        );

        # edit checked stored values
        $Selenium->InputFieldValueSet(
            Element => '#UserRefreshTime',
            Value   => 2,
        );
        $Selenium->find_element( '#UserRefreshTimeUpdate', 'css' )->VerifiedClick();

        $Selenium->InputFieldValueSet(
            Element => '#UserShowTickets',
            Value   => 20,
        );
        $Selenium->find_element( '#UserShowTicketsUpdate', 'css' )->VerifiedClick();

        # check edited values
        is(
            $Selenium->find_element( '#UserRefreshTime', 'css' )->get_value(),
            '2',
            '#UserRefreshTime updated value',
        );

        is(
            $Selenium->find_element( '#UserShowTickets', 'css' )->get_value(),
            '20',
            "#UserShowTickets updated value",
        );

        # test different language scenarios
        for my $Language (qw(de es ru zh_CN sr_Cyrl en)) {

            # change CustomerPreference language
            $Selenium->InputFieldValueSet(
                Element => '#UserLanguage',
                Value   => $Language,
            );

            $Selenium->find_element( '#UserLanguageUpdate', 'css' )->VerifiedClick();

            $Selenium->LogExecuteCommandActive(0);

            # check edited language value
            is(
                $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
                "$Language",
                "#UserLanguage updated value",
            );

            # create language object
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $Language,
            );

            # check for correct translation
            $Selenium->content_contains(
                $LanguageObject->Translate('Interface language'),
                "Test widget 'Interface language' found on screen"
            );
            $Selenium->content_contains(
                $LanguageObject->Translate('Number of displayed tickets'),
                "Test widget 'Number of displayed tickets' found on screen"
            );
            $Selenium->content_contains(
                $LanguageObject->Translate('Ticket overview'),
                "Test widget 'Ticket overview' found on screen"
            );

            $Selenium->LogExecuteCommandActive(1);
        }

        # try updating the UserGoogleAuthenticatorSecret (which has a regex validation configured)
        $Selenium->find_element( "#UserGoogleAuthenticatorSecretKey",       'css' )->send_keys('Invalid Key');
        $Selenium->find_element( '#UserGoogleAuthenticatorSecretKeyUpdate', 'css' )->VerifiedClick();
        $Selenium->content_contains(
            $SharedSecretConfig->{'ValidateRegexMessage'},
            "Error message for invalid shared secret found on screen"
        );

        # now use a valid secret
        $Selenium->find_element( "#UserGoogleAuthenticatorSecretKey",       'css' )->send_keys('ABCABCABCABCABC2');
        $Selenium->find_element( '#UserGoogleAuthenticatorSecretKeyUpdate', 'css' )->VerifiedClick();
        $Selenium->content_contains(
            'Preferences updated successfully!',
            "Success message found on screen"
        );

        # Inject malicious code in user language variable.
        my $MaliciousCode = 'en\\\'});window.iShouldNotExist=true;Core.Config.AddConfig({a:\\\'';
        $Selenium->execute_script(
            "\$('#UserLanguage').append(
                \$('<option/>', {
                    value: '$MaliciousCode',
                    text: 'Malevolent'
                })
            ).val('$MaliciousCode').trigger('redraw.InputField').trigger('change');"
        );

        # TODO: CustomerPreference not fully implemented
        #$Selenium->find_element( '#UserLanguageUpdate', 'css' )->VerifiedClick();

        # Check if malicious code was sanitized.
        #ok(
        #    $Selenium->execute_script(
        #        "return typeof window.iShouldNotExist === 'undefined';"
        #    ),
        #    'Malicious variable is undefined'
        #);
    }
);

done_testing();
