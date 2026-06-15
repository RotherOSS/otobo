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

package scripts::DBUpdateTo11_1::SysConfigMigrateTimeShowCreatedAt;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigMigrateTimeShowCreatedAt - Copy package setting TimeShowCreatedAt to core setting

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return 1 unless $Kernel::OM->Get('Kernel::Config')->Get('TimeShowCreatedAt');

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # fetch old setting for checks and retrieving old value
    my %OldTimeShowCreatedAtSetting = $SysConfigObject->SettingGet(
        Name => 'TimeShowCreatedAt',
    );

    return 1 unless %OldTimeShowCreatedAtSetting;
    return 1 unless $OldTimeShowCreatedAtSetting{IsValid};

    # fetch new setting for updating and storing
    my %NewTimeShowCreatedAtSetting = $SysConfigObject->SettingGet(
        Name => 'CustomerFrontend::TimeShowCreatedAt',
    );
    if ( !%NewTimeShowCreatedAtSetting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not fetch setting 'CustomerFrontend::TimeShowCreatedAt' - aborting.",
        );

        return;
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $NewTimeShowCreatedAtSetting{DefaultID},
    );

    # value 30 is not present in core setting
    #   in that case, log message and use value 7
    my $NewEffectiveValue = $OldTimeShowCreatedAtSetting{EffectiveValue};
    if ( $NewEffectiveValue == 30 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Setting 'TimeShowCreatedAt' has value '30', which is not present in setting 'CustomerFrontend::TimeShowCreatedAt'. Using value '7' instead.",
        );

        $NewEffectiveValue = 7;
    }

    # Update setting with modified data
    my %Result = $SysConfigObject->SettingUpdate(
        Name              => 'CustomerFrontend::TimeShowCreatedAt',
        IsValid           => 1,
        EffectiveValue    => $NewEffectiveValue,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not update setting 'CustomerFrontend::TimeShowCreatedAt'.",
        );

        return;
    }

    my $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $NewTimeShowCreatedAtSetting{DefaultID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not unlock setting 'CustomerFrontend::TimeShowCreatedAt'.",
        );

        return;
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11.1 - Copy package setting 'TimeShowCreatedAt' to core setting 'CustomerFrontend::TimeShowCreatedAt'.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => ['CustomerFrontend::TimeShowCreatedAt'],
    );

    if ( !$DeploymentResult{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Deployment failed.",
        );

        return;
    }

    return 1;
}

1;
