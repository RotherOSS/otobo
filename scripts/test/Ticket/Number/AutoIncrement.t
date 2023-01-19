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
use Test2::V0;
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'Ticket::NumberGenerator',
    Value => 'Kernel::System::Ticket::Number::AutoIncrement',
);
$ConfigObject->Set(
    Key   => 'Ticket::NumberGenerator::AutoIncrement::MinCounterSize',
    Value => 5,
);
$ConfigObject->Set(
    Key   => 'SystemID',
    Value => 10,
);

# Delete counters
my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => 'DELETE FROM ticket_number_counter',
);
$Self->True(
    $Success,
    'Temporary cleared ticket_nuber_counter table',
);

my $TicketNumberGeneratorObject = $Kernel::OM->Get('Kernel::System::Ticket::Number::AutoIncrement');

# Create a new ticket and get it in order to influence its cache
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $TicketID     = $TicketObject->TicketCreate(
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
my $CacheKey  = "Cache::GetTicket$TicketID";
my $CacheType = 'Ticket';

my $SystemID = $ConfigObject->Get('SystemID');

# Remove SystemID  and all zeros
my $ExpectedValue = $Ticket{TicketNumber};
$ExpectedValue =~ s{\A $SystemID 0* }{}msx;
$ExpectedValue++;

# Test InitialCounterOffsetCalculate()
my $InitialCounteOffset = $TicketNumberGeneratorObject->InitialCounterOffsetCalculate();
$Self->Is(
    $InitialCounteOffset,
    $ExpectedValue,
    "InitialCounterOffsetCalculate() - Normal last ticket"
);

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
$CacheObject->CleanUp();

# Remove ticket number InitialCounterOffsetCalculate should be 1
$CacheObject->Set(
    Type  => $CacheType,
    Key   => $CacheKey,
    Value => {
        %Ticket,
        TicketNumber => '',
    },
    TTL => 60 * 60 * 24 * 20,
);
$InitialCounteOffset = $TicketNumberGeneratorObject->InitialCounterOffsetCalculate();
$Self->Is(
    $InitialCounteOffset,
    1,
    "InitialCounterOffsetCalculate() - Last ticket without TicketNumber"
);

$CacheObject->CleanUp();

# Set ticket number to invalid for InitialCounterOffsetCalculate() by using only SytemID and 0s
#   that are removed by the function.
$CacheObject->Set(
    Type  => $CacheType,
    Key   => $CacheKey,
    Value => {
        %Ticket,
        TicketNumber => $SystemID . '00',
    },
    TTL => 60 * 60 * 24 * 20,
);
$InitialCounteOffset = $TicketNumberGeneratorObject->InitialCounterOffsetCalculate();
$Self->Is(
    $InitialCounteOffset,
    1,
    "InitialCounterOffsetCalculate() - Last ticket with invalid TicketNumber"
);

# Set ticket number to a date based one for InitialCounterOffsetCalculate()
$CacheObject->Set(
    Type  => $CacheType,
    Key   => $CacheKey,
    Value => {
        %Ticket,
        TicketNumber => 201705031069,
    },
    TTL => 60 * 60 * 24 * 20,
);
$InitialCounteOffset = $TicketNumberGeneratorObject->InitialCounterOffsetCalculate();
$Self->Is(
    $InitialCounteOffset,
    1,
    "InitialCounterOffsetCalculate() - Last ticket with date based TicketNumber"
);

my @Tests = (
    {
        TN => 9_999_999_999_000_000,
    },
    {
        TN => 9_999_999_999_999_000,
    },
);

for my $Test (@Tests) {

    my $TicketID = $TicketObject->TicketCreate(
        TN           => $Test->{TN},
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
}
$InitialCounteOffset = $TicketNumberGeneratorObject->InitialCounterOffsetCalculate();
$Self->Is(
    $InitialCounteOffset,
    9_999_999_999_999_001,
    "InitialCounterOffsetCalculate() after ticket creation"
);

# TicketNumberBuild() tests
$TicketID = $TicketObject->TicketCreate(
    TN           => 123,
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

my $TicketNumber = $TicketNumberGeneratorObject->TicketNumberBuild();

# Get last ticket number counter.
my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
my $PrepareSuccess = $DBObject->Prepare(
    SQL => 'SELECT MAX(counter) FROM ticket_number_counter',
);
if ( !$PrepareSuccess ) {
    done_testing();

    exit 0;
}

my $Counter;
while ( my @Data = $DBObject->FetchrowArray() ) {
    $Counter = $Data[0];
}

# Set the expected value
my $MinSize = $ConfigObject->Get('Ticket::NumberGenerator::AutoIncrement::MinCounterSize');
$Counter       = sprintf "%.*u", $MinSize, $Counter;
$ExpectedValue = $SystemID . $Counter;

$Self->Is(
    $TicketNumber,
    $ExpectedValue,
    "TicketNumberBuild() with counters",
);

# Delete current counters.
my $DoSuccess = $DBObject->Do(
    SQL => 'DELETE FROM ticket_number_counter',
);
if ( !$DoSuccess ) {
    done_testing();

    exit 0;
}

$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

$TicketNumber  = $TicketNumberGeneratorObject->TicketNumberBuild();
$Counter       = sprintf "%.*u", $MinSize, 124;
$ExpectedValue = $SystemID . $Counter;
$Self->Is(
    $TicketNumber,
    $ExpectedValue,
    "TicketNumberBuild() without counters",
);

# _LooksLikeDateBasedTicketNumber tests

@Tests = (
    {
        Name           => 'Empty',
        TicketNumber   => '',
        ExpectedResult => 0,
    },
    {
        Name           => 'Short Number',
        TicketNumber   => 1234567,
        ExpectedResult => 0,
    },
    {
        Name           => 'Large Number',
        TicketNumber   => 123456789,
        ExpectedResult => 0,
    },
    {
        Name           => 'Correct Length Number',
        TicketNumber   => 12345678,
        ExpectedResult => 0,
    },
    {
        Name           => 'Short Date',
        TicketNumber   => 2017020,
        ExpectedResult => 0,
    },
    {
        Name           => 'Large Date',
        TicketNumber   => 2017050302,
        ExpectedResult => 1,
    },
    {
        Name           => 'Correct Length Date',
        TicketNumber   => 20120503,
        ExpectedResult => 1,
    },
    {
        Name           => 'Wrong Date',
        TicketNumber   => 2016023112,
        ExpectedResult => 0,
    },
);

for my $Test (@Tests) {
    my $Result = $TicketNumberGeneratorObject->_LooksLikeDateBasedTicketNumber( $Test->{TicketNumber} );

    $Self->Is(
        $Result // 0,
        $Test->{ExpectedResult},
        "$Test->{Name} _LooksLikeDateBasedTicketNumber()",
    );
}

# Cleanup is done by RestoreDatabase.

done_testing();
