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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

# get ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @TicketIDs;

# create 2 tickets
for ( 1 .. 2 ) {
    my $TicketID = $TicketObject->TicketCreate(
        Title      => 'My ticket created by Agent A',
        QueueID    => '1',
        Lock       => 'unlock',
        PriorityID => 1,
        StateID    => 1,
        OwnerID    => 1,
        UserID     => 1,
    );

    $Self->True(
        $TicketID,
        "TicketCreate() for test - $TicketID",
    );
    push @TicketIDs, $TicketID;
}

FixedTimeSet();
FixedTimeAddSeconds(60);

# update ticket 1
my $Success = $TicketObject->TicketLockSet(
    Lock     => 'lock',
    TicketID => $TicketIDs[0],
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketLockSet() for test - $TicketIDs[0]",
);

# close ticket 2
$Success = $TicketObject->TicketStateSet(
    State    => 'closed successful',
    TicketID => $TicketIDs[1],
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketStateSet() for test - $TicketIDs[1]",
);

FixedTimeAddSeconds(60);

my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

my $TicketCloseTimeNewerDateObj = $DateTimeObject->Clone();
$TicketCloseTimeNewerDateObj->Subtract( Seconds => 61 );
my $TicketCloseTimeNewerDateTimeStamp = $TicketCloseTimeNewerDateObj->ToString();

# the following tests should provoke a join in ticket_history table and the resulting SQL should be valid
my @Tests = (
    {
        Name   => "CreatedTypeIDs",
        Config => {
            CreatedTypeIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => "CreatedStateIDs",
        Config => {
            CreatedStateIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketIDs[0], ],
    },
    {
        Name   => "CreatedUserIDs",
        Config => {
            CreatedUserIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => "CreatedQueueIDs",
        Config => {
            CreatedQueueIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => "CreatedPriorityIDs",
        Config => {
            CreatedPriorityIDs => [ '1', ],
        },
        ExpectedTicketIDs => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => "TicketChangeTimeOlderDate",
        Config => {
            TicketChangeTimeOlderDate => $DateTimeObject->ToString(),
        },
        ExpectedTicketIDs => [ $TicketIDs[0], $TicketIDs[1] ],
    },
    {
        Name   => "TicketCloseTimeOlderDate",
        Config => {
            TicketCloseTimeOlderDate => $DateTimeObject->ToString(),
        },
        ExpectedTicketIDs => [ $TicketIDs[1] ],
    },
    {
        Name   => "TicketCloseTimeNewerDate",
        Config => {
            TicketCloseTimeNewerDate => $TicketCloseTimeNewerDateTimeStamp,
        },
        ExpectedTicketIDs => [ $TicketIDs[1] ],
    },
);

for my $Test (@Tests) {

    my @ReturnedTicketIDs = $TicketObject->TicketSearch(
        Result  => 'ARRAY',
        UserID  => 1,
        OrderBy => ['Up'],
        SortBy  => ['TicketNumber'],
        %{ $Test->{Config} },
    );

    my %ReturnedLookup = map { $_ => 1 } @ReturnedTicketIDs;

    for my $TicketID ( @{ $Test->{ExpectedTicketIDs} } ) {

        $Self->True(
            $ReturnedLookup{$TicketID},
            "$Test->{Name} TicketSearch() - Results contains ticket $TicketID",
        );
    }
}

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
