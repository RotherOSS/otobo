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

package Kernel::System::SysConfig::Base::OTOBOCommunity;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::SysConfig::DB',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::SysConfig::Base::OTOBOCommunity - Base class extension for system configuration to enable OTOBO Community features.

=head1 PUBLIC INTERFACE

=head2 SettingHistory()

Returns the complete tracking of changes for a setting,
the default, current and modified values for a given setting.

    my %Result = $SysConfigObject->SettingHistory(
        DefaultID  => 45,             # optional
        Name       => 'Setting Name', # optional
        ModifiedID => 123,            # optional
    );

Returns:

    %Result = (
        Modified => [
            {
                DefaultID                => 123,
                ModifiedID               => 456,
                Name                     => "ProductName",
                Description              => "Defines the name of the application ...",
                # . . .
            },
            # . . . All the modified versions for this setting
        ],
        Default => [
            {
                DefaultID                => 123,
                ModifiedID               => 456,
                Name                     => "ProductName",
                Description              => "Defines the name of the application ...",
                . . .
            },
            # . . .  All the default versions for this setting
        },
        Current => {
            DefaultID                => 123,
            ModifiedID               => 456,
            Name                     => "ProductName",
            Description              => "Defines the name of the application ...",
            # . . .
        },
    );

=cut

sub SettingHistory {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Name!",
        );
        return;
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @ModifiedSettingVersionList = $SysConfigDBObject->ModifiedSettingVersionListGet(
        Name => $Param{Name},
    );

    if ( !@ModifiedSettingVersionList ) {

        # Get default entry
        my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
            Name => $Param{Name},
        );

        # Get corresponding default version
        my %DefaultSettingVersion = $SysConfigDBObject->DefaultSettingVersionGetLast(
            DefaultID => $DefaultSetting{DefaultID},
        );

        # Remember that there are no modified versions for this setting.
        $DefaultSettingVersion{OnlyDefault} = 1;

        push @ModifiedSettingVersionList, \%DefaultSettingVersion;
    }

    my @ModifiedSettingWithDefault;

    for my $ModifiedEntry (@ModifiedSettingVersionList) {

        my %CompleteVersion;

        # Get corresponding default version
        my %DefaultSettingVersion = $SysConfigDBObject->DefaultSettingVersionGet(
            DefaultVersionID => $ModifiedEntry->{DefaultVersionID},
        );

        $CompleteVersion{Default} = \%DefaultSettingVersion;

        # Update setting attributes.
        ATTRIBUTE:
        for my $Attribute ( sort keys %DefaultSettingVersion ) {
            next ATTRIBUTE if defined $ModifiedEntry->{$Attribute};
            $ModifiedEntry->{$Attribute} = $DefaultSettingVersion{$Attribute};
        }
        $CompleteVersion{Modified} = $ModifiedEntry;

        push @ModifiedSettingWithDefault, \%CompleteVersion;
    }

    return @ModifiedSettingWithDefault;
}

=head2 SettingRevertHistoricalValue()

Revert setting value to a previous point in history.

    my $Result = $SysConfigObject->SettingRevertHistoricalValue(
        Name              => 'Setting Name',
        ModifiedVersionID => 123,               # the id of the modified version to restore its value
        UserID            => 1,
    );

Returns:

    $Result = 1;        # or false in case of an error

=cut

sub SettingRevertHistoricalValue {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name ModifiedVersionID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Check if the setting version exists.
    my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
        ModifiedVersionID => $Param{ModifiedVersionID},
    );

    return if !%ModifiedSettingVersion;

    if ( $ModifiedSettingVersion{Name} ne $Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Setting name '$Param{Name} is invalid!",
        );

        return;
    }

    my %DefaultSettingVersion = $SysConfigDBObject->DefaultSettingVersionGet(
        DefaultVersionID => $ModifiedSettingVersion{DefaultVersionID},
    );
    return if !%DefaultSettingVersion;

    my $ExclusiveLockGUID = $Self->SettingLock(
        DefaultID => $DefaultSettingVersion{DefaultID},
        Force     => 1,
        UserID    => $Param{UserID},
    );

    if ( !$ExclusiveLockGUID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not lock setting $Param{Name}!",
        );

        return;
    }

    my %Result = $Self->SettingUpdate(
        Name              => $Param{Name},
        EffectiveValue    => $ModifiedSettingVersion{EffectiveValue},
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => $Param{UserID},
    );

    if ( !$Result{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not revert setting $Param{Name}!",
        );

        return;
    }

    my $UnlockSuccess = $Self->SettingUnlock(
        DefaultID => $DefaultSettingVersion{DefaultID},
    );

    if ( !$UnlockSuccess ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not unlock setting $Param{Name}!",
        );

        return;
    }

    return 1;
}

=head2 SettingPreviousValueGet()

Returns the previous content for a given setting.

    my %Result = $SysConfigObject->SettingPreviousValueGet(
        Name              => 'Setting Name',
        ModifiedVersionID => 456,
    );

Returns:

    %Result = (
        Name           => 'TestSetting',
        EffectiveValue => 'AValue',
        # ...
    );

=cut

sub SettingPreviousValueGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name ModifiedVersionID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
        Name => $Param{Name},
    );
    return if !%DefaultSetting;

    my %DefaultSettingVersionGetLast = $SysConfigDBObject->DefaultSettingVersionGetLast(
        DefaultID => $DefaultSetting{DefaultID},
    );
    return if !%DefaultSettingVersionGetLast;

    my @ModifiedSettingVersionList = $SysConfigDBObject->ModifiedSettingVersionListGet(
        DefaultVersionID => $DefaultSettingVersionGetLast{DefaultVersionID},
    );
    return if !@ModifiedSettingVersionList;

    if ( IsArrayRefWithData( \@ModifiedSettingVersionList ) ) {

        my $TakeVersion = 0;
        VERSIONS:
        for my $PreviousVersion (@ModifiedSettingVersionList) {

            if ( $PreviousVersion->{ModifiedVersionID} eq $Param{ModifiedVersionID} ) {
                $TakeVersion = 1;
                next VERSIONS;
            }

            if ($TakeVersion) {

                # Update default setting attributes.
                for my $Attribute (
                    qw(ModifiedID IsValid UserModificationActive EffectiveValue IsDirty CreateTime ChangeTime)
                    )
                {
                    $DefaultSetting{$Attribute} = $PreviousVersion->{$Attribute};
                }
                last VERSIONS;
            }

        }
    }

    return %DefaultSetting;
}

=head2 ConfigurationDeployRestore()

Restore a deployment from history.

- If a settings does not exist it should be skipped
- If settings value does not match it is skipped but show a log
- Deployment restore only reset modified settings to a certain version (set by deployment date)
- Once the settings has been restored to the correct version a new deployment has to be done
  (this could be optional as the admin might want to review first, so it should not be implemented by the function).

    my $Result = $SysConfigObject->ConfigurationDeployRestore(
        DeploymentID => 123,    # the deployment id
        UserID       => 456,
    );

Returns:

    $Result = 1;    # or 0 if restore configuration was not possible.

=cut

sub ConfigurationDeployRestore {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(DeploymentID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Get the modified versions involved into the deployment (and all previous)
    my %PreviousModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
        DeploymentID => $Param{DeploymentID},
        Mode         => 'SmallerThanEquals',
    );
    return 1 if !%PreviousModifiedVersionList;

    MODIFIEDVERSIONID:
    for my $ModifiedVersionID ( sort keys %PreviousModifiedVersionList ) {

        my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
            ModifiedVersionID => $ModifiedVersionID,
        );
        next MODIFIEDVERSIONID if !%ModifiedSettingVersion;

        my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
            DefaultID => $ModifiedSettingVersion{DefaultID},
        );
        next MODIFIEDVERSIONID if !%DefaultSetting;

        # Skip if settings value does not match.
        my %Result = $Self->SettingEffectiveValueCheck(
            EffectiveValue   => $ModifiedSettingVersion{EffectiveValue},
            XMLContentParsed => $DefaultSetting{XMLContentParsed},
            UserID           => $Param{UserID},
        );

        if ( $Result{Error} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => $Result{Error},
            );
            next MODIFIEDVERSIONID;
        }

        my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            DefaultID => $ModifiedSettingVersion{DefaultID},
            UserID    => $Param{UserID},
        );

        next MODIFIEDVERSIONID if !$ExclusiveLockGUID;

        $Self->SettingUpdate(
            %ModifiedSettingVersion,
            DefaultID         => $ModifiedSettingVersion{DefaultID},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => $Param{UserID},
        );

        # Unlock setting so it can be locked again afterwards.
        my $Success = $SysConfigDBObject->DefaultSettingUnlock(
            DefaultID => $ModifiedSettingVersion{DefaultID},
        );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Setting $ModifiedSettingVersion{Name} could not be unlocked!",
            );
        }
    }

    # Get the modified versions after the deployment
    my %LaterModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
        DeploymentID => $Param{DeploymentID},
        Mode         => 'GreaterThan',
    );

    return 1 if !%LaterModifiedVersionList;

    my %PreviousModifiedVersionListLookup = reverse %PreviousModifiedVersionList;

    MODIFIEDVERSIONID:
    for my $ModifiedVersionID ( sort keys %LaterModifiedVersionList ) {

        my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
            ModifiedVersionID => $ModifiedVersionID,
        );
        next MODIFIEDVERSIONID if !%ModifiedSettingVersion;

        # Skip settings that was in the previous modified list
        next MODIFIEDVERSIONID if $PreviousModifiedVersionListLookup{ $ModifiedSettingVersion{Name} };

        # Skip settings that was reset to default
        next MODIFIEDVERSIONID if $ModifiedSettingVersion{ResetToDefault};

        my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
            DefaultID => $ModifiedSettingVersion{DefaultID},
            UserID    => $Param{UserID},
        );

        next MODIFIEDVERSIONID if !$ExclusiveLockGUID;

        my $Result = $Self->SettingReset(
            Name              => $ModifiedSettingVersion{Name},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => $Param{UserID},
        );

        # Unlock setting so it can be locked again afterwards.
        my $Success = $SysConfigDBObject->DefaultSettingUnlock(
            DefaultID => $ModifiedSettingVersion{DefaultID},
        );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Setting $ModifiedSettingVersion{Name} could not be unlocked!",
            );
        }
    }

    return 1;

}

=head1 NAME

Kernel::System::SysConfig::Base::OTOBOUserSpecificSettings - Base class extension for system configurations to enable the use of user specific settings.

=head1 PUBLIC INTERFACE

=head2 UserSettingModifiedValueList()

Returns a list of users and values for modified settings by users.

    my %Result = $SysConfigObject->UserSettingModifiedValueList(
        Name => 'Setting Name',
    );

Returns:

    %Result = (
        123 => 'VALUEA',
        234 => 'VALUEB',
    );

=cut

sub UserSettingModifiedValueList {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Name!",
        );
        return;
    }

    my @ModifiedSettingsList = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->ModifiedSettingListGet(
        Name => $Param{Name},
    );

    return if !@ModifiedSettingsList;

    my %UsersModifiedSettingList = map { $_->{TargetUserID} => $_->{EffectiveValue} } grep { $_->{TargetUserID} } @ModifiedSettingsList;

    return %UsersModifiedSettingList;
}

=head2 UserSettingValueDelete()

Delete a particular or all user values for a setting.

    my $Result = $SysConfigObject->UserSettingValueDelete(
        Name                  => 'Setting Name',
        ModifiedID            => 678,                           # if an ID is defined just this entry is deleted,
                                                                #   'All' could be used as a param for deleting all the user values
        UserID                => 1,
    );

Returns:

    $Result = 1;        # or false in case of an error

=cut

sub UserSettingValueDelete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name ModifiedID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Check if the setting exists.
    my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
        Name => $Param{Name},
    );

    return if !IsHashRefWithData( \%DefaultSetting );

    my @ModifiedSettingsList;
    if ( $Param{ModifiedID} eq 'All' ) {

        @ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingListGet(
            Name => $Param{Name},
        );

        @ModifiedSettingsList = grep { $_->{TargetUserID} } @ModifiedSettingsList;
    }
    else {
        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            ModifiedID => $Param{ModifiedID},
        );

        return 1 if !$ModifiedSetting{TargetUserID};

        push @ModifiedSettingsList, \%ModifiedSetting;
    }

    return 1 if !@ModifiedSettingsList;

    MODIFIEDSETTING:
    for my $ModifiedSetting (@ModifiedSettingsList) {

        # Skip global setting.
        next MODIFIEDSETTING if !$ModifiedSetting->{TargetUserID};

        # Delete modified setting.
        my $DeleteResult = $SysConfigDBObject->ModifiedSettingDelete(
            ModifiedID => $ModifiedSetting->{ModifiedID},
        );
        if ( !$DeleteResult ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Not possible to delete Modified setting with ID: $ModifiedSetting->{ModifiedID}!",
            );
            next MODIFIEDSETTING;
        }

        # Deploy changes to user configuration file.
        my $DeploySuccess = $Self->UserConfigurationDeploy(
            Comments     => "Setting $Param{Name} reset.",
            TargetUserID => $ModifiedSetting->{TargetUserID},
        );

        if ( !$DeploySuccess ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Not possible to create configuration file for user: $ModifiedSetting->{TargetUserID}!",
            );
            next MODIFIEDSETTING;
        }
    }

    return 1;
}

=head2 UserConfigurationDeploy()

Write user configuration items from database into a perl module file.

    my $Success = $SysConfigObject->UserConfigurationDeploy(
        Comments     => "Some comments",     # (optional)
        TargetUserID => 456,

    );

Returns:

    $Success = 1;    # or false in case of an error

=cut

sub UserConfigurationDeploy {
    my ( $Self, %Param ) = @_;

    if ( !$Param{TargetUserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TargetUserID",
        );

        return;
    }
    if ( !IsPositiveInteger( $Param{TargetUserID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "TargetUserID is invalid!",
        );
        return;
    }
    my $TargetUserID = $Param{TargetUserID};

    my $BasePath     = 'Kernel/Config/Files/User/';
    my $FullBasePath = "$Self->{Home}/$BasePath";
    my $UserFile     = $FullBasePath . "$Param{TargetUserID}.pm";
    if ( !-d $FullBasePath ) {
        mkdir $FullBasePath;
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @Settings = $SysConfigDBObject->ModifiedSettingListGet(
        TargetUserID => $TargetUserID,
    );

    # If there are no settings to write, be sure to remove user file and deployment.
    if ( !@Settings ) {
        my %UserDeploymentList = reverse $SysConfigDBObject->DeploymentUserList();

        if ( $UserDeploymentList{$TargetUserID} ) {
            $SysConfigDBObject->DeploymentDelete(
                DeploymentID => $UserDeploymentList{$TargetUserID},
            );
        }

        return 1 if !-e $UserFile;

        if ( !unlink $UserFile ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "The file $UserFile could not be deleted!",
            );
            return;
        }

        return 1;
    }

    my $EffectiveValueStrg = '';
    if (@Settings) {
        $EffectiveValueStrg = $Self->_EffectiveValues2PerlFile(
            Settings   => \@Settings,
            TargetPath => $BasePath . "$TargetUserID.pm",
        );
        if ( !defined $EffectiveValueStrg ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not combine settings values into a perl hash!",
            );

            return;
        }
    }

    # Get system time stamp (string formated).
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );
    my $TimeStamp = $DateTimeObject->ToString();

    # Add a new deployment in the DB.
    my $DeploymentID = $SysConfigDBObject->DeploymentAdd(
        Comments            => $Param{Comments},
        EffectiveValueStrg  => \$EffectiveValueStrg,
        TargetUserID        => $TargetUserID,
        DeploymentTimeStamp => $TimeStamp,
        UserID              => $TargetUserID,
    );
    if ( !$DeploymentID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not create the deployment in the DB!",
        );

        return;
    }

    my @DirtyModifiedIDs;

    SETTING:
    for my $Setting (@Settings) {
        next SETTING if !$Setting->{IsDirty};

        push @DirtyModifiedIDs, $Setting->{ModifiedID};
    }

    # Remove IsDirty flag for deployed user specific settings.
    if (@DirtyModifiedIDs) {
        my $Success = $SysConfigDBObject->ModifiedSettingDirtyCleanUp(
            TargetUserID => $Param{TargetUserID},
            ModifiedIDs  => \@DirtyModifiedIDs,
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "System was unable to reset IsDirty flag for user specific setting (TargetUserID = $Param{TargetUserID})!"
            );
        }
    }

    return $Self->_FileWriteAtomic(
        Filename => $UserFile,
        Content  => \$EffectiveValueStrg,
    );
}

=head2 UserConfigurationDeploySync()

Updates C<$UserID.pm> to the latest deployment found in the database.

    my $Success = $SysConfigObject->UserConfigurationDeploySync();

=cut

sub UserConfigurationDeploySync {
    my ( $Self, %Param ) = @_;

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Check if user deployments are in sync
    my %UserDeploymentList = $SysConfigDBObject->DeploymentUserList();

    my $Home       = $Self->{Home};
    my $TargetBase = "$Home/Kernel/Config/Files/User/";

    if ( !-d $TargetBase ) {
        mkdir $TargetBase;
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Also check users without deployments, to make sure their files are cleaned up.
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Valid         => 0,
        NoOutOfOffice => 1,
    );

    USERID:
    for my $UserID ( sort keys %UserList ) {

        # User has deployment -> handled below.
        next USERID if $UserDeploymentList{$UserID};

        # User has no deployment, remove file if needed.
        my $TargetPath = $TargetBase . $UserID . '.pm';
        next USERID if !-e $TargetPath;

        if ( !unlink $TargetPath ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "The file $TargetPath could not be deleted!",
            );
        }
    }

    return 1 if !%UserDeploymentList;

    DEPLOYMENTID:
    for my $DeploymentID ( sort keys %UserDeploymentList ) {
        my $UserID = $UserDeploymentList{$DeploymentID};

        my $TargetPath  = $TargetBase . $UserID . '.pm';
        my $TargetClass = "Kernel::Config::Files::User::$UserID";

        if ( -e $TargetPath ) {

            # Load the configuration file (but remove it from INC first to get always a fresh copy)
            my %Config;
            delete $INC{$TargetPath};
            $MainObject->Require($TargetClass);

            # Persistent environments require to use do, check ConfigurationDeploymentSync.t
            do $TargetPath;
            $TargetClass->Load( \%Config );

            next DEPLOYMENTID if ( $Config{CurrentUserDeploymentID} || 0 ) eq $DeploymentID;
        }

        my %Deployment = $SysConfigDBObject->DeploymentGet(
            DeploymentID => $DeploymentID,
        );

        # Write user specific settings.
        my $Success = $Self->_FileWriteAtomic(
            Filename => $TargetPath,
            Content  => \$Deployment{EffectiveValueStrg},
        );
    }

    return 1;
}

=head2 UserConfigurationDump()

Gets a list of user specific settings in a format proper for ContigurationDump.

    my %UserConfigurationDump = $SysConfigObject->UserConfigurationDump(
        OnlyValues  => 0,                   # optional, default 0, dumps only the setting effective
                                            #   value  instead  of the whole setting attributes.
        SettingList => \@SettingList,       # as returned form $SysConfigDBObject->ModifiedSettingListGet()

Returns:

    %UserConfigurationDump = (
        JDoe => {
            Setting2 => {
                DefaultID  => 23777,
                ModifiedID => 1251,
                Name       => 'Setting2',
                # ...
            },
            # ...
        },
        # ...
    );

=cut

sub UserConfigurationDump {
    my ( $Self, %Param ) = @_;

    if ( !IsArrayRefWithData( $Param{SettingList} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings is missing or invalid!",
        );
        return;
    }

    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Valid => 1,
    );

    my %Result;

    SETTING:
    for my $Setting ( @{ $Param{SettingList} } ) {

        next SETTING if !$Setting->{TargetUserID};
        next SETTING if !$UserList{ $Setting->{TargetUserID} };

        my $Key = $UserList{ $Setting->{TargetUserID} };

        if ( $Param{OnlyValues} ) {
            $Result{$Key}->{ $Setting->{Name} } = $Setting->{EffectiveValue};
            next SETTING;
        }
        $Result{$Key}->{ $Setting->{Name} } = $Setting;
    }

    return %Result;
}

=head2 UserConfigurationResetToGlobal()

Delete and deploy user settings according with global configuration

    my $Success = $SysConfigObject->UserConfigurationResetToGlobal(
        Settings     => ['SomeSettingName1', 'SomeSettingName2'],
        UserID       => 123,
    );

=cut

sub UserConfigurationResetToGlobal {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Settings UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );

            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{Settings} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings is empty or invalid",
        );
        return;
    }

    SETTING:
    for my $SettingName ( @{ $Param{Settings} } ) {

        # Check if setting is modified by any user.
        my %UsersList = $Self->UserSettingModifiedValueList(
            Name => $SettingName,
        );

        next SETTING if !IsHashRefWithData( \%UsersList );

        # Get current setting value.
        my %Setting = $Self->SettingGet(
            Name => $SettingName,
        );

        USER:
        for my $TargetUserID ( sort keys %UsersList ) {

            my %UserValue = $Self->SettingGet(
                Name         => $SettingName,
                TargetUserID => $TargetUserID,
            );

            next USER if !%UserValue;

            my $IsDifferent = DataIsDifferent(
                Data1 => \$Setting{EffectiveValue},
                Data2 => \$UserValue{EffectiveValue},
            ) || 0;

            next USER if $IsDifferent;
            next USER if !$UserValue{ModifiedID};

            # Reset to default value (there is no need to have it duplicated).
            my $Success = $Self->UserSettingValueDelete(
                Name       => $SettingName,
                ModifiedID => $UserValue{ModifiedID},
                UserID     => $TargetUserID,
            );

            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "System was unable to delete user modification ($SettingName)!"
                );

                next USER;
            }

            my $DeploymentSuccess = $Self->UserConfigurationDeploy(
                TargetUserID => $TargetUserID,
                Comments     => "System updated user setting.",
            );

            if ( !$DeploymentSuccess ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "System was unable to deploy user setting ($SettingName)!"
                );
            }
        }
    }

    return 1;
}

1;
