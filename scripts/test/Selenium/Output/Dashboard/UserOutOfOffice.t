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

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );
my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Selenium->RunTest(
    sub {

        # make sure that UserOutOfOffice is enabled
        my %UserOutOfOfficeSysConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'DashboardBackend###0390-UserOutOfOffice',
            Default => 1,
        );

        # enable UserOutOfOffice and set it to load as default plugin
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'DashboardBackend###0390-UserOutOfOffice',
            Value => $UserOutOfOfficeSysConfig{EffectiveValue},
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );
        ok( $TestUserLogin, 'test user created' );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get test user ID
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );
        ok( $TestUserID, 'test user found' );

        # get time object
        my $DTObj    = $Kernel::OM->Create('Kernel::System::DateTime');
        my $DTValues = $DTObj->Get();

        # create OutOfOffice params
        my @OutOfOfficeTime = (
            {
                Key   => 'OutOfOffice',
                Value => 1,
            },
            {
                Key   => 'OutOfOfficeStartYear',
                Value => $DTValues->{Year},
            },
            {
                Key   => 'OutOfOfficeEndYear',
                Value => $DTValues->{Year} + 1,
            },
            {
                Key   => 'OutOfOfficeStartMonth',
                Value => $DTValues->{Month},
            },
            {
                Key   => 'OutOfOfficeEndMonth',
                Value => $DTValues->{Month},
            },
            {
                Key   => 'OutOfOfficeStartDay',
                Value => $DTValues->{Day},
            },
            {
                Key   => 'OutOfOfficeEndDay',
                Value => $DTValues->{Day},
            },
        );

        # set OutOfOffice preference
        for my $OutOfOfficePreference (@OutOfOfficeTime) {
            $UserObject->SetPreferences(
                UserID => $TestUserID,
                Key    => $OutOfOfficePreference->{Key},
                Value  => $OutOfOfficePreference->{Value},
            );
        }

        # clean up dashboard cache and refresh screen
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Dashboard' );

        try_ok {
            $Selenium->VerifiedRefresh();

            # test OutOfOffice plugin
            my $ExpectedResult = sprintf
                "$TestUserLogin until %02d/%02d/%d",
                $DTValues->{Month},
                $DTValues->{Day},
                $DTValues->{Year} + 1;
            $Selenium->content_contains(
                $ExpectedResult,
                "OutOfOffice message - found on screen"
            );
        };
    }
);

done_testing();
