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

package Kernel::System::Daemon::DaemonModules::SyncWithS3;

use strict;
use warnings;
use v5.24;
use utf8;

use parent qw(Kernel::System::Daemon::BaseDaemon Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

# core modules
use File::stat;

# CPAN modules
use Mojo::AWS::S3;
use Mojo::DOM;
use Mojo::Date;
use Mojo::URL;
use Mojo::UserAgent;

# OTOBO modules

our @ObjectDependencies = (
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SyncWithS3 - daemon to reinstall packages when packages are installed

=head1 DESCRIPTION

Reinstall packages.

=head1 PUBLIC INTERFACE

=head2 new()

Create sync object.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = bless {}, $Type;

    # Get objects in constructor to save performance.

    # Disable in memory cache to be clusterable.

    # Get the NodeID from the SysConfig settings, this is used on High Availability systems.

    # Check NodeID, if does not match is impossible to continue.

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
    my $ErrorMessage;
    my $Success;
    if ( $Self->{Debug} ) {
        print "    $Self->{DaemonName} Executes function: SyncWithS3\n";
    }

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

    return 1 unless exists $FileName2Size{$EventFileName};
    return 1 unless exists $FileName2LastModified{$EventFileName};

    {
        my $DoReinstallPackages = 0;

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

        return 1 unless $DoReinstallPackages;
    }

    warn "-- a new package event was detected";

    # reinstall packages
    # Use the console command in order to avoid dependance on OTOBO modules in the watchdog loop
    my $Output = qx{/opt/otobo/bin/otobo.Console.pl Admin::Package::ReinstallAll};
    warn "Admin::Package::ReinstallAll: $Output";
    # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Config::Rebuild
    # TODO: $OTOBO_HOME/bin/otobo.Console.pl Maint::Cache::Delete

    # no locking required as there should be no concurrent access

    # update event_package.json from S3
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
