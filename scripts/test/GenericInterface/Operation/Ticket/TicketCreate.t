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
use MIME::Base64 qw(encode_base64);

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM
use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Operation::Ticket::TicketCreate;
use Kernel::GenericInterface::Operation::Session::SessionCreate;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

# set up object attributes
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify     => 1,
        DisableAsyncCalls => 1,
    },
);

my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID();

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Type',
    Value => 1,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::AccountTime',
    Value => 1,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'Ticket::Frontend::NeedAccountedTime',
    Value => 1,
);

# disable DNS lookups
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckMXRecord',
    Value => 0,
);

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# disable SessionCheckRemoteIP setting
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SessionCheckRemoteIP',
    Value => 0,
);

# enable customer groups support
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'CustomerGroupSupport',
    Value => 1,
);

$Kernel::OM->ObjectsDiscard(
    Objects            => ['Kernel::Config'],
    ForcePackageReload => 1,
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# check if SSL Certificate verification is disabled
is(
    $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME},
    0,
    'Disabled SSL certificates verification in environment'
);

my $TestOwnerLogin        = $Helper->TestUserCreate();
my $TestResponsibleLogin  = $Helper->TestUserCreate();
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();
my $TestUserLogin         = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users', ],
);

my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my $OwnerID = $UserObject->UserLookup(
    UserLogin => $TestOwnerLogin,
);
my $ResponsibleID = $UserObject->UserLookup(
    UserLogin => $TestResponsibleLogin,
);
my $UserID = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

my $InvalidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( Valid => 'invalid' );

# sanity test
ok(
    defined $InvalidID,
    "ValidLookup() for 'invalid' should not be undef"
);

# get group object
my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

# create a new group
my $GroupID = $GroupObject->GroupAdd(
    Name    => 'TestSpecial' . $RandomID,
    Comment => 'comment describing the group',    # optional
    ValidID => 1,
    UserID  => 1,
);

my %GroupData = $GroupObject->GroupGet( ID => $GroupID );

# sanity check
ok(
    IsHashRefWithData( \%GroupData ),
    "GroupGet() - for testing group"
);

# create queue object
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

my @Queues;
my @QueueIDs;

my @QueueProperties = (
    {
        Name    => 'queue1' . $RandomID,
        GroupID => 1,
    },
    {
        Name    => 'queue2' . $RandomID,
        GroupID => $GroupID,
    }
);

# create queues
for my $QueueProperty (@QueueProperties) {
    my $QueueID = $QueueObject->QueueAdd(
        %{$QueueProperty},
        ValidID         => 1,
        SystemAddressID => 1,
        SalutationID    => 1,
        SignatureID     => 1,
        Comment         => 'Some comment',
        UserID          => 1,
    );

    # sanity check
    ok( $QueueID, "QueueAdd() - create testing queue" );

    my %QueueData = $QueueObject->QueueGet( ID => $QueueID );
    push @Queues,   \%QueueData;
    push @QueueIDs, $QueueData{QueueID};
}

# get type object
my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

# create new type
my $TypeID = $TypeObject->TypeAdd(
    Name    => 'TestType' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
ok( $TypeID, "TypeAdd() - create testing type" );

my %TypeData = $TypeObject->TypeGet(
    ID => $TypeID,
);

# sanity check
ok(
    IsHashRefWithData( \%TypeData ),
    "TypeGet() - for testing type"
);

# create service object
my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

# create new service
my $ServiceID = $ServiceObject->ServiceAdd(
    Name    => 'TestService' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
ok( $ServiceID, "ServiceAdd() - create testing service" );

my %ServiceData = $ServiceObject->ServiceGet(
    ServiceID => $ServiceID,
    UserID    => 1,
);

# sanity check
ok(
    IsHashRefWithData( \%ServiceData ),
    "ServiceGet() - for testing service"
);

# set service for the customer
$ServiceObject->CustomerUserServiceMemberAdd(
    CustomerUserLogin => $TestCustomerUserLogin,
    ServiceID         => $ServiceID,
    Active            => 1,
    UserID            => 1,
);

# create SLA object
my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

# create new SLA
my $SLAID = $SLAObject->SLAAdd(
    Name       => 'TestSLA' . $RandomID,
    ServiceIDs => [$ServiceID],
    ValidID    => 1,
    UserID     => 1,
);

# sanity check
ok( $SLAID, "SLAAdd() - create testing SLA" );

my %SLAData = $SLAObject->SLAGet(
    SLAID  => $SLAID,
    UserID => 1,
);

# sanity check
ok(
    IsHashRefWithData( \%SLAData ),
    "SLAGet() - for testing SLA"
);

# create state object
my $StateObject = $Kernel::OM->Get('Kernel::System::State');

# create new state
my $StateID = $StateObject->StateAdd(
    Name    => 'TestState' . $RandomID,
    TypeID  => 2,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
ok( $StateID, "StateAdd() - create testing state" );

my %StateData = $StateObject->StateGet(
    ID => $StateID,
);

# sanity check
ok(
    IsHashRefWithData( \%StateData ),
    "StateGet() - for testing state"
);

# create priority object
my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

# create new priority
my $PriorityID = $PriorityObject->PriorityAdd(
    Name    => 'TestPriority' . $RandomID,
    ValidID => 1,
    UserID  => 1,
);

# sanity check
ok( $PriorityID, "PriorityAdd() - create testing priority", );

my %PriorityData = $PriorityObject->PriorityGet(
    PriorityID => $PriorityID,
    UserID     => 1,
);

# sanity check
ok(
    IsHashRefWithData( \%PriorityData ),
    "PriorityGet() - for testing priority"
);

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
            0 => '0',
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

# add date-time dynamic field
my %DynamicFieldDateTimeConfig = (
    Name       => "Unittest4$RandomID",
    FieldOrder => 9994,
    FieldType  => 'DateTime',
    ObjectType => 'Ticket',
    Label      => 'Description',
    Config     => {
        DefaultValue  => 0,
        YearsInFuture => 0,
        YearsInPast   => 0,
        YearsPeriod   => 0,
    },
    ValidID => 1,
);
my $FieldDateTimeID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldDateTimeConfig,
    UserID  => 1,
    Reorder => 0,
);
ok( $FieldDateTimeID, "Dynamic Field $FieldDateTimeID" );

# add ID
$DynamicFieldDateTimeConfig{ID} = $FieldDateTimeID;

# add date-time dynamic field
my %DynamicFieldDateConfig = (
    Name       => "Unittest5$RandomID",
    FieldOrder => 9995,
    FieldType  => 'Date',
    ObjectType => 'Ticket',
    Label      => 'Description',
    Config     => {
        DefaultValue  => 0,
        YearsInFuture => 0,
        YearsInPast   => 0,
        YearsPeriod   => 0,
    },
    ValidID => 1,
);
my $FieldDateID = $DynamicFieldObject->DynamicFieldAdd(
    %DynamicFieldDateConfig,
    UserID  => 1,
    Reorder => 0,
);
ok( $FieldDateID, "Dynamic Field $FieldDateID", );

# add ID
$DynamicFieldDateConfig{ID} = $FieldDateID;

# create web service object
my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
isa_ok(
    $WebserviceObject,
    ['Kernel::System::GenericInterface::Webservice'],
    'Create web service object'
);

# set web service name
my $WebserviceName = '-Test-' . $RandomID;

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

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# prepare web service config
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
            TicketCreate => {
                Type => 'Ticket::TicketCreate',
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
            TicketCreate => {
                Type => 'Test::TestSimple',
            },
            SessionCreate => {
                Type => 'Test::TestSimple',
            },
        },
    },
};

# update web service with real config
my $WebserviceUpdate = $WebserviceObject->WebserviceUpdate(
    ID      => $WebserviceID,
    Name    => $WebserviceName,
    Config  => $WebserviceConfig,
    ValidID => 1,
    UserID  => 1,
);
ok( $WebserviceUpdate, "Updated web service $WebserviceID - $WebserviceName" );

# Get SessionID
# create requester object
my $RequesterSessionObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
isa_ok(
    $RequesterSessionObject,
    ['Kernel::GenericInterface::Requester'],
    'SessionID - Create requester object'
);

# create a new user for current test
my $UserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $Password = $UserLogin;

# create a new user without permissions for current test
my $UserLogin2 = $Helper->TestUserCreate();
my $Password2  = $UserLogin2;

# create a customer where a ticket will use and will have permissions
my $CustomerUserLogin = $Helper->TestCustomerUserCreate();
my $CustomerPassword  = $CustomerUserLogin;

# create a customer that will not have permissions
my $CustomerUserLogin2 = $Helper->TestCustomerUserCreate();
my $CustomerPassword2  = $CustomerUserLogin2;

# Create a customer with email address.
my $CustomerRand       = 'email-customer-' . $Helper->GetRandomID();
my $EmailCustomerRand  = $CustomerRand . '@localhost.com';
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my $TestCustomerUserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $CustomerRand,
    UserLogin      => $CustomerRand,
    UserEmail      => $EmailCustomerRand,
    UserPassword   => $CustomerRand,
    ValidID        => 1,
    UserID         => 1,
);

# start requester with our web service
my $RequesterSessionResult = $RequesterSessionObject->Run(
    WebserviceID => $WebserviceID,
    Invoker      => 'SessionCreate',
    Data         => {
        UserLogin => $UserLogin,
        Password  => $Password,
    },
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

sub TestTicketDelete {
    my %Param = @_;

    my @TicketIDs = @{ $Param{TicketIDs} };

    # Allow some time for all history entries to be written to the ticket before deleting it,
    #   otherwise TicketDelete could fail.
    sleep 1;
    TICKETID:
    for my $TicketID (@TicketIDs) {

        next TICKETID if !$TicketID;

        my $TicketDelete = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if the web server still writes to ticket history. Try again in this case.
        if ( !$TicketDelete ) {
            sleep 3;
            $TicketDelete = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        ok( $TicketDelete, "TicketDelete() successful for Ticket ID $TicketID" );
    }

    return 1;
}

my $NewSessionID = $RequesterSessionResult->{Data}->{SessionID};
my @Tests        = (
    {
        Name           => 'Empty Request',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {},
        ExpectedData   => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'No Article',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Ticket',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket  => 1,
            Article => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Article',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => 1,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid DynamicField',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => {
                Test => 1,
            },
            DynamicField => 1,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Attachment',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => 1,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Title',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Test => 1,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing CustomerUser',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title => 'Ticket Title',
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid CustomerUser',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Queue or QueueID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Queue',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid QueueID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Lock',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                Lock         => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid LockID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                LockID       => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Type or TypeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Type',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                Type         => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid TypeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Service',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                Service      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Service',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SLA',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLA          => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SLAID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing State or StateID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid State',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                State        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid StateID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Priority or PriorityID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Priority',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                Priority     => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PriorityID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Owner',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => $PriorityID,
                Owner        => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid OwnerID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => $PriorityID,
                OwnerID      => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid Responsible',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                QueueID      => $Queues[0]->{QueueID},
                TypeID       => $TypeID,
                ServiceID    => $ServiceID,
                SLAID        => $SLAID,
                StateID      => $StateID,
                PriorityID   => $PriorityID,
                OwnerID      => $OwnerID,
                Responsible  => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ResponsibeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => 'Invalid' . $RandomID,
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PendingTime',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 13,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PendingTime Diff',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Diff => -123456,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid PendingTime Diff + Full',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Diff   => 123456,
                    Year   => 2012,
                    Month  => 13,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Subject',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Test => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing Body',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject => 'Article subject',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing AutoResponseType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject => 'Article subject',
                Body    => 'Article body',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid AutoResponseType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject          => 'Article subject',
                Body             => 'Article body',
                AutoResponseType => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SenderType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderType           => 'Invalid' . $RandomID,
                IsVisibleForCustomer => 1,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid SenderTypeID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                IsVisibleForCustomer => 1,
                SenderTypeID         => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid From',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderTypeID         => 1,
                IsVisibleForCustomer => 1,
                From                 => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing ContentType or MIMEType and Charset',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderTypeID         => 1,
                IsVisibleForCustomer => 1,
                From                 => 'hello@otobo.org',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ContentType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderTypeID         => 1,
                IsVisibleForCustomer => 1,
                From                 => 'hello@otobo.org',
                ContentType          => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing ContentType or MIMEType and Charset',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderTypeID         => 1,
                IsVisibleForCustomer => 1,
                From                 => 'hello@otobo.org',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid HistoryType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderTypeID         => 1,
                IsVisibleForCustomer => 1,
                From                 => 'hello@otobo.org',
                ContentType          => 'text/plain; charset=UTF8',
                HistoryType          => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing TimeUnit',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderTypeID         => 1,
                IsVisibleForCustomer => 1,
                From                 => 'hello@otobo.org',
                ContentType          => 'text/plain; charset=UTF8',
                HistoryType          => 'NewTicket',
                HistoryComment       => '% % ',
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid TimeUnit',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                SenderTypeID         => 1,
                IsVisibleForCustomer => 1,
                From                 => 'hello@otobo.org',
                ContentType          => 'text/plain; charset=UTF8',
                HistoryType          => 'NewTicket',
                HistoryComment       => '% % ',
                TimeUnit             => 'Invalid' . $RandomID,
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ForceNotificationToUserID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                   => 'Article subject',
                Body                      => 'Article body',
                AutoResponseType          => 'auto reply',
                SenderTypeID              => 1,
                IsVisibleForCustomer      => 1,
                From                      => 'hello@otobo.org',
                ContentType               => 'text/plain; charset=UTF8',
                HistoryType               => 'NewTicket',
                HistoryComment            => '% % ',
                TimeUnit                  => 25,
                ForceNotificationToUserID => {
                    Item => 1,
                },
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ForceNotificationToUserID Internal',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                   => 'Article subject',
                Body                      => 'Article body',
                AutoResponseType          => 'auto reply',
                SenderTypeID              => 1,
                IsVisibleForCustomer      => 1,
                From                      => 'hello@otobo.org',
                ContentType               => 'text/plain; charset=UTF8',
                HistoryType               => 'NewTicket',
                HistoryComment            => '% % ',
                TimeUnit                  => 25,
                ForceNotificationToUserID => [ 'Invalid' . $RandomID ],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeNotificationToUserID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                     => 'Article subject',
                Body                        => 'Article body',
                AutoResponseType            => 'auto reply',
                SenderTypeID                => 1,
                IsVisibleForCustomer        => 1,
                From                        => 'hello@otobo.org',
                ContentType                 => 'text/plain; charset=UTF8',
                HistoryType                 => 'NewTicket',
                HistoryComment              => '% % ',
                TimeUnit                    => 25,
                ForceNotificationToUserID   => [$UserID],
                ExcludeNotificationToUserID => {
                    Item => 1,
                },
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeNotificationToUserID internal',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                     => 'Article subject',
                Body                        => 'Article body',
                AutoResponseType            => 'auto reply',
                SenderTypeID                => 1,
                IsVisibleForCustomer        => 1,
                From                        => 'hello@otobo.org',
                ContentType                 => 'text/plain; charset=UTF8',
                HistoryType                 => 'NewTicket',
                HistoryComment              => '% % ',
                TimeUnit                    => 25,
                ForceNotificationToUserID   => [$UserID],
                ExcludeNotificationToUserID => [ 'Invalid' . $RandomID ],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeMuteNotificationToUserID',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => {
                    Item => 1,
                },
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid ExcludeMuteNotificationToUserID internal',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [ 'Invalid' . $RandomID ],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing DynamicField name',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Test => 1,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing DynamicField value',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name => 'Invalid' . $RandomID,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid DynamicField name',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => 'Invalid' . $RandomID,
                Value => 'Invalid' . $RandomID,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid DynamicField value',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => 'Invalid' . $RandomID,
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing attachment Content',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Test => 1,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing attachment ContentType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Missing attachment Filename',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'Invalid' . $RandomID,
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Invalid attachment ContentType',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'Invalid' . $RandomID,
                Filename    => 'Test.txt',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with Customer User by email.',
        Type           => 'EmailCustomerUser',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $EmailCustomerRand,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
            },
            Article => {
                SenderTypeID         => 1,
                Subject              => 'Article subject',
                Body                 => 'Article body',
                AutoResponseType     => 'auto reply',
                From                 => $EmailCustomerRand,
                ContentType          => 'text/plain; charset=utf8',
                IsVisibleForCustomer => '1',
                TimeUnit             => 25,
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=utf8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs PendingTime Diff',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Diff => 10080,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs (Using Session)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with CDATA tags',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Test content <[[https://example.com/]]>',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            SessionID => $NewSessionID,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with Names',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                Service      => $ServiceData{Name},
                SLA          => $SLAData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body ɟ ɠ ɡ ɢ ɣ ɤ ɥ ɦ ɧ ʀ ʁ ʂ ʃ ʄ ʅ ʆ ʇ ʈ ʉ ʊ ʋ ʌ ʍ ʎ',
                AutoResponseType                => 'auto reply',
                SenderType                      => 'agent',
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name             => 'Ticket with external customer user - valid address',
        SuccessRequest   => 1,
        SuccessCreate    => 1,
        ExternalCustomer => 1,
        RequestData      => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => 'someone@somehots.com',
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body ɟ ɠ ɡ ɢ ɣ ɤ ɥ ɦ ɧ ʀ ʁ ʂ ʃ ʄ ʅ ʆ ʇ ʈ ʉ ʊ ʋ ʌ ʍ ʎ',
                AutoResponseType                => 'auto reply',
                SenderType                      => 'agent',
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name             => 'Ticket with external customer user - invalid address',
        SuccessRequest   => 1,
        SuccessCreate    => 0,
        ExternalCustomer => 1,
        RequestData      => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => 'someonesomehots.com',
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body ɟ ɠ ɡ ɢ ɣ ɤ ɥ ɦ ɧ ʀ ʁ ʂ ʃ ʄ ʅ ʆ ʇ ʈ ʉ ʊ ʋ ʌ ʍ ʎ',
                AutoResponseType                => 'auto reply',
                SenderType                      => 'agent',
                IsVisibleForCustomer            => 1,
                From                            => 'enjoy@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with TimeUnits 0',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                Service      => $ServiceData{Name},
                SLA          => $SLAData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderType                      => 'agent',
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with TimeUnits fractional',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title        => 'Ticket Title',
                CustomerUser => $TestCustomerUserLogin,
                Queue        => $Queues[0]->{Name},
                Type         => $TypeData{Name},
                Service      => $ServiceData{Name},
                SLA          => $SLAData{Name},
                State        => $StateData{Name},
                Priority     => $PriorityData{Name},
                Owner        => $TestOwnerLogin,
                Responsible  => $TestResponsibleLogin,
                PendingTime  => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject äöüßÄÖÜ€ис',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderType                      => 'agent',
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25.5,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs Agent (No Permission)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            UserLogin => $UserLogin2,
            Password  => $Password2,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.AccessDenied',
                },
            },
            Success => 1
        },

        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs Customer (With Permissions)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin,
            Password          => $CustomerPassword,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with IDs Customer (No Permission)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[1]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Filename    => 'Test.txt',
            },
        },
        Auth => {
            CustomerUserLogin => $CustomerUserLogin2,
            Password          => $CustomerPassword2,
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.AccessDenied',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Create DynamicFields (with empty value)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => [
                {
                    Name  => "Unittest1$RandomID",
                    Value => '',
                },
                {
                    Name  => "Unittest2$RandomID",
                    Value => '',
                },
                {
                    Name  => "Unittest3$RandomID",
                    Value => '',
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Create DynamicFields (with not empty value)',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
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
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Create DynamicFields (with dropdown value 0)',    # see bug#14858
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'enjoy@otobo.org',
                ContentType                     => 'text/plain; charset=utf8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => [
                {
                    Name  => "Unittest2$RandomID",
                    Value => '0',
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=utf8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Create DynamicFields (with wrong value type)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => [
                {
                    Name  => "Unittest1$RandomID",
                    Value => { Wrong => 'Value' },    # value type depends on the dynamic field
                },
                {
                    Name  => "Unittest2$RandomID",
                    Value => { Wrong => 'Value' },    # value type depends on the dynamic field
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.MissingParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Create DynamicFields (with invalid value)',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => [
                {
                    Name  => "Unittest2$RandomID",
                    Value => '4',                    # invalid value
                },
            ],
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=UTF8',
                Disposition => 'attachment',
                Filename    => 'Test.txt',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1,
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Ticket with Alias Charsets attachment',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=US-ASCII',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=US-ASCII',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Article with Email communication channel',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                CommunicationChannel            => 'Email',
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=US-ASCII',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=US-ASCII',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Article with Internal communication channel',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                CommunicationChannel            => 'Internal',
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=US-ASCII',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=US-ASCII',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Article with Phone communication channel',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                CommunicationChannel            => 'Phone',
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=US-ASCII',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=US-ASCII',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Article with wrong communication channel',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                SenderTypeID                    => 1,
                IsVisibleForCustomer            => 1,
                CommunicationChannel            => 'Test123',
                From                            => 'hello@otobo.org',
                ContentType                     => 'text/plain; charset=UTF8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=US-ASCII',
                Filename    => 'Test.txt',
                Disposition => 'attachment',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode => 'TicketCreate.InvalidParameter',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        Name           => 'Filename with name "0"',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                CommunicationChannel            => 'Email',
                ContentType                     => 'text/plain; charset=utf8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
                To                              =>
                    "$TestCustomerUserLogin $TestCustomerUserLogin <${TestCustomerUserLogin}\@localunittest.com>, "
                    . '"another \" recipient" <to_recipient_a@localunittest.com>, '
                    . '<to_recipient_b@localunittest.com>',
                Cc =>
                    '"another \" recipient" <cc_recipient_a@localunittest.com>, '
                    . '<cc_recipient_b@localunittest.com>',
            },
            DynamicField => {
                Name  => $DynamicFieldDateTimeConfig{Name},
                Value => '2012-01-17 12:40:00',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => 'text/plain; charset=us-ascii',
                Filename    => '0',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
    {
        # the attachment should be rejected because the ContentType looks dubious
        Name           => 'reject attachment: unknown charset',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                CommunicationChannel            => 'Email',
                ContentType                     => 'text/plain; charset=utf8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
                To                              =>
                    "$TestCustomerUserLogin $TestCustomerUserLogin <${TestCustomerUserLogin}\@localunittest.com>, "
                    . '"another \" recipient" <to_recipient_a@localunittest.com>, '
                    . '<to_recipient_b@localunittest.com>',
                Cc =>
                    '"another \" recipient" <cc_recipient_a@localunittest.com>, '
                    . '<cc_recipient_b@localunittest.com>',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => "text/plain; charset=notinventedhere",
                Filename    => 'reject_charset',
                Disposition => 'attachment',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketCreate.InvalidParameter',
                    ErrorMessage => 'TicketCreate: Attachment->ContentType is invalid!',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        # the attachment should be rejected because the ContentType contains a newline
        Name           => 'reject attachment: Web-Cache-Poisoning',
        SuccessRequest => 1,
        SuccessCreate  => 0,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                CommunicationChannel            => 'Email',
                ContentType                     => 'text/plain; charset=utf8',
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
                To                              =>
                    "$TestCustomerUserLogin $TestCustomerUserLogin <${TestCustomerUserLogin}\@localunittest.com>, "
                    . '"another \" recipient" <to_recipient_a@localunittest.com>, '
                    . '<to_recipient_b@localunittest.com>',
                Cc =>
                    '"another \" recipient" <cc_recipient_a@localunittest.com>, '
                    . '<cc_recipient_b@localunittest.com>',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => "text/plain\nHost-Header-Injection: Web-Cache-Poisoning",
                Filename    => 'reject_injection',
                Disposition => 'attachment',
            },
        },
        ExpectedData => {
            Data => {
                Error => {
                    ErrorCode    => 'TicketCreate.InvalidParameter',
                    ErrorMessage => 'TicketCreate: Attachment->ContentType is invalid!',
                },
            },
            Success => 1
        },
        Operation => 'TicketCreate',
    },
    {
        # the attachment should not be rejected because extra parameters are allowed
        Name           => 'extra parameter in ContentType',
        SuccessRequest => 1,
        SuccessCreate  => 1,
        RequestData    => {
            Ticket => {
                Title         => 'Ticket Title',
                CustomerUser  => $TestCustomerUserLogin,
                QueueID       => $Queues[0]->{QueueID},
                TypeID        => $TypeID,
                ServiceID     => $ServiceID,
                SLAID         => $SLAID,
                StateID       => $StateID,
                PriorityID    => $PriorityID,
                OwnerID       => $OwnerID,
                ResponsibleID => $ResponsibleID,
                PendingTime   => {
                    Year   => 2012,
                    Month  => 12,
                    Day    => 16,
                    Hour   => 20,
                    Minute => 48,
                },
            },
            Article => {
                Subject                         => 'Article subject',
                Body                            => 'Article body',
                AutoResponseType                => 'auto reply',
                ArticleTypeID                   => 1,
                SenderTypeID                    => 1,
                CommunicationChannel            => 'Email',
                ContentType                     => "text/plain; charset=utf8",
                HistoryType                     => 'NewTicket',
                HistoryComment                  => '% % ',
                TimeUnit                        => 25,
                ForceNotificationToUserID       => [$UserID],
                ExcludeNotificationToUserID     => [$UserID],
                ExcludeMuteNotificationToUserID => [$UserID],
                To                              =>
                    "$TestCustomerUserLogin $TestCustomerUserLogin <${TestCustomerUserLogin}\@localunittest.com>, "
                    . '"another \" recipient" <to_recipient_a@localunittest.com>, '
                    . '<to_recipient_b@localunittest.com>',
                Cc =>
                    '"another \" recipient" <cc_recipient_a@localunittest.com>, '
                    . '<cc_recipient_b@localunittest.com>',
            },
            Attachment => {
                Content     => 'VGhpcyBpcyBhIHRlc3QgdGV4dC4=',
                ContentType => "text/plain;extra_test_parameter=dummy_parameter",
                Filename    => 'extra_test_parameter',
                Disposition => 'attachment',
            },
        },
        Operation => 'TicketCreate',
    },
);

# debugger object
my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
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
    'DebuggerObject instantiate correctly'
);

for my $Test (@Tests) {

    subtest $Test->{Name} => sub {

        if ( $Test->{Type} && $Test->{Type} eq 'EmailCustomerUser' ) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'CheckEmailAddresses',
                Value => 0,
            );
        }
        else {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'CheckEmailAddresses',
                Value => 1,
            );
        }

        # create local object
        my $LocalObject = "Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"->new(
            DebuggerObject => $DebuggerObject,
            WebserviceID   => $WebserviceID,
        );
        isa_ok(
            $LocalObject,
            ["Kernel::GenericInterface::Operation::Ticket::$Test->{Operation}"],
            "Create local object"
        );

        my %Auth = (
            UserLogin => $UserLogin,
            Password  => $Password,
        );
        if ( IsHashRefWithData( $Test->{Auth} ) ) {
            %Auth = $Test->{Auth}->%*;
        }

        # start requester with our web service
        my $LocalResult = $LocalObject->Run(
            WebserviceID => $WebserviceID,
            Invoker      => $Test->{Operation},
            Data         => {
                %Auth,
                $Test->{RequestData}->%*,
            },
        );

        # check result
        ref_ok(
            $LocalResult,
            'HASH',
            "Local result structure is valid"
        );

        # create requester object
        my $RequesterObject = $Kernel::OM->Get('Kernel::GenericInterface::Requester');
        isa_ok(
            $RequesterObject,
            ['Kernel::GenericInterface::Requester'],
            "Create requester object"
        );

        # start requester with our web-service
        my $RequesterResult = $RequesterObject->Run(
            WebserviceID => $WebserviceID,
            Invoker      => $Test->{Operation},
            Data         => {
                %Auth,
                $Test->{RequestData}->%*,
            },
        );

        # TODO prevent failing test if enviroment on SaaS unit test system doesn't work.
        if (
            $Test->{SuccessCreate}
            &&
            $RequesterResult->{ErrorMessage}
            &&
            $RequesterResult->{ErrorMessage} eq 'faultcode: Server, faultstring: Attachment could not be created, please contact the system administrator'
            )
        {

            my @TicketIDs = ( $LocalResult->{Data}->{TicketID}, $RequesterResult->{Data}->{TicketID} );
            TestTicketDelete( TicketIDs => \@TicketIDs );

            return;
        }

        # check result
        ref_ok(
            $RequesterResult,
            'HASH',
            "Requester result structure is valid"
        );

        is(
            $RequesterResult->{Success},
            $Test->{SuccessRequest},
            "Requester successful result"
        );

        # tests supposed to succeed
        if ( $Test->{SuccessCreate} ) {

            # local results
            ok(
                $LocalResult->{Data}->{TicketID},
                "Local result TicketID with True."
            );
            ok(
                $LocalResult->{Data}->{TicketNumber},
                "Local result TicketNumber with True."
            );
            ok(
                $LocalResult->{Data}->{ArticleID},
                "Local result ArticleID with True."
            );
            is(
                $LocalResult->{Data}->{Error},
                undef,
                "Local result Error is undefined."
            );

            # requester results
            ok(
                $RequesterResult->{Data}->{TicketID},
                "Requester result TicketID with True."
            );
            ok(
                $RequesterResult->{Data}->{TicketNumber},
                "Requester result TicketNumber with True."
            );
            ok(
                $RequesterResult->{Data}->{ArticleID},
                "Requester result ArticleID with True."
            );
            is(
                $RequesterResult->{Data}->{Error},
                undef,
                "Requester result Error is undefined."
            );

            # get the Ticket entry (from local result)
            my %LocalTicketData = $TicketObject->TicketGet(
                TicketID      => $LocalResult->{Data}->{TicketID},
                DynamicFields => 1,
                UserID        => 1,
            );

            ok(
                scalar %LocalTicketData,
                "created local ticket structure with True."
            );

            # get the Ticket entry (from requester result)
            my %RequesterTicketData = $TicketObject->TicketGet(
                TicketID      => $RequesterResult->{Data}->{TicketID},
                DynamicFields => 1,
                UserID        => 1,
            );

            ok(
                scalar %RequesterTicketData,
                "created requester ticket structure with True."
            );

            # check ticket attributes as defined in the test
            is(
                $LocalTicketData{Title},
                $Test->{RequestData}->{Ticket}->{Title},
                "local Ticket->Title match test definition."

            );

            # external customers only set it's value in article (if no From is defined)
            # or CustomerUser is set as valid address.
            # See bug#14288 for more information.
            if ( $Test->{ExternalCustomer} ) {
                is(
                    $LocalTicketData{CustomerUserID},
                    $Test->{RequestData}->{Ticket}->{CustomerUser},
                    "local Ticket->CustomerUser is empty."
                );
            }
            else {
                my $ExpectedCustomerUserID = $Test->{RequestData}->{Ticket}->{CustomerUser};

                if ( ( $Test->{Type} // '' ) eq 'EmailCustomerUser' ) {
                    $ExpectedCustomerUserID = $CustomerRand;
                }

                is(
                    $LocalTicketData{CustomerUserID},
                    $ExpectedCustomerUserID,
                    "local Ticket->CustomerUser match test definition."
                );
            }

            for my $Attribute (qw(Queue Type Service SLA State Priority Owner Responsible)) {
                if ( $Test->{RequestData}->{Ticket}->{ $Attribute . 'ID' } ) {
                    is(
                        $LocalTicketData{ $Attribute . 'ID' },
                        $Test->{RequestData}->{Ticket}->{ $Attribute . 'ID' },
                        "local Ticket->$Attribute" . 'ID' . " match test definition.",
                    );
                }
                else {
                    is(
                        $LocalTicketData{$Attribute},
                        $Test->{RequestData}->{Ticket}->{$Attribute},
                        "local Ticket->$Attribute match test definition."
                    );
                }
            }

            my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

            my $LocalArticleBackendObject = $ArticleObject->BackendForArticle(
                TicketID  => $LocalResult->{Data}->{TicketID},
                ArticleID => $LocalResult->{Data}->{ArticleID},
            );

            # get local article information
            my %LocalArticleData = $LocalArticleBackendObject->ArticleGet(
                TicketID      => $LocalResult->{Data}->{TicketID},
                ArticleID     => $LocalResult->{Data}->{ArticleID},
                DynamicFields => 1,
            );

            my $RequesterArticleBackendObject = $ArticleObject->BackendForArticle(
                TicketID  => $RequesterResult->{Data}->{TicketID},
                ArticleID => $RequesterResult->{Data}->{ArticleID},
            );

            # get requester article information
            my %RequesterArticleData = $RequesterArticleBackendObject->ArticleGet(
                TicketID      => $RequesterResult->{Data}->{TicketID},
                ArticleID     => $RequesterResult->{Data}->{ArticleID},
                DynamicFields => 1,
            );

            for my $Attribute (qw(Subject Body ContentType MimeType Charset From)) {
                if ( $Test->{RequestData}->{Article}->{$Attribute} ) {
                    is(
                        $LocalArticleData{$Attribute},
                        $Test->{RequestData}->{Article}->{$Attribute},
                        "local Article->$Attribute match test definition."
                    );
                }
            }

            for my $Attribute (qw(SenderType)) {
                if ( $Test->{RequestData}->{Article}->{ $Attribute . 'ID' } ) {
                    is(
                        $LocalArticleData{ $Attribute . 'ID' },
                        $Test->{RequestData}->{Article}->{ $Attribute . 'ID' },
                        "local Article->$Attribute" . 'ID' . " match test definition."
                    );
                }
                else {
                    is(
                        $LocalArticleData{$Attribute},
                        $Test->{RequestData}->{Article}->{$Attribute},
                        "local Article->$Attribute match test definition."
                    );
                }
            }

            # check dynamic fields
            my @OriginalDynamicFields;
            if ( !$Test->{RequestData}->{DynamicField} ) {

                # nothing to do, dynamic fields are not required for all test cases
            }
            elsif ( ref $Test->{RequestData}->{DynamicField} eq 'HASH' ) {
                push @OriginalDynamicFields, $Test->{RequestData}->{DynamicField};
            }
            else {
                @OriginalDynamicFields = @{ $Test->{RequestData}->{DynamicField} };
            }
            for my $DynamicField (@OriginalDynamicFields) {

                if (
                    ( $DynamicField->{FieldType} // '' ) eq 'Date'
                    &&
                    ( $DynamicField->{Value} // '' ) =~ m{ \A \d{4}-\d{2}-\d{2} \z }xms
                    )
                {
                    $DynamicField->{Value} .= ' 00:00:00';
                }

                is(
                    $LocalTicketData{ 'DynamicField_' . $DynamicField->{Name} } // '',
                    $DynamicField->{Value},
                    "local Ticket->DynamicField_$DynamicField->{Name} match test definition."
                );
            }

            # check local and requester attachments against the originally submitted attachments
            {
                my @LocalAttachments;
                {
                    my %AttachmentIndex = $LocalArticleBackendObject->ArticleAttachmentIndex(
                        ArticleID        => $LocalResult->{Data}->{ArticleID},
                        ExcludePlainText => 1,
                        ExcludeHTMLBody  => 1,
                    );

                    ATTACHMENT:
                    for my $FileID ( sort keys %AttachmentIndex ) {
                        next ATTACHMENT unless $FileID;

                        my %Attachment = $LocalArticleBackendObject->ArticleAttachment(
                            ArticleID => $LocalResult->{Data}->{ArticleID},
                            FileID    => $FileID,
                        );

                        next ATTACHMENT unless IsHashRefWithData( \%Attachment );

                        # convert content to base64
                        $Attachment{Content} = encode_base64( $Attachment{Content}, '' );

                        # delete not needed attributes
                        delete @Attachment{qw(ContentAlternative ContentID Filesize FilesizeRaw)};

                        push @LocalAttachments, \%Attachment;
                    }
                }

                my @RequesterAttachments;
                {
                    my %AttachmentIndex = $RequesterArticleBackendObject->ArticleAttachmentIndex(
                        ArticleID        => $LocalResult->{Data}->{ArticleID},
                        ExcludePlainText => 1,
                        ExcludeHTMLBody  => 1,
                    );

                    ATTACHMENT:
                    for my $FileID ( sort keys %AttachmentIndex ) {
                        next ATTACHMENT unless $FileID;

                        my %Attachment = $RequesterArticleBackendObject->ArticleAttachment(
                            ArticleID => $RequesterResult->{Data}->{ArticleID},
                            FileID    => $FileID,
                        );

                        next ATTACHMENT unless IsHashRefWithData( \%Attachment );

                        # convert content to base64
                        $Attachment{Content} = encode_base64( $Attachment{Content}, '' );

                        # delete not needed attributes
                        delete @Attachment{qw(ContentAlternative ContentID Filesize FilesizeRaw)};

                        push @RequesterAttachments, \%Attachment;
                    }
                }

                my @OriginalAttachments;
                {
                    if ( ref $Test->{RequestData}->{Attachment} eq 'HASH' ) {
                        push @OriginalAttachments, $Test->{RequestData}->{Attachment};
                    }
                    else {
                        push @OriginalAttachments, $Test->{RequestData}->{Attachment}->@*;
                    }
                }

                # the actual checks
                is( \@LocalAttachments,     \@OriginalAttachments, "local Ticket->Attachment match test definition" );
                is( \@RequesterAttachments, \@OriginalAttachments, "requester Ticket->Attachment match test definition" );
                is( \@RequesterAttachments, \@LocalAttachments,    "requester and local attachments must match" );
            }

            # remove ticket attributes that might be different from local and requester responses
            for my $Attribute (
                qw(TicketID TicketNumber Created Changed Age UnlockTimeout)
                )
            {
                delete $LocalTicketData{$Attribute};
                delete $RequesterTicketData{$Attribute};
            }

            is(
                \%LocalTicketData,
                \%RequesterTicketData,
                "Local ticket result matched with remote result."
            );

            # remove attributes that might be different from local and requester responses
            for my $Attribute (
                qw( Age AgeTimeUnix ArticleID TicketID CreateTime ChangeTime IncomingTime TicketNumber
                )
                )
            {
                delete $LocalArticleData{$Attribute};
                delete $RequesterArticleData{$Attribute};
            }

            is(
                \%LocalArticleData,
                \%RequesterArticleData,
                'Local article result matched with remote result.'
            );

            my @TicketIDs = ( $LocalResult->{Data}->{TicketID}, $RequesterResult->{Data}->{TicketID} );
            TestTicketDelete( TicketIDs => \@TicketIDs );
        }

        # tests supposed to fail
        else {

            # check that there is an error, but no payload
            ref_ok(
                $LocalResult->{Data},
                'HASH',
                "Local result structure got Data"
            );
            ref_ok(
                $LocalResult->{Data}->{Error},
                'HASH',
                "Local result structure got Data->Error"
            );
            for my $Attr (qw(TicketID TicketNumber ArticleID)) {
                ok(
                    !exists $LocalResult->{Data}->{$Attr},
                    "Local result $Attr not present"
                );
            }

            # Check the expected error code
            is(
                $LocalResult->{Data}->{Error}->{ErrorCode},
                $Test->{ExpectedData}->{Data}->{Error}->{ErrorCode},
                "Local result ErrorCode matched with expected local call result."
            );
            ok( $LocalResult->{Data}->{Error}->{ErrorMessage}, "got a local result ErrorMessage" );

            # The expected error message is not always given
            if ( $Test->{ExpectedData}->{Data}->{Error}->{ErrorMessage} ) {
                is(
                    $LocalResult->{Data}->{Error}->{ErrorMessage},
                    $Test->{ExpectedData}->{Data}->{Error}->{ErrorMessage},
                    "Local result ErrorMessage matched with expected local call result."
                );
            }

            is(
                $LocalResult->{ErrorMessage},
                $LocalResult->{Data}->{Error}->{ErrorCode}
                    . ': '
                    . $LocalResult->{Data}->{Error}->{ErrorMessage},
                "Local result ErrorMessage (outside Data hash) matched with concatenation"
                    . " of ErrorCode and ErrorMessage within Data hash."
            );

            # remove ErrorMessage parameter from direct call
            # result to be consistent with SOAP call result
            if ( $LocalResult->{ErrorMessage} ) {
                delete $LocalResult->{ErrorMessage};
            }

            # sanity check
            ok(
                !$LocalResult->{ErrorMessage},
                "Local result ErrorMessage (outside Data hash) got removed to compare"
                    . " local and remote tests."
            );

            is(
                $LocalResult,
                $RequesterResult,
                "Local result matched with remote result."
            );
        }
    };
}

# delete web service
my $WebserviceDelete = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);
ok( $WebserviceDelete, "Deleted web service $WebserviceID" );

# get DB object
my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
isa_ok(
    $DBObject,
    ['Kernel::System::DB'],
    "DBObject created correctly",
);

# Some ticket has bean created on SaaS system but RequesterResult return error without ticket data.
# So get all created tickets by ticket search by Queue.
my @TicketIDs = $TicketObject->TicketSearch(
    QueueIDs => \@QueueIDs,
    UserID   => 1,
);
TestTicketDelete( TicketIDs => \@TicketIDs );

# delete queues
for my $QueueData (@Queues) {
    my $Success = $DBObject->Do(
        SQL => "DELETE FROM queue WHERE id = $QueueData->{QueueID}",
    );
    ok( $Success, "Queue with ID $QueueData->{QueueID} is deleted!" );
}

# delete group
my $Success = $DBObject->Do(
    SQL => "DELETE FROM groups_table WHERE id = $GroupID",
);
ok( $Success, "Group with ID $GroupID is deleted!" );

# delete type
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_type WHERE id = $TypeID",
);
ok( $Success, "Type with ID $TypeID is deleted!" );

# delete service_customer_user and service
$Success = $DBObject->Do(
    SQL => "DELETE FROM service_customer_user WHERE service_id = $ServiceID",
);
ok( $Success, "Service user referenced to service ID $ServiceID is deleted!" );

$Success = $DBObject->Do(
    SQL => "DELETE FROM service_sla WHERE service_id = $ServiceID OR sla_id = $SLAID",
);
ok( $Success, "Service SLA referenced to service ID $ServiceID is deleted!" );

$Success = $DBObject->Do(
    SQL => "DELETE FROM service WHERE id = $ServiceID",
);
ok( $Success, "Service with ID $ServiceID is deleted!" );

# delete SLA
$Success = $DBObject->Do(
    SQL => "DELETE FROM sla WHERE id = $SLAID",
);
ok( $Success, "SLA with ID $SLAID is deleted!", );

# delete state
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_state WHERE id = $StateID",
);
ok( $Success, "State with ID $StateID is deleted!" );

# delete priority
$Success = $DBObject->Do(
    SQL => "DELETE FROM ticket_priority WHERE id = $PriorityID",
);
ok( $Success, "Priority with ID $PriorityID is deleted!" );

# delete dynamic fields
my $DeleteFieldList = $DynamicFieldObject->DynamicFieldList(
    ResultType => 'HASH',
    ObjectType => 'Ticket',
);

my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

DYNAMICFIELD:
for my $DynamicFieldID ( sort keys $DeleteFieldList->%* ) {

    next DYNAMICFIELD if !$DynamicFieldID;
    next DYNAMICFIELD if !$DeleteFieldList->{$DynamicFieldID};

    next DYNAMICFIELD if $DeleteFieldList->{$DynamicFieldID} !~ m{ ^Unittest }xms;

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );
    my $ValuesDeleteSuccess = $BackendObject->AllValuesDelete(
        DynamicFieldConfig => $DynamicFieldConfig,
        UserID             => 1,
    );

    my $Success = $DynamicFieldObject->DynamicFieldDelete(
        ID     => $DynamicFieldID,
        UserID => 1,
    );

    ok( $Success, "DynamicFieldDelete() for $DeleteFieldList->{$DynamicFieldID} with true" );
}

# cleanup cache
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

done_testing();
