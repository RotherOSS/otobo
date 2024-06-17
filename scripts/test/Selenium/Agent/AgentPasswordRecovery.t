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

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
        my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');
        my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

        my %MailQueueCurrentItems = map { $_->{ID} => $_ } @{ $MailQueueObject->List() || [] };

        my $MailQueueClean = sub {
            my $Items = $MailQueueObject->List();
            MAIL_QUEUE_ITEM:
            for my $Item ( @{$Items} ) {
                next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
                $MailQueueObject->Delete(
                    ID => $Item->{ID},
                );
            }

            return;
        };

        my $MailQueueProcess = sub {
            my %Param = @_;

            my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

            # Process all items except the ones already present before the tests.
            my $Items = $MailQueueObject->List();
            MAIL_QUEUE_ITEM:
            for my $Item ( @{$Items} ) {
                next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
                $MailQueueObject->Send( %{$Item} );
            }

            # Clean any garbage.
            $MailQueueClean->();

            return;
        };

        # Make sure we start with a clean mail queue.
        $MailQueueClean->();

        # Use test email backend.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Clean up test email.
        my $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Initial cleanup',
        );

        $Self->IsDeeply(
            $TestEmailObject->EmailsGet(),
            [],
            'Test email empty after initial cleanup',
        );

        # Clean up test email again (cached).
        $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Initial cleanup',
        );

        # Create test user.
        my $TestUser = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to agent login screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?");
        $Selenium->delete_all_cookies();

        # Click on 'Lost your password?'.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?");
        $Selenium->find_element( "#LostPassword", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#PasswordUser").length && $("#PasswordBox button[type=submit]").length'
        );

        # Request new password.
        $Selenium->find_element( "#PasswordUser",                      'css' )->send_keys($TestUser);
        $Selenium->find_element( "#PasswordBox button[type='submit']", 'css' )->VerifiedClick();

        # Check for password recovery message.
        $Self->True(
            $Selenium->find_element( "#LoginBox p.Error", 'css' ),
            "Password recovery message found on screen for valid user",
        );

        # Really send the emails.
        $MailQueueProcess->();

        # Check if password recovery email is sent to valid user.
        my $Emails = $TestEmailObject->EmailsGet();
        $Self->Is(
            scalar @{$Emails},
            1,
            "Password recovery email sent for valid user $TestUser",
        );

        # Clean up test email again.
        $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Second cleanup',
        );

        $Self->IsDeeply(
            $TestEmailObject->EmailsGet(),
            [],
            'Test email empty after second cleanup',
        );

        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # Get test user ID.
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUser,
        );

        # Update user to invalid.
        $Success = $UserObject->UserUpdate(
            UserID        => $TestUserID,
            UserFirstname => $TestUser,
            UserLastname  => $TestUser,
            UserLogin     => $TestUser,
            UserPw        => $TestUser,
            UserEmail     => $TestUser . '@localunittest.com',
            ValidID       => 2,
            ChangeUserID  => 1,
        );
        $Self->True(
            $Success,
            "$TestUser set to invalid",
        );

        # Click on 'Lost your password?' again.
        $Selenium->find_element( "#LostPassword", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#PasswordUser").length && $("#PasswordBox button[type=submit]").length'
        );

        # Request new password.
        $Selenium->find_element( "#PasswordUser",                      'css' )->send_keys($TestUser);
        $Selenium->find_element( "#PasswordBox button[type='submit']", 'css' )->VerifiedClick();

        # Check for password recovery message for invalid user, for security measures it.
        # Should be visible.
        $Self->True(
            $Selenium->find_element( "#LoginBox p.Error", 'css' ),
            "Password recovery message found on screen for invalid user",
        );

        # Really send the emails.
        $MailQueueProcess->();

        # Check if password recovery email is sent to invalid user.
        $Emails = $TestEmailObject->EmailsGet();
        $Self->Is(
            scalar @{$Emails},
            0,
            "Password recovery email NOT sent for invalid user $TestUser",
        );
    }
);

$Self->DoneTesting();
