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

package Kernel::System::SysConfig::Base::SettingHistory;

=head1 NAME

Kernel::System::SysConfig::Base::SettingHistory - Base class extension for system configuration to enable the setting history feature.

=head1 PUBLIC INTERFACE

=cut

use strict;
use warnings;
use v5.24;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::SysConfig::DB',
);

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

1;
