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

our $Self;

my $UserObject           = $Kernel::OM->Get('Kernel::System::User');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $DateTimeObject       = $Kernel::OM->Create('Kernel::System::DateTime');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'Ticket::UnlockOnAway',
    Value => 1,
);

my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
    Groups => [ 'users', ],
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'lock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $TestUserID,
    UserID       => 1,
);

$Self->True( $TicketID, 'Could create ticket' );

$ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    Subject              => 'Should not unlock',
    Body                 => '.',
    ContentType          => 'text/plain; charset=UTF-8',
    HistoryComment       => 'Just a test',
    HistoryType          => 'OwnerUpdate',
    UserID               => 1,
    NoAgentNotify        => 1,
    UnlockOnAway         => 1,
);
my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1
);

$Self->Is(
    $Ticket{Lock},
    'lock',
    'Ticket still locked (UnlockOnAway)',
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOffice',
    Value  => 1,
);

my $DTValues = $DateTimeObject->Get();

# Special case for leap years. There is no Feb 29 in the next and previous years in this case.
if ( $DTValues->{Month} == 2 && $DTValues->{Day} == 29 ) {
    $DTValues->{Day}--;
}

$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartYear',
    Value  => $DTValues->{Year} - 1,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndYear',
    Value  => $DTValues->{Year} + 1,
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartMonth',
    Value  => $DTValues->{Month},
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndMonth',
    Value  => $DTValues->{Month},
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeStartDay',
    Value  => $DTValues->{Day},
);
$UserObject->SetPreferences(
    UserID => $Ticket{OwnerID},
    Key    => 'OutOfOfficeEndDay',
    Value  => $DTValues->{Day},
);

$ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    Subject              => 'Should now unlock',
    Body                 => '.',
    ContentType          => 'text/plain; charset=UTF-8',
    HistoryComment       => 'Just a test',
    HistoryType          => 'OwnerUpdate',
    UserID               => 1,
    NoAgentNotify        => 1,
    UnlockOnAway         => 1,
);
%Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1
);

$Self->Is(
    $Ticket{Lock},
    'unlock',
    'Ticket now unlocked (UnlockOnAway)',
);

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
