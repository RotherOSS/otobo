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

package Kernel::System::DynamicField::Driver::Checkbox;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::Base);

# core modules
use List::Util qw(sum);

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Ticket::ColumnFilter',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Checkbox - checkbox dynamic field

=head1 DESCRIPTION

DynamicFields Checkbox driver delegate

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

    # Checkbox dynamic fields are stored in the database table attribute dynamic_field_value.value_int
    $Self->{ValueKey}       = 'ValueInt';
    $Self->{TableAttribute} = 'value_int';

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 1,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 1,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 1,
        'IsSetCapable'                 => 1,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::Checkbox');

    EXTENSION:
    for my $ExtensionKey ( sort keys $DynamicFieldDriverExtensions->%* ) {

        # skip invalid extensions
        next EXTENSION unless IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension declares a new parent module
        if ( $Extension->{Module} ) {

            # load extension module and bail out when that fails
            if ( !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} ) ) {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # check if extension contains more behaviors
        if ( IsHashRefWithData( $Extension->{Behaviors} ) ) {

            %{ $Self->{Behaviors} } = (
                %{ $Self->{Behaviors} },
                %{ $Extension->{Behaviors} }
            );
        }
    }

    return $Self;
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    # get raw values of the dynamic field
    my $DFValue = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}{ID},
        ObjectID => $Param{ObjectID},
    );

    return $Self->ValueStructureFromDB(
        ValueDB    => $DFValue,
        ValueKey   => $Self->{ValueKey},
        MultiValue => $Param{DynamicFieldConfig}{Config}{MultiValue},
        Set        => $Param{Set},
    );
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # transform empty values into 0 to be able to use ValueStructureToDB
    if ( $Param{Set} && $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
        for my $i ( 0 .. $#{ $Param{Value} } ) {
            for my $j ( 0 .. $#{ $Param{Value}[$i] } ) {
                if ( defined $Param{Value}[$i][$j] && !$Param{Value}[$i][$j] ) {
                    $Param{Value}[$i][$j] = 0;
                }
                elsif ( $Param{Value}[$i][$j] && $Param{Value}[$i][$j] !~ m{\A [0|1]? \z}xms ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Value $Param{Value}[$i][$j] is invalid for Checkbox fields!",
                    );
                    return;
                }
            }
        }
    }
    elsif ( $Param{Set} || $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
        for my $i ( 0 .. $#{ $Param{Value} } ) {
            if ( defined $Param{Value}[$i] && !$Param{Value}[$i] ) {
                $Param{Value}[$i] = 0;
            }
            elsif ( $Param{Value}[$i] && $Param{Value}[$i] !~ m{\A [0|1]? \z}xms ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Value $Param{Value}[$i] is invalid for Checkbox fields!",
                );
                return;
            }
        }
    }
    else {
        if ( defined $Param{Value} && !$Param{Value} ) {
            $Param{Value} = 0;
        }
        elsif ( $Param{Value} && $Param{Value} !~ m{\A [0|1]? \z}xms ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Value $Param{Value} is invalid for Checkbox fields!",
            );
            return;
        }
    }

    my $DBValue = $Self->ValueStructureToDB(
        Value      => $Param{Value},
        ValueKey   => $Self->{ValueKey},
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}{Config}{MultiValue},
    );

    return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        Value    => $DBValue,
        UserID   => $Param{UserID},
    );
}

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    # check values
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = @{ $Param{Value} };
    }
    else {
        @Values = ( $Param{Value} );
    }

    for my $Value (@Values) {

        # check value for just 1 or 0
        if ( defined $Value && !$Value ) {
            $Value = 0;
        }
        elsif ( $Value && $Value !~ m{\A [0|1]? \z}xms ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Value $Value is invalid for Checkbox fields!",
            );
            return;
        }
    }

    my $Success;
    for my $Value (@Values) {
        $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueValidate(
            Value => {
                $Self->{ValueKey} => $Value,
            },
            UserID => $Param{UserID},
        );
        return if !$Success;
    }

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    if ( !IsInteger( $Param{SearchTerm} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => "Unsupported Search Term $Param{SearchTerm}, should be an integer",
        );
        return;
    }

    my %Operators = (
        Equals => '=',
    );

    if ( $Param{Operator} eq 'Empty' ) {
        if ( $Param{SearchTerm} ) {
            return " $Param{TableAlias}.value_int IS NULL ";
        }
        else {
            return " $Param{TableAlias}.value_int IS NOT NULL ";
        }
    }
    elsif ( !$Operators{ $Param{Operator} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => "Unsupported Operator $Param{Operator}",
        );
        return;
    }

    my $SQL = " $Param{TableAlias}.value_int $Operators{ $Param{Operator} } ";
    $SQL
        .= $Kernel::OM->Get('Kernel::System::DB')->Quote( $Param{SearchTerm}, 'Integer' ) . ' ';
    return $SQL;
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    return "$Param{TableAlias}.value_int";
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig   = $Param{DynamicFieldConfig}->{Config};
    my $FieldName     = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldNameUsed = $FieldName . "Used";
    my $FieldLabel    = $Param{DynamicFieldConfig}->{Label};

    my @Values;

    # extract the dynamic field value from the web request
    my $FieldValue = $Self->EditFieldValueGet(
        ReturnValueStructure => 1,
        %Param,
    );

    # cover the single value case
    if ( !$FieldConfig->{MultiValue} ) {
        $FieldValue = [$FieldValue];
    }

    # set values from ParamObject if present
    if ( defined $FieldValue && $FieldValue->@* ) {

        VALUE_ITEM:
        for my $ValueItem ( $FieldValue->@* ) {
            next VALUE_ITEM unless defined $ValueItem;
            next VALUE_ITEM unless IsHashRefWithData($ValueItem);
            next VALUE_ITEM unless defined $ValueItem->{UsedValue};
            next VALUE_ITEM unless defined $ValueItem->{UsedValue} eq '1';

            my $ValueIsUsed = ( $ValueItem->{UsedValue} // '' ) eq '1';
            if ( !defined $ValueItem->{FieldValue} && $ValueIsUsed ) {
                push @Values, {
                    FieldValue => 0,
                    UsedValue  => 1,
                };
                next VALUE_ITEM;
            }

            push @Values, {
                FieldValue => $ValueItem->{FieldValue},
                UsedValue  => $ValueItem->{UsedValue},
            };
        }
    }

    if ( !@Values ) {

        my @SimpleValues;

        if ( !defined $Param{Value} ) {

            # do nothing
        }
        elsif ( ref $Param{Value} eq 'ARRAY' ) {
            push @SimpleValues, $Param{Value}->@*;
        }
        else {
            push @SimpleValues, $Param{Value};
        }

        if ( !@SimpleValues && $Param{UseDefaultValue} ) {

            # might be undef
            push @SimpleValues, $FieldConfig->{DefaultValue};
        }

        if ( !@SimpleValues ) {
            push @SimpleValues, undef;
        }

        @Values = map { { FieldValue => $_ } } @SimpleValues;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldCheckbox';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set classes according to mandatory and acl hidden params
    if ( $Param{ACLHidden} && $Param{Mandatory} ) {
        $FieldClass .= ' Validate_Required_IfVisible';
    }
    elsif ( $Param{Mandatory} ) {
        $FieldClass .= ' Validate_Required';
    }

    # set readonly css class
    if ( $Param{Readonly} ) {
        $FieldClass .= ' ReadOnly';
    }

    # set error css class
    if ( $Param{ServerError} ) {
        $FieldClass .= ' ServerError';
    }

    # set ajaxupdate class
    if ( $Param{AJAXUpdate} ) {
        $FieldClass .= ' FormUpdate';
    }

    my %FieldTemplateData = (
        'FieldNameUsed' => $FieldNameUsed,
        'FieldClass'    => $FieldClass,
        'FieldName'     => $FieldName,
    );

    my %Confirmation = (
        ConfirmationNeeded => $Param{ConfirmationNeeded},
    );

    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $FieldLabel,
    );

    $FieldTemplateData{FieldLabelEscaped} = $FieldLabelEscaped;
    $FieldTemplateData{Readonly}          = $Param{Readonly} ? 1 : 0;

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/Checkbox'
        :
        'DynamicField/Agent/Checkbox';

    my %Error = (
        ServerError => $Param{ServerError},
        Mandatory   => $Param{Mandatory},
    );
    my @ResultHTML;
    for my $ValueIndex ( 0 .. $#Values ) {
        my $Value = $Values[$ValueIndex];

        # set suffix and adjust ids for template
        my $Suffix = $Param{DynamicFieldConfig}{Config}{MultiValue} ? '_' . $ValueIndex : '';
        $FieldTemplateData{FieldID}     = $FieldName . $Suffix;
        $FieldTemplateData{FieldIDUsed} = $FieldNameUsed . $Suffix;
        $FieldTemplateData{DivID}       = $FieldName . $Suffix;

        if ( $Confirmation{ConfirmationNeeded} ) {

            # set checked property
            $Confirmation{FieldUsedChecked0} = '';
            $Confirmation{FieldUsedChecked1} = '';
            if ( $Value->{UsedValue} ) {
                $Confirmation{FieldUsedChecked1} = 'checked ';
            }
            else {
                $Confirmation{FieldUsedChecked0} = 'checked ';
            }

            $Confirmation{FieldNameUsed0} = $FieldNameUsed . '0';
            $Confirmation{FieldIDUsed0}   = $FieldNameUsed . '0' . $Suffix;
            $Confirmation{FieldNameUsed1} = $FieldNameUsed . '1';
            $Confirmation{FieldIDUsed1}   = $FieldNameUsed . '1' . $Suffix;
            $Confirmation{Description}    = Translatable('Ignore this field.');

            $Confirmation{NoIgnoreField} = $Param{NoIgnoreField};
        }

        if ( !$ValueIndex ) {
            if ( $Error{ServerError} ) {
                $Error{DivIDServerError} = $FieldName . 'ServerError' . $Suffix;
                $Error{ErrorMessage}     = Translatable( $Param{ErrorMessage} || 'This field is required.' );
            }
            if ( $Error{Mandatory} ) {
                $Error{DivIDMandatory}       = $FieldName . 'Error' . $Suffix;
                $Error{FieldRequiredMessage} = Translatable('This field is required.');
            }
        }

        # set as checked if necessary
        my $FieldChecked = ( defined $Value->{UsedValue} ? $Value->{UsedValue} eq 1 : 1 ) && defined $Value->{FieldValue} && $Value->{FieldValue} eq 1;
        $FieldTemplateData{FieldChecked} = $FieldChecked ? 'checked ' : '';

        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                %Confirmation,
                %Error,
            },
        );
    }

    # build template html
    my $TemplateHTML;
    if ( $FieldConfig->{MultiValue} && !$Param{Readonly} ) {

        # adjust ids for template
        $FieldTemplateData{FieldID} = $FieldName . '_Template';
        $FieldTemplateData{DivID}   = $FieldName . '_Template';

        if ( $Confirmation{ConfirmationNeeded} ) {

            # set checked property
            $Confirmation{FieldUsedChecked0} = 'checked ';

            $Confirmation{FieldNameUsed0} = $FieldNameUsed . '0';
            $Confirmation{FieldIDUsed0}   = $FieldNameUsed . '0_Template';
            $Confirmation{FieldNameUsed1} = $FieldNameUsed . '1';
            $Confirmation{FieldIDUsed1}   = $FieldNameUsed . '1_Template';
            $Confirmation{Description}    = Translatable('Ignore this field.');

            $Confirmation{NoIgnoreField} = $Param{NoIgnoreField};
        }

        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                %Confirmation,
            },
        );
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        Mandatory => $Param{Mandatory} || '0',
        FieldName => $FieldConfig->{MultiValue} ? $FieldName . '_0' : $FieldName,
    );

    my $Data = {
        Label => $LabelString,
    };

    if ( $FieldConfig->{MultiValue} ) {
        $Data->{MultiValue}         = \@ResultHTML;
        $Data->{MultiValueTemplate} = $TemplateHTML;
    }
    else {
        $Data->{Field} = $ResultHTML[0];
    }

    return $Data;
}

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    my $Value;

    # check if there is a Template and retrieve the dynamic field value from there
    if (
        IsHashRefWithData( $Param{Template} ) && (
            defined $Param{Template}->{$FieldName}
            || defined $Param{Template}->{ $FieldName . 'Used' }
        )
        )
    {
        $Value = {
            FieldValue => $Param{Template}->{$FieldName},
            UsedValue  => $Param{Template}->{ $FieldName . 'Used' },
        };
    }

    # otherwise get dynamic field value from the web request
    elsif (
        defined $Param{ParamObject}
        && ref $Param{ParamObject} eq 'Kernel::System::Web::Request'
        )
    {
        if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
            my @DataValues = $Param{ParamObject}->GetArray( Param => $FieldName );
            my @DataUsed   = $Param{ParamObject}->GetArray( Param => $FieldName . 'Used' );

            # delete template used value
            pop @DataUsed;

            # NOTE deleting actual template value only necessary when default value is 1
            if ( $Param{DynamicFieldConfig}->{Config}{DefaultValue} ) {
                pop @DataValues;
            }

            my @CheckedValues;
            INDEX:
            for my $Index (@DataValues) {
                next INDEX unless $Index;

                $CheckedValues[ $Index - 1 ] = 1;
            }

            for my $ValueIndex ( 0 .. $#DataUsed ) {
                push $Value->@*, {
                    FieldValue => $CheckedValues[$ValueIndex],
                    UsedValue  => $DataUsed[$ValueIndex],
                };
            }
        }
        else {
            $Value = {
                FieldValue => $Param{ParamObject}->GetParam( Param => $FieldName ),
                UsedValue  => $Param{ParamObject}->GetParam( Param => $FieldName . 'Used' ),
            };

        }
    }

    # check if return value structure is needed
    if ( defined $Param{ReturnValueStructure} && $Param{ReturnValueStructure} eq '1' ) {
        return $Value;
    }

    # check if return template structure is needed
    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq '1' ) {

        # transform data into needed structure and return based on multivalue
        if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
            my @ReturnStructure;
            for my $ValueItem ( $Value->@* ) {
                push @ReturnStructure, {
                    $FieldName          => $ValueItem->{FieldValue},
                    $FieldName . 'Used' => $ValueItem->{UsedValue},
                };
            }
            return \@ReturnStructure;
        }
        else {
            return {
                $FieldName          => $Value->{FieldValue},
                $FieldName . 'Used' => $Value->{UsedValue},
            };
        }
    }

    # return undef if the hidden value is not present
    if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        return if !sum map { $_->{UsedValue} } $Value->@*;
    }
    else {
        return if !$Value->{UsedValue};
    }

    # set the correct return value
    if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        return [ map { ( defined $_->{FieldValue} ) ? 1 : 0 } $Value->@* ];
    }
    else {
        return ( defined $Value->{FieldValue} ) ? 1 : 0;
    }
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        ParamObject        => $Param{ParamObject},
    );

    my $ServerError;
    my $ErrorMessage;

    if ( !$Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        $Value = [$Value];
    }

    # perform necessary validations

    for my $ValueItem ( @{$Value} ) {

        # validate only 0 or 1 as possible values
        if ( $ValueItem && $ValueItem ne 1 ) {
            $ServerError  = 1;
            $ErrorMessage = 'The field content is invalid';
        }
    }

    # return resulting structure
    return {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # get raw Value strings from field value
    my @Values = !ref $Param{Value}
        ? ( $Param{Value} )
        : scalar $Param{Value}->@* ? $Param{Value}->@*
        :                            ('');

    my @ReadableValues;
    my @ReadableTitles;
    for my $ValueItem (@Values) {
        $ValueItem //= '';

        $ValueItem = $ValueItem ? 'Checked' : 'Unchecked';

        # translate value
        $ValueItem = $Param{LayoutObject}->{LanguageObject}->Translate($ValueItem);

        # set title as value after update and before limit
        push @ReadableTitles, $ValueItem;

        push @ReadableValues, $ValueItem;
    }

    my $ValueSeparator = '<br>';

    # return a data structure
    return {
        Value => '' . join( $ValueSeparator, @ReadableValues ),
        Title => '' . join( ', ',            @ReadableTitles ),
        Link  => undef,    # this field type does not support the Link Feature
    };
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value;

    my @DefaultValue;

    if ( defined $Param{DefaultValue} ) {
        @DefaultValue = split /;/, $Param{DefaultValue};
    }

    # set the field value
    if (@DefaultValue) {
        $Value = \@DefaultValue;
    }

    # get the field value, this function is always called after the profile is loaded
    my $FieldValues = $Self->SearchFieldValueGet(
        %Param,
    );

    if ( defined $FieldValues ) {
        $Value = $FieldValues;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldDropdown Modernize';

    if ( $FieldConfig->{MultiValue} ) {
        for my $Item ( @{$Value} ) {

            # value must be 1, '' or -1
            if ( !defined $Item || !$Item ) {
                $Item = '';
            }
            elsif ( $Item && $Item >= 1 ) {
                $Item = 1;
            }
            else {
                $Item = -1;
            }

        }

    }
    else {

        # value must be 1, '' or -1
        if ( !defined $Value || !$Value ) {
            $Value = '';
        }
        elsif ( $Value && $Value >= 1 ) {
            $Value = 1;
        }
        else {
            $Value = -1;
        }
    }

    my $HTMLString = $Param{LayoutObject}->BuildSelection(
        Data => {
            1  => 'Checked',
            -1 => 'Unchecked',
        },
        Name         => $FieldName,
        SelectedID   => $Value || '',
        Translation  => 1,
        PossibleNone => 1,
        Class        => $FieldClass,
        Multiple     => 1,
        HTMLQuote    => 1,
    );

    # call EditLabelRender on the common backend
    my $LabelString = $Self->EditLabelRender(
        %Param,
        FieldName => $FieldName,
    );

    return {
        Field => $HTMLString,
        Label => $LabelString,
    };
}

sub SearchFieldValueGet {
    my ( $Self, %Param ) = @_;

    my $Value;

    # get dynamic field value from param object
    if ( defined $Param{ParamObject} ) {
        my @FieldValues = $Param{ParamObject}->GetArray(
            Param => 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name}
        );

        $Value = \@FieldValues;
    }

    # otherwise get the value from the profile
    elsif ( defined $Param{Profile} ) {
        $Value = $Param{Profile}->{ 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name} };
    }
    else {
        return;
    }

    if ( defined $Param{ReturnProfileStructure} && $Param{ReturnProfileStructure} eq 1 ) {
        return {
            'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name} => $Value,
        };
    }

    return $Value;
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # get field value
    my $Value = $Self->SearchFieldValueGet(%Param);

    my $DisplayValue;

    if ( defined $Value && !$Value ) {
        $DisplayValue = '';
    }

    if ($Value) {
        if ( ref $Value eq 'ARRAY' ) {

            my @DisplayItemList;
            for my $Item ( @{$Value} ) {

                # set the display value
                my $DisplayItem = $Item eq 1
                    ? 'Checked'
                    : $Item eq -1 ? 'Unchecked'
                    :               '';

                # translate the value
                if ( defined $Param{LayoutObject} ) {
                    $DisplayItem = $Param{LayoutObject}->{LanguageObject}->Translate($DisplayItem);
                }

                push @DisplayItemList, $DisplayItem;

                # set the correct value for "unchecked" (-1) search options
                if ( $Item && $Item eq -1 ) {
                    $Item = '0';
                }
            }

            # combine different values into one string
            $DisplayValue = join ' + ', @DisplayItemList;
        }
        else {

            # set the display value
            $DisplayValue = $Value eq 1
                ? 'Checked'
                : $Value eq -1 ? 'Unchecked'
                :                '';

            # translate the value
            if ( defined $Param{LayoutObject} ) {
                $DisplayValue = $Param{LayoutObject}->{LanguageObject}->Translate($DisplayValue);
            }
        }

        # set the correct value for "unchecked" (-1) search options
        if ( $Value && $Value eq -1 ) {
            $Value = '0';
        }
    }

    # return search parameter structure
    return {
        Parameter => {
            Equals => $Value,
        },
        Display => $DisplayValue,
    };
}

sub StatsFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    return {
        Values => {
            '1'  => 'Checked',
            '-1' => 'Unchecked',
        },
        Name               => $Param{DynamicFieldConfig}->{Label},
        Element            => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        TranslatableValues => 1,
    };
}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Operator = 'Equals';
    my $Value    = $Param{Value};

    if ( IsArrayRefWithData($Value) ) {
        for my $Item ( @{$Value} ) {

            # set the correct value for "unchecked" (-1) search options
            if ( $Item && $Item eq '-1' ) {
                $Item = '0';
            }
        }
    }
    else {

        # set the correct value for "unchecked" (-1) search options
        if ( $Value && $Value eq '-1' ) {
            $Value = '0';
        }
    }

    return {
        $Operator => $Value,
    };
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    # transform value data type
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = $Param{Value}->@*;
    }
    else {
        @Values = ( $Param{Value} );
    }

    # Create a comma separated list
    my $Value = join ', ', map { $_ // '' } @Values;

    # Title is always equal to Value
    my $Title = $Value;

    # return a data structure
    return {
        Value => $Value,
        Title => $Title,
    };
}

sub TemplateValueTypeGet {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # set the field types
    my $EditValueType   = 'SCALAR';
    my $SearchValueType = 'ARRAY';

    # return the correct structure
    if ( $Param{FieldType} eq 'Edit' ) {
        return {
            $FieldName => $EditValueType,
        };
    }
    elsif ( $Param{FieldType} eq 'Search' ) {
        return {
            'Search_' . $FieldName => $SearchValueType,
        };
    }
    else {
        return {
            $FieldName             => $EditValueType,
            'Search_' . $FieldName => $SearchValueType,
        };
    }
}

sub RandomValueSet {
    my ( $Self, %Param ) = @_;

    my $Value;

    if ( $Param{SetCount} ) {
        if ( $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
            for my $i ( 0 .. $Param{SetCount} - 1 ) {
                for my $j ( 0 .. int( rand(3) ) ) {
                    $Value->[$i][$j] = int( rand(2) );
                }
            }
        }
        else {
            for my $i ( 0 .. $Param{SetCount} - 1 ) {
                $Value->[$i] = int( rand(2) );
            }
        }

        $Param{Set} = 1;
    }

    elsif ( $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
        for my $j ( 0 .. int( rand(3) ) ) {
            $Value->[$j] = int( rand(2) );
        }
    }

    else {
        $Value = int( rand(2) );
    }

    my $Success = $Self->ValueSet(
        %Param,
        Value => $Value,
    );

    if ( !$Success ) {
        return {
            Success => 0,
        };
    }
    return {
        Success => 1,
        Value   => $Value,
    };
}

sub ObjectMatch {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # return false if field is not defined
    return 0 if ( !defined $Param{ObjectAttributes}->{$FieldName} );

    # return false if not match
    if ( $Param{ObjectAttributes}->{$FieldName} ne $Param{Value} ) {
        return 0;
    }

    return 1;
}

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    # return historical values from database
    return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Integer',
    );
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    return unless defined $Param{Key};
    return '' if $Param{Key} eq '';

    my $Value = defined $Param{Key} && $Param{Key} eq '1' ? 'Checked' : 'Unchecked';

    # check if translation is possible
    if ( defined $Param{LanguageObject} ) {

        # translate value
        $Value = $Param{LanguageObject}->Translate($Value);
    }

    return $Value;
}

sub ColumnFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # set PossibleValues
    my $SelectionData = {
        0 => 'Unchecked',
        1 => 'Checked',
    };

    # article uses the same routine as ticket
    my $ObjectType = $Param{DynamicFieldConfig}{ObjectType} eq 'Article' ? 'Ticket' : $Param{DynamicFieldConfig}{ObjectType};

    # get column filter values from database
    my $ColumnFilterValues = $Kernel::OM->Get("Kernel::System::${ObjectType}::ColumnFilter")->DynamicFieldFilterValuesGet(
        %Param,
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Integer',
    );

    # get the display value if still exist in dynamic field configuration
    for my $Key ( sort keys %{$ColumnFilterValues} ) {
        if ( $SelectionData->{$Key} ) {
            $ColumnFilterValues->{$Key} = $SelectionData->{$Key};
        }
    }

    # translate the value
    for my $ValueKey ( sort keys %{$ColumnFilterValues} ) {

        my $OriginalValueName = $ColumnFilterValues->{$ValueKey};
        $ColumnFilterValues->{$ValueKey} = $Param{LayoutObject}->{LanguageObject}->Translate($OriginalValueName);
    }

    return $ColumnFilterValues;
}

1;
