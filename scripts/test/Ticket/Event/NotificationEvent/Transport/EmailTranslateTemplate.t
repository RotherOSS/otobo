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

use Kernel::System::MailQueue;
use Kernel::Language;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
    'Kernel::System::MailQueue' => {
        CheckEmailAddresses => 0,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $MailQueueObj = $Kernel::OM->Get('Kernel::System::MailQueue');

my $SendEmails = sub {
    my %Param = @_;

    # Get last item in the queue.
    my $Items = $MailQueueObj->List();
    my @ToReturn;
    for my $Item (@$Items) {
        $MailQueueObj->Send( %{$Item} );
        push @ToReturn, $Item;
    }

    # Clean the mail queue.
    $MailQueueObj->Delete();

    return @ToReturn;
};

# Ensure mail queue is empty before tests start.
$MailQueueObj->Delete();

# Enable email addresses checking.
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# Enable rich text editor.
$ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);

# Use Test email backend.
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);

# Set not self notify.
$ConfigObject->Set(
    Key   => 'AgentSelfNotifyOnAction',
    Value => 0,
);

# Enable banner in mails.
$ConfigObject->Set(
    Key   => 'Secure::DisableBanner',
    Value => '0',
);

my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

my $Success = $TestEmailObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);

$Self->IsDeeply(
    $TestEmailObject->EmailsGet(),
    [],
    'Test backend empty after initial cleanup',
);

my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# Create first test user with default language setting ('en').
my $UserLogin = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->TestUserCreate(
    Groups => ['users'],
);
my %UserData = $UserObject->GetUserData(
    User => $UserLogin,
);
my $UserID = $UserData{UserID};

# Create second test user with 'de' lanugage setting.
my $UserLoginDE = $Helper->TestUserCreate(
    Groups   => ['users'],
    Language => 'de'
);
my %UserDataDE = $UserObject->GetUserData(
    User => $UserLoginDE,
);
my $UserDEID = $UserDataDE{UserID};

# Create customer test user with 'es' language setting.
my $CustomerUser = $Helper->TestCustomerUserCreate(
    Language => 'es',
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Create ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => 'example.com',
    CustomerUser => $CustomerUser,
    OwnerID      => $UserID,
    UserID       => $UserID,
);
$Self->True(
    $TicketID,
    "TicketCreate() successful for Ticket ID $TicketID",
);

my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 1,
    SenderType           => 'customer',
    From                 => 'customerOne@example.com, customerTwo@example.com',
    To                   => 'Some Agent A <agent-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    Charset              => 'utf8',
    MimeType             => 'text/plain',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
);
$Self->True(
    $ArticleID,
    "ArticleCreate() successful for Article ID $ArticleID",
);

my $RandomID = $Helper->GetRandomNumber();

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# Create a dynamic field.
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "DFT1$RandomID",
    Label      => 'Description',
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'Default',
    },
    ValidID => 1,
    UserID  => 1,
    Reorder => 0,
);

my $NotificationEventObject      = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

# Test translation of 'Alert' email template. See bug#13722
#   (https://bugs.otrs.org/show_bug.cgi?id=13722).
$Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);
$Self->True(
    $Success,
    "Enable RichText with true",
);

my $NotificationID = $NotificationEventObject->NotificationAdd(
    Name => "JobNameTranslation-$RandomID",
    Data => {
        Events                 => [ 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update' ],
        Recipients             => ['Customer'],
        RecipientAgents        => [ $UserID, $UserDEID ],
        Transports             => ['Email'],
        TransportEmailTemplate => ['Alert'],
    },
    Message => {
        en => {
            Subject     => 'JobName',
            Body        => 'JobName <OTOBO_TICKET_TicketID> <OTOBO_CONFIG_SendmailModule> <OTOBO_OWNER_UserFirstname>',
            ContentType => 'text/html',
        },
    },
    Comment => 'An optional comment',
    ValidID => 1,
    UserID  => 1,
);

$EventNotificationEventObject->Run(
    Event => 'TicketDynamicFieldUpdate_DFT1' . $RandomID . 'Update',
    Data  => {
        TicketID => $TicketID,
    },
    Config => {},
    UserID => 1,
);
my @Emails = $SendEmails->();

my %Recipients = (
    "$UserLogin\@localunittest.com"    => 'en',
    "$CustomerUser\@localunittest.com" => 'es',
    "$UserLoginDE\@localunittest.com"  => 'de',
);

for my $Email (@Emails) {

    my $Language       = $Recipients{ $Email->{Recipient}[0] };
    my $LanguageObject = Kernel::Language->new(
        UserLanguage => $Language,
    );

    # Verify 'Alert' and 'Powered by' are translated in different recipient languages.
    my $Alert = $LanguageObject->Translate('Alert');
    $Self->True(
        index( $Email->{Message}->{Body}, $Alert ) > -1,
        "'Alert' is translated in notification: $Language -> $Alert ",
    );

    my $PoweredBy = $LanguageObject->Translate('Powered by');
    $Self->True(
        index( $Email->{Message}->{Body}, $PoweredBy ) > -1,
        "'Powered by' is translated in notificiation: $Language - $PoweredBy",
    );
}

$TestEmailObject->CleanUp();

# Delete the dynamic field.
my $DFDelete = $DynamicFieldObject->DynamicFieldDelete(
    ID      => $FieldID,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $DFDelete,
    "DynamicFieldDelete() successful for Field ID $FieldID",
);

# Delete the ticket.
my $TicketDelete = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => $UserID,
);
$Self->True(
    $TicketDelete,
    "TicketDelete() successful for Ticket ID $TicketID",
);

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
