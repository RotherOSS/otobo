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
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::Output::HTML::DynamicField::Mask',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Set - driver for the Set dynamic field

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
    };

    return $Self;
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
    my @DynamicFields;

    # This subroutine takes a DFEntry and the DynamicFieldObject as arguments
    # It retrieves the dynamic field definition for the given DFEntry
    # If the definition is not available, it retrieves it from the DynamicFieldObject
    # Returns the dynamic field definition
    my $GetDynamicField = sub {

        my ($DFEntry) = @_;

        my $DynamicField = $DFEntry->{Definition} // $Param{DynamicFieldObject}->DynamicFieldGet(
            Name => $DFEntry->{DF},
        );

        return $DynamicField;
    };

    my $Error;

    ITEM:
    for my $IncludeItem ( @{ $Param{Include} } ) {

        if ( $IncludeItem->{Grid} ) {

            for my $Row ( @{ $IncludeItem->{Grid}{Rows} } ) {

                for my $DFEntry ( $Row->@* ) {

                    my $DynamicField = $GetDynamicField->($DFEntry);
                    if ($DynamicField) {
                        push @DynamicFields, $DynamicField;
                    }
                    else {
                        $Error = "Error in Line: $DFEntry";
                        last ITEM;
                    }
                }
            }
        }
        elsif ( $IncludeItem->{DF} ) {

            my $DynamicField = $GetDynamicField->($IncludeItem);
            if ($DynamicField) {
                push @DynamicFields, $DynamicField;
            }
            else {
                $Error = "No DynamicField '$IncludeItem->{DF}'.";
                last ITEM;
            }
        }
        else {
            $Error = "Need either Grid or DF in each Row.";
            last ITEM;
        }
    }

    if ($Error) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Configuration Error. $Error",
        );

        return;
    }
    else {
        return \@DynamicFields;
    }
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @SetValue;

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    for my $i ( 0 .. $#{$DynamicFields} ) {

        my $DynamicField = $DynamicFields->[$i];

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

    my @SetValue = defined $Param{Value} ? $Param{Value}->@* : ( [] );    # TODO: why not simply ()  ???

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    return if !$DynamicFields;

    for my $i ( 0 .. $#{$DynamicFields} ) {

        my $DynamicField = $DynamicFields->[$i];

        # The values for an included dynamic field are the values from the respective column
        my @FieldValue = map { $_->[$i] } @SetValue;

        if (
            !$BackendObject->ValueSet(
                %Param,
                DynamicFieldConfig => $DynamicField,
                Value              => \@FieldValue,
                Set                => 1,
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

    my @SetValue = defined $Param{Value} ? $Param{Value}->@* : ( [] );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    return if !$DynamicFields;

    for my $i ( 0 .. $#{$DynamicFields} ) {

        for my $SetIndex ( 0 .. $#SetValue ) {

            return if !$BackendObject->ValueValidate(
                %Param,
                DynamicFieldConfig => $DynamicFields->[$i],
                ,
                Value => $SetValue[$SetIndex][$i],
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
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

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

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/Set'
        :
        'DynamicField/Agent/Set';

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

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    if ( !$DynamicFields ) {
        return;
    }
    else {

        for my $i ( 0 .. $#{$DynamicFields} ) {

            my $DynamicField = $DynamicFields->[$i];

            # prevent overwriting names in cached data
            $DynamicFieldConfigs{ $DynamicField->{Name} } = { $DynamicField->%* };

            for my $SetIndex ( 0 .. $#SetValue ) {
                $DynamicFieldValues[$SetIndex]{ 'DynamicField_' . $DynamicField->{Name} . '_' . $SetIndex } = $SetValue[$SetIndex][$i];
            }
        }
    }

    # TODO: Improve
    my $StoreBlockData = delete $Param{LayoutObject}{BlockData};

    for my $SetIndex ( 0 .. $#SetValue ) {
        for my $Name ( keys %DynamicFieldConfigs ) {
            $DynamicFieldConfigs{$Name}{Name} = $Name . '_' . $SetIndex;
        }

        my $DynamicFieldHTML = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
            Content            => $Include,
            DynamicFields      => \%DynamicFieldConfigs,
            UpdatableFields    => $Param{UpdatableFields},
            LayoutObject       => $Param{LayoutObject},
            ParamObject        => $Param{ParamObject},
            DynamicFieldValues => $DynamicFieldValues[$SetIndex],
            CustomerInterface  => $Param{CustomerInterface},

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

        my $DynamicFieldHTML = $Kernel::OM->Get('Kernel::Output::HTML::DynamicField::Mask')->EditSectionRender(
            Content            => $Param{DynamicFieldConfig}{Config}{Include},
            DynamicFields      => \%DynamicFieldConfigs,
            UpdatableFields    => $Param{UpdatableFields},
            LayoutObject       => $Param{LayoutObject},
            ParamObject        => $Param{ParamObject},
            DynamicFieldValues => {},
            CustomerInterface  => $Param{CustomerInterface},

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
    my $IndexMax = $Param{DynamicFieldConfig}{Config}{MultiValue} ? $DataAll[-2] // 0 : 0;

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    if ( !$DynamicFields ) {
        return;
    }
    else {
        for my $i ( 0 .. $#{$DynamicFields} ) {

            my $DynamicField = $DynamicFields->[$i];

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
    }

    return if !@SetData;
    return \@SetData;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $IndexMax = 0;

    if ( $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
        my @DataAll = $Param{ParamObject}->GetArray(
            Param => 'SetIndex_' . $Param{DynamicFieldConfig}->{Name},
        );

        # get the highest multivalue index (second to last; last is the empty template)
        $IndexMax = $DataAll[-2] // 0;
    }

    my $Result;
    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    if ( !$DynamicFields ) {

        # return error result
        return;
    }

    for my $i ( 0 .. $#{$DynamicFields} ) {

        # prevent overwriting names in cached data
        my $DynamicField = { $DynamicFields->[$i]->%* };

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

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    if ( !$DynamicFields ) {
        return;
    }
    else {
        for my $i ( 0 .. $#{$DynamicFields} ) {

            my $DynamicField = $DynamicFields->[$i];
            my $Label;

            if ($HTMLOutput) {
                $Label = $Param{LayoutObject}->Output(
                    Template => '[% Translate( Data.Label ) | html %]',
                    Data     => {
                        Label => $DynamicField->{Label},
                    },
                );
            }
            else {
                $Label = $Param{LayoutObject}->{LanguageObject}->Translate( $DynamicField->{Label} );
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

                if ($HTMLOutput) {
                    $SetValue{Value}[$SetIndex] .= "<label>$Label</label><p class='Value'><span title='$Element->{Title}'>$Element->{Value}</span></p>";
                }
                else {
                    $SetValue{Value}[$SetIndex] .= "$Label: $Element->{Value}\n";
                    $SetValue{Title}[$SetIndex] .= "$Label: $Element->{Title}\n";
                }
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
        $Value{Value} = '<div class="SetDisplayValue">'
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

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my %SetValue = (
        Value => [],
        Title => [],
    );

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    return if !$DynamicFields;

    for my $i ( 0 .. $#{$DynamicFields} ) {

        my $DynamicField = $DynamicFields->[$i];
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

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields(
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    if ( !$DynamicFields )
    {

        $Success = 0;
    }
    else {
        for my $i ( 0 .. $#{$DynamicFields} ) {

            my $DynamicField = $DynamicFields->[$i];
            my $Return       = $BackendObject->RandomValueSet(
                %Param,
                DynamicFieldConfig => $DynamicField,
                SetCount           => $SetCount,
            );

            if ( !$Return->{Success} ) {
                $Success = 0;
            }

            push @Value, $Return->{Value};
        }
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

    my $Include       = $Param{DynamicFieldConfig}{Config}{Include};
    my $DynamicFields = $Self->_GetIncludedDynamicFields (
        Include            => $Include,
        DynamicFieldObject => $DynamicFieldObject
    );

    return if !$DynamicFields;

    for my $i ( 0 .. $#{$DynamicFields} ) {

        my $DynamicField = $DynamicFields->[$i];

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

sub SearchFieldPreferences {
    my ( $Self, %Param ) = @_;

    # this field makes no use of SearchFieldPreferences
    # nevertheless, function needs to be overwritten to make sure that the call doesn't reach SearchFieldPreferences in BaseSelect
    return;
}

1;
