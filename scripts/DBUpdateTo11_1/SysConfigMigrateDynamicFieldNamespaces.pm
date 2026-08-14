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

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigMigrateDynamicFieldNamespaces - Copy dynamic field namespaces from old sysconfig to new sysconfig

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # prevent error message due to invalid setting
    return 1 unless $Kernel::OM->Get('Kernel::Config')->Get('DynamicField::Namespaces');

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # fetch old setting for checks and retrieving old value
    my %OldDynamicFieldNamespacesSetting = $SysConfigObject->SettingGet(
        Name => 'DynamicField::Namespaces',
    );
    if ( !%OldDynamicFieldNamespacesSetting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Could not fetch setting 'DynamicField::Namespaces' - aborting."
        );

        return 1;
    }

    return 1 unless ( ref $OldDynamicFieldNamespacesSetting{EffectiveValue} eq 'ARRAY' );

    # sort out empty strings in old value
    my @OldSettingEffectiveValue = grep {$_} $OldDynamicFieldNamespacesSetting{EffectiveValue}->@*;

    # report success if value is empty
    return 1 unless @OldSettingEffectiveValue;

    # fetch new setting for updating and storing
    #   NOTE old dynamic field namespaces are migrated to new global namespaces
    my %NewGlobalNamespacesSetting = $SysConfigObject->SettingGet(
        Name => 'Namespaces###Global',
    );
    if ( !%NewGlobalNamespacesSetting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not fetch setting 'Namespaces###Global' - aborting."
        );

        return;
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $NewGlobalNamespacesSetting{DefaultID},
    );

    # Update setting with modified data
    my %Result = $SysConfigObject->SettingUpdate(
        Name              => 'Namespaces###Global',
        IsValid           => 1,
        EffectiveValue    => \@OldSettingEffectiveValue,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not update setting 'Namespaces###Global'.",
        );

        return;
    }

    my $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $NewGlobalNamespacesSetting{DefaultID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not unlock setting 'Namespaces###Global'.",
        );

        return;
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11.1 - Copy dynamic field namespaces from 'DynamicField::Namespaces' to 'Namespaces###Global'.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => ['Namespaces###Global'],
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
