# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

use Test2::V0;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::UnitTest::RegisterOM;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $MaskObject         = $Kernel::OM->Get('Kernel::System::Ticket::Mask');

# Create random test variable.
my $RandomID = $Helper->GetRandomID();

# admin user
my $UserID = 1;

# name of mask
my $Mask = 'AgentTicketPhone';

# test cases
my @TestCases = (
    {
        Name          => 'ValidYAML',
        CreateSuccess => 1,
        DFCount       => 5,
        YAML          => <<"ENDYAML",
---
- DF: Category$RandomID
- DF: Serialnumber$RandomID
  Mandatory: 1
- Grid:
    Columns: 2
    ColumnWidth: 1fr 1fr
    Rows:
      -
        - DF: Part$RandomID
          Readonly: 1
          Label: Part Current
        - DF: PartShould$RandomID
      -
        - DF: TargetDate$RandomID
          ColumnStart: 2
          ColumnSpan: 1
ENDYAML
    },
    {
        Name          => 'InvalidYAML',
        CreateSuccess => 0,
        YAML          => <<"ENDYAML",
---
- DF: Category$RandomID
  - DF: Serialnumber$RandomID
ENDYAML
    },
    {
        Name          => 'SimpleListYAML',
        CreateSuccess => 1,
        DFCount       => 2,
        YAML          => <<"ENDYAML",
---
- DF: Category$RandomID
- DF: Serialnumber$RandomID
ENDYAML
    },
    {
        Name          => 'InvalidKeysYAML',
        CreateSuccess => 1,
        DFCount       => 0,
        YAML          => <<"ENDYAML",
---
- SomeThing: Category$RandomID
- SomeThing: Serialnumber$RandomID
ENDYAML
    },
    {
        Name          => 'InvalidDFYAML',
        CreateSuccess => 0,
        DFCount       => 0,
        YAML          => <<"ENDYAML",
---
- DF: Something$RandomID
- DF: OtherThing$RandomID
ENDYAML
    },
    {
        Name          => 'InvalidGridYAML',
        CreateSuccess => 0,
        DFCount       => 0,
        YAML          => <<"ENDYAML",
---
- DF: Category$RandomID
- DF: Serialnumber$RandomID
  Mandatory: 1
- Grid:
    - DF: Part$RandomID
        Readonly: 1
        Label: Part Current
    - DF: PartShould$RandomID
    - DF: Part$RandomID
        ColumnStart: 2
        ColumnSpan: 1
ENDYAML
    },
    {
        Name          => 'InvalidKeyInGridYAML',
        CreateSuccess => 1,
        DFCount       => 4,
        YAML          => <<"ENDYAML",
---
- DF: Category$RandomID
- DF: Serialnumber$RandomID
  Mandatory: 1
- Grid:
    Columns: 2
    ColumnWidth: 1fr 1fr
    Rows:
        - XX: Part$RandomID
          Readonly: 1
          Label: Part Current
        - DF: PartShould$RandomID
        - DF: Part$RandomID
          ColumnStart: 2
          ColumnSpan: 1
ENDYAML
    },
    {
        Name          => 'InvalidDFInGridYAML',
        CreateSuccess => 0,
        DFCount       => 0,
        YAML          => <<"ENDYAML",
---
- DF: Category$RandomID
- DF: Serialnumber$RandomID
  Mandatory: 1
- Grid:
    Columns: 2
    ColumnWidth: 1fr 1fr
    Rows:
        - DF: XXYYZZ$RandomID
          Readonly: 1
          Label: Part Current
        - DF: PartShould$RandomID
        - DF: Part$RandomID
          ColumnStart: 2
          ColumnSpan: 1
ENDYAML
    },
);

# DF to create for testing
my @IncludeDFConfigs = (

    # Fields to include in SetOfAgentsAndTexts
    {
        Name         => 'Category' . $RandomID,
        Label        => 'Category',
        LabelEscaped => 'Category',
        FieldOrder   => 1,
        FieldType    => 'DropDown',
        ObjectType   => 'Ticket',
        Config       => {
            MultiValue     => 0,
            Tooltip        => '',
            PossibleValues => {
                1 => 1,
                2 => 2,
                3 => 3,
            }
        },
        ValidID => 1,
        UserID  => $UserID,
    },
    {
        Name         => 'Serialnumber' . $RandomID,
        Label        => 'Serialnumber',
        LabelEscaped => 'Serialnumber',
        FieldOrder   => 1,
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
        Name         => 'Part' . $RandomID,
        Label        => 'Part',
        LabelEscaped => 'Part',
        FieldOrder   => 1,
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
        Name         => 'PartShould' . $RandomID,
        Label        => 'PartShould',
        LabelEscaped => 'PartShould',
        FieldOrder   => 1,
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
        Name         => 'TargetDate' . $RandomID,
        Label        => 'TargetDate',
        LabelEscaped => 'PartTargetDateShould',
        FieldOrder   => 1,
        FieldType    => 'Date',
        ObjectType   => 'Ticket',
        Config       => {
            MultiValue => 0,
            Tooltip    => '',
        },
        ValidID => 1,
        UserID  => $UserID,
    },
);

# create the DFs necessary for testing
subtest create_test_dfs => sub {

    for my $IncludeDFConfig (@IncludeDFConfigs) {

        my $Success = $DynamicFieldObject->DynamicFieldAdd(
            $IncludeDFConfig->%*,
        );

        ok( $Success, 'Creation of dynamic field ' . $IncludeDFConfig->{Name} );
    }
};

# run the test cases
for my $TestCase (@TestCases) {

    subtest $TestCase->{Name} => sub {

        my $Result = $MaskObject->DefinitionSet(
            DefinitionString => $TestCase->{YAML},
            Mask             => $Mask,
            UserID           => $UserID,
        );

        ok( $Result->{Success} == $TestCase->{CreateSuccess}, 'Ticket Mask created' );

        if ( $TestCase->{CreateSuccess} ) {

            my $Definition = $MaskObject->DefinitionGet(
                Mask => $Mask,
            );

            ok( IsHashRefWithData($Definition), "Got Definition" );

            my $Count = scalar keys $Definition->{DynamicFields}->%*;
            ok( $Count == $TestCase->{DFCount}, $TestCase->{DFCount} . ' DFs have beend expected, got: ' . $Count );
        }
    };
}

done_testing;
