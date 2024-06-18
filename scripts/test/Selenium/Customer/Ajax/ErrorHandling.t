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
use Kernel::Language ();
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

# TODO: This test does not cancel potential other AJAX calls that might happen in the background,
#   e. g. when the Chat is active.

$Selenium->RunTest(
    sub {
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $Language     = 'en';

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
            Language => $Language,
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to CustomerPreference screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketMessage");

        # Provoke an ajax error caused by unexpected result (404), should show no dialog, but an regular alert.
        $Selenium->execute_script(
            "Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle') + ':12345', null, function () {});"
        );

        {
            my $ToDo = todo('Error handling is either changed or broken. See issue #909');

            try_ok {
                $Selenium->WaitFor( JavaScript => "return \$('.NoConnection:visible').length;" );

                my $LanguageObject = Kernel::Language->new(
                    UserLanguage => $Language,
                );

                # Another alert dialog opens with the detail message.
                is(
                    $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection p').text().trim();"),
                    $LanguageObject->Translate(
                        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.',
                        $ConfigObject->Get('Product')
                    ),
                    'Check for opened alert text',
                );

                # Close dialog.
                $Selenium->find_element( '#DialogButton2', 'css' )->click();

                # Wait until modal dialog has closed.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;'
                );

                # Wait until all AJAX calls finished.
                $Selenium->WaitFor( JavaScript => "return \$.active == 0" );
            };
        }

        # Change the queue to trigger an ajax call.
        $Selenium->InputFieldValueSet(
            Element => '#Type',
            Value   => 1,
        );

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # There should be no error dialog yet.
        is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
            0,
            "Error dialog not visible yet"
        );

        # Overload ajax function to simulate connection drop.
        my $AjaxOverloadJSError = <<"JAVASCRIPT";
window.AjaxOriginal = \$.ajax;
\$.ajax = function() {
    var Status = 'Status',
        Error = 'Error';
    Core.Exception.HandleFinalError(new Core.Exception.ApplicationError("Error during AJAX communication. Status: " + Status + ", Error: " + Error, 'ConnectionError'));
    return false;
};
\$.ajax();
JAVASCRIPT

        # Trigger faked ajax request.
        $Selenium->execute_script($AjaxOverloadJSError);

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Wait until modal dialog has open.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
        );

        # Now check if we see a connection error popup.
        is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
            1,
            "Error dialog visible - first try"
        );

        # Now act as if the connection had been re-established.
        my $AjaxOverloadJSSuccess = <<"JAVASCRIPT";
\$.ajax = window.AjaxOriginal;
Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), null, function () {}, 'html');
\$.ajax();
JAVASCRIPT

        # Trigger faked ajax request.
        $Selenium->execute_script($AjaxOverloadJSSuccess);

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Wait until modal dialog has open.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
        );

        # The dialog should show the re-established message now.
        is(
            $Selenium->execute_script("return \$('#AjaxErrorDialogInner .ConnectionReEstablished:visible').length;"),
            1,
            "ConnectionReEstablished dialog visible"
        );

        # Close the dialog.
        $Selenium->find_element( '#DialogButton2', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;'
        );

        # Trigger faked ajax request again.
        $Selenium->execute_script($AjaxOverloadJSError);

        # Wait until all AJAX calls finished.
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        {
            my $ToDo = todo('Error handling is either changed or broken. See issue #909');

            try_ok {
                # Wait until modal dialog has open.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
                );

                # Now check if we see a connection error popup.
                is(
                    $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
                    1,
                    "Error dialog visible - second try"
                );

                # Now we close the dialog manually.
                $Selenium->find_element( '#DialogButton2', 'css' )->click();
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length;'
                );

                # The dialog should be gone.
                is(
                    $Selenium->execute_script("return \$('#AjaxErrorDialogInner .NoConnection:visible').length;"),
                    0,
                    "Error dialog closed"
                );

                # Now act as if the connection had been re-established.
                $Selenium->execute_script($AjaxOverloadJSSuccess);

                # Wait until all AJAX calls finished.
                $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

                # Wait until modal dialog has open.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && $(".Dialog.Modal").length;'
                );

                # The dialog should show the re-established message now.
                is(
                    $Selenium->execute_script("return \$('#AjaxErrorDialogInner .ConnectionReEstablished:visible').length;"),
                    1,
                    "ConnectionReEstablished dialog visible"
                );
            };
        }
    }
);

done_testing();
