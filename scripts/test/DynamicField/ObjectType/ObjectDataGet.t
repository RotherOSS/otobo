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

# Get the Dynamic Field Objects configuration
my $DynamicFieldObjectTypeConfig = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::ObjectType');

$Self->True(
    IsHashRefWithData($DynamicFieldObjectTypeConfig),
    "DynamicFields::ObjectType is a hash",
);

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

# Create all registered ObjectType handler modules
for my $ObjectType ( sort keys %{$DynamicFieldObjectTypeConfig} ) {

    # Check if the registration for each field type is valid
    $Self->IsNot(
        $DynamicFieldObjectTypeConfig->{$ObjectType}->{Module} || '',
        '',
        "$ObjectType module is not empty or undefined",
    );

    # Set the backend file.
    my $ObjectHandlerModule = $DynamicFieldObjectTypeConfig->{$ObjectType}->{Module};

    # Check if backend field exists
    my $LoadSuccess = $MainObject->Require($ObjectHandlerModule);

    $Self->True(
        $LoadSuccess,
        "$ObjectHandlerModule loads correctly",
    );

    # Create a backend object
    my $ObjectHandlerObject = $Kernel::OM->Get($ObjectHandlerModule);

    $Self->Is(
        ref $ObjectHandlerObject,
        $ObjectHandlerModule,
        "$ObjectHandlerModule creates correctly",
    );

    # Test if the object can execute ObjectDataGet.
    $Self->True(
        $ObjectHandlerObject->can('ObjectDataGet'),
        "$ObjectHandlerModule can execute ObjectDataGet()",
    );
}

$Self->DoneTesting();
