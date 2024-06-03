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

use vars (qw($Self));

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable PerformanceLog
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PerformanceLog',
            Value => 1
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminPerformanceLog screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPerformanceLog");

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        my %RangeBreadcrumb = (
            5    => 'Range (last 5 m)',
            30   => 'Range (last 30 m)',
            60   => 'Range (last 1 h 0 m)',
            120  => 'Range (last 2 h 0 m)',
            1440 => 'Range (last 1 d 0 h )',
            2880 => 'Range (last 2 d 0 h )',
        );

        # check for Admin on different range time screens
        for my $Time (
            qw(5 30 60 120 1440 2880)
            )
        {
            # click on Admin
            $Selenium->find_element("//a[contains(\@href, \'Interface=Agent;Minute=$Time' )]")->VerifiedClick();

            # check screen layout
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );
            $Selenium->find_element( "div.Progressbar",   'css' )->is_displayed();

            # check breadcrumb on Add screen
            my $Count = 1;
            for my $BreadcrumbText ( 'Performance Log', $RangeBreadcrumb{$Time} ) {
                $Self->Is(
                    $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                    $BreadcrumbText,
                    "Breadcrumb text '$BreadcrumbText' is found on screen"
                );

                $Count++;
            }

            # click on "Go to overview"
            $Selenium->find_element("//a[contains(\@href, \'Action=AdminPerformanceLog' )]")->VerifiedClick();

        }

    }

);

$Self->DoneTesting();
