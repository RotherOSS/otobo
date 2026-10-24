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

package scripts::DBUpdateTo11_1::CreateProcessManagementDynamicFields;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_1::CreateProcessManagementDynamicFields - Create the process management dynamic fields if the system does not yet have them.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my @FieldConfigs = (
        {
            InternalField => 1,
            Name          => 'ProcessManagementProcessID',
            Label         => 'Process',
            FieldOrder    => 1,
            FieldType     => 'ProcessID',
            ObjectType    => 'Ticket',
            Config        => {
                DefaultValue => '',
            },
            ValidID => 1,
        },
        {
            InternalField => 1,
            Name          => 'ProcessManagementActivityID',
            Label         => 'Activity',
            FieldOrder    => 2,
            FieldType     => 'ActivityID',
            ObjectType    => 'Ticket',
            Config        => {
                DefaultValue => '',
            },
            ValidID => 1,
        },
    );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    FIELDNAME:
    for my $FieldConfig (@FieldConfigs) {

        my $CheckExisting = $DynamicFieldObject->DynamicFieldGet(
            Name => $FieldConfig->{Name},
        );

        next FIELDNAME if IsHashRefWithData($CheckExisting);

        my $CreateSuccess = $DynamicFieldObject->DynamicFieldAdd(
            $FieldConfig->%*,
            UserID  => 1,
            Reorder => 1,
        );

        if ( !$CreateSuccess ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not create missing internal dynamic field $FieldConfig->{Name}. Manual intervention may be required.",
            );
        }
    }

    return 1;
}

1;
