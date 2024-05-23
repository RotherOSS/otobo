# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

# get needed objects
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $GenericAgentObject   = $Kernel::OM->Get('Kernel::System::GenericAgent');
my $CustomerUserObject   = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    RestoreDatabase  => 1,
    UseTmpArticleDir => 1,
);

my $RandomID = $HelperObject->GetRandomID();

my $TestCustomerUserLogin = $HelperObject->TestCustomerUserCreate();

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'GenericAgentArticle test ticket.',
    Queue        => 'Raw',
    Lock         => 'lock',
    PriorityID   => 1,
    StateID      => 1,
    CustomerUser => $TestCustomerUserLogin,
    CustomerID   => '123456',
    OwnerID      => 1,
    UserID       => 1,
);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
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
    'Ticket was created',
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
);

$Self->True(
    $Ticket{TicketNumber},
    'Found ticket number',
);

my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
    User => lc( $Ticket{CustomerUserID} ),
);

my %Notification = (
    Subject     => '',
    Body        => '<OTOBO_TICKET_TicketNumber>',
    ContentType => 'text/plain',
);

my %GenericAgentArticle = $Kernel::OM->Get('Kernel::System::TemplateGenerator')->GenericAgentArticle(
    TicketID     => $TicketID,
    Recipient    => \%CustomerUserData,
    Notification => \%Notification,
    UserID       => 1,
);

$Self->Is(
    $GenericAgentArticle{Body},
    $Ticket{TicketNumber},
    "TicketNumber found. OTOBO Tag used.",
);

$Self->DoneTesting();
