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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        DisableAsyncCalls => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Get the last ticket counter id.
my $Success = $DBObject->Prepare(
    SQL => 'SELECT MAX(id) from ticket_number_counter',
);
my $InitialCounterID;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $InitialCounterID = $Row[0];
}

my $CacheType = 'UnitTestTicketCounter';

my $ChildCount = $Kernel::OM->Get('Kernel::Config')->Get('UnitTest::TicketCreateNumber::ChildCount') || 5;

for my $TicketNumberBackend (qw (AutoIncrement Date DateChecksum)) {
    for my $ChildIndex ( 1 .. $ChildCount ) {

        # Disconnect database before fork.
        $DBObject->Disconnect();

        # Create a fork of the current process
        #   parent gets the PID of the child
        #   child gets PID = 0
        my $PID = fork;
        if ( !$PID ) {

            # Destroy objects.
            $Kernel::OM->ObjectsDiscard();

            $Kernel::OM->Get('Kernel::Config')->Set(
                Key   => 'Ticket::EventModulePost',
                Value => {},
            );

            my $TicketNumber
                = $Kernel::OM->Get("Kernel::System::Ticket::Number::$TicketNumberBackend")->TicketCreateNumber();

            my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Some Ticket Title',
                QueueID      => 1,
                Lock         => 'unlock',
                Priority     => '3 normal',
                StateID      => 4,
                CustomerID   => '123465',
                CustomerUser => 'customer@example.com',
                OwnerID      => 1,
                UserID       => 1,
            );

            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $CacheType,
                Key   => "${TicketNumberBackend}::${ChildIndex}",
                Value => {
                    TicketNumber => $TicketNumber,
                    TicketID     => $TicketID,
                },
                TTL => 60 * 10,
            );

            exit 0;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my %ChildData;

    my $Wait = 1;
    while ($Wait) {
        CHILDINDEX:
        for my $ChildIndex ( 1 .. $ChildCount ) {

            next CHILDINDEX if $ChildData{$ChildIndex};

            my $Cache = $CacheObject->Get(
                Type => $CacheType,
                Key  => "${TicketNumberBackend}::${ChildIndex}",
            );

            next CHILDINDEX if !$Cache;
            next CHILDINDEX if ref $Cache ne 'HASH';

            $ChildData{$ChildIndex} = $Cache;
        }
    }
    continue {
        my $GotDataCount = scalar keys %ChildData;
        if ( $GotDataCount == $ChildCount ) {
            $Wait = 0;
        }
        sleep 1;
    }

    my %TicketNumbers;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    CHILDINDEX:
    for my $ChildIndex ( 1 .. $ChildCount ) {

        my %Data = %{ $ChildData{$ChildIndex} };

        $Self->Is(
            $TicketNumbers{ $Data{TicketNumber} } || 0,
            0,
            "TicketNumber from child $ChildIndex '$Data{TicketNumber}' with $TicketNumberBackend assigned multiple times",
        );

        $Self->True(
            $Data{TicketID},
            "TicketID from child $ChildIndex using $TicketNumberBackend",
        );

        $TicketNumbers{ $Data{TicketNumber} } = 1;

        next CHILDINDEX if !$Data{TicketID};

        my $Success = $TicketObject->TicketDelete(
            TicketID => $Data{TicketID},
            UserID   => 1,
        );

        $Self->True(
            $Success,
            "TicketDelete for $Data{TicketID}",
        );
    }
    $CacheObject->CleanUp(
        Type => $CacheType,
    );
}

# Cleanup counters.
if ($InitialCounterID) {
    $Success = $DBObject->Do(
        SQL => "DELETE from ticket_number_counter WHERE id > $InitialCounterID",
    );
    $Self->True(
        $Success,
        "Removed added ticket number counters",
    );
}

$Self->DoneTesting();
