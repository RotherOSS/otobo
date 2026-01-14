# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package Kernel::Modules::AdminTypeImportExport;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Type',
    'Kernel::System::Valid',
    'Kernel::System::Web::Request',
    'Kernel::System::YAML',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TypeObject   = $Kernel::OM->Get('Kernel::System::Type');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $YAMLObject   = $Kernel::OM->Get('Kernel::System::YAML');
    my $CacheObject  = $Kernel::OM->Get('Kernel::System::Cache');

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
            Type  => 'AdminTypeImportExport',
            Key   => 'AdminTypeImportExport::' . $Self->{UserID},
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
            Type => 'AdminTypeImportExport',
            Key  => 'AdminTypeImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminType
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminType"
            );

            return $HTML;
        }

        # check required parameters
        my @TypesSelected             = $ParamObject->GetArray( Param => 'Types' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminTypeImportExport',
            Key  => 'AdminTypeImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import Types
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{Types} ) ) {

            my %TypesImport;
            TYPENAME:
            for my $TypeName ( keys $ImportData->{Types}->%* ) {

                my $Selected = grep { $TypeName eq $_ } @TypesSelected;

                next TYPENAME if !$Selected;
                next TYPENAME if !IsHashRefWithData( $ImportData->{Types}{$TypeName} );

                $TypesImport{$TypeName} = $ImportData->{Types}{$TypeName};
            }

            $TypeObject->ImportTypes(
                Types                     => \%TypesImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
        }

        # redirect to AdminType
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminType"
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
        my %Data;
        my $HTML;
        my @Types = $ParamObject->GetArray( Param => 'Types' );

        if (@Types) {
            $Data{Types} = $TypeObject->ExportTypes(
                Types => \@Types,
            );
        }

        if ( !%Data ) {

            # redirect to AdminTypeImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminTypeImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the type data hash to string
        my $TypeDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $TypeDataYAML,
            Type        => 'attachment',
            Filename    => "Export_Types_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;
    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminType
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminType"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TypeObject   = $Kernel::OM->Get('Kernel::System::Type');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        $Param{Data}{Types} = {};

        # export
        my %Types = $TypeObject->TypeList(
            Valid => 0,
        );

        # get type data
        for my $TypeID ( keys %Types ) {
            my %TypeData = $TypeObject->TypeGet(
                ID => $TypeID,
            );

            $Param{Data}{Types}{ $TypeData{Name} } = \%TypeData;
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of types
    $Self->_TypeShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminTypeImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _TypeShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');

    if ( IsHashRefWithData( $Param{Data}{Types} ) ) {

        my @TypesAlreadyUsed;

        TYPENAME:
        for my $TypeName ( sort keys $Param{Data}{Types}->%* ) {

            my $TypeData = $Param{Data}{Types}{$TypeName};

            push @TypesAlreadyUsed, $TypeData->{Name};

            next TYPENAME if !IsHashRefWithData($TypeData);

            # convert ValidID to Validity string
            my $Valid = $TypeData->{Valid} || $ValidObject->ValidLookup(
                ValidID => $TypeData->{ValidID},
            );

            my %TypeData = (
                %{$TypeData},
                Valid => $Valid,
            );

            for my $Blocks ( 'TypesRow', 'TypeCheckbox', $Param{Type} ) {

                # print each group row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %TypeData,
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
