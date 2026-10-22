# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.26;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create unique names in order to avoid conflicts with previous runs
        my $RandomID = $Helper->GetRandomID;
        note "RandomID: $RandomID";
        my $ProcessRandom         = 'Process' . $RandomID;
        my $ActivityRandom        = 'Activity' . $RandomID;
        my $ActivityDialogRandom  = 'ActivityDialog' . $RandomID;
        my $ActivityDialogRandom2 = $ActivityDialogRandom . '_2';

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement;IncludeInvalid=1");

        # Create new test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->VerifiedClick();
        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Submit",      'css' )->VerifiedClick();

        # Create new test Activity.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityNew' )]")->click();

        # Switch to pop up window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Check AdminProcessManagementActivity screen.
        for my $ID (
            qw(Name FilterAvailableActivityDialogs AvailableActivityDialogs AssignedActivityDialogs)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#Name.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Input name field and submit.
        $Selenium->find_element( "#Name",   'css' )->send_keys($ActivityRandom);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Switch back to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Check for created test activity using filter on AdminProcessManagement screen.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#Activities li:contains($ActivityRandom)').length"
        );
        $Selenium->find_element( "#ActivityFilter", 'css' )->send_keys($ActivityRandom);
        $Selenium->WaitFor( JavaScript => 'return $("#Activities li:visible").length === 1 && $.active == 0' );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$ActivityRandom\"]")->is_displayed(),
            "$ActivityRandom activity found on page",
        );

        # Get test ActivityID.
        my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
        my $ActivityQuoted = $DBObject->Quote($ActivityRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_activity WHERE name = ?",
            Bind => [ \$ActivityQuoted ]
        );
        my $ActivityID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityID = $Row[0];
        }

        # Get test ProcessEntityID.
        my $ProcessQuoted = $DBObject->Quote($ProcessRandom);
        $DBObject->Prepare(
            SQL  => "SELECT entity_id FROM pm_process WHERE name = ?",
            Bind => [ \$ProcessQuoted ]
        );
        my $ProcessEntityID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ProcessEntityID = $Row[0];
        }

        # Check for stored value and edit test Activity.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityEdit;ID=$ActivityID' )]")->click();
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $ActivityRandom,
            "#Name stored value",
        );

        $Selenium->find_element( "#Name",   'css' )->send_keys("edit");
        $Selenium->find_element( "#Global", 'css' )->click();

        # Create global ActivityDialog
        my $ActivityDialogNewButton = "//a[contains(.,\'Create New Activity Dialog\')]";
        $Selenium->WaitFor( ElementExists => $ActivityDialogNewButton );
        $Selenium->find_element($ActivityDialogNewButton)->VerifiedClick();

        # Input fields and submit.
        $Selenium->find_element( "#Name",             'css' )->send_keys($ActivityDialogRandom);
        $Selenium->find_element( "#DescriptionShort", 'css' )->send_keys($ActivityDialogRandom);
        $Selenium->find_element( "#Global",           'css' )->click();
        $Selenium->find_element( "#Submit",           'css' )->VerifiedClick();

        # Create non-global ActivityDialog
        $Selenium->find_element($ActivityDialogNewButton)->VerifiedClick();

        # Input fields and submit.
        $Selenium->find_element( "#Name",             'css' )->send_keys($ActivityDialogRandom2);
        $Selenium->find_element( "#DescriptionShort", 'css' )->send_keys($ActivityDialogRandom2);
        $Selenium->find_element( "#Submit",           'css' )->VerifiedClick();

        # Check if ActivityDialog is global
        my $ActivityDialogQuoted = $DBObject->Quote($ActivityDialogRandom);
        $DBObject->Prepare(
            SQL  => "SELECT process_entity_id FROM pm_activity_dialog WHERE name = ?",
            Bind => [ \$ActivityDialogQuoted ]
        );
        my $ActivityDialogProcessEntityID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityDialogProcessEntityID = $Row[0];
        }
        $Self->Is(
            $ActivityDialogProcessEntityID,
            undef,
            "ProcessEntityID stored in db column",
        );

        # Check if ActivityDialog2 is non-global
        my $ActivityDialogQuoted2 = $DBObject->Quote($ActivityDialogRandom2);
        $DBObject->Prepare(
            SQL  => "SELECT process_entity_id FROM pm_activity_dialog WHERE name = ?",
            Bind => [ \$ActivityDialogQuoted2 ]
        );
        my $ActivityDialogProcessEntityID2;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityDialogProcessEntityID2 = $Row[0];
        }
        is(
            $ActivityDialogProcessEntityID2,
            $ProcessEntityID,
            "ProcessEntityID2 stored in db column",
        );

# Example HTML:
# <ul class="AllocationList Tablelike W90pc" id="AvailableActivityDialogs">
#     <li data-id="3" data-name="ActivityDialogtest2830007259100000" data-namespace="" data-dialogprocess="" title="Name: ActivityDialogtest2830007259100000, EntityID: ActivityDialog-3cbce3415b0c8d9495ecfa93b7ebc3f8" class="">
#         ActivityDialogtest2830007259100000
#         <span class="Functions">
#             <span title="Global"><i class="Global fa fa-globe"></i></span>
#             <span class="AvailableIn">A</span>
#             <a href="#" data-entity="ActivityDialog-3cbce3415b0c8d9495ecfa93b7ebc3f8" data-id="3" data-process="Process-49a6df9a1c02e7b88ffba5393c76bc6b" data-action="AdminProcessManagementActivityDialog" data-subaction="ActivityDialogEdit" class="AsPopup_Redirect Edit_Confirm PopupType_ActivityDialog Icon" title="Edit">
#                 <i class="fa fa-edit"></i>
#             </a>
#         </span>
#     </li>

        # Check for created test ActivityDialogs in AvailableActivityDialogs list.
        # Check for the attribute data-name as this is more exact. Note that
        # $ActivityDialogRandom is a substring of $ActivityDialogRandom2.
        $Selenium->WaitFor(
            JavaScript =>
                qq{return typeof(\$) === 'function' && \$('ul#AvailableActivityDialogs li[data-name="$ActivityDialogRandom"]').length},
        );
        $Selenium->WaitFor(
            JavaScript =>
                qq{return typeof(\$) === 'function' && \$('ul#AvailableActivityDialogs li[data-name="$ActivityDialogRandom2"]').length}
        );

        # Only the global ActivityDialog should be displayed, even though both are present in the DOM
        ok(
            $Selenium->find_element( qq{ul#AvailableActivityDialogs li[data-name="$ActivityDialogRandom"]}, 'css' ),
            "$ActivityDialogRandom ActivityDialog exists in DOM",
        );
        ok(
            $Selenium->find_element( qq{ul#AvailableActivityDialogs li[data-name="$ActivityDialogRandom"]}, 'css' )->is_displayed(),
            "$ActivityDialogRandom ActivityDialog displayed on page",
        );

        ok(
            $Selenium->find_element( qq{ul#AvailableActivityDialogs li[data-name="$ActivityDialogRandom2"]}, 'css' ),
            "$ActivityDialogRandom2 ActivityDialog exists in DOM",
        );
        ok(
            !$Selenium->find_element( qq{ul#AvailableActivityDialogs li[data-name="$ActivityDialogRandom2"]}, 'css' )->is_displayed(),
            "$ActivityDialogRandom2 ActivityDialog not displayed on page",
        );

        # Toggling global selection displays non-global ActivityDialog
        $Selenium->find_element( "#Global", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => qq{
                return typeof(\$) === 'function' && \$("li:contains('$ActivityDialogRandom2')").filter(":visible").length
            }
        );

        # Get ID of ActivityDialogs for DragAndDrop
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_activity_dialog WHERE name = ?",
            Bind => [ \$ActivityDialogQuoted ]
        );
        my $ActivityDialogID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityDialogID = $Row[0];
        }
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_activity_dialog WHERE name = ?",
            Bind => [ \$ActivityDialogQuoted2 ]
        );
        my $ActivityDialogID2;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityDialogID2 = $Row[0];
        }

        # Assign both ActivityDialogs
        $Selenium->DragAndDrop(
            Element      => "#AvailableActivityDialogs li[data-id=\"$ActivityDialogID\"]",
            Target       => '#AssignedActivityDialogs',
            TargetOffset => {
                X => 10,
                Y => 10,
            },
        );
        $Selenium->DragAndDrop(
            Element      => "#AvailableActivityDialogs li[data-id=\"$ActivityDialogID2\"]",
            Target       => '#AssignedActivityDialogs',
            TargetOffset => {
                X => 10,
                Y => 10,
            },
        );

        # Toggling global selection throws alert
        $Selenium->find_element( "#Global", 'css' )->click();
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for non-global ActivityDialog assigned to global Activity not found';

        # Verify the alert message.
        $Selenium->alert_text_like(
            qr/Non-global ActivityDialogs may not be assigned to global Activities!/,
            'Non-global ActivityDialog warning is shown'
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Edit an ActivityDialog through redirect
        $Selenium->find_element( "#AssignedActivityDialogs li[data-id=\"$ActivityDialogID\"] a[data-subaction='ActivityDialogEdit']", 'css' )->click();
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for current ActivityEdit state being saved not found';

        # Verify the alert message.
        $Selenium->alert_text_like(
            qr/As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?/,
            'Warning for saving current ActivityEdit state is shown'
        );

        # Accept alert.
        $Selenium->accept_alert();

        # Go back without editing.
        $Selenium->WaitFor( ElementExists => q{//a[@class='GoBack']} );
        $Selenium->find_element(q{//a[@class='GoBack']})->VerifiedClick();

        # Verify Activity name edit.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $ActivityRandom . 'edit',
            "#Name stored value after redirect",
        );

        # Repeat with Submit instead of GoBack.
        $Selenium->find_element( "#AssignedActivityDialogs li[data-id=\"$ActivityDialogID\"] a[data-subaction='ActivityDialogEdit']", 'css' )->click();
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for current ActivityEdit state being saved not found';

        # Accept alert.
        $Selenium->accept_alert();

        # Submit without editing.
        $Selenium->WaitFor( ElementExists => [ "#Submit", 'css' ] );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Return to ProcessEdit screen.
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Return to main window after the popup is closed, as the popup sends commands to the main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Get process id.
        my $ProcessID = $Selenium->execute_script('return $("#ProcessDelete").data("id")') || undef;

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Set process to inactive.
        $Selenium->find_element( $ProcessRandom, 'link_text' )->VerifiedClick();
        $Selenium->InputFieldValueSet(
            Element => '#StateEntityID',
            Value   => 'S2',
        );
        $Selenium->execute_script("\$('#Submit').click()");

        # Test search filter.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Filter").length' );
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($ProcessRandom);

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Processes tbody tr:visible").length === 1'
        );

        # Check class of invalid Process in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td:contains($ProcessRandom)').length"
            ),
            "There is a class 'Invalid' for test Process",
        );

        # Delete test process.
        $Selenium->find_element( $ProcessRandom, 'link_text' )->VerifiedClick();
        $Selenium->find_element(q{//a[@id='ProcessDelete']})->click();

        # Confirm deletion.
        $Selenium->WaitFor( ElementExists => q{//div[@role='dialog']} );
        $Selenium->find_element( "div[role='dialog'] button[id='DialogButton2']", 'css' )->VerifiedClick();

        # Verify db-state.
        my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessGet(
            ID     => $ProcessID,
            UserID => $TestUserID,
        );
        $Self->False(
            $Success,
            "Process is deleted - $ProcessID",
        );
        $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity')->ActivityGet(
            ID     => $ActivityID,
            UserID => $TestUserID,
        );
        $Self->False(
            $Success,
            "Non-global Activity is deleted - $ActivityID",
        );
        $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog')->ActivityDialogGet(
            ID     => $ActivityDialogID2,
            UserID => $TestUserID,
        );
        $Self->False(
            $Success,
            "Non-global ActivityDialog is deleted - $ActivityDialogID2",
        );

        # Delete remaining global ActivityDialog.
        $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog')->ActivityDialogDelete(
            ID     => $ActivityDialogID,
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "Global ActivityDialog is deleted - $ActivityDialogID",
        );

        # Synchronize process after deleting test process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(ProcessManagement_Activity ProcessManagement_Process)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

done_testing;
