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

package Kernel::System::DynamicField::Event::UpdateSetFieldIncludedFields;

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

    # TODO refine checks based upon event
    return 1 if $Param{Data}{NewData}{FieldType} ne 'Set';
    return   if none { $Param{Event} eq $_ } qw(DynamicFieldAdd DynamicFieldDelete DynamicFieldUpdate);

    my $DynamicFieldObject    = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $SetDynamicFieldConfig = $Param{Data}{NewData};

    my $IncludedFields = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $SetDynamicFieldConfig->{Config}{Include},
    );

    if ( $Param{Event} eq 'DynamicFieldAdd' ) {

        # update configs of included fields
        for my $IncludedField ( keys $IncludedFields->%* ) {
            my $IncludedFieldConfig = $IncludedFields->{$IncludedField};
            $DynamicFieldObject->DynamicFieldUpdate(
                $IncludedFieldConfig->%*,
                Config => {
                    $IncludedFieldConfig->{Config}->%*,
                    PartOfSet => $SetDynamicFieldConfig->{ID},
                },
                UserID => $Param{UserID},
            );
        }
    }
    elsif ( $Param{Event} eq 'DynamicFieldUpdate' ) {

        my $OldDynamicFieldConfig = $Param{Data}{OldData};
        my $OldIncludedFields     = $Self->_GetIncludedDynamicFields(
            InputFieldDefinition => $OldDynamicFieldConfig->{Config}{Include},
        );

        # update configs of included fields
        FIELD:
        for my $IncludedField ( keys $IncludedFields->%*, keys $OldIncludedFields->%* ) {
            my $IncludedFieldConfig = $IncludedFields->{$IncludedField} // $OldIncludedFields->{$IncludedField};

            my $PartOfSet = ( any { $_->{ID} eq $IncludedFieldConfig->{ID} } values $IncludedFields->%* ) ? $SetDynamicFieldConfig->{ID} : 0;

            # skip field if nothing changed
            next FIELD if $PartOfSet && grep { $_->{ID} eq $IncludedFieldConfig->{ID} } values $OldIncludedFields->%*;

            $DynamicFieldObject->DynamicFieldUpdate(
                $IncludedFieldConfig->%*,
                Config => {
                    $IncludedFieldConfig->{Config}->%*,
                    PartOfSet => $PartOfSet,
                },
                UserID => $Param{UserID},
            );
        }
    }
    elsif ( $Param{Event} eq 'DynamicFieldDelete' ) {

        # update configs of included fields
        INCLUDEDFIELD:
        for my $IncludedField ( keys $IncludedFields->%* ) {
            my $IncludedFieldConfig = $IncludedFields->{$IncludedField};
            next INCLUDEDFIELD unless IsHashRefWithData($IncludedFieldConfig);
            next INCLUDEDFIELD unless $IncludedFieldConfig->{Name};

            $DynamicFieldObject->DynamicFieldUpdate(
                $IncludedFieldConfig->%*,
                Config => {
                    $IncludedFieldConfig->{Config}->%*,
                    PartOfSet => 0,
                },
                UserID => $Param{UserID},
            );
        }
    }

    return 1;
}

sub _GetIncludedDynamicFields {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my %DynamicField;

    ITEM:
    for my $IncludeItem ( @{ $Param{InputFieldDefinition} } ) {

        if ( $IncludeItem->{Grid} ) {

            for my $Row ( @{ $IncludeItem->{Grid}{Rows} } ) {

                DFENTRY:
                for my $DFEntry ( $Row->@* ) {

                    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                        Name => $DFEntry->{DF},
                    );
                    if ( IsHashRefWithData($DynamicField) ) {
                        $DynamicField->{Mandatory}      = $DFEntry->{Mandatory};
                        $DynamicField->{Readonly}       = $DFEntry->{Readonly};
                        $DynamicField{ $DFEntry->{DF} } = $DynamicField;
                    }
                    else {
                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => "DynamicFieldConfig missing for field: $DFEntry->{DF}, or is not a Ticket Dynamic Field!",
                        );

                        next DFENTRY;
                    }
                }
            }
        }
        elsif ( $IncludeItem->{DF} ) {

            my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
                Name => $IncludeItem->{DF},
            );
            if ($DynamicField) {
                $DynamicField->{Mandatory}          = $IncludeItem->{Mandatory};
                $DynamicField->{Readonly}           = $IncludeItem->{Readonly};
                $DynamicField{ $IncludeItem->{DF} } = $DynamicField;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "DynamicFieldConfig missing for field: $IncludeItem->{DF}, or is not a Ticket Dynamic Field!",
                );
                next ITEM;
            }
        }
        else {
            next ITEM;
        }
    }

    return \%DynamicField;
}

1;
