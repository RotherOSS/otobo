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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get authsession object
        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        # check current sessions
        my $CurrentSessionID;
        my @SessionIDs = $AuthSessionObject->GetAllSessionIDs();
        SESSION_ID:
        for my $SessionID (@SessionIDs) {
            my %SessionData = $AuthSessionObject->GetSessionIDData(
                SessionID => $SessionID,
            );

            if ( %SessionData && $SessionData{UserLogin} eq $TestUserLogin ) {
                $CurrentSessionID = $SessionID;
                last SESSION_ID;
            }
        }

        $Self->True(
            scalar $CurrentSessionID,
            "Current session ID found for user $TestUserLogin",
        ) || return;

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminSession screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSession");

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $CurrentSessionID ) > -1,
            'SessionID found on page',
        );
        $Selenium->find_element( "table", 'css' );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSession;Subaction=Detail;WantSessionID=$CurrentSessionID"
        );

        $Self->True(
            index( $Selenium->get_page_source(), $CurrentSessionID ) > -1,
            'SessionID found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), $TestUserLogin ) > -1,
            'UserLogin found on page',
        );

        $Selenium->find_element( "table", 'css' );

        # check breadcrumb on detail view screen
        my $Count = 1;

        my $DetailViewBreadcrumbText = "Detail Session View for $TestUserLogin $TestUserLogin (User)";
        for my $BreadcrumbText ( 'Session Management', $DetailViewBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # kill current session, this means a logout effectively
        $Selenium->find_element( "a#KillThisSession", 'css' )->VerifiedClick();

        # make sure that we now see the login screen
        $Selenium->find_element( "#LoginBox", 'css' );
    }
);

$Self->DoneTesting();
