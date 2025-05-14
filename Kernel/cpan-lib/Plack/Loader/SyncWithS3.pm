# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.io/
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

package Plack::Loader::SyncWithS3;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Plack::Loader);

# core modules
use File::stat;

# CPAN modules

# OTOBO modules
use Kernel::System::ModuleRefresh;
use Kernel::System::Storage::S3;

=head1 NAME

Plack::Loader::SyncWithS3 - check for package events

=head1 SYNOPSIS

    # to be used as a loader module in plackup
    plackup --server Gazelle --env deployment --port 5000 -I /opt/otobo/Kernel/cpan-lib --loader SyncWithS3  bin/psgi-bin/otobo.psgi

=head1 DESCRIPTION

This module is largely inspired from L<Plack::Loader::Restarter>. Instead of watching for changed files, this module
looks in S3 whether OTOBO packages have been added, updated or removed. If so, the webserver is stopped, packages are reinstalled,
and the web server is restarted.

=head1 PUBLIC INTERFACE

=cut

# The constructor Plack::Loader::new() is not overridden, as additional attributes like 'builder' don't have to be initialized.

=head2 preload_app()

Keep the subroutine that creates a PSGI app around. Use it for recreating the PSGI app when the webserver is restarted.

=cut

sub preload_app {
    my($Self, $Builder) = @_;

    $Self->{builder} = $Builder;

    return;
}

# Plack::Loader::watch() is not overridden, as neither bin/psgi-bin/otobo.psgi nor bin/psgi-bin/lib are watched.

sub run {
    my ($Self, $Server) = @_;

    # $Server is e.g. an instance of Plack::Handler::Gazelle
    $Self->_fork_and_start($Server);

    return unless $Self->{pid};

    # Load Kernel/Config.pm if it isn't loaded yet. Implicitly put $RelativeFile into %INC.
    if ( !require 'Kernel/Config.pm' ) {
        die "ERROR: Could not load Kernel/Config.pm: $!\n";
    }

    # Fill %Module::Refresh::Cache with the OTOBO modules in %INC if that hasn't happened before.
    # Add $RelativeFile to %Module::Refresh::Cache as $RelativeFile was required above and thus surely is in %INC.
    # Check for every request whether Kernel/Config.pm has been modified.
    Kernel::System::ModuleRefresh->refresh_module_if_modified( 'Kernel/Config.pm' );

    # Create storage S3 object for getting the Kernel/Config/Files/*.pm files.
    # For bootstrapping, pass in the values set up in Kernel/Config.pm,
    # disregarding the values from Kernel/Config/Defaults.pm and Kernel/Config/Files/*.pm.
    my $StorageS3Object = Kernel::System::Storage::S3->new(
        ConfigObject => Kernel::Config->new( Level => 'Clear' ),
    );
    my $FilesPrefix     = join '/', 'Kernel', 'Config', 'Files', '';  # no bucket, with trailing '/'

    CHECK_SYNC:
    while (1) {

        # run a blocking GET request to S3
        my %Name2Properties = $StorageS3Object->ListObjects(
            Prefix => $FilesPrefix,
        );

        # Only Package events are handled here.
        my $DoReinstallPackages = 0;
        my $EventFileName = 'event_package.json';
        if ( exists $Name2Properties{$EventFileName} ) {

            # gather info about the local event file
            my $Stat = stat "/opt/otobo/Kernel/Config/Files/$EventFileName";

            # info about the event file in S3
            my $Properties = $Name2Properties{$EventFileName};

            # reinstall packages when there is a unhandled package event
            if (
                !$Stat
                ||
                $Stat->size != $Properties->{Size}
                ||
                int($Stat->mtime) != int($Properties->{Mtime})
            )
            {
                $DoReinstallPackages = 1;
            }
        }

        if ( ! $DoReinstallPackages ) {
            # arbitrary sleep time,
            # SystemConfigurationSyncManager had sleep time of 60 s. 
            # $ModuleRefreshMiddleware had sleep time of 10 s. 
            sleep 10;

            next CHECK_SYNC;
        }

        warn "-- a new package event was detected";

        # TODO: kill web server when  sending SIGHUP does not work
        # shut down the web server
        #$Self->_kill_child;
        #warn "Successfully killed! Restarting the new server process.\n";

        # reinstall packages
        # Use the console command in order to avoid dependance on OTOBO modules in the watchdog loop
        my $Output = qx{/opt/otobo/bin/otobo.Console.pl Admin::Package::ReinstallAll};
        warn "Admin::Package::ReinstallAll: $Output";
        # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Config::Rebuild
        # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Cache::Delete

        # no locking required as there should be no concurrent access

        # update event_package.json from S3
        my $FilePath       = $FilesPrefix . $EventFileName; # $FilesPrefix already has trailing '/'
        my $TargetLocation = "/opt/otobo/Kernel/Config/Files/$EventFileName";
        $StorageS3Object->SaveObjectToFile(
            Key      => $FilePath,
            Location => $TargetLocation,
        );

        # TODO: start web server when  sending SIGHUP does not work
        #$Self->_fork_and_start($Server);

        # send SIGHUP, which should be supported by Gazelle
        $Self->_restart_child_gracefully;

        return unless $Self->{pid};

        next CHECK_SYNC;
    }
}

=head1 PRIVATE INTERFACE

=head2 _fork_and_start()

Run webserver in a child process and remember the PID of the child process.

=cut

sub _fork_and_start {
    my($Self, $Server) = @_;

    # re-init in case it's a restart
    delete $Self->{pid};

    my $PID = fork;

    die "Can't fork: $!" unless defined $PID;

    if ($PID == 0) {

        # run the webserver in the child process
        return $Server->run( $Self->{builder}->() );
    }
    else {
        $Self->{pid} = $PID;
    }

    return;
}

sub _kill_child {
    my $Self = shift;

    my $PID = $Self->{pid} or return;
    warn "Killing the existing server (pid:$PID)\n";
    kill 'TERM' => $PID;
    waitpid $PID, 0;
}

sub _restart_child_gracefully {
    my $Self = shift;

    my $PID = $Self->{pid} or return;
    warn "sending SIGHUP to the existing server (pid:$PID)\n";
    kill 'HUP' => $PID;
}

1;
