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

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::VariableCheck qw(:all);

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

FixedTimeSet();

# Use test email backend.
$Kernel::OM->Get('Kernel::Config')->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

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
    'TicketCreate()'
);

my $ArticleBackendObject = $Kernel::OM->Get("Kernel::System::Ticket::Article::Backend::Email");
my $MessageID            = '<' . $Helper->GetRandomID() . '@example.com>';
my %ArticleHash          = (
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
    FromRealname         => 'Some Agent',
    ToRealname           => 'Some Customer A',
    CcRealname           => 'Some Customer B',
);
$Self->True(
    $ArticleBackendObject,
    "Got 'Email' article backend object"
);

# Create test article.
my $ArticleID = $ArticleBackendObject->ArticleCreate(
    %ArticleHash,
);

$Self->True(
    $ArticleID,
    "ArticleCreate - Added article '$ArticleID'"
);

my $TransmissionLogObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');

$Self->True(
    $TransmissionLogObject,
    'TransmissionLogObject new()'
);

my $Result;

$Result = $TransmissionLogObject->ArticleCreateTransmissionError(
    ArticleID => $ArticleID,
    MessageID => $MessageID,
);

$Self->True(
    $Result,
    'TransmissionLogObject create()'
);

my $Object  = $TransmissionLogObject->ArticleGetTransmissionError( ArticleID => $ArticleID );
my $Success = IsHashRefWithData($Object);
$Self->True(
    $Success,
    'TransmissionLogObject create()'
);

$Result = $TransmissionLogObject->ArticleUpdateTransmissionError(
    ArticleID => $ArticleID,
    Message   => 'Test',
);

$Self->True(
    $Result,
    'TransmissionLogObject update()'
);

$Object = $TransmissionLogObject->ArticleGetTransmissionError( ArticleID => $ArticleID );

$Self->True( $Object->{Message} eq 'Test', 'Updated Status ok.' );

$Self->DoneTesting();
