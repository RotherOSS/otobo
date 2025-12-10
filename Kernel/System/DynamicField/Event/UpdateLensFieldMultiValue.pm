# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::DynamicField::Event::UpdateLensFieldMultiValue;

use strict;
use warnings;

# core modules
use List::Util qw(any none);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Data Event Config UserID)) {
        if ( !$Param{$Argument} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    return if none { $Param{Event} eq $_ } qw(DynamicFieldAdd DynamicFieldDelete DynamicFieldUpdate);

    my $UpdatedFieldConfig = $Param{Data}{NewData};

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # Two cases:
    #   1. AttributeDF of Lens changed -> check MultiValue of new AttributeDF
    #   2. Field config of an AttributeDF changed

    # it is not possible to add a new dynamic field which is a lens attribute field
    #   as lens fields check for existence of the fields they depend on
    #   so, DynamicFieldAdd case here means that a new Lens field was added
    if ( $Param{Event} eq 'DynamicFieldAdd' ) {

        return unless $UpdatedFieldConfig->{FieldType} eq 'Lens';

        # check if attribute field is MultiValue
        my $AttributeDFConfig = $DynamicFieldObject->DynamicFieldGet(
            ID => $UpdatedFieldConfig->{Config}{AttributeDF},
        );
        if ( $AttributeDFConfig->{Config}{MultiValue} ) {
            $DynamicFieldObject->DynamicFieldUpdate(
                $UpdatedFieldConfig->%*,
                Config => {
                    $UpdatedFieldConfig->{Config}->%*,
                    MultiValue => 1,
                },
                UserID => $Param{UserID},
            );
        }
    }

    # here, both cases are relevant
    elsif ( $Param{Event} eq 'DynamicFieldUpdate' ) {

        # check which case we are in
        if ( $UpdatedFieldConfig->{FieldType} eq 'Lens' ) {

            # prevent endless loops
            return if ( $UpdatedFieldConfig->{Config}{MultiValue} || 0 ) != ( $Param{Data}{OldData}{Config}{MultiValue} || 0 );

            # did attribute field change?
            return if $UpdatedFieldConfig->{Config}{AttributeDF} == $Param{Data}{OldData}{Config}{AttributeDF};

            my $NewAttributeDFConfig = $DynamicFieldObject->DynamicFieldGet(
                ID => $UpdatedFieldConfig->{Config}{AttributeDF},
            );
            $DynamicFieldObject->DynamicFieldUpdate(
                $UpdatedFieldConfig->%*,
                Config => {
                    $UpdatedFieldConfig->{Config}->%*,
                    MultiValue => $NewAttributeDFConfig->{Config}{MultiValue} ? '1' : '0',
                },
                UserID => $Param{UserID},
            );
        }
        else {

            # did MultiValue change?
            return if ( $UpdatedFieldConfig->{Config}{MultiValue} || 0 ) == ( $Param{Data}{OldData}{Config}{MultiValue} || 0 );

            # get all lens fields and check if updated field is an attribute field of one of them
            #   https://github.com/RotherOSS/otobo/issues/3400 would be really helpful
            my $DynamicFields = $DynamicFieldObject->DynamicFieldListGet(
                Valid => 0,
            );
            DFCONFIG:
            for my $DFConfig ( $DynamicFields->@* ) {
                next DFCONFIG unless $DFConfig->{FieldType} eq 'Lens';
                next DFCONFIG unless $DFConfig->{Config}{AttributeDF} ne $UpdatedFieldConfig->{Name};

                $DynamicFieldObject->DynamicFieldUpdate(
                    $DFConfig->%*,
                    Config => {
                        $DFConfig->{Config}->%*,
                        MultiValue => $UpdatedFieldConfig->{Config}{MultiValue} ? '1' : '0',
                    },
                    UserID => $Param{UserID},
                );
            }
        }
    }
    elsif ( $Param{Event} eq 'DynamicFieldDelete' ) {

        # do nothing
    }

    return 1;
}

1;
