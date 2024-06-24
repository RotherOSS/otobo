# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.io/
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

package Kernel::System::Daemon::DaemonModules::SyncWithS3;

use v5.24;
use strict;
use warnings;
use utf8;

use parent qw(Kernel::System::Daemon::BaseDaemon Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

# core modules
use File::stat qw(stat);

# CPAN modules

# OTOBO modules
use Kernel::System::Storage::S3 ();

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SyncWithS3 - daemon to re-install packages when packages are installed

=head1 DESCRIPTION

Reinstall packages on the current node when packages were installed via another node. This functionality
is similar to L<Plack::Loader::SyncWithS3>, which also re-installs packages.

This means that this daemon module does not have to be activated on nodes where a web server is running.

=head1 PUBLIC INTERFACE

=head2 new()

Create sync object.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = bless {}, $Type;

    # Get objects in constructor to save performance.
    $Self->{Home} = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # Do not change the following values!
    $Self->{SleepPost} = 10;         # sleep 10 seconds after each loop
    $Self->{Discard}   = 60 * 60;    # discard every hour

    $Self->{DiscardCount} = $Self->{Discard} / $Self->{SleepPost};

    $Self->{Debug}      = $Param{Debug};
    $Self->{DaemonName} = 'Daemon: SyncWithS3';

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # Check if database is on-line.
    return 1 if $Self->{DBObject}->Ping();

    sleep 10;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Execute the S3 sync
    if ( $Self->{Debug} ) {
        print "    $Self->{DaemonName} Executes function: SyncWithS3\n";
    }

    my $StorageS3Object = Kernel::System::Storage::S3->new();
    my $FilesPrefix     = join '/', 'Kernel', 'Config', 'Files';

    # run a blocking GET request to S3
    my %Name2Properties = $StorageS3Object->ListObjects(
        Prefix => "$FilesPrefix/",
    );

    # Only Package events are handled here.
    my $EventFileName = 'event_package.json';

    return 1 unless exists $Name2Properties{$EventFileName};

    my $DoReinstallPackages = 0;
    my $EventFileLocation   = "$Self->{Home}/Kernel/Config/Files/$EventFileName";

    {
        my $DoReinstallPackages = 0;

        # gather info about the local file
        my $Stat = stat $EventFileLocation;

        # info about the event file in S3
        my $Properties = $Name2Properties{$EventFileName};

        # reinstall packages when there is a unhandled package event
        if (
            !$Stat
            ||
            $Stat->size != $Properties->{Size}
            ||
            $Stat->mtime != $Properties->{Mtime}
            )
        {
            $DoReinstallPackages = 1;
        }

        return 1 unless $DoReinstallPackages;
    }

    warn "-- a new package event was detected";

    # TODO: what about locking
    # reinstall packages
    # Use the console command in order to avoid dependance on OTOBO modules in the watchdog loop
    my $Output = qx{$Self->{Home}/bin/otobo.Console.pl Admin::Package::ReinstallAll};
    warn "Admin::Package::ReinstallAll: $Output";

    # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Config::Rebuild
    # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Cache::Delete

    # no locking required as there should be no concurrent access

    # update event_package.json from S3
    my $FilePath = $FilesPrefix . $EventFileName;    # $FilesPrefix already has trailing '/'
    $StorageS3Object->SaveObjectToFile(
        Key      => $FilePath,
        Location => $EventFileLocation,
    );

    # Stop all daemons and reload configuration from main daemon.
    kill 'HUP', getppid;

    return 1;
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    sleep $Self->{SleepPost};

    $Self->{DiscardCount}--;

    if ( $Self->{Debug} && $Self->{DiscardCount} == 0 ) {
        print "  $Self->{DaemonName} will be stopped and set for restart!\n";
    }

    return if $Self->{DiscardCount} <= 0;
    return 1;
}

sub Summary {
    my ( $Self, %Param ) = @_;

    return (
        {
            Header        => "System configuration sync:",
            Column        => [],
            Data          => [],
            NoDataMessage => "Daemon is active.",
        },
    );
}

sub DESTROY {
    my $Self = shift;

    return 1;
}

1;
