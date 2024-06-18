# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2023 Znuny GmbH, http://znuny.com/
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM
use Kernel::System::UnitTest::Selenium;

our $Self;

my $HelperObject   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SeleniumObject = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );
my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject  = $Kernel::OM->Get('Kernel::System::Ticket::Article');

# create test ticket and articles
my $TicketNumber = $TicketObject->TicketCreateNumber();
my $TicketID     = $TicketObject->TicketCreate(
    TN           => $TicketNumber,
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "Created Ticket ID $TicketID - TN $TicketNumber",
);

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Phone',
);

my @ArticleIDs;
for my $ArticleCreate ( 0 .. 1 ) {

    my $SenderType = 'agent';
    my $ArticleID  = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,
        IsVisibleForCustomer => 1,
        SenderType           => $SenderType,
        Subject              => 'Selenium subject test',
        Body                 => "Article $ArticleCreate",
        ContentType          => 'text/plain; charset=ISO-8859-15',
        HistoryType          => 'OwnerUpdate',
        HistoryComment       => 'Some free text!',
        UserID               => 1,
    );
    $Self->True(
        $ArticleID,
        "ArticleCreate - ID $ArticleID",
    );
    push @ArticleIDs, $ArticleID;
}

# store test function in variable so the Selenium object can handle errors/exceptions/dies etc.
my $SeleniumTest = sub {

    # Create test user.
    my $TestUserLogin = $HelperObject->TestUserCreate(
        Groups => [ 'admin', 'users' ],
    ) || die "Did not get test user";

    # Get test user ID.
    my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
        UserLogin => $TestUserLogin,
    );

    # TODO: Use case for this test unknown
    #     # navigate to created test ticket in AgentTicketZoom page without an article
    #     $SeleniumObject->AgentInterface(
    #         Action      => 'AgentTicketZoom',
    #         TicketID    => $TicketID,
    #         WaitForAJAX => 0,
    #     );

    # Login as test user.
    $SeleniumObject->Login(
        Type     => 'Agent',
        User     => $TestUserLogin,
        Password => $TestUserLogin,
    );

    my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

    # Navigate to zoom view of created test ticket.
    $SeleniumObject->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

    # open the dropdown menu, sleep in order to be sure that the menu has opened
    $SeleniumObject->find_element( 'li#nav-Mark-as-\(un\)seen', 'css' )->click;
    sleep 1;

    # check for elements in the dropdown
    ok(
        $SeleniumObject->find_element( 'li#nav-Mark-as-seen a', 'css' )->is_displayed,
        '"Mark ticket as seen" link is visible',
    );

    ok(
        $SeleniumObject->find_element( 'li#nav-Mark-as-unseen a', 'css' )->is_displayed,
        '"Mark ticket as unseen" link is visible',
    );

    ok(
        $SeleniumObject->find_element( 'a.AgentTicketMarkSeenUnseenArticle', 'css' )->is_displayed,
        '"Mark article as unseen" link is visible',
    );

    # mark ticket as unseen
    # TODO: Unknown, why click AND AgentInterface call are both necessary. If one is omitted,
    # not all articles will be marked as unseen. Manual testing works.
    $SeleniumObject->find_element( 'li#nav-Mark-as-unseen a', 'css' )->click();

    # $SeleniumObject->AgentInterface(
    #     Action      => 'AgentTicketMarkSeenUnseen',
    #     Subaction   => 'Unseen',
    #     TicketID    => $TicketID,
    #     WaitForAJAX => 0,
    # );

    # check if flags were set correctly
    my %Flags = $ArticleObject->ArticleFlagGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        UserID    => $TestUserID,
    );

    $Self->False(
        $Flags{Seen},
        "Initial article seen flag - ID $ArticleIDs[0]",
    );

    %Flags = $ArticleObject->ArticleFlagGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[1],
        UserID    => $TestUserID,
    );

    $Self->False(
        $Flags{Seen},
        "Initial article seen flag - ID $ArticleIDs[1]",
    );

    # call "seen" subaction directly
    $SeleniumObject->VerifiedGet(
        "${ScriptAlias}index.pl?Action=AgentTicketMarkSeenUnseen;Subaction=Seen;TicketID=$TicketID;ArticleID=$ArticleIDs[0];WaitForAJAX=0"
    );

    # check if URL call has marked the article as seen
    %Flags = $ArticleObject->ArticleFlagGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        UserID    => $TestUserID,
    );

    $Self->True(
        $Flags{Seen},
        "Subaction article seen flag - ID $ArticleIDs[0]",
    );

    %Flags = $ArticleObject->ArticleFlagGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[1],
        UserID    => $TestUserID,
    );

    $Self->False(
        $Flags{Seen},
        "Subaction article seen flag - ID $ArticleIDs[1]",
    );

    # re-navigate to created test ticket in AgentTicketZoom page
    $SeleniumObject->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

    # give AJAX request time to mark second article as seen
    sleep(5);

    # check if AJAX requests have marked the remaining article as read
    %Flags = $ArticleObject->ArticleFlagGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[0],
        UserID    => $TestUserID,
    );

    $Self->True(
        $Flags{Seen},
        "Zoom AJAX article seen flag - ID $ArticleIDs[0]",
    );

    %Flags = $ArticleObject->ArticleFlagGet(
        TicketID  => $TicketID,
        ArticleID => $ArticleIDs[1],
        UserID    => $TestUserID,
    );

    $Self->True(
        $Flags{Seen},
        "Zoom AJAX article seen flag - ID $ArticleIDs[1]",
    );
};

# finally run the test(s) in the browser
$SeleniumObject->RunTest($SeleniumTest);

done_testing();
