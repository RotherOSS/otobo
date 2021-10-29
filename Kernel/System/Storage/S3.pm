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

package Kernel::System::Storage::S3;

use strict;
use warnings;
use v5.24;
use utf8;

# core modules

# CPAN modules
use Mojo::UserAgent;
use Mojo::Date;
use Mojo::URL;
use Mojo::AWS::S3;

# OTOBO modules

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::Storage::S3 - collection of helpers for handling storage in S3

=head1 DESCRIPTION

Interacting with S3 compatible storage.

Create bucket on Docker host with:

    docker_admin> export AWS_ACCESS_KEY_ID=test
    docker_admin> export AWS_SECRET_ACCESS_KEY=test
    docker_admin> aws --endpoint-url=http://localhost:4566 s3 mb s3://otobo-20211010a
    make_bucket: otobo-20211029a

=head1 PUBLIC INTERFACE

=head2 new()

create a new object. Do not use it directly, instead use:

    my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');

=cut

sub new {
    my ($Class) = @_;

    # TODO: get the settings from %Param, the configuration, or the environment
    my $Region    = 'eu-central-1';
    my $Bucket    = 'otobo-20211029a';
    my $AccessKey = 'test';
    my $SecretKey = 'test';
    my $Scheme    = 'https';

    # Use localstack as host, as we run within container
    my $Host      = 'localstack:4566';
    my $Delimiter = '/';

    my $UserAgent = Mojo::UserAgent->new();
    my $S3Object  = Mojo::AWS::S3->new(
        transactor => $UserAgent->transactor,
        service    => 's3',
        region     => $Region,
        access_key => $AccessKey,
        secret_key => $SecretKey,
    );

    my $Self = {
        Bucket    => $Bucket,
        Delimiter => '/',
        Host      => $Host,
        S3Object  => $S3Object,
        Scheme    => $Scheme,
        UserAgent => $UserAgent,
    };

    return bless $Self, $Class;
}

=head2 ListObjects()

return a hash with information about objects with a specific prefix.
The prefix will be removed from the keys of the returned hash.

    my %Name2Properties = $StorageS3Object->ListObjects(
        Prefix => 'Kernel/Config/Files/',
    );

Returns:

    %Name2Properties = (
        'ZZZAAuto.pm' => {
            Size  => 324238,
            Mtime => 1635496219,
            Key   => 'OTOBO/Kernel/Config/Files/ZZZAAuto,pm',
        },
        ...
    );

For the REST interface see L<https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectsV2.html>.

=cut

sub ListObjects {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Prefix)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed $Needed: $!",
                Priority => 'error',
            );

            return;
        }
    }

    my %Name2Properties;
    my $URL = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path( $Self->{Bucket} );
    $URL->query(
        [
            'list-type' => 2,
            prefix      => $Param{Prefix},
            delimiter   => '/'
        ]
    );
    my $Now         = Mojo::Date->new(time)->to_datetime;
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'GET',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # look at the Contents nodes in the returned XML
    $Transaction->res->dom->find('Contents')->map(
        sub {
            my ($ContentNode) = @_;

            my %Properties;

            # The key in the XML also includes the prefix.
            my $Key = $ContentNode->at('Key')->text;
            $Properties{Key} = $Key;

            # also keep the objects in the subdirectories, but relative to the prefix
            my $Name = $Key =~ s/^\Q$Param{Prefix}\E//r;

            $Properties{Size} = $ContentNode->at('Size')->text;

            # LastModified is actually the time when the file was uploaded
            my $ISO8601 = $ContentNode->at('LastModified')->text;
            my $Epoch   = Mojo::Date->new($ISO8601)->epoch;
            $Properties{Mtime} = $Epoch;

            $Name2Properties{$Name} = \%Properties;
        }
    );

    return %Name2Properties;
}

1;
