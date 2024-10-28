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

package Kernel::System::DynamicField::Driver::BaseDateTime;

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
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::DynamicField::Driver::BaseDateTime - base module of Date and DataTime dynamic fields

=head1 DESCRIPTION

Date common functions.

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
        ValueKey   => $Self->{ValueKey},
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}->{Config}->{MultiValue},
    );
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    my $DBValue = $Self->ValueStructureToDB(
        Value      => $Param{Value},
        ValueKey   => $Self->{ValueKey},
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}->{Config}->{MultiValue},
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

    my $Prefix          = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $DateRestriction = $Param{DynamicFieldConfig}->{Config}->{DateRestriction};

    # check values
    my @Values = !ref $Param{Value}
        ? ( $Param{Value} )
        : scalar $Param{Value}->@* ? $Param{Value}->@*
        :                            (undef);

    # get necessary object
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    # init system datetime object
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTime     = $DateTimeObject->ToEpoch();

    my $Success;
    for my $Value (@Values) {
        $Success = $DynamicFieldValueObject->ValueValidate(
            Value => {
                $Self->{ValueKey} => $Value,
            },
            UserID => $Param{UserID},
        );

        if ($DateRestriction) {

            my $ValueDateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $Value,
                },
            );
            my $ValueDateTime = $ValueDateTimeObject->ToEpoch();
            $ValueDateTime = $ValueDateTime ? $ValueDateTimeObject->ToEpoch() : undef;

            if ( $DateRestriction eq 'DisableFutureDates' && $ValueDateTime > $SystemTime ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "The value for the Date field ($Param{DynamicFieldConfig}->{Name}) is in the future! The date needs to be in the past!",
                );
                return;
            }
            elsif ( $DateRestriction eq 'DisablePastDates' && $ValueDateTime < $SystemTime ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  =>
                        "The value for the Date field ($Param{DynamicFieldConfig}->{Name}) is in the past! The date needs to be in the future!",
                );
                return;
            }
        }
    }

    return $Success;
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

    if ( $Param{Operator} eq 'Empty' ) {
        if ( $Param{SearchTerm} ) {
            return " $Param{TableAlias}.value_date IS NULL ";
        }
        else {
            return " $Param{TableAlias}.value_date IS NOT NULL ";
        }
    }
    elsif ( !$Operators{ $Param{Operator} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            'Priority' => 'error',
            'Message'  => "Unsupported Operator $Param{Operator}",
        );
        return;
    }

    my $SQL = " $Param{TableAlias}.value_date $Operators{ $Param{Operator} } '";
    $SQL .= $Kernel::OM->Get('Kernel::System::DB')->Quote( $Param{SearchTerm} ) . "' ";
    return $SQL;
}

sub SearchSQLOrderFieldGet {
    my ( $Self, %Param ) = @_;

    return "$Param{TableAlias}.value_date";
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value = '';

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = $FieldConfig->{DefaultValue} // '';
    }
    $Value = $Param{Value} // $Value;

    # extract the dynamic field value from the web request
    # TransformDates is always needed from EditFieldRender Bug#8452
    my $FieldValue = $Self->EditFieldValueGet(
        TransformDates => 1,
        %Param,
    );

    # set values from ParamObject if present
    if ( $FieldConfig->{MultiValue} ) {
        if ( defined $FieldValue ) {
            $Value = $FieldValue->@*;
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

    my @ValueParts;
    for my $ValueItem ( $Value->@* ) {
        $ValueItem //= '';
        my ( $Year, $Month, $Day, $Hour, $Minute, $Second ) = $ValueItem =~
            m{ \A ( \d{4} ) - ( \d{2} ) - ( \d{2} ) \s ( \d{2} ) : ( \d{2} ) : ( \d{2} ) \z }xms;

        # If a value is sent this value must be active, then the Used part needs to be set to 1
        #   otherwise user can easily forget to mark the checkbox and this could lead into data
        #   lost (Bug#8258).
        push @ValueParts, {
            $FieldName . 'Used'   => $ValueItem ? 1 : 0,
            $FieldName . 'Year'   => $Year,
            $FieldName . 'Month'  => $Month,
            $FieldName . 'Day'    => $Day,
            $FieldName . 'Hour'   => $Hour,
            $FieldName . 'Minute' => $Minute,
        };
    }

    # check and set class if necessary
    # Bug#9358: Class 'DateSelection' is needed for CustomerInterface
    my $FieldClass = 'DynamicFieldText DateSelection';
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

    # to set the predefined based on a time difference
    my $DiffTime = $FieldConfig->{DefaultValue};
    if ( !defined $DiffTime || $DiffTime !~ m/^ \s* -? \d+ \s* $/smx ) {
        $DiffTime = 0;
    }

    # to set the years range
    my %YearsPeriodRange;
    if ( defined $FieldConfig->{YearsPeriod} && $FieldConfig->{YearsPeriod} eq '1' ) {
        %YearsPeriodRange = (
            YearPeriodPast   => $FieldConfig->{YearsInPast}   || 0,
            YearPeriodFuture => $FieldConfig->{YearsInFuture} || 0,
        );
    }

    # date restrictions
    if ( $FieldConfig->{DateRestriction} ) {
        if ( $FieldConfig->{DateRestriction} eq 'DisablePastDates' ) {
            $FieldConfig->{ValidateDateInFuture} = 1;
        }
        elsif ( $FieldConfig->{DateRestriction} eq 'DisableFutureDates' ) {
            $FieldConfig->{ValidateDateNotInFuture} = 1;
        }
    }

    my %FieldTemplateData;

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/BaseDateTime'
        :
        'DynamicField/Agent/BaseDateTime';

    my %Error = (
        ServerError => $Param{ServerError},
        Mandatory   => $Param{Mandatory},
    );
    my @ResultHTML;
    for my $ValueIndex ( 0 .. $#ValueParts ) {

        my $Suffix = $FieldConfig->{MultiValue} ? "_$ValueIndex" : '';
        $FieldTemplateData{DivID} = $FieldName . $Suffix;

        if ( !$ValueIndex ) {
            if ( $Error{ServerError} ) {
                $Error{DivIDServerError} = $FieldName . 'UsedServerError' . $Suffix;
                $Error{ErrorMessage}     = Translatable( $Param{ErrorMessage} || 'This field is required.' );
            }
            if ( $Error{Mandatory} ) {
                $Error{DivIDMandatory}       = $FieldName . 'UsedError' . $Suffix;
                $Error{FieldRequiredMessage} = Translatable('This field is required.');
            }
        }

        my $DateSelectionHTML = $Param{LayoutObject}->BuildDateSelection(
            %Param,
            $ValueParts[$ValueIndex]->%*,
            Prefix                => $FieldName,
            Suffix                => $Suffix,
            Format                => 'DateInputFormatLong',
            $FieldName . 'Class'  => $FieldClass,
            DiffTime              => $DiffTime,
            $FieldName . Required => $Param{Mandatory} || 0,
            $FieldName . Optional => 1,
            Validate              => 1,
            Disabled              => $Param{Readonly},
            $FieldConfig->%*,
            %YearsPeriodRange,
        );

        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                %Error,
                DateSelectionHTML => $DateSelectionHTML,
            },
        );
    }

    my $TemplateHTML;
    if ( $FieldConfig->{MultiValue} && !$Param{Readonly} ) {

        $FieldTemplateData{DivID}            = $FieldName . '_Template';
        $FieldTemplateData{DivIDMandatory}   = $FieldName . 'UsedError_Template';
        $FieldTemplateData{DivIDServerError} = $FieldName . 'UsedServerError_Template';

        my $DateSelectionHTML = $Param{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix                => $FieldName,
            Suffix                => '_Template',
            Format                => 'DateInputFormatLong',
            $FieldName . 'Class'  => $FieldClass,
            DiffTime              => $DiffTime,
            $FieldName . Required => $Param{Mandatory} || 0,
            $FieldName . Optional => 1,
            Validate              => 1,
            $FieldConfig->%*,
            %YearsPeriodRange,
        );

        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
                DateSelectionHTML => $DateSelectionHTML,
            },
        );
    }

    # We do not rewrite Validate_DateYear etc. to Validate_DateYear_IfVisible as one valid option is always selected

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        Mandatory => $Param{Mandatory} || '0',
        FieldName => ( $FieldConfig->{MultiValue} ? $FieldName . '_0' : $FieldName ) . 'Used',
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

    # set the Prefix as the dynamic field name
    my $Prefix = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    my $Value;

    # check if there is a Template and retrieve the dynamic field value from there
    if ( IsHashRefWithData( $Param{Template} ) && defined $Param{Template}->{ $Prefix . 'Used' } ) {
        for my $Type (qw(Used Year Month Day Hour Minute)) {
            $Value->{ $Prefix . $Type } = $Param{Template}->{ $Prefix . $Type } || 0;
        }
    }

    # otherwise get dynamic field value from the web request
    elsif (
        defined $Param{ParamObject}
        && ref $Param{ParamObject} eq 'Kernel::System::Web::Request'
        )
    {
        if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
            my %Data;

            # retrieve value parts as arrays
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                my @ValueColumn = $Param{ParamObject}->GetArray( Param => $Prefix . $Type );

                # omit template values
                if ( $Type ne 'Used' ) {
                    pop @ValueColumn;
                }
                $Data{$Type} = \@ValueColumn;
            }

            # NOTE used data in multivalue case come as value index (e.g. 1, 3, 5, ...)
            #   this is for the purpose to identify unchecked values (e.g. 2, 4, ...)
            #   so, every index arriving here means that the corresponding value was checked and is therefor set to Used => 1
            #   note that the index in the following loop is shifted by one
            my @Used;
            INDEX:
            for my $Index ( $Data{Used}->@* ) {
                next INDEX unless $Index;

                $Used[ $Index - 1 ] = 1;
            }
            $Data{Used} = \@Used;

            # transform value arrays into rows
            for my $Index ( 0 .. $#{ $Data{Year} } ) {
                my %ValueRow = ();
                for my $Type (qw(Used Year Month Day Hour Minute)) {
                    $ValueRow{ $Prefix . $Type } = $Data{$Type}[$Index] || 0;
                }
                push $Value->@*, \%ValueRow;
            }
        }
        else {
            my %ValueRow;
            for my $Type (qw(Used Year Month Day Hour Minute)) {
                $ValueRow{ $Prefix . $Type } = $Param{ParamObject}->GetParam(
                    Param => $Prefix . $Type,
                );
                if ( $Type eq 'Used' && $ValueRow{ $Prefix . $Type } ) {
                    $ValueRow{ $Prefix . $Type } = 1;
                }
                $ValueRow{ $Prefix . $Type } ||= 0;
            }
            $Value = \%ValueRow;
        }
    }

    # check for emptiness
    if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        my $IsEmpty = 1;
        for my $ValueData ( $Value->@* ) {

            # return if the field is empty (e.g. initial screen)
            if (
                $ValueData->{ $Prefix . 'Used' }
                || $ValueData->{ $Prefix . 'Year' }
                || $ValueData->{ $Prefix . 'Month' }
                || $ValueData->{ $Prefix . 'Day' }
                || $ValueData->{ $Prefix . 'Hour' }
                || $ValueData->{ $Prefix . 'Minute' }
                )
            {
                $IsEmpty = 0;
            }
        }
        return if $IsEmpty;
    }
    else {

        # return if the field is empty (e.g. initial screen)
        return if !$Value->{ $Prefix . 'Used' }
            && !$Value->{ $Prefix . 'Year' }
            && !$Value->{ $Prefix . 'Month' }
            && !$Value->{ $Prefix . 'Day' }
            && !$Value->{ $Prefix . 'Hour' }
            && !$Value->{ $Prefix . 'Minute' };
    }

    # check if need and can transform dates
    # transform the dates early for ReturnValueStructure or ManualTimeStamp Bug#8452
    if ( $Param{TransformDates} && $Param{LayoutObject} ) {

        # transform time stamp based on user time zone
        if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
            TRANSFORMDATE:
            for my $ValueData ( $Value->@* ) {
                next TRANSFORMDATE if !$ValueData->%*;
                $ValueData->%* = $Param{LayoutObject}->TransformDateSelection(
                    $ValueData->%*,
                    Prefix => $Prefix,
                );
            }
        }
        else {
            $Value->%* = $Param{LayoutObject}->TransformDateSelection(
                $Value->%*,
                Prefix => $Prefix,
            );
        }
    }

    # check if return value structure is needed
    if ( defined $Param{ReturnValueStructure} && $Param{ReturnValueStructure} eq 1 ) {
        return $Value;
    }

    # check if return template structure is needed
    if ( defined $Param{ReturnTemplateStructure} && $Param{ReturnTemplateStructure} eq 1 ) {
        return $Value;
    }

    # add seconds as 0 to the DynamicFieldValues hash
    if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        for my $ValueData ( $Value->@* ) {
            $ValueData->{ 'DynamicField_' . $Param{DynamicFieldConfig}->{Name} . 'Second' } = 0;
        }
    }
    else {
        $Value->{ 'DynamicField_' . $Param{DynamicFieldConfig}->{Name} . 'Second' } = 0;
    }

    my $ManualTimeStamp = '';
    if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        my @ManualTimeStamps;
        for my $ValueData ( $Value->@* ) {
            if ( $ValueData->{ $Prefix . 'Used' } ) {

                # add a leading zero for date parts that could be less than ten to generate a correct
                # time stamp
                for my $Type (qw(Month Day Hour Minute Second)) {
                    $ValueData->{ $Prefix . $Type } = sprintf "%02d",
                        $ValueData->{ $Prefix . $Type };
                }

                my $Year   = $ValueData->{ $Prefix . 'Year' }   || '0000';
                my $Month  = $ValueData->{ $Prefix . 'Month' }  || '00';
                my $Day    = $ValueData->{ $Prefix . 'Day' }    || '00';
                my $Hour   = $ValueData->{ $Prefix . 'Hour' }   || '00';
                my $Minute = $ValueData->{ $Prefix . 'Minute' } || '00';
                my $Second = $ValueData->{ $Prefix . 'Second' } || '00';

                push @ManualTimeStamps, $Year . '-' . $Month . '-' . $Day . ' '
                    . $Hour . ':' . $Minute . ':' . $Second;
            }
            else {
                push @ManualTimeStamps, '';
            }
        }
        $ManualTimeStamp = \@ManualTimeStamps;
    }
    else {
        if ( $Value->{ $Prefix . 'Used' } ) {

            # add a leading zero for date parts that could be less than ten to generate a correct
            # time stamp
            for my $Type (qw(Month Day Hour Minute Second)) {
                $Value->{ $Prefix . $Type } = sprintf "%02d",
                    $Value->{ $Prefix . $Type };
            }

            my $Year   = $Value->{ $Prefix . 'Year' }   || '0000';
            my $Month  = $Value->{ $Prefix . 'Month' }  || '00';
            my $Day    = $Value->{ $Prefix . 'Day' }    || '00';
            my $Hour   = $Value->{ $Prefix . 'Hour' }   || '00';
            my $Minute = $Value->{ $Prefix . 'Minute' } || '00';
            my $Second = $Value->{ $Prefix . 'Second' } || '00';

            $ManualTimeStamp = $Year . '-' . $Month . '-' . $Day . ' '
                . $Hour . ':' . $Minute . ':' . $Second;
        }
    }

    return $ManualTimeStamp;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig   => $Param{DynamicFieldConfig},
        ParamObject          => $Param{ParamObject},
        ReturnValueStructure => 1,
    );

    # on normal basis Used field could be empty but if there was no value from EditFieldValueGet()
    # it must be an error
    if ( !defined $Value ) {
        return {
            ServerError  => 1,
            ErrorMessage => 'Invalid Date!'
        };
    }

    my $ServerError;
    my $ErrorMessage;

    if ( !$Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        $Value = [$Value];
    }

    # set the date time prefix as field name
    my $Prefix = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # date restriction
    my $DateRestriction = $Param{DynamicFieldConfig}->{Config}->{DateRestriction};

    # get time object
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $SystemTime     = $DateTimeObject->ToEpoch();
    my $HasValue;
    for my $ValueItem ( $Value->@* ) {
        $HasValue ||= $ValueItem->{ $Prefix . 'Used' };
        if ( $ValueItem->{ $Prefix . 'Used' } && $DateRestriction ) {

            my $Year   = $ValueItem->{ $Prefix . 'Year' }   || '0000';
            my $Month  = $ValueItem->{ $Prefix . 'Month' }  || '00';
            my $Day    = $ValueItem->{ $Prefix . 'Day' }    || '00';
            my $Hour   = $ValueItem->{ $Prefix . 'Hour' }   || '00';
            my $Minute = $ValueItem->{ $Prefix . 'Minute' } || '00';
            my $Second = $ValueItem->{ $Prefix . 'Second' } || '00';

            my $ManualTimeStamp =
                $Year . '-' . $Month . '-' . $Day . ' '
                . $Hour . ':' . $Minute . ':' . $Second;

            my $ValueItemSystemTime = $DateTimeObject->Set(
                String => $ManualTimeStamp,
            );
            $ValueItemSystemTime = $ValueItemSystemTime ? $DateTimeObject->ToEpoch() : undef;

            if ( $DateRestriction eq 'DisableFutureDates' && $ValueItemSystemTime > $SystemTime ) {
                $ServerError  = 1;
                $ErrorMessage = "Invalid date (need a past date)!";
            }
            elsif ( $DateRestriction eq 'DisablePastDates' && $ValueItemSystemTime < $SystemTime ) {
                $ServerError  = 1;
                $ErrorMessage = "Invalid date (need a future date)!";
            }
        }
    }

    if ( $Param{Mandatory} && !$HasValue ) {
        $ServerError = 1;
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

    # get raw Value strings from field value
    my @Values = !ref $Param{Value}
        ? ( $Param{Value} )
        : scalar $Param{Value}->@* ? $Param{Value}->@*
        :                            (undef);

    # convert date to localized string
    for my $ValueItem (@Values) {
        $ValueItem //= '';
        $ValueItem = $Param{LayoutObject}->{LanguageObject}->FormatTimeString(
            $ValueItem,
            'DateFormat',
            'NoSeconds',
        );
    }

    my $ValueSeparator;
    my $Title = join( ', ', @Values );

    # HTMLOutput transformations - needed because of multivalue
    if ($HTMLOutput) {
        $Title = $Param{LayoutObject}->Ascii2Html(
            Text => $Title,
        );
        $ValueSeparator = '<br/>';
    }
    else {
        $ValueSeparator = "\n";
    }

    # set field link from config
    my $Link        = $Param{DynamicFieldConfig}->{Config}->{Link}        || '';
    my $LinkPreview = $Param{DynamicFieldConfig}->{Config}->{LinkPreview} || '';

    # return a data structure
    return {
        Value       => join( $ValueSeparator, @Values ),
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

    # set the default type
    $Param{Type} ||= 'TimeSlot';

    # add type to FieldName
    $FieldName .= $Param{Type};

    my $Value;

    my %DefaultValue;

    if ( defined $Param{DefaultValue} ) {
        my @Items = split /;/, $Param{DefaultValue};

        # format example of the key name for TimePoint:
        #
        # Search_DynamicField_DateTest1TimePointFormat=week;Search_DynamicField_DateTest1TimePointStart=Before;Search_DynamicField_DateTest1TimePointValue=7;

        # format example of the key name for TimeSlot:
        #
        # Search_DynamicField_DateTest1TimeSlotStartYear=1974;Search_DynamicField_DateTest1TimeSlotStartMonth=01;Search_DynamicField_DateTest1TimeSlotStartDay=26;
        # Search_DynamicField_DateTest1TimeSlotStartHour=00;Search_DynamicField_DateTest1TimeSlotStartMinute=00;Search_DynamicField_DateTest1TimeSlotStartSecond=00;
        # Search_DynamicField_DateTest1TimeSlotStopYear=2013;Search_DynamicField_DateTest1TimeSlotStopMonth=01;Search_DynamicField_DateTest1TimeSlotStopDay=26;
        # Search_DynamicField_DateTest1TimeSlotStopHour=23;Search_DynamicField_DateTest1TimeSlotStopMinute=59;Search_DynamicField_DateTest1TimeSlotStopSecond=59;

        my $KeyName = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name} . $Param{Type};

        ITEM:
        for my $Item (@Items) {
            my ( $Key, $Value ) = split /=/, $Item;

            # only handle keys that match the current type
            next ITEM if $Key !~ m{ $Param{Type} }xms;

            if ( $Param{Type} eq 'TimePoint' ) {

                if ( $Key eq $KeyName . 'Format' ) {
                    $DefaultValue{Format}->{$Key} = $Value;
                }
                elsif ( $Key eq $KeyName . 'Start' ) {
                    $DefaultValue{Start}->{$Key} = $Value;
                }
                elsif ( $Key eq $KeyName . 'Value' ) {
                    $DefaultValue{Value}->{$Key} = $Value;
                }

                next ITEM;
            }

            if ( $Key =~ m{Start} ) {
                $DefaultValue{ValueStart}->{$Key} = $Value;
            }
            elsif ( $Key =~ m{Stop} ) {
                $DefaultValue{ValueStop}->{$Key} = $Value;
            }
        }
    }

    # set the field value
    if (%DefaultValue) {
        $Value = \%DefaultValue;
    }

    # get the field value, this function is always called after the profile is loaded
    my $FieldValues = $Self->SearchFieldValueGet(
        %Param,
    );

    if (
        defined $FieldValues
        && $Param{Type} eq 'TimeSlot'
        && defined $FieldValues->{ValueStart}
        && defined $FieldValues->{ValueStop}
        )
    {
        $Value = $FieldValues;
    }
    elsif (
        defined $FieldValues
        && $Param{Type} eq 'TimePoint'
        && defined $FieldValues->{Format}
        && defined $FieldValues->{Start}
        && defined $FieldValues->{Value}
        )
    {
        $Value = $FieldValues;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldDateTime';

    # set as checked if necessary
    my $FieldChecked = ( defined $Value->{$FieldName} && $Value->{$FieldName} == 1 ? 'checked' : '' );

    my $HTMLString = <<"EOF";
    <input type="hidden" id="$FieldName" name="$FieldName" value="1">
EOF

    if ( $Param{ConfirmationCheckboxes} ) {
        $HTMLString = <<"EOF";
    <input type="checkbox" id="$FieldName" name="$FieldName" value="1" $FieldChecked>
EOF
    }

    # build HTML for TimePoint
    if ( $Param{Type} eq 'TimePoint' ) {

        $HTMLString .= $Param{LayoutObject}->BuildSelection(
            Data => {
                'Before' => Translatable('more than ... ago'),
                'Last'   => Translatable('within the last ...'),
                'Next'   => Translatable('within the next ...'),
                'After'  => Translatable('in more than ...'),
            },
            Sort           => 'IndividualKey',
            SortIndividual => [ 'Before', 'Last', 'Next', 'After' ],
            Name           => $FieldName . 'Start',
            SelectedID     => $Value->{Start}->{ $FieldName . 'Start' } || 'Last',
        );
        $HTMLString .= ' ' . $Param{LayoutObject}->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => $FieldName . 'Value',
            SelectedID => $Value->{Value}->{ $FieldName . 'Value' } || 1,
        );
        $HTMLString .= ' ' . $Param{LayoutObject}->BuildSelection(
            Data => {
                minute => Translatable('minute(s)'),
                hour   => Translatable('hour(s)'),
                day    => Translatable('day(s)'),
                week   => Translatable('week(s)'),
                month  => Translatable('month(s)'),
                year   => Translatable('year(s)'),
            },
            Name       => $FieldName . 'Format',
            SelectedID => $Value->{Format}->{ $FieldName . 'Format' } || Translatable('day'),
        );

        my $AdditionalText;
        if ( $Param{UseLabelHints} ) {
            $AdditionalText = Translatable('before/after');
        }

        # call EditLabelRender on the common backend
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

    # to set the years range
    my %YearsPeriodRange;
    if ( defined $FieldConfig->{YearsPeriod} && $FieldConfig->{YearsPeriod} eq '1' ) {
        %YearsPeriodRange = (
            YearPeriodPast   => $FieldConfig->{YearsInPast}   || 0,
            YearPeriodFuture => $FieldConfig->{YearsInFuture} || 0,
        );
    }

    # build HTML for start value set
    $HTMLString .= $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName . 'Start',
        Format               => 'DateInputFormatLong',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => -( ( 60 * 60 * 24 ) * 30 ),
        Validate             => 1,
        %{ $Value->{ValueStart} },
        %YearsPeriodRange,
        OverrideTimeZone => 1,
    );

    # to put a line break between the two search dates
    my $LineBreak = ' <br>';

    # in screens where the confirmation checkboxes is set, there is no need to render the filed in
    # two lines (e.g. AdminGenericAgentn CustomerTicketSearch)
    if ( $Param{ConfirmationCheckboxes} ) {
        $LineBreak = '';
    }

    $HTMLString .= ' ' . $Param{LayoutObject}->{LanguageObject}->Translate("and") . "$LineBreak\n";

    # build HTML for stop value set
    $HTMLString .= $Param{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix               => $FieldName . 'Stop',
        Format               => 'DateInputFormatLong',
        $FieldName . 'Class' => $FieldClass,
        DiffTime             => +( ( 60 * 60 * 24 ) * 30 ),
        Validate             => 1,
        %{ $Value->{ValueStop} },
        %YearsPeriodRange,
        OverrideTimeZone => 1,
    );

    my $AdditionalText;
    if ( $Param{UseLabelHints} ) {
        $AdditionalText = Translatable('between');
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

    # set the Prefix as the dynamic field name
    my $Prefix = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};

    # set the default type
    $Param{Type} ||= 'TimeSlot';

    # add type to prefix
    $Prefix .= $Param{Type};

    if ( $Param{Type} eq 'TimePoint' ) {

        # get dynamic field value
        my %DynamicFieldValues;
        for my $Type (qw(Start Value Format)) {

            # get dynamic field value form param object
            if ( defined $Param{ParamObject} ) {

                # return if value was not checked (useful in customer interface)
                return if !$Param{ParamObject}->GetParam( Param => $Prefix );

                $DynamicFieldValues{ $Prefix . $Type } = $Param{ParamObject}->GetParam(
                    Param => $Prefix . $Type,
                );
            }

            # otherwise get the value from the profile
            elsif ( defined $Param{Profile} ) {

                # return if value was not checked (useful in customer interface)
                return if !$Param{Profile}->{$Prefix};

                $DynamicFieldValues{ $Prefix . $Type } = $Param{Profile}->{ $Prefix . $Type };
            }
            else {
                return;
            }
        }

        # return if the field is empty (e.g. initial screen)
        return if !$DynamicFieldValues{ $Prefix . 'Start' }
            && !$DynamicFieldValues{ $Prefix . 'Value' }
            && !$DynamicFieldValues{ $Prefix . 'Format' };

        $DynamicFieldValues{$Prefix} = 1;

        # check if return value structure is needed
        if ( defined $Param{ReturnProfileStructure} && $Param{ReturnProfileStructure} eq '1' ) {
            return \%DynamicFieldValues;
        }

        return {
            Format => {
                $Prefix . 'Format' => $DynamicFieldValues{ $Prefix . 'Format' } || 'Last',
            },
            Start => {
                $Prefix . 'Start' => $DynamicFieldValues{ $Prefix . 'Start' } || 'day',
            },
            Value => {
                $Prefix . 'Value' => $DynamicFieldValues{ $Prefix . 'Value' } || 1,
            },
            $Prefix => 1,
        };
    }

    # get dynamic field value
    my %DynamicFieldValues;
    for my $Type (qw(Start Stop)) {
        for my $Part (qw(Year Month Day Hour Minute)) {

            # get dynamic field value from param object
            if ( defined $Param{ParamObject} ) {

                # return if value was not checked (useful in customer interface)
                return if !$Param{ParamObject}->GetParam( Param => $Prefix );

                $DynamicFieldValues{ $Prefix . $Type . $Part } = $Param{ParamObject}->GetParam(
                    Param => $Prefix . $Type . $Part,
                );
            }

            # otherwise get the value from the profile
            elsif ( defined $Param{Profile} ) {

                # return if value was not checked (useful in customer interface)
                return if !$Param{Profile}->{$Prefix};

                $DynamicFieldValues{ $Prefix . $Type . $Part } = $Param{Profile}->{ $Prefix . $Type . $Part };
            }
            else {
                return;
            }
        }
    }

    # return if the field is empty (e.g. initial screen)
    return if !$DynamicFieldValues{ $Prefix . 'StartYear' }
        && !$DynamicFieldValues{ $Prefix . 'StartMonth' }
        && !$DynamicFieldValues{ $Prefix . 'StartDay' }
        && !$DynamicFieldValues{ $Prefix . 'StopYear' }
        && !$DynamicFieldValues{ $Prefix . 'StopMonth' }
        && !$DynamicFieldValues{ $Prefix . 'StopDay' };

    $DynamicFieldValues{ $Prefix . 'StartSecond' } = '00';
    $DynamicFieldValues{ $Prefix . 'StopSecond' }  = '59';

    $DynamicFieldValues{$Prefix} = 1;

    # check if return value structure is needed
    if ( defined $Param{ReturnProfileStructure} && $Param{ReturnProfileStructure} eq '1' ) {
        return \%DynamicFieldValues;
    }

    # add a leading zero for date parts that could be less than ten to generate a correct
    # time stamp
    for my $Type (qw(Start Stop)) {
        for my $Part (qw(Month Day Hour Minute Second)) {
            $DynamicFieldValues{ $Prefix . $Type . $Part } = sprintf "%02d",
                $DynamicFieldValues{ $Prefix . $Type . $Part };
        }
    }

    my $ValueStart = {
        $Prefix . 'StartYear'   => $DynamicFieldValues{ $Prefix . 'StartYear' }   || '0000',
        $Prefix . 'StartMonth'  => $DynamicFieldValues{ $Prefix . 'StartMonth' }  || '00',
        $Prefix . 'StartDay'    => $DynamicFieldValues{ $Prefix . 'StartDay' }    || '00',
        $Prefix . 'StartHour'   => $DynamicFieldValues{ $Prefix . 'StartHour' }   || '00',
        $Prefix . 'StartMinute' => $DynamicFieldValues{ $Prefix . 'StartMinute' } || '00',
        $Prefix . 'StartSecond' => $DynamicFieldValues{ $Prefix . 'StartSecond' } || '00',
    };

    my $ValueStop = {
        $Prefix . 'StopYear'   => $DynamicFieldValues{ $Prefix . 'StopYear' }   || '0000',
        $Prefix . 'StopMonth'  => $DynamicFieldValues{ $Prefix . 'StopMonth' }  || '00',
        $Prefix . 'StopDay'    => $DynamicFieldValues{ $Prefix . 'StopDay' }    || '00',
        $Prefix . 'StopHour'   => $DynamicFieldValues{ $Prefix . 'StopHour' }   || '00',
        $Prefix . 'StopMinute' => $DynamicFieldValues{ $Prefix . 'StopMinute' } || '00',
        $Prefix . 'StopSecond' => $DynamicFieldValues{ $Prefix . 'StopSecond' } || '00',
    };

    return {
        $Prefix    => 1,
        ValueStart => $ValueStart,
        ValueStop  => $ValueStop,
    };
}

sub SearchFieldPreferences {
    my ( $Self, %Param ) = @_;

    return [
        {
            Type        => 'TimePoint',
            LabelSuffix => 'before/after',
        },
        {
            Type        => 'TimeSlot',
            LabelSuffix => 'between',
        },
    ];
}

sub SearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    # set the default type
    $Param{Type} ||= 'TimeSlot';

    # get field value
    my $Value = $Self->SearchFieldValueGet(%Param);

    my $DisplayValue;

    if ( defined $Value && !$Value ) {
        $DisplayValue = '';
    }

    # do not search if value was not checked (useful for customer interface)
    if ( !$Value ) {
        return {
            Parameter => {
                Equals => $Value,
            },
            Display => $DisplayValue,
        };
    }

    # search for a wild card in the value
    if ( $Value && IsHashRefWithData($Value) ) {

        my $Prefix = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name} . $Param{Type};

        if (
            $Param{Type} eq 'TimePoint'
            && $Value->{Start}->{ $Prefix . 'Start' }
            && $Value->{Format}->{ $Prefix . 'Format' }
            && $Value->{Value}->{ $Prefix . 'Value' }
            && $Value->{$Prefix}
            )
        {

            # to store the search parameters
            my %Parameter;

            # store in local variables for easier handling
            my $Format = $Value->{Format}->{ $Prefix . 'Format' };
            my $Start  = $Value->{Start}->{ $Prefix . 'Start' };
            my $Value  = $Value->{Value}->{ $Prefix . 'Value' };

            my $DiffTimeMinutes = 0;
            if ( $Format eq 'minute' ) {
                $DiffTimeMinutes = $Value;
            }
            elsif ( $Format eq 'hour' ) {
                $DiffTimeMinutes = $Value * 60;
            }
            elsif ( $Format eq 'day' ) {
                $DiffTimeMinutes = $Value * 60 * 24;
            }
            elsif ( $Format eq 'week' ) {
                $DiffTimeMinutes = $Value * 60 * 24 * 7;
            }
            elsif ( $Format eq 'month' ) {
                $DiffTimeMinutes = $Value * 60 * 24 * 30;
            }
            elsif ( $Format eq 'year' ) {
                $DiffTimeMinutes = $Value * 60 * 24 * 365;
            }

            # get time object
            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

            # get the current time in epoch seconds and as time-stamp
            my $Now          = $DateTimeObject->ToEpoch();
            my $NowTimeStamp = $DateTimeObject->ToString();

            # calculate difference time seconds
            my $DiffTimeSeconds = $DiffTimeMinutes * 60;

            my $DisplayValue = '';

            # define to search before or after that time stamp
            if ( $Start eq 'Before' ) {

                # we must subtract the difference because it is in the past
                my $DateTimeObjectBefore = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        Epoch => $Now - $DiffTimeSeconds,
                    }
                );

                # only search dates in the past (before the time stamp)
                $Parameter{SmallerThanEquals} = $DateTimeObjectBefore->ToString();

                # set the display value
                $DisplayValue = '<= ' . $DateTimeObjectBefore->ToString();
            }
            elsif ( $Start eq 'Last' ) {

                # we must subtract the differences because it is in the past
                my $DateTimeObjectLast = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        Epoch => $Now - $DiffTimeSeconds,
                    }
                );

                # search dates in the past (after the time stamp and up to now)
                $Parameter{GreaterThanEquals} = $DateTimeObjectLast->ToString();
                $Parameter{SmallerThanEquals} = $NowTimeStamp;

                # set the display value
                $DisplayValue = $DateTimeObjectLast->ToString() . ' - ' . $NowTimeStamp;
            }
            elsif ( $Start eq 'Next' ) {

                # we must add the difference because it is in the future
                my $DateTimeObjectNext = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        Epoch => $Now + $DiffTimeSeconds,
                    }
                );

                # search dates in the future (after now and up to the time stamp)
                $Parameter{GreaterThanEquals} = $NowTimeStamp;
                $Parameter{SmallerThanEquals} = $DateTimeObjectNext->ToString();

                # set the display value
                $DisplayValue = $NowTimeStamp . ' - ' . $DateTimeObjectNext->ToString();
            }
            elsif ( $Start eq 'After' ) {

                # we must add the difference because it is in the future
                my $DateTimeObjectAfter = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        Epoch => $Now + $DiffTimeSeconds,
                    }
                );

                # only search dates in the future (after the time stamp)
                $Parameter{GreaterThanEquals} = $DateTimeObjectAfter->ToString();

                # set the display value
                $DisplayValue = '>= ' . $DateTimeObjectAfter->ToString();
            }

            # return search parameter structure
            return {
                Parameter => \%Parameter,
                Display   => $DisplayValue,
            };
        }

        my $ValueStart = $Value->{ValueStart}->{ $Prefix . 'StartYear' } . '-'
            . $Value->{ValueStart}->{ $Prefix . 'StartMonth' } . '-'
            . $Value->{ValueStart}->{ $Prefix . 'StartDay' } . ' '
            . $Value->{ValueStart}->{ $Prefix . 'StartHour' } . ':'
            . $Value->{ValueStart}->{ $Prefix . 'StartMinute' } . ':'
            . $Value->{ValueStart}->{ $Prefix . 'StartSecond' };

        my $ValueStop = $Value->{ValueStop}->{ $Prefix . 'StopYear' } . '-'
            . $Value->{ValueStop}->{ $Prefix . 'StopMonth' } . '-'
            . $Value->{ValueStop}->{ $Prefix . 'StopDay' } . ' '
            . $Value->{ValueStop}->{ $Prefix . 'StopHour' } . ':'
            . $Value->{ValueStop}->{ $Prefix . 'StopMinute' } . ':'
            . $Value->{ValueStop}->{ $Prefix . 'StopSecond' };

        # return search parameter structure
        return {
            Parameter => {
                GreaterThanEquals => $ValueStart,
                SmallerThanEquals => $ValueStop,
            },
            Display => $ValueStart . ' - ' . $ValueStop,
        };
    }

    return;
}

sub StatsFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    return {
        Name             => $Param{DynamicFieldConfig}->{Label},
        Element          => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        TimePeriodFormat => 'DateInputFormatLong',
        Block            => 'Time',
    };
}

sub StatsSearchFieldParameterBuild {
    my ( $Self, %Param ) = @_;

    my $Operator = $Param{Operator};
    my $Value    = $Param{Value};

    return {} if !$Operator;

    return {
        $Operator => $Value,
    };
}

sub ReadableValueRender {
    my ( $Self, %Param ) = @_;

    my $Value = '';

    # check value
    my @Values = !ref $Param{Value}
        ? ( $Param{Value} )
        : scalar $Param{Value}->@* ? $Param{Value}->@*
        :                            (undef);

    # only keep date and time without seconds or milliseconds
    for my $ValueItem (@Values) {
        $ValueItem //= '';
        $ValueItem =~ s{\A (\d{4} - \d{2} - \d{2} [ ] \d{2} : \d{2} ) }{$1}xms;
    }

    # set new line separator
    my $ItemSeparator = ', ';

    $Value = join( $ItemSeparator, @Values );

    # Title is always equal to Value
    my $Title = $Value;

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

    # TODO Suggestion to reduce code here: Unify this into one for loop and use LoopCount as limiter
    # my $LoopCount = $Param{DynamicFieldConfig}{Config}{MultiValue} ? 0 : int( rand(3) );
    if ( $Param{DynamicFieldConfig}{Config}{MultiValue} ) {
        for my $j ( 0 .. int( rand(3) ) ) {

            my $YearValue   = int( rand(40) ) + 1_990;
            my $MonthValue  = int( rand(9) ) + 1;
            my $DayValue    = int( rand(10) ) + 10;
            my $HourValue   = int( rand(12) ) + 10;
            my $MinuteValue = int( rand(30) ) + 10;
            my $SecondValue = int( rand(30) ) + 10;

            $Value->[$j] = $YearValue . '-0' . $MonthValue . '-' . $DayValue . ' '
                . $HourValue . ':' . $MinuteValue . ':' . $SecondValue;
        }
    }
    else {
        my $YearValue   = int( rand(40) ) + 1_990;
        my $MonthValue  = int( rand(9) ) + 1;
        my $DayValue    = int( rand(10) ) + 10;
        my $HourValue   = int( rand(12) ) + 10;
        my $MinuteValue = int( rand(30) ) + 10;
        my $SecondValue = int( rand(30) ) + 10;

        $Value = $YearValue . '-0' . $MonthValue . '-' . $DayValue . ' '
            . $HourValue . ':' . $MinuteValue . ':' . $SecondValue;
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

    # not supported
    return 0;
}

sub HistoricalValuesGet {
    my ( $Self, %Param ) = @_;

    # return the historical values from database
    return $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->HistoricalValueGet(
        FieldID   => $Param{DynamicFieldConfig}->{ID},
        ValueType => 'DateTime',
    );
}

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    my $Value = $Param{Key} // '';

    # check if formatting is possible
    return $Value unless defined $Param{LanguageObject};

    # format value as date without seconds
    return $Param{LanguageObject}->FormatTimeString(
        $Value,
        'DateFormat',
        'NoSeconds',
    );
}

1;
