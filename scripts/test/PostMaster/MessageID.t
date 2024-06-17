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

use Kernel::System::PostMaster;

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# define needed variable
my $RandomID = $Helper->GetRandomID();

for my $File (qw(1 2 3 5 6 11 21)) {

    # create random message ID
    my $MessageID = '<message' . $RandomID . $File . '@example.com>';

    # new ticket check
    my $Location = $ConfigObject->Get('Home')
        . "/scripts/test/sample/PostMaster/PostMaster-Test$File.box";

    my $ContentRef = $MainObject->FileRead(
        Location => $Location,
        Mode     => 'binmode',
        Result   => 'ARRAY',
    );

    my @Content;
    for my $Line ( @{$ContentRef} ) {

        # override Message-ID
        if ( $Line =~ /^Message-ID:/ ) {
            $Line = "Message-ID: $MessageID\n";
        }
        push @Content, $Line;
    }
    my @Return;

    $ConfigObject->Set(
        Key   => 'PostmasterDefaultState',
        Value => 'new'
    );

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

    $Self->Is(
        $Return[0] || 0,
        1,
        ' Run() - NewTicket',
    );

    my %Article = $ArticleBackendObject->ArticleGetByMessageID(
        MessageID => $MessageID,
    );

    $Self->Is(
        $Article{TicketID},
        $Return[1],
        "ArticleGetByMessageID - TicketID for message ID $MessageID"
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
