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

package Kernel::System::DynamicField::Driver::BaseReference;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseEntity);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(DataIsDifferent IsArrayRefWithData IsHashRefWithData IsStringWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::BaseReference - driver for the Reference dynamic field

=head1 DESCRIPTION

Store a reference to an object in an dynamic field. Object type specific features are provided in plugins.

=head1 PUBLIC INTERFACE

This dynamic field driver module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=cut

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

    # TODO adapt for filter list?
    my $CheckRegex = 1;
    if (
        !IsArrayRefWithData( $Param{DynamicFieldConfig}->{Config}->{RegExList} )
        || ( defined $Param{NoValidateRegex} && $Param{NoValidateRegex} )
        )
    {
        $CheckRegex = 0;
    }

    my $Success;
    for my $Value (@Values) {
        $Success = $DynamicFieldValueObject->ValueValidate(
            Value => {
                $Self->{ValueKey} => $Value,
            },
            UserID => $Param{UserID},
        );

        return if !$Success;

        if ( $CheckRegex && IsStringWithData($Value) ) {

            # check regular expressions
            my @RegExList = @{ $Param{DynamicFieldConfig}->{Config}->{RegExList} };

            REGEXENTRY:
            for my $RegEx (@RegExList) {

                if ( $Value !~ $RegEx->{Value} ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "The value '$Value' is not matching /"
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
    my $DFDetails  = $Param{DynamicFieldConfig}->{Config};
    my $FieldName  = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel = $Param{DynamicFieldConfig}->{Label};

    my $Value = '';

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = $DFDetails->{DefaultValue} // '';
    }
    $Value = $Param{Value} // $Value;

    # Extract the dynamic field value from the web request and set it if present. Do this after
    #   stored value is retrieved and processed, so it can be overridden if form has refreshed for
    #   some reasons (i.e. attachment has been uploaded). See bug#12453 for more information.
    my $FieldValue = $Self->EditFieldValueGet(
        %Param,
    );

    # set values from ParamObject if present
    if ( defined $FieldValue && $FieldValue && $FieldValue->@* ) {
        $Value = $FieldValue;
    }

    if ( !ref $Value ) {
        $Value = [$Value];
    }
    elsif ( !$Value->@* ) {
        $Value = [undef];
    }

    # check and set class if necessary
    my $FieldClass = "$Self->{FieldCSSClass} DynamicFieldText Modernize";    # for field specific JS
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

    my %FieldTemplateData = (
        FieldClass => $FieldClass,
        FieldName  => $FieldName,
        Readonly   => $Param{DynamicFieldConfig}->{Readonly},
    );

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/'
        :
        'DynamicField/Agent/';

    my $PossibleValues;
    my @SelectionHTML;
    if ( $DFDetails->{EditFieldMode} eq 'AutoComplete' ) {
        $FieldTemplateFile .= 'Reference';

        # Get default agent autocomplete config.
        my $AutoCompleteConfig = $Kernel::OM->Get('Kernel::Config')->Get( 'AutoComplete::' . ( $Param{CustomerInterface} ? 'Customer' : 'Agent' ) )->{'Default'};

        $Param{LayoutObject}->AddJSData(
            Key   => 'AutoCompleteActive',
            Value => $AutoCompleteConfig->{AutoCompleteActive},
        );
    }
    else {
        $FieldTemplateFile .= 'BaseSelect';

        $PossibleValues = $Self->PossibleValuesGet(%Param);

        if ( $DFDetails->{MultiValue} ) {
            for my $ValueIndex ( 0 .. $#{$Value} ) {
                my $FieldID = $FieldName . '_' . $ValueIndex;
                push @SelectionHTML, $Param{LayoutObject}->BuildSelection(
                    Data         => $PossibleValues || {},
                    Disabled     => $Param{Readonly},
                    Name         => $FieldName,
                    ID           => $FieldID,
                    SelectedID   => $Value->[$ValueIndex],
                    Class        => $FieldClass,
                    HTMLQuote    => 1,
                    Translation  => $DFDetails->{Translation},
                    PossibleNone => 0,
                );
            }
        }
        else {
            my @SelectedIDs = grep {$_} $Value->@*;
            push @SelectionHTML, $Param{LayoutObject}->BuildSelection(
                Data         => $PossibleValues || {},
                Disabled     => $Param{Readonly},
                Name         => $FieldName,
                SelectedID   => \@SelectedIDs,
                Class        => $FieldClass,
                HTMLQuote    => 1,
                Multiple     => $DFDetails->{Multiselect},
                Translation  => $DFDetails->{Translation},
                PossibleNone => 0,
            );
        }
    }

    my %Error = (
        ServerError => $Param{ServerError},
        Mandatory   => $Param{Mandatory},
    );
    my @ResultHTML;
    for my $ValueIndex ( 0 .. ( $DFDetails->{Multiselect} ? 0 : $#{$Value} ) ) {
        my $FieldID = $DFDetails->{MultiValue} ? $FieldName . '_' . $ValueIndex : $FieldName;

        if ( !$ValueIndex ) {
            if ( $Error{ServerError} ) {
                $Error{DivIDServerError} = "${FieldID}ServerError";
                $Error{ErrorMessage}     = Translatable( $Param{ErrorMessage} || 'This field is required.' );
            }
            if ( $Error{Mandatory} ) {
                $Error{DivIDMandatory}       = "${FieldID}Error";
                $Error{FieldRequiredMessage} = Translatable('This field is required.');
            }
        }

        # The actual value is the techical ID of the referenced object.
        # This might be empty e.g. in a ticket createion mask.
        my $VisibleValue;
        my $ReferencedObjectID = $Value->[$ValueIndex];
        if ($ReferencedObjectID) {

            # The visible value depends on the referenced object
            my %Description = $Self->ObjectDescriptionGet(
                ObjectID => $ReferencedObjectID,
                UserID   => 1,                     # TODO: what about Permission check
            );
            $VisibleValue = $Param{LayoutObject}->Ascii2Html(
                Text => $Description{Long},
            );
        }

        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                %Error,
                FieldID       => $FieldID,
                Value         => ( $Value->[$ValueIndex] // '' ),
                VisibleValue  => ( $VisibleValue         // '' ),
                SelectionHTML => ( $DFDetails->{EditFieldMode} ne 'AutoComplete' ? $SelectionHTML[$ValueIndex] : undef ),
            },
        );
    }

    my $TemplateHTML;
    if ( $DFDetails->{MultiValue} && !$Param{Readonly} ) {
        $FieldTemplateData{FieldID} = $FieldName . '_Template';

        my $SelectionHTML = $Param{LayoutObject}->BuildSelection(
            Data        => $PossibleValues || {},
            Disabled    => $Param{Readonly},
            Name        => $FieldName,
            ID          => $FieldTemplateData{FieldID},
            Class       => $FieldClass,
            HTMLQuote   => 1,
            Multiple    => $DFDetails->{Multiselect},
            Translation => $DFDetails->{TranslatableValues} || 0,
        );
        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                SelectionHTML => ( $DFDetails->{EditFieldMode} ne 'AutoComplete' ? $SelectionHTML : undef ),
            },
        );
    }

    if ( $Param{AJAXUpdate} ) {

        my $FieldSelector = '#' . $FieldName;

        my $FieldsToUpdate = '';
        if ( IsArrayRefWithData( $Param{UpdatableFields} ) ) {

            # Remove current field from updatable fields list
            my @FieldsToUpdate = grep { $_ ne $FieldName } @{ $Param{UpdatableFields} };

            # quote all fields, put commas in between them
            $FieldsToUpdate = join( ', ', map {"'$_'"} @FieldsToUpdate );
        }

        # add js to call FormUpdate()
        $Param{LayoutObject}->AddJSOnDocumentComplete( Code => <<"EOF");
\$('$FieldSelector').bind('change', function (Event) {
    Core.AJAX.FormUpdate(\$(this).parents('form'), 'AJAXUpdate', '$FieldName', [ $FieldsToUpdate ]);
});
Core.App.Subscribe('Event.AJAX.FormUpdate.Callback', function(Data) {
    var FieldName = '$FieldName';
});
EOF
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        Mandatory => $Param{Mandatory} || '0',
        FieldName => $DFDetails->{MultiValue} ? "${FieldName}_0" : $FieldName,
    );

    my %Data = (
        Label => $LabelString,
    );

    # decide which structure to return
    if ( $DFDetails->{MultiValue} ) {
        $Data{MultiValue}         = \@ResultHTML;
        $Data{MultiValueTemplate} = $TemplateHTML;
    }
    else {
        $Data{Field} = $ResultHTML[0];
    }

    return \%Data;
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

    # TODO validate by re-executing SearchObject()?

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
    my $Link;
    {
        my $DFDetails = $Param{DynamicFieldConfig}->{Config};
        for my $ObjectID (@ObjectIDs) {
            if ($ObjectID) {
                my %Description = $Self->ObjectDescriptionGet(
                    ObjectID     => $ObjectID,
                    Link         => $HTMLOutput,
                    LayoutObject => $Param{LayoutObject},
                );
                push @LongObjectDescriptions, $Description{Long};
                $Link = $Description{Link};
            }
            else {
                push @LongObjectDescriptions, '';
            }
        }
    }

    my ( @ReadableValues,    @ReadableTitles );
    my ( $ShowValueEllipsis, $ShowTitleEllipsis );

    VALUEITEM:
    for my $ReadableValue (@LongObjectDescriptions) {
        $ReadableValue //= '';
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
        push @ReadableTitles, $ReadableTitle;
    }

    # set new line separator
    my $ItemSeparator = $HTMLOutput ? '<br/>' : '\n';

    my $Value = join $ItemSeparator, @ReadableValues;
    my $Title = join ', ', @ReadableTitles;

    if ($ShowValueEllipsis) {
        $Value .= '...';
    }
    if ($ShowTitleEllipsis) {
        $Title .= '...';
    }

    # set field link TODO: (Prio 5) think about multi value
    $Link = scalar @ObjectIDs == 1 ? $Link : undef;

    # return a data structure
    return {
        Value       => $Value,
        Title       => $Title,
        Link        => $Link,
        LinkPreview => '',
    };
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $DFDetails  = $Param{DynamicFieldConfig}->{Config};
    my $FieldName  = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel = $Param{DynamicFieldConfig}->{Label};

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

    # prevent joining undefined values
    @Values = map { $_ // '' } @Values;

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

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    return $Param{Key} // '';
}

sub GetFieldTypeSettings {
    my ( $Self, %Param ) = @_;

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

    # setting independent from the referenced object
    my @GenericSettings;

    # For reference dynamic fields we want to display the referenced object type,
    # but the user should not be able to easily change that.
    # The select field can't be simply disabled as this would prevent that the info
    # is passed to the backend. Therefore we set up a list with a single element.
    {
        push @GenericSettings,
            {
                ConfigParamName => 'ReferencedObjectType',
                Label           => Translatable('Referenced object type'),
                Explanation     => Translatable('Select the type of the referenced object'),
                InputType       => 'Selection',
                SelectionData   => { $ReferencedObjectType => $ReferencedObjectType },
                PossibleNone    => 0,
                Mandatory       => 1,
            };
    }

    # set up the edit field mode selection
    {
        push @GenericSettings,
            {
                ConfigParamName => 'EditFieldMode',
                Label           => Translatable('Input mode of edit field'),
                Explanation     => Translatable('Select the input mode for the edit field.'),
                InputType       => 'Selection',
                SelectionData   => {
                    'AutoComplete' => 'AutoComplete',
                    'Dropdown'     => 'Dropdown',
                    'Multiselect'  => 'Multiselect',
                },
                PossibleNone => 0,
            };
    }

    # add possible none option
    {
        push @GenericSettings,
            {
                ConfigParamName => 'PossibleNone',
                Label           => Translatable('Add empty value'),
                Explanation     => Translatable('Activate this option to create an empty selectable value.'),
                InputType       => 'Selection',
                SelectionData   => {
                    0 => Translatable('No'),
                    1 => Translatable('Yes'),
                },
                PossibleNone => 0,
            };
    }

    # set up the field type specific settings
    # This dynamic field support multiple values.
    {
        my %MultiValueSelectionData = (
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        );

        push @GenericSettings,
            {
                ConfigParamName => 'MultiValue',
                Label           => Translatable('Multiple Values'),
                Explanation     => Translatable('Activate this option to allow multiple values for this field.'),
                InputType       => 'Selection',
                SelectionData   => \%MultiValueSelectionData,
                PossibleNone    => 0,
            };
    }

    return @GenericSettings;
}

=head2 PossibleValuesGet()

A wrapper for SearchObjects method.

    $DynamicFieldBackendObject->PossibleValuesGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # required
        Object             => {                         # optional
            %TicketData,
        },
    );

=cut

sub PossibleValuesGet {
    my ( $Self, %Param ) = @_;

    my %PossibleValues;

    # set PossibleNone attribute
    my $FieldPossibleNone;
    if ( defined $Param{OverridePossibleNone} ) {
        $FieldPossibleNone = $Param{OverridePossibleNone};
    }
    else {
        $FieldPossibleNone = $Param{DynamicFieldConfig}->{Config}->{PossibleNone} || 0;
    }

    # set none value if defined on field config
    if ($FieldPossibleNone) {
        %PossibleValues = ( '' => '-' );
    }

    # passing $Param{Object} to SearchObjects()
    my @SearchResult = $Self->SearchObjects(
        %Param,
    );

    for my $ResultItem (@SearchResult) {
        my %ItemDescription = $Self->ObjectDescriptionGet(
            ObjectID => $ResultItem,
            UserID   => 1,
        );
        %PossibleValues = (
            %PossibleValues,
            $ResultItem => $ItemDescription{Long},
        );
    }

    return \%PossibleValues;
}

1;
