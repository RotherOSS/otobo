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

package scripts::DBUpdateTo11_1::EnableSimilarSearchWidgetIfESActivated;

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

scripts::DBUpdateTo11_1::EnableSimilarSearchWidgetIfESActivated - Activate the Similar Search Widget if ES is activated

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my $Result          = 0;
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $ElasticsearchActivated = $ConfigObject->Get('Elasticsearch::Active');
    if ($ElasticsearchActivated) {

        my %Setting = $SysConfigObject->SettingGet(
            Name => 'Ticket::Frontend::AgentTicketZoom###Widgets###0400-SimilarTickets',
        );

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $Setting{DefaultID},
        );

        # enable similar search widget
        my %Result = $SysConfigObject->SettingUpdate(
            Name              => 'Ticket::Frontend::AgentTicketZoom###Widgets###0400-SimilarTickets',
            IsValid           => 1,
            UserID            => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            EffectiveValue    => $Setting{EffectiveValue},
        );

        if ( !$Result{Success} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Could not activate the Similar Ticket Search Widget for the TicketZoom mask.',
            );

            return $Result;
        }
        else {
            $Result = 1;
        }

        my $Success = $SysConfigObject->SettingUnlock(
            UserID    => 1,
            DefaultID => $Setting{DefaultID},
        );
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "UpgradeTo11.1 - Activate the Similar Search Widget if ES is activated.",
        UserID        => 1,
        Force         => 1,
        DirtySettings => ['Ticket::Frontend::AgentTicketZoom###Widgets###0400-SimilarTickets'],
    );

    if ( !$DeploymentResult{Success} ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Deployment failed.",
        );

        $Result = 0;
    }

    return $Result;
}

1;
