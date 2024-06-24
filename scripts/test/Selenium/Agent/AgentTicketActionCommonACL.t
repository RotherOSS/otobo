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
use Kernel::System::UnitTest::Selenium;

# Note: this UT covers bug #11874 - Restrict service based on state when posting a note

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ACLObject    = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $RandomID = $Helper->GetRandomID();

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###Service',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###Queue',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###Priority',
            Value => 1,
        );

        # Create test ticket dynamic field.
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldID     = $DynamicFieldObject->DynamicFieldAdd(
            Name       => 'Field' . $RandomID,
            Label      => 'Field' . $RandomID,
            FieldOrder => 99998,
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    0 => 'No',
                    1 => 'Yes',
                },
                TranslatableValues => 1,
            },
            Reorder => 0,
            ValidID => 1,
            UserID  => 1,
        );
        ok( $DynamicFieldID, "DynamicFieldAdd - Added dynamic field ($DynamicFieldID)" );

        my $DynamicFieldID2 = $DynamicFieldObject->DynamicFieldAdd(
            Name       => 'Field2' . $RandomID,
            Label      => 'Field2' . $RandomID,
            FieldOrder => 99999,
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                PossibleNone   => 1,
                PossibleValues => {
                    a => 'a',
                    b => 'b',
                    c => 'c',
                    d => 'd',
                },
                TranslatableValues => 1,
            },
            Reorder => 0,
            ValidID => 1,
            UserID  => 1,
        );
        ok( $DynamicFieldID2, "DynamicFieldAdd - Added dynamic field ($DynamicFieldID)" );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###DynamicField',
            Value => {
                'Field' . $RandomID  => 1,
                'Field2' . $RandomID => 1,
            },
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketClose###DynamicField',
            Value => {
                'Field' . $RandomID => 1,
            },
        );

        # Import test ACL.
        # For new tickets only the first test service is allowed.
        # The names of the ACLs don't have to be unique, as OverwriteExistingEntities is set.
        $ACLObject->ACLImport(
            Content => <<"END_CONTENT",
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:08:58
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        Service:
        - UT Test Service 1 $RandomID
  ConfigMatch:
    Properties:
      Ticket:
        State:
        - new
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 02:55:35
  Description: ''
  ID: '1'
  Name: ThisIsAUnitTestACL-1
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:10:05
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        SLA:
        - UT Test SLA 1 $RandomID
  ConfigMatch:
    Properties:
      DynamicField:
        DynamicField_Field$RandomID:
        - '0'
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 03:10:05
  Description: ''
  ID: '2'
  Name: ThisIsAUnitTestACL-2
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2016-02-16 03:11:05
  Comment: ''
  ConfigChange:
    PossibleNot:
      Ticket:
        Queue:
        - 'Junk'
  ConfigMatch:
    Properties:
      Ticket:
        Priority:
        - '2 low'
  CreateBy: root\@localhost
  CreateTime: 2016-02-16 03:11:05
  Description: ''
  ID: '3'
  Name: ThisIsAUnitTestACL-3
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2017-07-07 09:46:38
  Comment: ''
  ConfigChange:
    PossibleNot:
      Ticket:
        State:
        - closed successful
  ConfigMatch:
    Properties:
      DynamicField:
        DynamicField_Field$RandomID:
        - '0'
  CreateBy: root\@localhost
  CreateTime: 2017-07-07 09:45:38
  Description: ''
  ID: '4'
  Name: ThisIsAUnitTestACL-4
  StopAfterMatch: 0
  ValidID: '1'
- ChangeBy: root\@localhost
  ChangeTime: 2017-07-10 09:00:00
  Comment: ''
  ConfigChange:
    Possible:
      Ticket:
        DynamicField_Field2$RandomID:
        - 'a'
        - 'b'
  ConfigMatch:
    Properties:
      DynamicField:
        DynamicField_Field$RandomID:
        - '0'
  CreateBy: root\@localhost
  CreateTime: 2017-07-10 09:00:00
  Description: ''
  ID: '5'
  Name: ThisIsAUnitTestACL-5
  StopAfterMatch: 0
  ValidID: '1'
END_CONTENT
            OverwriteExistingEntities => 1,
            UserID                    => 1,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # After login, we need to navigate to the ACL deployment to make the imported ACL work.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Selenium->body_text_lacks(
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
            'ACL deployment successful'
        );

        # Add a customer.
        my $CustomerUserLogin = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            UserFirstname  => 'Huber',
            UserLastname   => 'Manfred',
            UserCustomerID => 'A124',
            UserLogin      => 'customeruser_' . $RandomID,
            UserPassword   => 'some-pass',
            UserEmail      => $RandomID . '@localhost.com',
            ValidID        => 1,
            UserID         => 1,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => $CustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        ok( $TicketID, "TicketCreate - ID $TicketID" );

        # Set test ticket dynamic field to zero-value, please see bug#12273 for more information.
        my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

        my $Success = $DynamicFieldValueObject->ValueSet(
            FieldID  => $DynamicFieldID,
            ObjectID => $TicketID,
            Value    => [
                {
                    ValueText => '0',
                },
            ],
            UserID => 1,
        );

        # Create some test services.
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        my @ServiceIDs;
        for my $Count ( 1 .. 3 ) {
            my $ServiceID = $ServiceObject->ServiceAdd(
                Name    => "UT Test Service $Count $RandomID",
                ValidID => 1,
                UserID  => 1,
                Comment => "test script: $0",
            );
            push @ServiceIDs, $ServiceID;

            $ServiceObject->CustomerUserServiceMemberAdd(
                CustomerUserLogin => $CustomerUserLogin,
                ServiceID         => $ServiceID,
                Active            => 1,
                UserID            => 1,
            );

            ok( $ServiceID, "Test service $Count ($ServiceID) created and assigned to customer user $CustomerUserLogin" );
        }

        # Create several test SLAs.
        my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

        my @SLAs;
        for my $Count ( 1 .. 3 ) {
            my $SLAID = $SLAObject->SLAAdd(
                ServiceIDs => \@ServiceIDs,
                Name       => "UT Test SLA $Count $RandomID",
                ValidID    => 1,
                UserID     => 1,
            );
            push @SLAs, $SLAID;
        }

        # Navigate to AgentTicketZoom screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Wait until page has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

        $Selenium->execute_script("\$('#nav-Communication-container').css('height', 'auto');");
        $Selenium->execute_script("\$('#nav-Communication-container').css('opacity', '1');");
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#nav-Communication-container').css('height') !== '0px' && \$('#nav-Communication-container').css('opacity') == '1';"
        );

        # Click on 'Note' and switch windo
        $Selenium->click_element_ok(qq{//a[contains(\@href, 'Action=AgentTicketNote;TicketID=$TicketID' )]});

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded
        # TODO: this sometimes fails when there are not Services available. Strange.
        try_ok {
            $Selenium->WaitFor(
                JavaScript => q{return typeof($) === "function" && $('#ServiceID option:not([value=""])').length}
            );
        };

        # Check for entries in the service selection.
        # Three test services have been added. But only "UT Test Service 1 $RandomID" is visible
        # because of the imported ACL setup.
        my $NumVisibleServices = $Selenium->execute_script(q{return $('#ServiceID option:not([value=""])').length;});
        is( $NumVisibleServices, 1, 'only one entry in the service selection' );

        # Set test service and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#ServiceID',
            Value   => $ServiceIDs[0],
        );

        # wait for the updated SLA selection
        try_ok {
            $Selenium->WaitFor(
                JavaScript => q{return !$(".AJAXLoader:visible").length && $("#SLAID option:not([value=''])").length;}
            );
        };

        # Check for restricted entries in the SLA selection, there should be only one.
        is(
            $Selenium->execute_script("return \$('#SLAID option:not([value=\"\"])').length;"),
            1,
            "There is only one entry in the SLA selection",
        );

        # Verify queue is updated on ACL trigger, see bug#12862 ( https://bugs.otrs.org/show_bug.cgi?id=12862 ).
        my %JunkQueue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
            Name => 'Junk',
        );
        ok(
            $Selenium->execute_script("return \$('#NewQueueID option[value=\"$JunkQueue{QueueID}\"]').length > 0;"),
            "Junk queue is available in selection before ACL trigger"
        );

        # Trigger ACL on priority change.
        $Selenium->InputFieldValueSet(
            Element => "#NewPriorityID",
            Value   => 2,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        ok(
            !$Selenium->execute_script("return \$('#NewQueueID option[value=\"$JunkQueue{QueueID}\"]').length > 0;"),
            "Junk queue is not available in selection after ACL trigger"
        );

        # Turn off priority and try again. Please see bug#13312 for more information.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketNote###Priority',
            Value => 0,
        );

        # Close the new note popup.
        $Selenium->find_element( '.CancelClosePopup', 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ServiceID").length;' );

        # Check for entries in the service selection, there should be only one.
        is(
            $Selenium->execute_script("return \$('#ServiceID option:not([value=\"\"])').length;"),
            1,
            'There is only one entry in the service selection'
        );

        # Set test service and trigger AJAX refresh.
        $Selenium->InputFieldValueSet(
            Element => '#ServiceID',
            Value   => $ServiceIDs[0],
        );
        try_ok {
            $Selenium->WaitFor(
                JavaScript =>
                    'return !$(".AJAXLoader:visible").length && $("#SLAID option:not([value=\'\'])").length == 1;'
            );
        };

        # Check for restricted entries in the SLA selection, there should be only one.
        is(
            $Selenium->execute_script("return \$('#SLAID option:not([value=\"\"])').length;"),
            1,
            'There is only one entry in the SLA selection'
        );

        # Close the new note popup.
        $Selenium->find_element( '.CancelClosePopup', 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Please see bug#12871 for more information.
        $Success = $DynamicFieldValueObject->ValueSet(
            FieldID  => $DynamicFieldID2,
            ObjectID => $TicketID,
            Value    => [
                {
                    ValueText => 'a',
                },
            ],
            UserID => 1,
        );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        is(
            $Selenium->execute_script(
                "return \$('#DynamicField_Field2$RandomID option:not([value=\"\"])').length;"
            ),
            2,
            "There are only two entries in the dynamic field 2 selection",
        );

        # De-select the dynamic field value for the first field.
        $Selenium->InputFieldValueSet(
            Element => "#DynamicField_Field$RandomID",
            Value   => '',
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length;' );

        is(
            $Selenium->execute_script("return \$('#DynamicField_Field2$RandomID option:not([value=\"\"])').length;"),
            4,
            "There are all four entries in the dynamic field 2 selection",
        );

        # Close the new note popup.
        $Selenium->find_element( '.CancelClosePopup', 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Click on 'Close' action and switch to it.
        $Selenium->click_element_ok("//a[contains(\@href, \'Action=AgentTicketClose;TicketID=$TicketID' )]");

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

        # At this point, state field should be missing 'closed successful' state because of ACL.
        #   Change the dynamic field property to '1' and wait until 'closed successful' is available again.
        #   Then, close the ticket and verify it was actually closed.
        #   Please see bug#12671 for more information.
        ok(
            $Selenium->execute_script('return $("#NewStateID option:contains(\'closed successful\')").length == 0;'),
            "State 'closed successful' not available in new state selection before DF update"
        );

        # Set dynamic field value to non-zero, and wait for AJAX to complete.
        $Selenium->InputFieldValueSet(
            Element => "#DynamicField_Field$RandomID",
            Value   => 1,
        );

        try_ok {
            $Selenium->WaitFor(
                JavaScript => 'return !$(".AJAXLoader:visible").length && $("#NewStateID option:contains(\'closed successful\')").length == 1;'
            );
        };

        ok(
            $Selenium->execute_script('return $("#NewStateID option:contains(\'closed successful\')").length == 1;'),
            "State 'closed successful' available in new state selection after DF update"
        );

        # Close the ticket.
        $Selenium->InputFieldValueSet(
            Element => "#NewStateID",
            Value   => 2,
        );
        $Selenium->find_element( '#Subject',        'css' )->send_keys('Close');
        $Selenium->find_element( '#RichText',       'css' )->send_keys('Closing...');
        $Selenium->find_element( '#submitRichText', 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Navigate to ticket history screen of test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Verify that the ticket was indeed closed successfully.
        my $CloseMsg = 'Changed state from "new" to "closed successful".';
        try_ok {
            $Selenium->content_contains( $CloseMsg, 'Ticket closed successfully' );
        };

        # Cleanup

        # Delete test ACLs rules.
        for my $Count ( 1 .. 5 ) {
            my $ACLData = $ACLObject->ACLGet(
                Name   => 'ThisIsAUnitTestACL-' . $Count,
                UserID => 1,
            );

            my $Success = $ACLObject->ACLDelete(
                ID     => $ACLData->{ID},
                UserID => 1,
            );
            ok( $Success, "ACL with ID $ACLData->{ID} is deleted" );
        }

        # Deploy again after we deleted the test acl.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL;Subaction=ACLDeploy");
        $Selenium->content_lacks(
            'ACL information from database is not in sync with the system configuration, please deploy all ACLs.',
            "ACL deployment successful."
        );

        # Delete created test tickets.
        $Success = $TicketObject->TicketDelete(
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
        ok( $Success, "Ticket with ticket ID $TicketID is deleted" );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

        # Delete test SLAs.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $SLAID (@SLAs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM service_sla WHERE sla_id = ?",
                Bind => [ \$SLAID ],
            );
            ok( $Success, "Deleted SLA with ID $SLAID" );
        }

        # Delete services and relations.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM service_customer_user WHERE customer_user_login = ?",
            Bind => [ \$CustomerUserLogin ],
        );
        ok( $Success, "Deleted service relations for $CustomerUserLogin" );
        for my $ServiceID (@ServiceIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM service WHERE ID = ?",
                Bind => [ \$ServiceID ],
            );
            ok( $Success, "Deleted service with ID $ServiceID" );
        }

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$CustomerUserLogin ],
        );
        ok( $Success, "Deleted Customer $CustomerUserLogin" );

        # Delete test dynamic field.
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        ok( $Success, "DynamicFieldDelete - Deleted test dynamic field $DynamicFieldID" );

        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID2,
            UserID => 1,
        );
        ok( $Success, "DynamicFieldDelete - Deleted test dynamic field $DynamicFieldID2" );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw( Service SLA CustomerUser DynamicField )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    },
);

done_testing();
