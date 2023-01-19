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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$ConfigObject->Set(
    Key   => 'CheckMXRecord',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
my $TicketID     = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'closed successful',
    CustomerNo   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    'TicketCreate()',
);

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Phone' );
my $ArticleID            = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,

    From           => 'Some Agent <email@example.com>',
    To             => 'Some Customer A <customer-a@example.com>',
    Subject        => 'some short description',
    Body           => 'the message text',
    Charset        => 'ISO-8859-15',
    MimeType       => 'text/plain',
    HistoryType    => 'OwnerUpdate',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    UnlockOnAway   => 1,
);
$Self->True(
    $ArticleID,
    'ArticleCreate()',
);

my %ExpectedDataTicket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
    UserID        => 1,
);

my %ExpectedDataArticle = $ArticleBackendObject->ArticleGet(
    ArticleID     => $ArticleID,
    TicketID      => $TicketID,
    DynamicFields => 1,
    RealNames     => 1,
    UserID        => 1,
);

my %ExpectedDataRaw = ( %ExpectedDataTicket, %ExpectedDataArticle );

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing TicketID',
        Config => {
            Data => {
                ArticleID => $ArticleID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Missing ArticleID',
        Config => {
            Data => {
                TicketID => $TicketID,
            },
        },
        Success => 0,
    },
    {
        Name   => 'Success',
        Config => {
            Data => {
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
            },
        },
        Success => 1,
    },
);

my $BackedObject = $Kernel::OM->Get('Kernel::GenericInterface::Event::ObjectType::Article');

TEST:
for my $Test (@Tests) {

    my %ObjectData = $BackedObject->DataGet( %{ $Test->{Config} } );

    my %ExpectedData;
    if ( $Test->{Success} ) {
        %ExpectedData = %ExpectedDataRaw;
    }

    $Self->IsDeeply(
        \%ObjectData,
        \%ExpectedData,
        "$Test->{Name} DataGet()"
    );
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
