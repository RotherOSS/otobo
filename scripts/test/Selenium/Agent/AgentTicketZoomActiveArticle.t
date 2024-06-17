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

use vars (qw($Self));

# Get selenium object.
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');

        # Set zoom sort to reverse.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomExpandSort',
            Value => 'reverse',
        );

        # Set maximum number of articles per page.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MaxArticlesPerPage',
            Value => 10,
        );

        # Create test customer.
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Get test customer user ID.
        my %TestCustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUser,
        );

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
            TN         => $TicketObject->TicketCreateNumber(),
            Title      => 'TestTicketTitle',
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => $TestCustomerUserData{UserCustomerID},
            OwnerID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Create ticket articles.
        my @ArticleIDs;
        for my $Count ( 1 .. 15 ) {
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
                Subject              => 'Selenium subject test',
                Body                 => "Article $Count",
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
                NoAgentNotify        => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleID $ArticleID is created",
            );
            push @ArticleIDs, $ArticleID;

            # Set first page articles to 'seen'.
            if ( $Count > 5 ) {
                my $Set = $ArticleObject->ArticleFlagSet(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    Key       => 'Seen',
                    Value     => 1,
                    UserID    => $TestUserID,
                );
                $Self->True(
                    $Set,
                    "ArticleID $ArticleID is set to 'Seen'",
                );
            }
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if selected article is in the first row on page 2 - it is the last not seen article (see bug#12663).
        # Check if there are exactly two pages.
        $Self->Is(
            $Selenium->execute_script("return \$('.ArticlePages a[title*=Page]').length;"),
            2,
            "There are 2 article pages",
        );

        # Check if page 2 is active.
        $Self->Is(
            $Selenium->execute_script("return \$('.ArticlePages a.Active').text();"),
            2,
            "Active article page is page 2",
        );

        # Check if active article is in the first row (Article 5).
        $Self->Is(
            $Selenium->execute_script("return \$('#ArticleTable tbody tr:eq(0).Active').attr('id');"),
            'Row5',
            "Active article is in the first table row - Row5",
        );

        # Cleanup.
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
            "TicketID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

$Self->DoneTesting();
