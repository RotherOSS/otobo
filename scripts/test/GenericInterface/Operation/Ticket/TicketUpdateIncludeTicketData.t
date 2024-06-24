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
use Kernel::System::UnitTest::RegisterOM;                                   # Set up $Kernel::OM
use Kernel::GenericInterface::Debugger                          ();
use Kernel::GenericInterface::Operation::Session::SessionCreate ();         ## no perlimports, new() from string
use Kernel::GenericInterface::Operation::Ticket::TicketUpdate   ();         ## no perlimports, new() from string
use Kernel::GenericInterface::Requester                         ();
use Kernel::System::VariableCheck                               qw(:all);

# get helper object
# skip SSL certificate verification
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get a random number
my $RandomID = $Helper->GetRandomNumber;

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => ['users'],
);
my $Password = $UserLogin;

# new user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');
my $UserID     = $UserObject->UserLookup(
    UserLogin => $UserLogin,
);

# create a new user without permissions for current test
# TODO: why do we need a second user?
my $UserLogin2 = $Helper->TestUserCreate();
my $Password2  = $UserLogin2;

# create a customer where a ticket will use and will have permissions
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();
my $CustomerPassword  = $CustomerUserLogin;

# create a customer that will not have permissions
# TODO: why do we need a second customer user?
my $CustomerUserLogin2 = $Helper->TestCustomerUserCreate();
my $CustomerPassword2  = $CustomerUserLogin2;

# create dynamic field object
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

# add text dynamic field
my %DynamicFieldTextConfig = (
    Name       => "Unittest1$RandomID",
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'Ticket',
    Label      => 'Description',
    ValidID    => 1,
    Config     => {
        DefaultValue => '',
    },
);
my $FieldTextID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldTextConfig,
    UserID  => 1,
    Reorder => 0,
);
ok( $FieldTextID, "Dynamic Field $FieldTextID" );

# add ID
$DynamicFieldTextConfig{ID} = $FieldTextID;

# add dropdown dynamic field
my %DynamicFieldDropdownConfig = (
    Name       => "Unittest2$RandomID",
    FieldOrder => 9992,
    FieldType  => 'Dropdown',
    ObjectType => 'Ticket',
    Label      => 'Description',
    ValidID    => 1,
    Config     => {
        PossibleValues => {
            1 => 'One',
            2 => 'Two',
            3 => 'Three',
        },
    },
);
my $FieldDropdownID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldDropdownConfig,
    UserID  => 1,
    Reorder => 0,
);
ok( $FieldDropdownID, "Dynamic Field $FieldDropdownID" );

# add ID
$DynamicFieldDropdownConfig{ID} = $FieldDropdownID;

# add multiselect dynamic field
my %DynamicFieldMultiselectConfig = (
    Name       => "Unittest3$RandomID",
    FieldOrder => 9993,
    FieldType  => 'Multiselect',
    ObjectType => 'Ticket',
    Label      => 'Multiselect label',
    ValidID    => 1,
    Config     => {
        PossibleValues => {
            1 => 'Value9ßüß',
            2 => 'DifferentValue',
            3 => '1234567',
        },
    },
);
my $FieldMultiselectID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldMultiselectConfig,
    UserID  => 1,
    Reorder => 0,
);
ok( $FieldMultiselectID, "Dynamic Field $FieldMultiselectID" );

# add ID
$DynamicFieldMultiselectConfig{ID} = $FieldMultiselectID;

# add text dynamic field for article type
my %ArticleDynamicFieldTextConfig = (
    Name       => "Unittest4$RandomID",
    FieldOrder => 9994,
    FieldType  => 'Text',
    ObjectType => 'Article',
    Label      => 'Description',
    ValidID    => 1,
    Config     => {
        DefaultValue => '',
    },
);
my $ArticleFieldTextID = $DynamicFieldObject->DynamicFieldAdd(
    %ArticleDynamicFieldTextConfig,
    UserID  => 1,
    Reorder => 0,
);
ok( $ArticleFieldTextID, "Dynamic Field $FieldTextID" );

# add ID
$ArticleDynamicFieldTextConfig{ID} = $ArticleFieldTextID;

# create ticket object
my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

#ticket id container
my @TicketIDs;

# create ticket 1
my $TicketID1 = $TicketObject->TicketCreate(
    Title        => 'Ticket One Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $CustomerUserLogin,
    CustomerUser => 'unittest@otobo.org',
    OwnerID      => 1,
    UserID       => 1,
);

# sanity check
ok( $TicketID1, "TicketCreate() successful for Ticket One ID $TicketID1", );

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID1,
    UserID   => 1,
);

# remember ticket id
push @TicketIDs, $TicketID1;

# create backed object
my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
isa_ok(
    $BackendObject,
    ['Kernel::System::DynamicField::Backend'],
    'Backend object was created successfully',
);

# set text field value
my $Result = $BackendObject->ValueSet(
    DynamicFieldConfig => \%DynamicFieldTextConfig,
    ObjectID           => $TicketID1,
    Value              => 'ticket1_field1',
    UserID             => 1,
);

# sanity check
ok( $Result, "Text ValueSet() for Ticket $TicketID1", );

# set dropdown field value
$Result = $BackendObject->ValueSet(
    DynamicFieldConfig => \%DynamicFieldDropdownConfig,
    ObjectID           => $TicketID1,
    Value              => 1,
    UserID             => 1,
);

# sanity check
ok( $Result, "Multiselect ValueSet() for Ticket $TicketID1", );

# set multiselect field value
$Result = $BackendObject->ValueSet(
    DynamicFieldConfig => \%DynamicFieldMultiselectConfig,
    ObjectID           => $TicketID1,
    Value              => [ 2, 3 ],
    UserID             => 1,
);

# sanity check
ok( $Result, "Dropdown ValueSet() for Ticket $TicketID1", );

# set web service name
my $WebserviceName = $Helper->GetRandomID;

# create web-service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

isa_ok(
    $WebserviceObject,
    ['Kernel::System::GenericInterface::Webservice'],
    "Create web service object",
);

my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Name   => $WebserviceName,
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
        Provider => {
            Transport => {
                Type => '',
            },
        },
    },
    ValidID => 1,
    UserID  => 1,
);
ok( $WebserviceID, "Added web service" );

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web-service config
my $RemoteSystem =
    $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . 'nph-genericinterface.pl/WebserviceID/'
    . $WebserviceID;

my $WebserviceConfig = {

    #    Name => '',
    Description =>
        'Test for Ticket Connector using SOAP transport backend.',
    Debugger => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    Provider => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                MaxLength => 10000000,
                NameSpace => 'http://otobo.org/SoapTestInterface/',
                Endpoint  => $RemoteSystem,
            },
        },
        Operation => {
            TicketUpdate => {
                Type              => 'Ticket::TicketUpdate',
                IncludeTicketData => '1',
            },
            SessionCreate => {
                Type => 'Session::SessionCreate',
            },
        },
    },
    Requester => {
        Transport => {
            Type   => 'HTTP::SOAP',
            Config => {
                NameSpace => 'http://otobo.org/SoapTestInterface/',
                Encoding  => 'UTF-8',
                Endpoint  => $RemoteSystem,
                Timeout   => 120,
            },
        },
        Invoker => {
            TicketUpdate => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web-service with real config
# the update is needed because we are using
# the WebserviceID for the Endpoint in config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => $UserID,
);
ok( $WebserviceUpdate, "Updated web service $WebserviceID - $WebserviceName", );

# disable SessionCheckRemoteIP setting
$ConfigObject->Set(
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
isa_ok(
    $RequesterSessionObject,
    ['Kernel::GenericInterface::Requester'],
    "SessionID - Create requester object",
);

# start requester with our web-service
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};

my @Tests = (

    {
        Name           => 'Check Ticket Data',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => $Ticket{Title},
            },
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title => $Ticket{Title},
                }
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title => $Ticket{Title},
                }
            },
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Check Ticket Data (With Article)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => $Ticket{Title},
            },
            Article => {
                Subject     => 'someSubject',
                Body        => 'someBody',
                ContentType => 'text/plain; charset=utf8',
                TimeUnit    => 1,
            },
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title   => $Ticket{Title},
                    Article => {
                        Subject     => 'someSubject',
                        Body        => 'someBody',
                        ContentType => 'text/plain; charset=utf8',
                        TimeUnit    => 1,
                    },
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title   => $Ticket{Title},
                    Article => {
                        Subject     => 'someSubject',
                        Body        => 'someBody',
                        ContentType => 'text/plain; charset=utf8',
                        TimeUnit    => 1,
                    },
                },
            },
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Check Ticket Data (With DynamicField)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => $Ticket{Title},
            },
            Article => {
                Subject     => 'someSubject',
                Body        => 'someBody',
                ContentType => 'text/plain; charset=utf8',
                TimeUnit    => 1,
            },
            DynamicField => [
                {
                    Name  => "Unittest1$RandomID",
                    Value => 'Value9ßüß-カスタ1234',
                },
                {
                    Name  => "Unittest2$RandomID",
                    Value => '2',
                },
                {
                    Name  => "Unittest3$RandomID",
                    Value => [ 1, 2 ],
                },
            ],
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title   => $Ticket{Title},
                    Article => {
                        Subject     => 'someSubject',
                        Body        => 'someBody',
                        ContentType => 'text/plain; charset=utf8',
                        TimeUnit    => 1,
                    },
                    DynamicField => [
                        {
                            Name  => "Unittest1$RandomID",
                            Value => 'Value9ßüß-カスタ1234',
                        },
                        {
                            Name  => "Unittest2$RandomID",
                            Value => '2',
                        },
                        {
                            Name  => "Unittest3$RandomID",
                            Value => [ 1, 2 ],
                        },
                    ],
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title   => $Ticket{Title},
                    Article => {
                        Subject     => 'someSubject',
                        Body        => 'someBody',
                        ContentType => 'text/plain; charset=utf8',
                        TimeUnit    => 1,
                    },
                    DynamicField => [
                        {
                            Name  => "Unittest1$RandomID",
                            Value => 'Value9ßüß-カスタ1234',
                        },
                        {
                            Name  => "Unittest2$RandomID",
                            Value => '2',
                        },
                        {
                            Name  => "Unittest3$RandomID",
                            Value => [ 1, 2 ],
                        },
                    ],
                },
            },
        },
        Operation => 'TicketUpdate',
    },

    {
        Name           => 'Check Ticket Data (With DynamicField, type article)',
        SuccessRequest => '1',
        RequestData    => {
            TicketID => $TicketID1,
            Ticket   => {
                Title => $Ticket{Title},
            },
            Article => {
                Subject     => 'someSubject',
                Body        => 'someBody',
                ContentType => 'text/plain; charset=utf8',
                TimeUnit    => 1,
            },
            DynamicField => [
                {
                    Name  => "Unittest4$RandomID",
                    Value => 'Value-ArticleField',
                },
            ],
        },
        ExpectedReturnRemoteData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title   => $Ticket{Title},
                    Article => {
                        Subject     => 'someSubject',
                        Body        => 'someBody',
                        ContentType => 'text/plain; charset=utf8',
                        TimeUnit    => 1,
                    },
                    DynamicField => [
                        {
                            Name  => "Unittest4$RandomID",
                            Value => 'Value-ArticleField',
                        },
                    ],
                },
            },
        },
        ExpectedReturnLocalData => {
            Success => 1,
            Data    => {
                TicketID     => $Ticket{TicketID},
                TicketNumber => $Ticket{TicketNumber},
                Ticket       => {
                    Title   => $Ticket{Title},
                    Article => {
                        Subject     => 'someSubject',
                        Body        => 'someBody',
                        ContentType => 'text/plain; charset=utf8',
                        TimeUnit    => 1,
                    },
                    DynamicField => [
                        {
                            Name  => "Unittest4$RandomID",
                            Value => 'Value-ArticleField',
                        },
                    ],
                },
            },
        },
        Operation => 'TicketUpdate',
    },

);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    UserID         => $UserID,
    DebuggerConfig => {
        DebugThreshold => 'debug',
        TestMode       => 1,
    },
    WebserviceID      => $WebserviceID,
    CommunicationType => 'Provider',
);
isa_ok(
    $DebuggerObject,
    ['Kernel::GenericInterface::Debugger'],
    'DebuggerObject instantiate correctly',
);

for my $Test (@Tests) {

    # create local object
    my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
        DebuggerObject => $DebuggerObject,
        WebserviceID   => $WebserviceID,
        Operation      => $Test->{Operation},
    );

    isa_ok(
        $LocalObject,
        ["Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"],
        "$Test->{Name} - Create local object",
    );

    my %Auth = (
        UserLogin => $UserLogin,
        Password  => $Password,
    );
    if ( IsHashRefWithData( $Test->{Auth} ) ) {
        %Auth = %{ $Test->{Auth} };
    }

    # start requester with our web-service
    my $LocalResult = $LocalObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    ref_ok(
        $LocalResult,
        'HASH',
        "$Test->{Name} - Local result structure is valid",
    );

    # create requester object
    my $RequesterObject = Kernel::GenericInterface::Requester->new(
        UserID       => $UserID,
        ConfigObject => $ConfigObject,
    );
    isa_ok(
        $RequesterObject,
        ['Kernel::GenericInterface::Requester'],
        "$Test->{Name} - Create requester object",
    );

    # start requester with our web-service
    my $RequesterResult = $RequesterObject->Run(
        WebserviceID => $WebserviceID,
        Invoker      => $Test->{Operation},
        Data         => {
            %Auth,
            %{ $Test->{RequestData} },
        },
    );

    # check result
    ref_ok(
        $RequesterResult,
        'HASH',
        "$Test->{Name} - Requester result structure is valid",
    );

    is(
        $RequesterResult->{Success},
        $Test->{SuccessRequest},
        "$Test->{Name} - Requester successful result",
    );

    # remove ErrorMessage parameter from direct call
    # result to be consistent with SOAP call result
    if ( $LocalResult->{ErrorMessage} ) {
        delete $LocalResult->{ErrorMessage};
    }

    if ( !$LocalResult->{Data}->{Error} ) {
        ok(
            $LocalResult->{Data}->{Ticket},
            "$Test->{Name} - Local result TicketData with True.",
        );
    }

    if ( !$RequesterResult->{Data}->{Error} ) {
        ok(
            $RequesterResult->{Data}->{Ticket},
            "$Test->{Name} - Local result TicketData with True.",
        );
    }

    my $RequestResultFound = IsHashRefWithData( $RequesterResult->{Data}->{Ticket} ) ? 1 : 0;
    is(
        $RequestResultFound,
        1,
        "$Test->{Name} - RequesterResult includes ticket data.",
    );

    my $LocalResultFound = IsHashRefWithData( $Test->{ExpectedReturnLocalData}->{Data}->{Ticket} ) ? 1 : 0;
    is(
        $LocalResultFound,
        1,
        "$Test->{Name} - LocalResult includes ticket data.",
    );

    my $RequestResultKey            = $RequesterResult->{Data}->{Ticket};
    my $ExpectedReturnRemoteDataKey = $Test->{ExpectedReturnRemoteData}->{Data}->{Ticket};

    # check several ticket data
    is(
        $RequestResultKey->{Title},
        $ExpectedReturnRemoteDataKey->{Title},
        "$Test->{Name} - RequesterResult Ticket title Ok.",
    );

    # check several article data
    if ( $ExpectedReturnRemoteDataKey->{Article} ) {
        is(
            $RequestResultKey->{Article}->{Body},
            $ExpectedReturnRemoteDataKey->{Article}->{Body},
            "$Test->{Name} - RequesterResult Article Body Ok.",
        );

        is(
            $RequestResultKey->{Article}->{Subject},
            $ExpectedReturnRemoteDataKey->{Article}->{Subject},
            "$Test->{Name} - RequesterResult Article Subject Ok.",
        );

        if ( IsArrayRefWithData( $RequestResultKey->{Article}->{DynamicField} ) ) {
            for my $Field ( @{ $RequestResultKey->{Article}->{DynamicField} } ) {
                my $Matched = 0;
                if ( $ExpectedReturnRemoteDataKey->{DynamicField}->[0]->{Value} eq $Field->{Value} ) {
                    $Matched = 1;

                    is(
                        $Matched,
                        1,
                        "$Test->{Name} - RequesterResult Article DynamicField Ok.",
                    );
                }
            }
        }
    }

    # check DynamicField
    if ( $ExpectedReturnRemoteDataKey->{DynamicField} ) {
        ok(
            $RequestResultKey->{DynamicField},
            "$Test->{Name} - RequesterResult Ticket DynamicField Ok.",
        );
    }

    my $LocalResultKey             = $LocalResult->{Data}->{Ticket};
    my $ExpectedReturnLocalDataKey = $Test->{ExpectedReturnLocalData}->{Data}->{Ticket};

    # check several ticket data
    is(
        $LocalResultKey->{Title},
        $ExpectedReturnLocalDataKey->{Title},
        "$Test->{Name} - LocalResult Ticket title Ok.",
    );

    # check several article data
    if ( $ExpectedReturnLocalDataKey->{Article} ) {
        is(
            $LocalResultKey->{Article}->{Body},
            $ExpectedReturnLocalDataKey->{Article}->{Body},
            "$Test->{Name} - LocalResult Article Body Ok.",
        );

        is(
            $LocalResultKey->{Article}->{Subject},
            $ExpectedReturnLocalDataKey->{Article}->{Subject},
            "$Test->{Name} - LocalResult Article Subject Ok.",
        );

        if ( IsArrayRefWithData( $LocalResultKey->{Article}->{DynamicField} ) ) {
            for my $Field ( @{ $LocalResultKey->{Article}->{DynamicField} } ) {
                my $Matched = 0;
                if ( $ExpectedReturnLocalDataKey->{DynamicField}->[0]->{Value} eq $Field->{Value} ) {
                    $Matched = 1;

                    is(
                        $Matched,
                        1,
                        "$Test->{Name} - LocalResult Article DynamicField Ok.",
                    );
                }
            }
        }
    }

    # check DynamicField
    if ( $ExpectedReturnLocalDataKey->{DynamicField} ) {
        ok(
            $LocalResultKey->{DynamicField},
            "$Test->{Name} - LocalResult Ticket DynamicField Ok.",
        );
    }
}

# cleanup

# delete web-service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => $UserID,
);
ok(
    $WebserviceDelete,
    "Deleted web service $WebserviceID",
);

# delete tickets
for my $TicketID (@TicketIDs) {
    my $TicketDelete = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => $UserID,
    );

    # sanity check
    ok(
        $TicketDelete,
        "TicketDelete() successful for Ticket ID $TicketID",
    );
}

# delete dynamic fields
my $DeleteFieldList = $DynamicFieldObject->DynamicFieldList(
    ResultType => 'HASH',
    ObjectType => 'Ticket',
);

DYNAMICFIELD:
for my $DynamicFieldID ( sort keys %{$DeleteFieldList} ) {

    next DYNAMICFIELD if !$DynamicFieldID;
    next DYNAMICFIELD if !$DeleteFieldList->{$DynamicFieldID};

    next DYNAMICFIELD if $DeleteFieldList->{$DynamicFieldID} !~ m{ ^Unittest }xms;

    $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp;

done_testing;
