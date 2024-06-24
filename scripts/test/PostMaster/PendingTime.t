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
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::PostMaster ();

our $Self;

# get needed objects
my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

FixedTimeSet();

my %NeededXHeaders = (
    'X-OTOBO-PendingTime'          => 1,
    'X-OTOBO-FollowUp-PendingTime' => 1,
);

my $XHeaders          = $ConfigObject->Get('PostmasterX-Header');
my @PostmasterXHeader = @{$XHeaders};
HEADER:
for my $Header ( sort keys %NeededXHeaders ) {
    next HEADER if ( grep { $_ eq $Header } @PostmasterXHeader );
    push @PostmasterXHeader, $Header;
}
$ConfigObject->Set(
    Key   => 'PostmasterX-Header',
    Value => \@PostmasterXHeader
);

# filter test
my @Tests = (
    {
        Name  => 'Regular pending time test',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '2021-01-01 00:00:00',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '2022-01-01 00:00:00',
            },
        ],
        CheckNewTicket => {
            RealTillTimeNotUsed => $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => '2021-01-01 00:00:00',
                }
            )->ToEpoch(),
        },
        CheckFollowUp => {
            RealTillTimeNotUsed => $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => '2022-01-01 00:00:00',
                }
            )->ToEpoch(),
        },
    },
    {
        Name  => 'Regular pending time test, wrong date',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '2022-01- 00:00:00',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '2022-01- 00:00:00',
            },
        ],
        CheckNewTicket => {
            RealTillTimeNotUsed => 0,
        },
        CheckFollowUp => {
            RealTillTimeNotUsed => 0,
        },
    },
    {
        Name  => 'Relative pending time test seconds',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+60s',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30s',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test implicit seconds',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+60s',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30s',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test implicit seconds no sign',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '60',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '30',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60,
        },
        CheckFollowUp => {
            UntilTime => 30,
        },
    },
    {
        Name  => 'Relative pending time test minutes',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+60m',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30m',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60 * 60,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60,
        },
    },
    {
        Name  => 'Relative pending time test hours',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+60h',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30h',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60 * 60 * 60,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60 * 60,
        },
    },
    {
        Name  => 'Relative pending time test days',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+60d',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30d',
            },
        ],
        CheckNewTicket => {
            UntilTime => 60 * 60 * 60 * 24,
        },
        CheckFollowUp => {
            UntilTime => 30 * 60 * 60 * 24,
        },
    },
    {
        Name  => 'Relative pending time test, invalid unit',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+60y',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30y',
            },
        ],
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
    {
        Name  => 'Relative pending time test, invalid unit',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+30y',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30y',
            },
        ],
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
    {
        Name  => 'Relative pending time test, invalid combination',
        Match => [
            {
                Key   => 'From',
                Value => 'sender@example.com',
            },
        ],
        Set => [
            {
                Key   => 'X-OTOBO-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-State-PendingTime',
                Value => '+30s +30m',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State',
                Value => 'pending reminder',
            },
            {
                Key   => 'X-OTOBO-FollowUp-State-PendingTime',
                Value => '+30s +30m',
            },
        ],
        CheckNewTicket => {
            UntilTime => 0,
        },
        CheckFollowUp => {
            UntilTime => 0,
        },
    },
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

for my $Test (@Tests) {

    $ConfigObject->Set(
        Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
        Value => {
            %{$Test},
            Module => 'Kernel::System::PostMaster::Filter::Match',
        },
    );

    my $Email = 'From: Sender <sender@example.com>
To: Some Name <recipient@example.com>
Subject: some subject

Some Content in Body
';

    my @Return;
    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => \$Email,
        );

        @Return = $PostMasterObject->Run();
    }
    $Self->Is(
        $Return[0] || 0,
        1,
        "$Test->{Name} - Create new ticket",
    );

    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - Create new ticket (TicketID)",
    );

    my $TicketID = $Return[1];

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{CheckNewTicket} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{CheckNewTicket}->{$Key},
            "$Test->{Name} - NewTicket - Check result value $Key",
        );
    }

    my $Subject = 'Subject: ' . $TicketObject->TicketSubjectBuild(
        TicketNumber => $Ticket{TicketNumber},
        Subject      => 'test',
    );

    my $Email2 = "From: Sender <sender\@example.com>
To: Some Name <recipient\@example.com>
$Subject

Some Content in Body
";

    {
        my $PostMasterObject = Kernel::System::PostMaster->new(
            CommunicationLogObject => $CommunicationLogObject,
            Email                  => \$Email2,
        );

        @Return = $PostMasterObject->Run();
    }

    $Self->Is(
        $Return[0] || 0,
        2,
        "$Test->{Name} - Create follow up ticket",
    );
    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - Create follow up ticket (TicketID)",
    );
    $Self->Is(
        $Return[1],
        $TicketID,
        "$Test->{Name} - Create follow up ticket (TicketID of original ticket)",
    );

    %Ticket = $TicketObject->TicketGet(
        TicketID      => $Return[1],
        DynamicFields => 1,
    );

    for my $Key ( sort keys %{ $Test->{CheckFollowUp} } ) {
        $Self->Is(
            $Ticket{$Key},
            $Test->{CheckFollowUp}->{$Key},
            "$Test->{Name} - FollowUp - Check result value $Key",
        );
    }

    $ConfigObject->Set(
        Key   => 'PostMaster::PreFilterModule###' . $Test->{Name},
        Value => undef,
    );
}

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
