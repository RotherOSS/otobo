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

package Kernel::Modules::AdminRoleGroupImportExport;

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
            Type  => 'AdminRoleGroupImportExport',
            Key   => 'AdminRoleGroupImportExport::' . $Self->{UserID},
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
            Type => 'AdminRoleGroupImportExport',
            Key  => 'AdminRoleGroupImportExport::' . $Self->{UserID},
        );

        if ( !IsHashRefWithData($ImportData) ) {

            # redirect to AdminRoleGroup
            my $HTML = $LayoutObject->Redirect(
                OP => "Action=AdminRoleGroup"
            );

            return $HTML;
        }

        # check required parameters
        my @RolesSelected             = $ParamObject->GetArray( Param => 'Roles' );
        my $OverwriteExistingEntities = $ParamObject->GetParam( Param => 'OverwriteExistingEntities' ) || 0;

        $CacheObject->Delete(
            Type => 'AdminRoleGroupImportExport',
            Key  => 'AdminRoleGroupImportExport::' . $Self->{UserID},
        );

        # ------------------------------------------------------------ #
        # Import RoleGroups
        # ------------------------------------------------------------ #
        if ( IsHashRefWithData( $ImportData->{RoleGroups} ) ) {

            my %RolesImport;
            ROLENAME:
            for my $RoleName ( keys $ImportData->{RoleGroups}->%* ) {

                my $Selected = grep { $RoleName eq $_ } @RolesSelected;

                next ROLENAME if !$Selected;
                next ROLENAME if !IsHashRefWithData( $ImportData->{RoleGroups}{$RoleName} );

                $RolesImport{$RoleName} = $ImportData->{RoleGroups}{$RoleName};
            }

            my $Success = $GroupObject->ImportRoleGroups(
                RoleGroups                => \%RolesImport,
                OverwriteExistingEntities => $OverwriteExistingEntities,
                UserID                    => $Self->{UserID},
            );
            if ( !$Success ) {

                # TODO show error
            }
        }

        # redirect to AdminRoleGroup
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminRoleGroup"
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
        my @Roles = $ParamObject->GetArray( Param => 'Roles' );

        if (@Roles) {
            $Data{RoleGroups} = $GroupObject->ExportRoleGroups(
                Roles => \@Roles,
            );
        }

        if ( !%Data ) {

            # redirect to AdminRoleGroupImportExport
            $HTML .= $LayoutObject->Redirect(
                OP => "Action=AdminRoleGroupImportExport;Subaction=Export",
            );
            return $HTML;
        }

        # convert the role data hash to string
        my $RoleDataYAML = $YAMLObject->Dump( Data => \%Data );

        # Get the current time formatted like '2016-01-31 14:05:45'.
        # Hoping that nobody has registered object params for Kernel::System::DateTime
        my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

        # send the result to the browser
        $HTML = $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $RoleDataYAML,
            Type        => 'attachment',
            Filename    => "Export_RoleGroups_$TimeStamp.yml",
            NoCache     => 1,
        );

        return $HTML;
    }

    # ------------------------------------------------------------ #
    # ------------------------------------------------------------ #
    else {

        # redirect to AdminRoleGroup
        my $HTML = $LayoutObject->Redirect(
            OP => "Action=AdminRoleGroup"
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

        $Param{Data}{RoleGroups} = {};

        # export
        my %Roles = $GroupObject->RoleList(
            Valid => 0,
        );

        $Param{Data}{RoleGroups} = { map { $_ => {} } values %Roles };
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # print the list of roles
    $Self->_RoleShow(
        %Param,
    );

    # output header
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminRoleGroupImportExport',
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _RoleShow {
    my ( $Self, %Param ) = @_;

    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( IsHashRefWithData( $Param{Data}{RoleGroups} ) ) {

        my @RolesAlreadyUsed;

        ROLENAME:
        for my $RoleName ( sort keys $Param{Data}{RoleGroups}->%* ) {

            push @RolesAlreadyUsed, $RoleName;

            for my $Blocks ( 'RolesRow', 'RoleCheckbox', $Param{Type} ) {

                # print each role row
                $LayoutObject->Block(
                    Name => $Blocks,
                    Data => {
                        Name => $RoleName,
                        ID   => $GroupObject->RoleLookup(
                            Role => $RoleName,
                        ),
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
