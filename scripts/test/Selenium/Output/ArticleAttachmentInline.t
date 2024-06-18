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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::PostMaster ();

our $Self;

# OTOBO modules
use Kernel::System::UnitTest::Selenium;
my $Selenium = Kernel::System::UnitTest::Selenium->new( LogExecuteCommandActive => 1 );

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Import sample email.
        my $Location   = $ConfigObject->Get('Home') . '/scripts/test/sample/PostMaster/PostMaster-Test26.box';
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
            Result   => 'ARRAY',
        );

        # Set ticket number in mail subject to get a follow-up.
        my $TicketNumber = $TicketObject->TicketNumberLookup(
            TicketID => $TicketID,
        );
        my @Content = ();
        for my $Line ( @{$ContentRef} ) {
            if ( $Line =~ /^Subject:/ ) {
                $Line = 'Subject: '
                    . $ConfigObject->Get('Ticket::Hook')
                    . $TicketNumber
                    . ' inline attachment test';
            }
            push @Content, $Line;
        }

        my @Return;

        # Execute PostMaster with the read email.
        {
            my $CommunicationLogObject = $Kernel::OM->Create(
                'Kernel::System::CommunicationLog',
                ObjectParams => {
                    Transport => 'Email',
                    Direction => 'Incoming',
                },
            );
            $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

            my $PostMasterObject = Kernel::System::PostMaster->new(
                CommunicationLogObject => $CommunicationLogObject,
                Email                  => \@Content,
            );

            @Return = $PostMasterObject->Run();

            $CommunicationLogObject->ObjectLogStop(
                ObjectLogType => 'Message',
                Status        => 'Successful',
            );
            $CommunicationLogObject->CommunicationStop(
                Status => 'Successful',
            );
        }

        # Check we actually got a follow-up.
        $Self->Is(
            $Return[0] || 0,
            2,
            'PostMaster::Run() - FollowUp'
        );

        # Check we actually got the same ticket ID.
        $Self->Is(
            $Return[1] || 0,
            $TicketID,
            'PostMaster::Run() - FollowUp/TicketID'
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Zoom the test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if all attachments are displayed correctly.
        my @Tests = (
            {
                Name       => 'Plain text attachment',
                Attachment => 'file-1',
            },
            {
                Name       => 'PGP signature',
                Attachment => 'signature.asc',
            },
            {
                Name       => 'PDF attachment',
                Attachment => 'StdAttachment-Test1.pdf',
            },
        );

        for my $Test (@Tests) {
            $Selenium->find_element(
                "//ul[\@class='ArticleAttachments']/li/h5[contains(text(), '$Test->{Attachment}')]"
            );
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
            "Ticket with ticket ID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );
    }
);

$Self->DoneTesting();
