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

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::Language ();

our $Self;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $Language = 'de';

        # Do not validate email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminEmail");

        # Check page.
        for my $ID (
            qw(From UserIDs GroupIDs GroupPermissionRO GroupPermissionRW Subject RichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # If there are roles, there will be select box for roles in AdminEmail.
        my %RoleList = $Kernel::OM->Get('Kernel::System::Group')->RoleList( Valid => 1 );
        if (%RoleList) {
            my $Element = $Selenium->find_element( "#RoleIDs", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        $Self->Is(
            $Selenium->find_element( '#From', 'css' )->get_value(),
            $Kernel::OM->Get('Kernel::Config')->Get("AdminEmail"),
            "#From stored value",
        );

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Subject", 'css' );
        $Element->send_keys("");
        $Selenium->find_element( "#submitRichText", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Subject').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create test admin notification.
        my $RandomID = $Helper->GetRandomID();
        my $Text     = "Selenium Admin Notification test";
        my $UserID   = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        $Selenium->InputFieldValueSet(
            Element => '#UserIDs',
            Value   => $UserID,
        );
        $Selenium->find_element( "#Subject",        'css' )->send_keys($RandomID);
        $Selenium->find_element( "#RichText",       'css' )->send_keys($Text);
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Check if test admin notification is success.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $Expected = $LanguageObject->Translate(
            "Your message was sent to"
        ) . ": $TestUserLogin\@localunittest.com";

        $Self->True(
            index( $Selenium->get_page_source(), $Expected ) > -1,
            "$RandomID admin notification was sent",
        );

    }

);

$Self->DoneTesting();
