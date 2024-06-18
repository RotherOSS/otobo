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
use Storable qw(dclone);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::MockTime qw(FixedTimeSet);
use Kernel::System::UnitTest::RegisterOM;                                 # Set up $Kernel::OM
use Kernel::GenericInterface::Debugger                        ();
use Kernel::GenericInterface::Invoker                         ();
use Kernel::GenericInterface::Operation::Ticket::TicketCreate ();         ## no perlimports, new() invoked from string
use Kernel::GenericInterface::Operation::Ticket::TicketUpdate ();         ## no perlimports, new() invoked from string
use Kernel::System::VariableCheck                             qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

# prepare data for tests
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID     = $HelperObject->GetRandomID();
FixedTimeSet();

my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
my $CustomerUserObject   = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $UserObject           = $Kernel::OM->Get('Kernel::System::User');
my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal');
my $DynamicFieldObject   = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DFBackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
my $WebserviceID     = $WebserviceObject->WebserviceAdd(
    Name   => 'OTOBOGenericInterfaceInvokerTicket-' . $RandomID,
    Config => {
        Name        => 'OTOBOGenericInterfaceInvokerTicket-' . $RandomID,
        Description => '',
        Debugger    => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type   => 'HTTP::SOAP',
                Config => {
                    NameSpace  => '',
                    SOAPAction => '',
                    Encoding   => '',
                    Endpoint   => '',
                },
            },
            Operation => {
                Operation1 => {
                    Mapping => {
                        Inbound => {
                            1 => 2,
                            2 => 4,
                        },
                        Outbound => {
                            1 => 2,
                            2 => 5,
                        },
                    },
                    Type => 'Test::Test',
                },
                Operation2 => {
                    Mapping => {
                        Inbound => {
                            1 => 2,
                            2 => 4,
                        },
                        Outbound => {
                            1 => 2,
                            2 => 5,
                        },
                    },
                },
            },
        },
        Requester => {
            Transport => {
                Type   => 'HTTP::SOAP',
                Config => {
                    NameSpace  => '',
                    SOAPAction => '',
                    Encoding   => '',
                    Endpoint   => '',
                },
            },
            Invokers => {
                TicketCreate => {},
                TicketUpdate => {},
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Requester',
);

my $UserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $RandomID . '-Customer-Id',
    UserLogin      => $RandomID,
    UserEmail      => $RandomID . '-Email@trash-mail.com',
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
);

my $TicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket_Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'open',
    CustomerUser => $UserID,
    OwnerID      => 1,
    UserID       => 1,
);
my %Ticket = $TicketObject->TicketGet(
    TicketID     => $TicketID,
    DynamicField => 1,
    UserID       => 1,
);

my $ArticleID = $ArticleBackendObject->ArticleCreate(
    TicketID             => $TicketID,
    IsVisibleForCustomer => 0,
    SenderType           => 'agent',
    From                 => 'Agent <email@trash-mail.com>',
    To                   => 'Customer A <customer-a@trash-mail.com>',
    Subject              => 'some short description ',
    Body                 => 'the message text',
    ContentType          => 'text/plain; charset=utf-8',
    HistoryType          => 'OwnerUpdate',
    HistoryComment       => 'Some free text!',
    UserID               => 1,
    Attachment           => [
        {
            Filename    => 'test.txt',
            Content     => 'blub blub blub blub blub blub blub blub',
            ContentType => 'text/html; charset="utf-8"',
        },
    ],
);
my %Article = $ArticleBackendObject->ArticleGet(
    TicketID     => $TicketID,
    ArticleID    => $ArticleID,
    DynamicField => 1,
    UserID       => 1,
);

# Add time units.
$TicketObject->TicketAccountTime(
    TicketID  => $TicketID,
    ArticleID => $ArticleID,
    TimeUnit  => 1500,
    UserID    => 1,
);

my $AccountedTime = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleAccountedTimeGet(
    ArticleID => $ArticleID,
);

my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name   => 'DynamicField' . $RandomID,
    Config => {
        Name        => 'Config Name',
        Description => 'Description for Dynamic Field.',
    },
    Label      => 'Other label',
    FieldOrder => 10000,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    ValidID    => 1,
    UserID     => 1,
);

my ( $AttachmentDynamicFieldID, $FormID, $AttachmentDynamicFieldConfig );

if ( $ConfigObject->Get('DynamicFields::Driver')->{Attachment} ) {

    # OTOBODynamicFieldAttachment is installed, add new dynamic field.
    $AttachmentDynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name   => 'DynamicFieldAttachment' . $RandomID,
        Config => {
            Name        => 'Config Name',
            Description => 'Description for Dynamic Field.',
        },
        Label      => 'Attachment label',
        FieldOrder => 11000,
        FieldType  => 'Attachment',
        ObjectType => 'Ticket',
        ValidID    => 1,
        UserID     => 1,
    );
    ok(
        $AttachmentDynamicFieldID,
        'Attachment dynamic field created.'
    );
    $AttachmentDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet( ID => $AttachmentDynamicFieldID );
}

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet( ID => $DynamicFieldID );

$ConfigObject->Set(
    Key   => 'GenericInterface::Invoker::Settings::ResponseDynamicField',
    Value => {
        $WebserviceID => 'DynamicField' . $RandomID,
    },
);

# declare test cases
my @Tests = (
    {
        Name             => 'Testcase 1',
        WebserviceUpdate => {
            TicketCreate => {},
            TicketUpdate => {},
        },
        TicketCreate => {
            ExpectedInvokerPrepareRequestResult => {
                'Article' => {
                    'Body'                 => $Article{Body},
                    'Charset'              => 'utf8',
                    'CommunicationChannel' => 'Internal',
                    'ContentType'          => 'text/plain; charset=utf8',    # modified explicitly in invoker
                    'From'                 => $Article{From},
                    'MimeType'             => $Article{MimeType},
                    'SenderType'           => $Article{SenderType},
                    'Subject'              => $Article{Subject},
                    'TimeUnit'             => $AccountedTime,
                },
                'Attachment' => [
                    {
                        'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                        'ContentType' => 'text/html; charset="utf8"',
                        'Disposition' => 'attachment',
                        'FileID'      => 1,
                        'Filename'    => 'test.txt',
                        'FilesizeRaw' => '39',
                        'MimeType'    => 'text/html',
                    }
                ],
                'DynamicField' => [
                    {
                        'Name'  => 'DynamicField' . $RandomID,
                        'Value' => 'test',
                    }
                ],
                'Ticket' => {
                    'Article' => [
                        {
                            'Attachment' => [
                                {
                                    'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                                    'ContentType' => 'text/html; charset="utf8"',
                                    'Disposition' => 'attachment',
                                    'FileID'      => 1,
                                    'Filename'    => 'test.txt',
                                    'FilesizeRaw' => '39',
                                    'MimeType'    => 'text/html',
                                },
                            ],
                            'Body'                 => $Article{Body},
                            'Charset'              => 'utf8',
                            'CommunicationChannel' => 'Internal',
                            'ContentType'          => 'text/plain; charset=utf8',    # modified explicitly in invoker
                            'From'                 => $Article{From},
                            'MimeType'             => $Article{MimeType},
                            'SenderType'           => $Article{SenderType},
                            'Subject'              => $Article{Subject},
                            'TimeUnit'             => $AccountedTime,
                        },
                    ],
                    'CustomerUser' => $UserID,
                    'DynamicField' => [
                        {
                            'Name'  => 'DynamicField' . $RandomID,
                            'Value' => 'test',
                        }
                    ],
                    'Lock'        => $Ticket{Lock},
                    'Owner'       => $Ticket{Owner},
                    'Priority'    => $Ticket{Priority},
                    'Queue'       => $Ticket{Queue},
                    'Responsible' => $Ticket{Responsible},
                    'State'       => $Ticket{State},
                    'Title'       => $Ticket{Title},
                    'Type'        => $Ticket{Type},
                },
                'TicketID'     => $Ticket{TicketID},
                'TicketNumber' => $Ticket{TicketNumber},
            },
        },
        TicketUpdate => {
            ExpectedInvokerPrepareRequestResult => {
                'Article' => {
                    'Body'                 => $Article{Body},
                    'Charset'              => 'utf8',
                    'CommunicationChannel' => 'Internal',
                    'ContentType'          => 'text/plain; charset=utf8',    # modified explicitly in invoker
                    'From'                 => $Article{From},
                    'MimeType'             => $Article{MimeType},
                    'SenderType'           => $Article{SenderType},
                    'Subject'              => $Article{Subject},
                    'TimeUnit'             => $AccountedTime,
                },
                'Attachment' => [
                    {
                        'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                        'ContentType' => 'text/html; charset="utf8"',
                        'Disposition' => 'attachment',
                        'FileID'      => 1,
                        'Filename'    => 'test.txt',
                        'FilesizeRaw' => '39',
                        'MimeType'    => 'text/html',
                    }
                ],
                'DynamicField' => [
                    {
                        'Name'  => 'DynamicField' . $RandomID,
                        'Value' => $Ticket{TicketID},
                    }
                ],
                'Ticket' => {
                    'Article' => [
                        {
                            'Attachment' => [
                                {
                                    'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                                    'ContentType' => 'text/html; charset="utf8"',
                                    'Disposition' => 'attachment',
                                    'FileID'      => 1,
                                    'Filename'    => 'test.txt',
                                    'FilesizeRaw' => '39',
                                    'MimeType'    => 'text/html',
                                },
                            ],
                            'Body'                 => $Article{Body},
                            'Charset'              => 'utf8',                        # modified explicitly in invoker
                            'CommunicationChannel' => 'Internal',
                            'ContentType'          => 'text/plain; charset=utf8',    # modified explicitly in invoker
                            'From'                 => $Article{From},
                            'MimeType'             => $Article{MimeType},
                            'SenderType'           => $Article{SenderType},
                            'Subject'              => $Article{Subject},
                            'TimeUnit'             => $AccountedTime,
                        },
                    ],
                    'CustomerUser' => $UserID,
                    'DynamicField' => [
                        {
                            'Name'  => 'DynamicField' . $RandomID,
                            'Value' => $Ticket{TicketID},
                        }
                    ],
                    'Lock'        => $Ticket{Lock},
                    'Owner'       => $Ticket{Owner},
                    'Priority'    => $Ticket{Priority},
                    'Queue'       => $Ticket{Queue},
                    'Responsible' => $Ticket{Responsible},
                    'State'       => $Ticket{State},
                    'Title'       => $Ticket{Title},
                    'Type'        => $Ticket{Type},
                },
                'TicketID'     => $Ticket{TicketID},
                'TicketNumber' => $Ticket{TicketNumber},
            },
        },
    },
    {
        Name             => 'Testcase 2',
        WebserviceUpdate => {
            TicketUpdate => {
                'TicketIdToDynamicField' => 'DynamicField' . $RandomID,
                'RequestArticleFields'   => [
                    'ArticleID',
                    'Attachment',
                    'Body',
                    'Cc',
                    'Charset',
                    'ContentType',
                    'From',
                    'IncomingTime',
                    'InReplyTo',
                    'MessageID',
                    'MimeType',
                    'References',
                    'ReplyTo',
                    'SenderType',
                    'SenderTypeID',
                    'Subject',
                    'To',
                ],
                'RequestDynamicFieldsArticle' => [],
                'RequestDynamicFieldsTicket'  => [
                    'DynamicField' . $RandomID,
                ],
                'RequestTicketFields' => [
                    'ArchiveFlag',
                    'ChangeBy',
                    'Changed',
                    'CreateBy',
                    'Created',
                    'CreateTimeUnix',
                    'CustomerUser',
                    'CustomerUserID',
                    'Lock',
                    'LockID',
                    'Owner',
                    'OwnerID',
                    'Priority',
                    'PriorityID',
                    'Queue',
                    'QueueID',
                    'Responsible',
                    'ResponsibleID',
                    'State',
                    'StateID',
                    'StateType',
                    'TicketID',
                    'TicketNumber',
                    'Title',
                    'Type',
                    'TypeID',
                ],
            },
        },
        TicketUpdate => {
            ExpectedInvokerPrepareRequestResult => {
                'Article' => {
                    'ArticleID'    => $Article{ArticleID},
                    'Body'         => $Article{Body},
                    'Cc'           => $Article{Cc},
                    'Charset'      => 'utf8',                        # modified explicitly in invoker
                    'ContentType'  => 'text/plain; charset=utf8',    # modified explicitly in invoker
                    'InReplyTo'    => $Article{InReplyTo},
                    'IncomingTime' => $Article{IncomingTime},
                    'MessageID'    => $Article{MessageID},
                    'From'         => $Article{From},
                    'MimeType'     => $Article{MimeType},
                    'References'   => $Article{References},
                    'ReplyTo'      => $Article{ReplyTo},
                    'SenderType'   => $Article{SenderType},
                    'SenderTypeID' => $Article{SenderTypeID},
                    'Subject'      => $Article{Subject},
                    'To'           => $Article{To},
                },
                'Attachment' => [
                    {
                        'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                        'ContentType' => 'text/html; charset="utf8"',
                        'Disposition' => 'attachment',
                        'FileID'      => 1,
                        'Filename'    => 'test.txt',
                        'FilesizeRaw' => '39',
                        'MimeType'    => 'text/html',
                    }
                ],
                'DynamicField' => [
                    {
                        'Name'  => 'DynamicField' . $RandomID,
                        'Value' => 'test',
                    }
                ],
                'Ticket' => {
                    'ArchiveFlag' => $Ticket{ArchiveFlag},
                    'Article'     => [
                        {
                            'ArticleID'  => $Article{ArticleID},
                            'Attachment' => [
                                {
                                    'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                                    'ContentType' => 'text/html; charset="utf8"',
                                    'Disposition' => 'attachment',
                                    'FileID'      => 1,
                                    'Filename'    => 'test.txt',
                                    'FilesizeRaw' => '39',
                                    'MimeType'    => 'text/html',
                                },
                            ],
                            'Body'         => $Article{Body},
                            'Cc'           => $Article{Cc},
                            'Charset'      => 'utf8',
                            'ContentType'  => 'text/plain; charset=utf8',    # modified explicitly in invoker
                            'InReplyTo'    => $Article{InReplyTo},
                            'IncomingTime' => $Article{IncomingTime},
                            'MessageID'    => $Article{MessageID},
                            'From'         => $Article{From},
                            'MimeType'     => $Article{MimeType},
                            'References'   => $Article{References},
                            'ReplyTo'      => $Article{ReplyTo},
                            'SenderType'   => $Article{SenderType},
                            'SenderTypeID' => $Article{SenderTypeID},
                            'Subject'      => $Article{Subject},
                            'To'           => $Article{To},
                        },
                    ],
                    'ChangeBy'       => $Ticket{ChangeBy},
                    'Changed'        => $Ticket{Changed},
                    'CreateBy'       => $Ticket{CreateBy},
                    'Created'        => $Ticket{Created},
                    'CustomerUser'   => $UserID,
                    'CustomerUserID' => $Ticket{CustomerUserID},
                    'DynamicField'   => [
                        {
                            'Name'  => 'DynamicField' . $RandomID,
                            'Value' => 'test',
                        }
                    ],
                    'Lock'          => $Ticket{Lock},
                    'LockID'        => $Ticket{LockID},
                    'Owner'         => $Ticket{Owner},
                    'OwnerID'       => $Ticket{OwnerID},
                    'Priority'      => $Ticket{Priority},
                    'PriorityID'    => $Ticket{PriorityID},
                    'Queue'         => $Ticket{Queue},
                    'QueueID'       => $Ticket{QueueID},
                    'Responsible'   => $Ticket{Responsible},
                    'ResponsibleID' => $Ticket{ResponsibleID},
                    'State'         => $Ticket{State},
                    'StateID'       => $Ticket{StateID},
                    'StateType'     => $Ticket{StateType},
                    'TicketID'      => $Ticket{TicketID},
                    'TicketNumber'  => $Ticket{TicketNumber},
                    'Title'         => $Ticket{Title},
                    'Type'          => $Ticket{Type},
                    'TypeID'        => $Ticket{TypeID},

                },
                'TicketID'     => $Ticket{TicketID},
                'TicketNumber' => $Ticket{TicketNumber},
            },
        },
    },
    {
        Name             => 'Testcase 3',
        WebserviceUpdate => {
            TicketUpdate => {
                'RequestArticleFields'        => [],
                'RequestDynamicFieldsArticle' => [],
                'RequestDynamicFieldsTicket'  => [],
                'RequestTicketFields'         => [],
            },
        },
        TicketUpdate => {
            ExpectedInvokerPrepareRequestResult => {
                'Article'    => {},
                'Attachment' => [
                    {
                        'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                        'ContentType' => 'text/html; charset="utf8"',
                        'Disposition' => 'attachment',
                        'FileID'      => 1,
                        'Filename'    => 'test.txt',
                        'FilesizeRaw' => '39',
                        'MimeType'    => 'text/html',
                    }
                ],
                'Ticket' => {
                    'Article' => [
                        {},
                    ],
                },
                'TicketID'     => $Ticket{TicketID},
                'TicketNumber' => $Ticket{TicketNumber},
            },
        },
    },
    {
        Name             => 'Testcase 4',
        WebserviceUpdate => {
            TicketCreate => {
                'TicketIdToDynamicField' => 'DynamicField' . $RandomID,
                'RequestArticleFields'   => [
                    'ArticleID',
                    'Attachment',
                    'Body',
                    'Cc',
                    'Charset',
                    'ContentType',
                    'From',
                    'IncomingTime',
                    'InReplyTo',
                    'MessageID',
                    'MimeType',
                    'References',
                    'ReplyTo',
                    'SenderType',
                    'SenderTypeID',
                    'Subject',
                    'To',
                    'TimeUnit',
                ],
                'RequestDynamicFieldsArticle' => [],
                'RequestDynamicFieldsTicket'  => [
                    'DynamicField' . $RandomID,
                ],
                'RequestTicketFields' => [
                    'ArchiveFlag',
                    'ChangeBy',
                    'Changed',
                    'CreateBy',
                    'Created',
                    'CreateTimeUnix',
                    'CustomerUser',
                    'CustomerUserID',
                    'Lock',
                    'LockID',
                    'Owner',
                    'OwnerID',
                    'Priority',
                    'PriorityID',
                    'Queue',
                    'QueueID',
                    'Responsible',
                    'ResponsibleID',
                    'State',
                    'StateID',
                    'StateType',
                    'TicketID',
                    'TicketNumber',
                    'Title',
                    'Type',
                    'TypeID',
                ],
            },
        },
        TicketCreate => {
            ExpectedInvokerPrepareRequestResult => {
                'Article' => {
                    'ArticleID'    => $Article{ArticleID},
                    'Body'         => $Article{Body},
                    'Cc'           => $Article{Cc},
                    'Charset'      => 'utf8',                        # modified explicitly in invoker
                    'ContentType'  => 'text/plain; charset=utf8',    # modified explicitly in invoker
                    'InReplyTo'    => $Article{InReplyTo},
                    'IncomingTime' => $Article{IncomingTime},
                    'MessageID'    => $Article{MessageID},
                    'From'         => $Article{From},
                    'MimeType'     => $Article{MimeType},
                    'References'   => $Article{References},
                    'ReplyTo'      => $Article{ReplyTo},
                    'SenderType'   => $Article{SenderType},
                    'SenderTypeID' => $Article{SenderTypeID},
                    'Subject'      => $Article{Subject},
                    'To'           => $Article{To},
                    'TimeUnit'     => $AccountedTime,
                },
                'Attachment' => [
                    {
                        'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                        'ContentType' => 'text/html; charset="utf8"',
                        'Disposition' => 'attachment',
                        'FileID'      => 1,
                        'Filename'    => 'test.txt',
                        'FilesizeRaw' => '39',
                        'MimeType'    => 'text/html',
                    }
                ],
                'DynamicField' => [
                    {
                        'Name'  => 'DynamicField' . $RandomID,
                        'Value' => 'test',
                    }
                ],
                'Ticket' => {
                    'ArchiveFlag' => $Ticket{ArchiveFlag},
                    'Article'     => [
                        {
                            'ArticleID'  => $Article{ArticleID},
                            'Attachment' => [
                                {
                                    'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                                    'ContentType' => 'text/html; charset="utf8"',
                                    'Disposition' => 'attachment',
                                    'FileID'      => 1,
                                    'Filename'    => 'test.txt',
                                    'FilesizeRaw' => '39',
                                    'MimeType'    => 'text/html',
                                },
                            ],
                            'Body'         => $Article{Body},
                            'Cc'           => $Article{Cc},
                            'Charset'      => 'utf8',
                            'ContentType'  => 'text/plain; charset=utf8',    # modified explicitly in invoker
                            'InReplyTo'    => $Article{InReplyTo},
                            'IncomingTime' => $Article{IncomingTime},
                            'MessageID'    => $Article{MessageID},
                            'From'         => $Article{From},
                            'MimeType'     => $Article{MimeType},
                            'References'   => $Article{References},
                            'ReplyTo'      => $Article{ReplyTo},
                            'SenderType'   => $Article{SenderType},
                            'SenderTypeID' => $Article{SenderTypeID},
                            'Subject'      => $Article{Subject},
                            'To'           => $Article{To},
                            'TimeUnit'     => $AccountedTime,
                        },
                    ],
                    'ChangeBy'       => $Ticket{ChangeBy},
                    'Changed'        => $Ticket{Changed},
                    'CreateBy'       => $Ticket{CreateBy},
                    'Created'        => $Ticket{Created},
                    'CustomerUser'   => $UserID,
                    'CustomerUserID' => $Ticket{CustomerUserID},
                    'DynamicField'   => [
                        {
                            'Name'  => 'DynamicField' . $RandomID,
                            'Value' => 'test',
                        }
                    ],
                    'Lock'          => $Ticket{Lock},
                    'LockID'        => $Ticket{LockID},
                    'Owner'         => $Ticket{Owner},
                    'OwnerID'       => $Ticket{OwnerID},
                    'Priority'      => $Ticket{Priority},
                    'PriorityID'    => $Ticket{PriorityID},
                    'Queue'         => $Ticket{Queue},
                    'QueueID'       => $Ticket{QueueID},
                    'Responsible'   => $Ticket{Responsible},
                    'ResponsibleID' => $Ticket{ResponsibleID},
                    'State'         => $Ticket{State},
                    'StateID'       => $Ticket{StateID},
                    'StateType'     => $Ticket{StateType},
                    'TicketID'      => $Ticket{TicketID},
                    'TicketNumber'  => $Ticket{TicketNumber},
                    'Title'         => $Ticket{Title},
                    'Type'          => $Ticket{Type},
                    'TypeID'        => $Ticket{TypeID},

                },
                'TicketID'     => $Ticket{TicketID},
                'TicketNumber' => $Ticket{TicketNumber},
            },
        },
    },
    {
        Name             => 'Testcase 5',
        WebserviceUpdate => {
            TicketUpdate => {
                'TicketIdToDynamicField' => 'DynamicField' . $RandomID,
                'RequestArticleFields'   => [
                    'ArticleID',
                    'Attachment',
                    'Body',
                    'Cc',
                    'Charset',
                    'ContentType',
                    'From',
                    'IncomingTime',
                    'InReplyTo',
                    'MessageID',
                    'MimeType',
                    'References',
                    'ReplyTo',
                    'SenderType',
                    'SenderTypeID',
                    'Subject',
                    'To',
                    'TimeUnit',
                ],
                'RequestDynamicFieldsArticle' => [],
                'RequestDynamicFieldsTicket'  => [
                    'DynamicField' . $RandomID,
                ],
                'RequestTicketFields' => [
                    'ArchiveFlag',
                    'ChangeBy',
                    'Changed',
                    'CreateBy',
                    'Created',
                    'CreateTimeUnix',
                    'CustomerUser',
                    'CustomerUserID',
                    'Lock',
                    'LockID',
                    'Owner',
                    'OwnerID',
                    'Priority',
                    'PriorityID',
                    'Queue',
                    'QueueID',
                    'Responsible',
                    'ResponsibleID',
                    'State',
                    'StateID',
                    'StateType',
                    'TicketID',
                    'TicketNumber',
                    'Title',
                    'Type',
                    'TypeID',
                ],
            },
        },
        TicketUpdate => {
            ExpectedInvokerPrepareRequestResult => {
                'Article' => {
                    'ArticleID'    => $Article{ArticleID},
                    'Body'         => $Article{Body},
                    'Cc'           => $Article{Cc},
                    'Charset'      => 'utf8',                        # modified explicitly in invoker
                    'ContentType'  => 'text/plain; charset=utf8',    # modified explicitly in invoker
                    'InReplyTo'    => $Article{InReplyTo},
                    'IncomingTime' => $Article{IncomingTime},
                    'MessageID'    => $Article{MessageID},
                    'From'         => $Article{From},
                    'MimeType'     => $Article{MimeType},
                    'References'   => $Article{References},
                    'ReplyTo'      => $Article{ReplyTo},
                    'SenderType'   => $Article{SenderType},
                    'SenderTypeID' => $Article{SenderTypeID},
                    'Subject'      => $Article{Subject},
                    'To'           => $Article{To},
                    'TimeUnit'     => $AccountedTime,
                },
                'Attachment' => [
                    {
                        'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                        'ContentType' => 'text/html; charset="utf8"',
                        'Disposition' => 'attachment',
                        'FileID'      => 1,
                        'Filename'    => 'test.txt',
                        'FilesizeRaw' => '39',
                        'MimeType'    => 'text/html',
                    }
                ],
                'DynamicField' => [
                    {
                        'Name'  => 'DynamicField' . $RandomID,
                        'Value' => 'test',
                    }
                ],
                'Ticket' => {
                    'ArchiveFlag' => $Ticket{ArchiveFlag},
                    'Article'     => [
                        {
                            'ArticleID'  => $Article{ArticleID},
                            'Attachment' => [
                                {
                                    'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                                    'ContentType' => 'text/html; charset="utf8"',
                                    'Disposition' => 'attachment',
                                    'Filename'    => 'test.txt',
                                    'FileID'      => 1,
                                    'FilesizeRaw' => '39',
                                    'MimeType'    => 'text/html',
                                },
                            ],
                            'Body'         => $Article{Body},
                            'Cc'           => $Article{Cc},
                            'Charset'      => 'utf8',
                            'ContentType'  => 'text/plain; charset=utf8',    # modified explicitly in invoker
                            'InReplyTo'    => $Article{InReplyTo},
                            'IncomingTime' => $Article{IncomingTime},
                            'MessageID'    => $Article{MessageID},
                            'From'         => $Article{From},
                            'MimeType'     => $Article{MimeType},
                            'References'   => $Article{References},
                            'ReplyTo'      => $Article{ReplyTo},
                            'SenderType'   => $Article{SenderType},
                            'SenderTypeID' => $Article{SenderTypeID},
                            'Subject'      => $Article{Subject},
                            'To'           => $Article{To},
                            'TimeUnit'     => $AccountedTime,
                        },
                    ],
                    'ChangeBy'       => $Ticket{ChangeBy},
                    'Changed'        => $Ticket{Changed},
                    'CreateBy'       => $Ticket{CreateBy},
                    'Created'        => $Ticket{Created},
                    'CustomerUser'   => $UserID,
                    'CustomerUserID' => $Ticket{CustomerUserID},
                    'DynamicField'   => [
                        {
                            'Name'  => 'DynamicField' . $RandomID,
                            'Value' => 'test',
                        }
                    ],
                    'Lock'          => $Ticket{Lock},
                    'LockID'        => $Ticket{LockID},
                    'Owner'         => $Ticket{Owner},
                    'OwnerID'       => $Ticket{OwnerID},
                    'Priority'      => $Ticket{Priority},
                    'PriorityID'    => $Ticket{PriorityID},
                    'Queue'         => $Ticket{Queue},
                    'QueueID'       => $Ticket{QueueID},
                    'Responsible'   => $Ticket{Responsible},
                    'ResponsibleID' => $Ticket{ResponsibleID},
                    'State'         => $Ticket{State},
                    'StateID'       => $Ticket{StateID},
                    'StateType'     => $Ticket{StateType},
                    'TicketID'      => $Ticket{TicketID},
                    'TicketNumber'  => $Ticket{TicketNumber},
                    'Title'         => $Ticket{Title},
                    'Type'          => $Ticket{Type},
                    'TypeID'        => $Ticket{TypeID},

                },
                'TicketID'     => $Ticket{TicketID},
                'TicketNumber' => $Ticket{TicketNumber},
            },
        },
    },
    {
        Name             => 'Testcase 6',
        WebserviceUpdate => {
            TicketCreate => {},
            TicketUpdate => {},
        },
        TestOTOBODynamicField => 1,
        TicketCreate          => {
            ExpectedInvokerPrepareRequestResult => {
                'Article' => {
                    'Body'                 => $Article{Body},
                    'Charset'              => 'utf8',
                    'CommunicationChannel' => 'Internal',
                    'ContentType'          => 'text/plain; charset=utf8',    # modified explicitly in invoker
                    'From'                 => $Article{From},
                    'MimeType'             => $Article{MimeType},
                    'SenderType'           => $Article{SenderType},
                    'Subject'              => $Article{Subject},
                    'TimeUnit'             => $AccountedTime,
                },
                'Attachment' => [
                    {
                        'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                        'ContentType' => 'text/html; charset="utf8"',
                        'Disposition' => 'attachment',
                        'FileID'      => 1,
                        'Filename'    => 'test.txt',
                        'FilesizeRaw' => '39',
                        'MimeType'    => 'text/html',
                    }
                ],
                'DynamicField' => [
                    {
                        'Name'  => 'DynamicField' . $RandomID,
                        'Value' => 'test',
                    },
                    {
                        "Name"  => "DynamicFieldAttachment$RandomID",
                        "Value" => [
                            {
                                "Content"     => "QXR0YWNobWVudCBjb250ZW50\n",
                                "ContentType" => "text/plain",
                                "Filename"    => "somefile.txt",
                                "FilesizeRaw" => 18,
                            },
                        ],
                    },
                ],
                'Ticket' => {
                    'Article' => [
                        {
                            'Attachment' => [
                                {
                                    'Content'     => 'Ymx1YiBibHViIGJsdWIgYmx1YiBibHViIGJsdWIgYmx1YiBibHVi' . "\n",
                                    'ContentType' => 'text/html; charset="utf8"',
                                    'Disposition' => 'attachment',
                                    'FileID'      => 1,
                                    'Filename'    => 'test.txt',
                                    'FilesizeRaw' => '39',
                                    'MimeType'    => 'text/html',
                                },
                            ],
                            'Body'                 => $Article{Body},
                            'Charset'              => 'utf8',
                            'CommunicationChannel' => 'Internal',
                            'ContentType'          => 'text/plain; charset=utf8',    # modified explicitly in invoker
                            'From'                 => $Article{From},
                            'MimeType'             => $Article{MimeType},
                            'SenderType'           => $Article{SenderType},
                            'Subject'              => $Article{Subject},
                            'TimeUnit'             => $AccountedTime,
                        },
                    ],
                    'CustomerUser' => $UserID,
                    'DynamicField' => [
                        {
                            'Name'  => 'DynamicField' . $RandomID,
                            'Value' => 'test',
                        },
                        {
                            "Name"  => "DynamicFieldAttachment$RandomID",
                            "Value" => [
                                {
                                    "Content"     => "QXR0YWNobWVudCBjb250ZW50\n",
                                    "ContentType" => "text/plain",
                                    "Filename"    => "somefile.txt",
                                    "FilesizeRaw" => 18,
                                },
                            ],
                        },
                    ],
                    'Lock'        => $Ticket{Lock},
                    'Owner'       => $Ticket{Owner},
                    'Priority'    => $Ticket{Priority},
                    'Queue'       => $Ticket{Queue},
                    'Responsible' => $Ticket{Responsible},
                    'State'       => $Ticket{State},
                    'Title'       => $Ticket{Title},
                    'Type'        => $Ticket{Type},
                },
                'TicketID'     => $Ticket{TicketID},
                'TicketNumber' => $Ticket{TicketNumber},
            },
        },
    },
);

# run the test cases
TEST:
for my $Test (@Tests) {
    if ( $Test->{TestOTOBODynamicField} && !$AttachmentDynamicFieldID ) {
        diag "Skipping '$Test->{Name}' as there is not attachment dynamic field";

        next TEST;
    }

    subtest $Test->{Name} => sub {

        if ( $Test->{WebserviceUpdate} ) {
            my $Webservice = $WebserviceObject->WebserviceGet(
                ID => $WebserviceID,
            );
            $Webservice->{Config}->{Requester}->{Invoker} = $Test->{WebserviceUpdate};
            $WebserviceObject->WebserviceUpdate(
                %{$Webservice},
                UserID => 1,
            );
        }

        my $DynamicFieldSuccess = $DFBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $TicketID,
            Value              => "test",
            UserID             => 1,
        );
        ok(
            $DynamicFieldSuccess,
            "Dynamic field 'DynamicField$RandomID' is set.",
        );

        if ( $Test->{TestOTOBODynamicField} ) {
            my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

            $FormID = $UploadCacheObject->FormIDCreate();

            my $UploadSuccess = $UploadCacheObject->FormIDAddFile(
                FormID      => $FormID,
                Filename    => 'somefile.txt',
                Content     => 'Attachment content',
                ContentType => 'text/plain',
                Disposition => 'inline',
            );

            ok(
                $UploadSuccess,
                'Attachment added to the upload cache.'
            );

            my $AttachmentDynamicFieldSuccess = $DFBackendObject->ValueSet(
                DynamicFieldConfig => $AttachmentDynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => {
                    FormID => $FormID,
                },
                UserID => 1,
            );
            ok(
                $AttachmentDynamicFieldSuccess,
                "Dynamic field 'DynamicFieldAttachemt$RandomID' is set.",
            );
        }

        INVOKERTYPE:
        for my $InvokerType (qw(TicketCreate TicketUpdate)) {
            next INVOKERTYPE unless $Test->{$InvokerType};

            my $InvokerObject = Kernel::GenericInterface::Invoker->new(
                DebuggerObject => $DebuggerObject,
                InvokerType    => "Ticket::$InvokerType",
                Invoker        => $InvokerType,
                WebserviceID   => $WebserviceID,
            );

            isa_ok(
                $InvokerObject,
                ['Kernel::GenericInterface::Invoker'],
                'InvokerObject was correctly instantiated',
            );

            my $InvokerResult = $InvokerObject->PrepareRequest(
                WebserviceID => $WebserviceID,
                Data         => {
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                },
            );

            ok(
                IsHashRefWithData($InvokerResult),
                "Invoker $InvokerType - Invoker PrepareRequest() return data is HASH",
            );

            ok(
                $InvokerResult->{Success},
                "Invoker $InvokerType - PrepareRequest() ok"
                    . (
                        $InvokerResult->{ErrorMessage}
                        ? "(Error: "
                        . $InvokerResult->{ErrorMessage} . ")"
                        : ""
                    ),
            );

            # check content of invoker result
            is(
                dclone( $InvokerResult->{Data} ),
                $Test->{$InvokerType}->{ExpectedInvokerPrepareRequestResult},
                "Invoker $InvokerType - Invoker PrepareRequest() return data matches expected result",
            );

            # create local object
            my $OperatorObject = "Kernel::GenericInterface::Operation::Ticket::$InvokerType"->new(
                DebuggerObject => $DebuggerObject,
                WebserviceID   => $WebserviceID,
            );

            isa_ok(
                $OperatorObject,
                ["Kernel::GenericInterface::Operation::Ticket::$InvokerType"],
                "OperatorObject - Create local object",
            );

            # create a new user for current test
            my $UserLogin = $HelperObject->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            );
            my $Password = $UserLogin;

            # Append FormID value to the Attachment Dynamic fields.
            for my $DynamicField ( @{ $InvokerResult->{Data}->{DynamicField} } ) {
                if ( $DynamicField->{Name} eq 'DynamicFieldAttachment' . $RandomID ) {

                    # Dynamic field type is attachment.
                    for my $Attachment ( @{ $DynamicField->{Value} } ) {
                        $Attachment->{FormID} = $FormID;
                    }
                }
            }

            my $OperatorResult = $OperatorObject->Run(
                WebserviceID => $WebserviceID,
                Invoker      => $InvokerType,
                Data         => {
                    TicketID  => $TicketID,
                    UserLogin => $UserLogin,
                    Password  => $Password,
                    %{ $InvokerResult->{Data} },
                },
            );

            ok(
                IsHashRefWithData($OperatorResult),
                "Operator $InvokerType - Invoker <--> Operation return data is HASH",
            );

            ok(
                $OperatorResult->{Success},
                "Operator $InvokerType - Invoker <--> Operation OK "
                    . (
                        $OperatorResult->{Errormessage}
                        ? "(Error: "
                        . $OperatorResult->{Errormessage} . ")"
                        : ""
                    ),
            );

            # set response dynamic field to invalid value in order to test invoker-based config
            if ( $Test->{WebserviceUpdate} && $Test->{WebserviceUpdate}->{$InvokerType}->{TicketIdToDynamicField} ) {
                $ConfigObject->Set(
                    Key   => 'GenericInterface::Invoker::Settings::ResponseDynamicField',
                    Value => {
                        $WebserviceID => 'DynamicField' . $RandomID . 'Invalid',
                    },
                );
            }

            $InvokerResult = $InvokerObject->HandleResponse(
                ResponseSuccess => 1,
                Data            => {
                    TicketID => $TicketID,
                },
            );

            # restore response dynamic field
            if ( $Test->{WebserviceUpdate} && $Test->{WebserviceUpdate}->{$InvokerType}->{TicketIdToDynamicField} ) {
                $ConfigObject->Set(
                    Key   => 'GenericInterface::Invoker::Settings::ResponseDynamicField',
                    Value => {
                        $WebserviceID => 'DynamicField' . $RandomID,
                    },
                );
            }

            ok(
                IsHashRefWithData($InvokerResult),
                "Operator $InvokerType - Invoker HandleResponse() return data is HASH",
            );

            ok(
                $InvokerResult->{Success},
                "Invoker $InvokerType - HandleResponse() ok"
                    . (
                        $InvokerResult->{ErrorMessage}
                        ? "(Error: "
                        . $InvokerResult->{ErrorMessage} . ")"
                        : ""
                    ),
            );
        }
    };
}

# cleanup is done by RestoreDatabase
done_testing();
