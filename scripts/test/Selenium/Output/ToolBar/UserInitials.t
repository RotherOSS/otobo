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

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # Set AvatarEngine to 'none'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::AvatarEngine',
            Value => 'none',
        );

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test user.
        my $UserID = $UserObject->UserAdd(
            UserFirstname => "Firstname$RandomID",
            UserLastname  => "Lastname$RandomID",
            UserLogin     => "UserLogin$RandomID",
            UserPw        => "UserLogin$RandomID",
            UserEmail     => "UserLogin$RandomID" . '@localunittest.com',
            ValidID       => 1,
            ChangeUserID  => 1,
        );
        $Self->True(
            $UserID,
            "UserID $UserID is created",
        );

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $User{UserLogin},
            Password => $User{UserLogin},
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my %Tests = (
            0 => 'FL',
            1 => 'LF',
            2 => 'FL',
            3 => 'LF',
            4 => 'FL',
            5 => 'LF',
            6 => 'LF',
            7 => 'LF',
            8 => 'LF',
            9 => 'L',
        );

        for my $Order ( sort keys %Tests ) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'FirstnameLastnameOrder',
                Value => $Order,
            );
            $Selenium->VerifiedGet("${ScriptAlias}index.pl");

            $Self->Is(
                $Selenium->find_element( '.Initials', 'css' )->get_text(),
                $Tests{$Order},
                "Correct initials - order '$Order', initials '$Tests{$Order}'",
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test user.
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM user_preferences WHERE user_id = ?",
            Bind => [ \$UserID ],
        );
        $Self->True(
            $Success,
            "User preferences for UserID $UserID is deleted",
        );
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM users WHERE id = ?",
            Bind => [ \$UserID ],
        );
        $Self->True(
            $Success,
            "UserID $UserID is deleted",
        );

    }
);

$Self->DoneTesting();
