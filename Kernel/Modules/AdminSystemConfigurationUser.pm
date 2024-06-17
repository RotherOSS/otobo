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

package Kernel::Modules::AdminSystemConfigurationUser;

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

    if ( $Self->{Subaction} eq 'UserSettingValueDelete' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $Name       = $ParamObject->GetParam( Param => 'SettingName' );
        my $ModifiedID = $ParamObject->GetParam( Param => 'ModifiedID' );

        my %Result;

        if ( !$Name || !$ModifiedID ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Missing setting name or modified id!",
            );
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my %Setting         = $SysConfigObject->SettingGet(
            Name => $Name,
        );

        my $Guid;

        if ( !$Setting{ExclusiveLockGUID} ) {

            # Setting is not locked yet.
            $Guid = $SysConfigObject->SettingLock(
                UserID    => $Self->{UserID},
                DefaultID => $Setting{DefaultID},
            );
        }
        elsif ( $Setting{ExclusiveLockUserID} != $Self->{UserID} ) {

            # Someone else locked the setting.
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Setting is locked by another user!",
            );
            return $Self->_ReturnJSON( Response => \%Result );
        }
        else {

            # Already locked to this user.
            $Guid = $Setting{ExclusiveLockGUID};
        }

        if ( !$Guid ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "System was not able to lock the setting!",
            );
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my $Success = $SysConfigObject->UserSettingValueDelete(
            Name              => $Name,
            ModifiedID        => $ModifiedID,
            ExclusiveLockGUID => $Guid,
            UserID            => $Self->{UserID},
        );

        if ( !$Success ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "System was not able to delete the user setting values!",
            );
            return $Self->_ReturnJSON( Response => \%Result );
        }

        $SysConfigObject->SettingUnlock(
            DefaultID => $Setting{DefaultID},
        );

        $Result{Success} = 1;

        return $Self->_ReturnJSON( Response => \%Result );
    }

    # Show user values for the given setting.
    elsif ( $Self->{Subaction} eq 'ShowUsersSettingValue' ) {

        my %Tree        = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationNavigationTree();
        my $SettingName = $ParamObject->GetParam( Param => 'SettingName' ) || '';
        if ( !$SettingName ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate('No setting name received!'),
            );
        }

        # Get user setting values.
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my %UsersList       = $SysConfigObject->UserSettingModifiedValueList(
            Name => $SettingName,
        );

        # Get global setting value.
        my %GlobalValue = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        $GlobalValue{HTMLStrg} = $SysConfigObject->SettingRender(
            Setting                 => \%GlobalValue,
            SkipEffectiveValueCheck => 1,
            UserID                  => $Self->{UserID},
        );

        # Hide the default value.
        $GlobalValue{HTMLStrg} =~ s{WidgetMessage}{WidgetMessage Hidden};

        $GlobalValue{ChangeByName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
            UserID => $GlobalValue{ChangeBy},
        );

        my @Settings;

        SETTING:
        for my $SettingUserID ( sort keys %UsersList ) {

            my %Versions;

            # Get modified by user setting values.
            my %UserValue = $SysConfigObject->SettingGet(
                Name         => $SettingName,
                TargetUserID => $SettingUserID,
            );

            $UserValue{HTMLStrg} = $SysConfigObject->SettingRender(
                Setting                 => \%UserValue,
                SkipEffectiveValueCheck => 1,
                UserID                  => $Self->{UserID},
            );
            $UserValue{SettingUserName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
                UserID => $SettingUserID,
            );
            push @Settings, \%UserValue;
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationUserModifiedDetails',
            Data         => {
                GlobalValue    => \%GlobalValue,
                SettingList    => \@Settings,
                RootNavigation => $GlobalValue{Navigation},
                Tree           => \%Tree,
                CategoriesStrg => $Self->_GetCategoriesStrg(),
            }
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # Redirect to admin system configuration screen.
    else {

        return $LayoutObject->Redirect( OP => "Action=AdminSystemConfiguration;" );
    }
}

sub _ReturnJSON {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Response)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # JSON response
    my $JSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Response},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
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
