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
use Kernel::System::UnitTest::RegisterDriver;    # set up $Self (unused) and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # disable 'Customer Information' and 'Linked Objects' widgets in AgentTicketZoom screen
        for my $WidgetDisable (qw(0200-CustomerInformation 0300-LinkTable)) {
            $Helper->ConfigSettingChange(
                Valid => 0,
                Key   => "Ticket::Frontend::AgentTicketZoom###Widgets###$WidgetDisable",
                Value => '',
            );
        }

        # do not check RichText, service and type
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
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AdminProcessManagement screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # import test selenium process scenario
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/ProcessManagement/TestProcess.yml";
        $Selenium->find_element( "#FileUpload",                      'css' )->send_keys($Location);
        $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
        $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")->VerifiedClick();

        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # get process object
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');

        # get process list
        my $List = $ProcessObject->ProcessList(
            UseEntities => 1,
            UserID      => $TestUserID,
        );

        # get process entity
        my %ListReverse = reverse %{$List};
        my $ProcessName = 'TestProcess';

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );

        is(
            $Process->{Name},
            'TestProcess',
            "Test process is created"
        );

        # navigate to AgentTicketProcess screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        # select test process
        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $ListReverse{$ProcessName},
        );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( ElementExists => [ '#Subject', 'css' ] );

        # input process ticket subject and body
        my $SubjectRand = 'ProcessSubject-' . $Helper->GetRandomID();
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => 2,
        );
        $Selenium->find_element( "#Subject",  'css' )->send_keys($SubjectRand);
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Test Process Body. ᾴ - U+01FB4 - GREEK SMALL LETTER ALPHA WITH OXIA AND YPOGEGRAMMENI');

        # Check if default value for title is shown.
        # See bug#13937 https://bugs.otrs.org/show_bug.cgi?id=13937.
        my $TitleValue = 'Test Process Title Default';

        is(
            $Selenium->execute_script("return \$('#Title').val();"),
            $TitleValue,
            "Title field Default value is: $TitleValue",
        );

        # submit process
        $Selenium->find_element("//button[\@value='Submit'][\@type='submit']")->VerifiedClick();

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get test process ticket ID
        my @TicketIDs = $TicketObject->TicketSearch(
            Result  => 'ARRAY',
            SortBy  => 'Age',
            OrderBy => 'Down',
            Limit   => 1,
            UserID  => 1,
        );

        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketIDs[0],
            UserID   => 1,
        );

        is(
            $Ticket{CreateBy},
            $TestUserID,
            "Test ticket process is created"
        ) || die;

        # navigate to AgentTicketZoom screen of created test process
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # Check ticket title.
        is(
            $Selenium->execute_script("return \$('.Headline.NoMargin h1').text().trim().split(\" — \").pop();"),
            $TitleValue,
            "Ticket title is: $TitleValue",
        );

        # verify there is 'Process Information' widget
        my $ParentElement = $Selenium->find_element( ".SidebarColumn", 'css' );
        is(
            $Selenium->find_child_element( $ParentElement, '.Header>h2', 'css' )->get_text(),
            'Process Information',
            'Process Information widget is enabled',
        );

        # verify there are process informations in 'Process Information' widget
        $Selenium->find_element_by_xpath_ok(
            q{//p[contains(@title, 'TestProcess')]},
            'Process name found in Process Information widget'
        );
        $Selenium->find_element_by_xpath_ok(
            q{//p[contains(@title, 'Shipping')]},
            'Process activity found in Ticket Information widget'
        );

        # click on 'Priority' and switch screen
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketPriority;TicketID=$TicketIDs[0]' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#NewPriorityID").length' );

        # select '5 very high' priority to trigger next stage in process
        $Selenium->InputFieldValueSet(
            Element => '#NewPriorityID',
            Value   => '5',
        );

        $Selenium->find_element( "#Subject",  'css' )->send_keys('TestSubject');
        $Selenium->find_element( "#RichText", 'css' )->send_keys('TestBody');
        $Selenium->find_element("//button[\@type='submit']")->click();

        # switch back screen
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # refresh screen
        $Selenium->VerifiedRefresh();

        # verify there is new activity in 'Process Information' widget
        $Selenium->find_element_by_xpath_ok(
            q{//p[contains(@title, 'Ordering complete')]},
            "Process activity found in Process Information widget"
        );

        # cleanup test data
        # delete test process ticket
        my $TicketDeleteSuccess = $TicketObject->TicketDelete(
            TicketID => $TicketIDs[0],
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$TicketDeleteSuccess ) {
            sleep 3;
            $TicketDeleteSuccess = $TicketObject->TicketDelete(
                TicketID => $TicketIDs[0],
                UserID   => $TestUserID,
            );
        }
        ok( $TicketDeleteSuccess, "Process ticket ID $TicketIDs[0] is deleted" );

        # get needed objects
        my $ActivityObject       = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

        # clean up activities
        for my $Item ( @{ $Process->{Activities} } ) {
            my $Activity = $ActivityObject->ActivityGet(
                EntityID            => $Item,
                UserID              => $TestUserID,
                ActivityDialogNames => 0,
            );

            # clean up activity dialogs
            for my $ActivityDialogItem ( @{ $Activity->{ActivityDialogs} } ) {
                my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
                    EntityID => $ActivityDialogItem,
                    UserID   => $TestUserID,
                );

                # delete test activity dialog
                my $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                ok( $Success, "ActivityDialog $ActivityDialog->{Name} is deleted", );
            }

            # delete test activity
            my $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "Activity $Activity->{Name} is deleted" );
        }

        # get transition actions object
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');

        # clean up transition actions
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # delete test transition action
            my $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "TransitionAction $TransitionAction->{Name} is deleted" );
        }

        # get transition object
        my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');

        # clean up transition
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # delete test transition
            my $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );
            ok( $Success, "Transition $Transition->{Name} is deleted" );
        }

        # delete test process
        my $ProcessDeleteSuccess = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );
        ok( $ProcessDeleteSuccess, "Process $Process->{Name} is deleted" );

        # navigate to AdminProcessManagement screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # synchronize process after deleting test process
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # make sure the cache is correct
        for my $Cache (
            qw (Ticket TicketSearch ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Transition ProcessManagement_TransitionAction )
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

done_testing();
