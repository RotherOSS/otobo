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

my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
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

my $CreateTestData = sub {
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

    my %Elements = (
        "Article::$ArticleID" => {
            %ElementData,
            ArticleID => $ArticleID,
            MessageID => 'dummy',
        },

        'Attempts::3' => {
            %ElementData,
            Attempts => 3,
        },

        'Recipient::mailqueue.test2@otobo.org' => {
            %ElementData,
            Recipient => 'mailqueue.test2@otobo.org',
        }
    );

    for my $Key ( sort keys %Elements ) {
        my $Result = $MailQueueObject->Create( %{ $Elements{$Key} } );
        $Self->True(
            $Result,
            sprintf( 'Created the mail queue element "%s" successfuly.', $Key, ),
        );
    }

    return scalar( keys %Elements );
};

my $TotalTestRecords = $CreateTestData->();

# START THE TESTS

my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $Result;

my %BaseSearch = (
    Sender => 'mailqueue.test@otobo.org',
);

my $TestMessage = sub {
    return sprintf( q{Get all the records for the sender '%s'%s.}, $BaseSearch{Sender}, ( shift || '' ), );
};

# Get all records for the sender X
$Result = $MailQueueObject->List(%BaseSearch);
$Self->True(
    $Result && scalar( @{$Result} ) == $TotalTestRecords,
    $TestMessage->(),
);

# Get all the records for the sender X and recipient Y
$Result = $MailQueueObject->List( %BaseSearch, Recipient => 'mailqueue.test2@otobo.org' );
$Self->True(
    $Result && scalar( @{$Result} ) == 1,
    $TestMessage->(q{ and recipient 'mailqueue.test2@otobo.org'}),
);

# Get all the records for the sender X and attempts 3
$Result = $MailQueueObject->List( %BaseSearch, Attempts => 3 );
$Self->True(
    $Result && scalar( @{$Result} ) == 1,
    $TestMessage->(q{ and attempts '3'}),
);

# Get all the records for the sender X and article-id 1
$Result = $MailQueueObject->List( %BaseSearch, ArticleID => $ArticleID );
$Self->True(
    $Result && scalar( @{$Result} ) == 1,
    $TestMessage->(" and article-id '$ArticleID'"),
);

# Get all the records for the sender X and recipent that match '@otobo.org'
$Result = $MailQueueObject->List( %BaseSearch, Recipient => '@otobo.org' );
$Self->True(
    $Result && scalar( @{$Result} ) == $TotalTestRecords,
    $TestMessage->(q{ and recipent that match '@otobo.org'}),
);

# Get all the records for the sender that match 'mailqueue.test'
$Result = $MailQueueObject->List( Sender => 'mailqueue.test@' );
$Self->True(
    $Result && scalar( @{$Result} ) == $TotalTestRecords,
    q{Get all the records where sender match 'mailqueue.test@'.},
);

# restore to the previous state is done by RestoreDatabase

$Self->DoneTesting();
