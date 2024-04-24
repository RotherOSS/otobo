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
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

# Create local function for wait on AJAX update.
sub WaitForAJAX {
    return
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length'
        );
}

$Selenium->RunTest(
    sub {
        my $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');
        my $QueueObject     = $Kernel::OM->Get('Kernel::System::Queue');
        my $ServiceObject   = $Kernel::OM->Get('Kernel::System::Service');
        my $SLAObject       = $Kernel::OM->Get('Kernel::System::SLA');
        my $StateObject     = $Kernel::OM->Get('Kernel::System::State');
        my $DBObject        = $Kernel::OM->Get('Kernel::System::DB');
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $RandomID = $Helper->GetRandomID();
        my $Success;

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Enable ticket responsible feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1,
        );

        # Enable ticket service feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # Create test customer user.
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate()
            || die "Did not get test customer user";

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Title' . $RandomID,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Create test queue.
        my $QueueName = 'Queue' . $RandomID;
        my $QueueID   = $QueueObject->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "QueueID $QueueID is created",
        );

        # Create test service.
        my $ServiceName = 'Service' . $RandomID;
        my $ServiceID   = $ServiceObject->ServiceAdd(
            Name    => $ServiceName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $ServiceID,
            "ServiceID $ServiceID is created",
        );

        # Add member customer user to the test service.
        $ServiceObject->CustomerUserServiceMemberAdd(
            CustomerUserLogin => $TestCustomerUserLogin,
            ServiceID         => $ServiceID,
            Active            => 1,
            UserID            => 1,
        );

        # Create test SLA.
        my $SLAName = 'SLA' . $RandomID;
        my $SLAID   = $SLAObject->SLAAdd(
            ServiceIDs => [$ServiceID],
            Name       => $SLAName,
            ValidID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $TicketID,
            "SLAID $SLAID is created",
        );

        # Get 'open' type ID.
        my %ListType = $StateObject->StateTypeList(
            UserID => 1,
        );
        my %ReverseListType = reverse %ListType;
        my $OpenID          = $ReverseListType{"open"};

        # Create test state (type 'open').
        my $StateName = 'State' . $RandomID;
        my $StateID   = $StateObject->StateAdd(
            Name    => $StateName,
            ValidID => 1,
            TypeID  => $OpenID,
            UserID  => 1,
        );
        $Self->True(
            $StateID,
            "StateID $StateID is created",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Define field IDs and frontend modules.
        my %FreeTextFields = (
            NoMandatory => {
                ServiceID        => 'Service',
                NewQueueID       => 'Queue',
                NewOwnerID       => 'Owner',
                NewResponsibleID => 'Responsible',
                NewStateID       => 'State',
            },
            Mandatory => {
                ServiceID        => 'ServiceMandatory',
                SLAID            => 'SLAMandatory',
                NewQueueID       => 'QueueMandatory',
                NewOwnerID       => 'OwnerMandatory',
                NewResponsibleID => 'ResponsibleMandatory',
                NewStateID       => 'StateMandatory',
            }
        );

        my @MandatoryTests = (
            {
                Name          => 'Disable NoMandatory and Mandatory fields, check NoMandatory field IDs',
                CheckFields   => 'NoMandatory',
                NoMandatory   => 0,
                Mandatory     => 0,
                ExpectedExist => 0,
            },
            {
                Name          => 'Enable NoMandatory and disable Mandatory fields, check NoMandatory field IDs',
                CheckFields   => 'NoMandatory',
                NoMandatory   => 1,
                Mandatory     => 0,
                ExpectedExist => 1,
            },
            {
                Name          => 'Disable NoMandatory and enable Mandatory fields, check Mandatory field IDs',
                CheckFields   => 'Mandatory',
                NoMandatory   => 0,
                Mandatory     => 1,
                ExpectedExist => 0,
            },
            {
                Name          => 'Enable NoMandatory and Mandatory fields, check Mandatory field IDs',
                CheckFields   => 'Mandatory',
                NoMandatory   => 1,
                Mandatory     => 1,
                ExpectedExist => 1,
            }
        );

        for my $Test (@MandatoryTests) {

            subtest "Test case for 'mandatory': $Test->{Name}" => sub {

                for my $NoMandatoryField ( values $FreeTextFields{NoMandatory}->%* ) {

                    $Helper->ConfigSettingChange(
                        Valid => 1,
                        Key   => "Ticket::Frontend::AgentTicketFreeText###$NoMandatoryField",
                        Value => $Test->{NoMandatory},
                    );
                }

                for my $MandatoryField ( values %{ $FreeTextFields{Mandatory} } ) {

                    $Helper->ConfigSettingChange(
                        Valid => 1,
                        Key   => "Ticket::Frontend::AgentTicketFreeText###$MandatoryField",
                        Value => $Test->{Mandatory},
                    );
                }

                # Navigate to zoom view of created test ticket.
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

                # Wait until page has loaded.
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

                # Force sub menus to be visible in order to be able to click one of the links.
                $Selenium->execute_script("\$('#nav-Miscellaneous ul').css('height', 'auto');");
                $Selenium->execute_script("\$('#nav-Miscellaneous ul').css('opacity', '1');");
                $Selenium->WaitFor(
                    JavaScript =>
                        "return \$('#nav-Miscellaneous ul').css('height') !== '0px' && \$('#nav-Miscellaneous ul').css('opacity') == '1';"
                );

                # Click on 'Free Fields' and switch window.
                $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketFreeText;TicketID=$TicketID' )]")->click();

                $Selenium->WaitFor( WindowCount => 2 );
                my $Handles = $Selenium->get_window_handles();
                $Selenium->switch_to_window( $Handles->[1] );

                # Wait until page has loaded, if necessary.
                $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length;' );

                # Get NoMandatory/Mandatory fields for exist checking.
                my $CheckFields = $Test->{CheckFields};

                for my $FieldID ( sort keys %{ $FreeTextFields{$CheckFields} } ) {

                    if ( $Test->{ExpectedExist} == 0 ) {
                        $Self->False(
                            $Selenium->execute_script(
                                "return \$('#$FieldID').length;"
                            ),
                            "FieldID $FieldID doesn't exist",
                        );
                    }
                    else {
                        $Self->True(
                            $Selenium->execute_script("return \$('#$FieldID').length;"),
                            "FieldID $FieldID exists",
                        );
                        if ( $CheckFields eq 'Mandatory' ) {
                            $Self->Is(
                                $Selenium->execute_script("return \$('label[for=$FieldID].Mandatory').length;"),
                                1,
                                "FieldID $FieldID is mandatory",
                            );
                        }
                    }
                }

                # Close the window and switch back to the first screen.
                $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
                $Selenium->WaitFor( WindowCount => 1 );
                $Selenium->switch_to_window( $Handles->[0] );
            };
        }

        # Define field values.
        my %SetFreeTextFields = (
            ServiceID        => $ServiceID,
            SLAID            => $SLAID,
            NewQueueID       => $QueueID,
            NewOwnerID       => $TestUserID,
            NewResponsibleID => $TestUserID,
            NewStateID       => $StateID,
        );

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Wait until page has loaded.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function";' );

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script("\$('#nav-Miscellaneous ul').css('height', 'auto');");
        $Selenium->execute_script("\$('#nav-Miscellaneous ul').css('opacity', '1');");
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#nav-Miscellaneous ul').css('height') !== '0px' && \$('#nav-Miscellaneous ul').css('opacity') == '1';"
        );

        # Click on 'Free Fields' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketFreeText;TicketID=$TicketID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length;' );

        # Fill all free text fields.
        FREETEXTFIELDS:
        for my $FieldID ( sort keys %SetFreeTextFields ) {

            next FREETEXTFIELDS if $FieldID eq 'SLAID';

            $Selenium->InputFieldValueSet(
                Element => "#$FieldID",
                Value   => $SetFreeTextFields{$FieldID},
            );

            # Wait for AJAX to finish.
            WaitForAJAX();

            if ( $FieldID eq 'ServiceID' ) {

                $Selenium->InputFieldValueSet(
                    Element => "#SLAID",
                    Value   => $SetFreeTextFields{SLAID},
                );

                # Wait for AJAX to finish.
                WaitForAJAX();
            }
        }

        # Test cases - all fields are set except exactly one, and in the last case all fields are set.
        # Some of these tests currently run into a time out and are marked as todo.
        # See issue #748.
        my @ClearTests = (
            {
                Name      => 'Clear Service field',
                ServiceID => '',
            },
            {
                Name      => 'Clear SLA field and set back Service field',
                ServiceID => $ServiceID,
                SLAID     => '',
            },
            {
                Name       => 'Clear Queue field and set back SLA field',
                SLAID      => $SLAID,
                NewQueueID => '',
            },

            {
                Name       => 'Clear Owner field and set back Queue field',
                Time       => 40,
                NewQueueID => $QueueID,
                NewOwnerID => '',
                ToDo       => 1
            },
            {
                Name             => 'Clear Responsible field and set back Owner field',
                NewOwnerID       => $TestUserID,
                NewResponsibleID => '',
            },
            {
                Name             => 'Clear State field and set back Responsible field',
                NewResponsibleID => $TestUserID,
                NewQueueID       => $QueueID,
                NewStateID       => '',
            },
            {
                Name       => 'Set back State field - all fields are set',
                NewStateID => $StateID,
                ToDo       => 1
            },
            {
                Name       => 'Set back Queue field - all fields are set',
                NewQueueID => $QueueID,
            }
        );

        # Run test - in each iteration exactly one field is empty, last case is correct.
        for my $Test (@ClearTests) {

            subtest "Test case for 'clear': $Test->{Name}" => sub {

                my $ToDo = $Test->{ToDo} ? todo('Timeouts occur. See https://github.com/RotherOSS/otobo/issues/748') : '';

                try_ok {
                    my $ExpectedErrorFieldID;

                    TESTFIELD:
                    for my $FieldID ( sort keys $Test->%* ) {

                        next TESTFIELD if $FieldID eq 'Name';
                        next TESTFIELD if $FieldID eq 'Time';
                        next TESTFIELD if $FieldID eq 'ToDo';

                        if ( $Test->{$FieldID} eq '' ) {
                            $ExpectedErrorFieldID = $FieldID;
                        }

                        $Selenium->InputFieldValueSet(
                            Element => "#$FieldID",
                            Value   => $Test->{$FieldID},
                            Time    => $Test->{Time},
                        );

                        # Wait for AJAX to finish.
                        WaitForAJAX();
                    }

                    # Wait until opened field (due to error) has closed.
                    $Selenium->WaitFor( JavaScript => 'return $("div.jstree-wholerow:visible").length == 0;' );

                    # Submit.
                    $Selenium->find_element( "#submitRichText", 'css' )->click();

                    # Check if class Error exists in expected field ID.
                    if ($ExpectedErrorFieldID) {
                        ok(
                            $Selenium->execute_script("return \$('#$ExpectedErrorFieldID.Error').length;"),
                            "FieldID $ExpectedErrorFieldID is empty",
                        );
                    }
                    else {
                        pass("All mandatory fields are filled - successful free text fields update");

                        # Switch back to the main window.
                        $Selenium->WaitFor( WindowCount => 1 );
                        $Selenium->switch_to_window( $Handles->[0] );

                        $Selenium->WaitFor(
                            JavaScript => "return typeof(\$) === 'function' && \$.active == 0;"
                        );
                    }
                }
            };
        }

        # Define messages in ticket history screen.
        my %FreeFieldMessages = (
            ServiceUpdate     => "Changed service to \"$ServiceName\" ($ServiceID).",
            SLAUpdate         => "Changed SLA to \"$SLAName\" ($SLAID).",
            OwnerUpdate       => "Changed owner to \"$TestUserLogin\" ($TestUserID).",
            ResponsibleUpdate => "Changed responsible to \"$TestUserLogin\" ($TestUserID).",
            QueueUpdate       => "Changed queue to \"$QueueName\" ($QueueID) from \"Raw\" (2).",
            StateUpdate       => "Changed state from \"new\" to \"$StateName\"."
        );

        # Navigate to AgentTicketHistory of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        for my $Action ( sort keys %FreeFieldMessages ) {

            $Self->True(
                index( $Selenium->get_page_source(), $FreeFieldMessages{$Action} ) > -1,
                "Action $Action is completed",
            );
        }

        # Cleanup
        # Delete created test ticket.
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
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        # Delete customer user referenced for service.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM service_customer_user WHERE customer_user_login = ?",
            Bind => [ \$TestCustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "Deleted service relations for $TestCustomerUserLogin",
        );

        # Delete sla referenced for service.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service_sla WHERE service_id = $ServiceID OR sla_id = $SLAID",
        );
        $Self->True(
            $Success,
            "Relation SLAID $SLAID referenced to service ID $ServiceID is deleted",
        );

        # Delete created test service.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "ServiceID $ServiceID is deleted",
        );

        # Delete created test SLA.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM sla WHERE id = $SLAID",
        );
        $Self->True(
            $Success,
            "SLAID $SLAID is deleted",
        );

        # Delete created test state.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM ticket_state WHERE id = $StateID",
        );
        $Self->True(
            $Success,
            "StateID $StateID is deleted",
        );

        # Delete created test queue.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "QueueID $QueueID is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(Ticket Service SLA State Queue)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

done_testing();
