# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => '0',
);

# Force rich text editor.
my $Success = $ConfigObject->Set(
    Key   => 'Frontend::RichText',
    Value => 1,
);
ok( $Success, 'Force RichText with true' );

# Use DoNotSendEmail email backend.
$Success = $ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);
ok( $Success, 'Set DoNotSendEmail backend with true' );

# Set Default Language.
$Success = $ConfigObject->Set(
    Key   => 'DefaultLanguage',
    Value => 'en',
);
ok( $Success, 'Set default language to English' );

my $RandomID = $Helper->GetRandomID();

# Create customer users.
my $TestUserLoginEN = $Helper->TestCustomerUserCreate(
    Language => 'en',
);
my $TestUserLoginDE = $Helper->TestCustomerUserCreate(
    Language => 'de',
);

my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

# Create new queue.
my $QueueName     = 'Some::Queue' . $RandomID;
my %QueueTemplate = (
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
my $QueueID = $QueueObject->QueueAdd(%QueueTemplate);
ok( defined $QueueID, 'QueueAdd() - QueueID should be defined' );

my $AutoResponseObject = $Kernel::OM->Get('Kernel::System::AutoResponse');

# Create new auto response.
my $AutoResonseName      = 'Some::AutoResponse' . $RandomID;
my %AutoResponseTemplate = (
    Name        => $AutoResonseName,
    ValidID     => 1,
    Subject     => 'Some Subject..',
    Response    => 'S:&nbsp;&lt;OTOBO_TICKET_State&gt;',    # include non-breaking space (bug#12097)
    ContentType => 'text/html',
    AddressID   => 1,
    TypeID      => 4,                                       # auto reply/new ticket
    UserID      => 1,
);
my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(%AutoResponseTemplate);
ok( defined $AutoResponseID, 'AutoResponseAdd() - AutoResonseID should not be undef' );

# Assign auto response to queue.
$Success = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $QueueID,
    AutoResponseIDs => [$AutoResponseID],
    UserID          => 1,
);
ok( $Success, "AutoResponseQueue() - assigned auto response - $AutoResonseName to queue - $QueueName" );

my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
    ChannelName => 'Email',
);

# Create a new ticket.
my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    QueueID      => $QueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
ok( defined $TicketID, 'TicketCreate() - TicketID should not be undef' );

my $HTMLTemplate =
    q{<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>:root{--ck-color-image-caption-background:hsl(0,0%,97%);--ck-color-image-caption-text:hsl(0,0%,20%);--ck-color-mention-background:hsla(341,100%,30%,.1);--ck-color-mention-text:hsl(341,100%,30%);--ck-color-selector-caption-background:hsl(0,0%,97%);--ck-color-selector-caption-text:hsl(0,0%,20%);--ck-highlight-marker-blue:hsl(201,97%,72%);--ck-highlight-marker-green:hsl(120,93%,68%);--ck-highlight-marker-pink:hsl(345,96%,73%);--ck-highlight-marker-yellow:hsl(60,97%,73%);--ck-highlight-pen-green:hsl(112,100%,27%);--ck-highlight-pen-red:hsl(0,85%,49%);--ck-image-style-spacing:1.5em;--ck-inline-image-style-spacing:calc(var(--ck-image-style-spacing) / 2);--ck-todo-list-checkmark-size:16px;--otobo-colMainLight:#001bff}.table .ck-table-resized{table-layout:fixed}.table table{overflow:hidden;border-collapse:collapse;border-spacing:0;width:100%;height:100%;border:1px double #b2b2b2}.image img,img.image_resized{height:auto}.table td,.table th{overflow-wrap:break-word;position:relative}.table{margin:.9em auto;display:table;}table{font-size:inherit;}.table table td,.table table th{min-width:2em;padding:.4em;border:1px solid #bfbfbf}.table table th{font-weight:700;background:hsla(0,0%,0%,5%)}.table[dir=rtl] th{text-align:right}.table[dir=ltr] th,pre{text-align:left}.page-break{position:relative;clear:both;padding:5px 0;display:flex;align-items:center;justify-content:center}.image img,.image.image_resized&gt;figcaption,.media,.page-break__label{display:block}.page-break::after{content:'';position:absolute;border-bottom:2px dashed #c4c4c4;width:100%}.page-break__label{position:relative;z-index:1;padding:.3em .6em;text-transform:uppercase;border:1px solid #c4c4c4;border-radius:2px;font-family:Helvetica,Arial,Tahoma,Verdana,Sans-Serif;font-size:.75em;font-weight:700;color:#333;background:#fff;box-shadow:2px 2px 1px hsla(0,0%,0%,.15);-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.media{clear:both;margin:.9em 0;min-width:15em}ol{list-style-type:decimal}ol ol{list-style-type:lower-latin}ol ol ol{list-style-type:lower-roman}ol ol ol ol{list-style-type:upper-latin}ol ol ol ol ol{list-style-type:upper-roman}ul{list-style-type:disc}ul ul{list-style-type:circle}ul ul ul,ul ul ul ul{list-style-type:square}.image{display:table;clear:both;text-align:center;margin:.9em auto;min-width:50px}.image img{margin:0 auto;max-width:100%;min-width:100%}.image-inline{display:inline-flex;max-width:100%;align-items:flex-start}.image-inline picture{display:flex}.image-inline img,.image-inline picture{flex-grow:1;flex-shrink:1;max-width:100%}.image.image_resized{max-width:100%;display:block;box-sizing:border-box}.image.image_resized img{width:100%}.image&gt;figcaption{display:table-caption;caption-side:bottom;word-break:break-word;color:var(--ck-color-image-caption-text);background-color:var(--ck-color-image-caption-background);padding:.6em;font-size:.75em;outline-offset:-1px}.image-style-block-align-left,.image-style-block-align-right{max-width:calc(100% - var(--ck-image-style-spacing))}.image-style-align-left,.image-style-align-right{clear:none}.image-style-side{float:right;margin-left:var(--ck-image-style-spacing);max-width:50%}.image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.image-style-align-center{margin-left:auto;margin-right:auto}.image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.image-style-block-align-right{margin-right:0;margin-left:auto}.image-style-block-align-left{margin-left:0;margin-right:auto}p+.image-style-align-left,p+.image-style-align-right,p+.image-style-side{margin-top:0}.image-inline.image-style-align-left,.image-inline.image-style-align-right{margin-top:var(--ck-inline-image-style-spacing);margin-bottom:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-left{margin-right:var(--ck-inline-image-style-spacing)}.image-inline.image-style-align-right{margin-left:var(--ck-inline-image-style-spacing)}.marker-yellow{background-color:var(--ck-highlight-marker-yellow)}.marker-green{background-color:var(--ck-highlight-marker-green)}.marker-pink{background-color:var(--ck-highlight-marker-pink)}.marker-blue{background-color:var(--ck-highlight-marker-blue)}.pen-green,.pen-red{background-color:transparent}.pen-red{color:var(--ck-highlight-pen-red)}.pen-green{color:var(--ck-highlight-pen-green)}blockquote{overflow:hidden;padding:0 0 0 4pt;margin-left:0;margin-right:0;font-style:normal;border-left:solid var(--otobo-colMainLight) 1.5pt}.ck-content[dir=rtl] blockquote{border-left:0;border-right:solid var(--otobo-colMainLight) 1.5pt}code{background-color:hsla(0,0%,78%,.3);padding:.15em;border-radius:2px}hr{margin:15px 0;height:4px;background:#ddd;border:0}pre{padding:1em;color:hsl(0,0%,20.8%);background:hsla(0,0%,78%,.3);border:1px solid #c4c4c4;border-radius:2px;direction:ltr;tab-size:4;white-space:pre-wrap;font-style:normal;min-width:200px}pre code{background:unset;padding:0;border-radius:0}@media print{.page-break{padding:0}.page-break::after{display:none}}</style></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">__BODY__</body></html>};
my @Tests = (
    {
        Name           => 'English Language Customer',
        CustomerUser   => $TestUserLoginEN,
        ExpectedResult => ( $HTMLTemplate =~ s/__BODY__/S:&nbsp;new/r ),
    },
    {
        Name           => 'German Language Customer',
        CustomerUser   => $TestUserLoginDE,
        ExpectedResult => ( $HTMLTemplate =~ s/__BODY__/S:&nbsp;neu/r ),
    },
    {
        Name           => 'Not existing Customer',
        CustomerUser   => 'customer@example.com',
        ExpectedResult => ( $HTMLTemplate =~ s/__BODY__/S:&nbsp;new/r ),
    },
);

my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

for my $Test (@Tests) {

    # Set ticket customer.
    my $Success = $TicketObject->TicketCustomerSet(
        User     => $Test->{CustomerUser},
        TicketID => $TicketID,
        UserID   => 1,
    );
    ok( $Success, "$Test->{Name} TicketCustomerSet() - for customer $Test->{CustomerUser} with true" );

    # Get assigned auto response.
    my %AutoResponse = $TemplateGeneratorObject->AutoResponse(
        TicketID         => $TicketID,
        OrigHeader       => {},
        AutoResponseType => 'auto reply/new ticket',
        UserID           => 1,
    );
    is(
        $AutoResponse{Text},
        $Test->{ExpectedResult},
        "$Test->{Name} AutoResponse() - Text"
    );

    # Create auto response article (bug#12097).
    my $ArticleID = $ArticleBackendObject->SendAutoResponse(
        TicketID         => $TicketID,
        AutoResponseType => 'auto reply/new ticket',
        OrigHeader       => {
            From => $Test->{CustomerUser},
        },
        IsVisibleForCustomer => 1,
        UserID               => 1,
    );
    ok( defined $ArticleID, "$Test->{Name} SendAutoResponse() - ArticleID should not be undef" );
}

# Check replacing time attribute tags (see bug#13865 - https://bugs.otrs.org/show_bug.cgi?id=13865).
# Create datetime dynamic field.
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldName   = "DateTimeDF$RandomID";
my $DynamicFieldID     = $DynamicFieldObject->DynamicFieldAdd(
    Name       => $DynamicFieldName,
    Label      => $DynamicFieldName,
    FieldOrder => 9991,
    FieldType  => 'DateTime',
    ObjectType => 'Ticket',
    Config     => {},
    ValidID    => 1,
    UserID     => 1,
);
ok( $DynamicFieldID, "DynamicFieldID $DynamicFieldID is created" );

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
    ID => $DynamicFieldID,
);

# Create test queue.
my $TestQueueID = $QueueObject->QueueAdd(
    Name            => "TestQueue$RandomID",
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);
ok( $TestQueueID, "TestQueueID $TestQueueID is created" );

my $TestAutoResponse = '<!DOCTYPE html><html>' .
    '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head>'
    . '<body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">'
    . 'OTOBO_TICKET_Created: &lt;OTOBO_TICKET_Created&gt;<br />'
    . 'OTOBO_TICKET_Changed: &lt;OTOBO_TICKET_Changed&gt;<br />'
    . 'OTOBO_TICKET_DynamicField_'
    . $DynamicFieldName
    . ': &lt;OTOBO_TICKET_DynamicField_'
    . $DynamicFieldName
    . '&gt;<br />'
    . 'OTOBO_TICKET_DynamicField_'
    . $DynamicFieldName
    . '_Value: &lt;OTOBO_TICKET_DynamicField_'
    . $DynamicFieldName
    . '_Value&gt;<br />'
    . '</body>'
    . '</html>';

# Create test auto response with tags.
my $TestAutoResponseID = $AutoResponseObject->AutoResponseAdd(
    Name        => "TestAutoResponse$RandomID",
    ValidID     => 1,
    Subject     => "$RandomID - <OTOBO_TICKET_Created>",
    Response    => $TestAutoResponse,
    ContentType => 'text/html',
    AddressID   => 1,
    TypeID      => 1,
    UserID      => 1,
);
ok( $TestAutoResponseID, "TestAutoResponseID $TestAutoResponseID is created" );

# Assign auto response to queue.
$Success = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $TestQueueID,
    AutoResponseIDs => [$TestAutoResponseID],
    UserID          => 1,
);
ok( $Success, "Auto response ID $TestAutoResponseID is assigned to QueueID $TestQueueID" );

# Set fixed time.
FixedTimeSet(
    $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => '2018-12-06 12:00:00',
        },
    )->ToEpoch
);

# Create test customer user.
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

# Create test ticket.
my $TestTicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    QueueID      => $TestQueueID,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $TestCustomerUserLogin,
    CustomerUser => $TestCustomerUserLogin,
    OwnerID      => 1,
    UserID       => 1,
);
ok( $TestTicketID, "TestTicketID $TestTicketID is created" );

# Get ticket number.
my $TicketNumber = $TicketObject->TicketNumberLookup(
    TicketID => $TestTicketID,
);

# Set datetime dynamic field value for test ticket.
$Success = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfig,
    Value              => '2018-12-03 15:00:00',
    UserID             => 1,
    ObjectID           => $TestTicketID,
);
ok( $Success, "Dynamic field value is set successfully" );

@Tests = (
    {
        Timezone        => 'Europe/Berlin',
        Language        => 'de',
        ExpectedSubject => "[Ticket#$TicketNumber] $RandomID - 06.12.2018 13:00 (Europe/Berlin)",
        ExpectedText    =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">OTOBO_TICKET_Created: 06.12.2018 13:00 (Europe/Berlin)<br />OTOBO_TICKET_Changed: 06.12.2018 13:00 (Europe/Berlin)<br />OTOBO_TICKET_DynamicField_'
            . $DynamicFieldName
            . ': 2018-12-03 16:00:00 (Europe/Berlin)<br />OTOBO_TICKET_DynamicField_'
            . $DynamicFieldName
            . '_Value: 03.12.2018 16:00 (Europe/Berlin)<br /></body></html>',
    },
    {
        Timezone        => 'America/Bogota',
        Language        => 'es',
        ExpectedSubject => "[Ticket#$TicketNumber] $RandomID - 06/12/2018 - 07:00 (America/Bogota)",
        ExpectedText    =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">OTOBO_TICKET_Created: 06/12/2018 - 07:00 (America/Bogota)<br />OTOBO_TICKET_Changed: 06/12/2018 - 07:00 (America/Bogota)<br />OTOBO_TICKET_DynamicField_'
            . $DynamicFieldName
            . ': 2018-12-03 10:00:00 (America/Bogota)<br />OTOBO_TICKET_DynamicField_'
            . $DynamicFieldName
            . '_Value: 03/12/2018 - 10:00 (America/Bogota)<br /></body></html>',
    },
    {
        Timezone        => 'Asia/Bangkok',
        Language        => 'en',
        ExpectedSubject => "[Ticket#$TicketNumber] $RandomID - 12/06/2018 19:00 (Asia/Bangkok)",
        ExpectedText    =>
            '<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/></head><body style="font-family:Geneva,Helvetica,Arial,sans-serif; font-size: 12px;">OTOBO_TICKET_Created: 12/06/2018 19:00 (Asia/Bangkok)<br />OTOBO_TICKET_Changed: 12/06/2018 19:00 (Asia/Bangkok)<br />OTOBO_TICKET_DynamicField_'
            . $DynamicFieldName
            . ': 2018-12-03 22:00:00 (Asia/Bangkok)<br />OTOBO_TICKET_DynamicField_'
            . $DynamicFieldName
            . '_Value: 12/03/2018 22:00 (Asia/Bangkok)<br /></body></html>',
    }
);

my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

for my $Test (@Tests) {

    # Set customer user's timezone and language.
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

    # Call AutoResponse function.
    my %TestAutoResponse = $TemplateGeneratorObject->AutoResponse(
        TicketID         => $TestTicketID,
        OrigHeader       => {},
        AutoResponseType => 'auto reply',
        UserID           => 1,
    );

    # Check replaced subject.
    is(
        $TestAutoResponse{Subject},
        $Test->{ExpectedSubject},
        "AutoResponse subject - Language: $Test->{Language}, Timezone: $Test->{Timezone} - tags are replaced correctly"
    );

    # Check replaced text.
    is(
        $TestAutoResponse{Text},
        $Test->{ExpectedText},
        "AutoResponse text - Language: $Test->{Language}, Timezone: $Test->{Timezone} - tags are replaced correctly"
    );
}

# Cleanup is done by RestoreDatabase.

done_testing;
