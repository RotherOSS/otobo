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
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $CreateMailQueueElement = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my %ElementData     = (
        Sender    => 'mailqueue.test@otobo.org',
        Recipient => 'mailqueue.test@otobo.org',
        Message   => {
            'Key1' => 'Value1',
            'Key2' => 'Value2',
        },
    );

    return $MailQueueObject->Create(
        %ElementData,
        %Param,
    );
};

# START THE TESTS

# Ensure check mail addresses is enabled.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# Disable MX record check.
$Helper->ConfigSettingChange(
    Key   => 'CheckMXRecord',
    Value => 0,
);

my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $Result;

# Pass no params.
$Result = $MailQueueObject->Create();
$Self->False(
    $Result,
    'Trying to create a queue element without passing params.',
);

# Pass an invalid sender address
$Result = $CreateMailQueueElement->(
    Sender => 'dummy',
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid sender.',
);

# Pass an invalid Recipient address
$Result = $CreateMailQueueElement->(
    Recipient => 'dummy',
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid recipient.',
);

# Pass an invalid Recipient address (array)
$Result = $CreateMailQueueElement->(
    Recipient => [ 'mailqueue.test@otobo.org', 'dummy' ],
);
$Self->False(
    $Result,
    'Trying to create a queue element with an invalid recipient (array).',
);

# Simple recipient
$Result = $CreateMailQueueElement->();
$Self->True(
    $Result,
    'Trying to create a queue element with simple recipient.',
);

# ArrayRef recipient
$Result = $CreateMailQueueElement->(
    Recipient => [ 'mailqueue.test@otobo.org', 'mailqueue.test@otobo.org' ],
);
$Self->True(
    $Result,
    'Trying to create a queue element with arrayref recipient.',
);

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $QueueObject          = $Kernel::OM->Get('Kernel::System::Queue');
my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

# Create test queue.
my $QueueName = 'Queue' . $Helper->GetRandomID();
my $QueueID   = $QueueObject->QueueAdd(
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    FollowUpID      => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'UnitTest queue',
    UserID          => 1,
);
$Self->True(
    $QueueID,
    "Test QueueAdd() - QueueID $QueueID",
);

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'UnitTest ticket one',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerID   => '12345',
    CustomerUser => 'test@localunittest.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "Test TicketCreate() - TicketID $TicketID",
);

# Create article for test ticket one.
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    Subject              => 'UnitTest article one',
    From                 => '"test" <test@localunittest.com>',
    To                   => $QueueName,
    Body                 => 'UnitTest body',
    Charset              => 'utf-8',
    MimeType             => 'text/plain',
    HistoryType          => 'PhoneCallCustomer',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    UnlockOnAway         => 1,
    AutoResponseType     => 'auto follow up',
    OrigHeader           => {
        From    => '"test" <test@localunittest.com>',
        To      => $QueueName,
        Subject => 'UnitTest article one',
        Body    => 'UnitTest body',

    },
    Queue => $QueueName,
);
$Self->True(
    $ArticleID,
    "Test  ArticleCreate() - ArticleID $ArticleID",
);

for my $Idx ( 0 .. 1 ) {
    $Result = $CreateMailQueueElement->(
        ArticleID => $ArticleID,
        MessageID => 'dummy',
    );
    my $TestType = $Idx ? 'False' : 'True';
    $Self->$TestType(
        $Result,
        'Trying to create a queue element to article-id 1, attempt ' . ( $Idx + 1 ),
    );
}

# Check if communication-log lookup was created.
my $Item = $MailQueueObject->Get(
    ArticleID => $ArticleID,
);
my $CommunicationLogDBObj = $Kernel::OM->Get(
    'Kernel::System::CommunicationLog::DB',
);
my $ComLookupInfo = $CommunicationLogDBObj->ObjectLookupGet(
    TargetObjectType => 'MailQueueItem',
    TargetObjectID   => $Item->{ID},
) || {};

$Self->True(
    $ComLookupInfo->{ObjectLogID},
    'Found communication-log lookup information for the queue element.',
);

# Restore to the previous state is done by RestoreDatabase.

$Self->DoneTesting();
