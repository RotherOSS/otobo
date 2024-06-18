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

package Kernel::System::DynamicField::Driver::BaseScript;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::Base);

# core modules
use List::Util qw(none);

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::DynamicField',
    'Kernel::System::Event',
    'Kernel::System::Log',
    'Kernel::System::Web::FormCache',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::DynamicField::Driver::BaseScript

=head1 DESCRIPTION

Script common functions.

=head1 PUBLIC INTERFACE

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 1,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 1,
        'IsLikeOperatorCapable'        => 1,
        'IsScriptField'                => 1,
        'SetsDynamicContent'           => 1,
        'IsSetCapable'                 => 1,
    };

    # TODO: probably needs completion for all frontends
    $Self->{Uniformity} = {
        Dest => 'Queue',
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
        ValueKey   => 'ValueText',
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}{Config}{MultiValue},
    );
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    # we only set the value from event triggers
    return 1 unless $Param{Store};

    my $Value = $Self->ValueStructureToDB(
        Value      => $Param{Value},
        ValueKey   => 'ValueText',
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

sub ValueValidate {
    my ( $Self, %Param ) = @_;

    my @Values;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        for my $Value ( @{ $Param{Value} } ) {
            push @Values, { ValueText => $Value };
        }
    }
    else {
        @Values = ( { ValueText => $Param{Values} } );
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
            Value  => $Item,
            UserID => $Param{UserID}
        );
        return if !$Success;

        if ( $CheckRegex && IsStringWithData( $Item->{ValueText} ) ) {

            # check regular expressions
            my @RegExList = @{ $Param{DynamicFieldConfig}->{Config}->{RegExList} };

            REGEXENTRY:
            for my $RegEx (@RegExList) {

                if ( $Item->{ValueText} !~ $RegEx->{Value} ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "The value '$Item->{ValueText}' is not matching /"
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
        my $SQL = $Kernel::OM->Get('Kernel::System::DB')->QueryCondition(
            Key   => "$Param{TableAlias}.value_text",
            Value => $Param{SearchTerm},
        );

        return $SQL;
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

    return "$Param{TableAlias}.value_text";
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value = $Param{Value} // '';

    if ( !ref $Value ) {
        $Value = [$Value];
    }
    elsif ( !$Value->@* ) {
        $Value = [undef];
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText W50pc';
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
        Readonly          => $Param{Readonly},
    );

    my $FieldTemplateFile = $Param{CustomerInterface}
        ? 'DynamicField/Customer/BaseScript'
        : 'DynamicField/Agent/BaseScript';

    my %Error = (
        ServerError => $Param{ServerError},
        Mandatory   => $Param{Mandatory},
    );
    my @ResultHTML;
    for my $ValueIndex ( 0 .. $#{$Value} ) {
        $FieldTemplateData{FieldID} = $FieldConfig->{MultiValue} ? $FieldName . '_' . $ValueIndex : $FieldName;

        if ( !$ValueIndex ) {
            if ( $Error{ServerError} ) {
                $Error{DivIDServerError} = $FieldTemplateData{FieldID} . 'ServerError';
                $Error{ErrorMessage}     = Translatable( $Param{ErrorMessage} || 'This field is required.' );
            }
            if ( $Error{Mandatory} ) {
                $Error{DivIDMandatory}       = $FieldTemplateData{FieldID} . 'Error';
                $Error{FieldRequiredMessage} = Translatable('This field is required.');
            }
        }

        my $ValueItem    = $Value->[$ValueIndex];
        my $ValueEscaped = $Param{LayoutObject}->Ascii2Html(
            Text => $ValueItem,
        );

        $FieldTemplateData{ValueEscaped} = $ValueEscaped;

        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                %Error,
            },
        );
    }

    my $TemplateHTML;
    if ( $FieldConfig->{MultiValue} && !$Param{Readonly} ) {

        $FieldTemplateData{FieldID} = $FieldTemplateData{FieldName} . '_Template';

        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
            },
        );
    }

    # write rendered value to FormCache for later usage in EditFieldValueValidate
    if ( $Value && !$Param{ServerError} ) {
        $Kernel::OM->Get('Kernel::System::Web::FormCache')->SetFormData(
            LayoutObject => $Param{LayoutObject},
            Key          => 'RenderedValue_DynamicField_' . $Param{DynamicFieldConfig}{Name},
            Value        => $Value,
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

    # decide which structure to return
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
            my @Data;

            for my $Item (@DataAll) {

                push @Data, $Item;
            }
            $Value = \@Data;

        }
        else {
            $Value = $Param{ParamObject}->GetParam( Param => $FieldName );
        }
    }

    if ( !$Param{DynamicFieldConfig}->{Config}->{MultiValue} && ref $Value eq 'ARRAY' ) {
        $Value = $Value->[0] || '';
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

    my $DynamicFieldConfig = $Param{DynamicFieldConfig};

    if ( !$Param{Mandatory} && !IsArrayRefWithData( $DynamicFieldConfig->{Config}{RegExList} ) ) {
        return {
            ServerError  => undef,
            ErrorMessage => undef
        };
    }

    # get the field value from the http request
    my $EditFieldValue = $Self->EditFieldValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ParamObject        => $Param{ParamObject},

        # not necessary for this Driver but place it for consistency reasons
        ReturnValueStructure => 1,
    );

    # NOTE following block does not work with multivalue script fields
    if ($EditFieldValue) {

        my $DFName = $DynamicFieldConfig->{Name};

        if ( defined $Param{SetIndex} ) {
            $DFName .= "_$Param{SetIndex}";
        }

        # if the value would change, we need to verify that the user is really allowed
        # to access the provided referenced data via this form
        # this is the case if either the referenced data was shown via a search (1)
        # or is currently stored for the edited ticket/ci/... (2)
        my $LastEvaluationResult = $Kernel::OM->Get('Kernel::System::Web::FormCache')->GetFormData(
            LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
            Key          => 'LastValue_DynamicField_' . $DFName,
        );

        # if no LastEvaluationResult is present, use rendered value
        $LastEvaluationResult //= $Kernel::OM->Get('Kernel::System::Web::FormCache')->GetFormData(
            LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
            Key          => 'RenderedValue_DynamicField_' . $DFName,
        );

        # check if EditFieldValue matches last evaluation result
        my $Allowed = ( $LastEvaluationResult eq $EditFieldValue ) ? 1 : 0;

        if ( !$Allowed ) {
            return {
                ServerError  => 1,
                ErrorMessage => 'Value invalid.',
            };
        }
    }

    my $ServerError;
    my $ErrorMessage;

    # transform scalar values to array ref for iteration
    if ( !$DynamicFieldConfig->{Config}{MultiValue} ) {
        $EditFieldValue = [$EditFieldValue];
    }

    # perform necessary validations
    for my $Index ( 0 .. $#{$EditFieldValue} ) {

        my $CurrentValue = $EditFieldValue->[$Index];

        if ( $Param{Mandatory} && $CurrentValue eq '' ) {
            $ServerError  = 1;
            $ErrorMessage = "This field is required.";
        }

        elsif (
            IsArrayRefWithData( $DynamicFieldConfig->{Config}{RegExList} )
            && ( $Param{Mandatory} || ( !$Param{Mandatory} && $CurrentValue ne '' ) )
            )
        {

            # check regular expressions
            my @RegExList = $DynamicFieldConfig->{Config}{RegExList}->@*;

            REGEXENTRY:
            for my $RegEx (@RegExList) {

                if ( $CurrentValue !~ $RegEx->{Value} ) {
                    $ServerError  = 1;
                    $ErrorMessage = $RegEx->{ErrorMessage};

                    last REGEXENTRY;
                }
            }
        }
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

    # get raw Title and Value strings from field value
    my $Value         = '';
    my $Title         = '';
    my $ValueMaxChars = $Param{ValueMaxChars} || '';
    my $TitleMaxChars = $Param{TitleMaxChars} || '';

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

    my $ShowValueEllipsis;
    my $ShowTitleEllipsis;

    VALUEITEM:
    for my $Item (@Values) {
        $Item //= '';

        my $ReadableValue = $Item;

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
        if ( $Param{HTMLOutput} ) {

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
    my $ItemSeparator = $Param{HTMLOutput} ? '<br>' : '\n';

    $Value = join( $ItemSeparator, @ReadableValues );
    $Title = join( $ItemSeparator, @ReadableTitles );

    if ($ShowValueEllipsis) {
        $Value .= '...';
    }
    if ($ShowTitleEllipsis) {
        $Title .= '...';
    }

    # set field link form config
    my $Link        = $Param{DynamicFieldConfig}{Config}{Link}        || '';
    my $LinkPreview = $Param{DynamicFieldConfig}{Config}{LinkPreview} || '';

    # create return structure
    my $Data = {
        Value       => $Value,
        Title       => $Title,
        Link        => $Link,
        LinkPreview => $LinkPreview,
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
    my $FieldClass = 'DynamicFieldText';

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

=head2 GetPossibleExecutionConditions()

returns a hash consisting of the possible requirements and trigger events

    my $List = $DynamicFieldBackendObject->GetPossibleExecutionConditions(
        ObjectType => 'Ticket',
    );

Returns (BaseScript only returns dynamic fields):

    $List = {
        RequiredArgs   => [ 'Queue', 'DynamicField_X' ],
        UpdateTriggers => [ 'TicketQueueUpdate', 'TicketDynamicFieldUpdate_X' ],
    };

=cut

sub GetPossibleExecutionConditions {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{ObjectType} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => "Unsupported Operator $Param{Operator}",
        );

        return;
    }

    my $ObjectType;
    my @Attributes;
    if ( $Param{ObjectType} eq 'Ticket' || $Param{ObjectType} eq 'Article' ) {
        $ObjectType = [qw(Ticket Article)];
        @Attributes = (
            qw/Type Queue Service/,
        );
    }
    else {
        $ObjectType = [ $Param{ObjectType} ];
    }

    # get registered event triggers from the config
    my %RegisteredEvents = $Kernel::OM->Get('Kernel::System::Event')->EventList(
        ObjectTypes => $ObjectType,
    );

    my @PossibleUpdateEvents;
    for my $Set ( values %RegisteredEvents ) {
        push @PossibleUpdateEvents, $Set->@*;
    }

    # get the dynamic fields for the object
    my $List = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        ObjectType => $ObjectType,
        ResultType => 'HASH',
    );
    delete $List->{ $Param{FieldID} } if $Param{FieldID};

    return {
        PossibleArgs => [
            ( map { 'DynamicField_' . $_ } values $List->%* ),
            @Attributes,
        ],
        PossibleAJAXTriggers => [
            ( map { 'DynamicField_' . $_ } values $List->%* ),
            @Attributes,
        ],
        PossibleUpdateEvents => \@PossibleUpdateEvents,
    };
}

=head2 SetUpdateEvents()

Sets the update events for a specific dynamic field

    my $Success = $DynamicFieldBackendObject->SetUpdateEvents(
        FieldID => $ID,
        Events  => \@Events,
    );

=cut

sub SetUpdateEvents {
    my ( $Self, %Param ) = @_;

    # check needed
    if ( !$Param{FieldID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => 'Need FieldID!',
        );

        return;
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => 'DynamicField',
        Key  => 'ScriptEvents',
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL  => 'DELETE FROM dynamic_field_script_event WHERE field_id = ?',
        Bind => [ \$Param{FieldID} ],
    );

    return 1 if !$Param{Events};

    return if !$DBObject->Do(
        SQL  => 'INSERT INTO dynamic_field_script_event( field_id, event ) VALUES ' . join( ', ', map {'( ?, ? )'} $Param{Events}->@* ),
        Bind => [ map { \$Param{FieldID} => \$_ } $Param{Events}->@* ],    # use '=>' in map action, because Perl::Critic was confused
    );

    return 1;
}

=head2 GetUpdateEvents()

Get the events which trigger script field updates and the respective fields

    my $Events = $DynamicFieldBackendObject->GetUpdateEvents();

Returns:
    $Events = {
        NotificationNewTicket             => [ 4, 17, 21 ],
        TicketDynamicFieldUpdate_JustDoIt => [ 17, 18 ],
    };

=cut

sub GetUpdateEvents {
    my ( $Self, %Param ) = @_;

    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => 'DynamicField',
        Key  => 'ScriptEvents',
    );

    return $Cache if $Cache;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT event, field_id from dynamic_field_script_event',
    );

    my %Events;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push $Events{ $Row[0] }->@*, $Row[1];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => 'DynamicField',
        Key   => 'ScriptEvents',
        Value => \%Events,
        TTL   => 60 * 60 * 24 * 90,
    );

    return \%Events;
}

sub Evaluate {
    my ( $Self, %Param ) = @_;

    return "No evaluation implemented for this field type.";
}

sub GetFieldState {
    my ( $Self, %Param ) = @_;

    my %GetParam           = $Param{GetParam}->%*;
    my $DynamicFieldConfig = $Param{DynamicFieldConfig};

    # for ticket dynamic fields we need the queue
    $GetParam{Queue} = defined $Param{GetParam}{Queue}
        ? $Param{GetParam}{Queue}
        : $Param{GetParam}{Dest} && $Param{GetParam}{Dest} =~ /\|\|(.+)$/ ? $1
        :                                                                   undef;

    # the required args have to be present
    for my $Required ( @{ $DynamicFieldConfig->{Config}{RequiredArgs} // [] } ) {
        my $Value = $GetParam{DynamicField}{$Required} // $GetParam{$Required};

        return () if !$Value || ( ref $Value && !IsArrayRefWithData($Value) );
    }

    my %ChangedElements = map { $Self->{Uniformity}{$_} // $_ => 1 } keys $Param{ChangedElements}->%*;
    delete $ChangedElements{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

    # skip if it's only a rerun due to self change
    return () if !%ChangedElements && !$Param{InitialRun};

    # if specific AJAX triggers are defined only update on changes to them...
    if ( IsArrayRefWithData( $DynamicFieldConfig->{Config}{AJAXTriggers} ) ) {
        return () if none { $ChangedElements{$_} } $DynamicFieldConfig->{Config}{AJAXTriggers}->@*;
    }

    # ...if not, only check in the first run
    elsif ( !$Param{InitialRun} ) {
        return ();
    }

    return () if IsArrayRefWithData( $DynamicFieldConfig->{Config}{AJAXTriggers} )
        && !$Param{InitialRun}
        && none { $ChangedElements{ $Self->{Uniformity}{$_} // $_ } } $DynamicFieldConfig->{Config}{AJAXTriggers}->@*;

    my $NewValue = $Self->Evaluate(
        DynamicFieldConfig => $DynamicFieldConfig,
        Object             => {

            # ticket specifics
            CustomerUserID => $Param{CustomerUser},
            TicketID       => $Param{TicketID},

            # ITSM config item specifics
            ConfigItemID => $Param{ConfigItemID},

            # general
            %GetParam,
        },
    );

    # do nothing if nothing changed
    return () if !$Self->ValueIsDifferent(
        DynamicFieldConfig => $DynamicFieldConfig,
        Value1             => $GetParam{DynamicField}{"DynamicField_$DynamicFieldConfig->{Name}"},
        Value2             => $NewValue,
    );

    my $DFName = $DynamicFieldConfig->{Name};
    if ( defined $Param{SetIndex} ) {
        $DFName .= "_$Param{SetIndex}";
    }

    # store all possible values for this field and form id for later verification
    $Kernel::OM->Get('Kernel::System::Web::FormCache')->SetFormData(
        LayoutObject => $Kernel::OM->Get('Kernel::Output::HTML::Layout'),
        FormID       => $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' ),
        Key          => 'LastValue_DynamicField_' . $DFName,
        Value        => $NewValue,
    );

    return (
        NewValue => $NewValue,
    );
}

1;
