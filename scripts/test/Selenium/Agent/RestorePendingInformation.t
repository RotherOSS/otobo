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

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Do not check email addresses.
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

        # Do not check service and type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0,
        );

        # Disable RequiredLock for AgentTicketCompose.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketCompose###RequiredLock',
            Value => 0
        );

        # Use test email backend.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::DoNotSendEmail',
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Add test customer user.
        my $TestCustomer       = 'Customer' . $Helper->GetRandomID();
        my $TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserPassword   => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => $TestUserID,
        );
        $Self->True(
            $TestCustomerUserID,
            "CustomerUserAdd - ID $TestCustomerUserID"
        );

        # Set customer user language to 'en' (because of diffrent browser default languages).
        $Kernel::OM->Get('Kernel::System::CustomerUser')->SetPreferences(
            UserID => $TestCustomerUserID,
            Key    => 'UserLanguage',
            Value  => 'en',
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketPhone screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # Create test phone ticket.
        my $AutoCompleteString = "\"$TestCustomer $TestCustomer\" <$TestCustomer\@localhost.com> ($TestCustomer)";
        my $TicketSubject      = "Selenium Ticket";
        my $TicketBody         = "Selenium body test";
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );

        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length' );

        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length' );

        $Selenium->find_element( "#Subject",  'css' )->send_keys($TicketSubject);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($TicketBody);

        $Selenium->execute_script("\$('#NextStateID').val('7').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("span.AJAXLoader:visible").length' );

        # Set new pending date.
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $DateTimeObject->Add(
            Years => 1,
            Days  => 1,
        );

        my $Date  = $DateTimeObject->Get();
        my $Year  = $Date->{Year};
        my $Month = $Date->{Month};
        my $Day   = $Date->{Day};

        $Selenium->execute_script("\$('#Hour').val('12').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#Minute').val('30').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#Year').val('$Year').trigger('redraw.InputField').trigger('change');");

        # Submit form.
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Get created test ticket ID and number.
        my %TicketIDs = $TicketObject->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomer,
        );
        my $TicketNumber = (%TicketIDs)[1];
        my $TicketID     = (%TicketIDs)[0];

        $Self->True(
            $TicketID,
            "TicketID $TicketID - Ticket was created and found",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Ticket with ticket ID $TicketID is created",
        );

        # Go to ticket zoom page of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if test ticket values are genuine.
        $Self->True(
            index( $Selenium->get_page_source(), 'Pending till:' ) > -1,
            "'Pending till:' found on page",
        );

        if ( $Month < 10 ) {
            $Month = '0' . $Month;
        }
        if ( $Day < 10 ) {
            $Day = '0' . $Day;
        }

        $Self->True(
            index( $Selenium->get_page_source(), "$Month/$Day/$Year 12:30" ) > -1,
            "'$Month/$Day/$Year 12:30'  found on page",
        );

        # Escape leading 0 for select box value.
        $Day   =~ s/^0//;
        $Month =~ s/^0//;

        # Test data for the screens where there is possible set pending data.
        my %PendingData = (
            NewTicket => {
                NewStateID => 7,
                Day        => $Day,
                Month      => $Month,
                Year       => $Year,
                Hour       => 12,
                Minute     => 30,
            },
            AddNote => {
                NewStateID => 6,
                Day        => $Day,
                Month      => $Month,
                Year       => 1,
                Hour       => 12,
                Minute     => 30,
            },
            PhoneCallAgent => {
                Action        => "AgentTicketPhoneOutbound;TicketID=$TicketID",
                NameOfStateID => 'NextStateID',
                NewStateID    => 8,
                Day           => $Day,
                Month         => $Month,
                Year          => 1,
                Hour          => 12,
                Minute        => 30,
            },
            PhoneCallCustomer => {
                Action        => "AgentTicketPhoneInbound;TicketID=$TicketID;ArticleID=",
                NameOfStateID => 'NextStateID',
                NewStateID    => 7,
                Day           => $Day,
                Month         => $Month,
                Year          => 0,
                Hour          => 12,
                Minute        => 30,
            },
            SendAnswer => {
                Action        => "AgentTicketCompose;TicketID=$TicketID;ResponseID=1;ArticleID=",
                NameOfStateID => 'StateID',
                NewStateID    => 6,
                Day           => $Day,
                Month         => $Month,
                Year          => 1,
                Hour          => 12,
                Minute        => 30,
            },
            Forward => {
                Action        => "AgentTicketForward;TicketID=$TicketID;ArticleID=",
                NameOfStateID => 'ComposeStateID',
                NewStateID    => 6,
                Day           => $Day,
                Month         => $Month,
                Year          => 1,
                Hour          => 12,
                Minute        => 30,
            },
        );

        # Go to AgentTicketPending.
        $Selenium->find_element( 'Pending', 'link_text' )->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject").length' );

        # Check prefill data.
        for my $Key ( sort keys %{ $PendingData{NewTicket} } ) {
            $Self->Is(
                $Selenium->find_element( "#$Key", 'css' )->get_value(),
                $PendingData{NewTicket}->{$Key},
                "$Key is filled correctly",
            );
        }

        # Change ticket to pending state.
        $Selenium->execute_script("\$('#NewStateID').val('6').trigger('redraw.InputField').trigger('change');");

        # Set new pending date.
        $Year++;
        $Selenium->execute_script("\$('#Year').val('$Year').trigger('redraw.InputField').trigger('change');");

        $Selenium->find_element( "#Subject",        'css' )->clear();
        $Selenium->find_element( "#Subject",        'css' )->send_keys('TestSubject');
        $Selenium->find_element( "#RichText",       'css' )->clear();
        $Selenium->find_element( "#RichText",       'css' )->send_keys('TestRichText');
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # Login in customer interface.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomer,
            Password => $TestCustomer,
        );

        # Go customer ticket zoom screen.
        $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]")
            ->VerifiedClick();

        # Reply on ticket.
        $Selenium->find_element( "#ReplyButton", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#RichText").length' );
        $Selenium->find_element( "#RichText", 'css' )->send_keys('Thanks for the ticket.');
        $Selenium->find_element("//button[contains(\@value, \'Submit' )]");

        # Go back in agent interface.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        TEST:
        for my $Type ( sort keys %PendingData ) {

            next TEST if $Type eq 'NewTicket';

            if ( $Type ne 'AddNote' ) {

                # Go to another type of the screen to set new pending data.
                my $Action = $PendingData{$Type}->{Action};

                if ( $Type =~ /Forward|SendAnswer/ ) {
                    my @Articles = $ArticleObject->ArticleList(
                        TicketID             => $TicketID,
                        IsVisibleForCustomer => 1,
                        OnlyLast             => 1,
                    );

                    my %Article;

                    if (@Articles) {
                        %Article = %{ $Articles[0] };
                    }

                    $Action .= $Article{ArticleID};

                    # Go to appropriate screen.
                    $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Action");

                    if ( $Type eq 'Forward' ) {
                        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys($TestCustomer);
                        $Selenium->WaitFor(
                            JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length'
                        );
                        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomer)').click()");
                        $Selenium->WaitFor(
                            JavaScript =>
                                'return typeof($) === "function" && $("#TicketCustomerContentToCustomer").length'
                        );
                    }

                }
                else {

                    # Go to appropriate screen.
                    $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=$Action");
                }

                # Change ticket to pending state.
                $Selenium->execute_script(
                    "\$('#$PendingData{$Type}->{NameOfStateID}').val('$PendingData{$Type}->{NewStateID}').trigger('redraw.InputField').trigger('change');"
                );

                # Set new pending date.
                $PendingData{$Type}->{Year} ? $Year++ : $Year--;

                $Selenium->execute_script("\$('#Hour').val('12').trigger('redraw.InputField').trigger('change');");
                $Selenium->execute_script("\$('#Minute').val('30').trigger('redraw.InputField').trigger('change');");
                $Selenium->execute_script("\$('#Year').val('$Year').trigger('redraw.InputField').trigger('change');");

                $Selenium->find_element( "#Subject",        'css' )->clear();
                $Selenium->find_element( "#Subject",        'css' )->send_keys('TestSubject');
                $Selenium->find_element( "#RichText",       'css' )->clear();
                $Selenium->find_element( "#RichText",       'css' )->send_keys('Some text');
                $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

                # Go to ticket zoom page.
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

                # Check if test ticket values are genuine.
                $Self->True(
                    index( $Selenium->get_page_source(), 'Pending till:' ) > -1,
                    "'Pending till:' found on page",
                );

                my $CheckPendingTime = sprintf "%02d/%02d/%02d 12:30", $Month, $Day, $Year;

                $Self->True(
                    index( $Selenium->get_page_source(), "$CheckPendingTime" ) > -1,
                    "'$CheckPendingTime' found on page",
                );

            }
            else {

                # Go to ticket zoom page.
                $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
            }

            # Go to AgentTicketPending.
            $Selenium->find_element( 'Pending', 'link_text' )->click();

            $Selenium->WaitFor( WindowCount => 2 );
            $Handles = $Selenium->get_window_handles();
            $Selenium->switch_to_window( $Handles->[1] );

            # Wait until page has loaded, if necessary.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
            );

            # Check prefill data.
            PENDING:
            for my $Key ( sort keys %{ $PendingData{$Type} } )
            {

                if ( $Key eq 'Year' ) {
                    $PendingData{$Type}->{Year} = $Year;
                }

                next PENDING if $Key =~ /Action|NameOfStateID/;

                $Self->Is(
                    $Selenium->find_element( "#$Key", 'css' )->get_value(),
                    $PendingData{$Type}->{$Key},
                    "$Key is filled correctly",
                );
            }

            $Selenium->close();
            $Selenium->WaitFor( WindowCount => 1 );
            $Selenium->switch_to_window( $Handles->[0] );
        }

        # Delete created test ticket.
        my $Success = $TicketObject->TicketDelete(
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
            "Ticket with ticket ID $TicketID is deleted",
        );

        # Delete created test customer user.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(Ticket CustomerUser))
        {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

$Self->DoneTesting();
