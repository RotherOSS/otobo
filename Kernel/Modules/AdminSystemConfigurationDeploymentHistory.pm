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

package Kernel::Modules::AdminSystemConfigurationDeploymentHistory;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $EntityType = $ParamObject->GetParam( Param => 'EntityType' ) || '';

    if ($EntityType) {

        # Set Entity Type.
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastEntityType',
            Value     => $EntityType,
        );

        # Update also environment at this moment to include the link in the sidebar
        $LayoutObject->SetEnv(
            Key   => 'LastEntityType',
            Value => $EntityType,
        );
    }

    # collect some data which needs to be passed to several screens
    my %OutputData = (
        CategoriesStrg => $Self->_GetCategoriesStrg(),
    );

    # Show the deployment history
    if ( $Self->{Subaction} eq 'DeploymentHistory' ) {

        my @List = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentListGet();

        for my $Deployment (@List) {
            $Deployment->{DeploymentRestore} = 1;
        }

        # Prevent last deployment to show restore button.
        $List[0]->{DeploymentRestore} = 0;

        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        for my $Item ( sort @List ) {
            $Item->{CreateByName} = $UserObject->UserName(
                UserID => $Item->{CreateBy},
            );
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        my $EmptyDeploymentExport = $ParamObject->GetParam( Param => 'EmptyDeploymentExport' ) || '';
        if ($EmptyDeploymentExport) {
            $Output .= $LayoutObject->Notify(
                Info => $LayoutObject->{LanguageObject}->Translate(
                    "This deployment does not contain changes in the setting values!"
                ),
            );
        }

        my $TemplateFile = 'AdminSystemConfiguration';

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationDeploymentHistory',
            Data         => {
                List => \@List,
                %OutputData,
            },
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # Show the deployment history details
    elsif ( $Self->{Subaction} eq 'DeploymentHistoryDetails' ) {

        my $DeploymentID = $ParamObject->GetParam( Param => 'DeploymentID' ) || '';
        if ( !$DeploymentID ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate('No DeploymentID received!'),
            );
        }

        # get data of the deployment
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my %Deployment      = $SysConfigObject->ConfigurationDeployGet(
            DeploymentID => $DeploymentID,
        );

        $Deployment{CreateByName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
            UserID => $Deployment{CreateBy},
        );

        my @SettingList = $SysConfigObject->ConfigurationDeploySettingsListGet(
            DeploymentID => $DeploymentID,
        );

        my @Settings;

        SETTING:
        for my $Setting (@SettingList) {
            my $ModifiedVersionID = $Setting->{ModifiedVersionID} || 0;

            next SETTING if !$ModifiedVersionID;

            my %Versions;

            $Versions{Initial} = $Setting;

            # Get previous version
            my %PreviousValues = $SysConfigObject->SettingPreviousValueGet(
                ModifiedVersionID => $ModifiedVersionID,
                Name              => $Setting->{Name},
            );

            $Versions{Previous} = \%PreviousValues;

            push @Settings, \%Versions;
        }

        for my $Setting (@Settings) {

            $Setting->{CurrentName}  = $Setting->{Initial}->{Name};
            $Setting->{PreviousName} = $Setting->{Previous}->{Name};
            $Setting->{Navigation}   = $Setting->{Initial}->{Navigation};

            $Setting->{HTMLStrg} = $SysConfigObject->SettingRender(
                Setting                 => $Setting->{Initial},
                SkipEffectiveValueCheck => 1,
                UserID                  => $Self->{UserID},
            );
            $Setting->{PreviousHTMLStrg} = $SysConfigObject->SettingRender(
                Setting                 => $Setting->{Previous},
                SkipEffectiveValueCheck => 1,
                UserID                  => $Self->{UserID},
            );
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationDeploymentHistoryDetails',
            Data         => {
                DeploymentID => $DeploymentID,
                SettingList  => \@Settings,
                %OutputData,
                %Deployment,
            },
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'DeploymentRestore' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $DeploymentID = $ParamObject->GetParam( Param => 'DeploymentID' ) || '';
        if ( !$DeploymentID ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate('No DeploymentID received!'),
            );
        }

        # get data of the deployment
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $RestoreResult   = $SysConfigObject->ConfigurationDeployRestore(
            DeploymentID => $DeploymentID,
            UserID       => $Self->{UserID},
        );

        if ( !$RestoreResult ) {

            return $LayoutObject->ErrorScreen(
                Message =>
                    'System Configuration could not be restored due to a unknown error, please check OTOBO logs for more information',
            );
        }

        return $LayoutObject->Redirect(
            OP => "Action=AdminSystemConfigurationDeployment;Subaction=Deployment;DeploymentRestore=1"
        );
    }

    # Export deployment.
    elsif ( $Self->{Subaction} eq 'DeploymentExport' ) {

        my $DeploymentID = $ParamObject->GetParam( Param => 'DeploymentID' );
        my $Filename     = "Export_Deployment_$DeploymentID.yml";

        # Get configuration data.
        my $ConfigurationDumpYAML = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationDump(
            SkipDefaultSettings => 1,               # keep it hardcoded due default settings are not needed
            DeploymentID        => $DeploymentID,
        );

        if ( !$ConfigurationDumpYAML ) {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=DeploymentHistory;EmptyDeploymentExport=1;"
            );
        }

        # Send the result to the browser.
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $ConfigurationDumpYAML,
            Type        => 'attachment',
            Filename    => $Filename,
            NoCache     => 1,
        );
    }

    # Just show the overview.
    else {

        # secure mode message (don't allow this action till secure mode is enabled)
        if ( !$Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
            return $LayoutObject->SecureMode();
        }

        return $LayoutObject->Redirect( OP => "Action=AdminSystemConfiguration" );
    }
}

sub _GetCategoriesStrg {
    my ( $Self, %Param ) = @_;

    # get selected category
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $Category = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Category' )
        || $UserPreferences{UserSystemConfigurationCategory};
    my %Categories = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationCategoriesGet();

    my %CategoryData = map { $_ => $Categories{$_}->{DisplayName} } keys %Categories;

    my $CategoriesStrg = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data         => \%CategoryData,
        Name         => 'Category',
        SelectedID   => $Category || 'All',
        PossibleNone => 0,
        Translation  => 1,
        Sort         => 'AlfaNumericKey',
        Class        => 'Modernize',
        Title        => $Kernel::OM->Get('Kernel::Language')->Translate('Category Search'),
    );

    return $CategoriesStrg;
}
1;
