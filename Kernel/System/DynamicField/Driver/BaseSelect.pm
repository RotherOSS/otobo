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

package Kernel::System::DynamicField::Driver::BaseSelect;

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
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Ticket::ColumnFilter',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::BaseSelect - base module for DropDown and MultiSelects dynamic fields

=head1 DESCRIPTION

Select common functions.

=head1 PUBLIC INTERFACE

Modules that are derived from this base module implement the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=cut

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

    # check for valid possible values list
    if ( !$Param{DynamicFieldConfig}->{Config}->{PossibleValues} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need PossibleValues in DynamicFieldConfig!",
        );
        return;
    }

    my $DBValue = $Self->ValueStructureToDB(
        Value      => $Param{Value},
        ValueKey   => 'ValueText',
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
    return $Self->SUPER::ValueIsDifferent(%Param);
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

    my $Success;
    for my $Value (@Values) {

        $Success = $DynamicFieldValueObject->ValueValidate(
            Value => {
                ValueText => $Value,
            },
            UserID => $Param{UserID},
        );
        return if !$Success;
    }

    return $Success;
}

sub SearchSQLGet {
    my ( $Self, %Param ) = @_;

    my $TableAttribute = $Self->{TableAttribute} // 'value_text';

    if ( $Param{Operator} eq 'Like' ) {
        return $Kernel::OM->Get('Kernel::System::DB')->QueryCondition(
            Key   => "$Param{TableAlias}.$TableAttribute",
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
            return " $Param{TableAlias}.$TableAttribute IS NULL OR $Param{TableAlias}.$TableAttribute = '' ";
        }
        else {
            my $DatabaseType = $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'};
            if ( $DatabaseType eq 'oracle' ) {
                return " $Param{TableAlias}.$TableAttribute IS NOT NULL ";
            }
            else {
                return " $Param{TableAlias}.$TableAttribute <> '' ";
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

    # TODO: this should be changed to bind variables
    if ( $TableAttribute eq 'value_int' ) {
        my $SQL = " $Param{TableAlias}.$TableAttribute $Operators{ $Param{Operator} } $Param{SearchTerm}";

        return $SQL;
    }
    else {
        my $SQL = " $Param{TableAlias}.$TableAttribute $Operators{ $Param{Operator} } '";
        $SQL .= $Kernel::OM->Get('Kernel::System::DB')->Quote( $Param{SearchTerm} ) . "' ";

        return $SQL;
    }
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    my $TableAttribute = $Self->{TableAttribute} // 'value_text';

    return "$Param{TableAlias}.$TableAttribute";
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value;

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = $FieldConfig->{DefaultValue} // '';
    }
    $Value = $Param{Value} // $Value;

    # check if a value in a template (GenericAgent etc.)
    # is configured for this dynamic field
    if (
        IsHashRefWithData( $Param{Template} )
        && defined $Param{Template}->{$FieldName}
        )
    {
        $Value = $Param{Template}->{$FieldName};
    }

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
    my $FieldClass = 'DynamicFieldText Modernize';
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

    # set ajaxupdate class
    if ( $Param{AJAXUpdate} ) {
        $FieldClass .= ' FormUpdate';
    }

    # set error css class
    if ( $Param{ServerError} ) {
        $FieldClass .= ' ServerError';
    }

    # set TreeView class
    if ( $FieldConfig->{TreeView} ) {
        $FieldClass .= ' DynamicFieldWithTreeView';
    }

    # set PossibleValues, use PossibleValuesFilter if defined
    my $PossibleValues = $Param{PossibleValuesFilter} // $Self->PossibleValuesGet(%Param);

    my $Size = 1;

    # TODO change ConfirmationNeeded parameter name to something more generic

    # when ConfimationNeeded parameter is present (AdminGenericAgent) the filed should be displayed
    # as an open list, because you might not want to change the value, otherwise a value will be
    # selected
    if ( $Param{ConfirmationNeeded} ) {
        $Size = 5;
    }

    my %FieldTemplateData = (
        'MultiValue' => $FieldConfig->{MultiValue},
    );

    if ( $FieldConfig->{TreeView} ) {
        $FieldTemplateData{TreeView}             = $FieldConfig->{TreeView};
        $FieldTemplateData{TreeSelectionMessage} = Translatable("Show Tree Selection");
    }

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/BaseSelect'
        :
        'DynamicField/Agent/BaseSelect';

    my %Error = (
        ServerError => $Param{ServerError},
        Mandatory   => $Param{Mandatory},
    );
    my @ResultHTML;
    for my $ValueIndex ( 0 .. $#{$Value} ) {
        my $FieldID = $FieldConfig->{MultiValue} ? $FieldName . '_' . $ValueIndex : $FieldName;

        if ( !$ValueIndex ) {
            if ( $Error{ServerError} ) {
                $Error{DivIDServerError} = $FieldID . 'ServerError';
                $Error{ErrorMessage}     = Translatable( $Param{ErrorMessage} || 'This field is required.' );
            }
            if ( $Error{Mandatory} ) {
                $Error{DivIDMandatory}       = $FieldID . 'Error';
                $Error{FieldRequiredMessage} = Translatable('This field is required.');
            }
        }

        # TODO: is this necessary?
        my $DataValues = $Self->BuildSelectionDataGet(
            DynamicFieldConfig => $Param{DynamicFieldConfig},
            PossibleValues     => $PossibleValues,
            Value              => $Value->[$ValueIndex],
        );

        my $SelectionHTML = $Param{LayoutObject}->BuildSelection(
            Data        => $DataValues || {},
            Sort        => 'AlphanumericKey',
            Disabled    => $Param{Readonly},
            Name        => $FieldName,
            ID          => $FieldID,
            SelectedID  => $Value->[$ValueIndex],
            Translation => $FieldConfig->{TranslatableValues} || 0,
            Class       => $FieldClass,
            Size        => $Size,
            HTMLQuote   => 1,
        );

        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                %Error,
                SelectionHTML => $SelectionHTML,
            },
        );
    }

    my $TemplateHTML;
    if ( $FieldConfig->{MultiValue} && !$Param{Readonly} ) {
        my $FieldID = $FieldName . '_Template';

        # TODO: is this necessary?
        my $DataValues = $Self->BuildSelectionDataGet(
            DynamicFieldConfig => $Param{DynamicFieldConfig},
            PossibleValues     => $PossibleValues,
        );

        my $SelectionHTML = $Param{LayoutObject}->BuildSelection(
            Data        => $DataValues || {},
            Sort        => 'AlphanumericKey',
            Name        => $FieldName,
            ID          => $FieldID,
            Translation => $FieldConfig->{TranslatableValues} || 0,
            Class       => $FieldClass,
            Size        => $Size,
            HTMLQuote   => 1,
        );

        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                SelectionHTML => $SelectionHTML,
            },
        );
    }

    if ( $Param{AJAXUpdate} ) {

        # add js to bind TreeSelection event
        $Param{LayoutObject}->AddJSOnDocumentComplete( Code => <<"EOF");
Core.App.Subscribe('Event.AJAX.FormUpdate.Callback', function(Data) {
    var FieldName = '$FieldName';
    if (Data[FieldName] && \$('#' + FieldName).hasClass('DynamicFieldWithTreeView')) {
        Core.UI.TreeSelection.RestoreDynamicFieldTreeView(\$('#' + FieldName), Data[FieldName], '' , 1);
    }
});
EOF
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

            # delete the template value
            pop @DataAll;

            for my $Item (@DataAll) {
                push @Data, $Item // '';
            }
            $Value = \@Data;
        }
        else {
            $Value = $Param{ParamObject}->GetParam( Param => $FieldName );
        }
    }

    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq 1 ) {
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

    # TODO: check whether EditFieldValueGet returns ('first','second','','','fifth','') in case of added but unfilled multivalue fields

    # get possible values list
    my $PossibleValues = $Param{PossibleValuesFilter} // $Param{DynamicFieldConfig}->{Config}->{PossibleValues};

    for my $ValueItem ( @{$Value} ) {

        # perform necessary validations
        if ( $Param{Mandatory} && !$ValueItem ) {
            return {
                ServerError => 1,
            };
        }
        else {
            # validate if value is in possible values list (but let pass empty values)
            if ( $ValueItem && !$PossibleValues->{$ValueItem} ) {
                $ServerError  = 1;
                $ErrorMessage = 'The field content is invalid';
            }
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

    # activate HTMLOutput when it wasn't specified
    my $HTMLOutput = $Param{HTMLOutput} // 1;

    # get raw Value strings from field value
    my @Values = !ref $Param{Value}
        ? ( $Param{Value} )
        : scalar $Param{Value}->@* ? $Param{Value}->@*
        :                            ('');

    $Param{ValueMaxChars} ||= '';

    my @ReadableValues;
    my @ReadableTitles;
    for my $ValueItem (@Values) {
        $ValueItem //= '';

        # get real value
        if ( $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$ValueItem} ) {

            # get readable value
            $ValueItem = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$ValueItem};
        }

        # check is needed to translate values
        if ( $Param{DynamicFieldConfig}->{Config}->{TranslatableValues} ) {

            # translate value
            $ValueItem = $Param{LayoutObject}->{LanguageObject}->Translate($ValueItem);
        }

        # set title as value after update and before limit
        push @ReadableTitles, $ValueItem;

        # HTML Output transformation
        if ($HTMLOutput) {
            $ValueItem = $Param{LayoutObject}->Ascii2Html(
                Text => $ValueItem,
                Max  => $Param{ValueMaxChars},
            );
        }
        else {
            if ( $Param{ValueMaxChars} && length($ValueItem) > $Param{ValueMaxChars} ) {
                $ValueItem = substr( $ValueItem, 0, $Param{ValueMaxChars} ) . '...';
            }
        }

        push @ReadableValues, $ValueItem;
    }

    my $ValueSeparator;
    my $Title = join( ', ', @ReadableTitles );

    # HTMLOutput transformations
    if ($HTMLOutput) {
        $Title = $Param{LayoutObject}->Ascii2Html(
            Text => $Title,
            Max  => $Param{TitleMaxChars} || '',
        );
        $ValueSeparator = '<br/>';
    }
    else {
        if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
            $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
        }
        $ValueSeparator = "\n";
    }

    # set field link from config
    my $Link        = $Param{DynamicFieldConfig}->{Config}->{Link}        || '';
    my $LinkPreview = $Param{DynamicFieldConfig}->{Config}->{LinkPreview} || '';

    # return a data structure
    return {
        Value       => '' . join( $ValueSeparator, @ReadableValues ),
        Title       => '' . $Title,
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
    my $FieldClass = 'DynamicFieldMultiSelect Modernize';

    # set TreeView class
    if ( $FieldConfig->{TreeView} ) {
        $FieldClass .= ' DynamicFieldWithTreeView';
    }

    # set PossibleValues
    my $SelectionData = $FieldConfig->{PossibleValues};

    # get historical values from database
    my $HistoricalValues = $Self->HistoricalValuesGet(%Param);

    # add historic values to current values (if they don't exist anymore)
    if ( IsHashRefWithData($HistoricalValues) ) {
        for my $Key ( sort keys %{$HistoricalValues} ) {
            if ( !$SelectionData->{$Key} ) {
                $SelectionData->{$Key} = $HistoricalValues->{$Key};
            }
        }
    }

    # use PossibleValuesFilter if defined
    $SelectionData = $Param{PossibleValuesFilter} // $SelectionData;

    # check if $SelectionData differs from configured PossibleValues
    # and show values which are not contained as disabled if TreeView => 1
    if ( $FieldConfig->{TreeView} ) {

        if ( keys %{ $FieldConfig->{PossibleValues} } != keys %{$SelectionData} ) {

            my @Values;
            for my $Key ( sort keys %{ $FieldConfig->{PossibleValues} } ) {

                push @Values, {
                    Key      => $Key,
                    Value    => $FieldConfig->{PossibleValues}->{$Key},
                    Disabled => ( defined $SelectionData->{$Key} ) ? 0 : 1,
                };
            }
            $SelectionData = \@Values;
        }
    }

    my $HTMLString = $Param{LayoutObject}->BuildSelection(
        Data         => $SelectionData,
        Sort         => 'AlphanumericKey',
        Name         => $FieldName,
        SelectedID   => $Value,
        Translation  => $FieldConfig->{TranslatableValues} || 0,
        PossibleNone => 0,
        Class        => $FieldClass,
        Multiple     => 1,
        HTMLQuote    => 1,
    );

    if ( $FieldConfig->{TreeView} ) {
        my $TreeSelectionMessage = $Param{LayoutObject}->{LanguageObject}->Translate("Show Tree Selection");
        $HTMLString
            .= ' <a href="#" title="'
            . $TreeSelectionMessage
            . '" class="ShowTreeSelection"><span>'
            . $TreeSelectionMessage . '</span><i class="fa fa-sitemap"></i></a>';
    }

    # call EditLabelRender on the common Driver
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
                my $DisplayItem = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Item}
                    || $Item;

                # translate the value
                if (
                    $Param{DynamicFieldConfig}->{Config}->{TranslatableValues}
                    && defined $Param{LayoutObject}
                    )
                {
                    $DisplayItem = $Param{LayoutObject}->{LanguageObject}->Translate($DisplayItem);
                }

                push @DisplayItemList, $DisplayItem;
            }

            # combine different values into one string
            $DisplayValue = join ' + ', @DisplayItemList;
        }
        else {

            # set the display value
            $DisplayValue = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value};

            # translate the value
            if (
                $Param{DynamicFieldConfig}->{Config}->{TranslatableValues}
                && defined $Param{LayoutObject}
                )
            {
                $DisplayValue = $Param{LayoutObject}->{LanguageObject}->Translate($DisplayValue);
            }
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

    # set PossibleValues
    my $Values = $Param{DynamicFieldConfig}->{Config}->{PossibleValues};

    # get historical values from database
    my $HistoricalValues = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text,',
    );

    # add historic values to current values (if they don't exist anymore)
    for my $Key ( sort keys %{$HistoricalValues} ) {
        if ( !$Values->{$Key} ) {
            $Values->{$Key} = $HistoricalValues->{$Key};
        }
    }

    # use PossibleValuesFilter if defined
    $Values = $Param{PossibleValuesFilter} // $Values;

    return {
        Values             => $Values,
        Name               => $Param{DynamicFieldConfig}->{Label},
        Element            => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        TranslatableValues => $Param{DynamicFieldConfig}->{Config}->{TranslatableValues},
        Block              => 'MultiSelectField',
    };
}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Operator = 'Equals';
    my $Value    = $Param{Value};

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

    # set item separator
    my $ItemSeparator = ', ';

    # Output transformations
    $Value = join( $ItemSeparator, @Values );

    # set title as value after update and before limit
    my $Title = $Value;

    # cut strings if needed
    if ( $Param{ValueMaxChars} && length($Value) > $Param{ValueMaxChars} ) {
        $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '...';
    }
    if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
        $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
    }

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
        ValueType => ( $Self->{ValueType} // 'Text' ),
    );
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    my $Value = $Param{Key} // '';

    # get real values
    my $PossibleValues = $Param{DynamicFieldConfig}->{Config}->{PossibleValues};

    if ($Value) {

        # check if there is a real value for this key (otherwise keep the key)
        if ( $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value} ) {

            # get readable value
            $Value = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value};

            # check if translation is possible
            if (
                defined $Param{LanguageObject}
                && $Param{DynamicFieldConfig}->{Config}->{TranslatableValues}
                )
            {

                # translate value
                $Value = $Param{LanguageObject}->Translate($Value);
            }
        }
    }

    return $Value;
}

sub BuildSelectionDataGet {
    my ( $Self, %Param ) = @_;

    my $FieldConfig            = $Param{DynamicFieldConfig}->{Config};
    my $FilteredPossibleValues = $Param{PossibleValues};

    # get the possible values again as it might or might not contain the possible none and it could
    # also be overwritten
    my $ConfigPossibleValues = $Self->PossibleValuesGet(%Param);

    # check if $PossibleValues differs from configured PossibleValues
    # and show values which are not contained as disabled if TreeView => 1
    if ( $FieldConfig->{TreeView} ) {

        if ( keys %{$ConfigPossibleValues} != keys %{$FilteredPossibleValues} ) {

            # define variables to use later in the for loop
            my @Values;
            my $Parents;
            my %DisabledElements;
            my %ProcessedElements;
            my $PosibleNoneSet;

            # loop on all filtered possible values
            for my $Key ( sort keys %{$FilteredPossibleValues} ) {

                # special case for possible none
                if ( !$Key && !$PosibleNoneSet && $FieldConfig->{PossibleNone} ) {

                    # add possible none
                    push @Values, {
                        Key      => $Key,
                        Value    => $ConfigPossibleValues->{$Key} || '-',
                        Selected => defined $Param{Value}         || !$Param{Value} ? 1 : 0,
                    };
                }

                # try to split its parents GrandParent::Parent::Son
                my @Elements = split /::/, $Key;

                # reset parents
                $Parents = '';

                # get each element in the hierarchy
                ELEMENT:
                for my $Element (@Elements) {

                    # add its own parents for the complete name
                    my $ElementLongName = $Parents . $Element;

                    # set new parent (before skip already processed)
                    $Parents .= $Element . '::';

                    # skip if already processed
                    next ELEMENT if $ProcessedElements{$ElementLongName};

                    my $Disabled;

                    # check if element exists in the original data or if it is already marked
                    if (
                        !defined $FilteredPossibleValues->{$ElementLongName}
                        && !$DisabledElements{$ElementLongName}
                        )
                    {

                        # mark element as disabled
                        $DisabledElements{$ElementLongName} = 1;

                        # also set the disabled flag for current element to add
                        $Disabled = 1;
                    }

                    # set element as already processed
                    $ProcessedElements{$ElementLongName} = 1;

                    # check if the current element is the selected one
                    my $Selected;
                    if (
                        defined $Param{Value}
                        && $Param{Value}
                        && $ElementLongName eq $Param{Value}
                        )
                    {
                        $Selected = 1;
                    }

                    # add element to the new list of possible values (now including missing parents)
                    push @Values, {
                        Key      => $ElementLongName,
                        Value    => $ConfigPossibleValues->{$ElementLongName} || $ElementLongName,
                        Disabled => $Disabled,
                        Selected => $Selected,
                    };
                }
            }
            $FilteredPossibleValues = \@Values;
        }
    }

    return $FilteredPossibleValues;
}

sub PossibleValuesGet {
    my ( $Self, %Param ) = @_;

    # to store the possible values
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
    #   NOTE  this is done here instead of passing it to $LayoutObject->BuildSelection() in $Self->EditFieldRender() on purpose.
    #         The reason is that some ACL mechanisms only work when the empty value is present in the PossibleValues data,
    #         e.g. removing it via ACL.
    if ($FieldPossibleNone) {
        %PossibleValues = ( '' => '-' );
    }

    # set all other possible values if defined on field config
    if ( IsHashRefWithData( $Param{DynamicFieldConfig}->{Config}->{PossibleValues} ) ) {
        %PossibleValues = (
            %PossibleValues,
            %{ $Param{DynamicFieldConfig}->{Config}->{PossibleValues} },
        );
    }

    # return the possible values hash as a reference
    return \%PossibleValues;
}

sub ColumnFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # Extract the information about the dynamic field,
    # so that sensible variable names can be used.
    my $DynamicField = $Param{DynamicFieldConfig};
    my $FieldConfig  = $DynamicField->{Config};

    # set PossibleValues
    my $SelectionData = $FieldConfig->{PossibleValues};

    # article uses the same routine as ticket
    my $ObjectType = $DynamicField->{ObjectType} eq 'Article' ? 'Ticket' : $DynamicField->{ObjectType};

    # get column filter values from database
    my $ColumnFilterValues = $Kernel::OM->Get("Kernel::System::${ObjectType}::ColumnFilter")->DynamicFieldFilterValuesGet(
        %Param,
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'Text',
    );

    # get the display value if still exist in dynamic field configuration
    for my $Key ( sort keys %{$ColumnFilterValues} ) {
        if ( $SelectionData->{$Key} ) {
            $ColumnFilterValues->{$Key} = $SelectionData->{$Key};
        }
    }

    if ( $FieldConfig->{TranslatableValues} ) {

        # translate the value
        for my $ValueKey ( sort keys %{$ColumnFilterValues} ) {

            my $OriginalValueName = $ColumnFilterValues->{$ValueKey};
            $ColumnFilterValues->{$ValueKey} = $Param{LayoutObject}->{LanguageObject}->Translate($OriginalValueName);
        }
    }

    return $ColumnFilterValues;
}

1;
