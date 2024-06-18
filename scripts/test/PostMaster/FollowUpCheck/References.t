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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

use Kernel::System::PostMaster;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# $ConfigObject->Set(
#     Key   => 'PostMaster::CheckFollowUpModule',
#     Value => {
#         '0400-Attachments' => {
#             Module => 'Kernel::System::PostMaster::FollowUpCheck::Attachments',
#             }
#         }
# );
#

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
FixedTimeSet();

# filter test
my @Tests = (
    {
        Name  => 'First article, new ticket',
        Email => <<'EOF',
From: Customer <test@example.com>
To: Agent <agent@example.com>
Message-ID: <message_followupcheck_references@example.com>
Subject: Test

Some Content in Body
$Subject
EOF
        NewTicket => 1,
    },
    {
        Name  => 'Followup article',
        Email => <<'EOF',
From: Customer <test@example.com>
To: Agent <agent@example.com>
References: <message_followupcheck_references@example.com>
Subject: Test2

Some Content in Body
$Subject
EOF
        NewTicket => 2,
    },

);

# First run the tests for a ticket that has the customer as an "unknown" customer.
for my $Test (@Tests) {
    my @Return;
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
            Email                  => \$Test->{Email},
            Debug                  => 2,
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
        $Test->{NewTicket},
        "$Test->{Name} - article created",
    );
    $Self->True(
        $Return[1] || 0,
        "$Test->{Name} - article created",
    );
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
