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

package Kernel::System::DynamicField::Driver::TextArea;

## nofilter(TidyAll::Plugin::OTOBO::Perl::ParamObject)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::DynamicField::Driver::BaseText);

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
);

=head1 NAME

Kernel::System::DynamicField::Driver::TextArea - driver for the TextArea dynamic field

=head1 DESCRIPTION

DynamicFields TextArea Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ($Type) = @_;

    # Call constructor of the base class.
    my $Self = $Type->SUPER::new;

    # Settings that are specific to the TextArea dynamic field

    # set the maximum length for the text-area fields to still be a searchable field
    # in some database systems
    $Self->{MaxLength} = 3800;

    # set Text specific field behaviors unless an extension already set it
    $Self->{Behaviors}->{IsSortable} //= 0;

    return $Self;
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

    # set the rows number
    my $RowsNumber = defined $FieldConfig->{Rows} && $FieldConfig->{Rows} ? $FieldConfig->{Rows} : '7';

    # set the cols number
    my $ColsNumber = defined $FieldConfig->{Cols} && $FieldConfig->{Cols} ? $FieldConfig->{Cols} : '42';

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldTextArea';
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

    # set validation class for maximum characters
    $FieldClass .= ' Validate_MaxLength';

    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $FieldLabel,
    );

    # create field HTML
    # the XHTML definition does not support maxlength attribute for a text-area field,
    # we use data-maxlength instead
    # Notice that some browsers count new lines \n\r as only 1 character. In these cases the
    # validation framework might generate an error while the user is still capable to enter text in the
    # text-area. Otherwise the maxlength property will prevent to enter more text than the maximum.
    my $MaxLength = $Param{MaxLength} // $Self->{MaxLength};

    my $ErrorMessage1 = $Param{LayoutObject}->{LanguageObject}->Translate("This field is required or");
    my $ErrorMessage2 = $Param{LayoutObject}->{LanguageObject}->Translate("The field content is too long!");
    my $ErrorMessage3 = $Param{LayoutObject}->{LanguageObject}->Translate( "Maximum size is %s characters.", $MaxLength );

    my %FieldTemplateData = (
        FieldClass        => $FieldClass,
        FieldName         => $FieldName,
        FieldLabelEscaped => $FieldLabelEscaped,
        MultiValue        => $FieldConfig->{MultiValue} || 0,
        Readonly          => $Param{Readonly},
        RowsNumber        => $RowsNumber,
        ColsNumber        => $ColsNumber,
        MaxLength         => $MaxLength,
        ErrorMessage1     => $ErrorMessage1,
        ErrorMessage2     => $ErrorMessage2,
        ErrorMessage3     => $ErrorMessage3,
        DivID             => $FieldName . 'Error',
    );

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/TextArea'
        :
        'DynamicField/Agent/TextArea';

    my %Error = (
        ServerError => $Param{ServerError},
        Mandatory   => $Param{Mandatory},
    );
    my @ResultHTML;
    for my $ValueIndex ( 0 .. $#{$Value} ) {
        $FieldTemplateData{FieldID}      = $FieldConfig->{MultiValue} ? $FieldName . '_' . $ValueIndex : $FieldName;
        $FieldTemplateData{ValueEscaped} = $Param{LayoutObject}->Ascii2Html(
            Text => $Value->[$ValueIndex],
        );

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

    for my $ValueItem ( @{$Value} ) {

        # perform necessary validations
        if ( $Param{Mandatory} && $ValueItem eq '' ) {
            $ServerError = 1;
        }
        elsif ( length $ValueItem > $Self->{MaxLength} ) {
            $ServerError  = 1;
            $ErrorMessage = "The field content is too long! Maximum size is $Self->{MaxLength} characters.";
        }
        elsif (
            IsArrayRefWithData( $Param{DynamicFieldConfig}->{Config}->{RegExList} )
            && ( $Param{Mandatory} || ( !$Param{Mandatory} && $ValueItem ne '' ) )
            )
        {

            # check regular expressions
            my @RegExList = @{ $Param{DynamicFieldConfig}->{Config}->{RegExList} };

            REGEXENTRY:
            for my $RegEx (@RegExList) {

                if ( $ValueItem !~ $RegEx->{Value} ) {
                    $ServerError  = 1;
                    $ErrorMessage = $RegEx->{ErrorMessage};

                    last REGEXENTRY;
                }
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

1;
