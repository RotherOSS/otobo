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

package scripts::DBUpdateTo11_1::SysConfigUpdatePostmasterXHeader;

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
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Package',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigUpdatePostmasterXHeader - Add key 'X-OTOBO-From' to postmaster X header config

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # the setting is required, therefor not using empty array
    my $PostmasterXHeader = $ConfigObject->Get('PostmasterX-Header');

    # tackle agent-side setting
    my %PostmasterXHeaderSetting = $SysConfigObject->SettingGet(
        Name => 'PostmasterX-Header',
    );

    return if !%PostmasterXHeaderSetting;

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $PostmasterXHeaderSetting{DefaultID},
    );

    # check if key is already present to prevent duplicate
    return if ( any { $_ eq 'X-OTOBO-From' } $PostmasterXHeaderSetting{EffectiveValue}->@* );

    # Update setting with modified data
    my %Result = $SysConfigObject->SettingUpdate(
        Name           => 'PostmasterX-Header',
        IsValid        => 1,
        EffectiveValue => [
            $PostmasterXHeaderSetting{EffectiveValue}->@*,
            'X-OTOBO-From',
        ],
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not update setting PostmasterX-Header.',
        );

        return;
    }

    my $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $PostmasterXHeaderSetting{DefaultID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not unlock setting PostmasterX-Header.',
        );

        return;
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11.1 - Adapt PostmasterX-Header setting.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => ['PostmasterX-Header'],
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
