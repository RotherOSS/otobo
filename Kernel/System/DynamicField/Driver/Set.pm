# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2023 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::DynamicField::Driver::Set;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::DynamicField::Driver::Base);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::DynamicField::Mask',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Set

=head1 DESCRIPTION

DynamicFields Set Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 0,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 1,
        'IsMultiValueCapable'          => 1,
        'IsSetCapable'                 => 0,
    };

    return $Self;
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @SetValue;
    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        my $FieldValue = $BackendObject->ValueGet(
            %Param,
            DynamicFieldConfig => $DynamicField,
            Set                => 1,
        );

        if ($FieldValue) {
            for my $SetIndex ( 0 .. $#{$FieldValue} ) {
                $SetValue[$SetIndex][$i] = $FieldValue->[$SetIndex];
            }
        }
    }

    return \@SetValue;
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    my $Success = 1;

    my @SetValue = defined $Param{Value} ? $Param{Value}->@* : ( [] );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        my @FieldValue;
        for my $SetIndex ( 0 .. $#SetValue ) {
            $FieldValue[$SetIndex] = $SetValue[$SetIndex][$i];
        }

        if (
            !$BackendObject->ValueSet(
                %Param,
                DynamicFieldConfig => $DynamicField,
                Value              => \@FieldValue,
                Set                => 1,
            )
            )
        {
            $Success = 0;
        }
    }

    return $Success;
}

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    my $Success = 1;

    my @SetValue = defined $Param{Value} ? $Param{Value}->@* : ( [] );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        for my $SetIndex ( 0 .. $#SetValue ) {
            $Success = $BackendObject->ValueValidate(
                %Param,
                DynamicFieldConfig => $DynamicField,
                Value              => $SetValue[$SetIndex][$i],
            );

            return if !$Success;
        }
    }

    return $Success;
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldSet';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # TODO: maybe set all mandatory? necessary?
    #    # set field as mandatory
    #    if ( $Param{Mandatory} ) {
    #    }

    # TODO:
    #    # set error css class
    #    if ( $Param{ServerError} ) {
    #        $FieldClass .= ' ServerError';
    #    }

    my %FieldTemplateData = (
        'FieldClass' => $FieldClass,
        'FieldName'  => $FieldName,
    );

    # ??
    #    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
    #        Text => $FieldLabel,
    #    );
    #
    #    $FieldTemplateData{FieldLabelEscaped} = $FieldLabelEscaped;

    #    if ( $Param{ServerError} ) {
    #
    #        $FieldTemplateData{ServerError}  = $Param{ServerError};
    #        $FieldTemplateData{ErrorMessage} = Translatable( $Param{ErrorMessage} || 'This field is required.' );
    #    }

    my $FieldTemplateFile = 'DynamicField/Agent/Set';
    if ( $Param{CustomerInterface} ) {
        $FieldTemplateFile = 'DynamicField/Customer/Set';
    }

    my @SetValue = $Param{Value} ? $Param{Value}->@* : ( [] );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %DynamicFieldConfigs;
    my @DynamicFieldValues;

    # call EditLabelRender on the common backend
    my $LabelString = $Self->EditLabelRender(
        %Param,
        Mandatory => $Param{Mandatory} || '0',
        FieldName => $FieldName,
    );

    my $Data = {
        Label => $LabelString,
    };

    my @ResultHTML;
    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        # prevent overwriting names in cached data
        $DynamicFieldConfigs{ $DynamicField->{Name} } = { $DynamicField->%* };

        for my $SetIndex ( 0 .. $#SetValue ) {
            $DynamicFieldValues[$SetIndex]{ 'DynamicField_' . $DynamicField->{Name} } = $SetValue[$SetIndex][$i];
        }
    }

    # TODO: Improve
    my $StoreBlockData = delete $Param{LayoutObject}{BlockData};

    for my $SetIndex ( 0 .. $#SetValue ) {
        for my $Name ( keys %DynamicFieldConfigs ) {
            $DynamicFieldConfigs{$Name}{Name} = $Name . '_' . $SetIndex;
        }

        my $DynamicFieldHTML = $Kernel::OM->Get('Kernel::System::DynamicField::Mask')->EditSectionRender(
            Content            => $Param{DynamicFieldConfig}{Config}{Include},
            DynamicFields      => \%DynamicFieldConfigs,
            UpdatableFields    => $Param{UpdatableFields},
            LayoutObject       => $Param{LayoutObject},
            ParamObject        => $Param{ParamObject},
            DynamicFieldValues => $DynamicFieldValues[$SetIndex],

            # TODO:
            #            PossibleValuesFilter => $Param{DFPossibleValues},
            #            Errors               => $Param{DFErrors},
            #            Visibility           => $Param{Visibility},
        );

        $ResultHTML[$SetIndex] = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                Name             => $Param{DynamicFieldConfig}->{Name},
                Index            => $SetIndex,
                DynamicFieldHTML => $DynamicFieldHTML,
            },
        );

        delete $Param{LayoutObject}{BlockData};
    }

    # decide which structure to return
    if ( $FieldConfig->{MultiValue} ) {
        for my $Name ( keys %DynamicFieldConfigs ) {
            $DynamicFieldConfigs{$Name}{Name} = $Name . '_Template';
        }

        my $DynamicFieldHTML = $Kernel::OM->Get('Kernel::System::DynamicField::Mask')->EditSectionRender(
            Content            => $Param{DynamicFieldConfig}{Config}{Include},
            DynamicFields      => \%DynamicFieldConfigs,
            UpdatableFields    => $Param{UpdatableFields},
            LayoutObject       => $Param{LayoutObject},
            ParamObject        => $Param{ParamObject},
            DynamicFieldValues => {},

            # TODO:
            #            PossibleValuesFilter => $Param{DFPossibleValues},
        );

        my $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                Name             => $Param{DynamicFieldConfig}->{Name},
                DynamicFieldHTML => $DynamicFieldHTML,
            },
        );

        $Data->{MultiValue}         = \@ResultHTML;
        $Data->{MultiValueTemplate} = $TemplateHTML;
    }
    else {
        $Data->{Field} = $ResultHTML[0];
    }

    # restore Layout BlockData
    $Param{LayoutObject}{BlockData} = $StoreBlockData;

    return $Data;
}

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    my @SetData;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @DataAll = $Param{ParamObject}->GetArray(
        Param => 'SetIndex_' . $Param{DynamicFieldConfig}->{Name},
    );

    # if we have nothing in the frontend just return
    return if !@DataAll;

    # get the highest multivalue index (second to last; last is the empty template)
    my $IndexMax = $Param{DynamicFieldConfig}{Config}{MultiValue} ? $DataAll[-2] : 0;

    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        # prevent overwriting names in cached data
        $DynamicField = { $DynamicField->%* };

        my $Name = $DynamicField->{Name};
        for my $SetIndex ( 0 .. $IndexMax ) {
            $DynamicField->{Name} = $Name . '_' . $SetIndex;

            $SetData[$SetIndex][$i] = $BackendObject->EditFieldValueGet(
                %Param,
                DynamicFieldConfig => $DynamicField,
            );
        }
    }

    return if !@SetData;
    return \@SetData;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    my $Success = 1;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $IndexMax = 0;

    if ( $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
        my @DataAll = $Param{ParamObject}->GetArray(
            Param => 'SetIndex_' . $Param{DynamicFieldConfig}->{Name},
        );

        # get the highest multivalue index (second to last; last is the empty template)
        $IndexMax = $DataAll[-2];
    }

    my $Result;
    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        # prevent overwriting names in cached data
        $DynamicField = { $DynamicField->%* };

        my $Name = $DynamicField->{Name};
        for my $SetIndex ( 0 .. $IndexMax ) {
            $DynamicField->{Name} = $Name . '_' . $SetIndex;

            $Result->{ $DynamicField->{Name} } = $BackendObject->EditFieldValueValidate(
                %Param,
                DynamicFieldConfig => $DynamicField,
            );
        }
    }

    return $Result;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # check for Null value
    if ( !defined $Param{Value} ) {
        return {
            Value => '',
            Title => '',
        };
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %SetValue = (
        Value => [],
        Title => [],
    );

    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        VALUE:
        for my $SetIndex ( 0 .. $#{ $Param{Value} } ) {
            next VALUE if !defined $Param{Value}[$SetIndex][$i];

            my $Element = $BackendObject->DisplayValueRender(
                %Param,
                DynamicFieldConfig => $DynamicField,
                Value              => $Param{Value}[$SetIndex][$i],
            );

            next VALUE if !defined $Element->{Value} || $Element->{Value} eq '';

            # TODO: check Value vs Title (seems same for most DF), add Links (maybe use tt)
            $SetValue{Value}[$SetIndex] .= "$DynamicField->{Label}: $Element->{Value}<br/>";
            $SetValue{Title}[$SetIndex] .= "$DynamicField->{Label}: $Element->{Title}<br/>";
        }
    }

    my %Value;
    for my $Return (qw/Value Title/) {
        @{ $SetValue{$Return} } = map { $_ // '' } $SetValue{$Return}->@*;

        $Value{$Return} = join( '<hr/>', $SetValue{$Return}->@* );
        $Value{$Return} = $Value{$Return} ? "<div class='SetDisplayValue'>$Value{$Return}</div>" : '';
    }

    return \%Value;
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %SetValue = (
        Value => [],
        Title => [],
    );

    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        VALUE:
        for my $SetIndex ( 0 .. $#{ $Param{Value} } ) {
            next VALUE if !defined $Param{Value}[$SetIndex][$i];

            my $Element = $BackendObject->ReadableValueRender(
                %Param,
                DynamicFieldConfig => $DynamicField,
                Value              => $Param{Value}[$SetIndex][$i],
            );

            $SetValue{Value}[$SetIndex] .= " $DynamicField->{Label}: $Element->{Value};";
            $SetValue{Title}[$SetIndex] .= " $DynamicField->{Label}: $Element->{Title};";
        }
    }

    my %Value;
    for my $Return (qw/Value Title/) {
        $Value{$Return} = join ' - ', map { $_ // '' } $SetValue{$Return}->@*;
        $Value{$Return} //= '';
    }

    return \%Value;
}

sub TemplateValueTypeGet {
    my ( $Self, %Param ) = @_;

    return;
}

sub RandomValueSet {
    my ( $Self, %Param ) = @_;

    my $Success = 1;
    my @Value;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # create 1 to 3 sets for MultiValue, else 1
    my $SetCount = $Param{DynamicFieldConfig}{Config}{MultiValue} ? int( rand(3) ) + 1 : 1;

    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        my $Return = $BackendObject->RandomValueSet(
            %Param,
            DynamicFieldConfig => $DynamicField,
            SetCount           => $SetCount,
        );

        if ( !$Return->{Success} ) {
            $Success = 0;
        }

        push @Value, $Return->{Value};
    }

    if ( !$Success ) {
        return {
            Success => 0,
        };
    }

    return {
        Success => 1,
        Value   => \@Value,
    };
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    return    unless defined $Param{Key};
    return '' unless ref $Param{Key};
    return '' unless ref $Param{Key} eq 'ARRAY';

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @SetValue;

    for my $i ( 0 .. $#{ $Param{DynamicFieldConfig}{Config}{Include} } ) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $Param{DynamicFieldConfig}{Config}{Include}[$i]{DF},
        );

        if ( !$DynamicField ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Param{DynamicFieldConfig}{Name} configured erroneously. 'DF: DynamicFieldName' missing or wrong.",
            );

            return;
        }

        # TODO: where does $Param{Value} come from ?
        VALUE:
        for my $SetIndex ( 0 .. $#{ $Param{Value} } ) {
            next VALUE unless defined $Param{Value}[$SetIndex][$i];

            # TODO: what if $Element is an arrayref ?
            my $Element = $BackendObject->ValueLookup(
                %Param,
                DynamicFieldConfig => $DynamicField,
                Value              => $Param{Value}[$SetIndex][$i],
            );

            # TODO: why concatenate to an undefined variable ?
            $SetValue[$SetIndex] .= " $DynamicField->{Label}: $Element;";
        }
    }

    return join ' - ', @SetValue;
}

1;
