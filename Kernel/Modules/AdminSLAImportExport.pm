# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
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

package Kernel::Modules::AdminSLAImportExport;

use strict;
use warnings;

# core modules
use List::AllUtils qw(first);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::SLA',
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
    my $SLAObject    = $Kernel::OM->Get('Kernel::System::SLA');
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
            Type  => 'AdminSLAImportExport',
            Key   => 'AdminSLAImportExport::' . $Self->{UserID},
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
            Type => 'AdminSLAImportExport',
            Key  => 'AdminSLAImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminSLA
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminSLA"
            );

            return $HTML;
        }

        # check required parameters
        my @SLAsSelected              = $ParamObject->GetArray( Param => 'SLAs' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminSLAImportExport',
            Key  => 'AdminSLAImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import SLAs
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{SLAs} ) ) {

            my %SLAImport;
            SLANAME:
            for my $SLAName ( keys $ImportData->{SLAs}->%* ) {

                my $Selected = grep { $SLAName eq $_ } @SLAsSelected;
                next SLANAME if !$Selected;

                next SLANAME if !IsHashRefWithData( $ImportData->{SLAs}{$SLAName} );

                $SLAImport{$SLAName} = $ImportData->{SLAs}{$SLAName};
            }

            $SLAObject->ImportSLAs(
                SLAs                      => \%SLAImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
        }

        # redirect to AdminSLA
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminSLA"
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
        my @SLAs = $ParamObject->GetArray( Param => 'SLAs' );

        my %Data;
        my $HTML;

        if (@SLAs) {

            $Data{SLAs} = $SLAObject->ExportSLAs(
                SLAs   => \@SLAs,
                UserID => $Self->{UserID},
            );
        }

        if ( !%Data ) {

            # redirect to AdminSLAImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminSLAImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the SLA data hash to string
        my $SLADataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $SLADataYAML,
            Type        => 'attachment',
            Filename    => "Export_SLAs_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;

    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminSLA
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminSLA"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SLAObject    = $Kernel::OM->Get('Kernel::System::SLA');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        $Param{Data}{SLAs} = {};

        # TODO change to SLAListGet()
        # export
        my %SLAs = $SLAObject->SLAList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # get SLA data
        for my $SLAID ( keys %SLAs ) {
            my %SLAData = $SLAObject->SLAGet(
                SLAID  => $SLAID,
                UserID => $Self->{UserID},
            );

            $Param{Data}{SLAs}{ $SLAData{Name} } = \%SLAData;
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of SLAs
    $Self->_SLAShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminSLAImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _SLAShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');

    # check if at least 1 dynamic field is registered in the system
    if ( IsHashRefWithData( $Param{Data}{SLAs} ) ) {

        my @SLAsAlreadyUsed;

        SLANAME:
        for my $SLAName ( sort keys $Param{Data}{SLAs}->%* ) {

            my $SLAData = $Param{Data}{SLAs}{$SLAName};

            push @SLAsAlreadyUsed, $SLAData->{Name};

            next SLANAME if !IsHashRefWithData($SLAData);

            # convert ValidID to Validity string
            my $Valid = $SLAData->{Valid} || $ValidObject->ValidLookup(
                ValidID => $SLAData->{ValidID},
            );

            my %SLAData = (
                %{$SLAData},
                Valid => $Valid,
            );

            for my $Blocks ( 'SLAsRow', 'SLACheckbox', $Param{Type} ) {

                # print each SLA row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %SLAData,
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
