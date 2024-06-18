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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self (unused) and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
        my $ACLObject     = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $QueueObject   = $Kernel::OM->Get('Kernel::System::Queue');
        my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

        # Do not check RichText and Service.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );

        # Disable CheckEmailAddresses feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        # Disable CheckMXRecord feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test user.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        # Get all processes.
        my $ProcessList = $ProcessObject->ProcessListGet(
            UserID => $TestUserID,
        );

        my @DeactivatedProcesses;
        my $ProcessName = "TestProcess";
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

        # Create test queues.
        my @Queues;
        for my $Item (qw( process activity dialog )) {
            my $QueueName = "Queue$Item-$RandomID";
            my $QueueID   = $QueueObject->QueueAdd(
                Name            => $QueueName,
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Selenium Queue',
                UserID          => $TestUserID,
            );
            ok( $QueueID, "QueueID $QueueID is created" );
            push @Queues, {
                ID   => $QueueID,
                Name => $QueueName,
            };
        }

        # Login.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Import test process if does not exist in the system.
        if ( !$TestProcessExists ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#OverwriteExistingEntitiesImport').length;"
            );

            # Import test Selenium Process.
            my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
            $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
            $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript => "return !\$('#OverwriteExistingEntitiesImport:checked').length;"
            );
            $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

            pass("Process information is synchronized");
        }

        # Get Process list.
        my $List = $ProcessObject->ProcessList(
            UseEntities    => 1,
            StateEntityIDs => ['S1'],
            UserID         => $TestUserID,
        );

        # Get Process entity.
        my %ListReverse = reverse %{$List};

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );

        my $InvalidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( Valid => 'invalid' );

        # Set previous ACLs on invalid.
        my $ACLList = $ACLObject->ACLList(
            ValidIDs => ['1'],
            UserID   => $TestUserID,
        );

        for my $Item ( sort keys %{$ACLList} ) {
            $ACLObject->ACLUpdate(
                ID      => $Item,
                Name    => $ACLList->{$Item},
                ValidID => $InvalidID,
                UserID  => $TestUserID,
            );
        }

        # Synchronize test ACLs.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");

        pass("ACL information is synchronized after update");

        # Create test ACLs.
        my @ACLs = (
            {
                Name           => "100-ACL-$RandomID",
                Comment        => 'Disable test queues',
                Description    => 'Disable test queues',
                StopAfterMatch => 0,
                ConfigMatch    => '',
                ConfigChange   => {
                    PossibleNot => {
                        Ticket => {
                            Queue => [ $Queues[0]->{Name}, $Queues[1]->{Name}, $Queues[2]->{Name} ],
                        },
                    },
                },
            },
            {
                Name           => "200-ACL-$RandomID",
                Comment        => 'Enable queue for appropriate process',
                Description    => 'Enable queue for appropriate process',
                StopAfterMatch => 0,
                ConfigMatch    => {
                    Properties => {
                        Process => {
                            'ProcessEntityID' => [ $Process->{EntityID} ],
                        },
                    },
                },
                ConfigChange => {
                    PossibleAdd => {
                        Ticket => {
                            Queue => [ $Queues[0]->{Name} ],
                        },
                    },
                },
            },
            {
                Name           => "300-ACL-$RandomID",
                Comment        => 'Enable queue for appropriate (the first) activity',
                Description    => 'Enable queue for appropriate (the first) activity',
                StopAfterMatch => 0,
                ConfigMatch    => {
                    Properties => {
                        Process => {
                            'ActivityEntityID' => [ $Process->{Config}->{StartActivity} ],
                        },
                    },
                },
                ConfigChange => {
                    PossibleAdd => {
                        Ticket => {
                            Queue => [ $Queues[1]->{Name} ],
                        },
                    },
                },
            },
            {
                Name           => "400-ACL-$RandomID",
                Comment        => 'Enable queue for appropriate (the first) activity dialog',
                Description    => 'Enable queue for appropriate (the first) activity dialog',
                StopAfterMatch => 0,
                ConfigMatch    => {
                    Properties => {
                        Process => {
                            'ActivityDialogEntityID' => [ $Process->{Config}->{StartActivityDialog} ],
                        },
                    },
                },
                ConfigChange => {
                    PossibleAdd => {
                        Ticket => {
                            Queue => [ $Queues[2]->{Name} ],
                        },
                    },
                },
            },
        );

        for my $ACL (@ACLs) {

            my $ACLID = $ACLObject->ACLAdd(
                %{$ACL},
                ValidID => 1,
                UserID  => $TestUserID,
            );
            ok( $ACLID, "ACLID $ACLID is created" );

            # Add ACLID to test ACL data.
            $ACL->{ACLID} = $ACLID;
        }

        # Navigate to AdminACL and synchronize ACL's.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # Verify ACL are
        for my $ACL (@ACLs) {
            ok(
                $Selenium->find_element("//a[text()=\"$ACL->{Name}\"]")->is_displayed(),
                "ACLName '$ACL->{Name}' found on page.",
            );
        }

        # Navigate to agent ticket process directly via URL with pre-selected process and activity dialog.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketProcess;ID=$Process->{EntityID};ActivityDialogEntityID=$Process->{Config}->{StartActivityDialog}"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        # Verify all test queues exist for appropriate process, activity and activity dialog (see bug#14775).
        $Selenium->WaitFor( ElementExists => [ '#QueueID', 'css' ] );
        for my $Queue (@Queues) {
            ok(
                $Selenium->execute_script("return \$('#QueueID option[value=\"$Queue->{ID}\"]').length;"),
                "QueueID $Queue->{ID} is found"
            );
        }

        # Set to invalid all test ACLs except the first one (which disables all test queues).
        ACL:
        for my $ACL (@ACLs) {

            # Do not invalidate the first ACL.
            next ACL if $ACL->{ACLID} == $ACLs[0]->{ACLID};

            my $Success = $ACLObject->ACLUpdate(
                ID             => $ACL->{ACLID},
                Name           => $ACL->{Name},
                ValidID        => $InvalidID,
                UserID         => $TestUserID,
                Comment        => $ACL->{Comment},
                Description    => $ACL->{Description},
                StopAfterMatch => $ACL->{StopAfterMatch},
                ConfigMatch    => $ACL->{ConfigMatch},
                ConfigChange   => $ACL->{ConfigChange},
            );
            ok( $Success, "ACLID $ACL->{ACLID}, ACLName '$ACL->{Name}' is set to invalid" );
        }

        # Synchronize test ACLs.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");
        $Selenium->content_contains(
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
            "ACL deployment successful."
        );
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Selenium->content_lacks(
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
            "ACL deployment successful."
        );

        # Navigate again to agent ticket process directly via URL with pre-selected process and activity dialog.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketProcess;ID=$Process->{EntityID};ActivityDialogEntityID=$Process->{Config}->{StartActivityDialog}"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        # Verify all test queues don't exist now.
        for my $Queue (@Queues) {
            $Selenium->find_no_element_by_css_ok(
                qq{#QueueID option[value="$Queue->{ID}"]},
                "QueueID $Queue->{ID} is not found"
            );
        }

        # Clean up activities.
        my $ActivityObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

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
                my $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                ok( $Success, "ActivityDialog $ActivityDialog->{Name} is deleted" );
            }

            # Delete test activity.
            my $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "Activity $Activity->{Name} is deleted" );
        }

        # Clean up transition actions.
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition action.
            my $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "TransitionAction $TransitionAction->{Name} is deleted" );
        }

        # Clean up transition.
        my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition.
            my $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "Transition $Transition->{Name} is deleted" );
        }

        # Delete test Process.
        my $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );
        ok( $Success, "Process $Process->{Name} is deleted" );

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize Process after deleting test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        pass("Process information is synchronized after removing '$Process->{Name}'");

        # Cleanup ACL.
        for my $ACL (@ACLs) {

            # Delete test ACL.
            my $Success = $ACLObject->ACLDelete(
                ID     => $ACL->{ACLID},
                UserID => $TestUserID,
            );
            ok( $Success, "ACLID $ACL->{ACLID} is deleted" );
        }

        # Navigate to AdminACL to synchronize after test ACL cleanup.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        pass("ACL information is synchronized after removing test ACLs");

        # Delete test queues.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $Queue (@Queues) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$Queue->{ID} ],
            );
            ok( $Success, "QueueID $Queue->{ID} is deleted" );
        }

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
            qw (ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Transition ProcessManagement_TransitionAction)
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

done_testing();
