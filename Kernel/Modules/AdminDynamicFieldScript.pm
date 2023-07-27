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

package Kernel::Modules::AdminDynamicFieldScript;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

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
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $FieldType  = $Param{FieldType}  || $ParamObject->GetParam( Param => 'FieldType' );
    my $ObjectType = $Param{ObjectType} || $ParamObject->GetParam( Param => 'ObjectType' );
    my $Config     = $FieldType ? $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Driver')->{$FieldType} : {};

    # Check module validity
    if ( !$Config->{Module} || !$Kernel::OM->Get('Kernel::System::Main')->Require( $Config->{Module} ) ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need valid field driver.'),
        );
    }

    my $DriverObject = $Kernel::OM->Get( $Config->{Module} );

    my $PossibleConditions = $DriverObject->GetPossibleExecutionConditions(
        ObjectType => $ObjectType,
        FieldID    => $ParamObject->GetParam( Param => 'ID' ),
    );

    my %ConditionHashes;
    if ( IsArrayRefWithData( $PossibleConditions->{PossibleArgs} ) ) {
        $ConditionHashes{PossibleArgs} = { map { $_ => $_ } $PossibleConditions->{PossibleArgs}->@* };
    }
    if ( IsArrayRefWithData( $PossibleConditions->{PossibleAJAXTriggers} ) ) {
        $ConditionHashes{PossibleAJAXTriggers} = { map { $_ => $_ } $PossibleConditions->{PossibleAJAXTriggers}->@* };
    }
    if ( IsArrayRefWithData( $PossibleConditions->{PossibleUpdateEvents} ) ) {
        $ConditionHashes{PossibleUpdateEvents} = { map { $_ => $_ } $PossibleConditions->{PossibleUpdateEvents}->@* };
    }

    if ( $Self->{Subaction} eq 'Add' ) {
        return $Self->_Add(
            %Param,
            %ConditionHashes,
        );
    }
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_AddAction(
            %Param,
            %ConditionHashes,
            DriverObject => $DriverObject,
        );
    }
    if ( $Self->{Subaction} eq 'Change' ) {
        return $Self->_Change(
            %Param,
            %ConditionHashes,
        );
    }
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        return $Self->_ChangeAction(
            %Param,
            %ConditionHashes,
            DriverObject => $DriverObject,
        );
    }
    return $LayoutObject->ErrorScreen(
        Message => Translatable('Undefined subaction.'),
    );
}

sub _Add {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %GetParam;
    for my $Needed (qw(ObjectType FieldType FieldOrder)) {
        $GetParam{$Needed} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Needed ),
            );
        }
    }

    # get the object type and field type display name
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $ObjectTypeName = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName}
        || '';
    my $FieldTypeName = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName} || '';

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

    if ( $GetParam{Name} ) {

        # check if name is alphanumeric
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

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

    if ( $GetParam{FieldOrder} ) {

        # check if field order is numeric and positive
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = Translatable('The field must be numeric.');
        }
    }

    for my $ConfigParam (
        qw(ObjectType ObjectTypeName FieldType FieldTypeName ValidID Tooltip Link LinkPreview Expression MultiValue)
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    for my $ConfigParam (
        qw(RequiredArgs AJAXTriggers UpdateEvents)
        )
    {
        $GetParam{$ConfigParam} = [ $ParamObject->GetArray( Param => $ConfigParam ) ];
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }
    for my $Arg ( $GetParam{RequiredArgs}->@* ) {
        if ( !$Param{PossibleArgs}{$Arg} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Bad value in RequiredArgs.'),
            );
        }
    }
    for my $Trigger ( $GetParam{AJAXTriggers}->@* ) {
        if ( !$Param{PossibleAJAXTriggers}{$Trigger} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Bad value in AJAXTriggers.'),
            );
        }
    }
    for my $Event ( $GetParam{UpdateEvents}->@* ) {
        if ( !$Param{PossibleUpdateEvents}{$Event} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Bad value in UpdateEvents.'),
            );
        }
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
        map { $_ => $GetParam{$_} } qw(Tooltip Link LinkPreview Expression RequiredArgs AJAXTriggers UpdateEvents MultiValue),
    );

    # create a new field
    my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $GetParam{FieldType},
        ObjectType => $GetParam{ObjectType},
        Config     => {
            %FieldConfig,
            Readonly => 1,
        },
        ValidID => $GetParam{ValidID},
        UserID  => $Self->{UserID},
    );

    if ( !$FieldID ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not create the new field'),
        );
    }

    if ( $GetParam{UpdateEvents}->@* ) {
        $Param{DriverObject}->SetUpdateEvents(
            FieldID => $FieldID,
            Events  => $GetParam{UpdateEvents},
        );
    }

    return $LayoutObject->Redirect(
        OP => "Action=AdminDynamicField",
    );
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

    # get the object type and field type display name
    my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
    my $ObjectTypeName = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName}
        || '';
    my $FieldTypeName = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName} || '';

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

    my %Config = ();

    # extract configuration
    if ( IsHashRefWithData( $DynamicFieldData->{Config} ) ) {
        %Config = %{ $DynamicFieldData->{Config} };
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
    my $FieldID      = $ParamObject->GetParam( Param => 'ID' );
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

    if ( $GetParam{Name} ) {

        # check if name is lowercase
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # add server error error class
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

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

    if ( $GetParam{FieldOrder} ) {

        # check if field order is numeric and positive
        if ( $GetParam{FieldOrder} !~ m{\A (?: \d )+ \z}xms ) {

            # add server error error class
            $Errors{FieldOrderServerError}        = 'ServerError';
            $Errors{FieldOrderServerErrorMessage} = Translatable('The field must be numeric.');
        }
    }

    for my $ConfigParam (
        qw(ObjectType ObjectTypeName FieldType FieldTypeName ValidID Tooltip Link LinkPreview Interpreter Expression MultiValue)
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    for my $ConfigParam (
        qw(RequiredArgs AJAXTriggers UpdateEvents)
        )
    {
        $GetParam{$ConfigParam} = [ $ParamObject->GetArray( Param => $ConfigParam ) ];
    }

    # uncorrectable errors
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }
    for my $Arg ( $GetParam{RequiredArgs}->@* ) {
        if ( !$Param{PossibleArgs}{$Arg} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Bad value in RequiredArgs.'),
            );
        }
    }
    for my $Trigger ( $GetParam{AJAXTriggers}->@* ) {
        if ( !$Param{PossibleAJAXTriggers}{$Trigger} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Bad value in AJAXTriggers.'),
            );
        }
    }
    for my $Event ( $GetParam{UpdateEvents}->@* ) {
        if ( !$Param{PossibleUpdateEvents}{$Event} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Bad value in UpdateEvents.'),
            );
        }
    }

    # Check if dynamic field is present in SysConfig setting
    my $UpdateEntity        = $ParamObject->GetParam( Param => 'UpdateEntity' ) || '';
    my $SysConfigObject     = $Kernel::OM->Get('Kernel::System::SysConfig');
    my %DynamicFieldOldData = %{$DynamicFieldData};
    my @IsDynamicFieldInSysConfig;
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

        # In case changing name an authorization (UpdateEntity) should be send
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
        map { $_ => $GetParam{$_} } qw(Tooltip Link LinkPreview Interpreter Expression RequiredArgs AJAXTriggers UpdateEvents MultiValue),
    );

    # update dynamic field (FieldType and ObjectType cannot be changed; use old values)
    my $UpdateSuccess = $DynamicFieldObject->DynamicFieldUpdate(
        ID         => $FieldID,
        Name       => $GetParam{Name},
        Label      => $GetParam{Label},
        FieldOrder => $GetParam{FieldOrder},
        FieldType  => $DynamicFieldData->{FieldType},
        ObjectType => $DynamicFieldData->{ObjectType},
        Config     => {
            %FieldConfig,
            Readonly => 1,
        },
        ValidID => $GetParam{ValidID},
        UserID  => $Self->{UserID},
    );

    if ( !$UpdateSuccess ) {
        return $LayoutObject->ErrorScreen(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Could not update the field %s', $GetParam{Name} ),
        );
    }

    if ( $GetParam{UpdateEvents}->@* ) {
        $Param{DriverObject}->SetUpdateEvents(
            FieldID => $FieldID,
            Events  => $GetParam{UpdateEvents},
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

    # if the user would like to continue editing the dynamic field, just redirect to the change screen
    if (
        defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
        && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
        )
    {
        return $LayoutObject->Redirect(
            OP =>
                "Action=$Self->{Action};Subaction=Change;ObjectType=$DynamicFieldData->{ObjectType};FieldType=$DynamicFieldData->{FieldType};ID=$FieldID"
        );
    }
    else {

        # otherwise return to overview
        return $LayoutObject->Redirect( OP => "Action=AdminDynamicField" );
    }
}

sub _ShowScreen {
    my ( $Self, %Param ) = @_;

    $Param{DisplayFieldName} = 'New';

    if ( $Param{Mode} eq 'Change' ) {
        $Param{ShowWarning}      = 'ShowWarning';
        $Param{DisplayFieldName} = $Param{Name};
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # header
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

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

    my $MultiValue = $Param{MultiValue} || '0';

    # create translatable values option list
    my $MultiValueStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        Name       => 'MultiValue',
        SelectedID => $MultiValue,
        Class      => 'Modernize W50pc',
    );

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

    # define config field specific settings
    my $Expression = ( defined $Param{Expression} ? $Param{Expression} : '' );

    # create the default value element
    $LayoutObject->Block(
        Name => 'Expression',
        Data => {
            %Param,
            Expression => $Expression,
        },
    );

    if ( $Param{PossibleArgs} ) {

        # create the Required select
        my $RequiredStrg = $LayoutObject->BuildSelection(
            Data         => $Param{PossibleArgs},
            Name         => 'RequiredArgs',
            SelectedID   => $Param{RequiredArgs},
            PossibleNone => 1,
            Translation  => 1,
            Class        => 'Modernize W50pc',
            Multiple     => 1,
        );

        $LayoutObject->Block(
            Name => 'RequiredArgs',
            Data => {
                %Param,
                RequiredStrg => $RequiredStrg,
            },
        );
    }

    if ( $Param{PossibleAJAXTriggers} ) {

        # create the Trigger select
        my $AJAXStrg = $LayoutObject->BuildSelection(
            Data         => $Param{PossibleAJAXTriggers},
            Name         => 'AJAXTriggers',
            SelectedID   => $Param{AJAXTriggers},
            PossibleNone => 1,
            Translation  => 1,
            Class        => 'Modernize W50pc',
            Multiple     => 1,
        );

        $LayoutObject->Block(
            Name => 'AJAXTriggers',
            Data => {
                %Param,
                AJAXStrg => $AJAXStrg,
            },
        );
    }

    if ( $Param{PossibleUpdateEvents} ) {

        # create the Trigger select
        my $EventStrg = $LayoutObject->BuildSelection(
            Data         => $Param{PossibleUpdateEvents},
            Name         => 'UpdateEvents',
            SelectedID   => $Param{UpdateEvents},
            PossibleNone => 1,
            Translation  => 1,
            Class        => 'Modernize W50pc',
            Multiple     => 1,
        );

        $LayoutObject->Block(
            Name => 'UpdateEvents',
            Data => {
                %Param,
                EventStrg => $EventStrg,
            },
        );
    }

    # define config field specific settings
    my $Link        = $Param{Link}        || '';
    my $LinkPreview = $Param{LinkPreview} || '';

    # create the default link element
    $LayoutObject->Block(
        Name => 'Link',
        Data => {
            %Param,
            Link        => $Link,
            LinkPreview => $LinkPreview,
        },
    );

    my $ReadonlyInternalField = '';

    # Internal fields can not be deleted and name should not change.
    if ( $Param{InternalField} ) {
        $LayoutObject->Block(
            Name => 'InternalField',
            Data => {%Param},
        );
        $ReadonlyInternalField = 'readonly="readonly"';
    }

    # get the field id
    my $FieldID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ID' );

    # only if the dymamic field exists and should be edited,
    # not if the field is added for the first time
    if ($FieldID) {

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            ID => $FieldID,
        );

        my $FieldConfig = $DynamicField->{Config};

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
                ,
            );
        }

    }

    # generate output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldScript',
        Data         => {
            %Param,
            ValidityStrg          => $ValidityStrg,
            DynamicFieldOrderStrg => $DynamicFieldOrderStrg,
            MultiValueStrg        => $MultiValueStrg,
            ReadonlyInternalField => $ReadonlyInternalField,
            Link                  => $Link,
            LinkPreview           => $LinkPreview,
            Tooltip               => $Tooltip,
        }
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
