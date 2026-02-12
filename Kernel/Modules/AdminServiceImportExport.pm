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

package Kernel::Modules::AdminServiceImportExport;

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
    'Kernel::System::Service',
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
    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
    my $ParamObject   = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $YAMLObject    = $Kernel::OM->Get('Kernel::System::YAML');
    my $CacheObject   = $Kernel::OM->Get('Kernel::System::Cache');

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
            Type  => 'AdminServiceImportExport',
            Key   => 'AdminServiceImportExport::' . $Self->{UserID},
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
            Type => 'AdminServiceImportExport',
            Key  => 'AdminServiceImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminService
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminService"
            );

            return $HTML;
        }

        # check required parameters
        my @ServicesSelected          = $ParamObject->GetArray( Param => 'Services' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminServiceImportExport',
            Key  => 'AdminServiceImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import Services
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{Services} ) ) {

            my %ServicesImport;
            SERVICENAME:
            for my $ServiceName ( keys $ImportData->{Services}->%* ) {

                my $Selected = grep { $ServiceName eq $_ } @ServicesSelected;
                next SERVICENAME if !$Selected;

                next SERVICENAME if !IsHashRefWithData( $ImportData->{Services}{$ServiceName} );

                $ServicesImport{$ServiceName} = $ImportData->{Services}{$ServiceName};
            }

            $ServiceObject->ImportServices(
                Services                  => \%ServicesImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
        }

        # redirect to AdminService
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminService"
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
        my @Services = $ParamObject->GetArray( Param => 'Services' );

        my %Data;
        my $HTML;

        if (@Services) {

            $Data{Services} = $ServiceObject->ExportServices(
                Services => \@Services,
                UserID   => $Self->{UserID},
            );
        }

        if ( !%Data ) {

            # redirect to AdminServiceImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminServiceImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the service data hash to string
        my $ServiceDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $ServiceDataYAML,
            Type        => 'attachment',
            Filename    => "Export_Services_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;

    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminService
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminService"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        $Param{Data}{Services} = {};

        # TODO change to ServiceListGet()
        # export
        my %Services = $ServiceObject->ServiceList(
            Valid  => 0,
            UserID => $Self->{UserID},
        );

        # get service data
        for my $ServiceID ( keys %Services ) {
            my %ServiceData = $ServiceObject->ServiceGet(
                ServiceID => $ServiceID,
                UserID    => $Self->{UserID},
            );

            $Param{Data}{Services}{ $ServiceData{Name} } = \%ServiceData;
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of services
    $Self->_ServiceShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminServiceImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _ServiceShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');

    # check if at least 1 dynamic field is registered in the system
    if ( IsHashRefWithData( $Param{Data}{Services} ) ) {

        my @ServicesAlreadyUsed;

        SERVICENAME:
        for my $ServiceName ( sort keys $Param{Data}{Services}->%* ) {

            my $ServiceData = $Param{Data}{Services}{$ServiceName};

            push @ServicesAlreadyUsed, $ServiceData->{Name};

            next SERVICENAME if !IsHashRefWithData($ServiceData);

            # convert ValidID to Validity string
            my $Valid = $ServiceData->{Valid} || $ValidObject->ValidLookup(
                ValidID => $ServiceData->{ValidID},
            );

            my %ServiceData = (
                %{$ServiceData},
                Valid => $Valid,
            );

            for my $Blocks ( 'ServicesRow', 'ServiceCheckbox', $Param{Type} ) {

                # print each service row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %ServiceData,
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
