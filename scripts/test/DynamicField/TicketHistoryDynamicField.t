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
use Kernel::System::UnitTest::RegisterOM;    # set up $Kernel::OM

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
ok( $BackendObject, 'Backend object was created' );
isa_ok(
    $BackendObject,
    ['Kernel::System::DynamicField::Backend'],
    'Backend object was created successfully',
);

# always random number with the same number of digits
my $RandomID = $Helper->GetRandomNumber();
$RandomID = substr $RandomID, -7, 7;

# keep track of dynamic fields
my @FieldIDs;

# create a dynamic field with short name length (21 characters)
my $FieldID1 = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "TestTextArea$RandomID",
    Label      => 'TestTextAreaShortName',
    FieldOrder => 9991,
    FieldType  => 'TextArea',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'TestTextAreaShortName',
    },
    ValidID => 1,
    UserID  => 1,
);

if ($FieldID1) {
    push @FieldIDs, $FieldID1;
}

# sanity check
ok( $FieldID1, "DynamicFieldAdd() successful for Field ID $FieldID1" );

# create a dynamic field with long name length (166 characters)
my $FieldID2 = $DynamicFieldObject->DynamicFieldAdd(
    Name =>
        "TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea$RandomID",
    Label      => 'TestTextArea_long',
    FieldOrder => 9992,
    FieldType  => 'TextArea',
    ObjectType => 'Ticket',
    Config     => {
        DefaultValue => 'TestTextAreaLongName',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
ok( $FieldID2, "DynamicFieldAdd() successful for Field ID $FieldID2" );
if ($FieldID2) {
    push @FieldIDs, $FieldID2;
}

# get the Dynamic Fields configuration
my $DynamicFieldsConfig = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Driver');
ref_ok( $DynamicFieldsConfig, 'HASH', 'Dynamic Field configuration' );
isnt(
    $DynamicFieldsConfig,
    {},
    'Dynamic Field configuration is not empty',
);

# check the relevant registered backend delegates
for my $FieldType ('TextArea') {
    ok(
        $BackendObject->{ 'DynamicField' . $FieldType . 'Object' },
        "Backend delegate for field type $FieldType was created",
    );
    isa_ok(
        $BackendObject->{ 'DynamicField' . $FieldType . 'Object' },
        [ $DynamicFieldsConfig->{$FieldType}->{Module} ],
        "Backend delegate for field type $FieldType was created successfully",
    );
}

# Tests for different length of Dynamic Field name and Value
# short value there is 12 characters
# long value there is 159 characters
# extra-long value there is 318 characters

my @Tests = (
    {
        Name               => 'short Value for short field name',
        DynamicFieldConfig => {
            ID         => $FieldID1,
            Name       => "TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },
        Value        => 'TestTextArea',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => 'TestTextArea_FirstValue',
        ExpectedData =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea%%OldValue%%TestTextArea_FirstValue",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea_FirstValue%%OldValue%%",
    },
    {
        Name               => 'long Value for short field name',
        DynamicFieldConfig => {
            ID         => $FieldID1,
            Name       => "TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },
        Value =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => 'TestTextArea_FirstValue',
        ExpectedData =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9Te[...]%%OldValue%%TestTextArea_FirstValue",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea_FirstValue%%OldValue%%",
    },

    {
        Name               => 'extra long Value for short field name',
        DynamicFieldConfig => {
            ID         => $FieldID1,
            Name       => "TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },

        Value =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => 'TestTextArea_FirstValue',
        ExpectedData =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9Te[...]%%OldValue%%TestTextArea_FirstValue",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea_FirstValue%%OldValue%%",
    },
    {
        Name               => 'short Value for long field name',
        DynamicFieldConfig => {
            ID   => $FieldID2,
            Name =>
                "TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },

        Value        => 'TestTextArea',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => 'TestTextArea_FirstValue',
        ExpectedData =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextA[...]%%Value%%TestTextArea%%OldValue%%TestTextArea_FirstValue",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTex[...]%%Value%%TestTextArea_FirstValue%%OldValue%%",
    },
    {
        Name               => 'long Value for long field name',
        DynamicFieldConfig => {
            ID   => $FieldID2,
            Name =>
                "TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },

        Value =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => 'TestTextArea_FirstValue',
        ExpectedData =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5T[...]%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5T[...]%%OldValue%%TestTextArea_FirstValue",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTex[...]%%Value%%TestTextArea_FirstValue%%OldValue%%",
    },
    {
        Name               => 'extra-long Value for long field name',
        DynamicFieldConfig => {
            ID   => $FieldID2,
            Name =>
                "TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },

        Value =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => 'TestTextArea_FirstValue',
        ExpectedData =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5T[...]%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5T[...]%%OldValue%%TestTextArea_FirstValue",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTex[...]%%Value%%TestTextArea_FirstValue%%OldValue%%",
    },
    {
        Name               => 'extra-long Value for long field name  and short FirstValue',
        DynamicFieldConfig => {
            ID   => $FieldID2,
            Name =>
                "TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },

        Value =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => 'TestTextArea_FirstValue_Short',
        ExpectedData =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextAre[...]%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextAre[...]%%OldValue%%TestTextArea_FirstValue_Short",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10T[...]%%Value%%TestTextArea_FirstValue_Short%%OldValue%%",
    },
    {
        Name               => 'extra-long Value for long field name and long FirstValue',
        DynamicFieldConfig => {
            ID   => $FieldID2,
            Name =>
                "TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },

        Value =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12',
        UserID     => 1,
        Success    => 1,
        ShouldGet  => 1,
        FirstValue =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6_FirstValue_Long',
        ExpectedData =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextAre[...]%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextAre[...]%%OldValue%%TestTextArea1TestTextArea2TestTextArea3TestTextAre[...]",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6[...]%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6[...]%%OldValue%%",
    },
    {
        Name               => 'empty Value and long FirstValue',
        DynamicFieldConfig => {
            ID   => $FieldID2,
            Name =>
                "TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },

        Value      => '',
        UserID     => 1,
        Success    => 1,
        ShouldGet  => 1,
        FirstValue =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TextArea7TextArea8TextArea9TextArea10TextArea11TextArea12TextArea13TextArea14TextArea15_FirstValue_Long',
        ExpectedData =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%%%OldValue%%TestTextArea1TestTextArea2TestTextArea3TestTextAre[...]",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TextArea7TextArea8TextArea9TextArea10TextArea11TextArea12TextAre[...]%%OldValue%%",
    },
    {
        Name               => 'long Value and empty FirstValue, only a single history line',
        DynamicFieldConfig => {
            ID         => $FieldID2,
            Name       => "TestTextArea$RandomID",
            ObjectType => 'Ticket',
            FieldType  => 'TextArea',
            Config     => {
                DefaultValue => 'TestTextArea',
            },
        },
        Value =>
            'TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextArea11TestTextArea12',
        UserID       => 1,
        Success      => 1,
        ShouldGet    => 1,
        FirstValue   => '',
        ExpectedData =>
            "this is never checked as there is no history line with OldValue",
        ExpectedDataWitoutOld =>
            "%%FieldName%%TestTextArea$RandomID%%Value%%TestTextArea1TestTextArea2TestTextArea3TestTextArea4TestTextArea5TestTextArea6TestTextArea7TestTextArea8TestTextArea9TestTextArea10TestTextAre[...]%%OldValue%%",
    },
);

for my $Test (@Tests) {
    subtest $Test->{Name} => sub {

        # create a ticket for test DynamicField Value
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'unittest' . $RandomID,
            CustomerUser => 'customer@example.com',
            OwnerID      => 1,
            UserID       => 1,
        );
        ok( $TicketID, "TicketCreate() successful for Ticket ID $TicketID" );

        #  set value of dynamic field, OldValue is not set on TicketCreate
        my $Success = $BackendObject->ValueSet(
            DynamicFieldConfig => $Test->{DynamicFieldConfig},
            ObjectID           => $TicketID,
            Value              => $Test->{FirstValue},
            UserID             => $Test->{UserID},
        );

        #  update value of dynamic field for ticket history to set OldValue
        $Success = $BackendObject->ValueSet(
            DynamicFieldConfig => $Test->{DynamicFieldConfig},
            ObjectID           => $TicketID,
            Value              => $Test->{Value},
            UserID             => $Test->{UserID},
        );

        if ( !$Test->{Success} ) {
            ok( !$Success, "ValueSet() failed" );

            # Try to get the value with ValueGet()
            my $Value = $BackendObject->ValueGet(
                DynamicFieldConfig => $Test->{DynamicFieldConfig},
                ObjectID           => $TicketID,
            );

            # fix Value if it's an array ref
            if ( defined $Value && ref $Value eq 'ARRAY' ) {
                $Value = join ',', $Value->@*;
            }

            # compare data
            if ( $Test->{ShouldGet} ) {
                isnt(
                    $Value,
                    $Test->{Value},
                    "ValueGet() after unsuccessful ValueSet() - Value",
                );
            }
            else {
                is(
                    $Value,
                    undef,
                    "ValueGet() after unsuccessful ValueSet() - Value undef",
                );
            }

        }
        else {
            ok( $Success, "ValueSet() - was successful" );

            # get the value with ValueGet()
            my $Value = $BackendObject->ValueGet(
                DynamicFieldConfig => $Test->{DynamicFieldConfig},
                ObjectID           => $TicketID,
            );

            # workaround for oracle
            # oracle databases can't determine the difference between NULL and ''
            if ( !defined $Value || $Value eq '' ) {

                # test falseness
                ok( !$Value, "ValueGet() after successful ValueSet() - Value (Special case for '')" );
            }
            else {

                # compare data
                is(
                    $Value,
                    $Test->{Value},
                    "ValueGet() after successful ValueSet() - Value",
                );
            }

            # look at the dynamic field update in the ticket history
            my @HistoryLines = $TicketObject->HistoryGet(
                UserID   => 1,
                TicketID => $TicketID,
            );

            HISTORY_LINE:
            for my $HistoryEntry (@HistoryLines) {
                next HISTORY_LINE unless $HistoryEntry->{HistoryType} eq 'TicketDynamicFieldUpdate';

                my $ResultEntryDynamicField = 'Name';

                # check if there is OldValue
                ( my $CheckOldValue ) = $HistoryEntry->{$ResultEntryDynamicField} =~ m/\%\%OldValue\%\%(?:(.+?))?$/;
                if ($CheckOldValue) {
                    is(
                        $HistoryEntry->{$ResultEntryDynamicField},
                        $Test->{ExpectedData},
                        "HistoryLine for Ticket DynamicField Update - History Name for ticket $TicketID"
                    );
                }
                else {
                    is(
                        $HistoryEntry->{$ResultEntryDynamicField},
                        $Test->{ExpectedDataWitoutOld},
                        "HistoryLines for TicketCreate - History Name for ticket $TicketID"
                    );
                }
            }
        }
    };
}

done_testing;
