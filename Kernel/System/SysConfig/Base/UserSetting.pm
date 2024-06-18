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

package Kernel::System::SysConfig::Base::UserSetting;

=head1 NAME

Kernel::System::SysConfig::Base::UserSetting - Base class extension for system configurations to enable the use of user specific settings.

=head1 PUBLIC INTERFACE

=cut

use v5.24;
use strict;
use warnings;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::ModuleRefresh;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::SysConfig::DB',
    'Kernel::System::User',
);

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

    return unless @ModifiedSettingsList;

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
When the S3 backend is active then the file is stored only in S3.

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
    my $UserFile     = $FullBasePath . "$TargetUserID.pm";
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

        # delete in S3
        if ( $Self->{S3Active} ) {
            my $StorageS3Object = Kernel::System::Storage::S3->new();
            my $S3Key           = join '/', 'Kernel', 'Config', 'Files', 'User', "$TargetUserID.pm";
            $StorageS3Object->DiscardObject(
                Key => $S3Key,
            );
        }

        # remove user file in the file system
        return 1 unless -e $UserFile;

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
            TargetUserID => $TargetUserID,
            ModifiedIDs  => \@DirtyModifiedIDs,
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "System was unable to reset IsDirty flag for user specific setting (TargetUserID = $TargetUserID)!"
            );
        }
    }

    if ( $Self->{S3Active} ) {

        # only write to S3
        my $StorageS3Object = Kernel::System::Storage::S3->new();
        my $S3Key           = join '/', 'Kernel', 'Config', 'Files', 'User', "$TargetUserID.pm";

        return $StorageS3Object->StoreObject(
            Key     => $S3Key,
            Content => $EffectiveValueStrg,
        );
    }

    return $Self->_FileWriteAtomic(
        Filename => $UserFile,
        Content  => \$EffectiveValueStrg,
    );
}

=head2 UserConfigurationDeploySync()

Remove user config files that do not have deployments in the database.
Updates the C<$UserID.pm> files to the latest deployments found in the database.

    my $Success = $SysConfigObject->UserConfigurationDeploySync();

=cut

sub UserConfigurationDeploySync {
    my ( $Self, %Param ) = @_;

    # Check if user deployments are in sync
    my $SysConfigDBObject  = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
    my %UserDeploymentList = $SysConfigDBObject->DeploymentUserList();

    my $BasePath     = 'Kernel/Config/Files/User/';
    my $FullBasePath = "$Self->{Home}/$BasePath";

    if ( !-d $FullBasePath ) {
        mkdir $FullBasePath;
    }

    # Also check users without deployments, to make sure their files are cleaned up.
    my %UserList = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Valid         => 0,
        NoOutOfOffice => 1,
    );

    # collect some info before discarding files in the S3 User dir
    my ( $StorageS3Object, $S3UserPath, %S3UserIDFound );
    if ( $Self->{S3Active} ) {
        $StorageS3Object = Kernel::System::Storage::S3->new();
        $S3UserPath      = join '/', 'Kernel', 'Config', 'Files', 'User';
        my %SubPath2Properties = $StorageS3Object->ListObjects(
            Prefix    => "$S3UserPath/",
            Delimiter => '',
        );
        %S3UserIDFound =
            map { $_ => 1 }
            map {s/\.pm$//r}
            keys %SubPath2Properties;
    }

    # clean up obsolete user settings
    USERID:
    for my $UserID ( sort keys %UserList ) {

        # do not discard user settings for users that have a deployment
        next USERID if $UserDeploymentList{$UserID};

        # delete in S3 when there is an user file
        if ( $Self->{S3Active} && $S3UserIDFound{$UserID} ) {
            $StorageS3Object->DiscardObject(
                Key => "$S3UserPath/$UserID.pm",
            );
        }

        # delete the user setting file if it exists
        my $FullTargetPath = $FullBasePath . $UserID . '.pm';

        next USERID unless -e $FullTargetPath;

        if ( !unlink $FullTargetPath ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "The file $FullTargetPath could not be deleted!",
            );
        }
    }

    return 1 unless %UserDeploymentList;

    DEPLOYMENTID:
    for my $DeploymentID ( sort keys %UserDeploymentList ) {
        my $UserID = $UserDeploymentList{$DeploymentID};

        my $TargetPath     = $BasePath . $UserID . '.pm';
        my $FullTargetPath = $FullBasePath . $UserID . '.pm';
        my $TargetClass    = "Kernel::Config::Files::User::$UserID";

        if ( -e $FullTargetPath ) {

            # load a fresh copy the user setting file
            Kernel::System::ModuleRefresh->refresh_module($TargetPath);

            # Get the setting from the user settings file
            my %Config;
            $TargetClass->Load( \%Config );

            next DEPLOYMENTID if ( $Config{CurrentUserDeploymentID} || 0 ) eq $DeploymentID;
        }

        my %Deployment = $SysConfigDBObject->DeploymentGet(
            DeploymentID => $DeploymentID,
        );

        # Write user specific settings.
        if ( $Self->{S3Active} ) {

            # only write to S3, SyncWithS3() will be called later
            my $StorageS3Object = Kernel::System::Storage::S3->new();
            my $S3Key           = join '/', 'Kernel', 'Config', 'Files', 'User', "$UserID.pm";
            $StorageS3Object->StoreObject(
                Key     => $S3Key,
                Content => $Deployment{EffectiveValueStrg},
            );
        }
        else {
            $Self->_FileWriteAtomic(
                Filename => $FullTargetPath,
                Content  => \$Deployment{EffectiveValueStrg},
            );
        }
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
