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

package Kernel::Modules::AdminSystemConfigurationSettingHistory;

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

    my $LayoutObject    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    if ( $Self->{Subaction} eq 'ShowSettingHistory' ) {

        my %Tree = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationNavigationTree();

        my $SettingName = $ParamObject->GetParam( Param => 'SettingName' ) || '';
        if ( !$SettingName ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate('No setting name received!'),
            );
        }

        # Get setting history.
        my @SettingHistory = $SysConfigObject->SettingHistory(
            Name => $SettingName,
        );

        for my $HistoryEntry (@SettingHistory) {
            for my $HistoryType (qw(Default Modified)) {

                $HistoryEntry->{$HistoryType}->{HTMLStrg} = $SysConfigObject->SettingRender(
                    Setting                 => $HistoryEntry->{$HistoryType},
                    SkipEffectiveValueCheck => 1,
                    UserID                  => $Self->{UserID},
                );

                $HistoryEntry->{$HistoryType}->{ChangeByName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
                    UserID => $HistoryEntry->{$HistoryType}->{ChangeBy},
                );

                # Add setting label
                if (
                    $HistoryEntry->{$HistoryType}->{DeploymentTimeStamp}
                    && !$HistoryEntry->{$HistoryType}->{ResetToDefault}
                    )
                {
                    $HistoryEntry->{$HistoryType}->{SettingLabel} = Translatable('Modified Version');
                }
                elsif ( $HistoryEntry->{$HistoryType}->{ResetToDefault} ) {
                    $HistoryEntry->{$HistoryType}->{SettingLabel} = Translatable('Reset To Default');
                }
                else {
                    $HistoryEntry->{$HistoryType}->{SettingLabel} = Translatable('Default Version');
                }
            }

            $HistoryEntry->{Modified}->{ResetToThisValue} = 1;
        }

        # Do not show ResettoThisValue on current value
        $SettingHistory[0]->{Modified}->{ResetToThisValue} = 0;

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationSettingHistoryDetails',
            Data         => {
                SettingName    => $SettingName,
                SettingHistory => \@SettingHistory,
                RootNavigation => $SettingHistory[0]->{Modified}->{Navigation},
                Tree           => \%Tree,
                CategoriesStrg => $Self->_GetCategoriesStrg(),
            },
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'RevertToHistoricalValue' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        my $SettingName       = $ParamObject->GetParam( Param => 'SettingName' )       || '';
        my $ModifiedVersionID = $ParamObject->GetParam( Param => 'ModifiedVersionID' ) || '';

        my %Result;

        if ( !$SettingName || !$ModifiedVersionID ) {
            return $LayoutObject->FatalError(
                Message =>
                    $LayoutObject->{LanguageObject}->Translate('No setting name or modified version id received!'),
            );
        }

        my $RevertHistorical = $SysConfigObject->SettingRevertHistoricalValue(
            Name              => $SettingName,
            ModifiedVersionID => $ModifiedVersionID,
            UserID            => $Self->{UserID},
        );

        if ( !$RevertHistorical ) {
            return $LayoutObject->FatalError(
                Message =>
                    $LayoutObject->{LanguageObject}->Translate('Was not possible to revert the historical value!'),
            );
        }

        return $LayoutObject->Redirect( OP => "Action=AdminSystemConfiguration;Subaction=View;Setting=$SettingName" );
    }

    # Redirect to admin system configuration screen.
    else {

        return $LayoutObject->Redirect( OP => "Action=AdminSystemConfiguration;" );
    }
}

sub _GetCategoriesStrg {
    my ( $Self, %Param ) = @_;

    # get selected category
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $Category = $UserPreferences{UserSystemConfigurationCategory};

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
