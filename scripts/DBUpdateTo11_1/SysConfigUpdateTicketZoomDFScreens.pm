# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2025 Rother OSS GmbH, https://otobo.io/
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

package scripts::DBUpdateTo11_1::SysConfigUpdateTicketZoomDFScreens;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Package',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigUpdateTicketZoomDFScreens - Add process dynamic fields to ticket zoom dynamic field screen configs

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # abort if the package for removing the process information is installed
    return if $Kernel::OM->Get('Kernel::System::Package')->PackageIsInstalled(
        Name => 'CustomerTicketZoom-NoProcessInfo',
    );

    # both settings are required, therefor not using empty string as default
    my $ProcessIDDF  = $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID');
    my $ActivityIDDF = $ConfigObject->Get('Process::DynamicFieldProcessManagementActivityID');

    my %AgentTicketZoomDFScreensSetting = $SysConfigObject->SettingGet(
        Name => 'Ticket::Frontend::AgentTicketZoom###DynamicField',
    );

    return if !%AgentTicketZoomDFScreensSetting;

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $AgentTicketZoomDFScreensSetting{DefaultID},
    );

    # Update setting with modified data
    my %Result = $SysConfigObject->SettingUpdate(
        Name           => 'Ticket::Frontend::AgentTicketZoom###DynamicField',
        IsValid        => 1,
        EffectiveValue => {
            $AgentTicketZoomDFScreensSetting{EffectiveValue}->%*,
            $ProcessIDDF  => 1,
            $ActivityIDDF => 1,
        },
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not update setting Ticket::Frontend::AgentTicketZoom###DynamicField.',
        );

        return;
    }

    my $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $AgentTicketZoomDFScreensSetting{DefaultID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not unlock setting Ticket::Frontend::AgentTicketZoom###DynamicField.',
        );

        return;
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11.1 - Adapt AgentTicketZoom dynamic field screen settings.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => ['Ticket::Frontend::AgentTicketZoom###DynamicField'],
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
