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

# you can find a copy+paste ready version of this file at development/templates/testing/SeleniumTest.t

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;    # please use this for assertions

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;      # Set up $Selenium

# OTOBO specific test helpers
# $Selenium provides all the functions of Test::Selenium::Remote::Driver
# as well as OTOBO specific helper functions ie. for logging in or drag-and-drop
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

# OTOBO specific helper functions, ie. user creation / changing sysconfig settings
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# writing the test as an anonymous function handed to RunTest() we make sure that it is only
# executed if Selenium testing is activated. Otherwise it will just skip with a logged comment.
$Selenium->RunTest(
    sub {

        # Set up: if you need a lot of steps for you setup please add a short comment why it is neede for your test

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # create test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        #log in as test user
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Test: please state which functionality you are testing, not how you are testing it
        # test if logo is in DOM after login

        # check if the page has loaded successfully
        $Selenium->VerifiedGet("${ScriptAlias}index.pl");

        # verify that the logo is present in the html as expected
        ok(
            $Selenium->find_element( 'body #Logo', 'css' ),
            'Logo found!'
        );

        # is this test useful?

        # how would i check if the logo is actually visible?

    },
);

done_testing();
