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

$Selenium->RunTest(
    sub {

        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
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
        ok( $Success, 'Initial cleanup' );

        is(
            $TestEmailObject->EmailsGet(),
            [],
            'Test email empty after initial cleanup',
        );

        # Create test customer user.
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to customer login screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?");
        $Selenium->delete_all_cookies();

        # Click on 'Forgot password'.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?");
        $Selenium->find_element( "#ForgotPassword", 'css' )->click();

        $Selenium->WaitFor( JavaScript => "return \$('#ResetUser').length" );

        # Request new password.
        $Selenium->find_element( "#ResetUser",                   'css' )->send_keys($TestCustomerUser);
        $Selenium->find_element( "#Reset button[type='submit']", 'css' )->VerifiedClick();

        # Check for password recovery message.
        my $SuccessBoxElement = $Selenium->find_element( q{div.SuccessBox p}, 'css', );
        ok( $SuccessBoxElement, "Password recovery message found on screen for valid customer" );
        $SuccessBoxElement->text_like(qr/\QSent password reset instructions.\E/);

        # Process mail queue items.
        $MailQueueProcess->();

        # Check if password recovery email is sent.
        my $Emails = $TestEmailObject->EmailsGet();
        is(
            scalar $Emails->@*,
            1,
            "Password recovery email sent for valid customer user $TestCustomerUser",
        );

        # Clean up test email again.
        $Success = $TestEmailObject->CleanUp();
        ok( $Success, 'Second cleanup' );

        is(
            $TestEmailObject->EmailsGet(),
            [],
            'Test email empty after second cleanup',
        );

        # Update test customer to invalid status.
        $Success = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser,
            UserCustomerID => $TestCustomerUser,
            UserLogin      => $TestCustomerUser,
            UserFirstname  => $TestCustomerUser,
            UserLastname   => $TestCustomerUser,
            UserPassword   => $TestCustomerUser,
            UserEmail      => $TestCustomerUser . '@localunittest.com',
            ValidID        => 2,
            UserID         => 1,
        );
        ok( $Success, "$TestCustomerUser set to invalid" );

        # Click on 'Forgot password' again.
        $Selenium->find_element( "#ForgotPassword", 'css' )->click();

        $Selenium->WaitFor( JavaScript => "return \$('#ResetUser').length" );

        # Request new password.
        $Selenium->find_element( "#ResetUser",                   'css' )->send_keys($TestCustomerUser);
        $Selenium->find_element( "#Reset button[type='submit']", 'css' )->VerifiedClick();

        # Check for password recovery message for invalid customer user, for security measures it
        # should be visible.
        $Selenium->find_element_by_css_ok(
            q{div.SuccessBox p},
            'Password recovery message found on screen for invalid customer',
        );

        # Process mail queue items.
        $MailQueueProcess->();

        # Check if password recovery email is sent to invalid customer user.
        $Emails = $TestEmailObject->EmailsGet();
        is(
            scalar $Emails->@*,
            0,
            "Password recovery email NOT sent for invalid customer user $TestCustomerUser",
        );
    }
);

done_testing();
