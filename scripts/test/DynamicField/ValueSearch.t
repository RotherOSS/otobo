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

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get needed objects
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

# define needed variable
my $RandomID = $Helper->GetRandomNumber();

# create a dynamic field
my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
    Name       => "dynamicfieldtest$RandomID",
    Label      => 'a description',
    FieldOrder => 9991,
    FieldType  => 'Text',
    ObjectType => 'CustomerUser',
    Config     => {
        DefaultValue => 'a value',
    },
    ValidID => 1,
    UserID  => 1,
);

# sanity check
$Self->True(
    $FieldID,
    "DynamicFieldAdd() successful for Field ID $FieldID",
);

my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet( ID => $FieldID );

# set dynamic field value via object name
my @ObjectNames;
for my $Count ( 1 .. 3 ) {
    push @ObjectNames, $Helper->GetRandomID();
}

for my $ObjectName (@ObjectNames) {
    my $Success = $BackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        Value              => "This is a sample text for ObjectIDsSearch.",
        UserID             => 1,
        ObjectName         => $ObjectName,
    );
    $Self->True(
        $Success,
        'Creation of dynamic field value via object name must succeed.'
    );
}

# fetch object IDs for object names
my $ObjectIDByObjectName = $DynamicFieldObject->ObjectMappingGet(
    ObjectName => \@ObjectNames,
    ObjectType => 'CustomerUser',
);
$Self->Is(
    scalar keys %{$ObjectIDByObjectName},
    scalar @ObjectNames,
    'Number of found object IDs must match number of object names.',
);

# check that ValueSearch() returns expected data
my $Results = $BackendObject->ValueSearch(
    DynamicFieldConfig => $DynamicFieldConfig,
    Search             => 'sample text for ObjectIDsSearch',
);

$Self->True(
    IsArrayRefWithData($Results),
    'ValueSearch must return a result.'
);

my $ObjectIDsMatch = ( scalar keys %{$ObjectIDByObjectName} == scalar @{$Results} ) ? 1 : 0;
if ($ObjectIDsMatch) {
    my %ObjectNameByObjectID = reverse %{$ObjectIDByObjectName};
    RESULT:
    for my $Result ( @{$Results} ) {
        next RESULT if $ObjectNameByObjectID{ $Result->{ObjectID} }
            && $Result->{ValueText} =~ m{sample text for ObjectIDsSearch};

        $ObjectIDsMatch = 0;
        last OBJECTID;
    }
}

$Self->True(
    $ObjectIDsMatch,
    'ValueSearch must return expected object IDs.',
);

# cleanup is done by RestoreDatabase

$Self->DoneTesting();
