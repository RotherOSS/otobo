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

our $Self;

my $ConfigObject            = $Kernel::OM->Get('Kernel::Config');
my $TicketObject            = $Kernel::OM->Get('Kernel::System::Ticket');
my $DynamicFieldObject      = $Kernel::OM->Get('Kernel::System::DynamicField');
my $CustomerUserObject      = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $UserObject              = $Kernel::OM->Get('Kernel::System::User');
my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
my $GroupObject             = $Kernel::OM->Get('Kernel::System::Group');
my $MailQueueObj            = $Kernel::OM->Get('Kernel::System::MailQueue');
my $TestEmailObject         = $Kernel::OM->Get('Kernel::System::Email::Test');

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

# Ensure mail queue is empty before tests start.
$MailQueueObj->Delete();

my $SendEmails = sub {
    my %Param = @_;

    # Get last item in the queue.
    my $Items = $MailQueueObj->List();
    my @ToReturn;
    for my $Item (@$Items) {
        $MailQueueObj->Send( %{$Item} );
        push @ToReturn, $Item->{Message};
    }

    # Clean the mail queue.
    $MailQueueObj->Delete();

    return @ToReturn;
};

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => '0',
);

# Set system timezone.
my $SystemTimezone = 'UTC';
$ConfigObject->Set(
    Key   => 'OTOBOTimeZone',
    Value => $SystemTimezone,
);

# Use Test email backend.
my $Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::Test',
);
$Self->True(
    $Success,
    "Set Email Test backend with true",
);

$Success = $TestEmailObject->CleanUp();
$Self->True(
    $Success,
    'Initial cleanup',
);
$Self->IsDeeply(
    $TestEmailObject->EmailsGet(),
    [],
    'Test backend is empty after initial cleanup',
);

my $RandomID = $Helper->GetRandomID();

# Create test customer user.
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();
my %TestCustomerUserData  = $CustomerUserObject->CustomerUserDataGet(
    User => $TestCustomerUserLogin,
);

# Create test user.
my $TestUserLogin = $Helper->TestUserCreate();
my %TestUserData  = $UserObject->GetUserData(
    User => $TestUserLogin,
);

# Define additional recipient email address.
my $AdditionalRecipientEmailAddress = $RandomID . '@test.com';

# Create test group.
my $GroupID = $GroupObject->GroupAdd(
    Name    => "Group-$RandomID",
    Comment => "Create test group - $RandomID",
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $GroupID,
    "GroupID $GroupID is created",
);

# Create test role.
my $RoleID = $GroupObject->RoleAdd(
    Name    => "Role-$RandomID",
    Comment => "Create test role - $RandomID",
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $RoleID,
    "RoleID $RoleID is created",
);

# Add user to group.
$Success = $GroupObject->PermissionGroupUserAdd(
    GID        => $GroupID,
    UID        => $TestUserData{UserID},
    Permission => {
        ro        => 1,
        move_into => 1,
        create    => 1,
        owner     => 1,
        priority  => 1,
        rw        => 1,
    },
    UserID => 1,
);
$Self->True(
    $Success,
    "Added User ID $TestUserData{UserID} to Group ID $GroupID",
);

# Add user to role.
$Success = $GroupObject->PermissionRoleUserAdd(
    RID    => $RoleID,
    UID    => $TestUserData{UserID},
    Active => 1,
    UserID => 1,
);
$Self->True(
    $Success,
    "Added User ID $TestUserData{UserID} to Role ID $RoleID",
);

# Create test queue with escalations.
my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name                => "TestQueue$RandomID",
    ValidID             => 1,
    GroupID             => $GroupID,
    FirstResponseTime   => 10,
    FirstResponseNotify => 80,
    UpdateTime          => 20,
    UpdateNotify        => 80,
    SolutionTime        => 40,
    SolutionNotify      => 80,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    Comment             => "Create test queue - $RandomID",
    UserID              => 1,
);
$Self->True(
    $QueueID,
    "QueueID $QueueID is created",
);

# Set fixed time.
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2018-12-06 12:00:00',
        },
    )->ToEpoch()
);

# Create datetime dynamic field.
my $DynamicFieldName = "DateTimeDF$RandomID";
my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $DynamicFieldName,
    Label      => $DynamicFieldName,
    FieldOrder => 9991,
    FieldType  => 'DateTime',
    ObjectType => 'Ticket',
    Config     => {},
    ValidID    => 1,
    UserID     => 1,
);
$Self->True(
    $DynamicFieldID,
    "DynamicFieldID $DynamicFieldID is created",
);

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $DynamicFieldID,
);

my $NotificationBody =
    "TicketID: <OTOBO_TICKET_TicketID>\n" .
    "OTOBO_TICKET_DynamicField: <OTOBO_TICKET_DynamicField_$DynamicFieldName>\n" .
    "OTOBO_TICKET_DynamicField_Value: <OTOBO_TICKET_DynamicField_${DynamicFieldName}_Value>\n" .
    "EscalationDestinationDate: <OTOBO_TICKET_EscalationDestinationDate>\n" .
    "FirstResponseTimeDestinationDate: <OTOBO_TICKET_FirstResponseTimeDestinationDate>\n" .
    "SolutionTimeDestinationDate: <OTOBO_TICKET_SolutionTimeDestinationDate>";

my %Notification = (
    en => {
        Subject     => 'en - JobName',
        Body        => $NotificationBody,
        ContentType => 'text/plain',
    },
    de => {
        Subject     => 'de - JobName',
        Body        => $NotificationBody,
        ContentType => 'text/plain',
    },
    es => {
        Subject     => 'es - JobName',
        Body        => $NotificationBody,
        ContentType => 'text/plain',
    },
);

# Create test notification with time tags.
my $NotificationID = $NotificationEventObject->NotificationAdd(
    Name    => "Notification$RandomID",
    Comment => "Create test notification - $RandomID",
    Data    => {
        Events          => [ 'TicketDynamicFieldUpdate_' . $DynamicFieldName . 'Update' ],
        RecipientAgents => [ $TestUserData{UserID} ],
        Recipients      => ['Customer'],
        RecipientEmail  => [$AdditionalRecipientEmailAddress],
        Transports      => ['Email'],
    },
    Message => \%Notification,
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $NotificationID,
    "NotificationID $NotificationID is created",
);

# Create test ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => "Title-$RandomID",
    QueueID      => $QueueID,
    Lock         => 'unlock',
    PriorityID   => 3,
    State        => 'new',
    CustomerID   => $TestCustomerUserLogin,
    CustomerUser => $TestCustomerUserLogin,
    OwnerID      => 1,
    UserID       => 1,
);
$Self->True(
    $TicketID,
    "TicketID $TicketID is created",
);

# Renew object because of transaction.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# Set datetime dynamic field value for test ticket.
$Success = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    Value              => '2018-12-07 15:00:00',
    UserID             => 1,
    ObjectID           => $TicketID,
);
$Self->True(
    $Success,
    "Dynamic field value is set successfully",
);

my %NotificationEventConfig = (
    Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldName . 'Update',
    Data  => {
        TicketID => $TicketID,
    },
    Config => {},
    UserID => 1,
);

# Define timezones.
my $TimezoneEN = 'Europe/London';
my $TimezoneDE = 'Europe/Berlin';
my $TimezoneES = 'America/Mexico_City';

# Define test cases.
my @Tests = (
    {
        Description => "Language - en, Timezone - $TimezoneEN",
        Language    => 'en',
        Timezone    => $TimezoneEN,
        Result      => {
            $TestUserData{UserEmail} => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 15:00:00 ($TimezoneEN)",
                OTOBO_TICKET_DynamicField_Value  => "12/07/2018 15:00 ($TimezoneEN)",
                EscalationDestinationDate        => "12/06/2018 12:10 ($TimezoneEN)",
                FirstResponseTimeDestinationDate => "12/06/2018 12:10 ($TimezoneEN)",
                SolutionTimeDestinationDate      => "12/06/2018 12:40 ($TimezoneEN)",
            },
            $TestCustomerUserData{UserEmail} => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 15:00:00 ($TimezoneEN)",
                OTOBO_TICKET_DynamicField_Value  => "12/07/2018 15:00 ($TimezoneEN)",
                EscalationDestinationDate        => "12/06/2018 12:10 ($TimezoneEN)",
                FirstResponseTimeDestinationDate => "12/06/2018 12:10 ($TimezoneEN)",
                SolutionTimeDestinationDate      => "12/06/2018 12:40 ($TimezoneEN)",
            },
            $AdditionalRecipientEmailAddress => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 15:00:00 ($SystemTimezone)",
                OTOBO_TICKET_DynamicField_Value  => "12/07/2018 15:00 ($SystemTimezone)",
                EscalationDestinationDate        => "12/06/2018 12:10 ($SystemTimezone)",
                FirstResponseTimeDestinationDate => "12/06/2018 12:10 ($SystemTimezone)",
                SolutionTimeDestinationDate      => "12/06/2018 12:40 ($SystemTimezone)",
            },
        },
    },
    {
        Description => "Language - de, Timezone - $TimezoneDE",
        Language    => 'de',
        Timezone    => $TimezoneDE,
        Result      => {
            $TestUserData{UserEmail} => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 16:00:00 ($TimezoneDE)",
                OTOBO_TICKET_DynamicField_Value  => "07.12.2018 16:00 ($TimezoneDE)",
                EscalationDestinationDate        => "06.12.2018 13:10 ($TimezoneDE)",
                FirstResponseTimeDestinationDate => "06.12.2018 13:10 ($TimezoneDE)",
                SolutionTimeDestinationDate      => "06.12.2018 13:40 ($TimezoneDE)",
            },
            $TestCustomerUserData{UserEmail} => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 16:00:00 ($TimezoneDE)",
                OTOBO_TICKET_DynamicField_Value  => "07.12.2018 16:00 ($TimezoneDE)",
                EscalationDestinationDate        => "06.12.2018 13:10 ($TimezoneDE)",
                FirstResponseTimeDestinationDate => "06.12.2018 13:10 ($TimezoneDE)",
                SolutionTimeDestinationDate      => "06.12.2018 13:40 ($TimezoneDE)",
            },
            $AdditionalRecipientEmailAddress => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 15:00:00 ($SystemTimezone)",
                OTOBO_TICKET_DynamicField_Value  => "12/07/2018 15:00 ($SystemTimezone)",
                EscalationDestinationDate        => "12/06/2018 12:10 ($SystemTimezone)",
                FirstResponseTimeDestinationDate => "12/06/2018 12:10 ($SystemTimezone)",
                SolutionTimeDestinationDate      => "12/06/2018 12:40 ($SystemTimezone)",
            },
        },
    },
    {
        Description => "Language - es, Timezone - $TimezoneES",
        Language    => 'es',
        Timezone    => $TimezoneES,
        Result      => {
            $TestUserData{UserEmail} => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 09:00:00 ($TimezoneES)",
                OTOBO_TICKET_DynamicField_Value  => "07/12/2018 - 09:00 ($TimezoneES)",
                EscalationDestinationDate        => "06/12/2018 - 06:10 ($TimezoneES)",
                FirstResponseTimeDestinationDate => "06/12/2018 - 06:10 ($TimezoneES)",
                SolutionTimeDestinationDate      => "06/12/2018 - 06:40 ($TimezoneES)",
            },
            $TestCustomerUserData{UserEmail} => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 09:00:00 ($TimezoneES)",
                OTOBO_TICKET_DynamicField_Value  => "07/12/2018 - 09:00 ($TimezoneES)",
                EscalationDestinationDate        => "06/12/2018 - 06:10 ($TimezoneES)",
                FirstResponseTimeDestinationDate => "06/12/2018 - 06:10 ($TimezoneES)",
                SolutionTimeDestinationDate      => "06/12/2018 - 06:40 ($TimezoneES)",
            },
            $AdditionalRecipientEmailAddress => {
                TicketID                         => $TicketID,
                OTOBO_TICKET_DynamicField        => "2018-12-07 15:00:00 ($SystemTimezone)",
                OTOBO_TICKET_DynamicField_Value  => "12/07/2018 15:00 ($SystemTimezone)",
                EscalationDestinationDate        => "12/06/2018 12:10 ($SystemTimezone)",
                FirstResponseTimeDestinationDate => "12/06/2018 12:10 ($SystemTimezone)",
                SolutionTimeDestinationDate      => "12/06/2018 12:40 ($SystemTimezone)",
            },
        },
    },
);

my $EventNotificationEventObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent');

# Run test cases.
for my $Test (@Tests) {

    # Set test customer user's timezone and language.
    $CustomerUserObject->SetPreferences(
        Key    => 'UserTimeZone',
        Value  => $Test->{Timezone},
        UserID => $TestCustomerUserLogin,
    );
    $CustomerUserObject->SetPreferences(
        Key    => 'UserLanguage',
        Value  => $Test->{Language},
        UserID => $TestCustomerUserLogin,
    );

    # Set test user's timezone and language.
    $UserObject->SetPreferences(
        Key    => 'UserTimeZone',
        Value  => $Test->{Timezone},
        UserID => $TestUserData{UserID},
    );
    $UserObject->SetPreferences(
        Key    => 'UserLanguage',
        Value  => $Test->{Language},
        UserID => $TestUserData{UserID},
    );

    my $Result = $EventNotificationEventObject->Run(%NotificationEventConfig);

    $Self->True(
        $Result,
        "$Test->{Description} - NotificationEvent Run() with true",
    );

    $SendEmails->();

    # Get test emails.
    my $Emails = $TestEmailObject->EmailsGet();

    # Check email bodies for all notifications.
    for my $Email ( @{$Emails} ) {
        my $To = $Email->{ToArray}->[0];

        for my $Tag ( sort keys %{ $Test->{Result}->{$To} } ) {
            my $Match = "$Tag: " . $Test->{Result}->{$To}->{$Tag};
            $Self->True(
                index( ${ $Email->{Body} }, $Match ) > 0,
                "$Test->{Description}, To: $To - $Match - found",
            );
        }
    }

    # Cleanup test email backend.
    $TestEmailObject->CleanUp();
}

# Delete test notification.
$Success = $NotificationEventObject->NotificationDelete(
    ID     => $NotificationID,
    UserID => 1,
);
$Self->True(
    $Success,
    "NotificationID $NotificationID is deleted",
);

# Delete test ticket.
$Success = $TicketObject->TicketDelete(
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "TicketID $TicketID is deleted",
);

# Delete test dynamic field.
$Success = $DynamicFieldObject->DynamicFieldDelete(
    ID      => $DynamicFieldID,
    UserID  => 1,
    Reorder => 0,
);
$Self->True(
    $Success,
    "DynamicFieldID $DynamicFieldID is deleted",
);

# Cleanup is done by RestoreDatabase.

$Self->DoneTesting();
