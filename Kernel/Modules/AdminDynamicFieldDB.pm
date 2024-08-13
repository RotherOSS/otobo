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

package Kernel::Modules::AdminDynamicFieldDB;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language              qw(Translatable);

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
            ObjectType ObjectTypeName FieldType FieldTypeName ValidID Link LinkPreview DBType Server Port
            DBName DBTable User Password Identifier Multiselect CacheTTL Searchprefix Searchsuffix
            SID Driver ResultLimit CaseSensitive Tooltip MultiValue Namespace
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

    # Prepare the multiselect and case-sensitive parameters.
    if ( defined $GetParam{Multiselect} ) {
        $GetParam{Multiselect} = 'checked';
        $GetParam{MultiValue}  = 0;
    }

    if ( defined $GetParam{CaseSensitive} ) {
        $GetParam{CaseSensitive} = 'checked ';
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Uncorrectable errors.
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

    my $PossibleValues = $Self->_GetPossibleValues();

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
        PossibleValues => $PossibleValues,
        Link           => $GetParam{Link},
        LinkPreview    => $GetParam{LinkPreview},
        DBType         => $GetParam{DBType},
        SID            => $GetParam{SID},
        Driver         => $GetParam{Driver},
        Server         => $GetParam{Server},
        Port           => $GetParam{Port},
        DBName         => $GetParam{DBName},
        DBTable        => $GetParam{DBTable},
        User           => $GetParam{User},
        Password       => $GetParam{Password},
        Identifier     => $GetParam{Identifier},
        CacheTTL       => $GetParam{CacheTTL} || 0,
        Multiselect    => $GetParam{Multiselect},
        Searchprefix   => $GetParam{Searchprefix},
        Searchsuffix   => $GetParam{Searchsuffix},
        ResultLimit    => $GetParam{ResultLimit},
        CaseSensitive  => $GetParam{CaseSensitive},
        Tooltip        => $GetParam{Tooltip},
        MultiValue     => $GetParam{MultiValue}
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
        %Config = %{ $DynamicFieldData->{Config} };
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
            ObjectType ObjectTypeName FieldType FieldTypeName ValidID Link LinkPreview DBType Server Port
            DBName DBTable User Password Identifier Multiselect CacheTTL Searchprefix Searchsuffix
            SID Driver ResultLimit CaseSensitive Tooltip MultiValue Namespace
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

    # Prepare the multiselect and case-sensitive parameters.
    if ( defined $GetParam{Multiselect} ) {
        $GetParam{Multiselect} = 'checked';
        $GetParam{MultiValue}  = 0;
    }

    if ( defined $GetParam{CaseSensitive} ) {
        $GetParam{CaseSensitive} = 'checked ';
    }

    # Uncorrectable errors.
    if ( !$GetParam{ValidID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Need ValidID'),
        );
    }

    my $PossibleValues = $Self->_GetPossibleValues();

    # Check if dynamic field is present in SysConfig setting.
    my $UpdateEntity = $ParamObject->GetParam( Param => 'UpdateEntity' ) || '';
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
        PossibleValues => $PossibleValues,
        Link           => $GetParam{Link},
        LinkPreview    => $GetParam{LinkPreview},
        DBType         => $GetParam{DBType},
        SID            => $GetParam{SID},
        Driver         => $GetParam{Driver},
        Server         => $GetParam{Server},
        Port           => $GetParam{Port},
        DBName         => $GetParam{DBName},
        DBTable        => $GetParam{DBTable},
        User           => $GetParam{User},
        Password       => $GetParam{Password},
        Identifier     => $GetParam{Identifier},
        CacheTTL       => $GetParam{CacheTTL} || 0,
        Multiselect    => $GetParam{Multiselect},
        Searchprefix   => $GetParam{Searchprefix},
        Searchsuffix   => $GetParam{Searchsuffix},
        ResultLimit    => $GetParam{ResultLimit},
        CaseSensitive  => $GetParam{CaseSensitive},
        Tooltip        => $GetParam{Tooltip},
        MultiValue     => $GetParam{MultiValue},
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

    # Cleanup the cache.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'DynamicFieldDB',
    );

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

    $Param{Name} //= '';

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
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldList   = $DynamicFieldObject->DynamicFieldListGet(
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

        # Get the last element form the order list and add 1.
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

    my $MultiValueStrg = $LayoutObject->BuildSelection(
        Data => {
            0 => Translatable('No'),
            1 => Translatable('Yes'),
        },
        Name       => 'MultiValue',
        SelectedID => $Param{MultiValue} || '0',
        Class      => 'Modernize W50pc',
    );

    # Build namespace selection
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

    # Prepare the possible values hash based on the sequential number of any item.
    my $PreparedPossibleValues = {};

    KEY:
    for my $Key ( sort keys %PossibleValues ) {

        next KEY if !$Key;

        if ( $Key =~ m/^\w+_(\d+)$/ ) {

            if ( !IsHashRefWithData( $PreparedPossibleValues->{$1} ) ) {
                $PreparedPossibleValues->{$1} = {
                    "$Key" => $PossibleValues{$Key},
                };
            }
            else {
                $PreparedPossibleValues->{$1}->{$Key} = $PossibleValues{$Key};
            }
        }
    }

    # Prepare the available data-types and filters.
    my %DataTypes = (
        DATE    => 'Date',
        INTEGER => 'Integer',
        TEXT    => 'Text',
    );

    my %Filters = (
        CustomerID     => 'CustomerID',
        CustomerUserID => 'CustomerUserID',
        TicketNumber   => 'TicketNumber',
        Title          => 'Title',
        Type           => 'Type',
        TypeID         => 'TypeID',
        Service        => 'Service',
        ServiceID      => 'ServiceID',
        Owner          => 'Owner',
        OwnerID        => 'OwnerID',
        Responsible    => 'Responsible',
        ResponsibleID  => 'ResponsibleID',
        Queue          => 'Queue',
        QueueID        => 'QueueID',
        Priority       => 'Priority',
        PriorityID     => 'PriorityID',
        SLA            => 'SLA',
        SLAID          => 'SLAID',
        State          => 'State',
        StateID        => 'StateID',
        StateType      => 'StateType',
    );

    # Get a list of available dynamic fields for use as filters.
    my %DynamicFieldList = %{
        $DynamicFieldObject->DynamicFieldList(
            Valid      => 1,
            ResultType => 'HASH',
        )
    };

    # Add the dynamic fields to the hash.
    DYNAMICFIELDKEY:
    for my $DynamicFieldKey ( sort keys %DynamicFieldList ) {

        # Ignore the own field.
        if ( IsStringWithData( $Param{Name} ) ) {
            next DYNAMICFIELDKEY if $DynamicFieldList{$DynamicFieldKey} eq $Param{Name};
        }

        my $DynamicFieldName = 'DynamicField_' . $DynamicFieldList{$DynamicFieldKey};
        $Filters{$DynamicFieldName} = $DynamicFieldName;
    }

    # Prepare the identifier data for the drop-down menu.
    my %IdentifierData;

    # Output the possible values and errors within (if any).
    KEY:
    for my $Key ( sort keys %{$PreparedPossibleValues} ) {

        next KEY if !$Key;
        next KEY if !IsHashRefWithData( $PreparedPossibleValues->{$Key} );

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

                # set the error class
                $KeyError     = 'ServerError';
                $KeyErrorStrg = Translatable('This field value is duplicated.');
            }

            # Check for error on value.
            if ( $Param{'PossibleValueErrors'}->{'ValueEmptyError'}->{$Key} ) {

                # Set the error class.
                $ValueError = 'ServerError';
            }
        }

        my %NormalizedPossibleValueNames;

        OLDKEY:
        for my $OldKey ( sort keys %{ $PreparedPossibleValues->{$Key} } ) {

            next OLDKEY if !$OldKey;

            if (
                $OldKey =~ m/^(\w+)_(\d+)$/
                && IsStringWithData( $PreparedPossibleValues->{$Key}->{$OldKey} )
                )
            {

                my $NewKey           = $1;
                my $SequentialNumber = $2;

                if ( $OldKey =~ m/(?:Searchfield|Listfield)/ ) {
                    $NormalizedPossibleValueNames{$NewKey} = 'checked ';
                }
                elsif ( $OldKey =~ m/FieldName/ ) {
                    $NormalizedPossibleValueNames{$NewKey} = $PreparedPossibleValues->{$Key}->{$OldKey};

                    # Fill the identifier data hash.
                    $IdentifierData{$SequentialNumber} = $PreparedPossibleValues->{$Key}->{$OldKey};
                }
                else {
                    $NormalizedPossibleValueNames{$NewKey} = $PreparedPossibleValues->{$Key}->{$OldKey};
                }
            }
        }

        # Build the data-type field
        $Param{Datatype} = $LayoutObject->BuildSelection(
            Data         => \%DataTypes,
            Name         => "FieldDatatype_$ValueCounter",
            ID           => "FieldDatatype_$ValueCounter",
            Class        => 'Modernize Validate_Required',
            SelectedID   => $NormalizedPossibleValueNames{FieldDatatype},
            Translation  => 1,
            PossibleNone => 1,
        );

        # Build the select field for the filters.
        $Param{SelectFilter} = $LayoutObject->BuildSelection(
            Data         => \%Filters,
            Name         => "FieldFilter_$ValueCounter",
            SelectedID   => $NormalizedPossibleValueNames{FieldFilter},
            Translation  => 1,
            PossibleNone => 1,
            Class        => 'Modernize',
        );

        # Create a value map row.
        $LayoutObject->Block(
            Name => 'ValueRow',
            Data => {
                %NormalizedPossibleValueNames,
                ValueCounter => $ValueCounter,
                Datatype     => $Param{Datatype},
                SelectFilter => $Param{SelectFilter},
            },
        );
    }

    # Build the data-type and filter field.
    $Param{Datatype} = $LayoutObject->BuildSelection(
        Data         => \%DataTypes,
        Name         => 'FieldDatatype',
        ID           => 'FieldDatatype',
        Translation  => 1,
        PossibleNone => 1,
        Class        => 'Modernize',
    );

    $Param{SelectFilter} = $LayoutObject->BuildSelection(
        Data         => \%Filters,
        Name         => 'FieldFilter',
        ID           => 'FieldFilter',
        Translation  => 1,
        PossibleNone => 1,
        Class        => 'Modernize',
    );

    # Create the possible values template.
    $LayoutObject->Block(
        Name => 'ValueTemplate',
        Data => {
            %Param,
        },
    );

    # Define config field specific settings.
    my $DefaultValue = ( defined $Param{DefaultValue} ? $Param{DefaultValue} : '' );

    # Create the default value element.
    $LayoutObject->Block(
        Name => 'DefaultValue' . $Param{FieldType},
        Data => {
            %Param,
            DefaultValue => $DefaultValue,
        },
    );

    # Define config field specific settings.
    my $Link        = $Param{Link}        || '';
    my $LinkPreview = $Param{LinkPreview} || '';

    if ( $Param{FieldType} eq 'Database' ) {

        # Create the default link element.
        $LayoutObject->Block(
            Name => 'Link',
            Data => {
                %Param,
                Link        => $Link,
                LinkPreview => $LinkPreview,
            },
        );
    }

    # Prepare available database types.
    my %Databases = (
        mysql      => "MySQL",
        postgresql => "PostgreSQL",
        ODBC       => "SQL Server (ODBC)",
        oracle     => "Oracle",
    );

    # Build the select field for the InstallerDBStart.tt.
    $Param{SelectDBType} = $LayoutObject->BuildSelection(
        Data         => \%Databases,
        Name         => 'DBType',
        Class        => 'Modernize Validate_Required',
        SelectedID   => $Param{DBType} || 'mysql',
        PossibleNone => 1,
        ID           => 'Type',
    );

    # Build the select field for the identifier.
    $Param{Identifier} = $LayoutObject->BuildSelection(
        Data         => \%IdentifierData,
        Name         => 'Identifier',
        ID           => 'Identifier',
        Class        => 'Modernize Validate_Required',
        SelectedID   => $Param{Identifier},
        PossibleNone => 1,
        Translation  => 0,
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
        TemplateFile => 'AdminDynamicFieldDB',
        Data         => {
            %Param,
            FilterStrg            => $FilterStrg,
            ValueCounter          => $ValueCounter,
            ValidityStrg          => $ValidityStrg,
            DynamicFieldOrderStrg => $DynamicFieldOrderStrg,
            DefaultValue          => $DefaultValue,
            MultiValueStrg        => $MultiValueStrg,
            ReadonlyInternalField => $ReadonlyInternalField,
            Link                  => $Link,
            Tooltip               => $Tooltip,
        }
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetPossibleValues {
    my ( $Self, %Param ) = @_;

    my $PossibleValueConfig;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $ValueCounter = $ParamObject->GetParam( Param => 'ValueCounter' ) || 0;

    my $ValueRealIndex = 1;

    VALUEINDEX:
    for my $ValueIndex ( 1 .. $ValueCounter ) {

        # Get possible keys and related values.
        my $KeyFieldName     = 'FieldName' . '_' . $ValueIndex;
        my $KeyFieldLabel    = 'FieldLabel' . '_' . $ValueIndex;
        my $KeyFieldDatatype = 'FieldDatatype' . '_' . $ValueIndex;
        my $KeyFieldFilter   = 'FieldFilter' . '_' . $ValueIndex;
        my $KeySearchfield   = 'Searchfield' . '_' . $ValueIndex;
        my $KeyListfield     = 'Listfield' . '_' . $ValueIndex;

        my $ValueFieldName     = $ParamObject->GetParam( Param => $KeyFieldName );
        my $ValueFieldLabel    = $ParamObject->GetParam( Param => $KeyFieldLabel );
        my $ValueFieldDatatype = $ParamObject->GetParam( Param => $KeyFieldDatatype );
        my $ValueFieldFilter   = $ParamObject->GetParam( Param => $KeyFieldFilter );
        my $ValueSearchfield   = $ParamObject->GetParam( Param => $KeySearchfield );
        my $ValueListfield     = $ParamObject->GetParam( Param => $KeyListfield );

        $ValueFieldName     = ( defined $ValueFieldName     ? $ValueFieldName     : '' );
        $ValueFieldLabel    = ( defined $ValueFieldLabel    ? $ValueFieldLabel    : '' );
        $ValueFieldDatatype = ( defined $ValueFieldDatatype ? $ValueFieldDatatype : '' );
        $ValueFieldFilter   = ( defined $ValueFieldFilter   ? $ValueFieldFilter   : '' );
        $ValueSearchfield   = ( defined $ValueSearchfield   ? $ValueSearchfield   : '' );
        $ValueListfield     = ( defined $ValueListfield     ? $ValueListfield     : '' );

        # Check for removed values.
        if ( !IsStringWithData($ValueFieldName) || !IsStringWithData($ValueFieldLabel) || !IsStringWithData($ValueFieldDatatype) ) {
            next VALUEINDEX;
        }

        $PossibleValueConfig->{ 'FieldName_' . $ValueRealIndex }     = $ValueFieldName;
        $PossibleValueConfig->{ 'FieldLabel_' . $ValueRealIndex }    = $ValueFieldLabel;
        $PossibleValueConfig->{ 'FieldDatatype_' . $ValueRealIndex } = $ValueFieldDatatype;
        $PossibleValueConfig->{ 'FieldFilter_' . $ValueRealIndex }   = $ValueFieldFilter;
        $PossibleValueConfig->{ 'Searchfield_' . $ValueRealIndex }   = $ValueSearchfield;
        $PossibleValueConfig->{ 'Listfield_' . $ValueRealIndex }     = $ValueListfield;
        $PossibleValueConfig->{ValueCounter}                         = $ValueCounter;

        $ValueRealIndex++;
    }

    return $PossibleValueConfig;
}

1;
