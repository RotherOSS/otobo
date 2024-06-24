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

package Kernel::System::CustomerCompany::Event::DynamicFieldObjectNameUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw( Data Event Config UserID )) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );

            return;
        }
    }
    for my $Needed (qw( CustomerID OldCustomerID )) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in Data!"
            );

            return;
        }
    }

    # The dynamic fields of a CustomerCompany are linked via the the field CustomerID.
    # Only update if CustomerID has really changed.
    return 1 if lc $Param{Data}->{CustomerID} eq lc $Param{Data}->{OldCustomerID};

    # If the customer ID has been changed, update dynamic field object name for given name and type.
    my $Success = $Kernel::OM->Get('Kernel::System::DynamicField')->ObjectMappingNameChange(
        OldObjectName => $Param{Data}->{OldCustomerID},
        NewObjectName => $Param{Data}->{CustomerID},
        ObjectType    => 'CustomerCompany',
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  =>
                "Unable to change dynamic field object mapping name from $Param{Data}->{OldCustomerID} to $Param{Data}->{CustomerID} for type CustomerCompany!",
        );

        return;
    }

    return 1;
}

1;
