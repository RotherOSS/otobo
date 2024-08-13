# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2023 OTRS AG, https://otrs.com/
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

package Kernel::Modules::AdminDynamicFieldReference;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {%Param}, $Type;

    # Some setup
    $Self->{TemplateFile} = 'AdminDynamicFieldReference';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Store last entity screen.
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenEntity',
        Value     => $Self->{RequestedURL},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Get the field specific settings and attributes during the runtime as the
    # complete list depends on the previous selection of ReferencedObjectType.
    my @FieldTypeSettings;
    my %EqualsObjectFilterableAttributes;
    my %ReferenceObjectFilterableAttributes;
    {
        my $ObjectType = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ObjectType' );
        my $FieldType  = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FieldType' );
        if ($FieldType) {
            my $DriverObject = $Kernel::OM->Get( 'Kernel::System::DynamicField::Driver::' . $FieldType );

            # The available settings may depend on the type of the referencing object.
            @FieldTypeSettings = $DriverObject->GetFieldTypeSettings(
                ObjectType => $ObjectType,
            );

            # fetch field type filterable attributes
            my $FieldTypeObjectName =
                $FieldType eq 'Agent'      ? 'User' :
                $FieldType =~ /ConfigItem/ ? 'ITSMConfigItem' :
                $FieldType;
            my $FieldTypeObject = $Kernel::OM->Get( 'Kernel::System::' . $FieldTypeObjectName );

            # try ObjectAttributesGet as Agent, ConfigItem and Ticket provide this method
            if ( $FieldTypeObject->can('ObjectAttributesGet') ) {
                my %FieldTypeAttributes = $FieldTypeObject->ObjectAttributesGet(
                    DynamicFields => 1,
                );
                %ReferenceObjectFilterableAttributes = map { $FieldTypeAttributes{$_} ? ( $_ => $_ ) : () } keys %FieldTypeAttributes;
            }
            else {
                %ReferenceObjectFilterableAttributes = _ObjectAttributesGet( ObjectName => $FieldTypeObjectName );
            }
        }

        # fetch reference object attributes depending on df object type
        if ($ObjectType) {

            # fetch object type filterable attributes
            my $ObjectTypeObjectName =
                $ObjectType eq 'Agent'      ? 'User' :
                $ObjectType =~ /ConfigItem/ ? 'ITSMConfigItem' :
                $ObjectType eq 'Article'    ? 'Ticket' :
                $ObjectType;
            my $ObjectTypeObject = $Kernel::OM->Get( 'Kernel::System::' . $ObjectTypeObjectName );

            # try ObjectAttributesGet as Agent, ConfigItem and Ticket provide this method
            if ( $ObjectTypeObject->can('ObjectAttributesGet') ) {
                my %ObjectTypeAttributes = $ObjectTypeObject->ObjectAttributesGet(
                    EditMask      => 1,
                    DynamicFields => 1,
                );
                %EqualsObjectFilterableAttributes = map { $ObjectTypeAttributes{$_} ? ( $_ => $_ ) : () } keys %ObjectTypeAttributes;
            }
            else {
                %EqualsObjectFilterableAttributes = _ObjectAttributesGet( ObjectName => $ObjectTypeObjectName );
            }
            $EqualsObjectFilterableAttributes{UserID} = 'UserID';
        }
    }

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            %Param,
            FieldTypeSettings                   => \@FieldTypeSettings,
            EqualsObjectFilterableAttributes    => \%EqualsObjectFilterableAttributes,
            ReferenceObjectFilterableAttributes => \%ReferenceObjectFilterableAttributes,
        );
    }

    if ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddAction(
            %Param,
            FieldTypeSettings                   => \@FieldTypeSettings,
            EqualsObjectFilterableAttributes    => \%EqualsObjectFilterableAttributes,
            ReferenceObjectFilterableAttributes => \%ReferenceObjectFilterableAttributes,
        );
    }

    if ( $Self->{Subaction} eq 'Change' ) {
        return $Self->_Change(
            %Param,
            FieldTypeSettings                   => \@FieldTypeSettings,
            EqualsObjectFilterableAttributes    => \%EqualsObjectFilterableAttributes,
            ReferenceObjectFilterableAttributes => \%ReferenceObjectFilterableAttributes,
        );
    }

    if ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
            FieldTypeSettings                   => \@FieldTypeSettings,
            EqualsObjectFilterableAttributes    => \%EqualsObjectFilterableAttributes,
            ReferenceObjectFilterableAttributes => \%ReferenceObjectFilterableAttributes,
        );
    }

    return $LayoutObject->ErrorScreen(
        Message => Translatable('Undefined subaction.'),
    );
}

sub _Add {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %GetParam;

    # check if we clone from an existing field
    my $CloneFieldID = $ParamObject->GetParam( Param => "CloneFieldID" );
    if ($CloneFieldID) {
        my $FieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
            ID => $CloneFieldID,
        );

        # if we found a field config, copy its content for usage in _ShowScreen
        if ( IsHashRefWithData($FieldConfig) ) {

            # copy standard stuff
            for my $Key (qw(ObjectType FieldType Label Name ValidID)) {
                $GetParam{$Key} = $FieldConfig->{$Key};
            }

            # iterate over special stuff and copy in-depth content as flat list
            CONFIGKEY:
            for my $ConfigKey ( keys $FieldConfig->{Config}->%* ) {
                next CONFIGKEY if $ConfigKey eq 'PartOfSet';

                my $DFDetails = $FieldConfig->{Config};
                $GetParam{$ConfigKey} = $DFDetails->{$ConfigKey};
            }
        }
        $GetParam{CloneFieldID} = $CloneFieldID;
    }

    for my $Needed (qw(ObjectType FieldType FieldOrder)) {
        $GetParam{$Needed} //= $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Needed ),
            );
        }
    }

    for my $FilterParam (qw(ObjectTypeFilter NamespaceFilter)) {
        $GetParam{$FilterParam} = $ParamObject->GetParam( Param => $FilterParam );
    }

    # extract field type specific parameters, e.g. MultiValue
    SETTING:
    for my $Setting ( $Param{FieldTypeSettings}->@* ) {

        # skip custom inputs which are handled separately
        # currently only used for reference filter list
        next SETTING if !$Setting->{InputType};

        my $Name = $Setting->{ConfigParamName};
        if ( $Setting->{Multiple} && !defined $GetParam{$Name} ) {
            $GetParam{$Name}->@* = $ParamObject->GetArray( Param => $Name );
        }
        else {
            $GetParam{$Name} //= $ParamObject->GetParam( Param => $Name );
        }

        # validate input if necessary
        if ( $Setting->{Mandatory} ) {
            if ( !$GetParam{$Name} || ( $Setting->{Multiple} && !$GetParam{$Name}->@* ) ) {
                return $LayoutObject->ErrorScreen(
                    Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Name ),
                );
            }
        }
    }

    # get the object type and field type display name
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $ObjectTypeName = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName  = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName}      || '';

    # check namespace validity
    my $Namespaces = $ConfigObject->Get('DynamicField::Namespaces');
    my $Namespace  = '';
    if ( IsArrayRefWithData($Namespaces) && $GetParam{NamespaceFilter} ) {
        $Namespace = ( grep { $_ eq $GetParam{NamespaceFilter} } $Namespaces->@* ) ? $GetParam{NamespaceFilter} : '';
    }

    return $Self->_ShowScreen(
        %Param,
        %GetParam,
        Mode           => 'Add',
        BreadcrumbText => $LayoutObject->{LanguageObject}->Translate( 'Add %s field', $LayoutObject->{LanguageObject}->Translate($FieldTypeName) ),
        ObjectTypeName => $ObjectTypeName,
        FieldTypeName  => $FieldTypeName,
    );
}

sub _AddAction {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %Errors;
    my %GetParam;
    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required.');
        }
    }

    # extract field type specific parameters, e.g. MultiValue
    SETTING:
    for my $Setting ( $Param{FieldTypeSettings}->@* ) {

        # skip custom inputs which are handled separately
        # currently only used for reference filter list
        next SETTING if !$Setting->{InputType};

        my $Name = $Setting->{ConfigParamName};
        if ( $Setting->{Multiple} ) {
            $GetParam{$Name}->@* = $ParamObject->GetArray( Param => $Name );
        }
        else {
            $GetParam{$Name} = $ParamObject->GetParam( Param => $Name );
        }

        # validate input if necessary
        if ( $Setting->{Mandatory} ) {
            if ( !$GetParam{$Name} || ( $Setting->{Multiple} && !$GetParam{$Name}->@* ) ) {
                $Errors{ $Name . 'ServerError' }        = 'ServerError';
                $Errors{ $Name . 'ServerErrorMessage' } = Translatable('This field is required.');
            }
        }
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    if ( $GetParam{FieldOrder} ) {

        # check if field order is numeric and positive
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = Translatable('The field must be numeric.');
        }
    }

    for my $ConfigParam (
        qw(ObjectType ObjectTypeName FieldType FieldTypeName ValidID Tooltip Namespace
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    for my $FilterParam (qw(ObjectTypeFilter NamespaceFilter)) {
        $GetParam{$FilterParam} = $ParamObject->GetParam( Param => $FilterParam );
    }

    if ( $GetParam{Name} ) {

        # check if name is alphanumeric
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

        $GetParam{Name} = $GetParam{Namespace} ? $GetParam{Namespace} . '-' . $GetParam{Name} : $GetParam{Name};

        # check if name is duplicated
        my %DynamicFieldsList = %{
            $DynamicFieldObject->DynamicFieldList(
                Valid      => 0,
                ResultType => 'HASH',
            )
        };

        %DynamicFieldsList = reverse %DynamicFieldsList;

        if ( $DynamicFieldsList{ $GetParam{Name} } ) {

            # add server error error class
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = Translatable('There is another field with the same name.');
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

    # return to add screen if errors
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            Mode => 'Add',
        );
    }

    # set specific config
    my %FieldConfig = (
        Tooltip => $GetParam{Tooltip},
    );

    # extract field type specific parameters, e.g. MultiValue
    SETTING:
    for my $Setting ( $Param{FieldTypeSettings}->@* ) {

        # skip custom inputs which are handled separately
        # currently only used for reference filter list
        next SETTING if !$Setting->{InputType};

        my $Name = $Setting->{ConfigParamName};
        $FieldConfig{$Name} = $GetParam{$Name};
    }

    # interdependencies of multiselect, multivalue and editfieldmode
    # set multiselect key for consistency in backend
    $FieldConfig{Multiselect} = $FieldConfig{EditFieldMode} eq 'Multiselect' ? 1 : 0;

    # differentiate only between autocomplete and dropdown
    $FieldConfig{EditFieldMode} = $FieldConfig{EditFieldMode} eq 'AutoComplete' ? 'AutoComplete' : 'Dropdown';

    # multiselect excludes multivalue
    $FieldConfig{MultiValue} = $FieldConfig{Multiselect} ? 0 : $FieldConfig{MultiValue};

    if ( any { $_->{ConfigParamName} eq 'ReferenceFilterList' } $Param{FieldTypeSettings}->@* ) {
        $GetParam{ReferenceFilterCounter} = $ParamObject->GetParam( Param => 'ReferenceFilterCounter' ) || 0;

        my @ReferenceFilterList = $Self->_GetParamReferenceFilterList(
            GetParam => \%GetParam,
            Errors   => \%Errors,
        );

        $FieldConfig{ReferenceFilterList} = \@ReferenceFilterList;
    }

    # create a new field
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $GetParam{FieldType},
        ObjectType => $GetParam{ObjectType},
        Config     => \%FieldConfig,
        ValidID    => $GetParam{ValidID},
        UserID     => $Self->{UserID},
    );

    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not create the new field'),
        );
    }

    my $RedirectString = "Action=AdminDynamicField";

    if ( IsStringWithData( $GetParam{ObjectTypeFilter} ) ) {
        $RedirectString .= ";ObjectTypeFilter=" . $LayoutObject->Output(
            Template => '[% Data.Filter | uri %]',
            Data     => {
                Filter => $GetParam{ObjectTypeFilter},
            },
        );
    }
    if ( IsStringWithData( $GetParam{NamespaceFilter} ) ) {
        $RedirectString .= ";NamespaceFilter=" . $LayoutObject->Output(
            Template => '[% Data.Filter | uri %]',
            Data     => {
                Filter => $GetParam{NamespaceFilter},
            },
        );
    }

    return $LayoutObject->Redirect( OP => $RedirectString );
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %GetParam;
    for my $Needed (qw(ObjectType FieldType)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Needed ),
            );
        }
    }

    for my $FilterParam (qw(ObjectTypeFilter NamespaceFilter)) {
        $GetParam{$FilterParam} = $ParamObject->GetParam( Param => $FilterParam );
    }

    # get the object type and field type display name
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $ObjectTypeName = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName  = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName}      || '';

    my $FieldID = $ParamObject->GetParam( Param => 'ID' );
    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ID'),
        );
    }

    # get dynamic field data
    my $DynamicFieldData = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        ID => $FieldID,
    );

    # check for valid dynamic field configuration
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for dynamic field %s', $FieldID ),
        );
    }

    my %Config;

    # extract configuration
    if ( IsHashRefWithData( $DynamicFieldData->{Config} ) ) {
        %Config = $DynamicFieldData->{Config}->%*;
    }

    return $Self->_ShowScreen(
        %Param,
        %GetParam,
        $DynamicFieldData->%*,
        %Config,
        ID             => $FieldID,
        Mode           => 'Change',
        BreadcrumbText => $LayoutObject->{LanguageObject}->Translate( 'Change %s field', $LayoutObject->{LanguageObject}->Translate($FieldTypeName) ),
        ObjectTypeName => $ObjectTypeName,
        FieldTypeName  => $FieldTypeName,
    );
}

sub _ChangeAction {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FieldID = $ParamObject->GetParam( Param => 'ID' );
    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ID'),
        );
    }

    my %Errors;
    my %GetParam;
    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required.');
        }
    }

    # extract field type specific parameters, e.g. MultiValue
    SETTING:
    for my $Setting ( $Param{FieldTypeSettings}->@* ) {

        # skip custom inputs which are handled separately
        # currently only used for reference filter list
        next SETTING if !$Setting->{InputType};

        my $Name = $Setting->{ConfigParamName};
        if ( $Setting->{Multiple} ) {
            $GetParam{$Name}->@* = $ParamObject->GetArray( Param => $Name );
        }
        else {
            $GetParam{$Name} = $ParamObject->GetParam( Param => $Name );
        }

        # validate input if necessary
        if ( $Setting->{Mandatory} ) {
            if ( !defined $GetParam{$Name} || ( $Setting->{Multiple} && !$GetParam{$Name}->@* ) ) {
                $Errors{ $Name . 'ServerError' }        = 'ServerError';
                $Errors{ $Name . 'ServerErrorMessage' } = Translatable('This field is required.');
            }
        }
    }

    # get dynamic field data
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldData   = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    # check for valid dynamic field configuration
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for dynamic field %s', $FieldID ),
        );
    }

    if ( $GetParam{FieldOrder} ) {

        # check if field order is numeric and positive
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = Translatable('The field must be numeric.');
        }
    }

    for my $ConfigParam (
        qw(ObjectType ObjectTypeName FieldType FieldTypeName ValidID Tooltip Namespace
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    for my $FilterParam (qw(ObjectTypeFilter NamespaceFilter)) {
        $GetParam{$FilterParam} = $ParamObject->GetParam( Param => $FilterParam );
    }

    if ( $GetParam{Name} ) {

        # check if name is lowercase
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

        $GetParam{Name} = $GetParam{Namespace} ? $GetParam{Namespace} . '-' . $GetParam{Name} : $GetParam{Name};

        # check if name is duplicated
        my %DynamicFieldsList = %{
            $DynamicFieldObject->DynamicFieldList(
                Valid      => 0,
                ResultType => 'HASH',
            )
        };

        %DynamicFieldsList = reverse %DynamicFieldsList;

        if (
            $DynamicFieldsList{ $GetParam{Name} } &&
            $DynamicFieldsList{ $GetParam{Name} } ne $FieldID
            )
        {

            # add server error class
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = Translatable('There is another field with the same name.');
        }

        # if it's an internal field, it's name should not change
        if (
            $DynamicFieldData->{InternalField} &&
            $DynamicFieldsList{ $GetParam{Name} } ne $FieldID
            )
        {

            # add server error class
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = Translatable('The name for this field should not change.');
            $Param{InternalField}           = $DynamicFieldData->{InternalField};
        }
    }

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

    # Check if dynamic field is present in SysConfig setting
    my $UpdateEntity              = $ParamObject->GetParam( Param => 'UpdateEntity' ) || '';
    my $SysConfigObject           = $Kernel::OM->Get('Kernel::System::SysConfig');
    my %DynamicFieldOldData       = %{$DynamicFieldData};
    my @IsDynamicFieldInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
        EntityType => 'DynamicField',
        EntityName => $DynamicFieldData->{Name},
    );
    if (@IsDynamicFieldInSysConfig) {

        # An entity present in SysConfig couldn't be invalidated.
        if (
            $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $GetParam{ValidID} )
            ne 'valid'
            )
        {
            $Errors{ValidIDInvalid}         = 'ServerError';
            $Errors{ValidOptionServerError} = 'InSetting';
        }

        # In case changing name an authorization (UpdateEntity) should be sent
        elsif ( $DynamicFieldData->{Name} ne $GetParam{Name} && !$UpdateEntity ) {
            $Errors{NameInvalid}              = 'ServerError';
            $Errors{InSettingNameServerError} = 1;
        }
    }

    # return to change screen if errors
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            ID   => $FieldID,
            Mode => 'Change',
        );
    }

    # set specific config
    my %FieldConfig = (
        Tooltip => $GetParam{Tooltip},
    );

    # extract field type specific parameters, e.g. MultiValue
    SETTING:
    for my $Setting ( $Param{FieldTypeSettings}->@* ) {

        # skip custom inputs which are handled separately
        # currently only used for reference filter list
        next SETTING if !$Setting->{InputType};

        my $Name = $Setting->{ConfigParamName};
        $FieldConfig{$Name} = $GetParam{$Name};
    }

    # interdependencies of multiselect, multivalue and editfieldmode
    # set multiselect key for consistency in backend
    $FieldConfig{Multiselect} = $FieldConfig{EditFieldMode} eq 'Multiselect' ? 1 : 0;

    # differentiate only between autocomplete and dropdown
    $FieldConfig{EditFieldMode} = $FieldConfig{EditFieldMode} eq 'AutoComplete' ? 'AutoComplete' : 'Dropdown';

    # multiselect excludes multivalue
    $FieldConfig{MultiValue} = $FieldConfig{Multiselect} ? 0 : $FieldConfig{MultiValue};

    if ( any { $_->{ConfigParamName} eq 'ReferenceFilterList' } $Param{FieldTypeSettings}->@* ) {
        $GetParam{ReferenceFilterCounter} = $ParamObject->GetParam( Param => 'ReferenceFilterCounter' ) || 0;

        my @ReferenceFilterList = $Self->_GetParamReferenceFilterList(
            GetParam => \%GetParam,
            Errors   => \%Errors,
        );

        $FieldConfig{ReferenceFilterList} = \@ReferenceFilterList;
    }

    # update dynamic field (FieldType and ObjectType cannot be changed; use old values)
    my $UpdateSuccess = $DynamicFieldObject->DynamicFieldUpdate(
        ID         => $FieldID,
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $DynamicFieldData->{FieldType},
        ObjectType => $DynamicFieldData->{ObjectType},
        Config     => \%FieldConfig,
        ValidID    => $GetParam{ValidID},
        UserID     => $Self->{UserID},
    );

    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Could not update the field %s', $GetParam{Name} ),
        );
    }

    if (
        @IsDynamicFieldInSysConfig
        && $DynamicFieldOldData{Name} ne $GetParam{Name}
        && $UpdateEntity
        )
    {
        SETTING:
        for my $SettingName (@IsDynamicFieldInSysConfig) {

            my %Setting = $SysConfigObject->SettingGet(
                Name => $SettingName,
            );

            next SETTING if !IsHashRefWithData( \%Setting );

            $Setting{EffectiveValue} =~ s/$DynamicFieldOldData{Name}/$GetParam{Name}/g;

            my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                Name   => $Setting{Name},
                Force  => 1,
                UserID => $Self->{UserID}
            );
            $Setting{ExclusiveLockGUID} = $ExclusiveLockGUID;

            $SysConfigObject->SettingUpdate(
                %Setting,
                UserID => $Self->{UserID},
            );
        }

        $SysConfigObject->ConfigurationDeploy(
            Comments      => "DynamicField name change",
            DirtySettings => \@IsDynamicFieldInSysConfig,
            UserID        => $Self->{UserID},
            Force         => 1,
        );
    }

    my $FilterString = '';

    if ( IsStringWithData( $GetParam{ObjectTypeFilter} ) ) {
        $FilterString .= ";ObjectTypeFilter=" . $LayoutObject->Output(
            Template => '[% Data.Filter | uri %]',
            Data     => {
                Filter => $GetParam{ObjectTypeFilter},
            },
        );
    }
    if ( IsStringWithData( $GetParam{NamespaceFilter} ) ) {
        $FilterString .= ";NamespaceFilter=" . $LayoutObject->Output(
            Template => '[% Data.Filter | uri %]',
            Data     => {
                Filter => $GetParam{NamespaceFilter},
            },
        );
    }

    # if the user would like to continue editing the dynamic field, just redirect to the change screen
    if (
        defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
        && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
        )
    {
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=Change;ObjectType=$DynamicFieldData->{ObjectType};FieldType=$DynamicFieldData->{FieldType};ID=$FieldID$FilterString"
        );
    }
    else {

        # otherwise return to overview
        return $LayoutObject->Redirect( OP => "Action=AdminDynamicField$FilterString" );
    }
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    my $Namespace = $Param{Namespace};
    $Param{DisplayFieldName} = 'New';

    if ( $Param{Mode} eq 'Change' || $Param{Name} ) {

        if ( !$Param{CloneFieldID} ) {
            $Param{ShowWarning}      = 'ShowWarning';
            $Param{DisplayFieldName} = $Param{Name};
        }

        # check for namespace
        if ( $Param{Name} =~ /(.*)-(.*)/ ) {
            $Namespace = $1;
            $Param{PlainFieldName} = $2 unless $Param{CloneFieldID};
        }
        else {
            $Param{PlainFieldName} = $Param{Name};
        }
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get all fields
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid => 0,
    );

    # get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    my %DynamicfieldNamesList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
        $DynamicfieldNamesList{ $Dynamicfield->{FieldOrder} } = $Dynamicfield->{Label};
    }

    # when adding we need to create an extra order number for the new field
    if ( $Param{Mode} eq 'Add' ) {

        # get the last element from the order list and add 1
        my $LastOrderNumber = $DynamicfieldOrderList[-1];
        $LastOrderNumber++;

        # add this new order number to the end of the list
        push @DynamicfieldOrderList, $LastOrderNumber;
    }

    # show the names of the other fields to ease ordering
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my %OrderNamesList;
    my $CurrentlyText = $LayoutObject->{LanguageObject}->Translate('Currently') . ': ';
    for my $OrderNumber ( sort @DynamicfieldOrderList ) {
        $OrderNamesList{$OrderNumber} = $OrderNumber;
        if ( $DynamicfieldNamesList{$OrderNumber} && $OrderNumber ne $Param{FieldOrder} ) {
            $OrderNamesList{$OrderNumber} = $OrderNumber . ' - '
                . $CurrentlyText
                . $DynamicfieldNamesList{$OrderNumber};
        }
    }

    my $DynamicFieldOrderStrg = $LayoutObject->BuildSelection(
        Data          => \%OrderNamesList,
        Name          => 'FieldOrder',
        SelectedValue => $Param{FieldOrder} || 1,
        PossibleNone  => 0,
        Translation   => 0,
        Sort          => 'NumericKey',
        Class         => 'Modernize W75pc Validate_Number',
    );

    # compute value for editfieldmode to maintain frontend selection
    $Param{EditFieldMode} //= '';
    $Param{EditFieldMode} = $Param{EditFieldMode} eq 'AutoComplete' ? 'AutoComplete' : ( $Param{Multiselect} ? 'Multiselect' : 'Dropdown' );

    # Add field type specific inputs. Currently only Selections are supported.
    # Selections may be set up in a declarative way.
    SETTING:
    for my $Setting ( $Param{FieldTypeSettings}->@* ) {
        next SETTING unless $Setting->{InputType};

        if ( $Setting->{InputType} eq 'Selection' ) {
            my $Name       = $Setting->{ConfigParamName};
            my @CssClasses = qw(Modernize W50pc);
            push @CssClasses, $Setting->{Mandatory}           ? 'Validate_Required' : ();
            push @CssClasses, $Param{ $Name . 'ServerError' } ? 'ServerError'       : ();
            my $FieldStrg = $LayoutObject->BuildSelection(
                Name           => $Name,
                Data           => $Setting->{SelectionData},
                PossibleNone   => ( $Setting->{PossibleNone} // 0 ),
                Disabled       => ( $Setting->{Disabled}     // 0 ),
                SelectedID     => $Param{$Name} || '0',
                Class          => ( join ' ', @CssClasses ),
                Multiple       => ( $Setting->{Multiple}    // 0 ),
                TreeView       => ( $Setting->{TreeView}    // 0 ),
                Sort           => ( $Setting->{Sort}        // 0 ),
                SortReverse    => ( $Setting->{SortReverse} // 0 ),
                SortIndividual => $Setting->{SortIndividual},
            );
            $LayoutObject->Block(
                Name => 'ConfigParamRow',
                Data => {
                    ConfigParamName    => $Name,
                    Label              => $Setting->{Label},
                    FieldStrg          => $FieldStrg,
                    Explanation        => $Setting->{Explanation},
                    ServerErrorMessage => $Param{ $Name . 'ServerErrorMessage' },
                },
            );

            next SETTING;
        }

        # more input types might be supported in future
    }

    my $NamespaceList = $Kernel::OM->Get('Kernel::Config')->Get('DynamicField::Namespaces');
    if ( IsArrayRefWithData($NamespaceList) ) {
        my $NamespaceStrg = $LayoutObject->BuildSelection(
            Data          => $NamespaceList,
            Name          => 'Namespace',
            SelectedValue => $Namespace || '',
            PossibleNone  => 1,
            Translation   => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize W50pc',
        );

        $LayoutObject->Block(
            Name => 'DynamicFieldNamespace',
            Data => {
                NamespaceStrg => $NamespaceStrg,
            },
        );
    }

    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    # create the Validity select
    my $ValidityStrg = $LayoutObject->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $Param{ValidID} || 1,
        PossibleNone => 0,
        Translation  => 1,
        Class        => 'Modernize W50pc Validate_Required',
    );

    # define config field specific settings

    # define tooltip
    my $Tooltip = $Param{Tooltip} // '';

    # create the default value element
    $LayoutObject->Block(
        Name => 'Tooltip',
        Data => {
            %Param,
            Tooltip => $Tooltip,
        },
    );

    my $ReadonlyInternalField = '';

    # Internal fields can not be deleted and name should not change.
    if ( $Param{InternalField} ) {
        $LayoutObject->Block(
            Name => 'InternalField',
            Data => {%Param},
        );
        $ReadonlyInternalField = 'readonly';
    }

    # render reference filter list only if enabled
    if (
        any {
            $_->{ConfigParamName} eq 'ReferenceFilterList'
        }
        $Param{FieldTypeSettings}->@*
        )
    {

        # build attributes selections for template filter row
        $Param{'ReferenceFilter_EqualsObjectAttributeStrg'} = $LayoutObject->BuildSelection(
            Data         => $Param{EqualsObjectFilterableAttributes},
            Name         => 'ReferenceFilter_EqualsObjectAttribute',
            PossibleNone => 1,
            Translation  => 0,
            Sort         => 'AlphanumericValue',
            Class        => 'Modernize W75pc',
        );
        $Param{'ReferenceFilter_ReferenceObjectAttributeStrg'} = $LayoutObject->BuildSelection(
            Data         => $Param{ReferenceObjectFilterableAttributes},
            Name         => 'ReferenceFilter_ReferenceObjectAttribute',
            PossibleNone => 1,
            Translation  => 0,
            Sort         => 'AlphanumericValue',
            Class        => 'Modernize W75pc',
        );

        if ( !$Param{ReferenceFilterCounter} ) {

            my $ReferenceFilterCounter = 0;
            for my $ReferenceFilter ( @{ $Param{ReferenceFilterList} } ) {

                $ReferenceFilterCounter++;
                for my $FilterItem (qw(ReferenceObjectAttribute EqualsObjectAttribute EqualsString)) {
                    $Param{ 'ReferenceFilter_' . $FilterItem . '_' . $ReferenceFilterCounter } = $ReferenceFilter->{$FilterItem};
                }

                # NOTE SelectedID is necessary because e.g. for tickets key and value are different
                $Param{ 'ReferenceFilter_EqualsObjectAttributeStrg_' . $ReferenceFilterCounter } = $LayoutObject->BuildSelection(
                    Data         => $Param{EqualsObjectFilterableAttributes},
                    Name         => 'ReferenceFilter_EqualsObjectAttribute_' . $ReferenceFilterCounter,
                    SelectedID   => $Param{ 'ReferenceFilter_EqualsObjectAttribute_' . $ReferenceFilterCounter } || '',
                    PossibleNone => 1,
                    Translation  => 0,
                    Sort         => 'AlphanumericValue',
                    Class        => 'Modernize W75pc',
                );
                $Param{ 'ReferenceFilter_ReferenceObjectAttributeStrg_' . $ReferenceFilterCounter } = $LayoutObject->BuildSelection(
                    Data         => $Param{ReferenceObjectFilterableAttributes},
                    Name         => 'ReferenceFilter_ReferenceObjectAttribute_' . $ReferenceFilterCounter,
                    SelectedID   => $Param{ 'ReferenceFilter_ReferenceObjectAttribute_' . $ReferenceFilterCounter } || '',
                    PossibleNone => 1,
                    Translation  => 0,
                    Sort         => 'AlphanumericValue',
                    Class        => 'Modernize W75pc',
                );
            }

            $Param{ReferenceFilterCounter} = $ReferenceFilterCounter;
        }

        $LayoutObject->Block(
            Name => 'ReferenceFilterList',
            Data => {
                %Param,
            },
        );

        if ( $Param{ReferenceFilterCounter} ) {

            REFERENCEFILTERENTRY:
            for my $CurrentReferenceFilterEntryID ( 1 .. $Param{ReferenceFilterCounter} ) {

                # check existing filter
                my %FilterRow;
                my %Errors;
                for my $FilterItem (qw(ReferenceObjectAttribute ReferenceObjectAttributeStrg EqualsObjectAttribute EqualsObjectAttributeStrg EqualsString)) {
                    $FilterRow{ 'ReferenceFilter_' . $FilterItem } = $Param{ 'ReferenceFilter_' . $FilterItem . '_' . $CurrentReferenceFilterEntryID };
                }

                # skip if values are undef
                next REFERENCEFILTERENTRY if !grep { defined $_ } values %FilterRow;

                $LayoutObject->Block(
                    Name => 'ReferenceFilterRow',
                    Data => {
                        %FilterRow,
                        %Errors,
                        EntryCounter => $CurrentReferenceFilterEntryID,
                    }
                );
            }
        }
    }

    # get the dynamic field id
    my $FieldID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ID' );

    # only if the dymamic field exists and should be edited,
    # not if the field is added for the first time
    if ($FieldID) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $FieldID,
        );

        my $DynamicFieldName = $DynamicField->{Name};

        # Add warning in case the DynamicField belongs a SysConfig setting.
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # In case dirty setting disable form
        my $IsDirtyConfig = 0;
        my @IsDirtyResult = $SysConfigObject->ConfigurationDirtySettingsList();
        my %IsDirtyList   = map { $_ => 1 } @IsDirtyResult;

        my @IsDynamicFieldInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
            EntityType => 'DynamicField',
            EntityName => $DynamicFieldName // '',
        );

        if (@IsDynamicFieldInSysConfig) {
            $LayoutObject->Block(
                Name => 'DynamicFieldInSysConfig',
                Data => {
                    OldName => $DynamicFieldName,
                },
            );
            for my $SettingName (@IsDynamicFieldInSysConfig) {
                $LayoutObject->Block(
                    Name => 'DynamicFieldInSysConfigRow',
                    Data => {
                        SettingName => $SettingName,
                    },
                );

                # Verify if dirty setting
                if ( $IsDirtyList{$SettingName} ) {
                    $IsDirtyConfig = 1;
                }

            }
        }

        if ($IsDirtyConfig) {
            $LayoutObject->Block(
                Name => 'DynamicFieldInSysConfigDirty',

            );
        }
    }

    my $FilterStrg = '';
    if ( IsStringWithData( $Param{ObjectTypeFilter} ) ) {
        $FilterStrg .= ";ObjectTypeFilter=" . $LayoutObject->Output(
            Template => '[% Data.Filter | uri %]',
            Data     => {
                Filter => $Param{ObjectTypeFilter},
            },
        );
    }

    if ( IsArrayRefWithData($NamespaceList) ) {
        if ( IsStringWithData( $Param{NamespaceFilter} ) ) {
            $FilterStrg .= ";NamespaceFilter=" . $LayoutObject->Output(
                Template => '[% Data.Filter | uri %]',
                Data     => {
                    Filter => $Param{NamespaceFilter},
                },
            );
        }
    }

    # generate output
    return join '',
        $LayoutObject->Header,
        $LayoutObject->NavigationBar,
        $LayoutObject->Output(
            TemplateFile => $Self->{TemplateFile},
            Data         => {
                %Param,
                FilterStrg            => $FilterStrg,
                ValidityStrg          => $ValidityStrg,
                DynamicFieldOrderStrg => $DynamicFieldOrderStrg,
                ReadonlyInternalField => $ReadonlyInternalField,
                Tooltip               => $Tooltip,
            },
        ),
        $LayoutObject->Footer;
}

sub _GetParamReferenceFilterList {
    my ( $Self, %Param ) = @_;

    my $GetParam = $Param{GetParam};
    my @ReferenceFilterList;

    # Check reference filter list
    if ( $GetParam->{ReferenceFilterCounter} && $GetParam->{ReferenceFilterCounter} =~ m{\A\d+\z}xms ) {

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        REFERENCEFILTERENTRY:
        for my $CurrentReferenceFilterEntryID ( 1 .. $GetParam->{ReferenceFilterCounter} ) {

            # check existing reference filter
            my %FilterRow;
            for my $FilterItem (qw(ReferenceObjectAttribute EqualsObjectAttribute EqualsString)) {
                $GetParam->{ 'ReferenceFilter_' . $FilterItem . '_' . $CurrentReferenceFilterEntryID }
                    = $ParamObject->GetParam( Param => 'ReferenceFilter_' . $FilterItem . '_' . $CurrentReferenceFilterEntryID );
                $FilterRow{$FilterItem} = $GetParam->{ 'ReferenceFilter_' . $FilterItem . '_' . $CurrentReferenceFilterEntryID };
            }

            # skip if filter values are undef
            next REFERENCEFILTERENTRY if !grep { defined $_ } values %FilterRow;

            # is the reference filter valid?
            # TODO Check selects also
            # my $ReferenceFilterCheck = eval {
            #     qr{$ReferenceFilter}xms;
            # };

            my $CurrentEntryErrors = 0;

            # if ($@) {
            #     $Errors->{ 'ReferenceFilter_' . $CurrentReferenceFilterEntryID . 'ServerError' } = 'ServerError';

            #     # cut last part of regex error
            #     # 'Invalid regular expression (Unmatched [ in regex; marked by
            #     # <-- HERE in m/aaa[ <-- HERE / at
            #     # /opt/otobo/bin/cgi-bin/../../Kernel/Modules/AdminDynamicFieldText.pm line 452..
            #     my $ServerErrorMessage = $@;
            #     $ServerErrorMessage =~ s{ (in \s regex); .*$ }{ $1 }xms;
            #     $Errors->{ 'ReferenceFilter_' . $CurrentReferenceFilterEntryID . 'ServerErrorMessage' } = $ServerErrorMessage;

            #     $CurrentEntryErrors = 1;
            # }

            # # check required error message for regex
            # if ( !$CustomerReferenceFilterErrorMessage ) {
            #     $Errors->{ 'CustomerReferenceFilterErrorMessage_' . $CurrentReferenceFilterEntryID . 'ServerError' } = 'ServerError';
            #     $Errors->{
            #         'CustomerReferenceFilterErrorMessage_'
            #             . $CurrentReferenceFilterEntryID
            #             . 'ServerErrorMessage'
            #     } = Translatable('This field is required.');

            #     $CurrentEntryErrors = 1;
            # }

            next REFERENCEFILTERENTRY if $CurrentEntryErrors;

            push @ReferenceFilterList, \%FilterRow;
        }
    }

    return @ReferenceFilterList;
}

# fallback method to fetch attributes for objects which do not provide sub ObjectAttributesGet()
sub _ObjectAttributesGet {
    my (%Param) = @_;

    return unless $Param{ObjectName};

    my @ObjectData;
    if ( $Param{ObjectName} eq 'CustomerCompany' ) {
        @ObjectData = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanySearchFields();
    }
    elsif ( $Param{ObjectName} eq 'CustomerUser' ) {
        @ObjectData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserSearchFields();
    }

    my %MappedData = map { $_->{Name} => $_->{Label} } @ObjectData;

    return %MappedData;
}

1;
