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

package scripts::DBUpdateTo11_1::SysConfigDeactivateAutoloadModules;

use v5.26;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(scripts::DBUpdateTo11_1::Base);

# core modules

# CPAN modules
use Capture::Tiny qw(capture_stderr);

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::DBUpdateTo11_1::SysConfigDeactivateAutoloadModules - deactivate autoload modules from integrated packages

=head1 DESCRIPTION

Packages may use autoload modules for enhancing and modifying the core modules.
When a package is integrated into OTOBO core then the autoloads are usually no longer needed.
This is the case with the package C<ImportExportStandardObjects>.

The SysConfig settings for the autoload modules must be deactivated because otherwise
C<Kernel::Config> would try to load these modules. This would result in warning because
either the files are not found or found files would redefine subroutines.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # The autoload settings are not deactivated yet. So we expect some errors.
    # The user should not be bothered with these errors.
    my $SysConfigObject;
    my $CapturedStderr = capture_stderr {
        $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    };
    my $FilteredStderr = join "\n",
        grep { $_ !~ m!Subroutine \w+ redefined! }         # in case the autoload module file exists
        grep { $_ !~ m!Can't locate Kernel/Autoload/! }    # in case the autoload module file does not exist
        split /\n/, $CapturedStderr;
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # nobody else should meddle with the SysConfig
    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => 1,
    );

    # The config object already exists in the OM as one has been created in Kernel::Systest::SysConfig::new()
    my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
    my %AutoloadConfiguration = ( $ConfigObject->Get('AutoloadPerlPackages') // {} )->%*;

    # Settings for the autoload Perl modules that are no longer needed in OTOBO 11.1.x.
    my @Keys = (

        # autoloads from the integrated package ImportExportStandardObjects
        'AutoloadPerlPackages###003-GenericAgentImportExport',
        'AutoloadPerlPackages###003-GroupImportExport',
        'AutoloadPerlPackages###003-QueueImportExport',
        'AutoloadPerlPackages###003-QueueTemplatesImportExport',
        'AutoloadPerlPackages###003-RoleImportExport',
        'AutoloadPerlPackages###003-RoleGroupImportExport',
        'AutoloadPerlPackages###003-TemplateImportExport',
        'AutoloadPerlPackages###003-TypeImportExport',
    );

    KEY:
    for my $Key (@Keys) {

        # First check whether the autoload is configured as calling SettingGet()
        # on an non-existing item causes annoying log messages.
        # The autoloads is not configured when ImportExportStandardObjects was not installed in the source installation.
        ( undef, my $SubKey ) = split /###/, $Key, 2;
        my $Modules = $AutoloadConfiguration{$SubKey};

        next KEY unless ref $Modules eq 'ARRAY';

        my %Setting = $SysConfigObject->SettingGet(
            Name => $Key,
        );

        next KEY unless %Setting;
        next KEY unless $Setting{IsValid};

        # deactivate
        my %Result = $SysConfigObject->SettingUpdate(
            Name              => $Key,
            IsValid           => 0,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result{Success} ) {
            $LogObject->Log(
                Priority => 'warning',
                Message  => "Could not update setting '$Key'.",
            );
        }
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

    return 1;
}

1;
