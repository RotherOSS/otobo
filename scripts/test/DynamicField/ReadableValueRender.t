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

our $Self;

# get helper object
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $DFBackendObject       = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $TicketObject          = $Kernel::OM->Get('Kernel::System::Ticket');
my $UserObject            = $Kernel::OM->Get('Kernel::System::User');

# Create random test variable.
my $RandomID = $Helper->GetRandomID();

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserID = 1;

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
$Self->True( $FirstUserID, 'Creation of first agent' );

my $FirstUserName = $UserObject->UserName(
    UserID => $FirstUserID,
);
my %FirstUserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences( UserID => $FirstUserID );
my $FirstUserNameStrg    = qq{"$FirstUserName" <$FirstUserPreferences{UserEmail}>};

my $SecondUserID = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User',
    UserLogin     => 'TestUser2' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test2' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);
$Self->True( $SecondUserID, 'Creation of second agent' );

my $SecondUserName = $UserObject->UserName(
    UserID => $SecondUserID,
);
my %SecondUserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences( UserID => $SecondUserID );
my $SecondUserNameStrg    = qq{"$SecondUserName" <$SecondUserPreferences{UserEmail}>};

# create customer companies
my $FirstCustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID          => 'TestCustomerCompany1' . $RandomID,
    CustomerCompanyName => 'TestCustomerCompany1' . $RandomID,
    ValidID             => 1,
    UserID              => $UserID,
);
$Self->True( $FirstCustomerCompanyID, 'Creation of first customer company' );

my $SecondCustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID          => 'TestCustomerCompany2' . $RandomID,
    CustomerCompanyName => 'TestCustomerCompany2' . $RandomID,
    ValidID             => 1,
    UserID              => $UserID,
);
$Self->True( $SecondCustomerCompanyID, 'Creation of second customer company' );

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
$Self->True( $FirstCustomerUserLogin, 'Creation of first customer user' );

my %FirstCustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
    User => $FirstCustomerUserLogin,
);
my $FirstCustomerUserStrg = $FirstCustomerUserData{UserMailString};

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
$Self->True( $SecondCustomerUserLogin, 'Creation of second customer user' );

my %SecondCustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
    User => $SecondCustomerUserLogin,
);
my $SecondCustomerUserStrg = $SecondCustomerUserData{UserMailString};

# prepare information for building ticket description
my $ParamHook = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Hook')      || 'Ticket#';
$ParamHook .= $Kernel::OM->Get('Kernel::Config')->Get('Ticket::HookDivider') || '';

# create a source ticket
my $SourceTicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => $UserID,
);
$Self->True( $SourceTicketID, 'Creation of source ticket' );

# create tickets for referencing
my $FirstReferenceTicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $FirstCustomerCompanyID,
    CustomerUser => 'TestCustomer1' . $RandomID . '@example.com',
    OwnerID      => 1,
    UserID       => $UserID,
);
$Self->True( $FirstReferenceTicketID, 'Creation of first reference ticket' );

# create ticket description
my %FirstReferenceTicket = $TicketObject->TicketGet(
    TicketID => $FirstReferenceTicketID,
    UserID   => $UserID,
);

my %FirstReferenceTicketDescription = (
    Normal => $ParamHook . "$FirstReferenceTicket{TicketNumber}",
    Long   => $ParamHook . "$FirstReferenceTicket{TicketNumber}: $FirstReferenceTicket{Title}",
);

my $SecondReferenceTicketID = $TicketObject->TicketCreate(
    Title        => 'Some Ticket Title',
    Queue        => 'Raw',
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => $SecondCustomerCompanyID,
    CustomerUser => 'TestCustomer2' . $RandomID . '@example.com',
    OwnerID      => 1,
    UserID       => $UserID,
);
$Self->True( $SecondReferenceTicketID, 'Creation of second reference ticket' );

# create ticket description
my %SecondReferenceTicket = $TicketObject->TicketGet(
    TicketID => $SecondReferenceTicketID,
    UserID   => $UserID,
);

my %SecondReferenceTicketDescription = (
    Normal => $ParamHook . "$SecondReferenceTicket{TicketNumber}",
    Long   => $ParamHook . "$SecondReferenceTicket{TicketNumber}: $SecondReferenceTicket{Title}",
);

# theres is not really needed to add the dynamic fields for this test, we can define a static
# set of configurations
my %DynamicFieldConfigs = (
    Text => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextField',
        Label         => 'TextField',
        FieldOrder    => 123,
        FieldType     => 'Text',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '',
            Link         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    TextArea => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TextAreaField',
        Label         => 'TextAreaField',
        FieldOrder    => 123,
        FieldType     => 'TextArea',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '',
            Rows         => '',
            Cols         => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Checkbox => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CheckboxField',
        Label         => 'CheckboxField',
        FieldOrder    => 123,
        FieldType     => 'Checkbox',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Dropdown => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DropdownField',
        Label         => 'DropdownField',
        FieldOrder    => 123,
        FieldType     => 'Dropdown',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => '',
            Link               => '',
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Multiselect => {
        ID            => 123,
        InternalField => 0,
        Name          => 'MultiselectField',
        Label         => 'MultiselectField',
        FieldOrder    => 123,
        FieldType     => 'Multiselect',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue       => '',
            PossibleNone       => 1,
            TranslatableValues => '',
            PossibleValues     => {
                1 => 'A',
                2 => 'B',
            },
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    DateTime => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateTimeField',
        Label         => 'DateTimeField',
        FieldOrder    => 123,
        FieldType     => 'DateTime',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '',
            Link          => '',
            YearsPeriod   => '',
            YearsInFuture => '',
            YearsInPast   => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Date => {
        ID            => 123,
        InternalField => 0,
        Name          => 'DateField',
        Label         => 'DateField',
        FieldOrder    => 123,
        FieldType     => 'Date',
        ObjectType    => 'Ticket',
        Config        => {
            DefaultValue  => '',
            Link          => '',
            YearsPeriod   => '',
            YearsInFuture => '',
            YearsInPast   => '',
        },
        ValidID    => 1,
        CreateTime => '2011-02-08 15:08:00',
        ChangeTime => '2011-06-11 17:22:00',
    },
    Agent => {
        ID            => 123,
        InternalField => 0,
        Name          => 'Agent',
        Label         => 'Agent',
        FieldOrder    => 123,
        FieldType     => 'Agent',
        ObjectType    => 'Ticket',
        Config        => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 0,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    AgentMS => {
        ID            => 123,
        InternalField => 0,
        Name          => 'AgentMS',
        Label         => 'AgentMS',
        FieldOrder    => 123,
        FieldType     => 'Agent',
        ObjectType    => 'Ticket',
        Config        => {
            PossibleNone => 1,
            Multiselect  => 1,
            MultiValue   => 0,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    AgentMV => {
        ID            => 123,
        InternalField => 0,
        Name          => 'AgentMV',
        Label         => 'AgentMV',
        FieldOrder    => 123,
        FieldType     => 'Agent',
        ObjectType    => 'Ticket',
        Config        => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 1,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    CustomerCompany => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CustomerCompany',
        Label         => 'CustomerCompany',
        FieldOrder    => 123,
        FieldType     => 'CustomerCompany',
        ObjectType    => 'Ticket',
        Config        => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 0,
            Tooltip      => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    CustomerCompanyMS => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CustomerCompanyMS',
        Label         => 'CustomerCompanyMS',
        FieldOrder    => 123,
        FieldType     => 'CustomerCompany',
        ObjectType    => 'Ticket',
        Config        => {
            PossibleNone => 1,
            Multiselect  => 1,
            MultiValue   => 0,
            Tooltip      => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    CustomerCompanyMV => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CustomerCompanyMV',
        Label         => 'CustomerCompanyMV',
        FieldOrder    => 123,
        FieldType     => 'CustomerCompany',
        ObjectType    => 'Ticket',
        Config        => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 1,
            Tooltip      => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    CustomerUser => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CustomerUser',
        Label         => 'CustomerUser',
        FieldOrder    => 123,
        FieldType     => 'CustomerUser',
        ObjectType    => 'Ticket',
        Config        => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    CustomerUserMV => {
        ID            => 123,
        InternalField => 0,
        Name          => 'CustomerUserMV',
        Label         => 'CustomerUserMV',
        FieldOrder    => 123,
        FieldType     => 'CustomerUser',
        ObjectType    => 'Ticket',
        Config        => {
            MultiValue => 1,
            Tooltip    => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    TicketRef => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TicketRef',
        Label         => 'TicketRef',
        FieldOrder    => 123,
        FieldType     => 'Ticket',
        ObjectType    => 'Ticket',
        Config        => {
            EditFieldMode        => 'Dropdown',
            PossibleNone         => 1,
            Multiselect          => 0,
            MultiValue           => 0,
            ReferenceFilterList  => [],
            ReferencedObjectType => 'Ticket',
            Tooltip              => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    TicketRefMS => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TicketRefMS',
        Label         => 'TicketRefMS',
        FieldOrder    => 123,
        FieldType     => 'Ticket',
        ObjectType    => 'Ticket',
        Config        => {
            EditFieldMode        => 'Dropdown',
            PossibleNone         => 1,
            Multiselect          => 1,
            MultiValue           => 0,
            ReferenceFilterList  => [],
            ReferencedObjectType => 'Ticket',
            Tooltip              => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    TicketRefMV => {
        ID            => 123,
        InternalField => 0,
        Name          => 'TicketRefMV',
        Label         => 'TicketRefMV',
        FieldOrder    => 123,
        FieldType     => 'Ticket',
        ObjectType    => 'Ticket',
        Config        => {
            EditFieldMode        => 'Dropdown',
            PossibleNone         => 1,
            Multiselect          => 0,
            MultiValue           => 1,
            ReferenceFilterList  => [],
            ReferencedObjectType => 'Ticket',
            Tooltip              => '',
        },
        ValidID    => 1,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
);

# define tests
my @Tests = (
    {
        Name    => 'No Params',
        Config  => undef,
        Success => 0,
    },
    {
        Name    => 'Empty Config',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing DynamicFieldConfig',
        Config => {
            DynamicFieldConfig => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Missing Value Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Missing Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value Text',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'ÁäñƱƩ⨅ß',
        },
        ExpectedResults => {
            Value => 'ÁäñƱƩ⨅ß',
            Title => 'ÁäñƱƩ⨅ß',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value TextArea',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Line1\nÁäñƱƩ⨅ß\nLine3',
        },
        ExpectedResults => {
            Value => 'Line1\nÁäñƱƩ⨅ß\nLine3',
            Title => 'Line1\nÁäñƱƩ⨅ß\nLine3',
        },
        Success => 1,
    },
    {
        Name   => 'Value 1 Checkbox',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 1,
        },
        ExpectedResults => {
            Value => '1',
            Title => '1',
        },
        Success => 1,
    },
    {
        Name   => 'Long Value Dropdown',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Looooooooooooooooooooooooooooong',
        },
        ExpectedResults => {
            Value => 'Looooooooooooooooooooooooooooong',
            Title => 'Looooooooooooooooooooooooooooong',
        },
        Success => 1,
    },
    {
        Name   => 'Single Value Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Value1',
        },
        ExpectedResults => {
            Value => 'Value1',
            Title => 'Value1',
        },
        Success => 1,
    },
    {
        Name   => 'Multiple Values Multiselect',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ 'Value1', 'Value2' ],
        },
        ExpectedResults => {
            Value => 'Value1, Value2',
            Title => 'Value1, Value2',
        },
        Success => 1,
    },
    {
        Name   => 'Correct Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '1977-12-12 00:00:00',
        },
        ExpectedResults => {
            Value => '1977-12-12',
            Title => '1977-12-12',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-02-31 00:00:00',
        },
        ExpectedResults => {
            Value => '2013-02-31',
            Title => '2013-02-31',
        },
        Success => 1,
    },
    {
        Name   => 'Correct DateTime Value DateTime',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1977-12-12 12::59:32',
        },
        ExpectedResults => {
            Value => '1977-12-12 12::59:32',
            Title => '1977-12-12 12::59:32',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2013-02-31 56:00:28',
        },
        ExpectedResults => {
            Value => '2013-02-31 56:00:28',
            Title => '2013-02-31 56:00:28',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value Text (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Value              => 'ÁäñƱƩ⨅ß',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Áä...',
            Title => 'ÁäñƱ...',
        },
        Success => 1,
    },
    {
        Name   => 'UTF8 Value TextArea (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Value              => 'Line1\nÁäñƱƩ⨅ß\nLine3',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Li...',
            Title => 'Line...',
        },
        Success => 1,
    },
    {
        Name   => 'Value Other Checkbox (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Value              => 'Other',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Other',
            Title => 'Other',
        },
        Success => 1,
    },
    {
        Name   => 'Long Value Dropdown (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Value              => 'Looooooooooooooooooooooooooooong',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Lo...',
            Title => 'Looo...',
        },
        Success => 1,
    },
    {
        Name   => 'Single Value Multiselect (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => 'Value1',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Va...',
            Title => 'Valu...',
        },
        Success => 1,
    },
    {
        Name   => 'Multiple Values Multiselect (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Value              => [ 'Value1', 'Value2' ],
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => 'Va...',
            Title => 'Valu...',
        },
        Success => 1,
    },
    {
        Name   => 'Correct Date Value Date (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '1977-12-12 00:00:00',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '1977-12-12',
            Title => '1977-12-12',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Value              => '2013-02-31 00:00:00',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '2013-02-31',
            Title => '2013-02-31',
        },
        Success => 1,
    },
    {
        Name   => 'Correct DateTime Value DateTime (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '1977-12-12 12::59:32',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '1977-12-12 12::59:32',
            Title => '1977-12-12 12::59:32',
        },
        Success => 1,
    },
    {
        Name   => 'Incorrect Date Value Date (reduced)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Value              => '2013-02-31 56:00:28',
            ValueMaxChars      => 2,
            TitleMaxChars      => 4,
        },
        ExpectedResults => {
            Value => '2013-02-31 56:00:28',
            Title => '2013-02-31 56:00:28',
        },
        Success => 1,
    },

    # Dynamic Field Agent
    # Agent SingleSelect
    {
        Name   => 'Agent: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Agent: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Agent: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => $FirstUserID,
        },
        ExpectedResults => {
            Value => $FirstUserNameStrg,
            Title => $FirstUserNameStrg,
        },
        Success => 1,
    },
    {
        Name   => 'Agent: Value array ref one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Value              => [$FirstUserID],
        },
        ExpectedResults => {
            Value => $FirstUserNameStrg,
            Title => $FirstUserNameStrg,
        },
        Success => 1,
    },

    # Agent Multiselect
    {
        Name   => 'Agent Multiselect: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => $FirstUserID,
        },
        ExpectedResults => {
            Value => $FirstUserNameStrg,
            Title => $FirstUserNameStrg,
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value array ref with one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => [$FirstUserID],
        },
        ExpectedResults => {
            Value => $FirstUserNameStrg,
            Title => $FirstUserNameStrg,
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value array ref with two user ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Value              => [ $FirstUserID, $SecondUserID ],
        },
        ExpectedResults => {
            Value => "$FirstUserNameStrg, $SecondUserNameStrg",
            Title => "$FirstUserNameStrg, $SecondUserNameStrg",
        },
        Success => 1,
    },

    # Agent MultiValue
    {
        Name   => 'Agent MultiValue: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => $FirstUserID,
        },
        ExpectedResults => {
            Value => $FirstUserNameStrg,
            Title => $FirstUserNameStrg,
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [$FirstUserID],
        },
        ExpectedResults => {
            Value => $FirstUserNameStrg,
            Title => $FirstUserNameStrg,
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with two user ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [ $FirstUserID, $SecondUserID ],
        },
        ExpectedResults => {
            Value => "$FirstUserNameStrg, $SecondUserNameStrg",
            Title => "$FirstUserNameStrg, $SecondUserNameStrg",
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [undef],
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Value              => [ $FirstUserID, undef, $SecondUserID ],
        },
        ExpectedResults => {
            Value => "$FirstUserNameStrg, , $SecondUserNameStrg",
            Title => "$FirstUserNameStrg, , $SecondUserNameStrg",
        },
        Success => 1,
    },

    # Dynamic Field CustomerCompany
    # CustomerCompany SingleSelect
    {
        Name   => 'CustomerCompany: Value one plain customer company id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompany},
            Value              => $FirstCustomerCompanyID,
        },
        ExpectedResults => {
            Value => $FirstCustomerCompanyID,
            Title => $FirstCustomerCompanyID,
        },
        Success => 1,
    },

    # CustomerCompany Multiselect
    {
        Name   => 'CustomerCompany Multiselect: Value array ref with two customer company ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompanyMS},
            Value              => [ $FirstCustomerCompanyID, $SecondCustomerCompanyID ],
        },
        ExpectedResults => {
            Value => "$FirstCustomerCompanyID, $SecondCustomerCompanyID",
            Title => "$FirstCustomerCompanyID, $SecondCustomerCompanyID",
        },
        Success => 1,
    },

    # CustomerCompany MultiValue
    {
        Name   => 'CustomerCompany MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompanyMV},
            Value              => [ $FirstCustomerCompanyID, undef, $SecondCustomerCompanyID ],
        },
        ExpectedResults => {
            Value => "$FirstCustomerCompanyID, , $SecondCustomerCompanyID",
            Title => "$FirstCustomerCompanyID, , $SecondCustomerCompanyID",
        },
        Success => 1,
    },

    # Dynamic Field CustomerUser
    # CustomerUser SingleSelect
    {
        Name   => 'CustomerUser: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser: Value one plain customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => $FirstCustomerUserLogin,
        },
        ExpectedResults => {
            Value => $FirstCustomerUserStrg,
            Title => $FirstCustomerUserStrg,
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser: Value array ref with one customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Value              => [$FirstCustomerUserLogin],
        },
        ExpectedResults => {
            Value => $FirstCustomerUserStrg,
            Title => $FirstCustomerUserStrg,
        },
        Success => 1,
    },

    # CustomerUser MultiValue
    {
        Name   => 'CustomerUser MultiValue: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value one plain customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => $FirstCustomerUserLogin,
        },
        ExpectedResults => {
            Value => $FirstCustomerUserStrg,
            Title => $FirstCustomerUserStrg,
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with one customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [$FirstCustomerUserLogin],
        },
        ExpectedResults => {
            Value => $FirstCustomerUserStrg,
            Title => $FirstCustomerUserStrg,
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with two customer user logins',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [ $FirstCustomerUserLogin, $SecondCustomerUserLogin ],
        },
        ExpectedResults => {
            Value => "$FirstCustomerUserStrg, $SecondCustomerUserStrg",
            Title => "$FirstCustomerUserStrg, $SecondCustomerUserStrg",
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [undef],
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Value              => [ $FirstCustomerUserLogin, undef, $SecondCustomerUserLogin ],
        },
        ExpectedResults => {
            Value => "$FirstCustomerUserStrg, , $SecondCustomerUserStrg",
            Title => "$FirstCustomerUserStrg, , $SecondCustomerUserStrg",
        },
        Success => 1,
    },

    # Dynamic Field TicketRef
    # TicketRef SingleSelect
    {
        Name   => 'TicketRef: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => $FirstReferenceTicketID,
        },
        ExpectedResults => {
            Value => $FirstReferenceTicketDescription{Long},
            Title => $FirstReferenceTicketDescription{Long},
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Value              => [$FirstReferenceTicketID],
        },
        ExpectedResults => {
            Value => $FirstReferenceTicketDescription{Long},
            Title => $FirstReferenceTicketDescription{Long},
        },
        Success => 1,
    },

    # TicketRef Multiselect
    {
        Name   => 'TicketRef Multiselect: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => $FirstReferenceTicketID,
        },
        ExpectedResults => {
            Value => $FirstReferenceTicketDescription{Long},
            Title => $FirstReferenceTicketDescription{Long},
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => [$FirstReferenceTicketID],
        },
        ExpectedResults => {
            Value => $FirstReferenceTicketDescription{Long},
            Title => $FirstReferenceTicketDescription{Long},
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value array ref with two ticket ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Value              => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
        },
        ExpectedResults => {
            Value => "$FirstReferenceTicketDescription{Long}, $SecondReferenceTicketDescription{Long}",
            Title => "$FirstReferenceTicketDescription{Long}, $SecondReferenceTicketDescription{Long}",
        },
        Success => 1,
    },

    # TicketRef MultiValue
    {
        Name   => 'TicketRef MultiValue: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => undef,
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => '',
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => $FirstReferenceTicketID,
        },
        ExpectedResults => {
            Value => $FirstReferenceTicketDescription{Long},
            Title => $FirstReferenceTicketDescription{Long},
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [$FirstReferenceTicketID],
        },
        ExpectedResults => {
            Value => $FirstReferenceTicketDescription{Long},
            Title => $FirstReferenceTicketDescription{Long},
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with two ticket ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
        },
        ExpectedResults => {
            Value => "$FirstReferenceTicketDescription{Long}, $SecondReferenceTicketDescription{Long}",
            Title => "$FirstReferenceTicketDescription{Long}, $SecondReferenceTicketDescription{Long}",
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [undef],
        },
        ExpectedResults => {
            Value => '',
            Title => '',
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with undef inbetween',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Value              => [ $FirstReferenceTicketID, undef, $SecondReferenceTicketID ],
        },
        ExpectedResults => {
            Value => "$FirstReferenceTicketDescription{Long}, , $SecondReferenceTicketDescription{Long}",
            Title => "$FirstReferenceTicketDescription{Long}, , $SecondReferenceTicketDescription{Long}",
        },
        Success => 1,
    },
);

# execute tests
for my $Test (@Tests) {

    my $ValueStrg = $DFBackendObject->ReadableValueRender( %{ $Test->{Config} } );

    if ( $Test->{Success} ) {
        $Self->IsDeeply(
            $ValueStrg,
            $Test->{ExpectedResults},
            "$Test->{Name} | ReadableValueRender()",
        );
    }
    else {
        $Self->Is(
            $ValueStrg,
            undef,
            "$Test->{Name} | ReadableValueRender() should be undef",
        );
    }
}

# we don't need any cleanup

$Self->DoneTesting();
