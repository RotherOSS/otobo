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

use v5.24;
use strict;
use warnings;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(:all);
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Self and $Kernel::OM

our $Self;

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# Get helper object.
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();
my ( $TestUserLogin, $UserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

my $NotificationLanguage = 'en';
my $UserLanguage         = 'de';

my @DynamicFieldsToAdd = (
    {
        Name       => 'Replace1password' . $RandomID,
        Label      => 'a description',
        FieldOrder => 9998,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            Name        => 'Replace1password' . $RandomID,
            Description => 'Description for Dynamic Field.',
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => 'Replace2' . $RandomID,
        Label      => 'a description',
        FieldOrder => 9999,
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            Name           => 'Replace2' . $RandomID,
            Description    => 'Description for Dynamic Field.',
            PossibleValues => {
                1 => 'A',
                2 => 'B',
            }
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    },
);

my %AddedDynamicFieldIds;
my %DynamicFieldConfigs;

for my $DynamicField (@DynamicFieldsToAdd) {

    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicField},
    );
    $Self->IsNot(
        $DynamicFieldID,
        undef,
        'DynamicFieldAdd()',
    );

    # Remember added DynamicFields.
    $AddedDynamicFieldIds{$DynamicFieldID} = $DynamicField->{Name};

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $DynamicField->{Name},
    );
    $Self->Is(
        ref $DynamicFieldConfig,
        'HASH',
        'DynamicFieldConfig must be a hash reference',
    );

    # Remember the DF config.
    $DynamicFieldConfigs{ $DynamicField->{FieldType} } = $DynamicFieldConfig;
}

# Create template generator after the dynamic field are created as it gathers all DF in the
# constructor.
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

my $TestCustomerLogin = $Helper->TestCustomerUserCreate(
    Language => $UserLanguage,
);

my %TestCustomerData = $CustomerUserObject->CustomerUserDataGet(
    User => $TestCustomerLogin,
);

# Add a random secret for the customer user.
$CustomerUserObject->SetPreferences(
    Key    => 'UserGoogleAuthenticatorSecretKey',
    Value  => $Helper->GetRandomID(),
    UserID => $TestCustomerLogin,
);

# Generate a token for the customer user.
$CustomerUserObject->TokenGenerate(
    UserID => $TestCustomerLogin,
);

my @TestUsers;
for ( 1 .. 4 ) {
    my $TestUserLogin = $Helper->TestUserCreate(
        Language => $UserLanguage,
    );
    my %TestUser = $UserObject->GetUserData(
        User => $TestUserLogin,
    );

    # Add a random secret for the user.
    $UserObject->SetPreferences(
        Key    => 'UserGoogleAuthenticatorSecretKey',
        Value  => $Helper->GetRandomID(),
        UserID => $TestUser{UserID},
    );

    # Generate a token for the user.
    $UserObject->TokenGenerate(
        UserID => $TestUser{UserID},
    );

    push @TestUsers, \%TestUser;
}

# Create time for time tags check.
my $SystemTime = $Kernel::OM->Create(
    'Kernel::System::DateTime',
    ObjectParams => {
        String => '2017-07-05 11:00:00',
    },
)->ToEpoch();

# Set the fixed time.
FixedTimeSet($SystemTime);

# Create test queue with escalation times.
my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name                => 'Queue' . $RandomID,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 80,
    UpdateTime          => 40,
    UpdateNotify        => 80,
    SolutionTime        => 50,
    SolutionNotify      => 80,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => "Test Queue",
);
$Self->True(
    $QueueID,
    "QueueID $QueueID - created"
);

my $TicketID = $TicketObject->TicketCreate(
    Title         => 'Some Ticket_Title',
    QueueID       => $QueueID,
    Lock          => 'unlock',
    Priority      => '3 normal',
    State         => 'open',
    CustomerNo    => '123465',
    CustomerUser  => $TestCustomerLogin,
    OwnerID       => $TestUsers[0]->{UserID},
    ResponsibleID => $TestUsers[1]->{UserID},
    UserID        => $TestUsers[2]->{UserID},
);
$Self->IsNot(
    $TicketID,
    undef,
    'TicketCreate() TicketID',
);

my $Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfigs{Text},
    ObjectID           => $TicketID,
    Value              => 'otobo',
    UserID             => 1,
);
$Self->True(
    $Success,
    'DynamicField ValueSet() for Dynamic Field Text - with true',
);

$Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
    ObjectID           => $TicketID,
    Value              => 1,
    UserID             => 1,
);
$Self->True(
    $Success,
    'DynamicField ValueSet() Dynamic Field Dropdown - with true',
);

my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Internal',
);

# Add 5 minutes for escalation times evaluation.
FixedTimeAddSeconds(300);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Some Agent <email@example.com>',
    To                   => 'Some Customer <customer-a@example.com>',
    Subject              => 'some short description',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=ISO-8859-15',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    NoAgentNotify        => 1,                                          # if you don't want to send agent notifications
);
$Self->IsNot(
    $ArticleID,
    undef,
    'ArticleCreate() ArticleID',
);

# Renew object because of transaction.
$Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my @Tests = (
    {
        Name => 'Simple replace',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_From>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'Simple replace, case insensitive',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_FROM>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'remove unknown tags',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_INVALID_TAG>',
        Result   => 'Test -',
    },
    {
        Name => 'OTOBO customer subject',    # <OTOBO_CUSTOMER_SUBJECT>
        Data => {
            From    => 'test@home.com',
            Subject => 'otobo',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_SUBJECT>',
        Result   => 'Test otobo',
    },
    {
        Name => 'OTOBO customer subject 3 letters',    # <OTOBO_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'otobo',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_SUBJECT[3]>',
        Result   => 'Test oto [...]',
    },
    {
        Name => 'OTOBO customer subject 20 letters + garbarge',    # <OTOBO_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'RE: otobo',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_SUBJECT[20]>',
        Result   => 'Test otobo',
    },
    {
        Name => 'OTOBO responsible firstname',                     # <OTOBO_RESPONSIBLE_UserFirstname>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_RESPONSIBLE_UserFirstname> <OTOBO_RESPONSIBLE_nonexisting>',
        Result   => "Test $TestUsers[1]->{UserFirstname} -",
    },
    {
        Name => 'OTOBO_TICKET_RESPONSIBLE firstname',              # <OTOBO_RESPONSIBLE_UserFirstname>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_RESPONSIBLE_UserFirstname> <OTOBO_TICKET_RESPONSIBLE_nonexisting>',
        Result   => "Test $TestUsers[1]->{UserFirstname} -",
    },
    {
        Name => 'OTOBO responsible password (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_RESPONSIBLE_UserPw> <OTOBO_RESPONSIBLE_SomeOtherValue::Password>',
        Result   => "Test xxx -",
    },
    {
        Name => 'OTOBO responsible secrets (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_RESPONSIBLE_UserGoogleAuthenticatorSecretKey> <OTOBO_RESPONSIBLE_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name => 'OTOBO owner firstname',    # <OTOBO_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_OWNER_UserFirstname> <OTOBO_OWNER_nonexisting>',
        Result   => "Test $TestUsers[0]->{UserFirstname} -",
    },
    {
        Name => 'OTOBO_TICKET_OWNER firstname',    # <OTOBO_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_OWNER_UserFirstname> <OTOBO_TICKET_OWNER_nonexisting>',
        Result   => "Test $TestUsers[0]->{UserFirstname} -",
    },
    {
        Name => 'OTOBO owner password (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_OWNER_UserPw> <OTOBO_OWNER_SomeOtherValue::Password>',
        Result   => "Test xxx -",
    },
    {
        Name => 'OTOBO owner secrets (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_OWNER_UserGoogleAuthenticatorSecretKey> <OTOBO_OWNER_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name => 'OTOBO current firstname',    # <OTOBO_CURRENT_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CURRENT_UserFirstname> <OTOBO_CURRENT_nonexisting>',
        Result   => "Test $TestUsers[2]->{UserFirstname} -",
    },
    {
        Name => 'OTOBO current password (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CURRENT_UserPw> <OTOBO_CURRENT_SomeOtherValue::Password>',
        Result   => 'Test xxx -',
    },
    {
        Name => 'OTOBO current secrets (masked)',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_CURRENT_UserGoogleAuthenticatorSecretKey> <OTOBO_CURRENT_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name => 'OTOBO ticket ticketid',    # <OTOBO_TICKET_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_TicketID>',
        Result   => 'Test ' . $TicketID,
    },
    {
        Name => 'OTOBO dynamic field (text)',    # <OTOBO_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_DynamicField_Replace1password' . $RandomID . '>',
        Result   => 'Test otobo',
    },
    {
        Name => 'OTOBO dynamic field value (text)',    # <OTOBO_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_DynamicField_Replace1password' . $RandomID . '_Value>',
        Result   => 'Test otobo',
    },
    {
        Name => 'OTOBO dynamic field (Dropdown)',      # <OTOBO_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_DynamicField_Replace2' . $RandomID . '>',
        Result   => 'Test 1',
    },
    {
        Name => 'OTOBO dynamic field value (Dropdown)',    # <OTOBO_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_DynamicField_Replace2' . $RandomID . '_Value>',
        Result   => 'Test A',
    },
    {
        Name     => 'OTOBO config value',                  # <OTOBO_CONFIG_*>
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_CONFIG_DefaultTheme>',
        Result   => 'Test Standard',
    },
    {
        Name     => 'OTOBO secret config values, must be masked (even unknown settings)',
        Data     => {},
        RichText => 0,
        Template =>
            'Test <OTOBO_CONFIG_DatabasePw> <OTOBO_CONFIG_Core::MirrorDB::Password> <OTOBO_CONFIG_SomeOtherValue::Password> <OTOBO_CONFIG_SomeOtherValue::Pw>',
        Result => 'Test xxx xxx xxx xxx',
    },
    {
        Name     => 'OTOBO secret config value and normal config value',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_CONFIG_DatabasePw> and <OTOBO_CONFIG_DefaultTheme>',
        Result   => 'Test xxx and Standard',
    },
    {
        Name     => 'OTOBO secret config values with numbers',
        Data     => {},
        RichText => 0,
        Template =>
            'Test <OTOBO_CONFIG_AuthModule::LDAP::SearchUserPw1> and <OTOBO_CONFIG_AuthModule::LDAP::SearchUserPassword1>',
        Result => 'Test xxx and xxx',
    },
    {
        Name => 'mailto-Links RichText enabled',
        Data => {
            From => 'test@home.com',
        },
        RichText => 1,
        Template =>
            'mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20%3COTOBO_CUSTOMER_From%3E&amp;body=From%3A%20%3COTOBO_CUSTOMER_From%3E">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20%3COTOBO_CUSTOMER_From%3E">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otobo.org?body=From%3A%20%3COTOBO_CUSTOMER_From%3E">E-Mail mit Body</a><br />',
        Result =>
            'mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20test%40home.com&amp;body=From%3A%20test%40home.com">E-Mail mit Subject und Body</a><br /><br />mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20test%40home.com">E-Mail mit Subject</a><br /><br />mailto-Link <a href="mailto:skywalker@otobo.org?body=From%3A%20test%40home.com">E-Mail mit Body</a><br />',
    },
    {
        Name => 'mailto-Links',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template =>
            'mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20%3COTOBO_CUSTOMER_From%3E&amp;body=From%3A%20%3COTOBO_CUSTOMER_From%3E">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20%3COTOBO_CUSTOMER_From%3E">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otobo.org?body=From%3A%20%3COTOBO_CUSTOMER_From%3E">E-Mail mit Body</a><br />',
        Result =>
            'mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20test%40home.com&amp;body=From%3A%20test%40home.com">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otobo.org?subject=From%3A%20test%40home.com">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otobo.org?body=From%3A%20test%40home.com">E-Mail mit Body</a><br />',
    },
    {
        Name => 'OTOBO AGENT + CUSTOMER FROM',    # <OTOBO_TICKET_DynamicField_*_Value>
        Data => {
            From => 'testcustomer@home.com',
        },
        DataAgent => {
            From => 'testagent@home.com',
        },
        RichText => 0,
        Template => 'Test <OTOBO_AGENT_From> - <OTOBO_CUSTOMER_From>',
        Result   => 'Test testagent@home.com - testcustomer@home.com',
    },
    {
        Name =>
            'OTOBO AGENT + CUSTOMER BODY',    # this is an special case, it sets the Body as it is since is the Data param
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTOBO_AGENT_BODY> - <OTOBO_CUSTOMER_BODY>',
        Result   => "Test Line1\nLine2\nLine3 - Line1\nLine2\nLine3",
    },
    {
        Name =>
            'OTOBO AGENT + CUSTOMER BODY With RichText enabled'
        ,    # this is an special case, it sets the Body as it is since is the Data param
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 1,
        Template => 'Test &lt;OTOBO_AGENT_BODY&gt; - &lt;OTOBO_CUSTOMER_BODY&gt;',
        Result   => "Test Line1<br/>
Line2<br/>
Line3 - Line1<br/>
Line2<br/>
Line3",
    },
    {
        Name => 'OTOBO AGENT + CUSTOMER BODY[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTOBO_AGENT_BODY[2]> - <OTOBO_CUSTOMER_BODY[2]>',
        Result   => "Test > Line1\n> Line2 - > Line1\n> Line2",
    },
    {
        Name => 'OTOBO AGENT + CUSTOMER BODY[7] with RichText enabled',
        Data => {
            Body => "Line1\nLine2\nLine3\nLine4\nLine5\nLine6\nLine7\nLine8\nLine9",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3\nLine4\nLine5\nLine6\nLine7\nLine8\nLine9",
        },
        RichText => 1,
        Template => 'Test &lt;OTOBO_AGENT_BODY[7]&gt; - &lt;OTOBO_CUSTOMER_BODY[7]&gt;',
        Result   =>
            'Test <div  type="cite" style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Line1<br/>
Line2<br/>
Line3<br/>
Line4<br/>
Line5<br/>
Line6<br/>
Line7</div> - <div  type="cite" style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Line1<br/>
Line2<br/>
Line3<br/>
Line4<br/>
Line5<br/>
Line6<br/>
Line7</div>',
    },
    {
        Name => 'OTOBO AGENT + CUSTOMER EMAIL',    # EMAIL without [ ] does not exists
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTOBO_AGENT_EMAIL> - <OTOBO_CUSTOMER_EMAIL>',
        Result   => "Test Line1\nLine2\nLine3 - Line1\nLine2\nLine3",
    },
    {
        Name => 'OTOBO AGENT + CUSTOMER EMAIL[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTOBO_AGENT_EMAIL[2]> - <OTOBO_CUSTOMER_EMAIL[2]>',
        Result   => "Test > Line1\n> Line2 - > Line1\n> Line2",
    },
    {
        Name => 'OTOBO COMMENT',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTOBO_COMMENT>',
        Result   => "Test > Line1\n> Line2\n> Line3",
    },

    {
        Name => 'OTOBO COMMENT[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTOBO_COMMENT[2]>',
        Result   => "Test > Line1\n> Line2",
    },
    {
        Name => 'OTOBO AGENT + CUSTOMER SUBJECT[2]',
        Data => {
            Subject => '0123456789'
        },
        DataAgent => {
            Subject => '987654321'
        },
        RichText => 0,
        Template => 'Test <OTOBO_AGENT_SUBJECT[2]> - <OTOBO_CUSTOMER_SUBJECT[2]>',
        Result   => "Test 98 [...] - 01 [...]",
    },
    {
        Name     => 'OTOBO CUSTOMER REALNAME',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_REALNAME>',
        Result   => "Test $TestCustomerLogin $TestCustomerLogin",
    },
    {
        Name     => 'OTOBO CUSTOMER DATA UserFirstname',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_DATA_UserFirstname>',
        Result   => "Test $TestCustomerLogin",
    },
    {
        Name     => 'OTOBO CUSTOMER DATA UserPassword (masked)',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_DATA_UserPassword>',
        Result   => 'Test xxx',
    },
    {
        Name     => 'OTOBO CUSTOMER DATA secret (masked)',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_CUSTOMER_DATA_UserGoogleAuthenticatorSecretKey> <OTOBO_CUSTOMER_DATA_UserToken>',
        Result   => 'Test xxx xxx',
    },
    {
        Name     => 'OTOBO <OTOBO_NOTIFICATION_RECIPIENT_UserFullname>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_NOTIFICATION_RECIPIENT_UserFullname> <OTOBO_NOTIFICATION_RECIPIENT_nonexisting>',
        Result   => "Test $TestUsers[3]->{UserFullname} -",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_EscalationResponseTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_EscalationResponseTime>',
        Result   => "Test 07/05/2017 11:30",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_EscalationUpdateTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_EscalationUpdateTime>',
        Result   => "Test 07/05/2017 11:45",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_EscalationSolutionTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_EscalationSolutionTime>',
        Result   => "Test 07/05/2017 11:50",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_EscalationTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_EscalationTimeWorkingTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_EscalationTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_EscalationTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_FirstResponseTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_FirstResponseTimeWorkingTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_FirstResponseTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_FirstResponseTime>',
        Result   => "Test 25 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_UpdateTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_UpdateTimeWorkingTime>',
        Result   => "Test 40 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_UpdateTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_UpdateTime>',
        Result   => "Test 40 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_SolutionTimeWorkingTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_SolutionTimeWorkingTime>',
        Result   => "Test 45 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_SolutionTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_SolutionTime>',
        Result   => "Test 45 m",
    },
);

my %Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text        => $Test->{Template},
        Data        => $Test->{Data},
        DataAgent   => $Test->{DataAgent},
        RichText    => $Test->{RichText},
        TicketData  => \%Ticket,
        UserID      => $TestUsers[2]->{UserID},
        RecipientID => $TestUsers[3]->{UserID},
        Language    => $NotificationLanguage,
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - _Replace()",
    );
}

# Set state to 'pending reminder'.
$Success = $TicketObject->TicketStateSet(
    State    => 'pending reminder',
    TicketID => $TicketID,
    UserID   => $TestUsers[2]->{UserID},
);
$Self->True(
    $Success,
    "TicketID $TicketID - set state to pending reminder successfully",
);

$Success = $TicketObject->TicketPendingTimeSet(
    String   => '2017-07-06 10:00:00',
    TicketID => $TicketID,
    UserID   => 1,
);
$Self->True(
    $Success,
    "Set pending time successfully",
);

# Check 'UntilTime' and 'RealTillTimeNotUsed' tags (see bug#8301).
@Tests = (
    {
        Name     => 'OTOBO <OTOBO_TICKET_UntilTime>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_UntilTime>',
        Result   => "Test 22 h 55 m",
    },
    {
        Name     => 'OTOBO <OTOBO_TICKET_RealTillTimeNotUsed>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTOBO_TICKET_RealTillTimeNotUsed>',
        Result   => "Test 07/06/2017 10:00",
    }
);

%Ticket = $TicketObject->TicketGet(
    TicketID      => $TicketID,
    DynamicFields => 1,
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text        => $Test->{Template},
        Data        => $Test->{Data},
        DataAgent   => $Test->{DataAgent},
        RichText    => $Test->{RichText},
        TicketData  => \%Ticket,
        UserID      => $TestUsers[2]->{UserID},
        RecipientID => $TestUsers[3]->{UserID},
        Language    => $NotificationLanguage,
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - _Replace()",
    );
}

# Test for bug#14948 Appointment description tag replace with line brakes.
my %Calendar = $Kernel::OM->Get('Kernel::System::Calendar')->CalendarCreate(
    CalendarName => "My Calendar $RandomID",
    Color        => '#3A87AD',
    GroupID      => 1,
    UserID       => $UserID,
    ValidID      => 1,
);
$Self->True(
    $Calendar{CalendarID},
    "CalendarID $Calendar{CalendarID} is created.",
);

my $AppointmentID = $Kernel::OM->Get('Kernel::System::Calendar::Appointment')->AppointmentCreate(
    CalendarID  => $Calendar{CalendarID},
    Title       => "Test Appointment $RandomID",
    Description => "Test
description
$RandomID",
    Location  => 'Germany',
    StartTime => '2016-09-01 00:00:00',
    EndTime   => '2016-09-01 01:00:00',
    UserID    => $UserID,
);
$Self->True(
    $AppointmentID,
    "AppointmentID $AppointmentID is created.",
);

# Unset fixed time before potentially interacting with S3 as S3 includes a sanity check of the timestamps.
FixedTimeUnset();

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Frontend::RichText',
    Value => 1,
);

my $Result = $Kernel::OM->Get('Kernel::System::CalendarTemplateGenerator')->_Replace(
    Text          => 'Description &lt;OTOBO_APPOINTMENT_DESCRIPTION&gt;',
    RichText      => 1,
    AppointmentID => $AppointmentID,
    CalendarID    => $Calendar{CalendarID},
    UserID        => $UserID,
);
$Self->Is(
    $Result,
    "Description Test<br/>
description<br/>
$RandomID",
    "Appointment description tag correctly replaced.",
);

done_testing();
