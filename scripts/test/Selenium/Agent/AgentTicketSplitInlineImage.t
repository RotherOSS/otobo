# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
        my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
        my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');

        # Turn on RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 1,
        );

        # Set ArticleStorage FS.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Article::Backend::MIMEBase::ArticleStorage',
            Value => 'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS',
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Get all processes.
        my $ProcessList = $ProcessObject->ProcessListGet(
            UserID => $TestUserID,
        );

        my @DeactivatedProcesses;
        my $ProcessName = 'TestProcess';
        my $TestProcessExists;

        # If there had been some active processes before testing, set them to inactive.
        PROCESS:
        for my $Process ( @{$ProcessList} ) {
            if ( $Process->{State} eq 'Active' ) {

                # Check if active test process already exists.
                if ( $Process->{Name} eq $ProcessName ) {
                    $TestProcessExists = 1;
                    next PROCESS;
                }

                $ProcessObject->ProcessUpdate(
                    ID            => $Process->{ID},
                    EntityID      => $Process->{EntityID},
                    Name          => $Process->{Name},
                    StateEntityID => 'S2',
                    Layout        => $Process->{Layout},
                    Config        => $Process->{Config},
                    UserID        => $TestUserID,
                );

                # Save process because of restoring on the end of test.
                push @DeactivatedProcesses, $Process;
            }
        }

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $Location;

        # Import test process if does not exist in the system.
        if ( !$TestProcessExists ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#OverwriteExistingEntitiesImport').length;"
            );

            # Import test Selenium Process.
            $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
            $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
            $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript => "return !\$('#OverwriteExistingEntitiesImport:checked').length;"
            );
            $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();
        }

        # Get process list.
        my $List = $ProcessObject->ProcessList(
            UseEntities    => 1,
            StateEntityIDs => ['S1'],
            UserID         => $TestUserID,
        );

        # Get process entity.
        my %ListReverse = reverse %{$List};

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );

        # Get image attachment.
        my $AttachmentName = "StdAttachment-Test1.png";
        $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content   = ${$ContentRef};
        my $ContentID = 'inline173020.131906379.1472199795.695365.264540139@localhost';

        # Create test note with inline attachment.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'agent',
            Subject              => 'Selenium subject test',
            Body                 => '<!DOCTYPE html><html><body><img src="cid:' . $ContentID . '" /></body></html>',
            ContentType          => 'text/html; charset="utf8"',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Added note (Note)',
            UserID               => 1,
            Attachment           => [
                {
                    Content     => $Content,
                    ContentID   => $ContentID,
                    ContentType => 'image/png; name="' . $AttachmentName . '"',
                    Disposition => 'inline',
                    FileID      => 1,
                    Filename    => $AttachmentName,
                },
            ],
            NoAgentNotify => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - ID $ArticleID",
        );

        # Navigate to zoom screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ArticleID=$ArticleID");

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '.SplitSelection',
        );

        # Click on the split action.
        $Selenium->find_element( '.SplitSelection', 'css' )->click();

        $Selenium->WaitFor( JavaScript => 'return $("#SplitSelection").length && $("#SplitSubmit").length;' );

        # Change it to Process Ticket.
        $Selenium->InputFieldValueSet(
            Element => '#SplitSelection',
            Value   => 'ProcessTicket',
        );

        $Selenium->WaitFor( JavaScript => 'return $("#ProcessEntityID").length;' );

        # Select test process.
        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $Process->{EntityID},
        );

        $Selenium->find_element( '#SplitSubmit', 'css' )->VerifiedClick();

        # Wait until process is selected and all AJAX calls are finished.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ProcessEntityID option:selected').text().trim() == 'TestProcess';"
        );

        $Selenium->WaitFor( JavaScript => "return \$.active == 0;" );

        # Wait for the CKEditor to load.
        my $RichTextElement = $Selenium->find_element( '#RichText', 'css' );
        $Selenium->WaitFor(
            JavaScript => [
                q{ return arguments[0].classList.contains('HasCKEInstance') },
                $RichTextElement,
            ],
        );

        my $CKEditorValue = $Selenium->execute_script(
            q{ return CKEditorInstances['RichText'].getData() }
        );

        # Check if there is inline image in process screen.
        $ContentID =~ s/@/%40/g;
        $Self->True(
            index( $CKEditorValue, $ContentID ) > -1,
            "RichText contains inline image.",
        );

        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # Get last article id.
        my @Articles = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
            TicketID => $TicketID,
            OnlyLast => 1,
        );
        my $LastArticleID = $Articles[0]->{ArticleID};

        # Get article attachments.
        my $HTMLContent     = '';
        my %AttachmentIndex = $ArticleBackendObject->ArticleAttachmentIndex(
            ArticleID => $LastArticleID,
        );

        # Go through all attachments.
        for my $FileID ( sort keys %AttachmentIndex ) {
            my %Attachment = $ArticleBackendObject->ArticleAttachment(
                ArticleID => $LastArticleID,
                FileID    => $FileID,
            );

            # Image attachment.
            if ( $Attachment{ContentType} =~ /^image\/png/ ) {
                $Self->Is(
                    $Attachment{Disposition},
                    'inline',
                    'Inline image attachment found',
                );

                # Save content id.
                if ( $Attachment{ContentID} ) {
                    $ContentID = $Attachment{ContentID};
                    $ContentID =~ s/<|>//g;
                }
            }

            # Html attachment.
            elsif ( $Attachment{ContentType} =~ /^text\/html/ ) {
                $HTMLContent = $Attachment{Content};
            }
        }

        my $TransitionObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
        my $ActivityObject          = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
        my $ActivityDialogObject    = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

        my $Success;

        # Clean up activities.
        for my $Item ( @{ $Process->{Activities} } ) {
            my $Activity = $ActivityObject->ActivityGet(
                EntityID            => $Item,
                UserID              => $TestUserID,
                ActivityDialogNames => 0,
            );

            # Clean up activity dialogs.
            for my $ActivityDialogItem ( @{ $Activity->{ActivityDialogs} } ) {
                my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
                    EntityID => $ActivityDialogItem,
                    UserID   => $TestUserID,
                );

                # Delete test activity dialog.
                $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "ActivityDialog deleted - $ActivityDialog->{Name},",
                );
            }

            # Delete test activity.
            $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Activity deleted - $Activity->{Name},",
            );
        }

        # Clean up transition actions.
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition action.
            $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "TransitionAction deleted - $TransitionAction->{Name},",
            );
        }

        # Clean up transition.
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition.
            $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Transition deleted - $Transition->{Name},",
            );
        }

        # Delete test process.
        $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Process deleted - $Process->{Name},",
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # Delete created test tickets.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
        }
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID",
        );

        # Restore state of process.
        for my $Process (@DeactivatedProcesses) {
            $ProcessObject->ProcessUpdate(
                ID            => $Process->{ID},
                EntityID      => $Process->{EntityID},
                Name          => $Process->{Name},
                StateEntityID => 'S1',
                Layout        => $Process->{Layout},
                Config        => $Process->{Config},
                UserID        => $TestUserID,
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (
            qw (ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Transition ProcessManagement_TransitionAction Ticket)
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }

    },
);

done_testing;
