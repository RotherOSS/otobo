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
use Kernel::Output::HTML::Layout ();
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Change web max file upload.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'WebMaxFileUpload',
            Value => '50000'
        );

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

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            Lang         => $Language,
            UserTimeZone => 'UTC',
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');
        my $Home         = $ConfigObject->Get('Home');
        my $SessionName  = $ConfigObject->Get('SessionName');
        my $SessionToken;

        # Get all session after login.
        my @PostLoginSessions = $AuthSessionObject->GetAllSessionIDs();

        # If there are no other sessions before login, take token from only available one.
        if ( !@PreLoginSessions ) {
            $SessionToken = $PostLoginSessions[0];
        }

        # If there are more sessions, find current logged one by looking at the difference.
        else {
            my %Difference;
            @Difference{@PostLoginSessions} = @PostLoginSessions;
            delete @Difference{@PreLoginSessions};
            $SessionToken = ( keys %Difference )[0];
        }

        # Check screens.
        # For each screen Test1.pdf and Test1.doc are uploaded and then deleted.
        for my $Action (qw(AgentTicketPhone AgentTicketEmail)) {

            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Action;$SessionName=$SessionToken");
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $(".DnDUpload").length;'
            );

            # Check DnDUpload.
            my $Element = $Selenium->find_element( ".DnDUpload", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();

            # Hide DnDUpload and show input field.
            $Selenium->execute_script("\$('.DnDUpload').css('display', 'none')");
            $Selenium->execute_script("\$('#FileUpload').css('display', 'block')");

            # limit the allowed file types
            $Selenium->execute_script(
                "\$('#FileUpload').data('file-types', 'myext')"
            );

            my $CheckFileTypeFilename = 'Test1.png';
            my $Location              = "$Home/scripts/test/sample/Cache/$CheckFileTypeFilename";
            $Selenium->find_element( "#FileUpload", 'css' )->clear();
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
            );

            # Verify dialog message.
            my $FileTypeMessage = "The following files are not allowed to be uploaded: $CheckFileTypeFilename";
            ok(
                $Selenium->execute_script(
                    "return \$('.Dialog.Modal .InnerContent:contains(\"$FileTypeMessage\")').length"
                ),
                "$Action - FileTypeMessage is found",
            );

            # Confirm dialog action.
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

            $Selenium->find_element( "#FileUpload", 'css' )->clear();

            # limit the max amount of files
            $Selenium->execute_script(
                "\$('#FileUpload').removeData('file-types')"
            );
            $Selenium->execute_script(
                "\$('#FileUpload').data('max-files', 2)"
            );

            $Location = "$Home/scripts/test/sample/Cache/Test1.pdf";
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === 1"
            );

            # Waiting for js to finish work to prevent erroneous upload of previous files
            $Selenium->WaitFor( JavaScript => 'return $.active == 0' );

            $Location = "$Home/scripts/test/sample/Cache/Test1.doc";
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === 2"
            );

            # Waiting for js to finish work to prevent erroneous upload of previous files
            $Selenium->WaitFor( JavaScript => 'return $.active == 0' );

            $Location = "$Home/scripts/test/sample/Cache/Test1.txt";
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                AlertPresent => 1,
            );

            # Verify alert text.
            is(
                $Selenium->get_alert_text(),
                'Sorry, you can only upload 2 files.',
                "$Action - alert for max files shown correctly",
            );

            # Accept alert.
            $Selenium->accept_alert();

            # Wait until the attachment list is updated, two elements are expected
            my $Count = 2;
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === $Count"
            );

            # Remove the two existing files.
            for my $DeleteExtension (qw(doc pdf)) {

                # Delete attachment.
                # There had been sporadic errros when selecting the trashbin with
                # the XPath selector (//a[\@class='AttachmentDelete'])[$Count].
                # Therefore a css selector is used here.
                ( $Selenium->find_elements( 'a.AttachmentDelete', 'css' ) )[ $Count - 1 ]->click();
                $Count--;

                # Wait until attachment is deleted.
                $Selenium->WaitFor(
                    JavaScript => "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === $Count"
                );

                # Check if deleted.
                ok(
                    $Selenium->execute_script(
                        "return \$('.AttachmentDelete i').length === $Count"
                    ),
                    "$Action - Upload '$DeleteExtension' file deleted"
                );
            }

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

            # Now try to upload two files of which one exceeds the max size
            # (.pdf should work (5KB), .png shouldn't (20KB)).
            $Location = "$Home/scripts/test/sample/Cache/Test1.pdf";
            $Selenium->find_element( "#FileUpload", 'css' )->clear();
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length === 1"
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
            ok(
                $Selenium->execute_script(
                    "return \$('.Dialog.Modal .InnerContent:contains(\"$MaxAllowedSizeMessage\")').length"
                ),
                "$Action - MaxAllowedSizeMessage is found",
            );

            # Confirm dialog action.
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

            # Remove the limitations again.
            $Selenium->execute_script(
                "\$('#FileUpload').removeData('max-size-per-file')"
            );

            $Selenium->VerifiedRefresh();

            # Hide DnDUpload and show input field.
            $Selenium->execute_script("\$('.DnDUpload').css('display', 'none')");
            $Selenium->execute_script("\$('#FileUpload').css('display', 'block')");

            # Upload file.
            $Location = "$Home/scripts/test/sample/Main/Main-Test1.txt";
            $Selenium->find_element( "#FileUpload", 'css' )->clear();
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('.AttachmentDelete i').length"
            );

            # Check if uploaded.
            ok(
                $Selenium->execute_script(
                    "return \$('.AttachmentList tbody tr td.Filename:contains(\"Main-Test1.txt\")').length"
                ),
                "$Action - Upload Main-Test1.txt file correct"
            );

            # Upload file again.
            my $CheckUploadAgainFilename = 'Main-Test1.txt';
            $Location = "$Home/scripts/test/sample/Main/$CheckUploadAgainFilename";
            $Selenium->find_element( "#FileUpload", 'css' )->clear();
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
            );

            # Verify dialog message.
            my $UploadAgainMessage
                = "The following files were already uploaded and have not been uploaded again: $CheckUploadAgainFilename";
            ok(
                $Selenium->execute_script(
                    "return \$('.Dialog.Modal .InnerContent:contains(\"$UploadAgainMessage\")').length"
                ),
                "$Action - UploadAgainMessage is found",
            );

            # Confirm dialog action.
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );

            $Selenium->VerifiedRefresh();

            # Hide DnDUpload and show input field.
            $Selenium->execute_script("\$('.DnDUpload').css('display', 'none')");
            $Selenium->execute_script("\$('#FileUpload').css('display', 'block')");

            # Check max size.
            my $CheckMaxSizeFilename = 'PostMaster-Test13.box';
            $Location = "$Home/scripts/test/sample/EmailParser/$CheckMaxSizeFilename";
            $Selenium->find_element( "#FileUpload", 'css' )->clear();
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->WaitFor(
                JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length'
            );

            # Verify dialog message.
            my $UploadMaxMessage = "No space left for the following files: $CheckMaxSizeFilename";
            ok(
                $Selenium->execute_script(
                    "return \$('.Dialog.Modal .InnerContent:contains(\"$UploadMaxMessage\")').length"
                ),
                "$Action - UploadMaxMessage is found",
            );

            # Confirm dialog action.
            $Selenium->find_element( "#DialogButton1", 'css' )->click();
            $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Dialog.Modal").length' );
        }
    }
);

done_testing;
