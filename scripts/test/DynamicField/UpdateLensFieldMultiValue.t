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

# Test for the event module Kernel::System::DynamicField::Event::UpdateLensFieldMultiValue.
# Changing the MultiValue setting of a dynamic field must only change the MultiValue setting
# of the lenses which use this field as attribute field, not of all lenses.

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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

my $RandomID   = $Helper->GetRandomID;
my $FieldOrder = 9000;

# add a ticket dynamic field and return its ID
sub FieldAdd {
    my (%Param) = @_;

    my $ID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $Param{Name},
        Label      => $Param{Name},
        FieldOrder => $FieldOrder++,
        FieldType  => $Param{FieldType},
        ObjectType => 'Ticket',
        Config     => $Param{Config},
        ValidID    => 1,
        UserID     => 1,
        Reorder    => 0,
    );
    ok( $ID, "$Param{FieldType} field $Param{Name} created" );

    # run the transaction event modules, e.g. UpdateLensFieldMultiValue
    $DynamicFieldObject->EventHandlerTransaction;

    return $ID;
}

# update the config of a dynamic field
sub FieldConfigUpdate {
    my (%Param) = @_;

    my $Field = $DynamicFieldObject->DynamicFieldGet( Name => $Param{Name} );

    my $Success = $DynamicFieldObject->DynamicFieldUpdate(
        $Field->%*,
        Config => {
            $Field->{Config}->%*,
            $Param{Config}->%*,
        },
        UserID  => 1,
        Reorder => 1,
    );
    ok( $Success, "field $Param{Name} updated" );

    # run the transaction event modules, e.g. UpdateLensFieldMultiValue
    $DynamicFieldObject->EventHandlerTransaction;

    return;
}

# the MultiValue setting of a field as '0' or '1'
sub MultiValueGet {
    my ($Name) = @_;

    my $Field = $DynamicFieldObject->DynamicFieldGet( Name => $Name );

    return $Field->{Config}{MultiValue} ? '1' : '0';
}

# setup: two attribute fields, a reference field and a lens on each attribute field
my %ID;
for my $Name ( "TextA$RandomID", "TextB$RandomID" ) {
    $ID{$Name} = FieldAdd(
        Name      => $Name,
        FieldType => 'Text',
        Config    => {
            DefaultValue => '',
            MultiValue   => 0,
        },
    );
}

$ID{"Ticket$RandomID"} = FieldAdd(
    Name      => "Ticket$RandomID",
    FieldType => 'Ticket',
    Config    => {
        ReferencedObjectType => 'Ticket',
        EditFieldMode        => 'AutoComplete',
        MultiValue           => 0,
    },
);

for my $Attribute (qw(A B)) {
    FieldAdd(
        Name      => "Lens$Attribute$RandomID",
        FieldType => 'Lens',
        Config    => {
            AttributeDF => $ID{"Text$Attribute$RandomID"},
            ReferenceDF => $ID{"Ticket$RandomID"},
            MultiValue  => 0,
        },
    );
}

subtest 'MultiValue of attribute field switched on' => sub {
    FieldConfigUpdate(
        Name   => "TextA$RandomID",
        Config => { MultiValue => 1 },
    );

    is( MultiValueGet("LensA$RandomID"), '1', 'lens on the changed field follows' );
    is( MultiValueGet("LensB$RandomID"), '0', 'lens on another field is not changed' );
};

subtest 'MultiValue of attribute field switched off' => sub {
    FieldConfigUpdate(
        Name   => "TextB$RandomID",
        Config => { MultiValue => 1 },
    );
    FieldConfigUpdate(
        Name   => "TextA$RandomID",
        Config => { MultiValue => 0 },
    );

    is( MultiValueGet("LensA$RandomID"), '0', 'lens on the changed field follows' );
    is( MultiValueGet("LensB$RandomID"), '1', 'lens on another field is not changed' );
};

subtest 'new lens on a MultiValue field' => sub {
    FieldAdd(
        Name      => "LensB2$RandomID",
        FieldType => 'Lens',
        Config    => {
            AttributeDF => $ID{"TextB$RandomID"},
            ReferenceDF => $ID{"Ticket$RandomID"},
            MultiValue  => 0,
        },
    );

    is( MultiValueGet("LensB2$RandomID"), '1', 'new lens takes over MultiValue of its attribute field' );
};

subtest 'attribute field of a lens changed' => sub {
    FieldConfigUpdate(
        Name   => "LensA$RandomID",
        Config => { AttributeDF => $ID{"TextB$RandomID"} },
    );

    is( MultiValueGet("LensA$RandomID"), '1', 'lens takes over MultiValue of its new attribute field' );
};

done_testing;
