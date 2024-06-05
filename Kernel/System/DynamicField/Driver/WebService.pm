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

package Kernel::System::DynamicField::Driver::WebService;

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
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::GenericInterface::Requester',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
    'Kernel::System::Web::Request',
);

=head1 NAME

Kernel::System::DynamicField::Driver::WebService - driver for the WebService dynamic field

=head1 DESCRIPTION

DynamicFields Web Service Driver delegate

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
        'IsACLReducible'               => 1,
        'IsNotificationEventCondition' => 1,
        'IsSortable'                   => 0,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 1,
        'IsLikeOperatorCapable'        => 1,
    };

    # Get the Dynamic Field Backend custom extensions.
    my $DynamicFieldDriverExtensions = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::Webservice');

    EXTENSIONKEY:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # Skip invalid extensions.
        next EXTENSIONKEY if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # Create a extension config shortcut.
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # Check if extension has a new module.
        if ( $Extension->{Module} ) {

            # Check if module can be loaded.
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # Check if extension contains more behaviors.
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
        ValueKey   => 'ValueText',
        Set        => $Param{Set},
        MultiValue => $Param{DynamicFieldConfig}{Config}{MultiValue},
    );
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

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
    if ( $FieldConfig->{MultiValue} || $FieldConfig->{Multiselect} ) {
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
    my $FieldClass = ( $FieldConfig->{Multiselect} ? 'DynamicFieldDropdown' : 'DynamicFieldText' ) . " Modernize DynamicFieldWebservice";
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

    if ( $Param{Mandatory} ) {
        $FieldTemplateData{Mandatory}            = $Param{Mandatory};
        $FieldTemplateData{DivIDMandatory}       = $FieldName . 'Error';
        $FieldTemplateData{FieldRequiredMessage} = Translatable("This field is required.");
    }

    if ( $Param{ServerError} ) {

        $FieldTemplateData{ServerError}      = $Param{ServerError};
        $FieldTemplateData{ErrorMessage}     = Translatable( $Param{ErrorMessage} || 'This field is required.' );
        $FieldTemplateData{DivIDServerError} = $FieldName . 'ServerError';
    }

    my $FieldTemplateFile = $Param{CustomerInterface}
        ?
        'DynamicField/Customer/WebService'
        :
        'DynamicField/Agent/WebService';

    my @ResultHTML;
    for my $ValueIndex ( 0 .. $#{$Value} ) {
        my $FieldID = $FieldConfig->{MultiValue} ? $FieldName . '_' . $ValueIndex : $FieldName;

        # TODO: is this necessary?
        my $DataValues = $Self->BuildSelectionDataGet(
            DynamicFieldConfig => $Param{DynamicFieldConfig},
            PossibleValues     => $PossibleValues,
            Value              => $Value->[$ValueIndex],
        );

        my $SelectionHTML = $Param{LayoutObject}->BuildSelection(
            Data         => $DataValues || {},
            Disabled     => $Param{Readonly},
            Name         => $FieldName,
            ID           => $FieldID,
            SelectedID   => $Value->[$ValueIndex],
            Translation  => $FieldConfig->{TranslatableValues} || 0,
            Class        => $FieldClass,
            Multiple     => $FieldConfig->{Multiselect} ? 1 : 0,
            Size         => $Size,
            HTMLQuote    => 1,
            PossibleNone => $FieldConfig->{PossibleNone} || 0,
        );

        push @ResultHTML, $Param{LayoutObject}->Output(
            TemplateFile => $FieldTemplateFile,
            Data         => {
                %FieldTemplateData,
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
            Data         => $DataValues || {},
            Name         => $FieldName,
            ID           => $FieldID,
            Translation  => $FieldConfig->{TranslatableValues} || 0,
            Class        => $FieldClass,
            Multiple     => $FieldConfig->{Multiselect} ? 1 : 0,
            Size         => $Size,
            HTMLQuote    => 1,
            PossibleNone => $FieldConfig->{PossibleNone} || 0,
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

        if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {

            # delete the template value
            pop @Data;
            $Value = \@Data;

        }
        else {

            # Delete empty values (can happen if the user has selected the "-" entry).
            my $Index = 0;
            ITEM:
            for my $Item ( sort @Data ) {

                if ( !$Item ) {
                    splice( @Data, $Index, 1 );
                    next ITEM;
                }
                $Index++;
            }

            $Value = $Data[0];

            if ( $Param{DynamicFieldConfig}->{Config}->{Multiselect} ) {
                $Value = \@Data;
            }
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

    # Perform necessary validations.
    if ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} ) {
        for my $ValueItem ( @{$Value} ) {
            if ( $Param{Mandatory} && $ValueItem eq '' ) {
                $ServerError = 1;
            }
        }
    }
    else {
        if ( $Param{Mandatory} && ( !defined $Value || !length $Value ) ) {
            return {
                ServerError => 1,
            };
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

    # Get specific field settings.
    my $FieldConfig = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Driver')->{Webservice} || {};

    # Set new line separator.
    my $ValueSeparator = $FieldConfig->{ItemSeparator} || ', ';
    my $Title          = join( ', ', @ReadableTitles );

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
        Name         => $FieldName,
        SelectedID   => $Value,
        Translation  => $FieldConfig->{TranslatableValues} || 0,
        PossibleNone => 0,
        Class        => $FieldClass,
        Multiple     => ( $FieldConfig->{MultiValue} || $FieldConfig->{Multiselect} ) ? 1 : 0,
        Size         => 5,
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
        Values             => $Values,
        Name               => $Param{DynamicFieldConfig}->{Label},
        Element            => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
        TranslatableValues => $Param{DynamicFieldConfig}->{Config}->{TranslatableValues},
        Block              => 'MultiSelectField',
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
            my $PossibleNoneSet;

            my %Values;
            if (
                ( $FieldConfig->{Multiselect} )
                && defined $Param{Value}
                && IsArrayRefWithData( $Param{Value} )
                )
            {

                # Create a lookup table.
                %Values = map { $_ => 1 } @{ $Param{Value} };
            }

            # Loop on all filtered possible values.
            for my $Key ( sort keys %{$FilteredPossibleValues} ) {

                # special case for possible none
                if ( !$Key && !$PossibleNoneSet && $FieldConfig->{PossibleNone} ) {

                    if ( $FieldConfig->{Multiselect} ) {
                        my $Selected;
                        if (
                            !IsHashRefWithData( \%Values )
                            || ( defined $Values{''} && $Values{''} )
                            )
                        {
                            $Selected = 1;
                        }

                        # Add possible none.
                        push @Values, {
                            Key      => $Key,
                            Value    => $ConfigPossibleValues->{$Key} || '-',
                            Selected => $Selected,
                        };
                    }
                    else {
                        push @Values, {
                            Key      => $Key,
                            Value    => $ConfigPossibleValues->{$Key} || '-',
                            Selected => defined $Param{Value}         || !$Param{Value} ? 1 : 0,
                        };
                    }
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
                        $FieldConfig->{Multiselect}
                        && IsHashRefWithData( \%Values )
                        && $Values{$ElementLongName}
                        )
                    {
                        $Selected = 1;
                    }
                    elsif (
                        !$FieldConfig->{Multiselect}
                        && defined $Param{Value}
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

    # Determine object data / use the given hash.
    my $ObjectData = $Self->_ObjectDataGet(%Param);

    # Include the data from the web request.
    $ObjectData->{Data}->{Form} = $Self->_FormDataGet();

    # Get md5 sum of given object data hash.
    my $HashMD5String = $Self->_HashMD5Get(
        Structure => $ObjectData->{Data},
    );

    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};

    if ( $FieldConfig->{CacheTTL} ) {

        my $CacheType = 'DynamicFieldWebservice';
        my $CacheKey  = $FieldConfig->{WebserviceID} . '::' . $FieldConfig->{Invoker} . '::' . $HashMD5String;

        # Check if value is cached.
        my $Data = $Kernel::OM->Get('Kernel::System::Cache')->Get(
            Type => $CacheType,
            Key  => $CacheKey,
        );

        return $Data if IsHashRefWithData($Data);
    }

    my %PossibleValues;

    # set PossibleNone attribute
    my $FieldPossibleNone;
    if ( defined $Param{OverridePossibleNone} ) {
        $FieldPossibleNone = $Param{OverridePossibleNone};
    }
    else {
        $FieldPossibleNone = $Param{DynamicFieldConfig}->{Config}->{PossibleNone} || 0;
    }

    my $Result = {};

    # Retrieve the remote possible values.
    if ( IsHashRefWithData( $ObjectData->{Data} ) ) {
        $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $FieldConfig->{WebserviceID},
            Invoker      => $FieldConfig->{Invoker},
            Asynchronous => 0,
            Data         => {
                %{ $ObjectData->{Data} },
                UserID => $Self->{UserID} || $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserID} || 1,
            },
        );
    }

    # Multiple values to process.
    if (
        $Result->{Success}
        && $Result->{Data}
        && $Result->{Data}->{PossibleValue}
        && IsArrayRefWithData( $Result->{Data}->{PossibleValue} )
        )
    {
        my %Result;

        DATASET:
        for my $DataSet ( @{ $Result->{Data}->{PossibleValue} } ) {

            next DATASET if !$DataSet;
            next DATASET if !IsHashRefWithData($DataSet);
            next DATASET if !IsStringWithData( $DataSet->{Key} );
            next DATASET if !IsStringWithData( $DataSet->{Value} );

            $Result{ $DataSet->{Key} } = $DataSet->{Value};
        }

        %PossibleValues = (
            %PossibleValues,
            %Result
        );
    }

    # Single value to process.
    elsif (
        $Result->{Success}
        && $Result->{Data}
        && $Result->{Data}->{PossibleValue}
        && IsHashRefWithData( $Result->{Data}->{PossibleValue} )
        && IsStringWithData( $Result->{Data}->{PossibleValue}->{Key} )
        && IsStringWithData( $Result->{Data}->{PossibleValue}->{Value} )
        )
    {
        $PossibleValues{ $Result->{Data}->{PossibleValue}->{Key} } = $Result->{Data}->{PossibleValue}->{Value};
    }

    if ( $FieldConfig->{CacheTTL} ) {

        my $CacheType = 'DynamicFieldWebservice';
        my $CacheKey  = $FieldConfig->{WebserviceID} . '::' . $FieldConfig->{Invoker} . '::' . $HashMD5String;
        my $CacheTTL  = $FieldConfig->{CacheTTL} * 60;

        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => \%PossibleValues,
            TTL   => $CacheTTL,
        );
    }

    # Return the possible values hash as a reference.
    return \%PossibleValues;
}

sub _ObjectDataGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(DynamicFieldConfig)) {

        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'error',
                'Message'  => "Need '$Needed' to determine object data!",
            );
            return {
                ObjectID => '',
                Data     => {},
            };
        }
    }

    my $ObjectType = $Param{DynamicFieldConfig}->{ObjectType};

    $ObjectType = $ObjectType eq 'Article' ? 'Ticket' : $ObjectType;

    # Get additional object data to inject to the request.
    my %AdditionalData;
    my $ObjectID;

    # Set the dynamic field object handler.
    my $ObjectName = 'DynamicField' . $ObjectType . 'HandlerObject';

    my $DynamicFieldObjectHandler = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->{$ObjectName};

    # If an ObjectType handler is registered, use it.
    if (
        ref $DynamicFieldObjectHandler
        && $DynamicFieldObjectHandler->can('ObjectDataGet')
        )
    {
        my %ObjectData = $DynamicFieldObjectHandler->ObjectDataGet(
            DynamicFieldConfig => $Param{DynamicFieldConfig},
            UserID             => $Self->{UserID} || $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserID} || 1,
        );

        $ObjectID       = $ObjectData{ObjectID};
        %AdditionalData = %{ $ObjectData{Data} || {} };
    }
    elsif ( !$DynamicFieldObjectHandler->can('ObjectDataGet') ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$ObjectType object type does not provide ObjectDataGet()",
        );
    }

    my $GetFunction       = ( $Param{DynamicFieldConfig}->{Config}->{MultiValue} || $Param{DynamicFieldConfig}->{Config}->{Multiselect} ) ? 'GetArray' : 'GetParam';
    my $DynamicFieldValue = $Kernel::OM->Get('Kernel::System::Web::Request')->$GetFunction(
        Param => 'DynamicField_' . $Param{DynamicFieldConfig}->{Name},
    );

    # Prepare object data hash with related object type (Ticket, Article etc...).
    my %ObjectData = (
        $ObjectType       => {},
        DynamicFieldID    => $Param{DynamicFieldConfig}->{ID},
        DynamicFieldName  => $Param{DynamicFieldConfig}->{Name},
        DynamicFieldLabel => $Param{DynamicFieldConfig}->{Label},
        DynamicFieldValue => $DynamicFieldValue || '',              # should not use undef due to XSLT mapping complaints.
    );

    my %ObjectDynamicFields;

    # Pre-compile regular expressions.
    my $DFMatch = qr{ ^DynamicField_ }xms;

    DATAKEY:
    for my $DataKey ( sort keys %AdditionalData ) {

        next DATAKEY if !$DataKey;

        if ( $DataKey =~ m{ $DFMatch }xms ) {

            # Remove dynamic field prefix.
            my $DynamicFieldName = substr( $DataKey, 13 );

            # Detect own dynamic field name and set matching value.
            if (
                $DynamicFieldName eq $Param{DynamicFieldConfig}->{Name}
                && $AdditionalData{$DataKey}
                )
            {
                $ObjectData{DynamicFieldValue} = $AdditionalData{$DataKey};
            }

            next DATAKEY if !$AdditionalData{$DataKey};

            $ObjectData{$ObjectType}->{DynamicField}->{$DynamicFieldName} = $AdditionalData{$DataKey};
            $ObjectDynamicFields{$DynamicFieldName} = $AdditionalData{$DataKey};
        }
        else {

            next DATAKEY if !$AdditionalData{$DataKey};
            $ObjectData{$ObjectType}->{$DataKey} = $AdditionalData{$DataKey};
        }
    }

    # Add dynamic fields additionally on root level.
    if ( IsHashRefWithData( \%ObjectDynamicFields ) ) {
        $ObjectData{DynamicField} = \%ObjectDynamicFields;
    }

    return {
        ObjectType => $ObjectType,
        ObjectID   => $ObjectID,
        Data       => \%ObjectData,
    };
}

sub _FormDataGet {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my @ParamNames  = $ParamObject->GetParamNames();
    my %SkipParams  = (
        DynamicFieldNamesStrg   => 1,
        FormID                  => 1,
        ExpandCustomerName      => 1,
        OwnerAll                => 1,
        ResponsibleAll          => 1,
        PreSelectedCustomerUser => 1,
        SelectedCustomerUser    => 1,
        FromCustomer            => 1,
        ChallengeToken          => 1,
        Action                  => 1,
        Subaction               => 1,
        ElementChanged          => 1,
        FileUpload              => 1,
    );

    # Pre-compile regular expressions.
    my $DFMatch = qr{ \A DynamicField_ }xms;

    my %FormData;
    PARAM:
    for my $Param (@ParamNames) {
        next PARAM if $SkipParams{$Param};

        # Get the param as array by default.
        my @ValueRaw = $ParamObject->GetArray( Param => $Param );

        # Convert value back to scalar if there is only one array element.
        my $Value = scalar @ValueRaw > 1 ? \@ValueRaw : $ValueRaw[0] || '';

        # Decompose Dest parameter (from ticket create screens).
        if ( $Param eq 'Dest' ) {
            my ( $QueueID, $Queue ) = $Value =~ m{\A (\d+) \|\| (.*) \z}msx;

            if ( $QueueID && $Queue ) {
                $FormData{QueueID} = $QueueID;
                $FormData{Queue}   = $Queue;
                next PARAM;
            }
        }

        # Add normal parameters.
        if ( $Param !~ m{ $DFMatch }xms ) {

            $FormData{$Param} = $Value;
            next PARAM;
        }

        # Continue with dynamic fields, remove the prefix.
        my $DynamicFieldName = substr( $Param, 13 );    # length of 'DynamicField_'

        $FormData{DynamicField}->{$DynamicFieldName} = $Value;
    }

    return \%FormData;
}

sub _HashMD5Get {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Structure)) {

        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                'Priority' => 'error',
                'Message'  => "Need '$Needed' to determine object data!",
            );
            return;
        }
    }

    my %Result;
    my @MD5Strings;

    KEY:
    for my $Key ( sort keys %{ $Param{Structure} } ) {

        next KEY if !$Key;

        if ( IsHashRefWithData( $Param{Structure}->{$Key} ) ) {
            push @MD5Strings, $Self->_HashMD5Get(
                Structure => $Param{Structure}->{$Key},
            );
        }
        else {
            $Result{$Key} = $Param{Structure}->{$Key};
        }
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    push @MD5Strings, $MainObject->Dump( \%Result, 'ascii' );

    my $MD5Sum = $MainObject->MD5sum(
        String => join '::',
        sort @MD5Strings,
    );

    return $MD5Sum;
}

1;
