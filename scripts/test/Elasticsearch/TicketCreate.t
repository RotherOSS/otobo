# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use List::Util qw(any);
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # set up the $Kernel::OM

# get needed objects
my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $SysConfigObject      = $Kernel::OM->Get('Kernel::System::SysConfig');
my $MainObject           = $Kernel::OM->Get('Kernel::System::Main');
my $ValidObject          = $Kernel::OM->Get('Kernel::System::Valid');
my $ESObject             = $Kernel::OM->Get('Kernel::System::Elasticsearch');
my $WebserviceObject     = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
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
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# activate Elasticsearch indices
my %DefaultIndexSetting = $SysConfigObject->SettingGet(
    Name   => 'Elasticsearch::IndexSettings###Default',
    UserID => $UserID,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Elasticsearch::IndexSettings###Default',
    Value => $DefaultIndexSetting{DefaultValue},
);
my %CustomerIndexSetting = $SysConfigObject->SettingGet(
    Name   => 'Elasticsearch::IndexSettings###Customer',
    UserID => $UserID,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Elasticsearch::IndexSettings###Customer',
    Value => $CustomerIndexSetting{DefaultValue},
);
my %CustomerUserIndexSetting = $SysConfigObject->SettingGet(
    Name   => 'Elasticsearch::IndexSettings###CustomerUser',
    UserID => $UserID,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Elasticsearch::IndexSettings###CustomerUser',
    Value => $CustomerUserIndexSetting{DefaultValue},
);
my %TicketIndexSetting = $SysConfigObject->SettingGet(
    Name   => 'Elasticsearch::IndexSettings###Ticket',
    UserID => $UserID,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Elasticsearch::IndexSettings###Ticket',
    Value => $TicketIndexSetting{DefaultValue},
);

# activate Elasticsearch, if necessary
my $Webservice = $WebserviceObject->WebserviceGet(
    Name => 'Elasticsearch',
);

my $Valid = $ValidObject->ValidLookup(
    ValidID => $Webservice->{ValidID},
);

if ( $Valid ne 'valid' ) {

    # set valid state
    my $ValidID = $ValidObject->ValidLookup(
        Valid => 'valid',
    );
    my $WebserviceActivateSuccess = $WebserviceObject->WebserviceUpdate(
        $Webservice->%*,
        ValidID => $ValidID,
        UserID  => $UserID,
    );
    ok( $WebserviceActivateSuccess, 'Activated Elasticsearch webservice' );

    # test the connection
    ok( $ESObject->TestConnection(), 'Elasticsearch connection active' );

    # try to set up Elasticsearch
    my ($SetupSuccess) = $ESObject->InitialSetup();
    ok( $SetupSuccess, 'Initial setup successful' );
}

# create ticket
my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
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
    Body                 => 'A text for the body, Title äöüßÄÖÜ€ис, deoxyribonucleicacid',
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

# trigger execution of events, which is necessary to have the content present in Elasticsearch
$Kernel::OM->Get('Kernel::System::Ticket')->EventHandlerTransaction();
$ArticleBackendObject->EventHandlerTransaction();

# events may take a second
sleep 1;

# search by article body
my @BodySearchTicketIDs = $ESObject->TicketSearch(
    Result     => 'ARRAY',
    UserID     => $UserID,
    Fulltext   => 'deoxyribonucleicacid',
    Permission => 'ro',
    Limit      => 100,
);
my $TicketIDFound = any { $_ == $TicketID } @BodySearchTicketIDs;
ok( $TicketIDFound, 'Search for article body successful' );

# search by attachment content
my @AttachmentContentSearchTicketIDs = $ESObject->TicketSearch(
    Result     => 'ARRAY',
    UserID     => $UserID,
    Fulltext   => 'xylophone',
    Permission => 'ro',
    Limit      => 100,
);
$TicketIDFound = any { $_ == $TicketID } @AttachmentContentSearchTicketIDs;
ok( $TicketIDFound, 'Search for attachment content successful' );

# no results are expected when the search string is not in the ticket
{
    my @TicketIDs = $ESObject->TicketSearch(
        Result     => 'ARRAY',
        UserID     => $UserID,
        Fulltext   => q{Cantor's dilemma},
        Permission => 'ro',
        Limit      => 100,
    );
    my $TicketIDFound = any { $_ == $TicketID } @TicketIDs;
    ok( !$TicketIDFound, 'did not find ticket for an arbitrary search' );
}

# delete ticket
my $DeleteSuccess = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
    TicketID => $TicketID,
    UserID   => $UserID,
);
ok( $DeleteSuccess, 'Deleted ticket' );

# trigger execution of events
$Kernel::OM->Get('Kernel::System::Ticket')->EventHandlerTransaction();

# events may take a second
sleep 1;

# verify that ticket was deleted successfully
my @DeleteTicketIDs = $ESObject->TicketSearch(
    Result     => 'ARRAY',
    UserID     => $UserID,
    Fulltext   => 'deoxyribonucleicacid',
    Permission => 'ro',
    Limit      => 100,
);
$TicketIDFound = any { $_ == $TicketID } @DeleteTicketIDs;
ok( !$TicketIDFound, 'Verification of ticket deletion successful' );

done_testing;
