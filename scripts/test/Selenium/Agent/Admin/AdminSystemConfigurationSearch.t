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

our $Self;

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # navigate to AdminSystemConfiguration screen
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSystemConfiguration"
        );

        # Search for CloudService::Admin::Module###100-SupportDataCollector(setting with : and # to test encoding).
        $Selenium->find_element( '#SysConfigSearch', 'css' )->send_keys('CloudService::Admin::Module###100-SupportDataCollector');
        $Selenium->WaitFor(
            JavaScript => 'return $("ul.ui-autocomplete a:visible").length',
        );

        # Select autocomplete value.
        $Selenium->find_element( 'a.ui-menu-item-wrapper', 'css' )->VerifiedClick();

        # Check if bread crumb link is working.
        $Selenium->find_element( 'ul.BreadCrumb li:nth-child(3) a', 'css' )->VerifiedClick();

        # Check settings count.
        my $SettingCount = $Selenium->execute_script(
            'return $(".SettingsList li").length'
        );
        $Self->Is(
            $SettingCount,
            1,
            'Make sure there is just 1 setting listed',
        );

        my $SettingName = $Selenium->execute_script(
            'return $(".SettingEdit").data("name");'
        );
        $Self->Is(
            $SettingName,
            'CloudService::Admin::Module###100-SupportDataCollector',
            'Check if correct setting is listed.'
        );
    }
);

$Self->DoneTesting();
