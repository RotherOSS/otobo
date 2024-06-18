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
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM
use Kernel::System::VariableCheck qw(IsHashRefWithData);

=head1 NAME

ValueSetGet.t - test the method ValueSet() and ValueGet() for different dynamic field types

=head1 SYNOPSIS

    bin/otobo.Console.pl Dev::UnitTest::Run --verbose --merge scripts/test/DynamicField/ValueSetGet.t

=head1 DESCRIPTION

Set and get dynamic field values that are attached to a ticket.

=cut

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper   = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $RandomID = $Helper->GetRandomID;
diag "RandomID is $RandomID";

# get needed objects
my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');
my $CustomerCompanyObject     = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my $CustomerUserObject        = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject                = $Kernel::OM->Get('Kernel::System::User');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserID = 1;    # root

# create agents
my $FirstUserID = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User',
    UserLogin     => 'TestUser1' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test1' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);
ok( $FirstUserID, 'Creation of first agent' );

my $SecondUserID = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User',
    UserLogin     => 'TestUser2' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test2' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);
ok( $SecondUserID, 'Creation of second agent' );

# create customer companies
my $FirstCustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID          => 'TestCustomerCompany1' . $RandomID,
    CustomerCompanyName => 'TestCustomerCompany1' . $RandomID,
    ValidID             => 1,
    UserID              => $UserID,
);
ok( $FirstCustomerCompanyID, 'Creation of first customer company' );

my $SecondCustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID          => 'TestCustomerCompany2' . $RandomID,
    CustomerCompanyName => 'TestCustomerCompany2' . $RandomID,
    ValidID             => 1,
    UserID              => $UserID,
);
ok( $SecondCustomerCompanyID, 'Creation of second customer company' );

# create customer users
my $FirstCustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'TestCustomer1' . $RandomID,
    UserLastname   => 'TestCustomer1' . $RandomID,
    UserCustomerID => 'TestCustomerCompany1' . $RandomID,
    UserLogin      => 'TestCustomer1' . $RandomID,
    UserEmail      => 'TestCustomer1' . $RandomID . '@example.com',
    ValidID        => 1,
    UserID         => $UserID,
);
ok( $FirstCustomerUserLogin, 'Creation of first customer user' );

my $SecondCustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'TestCustomer2' . $RandomID,
    UserLastname   => 'TestCustomer2' . $RandomID,
    UserCustomerID => 'TestCustomerCompany1' . $RandomID,
    UserLogin      => 'TestCustomer2' . $RandomID,
    UserEmail      => 'TestCustomer2' . $RandomID . '@example.com',
    ValidID        => 1,
    UserID         => $UserID,
);
ok( $SecondCustomerUserLogin, 'Creation of second customer user' );

# create a source ticket
my $SourceTicketID = $TicketObject->TicketCreate(
    Title        => 'SourceTicket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => $UserID,
);
ok( $SourceTicketID, 'Creation of source ticket' );

# create tickets for referencing
my $FirstReferenceTicketID = $TicketObject->TicketCreate(
    Title        => 'FirstReferenceTicket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $FirstCustomerCompanyID,
    CustomerUser => 'TestCustomer1' . $RandomID . '@example.com',
    OwnerID      => 1,
    UserID       => $UserID,
);
ok( $FirstReferenceTicketID, 'Creation of first reference ticket' );

my $SecondReferenceTicketID = $TicketObject->TicketCreate(
    Title        => 'SecondReferenceTicket',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $SecondCustomerCompanyID,
    CustomerUser => 'TestCustomer2' . $RandomID . '@example.com',
    OwnerID      => 1,
    UserID       => $UserID,
);
ok( $SecondReferenceTicketID, 'Creation of second reference ticket' );

# set of dynamic field configurations to be created
# sorted alphabetically by FieldType
my @CreateDynamicFieldConfigs = (

    # Agent
    {
        Name       => 'Agent',
        Label      => 'Agent',
        FieldOrder => 123,
        FieldType  => 'Agent',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 0,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'AgentMS',
        Label      => 'AgentMS',
        FieldOrder => 123,
        FieldType  => 'Agent',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 1,
            MultiValue   => 0,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'AgentMV',
        Label      => 'AgentMV',
        FieldOrder => 123,
        FieldType  => 'Agent',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 1,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # CustomerCompany
    {
        Name       => 'CustomerCompany',
        Label      => 'CustomerCompany',
        FieldOrder => 123,
        FieldType  => 'CustomerCompany',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 0,
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'CustomerCompanyMS',
        Label      => 'CustomerCompanyMS',
        FieldOrder => 123,
        FieldType  => 'CustomerCompany',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 1,
            MultiValue   => 0,
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'CustomerCompanyMV',
        Label      => 'CustomerCompanyMV',
        FieldOrder => 123,
        FieldType  => 'CustomerCompany',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 1,
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # CustomerUser
    {
        Name       => 'CustomerUser',
        Label      => 'CustomerUser',
        FieldOrder => 123,
        FieldType  => 'CustomerUser',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'CustomerUserMV',
        Label      => 'CustomerUserMV',
        FieldOrder => 123,
        FieldType  => 'CustomerUser',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 1,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # Text
    {
        Name       => 'Text1',
        Label      => 'Text1',
        FieldOrder => 123,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'Text2',
        Label      => 'Text2',
        FieldOrder => 123,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # Fields to include in SetOfTexts
    {
        Name       => 'Text3',
        Label      => 'Text3',
        FieldOrder => 123,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'Text4',
        Label      => 'Text4',
        FieldOrder => 123,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 1,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # Fields to include in SetOfAgentsAndTexts
    {
        Name       => 'Text5',
        Label      => 'Text5',
        FieldOrder => 123,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'Text6',
        Label      => 'Text6',
        FieldOrder => 123,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 1,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'Agent1',
        Label      => 'Agent1',
        FieldOrder => 123,
        FieldType  => 'Agent',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 0,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'Agent2',
        Label      => 'Agent2',
        FieldOrder => 123,
        FieldType  => 'Agent',
        ObjectType => 'Ticket',
        Config     => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 1,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # Set, using the previously created Text3 and Text4 dynamic fields
    {
        Name       => 'SetOfTexts',
        Label      => 'set of texts',
        FieldOrder => 123,
        FieldType  => 'Set',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 0,
            Tooltip    => '',
            Include    => [
                { DF => 'Text3' . $RandomID },
                { DF => 'Text4' . $RandomID },
            ],
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # Set, using the previously created Text5 and Text6 and agent fields
    {
        Name       => 'SetOfAgentsAndTexts',
        Label      => 'set of agents and texts',
        FieldOrder => 123,
        FieldType  => 'Set',
        ObjectType => 'Ticket',
        Config     => {
            MultiValue => 0,
            Tooltip    => '',
            Include    => [
                { DF => 'Text5' . $RandomID },
                { DF => 'Text6' . $RandomID },
                { DF => 'Agent1' . $RandomID },
                { DF => 'Agent2' . $RandomID },
            ],
        },
        ValidID => 1,
        UserID  => $UserID,
    },

    # TicketReference
    {
        Name       => 'TicketRef',
        Label      => 'TicketRef',
        FieldOrder => 123,
        FieldType  => 'Ticket',
        ObjectType => 'Ticket',
        Config     => {
            EditFieldMode        => 'Dropdown',
            PossibleNone         => 1,
            Multiselect          => 0,
            MultiValue           => 0,
            ReferenceFilterList  => [],
            ReferencedObjectType => 'Ticket',
            Tooltip              => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'TicketRefMS',
        Label      => 'TicketRefMS',
        FieldOrder => 123,
        FieldType  => 'Ticket',
        ObjectType => 'Ticket',
        Config     => {
            EditFieldMode        => 'Dropdown',
            PossibleNone         => 1,
            Multiselect          => 1,
            MultiValue           => 0,
            ReferenceFilterList  => [],
            ReferencedObjectType => 'Ticket',
            Tooltip              => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name       => 'TicketRefMV',
        Label      => 'TicketRefMV',
        FieldOrder => 123,
        FieldType  => 'Ticket',
        ObjectType => 'Ticket',
        Config     => {
            EditFieldMode        => 'Dropdown',
            PossibleNone         => 1,
            Multiselect          => 0,
            MultiValue           => 1,
            ReferenceFilterList  => [],
            ReferencedObjectType => 'Ticket',
            Tooltip              => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
);

# create dynamic fields
my %DynamicFieldConfigs;
for my $CreateDFConfig (@CreateDynamicFieldConfigs) {

    my $ShortName = $CreateDFConfig->{Name};
    $CreateDFConfig->{Name} .= $RandomID;
    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        $CreateDFConfig->%*,
    );
    ok( $DynamicFieldID, 'Creation of dynamic field ' . $CreateDFConfig->{Name} );

    # Get the test dynamic field
    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        ID => $DynamicFieldID,
    );

    # test the roundtrip
    is(
        $DynamicFieldConfig->{Config},
        $CreateDFConfig->{Config},
        "config for $CreateDFConfig->{Name}"
    );
    $DynamicFieldConfigs{$ShortName} = $DynamicFieldConfig;
}

# define tests
my @Tests = (

    # Dynamic Field Agent
    # Agent SingleSelect
    {
        Name   => 'Agent: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Agent: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Agent: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => $FirstUserID,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstUserID],
        Success         => 1,
    },
    {
        Name   => 'Agent: Value array ref one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => [$FirstUserID],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstUserID],
        Success         => 1,
    },

    # Agent Multiselect
    {
        Name   => 'Agent Multiselect: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Agent Multiselect: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Agent Multiselect: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => $FirstUserID,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstUserID],
        Success         => 1,
    },
    {
        Name   => 'Agent Multiselect: Value array ref with one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => [$FirstUserID],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstUserID],
        Success         => 1,
    },
    {
        Name   => 'Agent Multiselect: Value array ref with two user ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => [ $FirstUserID, $SecondUserID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstUserID, $SecondUserID ],
        Success         => 1,
    },

    # Agent MultiValue
    {
        Name   => 'Agent MultiValue: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Agent MultiValue: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Agent MultiValue: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => $FirstUserID,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstUserID],
        Success         => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [$FirstUserID],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstUserID],
        Success         => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with two user ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [ $FirstUserID, $SecondUserID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstUserID, $SecondUserID ],
        Success         => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [undef],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [ $FirstUserID, undef, $SecondUserID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstUserID, undef, $SecondUserID ],
        Success         => 1,
    },

    # Dynamic Field CustomerCompany

    # CustomerCompany SingleSelect
    {
        Name   => 'CustomerCompany: Value one plain customer company id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompany},
            Value              => $FirstCustomerCompanyID,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstCustomerCompanyID],
        Success         => 1,
    },

    # CustomerCompany Multiselect
    {
        Name   => 'CustomerCompany Multiselect: Value array ref with two customer company ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompanyMS},
            Value              => [ $FirstCustomerCompanyID, $SecondCustomerCompanyID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstCustomerCompanyID, $SecondCustomerCompanyID ],
        Success         => 1,
    },

    # CustomerCompany MultiValue
    {
        Name   => 'CustomerCompany MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompanyMV},
            Value              => [ $FirstCustomerCompanyID, undef, $SecondCustomerCompanyID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstCustomerCompanyID, undef, $SecondCustomerCompanyID ],
        Success         => 1,
    },

    # Dynamic Field CustomerUser

    # CustomerUser SingleSelect
    {
        Name   => 'CustomerUser: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'CustomerUser: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'CustomerUser: Value one plain customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => $FirstCustomerUserLogin,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstCustomerUserLogin],
        Success         => 1,
    },
    {
        Name   => 'CustomerUser: Value array ref with one customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => [$FirstCustomerUserLogin],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstCustomerUserLogin],
        Success         => 1,
    },

    # CustomerUser MultiValue
    {
        Name   => 'CustomerUser MultiValue: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value one plain customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => $FirstCustomerUserLogin,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstCustomerUserLogin],
        Success         => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with one customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [$FirstCustomerUserLogin],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstCustomerUserLogin],
        Success         => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with two customer user logins',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [ $FirstCustomerUserLogin, $SecondCustomerUserLogin ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstCustomerUserLogin, $SecondCustomerUserLogin ],
        Success         => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [undef],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [ $FirstCustomerUserLogin, undef, $SecondCustomerUserLogin ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstCustomerUserLogin, undef, $SecondCustomerUserLogin ],
        Success         => 1,
    },

    # Dynamic Field Text
    {
        Name   => 'Text1',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text1},
            Value              => '⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => '⛄ - U+026C4 - SNOWMAN WITHOUT SNOW',
        Success         => 1,
    },
    {
        Name   => 'Text2',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text1},
            Value              => '🌨 - U+1F328 - CLOUD WITH SNOW',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => '🌨 - U+1F328 - CLOUD WITH SNOW',
        Success         => 1,
    },

    # Dynamic Field Set
    {
        Name   => 'SetOfTexts',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{SetOfTexts},
            Value              =>

                # a list of Set values
                [

                    # actually only on Set value in the list
                    {
                        # value for the first dynamic field in the set
                        "Text3$RandomID" => 'Text1: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',

                        # value for the second dynamic field in the set
                        "Text4$RandomID" => [
                            'Text1: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                            'Text2: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                        ],
                    },
                ],
            ObjectID => $SourceTicketID,
            UserID   => $UserID,
        },
        ExpectedResults => [
            {
                "Text3$RandomID" => 'Text1: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                "Text4$RandomID" => [
                    'Text1: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                    'Text2: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                ],
            },
        ],
        Success => 1,
    },
    {
        Name   => 'SetOfAgentsAndTexts',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{SetOfAgentsAndTexts},
            Value              =>

                # a list of Set values
                [

                    # actually only on Set value in the list
                    {

                        # value for the first dynamic field in the set
                        "Text5$RandomID" => 'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',

                        # value for the second dynamic field in the set
                        "Text6$RandomID" => [
                            'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                            'Text4: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                        ],

                        # value for the third dynamic field in the set
                        "Agent1$RandomID" => [$FirstUserID],

                        # value for the fourth dynamic field in the set
                        "Agent2$RandomID" => [
                            $FirstUserID,
                            $SecondUserID,
                        ],
                    },
                ],
            ObjectID => $SourceTicketID,
            UserID   => $UserID,
        },
        ExpectedResults => [
            {
                "Text5$RandomID" => 'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                "Text6$RandomID" => [
                    'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                    'Text4: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                ],
                "Agent1$RandomID" => [$FirstUserID],
                "Agent2$RandomID" => [
                    $FirstUserID,
                    $SecondUserID,
                ],
            },
        ],
        Success => 1,
    },

    # Dynamic Field TicketRef

    # TicketRef SingleSelect
    {
        Name   => 'TicketRef: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'TicketRef: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'TicketRef: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => $FirstReferenceTicketID,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstReferenceTicketID],
        Success         => 1,
    },
    {
        Name   => 'TicketRef: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => [$FirstReferenceTicketID],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstReferenceTicketID],
        Success         => 1,
    },

    # TicketRef Multiselect
    {
        Name   => 'TicketRef Multiselect: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => $FirstReferenceTicketID,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstReferenceTicketID],
        Success         => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => [$FirstReferenceTicketID],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstReferenceTicketID],
        Success         => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value array ref with two ticket ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
        Success         => 1,
    },

    # TicketRef MultiValue
    {
        Name   => 'TicketRef MultiValue: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => undef,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => '',
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => $FirstReferenceTicketID,
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstReferenceTicketID],
        Success         => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [$FirstReferenceTicketID],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [$FirstReferenceTicketID],
        Success         => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with two ticket ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
        Success         => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [undef],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [ $FirstReferenceTicketID, undef, $SecondReferenceTicketID ],
            ObjectID           => $SourceTicketID,
            UserID             => $UserID,
        },
        ExpectedResults => [ $FirstReferenceTicketID, undef, $SecondReferenceTicketID ],
        Success         => 1,
    },
);

# execute tests
TEST:
for my $Test (@Tests) {

    next TEST unless IsHashRefWithData( $Test->{Config} );

    my %Config = $Test->{Config}->%*;

    subtest $Test->{Name} => sub {

        # set value for dynamic field config
        my $Success = $DynamicFieldBackendObject->ValueSet(%Config);

        # check successful value set
        if ( $Test->{Success} ) {
            ok( $Success, 'ValueSet() successfull' );
        }
        else {
            ok( !$Success, 'ValueSet() expected to fail' );
        }

        # retrieve value again
        my $Value = $DynamicFieldBackendObject->ValueGet(%Config);

        # check if value aligns with original input
        if ( $Test->{Success} ) {
            is( $Value, $Test->{ExpectedResults}, "ValueGet()" );
        }
    };
}

done_testing;
