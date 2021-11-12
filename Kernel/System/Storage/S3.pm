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
use File::Basename qw(basename);

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
    my $Region         = 'eu-central-1';
    my $Bucket         = 'otobo-20211029a';
    my $AccessKey      = 'test';
    my $SecretKey      = 'test';
    my $Scheme         = 'https';
    my $MetadataPrefix = 'x-amz-meta-';

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
        Bucket         => $Bucket,
        Delimiter      => '/',
        Host           => $Host,
        S3Object       => $S3Object,
        Scheme         => $Scheme,
        UserAgent      => $UserAgent,
        MetadataPrefix => $MetadataPrefix,
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

=head2 StoreObject()

to be documented

=cut

sub StoreObject {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Key Content)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed $Needed: $!",
                Priority => 'error',
            );

            return;
        }
    }

    my $KeyWithBucket = join '/', $Self->{Bucket}, $Param{Key};
    my $Headers       = $Param{Headers} // {};
    my $Now           = Mojo::Date->new(time)->to_datetime;
    my $URL           = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path($KeyWithBucket);

    # In ArticleStorageFS this is done implicitly in Kernel::System::Main::FileWrite().
    # not sure how this works for Perl strings containing binary data
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Param{Content} );

    # The header fields of MIME message and of HTTP headers treat encodings differently.
    # MIME headers support fields in different encodings. HTTP headers seem to support only iso-8859-1.
    # But there is RFC 8187 which might do the right thing.
    # For now we simply store the UTF8-bytes.
    # See scripts/test/sample/Postmaster/Postmaster-Test13.box for an example that uses kyrillic koi8 encoded headers.
    for my $Key ( keys $Headers->%* ) {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$Headers->{$Key} );
    }

    my $Transaction = $Self->{S3Object}->signed_request(
        method         => 'PUT',
        datetime       => $Now,
        url            => $URL,
        signed_headers => $Headers,
        payload        => [ $Param{Content} ],
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    return $Param{Key} if $Transaction->result->is_success;
    return;
}

=head2 ObjectExists()

to be documented

=cut

sub ObjectExists {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Key)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed $Needed: $!",
                Priority => 'error',
            );

            return;
        }
    }

    # retrieve attachment from S3
    my $KeyWithBucket = join '/', $Self->{Bucket}, $Param{Key};
    my $Now           = Mojo::Date->new(time)->to_datetime;
    my $URL           = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path($KeyWithBucket);

    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'HEAD',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    return $Transaction->res->is_success;
}

=head2 RetrieveObject()

to be documented

=cut

sub RetrieveObject {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Key)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed $Needed: $!",
                Priority => 'error',
            );

            return;
        }
    }

    # retrieve attachment from S3
    my $KeyWithBucket = join '/', $Self->{Bucket}, $Param{Key};
    my $Now           = Mojo::Date->new(time)->to_datetime;
    my $URL           = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path($KeyWithBucket);
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'GET',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    return unless $Transaction->result->is_success;

    my %Data;

    # the S3 backend does not support storing articles in mixed backends
    $Data{ContentType} = $Transaction->res->headers->content_type;

    return unless $Data{ContentType};

    $Data{Content} = $Transaction->res->body;

    return unless defined $Data{Content};

    $Data{FilesizeRaw} = $Transaction->res->headers->content_length;

    $Data{Filename} = basename( $Param{Key} );

    # ContentID and ContentAlternative are not regular HTTP Headers.
    # They are stored as metadata. Default is an empty string as in ArticleStorageFS.
    my $ContentID = $Transaction->res->headers->header("$Self->{MetadataPrefix}ContentID");
    $Data{ContentID} = $ContentID // '';
    my $ContentAlternative = $Transaction->res->headers->header("$Self->{MetadataPrefix}ContentAlternative");
    $Data{ContentAlternative} = $ContentAlternative // '';

    my $FullDisposition = $Transaction->res->headers->content_disposition;
    if ($FullDisposition) {
        ( $Data{Disposition} ) = split ';', $FullDisposition, 2;    # ignore the filename part
    }

    # if no content disposition is set images with content id should be inline
    elsif ( $Data{ContentID} && $Data{ContentType} =~ m{image}i ) {
        $Data{Disposition} = 'inline';
    }

    # converted article body should be inline
    elsif ( $Data{Filename} =~ m{file-[12]} ) {
        $Data{Disposition} = 'inline';
    }

    # all others including attachments with content id that are not images
    #   should NOT be inline
    else {
        $Data{Disposition} = 'attachment';
    }

    # the S3 backend does not support storing articles in mixed backends
    return %Data;
}

=head2 SaveObjectToFile()

to be documented

=cut

sub SaveObjectToFile {
    my ( $Self, %Param ) = @_;

    # check needed params
    for my $Needed (qw(Key Location)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Message  => "Needed $Needed: $!",
                Priority => 'error',
            );

            return;
        }
    }

    # retrieve object and save it to file
    my $KeyWithBucket = join '/', $Self->{Bucket}, $Param{Key};
    my $Now           = Mojo::Date->new(time)->to_datetime;
    my $URL           = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path($KeyWithBucket);
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'GET',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # Do not use the Kernel::System::Main in Kernel/Config/Defaults
    $Transaction->result->save_to( $Param{Location} );

    # Touch the downloaded file to the value of LastModified from S3, e.g. 'Sat, 23 Oct 2021 11:15:14 GMT'.
    # This is useful because the mtime is used in the comparison whether a new version of the file must be downloaded.
    # $Name2Properties{$EventFileName} can't be used here as the file could have changed since the last check.
    my $LastModified = $Transaction->result->headers->last_modified;
    my $Epoch        = Mojo::Date->new($LastModified)->epoch;
    utime $Epoch, $Epoch, $Param{Location};

    return 1;
}

1;
