# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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

package Kernel::Modules::AdminDynamicFieldImportExport;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::System::Web::Request',
    'Kernel::System::YAML',
    'Kernel::System::ZnunyHelper',
    'Kernel::System::DateTime',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get objects
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $YAMLObject         = $Kernel::OM->Get('Kernel::System::YAML');
    my $ZnunyHelperObject  = $Kernel::OM->Get('Kernel::System::ZnunyHelper');
    my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');

    my $DynamicFields = $DynamicFieldObject->GetValidDynamicFields();
    $Self->{DynamicFields} = $DynamicFields;

    my $ValidDynamicFieldScreenList = $ZnunyHelperObject->_ValidDynamicFieldScreenListGet(
        Result => 'HASH',
    );

    $Self->{DynamicFieldScreens}   = $ValidDynamicFieldScreenList->{DynamicFieldScreens};
    $Self->{DefaultColumnsScreens} = $ValidDynamicFieldScreenList->{DefaultColumnsScreens};

    $Self->{Subaction} = $ParamObject->GetParam( Param => 'Subaction' ) || '';

    # ------------------------------------------------------------ #
    # Import
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Import' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );

        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' );

        my $PerlStructure = $YAMLObject->Load(
            Data => $UploadStuff{Content},
        );

        $CacheObject->Set(
            Type  => 'AdminDynamicFieldImportExport',
            Key   => 'AdminDynamicFieldImportExport::' . $Self->{UserID},
            Value => $PerlStructure,
            TTL   => 60 * 60,
        );

        return $Self->_Mask(
            Data                      => $PerlStructure,
            Type                      => $Self->{Subaction},
            OverwriteExistingEntities => $OverwriteExistingEntities || 0,
        );
    }

    # ------------------------------------------------------------ #
    # ImportAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ImportAction' ) {

        my $ImportData = $CacheObject->Get(
            Type => 'AdminDynamicFieldImportExport',
            Key  => 'AdminDynamicFieldImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminDynamicField
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminDynamicField"
            );

            return $HTML;
        }

        # check required parameters
        my @DynamicFieldsSelected          = $ParamObject->GetArray( Param => 'DynamicFields' );
        my @DynamicFieldForScreensSelected = $ParamObject->GetArray( Param => 'DynamicFieldScreens' );
        my $OverwriteExistingEntities      = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminDynamicFieldImportExport',
            Key  => 'AdminDynamicFieldImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import DynamicFields
        # ------------------------------------------------------------ #
        my $FieldTypeConfig = $ConfigObject->Get('DynamicFields::Driver');
        if ( IsHashRefWithData( $ImportData->{DynamicFields} ) ) {

            my @DynamicFieldsImport;
            DYNAMICFIELD:
            for my $DynamicField ( sort keys %{ $ImportData->{DynamicFields} } ) {

                my $Selected = grep { $ImportData->{DynamicFields}->{$DynamicField}->{Name} eq $_ } @DynamicFieldsSelected;
                next DYNAMICFIELD if !$Selected;

                next DYNAMICFIELD if !IsHashRefWithData( $ImportData->{DynamicFields}->{$DynamicField} );

                my $FieldType = $ImportData->{DynamicFields}->{$DynamicField}->{FieldType};

                if ( !IsHashRefWithData( $FieldTypeConfig->{$FieldType} ) ) {

                    $LogObject->Log(
                        'Priority' => 'error',
                        'Message'  =>
                            "Could not import dynamic field '$ImportData->{DynamicFields}->{$DynamicField}->{Name}' - Dynamic field backend for FieldType '$ImportData->{DynamicFields}->{$DynamicField}->{FieldType}' does not exists!",
                    );
                    next DYNAMICFIELD;
                }

                push @DynamicFieldsImport, $ImportData->{DynamicFields}->{$DynamicField};
            }

            if ($OverwriteExistingEntities) {
                $ZnunyHelperObject->_DynamicFieldsCreate(@DynamicFieldsImport);
            }
            else {
                $ZnunyHelperObject->_DynamicFieldsCreateIfNotExists(@DynamicFieldsImport);
            }
        }

        # ------------------------------------------------------------ #
        # Import DynamicFieldsScreens
        # ------------------------------------------------------------ #

        if ( IsHashRefWithData( $ImportData->{DynamicFieldsScreens} ) ) {

            my %DynamicFieldsScreensImport;
            DYNAMICFIELDSCREEN:
            for my $DynamicField ( sort keys %{ $ImportData->{DynamicFieldsScreens} } ) {

                # check if dynamic field screen was selected
                my $Selected = grep { $DynamicField eq $_ } @DynamicFieldForScreensSelected;
                next DYNAMICFIELDSCREEN if !$Selected;

                $DynamicFieldsScreensImport{$DynamicField} = $ImportData->{DynamicFieldsScreens}->{$DynamicField};
            }

            if (%DynamicFieldsScreensImport) {
                $ZnunyHelperObject->_DynamicFieldsScreenConfigImport(
                    Config => \%DynamicFieldsScreensImport,
                );
            }
        }

        # redirect to AdminDynamicField
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminDynamicField"
        );

        return $HTML;

    }

    # ------------------------------------------------------------ #
    # Export
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Export' ) {

        return $Self->_Mask(
            %Param,
            Type => $Self->{Subaction},
        );

    }

    # ------------------------------------------------------------ #
    # ExportAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ExportAction' ) {

        # check required parameters
        my @DynamicFields          = $ParamObject->GetArray( Param => 'DynamicFields' );
        my @DynamicFieldForScreens = $ParamObject->GetArray( Param => 'DynamicFieldScreens' );

        my %Data;
        my $HTML;

        if (@DynamicFields) {

            $Data{DynamicFields} = $ZnunyHelperObject->_DynamicFieldsConfigExport(
                Format                => 'var',
                IncludeInternalFields => 1,
                IncludeAllConfigKeys  => 1,
                DynamicFields         => \@DynamicFields,
                Result                => 'HASH',
            );
        }

        if (@DynamicFieldForScreens) {

            %{ $Data{DynamicFieldsScreens} } = $ZnunyHelperObject->_DynamicFieldsScreenConfigExport(
                DynamicFields => \@DynamicFieldForScreens,
            );
        }

        if ( !%Data ) {

            # redirect to AdminDynamicFieldImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminDynamicFieldImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the dynamicfielddata hash to string
        my $DynamicFieldDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $DynamicFieldDataYAML,
            Type        => 'attachment',
            Filename    => "Export_DynamicFields_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;

    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminDynamicField
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminDynamicField"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $LogObject          = $Kernel::OM->Get('Kernel::System::Log');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        # export
        my $DynamicFields = $DynamicFieldObject->GetValidDynamicFields();
        %{ $Param{Data}->{DynamicFields} } = %{$DynamicFields};
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of dynamic fields
    $Self->_DynamicFieldShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminDynamicFieldImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _DynamicFieldShow {
    my ( $Self, %Param ) = @_;

    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject        = $Kernel::OM->Get('Kernel::System::Valid');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $FieldTypeConfig = $ConfigObject->Get('DynamicFields::Driver');

    my $InvalidCounter = 0;

    # check if at least 1 dynamic field is registered in the system
    if (
        IsHashRefWithData( $Param{Data}->{DynamicFields} )
        || IsHashRefWithData( $Param{Data}->{DynamicFieldsScreens} )
        )
    {

        my @DynamicFieldsAlreadyUsed;

        DYNAMICFIELD:
        for my $DynamicField ( sort keys %{ $Param{Data}->{DynamicFields} } ) {

            push @DynamicFieldsAlreadyUsed, $DynamicField;

            my $DynamicFieldData;
            if ( IsHashRefWithData( $Param{Data}->{DynamicFields}->{$DynamicField} ) ) {
                $DynamicFieldData = $Param{Data}->{DynamicFields}->{$DynamicField};

            }
            else {
                $DynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
                    Name => $DynamicField,
                );
            }

            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldData);

            # convert ValidID to Validity string
            my $Valid = $ValidObject->ValidLookup(
                ValidID => $DynamicFieldData->{ValidID},
            );

            # get the object type display name
            my $ObjectTypeName = $ConfigObject->Get('DynamicFields::ObjectType')
                ->{ $DynamicFieldData->{ObjectType} }->{DisplayName}
                || $DynamicFieldData->{ObjectType};

            # get the field type display name
            my $FieldTypeName = $FieldTypeConfig->{ $DynamicFieldData->{FieldType} }->{DisplayName}
                || $DynamicFieldData->{FieldType};

            # get the field backend dialog
            my $ConfigDialog = $FieldTypeConfig->{ $DynamicFieldData->{FieldType} }->{ConfigDialog}
                || '';

            my %DynamicFieldData = (
                %{$DynamicFieldData},
                Valid          => $Valid,
                ConfigDialog   => $ConfigDialog,
                FieldTypeName  => $FieldTypeName,
                ObjectTypeName => $ObjectTypeName,
            );

            if ( !$ConfigDialog ) {
                if ( $InvalidCounter eq 0 ) {

                    $LayoutObject->Block(
                        Name => 'DynamicFieldsInvalidBackend',
                    );
                }

                # print each dynamic field row
                $LayoutObject->Block(
                    Name => 'DynamicFieldsRowInvalidBackend',
                    Data => {
                        %DynamicFieldData,
                    },
                );

                $InvalidCounter++;
                next DYNAMICFIELD;
            }

            for my $Blocks ( 'DynamicFieldsRow', 'DynamicFieldCheckbox', $Param{Type} ) {

                # print each dynamic field row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %DynamicFieldData,
                    },
                );
            }

            if (
                IsHashRefWithData( $Param{Data}->{DynamicFieldsScreens}->{$DynamicField} )
                || $Param{Type} ne 'Import'
                )
            {
                $LayoutObject->Block(
                    Name => 'DynamicFieldScreensCheckbox',
                    Data => {
                        %DynamicFieldData
                    },
                );
            }

        }

        DYNAMICFIELDSCREEN:
        for my $DynamicField ( sort keys %{ $Param{Data}->{DynamicFieldsScreens} } ) {

            next DYNAMICFIELDSCREEN if grep { $DynamicField eq $_ } @DynamicFieldsAlreadyUsed;
            next DYNAMICFIELDSCREEN if !IsHashRefWithData( $Param{Data}->{DynamicFieldsScreens}->{$DynamicField} );

            my $DynamicFieldsScreensData = $Param{Data}->{DynamicFieldsScreens}->{$DynamicField};

            my %DynamicFieldData = (
                Name  => $DynamicField,
                Label => 'DynamicField Screens',
            );

            for my $Blocks ( 'DynamicFieldsRow', 'DynamicFieldScreensCheckbox', $Param{Type} ) {

                # print each dynamic field row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %DynamicFieldData
                    },
                );
            }
        }
    }

    # otherwise show a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoDataFound',
            Data => \%Param,
        );
    }

    return;
}

1;
