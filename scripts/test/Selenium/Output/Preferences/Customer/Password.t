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
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestCustomerUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to customer preferences
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerPreferences");

        try_ok {

            # Change test customer password preference to a password with accents.
            # First input an incorrect current password.
            my $NewPw = "newáél" . $TestUserLogin;
            $Selenium->find_element( "#CurPw",  'css' )->send_keys("incorrect");
            $Selenium->find_element( "#NewPw",  'css' )->send_keys($NewPw);
            $Selenium->find_element( "#NewPw1", 'css' )->send_keys($NewPw);
            $Selenium->find_element( "#Update", 'css' )->VerifiedClick();

            # check for incorrect password update preferences message on screen
            my $IncorrectUpdateMessage = "The current password is not correct. Please try again!";
            $Selenium->content_contains( $IncorrectUpdateMessage, 'Customer incorrect preferences password - update' );

            # change test customer password preference, use the correct current password this time
            $Selenium->find_element( "#CurPw",  'css' )->send_keys($TestUserLogin);
            $Selenium->find_element( "#NewPw",  'css' )->send_keys($NewPw);
            $Selenium->find_element( "#NewPw1", 'css' )->send_keys($NewPw);
            $Selenium->find_element( "#Update", 'css' )->VerifiedClick();

            # check for correct password update preferences message on screen
            my $UpdateMessage = "Preferences updated successfully!";
            $Selenium->content_contains( $UpdateMessage, 'Customer preference password - updated' );
        };
    }
);

done_testing();
