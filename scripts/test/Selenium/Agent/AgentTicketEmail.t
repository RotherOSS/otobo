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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SignatureObject    = $Kernel::OM->Get('Kernel::System::Signature');
        my $QueueObject        = $Kernel::OM->Get('Kernel::System::Queue');
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Disable check email addresses.
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

        # Define random test variable.
        my $RandomID = $Helper->GetRandomID();

        my @SignatureIDs;
        my @QueueIDs;
        my @QueueNames;
        my @CustomerUserIDs;
        my @TestData = (
            {
                SignatureName => 'Signature1' . $RandomID,
                SignatureText => 'Customer First Name: <OTOBO_CUSTOMER_DATA_UserFirstname>',
                QueueName     => 'Queue1' . $RandomID,
                UserFirstName => 'FirstName1' . $RandomID,
                UserLastName  => 'LastName1' . $RandomID,
                UserLogin     => 'UserLogin1' . $RandomID,
            },
            {
                SignatureName => 'Signature2' . $RandomID,
                SignatureText => 'Customer Last Name: <OTOBO_CUSTOMER_DATA_UserLastname>',
                QueueName     => 'Queue2' . $RandomID,
                UserFirstName => 'FirstName2' . $RandomID,
                UserLastName  => 'LastName2' . $RandomID,
                UserLogin     => 'UserLogin2' . $RandomID,
            },
        );

        for my $Data (@TestData) {
            my $SignatureID = $SignatureObject->SignatureAdd(
                Name        => $Data->{SignatureName},
                Text        => $Data->{SignatureText},
                ContentType => 'text/plain; charset=utf-8',
                Comment     => 'Selenium signature',
                ValidID     => 1,
                UserID      => 1,
            );
            ok( $SignatureID, "SignatureID $SignatureID is created" );
            push @SignatureIDs, $SignatureID;

            my $QueueID = $QueueObject->QueueAdd(
                Name            => $Data->{QueueName},
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => $SignatureID,
                Comment         => 'Selenium Queue',
                UserID          => 1,
            );
            ok( $QueueID, "QueueID $QueueID is created" );
            push @QueueIDs,   $QueueID;
            push @QueueNames, $Data->{QueueName};

            my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => $Data->{UserFirstName},
                UserLastname   => $Data->{UserLastName},
                UserCustomerID => $Data->{UserLogin},
                UserLogin      => $Data->{UserLogin},
                UserEmail      => "$Data->{UserLogin}\@localhost.com",
                ValidID        => 1,
                UserID         => 1,
            );
            ok( $CustomerUserID, "CustomerUserID $CustomerUserID is created" );
            push @CustomerUserIDs, $CustomerUserID;
        }

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

        # Navigate to AgentTicketEmail screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        # Check page.
        for my $ID (
            qw(Dest ToCustomer CcCustomer BccCustomer CustomerID RichText
            Signature FileUpload NextStateID PriorityID submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Subject", 'css' );
        $Element->send_keys("");
        $Selenium->find_element( "#submitRichText", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Subject.Error").length' );

        ok(
            $Selenium->execute_script("return \$('#Subject.Error').length"),
            'Client side validation correctly detected missing input value',
        );

        # Navigate to AgentTicketEmail screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        # Verify signature tags like <OTOBO_CUSTOMER_DATA_*>, please see bug#12853 for more information.
        #   Select first queue.
        my $Option = $Selenium->execute_script(
            "return \$('#Dest option').filter(function () { return \$(this).html() == '$QueueNames[0]'; }).val();"
        );
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => $Option,
        );

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # There is no selected customer, should be no replaced tags in signature.
        my $SignatureText = "Customer First Name: -";
        is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with no replaced tags"
        );

        # Select customer user.
        $Selenium->find_element( "#ToCustomer", 'css' )->clear();
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => $Option,
        );
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( $TestData[0]->{UserLogin} );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestData[0]->{UserLogin})').click()");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#CustomerSelected_1").length && !$(".AJAXLoader:visible").length'
        );

        $SignatureText = "Customer First Name: $TestData[0]->{UserFirstName}";
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Signature').val().indexOf('$SignatureText') !== -1;"
        );

        # Input subject data.
        my $TicketSubject = "Selenium Ticket";
        $Selenium->find_element( "#Subject", 'css' )->clear();
        $Selenium->find_element( "#Subject", 'css' )->send_keys($TicketSubject);

        # Queue and customer are selected, signature has replaced tags.
        is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with replaced tags on selected customer"
        );

        # Change queue, trigger new signature.
        $Option = $Selenium->execute_script(
            "return \$('#Dest option').filter(function () { return \$(this).html() == '$QueueNames[1]'; }).val();"
        );
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => $Option,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        # Queue is changed, verify signature change with replaced tags.
        $SignatureText = "Customer Last Name: $TestData[0]->{UserLastName}";
        is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with replaced tags on queue change"
        );

        # Add new customer in 'To'.
        $Selenium->find_element( "#ToCustomer", 'css' )->clear();
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( $TestData[1]->{UserLogin} );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestData[1]->{UserLogin})').click()");

        # Change selected customer, trigger replacement tag in signature.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerSelected_2").length' );
        $Selenium->find_element( "#CustomerSelected_2", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );

        $SignatureText = "Customer Last Name: $TestData[1]->{UserLastName}";
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Signature').val().indexOf('$SignatureText') !== -1;"
        );

        # Input body data.
        my $TicketBody = "Selenium body test";
        $Selenium->find_element( "#RichText", 'css' )->clear();
        $Selenium->find_element( "#RichText", 'css' )->send_keys($TicketBody);

        # Selected customer is changed, signature replaced tags are changed.
        is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature is found with replaced tags on selected customer change"
        );

        # Submit form.
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        # Get created test ticket data.
        my %TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestData[1]->{UserLogin},
        );
        my $TicketNumber = (%TicketIDs)[1];
        my $TicketID     = (%TicketIDs)[0];

        # TODO: is bail_out() more appropriate here?
        ok( $TicketID, "Ticket was created and found - $TicketID" ) || die;

        ok(
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;TicketID=$TicketID' )]"),
            "Ticket with ticket number $TicketNumber is created",
        );

        # Go to ticket zoom page of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if test ticket values are genuine.
        ok(
            index( $Selenium->get_page_source(), $TicketSubject ) > -1,
            "$TicketSubject found on page",
        ) || die "$TicketSubject not found on page";
        ok(
            index( $Selenium->get_page_source(), $TicketBody ) > -1,
            "$TicketBody found on page",
        ) || die "$TicketBody not found on page";
        ok(
            index( $Selenium->get_page_source(), $TestData[1]->{UserLogin} ) > -1,
            "$TestData[1]->{UserLogin} found on page",
        ) || die "$TestData[1]->{UserLogin} not found on page";
        ok(
            index( $Selenium->get_page_source(), $SignatureText ) > -1,
            "Signature found on page"
        ) || die "$SignatureText not found on page";

        # There is no redirect to the login page as support for SessionUseCookie = 1
        # had been removed for OTOBO 11.1.x
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");
        $Selenium->find_no_element_ok( "#User",        'css' );
        $Selenium->find_no_element_ok( "#Password",    'css' );
        $Selenium->find_no_element_ok( "#LoginButton", 'css' );

        my $DestValue = $Selenium->execute_script(
            "return \$('#Dest option').filter(function () { return \$(this).html() == '$QueueNames[0]'; } ).val();"
        );
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => $DestValue,
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".AJAXLoader:visible").length' );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ToCustomer").length' );

        # Select customer user.
        $Selenium->find_element( "#ToCustomer", 'css' )->send_keys( $TestData[0]->{UserLogin} );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestData[0]->{UserLogin})').click()");
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#CustomerSelected_1").length && !$(".AJAXLoader:visible").length'
        );

        $SignatureText = "Customer First Name: $TestData[0]->{UserFirstName}";
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Signature').val().indexOf('$SignatureText') !== -1;"
        );

        # Check if signature have correct text after set queue and customer user.
        is(
            $Selenium->execute_script('return $("#Signature").val()'),
            $SignatureText,
            "Signature has correct text"
        );

        # Delete created test ticket.
        my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        ok( $Success, "Ticket with ticket ID $TicketID is deleted" );

        # Delete created test customer users.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        for my $CustomerLogin (@CustomerUserIDs) {
            my $TestCustomer = $DBObject->Quote($CustomerLogin);
            my $Success      = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$TestCustomer ],
            );
            ok( $Success, "Customer user $TestCustomer is deleted" );
        }

        # Delete created test queues.
        for my $QueueID (@QueueIDs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$QueueID ],
            );
            ok( $Success, "QueueID $QueueID is deleted" );
        }

        # Delete created test signature.
        for my $SignatureID (@SignatureIDs) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM signature WHERE id = ?",
                Bind => [ \$SignatureID ],
            );
            ok( $Success, "SignatureID $SignatureID is deleted" );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw (Ticket CustomerUser)) {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }
);

done_testing;
