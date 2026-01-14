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

package Kernel::Modules::AdminGroupImportExport;

use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Group',
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
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
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
            Type  => 'AdminGroupImportExport',
            Key   => 'AdminGroupImportExport::' . $Self->{UserID},
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
            Type => 'AdminGroupImportExport',
            Key  => 'AdminGroupImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminGroup
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminGroup"
            );

            return $HTML;
        }

        # check required parameters
        my @GroupsSelected            = $ParamObject->GetArray( Param => 'Groups' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminGroupImportExport',
            Key  => 'AdminGroupImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import Groups
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{Groups} ) ) {

            my %GroupsImport;
            GROUPNAME:
            for my $GroupName ( keys $ImportData->{Groups}->%* ) {

                my $Selected = grep { $GroupName eq $_ } @GroupsSelected;

                next GROUPNAME if !$Selected;
                next GROUPNAME if !IsHashRefWithData( $ImportData->{Groups}{$GroupName} );

                $GroupsImport{$GroupName} = $ImportData->{Groups}{$GroupName};
            }

            my $Success = $GroupObject->ImportGroups(
                Groups                    => \%GroupsImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
            if ( !$Success ) {

                # TODO show error
            }
        }

        # redirect to AdminGroup
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminGroup"
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
        my @Groups = $ParamObject->GetArray( Param => 'Groups' );

        if (@Groups) {
            $Data{Groups} = $GroupObject->ExportGroups(
                Groups => \@Groups,
            );
        }

        if ( !%Data ) {

            # redirect to AdminGroupImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminGroupImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the group data hash to string
        my $GroupDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $GroupDataYAML,
            Type        => 'attachment',
            Filename    => "Export_Groups_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;
    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminGroup
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminGroup"
        );

        return $HTML;
    }

    return;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    $LayoutObject->Block( Name => 'ActionOverview' );

    # call hint block
    $LayoutObject->Block(
        Name => $Param{Type} . 'Hint',
        Data => {
            %Param,
        },
    );

    if ( !$Param{Data} ) {

        $Param{Data}{Groups} = {};

        # export
        my %Groups = $GroupObject->GroupList(
            Valid => 0,
        );

        # get group data
        for my $GroupID ( keys %Groups ) {
            my %GroupData = $GroupObject->GroupGet(
                ID => $GroupID,
            );

            $Param{Data}{Groups}{ $GroupData{Name} } = \%GroupData;
        }
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of groups
    $Self->_GroupShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminGroupImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _GroupShow {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ValidObject  = $Kernel::OM->Get('Kernel::System::Valid');

    if ( IsHashRefWithData( $Param{Data}{Groups} ) ) {

        my @GroupsAlreadyUsed;

        GROUPNAME:
        for my $GroupName ( sort keys $Param{Data}{Groups}->%* ) {

            my $GroupData = $Param{Data}{Groups}{$GroupName};

            push @GroupsAlreadyUsed, $GroupData->{Name};

            next GROUPNAME if !IsHashRefWithData($GroupData);

            # convert ValidID to Validity string
            my $Valid = $GroupData->{Valid} || $ValidObject->ValidLookup(
                ValidID => $GroupData->{ValidID},
            );

            my %GroupData = (
                %{$GroupData},
                Valid => $Valid,
            );

            for my $Blocks ( 'GroupsRow', 'GroupCheckbox', $Param{Type} ) {

                # print each group row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        %GroupData,
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
