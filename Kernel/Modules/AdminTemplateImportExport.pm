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

package Kernel::Modules::AdminTemplateImportExport;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::StandardTemplate',
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
    my $LayoutObject           = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
    my $ParamObject            = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $YAMLObject             = $Kernel::OM->Get('Kernel::System::YAML');
    my $CacheObject            = $Kernel::OM->Get('Kernel::System::Cache');

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
            Type  => 'AdminTemplateImportExport',
            Key   => 'AdminTemplateImportExport::' . $Self->{UserID},
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
            Type => 'AdminTemplateImportExport',
            Key  => 'AdminTemplateImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminTemplate
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminTemplate"
            );

            return $HTML;
        }

        # check required parameters
        my @TemplatesSelected         = $ParamObject->GetArray( Param => 'Templates' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminTemplateImportExport',
            Key  => 'AdminTemplateImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import Templates
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{Templates} ) ) {

            my %TemplatesImport;
            TEMPLATENAME:
            for my $TemplateName ( keys $ImportData->{Templates}->%* ) {

                my $Selected = grep { $TemplateName eq $_ } @TemplatesSelected;

                next TEMPLATENAME if !$Selected;
                next TEMPLATENAME if !IsHashRefWithData( $ImportData->{Templates}{$TemplateName} );

                $TemplatesImport{$TemplateName} = $ImportData->{Templates}{$TemplateName};
            }

            my $Success = $StandardTemplateObject->ImportTemplates(
                Templates                 => \%TemplatesImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
            if ( !$Success ) {

                # TODO show error
            }
        }

        # redirect to AdminTemplate
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminTemplate"
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
        my @Templates = $ParamObject->GetArray( Param => 'Templates' );

        if (@Templates) {
            $Data{Templates} = $StandardTemplateObject->ExportTemplates(
                Templates => \@Templates,
            );
        }

        if ( !%Data ) {

            # redirect to AdminTemplateImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminTemplateImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the template data hash to string
        my $TemplateDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $TemplateDataYAML,
            Type        => 'attachment',
            Filename    => "Export_Templates_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;
    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminTemplate
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminTemplate"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject           = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        $Param{Data}{Templates} = {};

        # export
        my %Templates = $StandardTemplateObject->StandardTemplateList(
            Valid => 0,
        );

        # get template data
        for my $TemplateID ( keys %Templates ) {
            my %TemplateData = $StandardTemplateObject->StandardTemplateGet(
                ID => $TemplateID,
            );

            $Param{Data}{Templates}{ $TemplateData{Name} } = \%TemplateData;
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of templates
    $Self->_TemplateShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminTemplateImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _TemplateShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');

    if ( IsHashRefWithData( $Param{Data}{Templates} ) ) {

        my @TemplatesAlreadyUsed;

        TEMPLATENAME:
        for my $TemplateName ( sort keys $Param{Data}{Templates}->%* ) {

            my $TemplateData = $Param{Data}{Templates}{$TemplateName};

            push @TemplatesAlreadyUsed, $TemplateData->{Name};

            next TEMPLATENAME if !IsHashRefWithData($TemplateData);

            # convert ValidID to Validity string
            my $Valid = $TemplateData->{Valid} || $ValidObject->ValidLookup(
                ValidID => $TemplateData->{ValidID},
            );

            my %TemplateData = (
                %{$TemplateData},
                Valid => $Valid,
            );

            for my $Blocks ( 'TemplatesRow', 'TemplateCheckbox', $Param{Type} ) {

                # print each template row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %TemplateData,
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
