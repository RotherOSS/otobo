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

use Kernel::Output::HTML::Layout;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Change web max file upload.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'WebMaxFileUpload',
            Value => '68000'
        );

        my $Language = 'en';

        # Create test customer user and login.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
            Language => $Language,
        ) || die "Did not get test customer user";

        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            Lang         => $Language,
            UserTimeZone => 'UTC',
        );

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $TestCustomerUserLogin,
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID is created",
        );

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $Home        = $ConfigObject->Get('Home');

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber");
        $Selenium->find_element(q{//button[@id='ReplyButton']})->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#FollowUp.Visible').length"
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

        # Limit the allowed file types.
        $Selenium->execute_script(
            "\$('#FileUpload').data('file-types', 'myext')"
        );

        my $CheckFileTypeFilename = 'Test1.png';
        my $Location              = "$Home/scripts/test/sample/Cache/$CheckFileTypeFilename";
        $Selenium->find_element( "#FileUpload", 'css' )->clear();
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length' );

        # Verify dialog message.
        my $FileTypeMessage = "The following files are not allowed to be uploaded: $CheckFileTypeFilename";
        $Self->True(
            $Selenium->execute_script(
                "return \$('.Dialog.Modal .InnerContent:contains(\"$FileTypeMessage\")').length"
            ),
            "FileTypeMessage is found",
        );

        # Confirm dialog action.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

        $Selenium->find_element( "#FileUpload", 'css' )->clear();
        $Selenium->execute_script(
            "\$('#FileUpload').removeData('file-types')"
        );

        # Limit the max size per file (to 6 KB).
        $Selenium->execute_script(
            "\$('#FileUpload').removeData('max-files')"
        );
        $Selenium->execute_script(
            "\$('#FileUpload').data('max-size-per-file', 6000)"
        );
        $Selenium->execute_script(
            "\$('#FileUpload').data('max-size-per-file-hr', '6 KB')"
        );

        # Now try to upload two files of which one exceeds the max size (.pdf should work (5KB), .png shouldn't (20KB))
        $Location = "$Home/scripts/test/sample/Cache/Test1.pdf";
        $Selenium->find_element( "#FileUpload", 'css' )->clear();
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length"
        );

        my $CheckMaxAllowedSizeFilename = 'Test1.png';
        $Location = "$Home/scripts/test/sample/Cache/$CheckMaxAllowedSizeFilename";
        $Selenium->find_element( "#FileUpload", 'css' )->clear();
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
        );

        # Verify dialog message.
        my $MaxAllowedSizeMessage
            = "The following files exceed the maximum allowed size per file of 6 KB and were not uploaded: $CheckMaxAllowedSizeFilename";
        $Self->True(
            $Selenium->execute_script(
                "return \$('.Dialog.Modal .InnerContent:contains(\"$MaxAllowedSizeMessage\")').length"
            ),
            "MaxAllowedSizeMessage is found",
        );

        # Confirm dialog action.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

        # Remove the limitations again.
        $Selenium->execute_script(
            "\$('#FileUpload').removeData('max-size-per-file')"
        );

        $Self->True(
            $Selenium->execute_script(
                "return \$('.AttachmentList tbody tr td.Filename:contains(\"Test1.pdf\")').length"
            ),
            "Uploaded 'pdf' file still there"
        );

        # Upload file again.
        my $CheckUploadAgainFilename = 'Test1.pdf';
        $Location = "$Home/scripts/test/sample/Cache/$CheckUploadAgainFilename";
        $Selenium->find_element( "#FileUpload", 'css' )->clear();
        $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length' );

        # Verify dialog message.
        my $UploadAgainMessage
            = "The following files were already uploaded and have not been uploaded again: $CheckUploadAgainFilename";
        $Self->True(
            $Selenium->execute_script(
                "return \$('.Dialog.Modal .InnerContent:contains(\"$UploadAgainMessage\")').length"
            ),
            "UploadAgainMessage is found",
        );

        # Confirm dialog action.
        $Selenium->find_element( "#DialogButton1", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

        # Delete the only existing attachment.
        $Selenium->find_element( q{//a[contains(@class,'AttachmentDelete')]}, 'xpath' )->click();

        # Wait until attachment is deleted.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === 0"
        );

        # Check if deleted.
        $Self->True(
            $Selenium->execute_script(
                "return \$('.AttachmentDelete i').length === 0"
            ),
            "CustomerTicketZoom - Uploaded file 'Test1.pdf' deleted"
        );

        # Clean up test data from the DB.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

$Self->DoneTesting();
