# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::DynamicField::Driver::BaseEntity;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseSelect);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::BaseEntity - base module for Entity dynamic fields

=head1 DESCRIPTION

Entity common functions. Entities are a loose group of dynamic fields where the content is
not arbitrary. Like picking a customer from the customer list. The value can be either a
copy of an item from a resource or a reference to an item.

=head1 PUBLIC INTERFACE

Modules that are derived from this base module implement the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=cut

sub ValueGet {
    my ( $Self, %Param ) = @_;

    my $ValueKey = $Self->{ValueKey} // 'ValueText';

    # get raw values of the dynamic field
    my $DFValue = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueGet(
        FieldID  => $Param{DynamicFieldConfig}{ID},
        ObjectID => $Param{ObjectID},
    );

    if ( $Param{DynamicFieldConfig}{Config}{Multiselect} ) {

        return unless $DFValue;
        return unless IsArrayRefWithData($DFValue);
        return unless IsHashRefWithData( $DFValue->[0] );

        return [ map { $_->{$ValueKey} } $DFValue->@* ];
    }

    return $Self->ValueStructureFromDB(
        ValueDB    => $DFValue,
        ValueKey   => $ValueKey,
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}{Config}{MultiValue},
        BaseArray  => !$Param{DynamicFieldConfig}{Config}{MultiValue},
    );
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Value} ) {
        return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueDelete(
            FieldID  => $Param{DynamicFieldConfig}->{ID},
            ObjectID => $Param{ObjectID},
            UserID   => $Param{UserID},
        );
    }
    elsif ( !ref $Param{Value} ) {
        $Param{Value} = [ $Param{Value} ];
    }
    elsif ( !$Param{Value}->@* ) {
        return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueDelete(
            FieldID  => $Param{DynamicFieldConfig}->{ID},
            ObjectID => $Param{ObjectID},
            UserID   => $Param{UserID},
        );
    }

    my $ValueKey = $Self->{ValueKey} // 'ValueText';

    # perform search if neccessary
    if ( $Param{ExternalSource} && $Param{DynamicFieldConfig}{Config}{ImportSearchAttribute} && $Self->can('SearchObjects') ) {

        my @Values;
        for my $ValueItem ( $Param{Value} ) {

            # perform search based on value and previously fetched data
            my @ObjectIDs = $Self->SearchObjects(
                DynamicFieldConfig => $Param{DynamicFieldConfig},
                Term               => $ValueItem,
                ExternalSource     => 1,
                UserID             => $Param{UserID},
            );

            if ( !@ObjectIDs ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "No objects found for $Param{DynamicFieldConfig}{Name}, search term $ValueItem.",
                );
                return;
            }
            elsif ( @ObjectIDs > 1 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "Ambiguous result found for $Param{DynamicFieldConfig}{Name}, search term $ValueItem.",
                );
                return;
            }
            else {
                push @Values, $ObjectIDs[0];
            }
        }
        $Param{Value} = @Values ? \@Values : $Param{Value};
    }

    # for multiselect no set or multivalue structures
    if ( $Param{DynamicFieldConfig}{Config}{Multiselect} ) {
        my $DBValue = [
            map {
                { $ValueKey => $_ }
            } $Param{Value}->@*
        ];

        return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
            FieldID  => $Param{DynamicFieldConfig}->{ID},
            ObjectID => $Param{ObjectID},
            Value    => $DBValue,
            UserID   => $Param{UserID},
        );
    }

    # in MultiValue and Set case, the value is needed as array ref for creating the value structure correctly
    my $Value = $Param{DynamicFieldConfig}{Config}{MultiValue}
        ? $Param{Value}
        : $Param{Set} ? [ map { $_->[0] } $Param{Value}->@* ]
        :               $Param{Value}->[0];

    my $DBValue = $Self->ValueStructureToDB(
        Value      => $Value,
        ValueKey   => $ValueKey,
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

    my $ValueKey = $Self->{ValueKey} // 'ValueText';

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
                $ValueKey => $Value,
            },
            UserID => $Param{UserID},
        );

        return unless $Success;
    }

    return $Success;
}

sub FieldValueValidate {
    my ( $Self, %Param ) = @_;

    # Check for valid possible values list.
    my $PossibleValues = $Self->PossibleValuesGet(%Param);
    if ( !IsHashRefWithData($PossibleValues) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Possible values are empty!",
        );

        return;
    }

    # Check for defined value.
    if ( !defined $Param{Value} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Value in $Param{DynamicFieldConfig}->{FieldType} DynamicField!",
        );

        return;
    }

    # Check if value parameter exists in possible values config.
    if ( length $Param{Value} ) {
        my @Values;
        if ( ref $Param{Value} eq 'ARRAY' ) {
            @Values = @{ $Param{Value} };
        }
        else {
            push @Values, $Param{Value};
        }

        for my $Value (@Values) {
            return unless defined $PossibleValues->{$Value};
        }
    }

    return 1;
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    my $Value = $Param{Value} // '';

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
    my $FieldClass = ( $FieldConfig->{Multiselect} ? 'DynamicFieldText' : 'DynamicFieldDropdown' ) . " Modernize";
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

    # set PossibleValues, use PossibleValuesFilter if defined
    my $PossibleValues = $Param{PossibleValuesFilter} // $Self->PossibleValuesGet(%Param);

    my %FieldTemplateData;

    my @SelectionHTML;
    if ( $FieldConfig->{MultiValue} ) {
        for my $ValueIndex ( 0 .. $#{$Value} ) {
            my $FieldID = $FieldName . '_' . $ValueIndex;
            push @SelectionHTML, $Param{LayoutObject}->BuildSelection(
                Data        => $PossibleValues || {},
                Disabled    => $Param{Readonly},
                Name        => $FieldName,
                ID          => $FieldID,
                SelectedID  => $Value->[$ValueIndex],
                Class       => $FieldClass,
                HTMLQuote   => 1,
                Translation => $FieldConfig->{TranslatableValues},
            );
        }
    }
    else {
        my @SelectedIDs = grep {$_} $Value->@*;
        push @SelectionHTML, $Param{LayoutObject}->BuildSelection(
            Data        => $PossibleValues || {},
            Disabled    => $Param{Readonly},
            Name        => $FieldName,
            SelectedID  => \@SelectedIDs,
            Class       => $FieldClass,
            HTMLQuote   => 1,
            Multiple    => $FieldConfig->{Multiselect},
            Translation => $FieldConfig->{TranslatableValues},
        );
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
        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                %Error,
                SelectionHTML => $SelectionHTML[$ValueIndex],
            },
        );
    }

    my $TemplateHTML;
    if ( $FieldConfig->{MultiValue} && !$Param{Readonly} ) {
        $FieldTemplateData{FieldID} = $FieldName . '_Template';

        my $SelectionHTML = $Param{LayoutObject}->BuildSelection(
            Data        => $PossibleValues || {},
            Disabled    => $Param{Readonly},
            Name        => $FieldName,
            ID          => $FieldTemplateData{FieldID},
            Translation => $FieldConfig->{TranslatableValues} || 0,
            Class       => $FieldClass,
            HTMLQuote   => 1,
            Translation => $FieldConfig->{TranslatableValues},
        );

        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                SelectionHTML => $SelectionHTML,
            },
        );
    }

    # call EditLabelRender on the common Driver
    # only a single label is returned, even for MultiValue fields
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
        my @Data = $Param{ParamObject}->GetArray( Param => $FieldName );

        if ( $Param{DynamicFieldConfig}->{Config}{MultiValue} ) {

            # delete the template value
            pop @Data;
        }
        else {

            # delete empty values
            @Data = grep {$_} @Data;
        }

        $Value = \@Data;
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

    # ref comparison because EditFieldValuetet returns an arrayref except when using template value
    if ( !ref $Value eq 'ARRAY' ) {
        $Value = [$Value];
    }

    # value constellation [undef] is caught by mandatory check in for loop below
    if ( $Param{Mandatory} && !$Value->@* ) {
        return {
            ServerError => 1,
        };
    }

    # get possible values list
    my $PossibleValues = $Self->PossibleValuesGet(%Param);

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

    # this field type does not support the Link Feature
    my $Link;

    # return a data structure
    return {
        Value => '' . join( $ValueSeparator, @ReadableValues ),
        Title => '' . $Title,
        Link  => $Link,
    };
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # get possible values
    my $PossibleValues = $Self->PossibleValuesGet(%Param);

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
                my $DisplayItem = $PossibleValues->{$Item}
                    || $Item;

                push @DisplayItemList, $DisplayItem;
            }

            # combine different values into one string
            $DisplayValue = join ' + ', @DisplayItemList;
        }
        else {

            # set the display value
            $DisplayValue = $PossibleValues->{$Value};
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

    # Set PossibleValues from config is not possible as they could depend on request params.
    my $Values = {};

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
        Values  => $Values,
        Name    => $Param{DynamicFieldConfig}->{Label},
        Element => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        Block   => 'MultiSelectField',
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

    for my $Item (@Values) {
        $Item //= '';

        push @ReadableValues, $Item || '';
    }

    # set new line separator
    my $ItemSeparator = ', ';

    # Output transformations
    $Value = join( $ItemSeparator, @ReadableValues );
    $Title = $Value;

    # prepare title
    $Title = $Value;

    if ( $Param{TitleMaxChars} && length $Title > $Param{TitleMaxChars} ) {
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
    my $EditValueType   = 'ARRAY';
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

sub ObjectMatch {
    my ( $Self, %Param ) = @_;

    my $FieldName = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # the attribute must be an array
    return 0 if !IsArrayRefWithData( $Param{ObjectAttributes}->{$FieldName} );

    my $Match;

    # search in all values for this attribute
    VALUE:
    for my $AttributeValue ( @{ $Param{ObjectAttributes}->{$FieldName} } ) {

        next VALUE if !defined $AttributeValue;

        # only need to match one
        if ( $Param{Value} eq $AttributeValue ) {
            $Match = 1;
            last VALUE;
        }
    }

    return $Match;
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    my @Keys;
    if ( ref $Param{Key} eq 'ARRAY' ) {
        @Keys = @{ $Param{Key} };
    }
    else {
        @Keys = ( $Param{Key} );
    }

    # get real values
    my $PossibleValues = $Self->PossibleValuesGet(%Param);

    # to store final values
    my @Values;

    KEYITEM:
    for my $Item (@Keys) {
        next KEYITEM if !$Item;

        # set the value as the key by default
        my $Value = $Item;

        # try to convert key to real value
        if ( $PossibleValues->{$Item} ) {
            $Value = $PossibleValues->{$Item};

        }
        push @Values, $Value;
    }

    return \@Values;
}

sub ColumnFilterValuesGet {
    my ( $Self, %Param ) = @_;

    # Extract the information about the dynamic field,
    # so that sensible variable names can be used.
    my $DynamicField = $Param{DynamicFieldConfig};
    my $FieldConfig  = $DynamicField->{Config};

    # article uses the same routine as ticket
    my $ObjectType = $DynamicField->{ObjectType} eq 'Article' ? 'Ticket' : $DynamicField->{ObjectType};

    # get column filter values from database
    my $ColumnFilterValues = $Kernel::OM->Get("Kernel::System::${ObjectType}::ColumnFilter")->DynamicFieldFilterValuesGet(
        %Param,
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => $Self->{ValueType},
    );

    # get the display value if still exist in dynamic field configuration
    for my $Key ( sort keys %{$ColumnFilterValues} ) {

        my $DisplayValue = $Self->DisplayValueRender(
            LayoutObject => $Param{LayoutObject},
            Value        => $Key,
        );

        if ( IsHashRefWithData($DisplayValue) ) {
            $ColumnFilterValues->{$Key} = $DisplayValue->{Value};
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
