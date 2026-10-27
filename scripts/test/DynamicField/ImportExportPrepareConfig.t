# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

# Import and export of dynamic field configs, see issue #6227.
#
# Part 1: ImportExportPrepareConfig() of the drivers, checked against their POD:
#         "For export, the Name is needed ... During import, the Name needs to be
#         translated back into the ID". Shows which direction each driver implements.
# Part 2: DynamicFieldConfigID2Name() (export) and DynamicFieldConfigName2ID() (import)
#         of Kernel::System::DynamicField for the fields with ID based config attributes.
# Part 3: complete round trip like AdminDynamicFieldImportExport does it, for one field
#         of every field type registered in the OTOBO standard:
#           create -> export -> delete -> import (new IDs, like another system) -> compare
#
# The package ITSMConfigurationManagement has an own test for its field types and
# for the Lens driver it overrides (Custom/Kernel/System/DynamicField/Driver/Lens.pm).

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use Test2::V0;

# OTOBO modules
use Kernel::System::UnitTest::RegisterOM;
use Kernel::System::VariableCheck qw(IsHashRefWithData);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
my $StorableObject     = $Kernel::OM->Get('Kernel::System::Storable');

my $RandomID = $Helper->GetRandomID;

# work on copies, the tested functions change the passed config in place
sub Clone {
    my ($Data) = @_;

    return $StorableObject->Clone( Data => $Data );
}

# the driver object of a field type, taken from the registration like the code under test does
sub DriverObjectGet {
    my ($FieldType) = @_;

    my $DriverConfig = $ConfigObject->Get('DynamicFields::Driver') // {};
    my $DriverModule = $DriverConfig->{$FieldType}->{Module};

    return $Kernel::OM->Get($DriverModule);
}

# ------------------------------------------------------------ #
# setup: objects which are referenced by ID in field configs
# ------------------------------------------------------------ #

my $QueueName = "Queue$RandomID";
my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Unit test queue',
    UserID          => 1,
);
ok( $QueueID, "queue $QueueName created" );

my $TypeName = "Type$RandomID";
my $TypeID   = $Kernel::OM->Get('Kernel::System::Type')->TypeAdd(
    Name    => $TypeName,
    ValidID => 1,
    UserID  => 1,
);
ok( $TypeID, "ticket type $TypeName created" );

my $GroupName = "Group$RandomID";
my $GroupID   = $Kernel::OM->Get('Kernel::System::Group')->GroupAdd(
    Name    => $GroupName,
    ValidID => 1,
    UserID  => 1,
);
ok( $GroupID, "group $GroupName created" );

# ------------------------------------------------------------ #
# setup: one dynamic field of every field type of the OTOBO standard
# ------------------------------------------------------------ #

# field definitions in creation order, dependencies first
# Lens fields reference other fields by ID, the IDs are filled in during creation
my @FieldDefinitions = (
    {
        Name      => "Text$RandomID",
        FieldType => 'Text',
        Config    => {
            DefaultValue => 'default',
            RegExList    => []
        },
    },
    {
        Name      => "TextArea$RandomID",
        FieldType => 'TextArea',
        Config    => {
            DefaultValue => '',
            Rows         => 7,
            Cols         => 42
        },
    },
    {
        Name      => "RichText$RandomID",
        FieldType => 'RichText',
        Config    => { DefaultValue => '' },
    },
    {
        Name      => "Checkbox$RandomID",
        FieldType => 'Checkbox',
        Config    => { DefaultValue => 1 },
    },
    {
        Name      => "Dropdown$RandomID",
        FieldType => 'Dropdown',
        Config    => {
            PossibleValues => {
                a => 'A',
                b => 'B'
            },
            PossibleNone       => 1,
            TranslatableValues => 0,
            TreeView           => 0,
            DefaultValue       => 'a',
        },
    },
    {
        Name      => "Multiselect$RandomID",
        FieldType => 'Multiselect',
        Config    => {
            PossibleValues => {
                x => 'X',
                y => 'Y'
            },
            PossibleNone       => 0,
            TranslatableValues => 1,
            TreeView           => 0,
            DefaultValue       => ['x'],
        },
    },
    {
        Name      => "Date$RandomID",
        FieldType => 'Date',
        Config    => {
            DefaultValue  => 0,
            YearsInFuture => 5,
            YearsInPast   => 5,
            YearsPeriod   => 1
        },
    },
    {
        Name      => "DateTime$RandomID",
        FieldType => 'DateTime',
        Config    => {
            DefaultValue  => 0,
            YearsInFuture => 5,
            YearsInPast   => 5,
            YearsPeriod   => 0
        },
    },
    {
        Name      => "Title$RandomID",
        FieldType => 'Title',
        Config    => {
            CBFontStyle          => 'default',
            CBFontStyleUnderLine => 0
        },
    },
    {
        Name      => "Script$RandomID",
        FieldType => 'ScriptTemplateToolkit',
        Config    => {
            Template     => '[% 6 * 7 %]',
            RequiredArgs => [],
            TemplateType => 'Text'
        },
    },
    {
        Name      => "Database$RandomID",
        FieldType => 'Database',
        Config    => {
            DBType         => 'mysql',
            Server         => 'localhost',
            Port           => 3306,
            DBName         => 'example',
            DBTable        => 'example_table',
            User           => 'example',
            Password       => 'example',
            Identifier     => 1,
            PossibleValues => {},
        },
    },
    {
        Name      => "WebService$RandomID",
        FieldType => 'WebService',
        Config    => {
            Webservice      => 'ExampleWebservice',
            InvokerSearch   => 'Search',
            InvokerGet      => 'Get',
            StoredValue     => 'ID',
            DisplayedValues => 'Name',
        },
    },
    {
        Name      => "ContactWD$RandomID",
        FieldType => 'ContactWD',
        Config    => {
            ContactsWithData        => {},
            MandatoryFieldsComputed => [],
        },
    },
    {
        Name      => "CustomerUser$RandomID",
        FieldType => 'CustomerUser',
        Config    => {
            ReferencedObjectType => 'CustomerUser',
            EditFieldMode        => 'AutoComplete',
            MultiValue           => 0
        },
    },
    {
        Name      => "CustomerCompany$RandomID",
        FieldType => 'CustomerCompany',
        Config    => {
            ReferencedObjectType => 'CustomerCompany',
            EditFieldMode        => 'Dropdown',
            MultiValue           => 0
        },
    },
    {
        Name      => "Agent$RandomID",
        FieldType => 'Agent',
        Config    => {
            ReferencedObjectType => 'Agent',
            EditFieldMode        => 'Dropdown',
            MultiValue           => 0,
            Group                => [$GroupID],
        },
    },
    {
        Name      => "Ticket$RandomID",
        FieldType => 'Ticket',
        Config    => {
            ReferencedObjectType => 'Ticket',
            EditFieldMode        => 'AutoComplete',
            MultiValue           => 0,
            Queue                => [$QueueID],
            TicketType           => [$TypeID],
        },
    },
    {
        Name      => "ProcessID$RandomID",
        FieldType => 'ProcessID',
        Config    => { DefaultValue => '' },
    },
    {
        Name      => "ActivityID$RandomID",
        FieldType => 'ActivityID',
        Config    => { DefaultValue => '' },
    },

    # Lens: AttributeDF and ReferenceDF are stored as IDs
    {
        Name      => "Lens$RandomID",
        FieldType => 'Lens',
        Config    => { MultiValue => 0 },
        LensOf    => {
            AttributeDF => "Text$RandomID",
            ReferenceDF => "Ticket$RandomID"
        },
    },

    # Lens on a Lens
    {
        Name      => "LensOfLens$RandomID",
        FieldType => 'Lens',
        Config    => { MultiValue => 0 },
        LensOf    => {
            AttributeDF => "Lens$RandomID",
            ReferenceDF => "Ticket$RandomID"
        },
    },

    # Set: included fields are stored by name
    {
        Name      => "Set$RandomID",
        FieldType => 'Set',
        Config    => {
            MultiValue => 1,
            Include    => [
                { DF => "TextArea$RandomID" },
                { DF => "Dropdown$RandomID" },
            ],
        },
    },
);

my %FieldID;    # name -> ID in the "source" system
my $FieldOrder = 9000;
for my $Definition (@FieldDefinitions) {
    my %Config = $Definition->{Config}->%*;

    # replace field names by the IDs of the already created fields
    if ( $Definition->{LensOf} ) {
        for my $Attribute ( keys $Definition->{LensOf}->%* ) {
            $Config{$Attribute} = $FieldID{ $Definition->{LensOf}{$Attribute} };
        }
    }

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $Definition->{Name},
        Label      => "Label $Definition->{Name}",
        FieldOrder => $FieldOrder++,
        FieldType  => $Definition->{FieldType},
        ObjectType => 'Ticket',
        Config     => \%Config,
        ValidID    => 1,
        UserID     => 1,
        Reorder    => 0,
    );
    ok( $ID, "source system: $Definition->{FieldType} field $Definition->{Name} created" );
    $FieldID{ $Definition->{Name} } = $ID;
}

my @FieldNames = map { $_->{Name} } @FieldDefinitions;
my %Original   = map { $_ => $DynamicFieldObject->DynamicFieldGet( Name => $_ ) } @FieldNames;

# make sure that the test stays meaningful when new field types are added
subtest 'every registered field type of the OTOBO standard is covered' => sub {
    my %Covered = map { $_->{FieldType} => 1 } @FieldDefinitions;

    # field types of installed packages are tested by the packages
    my %PackageFieldTypes = map { $_ => 1 } qw(Attachment ConfigItem ConfigItemVersion GeneralCatalog Service FAQ);

    my $DriverConfig = $ConfigObject->Get('DynamicFields::Driver');
    FIELDTYPE:
    for my $FieldType ( sort keys $DriverConfig->%* ) {
        next FIELDTYPE if $PackageFieldTypes{$FieldType};

        ok( $Covered{$FieldType}, "field type $FieldType is part of the round trip" );
    }
};

# ------------------------------------------------------------ #
# part 1: drivers, direction as documented in their POD
# ------------------------------------------------------------ #

# Direction 'Export' must turn IDs into names, Direction 'Import' names into IDs.
my @DriverTests = (
    {
        FieldType => 'Agent',
        IDs       => { Group => [$GroupID] },
        Names     => { Group => [$GroupName] },
    },
    {
        FieldType => 'Ticket',
        IDs       => {
            Queue      => [$QueueID],
            TicketType => [$TypeID]
        },
        Names => {
            Queue      => [$QueueName],
            TicketType => [$TypeName]
        },
    },
    {
        FieldType => 'Lens',
        IDs       => {
            AttributeDF => $FieldID{"Text$RandomID"},
            ReferenceDF => $FieldID{"Ticket$RandomID"}
        },
        Names => {
            AttributeDF => "Text$RandomID",
            ReferenceDF => "Ticket$RandomID"
        },
    },
);

for my $Test (@DriverTests) {
    subtest "driver $Test->{FieldType}: ImportExportPrepareConfig() as documented" => sub {
        my $DriverObject = DriverObjectGet( $Test->{FieldType} );

        my %Exported;
        ok(
            lives {
                %Exported = $DriverObject->ImportExportPrepareConfig(
                    Direction          => 'Export',
                    DynamicFieldConfig => {
                        Name   => 'DriverTest',
                        Config => Clone( $Test->{IDs} )
                    },
                );
            },
            "Direction 'Export' does not die",
        ) || diag($@);
        is( \%Exported, $Test->{Names}, "Direction 'Export' translates IDs into names" );

        my %Imported;
        ok(
            lives {
                %Imported = $DriverObject->ImportExportPrepareConfig(
                    Direction          => 'Import',
                    DynamicFieldConfig => {
                        Name   => 'DriverTest',
                        Config => Clone( $Test->{Names} )
                    },
                );
            },
            "Direction 'Import' does not die",
        ) || diag($@);
        is( \%Imported, $Test->{IDs}, "Direction 'Import' translates names into IDs" );
    };
}

# ------------------------------------------------------------ #
# part 2: DynamicFieldConfigID2Name() and DynamicFieldConfigName2ID()
# ------------------------------------------------------------ #

my @TranslationTests = (
    {
        Name  => "Agent$RandomID",
        Names => { Group => [$GroupName] },
        IDs   => { Group => [$GroupID] },
    },
    {
        Name  => "Ticket$RandomID",
        Names => {
            Queue      => [$QueueName],
            TicketType => [$TypeName]
        },
        IDs => {
            Queue      => [$QueueID],
            TicketType => [$TypeID]
        },
    },
    {
        Name  => "Lens$RandomID",
        Names => {
            AttributeDF => "Text$RandomID",
            ReferenceDF => "Ticket$RandomID"
        },
        IDs => {
            AttributeDF => $FieldID{"Text$RandomID"},
            ReferenceDF => $FieldID{"Ticket$RandomID"}
        },
    },
    {
        Name  => "ProcessID$RandomID",
        Names => {},
        IDs   => {},
    },
    {
        Name  => "ActivityID$RandomID",
        Names => {},
        IDs   => {},
    },
);

for my $Test (@TranslationTests) {
    subtest "DynamicFieldConfigID2Name() and DynamicFieldConfigName2ID(): $Original{ $Test->{Name} }{FieldType}" => sub {
        my $Exported;
        ok(
            lives {
                $Exported = $DynamicFieldObject->DynamicFieldConfigID2Name(
                    DynamicFieldConfig => Clone( $Original{ $Test->{Name} } ),
                );
            },
            'DynamicFieldConfigID2Name() does not die',
        ) || diag($@);

        for my $Attribute ( sort keys $Test->{Names}->%* ) {
            is( $Exported->{Config}{$Attribute}, $Test->{Names}{$Attribute}, "export: $Attribute as name" );
        }

        my $ImportConfig = Clone( $Original{ $Test->{Name} } );
        $ImportConfig->{Config} = {
            $ImportConfig->{Config}->%*,
            Clone( $Test->{Names} )->%*,
        };

        my $Imported;
        ok(
            lives {
                $Imported = $DynamicFieldObject->DynamicFieldConfigName2ID(
                    DynamicFieldConfig => $ImportConfig,
                );
            },
            'DynamicFieldConfigName2ID() does not die',
        ) || diag($@);

        for my $Attribute ( sort keys $Test->{IDs}->%* ) {
            is( $Imported->{Config}{$Attribute}, $Test->{IDs}{$Attribute}, "import: $Attribute as ID" );
        }
    };
}

# ------------------------------------------------------------ #
# part 3: round trip export -> delete -> import, like into another system
# ------------------------------------------------------------ #

subtest 'round trip of all field types' => sub {

    # export, same parameters as Kernel::Modules::AdminDynamicFieldImportExport
    my $Export;
    ok(
        lives {
            $Export = $ZnunyHelperObject->_DynamicFieldsConfigExport(
                Format                => 'var',
                IncludeInternalFields => 1,
                IncludeAllConfigKeys  => 1,
                DynamicFields         => \@FieldNames,
                Result                => 'HASH',
            );
        },
        'export does not die',
    ) || diag($@);

    if ( !IsHashRefWithData($Export) ) {
        fail('nothing exported, round trip not possible');
        return;
    }

    is( [ sort keys $Export->%* ], [ sort @FieldNames ], 'all fields are exported' );

    # simulate the transfer into another system via YAML, like the download does
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
    my $Transfer   = $YAMLObject->Load(
        Data => $YAMLObject->Dump( Data => { DynamicFields => $Export } ),
    );

    # remove the fields, dependent fields first, and create a filler field,
    # so the re-created fields will surely get other IDs
    for my $Name ( reverse @FieldNames ) {
        my $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $FieldID{$Name},
            UserID => 1,
        );
        ok( $Success, "$Name deleted" );
    }
    my $FillerID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => "Filler$RandomID",
        Label      => 'Filler',
        FieldOrder => 9999,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {},
        ValidID    => 1,
        UserID     => 1,
        Reorder    => 0,
    );
    ok( $FillerID, 'filler field created' );

    # import, same function as Kernel::Modules::AdminDynamicFieldImportExport with overwrite
    my @ImportFields = map { $Transfer->{DynamicFields}{$_} } @FieldNames;
    my $Return;
    ok(
        lives { $Return = $ZnunyHelperObject->_DynamicFieldsCreate(@ImportFields) },
        'import does not die',
    ) || diag($@);
    ok( $Return && $Return->{Success}, 'import reports success' );

    # compare every imported field with the original one
    my %NewFieldID;
    NAME:
    for my $Name (@FieldNames) {
        my $Imported = $DynamicFieldObject->DynamicFieldGet( Name => $Name );
        next NAME unless ok( IsHashRefWithData($Imported), "$Name exists after import" );

        $NewFieldID{$Name} = $Imported->{ID};
        isnt( $Imported->{ID}, $FieldID{$Name}, "$Name has a new ID" );
    }

    NAME:
    for my $Name (@FieldNames) {
        next NAME unless $NewFieldID{$Name};

        my $Imported = $DynamicFieldObject->DynamicFieldGet( Name => $Name );

        # expected: the original config, references to other fields point to the new IDs
        my $Expected = Clone( $Original{$Name}{Config} );
        if ( $Original{$Name}{FieldType} eq 'Lens' ) {
            my %OldID2Name = reverse %FieldID;
            for my $Attribute (qw(AttributeDF ReferenceDF)) {
                my $ReferencedName = $OldID2Name{ $Expected->{$Attribute} };
                $Expected->{$Attribute} = $NewFieldID{$ReferencedName};
            }
        }
        delete $Expected->{PartOfSet};

        my $Got = Clone( $Imported->{Config} );
        delete $Got->{PartOfSet};

        is(
            {
                Label      => $Imported->{Label},
                FieldType  => $Imported->{FieldType},
                ObjectType => $Imported->{ObjectType},
                Config     => $Got,
            },
            {
                Label      => $Original{$Name}{Label},
                FieldType  => $Original{$Name}{FieldType},
                ObjectType => $Original{$Name}{ObjectType},
                Config     => $Expected,
            },
            "$Original{$Name}{FieldType} field $Name: imported config matches the original",
        );
    }

    # a second export must deliver the same data as the first one
    my $Reexport;
    ok(
        lives {
            $Reexport = $ZnunyHelperObject->_DynamicFieldsConfigExport(
                Format                => 'var',
                IncludeInternalFields => 1,
                IncludeAllConfigKeys  => 0,
                DynamicFields         => \@FieldNames,
                Result                => 'HASH',
            );
        },
        'second export does not die',
    ) || diag($@);

    for my $Name (@FieldNames) {
        my %First = $Export->{$Name}->%*;
        delete @First{qw(ChangeTime CreateTime ID InternalField ValidID FieldOrder)};
        my %Second = ( $Reexport->{$Name} // {} )->%*;
        delete @Second{qw(FieldOrder)};

        is( \%Second, \%First, "$Name: second export equals the first export" );
    }
};

done_testing;
