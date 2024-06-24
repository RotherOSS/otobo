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
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self
use Kernel::System::PostMaster ();

our $Self;

my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Do not check email addresses.
$Helper->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# Do not check RichText.
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Frontend::RichText',
    Value => 0
);

my $RandomID = $Helper->GetRandomID();
my $Home     = $ConfigObject->Get('Home');
my $Success;

# Create test queue.
my $TestQueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => "TestQueue$RandomID",
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
$Self->True(
    $TestQueueID,
    "TestQueueID $TestQueueID is created",
);

# Create customer user.
my $CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => "Firstname$RandomID",
    UserLastname   => "Lastname$RandomID",
    UserCustomerID => "CustomerID$RandomID",
    UserLogin      => "Login$RandomID",
    UserEmail      => 'unittest@example.org',
    ValidID        => 1,
    UserID         => 1,
);
$Self->True(
    $CustomerUser,
    "CustomerUser $CustomerUser is created."
);

my $TestAutoResponse = '<!DOCTYPE html><html>' .
    '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head>' .
    '<body>&lt;OTOBO_CUSTOMER_EMAIL&gt;</body>' .
    '</html>';

# Create test auto response with tags.
my $TestAutoResponseID = $AutoResponseObject->AutoResponseAdd(
    Name        => "TestAutoResponse$RandomID",
    ValidID     => 1,
    Subject     => "Subject - $RandomID",
    Response    => $TestAutoResponse,
    ContentType => 'text/html',
    AddressID   => 1,
    TypeID      => 1,
    UserID      => 1,
);
$Self->True(
    $TestAutoResponseID,
    "TestAutoResponseID $TestAutoResponseID is created",
);

# Assign auto response to queue.
$Success = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $TestQueueID,
    AutoResponseIDs => [$TestAutoResponseID],
    UserID          => 1,
);
$Self->True(
    $Success,
    "Auto response ID $TestAutoResponseID is assigned to QueueID $TestQueueID",
);

# Read email content (from a file).
my $Email = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => $Home . '/scripts/test/sample/SMIME/SMIME-Test.eml',
    Result   => 'ARRAY',
);

my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Email',
        Direction => 'Incoming',
    },
);
$CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

my $PostMasterObject = Kernel::System::PostMaster->new(
    CommunicationLogObject => $CommunicationLogObject,
    Email                  => $Email,
    Trusted                => 1,
);

my @Return = $PostMasterObject->Run( QueueID => $TestQueueID );

$Self->Is(
    $Return[0] || 0,
    1,
    "Create new ticket",
);

$Self->True(
    $Return[1] || 0,
    "Create new ticket (TicketID)",
);

$CommunicationLogObject->ObjectLogStop(
    ObjectLogType => 'Message',
    Status        => 'Successful',
);
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

my $TicketID = $Return[1];

my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
    TicketID => $TicketID,
);

my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );
my @Articles             = $ArticleObject->ArticleList(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->Is(
    scalar @Articles,
    2,
    "Two articles are created - PostMaster and AutoResponse",
);

for my $Article (@Articles) {
    my %ArticleData = $ArticleBackendObject->ArticleGet(
        TicketID  => $TicketID,
        ArticleID => $Article->{ArticleID},
    );

    my $Body = $ArticleData{Body};
    chomp($Body);

    $Self->Is(
        $Body,
        '- no text message => see attachment -',
        "Body is correct",
    );
}

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
