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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;
use Kernel::Output::HTML::Layout ();

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Disable SessionUseCookie. See bug#14432.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionUseCookie',
            Value => 0,
        );

        # Get all sessions before login.
        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
        my @PreLoginSessions  = $AuthSessionObject->GetAllSessionIDs();

        my $Language = 'en';

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
            Language => $Language,
        ) || die "Did not get test customer user";

        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            Lang         => $Language,
            UserTimeZone => 'UTC',
        );

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias              = $ConfigObject->Get('ScriptAlias');
        my $Home                     = $ConfigObject->Get('Home');
        my $CustomerPanelSessionName = $ConfigObject->Get('CustomerPanelSessionName');
        my $CustomerPanelSessionToken;

        # Get all session after login.
        my @PostLoginSessions = $AuthSessionObject->GetAllSessionIDs();

        # If there are no other sessions before login, take token from only available one.
        if ( !scalar @PreLoginSessions ) {
            $CustomerPanelSessionToken = $PostLoginSessions[0];
        }

        # If there are more sessions, find current logged one by looking at the difference.
        else {
            my %Difference;
            @Difference{@PostLoginSessions} = @PostLoginSessions;
            delete @Difference{@PreLoginSessions};
            $CustomerPanelSessionToken = ( keys %Difference )[0];
        }

        $Selenium->VerifiedGet(
            "${ScriptAlias}customer.pl?Action=CustomerTicketMessage;$CustomerPanelSessionName=$CustomerPanelSessionToken"
        );

        # Check DnDUpload.
        my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # Hide DnDUpload and show input field.
        $Selenium->execute_script(
            "\$('.DnDUpload').css('display', 'none')"
        );
        $Selenium->execute_script(
            "\$('#FileUpload').css('display', 'block')"
        );

        my $Location = "$Home/scripts/test/sample/Main/Main-Test1.doc";
        $Selenium->find_element( "#FileUpload", 'css' )->clear();
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

        # Wait until the delete link is available and no longer hidden.
        # The class Hidden is only removed when the upload is complete.
        $Selenium->WaitFor(
            JavaScript =>
                q{return typeof($) === 'function' && $('a.AttachmentDelete:not(.Hidden) i').length}
        );

        # Check if uploaded.
        ok(
            $Selenium->execute_script(
                "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.doc\")').length"
            ),
            "Upload file correct"
        );

        # Check if files still there.
        ok(
            $Selenium->execute_script(
                "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.doc\")').length"
            ),
            "Uploaded 'doc' file still there"
        );

        # Delete Attachment.
        $Selenium->find_element( "(//a[\@class='AttachmentDelete ooo12g'])[1]", 'xpath' )->click();

        # Wait until attachment is deleted.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === 0"
        );

        # Check if deleted.
        ok(
            $Selenium->execute_script(
                "return \$('.AttachmentDelete i').length === 0"
            ),
            "CustomerTicketMessage - Uploaded file 'Main-Test1.doc' deleted"
        );
    }
);

done_testing();
