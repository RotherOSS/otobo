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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self (unused) and $Kernel::OM
use Kernel::Language;
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable google authenticator shared secret preference
        my $SharedSecretConfig = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups')->{'GoogleAuthenticatorSecretKey'};
        $SharedSecretConfig->{Active} = 1;
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "PreferencesGroups###GoogleAuthenticatorSecretKey",
            Value => $SharedSecretConfig,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # Simulate that we have overridden setting in the .pm file.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::ZoomTimeDisplay',
            Value => 1,
        );

        # create test user and login
        my $Language      = "en";
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', 'admin' ],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # add a test notification
        my $RandomID                = $Helper->GetRandomID();
        my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
        my $NotificationID          = $NotificationEventObject->NotificationAdd(
            Name => 'NotificationTest' . $RandomID,
            Data => {
                Events          => ['TicketQueueUpdate'],
                VisibleForAgent => ['2'],
                Transports      => ['Email'],
            },
            Message => {
                en => {
                    Subject     => 'Subject',
                    Body        => 'Body',
                    ContentType => 'text/html',
                },
            },
            ValidID => 1,
            UserID  => 1,
        );
        ok( $NotificationID, "Created test notification" );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentPreferences screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        my $PreferencesGroups = $Kernel::OM->Get('Kernel::Config')->Get('AgentPreferencesGroups');

        my @GroupNames = map { $_->{Key} } @{$PreferencesGroups};

        # check if the default groups are present (UserProfile)
        for my $Group (@GroupNames) {
            my $Element = $Selenium->find_element("//a[contains(\@href, \'Group=$Group')]");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # enter the user profile group
        $Selenium->find_element("//a[contains(\@href, \'Group=UserProfile')]")->VerifiedClick();

        # check for some settings
        ID:
        for my $ID (
            qw(CurPw NewPw NewPw1 UserTimeZone_Search UserLanguage_Search OutOfOfficeOn OutOfOfficeOff UserGoogleAuthenticatorSecretKey GenerateUserGoogleAuthenticatorSecretKey)
            )
        {
            # Scroll to element view if necessary.
            my $ScrollSuccess = try_ok {
                $Selenium->execute_script("\$('#$ID')[0].scrollIntoView(true);");
            };

            next ID unless $ScrollSuccess;

            my $Element = $Selenium->find_element( "#$ID", 'css' );

            ok( $Element,                 "element $ID found" );
            ok( $Element->is_enabled(),   "$ID is enabled." );
            ok( $Element->is_displayed(), "$ID is displayed." );
        }

        # Click on "Generate" button.
        $Selenium->find_element( "#GenerateUserGoogleAuthenticatorSecretKey", 'css' )->click();

        # Wait until generated key is there.
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserGoogleAuthenticatorSecretKey').val().length"
        );

        my $SecretKey = $Selenium->execute_script(
            "return \$('#UserGoogleAuthenticatorSecretKey').val();"
        );
        like( $SecretKey, qr/[A-Z2-7]{16}/, 'Secret key is valid.' );

        # check some of AgentPreferences default values
        is(
            $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
            "en",
            "#UserLanguage stored value",
        );

        # test different language scenarios
        my @Languages = (qw(de es ru zh_CN sr_Cyrl en));
        my $Count     = 0;
        for my $Language (@Languages) {

            # change AgentPreference language
            $Selenium->InputFieldValueSet(
                Element => '#UserLanguage',
                Value   => $Language,
            );

            $Selenium->WaitForjQueryEventBound(
                CSSSelector =>
                    "form:has(input[type=hidden][name=Group][value=Language]) .WidgetSimple .SettingUpdateBox button",
            );

            $Selenium->execute_script(
                "\$('#UserLanguage').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
            );

            # wait for the ajax call to finish
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
            );
            $Selenium->WaitFor(
                JavaScript =>
                    "return !\$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
            );

            # check edited language value
            is(
                $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
                "$Language",
                "#UserLanguage updated value",
            );

            # create language object
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => $Languages[ $Count - 1 ],
            );

            # check, if reload notification is shown
            my $NotificationTranslation = $LanguageObject->Translate(
                "Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen."
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('div.MessageBox.Notice:contains(\"" . $NotificationTranslation . "\")').length"
            );

            # reload the screen
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

            # check for correct translation
            $LanguageObject = Kernel::Language->new(
                UserLanguage => $Language,
            );
            for my $String ( 'Change password', 'Language', 'Out Of Office Time' ) {

                my $Translation = $LanguageObject->Translate($String);
                $Selenium->content_contains(
                    $Translation,
                    "Test widget '$String' found on screen for language $Language ($Translation)"
                );
            }

            $Count++;
        }

        # try updating the UserGoogleAuthenticatorSecret (which has a regex validation configured)
        $Selenium->find_element( "#UserGoogleAuthenticatorSecretKey", 'css' )->send_keys('Invalid Key');

        $Selenium->WaitForjQueryEventBound(
            CSSSelector =>
                "form:has(input[type=hidden][name=Group][value=GoogleAuthenticatorSecretKey]) .WidgetSimple .SettingUpdateBox button",
        );

        $Selenium->execute_script(
            "\$('#UserGoogleAuthenticatorSecretKey').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#UserGoogleAuthenticatorSecretKey').closest('.WidgetSimple').find('.WidgetMessage.Error:visible').length"
        );

        # wait for the message to disappear again
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserGoogleAuthenticatorSecretKey').closest('.WidgetSimple').find('.WidgetMessage.Error:visible').length"
        );

        # clear the field and then use a valid secret
        $Selenium->find_element( "#UserGoogleAuthenticatorSecretKey", 'css' )->clear();
        $Selenium->find_element( "#UserGoogleAuthenticatorSecretKey", 'css' )->send_keys('ABCABCABCABCABC2');
        $Selenium->execute_script(
            "\$('#UserGoogleAuthenticatorSecretKey').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserGoogleAuthenticatorSecretKey').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserGoogleAuthenticatorSecretKey').closest('.WidgetSimple.HasOverlay').find('.fa-check:visible').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserGoogleAuthenticatorSecretKey').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # check if the correct avatar widget is displayed (engine disabled)
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::AvatarEngine',
            Value => 'None',
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");
        $Selenium->content_contains(
            "Avatars have been disabled by the system administrator. You'll see your initials instead.",
            "Avatars disabled message found"
        );

        # now set engine to 'Gravatar' and reload the screen
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::AvatarEngine',
            Value => 'Gravatar',
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");
        $Selenium->content_contains(
            "You can change your avatar image by registering with your email address",
            "Gravatar message found"
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

        $Selenium->WaitForjQueryEventBound(
            CSSSelector =>
                "form:has(input[type=hidden][name=Group][value=Language]) .WidgetSimple .SettingUpdateBox button",
        );

        $Selenium->execute_script(
            "\$('#UserLanguage').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );

        # Wait for the AJAX call to finish.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # Reload the screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        # Check if malicious code was sanitized.
        ok(
            $Selenium->execute_script(
                "return typeof window.iShouldNotExist === 'undefined';"
            ),
            'Malicious variable is undefined'
        );

        # head over to the notification settings group
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=NotificationSettings"
        );

        # check for some settings
        for my $ID (
            qw(QueueID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        $Selenium->content_contains(
            qq{<span class="Mandatory">* NotificationTest$RandomID</span>},
            "Notification correctly marked as mandatory in preferences."
        );

        my $CheckAlertJS = <<"JAVASCRIPT";
(function () {
    var lastAlert = undefined;
    window.alert = function (message) {
        lastAlert = message;
    };
    window.getLastAlert = function () {
        var result = lastAlert;
        lastAlert = undefined;
        return result;
    };
}());
JAVASCRIPT

        $Selenium->execute_script($CheckAlertJS);

        # we should not be able to save the notification setting without an error
        $Selenium->execute_script(
            "\$('.NotificationEvent').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );

        # wait for the ajax call to finish, an error message should occurr
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.NotificationEvent').closest('.WidgetSimple').find('.WidgetMessage.Error:visible').length"
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        is(
            $Selenium->execute_script(
                "return \$('.NotificationEvent').closest('.WidgetSimple').find('.WidgetMessage.Error').text()"
            ),
            $LanguageObject->Translate(
                "Please make sure you've chosen at least one transport method for mandatory notifications."
            ),
            'Error message shows up correctly',
        );

        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('.NotificationEvent').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # now enable the checkbox and try to submit again, it should work this time
        $Selenium->find_element( "#Notification-$NotificationID-Email-checkbox", 'css' )->click();

        $Selenium->execute_script(
            "\$('.NotificationEvent').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );

        # wait for the ajax call to finish
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('.NotificationEvent').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('.NotificationEvent').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('.NotificationEvent').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # now that the checkbox is checked, it should not be possible to disable it again
        $Selenium->find_element( "#Notification-$NotificationID-Email-checkbox", 'css' )->click();

        is(
            $Selenium->execute_script("return window.getLastAlert()"),
            $LanguageObject->Translate("Sorry, but you can't disable all methods for this notification."),
            'Alert message shows up correctly',
        );

        # delete notification entry again
        my $SuccessDelete = $NotificationEventObject->NotificationDelete(
            ID     => $NotificationID,
            UserID => 1,
        );
        ok( $SuccessDelete, "Delete test notification - $NotificationID" );

        # head over to misc settings
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=Miscellaneous");

        # check for some settings
        for my $ID (
            qw(UserSkin UserRefreshTime UserCreateNextMask)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        is(
            $Selenium->find_element( '#UserSkin', 'css' )->get_value(),
            $Kernel::OM->Get('Kernel::Config')->Get('Loader::Agent::DefaultSelectedSkin'),
            "#UserSkin stored value",
        );

        # edit some of checked stored values
        $Selenium->InputFieldValueSet(
            Element => '#UserSkin',
            Value   => 'ivory',
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector =>
                "form:has(input[type=hidden][name=Group][value=Skin]) .WidgetSimple .SettingUpdateBox button",
        );

        $Selenium->execute_script(
            "\$('#UserSkin').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );

        # wait for the ajax call to finish
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' &&  \$('#UserSkin').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserSkin').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserSkin').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        $Selenium->find_element_ok(
            "//div[contains(\@class, 'MessageBox Notice' )]//a[contains(\@href, 'Action=AgentPreferences;Subaction=Group;Group=Miscellaneous' )]",
            'xpath',
            "Notification contains user miscellaneous group link"
        );

        # check, if reload notification is shown
        $LanguageObject = Kernel::Language->new(
            UserLanguage => "en",
        );

        my $NotificationTranslation = $LanguageObject->Translate(
            "Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen."
        );

        $Selenium->WaitFor(
            JavaScript =>
                "return \$('div.MessageBox.Notice:contains(\"" . $NotificationTranslation . "\")').length"
        );

        $Selenium->find_element_ok(
            "//div[contains(\@class, 'MessageBox Notice' )]//a[contains(\@href, 'Action=AgentPreferences;Subaction=Group;Group=UserProfile' )]",
            'xpath',
            "Notification contains user profile group link"
        );

        # reload the screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=Miscellaneous");

        # check edited values
        my $UserSkin = $Selenium->find_element( '#UserSkin', 'css' )->get_value();
        {
            my $ToDo = todo('skin ivory does not exist in OTOBO, issue #678');

            is( $UserSkin, "ivory", "#UserSkin updated value" );
        }
    }
);

done_testing();
