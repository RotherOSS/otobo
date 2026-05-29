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

package scripts::DBUpdateTo11_1::SysConfigMigrateDynamicFieldNamespaces;

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

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigMigrateDynamicFieldNamespaces - Copy dynamic field namespaces from old sysconfig to new sysconfig

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # fetch old setting for checks and retrieving old value
    my %OldDynamicFieldNamespacesSetting = $SysConfigObject->SettingGet(
        Name => 'DynamicField::Namespaces',
    );
    if ( !%OldDynamicFieldNamespacesSetting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not fetch setting 'DynamicField::Namespaces' - aborting."
        );
    }

    # report success if setting is undef (not activated) or value is empty
    return 1 unless %OldDynamicFieldNamespacesSetting;
    return 1 unless IsArrayRefWithData( $OldDynamicFieldNamespacesSetting{EffectiveValue}->@* );

    # fetch new setting for updating and storing
    my %NewDynamicFieldNamespacesSetting = $SysConfigObject->SettingGet(
        Name => 'Namespaces###DynamicField',
    );
    if ( !%NewDynamicFieldNamespacesSetting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not fetch setting 'Namespaces###DynamicField' - aborting."
        );
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $NewDynamicFieldNamespacesSetting{DefaultID},
    );

    # Update setting with modified data
    my %Result = $SysConfigObject->SettingUpdate(
        Name              => 'Namespaces###DynamicField',
        IsValid           => 1,
        EffectiveValue    => $OldDynamicFieldNamespacesSetting{EffectiveValue},
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not update setting 'Namespaces###DynamicField'.",
        );

        return;
    }

    my $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $NewDynamicFieldNamespacesSetting{DefaultID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not unlock setting 'Namespaces###DynamicField'.",
        );

        return;
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11.1 - Copy dynamic field namespaces from 'DynamicField::Namespaces' to 'Namespaces###DynamicField'.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => ['Namespaces###DynamicField'],
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
