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

package Kernel::Modules::AdminDynamicFieldLens;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = bless {%Param}, $Type;

    # Some setup
    $Self->{TemplateFile} = 'AdminDynamicFieldLens';

    # declare the field type specific settings
    $Self->{FieldTypeSettings} = {
        Lens => [
            {
                ConfigParamName => 'ReferenceDF',
                Label           => Translatable('The referenced dynamic field'),
                Explanation     => Translatable('Select the dynamic field that references an object'),
                InputType       => 'Text',
            },
            {
                ConfigParamName => 'AttributeDF',
                Label           => Translatable('The attribute of the referenced object'),
                Explanation     => Translatable('Select the attribute dynamic field that references an object'),
                InputType       => 'Text',
            },
        ],
    };

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

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            %Param,
        );
    }

    if ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddAction(
            %Param,
        );
    }

    if ( $Self->{Subaction} eq 'Change' ) {
        return $Self->_Change(
            %Param,
        );
    }

    if ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
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
    my $CloneFieldID = $ParamObject->GetParam( Param => "ID" );
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
                if ( $ConfigKey eq 'ReferenceDF' || $ConfigKey eq 'AttributeDF' ) {
                    my $FieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                        ID => $DFDetails->{$ConfigKey},
                    );
                    $GetParam{$ConfigKey} = $FieldConfig->{Name};
                }
                else {
                    $GetParam{$ConfigKey} = $DFDetails->{$ConfigKey};
                }
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
        Namespace      => $Namespace,
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

    # extract field type specific parameters, e.g. MultiValue
    my $FieldType = $GetParam{FieldType};
    if ( $Self->{FieldTypeSettings}->{$FieldType} ) {
        for my $Setting ( $Self->{FieldTypeSettings}->{$FieldType}->@* ) {
            my $Name = $Setting->{ConfigParamName};
            $GetParam{$Name} = $ParamObject->GetParam( Param => $Name );
        }
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

    # set specific config
    my %FieldConfig = (
        Tooltip => $GetParam{Tooltip},
    );

    # extract field type specific parameters, e.g. MultiValue
    if ( $Self->{FieldTypeSettings}->{$FieldType} ) {
        for my $Setting ( $Self->{FieldTypeSettings}->{$FieldType}->@* ) {
            my $Name = $Setting->{ConfigParamName};
            $FieldConfig{$Name} = $GetParam{$Name};
        }
    }

    # store the name for easier ajax evaluation
    $FieldConfig{ReferenceDFName} = 'DynamicField_' . $FieldConfig{ReferenceDF};

    for my $ConfigDF (qw/ReferenceDF AttributeDF/) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $FieldConfig{$ConfigDF},
        );

        # show error message
        if ( !IsHashRefWithData($DynamicField) ) {
            $Errors{ $ConfigDF . 'ServerError' }        = 'ServerError';
            $Errors{ $ConfigDF . 'ServerErrorMessage' } = Translatable('Not a valid dynamic field.');
        }

        # store the ID
        $FieldConfig{$ConfigDF} = $DynamicField->{ID};
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

    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

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
    my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
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

    # show dynamic field names instead of IDs
    for my $ConfigDF (qw/ReferenceDF AttributeDF/) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $Config{$ConfigDF},
        );

        # translate to name
        $Config{$ConfigDF} = $DynamicField->{Name};
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

    my %Errors;
    my %GetParam;
    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required.');
        }
    }

    my $FieldID = $ParamObject->GetParam( Param => 'ID' );
    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ID'),
        );
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get dynamic field data
    my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
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

    # extract field type specific parameters, e.g. MultiValue
    my $FieldType = $GetParam{FieldType};
    if ( $Self->{FieldTypeSettings}->{$FieldType} ) {
        for my $Setting ( $Self->{FieldTypeSettings}->{$FieldType}->@* ) {
            my $Name = $Setting->{ConfigParamName};
            $GetParam{$Name} = $ParamObject->GetParam( Param => $Name );
        }
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

    # set specific config
    my %FieldConfig = (
        Tooltip => $GetParam{Tooltip},
    );

    # extract field type specific parameters, e.g. MultiValue
    if ( $Self->{FieldTypeSettings}->{$FieldType} ) {
        for my $Setting ( $Self->{FieldTypeSettings}->{$FieldType}->@* ) {
            my $Name = $Setting->{ConfigParamName};
            $FieldConfig{$Name} = $ParamObject->GetParam( Param => $Name );
        }
    }

    # store the name for easier ajax evaluation
    $FieldConfig{ReferenceDFName} = 'DynamicField_' . $FieldConfig{ReferenceDF};

    for my $ConfigDF (qw/ReferenceDF AttributeDF/) {
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $FieldConfig{$ConfigDF},
        );

        # show error message
        if ( !IsHashRefWithData($DynamicField) ) {
            $Errors{ $ConfigDF . 'ServerError' }        = 'ServerError';
            $Errors{ $ConfigDF . 'ServerErrorMessage' } = Translatable('Not a valid dynamic field.');
        }

        # store the ID
        $FieldConfig{$ConfigDF} = $DynamicField->{ID};
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

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # header
    my $Output = join '',
        $LayoutObject->Header,
        $LayoutObject->NavigationBar;

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

    # Selections may be set up in a declaritive way
    my $FieldType = $Param{FieldType};
    if ( $Self->{FieldTypeSettings}->{$FieldType} ) {
        for my $Setting ( $Self->{FieldTypeSettings}->{$FieldType}->@* ) {
            my $Name = $Setting->{ConfigParamName};

            my $FieldStrg;
            if ( $Setting->{InputType} eq 'Text' ) {

                my $ClassString = 'W50pc' . ( $Param{ $Name . 'ServerError' } ? ' ServerError' : '' );

                # TODO: proper HTML builder
                $FieldStrg = sprintf
                    qq{<input id="%s" class="$ClassString" type="text" maxlength="500" value="%s" name="%s"/>},
                    $Name,
                    $Param{$Name} // '',
                    $Name;
            }
            elsif ( $Setting->{InputType} eq 'Selection' ) {
                $FieldStrg = $LayoutObject->BuildSelection(
                    Name       => $Name,
                    Data       => $Setting->{SelectionData},
                    SelectedID => $Param{$Name} || '0',
                    Class      => 'Modernize W50pc' . ( $Param{ $Name . 'ServerError' } ? ' ServerError' : '' ),
                );
            }

            if ($FieldStrg) {
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
            }
        }
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
        Class        => 'Modernize W50pc',
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

    # get the field id
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
        $Output,
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

1;
