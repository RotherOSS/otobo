# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package scripts::DBUpdateTo11_1::UpdateLensDynamicFieldsMultiValue;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use List::Util qw(first);

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
);

=head1 NAME

scripts::DBUpdateTo11_1::UpdateLensDynamicFieldsMultiValue - Update MultiValue attribute of Lens fields depending on the referenced field

=cut

use parent qw(scripts::DBUpdateTo11_1::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid => 0,
    );
    return unless IsArrayRefWithData($DynamicFieldList);

    DFCONFIG:
    for my $DFConfig ( $DynamicFieldList->@* ) {
        next DFCONFIG unless IsHashRefWithData($DFConfig);
        next DFCONFIG unless $DFConfig->{FieldType} eq 'Lens';

        my $AttributeDFConfig = first { $_->{ID} eq $DFConfig->{Config}{AttributeDF} } $DynamicFieldList->@*;

        $DFConfig->{Config}{MultiValue} = $AttributeDFConfig->{Config}{MultiValue};

        $DynamicFieldObject->DynamicFieldUpdate(
            $DFConfig->%*,
            UserID => 1,
        );
    }

    return 1;
}

1;
