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

use Test2::V0;

# OTOBO modules

use Kernel::System::UnitTest::RegisterDriver;    # Set up $Kernel::OM and the test driver $Self

our $Self;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

# Objects used
my $Helper                    = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $TicketObject              = $Kernel::OM->Get('Kernel::System::Ticket');
my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $YAMLObject                = $Kernel::OM->Get('Kernel::System::YAML');

# Test plan
plan 27;

# Test User
my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
    Groups => ['users'],
);

# Dynamic Field ids for test created dynamically
my $TextFieldID;
my $DropDownFieldID;
my $CheckBoxFieldID;
my $DateFieldID;
my $TicketRefFieldID;
my $LensFieldID;
my $DropLensFieldID;
my $CheckLensFieldID;
my $DateLensFieldID;

# Test Ticket ids
my $ReferencedTicketID;
my $FirstReferencingTicketID;
my $SecondReferencingTicketID;

############################################
# Prepare test
############################################

subtest 'Create Dynamic Fields for Test' => sub {

    $TextFieldID      = _CreateDynamicTextField();
    $DropDownFieldID  = _CreateDynamicDropDownField();
    $CheckBoxFieldID  = _CreateDynamicCheckBoxField();
    $DateFieldID      = _CreateDynamicDateField();
    $TicketRefFieldID = _CreateDynamicTicketRefField();
    $LensFieldID      = _CreateDynamicLensField( $TicketRefFieldID, $TextFieldID );
    $DropLensFieldID  = _CreateDynamicDropLensField( $TicketRefFieldID, $DropDownFieldID );
    $CheckLensFieldID = _CreateDynamicCheckBoxLensField( $TicketRefFieldID, $CheckBoxFieldID );
    $DateLensFieldID  = _CreateDynamicDateLensField( $TicketRefFieldID, $DateFieldID );
};

subtest 'Create Test Tickets with DF' => sub {

    $ReferencedTicketID = _CreateTicket(
        TextFieldValue   => 'TheUnitTestSimpleTextValueForSearch',
        TicketRefFieldID => $TicketRefFieldID,
        TicketRefValue   => undef,
        DropDownValue    => 'c',
        CheckBoxValue    => 1,
        DateValue        => '2024-09-01'
    );

    $FirstReferencingTicketID = _CreateTicket(
        TextFieldValue   => 'TheUnitTestSimpleTextValueNotForSearch',
        TicketRefFieldID => $TicketRefFieldID,
        TicketRefValue   => $ReferencedTicketID,
        DropDownValue    => 'a',
        CheckBoxValue    => 0,
        DateValue        => undef,
    );

    $SecondReferencingTicketID = _CreateTicket(
        TextFieldValue   => 'TheUnitTestSimpleTextValueAlsoNotForSearch',
        TicketRefFieldID => $TicketRefFieldID,
        TicketRefValue   => $ReferencedTicketID,
        DropDownValue    => 'a',
        CheckBoxValue    => 0,
        DateValue        => undef,
    );
};

############################################
# Main Test routine to test DF Lense Ticket
# Searches
############################################

sub TestTicketSearch {

    my %Param = @_;

    my $Name     = delete $Param{Name};
    my $Count    = delete $Param{Count};
    my $Expected = delete $Param{Expected};

    # note: remaining %Param hash now has the
    # ticket search condition(s)

    subtest $Name => sub {

        my @TicketIDs = $TicketObject->TicketSearch(
            Result    => 'ARRAY',
            StateType => ['open'],
            UserID    => $TestUserID,
            Limit     => 100,
            CacheTTL  => 0,
            %Param
        );

        is( scalar @TicketIDs, $Count, "Search result count is $Count." );

        my %Hash = map { $_ => $_ } @TicketIDs;

        for my $ExpectedTicket (@$Expected) {
            ok( exists $Hash{$ExpectedTicket}, "Search result has Ticket ID $ExpectedTicket." );
        }
    };

    return;
}

############################################
# Test Cases Table
############################################

my @TestCases = (

    # the most basic search
    {
        Name     => "Simple Search via Title",
        Count    => 3,
        Expected => [ $ReferencedTicketID, $FirstReferencingTicketID, $SecondReferencingTicketID ],
        Title    => '%Some Ticket_Title for Unit-Testing%'
    },

    # the operator equals tests for DF searches
    {
        Name                                 => "Search via DF Text Field",
        Count                                => 1,
        Expected                             => [$ReferencedTicketID],
        DynamicField_UnitTestSimpleTextField => { Equals => 'TheUnitTestSimpleTextValueForSearch' },
    },
    {
        Name                               => "Search via DF Dropdown Field",
        Count                              => 1,
        Expected                           => [$ReferencedTicketID],
        DynamicField_UnitTestDropDownField => { Equals => 'c' },
    },
    {
        Name                                => "Search via DF Ticket Ref Field",
        Count                               => 2,
        Expected                            => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestTicketRefField => { Equals => $ReferencedTicketID },
    },

    # the operator equals tests for DF *Lens* searches
    {
        Name                           => "Search via DF Text-Lens Field",
        Count                          => 2,
        Expected                       => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestLensField => { Equals => 'TheUnitTestSimpleTextValueForSearch' },
    },
    {
        Name                               => "Search via DF Dropdown-Lens Field",
        Count                              => 2,
        Expected                           => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestDropLensField => { Equals => 'c' },
    },
    {
        Name                                   => "Search via DF CheckBox-Lens Field",
        Count                                  => 2,
        Expected                               => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestCheckBoxLensField => { Equals => 1 }
    },
    {
        Name                               => "Search via DF Date-Lens Field",
        Count                              => 2,
        Expected                           => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestDateLensField => { Equals => '2024-09-01' }
    },

    # the operator like tests for DF searches
    {
        Name                                 => "Search via DF Text Field (like)",
        Count                                => 1,
        Expected                             => [$ReferencedTicketID],
        DynamicField_UnitTestSimpleTextField => { Like => 'TheUnitTestSimpleTextValueForSea%' },
    },
    {
        Name                               => "Search via DF Dropdown Field (like)",
        Count                              => 1,
        Expected                           => [$ReferencedTicketID],
        DynamicField_UnitTestDropDownField => { Like => 'c%' },
    },
    {
        Name                                => "Search via DF Ticket Ref Field (like)",
        Count                               => 2,
        Expected                            => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestTicketRefField => { Like => $ReferencedTicketID },
    },

    # the operator like tests for DF *Lens* searches
    {
        Name                           => "Search via DF Text-Lens Field (like)",
        Count                          => 2,
        Expected                       => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestLensField => { Like => 'TheUnitTestSimpleTextValueForSear%' },
    },
    {
        Name                               => "Search via DF Dropdown-Lens Field (like)",
        Count                              => 2,
        Expected                           => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestDropLensField => { Like => 'c%' },
    },
    {
        Name                                   => "Search via DF CheckBox-Lens Field (like) failed as expected.",
        Count                                  => 0,                                                                # there is no like operator for check boxes
        Expected                               => [],
        DynamicField_UnitTestCheckBoxLensField => { Like => 1 },
    },
    {
        Name                               => "Search via DF Date-Lens Field (like) failed as expected.",
        Count                              => 0,                                                                    # there is no like operator for date fields
        Expected                           => [],
        DynamicField_UnitTestDateLensField => { Like => '2024-09-01' }
    },

    # operator SmallerThan Date Lens search
    {
        Name                               => "Search via DF Date-Lens Field (<)",
        Count                              => 2,
        Expected                           => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestDateLensField => { SmallerThan => '2024-09-02' }
    },

    # operator GreaterThan Date Lens search
    {
        Name                               => "Search via DF Date-Lens Field (>)",
        Count                              => 2,
        Expected                           => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestDateLensField => { GreaterThan => '2024-08-31' }
    },

    # combined searches (two and three search conditions)
    {
        Name                               => "Search via DF Text-Lens Field and Dropdown.",
        Count                              => 2,
        Expected                           => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestLensField     => { Equals => 'TheUnitTestSimpleTextValueForSearch' },
        DynamicField_UnitTestDropLensField => { Equals => 'c' },
    },
    {
        Name                                   => "Search via DF Text-Lens Field and CheckBox.",
        Count                                  => 2,
        Expected                               => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestLensField         => { Equals => 'TheUnitTestSimpleTextValueForSearch' },
        DynamicField_UnitTestCheckBoxLensField => { Equals => 1 }
    },
    {
        Name                                   => "Search via DF Text-Lens Field for non existing combined search.",
        Count                                  => 0,
        Expected                               => [],
        DynamicField_UnitTestLensField         => { Equals => 'TheUnitTestSimpleTextValueForSearch' },
        DynamicField_UnitTestCheckBoxLensField => { Equals => 0 }
    },
    {
        Name                                   => "Search via DF Text-Lens Field and CheckBox and Date.",
        Count                                  => 2,
        Expected                               => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestLensField         => { Equals      => 'TheUnitTestSimpleTextValueForSearch' },
        DynamicField_UnitTestCheckBoxLensField => { Equals      => 1 },
        DynamicField_UnitTestDateLensField     => { SmallerThan => '2024-09-02' }
    },

    # test combination of DF and classic field as well
    {
        Name                           => "Search via DF Text-Lens Field and Title standard field.",
        Count                          => 2,
        Expected                       => [ $FirstReferencingTicketID, $SecondReferencingTicketID ],
        DynamicField_UnitTestLensField => { Equals => 'TheUnitTestSimpleTextValueForSearch' },
        Title                          => 'Some Ticket_Title for Unit-Test%',
    },
    {
        Name                           => "Search via DF Text-Lens Field and Title standard field, no result.",
        Count                          => 0,
        Expected                       => [],
        DynamicField_UnitTestLensField => { Equals => 'TheUnitTestSimpleTextValueForSearch' },
        Title                          => 'UnitTestSomethingElse%',
    },
    {
        Name                           => "Search via DF Text-Lens Field and Title standard field, no result.",
        Count                          => 0,
        Expected                       => [],
        DynamicField_UnitTestLensField => { Equals => 'TheUnitTestOtherValue' },
        Title                          => 'Some Ticket_Title for Unit-Test%',
    },

);

# run all test cases
foreach my $TestCase (@TestCases) {

    TestTicketSearch(%$TestCase);
}

# cleanup
$Self->DoneTesting();

########################################################
# Setup test fixture helpers
########################################################

sub _CreateTicket {

    my %Param = @_;

    my $TextFieldValue   = $Param{TextFieldValue};
    my $TicketRefFieldID = $Param{TicketRefFieldID};
    my $TicketRefValue   = $Param{TicketRefValue};
    my $DropDownValue    = $Param{DropDownValue};
    my $CheckBoxValue    = $Param{CheckBoxValue};
    my $DateValue        = $Param{DateValue};

    my $TicketID = $TicketObject->TicketCreate(
        Title    => 'Some Ticket_Title for Unit-Testing',
        Queue    => 'Postmaster',
        Lock     => 'unlock',
        Priority => '3 normal',
        State    => 'open',
        OwnerID  => $TestUserID,
        UserID   => $TestUserID,
    );

    ok( $TicketID, "Got a ticket id." );

    # set the ticket ref DF
    my $Success = _SetDynamicFieldValue(
        TicketID => $TicketID,
        FieldID  => $TicketRefFieldID,
        Value    => $TicketRefValue,
    );

    # set the simple text DF
    $Success = _SetDynamicFieldValue(
        TicketID => $TicketID,
        FieldID  => $TextFieldID,
        Value    => $TextFieldValue
    );

    # set the dropdown value
    $Success = _SetDynamicFieldValue(
        TicketID => $TicketID,
        FieldID  => $DropDownFieldID,
        Value    => $DropDownValue,
    );

    # set the checkbox value
    $Success = _SetDynamicFieldValue(
        TicketID => $TicketID,
        FieldID  => $CheckBoxFieldID,
        Value    => $CheckBoxValue,
    );

    # set the date value
    $Success = _SetDynamicFieldValue(
        TicketID => $TicketID,
        FieldID  => $DateFieldID,
        Value    => $DateValue,
    );

    return $TicketID;
}

sub _CreateDynamicTextField {

    return _CreateDynamicField(
        'UnitTestSimpleTextField',
        1,
        'Text',

        "---\n" .
            "DefaultValue: ''\n" .
            "Link: ''\n" .
            "LinkPreview: ''\n" .
            "MultiValue: '0'\n" .
            "RegExList: []\n" .
            "Tooltip: ''\n",
    );
}

sub _CreateDynamicDropDownField {

    return _CreateDynamicField(
        'UnitTestDropDownField',
        2,
        'Dropdown',

        "---\n" .
            "DefaultValue: a\n" .
            "Link: ''\n" .
            "LinkPreview: ''\n" .
            "MultiValue: '0'\n" .
            "PossibleNone: '0'\n" .
            "PossibleValues:\n" .
            "   a: a\n" .
            "   b: b\n" .
            "   c: c\n" .
            "Tooltip: ''\n" .
            "TranslatableValues: '0'\n" .
            "TreeView: '0'\n"
    );
}

sub _CreateDynamicTicketRefField {

    return _CreateDynamicField(
        'UnitTestTicketRefField',
        3,
        'Ticket',

        "---\n" .
            "DisplayType: ''\n" .
            "EditFieldMode: Dropdown\n" .
            "ImportSearchAttribute: ''\n" .
            "MultiValue: '0'\n" .
            "Multiselect: 0\n" .
            "PossibleNone: '0'\n" .
            "Queue: []\n" .
            "ReferenceFilterList: []\n" .
            "ReferencedObjectType: Ticket\n" .
            "SearchAttribute: ''\n" .
            "Tooltip: ''\n",
    );
}

sub _CreateDynamicLensField {

    my ( $ReferenceDF, $AttributeDF ) = @_;

    return _CreateDynamicField(
        'UnitTestLensField',
        4,
        'Lens',

        "---\n" .
            "AttributeDF: $AttributeDF\n" .
            "ReferenceDF: $ReferenceDF\n" .
            "ReferenceDFName: DynamicField_UnitTestTicketRefField\n" .
            "Tooltip: ''\n"
    );
}

sub _CreateDynamicDropLensField {

    my ( $ReferenceDF, $AttributeDF ) = @_;

    return _CreateDynamicField(
        'UnitTestDropLensField',
        5,
        'Lens',

        "---\n" .
            "AttributeDF: $AttributeDF\n" .
            "ReferenceDF: $ReferenceDF\n" .
            "ReferenceDFName: DynamicField_UnitTestTicketRefField\n" .
            "Tooltip: ''\n"
    );
}

sub _CreateDynamicCheckBoxField {

    return _CreateDynamicField(
        'UnitTestCheckBoxField',
        6,
        'Checkbox',

        "---\n" .
            "DefaultValue: '0'\n" .
            "MultiValue: ~\n" .
            "Tooltip: ''\n"
    );

}

sub _CreateDynamicCheckBoxLensField {

    my ( $ReferenceDF, $AttributeDF ) = @_;

    return _CreateDynamicField(
        'UnitTestCheckBoxLensField',
        7,
        'Lens',

        "---\n" .
            "AttributeDF: $AttributeDF\n" .
            "ReferenceDF: $ReferenceDF\n" .
            "ReferenceDFName: DynamicField_TicketRefField\n" .
            "Tooltip: ''\n"
    );
}

sub _CreateDynamicDateField {

    return _CreateDynamicField(
        'UnitTestDateField',
        8,
        'Date',

        "---\n" .
            "DateRestriction: ''\n" .
            "DefaultValue: 0\n" .
            "Link: ''\n" .
            "LinkPreview: ''\n" .
            "MultiValue: ~\n" .
            "Tooltip: ''\n" .
            "YearsInFuture: '5'\n" .
            "YearsInPast: '5'\n" .
            "YearsPeriod: '0'\n"
    );
}

sub _CreateDynamicDateLensField {

    my ( $ReferenceDF, $AttributeDF ) = @_;

    return _CreateDynamicField(
        'UnitTestDateLensField',
        9,
        'Lens',

        "---\n" .
            "AttributeDF: $AttributeDF\n" .
            "ReferenceDF: $ReferenceDF\n" .
            "ReferenceDFName: DynamicField_TicketRefField\n" .
            "Tooltip: ''\n"
    );
}

sub _CreateDynamicField {

    my ( $Name, $Order, $Type, $Config ) = @_;

    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $Name,
        Label      => $Name,
        FieldOrder => $Order,
        FieldType  => $Type,
        ObjectType => 'Ticket',
        Config     => $YAMLObject->Load( Data => $Config ),
        ValidID    => 1,
        UserID     => $TestUserID
    );

    ok( $FieldID, "Field ID $FieldID : $Name created." );

    return $FieldID;
}

sub _SetDynamicFieldValue {

    my %Param = @_;

    my $DFConfig = $DynamicFieldObject->DynamicFieldGet( ID => $Param{FieldID} );

    my $Success = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DFConfig,
        ObjectID           => $Param{TicketID},
        Value              => $Param{Value},
        UserID             => $TestUserID,
    );

    my $Val = $Param{Value} // "undef";

    ok( $Success, "Set dynamic field " . $DFConfig->{Name} . " value '$Val' success." );

    return $Success;
}
