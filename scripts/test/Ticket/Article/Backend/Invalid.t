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
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;

use vars (qw($Self));

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $EmailBackendObject   = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');
my $InvalidBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Invalid');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
FixedTimeSet();

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
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

my $MessageID   = '<' . $Helper->GetRandomID() . '@example.com>';
my %ArticleHash = (
    TicketID             => $TicketID,
    SenderType           => 'agent',
    IsVisibleForCustomer => 1,
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer A <customer-a@example.com>',
    Cc                   => 'Some Customer B <customer-b@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    MessageID            => $MessageID,
    Charset              => 'ISO-8859-15',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    UnlockOnAway         => 1,
);

my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

# Create test article via email backend.
my $ArticleID = $EmailBackendObject->ArticleCreate(
    %ArticleHash,
);
$Self->True(
    $ArticleID,
    "ArticleCreate() - Added article $ArticleID via email backend"
);
$ArticleHash{ArticleID}     = $ArticleID;
$ArticleHash{ArticleNumber} = 1;
$ArticleHash{CreateBy}      = 1;
$ArticleHash{CreateTime}    = $TimeStamp;

my %ResultHash = $EmailBackendObject->ArticleGet(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
);

KEY:
for my $Key (
    qw(TicketID ArticleID From ReplyTo To Cc Subject MessageID InReplyTo References ContentType Body SenderType SenderTypeID IsVisibleForCustomer CreateBy CreateTime Charset MimeType FromRealname ToRealname CcRealname)
    )
{
    next KEY if !defined $ArticleHash{$Key};

    $Self->Is(
        $ResultHash{$Key},
        $ArticleHash{$Key},
        "ArticleGet - Value for $Key"
    );
}

$Self->Is(
    scalar $InvalidBackendObject->ArticleCreate(%ArticleHash),
    scalar undef,
    'Invalid backend dummy ArticleCreate()',
);

my $UpdateResult = $InvalidBackendObject->ArticleUpdate(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    Key       => 'IsVisibleForCustomer',
    Value     => 1,
    UserID    => 1,
);
$Self->Is(
    $UpdateResult,
    scalar undef,
    'Invalid backend dummy ArticleUpdate()',
);

# Construct expected meta article data.
my %MetaArticleHash;
my @SliceFields = qw(TicketID ArticleID ArticleNumber IsVisibleForCustomer CreateBy CreateTime);
@MetaArticleHash{@SliceFields} = @ArticleHash{@SliceFields};

$MetaArticleHash{ChangeBy}               = 1;
$MetaArticleHash{ChangeTime}             = $TimeStamp;
$MetaArticleHash{CommunicationChannelID} = 1;
$MetaArticleHash{SenderType}             = 'agent';
$MetaArticleHash{SenderTypeID}           = 1;

$Self->IsDeeply(
    { $InvalidBackendObject->ArticleGet(%ArticleHash) },
    \%MetaArticleHash,
    'Invalid backend ArticleGet() returns meta article data',
);

$Self->Is(
    scalar $InvalidBackendObject->ArticleSearchableContentGet(%ArticleHash),
    scalar undef,
    'Invalid backend dummy ArticleSearchableContentGet()',
);

$Self->Is(
    scalar $InvalidBackendObject->BackendSearchableFieldsGet(%ArticleHash),
    scalar undef,
    'Invalid backend dummy BackendSearchableFieldsGet()',
);

$Self->Is(
    scalar $InvalidBackendObject->ArticleDelete( %ArticleHash, UserID => 1 ),
    1,
    'Invalid backend ArticleDelete() success',
);

$Self->IsDeeply(
    { $InvalidBackendObject->ArticleGet(%ArticleHash) },
    {},
    'Invalid backend ArticleGet() after ArticleDelete()',
);

$Self->IsDeeply(
    { $EmailBackendObject->ArticleGet(%ArticleHash) },
    {},
    'Email backend ArticleGet() after ArticleDelete()',
);

# cleanup is done by RestoreDatabase.

$Self->DoneTesting();
