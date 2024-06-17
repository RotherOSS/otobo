# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

package Kernel::System::DynamicField::Driver::BaseDatabase;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldDB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
);

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::DynamicField::Driver::Base);

=head1 NAME

Kernel::System::DynamicField::Driver::BaseDatabase - sub module of
Kernel::System::DynamicField::Driver::Database

=head1 DESCRIPTION

Text common functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

sub ValueIsDifferent {
    my ( $Self, %Param ) = @_;

    # Special cases where the values are different but they should be reported as equals.
    return if !defined $Param{Value1} && ( defined $Param{Value2} && $Param{Value2} eq '' );
    return if !defined $Param{Value2} && ( defined $Param{Value1} && $Param{Value1} eq '' );

    # Special cases where one value is a scalar and the other one is an array (see bug#13998).
    if ( ref \$Param{Value1} eq 'SCALAR' && ref $Param{Value2} eq 'ARRAY' ) {
        my @TmpArray = sort { $a <=> $b } ( split ',', $Param{Value1} );
        @{ $Param{Value2} } = sort { $a <=> $b } @{ $Param{Value2} };

        return DataIsDifferent(
            Data1 => \@TmpArray,
            Data2 => $Param{Value2},
        );
    }
    if ( ref \$Param{Value2} eq 'SCALAR' && ref $Param{Value1} eq 'ARRAY' ) {
        my @TmpArray = sort { $a <=> $b } ( split ',', $Param{Value2} );
        @{ $Param{Value1} } = sort { $a <=> $b } @{ $Param{Value1} };

        return DataIsDifferent(
            Data1 => $Param{Value1},
            Data2 => \@TmpArray,
        );
    }

    # Compare the results.
    return DataIsDifferent(
        Data1 => \$Param{Value1},
        Data2 => \$Param{Value2},
    );
}

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $DFValue = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
    );

    return if !$DFValue;
    return if !IsArrayRefWithData($DFValue);
    return if !IsHashRefWithData( $DFValue->[0] );

    # extract real values
    my @ReturnData;
    for my $Item ( @{$DFValue} ) {
        push @ReturnData, $Item->{ValueText};
    }

    return \@ReturnData;
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # check value
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = @{ $Param{Value} };
    }
    else {

        my @CommaSeparatedValues = split ',', $Param{Value};

        if ( IsArrayRefWithData( \@CommaSeparatedValues ) ) {
            @Values = @CommaSeparatedValues;
        }
        else {
            @Values = ( $Param{Value} );
        }
    }

    # get local dynamic field value object
    my $DynamicFieldValue = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    my $Success;
    if ( IsArrayRefWithData( \@Values ) ) {

        # if there is at least one value to set, this means one or more values are selected,
        # set those values!
        my @ValueText;
        for my $Item (@Values) {
            push @ValueText, { ValueText => $Item };
        }

        $Success = $DynamicFieldValue->ValueSet(
            FieldID  => $Param{DynamicFieldConfig}->{ID},
            ObjectID => $Param{ObjectID},
            Value    => \@ValueText,
            UserID   => $Param{UserID},
        );
    }
    else {

        # otherwise no value was selected, then in fact this means that any value there should be
        # deleted
        $Success = $DynamicFieldValue->ValueDelete(
            FieldID  => $Param{DynamicFieldConfig}->{ID},
            ObjectID => $Param{ObjectID},
            UserID   => $Param{UserID},
        );
    }

    return $Success;
}

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    # check value
    my @Values;
    if ( IsArrayRefWithData( $Param{Value} ) ) {
        @Values = @{ $Param{Value} };
    }
    else {
        @Values = ( $Param{Value} );
    }

    my $Success;

    for my $Item (@Values) {

        $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueValidate(
            Value => {
                ValueText => $Item,
            },
            UserID => $Param{UserID}
        );

        return if !$Success;
    }

    return $Success;
}

sub FieldValueValidate {
    my ( $Self, %Param ) = @_;

    # Check for defined value.
    if ( !defined $Param{Value} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Value in Dropdown DynamicField!",
        );
        return;
    }

    my @Values;
    if ( IsArrayRefWithData( $Param{Value} ) ) {
        @Values = @{ $Param{Value} };
    }
    else {
        @Values = ( $Param{Value} );
    }

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::DynamicFieldDB' => {
            DynamicFieldConfig => $Param{DynamicFieldConfig},
        },
    );
    my $DynamicFieldDBObject = $Kernel::OM->Get('Kernel::System::DynamicFieldDB');

    for my $Value (@Values) {
        my @SearchResult = $DynamicFieldDBObject->DatabaseSearchByConfig(
            Config => $Param{DynamicFieldConfig}->{Config},
            Search => $Value,
        );
        return if !IsArrayRefWithData( \@SearchResult );
    }

    return 1;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    my %Operators = (
        Equals            => '=',
        GreaterThan       => '>',
        GreaterThanEquals => '>=',
        SmallerThan       => '<',
        SmallerThanEquals => '<=',
    );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $Operators{ $Param{Operator} } ) {
        my $SQL = " $Param{TableAlias}.value_text $Operators{$Param{Operator}} '";
        $SQL .= $DBObject->Quote( $Param{SearchTerm} ) . "' ";
        return $SQL;
    }

    if ( $Param{Operator} eq 'Like' ) {

        my $SQL = $DBObject->QueryCondition(
            Key   => "$Param{TableAlias}.value_text",
            Value => $Param{SearchTerm},
        );

        return $SQL;
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        'Priority' => 'error',
        'Message'  => "Unsupported Operator $Param{Operator}",
    );

    return;
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    return "$Param{TableAlias}.value_text";
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value = '';

    # Prepare the value to be comma separated and set the field value.
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = @{ $Param{Value} };
    }
    elsif ( IsStringWithData( $Param{Value} ) ) {
        @Values = ( $Param{Value} );
    }

    # Set new line separator.
    my $ItemSeparator = ', ';

    $Value = join $ItemSeparator, @Values;

    # Extract the dynamic field value from the web request and set it if present. Do this after
    #   stored value is retrieved and processed, so it can be overridden if form has refreshed for
    #   some reasons (i.e. attachment has been uploaded). See bug#12453 for more information.
    my $FieldValue = $Self->EditFieldValueGet(
        %Param,
    );
    if ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldDB W50pc';
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

    # get translations
    my $DetailedSearchMsg = $Param{LayoutObject}->{LanguageObject}->Translate("Detailed search");
    my $DetailsMsg        = $Param{LayoutObject}->{LanguageObject}->Translate("Details");
    my $RemoveValueMsg    = $Param{LayoutObject}->{LanguageObject}->Translate("Remove value");

    # Handling for DF database in CustomerTicketProcess screen (see bug#14036).
    my $DynamicFieldDBContainer = 'DynamicFieldDBContainer';
    if ( $Param{ParamObject}->GetParam( Param => 'Action' ) eq 'CustomerTicketProcess' ) {
        $DynamicFieldDBContainer .= ' DynamicFieldDBContainerProcess';
    }

    my $HTMLString = <<"EOF";
    <input type="text" class="$FieldClass" id="${FieldName}" title="$FieldLabel" value="$Value" />
    <a href="#" id="DynamicFieldDBDetailedSearch_${FieldName}" field="${FieldName}" alt="$DetailedSearchMsg" title="$DetailedSearchMsg"><i class="fa fa-search"></i></a>
    <input type="hidden" class="$FieldClass" width="100%" id="${FieldName}Data" name="${FieldName}" title="$FieldLabel" value="$Value" />
    <div class="Field Hidden">
        <div class="ResultElementTemplate${FieldName} Hidden">
            <input id="ResultElementText" class="ResultElementText Radio" type="text" readonly="readonly" value="" name="ResultElementText" title="" />
            <a href="#" class="DynamicFieldDBDetails_${FieldName} AddButton" field="${FieldName}" alt="$DetailsMsg" title="$DetailsMsg"><i class="fa fa-list-alt"></i></a>
            <a id="RemoveDynamicFieldDBEntry" class="RemoveButton" title="$RemoveValueMsg" href="#"><i class="fa fa-minus-square-o"></i></a>
        </div>
        <div id="${FieldName}Container" class="$DynamicFieldDBContainer"></div>
    </div>
EOF

    if ( $Param{Mandatory} ) {
        my $DivID = $FieldName . 'Error';

        my $FieldRequiredMessage = $Param{LayoutObject}->{LanguageObject}->Translate("This field is required.");

        # for client side validation
        $HTMLString .= <<"EOF";
    <div id="$DivID" class="TooltipErrorMessage">
        <p>
            $FieldRequiredMessage
        </p>
    </div>
EOF
    }

    if ( $Param{ServerError} ) {

        my $ErrorMessage = $Param{LayoutObject}->Output(
            'Template' => '[% Translate(Data.ErrorMessage) | html %]',
            'Data'     => {
                'ErrorMessage' => $Param{ErrorMessage} || 'This field is required.',
            }
        );
        my $DivID = $FieldName . 'ServerError';

        my $FieldRequiredMessage = $Param{LayoutObject}->{LanguageObject}->Translate($ErrorMessage);

        # for server side validation
        $HTMLString .= <<"EOF";
    <div id="$DivID" class="TooltipErrorMessage">
        <p>
            $FieldRequiredMessage
        </p>
    </div>
EOF
    }

    my $AutoCompleteConfig = $Kernel::OM->Get('Kernel::Config')->Get('AutoComplete::Agent')
        ->{'DynamicFieldDBSearch'};
    my $ActiveAutoComplete = $AutoCompleteConfig->{AutoCompleteActive} || 0;

    $Param{LayoutObject}->AddJSData(
        Key   => 'ActiveAutoComplete',
        Value => $ActiveAutoComplete,
    );

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        Mandatory          => $Param{Mandatory} || '0',
        FieldName          => $FieldName,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}

sub EditFieldValueGet {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    my $Value;

    # check if there is a Template and retrieve the dynamic field value from there
    if ( IsHashRefWithData( $Param{Template} ) ) {
        $Value = $Param{Template}->{$FieldName};
    }

    # otherwise get dynamic field value from the web request
    elsif (
        defined $Param{ParamObject}
        && ref $Param{ParamObject} eq 'Kernel::System::Web::Request'
        )
    {
        $Value = $Param{ParamObject}->GetParam( Param => $FieldName );
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

    # perform necessary validations
    if ( $Param{Mandatory} && $Value eq '' ) {
        $ServerError = 1;
    }

    # create resulting structure
    my $Result = {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };

    return $Result;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # set HTMLOutput as default if not specified
    if ( !defined $Param{HTMLOutput} ) {
        $Param{HTMLOutput} = 1;
    }

    # set Value and Title variables
    my $Value = '';
    my $Title = '';

    # check value
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = @{ $Param{Value} };
    }
    else {
        @Values = ( $Param{Value} );
    }

    my @ReadableValues;
    my @ReadableTitles;

    VALUEITEM:
    for my $Item (@Values) {

        next VALUEITEM if !$Item;

        my $ReadableTitle = $Item;
        my $ReadableValue = $Item;

        # HTMLOuput transformations
        if ( $Param{HTMLOutput} ) {

            $ReadableValue = $Param{LayoutObject}->Ascii2Html(
                Text => $ReadableValue,
                Max  => $Param{ValueMaxChars} || '',
            );

            $ReadableTitle = $Param{LayoutObject}->Ascii2Html(
                Text => $ReadableTitle,
                Max  => $Param{TitleMaxChars} || '',
            );
        }
        else {

            if ( $Param{ValueMaxChars} && length($ReadableValue) > $Param{ValueMaxChars} ) {
                $ReadableValue = substr( $ReadableValue, 0, $Param{ValueMaxChars} ) . '...';
            }
            if ( $Param{TitleMaxChars} && length($ReadableTitle) > $Param{TitleMaxChars} ) {
                $ReadableTitle = substr( $ReadableTitle, 0, $Param{TitleMaxChars} ) . '...';
            }
        }

        if ( length $ReadableValue ) {
            push @ReadableValues, $ReadableValue;
        }
        if ( length $ReadableTitle ) {
            push @ReadableTitles, $ReadableTitle;
        }
    }

    # set new line separator
    my $ItemSeparator = ', ';

    $Value = join $ItemSeparator, @ReadableValues;
    $Title = join $ItemSeparator, @ReadableTitles;

    # set field link form config
    my $Link        = $Param{DynamicFieldConfig}->{Config}->{Link}        || '';
    my $LinkPreview = $Param{DynamicFieldConfig}->{Config}->{LinkPreview} || '';

    # create return structure
    my $Data = {
        Value       => $Value,
        Title       => $Title,
        Link        => $Link,
        LinkPreview => $LinkPreview,
        Class       => 'DynamicFieldType_Database',
    };

    return $Data;
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    # set the field value
    my $Value = ( defined $Param{DefaultValue} ? $Param{DefaultValue} : '' );

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
    my $FieldClass = 'DynamicFieldDB';

    my $HTMLString = <<"EOF";
<input type="text" class="$FieldClass" id="${FieldName}" name="${FieldName}" title="$FieldLabel" value="$Value" />
EOF

    my $AdditionalText;
    if ( $Param{UseLabelHints} ) {
        $AdditionalText = 'e.g. Text or Te*t';
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        LayoutObject       => $Param{LayoutObject},
        FieldName          => $FieldName,
        AdditionalText     => $AdditionalText,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
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
    if ( $Value && $Value =~ m{\*} ) {

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

    # set Value and Title variables
    my $Value = '';
    my $Title = '';

    # check value
    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Values = @{ $Param{Value} };
    }
    else {
        @Values = ( $Param{Value} );
    }

    my @ReadableValues;

    VALUEITEM:
    for my $Item (@Values) {

        next VALUEITEM if !$Item;

        # cut strings if needed
        if ( $Param{ValueMaxChars} && length $Item > $Param{ValueMaxChars} ) {
            $Item = substr( $Item, 0, $Param{ValueMaxChars} ) . '...';
        }

        push @ReadableValues, $Item;
    }

    # set new line separator
    my $ItemSeparator = ', ';

    # Output transformations
    $Value = join $ItemSeparator, @ReadableValues;

    # prepare title
    $Title = $Value;

    if ( $Param{TitleMaxChars} && length $Title > $Param{TitleMaxChars} ) {
        $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
    }

    # create return structure
    my $Data = {
        Value => $Value,
        Title => $Title,
    };

    return $Data;
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

    my $Value = int( rand(500) );

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

    # get historical values from database
    my $HistoricalValues = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text',
    );

    # return the historical values from database
    return $HistoricalValues;
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    my $Value = defined $Param{Key} ? $Param{Key} : '';

    return $Value;
}

=back

=cut

1;
