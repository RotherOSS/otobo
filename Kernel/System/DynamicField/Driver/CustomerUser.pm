# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::DynamicField::Driver::CustomerUser;

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
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::CustomerUser - the CustomerUser dynamic field

=head1 DESCRIPTION

DynamicFields CustomerUser Driver delegate.

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
        'IsACLReducible' => 0,

        # TODO Check if this makes sense
        'IsNotificationEventCondition' => 0,
        'IsSortable'                   => 0,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 0,
        'IsCustomerInterfaceCapable'   => 0,
        'IsLikeOperatorCapable'        => 1,
        'IsSetCapable'                 => 0,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::CustomerUser');

    EXTENSION:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # skip invalid extensions
        next EXTENSION if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension has a new module
        if ( $Extension->{Module} ) {

            # check if module can be loaded
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
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

sub FieldValueValidate {
    my ( $Self, %Param ) = @_;

    # Check for defined value.
    if ( !defined $Param{Value} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Value in CustomerUser DynamicField!",
        );
        return;
    }

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

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
            return if !defined $CustomerUserObject->CustomerUserDataGet(
                User => $Value,
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
    my $FieldClass = 'DynamicFieldText DynamicFieldCustomerUser Modernize';
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

    my $FieldTemplateFile = 'DynamicField/Agent/CustomerUser';

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
                Value => $Value->[$ValueIndex] || '',
            }
        );
    }

    my $TemplateHTML;
    if ( $FieldConfig->{MultiValue} && !$Param{Readonly} ) {
        $FieldTemplateData{FieldID} = $FieldName . '_Template';

        $TemplateHTML = $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
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

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    for my $ValueItem ( @{$Value} ) {

        # perform necessary validations
        if ( $Param{Mandatory} && !$ValueItem ) {
            return {
                ServerError => 1,
            };
        }
        else {
            # validate if value is in possible values list (but let pass empty values)
            if ( $ValueItem && !defined $CustomerUserObject->CustomerUserDataGet( User => $ValueItem ) ) {
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

        # replace customer user login with full name
        if ($ValueItem) {
            $ValueItem = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
                UserLogin => $ValueItem,
            );
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

    # get field value
    my $Value = $Self->SearchFieldValueGet(%Param);

    my $DisplayValue;

    if ( defined $Value && !$Value ) {
        $DisplayValue = '';
    }

    if ($Value) {
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        if ( ref $Value eq 'ARRAY' ) {

            my @DisplayItemList;
            for my $Item ( @{$Value} ) {

                # set the display value
                my $DisplayItem = $CustomerUserObject->CustomerName(
                    UserLogin => $Item,
                ) || $Item;

                push @DisplayItemList, $DisplayItem;
            }

            # combine different values into one string
            $DisplayValue = join ' + ', @DisplayItemList;
        }
        else {

            # set the display value
            $DisplayValue = $CustomerUserObject->CustomerName(
                UserLogin => $Value,
            );
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

    # function needs to be overwritten to make sure that the call doesn't reach StatsFieldParameterBuild in BaseEntity
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Prioritiy => 'error',
        Message   => 'Method StatsFieldParameterBuild is not implemented for CustomerUser dynamic fields and should never be called.',
    );
    return;
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

        # replace customer user login with full name
        if ($Item) {
            $Item = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
                UserLogin => $Item,
            );
        }

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

sub ValueLookup {
    my ( $Self, %Param ) = @_;

    my $Value = $Param{Key} // '';

    my @Keys;
    if ( ref $Param{Key} eq 'ARRAY' ) {
        @Keys = @{ $Param{Key} };
    }
    else {
        @Keys = ( $Param{Key} );
    }

    # to store final values
    my @Values;

    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    KEYITEM:
    for my $Item (@Keys) {
        next KEYITEM if !$Item;

        # try to convert key to real value or set value as key
        $Value = $CustomerUserObject->CustomerName(
            UserLogin => $Item,
        ) || $Item;

        push @Values, $Value;
    }

    return \@Values;
}

sub PossibleValuesGet {

    # this field makes no use of PossibleValuesGet for performance purpose - instead, values are checked via CustomerUserDataGet
    # nevertheless, function needs to be overwritten to make sure that the call doesn't reach PossibleValuesGet in BaseSelect
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Prioritiy => 'error',
        Message   => 'Method PossibleValuesGet is per design not implemented for CustomerUser dynamic fields and should never be called.',
    );
    return;
}

1;
