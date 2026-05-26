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

package scripts::DBUpdateTo11_1::SysConfigDeactivateCustomerTicketSearch;

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
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigDeactivateCustomerTicketSearch - Deactivates the system configuration setting for CustomerTicketSearch per default

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $LogObject       = $Kernel::OM->Get('Kernel::System::Log');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %CustomerTicketSearchSetting = $SysConfigObject->SettingGet(
        Name => "CustomerFrontend::Module###CustomerTicketSearch",
    );

    if ( $CustomerTicketSearchSetting{IsModified} ) {
        $LogObject->Log(
            Priority => 'info',
            Message  => "Setting 'CustomerFrontend::Module###CustomerTicketSearch' already modified, doing nothing",
        );

        return 1;
    }
    if ( !$CustomerTicketSearchSetting{IsValid} ) {
        $LogObject->Log(
            Priority => 'info',
            Message  => "Setting 'CustomerFrontend::Module###CustomerTicketSearch' already invalid, doing nothing",
        );

        return 1;
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $CustomerTicketSearchSetting{DefaultID},
    );

    # Update setting with modified data
    my %Result = $SysConfigObject->SettingUpdate(
        Name              => 'CustomerFrontend::Module###CustomerTicketSearch',
        IsValid           => 0,
        EffectiveValue    => $CustomerTicketSearchSetting{EffectiveValue},
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Could not update setting 'CustomerFrontend::Module###CustomerTicketSearch'.",
        );

        return;
    }

    my $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $CustomerTicketSearchSetting{DefaultID},
    );

    if ( !$Success ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Could not unlock setting 'CustomerFrontend::Module###CustomerTicketSearch'.",
        );

        return;
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11.1 - Deactivated setting 'CustomerFrontend::Module###CustomerTicketSearch'.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => ['CustomerFrontend::Module###CustomerTicketSearch'],
    );

    if ( !$DeploymentResult{Success} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Deployment failed.",
        );

        return;
    }

    return 1;
}

1;
