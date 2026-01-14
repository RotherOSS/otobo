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

package Kernel::Modules::AdminQueueImportExport;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Queue',
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
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
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
            Type  => 'AdminQueueImportExport',
            Key   => 'AdminQueueImportExport::' . $Self->{UserID},
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
            Type => 'AdminQueueImportExport',
            Key  => 'AdminQueueImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminQueue
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminQueue"
            );

            return $HTML;
        }

        # check required parameters
        my @QueuesSelected            = $ParamObject->GetArray( Param => 'Queues' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminQueueImportExport',
            Key  => 'AdminQueueImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import Queues
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{Queues} ) ) {

            my %QueuesImport;
            QUEUENAME:
            for my $QueueName ( keys $ImportData->{Queues}->%* ) {

                my $Selected = grep { $QueueName eq $_ } @QueuesSelected;

                next QUEUENAME if !$Selected;
                next QUEUENAME if !IsHashRefWithData( $ImportData->{Queues}{$QueueName} );

                $QueuesImport{$QueueName} = $ImportData->{Queues}{$QueueName};
            }

            my $Success = $QueueObject->ImportQueues(
                Queues                    => \%QueuesImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
            if ( !$Success ) {

                # TODO show error
            }
        }

        # redirect to AdminQueue
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminQueue"
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
        my @Queues = $ParamObject->GetArray( Param => 'Queues' );

        if (@Queues) {
            $Data{Queues} = $QueueObject->ExportQueues(
                Queues => \@Queues,
            );
        }

        if ( !%Data ) {

            # redirect to AdminQueueImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminQueueImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the queue data hash to string
        my $QueueDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $QueueDataYAML,
            Type        => 'attachment',
            Filename    => "Export_Queues_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;
    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminQueue
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminQueue"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        $Param{Data}{Queues} = {};

        # export
        my %Queues = $QueueObject->QueueList(
            Valid => 0,
        );

        # get queue data
        for my $QueueID ( keys %Queues ) {
            my %QueueData = $QueueObject->QueueGet(
                ID => $QueueID,
            );

            $Param{Data}{Queues}{ $QueueData{Name} } = \%QueueData;
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of queues
    $Self->_QueueShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminQueueImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _QueueShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');

    # check if at least 1 dynamic field is registered in the system
    if ( IsHashRefWithData( $Param{Data}{Queues} ) ) {

        my @QueuesAlreadyUsed;

        QUEUENAME:
        for my $QueueName ( sort keys $Param{Data}{Queues}->%* ) {

            my $QueueData = $Param{Data}{Queues}{$QueueName};

            push @QueuesAlreadyUsed, $QueueData->{Name};

            next QUEUENAME if !IsHashRefWithData($QueueData);

            # convert ValidID to Validity string
            my $Valid = $QueueData->{Valid} || $ValidObject->ValidLookup(
                ValidID => $QueueData->{ValidID},
            );

            my %QueueData = (
                %{$QueueData},
                Valid => $Valid,
            );

            for my $Blocks ( 'QueuesRow', 'QueueCheckbox', $Param{Type} ) {

                # print each queue row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %QueueData,
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
