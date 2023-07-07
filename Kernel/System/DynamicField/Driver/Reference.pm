# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::DynamicField::Driver::Reference;

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
use Kernel::System::VariableCheck qw(DataIsDifferent IsArrayRefWithData IsHashRefWithData IsStringWithData);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Reference - driver for the Reference dynamic field

=head1 DESCRIPTION

Store a reference to an object in an dynamic field. Object type specific features are provided in plugins.

=head1 PUBLIC INTERFACE

This dynamic field driver module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

it is usually not necessary to explicitly create instances of dynamic field drivers.
Instances of the drivers are created in the constructor of the
dynamic field backend object C<Kernel::System::DynamicField::Backend>.

=cut

sub new {
    my ($Type) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # Reference dynamic fields are stored in the database table attribute dynamic_field_value.value_int.
    # TODO: References to Customer and CustomerUser use a String as a key.
    $Self->{ValueKey}       = 'ValueInt';
    $Self->{TableAttribute} = 'value_int';

    # Used for declaring CSS classes
    $Self->{FieldCSSClass} = 'DynamicFieldReference';

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 0,
        'IsHiddenInTicketInformation'  => 0,
    };

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
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}{Config}{MultiValue},
    );
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    my $Value = $Self->ValueStructureToDB(
        Value      => $Param{Value},
        ValueKey   => $Self->{ValueKey},
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}{Config}{MultiValue},
    );

    return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        Value    => $Value,
        UserID   => $Param{UserID},
    );
}

# TODO: probably adjust Base.pm to check for arrays
sub ValueIsDifferent {
    my ( $Self, %Param ) = @_;

    # special cases where the values are different but they should be reported as equals
    if (
        !defined $Param{Value1}
        && ref $Param{Value2} eq 'ARRAY'
        && !IsArrayRefWithData( $Param{Value2} )
        )
    {
        return;
    }
    if (
        !defined $Param{Value2}
        && ref $Param{Value1} eq 'ARRAY'
        && !IsArrayRefWithData( $Param{Value1} )
        )
    {
        return;
    }

    # compare the results
    return DataIsDifferent(
        Data1 => \$Param{Value1},
        Data2 => \$Param{Value2},
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

    # get dynamic field value object
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    my $CheckRegex = 1;
    if (
        !IsArrayRefWithData( $Param{DynamicFieldConfig}->{Config}->{RegExList} )
        || ( defined $Param{NoValidateRegex} && $Param{NoValidateRegex} )
        )
    {
        $CheckRegex = 0;
    }

    my $Success;
    for my $Item (@Values) {
        $Success = $DynamicFieldValueObject->ValueValidate(
            Value => {
                $Self->{ValueKey} => $Param{Value},
            },
            UserID => $Param{UserID}
        );

        return if !$Success;

        if ( $CheckRegex && IsStringWithData($Item) ) {

            # check regular expressions
            my @RegExList = @{ $Param{DynamicFieldConfig}->{Config}->{RegExList} };

            REGEXENTRY:
            for my $RegEx (@RegExList) {

                if ( $Item !~ $RegEx->{Value} ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "The value '$Item' is not matching /"
                            . $RegEx->{Value} . "/ ("
                            . $RegEx->{ErrorMessage} . ")!",
                    );
                    return;
                }
            }
        }
    }

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{Operator} eq 'Like' ) {
        return $Kernel::OM->Get('Kernel::System::DB')->QueryCondition(
            Key   => "$Param{TableAlias}.$Self->{TableAttribute}",
            Value => $Param{SearchTerm},
        );
    }

    my %Operators = (
        Equals            => '=',
        GreaterThan       => '>',
        GreaterThanEquals => '>=',
        SmallerThan       => '<',
        SmallerThanEquals => '<=',
    );

    if ( $Param{Operator} eq 'Empty' ) {
        if ( $Param{SearchTerm} ) {
            return " $Param{TableAlias}.value_text IS NULL ";
        }
        else {
            my $DatabaseType = $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'};
            if ( $DatabaseType eq 'oracle' ) {
                return " $Param{TableAlias}.value_text IS NOT NULL ";
            }
            else {
                return " $Param{TableAlias}.value_text <> '' ";
            }
        }
    }
    elsif ( !$Operators{ $Param{Operator} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => "Unsupported Operator $Param{Operator}",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my $Lower    = '';
    if ( $DBObject->GetDatabaseFunction('CaseSensitive') ) {
        $Lower = 'LOWER';
    }

    my $SQL = " $Lower($Param{TableAlias}.value_text) $Operators{ $Param{Operator} } ";
    $SQL .= "$Lower('" . $DBObject->Quote( $Param{SearchTerm} ) . "') ";

    return $SQL;
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    return "$Param{TableAlias}.$Self->{TableAttribute}";
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};
    my $Object      = $FieldConfig->{ReferencedObjectType};

    my $Value = '';

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = $FieldConfig->{DefaultValue} // '';
    }
    $Value = $Param{Value} // $Value;

    # extract the dynamic field value from the web request
    my $FieldValue = $Self->EditFieldValueGet(
        %Param,
    );

    # set values from ParamObject if present
    if ( $FieldConfig->{MultiValue} ) {
        if ( $FieldValue->@* ) {
            $Value = $FieldValue;
        }
    }
    elsif ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    if ( !ref $Value ) {
        $Value = [$Value];
    }
    elsif ( !$Value->@* ) {
        $Value = [undef];
    }

    # check and set class if necessary
    my $FieldClass = "$Self->{FieldCSSClass} W50pc";    # for field specific JS
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    if ( $Param{Mandatory} ) {
        $FieldClass .= ' Validate_Required';
    }

    # set error css class
    if ( $Param{ServerError} ) {
        $FieldClass .= ' ServerError';
    }

    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $FieldLabel,
    );

    my %FieldTemplateData = (
        FieldClass        => $FieldClass,
        FieldName         => $FieldName,
        FieldLabelEscaped => $FieldLabelEscaped,
        MultiValue        => $FieldConfig->{MultiValue} || 0,
        ReadOnly          => $Param{ReadOnly},
    );

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/Reference'
        :
        'DynamicField/Agent/Reference';

    # Get default agent autocomplete config.
    my $AutoCompleteConfig = $Kernel::OM->Get('Kernel::Config')->Get('AutoComplete::Agent')->{'Default'};
    $Param{LayoutObject}->AddJSData(
        Key   => 'AutoCompleteActive',
        Value => $AutoCompleteConfig->{AutoCompleteActive},
    );

    # for getting descriptive names for the values, e.g. TicketNumber for TicketID
    my $PluginObject = $Self->_GetObjectTypePlugin(
        ObjectType => $FieldConfig->{ReferencedObjectType},
    );
    my @ResultHTML;
    for my $ValueIndex ( 0 .. $#{$Value} ) {
        $FieldTemplateData{FieldID} = $FieldConfig->{MultiValue} ? $FieldName . '_' . $ValueIndex : $FieldName;

        # The visible value depends on the referenced object
        my $ObjectID    = $Value->[$ValueIndex];
        my %Description = $PluginObject->ObjectDescriptionGet(
            ObjectID => $ObjectID,
            UserID   => 1,           # TODO: what about Permission check
        );
        $FieldTemplateData{VisibleValue} = $Param{LayoutObject}->Ascii2Html(
            Text => $Description{Long},
        );

        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => \%FieldTemplateData,
        );
    }

    my $TemplateHTML;
    if ( $FieldConfig->{MultiValue} && !$Param{ReadOnly} ) {

        $FieldTemplateData{FieldID} = $FieldTemplateData{FieldName} . '_Template';

        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => \%FieldTemplateData,
        );

    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        Mandatory => $Param{Mandatory} || '0',
        FieldName => $FieldName,
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
    if ( IsHashRefWithData( $Param{Template} ) && defined $Param{Template}->{$FieldName} ) {
        $Value = $Param{Template}->{$FieldName};
    }

    # otherwise get dynamic field value from the web request
    elsif (
        defined $Param{ParamObject}
        && ref $Param{ParamObject} eq 'Kernel::System::Web::Request'
        )
    {
        if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
            my @DataAll = $Param{ParamObject}->GetArray( Param => $FieldName );

            # delete the template value
            pop @DataAll;

            # delete empty values (can happen if the user has selected the "-" entry)
            $Value = [ map { $_ // '' } @DataAll ];
        }
        else {
            $Value = $Param{ParamObject}->GetParam( Param => $FieldName );
        }
    }

    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq '1' ) {
        return {
            $FieldName => $Value,
        };
    }

    # for this field the normal return an the ReturnValueStructure are the same
    return $Value;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        ParamObject        => $Param{ParamObject},

        # not necessary for this Driver but place it for consistency reasons
        ReturnValueStructure => 1,
    );

    my $ServerError;
    my $ErrorMessage;

    if ( !$Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        $Value = [$Value];
    }

    # create resulting structure
    return {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # activate HTMLOutput when it wasn't specified
    my $HTMLOutput = $Param{HTMLOutput} // 1;

    # get raw Title and Value strings from field value
    my $ValueMaxChars = $Param{ValueMaxChars} || '';
    my $TitleMaxChars = $Param{TitleMaxChars} || '';

    # check value
    my @ObjectIDs;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @ObjectIDs = @{ $Param{Value} };
    }
    else {
        @ObjectIDs = ( $Param{Value} );
    }

    # get descriptive names for the values, e.g. TicketNumber for TicketID
    my @LongObjectDescriptions;
    {
        my $FieldConfig  = $Param{DynamicFieldConfig}->{Config};
        my $PluginObject = $Self->_GetObjectTypePlugin(
            ObjectType => $FieldConfig->{ReferencedObjectType},
        );
        if ($PluginObject) {
            for my $ObjectID (@ObjectIDs) {
                my %Description = $PluginObject->ObjectDescriptionGet(
                    ObjectID => $ObjectID,
                    UserID   => 1,           # TODO: what about Permission check
                );
                push @LongObjectDescriptions, $Description{Long} // '';
            }
        }
    }

    my ( @ReadableValues,    @ReadableTitles );
    my ( $ShowValueEllipsis, $ShowTitleEllipsis );

    VALUEITEM:
    for my $ReadableValue (@LongObjectDescriptions) {
        my $ReadableLength = length $ReadableValue;

        # set title equal value
        my $ReadableTitle = $ReadableValue;

        # cut strings if needed
        if ( $ValueMaxChars ne '' ) {

            if ( length $ReadableValue > $ValueMaxChars ) {
                $ShowValueEllipsis = 1;
            }
            $ReadableValue = substr $ReadableValue, 0, $ValueMaxChars;

            # decrease the max parameter
            $ValueMaxChars = $ValueMaxChars - $ReadableLength;
            if ( $ValueMaxChars < 0 ) {
                $ValueMaxChars = 0;
            }
        }

        if ( $TitleMaxChars ne '' ) {

            if ( length $ReadableTitle > $ValueMaxChars ) {
                $ShowTitleEllipsis = 1;
            }
            $ReadableTitle = substr $ReadableTitle, 0, $TitleMaxChars;

            # decrease the max parameter
            $TitleMaxChars = $TitleMaxChars - $ReadableLength;
            if ( $TitleMaxChars < 0 ) {
                $TitleMaxChars = 0;
            }
        }

        # HTMLOutput transformations
        if ($HTMLOutput) {

            $ReadableValue = $Param{LayoutObject}->Ascii2Html(
                Text => $ReadableValue,
            );
            $ReadableTitle = $Param{LayoutObject}->Ascii2Html(
                Text => $ReadableTitle,
            );
        }

        push @ReadableValues, $ReadableValue;
        if ( length $ReadableTitle ) {
            push @ReadableTitles, $ReadableTitle;
        }
    }

    # set new line separator
    my $ItemSeparator = $HTMLOutput ? '<br>' : '\n';

    my $Value = join $ItemSeparator, @ReadableValues;
    my $Title = join $ItemSeparator, @ReadableTitles;

    if ($ShowValueEllipsis) {
        $Value .= '...';
    }
    if ($ShowTitleEllipsis) {
        $Title .= '...';
    }

    # set field link from config
    my $Link        = $Param{DynamicFieldConfig}->{Config}->{Link}        || '';
    my $LinkPreview = $Param{DynamicFieldConfig}->{Config}->{LinkPreview} || '';

    # return a data structure
    return {
        Value       => $Value,
        Title       => $Title,
        Link        => $Link,
        LinkPreview => $LinkPreview,
    };
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    # set the field value
    my $Value = $Param{DefaultValue} // '';

    # get the field value, this function is always called after the profile is loaded
    my $FieldValue = $Self->SearchFieldValueGet(%Param);

    # set values from profile if present
    if ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    # check if value is an array reference (GenericAgent Jobs and NotificationEvents)
    if ( IsArrayRefWithData($Value) ) {
        $Value = @{$Value}[0];
    }

    # check and set class if necessary
    my $FieldClass = $Self->{FieldCSSClass};    # for field specific JS

    my $ValueEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $Value,
    );

    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $FieldLabel,
    );

    my $HTMLString = <<"EOF";
<input type="text" class="$FieldClass" id="$FieldName" name="$FieldName" title="$FieldLabelEscaped" value="$ValueEscaped" />
EOF

    my $AdditionalText;
    if ( $Param{UseLabelHints} ) {
        $AdditionalText = Translatable('e.g. Text or Te*t');
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        FieldName      => $FieldName,
        AdditionalText => $AdditionalText,
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
        $Value = $Param{ParamObject}->GetParam(
            Param => 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name}
        );
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

    # set operator
    my $Operator = 'Equals';

    # search for a wild card in the value
    if ( $Value && ( $Value =~ m{\*} || $Value =~ m{\|\|} ) ) {

        # change operator
        $Operator = 'Like';
    }

    # return search parameter structure
    return {
        Parameter => {
            $Operator => $Value,
        },
        Display => $Value,
    };
}

sub StatsFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    return {
        Name    => $Param{DynamicFieldConfig}->{Label},
        Element => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        Block   => 'InputField',
    };
}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Value = $Param{Value};

    # set operator
    my $Operator = 'Equals';

    # search for a wild card in the value
    if ( $Value && $Value =~ m{\*} ) {

        # change operator
        $Operator = 'Like';
    }

    return {
        $Operator => $Value,
    };
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = '';

    # check value
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = @{ $Param{Value} };
    }
    else {
        @Values = ( $Param{Value} );
    }

    # set new line separator
    my $ItemSeparator = ', ';

    # Output transformations
    $Value = join( $ItemSeparator, @Values );
    my $Title = $Value;

    # cut strings if needed
    if ( $Param{ValueMaxChars} && length($Value) > $Param{ValueMaxChars} ) {
        $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '...';
    }
    if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
        $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
    }

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
    my $SearchValueType = 'SCALAR';

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
                    $Value->[$i][$j] = int( rand(500) );
                }
            }
        }
        else {
            for my $i ( 0 .. $Param{SetCount} - 1 ) {
                $Value->[$i] = int( rand(500) );
            }
        }

        $Param{Set} = 1;
    }

    elsif ( $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
        for my $j ( 0 .. int( rand(3) ) ) {
            $Value->[$j] = int( rand(500) );
        }
    }

    else {
        $Value = int( rand(500) );
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
    return 0 unless defined $Param{ObjectAttributes}->{$FieldName};

    # return false if not match
    return 1 if $Param{ObjectAttributes}->{$FieldName} eq $Param{Value};
    return 0;
}

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    # return the historical values from database
    return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text',
    );
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    return $Param{Key} // '';
}

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

    # For reference dynamic fields we can select the
    # type of the referenced object. Only objects
    # that support dynamic fields can be referenced.
    # For now take the list from the SysConfig.
    my %ObjectTypeSelectionData;
    {
        my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
        my $FieldTypeConfig = $ConfigObject->Get('DynamicFields::Driver');
        %ObjectTypeSelectionData = map
            { $_ => $_ }
            $FieldTypeConfig->{Reference}->{ReferencedObjectTypes}->@*;
    }

    # set up the field type specific settings
    # This dynamic field support multiple values.
    my %MultiValueSelectionData = (
        0 => Translatable('No'),
        1 => Translatable('Yes'),
    );

    my @GenericSettings = (
        {
            ConfigParamName => 'ReferencedObjectType',
            Label           => Translatable('Referenced object type'),
            Explanation     => Translatable('Select the type of of referenced object'),
            InputType       => 'Selection',
            SelectionData   => \%ObjectTypeSelectionData,
            PossibleNone    => 1,
        },
        {
            ConfigParamName => 'MultiValue',
            Label           => Translatable('Multiple Values'),
            Explanation     => Translatable('Activate this option to allow multiple values for this field.'),
            InputType       => 'Selection',
            SelectionData   => \%MultiValueSelectionData,
            PossibleNone    => 0,
        }
    );

    # Get settings that depend on the referenced object type
    my $ParamObject = $Param{ParamObject};

    # The referenced object type might have been passed in the URL
    my $ReferencedObjectType = $ParamObject->GetParam( Param => 'ReferencedObjectType' );

    # or it can be taken from the existing configuration
    if ( !$ReferencedObjectType ) {
        my $FieldID = $ParamObject->GetParam( Param => 'ID' );
        if ($FieldID) {
            my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
            my $DynamicField       = $DynamicFieldObject->DynamicFieldGet(
                ID => $FieldID,
            );

            if ( ref $DynamicField eq 'HASH' && ref $DynamicField->{Config} eq 'HASH' ) {
                $ReferencedObjectType = $DynamicField->{Config}->{ReferencedObjectType};
            }
        }
    }

    my @SpecificSettings;
    if ($ReferencedObjectType) {
        my $PluginObject = $Self->_GetObjectTypePlugin(
            ObjectType => $ReferencedObjectType,
        );
        @SpecificSettings = $PluginObject->GetFieldTypeSettings;
    }
    return ( @GenericSettings, @SpecificSettings );
}

=begin Internal:

=head2 _GetObjectTypePlugin()

Get an instance of the plugin for the object type.

=cut

sub _GetObjectTypePlugin {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    NEEDED:
    for my $Needed (qw(ObjectType)) {
        next NEEDED if $Param{$Needed};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need $Needed!"
        );

        return;
    }

    my $ObjectType = $Param{ObjectType};

    # load the plugin
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $PluginModule = join '::', 'Kernel::System::DynamicField::Driver::Reference', $ObjectType;
    if ( !$MainObject->Require($PluginModule) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't load Reference dynamic field plugin module for object type $ObjectType!",
        );

        return;
    }

    # create a plugin object
    my $PluginObject = $PluginModule->new;
    if ( !$PluginObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Couldn't create a plugin object for object type $ObjectType!",
        );

        return;
    }

    if ( ref $PluginObject ne $PluginModule ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Plugin object for object type $ObjectType was not created successfully!",
        );

        return;
    }

    # give back the plugin
    return $PluginObject;
}

=end Internal:

=cut

1;
