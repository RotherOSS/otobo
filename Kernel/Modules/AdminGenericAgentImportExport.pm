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

package Kernel::Modules::AdminGenericAgentImportExport;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::GenericAgent',
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
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $YAMLObject         = $Kernel::OM->Get('Kernel::System::YAML');
    my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');

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
            Type  => 'AdminGenericAgentImportExport',
            Key   => 'AdminGenericAgentImportExport::' . $Self->{UserID},
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
            Type => 'AdminGenericAgentImportExport',
            Key  => 'AdminGenericAgentImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminGenericAgent
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminGenericAgent"
            );

            return $HTML;
        }

        # check required parameters
        my @GenericAgentsSelected     = $ParamObject->GetArray( Param => 'GenericAgents' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminGenericAgentImportExport',
            Key  => 'AdminGenericAgentImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import GenericAgents
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{GenericAgents} ) ) {

            my %GenericAgentsImport;
            GENERICAGENTNAME:
            for my $GenericAgentName ( keys $ImportData->{GenericAgents}->%* ) {

                my $Selected = grep { $GenericAgentName eq $_ } @GenericAgentsSelected;

                next GENERICAGENTNAME if !$Selected;
                next GENERICAGENTNAME if !IsHashRefWithData( $ImportData->{GenericAgents}{$GenericAgentName} );

                $GenericAgentsImport{$GenericAgentName} = $ImportData->{GenericAgents}{$GenericAgentName};
            }

            my $Success = $GenericAgentObject->ImportGenericAgents(
                GenericAgents             => \%GenericAgentsImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
            if ( !$Success ) {

                # TODO show error
            }
        }

        # redirect to AdminGenericAgent
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminGenericAgent"
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
        my @GenericAgents = $ParamObject->GetArray( Param => 'GenericAgents' );

        if (@GenericAgents) {
            $Data{GenericAgents} = $GenericAgentObject->ExportGenericAgents(
                GenericAgents => \@GenericAgents,
            );
        }

        if ( !%Data ) {

            # redirect to AdminGenericAgentImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminGenericAgentImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the generic agent data hash to string
        my $GenericAgentDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $GenericAgentDataYAML,
            Type        => 'attachment',
            Filename    => "Export_GenericAgents_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;
    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminGenericAgent
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminGenericAgent"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        $Param{Data}{GenericAgents} = {};

        # export
        my %GenericAgents = $GenericAgentObject->JobList();

        # get generic agent data
        for my $GenericAgentName ( keys %GenericAgents ) {
            my %GenericAgentData = $GenericAgentObject->JobGet(
                Name => $GenericAgentName,
            );

            $Param{Data}{GenericAgents}{ $GenericAgentData{Name} } = \%GenericAgentData;
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of generic agents
    $Self->_GenericAgentShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGenericAgentImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GenericAgentShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( IsHashRefWithData( $Param{Data}{GenericAgents} ) ) {

        my @GenericAgentsAlreadyUsed;

        GENERICAGENTNAME:
        for my $GenericAgentName ( sort keys $Param{Data}{GenericAgents}->%* ) {

            my $GenericAgentData = $Param{Data}{GenericAgents}{$GenericAgentName};

            push @GenericAgentsAlreadyUsed, $GenericAgentData->{Name};

            next GENERICAGENTNAME if !IsHashRefWithData($GenericAgentData);

            my %GenericAgentData = (
                %{$GenericAgentData},
            );

            for my $Blocks ( 'GenericAgentsRow', 'GenericAgentCheckbox', $Param{Type} ) {

                # print each generic agent row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %GenericAgentData,
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
