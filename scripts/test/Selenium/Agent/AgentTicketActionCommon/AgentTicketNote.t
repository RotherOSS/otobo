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

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Create test group.
        my $RandomID    = $Helper->GetRandomID();
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        my $GroupName   = "Group" . $RandomID;
        my $GroupID     = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        ok( $GroupID, "Group ID $GroupID is created." );

        # Create test queue.
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
        my $QueueName   = 'Queue' . $RandomID;
        my $QueueID     = $QueueObject->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => 1,
        );
        ok( $QueueID, "Queue ID $QueueID is created." );

        # Create two test user. One with 'ro' and 'note' permissions, other one with only 'note' permission.
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my @CreatedUserIDs;
        for my $Count ( 1 .. 2 ) {
            my $UserID = $UserObject->UserAdd(
                UserFirstname => $Count . 'First' . $RandomID,
                UserLastname  => $Count . 'Last' . $RandomID,
                UserLogin     => $Count . $RandomID,
                UserEmail     => $Count . $RandomID . '@localhost.com',
                ValidID       => 1,
                ChangeUserID  => 1,
            );
            ok( $UserID, "User ID $UserID is created." );
            push @CreatedUserIDs, $UserID;

            # Add created test user to appropriate group.
            my $HasRoPermission = $Count == 1 ? 1 : 0;
            my $Success         = $GroupObject->PermissionGroupUserAdd(
                GID        => $GroupID,
                UID        => $UserID,
                Permission => {
                    ro        => $HasRoPermission,
                    move_into => 0,
                    create    => 0,
                    note      => 1,
                    owner     => 0,
                    priority  => 0,
                    rw        => 0,
                },
                UserID => 1,
            );
            ok( $Success, "User $UserID with note=1, ro=$HasRoPermission on group $GroupID" );
        }

        # Enable 'InformAgent' for AgentTicketNote screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InformAgent',
            Value => 1,
        );

        # Enable 'InvolvedAgent' for AgentTicketNote screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###InvolvedAgent',
            Value => 1,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', $GroupName ],
        );
        bail_out('test user could npt be created') unless $TestUserLogin;

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            QueueID      => $QueueID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        ok( $TicketID, "Ticket $TicketID is created" );

        # Update the ticket owner to have an involved user.
        $TicketObject->TicketOwnerSet(
            TicketID  => $TicketID,
            NewUserID => $CreatedUserIDs[0],
            UserID    => $CreatedUserIDs[0],
        );

        # Create test user.
        my ( undef, $TestUserID2 ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', $GroupName ],
        );

        $TicketObject->TicketStateSet(
            StateID  => 3,
            TicketID => $TicketID,
            UserID   => $TestUserID2,
        );

        # Change permission for test user
        # See bug#15031.
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID,
            UID        => $TestUserID2,
            Permission => {
                ro        => 0,
                move_into => 0,
                create    => 0,
                note      => 1,
                owner     => 0,
                priority  => 0,
                rw        => 0,
            },
            UserID => 1,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$.active == 0"
        );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script(
            '$("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );
        $Selenium->WaitFor( JavaScript => "return \$('#nav-Communication ul').css('opacity') == 1;" );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".WidgetSimple").length;' );

        # Open collapsed widgets, if necessary.
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed .WidgetAction > a').trigger('click');"
        );

        $Selenium->WaitFor( JavaScript => 'return $(".WidgetSimple.Expanded").length;' );

        # Check page.
        for my $ID (
            qw(Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Verify only agent with 'ro' permission is available for Inform Agents selection.
        # See bug#14488.
        ok(
            $Selenium->execute_script("return \$('#InformUserID option[value=$CreatedUserIDs[0]]').length"),
            "UserID $CreatedUserIDs[0] with 'ro' and 'note' permission is available for selection in Inform Agents."
        );
        ok(
            !$Selenium->execute_script("return \$('#InformUserID option[value=$CreatedUserIDs[1]]').length"),
            "UserID $CreatedUserIDs[1] with only 'note' permission is not available for selection in Inform Agents."
        );

        # Verify only agent with 'ro' permission is available for Inform Agents selection.
        # See bug#15031.
        ok(
            $Selenium->execute_script("return \$('#InvolvedUserID option[value=$CreatedUserIDs[0]]').length"),
            "UserID $CreatedUserIDs[0] with 'ro' and 'note' permission is available for selection in Involved Agents."
        );
        ok(
            !$Selenium->execute_script("return \$('#InvolvedUserID option[value=$TestUserID2]').length"),
            "UserID $TestUserID2 without 'ro' permission is not available for selection in Involved Agents."
        );

        # Get default subject value from Ticket::Frontend::AgentTicketNote###Subject.
        my $DefaultNoteSubject = $ConfigObject->Get("Ticket::Frontend::AgentTicketNote")->{Subject};

        # Add note.
        my $NoteSubject;
        if ($DefaultNoteSubject) {
            $NoteSubject = $DefaultNoteSubject;
        }
        else {
            $NoteSubject = 'Test';
            $Selenium->find_element( "#Subject", 'css' )->send_keys($NoteSubject);
        }

        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Switch window back to agent ticket zoom view of created test ticket.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->WaitFor(
            JavaScript => 'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        # Navigate to history of created test ticket.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID"
        );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Confirm note action.
        $Selenium->content_contains(
            'Added note (Note)',
            'Ticket note action completed',
        );

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Click 'Reply to note' in order to check for pre-loaded reply-to note subject, see bug #10931.
        $Selenium->find_element("//a[contains(\@href, \'ReplyToArticle' )]")->click();

        # Switch window.
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".WidgetSimple").length;' );

        # Check for subject pre-loaded value.
        my $NoteSubjectRe = $ConfigObject->Get('Ticket::SubjectRe') || 'Re';

        is(
            $Selenium->find_element( '#Subject', 'css' )->get_value(),
            $NoteSubjectRe . ': ' . $NoteSubject,
            "Reply-To note #Subject pre-loaded value",
        );

        # Close note pop-up window.
        $Selenium->close;

        # Switch window back to agent ticket zoom view of created test ticket.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Turn on RichText for next test.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 1,
        );

        # Get image attachment.
        my $AttachmentName = "StdAttachment-Test1.png";
        my $Location       = $ConfigObject->Get('Home')
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
        ok( $ArticleID, "ArticleCreate ID $ArticleID is created." );

        # Navigate to added note article.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ArticleID=$ArticleID");

        # Click 'Reply to note'.
        $Selenium->find_element("//a[contains(\@href, \'ReplyToArticle' )]")->click();

        # Switch window.
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function';"
        );

        # find <textarea id="RichText" class="RichText Validate  Validate_Required" name="Body" rows="15" cols="78"></textarea>
        # This element is there even if CKEditor is not ready yet
        my $RichTextElement = $Selenium->find_element(
            q{//textarea[@id="RichText"]},
            'xpath'
        );

        # Wait for the CKEditor to load.
        $Selenium->WaitFor(
            JavaScript => [
                <<'END_JS',
// do a simple check. HasCKEInstance is set in Core.UT.RichTextEditor.js
return arguments[0].classList.contains('HasCKEInstance');

// The saner check for the state of the Editor does not seem to work here.
/*
const editableElement = arguments[0].closest('.ck-editor__editable_inline');
const editorInstance  = editableElements.ckeditorInstance;
const editorState     = editorInstance.state;
return editorState  == 'ready';
*/

END_JS
                $RichTextElement,
            ]
        );

        # Submit note.
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Wait until popup has closed.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

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
                is(
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

        # Check if inline attachment is present in the note reply (see bug#12259).
        ok(
            index( $HTMLContent, $ContentID ) > -1,
            'Inline attachment found in note reply',
        );

        # Add a template.
        my $TemplateText           = 'This is a test template';
        my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
        my $TemplateID             = $StandardTemplateObject->StandardTemplateAdd(
            Name         => 'UTTemplate_' . $RandomID,
            Template     => $TemplateText,
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Note',
            ValidID      => 1,
            UserID       => 1,
        );
        ok( $TemplateID, "Template ID $TemplateID is created." );

        # Assign the template to our queue.
        my $Success = $QueueObject->QueueStandardTemplateMemberAdd(
            QueueID            => $QueueID,
            StandardTemplateID => $TemplateID,
            Active             => 1,
            UserID             => 1,
        );
        ok( $Success, "Template got assigned to $QueueName" );

        # Now switch to mobile mode and reload the window.
        $Selenium->set_window_size( 600, 400 );
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID"
        );

        $Selenium->execute_script(
            "\$('.Cluster ul.Actions').scrollLeft(\$('#nav-Note').offset().left - \$('#nav-Note').width());"
        );

        # Open the note screen (which should be an iframe now).
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

        # Wait for the iframe to show up.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('form#Compose', \$('.PopupIframe').contents()).length == 1;"
        );

        $Selenium->SwitchToFrame(
            FrameSelector => '.PopupIframe',
            WaitForLoad   => 1,
        );

        $Selenium->WaitFor( JavaScript => "return \$('#RichText').length;" );

        # Check if the richtext is empty.
        is(
            $Selenium->find_element( '#RichText', 'css' )->get_value(),
            '',
            "RichText is empty",
        );

        # Select the created template.
        $Selenium->InputFieldValueSet(
            Element => '#StandardTemplateID',
            Value   => $TemplateID,
        );

        # Wait a short time and for the spinner to disappear.
        sleep 2;
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.AJAXLoader:visible', \$('.PopupIframe').contents()).length == 0"
        );

        $Selenium->WaitFor(
            JavaScript => q{return CKEditorInstances['RichText'].getData()},
        );

        my $CKEditorValue = $Selenium->execute_script(
            "return CKEditorInstances['RichText'].getData()"
        );

        my $TemplateTextInParagraph = qq{<p>$TemplateText</p>};
        is(
            $CKEditorValue,
            $TemplateTextInParagraph,
            'CKEditor seems to put plain lines into paragraphs',
        );
        bail_out('unexpected content in RichText field') unless $CKEditorValue eq $TemplateTextInParagraph;

        # Delete template.
        my $TemplateDeleteSuccess = $StandardTemplateObject->StandardTemplateDelete(
            ID => $TemplateID,
        );
        ok( $TemplateDeleteSuccess, "Template ID $TemplateID is deleted." );

        # Delete created test tickets.
        my $TicketDeleteSuccess = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$TicketDeleteSuccess ) {
            sleep 3;
            $TicketDeleteSuccess = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
        }
        ok( $TicketDeleteSuccess, "Ticket ID $TicketID is deleted." );

        # Delete test created queue.
        my $DBObject           = $Kernel::OM->Get('Kernel::System::DB');
        my $GroupDeleteSuccess = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$QueueID ],
        );
        ok( $GroupDeleteSuccess, "QueueID $QueueID is deleted." );

        # Delete group-user relations.
        my $GroupUserDeleteSuccess = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        ok( $GroupUserDeleteSuccess, "Relation for group ID $GroupID is deleted." );

        # Delete test created users.
        for my $UserID (@CreatedUserIDs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM user_preferences WHERE user_id = ?",
                Bind => [ \$UserID ],
            );
            ok( $Success, "User preferences for $UserID is deleted." );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM users WHERE id = ?",
                Bind => [ \$UserID ],
            );
            ok( $Success, "UserID $UserID is deleted." );
        }

        # Delete test created groups.
        my $GroupsTableDeleteSuccess = $DBObject->Do(
            SQL  => "DELETE FROM groups_table WHERE id = ?",
            Bind => [ \$GroupID ],
        );
        ok( $GroupsTableDeleteSuccess, "GroupID $GroupID is deleted." );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    },
);

done_testing;
