# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::Base);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::Output::HTML::DynamicField::Mask',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Set - driver for the Set dynamic field

=for stopwords multivalue

=head1 DESCRIPTION

DynamicFields Set Driver delegate
In the perl backend sets handle their data as array of hashes, where the outer array runs over the set index (i.e. the multi value index of the set, or 0),
and the hash stores the field values. A set containing the dynamic fields "Person" and "Pets" could thus have the content:
[ { Person => "Max", Pets => ["Cat"] }, { Person => "Anna", Pets => ["Dog","Parrot"] } ]
In ValueSet() and ValueGet() this data would be given to the dynamic fields "Person" and "Pet" as ["Max", "Dog"] and [["Cat"], ["Dog","Parrot"]] respectively,
the array still representing the SetIndex, with the parameter Set => 1.
To be able to correctly render edit masks in the frontend and above all receive the data of the frontend correctly, for all EditField methods, this driver
changes the DynamicFieldConfig of the inner fields and appends the set index as "_$SetIndex" to the name of the fields. Therefore all frontend methods for
the inner fields must exclusively be called via this driver. (Note however, that this suffix is not used for all variables. Please always check the context.)

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 0,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 1,
        'IsSetCapable'                 => 0,
        'SetsDynamicContent'           => 1,
    };

    return $Self;
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @SetValue;

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject
    );

    return if !$DynamicField;

    for my $Name ( sort keys $DynamicField->%* ) {

        my $FieldValue = $BackendObject->ValueGet(
            %Param,
            DynamicFieldConfig => $DynamicField->{$Name},
            Set                => 1,
            ObjectName         => undef,
        );

        if ($FieldValue) {
            for my $SetIndex ( 0 .. $#{$FieldValue} ) {
                $SetValue[$SetIndex]{$Name} = $FieldValue->[$SetIndex];
            }
        }
    }

    return if !@SetValue;
    return \@SetValue;
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    my @SetValue = defined $Param{Value} ? $Param{Value}->@* : ( {} );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject
    );

    return if !$DynamicField;

    for my $Name ( sort keys $DynamicField->%* ) {

        # The values for an included dynamic field are the values from the respective column
        my @FieldValue = map { $_->{$Name} } @SetValue;

        if (
            !$BackendObject->ValueSet(
                %Param,
                DynamicFieldConfig => $DynamicField->{$Name},
                Value              => \@FieldValue,
                Set                => 1,
                ObjectName         => undef,
            )
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Error setting Value for DynamicField $DynamicField"
            );

            return;
        }
    }

    return 1;
}

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    my @SetValue = defined $Param{Value} ? $Param{Value}->@* : ();

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject
    );

    return if !$DynamicField;

    for my $Name ( sort keys $DynamicField->%* ) {
        for my $SetIndex ( 0 .. $#SetValue ) {

            return if !$BackendObject->ValueValidate(
                %Param,
                DynamicFieldConfig => $DynamicField->{$Name},
                Value              => $SetValue[$SetIndex]{$Name},
            );
        }
    }

    return 1;
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldSet';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # TODO: maybe set all mandatory? necessary?
    #    # set classes according to mandatory and acl hidden params
    #    if ( $Param{ACLHidden} && $Param{Mandatory} ) {
    #        $FieldClass .= ' Validate_Required_IfVisible';
    #    }
    #    elsif ( $Param{Mandatory} ) {
    #        $FieldClass .= ' Validate_Required';
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

    #    if ( $Param{ServerError} ) {
    #
    #        $FieldTemplateData{ServerError}  = $Param{ServerError};
    #        $FieldTemplateData{ErrorMessage} = Translatable( $Param{ErrorMessage} || 'This field is required.' );
    #    }

    my $FieldTemplateFile = $Param{CustomerInterface}
        ? 'DynamicField/Customer/Set'
        : 'DynamicField/Agent/Set';

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject
    );

    return if !$DynamicField;

    DYNAMICFIELD:
    for my $Name ( sort keys $DynamicField->%* ) {
        if ( !IsHashRefWithData( $DynamicField->{$Name} ) ) {
            delete $DynamicField->{$Name};

            next DYNAMICFIELD;
        }

        # prevent overwriting names in cached data later
        $DynamicField->{$Name} = { $DynamicField->{$Name}->%* };
    }

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
    my @SetValue = $Param{Value} ? $Param{Value}->@* : ( {} );

    # TODO: Improve
    my $StoreBlockData = delete $Param{LayoutObject}{BlockData};

    for my $SetIndex ( 0 .. $#SetValue ) {
        my %Value;
        for my $Name ( sort keys $DynamicField->%* ) {
            $Value{"DynamicField_$Name"} = $SetValue[$SetIndex]{$Name};
            $DynamicField->{$Name}{Name} = $Name . '_' . $SetIndex;
        }

        my $DynamicFieldHTML = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
            Content            => $Include,
            DynamicFields      => $DynamicField,
            UpdatableFields    => $Param{UpdatableFields},
            LayoutObject       => $Param{LayoutObject},
            ParamObject        => $Param{ParamObject},
            DynamicFieldValues => \%Value,
            CustomerInterface  => $Param{CustomerInterface},

            # can be set by preceding GetFieldState()
            PossibleValuesFilter => $Self->{PossibleValuesFilter}{ $Param{DynamicFieldConfig}->{Name} }[$SetIndex] // {},

            # TODO:
            #            Errors               => $Param{DFErrors},
            #            Visibility           => $Param{Visibility},
            Object => $Param{Object},
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
    # decide which structure to return
    if ( $FieldConfig->{MultiValue} ) {
        for my $Name ( sort keys $DynamicField->%* ) {
            $DynamicField->{$Name}{Name} = $Name . '_Template';
        }

        # can be set by preceding GetFieldState()
        my %TemplateValues = map { 'DynamicField_' . $_ => $Self->{TemplateValues}{ $Param{DynamicFieldConfig}->{Name} }{$_} }
            keys %{ $Self->{TemplateValues}{ $Param{DynamicFieldConfig}->{Name} } // {} };

        my $DynamicFieldHTML = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
            Content            => $Param{DynamicFieldConfig}{Config}{Include},
            DynamicFields      => $DynamicField,
            UpdatableFields    => $Param{UpdatableFields},
            LayoutObject       => $Param{LayoutObject},
            ParamObject        => $Param{ParamObject},
            DynamicFieldValues => \%TemplateValues,
            CustomerInterface  => $Param{CustomerInterface},

            # can be set by preceding GetFieldState()
            PossibleValuesFilter => $Self->{PossibleValuesFilter}{ $Param{DynamicFieldConfig}->{Name} }[ $#SetValue + 1 ] // {},
            Object               => $Param{Object},
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

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}{Name};

    my $Value;

    # check if there is a Template and retrieve the dynamic field value from there
    if ( IsHashRefWithData( $Param{Template} ) && defined $Param{Template}->{$FieldName} ) {
        $Value = $Param{Template}->{$FieldName};
    }

    # otherwise get dynamic field value from the web request
    elsif (
        defined $Param{ParamObject}
        && ref $Param{ParamObject} eq 'Kernel::System::Web::Request'
        )
    {
        my @SetData;

        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        my @DataAll = $Param{ParamObject}->GetArray(
            Param => 'SetIndex_' . $Param{DynamicFieldConfig}->{Name},
        );

        # if we have nothing in the frontend just return
        return if !@DataAll;

        # get the highest multi value index (second to last; last is the empty template)
        my $IndexMax = $Param{DynamicFieldConfig}{Config}{MultiValue} ? $DataAll[-2] // 0 : 0;

        my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
        my $DynamicField = $Self->_GetIncludedDynamicFields(
            InputFieldDefinition => $Include,
            DynamicFieldObject   => $DynamicFieldObject,
        );

        return if !$DynamicField;

        DYNAMICFIELD:
        for my $Name ( sort keys $DynamicField->%* ) {
            if ( !IsHashRefWithData( $DynamicField->{$Name} ) ) {
                delete $DynamicField->{$Name};

                next DYNAMICFIELD;
            }

            # prevent overwriting names in cached data later
            $DynamicField->{$Name} = { $DynamicField->{$Name}->%* };
        }

        for my $Name ( sort keys $DynamicField->%* ) {
            my $DynamicFieldConfig = $DynamicField->{$Name};

            for my $SetIndex ( 0 .. $IndexMax ) {
                $DynamicFieldConfig->{Name} = $Name . '_' . $SetIndex;

                $SetData[$SetIndex]{$Name} = $BackendObject->EditFieldValueGet(
                    %Param,
                    DynamicFieldConfig => $DynamicFieldConfig,
                );
            }
        }

        return if !@SetData;
        $Value = \@SetData;
    }

    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq '1' ) {
        return {
            $FieldName => $Value,
        };
    }

    # TODO check if below comment is true
    # for this field the normal return an the ReturnValueStructure are the same
    return $Value;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    if (
        ( !defined $Param{GetParam}{DynamicField} || !defined $Param{GetParam}{DynamicField}{"DynamicField_$Param{DynamicFieldConfig}{Name}"} )
        && !$Param{Mandatory}
        )
    {
        return {
            ServerError  => undef,
            ErrorMessage => undef,
        };
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $IndexMax = 0;

    my $SetDFConfig = $Param{DynamicFieldConfig};

    if ( $SetDFConfig->{Config}{MultiValue} ) {
        my @DataAll = $Param{ParamObject}->GetArray(
            Param => 'SetIndex_' . $SetDFConfig->{Name},
        );

        # get the highest multi value index (second to last; last is the empty template)
        $IndexMax = $DataAll[-2] // 0;
    }

    my $Result;
    my $Include      = $SetDFConfig->{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject,
    );

    return 1 if !$DynamicField;

    DYNAMICFIELD:
    for my $Name ( sort keys $DynamicField->%* ) {
        if ( !IsHashRefWithData( $DynamicField->{$Name} ) ) {
            delete $DynamicField->{$Name};

            next DYNAMICFIELD;
        }

        # prevent overwriting names in cached data later
        $DynamicField->{$Name} = { $DynamicField->{$Name}->%* };
    }

    for my $SetIndex ( 0 .. $IndexMax ) {

        # map inner set values to GetParam
        my %SetDFValues = map {
            (
                "DynamicField_$_" => $Param{GetParam}{DynamicField}{"DynamicField_$SetDFConfig->{Name}"}[$SetIndex]{$_}
            )
        } keys $Param{GetParam}{DynamicField}{"DynamicField_$SetDFConfig->{Name}"}[$SetIndex]->%*;

        for my $Name ( sort keys $DynamicField->%* ) {
            my $DynamicFieldConfig = $DynamicField->{$Name};
            $DynamicFieldConfig->{Name} = $Name . '_' . $SetIndex;

            $Result->{ $DynamicFieldConfig->{Name} } = $BackendObject->EditFieldValueValidate(
                %Param,
                GetParam => {
                    $Param{GetParam}->%*,
                    DynamicField => {
                        $Param{GetParam}{DynamicField}->%*,
                        %SetDFValues,
                    },
                },
                DynamicFieldConfig => $DynamicFieldConfig,
            );
        }
    }

    return $Result;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Value} ) {
        return {
            Value => '',
            Title => '',
        };
    }

    # activate HTMLOutput when it wasn't specified
    my $HTMLOutput = $Param{HTMLOutput} // 1;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %SetValue = (
        Value => [],
        Title => [],
    );

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject,
    );

    return 1 if !$DynamicField;

    my @FieldOrdered = $Self->_GetIncludedFieldOrdered(
        Include => $Include,
    );

    for my $Name (@FieldOrdered) {
        my $DynamicFieldConfig = $DynamicField->{$Name};
        my $Label;

        if ($HTMLOutput) {
            $Label = $Param{LayoutObject}->Output(
                Template => '[% Translate( Data.Label ) | html %]',
                Data     => {
                    Label => $DynamicFieldConfig->{Label},
                },
            );
        }
        else {
            $Label = $Param{LayoutObject}->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} );
        }

        VALUE:
        for my $SetIndex ( 0 .. $#{ $Param{Value} } ) {
            next VALUE if !defined $Param{Value}[$SetIndex]{$Name};

            my $Element = $BackendObject->DisplayValueRender(
                %Param,
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Param{Value}[$SetIndex]{$Name},
            );

            next VALUE if !defined $Element->{Value} || $Element->{Value} eq '';

            if ($HTMLOutput) {
                $SetValue{Value}[$SetIndex] .= "<label>$Label</label><p class='Value'><span title='$Element->{Title}'>$Element->{Value}</span></p><div class='Clear'></div>";
            }
            else {
                $SetValue{Value}[$SetIndex] .= "$Label: $Element->{Value}\n";
                $SetValue{Title}[$SetIndex] .= "$Label: $Element->{Title}\n";
            }
        }
    }

    if ( !scalar $SetValue{Value}->@* ) {
        return {
            Value => '',
            Title => '',
        };
    }

    @{ $SetValue{Value} } = map { $_ // '' } $SetValue{Value}->@*;

    my %Value;
    if ($HTMLOutput) {
        $Value{Value} = '<div class="Clear"></div><div class="SetDisplayValue">'
            . join( '</div><div class="SetDisplayValue">', $SetValue{Value}->@* )
            . '</div>';
        $Value{Title} = '';
    }
    else {
        $Value{Value} = join( "\n", $SetValue{Value}->@* );
        $Value{Title} = join( "; ", $SetValue{Title}->@* );
    }

    return \%Value;
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => 'Dynamic field type Set is currently not searchable!',
    );

    return;
}

sub SearchFieldValueGet {
    my ( $Self, %Param ) = @_;

    return;
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    $Param{Value} ||= [];

    my %SetValue = (
        Value => [],
        Title => [],
    );

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject,
    );

    return if !$DynamicField;

    my @FieldOrdered = $Self->_GetIncludedFieldOrdered(
        Include => $Include,
    );

    for my $Name (@FieldOrdered) {
        my $DynamicFieldConfig = $DynamicField->{$Name};

        VALUE:
        for my $SetIndex ( 0 .. $#{ $Param{Value} } ) {
            next VALUE if !defined $Param{Value}[$SetIndex]{$Name};

            my $Element = $BackendObject->ReadableValueRender(
                %Param,
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Param{Value}[$SetIndex]{$Name},
            );

            $SetValue{Value}[$SetIndex] .= " $DynamicFieldConfig->{Label}: $Element->{Value};";
            $SetValue{Title}[$SetIndex] .= " $DynamicFieldConfig->{Label}: $Element->{Title};";
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

    my @Value;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # create 1 to 3 sets for MultiValue, else 1
    my $SetCount = $Param{DynamicFieldConfig}{Config}{MultiValue} ? int( rand(3) ) + 1 : 1;

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject,
    );

    return { Success => 0 } if !$DynamicField;

    for my $Name ( sort keys $DynamicField->%* ) {
        my $DynamicFieldConfig = $DynamicField->{$Name};

        my $Return = $BackendObject->RandomValueSet(
            %Param,
            DynamicFieldConfig => $DynamicFieldConfig,
            SetCount           => $SetCount,
        );

        return { Success => 0 } if !$Return->{Success};

        for my $SetIndex ( 0 .. $SetCount - 1 ) {
            $Value[$SetIndex]{$Name} = $Return->[$SetIndex];
        }
    }

    return {
        Success => 1,
        Value   => \@Value,
    };
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    return    unless defined $Param{Key};
    return [] unless ref $Param{Key} eq 'ARRAY';

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @SetValue;

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject,
    );

    return if !$DynamicField;

    my @FieldOrdered = $Self->_GetIncludedFieldOrdered(
        Include => $Include,
    );

    for my $Name (@FieldOrdered) {
        my $DynamicFieldConfig = $DynamicField->{$Name};

        VALUE:
        for my $SetIndex ( 0 .. $#{ $Param{Key} } ) {
            next VALUE unless defined $Param{Key}[$SetIndex]{$Name};

            $Param{Key}[$SetIndex]{$Name} = $BackendObject->ValueLookup(
                %Param,
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Param{Key}[$SetIndex]{$Name},
            );
        }
    }

    return $Param{Key};
}

sub SearchFieldPreferences {
    my ( $Self, %Param ) = @_;

    # this field makes no use of SearchFieldPreferences
    # nevertheless, function needs to be overwritten to make sure that the call doesn't reach SearchFieldPreferences in BaseSelect
    return;
}

sub GetFieldState {
    my ( $Self, %Param ) = @_;

    my %GetParam  = $Param{GetParam}->%*;
    my %DFParam   = %{ $GetParam{DynamicField} // {} };
    my $SetConfig = $Param{DynamicFieldConfig};
    my @SetValue  = $DFParam{"DynamicField_$SetConfig->{Name}"} ? $DFParam{"DynamicField_$SetConfig->{Name}"}->@* : ( {} );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $Include      = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicField = $Self->_GetIncludedDynamicFields(
        InputFieldDefinition => $Include,
        DynamicFieldObject   => $DynamicFieldObject,
    );

    return if !$DynamicField;

    my %Return;

    for my $SetIndex ( 0 .. $#SetValue ) {
        for my $Name ( sort keys $DynamicField->%* ) {
            $DFParam{"DynamicField_$Name"} = $SetValue[$SetIndex]{$Name};
        }

        my $LoopProtection = 100;
        my %SetFieldStates = $Param{FieldRestrictionsObject}->GetFieldStates(
            %Param,
            DynamicFields => $DynamicField,
            GetParam      => {
                %GetParam,
                %DFParam,
                DynamicField => \%DFParam,
            },
            LoopProtection     => \$LoopProtection,
            PossibleValuesOnly => 1,
            SetIndex           => $SetIndex,
        );

        for my $Name ( sort keys $SetFieldStates{Fields}->%* ) {

            # prepare the return used by the frontend modules for AJAX updates
            $Return{Set}{$Name}{DynamicFieldConfig}                     = $DynamicField->{$Name};
            $Return{Set}{$Name}{FieldStates}{ $Name . '_' . $SetIndex } = $SetFieldStates{Fields}{$Name};
            $Return{Set}{$Name}{Values}{ $Name . '_' . $SetIndex }      = exists $SetFieldStates{NewValues}{$Name}
                ?
                $SetFieldStates{NewValues}{$Name}
                : $DFParam{"DynamicField_$Name"};

            # set the new value of the set itself copied to GetParam in the frontend modules
            if ( $SetFieldStates{NewValues}{ 'DynamicField_' . $Name } ) {
                $Return{NewValue}[$SetIndex]{$Name} = $SetFieldStates{NewValues}{ 'DynamicField_' . $Name };
            }

            # store the reduced possible values in this object for a possible subsequent EditFieldRender
            $Self->{PossibleValuesFilter}{ $SetConfig->{Name} }[$SetIndex]{ 'DynamicField_' . $Name } = $SetFieldStates{Fields}{$Name}{PossibleValues};
        }
    }

    if ( $SetConfig->{Config}{MultiValue} ) {
        for my $Name ( sort keys $DynamicField->%* ) {
            $DFParam{"DynamicField_$Name"} = undef;
        }

        my $LoopProtection = 100;
        my %SetFieldStates = $Param{FieldRestrictionsObject}->GetFieldStates(
            %Param,
            DynamicFields => $DynamicField,
            GetParam      => {
                %GetParam,
                %DFParam,
                DynamicField => \%DFParam,
            },
            LoopProtection     => \$LoopProtection,
            PossibleValuesOnly => 1,
        );

        for my $Name ( sort keys $SetFieldStates{Fields}->%* ) {

            # prepare the return used by the frontend modules for AJAX updates
            $Return{Set}{$Name}{DynamicFieldConfig}                 = $DynamicField->{$Name};
            $Return{Set}{$Name}{FieldStates}{ $Name . '_Template' } = $SetFieldStates{Fields}{$Name};
            $Return{Set}{$Name}{Values}{ $Name . '_Template' }      = exists $SetFieldStates{NewValues}{$Name}
                ?
                $SetFieldStates{NewValues}{$Name}
                : $DFParam{"DynamicField_$Name"};

            # store the reduced possible values in this object for a possible subsequent EditFieldRender
            $Self->{PossibleValuesFilter}{ $SetConfig->{Name} }[ $#SetValue + 1 ]{ 'DynamicField_' . $Name } = $SetFieldStates{Fields}{$Name}{PossibleValues};
            $Self->{TemplateValues}{ $SetConfig->{Name} }{$Name} = exists $SetFieldStates{NewValues}{$Name}
                ?
                $SetFieldStates{NewValues}{$Name}
                : $DFParam{"DynamicField_$Name"};
        }
    }

    return %Return;
}

=head1 PRIVATE FUNCTIONS

=head2 _GetIncludedDynamicFields($Include, $DynamicFieldObject)

Helper Function for getting the Dynamic Fields from an Include, i.e.
$DynamicFields = $GetIncludedDynamicFields->($Param{DynamicFieldConfig}{Config}{Include});
This subroutine takes three arguments:
$Include: a list of hash references containing information about the items to include
$DynamicFieldObject: an object used to retrieve dynamic field information
and returns either the DynamicFields or undef in case of an error.

=cut

sub _GetIncludedDynamicFields {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my %DynamicField;

    # This subroutine takes a DFEntry and the DynamicFieldObject as arguments
    # It retrieves the dynamic field definition for the given DFEntry
    # If the definition is not available, it retrieves it from the DynamicFieldObject
    # Returns the dynamic field definition
    my $GetDynamicField = sub {

        my ($DFEntry) = @_;

        my $DynamicField = $DFEntry->{Definition} // $DynamicFieldObject->DynamicFieldGet(
            Name => $DFEntry->{DF},
        );

        return $DynamicField;
    };

    ITEM:
    for my $IncludeItem ( @{ $Param{InputFieldDefinition} } ) {

        if ( $IncludeItem->{Grid} ) {

            for my $Row ( @{ $IncludeItem->{Grid}{Rows} } ) {

                DFENTRY:
                for my $DFEntry ( $Row->@* ) {

                    my $DynamicField = $GetDynamicField->($DFEntry);
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

            my $DynamicField = $GetDynamicField->($IncludeItem);
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

sub _GetIncludedFieldOrdered {
    my ( $Self, %Param ) = @_;

    my @Return;

    ITEM:
    for my $IncludeItem ( @{ $Param{Include} } ) {

        if ( $IncludeItem->{Grid} ) {
            for my $Row ( @{ $IncludeItem->{Grid}{Rows} } ) {

                COLUMN:
                for my $DFEntry ( $Row->@* ) {
                    next COLUMN if !$DFEntry->{DF};

                    push @Return, $DFEntry->{DF};
                }
            }
        }
        elsif ( $IncludeItem->{DF} ) {
            push @Return, $IncludeItem->{DF};
        }
    }

    return @Return;
}

1;
