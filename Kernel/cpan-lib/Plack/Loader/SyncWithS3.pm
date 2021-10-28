# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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
use Mojo::AWS::S3;
use Mojo::DOM;
use Mojo::Date;
use Mojo::URL;
use Mojo::UserAgent;

# OTOBO modules

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

    # TODO: AWS region must be set up in Kubernetes config map
    my $Region = 'eu-central-1';

    # generate Mojo transaction for submitting plain to S3
    # TODO: AWS bucket must be set up in Kubernetes config map
    my $Bucket      = 'otobo-20211018a';
    my $FilesPrefix = join '/', 'OTOBO', 'Kernel', 'Config', 'Files', '';  # no bucket, with trailing '/'

    my $UserAgent = Mojo::UserAgent->new();
    my $S3Object  = Mojo::AWS::S3->new(
        transactor => $UserAgent->transactor,
        service    => 's3',
        region     => $Region,
        access_key => 'test',
        secret_key => 'test',
    );

    CHECK_SYNC:
    while (1) {

        # TODO: AWS region must be set up in Kubernetes config map
        # REST request to S3
        # extract the relevant info from the returned XML
        # expect something like:
        #   %FileName2Size         = ( 'ZZZAAuto.pm' => 325269 );
        #   %FileName2LastModified = ( 'ZZZAAuto.pm' => 1634912805 );
        my (%FileName2Size, %FileName2LastModified);
        {
            # Use localstack as host, as we run within container
            # For the interface see https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectsV2.html.
            my $URL = Mojo::URL->new
                ->scheme('https')
                ->host('localstack:4566')
                ->path( $Bucket );
            $URL->query(
                [
                    'list-type' => 2,
                    prefix      => $FilesPrefix,
                    delimiter   => '/'
                ]
            );

            my $Now         = Mojo::Date->new(time)->to_datetime;
            my $Transaction = $S3Object->signed_request(
                method   => 'GET',
                datetime => $Now,
                url      => $URL,
            );

            # run blocking request
            $UserAgent->start($Transaction);

            # look at the Contents nodes in the returned XML
            $Transaction->res->dom->find('Contents')->map(
                sub {
                    my ($ContentNode) = @_;

                    # also keep the objects in the subdirectories, but relative to the prefix
                    my $Filename = $ContentNode->at('Key')->text =~ s/^\Q$FilesPrefix\E//r;

                    $FileName2Size{$Filename} = $ContentNode->at('Size')->text;

                    # LastModified is actually the time when the file was uploaded
                    my $ISO8601 = $ContentNode->at('LastModified')->text;
                    my $Epoch   = Mojo::Date->new($ISO8601)->epoch;
                    $FileName2LastModified{$Filename} = $Epoch;
                }
            );
        }

        # Only Package events are handled here.
        my $DoReinstallPackages = 0;
        my $EventFileName = 'event_package.json';
        if ( exists $FileName2Size{$EventFileName} && exists $FileName2LastModified{$EventFileName} ) {

            # gather info about the local file
            my $Stat = stat "/opt/otobo/Kernel/Config/Files/$EventFileName";

            # reinstall packages when there is a unhandled package event
            if (
                !$Stat
                ||
                $Stat->size != $FileName2Size{$EventFileName}
                ||
                $Stat->mtime != $FileName2LastModified{$EventFileName}
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

        warn "Successfully killed! Restarting the new server process.\n";

        # reinstall packages
        # Use the console command in order to avoid dependance on OTOBO modules in the watchdog loop
        my $Output = qx{/opt/otobo/bin/otobo.Console.pl Admin::Package::ReinstallAll};
        warn "Admin::Package::ReinstallAll: $Output";
        # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Config::Rebuild
        # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Cache::Delete

        # no locking required as there should be no concurrent access

        # update event_package.json from S3
        {
            my $FilePath    = join '/', $Bucket, ($FilesPrefix . $EventFileName); # $FilesPrefix already has trailing '/'
            my $Now         = Mojo::Date->new(time)->to_datetime;
            my $URL         = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
            my $Transaction = $S3Object->signed_request(
                method   => 'GET',
                datetime => $Now,
                url      => $URL,
            );

            # run blocking request
            $UserAgent->start($Transaction);

            # Do not use the Kernel::System::Main in Kernel/Config/Defaults
            $Transaction->result->save_to("/opt/otobo/Kernel/Config/Files/$EventFileName");

            # Touch the downloaded file to the value of LastModified from S3, e.g. 'Sat, 23 Oct 2021 11:15:14 GMT'.
            # This is useful because the mtime is used in the comparison whether a new version of the file must be downloaded.
            # $FileName2LastModified{$EventFileName} can't be used here as the file could have changed since the last check.
            my $LastModified = $Transaction->result->headers->last_modified;
            my $Epoch        = Mojo::Date->new($LastModified)->epoch;
            utime $Epoch, $Epoch, "/opt/otobo/Kernel/Config/Files/$EventFileName";
        }

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
