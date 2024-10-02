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
    q{<!DOCTYPE html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><style>/**
 * @license Copyright (c) 2003-2024, CKSource Holding sp. z o.o. All rights reserved.
 * For licensing, see LICENSE.md or https://ckeditor.com/legal/ckeditor-oss-license
 */:root{--ck-color-mention-background:rgba(153,0,48,.1);--ck-color-mention-text:#990030;--ck-highlight-marker-yellow:#fdfd77;--ck-highlight-marker-green:#62f962;--ck-highlight-marker-pink:#fc7899;--ck-highlight-marker-blue:#72ccfd;--ck-highlight-pen-red:#e71313;--ck-highlight-pen-green:#128a00;--ck-color-image-caption-background:#f7f7f7;--ck-color-image-caption-text:#333;--ck-image-style-spacing:1.5em;--ck-inline-image-style-spacing:calc(var(--ck-image-style-spacing)/2);--ck-todo-list-checkmark-size:16px}.ck-content .mention{background:var(--ck-color-mention-background);color:var(--ck-color-mention-text)}.ck-content code{background-color:hsla(0,0%,78%,.3);border-radius:2px;padding:.15em}.ck-content blockquote{border-left:5px solid #ccc;font-style:italic;margin-left:0;margin-right:0;overflow:hidden;padding-left:1.5em;padding-right:1.5em}.ck-content[dir=rtl] blockquote{border-left:0;border-right:5px solid #ccc}.ck-content pre{background:hsla(0,0%,78%,.3);border:1px solid #c4c4c4;border-radius:2px;color:#353535;direction:ltr;font-style:normal;min-width:200px;padding:1em;tab-size:4;text-align:left;white-space:pre-wrap}.ck-content pre code{background:unset;border-radius:0;padding:0}.ck-content .text-tiny{font-size:.7em}.ck-content .text-small{font-size:.85em}.ck-content .text-big{font-size:1.4em}.ck-content .text-huge{font-size:1.8em}.ck-content .marker-yellow{background-color:var(--ck-highlight-marker-yellow)}.ck-content .marker-green{background-color:var(--ck-highlight-marker-green)}.ck-content .marker-pink{background-color:var(--ck-highlight-marker-pink)}.ck-content .marker-blue{background-color:var(--ck-highlight-marker-blue)}.ck-content .pen-red{background-color:transparent;color:var(--ck-highlight-pen-red)}.ck-content .pen-green{background-color:transparent;color:var(--ck-highlight-pen-green)}.ck-content hr{background:#dedede;border:0;height:4px;margin:15px 0}.ck-content .image>figcaption{background-color:var(--ck-color-image-caption-background);caption-side:bottom;color:var(--ck-color-image-caption-text);display:table-caption;font-size:.75em;outline-offset:-1px;padding:.6em;word-break:break-word}.ck-content img.image_resized{height:auto}.ck-content .image.image_resized{box-sizing:border-box;display:block;max-width:100%}.ck-content .image.image_resized img{width:100%}.ck-content .image.image_resized>figcaption{display:block}.ck-content .image.image-style-block-align-left{max-width:calc(100% - var(--ck-image-style-spacing))}.ck-content .image.image-style-align-left{clear:none}.ck-content .image.image-style-side{float:right;margin-left:var(--ck-image-style-spacing);max-width:50%}.ck-content .image.image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.ck-content .image.image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.ck-content .image.image-style-block-align-right{margin-left:auto;margin-right:0}.ck-content .image.image-style-block-align-left{margin-left:0;margin-right:auto}.ck-content .image-style-align-center{margin-left:auto;margin-right:auto}.ck-content .image-style-align-left{float:left;margin-right:var(--ck-image-style-spacing)}.ck-content .image-style-align-right{float:right;margin-left:var(--ck-image-style-spacing)}.ck-content p+.image.image-style-align-left{margin-top:0}.ck-content .image-inline.image-style-align-left{margin-bottom:var(--ck-inline-image-style-spacing);margin-right:var(--ck-inline-image-style-spacing);margin-top:var(--ck-inline-image-style-spacing)}.ck-content .image-inline.image-style-align-right{margin-left:var(--ck-inline-image-style-spacing)}.ck-content .image{clear:both;display:table;margin:.9em auto;min-width:50px;text-align:center}.ck-content .image img{display:block;height:auto;margin:0 auto;max-width:100%;min-width:100%}.ck-content .image-inline{align-items:flex-start;display:inline-flex;max-width:100%}.ck-content .image-inline picture{display:flex}.ck-content .image-inline img{flex-grow:1;flex-shrink:1;max-width:100%}.ck-content ol{list-style-type:decimal}.ck-content ol ol{list-style-type:lower-latin}.ck-content ol ol ol{list-style-type:lower-roman}.ck-content ol ol ol ol{list-style-type:upper-latin}.ck-content ol ol ol ol ol{list-style-type:upper-roman}.ck-content ul{list-style-type:disc}.ck-content ul ul{list-style-type:circle}.ck-content ul ul ul{list-style-type:square}.ck-content .todo-list{list-style:none}.ck-content .todo-list li{margin-bottom:5px;position:relative}.ck-content .todo-list li .todo-list{margin-top:5px}.ck-content .todo-list .todo-list__label>input{-webkit-appearance:none;border:0;display:inline-block;height:var(--ck-todo-list-checkmark-size);left:-25px;margin-left:0;margin-right:-15px;position:relative;right:0;vertical-align:middle;width:var(--ck-todo-list-checkmark-size)}.ck-content[dir=rtl] .todo-list .todo-list__label>input{left:0;margin-left:-15px;margin-right:0;right:-25px}.ck-content .todo-list .todo-list__label>input:before{border:1px solid #333;border-radius:2px;box-sizing:border-box;content:"";display:block;height:100%;position:absolute;transition:box-shadow .25s ease-in-out;width:100%}.ck-content .todo-list .todo-list__label>input:after{border-color:transparent;border-style:solid;border-width:0 calc(var(--ck-todo-list-checkmark-size)/8) calc(var(--ck-todo-list-checkmark-size)/8) 0;box-sizing:content-box;content:"";display:block;height:calc(var(--ck-todo-list-checkmark-size)/2.6);left:calc(var(--ck-todo-list-checkmark-size)/3);pointer-events:none;position:absolute;top:calc(var(--ck-todo-list-checkmark-size)/5.3);transform:rotate(45deg);width:calc(var(--ck-todo-list-checkmark-size)/5.3)}.ck-content .todo-list .todo-list__label>input[checked]:before{background:#26ab33;border-color:#26ab33}.ck-content .todo-list .todo-list__label>input[checked]:after{border-color:#fff}.ck-content .todo-list .todo-list__label .todo-list__label__description{vertical-align:middle}.ck-content .todo-list .todo-list__label.todo-list__label_without-description input[type=checkbox]{position:absolute}.ck-content .media{clear:both;display:block;margin:.9em 0;min-width:15em}.ck-content .page-break{align-items:center;clear:both;display:flex;justify-content:center;padding:5px 0;position:relative}.ck-content .page-break:after{border-bottom:2px dashed #c4c4c4;content:"";position:absolute;width:100%}.ck-content .page-break__label{background:#fff;border:1px solid #c4c4c4;border-radius:2px;box-shadow:2px 2px 1px rgba(0,0,0,.15);color:#333;display:block;font-family:Helvetica,Arial,Tahoma,Verdana,Sans-Serif;font-size:.75em;font-weight:700;padding:.3em .6em;position:relative;text-transform:uppercase;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;z-index:1}
/* OTOBO is a web-based ticketing system for service organisations.

Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
*/.ck-content{text-wrap:wrap;white-space:pre-wrap;font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:12px;line-height:1.6}.ck-content.ck-editor__editable_inline{padding:15px}.ck-content figure.table{float:left;margin:0 0 0 0}.ck-content p{margin-top:.8em;margin-bottom:.8em}.ck-content h1{font-size:2em}.ck-content h2{font-size:1.5em}.ck-content h3{font-size:1.17em}.ck-content h5{font-size:.83em}.ck-content h6{font-size:.67em}.ck-content blockquote{font-style:normal!important;border-left:solid #000099 1.5pt!important;padding:0 0 0 4pt!important}.ck-content ul,.ck-content ol{padding:0 50px}
.ck-content {}</style></head><body class="ck-content">__BODY__</body></html>};
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
