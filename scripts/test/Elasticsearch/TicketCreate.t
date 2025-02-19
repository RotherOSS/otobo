# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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
use v5.24;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # set up the $Self and $Kernel::OM

our $Self;

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $ESObject             = $Kernel::OM->Get('Kernel::System::Elasticsearch');
my $MigObject            = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::Elasticsearch::Migration');
my $WebserviceObject     = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set necessary variables
my $UserID   = 1;
my $RandomID = $Helper->GetRandomID();

# set necessary sysconfig setting
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# activate Elasticsearch
$ConfigObject->Set(
    Key   => 'Elasticsearch::Active',
    Value => 1,
);
my $Webservice = $WebserviceObject->WebserviceGet(
    Name => 'Elasticsearch',
);
my $WebserviceActivateSuccess = $WebserviceObject->WebserviceUpdate(
    $Webservice->%*,
    ValidID => 1,
    UserID  => $UserID,
);
ok( $WebserviceActivateSuccess, 'Activated Elasticsearch webservice' );

# create ticket
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'TestTicketTitle' . $RandomID,
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => $UserID,
    UserID       => $UserID,
);
ok( $TicketID, 'Ticket creation successful' );

# create article
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Agent Some Agent Some Agent <email@example.com>',
    To                   => 'Customer A <customer-a@example.com>',
    Subject              => 'TestArticleSubject' . $RandomID,
    Body                 => 'A text for the body, Title äöüßÄÖÜ€ис',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'AddNote',
    HistoryComment       => 'first article',
    UserID               => $UserID,
    NoAgentNotify        => 1,
);
ok( $ArticleID, 'Article creation successful' );

# add attachment to article
my $Location = $ConfigObject->Get('Home')
    . "/scripts/test/sample/Elasticsearch/Elasticsearch-Test1.txt";

my $ContentRef = $MainObject->FileRead(
    Location => $Location,
    Mode     => 'binmode',
    Type     => 'Local',
);

my $ArticleWriteAttachment = $ArticleBackendObject->ArticleWriteAttachment(
    Content     => ${$ContentRef},
    Filename    => 'TestAttachment' . $RandomID . '.txt',
    ContentType => 'text/plain',
    ArticleID   => $ArticleID,
    UserID      => $UserID,
);
ok( $ArticleWriteAttachment, 'Attachment writing successful' );

# rebuild Elasticsearch index
my $ExitCode = $MigObject->Execute( '--target', 't' );
is( $ExitCode, 0, 'Rebuild index after ticket creation' );

sleep 5;

# search by ticket title
my @TitleSearchTicketIDs = $ESObject->TicketSearch(
    Result     => 'ARRAY',
    UserID     => $UserID,
    Fulltext   => 'TestTicketTitle',
    Permission => 'ro',
    Limit      => 100,
);
my $TicketIDFound = grep { $_ == $TicketID } @TitleSearchTicketIDs;
ok( $TicketIDFound, 'Search for ticket title successful' );

# search by attachment name
my @AttachmentNameSearchTicketIDs = $ESObject->TicketSearch(
    Result     => 'ARRAY',
    UserID     => $UserID,
    Fulltext   => 'TestAttachment',
    Permission => 'ro',
    Limit      => 100,
);
$TicketIDFound = grep { $_ == $TicketID } @AttachmentNameSearchTicketIDs;
ok( $TicketIDFound, 'Search for attachment name successful' );

# delete ticket
my $DeleteSuccess = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => $UserID,
);
ok( $DeleteSuccess, 'Deleted ticket' );

# rebuild Elasticsearch index again
$ExitCode = $MigObject->Execute( '--target', 't' );
is( $ExitCode, 0, 'Rebuild index after cleaning up' );

# deactivate Elasticsearch
$ConfigObject->Set(
    Key   => 'Elasticsearch::Active',
    Value => 0,
);
my $WebserviceDeactivateSuccess = $WebserviceObject->WebserviceUpdate(
    $Webservice->%*,
    ValidID => 1,
    UserID  => $UserID,
);
ok( $WebserviceDeactivateSuccess, 'Deactivated Elasticsearch webservice' );

done_testing();
