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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @BackendOrder = (
    [qw(AutoIncrement Date DateChecksum)],
    [qw(Date AutoIncrement DateChecksum)],
    [qw(Date DateChecksum AutoIncrement)],
    [qw(DateChecksum AutoIncrement Date)],
    [qw(DateChecksum Date AutoIncrement)],
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
my $CacheObject  = $Kernel::OM->Get('Kernel::System::Cache');

my $Iterations = 3;

for my $DeleteCounters ( 0, 1 ) {
    for my $Pass ( 1 .. $Iterations ) {
        for my $Index ( 0 .. $#BackendOrder ) {
            for my $Backend ( @{ $BackendOrder[$Index] } ) {

                $ConfigObject->Set(
                    Key   => 'Ticket::NumberGenerator',
                    Value => 'Kernel::System::Ticket::Number::' . $Backend,
                );

                if ($DeleteCounters) {

                    # Delete current counters.
                    my $DoSuccess = $DBObject->Do(
                        SQL => 'DELETE FROM ticket_number_counter',
                    );
                    if ( !$DoSuccess ) {
                        done_testing();

                        exit 0;
                    }

                    $CacheObject->CleanUp();
                }

                my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                my $TicketID = $TicketObject->TicketCreate(
                    Title        => 'Some Ticket Title',
                    QueueID      => 1,
                    Lock         => 'unlock',
                    PriorityID   => 3,
                    StateID      => 4,
                    TypeID       => 1,
                    CustomerID   => '123465',
                    CustomerUser => 'customer@example.com',
                    OwnerID      => 1,
                    UserID       => 1,
                );
                my %Ticket = $TicketObject->TicketGet(
                    TicketID      => $TicketID,
                    DynamicFields => 0,
                    UserID        => 1,
                    Silent        => 0,
                );

                $Self->IsNot(
                    $Ticket{TicketNumber},
                    undef,
                    "TicketNumber Pass $Pass with backend $Backend using order $Index deleting counters $DeleteCounters",
                );
            }
        }
    }
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
