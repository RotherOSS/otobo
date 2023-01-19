# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

# get selenium object
# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # create test article with subject that is link
        my $BodyText      = 'www.seleniumtest.com';
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleID     = $ArticleObject->BackendForChannel( ChannelName => 'Phone' )->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'agent',
            Subject              => 'Selenium Test Article',
            Body                 => '
www.seleniumtest.com
ftp.seleniumtest.com
cdn.www.seleniumtest.com
my.ftp.de
myftp.de
sub-domain.www.seleniumtest.com
somestringbeforeactuallink<www.some-long-url-for-test-purpose-with-many-characters-to-check-for-integrity-of-link-triggered-by-bug-11901.com>
            ',
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => $TestUserID,
        );
        $Self->True(
            $ArticleID,
            "Article is created - $ArticleID",
        );

        # navigate to zoom view of created test ticket with attachment
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ArticleID=$ArticleID");

        my @ExpectedLinks = (
            'http://www.seleniumtest.com',
            'ftp://ftp.seleniumtest.com',
            'http://cdn.www.seleniumtest.com',
            'http://my.ftp.de',
            'http://myftp.de',
            'http://sub-domain.www.seleniumtest.com',
            'http://www.some-long-url-for-test-purpose-with-many-characters-to-check-for-integrity-of-link-triggered-by-bug-11901.com',
        );

        # check for links in article body
        for my $ExpectedLink (@ExpectedLinks) {
            $Self->True(
                index( $Selenium->get_page_source(), 'href="' . $ExpectedLink . '"' ) > -1,
                "TextURL link $ExpectedLink on zoom view - found with RichText ON",
            );
        }

        # Disable RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Check for links in article body with RichText turned off
        for my $ExpectedLink (@ExpectedLinks) {
            $Self->True(
                index( $Selenium->get_page_source(), 'href="' . $ExpectedLink . '"' ) > -1,
                "TextURL link $ExpectedLink on zoom view - found with RichText OFF",
            );
        }

        # turn off OutputFilter TextURL in sysconfig
        my %TextURL = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
            Name    => 'Frontend::Output::FilterText###AAAURL',
            Default => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 0,
            Key   => 'Frontend::Output::FilterText###AAAURL',
            Value => $TextURL{EffectiveValue},
        );

        # Enable RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 1,
        );

        # refresh screen
        $Selenium->VerifiedRefresh();

        # links shouldn't be present anymore with OutputFilter turned off
        for my $ExpectedLink (@ExpectedLinks) {
            $Self->True(
                index( $Selenium->get_page_source(), 'href="' . $ExpectedLink . '"' ) == -1,
                "TextURL link $ExpectedLink on zoom view - not found",
            );
        }
    }
);

$Self->DoneTesting();
