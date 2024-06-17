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

package Kernel::Modules::AdminDynamicFieldWebService;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

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

    if ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
        my $WebserviceID = $ParamObject->GetParam( Param => 'WebserviceID' );
        my $Invoker      = $ParamObject->GetParam( Param => 'Invoker' );

        # Create the invoker select
        my %InvokerList;

        # Get a list of configured invokers out of the web service.
        if ($WebserviceID) {

            my $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
                ID => $WebserviceID,
            );

            my @Invoker = keys %{ $Webservice->{Config}->{Requester}->{Invoker} };

            INVOKER:
            for my $Invoker (@Invoker) {

                next INVOKER if !$Invoker;

                if ( $Webservice->{Config}->{Requester}->{Invoker}->{$Invoker}->{Type} ne 'Generic::PassThrough' ) {
                    next INVOKER;
                }

                $InvokerList{$Invoker} = $Invoker;
            }
        }

        my $JSON = $LayoutObject->BuildSelectionJSON(
            [
                {
                    Name         => 'Invoker',
                    Data         => \%InvokerList,
                    SelectedID   => $Invoker || '',
                    Translation  => 0,
                    PossibleNone => 1,
                    TreeView     => 0,
                    Max          => 100,
                },
            ],
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
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
    for my $Needed (qw(ObjectType FieldType FieldOrder)) {
        $GetParam{$Needed} = $ParamObject->GetParam( Param => $Needed );
        if ( !$GetParam{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s', $Needed ),
            );
        }
    }

    # Get the object type and field type display name.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ObjectTypeName = $ConfigObject->Get('DynamicFields::ObjectType')->{ $GetParam{ObjectType} }->{DisplayName} || '';
    my $FieldTypeName  = $ConfigObject->Get('DynamicFields::Driver')->{ $GetParam{FieldType} }->{DisplayName}      || '';

    return $Self->_ShowScreen(
        %Param,
        %GetParam,
        Mode           => 'Add',
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

    # Get the TreeView option and set it to '0' if it is undefined.
    $GetParam{TreeView} = $ParamObject->GetParam( Param => 'TreeView' );
    $GetParam{TreeView} = defined $GetParam{TreeView} && $GetParam{TreeView} ? '1' : '0';

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    if ( $GetParam{Name} ) {

        # Check if name is alphanumeric.
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # Add server error error class.
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

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
            ObjectType ObjectTypeName FieldType FieldTypeName PossibleNone TranslatableValues
            ValidID WebserviceID Invoker Multiselect CacheTTL Link LinkPreview
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Uncorrectable errors.
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

    # Return to add screen if errors.
    if (%Errors) {
        return $Self->_ShowScreen(
            %Param,
            %Errors,
            %GetParam,
            Mode => 'Add',
        );
    }

    # Set specific config.
    my $FieldConfig = {
        WebserviceID       => $GetParam{WebserviceID},
        Invoker            => $GetParam{Invoker},
        Multiselect        => $GetParam{Multiselect},
        CacheTTL           => $GetParam{CacheTTL},
        TreeView           => $GetParam{TreeView},
        PossibleNone       => $GetParam{PossibleNone},
        TranslatableValues => $GetParam{TranslatableValues},
    };

    if ( $GetParam{Multiselect} eq '0' ) {
        $FieldConfig->{Link}        = $GetParam{Link};
        $FieldConfig->{LinkPreview} = $GetParam{LinkPreview};
    }

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

        # Set web service.
        $Config{WebserviceID} = $DynamicFieldData->{Config}->{WebserviceID};

        # Set invoker.
        $Config{Invoker} = $DynamicFieldData->{Config}->{Invoker};

        # Set multiselect.
        $Config{Multiselect} = $DynamicFieldData->{Config}->{Multiselect};

        # Set cache TTL.
        $Config{CacheTTL} = $DynamicFieldData->{Config}->{CacheTTL};

        # Set PossibleNone.
        $Config{PossibleNone} = $DynamicFieldData->{Config}->{PossibleNone};

        # Set TranslatableValues.
        $Config{TranslatableValues} = $DynamicFieldData->{Config}->{TranslatableValues};

        # Set TreeView.
        $Config{TreeView} = $DynamicFieldData->{Config}->{TreeView};
    }

    return $Self->_ShowScreen(
        %Param,
        %GetParam,
        %${DynamicFieldData},
        %Config,
        ID             => $FieldID,
        Mode           => 'Change',
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

    # Get the TreeView option and set it to '0' if it is undefined.
    $GetParam{TreeView} = $ParamObject->GetParam( Param => 'TreeView' );
    $GetParam{TreeView} = defined $GetParam{TreeView} && $GetParam{TreeView} ? '1' : '0';

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

    if ( $GetParam{Name} ) {

        # Check if name is lowercase.
        if ( $GetParam{Name} !~ m{\A (?: [a-zA-Z] | \d )+ \z}xms ) {

            # Add server error error class.
            $Errors{NameServerError} = 'ServerError';
            $Errors{NameServerErrorMessage} =
                Translatable('The field does not contain only ASCII letters and numbers.');
        }

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
            ObjectType ObjectTypeName FieldType FieldTypeName WebserviceID Invoker Multiselect CacheTTL
            PossibleNone TranslatableValues ValidID Link LinkPreview
        )
        )
    {
        $GetParam{$ConfigParam} = $ParamObject->GetParam( Param => $ConfigParam );
    }

    # Uncorrectable errors.
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

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
            ID   => $FieldID,
            Mode => 'Change',
        );
    }

    # Set specific config.
    my $FieldConfig = {
        WebserviceID       => $GetParam{WebserviceID},
        Invoker            => $GetParam{Invoker},
        Multiselect        => $GetParam{Multiselect},
        CacheTTL           => $GetParam{CacheTTL},
        PossibleNone       => $GetParam{PossibleNone},
        TreeView           => $GetParam{TreeView},
        TranslatableValues => $GetParam{TranslatableValues},
    };

    if ( $GetParam{Multiselect} eq '0' ) {
        $FieldConfig->{Link}        = $GetParam{Link};
        $FieldConfig->{LinkPreview} = $GetParam{LinkPreview};
    }

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

    # If the user would like to continue editing the dynamic field, just redirect to the change screen.
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

        # Otherwise return to overview.
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

    # Check and build the selection type list.
    my $SelectionType = ( defined $Param{SelectionType} ? $Param{SelectionType} : '' );

    my %SelectionTypes = (
        dropdown    => 'Dropdown',
        multiselect => 'Multiselect',
    );

    # Create the selection type select field.
    my $SelectionTypeStrg = $LayoutObject->BuildSelection(
        Data         => \%SelectionTypes,
        Name         => 'SelectionType',
        SelectedID   => $SelectionType,
        PossibleNone => 0,

        # Don't make is translatable because this will confuse the user (also current JS
        #   is not prepared).
        Translation => 1,

        # Multiple selections are currently not supported.
        Multiple => 0,
        Class    => 'Modernize W50pc',
    );

    # Check and build the web service list
    my $WebserviceID = ( defined $Param{WebserviceID} ? $Param{WebserviceID} : '' );

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');

    my $Webservices = $WebserviceObject->WebserviceList();

    # create the selection type select field
    my $WebserviceIDStrg = $LayoutObject->BuildSelection(
        Data         => $Webservices,
        Name         => 'WebserviceID',
        ID           => 'WebserviceID',
        SelectedID   => $WebserviceID,
        PossibleNone => 1,

        # Don't make is translatable because this will confuse the user (also current JS
        #   is not prepared).
        Translation => 1,

        # Multiple selections are currently not supported.
        Multiple => 0,
        Class    => 'Modernize W50pc Validate_Required',
    );

    # Create the invoker select.
    my %InvokerList;

    # Get a list of configured invokers out of the web service.
    if ($WebserviceID) {

        my $Webservice = $WebserviceObject->WebserviceGet(
            ID => $WebserviceID,
        );

        my @Invoker = keys %{ $Webservice->{Config}->{Requester}->{Invoker} };

        INVOKER:
        for my $Invoker (@Invoker) {

            next INVOKER if !$Invoker;

            if ( $Webservice->{Config}->{Requester}->{Invoker}->{$Invoker}->{Type} ne 'Generic::PassThrough' ) {
                next INVOKER;
            }

            $InvokerList{$Invoker} = $Invoker;
        }
    }

    my $Invoker = ( defined $Param{Invoker} ? $Param{Invoker} : '' );

    my $InvokerStrg = $LayoutObject->BuildSelection(
        Data         => \%InvokerList,
        Name         => 'Invoker',
        ID           => 'Invoker',
        SelectedID   => $Invoker,
        PossibleNone => 1,
        Translation  => 0,
        Multiple     => 0,
        Class        => 'Modernize Validate_Required',    # can't use W50pc due to problems with modern inputs
    );

    # Create the multiselect selection.
    my $Multiselect = $Param{Multiselect} || '0';

    # Create translatable values option list
    my $MultiselectStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        Name       => 'Multiselect',
        SelectedID => $Multiselect,
        Class      => 'Modernize W50pc',
    );

    my $PossibleNone = $Param{PossibleNone} || '0';

    # Create translatable values option list.
    my $PossibleNoneStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        Name       => 'PossibleNone',
        SelectedID => $PossibleNone,
        Class      => 'Modernize W50pc',
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

    my $TreeView = $Param{TreeView} || '0';

    # Create tree-view option list.
    my $TreeViewStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        Name       => 'TreeView',
        SelectedID => $TreeView,
        Class      => 'Modernize W50pc',
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

    # Define config field specific settings.
    my $Link        = $Param{Config}->{Link}        || '';
    my $LinkPreview = $Param{Config}->{LinkPreview} || '';

    if ($IsDirtyConfig) {
        $LayoutObject->Block(
            Name => 'DynamicFieldInSysConfigDirty',
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldWebService',
        Data         => {
            %Param,
            ValidityStrg           => $ValidityStrg,
            DynamicFieldOrderStrg  => $DynamicFieldOrderStrg,
            ValueCounter           => $ValueCounter,
            SelectionTypeStrg      => $SelectionTypeStrg,
            WebserviceIDStrg       => $WebserviceIDStrg,
            InvokerStrg            => $InvokerStrg,
            MultiselectStrg        => $MultiselectStrg,
            PossibleNoneStrg       => $PossibleNoneStrg,
            TreeViewStrg           => $TreeViewStrg,
            TranslatableValuesStrg => $TranslatableValuesStrg,
            ReadonlyInternalField  => $ReadonlyInternalField,
            Link                   => $Link,
            LinkPreview            => $LinkPreview,
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
