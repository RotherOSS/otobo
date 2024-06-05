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
use HTTP::Request::Common qw(POST);
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM
use Kernel::System::Web::Request  ();
use Kernel::System::VariableCheck qw(:all);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
my $CustomerUserObject    = $Kernel::OM->Get('Kernel::System::CustomerUser');
my $DFBackendObject       = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $DynamicFieldObject    = $Kernel::OM->Get('Kernel::System::DynamicField');
my $ParamObject           = $Kernel::OM->Get('Kernel::System::Web::Request');
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
ok($FirstUserID);

my $SecondUserID = $UserObject->UserAdd(
    UserFirstname => 'Test',
    UserLastname  => 'User',
    UserLogin     => 'TestUser2' . $RandomID,
    UserPw        => 'some-pass',
    UserEmail     => 'test2' . $RandomID . 'email@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);
ok($SecondUserID);

# create customer companies
my $FirstCustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID          => 'TestCustomerCompany1' . $RandomID,
    CustomerCompanyName => 'TestCustomerCompany1' . $RandomID,
    ValidID             => 1,
    UserID              => $UserID,
);
ok($FirstCustomerCompanyID);

my $SecondCustomerCompanyID = $CustomerCompanyObject->CustomerCompanyAdd(
    CustomerID          => 'TestCustomerCompany2' . $RandomID,
    CustomerCompanyName => 'TestCustomerCompany2' . $RandomID,
    ValidID             => 1,
    UserID              => $UserID,
);
ok($SecondCustomerCompanyID);

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
ok($FirstCustomerUserLogin);

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
ok($SecondCustomerUserLogin);

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
ok($SourceTicketID);

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
ok($FirstReferenceTicketID);

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
ok($SecondReferenceTicketID);

# prepare dynamic fields to include in set
my @IncludeDFConfigs = (

    # Fields to include in SetOfAgentsAndTexts
    {
        Name         => 'Text5' . $RandomID,
        Label        => 'Text5',
        LabelEscaped => 'Text5',
        FieldOrder   => 123,
        FieldType    => 'Text',
        ObjectType   => 'Ticket',
        Config       => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name         => 'Text6' . $RandomID,
        Label        => 'Text6',
        LabelEscaped => 'Text6',
        FieldOrder   => 123,
        FieldType    => 'Text',
        ObjectType   => 'Ticket',
        Config       => {
            MultiValue => 1,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name         => 'Agent1' . $RandomID,
        Label        => 'Agent1',
        LabelEscaped => 'Agent1',
        FieldOrder   => 123,
        FieldType    => 'Agent',
        ObjectType   => 'Ticket',
        Config       => {
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
        Name         => 'Agent2' . $RandomID,
        Label        => 'Agent2',
        LabelEscaped => 'Agent2',
        FieldOrder   => 123,
        FieldType    => 'Agent',
        ObjectType   => 'Ticket',
        Config       => {
            PossibleNone => 1,
            Multiselect  => 0,
            MultiValue   => 1,
            GroupFilter  => [],
            Tooltip      => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
);

for my $IncludeDFConfig (@IncludeDFConfigs) {

    my $Success = $DynamicFieldObject->DynamicFieldAdd(
        $IncludeDFConfig->%*,
    );

    ok( $Success, 'Creation of set-included dynamic field ' . $IncludeDFConfig->{Name} );
}

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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
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
        UserID     => $UserID,
        CreateTime => '2023-02-08 15:08:00',
        ChangeTime => '2023-06-11 17:22:00',
    },
    SetOfAgentsAndTexts => {
        ID            => 123,
        InternalField => 0,
        Name          => 'SetOfAgentsAndTexts',
        Label         => 'Set of agents and texts',
        FieldOrder    => 123,
        FieldType     => 'Set',
        ObjectType    => 'Ticket',
        Config        => {
            MultiValue => 0,
            Tooltip    => '',
            Include    => [
                { DF => 'Text5' . $RandomID },
                { DF => 'Text6' . $RandomID },
                { DF => 'Agent1' . $RandomID },
                { DF => 'Agent2' . $RandomID },
            ],
        },
        ValidID    => 1,
        UserID     => $UserID,
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
        Name   => 'Missing ParamObject and Template',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            ParamObject        => undef,
            Template           => undef,
        },
        Success => 0,
    },
    {
        Name   => 'Missing LayoutObject (W/TransformDates)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            ParamObject        => $ParamObject,
            TransformDates     => 1,
            LayoutObject       => undef
        },
        Success => 0,
    },

    # Dynamic Field Text
    {
        Name   => 'Text: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: wrong template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {
                Some => 'Data',
            },
            ParamObject => $ParamObject,
            CGIParam    => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },

    {
        Name   => 'Text: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Text: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Text: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'Text: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Text},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Text: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'Text: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Text},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },

    # Dynamic Field TextArea
    {
        Name   => 'TextArea: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: wrong template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {
                Some => 'Data',
            },
            ParamObject => $ParamObject,
            CGIParam    => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },

    {
        Name   => 'TextArea: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'TextArea: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'TextArea: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'TextArea: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{TextArea},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => undef,
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'TextArea: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TextArea},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TextAreaField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TextAreaField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },

    # Dynamic Field Checkbox
    # In the case of success, he retured value is 0|1. This depends on whether the input is true or false.
    {
        Name   => 'Checkbox: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 1,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 1,
    },
    {
        # The retured value is 0|1, depending on whether the input is true or false.
        Name   => 'Checkbox: wrong template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                Some => 'Data',
            },
            ParamObject => $ParamObject,
            CGIParam    => {
                DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 1,
    },
    {
        Name   => 'Checkbox: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => undef,
        Success         => 1,
    },
    {
        Name   => 'Checkbox: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            FieldValue => undef,
            UsedValue  => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',    # TODO: is this consistent ?
            UsedValue  => 1,
        }
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',    # TODO: is this consistent ?
            UsedValue  => 1
        },

    },
    {
        Name   => 'Checkbox: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField     => undef,
            DynamicField_CheckboxFieldUsed => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Checkbox},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField     => undef,
            DynamicField_CheckboxFieldUsed => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',    # TODO: is this consistent
            DynamicField_CheckboxFieldUsed => 1,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',    # TODO: is this consistent ?
            DynamicField_CheckboxFieldUsed => 1,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            UsedValue  => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            FieldValue => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            UsedValue  => 0,

        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: UTF8 template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            DynamicField_CheckboxFieldUsed => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Checkbox: empty template and UTF8 ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Checkbox},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CheckboxField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_CheckboxFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CheckboxField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            DynamicField_CheckboxFieldUsed => 0,
        },
        Success => 1,
    },

    # Dynamic Field Dropdown
    {
        Name   => 'Dropdown: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: wrong template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {
                Some => 'Data',
            },
            ParamObject => $ParamObject,
            CGIParam    => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Dropdown: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Dropdown: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'Dropdown: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Dropdown},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => undef,
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'Dropdown: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DropdownField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DropdownField => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },

    # Dynamic Field Multiselect
    {
        Name   => 'Multiselect: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        Success         => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                Some => 'Data',
            },
            ParamObject => $ParamObject,
            CGIParam    => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Multiselect: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
    },
    {
        Name   => 'Multiselect: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField => undef,
        },

        Success => 1,
    },
    {
        Name   => 'Multiselect: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Multiselect},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField => [],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                ['äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß'],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (Normal MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (Normal MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        Success         => 1,
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (ValueStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (ValueStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
    },
    {
        Name   => 'Multiselect: UTF8 template and empty ParamObject (TemplateStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        },
        Success => 1,
    },
    {
        Name   => 'Multiselect: empty template and UTF8 ParamObject (TemplateStructure MultiValue)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Multiselect},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_MultiselectField =>
                    [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_MultiselectField =>
                [ 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß', 'Foo' ],
        },
        Success => 1,
    },

    # Dynamic Field DateTime
    {
        Name   => 'DateTime: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => '0000-00-00 00:00:00',
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 16:45:00',
        Success         => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '0000-00-00 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 16:45:00',
        Success         => 1,
    },
    {
        Name   => 'DateTime: wrong template and Correct ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                Some => 'Data',
            },
            ParamObject => $ParamObject,
            CGIParam    => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 16:45:00',
        Success         => 1,
    },
    {
        Name   => 'DateTime: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{DateTime},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 1,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 1,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: Wrong template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: Correct template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },
    {
        Name   => 'DateTime: empty template and Wrong ParamObject (TemplateStructure NotUsed)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeField =>
                    'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateTimeFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 0,
            DynamicField_DateTimeFieldMonth  => 0,
            DynamicField_DateTimeFieldDay    => 0,
            DynamicField_DateTimeFieldHour   => 0,
            DynamicField_DateTimeFieldMinute => 0,
        },
        Success => 0,
    },
    {
        Name   => 'DateTime: empty template and Correct ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{DateTime},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateTimeFieldUsed   => 0,
                DynamicField_DateTimeFieldYear   => 2013,
                DynamicField_DateTimeFieldMonth  => 8,
                DynamicField_DateTimeFieldDay    => 21,
                DynamicField_DateTimeFieldHour   => 16,
                DynamicField_DateTimeFieldMinute => 45,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateTimeFieldUsed   => 0,
            DynamicField_DateTimeFieldYear   => 2013,
            DynamicField_DateTimeFieldMonth  => 8,
            DynamicField_DateTimeFieldDay    => 21,
            DynamicField_DateTimeFieldHour   => 16,
            DynamicField_DateTimeFieldMinute => 45,
        },
        Success => 1,
    },

    # Dynamic Field Date
    {
        Name   => 'Date: Empty template and no ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Empty template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => '0000-00-00 00:00:00',
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '0000-00-00 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'Date: wrong template and Correct ParamObject (Normal)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                Some => 'Data',
            },
            ParamObject => $ParamObject,
            CGIParam    => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '2013-08-21 00:00:00',
        Success         => 1,
    },
    {
        Name   => 'Date: Empty template and no ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Empty template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 0,
            DynamicField_DateFieldMonth => 0,
            DynamicField_DateFieldDay   => 0,
        },
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 0,
            DynamicField_DateFieldMonth => 0,
            DynamicField_DateFieldDay   => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (ValueStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },
    {
        Name   => 'Date: Empty template and no ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => undef,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Empty template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig      => $DynamicFieldConfigs{Date},
            Template                => {},
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success         => 1,
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 0,
            DynamicField_DateFieldMonth => 0,
            DynamicField_DateFieldDay   => 0,
        },
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 1,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 0,
            DynamicField_DateFieldMonth => 0,
            DynamicField_DateFieldDay   => 0,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (TemplateStructure)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 1,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 1,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (Normal Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => '',
        Success         => 1,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 0,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (ValueStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 1,
            ReturnTemplateStructure => 0,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 0,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },
    {
        Name   => 'Date: Wrong template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        Success => 0,
    },
    {
        Name   => 'Date: Correct template and empty ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            ParamObject             => $ParamObject,
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 0,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },
    {
        Name   => 'Date: empty template and Wrong ParamObject (TemplateStructure NotUsed)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateField     => 'äëïöüÄËÏÖÜáéíóúÁÉÍÓÚñÑ€исß',
                DynamicField_DateFieldUsed => 0,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 0,
            DynamicField_DateFieldYear  => 0,
            DynamicField_DateFieldMonth => 0,
            DynamicField_DateFieldDay   => 0,
        },
        Success => 0,
    },
    {
        Name   => 'Date: empty template and Correct ParamObject (TemplateStructure Not-Used)',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Date},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_DateFieldUsed  => 0,
                DynamicField_DateFieldYear  => 2013,
                DynamicField_DateFieldMonth => 8,
                DynamicField_DateFieldDay   => 21,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_DateFieldUsed  => 0,
            DynamicField_DateFieldYear  => 2013,
            DynamicField_DateFieldMonth => 8,
            DynamicField_DateFieldDay   => 21,
        },
        Success => 1,
    },

    # Dynamic Field Agent
    # Agent SingleSelect
    {
        Name   => 'Agent: Value undef',
        Config => {

            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_Agent => [],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_Agent => [],
        },
        Success => 1,
    },
    {
        Name   => 'Agent: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_Agent => '',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_Agent => [],
        },
        Success => 1,
    },
    {
        Name   => 'Agent: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_Agent => $FirstUserID,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_Agent => [$FirstUserID],
        },
        Success => 1,
    },
    {
        Name   => 'Agent: Value array ref one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{Agent},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_Agent => [$FirstUserID],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_Agent => [$FirstUserID],
        },
        Success => 1,
    },

    # Agent Multiselect
    {
        Name   => 'Agent Multiselect: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMS => [],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMS => [],
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMS => '',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMS => [],
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value one plain user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMS => $FirstUserID,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMS => [$FirstUserID],
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value array ref with one user id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMS => [$FirstUserID],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMS => [$FirstUserID],
        },
        Success => 1,
    },
    {
        Name   => 'Agent Multiselect: Value array ref with two user ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMS => [ $FirstUserID, $SecondUserID ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMS => [ $FirstUserID, $SecondUserID ],
        },
        Success => 1,
    },

    # Agent MultiValue
    {
        Name   => 'Agent MultiValue: Value array ref with undef and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMV => [ undef, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMV => [''],
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with empty string and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMV => [ '', undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMV => [''],
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with one user id and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMV => [ $FirstUserID, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMV => [$FirstUserID],
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with two user ids and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMV => [ $FirstUserID, $SecondUserID, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMV => [ $FirstUserID, $SecondUserID ],
        },
        Success => 1,
    },
    {
        Name   => 'Agent MultiValue: Value array ref with undef inbetween and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{AgentMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_AgentMV => [ $FirstUserID, undef, $SecondUserID, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_AgentMV => [ $FirstUserID, '', $SecondUserID ],
        },
        Success => 1,
    },

    # Dynamic Field CustomerCompany
    # CustomerCompany SingleSelect
    {
        Name   => 'CustomerCompany: Value one plain customer company id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompany},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerCompany => $FirstCustomerCompanyID,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerCompany => [$FirstCustomerCompanyID],
        },
        Success => 1,
    },

    # CustomerCompany Multiselect
    {
        Name   => 'CustomerCompany Multiselect: Value array ref with two customer company ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompanyMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerCompanyMS => [ $FirstCustomerCompanyID, $SecondCustomerCompanyID ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerCompanyMS => [ $FirstCustomerCompanyID, $SecondCustomerCompanyID ],
        },
        Success => 1,
    },

    # CustomerCompany MultiValue
    {
        Name   => 'CustomerCompany MultiValue: Value array ref with undef inbetween and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerCompanyMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerCompanyMV => [ $FirstCustomerCompanyID, undef, $SecondCustomerCompanyID, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerCompanyMV => [ $FirstCustomerCompanyID, '', $SecondCustomerCompanyID ],
        },
        Success => 1,
    },

    # Dynamic Field CustomerUser
    # CustomerUser SingleSelect
    {
        Name   => 'CustomerUser: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUser => [],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUser => [],
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUser => '',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUser => [],
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser: Value one plain customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUser => $FirstCustomerUserLogin,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUser => [$FirstCustomerUserLogin],
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser: Value array ref with one customer user login',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUser},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUser => [$FirstCustomerUserLogin],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUser => [$FirstCustomerUserLogin],
        },
        Success => 1,
    },

    # CustomerUser MultiValue
    {
        Name   => 'CustomerUser MultiValue: Value array ref with undef and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUserMV => [ undef, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUserMV => [''],
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with empty string and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUserMV => [ '', undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUserMV => [''],
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with one customer user login and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUserMV => [ $FirstCustomerUserLogin, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUserMV => [$FirstCustomerUserLogin],
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with two customer user logins and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUserMV => [ $FirstCustomerUserLogin, $SecondCustomerUserLogin, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUserMV => [ $FirstCustomerUserLogin, $SecondCustomerUserLogin ],
        },
        Success => 1,
    },
    {
        Name   => 'CustomerUser MultiValue: Value array ref with undef inbetween and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{CustomerUserMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_CustomerUserMV => [ $FirstCustomerUserLogin, undef, $SecondCustomerUserLogin, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_CustomerUserMV => [ $FirstCustomerUserLogin, '', $SecondCustomerUserLogin ],
        },
        Success => 1,
    },

    # Dynamic Field TicketRef
    # TicketRef SingleSelect
    {
        Name   => 'TicketRef: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRef => [],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRef => [],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRef => '',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRef => [],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRef => $FirstReferenceTicketID,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRef => [$FirstReferenceTicketID],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRef},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRef => [$FirstReferenceTicketID],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRef => [$FirstReferenceTicketID],
        },
        Success => 1,
    },

    # TicketRef Multiselect
    {
        Name   => 'TicketRef Multiselect: Value undef',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMS => [],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMS => [],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value empty string',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMS => '',
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMS => [],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value one plain ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMS => $FirstReferenceTicketID,
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMS => [$FirstReferenceTicketID],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value array ref with one ticket id',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMS => [$FirstReferenceTicketID],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMS => [$FirstReferenceTicketID],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef Multiselect: Value array ref with two ticket ids',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMS},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMS => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMS => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
        },
        Success => 1,
    },

    # TicketRef MultiValue
    {
        Name   => 'TicketRef MultiValue: Value array ref with undef and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMV => [ undef, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMV => [''],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with empty string and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMV => [ '', undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMV => [''],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with one ticket id and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMV => [ $FirstReferenceTicketID, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMV => [$FirstReferenceTicketID],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with two ticket ids and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMV => [ $FirstReferenceTicketID, $SecondReferenceTicketID, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMV => [ $FirstReferenceTicketID, $SecondReferenceTicketID ],
        },
        Success => 1,
    },
    {
        Name   => 'TicketRef MultiValue: Value array ref with undef inbetween and template value',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{TicketRefMV},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                DynamicField_TicketRefMV => [ $FirstReferenceTicketID, undef, $SecondReferenceTicketID, undef ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            DynamicField_TicketRefMV => [ $FirstReferenceTicketID, '', $SecondReferenceTicketID ],
        },
        Success => 1,
    },

    # Set
    {
        Name   => 'Set: Correct value structure',
        Config => {
            DynamicFieldConfig => $DynamicFieldConfigs{SetOfAgentsAndTexts},
            Template           => {},
            ParamObject        => $ParamObject,
            CGIParam           => {
                SetIndex_SetOfAgentsAndTexts => [
                    [],
                ],
                'DynamicField_Text5' . $RandomID . '_0' => 'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                'DynamicField_Text6' . $RandomID . '_0' => [
                    'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                    'Text4: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                    undef,

                ],
                'DynamicField_Agent1' . $RandomID . '_0' => $FirstUserID,
                'DynamicField_Agent2' . $RandomID . '_0' => [
                    $FirstUserID,
                    $SecondUserID,
                    undef,
                ],
            },
            TransformDates          => 0,
            ReturnValueStructure    => 0,
            ReturnTemplateStructure => 1,
        },
        ExpectedResults => {
            "DynamicField_SetOfAgentsAndTexts" => [
                {
                    "Text5$RandomID" => {
                        'DynamicField_Text5' . $RandomID . '_0' => 'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN'
                    },
                    "Text6$RandomID" => {
                        'DynamicField_Text6' . $RandomID . '_0' => [
                            'Text3: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                            'Text4: 🏔 - U+1F3D4 - SNOW CAPPED MOUNTAIN',
                        ],
                    },
                    "Agent1$RandomID" => {
                        'DynamicField_Agent1' . $RandomID . '_0' => [$FirstUserID],
                    },
                    "Agent2$RandomID" => {
                        'DynamicField_Agent2' . $RandomID . '_0' => [
                            $FirstUserID,
                            $SecondUserID,
                        ],
                    },
                },
            ],
        },
        Success => 1,
    },
);

# execute tests
TEST:
for my $Test (@Tests) {

    next TEST unless IsHashRefWithData( $Test->{Config} );

    my %Config = $Test->{Config}->%*;

    # When CGI parameters are given,
    # then create a new CGI object to simulate a web request.
    # CGI parametes overrides ParamObject.
    if ( IsHashRefWithData( $Test->{Config}->{CGIParam} ) ) {
        $Config{ParamObject} = Kernel::System::Web::Request->new(
            HTTPRequest => POST( '/', [ $Test->{Config}->{CGIParam}->%* ] ),
        );
    }

    my $Value = $DFBackendObject->EditFieldValueGet(%Config);

    if ( $Test->{Success} ) {
        is( $Value, $Test->{ExpectedResults}, "$Test->{Name} | EditFieldValueGet()" );
    }
    else {
        ok( !defined $Value, "$Test->{Name} | EditFieldValueGet() not successful", );
    }
}

done_testing;
