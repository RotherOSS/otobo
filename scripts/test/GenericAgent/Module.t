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

# This test should verify that a module gets the configured parameters
#   passed directly in the param hash

use strict;
use warnings;
use utf8;

# Set up the test driver $Self when we are running as a standalone script.
use Kernel::System::UnitTest::RegisterDriver;

our $Self;

my $TicketObject                 = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject                = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $InternalArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
my $GenericAgentObject           = $Kernel::OM->Get('Kernel::System::GenericAgent');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# create a Ticket to test JobRun and JobRunTicket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Testticket for Untittest of the Generic Agent',
    Queue        => 'Raw',
    Lock         => 'unlock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerNo   => '123465',
    CustomerUser => 'customerUnitTest@example.com',
    OwnerID      => 1,
    UserID       => 1,
);

my $ArticleID = $InternalArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 0,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Cc                   => 'Customer B <customer-b@example.com>',
    ReplyTo              => 'Customer B <customer-b@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text Perl modules provide a range of',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,
);

$Self->True(
    $TicketID,
    "Ticket is created - $TicketID",
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->True(
    $Ticket{TicketNumber},
    "Found ticket number - $Ticket{TicketNumber}",
);

# add a new Job
my $Name          = 'job' . $Helper->GetRandomID();
my $TargetAddress = $Helper->GetRandomID() . '@unittest.com';
my %NewJob        = (
    Name => $Name,
    Data => {
        TicketNumber   => $Ticket{TicketNumber},
        NewModule      => 'scripts::test::GenericAgent::MailForward',
        NewParamKey1   => 'TargetAddress',
        NewParamValue1 => $TargetAddress,
    },
);

my $JobAdd = $GenericAgentObject->JobAdd(
    %NewJob,
    UserID => 1,
);
$Self->True(
    $JobAdd || '',
    "JobAdd() - $Name"
);

$Self->True(
    $GenericAgentObject->JobRun(
        Job    => $Name,
        UserID => 1,
    ),
    'JobRun() Run the UnitTest GenericAgent job'
);

my @Articles = $ArticleObject->ArticleList(
    TicketID => $TicketID,
);
my @ArticleBox;
for my $Article (@Articles) {
    my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$Article} );

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $TicketID,
        ArticleID     => $Article->{ArticleID},
        DynamicFields => 0,
    );
    push @ArticleBox, \%Article;
}

$Self->Is(
    scalar @ArticleBox,
    2,
    '2 articles found, forward article was created'
);

$Self->Is(
    $ArticleBox[1]->{To},
    $TargetAddress,
    'TargetAddress is used'
);

my $JobDelete = $GenericAgentObject->JobDelete(
    Name   => $Name,
    UserID => 1,
);
$Self->True(
    $JobDelete || '',
    'JobDelete()'
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
