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

package scripts::DBUpdateTo11_1::RemoveRedisOverride;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Time)

use v5.26;
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
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::RemoveRedisOverride - no longer force Redis to be caching backend

=head1 DESCRIPTION

Up the OTOBO 11.0.x the caching backing was hardcoded the C<Kernel::System::Cache::Redis>
when running under Docker. This hard coding was done in F<Kernel/Config.pm>.
This file overrides the settings in the SysConfig.
For OTOBO 11.1.x the default caching backend is back to C<FileStorable>.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check if this needs to be executed
    if ( !$ENV{OTOBO_RUNS_UNDER_DOCKER} ) {
        print "\n\n    Skipping this step as it is relevant only for Docker based installations.\n";

        # Not running under Docker is fine
        return 1;
    }

    # Tweak Kernel/Config.pm
    my $Now    = scalar localtime;
    my $Failed = system(
        qq!$^X -i.backup_upgrade -pe 's/(?=.*\\\$Self->{.Cache::)/# commented out by DBUpdate-to-11.1.pl $Now /' /opt/otobo/Kernel/Config.pm!
    );

    if ($Failed) {
        print "\n\n    ERROR: could not tweak Kernel/Config.pm\n";

        return 0;
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $LogObject       = $Kernel::OM->Get('Kernel::System::Log');

    # Tweak the SysConfig if necessary
    my $Key     = 'Cache::Module';
    my %Setting = $SysConfigObject->SettingGet(
        Name => $Key,
    );

    if (
        %Setting
        &&
        $Setting{IsValid}
        &&
        ( $Setting{EffectiveValue} // '' ) eq 'Kernel::System::Cache::Redis'
        )
    {
        print "    changing the SysConfig setting Cache::Module to Kernel::System::Cache::FileStorable\n";

        # nobody else should meddle with the SysConfig
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            LockAll => 1,
            Force   => 1,
            UserID  => 1,
        );

        # change the setting
        my %Result = $SysConfigObject->SettingUpdate(
            Name              => $Key,
            IsValid           => 1,
            EffectiveValue    => 'Kernel::System::Cache::FileStorable',
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            $LogObject->Log(
                Priority => 'warning',
                Message  => "Could not update setting '$Key'.",
            );

            return;
        }

        my $Success = $SysConfigObject->SettingUnlock(
            UnlockAll => 1,
        );

        if ( !$Success ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Could not unlock settings.",
            );

            return;
        }

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            AllSettings => 1,
            Comments    => sprintf( 'UpgradeTo11.1 - %s', __FILE__ ),
            Force       => 1,
            UserID      => 1,
        );

        if ( !$DeploymentResult{Success} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Deployment failed.",
            );

            return;
        }
    }

    # looking good
    return 1;
}

1;
