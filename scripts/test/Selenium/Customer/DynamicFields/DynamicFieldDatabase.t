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

# CPAN modules
use Test2::V0;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;
use Kernel::System::VariableCheck qw(IsHashRefWithData);

use vars (qw($Self));

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
use Selenium::Waiter qw(wait_until);
my $Selenium =
    Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # Create necessary objects
        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $ACLObject          = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $ProcessObject      = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
        my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

        # Disable CheckEmailAddresses feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        my @DeleteACLIDs;
        my @DeleteTicketIDs;
        my $Success;

        # Configure and create dynamic database field
        my $DynamicFieldGet = $DynamicFieldObject->DynamicFieldGet( Name => 'TestDatabase' );

        my $DynamicFieldID = $DynamicFieldGet->{ID};
        if ( !IsHashRefWithData($DynamicFieldGet) ) {
            $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                Name       => 'TestDatabase',
                Label      => 'TestDatabase',
                FieldOrder => 3,
                FieldType  => 'Database',
                Config     => {
                    Searchprefix   => '',
                    Driver         => '',
                    CaseSensitive  => undef,
                    SearchSuffix   => '',
                    CacheTTL       => '0',
                    DBName         => 'otobo',
                    SID            => '',
                    Multiselect    => 'checked=checked',
                    Password       => 'otobo-docker-databasepw',
                    Link           => '',
                    Identifier     => '1',
                    DBTable        => 'queue',
                    User           => 'otobo',
                    ResultLimit    => '',
                    PossibleValues => {
                        FieldDatatype_1 => 'INTEGER',
                        FieldName_1     => 'id',
                        Searchfield_1   => 'on',
                        Listfield_1     => 'on',
                        FieldLabel_1    => 'id',
                        FieldFilter_1   => '',
                        ValueCounter    => '1',
                        ListField_1     => 'on',
                    },
                    Port        => '',
                    LinkPreview => '',
                    DBType      => 'mysql',
                    Tooltip     => 'abcd bcde cdef',
                    Server      => 'db',
                },
                ObjectType => 'Ticket',
                ValidID    => 1,
                UserID     => 1,
                Reorder    => 1,
            );
        }

        # Set config options for dynamic field screens
        for my $Key (
            'CustomerTicketMessage###DynamicField',
            'CustomerTicketZoom###DynamicField',
            'CustomerTicketZoom###FollowUpDynamicField'
            )
        {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => "Ticket::Frontend::$Key",
                Value => {
                    TestDatabase => 1,
                }
            );
        }

        # Preparation for process testing
        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate()
            || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Create ACL and import process
        my $RandomID = $Helper->GetRandomID();

        # Set previous ACLs on invalid.
        my $ACLList = $ACLObject->ACLList(
            ValidIDs => ['1'],
            UserID   => 1,
        );

        for my $Item ( sort keys %{$ACLList} ) {

            $ACLObject->ACLUpdate(
                ID   => $Item,
                Name => $ACLList->{$Item},
                ,
                ValidID => 2,
                UserID  => 1,
            );
        }

        my @ACLs = (
            {
                Name           => '2-ACL-' . $RandomID,
                Comment        => 'Selenium Dynamic Field Database ACL',
                Description    => 'Description',
                StopAfterMatch => 1,
                ConfigChange   => {
                    PossibleNot => {
                        'Form' => [
                            '[RegExp].*',
                        ],
                    }
                },
                ValidID => 1,
                UserID  => 1,
            },
            {
                Name           => '1-ACL-' . $RandomID,
                Comment        => 'Selenium Dynamic Field Database ACL',
                Description    => 'Description',
                StopAfterMatch => 1,
                ConfigMatch    => {
                    Properties => {
                        'Queue' => {
                            'Name' => [
                                'Raw',
                            ],
                        },
                    },
                },
                ConfigChange => {
                    Possible => {
                        'Form' => [
                            'TestDatabase',
                        ],
                    }
                },
                ValidID => 1,
                UserID  => 1,

            }
        );

        for my $ACL (@ACLs) {
            my $ACLID = $ACLObject->ACLAdd(
                %{$ACL},
            );

            $Self->True(
                $ACLID,
                "ACLID $ACLID is created",
            );
            push @DeleteACLIDs, $ACLID;
        }

        # Navigate to AdminACL and synchronize the created ACL's.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # Get all processes.
        my $ProcessList = $ProcessObject->ProcessListGet(
            UserID => $TestUserID,
        );

        my @DeactivatedProcesses;
        my $ProcessName = "TestDynamicFieldDatabaseProcess";
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

        if ( !$TestProcessExists ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$('#OverwriteExistingEntitiesImport').length;"
            );

            # Import test Selenium Process.
            my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/DynamicFieldDatabaseProcess.yml";
            $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
            $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript => "return !\$('#OverwriteExistingEntitiesImport:checked').length;"
            );
            $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();
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

        # Create Process Ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        $Selenium->find_element( "#ProcessEntityID_Search", 'css' )->send_keys($ProcessName);
        $Selenium->find_element( "#ProcessEntityID_Search", 'css' )->click();
        $Selenium->find_element( "#ProcessEntityID_Select", 'css' )->click();

        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        $Selenium->WaitFor(
            ElementExists => [ "#CustomerAutoComplete", 'css' ]
        );
        $Selenium->execute_script(
            "\$('#CustomerAutoComplete').autocomplete('search', '$TestCustomerUserLogin');"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$.active == 0"
        );
        $Selenium->find_element( "#ui-id-1 > li > a",     'css' )->click();
        $Selenium->find_element( "#QueueID_Search",       'css' )->send_keys('raw');
        $Selenium->find_element( "#QueueID_Select",       'css' )->click();
        $Selenium->find_element( "button[type='submit']", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$.active == 0",
        );

        ( undef, my $ProcessTicketID ) = split /TicketID=/, $Selenium->get_current_url();
        push @DeleteTicketIDs, $ProcessTicketID;
        my $ProcessTicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $ProcessTicketID,
        );

        # Start testing as customer user
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # Navigate to Screens which don't require an existing ticket
        for my $Page (qw(CustomerTicketMessage)) {
            $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=$Page");

            # Element should be hidden due to ACL
            $Selenium->find_element( "#DynamicField_TestDatabase", 'css' )->is_hidden();

            # ACL testing: setting queue to 2 should display the field
            $Selenium->find_element( "#Dest_Search",         'css' )->send_keys('Raw');
            $Selenium->find_element( "li[data-id='2||Raw']", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript => "return \$.active == 0",
            );

            my $Element = $Selenium->find_element( "#DynamicField_TestDatabase", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();

            # Testing invalid search term first
            # Working with autocomplete here for triggering the AJAX request
            $Selenium->execute_script(
                "\$('#DynamicField_TestDatabase').autocomplete('search', '-1');"
            );

            # Wait for AJAX Call
            $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

            is(
                $Selenium->execute_script("return \$('.ui-menu-item').length;"),
                0, "Dropdown not visible yet"
            );

            # Testing with valid search term
            $Selenium->execute_script(
                "\$('#DynamicField_TestDatabase').autocomplete('search', '1');"
            );

            # Wait for AJAX Call
            $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

            $Selenium->find_element( ".ui-menu-item", 'css' )->click();

            # Open Detailed Search Dialog
            $Selenium->find_element(
                "#DynamicFieldDBDetailedSearch_DynamicField_TestDatabase",
                'css'
            )->click();

            # Wait for AJAX Call
            $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

            # Fetching iframe and switching to it
            my $DetailedSearchIframe = $Selenium->find_element( ".TextOption", 'css' );
            $Selenium->switch_to_frame($DetailedSearchIframe);
            $Selenium->InputFieldValueSet(
                Element => '#id',
                Value   => '2',
            );

            $Selenium->find_element( "#Search", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript => "return \$.active == 0",
            );
            $Selenium->find_element( "tr[class='MasterAction'] > td", 'css' )->click();

            $Selenium->WaitFor(
                JavaScript => "return \$.active == 0",
            );

            $Selenium->find_element( "#ResultElementText_1", 'css' );
            wait_until {
                $Selenium->find_element( "#ResultElementText_2", 'css' );
            }

            # Test removing a value
            $Selenium->find_element( "#ResultElementText_1 ~ #RemoveDynamicFieldDBEntry", 'css' )->click();
            is(
                $Selenium->execute_script("return \$('#ResultElementText_1').length;"),
                0, "Result Element not visible"
            );

            # Testing Details Function
            $Selenium->find_element( "#ResultElementText_2 ~ .DynamicFieldDBDetails_DynamicField_TestDatabase", 'css' )->click();
            my $DetailsIframe = $Selenium->find_element( ".TextOption", 'css' );
            $Selenium->switch_to_frame($DetailsIframe);

            # Check Elements
            $Selenium->find_element( "fieldset[field='DynamicField_TestDatabase']", 'css' );

            $Selenium->switch_to_parent_frame();
            $Selenium->find_element( ".Close", 'css' )->click();
        }

        # Create Ticket for Screens which require one
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $TestCustomerUserLogin,
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        ok( $TicketID, "Ticket is created - $TicketID" );
        push @DeleteTicketIDs, $TicketID;

        # Create Test Article for Test Ticket
        my $SubjectRandom = "Subject" . $Helper->GetRandomID();
        my $TextRandom    = "Text" . $Helper->GetRandomID();

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Phone',
        );

        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'customer',
            IsVisibleForCustomer => 1,
            Subject              => $SubjectRandom,
            Body                 => $TextRandom,
            Charset              => 'charset=ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'AddNote',
            HistoryComment       => 'Some free text',
            UserID               => 1,
        );
        ok( $ArticleID, "Article #1 is created - $ArticleID" );

        $Selenium->VerifiedGet(
            "${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$TicketNumber"
        );
        $Selenium->find_element( "#ReplyButton", 'css' )->click();
        my $Element = $Selenium->find_element( "#DynamicField_TestDatabase", 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # Testing invalid search term first
        # Working with autocomplete here for triggering the AJAX request
        $Selenium->execute_script(
            "\$('#DynamicField_TestDatabase').autocomplete('search', '-1');"
        );

        # Wait for AJAX Call
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        is(
            $Selenium->execute_script("return \$('.ui-menu-item').length;"),
            0, "Dropdown dialog not visible yet"
        );

        # Testing with valid search term
        $Selenium->execute_script(
            "\$('#DynamicField_TestDatabase').autocomplete('search', '1');"
        );

        # Wait for AJAX Call
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        $Selenium->find_element( ".ui-menu-item", 'css' )->click();

        # Open Detailed Search Dialog
        $Selenium->find_element(
            "#DynamicFieldDBDetailedSearch_DynamicField_TestDatabase",
            'css'
        )->click();

        # Wait for AJAX Call
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Fetching iframe and switching to it
        my $DetailedSearchIframe = $Selenium->find_element( ".TextOption", 'css' );
        $Selenium->switch_to_frame($DetailedSearchIframe);
        $Selenium->InputFieldValueSet(
            Element => '#id',
            Value   => '2',
        );
        $Selenium->find_element( "#Search",                  'css' )->click();
        $Selenium->find_element( "tr[class='MasterAction']", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => "return \$.active == 0"
        );

        $Selenium->find_element( "#ResultElementText_1", 'css' );
        wait_until {
            $Selenium->find_element( "#ResultElementText_2", 'css' );
        }

        # Test removing a value
        $Selenium->find_element( "#ResultElementText_1 ~ #RemoveDynamicFieldDBEntry", 'css' )->click();
        is(
            $Selenium->execute_script("return \$('#ResultElementText_1').length;"),
            0, "Result Element not visible"
        );

        # TODO Find a way to hide / display the dynamic database field in CustomerTicketZoom

        # Testing process ticket
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketZoom;TicketNumber=$ProcessTicketNumber");

        $Selenium->find_element( "button[title='Dialog_1']", 'css' )->click();

        my $DialogID = substr( $Selenium->find_element( "input[name='ActivityDialogEntityID']", 'css' )->get_value(), length "ActivityDialog-" );

        $Element = $Selenium->find_element( "#DynamicField_TestDatabase_$DialogID", 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # Testing invalid search term first
        $Selenium->execute_script(
            "\$('#DynamicField_TestDatabase_" . $DialogID . "').autocomplete('search', '-1');"
        );

        # Wait for AJAX Call
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        is(
            $Selenium->execute_script("return \$('.ui-menu-item').length;"),
            0, "Dropdown not visible yet"
        );

        # Testing with valid search term
        $Selenium->execute_script(
            "\$('#DynamicField_TestDatabase_" . $DialogID . "').autocomplete('search', '1');"
        );

        # Wait for AJAX Call
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        $Selenium->find_element( ".ui-menu-item", 'css' )->click();

        # Open Detailed Search Dialog
        $Selenium->find_element(
            "#DynamicFieldDBDetailedSearch_DynamicField_TestDatabase_$DialogID",
            'css'
        )->click();

        # Wait for AJAX Call
        $Selenium->WaitFor( JavaScript => "return \$.active == 0" );

        # Fetching iframe and switching to it
        $DetailedSearchIframe = $Selenium->find_element( ".TextOption", 'css' );
        $Selenium->switch_to_frame($DetailedSearchIframe);
        $Selenium->InputFieldValueSet(
            Element => '#id',
            Value   => '2',
        );

        $Selenium->find_element( "#Search", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return \$.active == 0",
        );
        $Selenium->find_element( "tr[class='MasterAction'] > td", 'css' )->click();

        $Selenium->find_element( "#ResultElementText_1", 'css' );
        wait_until {
            $Selenium->find_element( "#ResultElementText_2", 'css' );
        }

        # Test removing a value
        $Selenium->find_element( "#ResultElementText_1 ~ #RemoveDynamicFieldDBEntry", 'css' )->click();

        is(
            $Selenium->execute_script("return \$('#ResultElementText_1').length;"),
            0, "Result Element not visible"
        );

        # Testing Details Function
        $Selenium->find_element( "#ResultElementText_2 ~ .DynamicFieldDBDetails_DynamicField_TestDatabase_$DialogID", 'css' )->click();
        my $DetailsIframe = $Selenium->find_element( ".TextOption", 'css' );
        $Selenium->switch_to_frame($DetailsIframe);

        # Check Elements
        $Selenium->find_element( "fieldset[field='DynamicField_TestDatabase']", 'css' );

        $Selenium->switch_to_parent_frame();
        $Selenium->find_element( ".Close", 'css' )->click();

        # Delete test tickets
        for my $TicketID (@DeleteTicketIDs) {
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
            ok( $Success, "TicketID $TicketID is deleted" );
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
                $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                ok( $Success, "ActivityDialog $ActivityDialog->{Name} is deleted" );
            }

            # Delete test activity.
            $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "Activity $Activity->{Name} is deleted" );
        }

        # Clean up transition actions
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
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
            $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "Transition $Transition->{Name} is deleted" );
        }

        # Delete test Process.
        $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "Process $Process->{Name} is deleted",
        );

        # Dynchronize Process after deleting test Process.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize Process after deleting test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # Delete test ACL
        for my $ACLID (@DeleteACLIDs) {
            $Success = $ACLObject->ACLDelete(
                ID     => $ACLID,
                UserID => 1,
            );
            ok( $Success, "ACLID $ACLID is deleted" );
        }

        # Navigate to AdminACL to synchronize after test ACL cleanup.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # Delete created test DynamicField.
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        ok( $Success, "DynamicFieldID $DynamicFieldID is deleted" );
    }
);

$Self->DoneTesting();
