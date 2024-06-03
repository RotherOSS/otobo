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
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM
use Kernel::System::UnitTest::Selenium;

# get selenium object
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Enable change owner to everyone feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::ChangeOwnerToEveryone',
            Value => 1
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # Disable check of email addresses.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Disable MX record check.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0,
        );

        my $Config = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::AgentTicketOwner');
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketOwner',
            Value => {
                %$Config,
                Note          => 1,
                NoteMandatory => 1,
            },
        );

        # Create test users and login first.
        my @TestUser;
        for my $Count ( 1 .. 2 ) {
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            ) || die "Did not get test user $Count";

            push @TestUser, $TestUserLogin;
        }

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[0],
            Password => $TestUser[0],
        );

        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # Get test users ID.
        my @UserID = map { $UserObject->UserLookup( UserLogin => $_ ) } @TestUser;

        my $DateTimeSettings = $Kernel::OM->Create('Kernel::System::DateTime')->Get;
        my %Values           = (
            'OutOfOffice'           => 'on',
            'OutOfOfficeStartYear'  => $DateTimeSettings->{Year},
            'OutOfOfficeStartMonth' => $DateTimeSettings->{Month},
            'OutOfOfficeStartDay'   => $DateTimeSettings->{Day},
            'OutOfOfficeEndYear'    => $DateTimeSettings->{Year} + 1,
            'OutOfOfficeEndMonth'   => $DateTimeSettings->{Month},
            'OutOfOfficeEndDay'     => $DateTimeSettings->{Day},
        );

        for my $Key ( sort keys %Values ) {
            $UserObject->SetPreferences(
                UserID => $UserID[1],
                Key    => $Key,
                Value  => $Values{$Key},
            );
        }

        my %UserData = $UserObject->GetUserData(
            UserID => $UserID[1],
            Valid  => 0,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $UserID[1],
            UserID       => $UserID[1],
        );
        ok( $TicketID, "Ticket $TicketID is created" );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to owner screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketOwner;TicketID=$TicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Check page.
        for my $ID (
            qw(NewOwnerID Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled;
            $Element->is_displayed;
        }

        # Check out of office user message without filter.
        # Note that there is no leading '1: '
        is(
            $Selenium->execute_script("return \$('#NewOwnerID option[value=$UserID[1]]').text();"),
            $UserData{UserFullname},
            "Out of office message is found for the user - $TestUser[1]"
        );

        # The convoluted way of getting the focus seems to work.
        my $SearchElement = $Selenium->find_element_by_css( '#NewOwnerID_Search', 'css' );
        ok( $SearchElement, '#NewOwnerID_Search found' );
        $SearchElement->execute_script(q{arguments[0].focus();});
        $Selenium->find_element_by_css_ok( '#NewOwnerID_Search', 'element with id=NewOwnerID_Search still exists' );

        # Click on filter button in input fileld.
        $Selenium->execute_script("\$('.InputField_Filters').click();");

        # Enable 'Previous Owner' filter.
        # Only one previous owner should be available.
        $Selenium->execute_script(qq{ \$('.InputField_FiltersList').children('input')[0].click(); });

        # Check out of office user message with filter.
        # Note that the prefix '1: ' is added
        my $UserSelectionElement = $Selenium->find_element( qq{#NewOwnerID option[value="$UserID[1]"]}, 'css' );
        is(
            $UserSelectionElement->execute_script(q{ return $(arguments[0]).text(); }),
            "1: $UserData{UserFullname}",
            "Out of office message is found for the user $TestUser[1]"
        );

        # Change ticket user owner by clicking
        # TODO: this does not actually select the user 1 and the test script fails
        $UserSelectionElement->execute_script(q{ $(arguments[0]).click() });

        $Selenium->find_element( "#Subject",        'css' )->send_keys('Test');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('Test');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick;

        # Navigate to AgentTicketHistory of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # Confirm owner change action.
        my $OwnerMsg = "Added note (Owner)";
        ok(
            index( $Selenium->get_page_source(), $OwnerMsg ) > -1,
            "Ticket owner action completed",
        );

        # Login as second created user who is set Out Of Office and create Note article, see bug#13521.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUser[1],
            Password => $TestUser[1],
        );

        # Navigate to note screen of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketNote;TicketID=$TicketID");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#Subject").length && $("#RichText").length && $("#submitRichText").length;'
        );

        # Create Note article.
        $Selenium->find_element( "#Subject",        'css' )->send_keys('TestSubject');
        $Selenium->find_element( "#RichText",       'css' )->send_keys('TestBody');
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick;

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Row2 .Sender a').text() === '$TestUser[1] $TestUser[1]';"
        );

        # Verified there is no Out Of Office message in the 'Sender' column of created Note.
        is(
            $Selenium->execute_script("return \$('#Row2 .Sender a').text();"),
            "$TestUser[1] $TestUser[1]",
            "There is no Out Of Office message in the article 'Sender' column."
        );

        # Check <OTOBO_CUSTOMER_BODY> tag in NotificationOwnerUpdate notification body (see bug#14678).
        my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
        my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

        # Cleanup mail queue.
        $MailQueueObject->Delete();

        my $SendEmails = sub {
            my %Param = @_;
            my $Items = $MailQueueObject->List();
            my @ToReturn;
            for my $Item (@$Items) {
                $MailQueueObject->Send( %{$Item} );
                push @ToReturn, $Item->{Message};
            }

            # Clean mail queue.
            $MailQueueObject->Delete();

            return @ToReturn;
        };

        # Enable Test email backend.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        # Cleanup test email backend.
        my $Success = $TestEmailObject->CleanUp();
        ok( $Success, 'Initial cleanup' );

        # Disable AgentTicketOwner###NoteMandatory.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketOwner###NoteMandatory',
            Value => 0
        );

        my $RandomID = $Helper->GetRandomID();
        my $Subject  = "Subject-$RandomID";
        my $Body     = "Body-$RandomID";

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # Create customer article for test ticket.
        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
            Subject              => $Subject,
            Body                 => $Body,
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => $UserID[1],
        );
        ok( $ArticleID, "ArticleID $ArticleID is created for TicketID $TicketID" );

        # Add notification.
        my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
        my $NotificationID          = $NotificationEventObject->NotificationAdd(
            Name => "Notification-$RandomID",
            Data => {
                Events          => ['NotificationOwnerUpdate'],
                RecipientAgents => [ $UserID[0] ],
                Transports      => ['Email'],
            },
            Message => {
                en => {
                    Subject     => "Notification-Subject-$RandomID",
                    Body        => 'OTOBO_CUSTOMER_BODY tag: <OTOBO_CUSTOMER_BODY>',
                    ContentType => 'text/plain',
                },
            },
            ValidID => 1,
            UserID  => 1,
        );
        ok( $NotificationID, "NotificationID $NotificationID is created" );

        # Navigate to owner screen of created test ticket to change owner without note (article).
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketOwner;TicketID=$TicketID");

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".WidgetSimple").length && $("#NewOwnerID").length;'
        );

        # Change ticket owner.
        $Selenium->InputFieldValueSet(
            Element => '#NewOwnerID',
            Value   => $UserID[0],
        );

        # Submit.
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick;

        $SendEmails->();

        # Get test emails.
        my $Emails = $TestEmailObject->EmailsGet();

        # Check if OTOBO_CUSTOMER_BODY tag is replaced correctly in any email.
        my $Found = 0;
        my $Match = "OTOBO_CUSTOMER_BODY tag: $Body";
        EMAIL:
        for my $Email ( @{$Emails} ) {
            $Found = ( ${ $Email->{Body} } =~ m/$Match/ ? 1 : 0 );

            last EMAIL if $Found;
        }

        ok( $Found, 'OTOBO_CUSTOMER_BODY tag is replaced correctly' );

        # Cleanup test email backend and mail queue.
        $TestEmailObject->CleanUp();
        $MailQueueObject->Delete();

        $Success = $NotificationEventObject->NotificationDelete(
            ID     => $NotificationID,
            UserID => 1,
        );
        ok( $Success, "NotificationID $NotificationID is deleted" );

        # Delete created test tickets.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $UserID[0],
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $UserID[0],
            );
        }
        ok( $Success, "Ticket $TicketID is deleted" );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

done_testing();
