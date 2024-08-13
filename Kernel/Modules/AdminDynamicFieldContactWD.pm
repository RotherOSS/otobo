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

package Kernel::Modules::AdminDynamicFieldContactWD;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    # Set possible values handling strings.
    $Self->{EmptyString}     = '_DynamicFields_EmptyString_Dont_Use_It_String_Please';
    $Self->{DuplicateString} = '_DynamicFields_DuplicatedString_Dont_Use_It_String_Please';
    $Self->{DeletedString}   = '_DynamicFields_DeletedString_Dont_Use_It_String_Please';

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
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # Challenge token check for write action.
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
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # Challenge token check for write action.
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
                if ( $ConfigKey eq 'PossibleValues' ) {
                    $GetParam{PossibleValues} = $DFDetails->{PossibleValues};
                }
                elsif ( IsHashRefWithData( $DFDetails->{$ConfigKey} ) ) {
                    my $ConfigContent = $DFDetails->{$ConfigKey};
                    for my $ContentKey ( keys $ConfigContent->%* ) {
                        $GetParam{$ContentKey} = $ConfigContent->{$ContentKey};
                    }
                }
                else {
                    $GetParam{$ConfigKey} = $DFDetails->{$ConfigKey};
                }
            }
        }
        $GetParam{CloneFieldID} = $CloneFieldID;
    }

    for my $Needed (qw(ObjectType FieldType FieldOrder)) {
        $GetParam{$Needed} //= $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Needed ),
            );
        }
    }

    for my $FilterParam (qw(ObjectTypeFilter NamespaceFilter)) {
        $GetParam{$FilterParam} = $ParamObject->GetParam( Param => $FilterParam );
    }

    # Get the object type and field type display name.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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

    my %Errors;
    my %GetParam;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required.');
        }
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    if ( $GetParam{FieldOrder} ) {

        # Check if field order is numeric and positive.
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # Add server error error class.
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = Translatable('The field must be numeric.');
        }
    }

    for my $ConfigParam (
        qw(
            ObjectType ObjectTypeName FieldType FieldTypeName
            TranslatableValues SortOrder MandatoryFields SearchableFields ValidID Tooltip Namespace
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    for my $FilterParam (qw(ObjectTypeFilter NamespaceFilter)) {
        $GetParam{$FilterParam} = $ParamObject->GetParam( Param => $FilterParam );
    }

    if ( $GetParam{Name} ) {

        # Check if name is alphanumeric.
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # Add server error error class.
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

        $GetParam{Name} = $GetParam{Namespace} ? $GetParam{Namespace} . '-' . $GetParam{Name} : $GetParam{Name};

        # Check if name is duplicated.
        my %DynamicFieldsList = %{
            $DynamicFieldObject->DynamicFieldList(
                Valid      => 0,
                ResultType => 'HASH',
            )
        };

        %DynamicFieldsList = reverse %DynamicFieldsList;

        if ( $DynamicFieldsList{ $GetParam{Name} } ) {

            # Add server error error class.
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = Translatable('There is another field with the same name.');
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Uncorrectable errors.
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

    my $PossibleValues = $Self->_GetPossibleValues();

    # Set errors for possible values entries.
    KEY:
    for my $Key ( sort keys %{$PossibleValues} ) {

        # Check for empty original values.
        if ( $Key =~ m{\A $Self->{EmptyString} (?: \d+)}smx ) {

            # Set a true entry in KeyEmptyError.
            $Errors{'PossibleValueErrors'}->{'KeyEmptyError'}->{$Key} = 1;
        }

        # Otherwise check for duplicate original values.
        elsif ( $Key =~ m{\A (.+) - $Self->{DuplicateString} (?: \d+)}smx ) {

            # Set an entry in OrigValueDuplicateError with the duplicate key as value.
            $Errors{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key} = $1;
        }

        # Check for empty new values.
        if ( !defined $PossibleValues->{$Key} ) {

            # Set a true entry in NewValueEmptyError.
            $Errors{'PossibleValueErrors'}->{'ValueEmptyError'}->{$Key} = 1;
        }
    }

    # Check if we have a possible value 'Name' (our main key) and 'ValidID'.
    MANDATORYFIELD:
    for my $MandatoryField (qw(Name ValidID)) {
        next MANDATORYFIELD if $PossibleValues->{$MandatoryField};
        $Errors{"${MandatoryField}FieldServerError"} = 'ServerError';
    }

    # Check, unify and pre-compute SortOrder, MandatoryFields and SearchableFields.
    $Self->_ComputeFields(
        GetParam       => \%GetParam,
        PossibleValues => $PossibleValues,
    );

    # Return to add screen if errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            PossibleValues => $PossibleValues,
            Mode           => 'Add',
        );
    }

    # Set specific config.
    my $FieldConfig = {
        PossibleValues           => $PossibleValues,
        TranslatableValues       => $GetParam{TranslatableValues},
        SortOrder                => $GetParam{SortOrder},
        SortOrderComputed        => $GetParam{SortOrderComputed},
        MandatoryFields          => $GetParam{MandatoryFields},
        MandatoryFieldsComputed  => $GetParam{MandatoryFieldsComputed},
        SearchableFields         => $GetParam{SearchableFields},
        SearchableFieldsComputed => $GetParam{SearchableFieldsComputed},
        Tooltip                  => $GetParam{Tooltip},
    };

    # Create a new field.
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $GetParam{FieldType},
        ObjectType => $GetParam{ObjectType},
        Config     => $FieldConfig,
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

    # Get the object type and field type display name.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ObjectTypeName = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName  = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName}      || '';

    my $FieldID = $ParamObject->GetParam( Param => 'ID' );

    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ID'),
        );
    }

    my $DynamicFieldData = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
        ID => $FieldID,
    );

    # Check for valid dynamic field configuration.
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for dynamic field %s', $FieldID ),
        );
    }

    my %Config = ();

    # Extract configuration.
    if ( IsHashRefWithData( $DynamicFieldData->{Config} ) ) {

        # Set PossibleValues.
        $Config{PossibleValues} = {};
        if ( IsHashRefWithData( $DynamicFieldData->{Config}->{PossibleValues} ) ) {
            $Config{PossibleValues} = $DynamicFieldData->{Config}->{PossibleValues};
        }

        # Set TranslatableValues.
        $Config{TranslatableValues} = $DynamicFieldData->{Config}->{TranslatableValues};

        # Set extra values.
        $Config{SortOrder}        = $DynamicFieldData->{Config}->{SortOrder};
        $Config{MandatoryFields}  = $DynamicFieldData->{Config}->{MandatoryFields};
        $Config{SearchableFields} = $DynamicFieldData->{Config}->{SearchableFields};
    }

    return $Self->_ShowScreen(
        %Param,
        %GetParam,
        %${DynamicFieldData},
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

    my %Errors;
    my %GetParam;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(Name Label FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            $Errors{ $Needed . 'ServerError' }        = 'ServerError';
            $Errors{ $Needed . 'ServerErrorMessage' } = Translatable('This field is required.');
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $FieldID = $ParamObject->GetParam( Param => 'ID' );
    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ID'),
        );
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
        ID => $FieldID,
    );

    # Check for valid dynamic field configuration.
    if ( !IsHashRefWithData($DynamicFieldData) ) {
        return $LayoutObject->ErrorScreen(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'Could not get data for dynamic field %s', $FieldID ),
        );
    }

    if ( $GetParam{FieldOrder} ) {

        # Check if field order is numeric and positive.
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # Add server error error class.
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = Translatable('The field must be numeric.');
        }
    }

    for my $ConfigParam (
        qw(
            ObjectType ObjectTypeName FieldType FieldTypeName
            TranslatableValues SortOrder MandatoryFields SearchableFields ValidID Tooltip Namespace
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    for my $FilterParam (qw(ObjectTypeFilter NamespaceFilter)) {
        $GetParam{$FilterParam} = $ParamObject->GetParam( Param => $FilterParam );
    }

    if ( $GetParam{Name} ) {

        # Check if name is lowercase.
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # Add server error error class.
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

        $GetParam{Name} = $GetParam{Namespace} ? $GetParam{Namespace} . '-' . $GetParam{Name} : $GetParam{Name};

        # Check if name is duplicated.
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

            # Add server error class.
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = Translatable('There is another field with the same name.');
        }

        # If it's an internal field, it's name should not change.
        if (
            $DynamicFieldData->{InternalField} &&
            $DynamicFieldsList{ $GetParam{Name} } ne $FieldID
            )
        {

            # Add server error class.
            $Errors{NameServerError}        = 'ServerError';
            $Errors{NameServerErrorMessage} = Translatable('The name for this field should not change.');
            $Param{InternalField}           = $DynamicFieldData->{InternalField};
        }
    }

    # Uncorrectable errors.
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

    my $PossibleValues = $Self->_GetPossibleValues();

    # Set errors for possible values entries.
    KEY:
    for my $Key ( sort keys %{$PossibleValues} ) {

        # Check for empty original values.
        if ( $Key =~ m{\A $Self->{EmptyString} (?: \d+)}smx ) {

            # Set a true entry in KeyEmptyError.
            $Errors{'PossibleValueErrors'}->{'KeyEmptyError'}->{$Key} = 1;
        }

        # Otherwise check for duplicate original values.
        elsif ( $Key =~ m{\A (.+) - $Self->{DuplicateString} (?: \d+)}smx ) {

            # Set an entry in OrigValueDuplicateError with the duplicate key as value.
            $Errors{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key} = $1;
        }

        # Check for empty new values.
        if ( !defined $PossibleValues->{$Key} ) {

            # Set a true entry in NewValueEmptyError.
            $Errors{'PossibleValueErrors'}->{'ValueEmptyError'}->{$Key} = 1;
        }
    }

    # Check if we have a possible value 'Name' (our main key) and 'ValidID'.
    MANDATORYFIELD:
    for my $MandatoryField (qw(Name ValidID)) {
        next MANDATORYFIELD if $PossibleValues->{$MandatoryField};
        $Errors{"${MandatoryField}FieldServerError"} = 'ServerError';
    }

    # Check, unify and pre-compute SortOrder, MandatoryFields and SearchableFields.
    $Self->_ComputeFields(
        GetParam       => \%GetParam,
        PossibleValues => $PossibleValues,
    );

    # Check if dynamic field is present in SysConfig setting.
    my $UpdateEntity        = $ParamObject->GetParam( Param => 'UpdateEntity' ) || '';
    my %DynamicFieldOldData = %{$DynamicFieldData};
    my @IsDynamicFieldInSysConfig;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    @IsDynamicFieldInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
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

        # In case changing name an authorization (UpdateEntity) should be send.
        elsif ( $DynamicFieldData->{Name} ne $GetParam{Name} && !$UpdateEntity ) {
            $Errors{NameInvalid}              = 'ServerError';
            $Errors{InSettingNameServerError} = 1;
        }
    }

    # Return to change screen if errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            PossibleValues => $PossibleValues,
            ID             => $FieldID,
            Mode           => 'Change',
        );
    }

    # Set specific config.
    my $FieldConfig = {
        %{ $DynamicFieldData->{Config} },
        PossibleValues           => $PossibleValues,
        TranslatableValues       => $GetParam{TranslatableValues},
        SortOrder                => $GetParam{SortOrder},
        SortOrderComputed        => $GetParam{SortOrderComputed},
        MandatoryFields          => $GetParam{MandatoryFields},
        MandatoryFieldsComputed  => $GetParam{MandatoryFieldsComputed},
        SearchableFields         => $GetParam{SearchableFields},
        SearchableFieldsComputed => $GetParam{SearchableFieldsComputed},
        Tooltip                  => $GetParam{Tooltip},
    };

    # Update dynamic field (FieldType and ObjectType cannot be changed; use old values).
    my $UpdateSuccess = $DynamicFieldObject->DynamicFieldUpdate(
        ID         => $FieldID,
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $DynamicFieldData->{FieldType},
        ObjectType => $DynamicFieldData->{ObjectType},
        Config     => $FieldConfig,
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

    # If the user would like to continue editing the dynamic field, just redirect to the change screen.
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

    $Param{DeletedString} = $Self->{DeletedString};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # Get all fields.
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid => 0,
    );

    # Get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    my %DynamicfieldNamesList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
        $DynamicfieldNamesList{ $Dynamicfield->{FieldOrder} } = $Dynamicfield->{Label};
    }

    # When adding we need to create an extra order number for the new field.
    if ( $Param{Mode} eq 'Add' ) {

        # Get the last element from the order list and add 1.
        my $LastOrderNumber = $DynamicfieldOrderList[-1];
        $LastOrderNumber++;

        # Add this new order number to the end of the list.
        push @DynamicfieldOrderList, $LastOrderNumber;
    }

    # Show the names of the other fields to ease ordering.
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

    my $NamespaceList = $Kernel::OM->Get('Kernel::Config')->Get('DynamicField::Namespaces');
    if ( IsArrayRefWithData($NamespaceList) ) {
        my $NamespaceStrg = $LayoutObject->BuildSelection(
            Data          => $NamespaceList,
            Name          => 'Namespace',
            SelectedValue => $Namespace || '',
            PossibleNone  => 1,
            Translation   => 0,
            Sort          => 'AlphanumericValue',
            Class         => 'Modernize W75pc',
        );

        $LayoutObject->Block(
            Name => 'DynamicFieldNamespace',
            Data => {
                NamespaceStrg => $NamespaceStrg,
            },
        );
    }

    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    # Create the Validity select.
    my $ValidityStrg = $LayoutObject->BuildSelection(
        Data         => \%ValidList,
        Name         => 'ValidID',
        SelectedID   => $Param{ValidID} || 1,
        PossibleNone => 0,
        Translation  => 1,
        Class        => 'Modernize W50pc',
    );

    # Define as 0 to get the real value in the HTML.
    my $ValueCounter = 0;

    # Set PossibleValues.
    my %PossibleValues;
    if ( IsHashRefWithData( $Param{PossibleValues} ) ) {
        %PossibleValues = %{ $Param{PossibleValues} };
    }

    $Param{NameField}    = delete $PossibleValues{Name};
    $Param{ValidIDField} = delete $PossibleValues{ValidID};

    # Output the possible values and errors within (if any).
    for my $Key ( sort { lc($a) cmp lc($b) } keys %PossibleValues ) {

        $ValueCounter++;

        # Needed for server side validation.
        my $KeyError;
        my $KeyErrorStrg;
        my $ValueError;

        # To set the correct original value.
        my $KeyClone = $Key;

        # Check for errors.
        if ( $Param{'PossibleValueErrors'} ) {

            # Check for errors on original value (empty).
            if ( $Param{'PossibleValueErrors'}->{'KeyEmptyError'}->{$Key} ) {

                # If the original value was empty it has been changed in _GetParams to a predefined
                #   string and need to be set to empty again.
                $KeyClone = '';

                # Set the error class.
                $KeyError     = 'ServerError';
                $KeyErrorStrg = Translatable('This field is required.');
            }

            # check for errors on original value (duplicate)
            elsif ( $Param{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key} ) {

                # If the original value was empty it has been changed in _GetParams to a predefined
                #   string and need to be set to the original value again.
                $KeyClone = $Param{'PossibleValueErrors'}->{'KeyDuplicateError'}->{$Key};

                # Set the error class.
                $KeyError     = 'ServerError';
                $KeyErrorStrg = Translatable('This field key is duplicated.');
            }

            # Check for error on value.
            if ( $Param{'PossibleValueErrors'}->{'ValueEmptyError'}->{$Key} ) {

                # Set the error class.
                $ValueError = 'ServerError';
            }
        }

        # Create a value map row.
        $LayoutObject->Block(
            Name => 'ValueRow',
            Data => {
                KeyError     => $KeyError,
                KeyErrorStrg => $KeyErrorStrg || Translatable('This field is required.'),
                Key          => $KeyClone,
                ValueCounter => $ValueCounter,
                Value        => $PossibleValues{$Key},
                ValueError   => $ValueError,
            },
        );
    }

    # Create the possible values template.
    $LayoutObject->Block(
        Name => 'ValueTemplate',
        Data => {
            %Param,
        },
    );

    my $TranslatableValues = $Param{TranslatableValues} || '0';

    # Create translatable values option list.
    my $TranslatableValuesStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        Name       => 'TranslatableValues',
        SelectedID => $TranslatableValues,
        Class      => 'Modernize W50pc',
    );

    # define tooltip
    my $Tooltip = ( defined $Param{Tooltip} ? $Param{Tooltip} : '' );

    # create the default value element
    $LayoutObject->Block(
        Name => 'Tooltip',
        Data => {
            %Param,
            Tooltip => $Tooltip,
        },
    );

    # Internal fields can not be deleted and name should not change.
    my $ReadonlyInternalField = '';
    if ( $Param{InternalField} ) {
        $LayoutObject->Block(
            Name => 'InternalField',
            Data => {%Param},
        );
        $ReadonlyInternalField = 'readonly';
    }

    my $DynamicFieldName = $Param{Name};

    # Add warning in case the DynamicField belongs a SysConfig setting.
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # In case dirty setting disable form.
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

            # Verify if dirty setting.
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

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldContactWD',
        Data         => {
            %Param,
            FilterStrg             => $FilterStrg,
            ValidityStrg           => $ValidityStrg,
            DynamicFieldOrderStrg  => $DynamicFieldOrderStrg,
            ValueCounter           => $ValueCounter,
            TranslatableValuesStrg => $TranslatableValuesStrg,
            ReadonlyInternalField  => $ReadonlyInternalField,
            Tooltip                => $Tooltip,
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetPossibleValues {
    my ( $Self, %Param ) = @_;

    my $PossibleValueConfig;
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get parameters from web browser.
    # Get ValueCounters.
    my $ValueCounter          = $ParamObject->GetParam( Param => 'ValueCounter' ) || 0;
    my $EmptyValueCounter     = 0;
    my $DuplicateValueCounter = 0;

    VALUEINDEX:
    for my $ValueIndex ( 1 .. $ValueCounter ) {
        my $Key = $ParamObject->GetParam( Param => 'Key' . '_' . $ValueIndex );
        $Key = ( defined $Key ? $Key : '' );

        # Check if key was deleted by the user and skip it.
        next VALUEINDEX if $Key eq $Self->{DeletedString};

        # Check if the original value is empty.
        if ( $Key eq '' ) {

            # Change the empty value to a predefined string.
            $Key = $Self->{EmptyString} . int $EmptyValueCounter;
            $EmptyValueCounter++;
        }

        # Otherwise check for duplicate.
        elsif ( exists $PossibleValueConfig->{$Key} ) {

            # Append a predefined unique string to make this value unique.
            $Key .= '-' . $Self->{DuplicateString} . $DuplicateValueCounter;
            $DuplicateValueCounter++;
        }

        my $Value = $ParamObject->GetParam( Param => 'Value' . '_' . $ValueIndex );
        $Value = ( defined $Value ? $Value : '' );
        $PossibleValueConfig->{$Key} = $Value;
    }

    # Add Name and ValidID from the separated inputs to overwrite any possible added value.
    for my $MandatoryField (qw(Name ValidID)) {
        $PossibleValueConfig->{$MandatoryField} = $ParamObject->GetParam( Param => "${MandatoryField}Field" );
    }
    return $PossibleValueConfig;
}

sub _ComputeFields {
    my ( $Self, %Param ) = @_;

    # Clean and unify fields.
    FIELD:
    for my $Field (qw(SortOrder MandatoryFields SearchableFields)) {
        if ( !$Param{GetParam}->{$Field} ) {
            $Param{GetParam}->{$Field} = '';
            next FIELD;
        }
        my @Attributes = split /,/, $Param{GetParam}->{$Field};
        $Param{GetParam}->{$Field} = '';
        ATTRIBUTE:
        for my $Attribute (@Attributes) {
            next ATTRIBUTE if $Attribute eq '';
            $Attribute =~ s{ \A \s+ }{}xms;
            $Attribute =~ s{ \s+ \z }{}xms;
            next ATTRIBUTE if $Attribute eq '';
            if ( $Param{GetParam}->{$Field} ) {
                $Param{GetParam}->{$Field} .= ',';
            }
            $Param{GetParam}->{$Field} .= $Attribute;
        }
    }

    # Add and filter (= allow only possible values) complete sorted field.
    my @SortOrderComputed = split /,/, $Param{GetParam}->{SortOrder};
    @SortOrderComputed = grep { $Param{PossibleValues}->{$_} } @SortOrderComputed;
    my %PreSorted = map { $_ => 1 } @SortOrderComputed;
    FIELD:
    for my $Field ( sort { lc($a) cmp lc($b) } keys %{ $Param{PossibleValues} } ) {
        next FIELD if $PreSorted{$Field};
        push @SortOrderComputed, $Field;
    }
    $Param{GetParam}->{SortOrderComputed} = \@SortOrderComputed;

    # Add 'Name' and 'ValidID' to mandatory and searchable fields
    #   and filter them (= allow only possible values).
    FIELD:
    for my $Field (qw(MandatoryFields SearchableFields)) {
        my @Computed;
        push @Computed, 'Name';
        if ( $Field eq 'MandatoryFields' ) {
            push @Computed, 'ValidID';
        }
        ATTRIBUTE:
        for my $Attribute ( split /,/, $Param{GetParam}->{$Field} ) {
            next ATTRIBUTE if $Attribute eq '';
            $Attribute =~ s{ \A \s+ }{}xms;
            $Attribute =~ s{ \s+ \z }{}xms;
            next ATTRIBUTE if $Attribute eq '';
            next ATTRIBUTE if !$Param{PossibleValues}->{$Attribute};
            push @Computed, $Attribute;
        }
        $Param{GetParam}->{ $Field . 'Computed' } = \@Computed;
    }

    return 1;
}

1;
