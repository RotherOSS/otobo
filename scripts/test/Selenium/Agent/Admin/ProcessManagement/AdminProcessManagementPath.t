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

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

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

        my $ProcessRandom          = 'Process' . $Helper->GetRandomID();
        my $ActivityRandom         = 'Activity' . $Helper->GetRandomID();
        my $ActivityRandom2        = $ActivityRandom . '2';
        my $TransitionRandom       = 'Transition' . $Helper->GetRandomID();
        my $TransitionRandom2      = $TransitionRandom . '2';
        my $TransitionActionRandom = 'TransitionAction' . $Helper->GetRandomID();

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement;IncludeInvalid=1");

        # Create new test Process.
        $Selenium->find_element('//a[contains(@href, "Subaction=ProcessNew" )]')->VerifiedClick();
        $Selenium->find_element( '#Name',        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( '#Description', 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( '#Submit',      'css' )->VerifiedClick();

        # Get test ProcessEntityID.
        my $ProcessQuoted = $DBObject->Quote($ProcessRandom);
        $DBObject->Prepare(
            SQL  => 'SELECT entity_id FROM pm_process WHERE name = ?',
            Bind => [ \$ProcessQuoted ]
        );
        my $ProcessEntityID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ProcessEntityID = $Row[0];
        }

        # Save test ElementIDs grouped by type for later.
        my $ElementIDs = {
            Activity => {
                $ActivityRandom  => {},
                $ActivityRandom2 => {},
            },
            Transition => {
                $TransitionRandom  => {},
                $TransitionRandom2 => {},
            },
            TransitionAction => {
                $TransitionActionRandom => {},
            },
        };

        # Save test ElementEntityIDs for later.
        my %ElementEntityIDs;

        my $ElementDBTableMap = {
            Activity         => 'pm_activity',
            Transition       => 'pm_transition',
            TransitionAction => 'pm_transition_action',
        };

        # Create test Elements.
        for my $ElementType ( sort keys %{$ElementIDs} ) {

            my $Elements = $ElementIDs->{$ElementType};

            for my $ElementName ( sort keys %{$Elements} ) {

                # Expand correct AccordionElement.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function"'
                        . ' && $("#ProcessElements li.AccordionElement").has("a[href*=\"Subaction='
                        . $ElementType
                        . 'New\"]").find("a.AsBlock").length === 1'
                        . ' && $("#ProcessElements li.AccordionElement").has("a[href*=\"Subaction='
                        . $ElementType
                        . 'New\"]").find("a.AsBlock").is(":visible");'
                );
                $Selenium->find_element(
                    '//li[contains(@class,"AccordionElement")][.//a[contains(@href,"Subaction='
                        . $ElementType
                        . 'New")]]//a[contains(@class,"AsBlock")]',
                    'xpath',
                )->click();
                $Selenium->WaitFor(
                    JavaScript =>
                        'return $("#ProcessElements li.AccordionElement")'
                        . '.has("a[href*=\"Subaction=' . $ElementType . 'New\"]")'
                        . '.hasClass("Active");'
                );

                # Create new test Element.
                $Selenium->find_element( '//a[contains(@href,"Subaction=' . $ElementType . 'New")]' )->click();

                # Switch to pop up window.
                $Selenium->WaitFor( WindowCount => 2 );
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                # Input name.
                $Selenium->find_element( '#Name', 'css' )->send_keys($ElementName);

                # Fill additional required fields with placeholder data.
                if ( $ElementType eq 'Transition' ) {

                    $Selenium->find_element('.//*[@id="ConditionFieldName[1][1]"]')->send_keys( $ElementName . 'FieldName' );
                    $Selenium->find_element('.//*[@id="ConditionFieldValue[1][1]"]')->send_keys( $ElementName . 'FieldValue' );
                }
                elsif ( $ElementType eq 'TransitionAction' ) {

                    $Selenium->InputFieldValueSet(
                        Element => '#Module',
                        Value   => 'Kernel::System::ProcessManagement::TransitionAction::DynamicFieldSet',
                    );
                }

                $Selenium->find_element( '#Submit', 'css' )->click();

                # Switch back to main window.
                $Selenium->WaitFor( WindowCount => 1 );
                $Selenium->switch_to_window( $Handles->[0] );

                # Get test ElementID.
                my $ElementQuoted = $DBObject->Quote($ElementName);
                $DBObject->Prepare(
                    SQL  => 'SELECT id, entity_id FROM ' . $ElementDBTableMap->{$ElementType} . ' WHERE name = ?',
                    Bind => [ \$ElementQuoted ]
                );
                while ( my @Row = $DBObject->FetchrowArray() ) {
                    $ElementIDs->{$ElementType}->{$ElementName} = $Row[0];
                    $ElementEntityIDs{$ElementName} = $Row[1];
                }

                # Wait for jsPlumb to stabilize before continuing.
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function"'
                        . ' && $("li.AccordionElement.Active li[data-id=\"'
                        . $ElementIDs->{$ElementType}->{$ElementName}
                        . '\"]").length === 1'
                        . ' && $("li.AccordionElement.Active li[data-id=\"'
                        . $ElementIDs->{$ElementType}->{$ElementName}
                        . '\"]").is(":visible")'
                        . ' && $("li.AccordionElement.Active li[data-id=\"'
                        . $ElementIDs->{$ElementType}->{$ElementName}
                        . '\"]").hasClass("ui-draggable");'
                );
            }
        }

        # Wait for Canvas to initialize.
        $Selenium->WaitFor(
            JavaScript =>
                'return $("#Canvas").hasClass("ui-droppable");'
        );

        # Expand Activity AccordionElement.
        $Selenium->execute_script('$("#ProcessElements .AccordionElement:eq(0) a.AsBlock").click();');

        # Wait for jsPlumb to stabilize before dragging.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function"'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Activity}->{$ActivityRandom}
                . '\"]").length === 1'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Activity}->{$ActivityRandom}
                . '\"]").is(":visible")'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Activity}->{$ActivityRandom}
                . '\"]").hasClass("ui-draggable");'
        );

        # DragAndDrop Activity1 to Canvas.
        $Selenium->DragAndDrop(
            Element      => 'li.AccordionElement.Active ul[id="Activities"] li[data-id="' . $ElementIDs->{Activity}->{$ActivityRandom} . '"]',
            Target       => 'div[id="Canvas"]',
            TargetOffset => {
                X => -200,
                Y => -100
            },
        );
        $Selenium->WaitFor( ElementExists => '//div[@id="Canvas"]//div[@id="' . $ElementEntityIDs{$ActivityRandom} . '"]' );

        # Wait for jsPlumb to stabilize before dragging.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function"'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Activity}->{$ActivityRandom2}
                . '\"]").length === 1'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Activity}->{$ActivityRandom2}
                . '\"]").is(":visible")'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Activity}->{$ActivityRandom2}
                . '\"]").hasClass("ui-draggable");'
        );

        # DragAndDrop Activity2 to Canvas.
        $Selenium->DragAndDrop(
            Element      => 'li.AccordionElement.Active ul[id="Activities"] li[data-id="' . $ElementIDs->{Activity}->{$ActivityRandom2} . '"]',
            Target       => 'div[id="Canvas"]',
            TargetOffset => {
                X => 200,
                Y => -200
            },
        );
        $Selenium->WaitFor( ElementExists => '//div[@id="Canvas"]//div[@id="' . $ElementEntityIDs{$ActivityRandom2} . '"]' );

        # Adding duplicate Activity1 to canvas throws error.
        $Selenium->DragAndDrop(
            Element      => 'ul[id="Activities"] li[data-id="' . $ElementIDs->{Activity}->{$ActivityRandom} . '"]',
            Target       => 'div[id="Canvas"]',
            TargetOffset => {
                X => -200,
                Y => -100
            },
        );
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for duplicate Activity added to Canvas not found';

        # Verify the alert message.
        $Selenium->alert_text_like(
            qr/This Activity is already used in the Process. You cannot add it twice!/,
            'Duplicate Activity warning is shown'
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Expand Transition AccordionElement.
        $Selenium->execute_script('$("#ProcessElements .AccordionElement:eq(2) a.AsBlock").click();');

        # Wait for jsPlumb to stabilize before dragging.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function"'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Transition}->{$TransitionRandom}
                . '\"]").length === 1'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Transition}->{$TransitionRandom}
                . '\"]").is(":visible")'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Transition}->{$TransitionRandom}
                . '\"]").hasClass("ui-draggable");'
        );

        # DragAndDrop Transition1 onto Activity1.
        $Selenium->DragAndDrop(
            Element => 'li.AccordionElement.Active ul[id="Transitions"] li[data-id="'
                . $ElementIDs->{Transition}->{$TransitionRandom}
                . '"]',
            Target       => 'div[id="Canvas"] div[id="' . $ElementEntityIDs{$ActivityRandom} . '"]',
            TargetOffset => {
                X => 10,
                Y => 10
            },
        );
        $Selenium->WaitFor( ElementExists => '//div[@id="Canvas"]//span[@id="' . $ElementEntityIDs{$TransitionRandom} . '"]' );

        # Wait for jsPlumb to stabilize before dragging.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function"'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Transition}->{$TransitionRandom2}
                . '\"]").length === 1'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Transition}->{$TransitionRandom2}
                . '\"]").is(":visible")'
                . ' && $("li.AccordionElement.Active li[data-id=\"'
                . $ElementIDs->{Transition}->{$TransitionRandom2}
                . '\"]").hasClass("ui-draggable");'
        );

        # DragAndDrop Transition2 onto Activity2 before fully connecting Transition1 throws error.
        $Selenium->DragAndDrop(
            Element => 'li.AccordionElement.Active ul[id="Transitions"] li[data-id="'
                . $ElementIDs->{Transition}->{$TransitionRandom2}
                . '"]',
            Target       => 'div[id="Canvas"] div[id="' . $ElementEntityIDs{$ActivityRandom2} . '"]',
            TargetOffset => {
                X => 10,
                Y => 10
            },
        );
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for two unfinished Transitions added to Canvas not found';

        # Verify the alert message.
        $Selenium->alert_text_like(
            qr/An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition./,
            'Two unfinished Transitions warning is shown'
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Connect the open Transition1 endpoint to Activity2.
        $Selenium->DragAndDrop(
            Element      => 'div._jsPlumb_endpoint:not(._jsPlumb_endpoint_connected)',
            Target       => 'div[id="Canvas"] div[id="' . $ElementEntityIDs{$ActivityRandom2} . '"]',
            TargetOffset => {
                X => 10,
                Y => 10
            },
        );
        $Selenium->WaitFor( ElementExists => '//div[@id="Canvas"]//div[contains(@class, "_jsPlumb_endpoint_connected")]' );

        # Save path changes.
        $Selenium->find_element( '#SubmitAndContinue', 'css' )->VerifiedClick();

        # Verify db-state.
        my $ProcessData = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessGet(
            EntityID => $ProcessEntityID,
            UserID   => $TestUserID
        );

        $Self->Is(
            $ProcessData->{Config}->{StartActivity},
            $ElementEntityIDs{$ActivityRandom},
            'StartActivity is in Path - $ElementEntityIDs{$ActivityRandom}'
        );

        $Self->IsDeeply(
            $ProcessData->{Config}->{Path}->{ $ElementEntityIDs{$ActivityRandom2} },
            {},
            'EndActivity is in Path - $ElementEntityIDs{$ActivityRandom2}'
        );

        $Self->Is(
            $ProcessData->{Config}->{Path}->{ $ElementEntityIDs{$ActivityRandom} }->{ $ElementEntityIDs{$TransitionRandom} }->{ActivityEntityID},
            $ElementEntityIDs{$ActivityRandom2},
            'Created path itself is in Path'
        );

        # Double click TransitionLabel to open PathEdit.
        $Selenium->execute_script('$("div[id=\"Canvas\"] div[class*=\"TransitionLabel\"]").dblclick()');

        # Switch to pop up window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Check for created test TransitionAction.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#AvailableTransitionActions li:contains($TransitionActionRandom)').length"
        );

        # Assign test TransitionAction.
        $Selenium->DragAndDrop(
            Element      => '#AvailableTransitionActions li[data-id="' . $ElementIDs->{TransitionAction}->{$TransitionActionRandom} . '"]',
            Target       => '#AssignedTransitionActions',
            TargetOffset => {
                X => 10,
                Y => 10,
            },
        );

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#AssignedTransitionActions li:contains($TransitionActionRandom)').length"
        );

        # Edit test TransitionAction through redirect.
        $Selenium->find_element(
            '#AssignedTransitionActions li[data-id="' . $ElementIDs->{TransitionAction}->{$TransitionActionRandom} . '"] a[data-subaction="TransitionActionEdit"]',
            'css',
        )->click();
        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for current PathEdit state being saved not found';

        # Verify the alert message.
        $Selenium->alert_text_like(
            qr/As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?/,
            'Warning for saving current PathEdit state is shown'
        );

        # Accept alert.
        $Selenium->accept_alert();

        # Go back without editing.
        $Selenium->WaitFor( ElementExists => '//a[@class="GoBack"]' );
        $Selenium->find_element('//a[@class="GoBack"]')->VerifiedClick();

        # Change to test Transition2 and submit.
        $Selenium->find_element( '//select[@id="Transition"]//option[@value="' . $ElementEntityIDs{$TransitionRandom2} . '"]' )->click();
        $Selenium->find_element( '#Submit', 'css' )->click();

        # Switch back to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Save Path changes.
        $Selenium->find_element( '#SubmitAndContinue', 'css' )->VerifiedClick();

        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ProcessManagement_Process',
        );

        # Verify Path entry in ProcessConfig.
        $ProcessData = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessGet(
            EntityID => $ProcessEntityID,
            UserID   => $TestUserID
        );

        $Self->Is(
            $ProcessData->{Config}->{Path}->{ $ElementEntityIDs{$ActivityRandom} }->{ $ElementEntityIDs{$TransitionRandom2} }->{TransitionAction}->[0],
            $ElementEntityIDs{$TransitionActionRandom},
            'Updated path is in Path'
        );

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
        $Selenium->find_element( '#Submit', 'css' )->click();

        # Test search filter.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Filter").length' );
        $Selenium->find_element( '#Filter', 'css' )->clear();
        $Selenium->find_element( '#Filter', 'css' )->send_keys($ProcessRandom);

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
        $Selenium->find_element('//a[@id="ProcessDelete"]')->click();

        # Confirm deletion.
        $Selenium->WaitFor( ElementExists => '//div[@role="dialog"]' );
        $Selenium->find_element( 'div[role="dialog"] button[id="DialogButton2"]', 'css' )->VerifiedClick();

        # Verify db-state.
        my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessGet(
            ID     => $ProcessID,
            UserID => $TestUserID,
        );
        $Self->False(
            $Success,
            "Process is deleted - $ProcessID",
        );

        # Delete remaining Elements and verify db-state again.
        while ( my ( $ElementType, $Elements ) = each %{$ElementIDs} ) {

            my $ElementDelete = $ElementType . 'Delete';
            my $ElementGet    = $ElementType . 'Get';

            while ( my ( $ElementName, $ElementID ) = each %{$Elements} ) {

                $Kernel::OM->Get( 'Kernel::System::ProcessManagement::DB::' . $ElementType )->$ElementDelete(
                    ID     => $ElementID,
                    UserID => $TestUserID,
                );

                $Success = $Kernel::OM->Get( 'Kernel::System::ProcessManagement::DB::' . $ElementType )->$ElementGet(
                    ID     => $ElementID,
                    UserID => $TestUserID,
                );
                $Self->False(
                    $Success,
                    "Element is deleted - $ElementID",
                );
            }
        }

        # Synchronize process after deleting test process.
        $Selenium->find_element('//a[contains(@href, "Subaction=ProcessSync" )]')->VerifiedClick();

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(ProcessManagement_Activity ProcessManagement_Process)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

$Self->DoneTesting();
