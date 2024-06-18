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

package Kernel::System::Storage::S3;

use v5.24;
use strict;
use warnings;
use utf8;

# core modules
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Cwd qw(realpath);

# CPAN modules
use Mojo::UserAgent;
use Mojo::Date;
use Mojo::DOM;
use Mojo::URL;
use Mojo::AWS::S3;
use Plack::Util;

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Storage::S3 - collection of helpers for handling storage in S3

=head1 DESCRIPTION

Interacting with S3 compatible storage.

Create bucket on Docker host with:

    docker_admin> export AWS_ACCESS_KEY_ID=test
    docker_admin> export AWS_SECRET_ACCESS_KEY=test
    docker_admin> aws --endpoint-url=http://localhost:4566 s3 mb s3://otobo-bucket-20211128a
    make_bucket: otobo-bucket-20211128a

=head1 PUBLIC INTERFACE

=head2 new()

create a new object.

    my $StorageS3Object = Kernel::System::Storage::S3->new();

But syncing from S3 is also required in the constructor of Kernel::Config object. And this constructor wants to use the config object,
meaning that we have a bootstrapping problem. Therefore we have the parameter ConfigObject, where we can pass in a partly built Kernel::Config object.

    # in Kernel::Config::Defaults::new()
    my $StorageS3Object = Kernel::System::Storage::S3->new(
        ConfigObject => $ConfigObject,
    );

=cut

sub new {
    my ( $Class, %Param ) = @_;

    # handle config bootstrap problem
    my $ConfigObject = $Param{ConfigObject} // $Kernel::OM->Get('Kernel::Config');

    # create an UserAgent and S3Object
    my $Region    = $ConfigObject->Get('Storage::S3::Region');
    my $AccessKey = $ConfigObject->Get('Storage::S3::AccessKey');
    my $SecretKey = $ConfigObject->Get('Storage::S3::SecretKey');
    my $UserAgent = Mojo::UserAgent->new();
    my $S3Object  = Mojo::AWS::S3->new(
        transactor => $UserAgent->transactor,
        service    => 's3',
        region     => $Region,
        access_key => $AccessKey,
        secret_key => $SecretKey,
    );

    my $Self = {
        Scheme         => $ConfigObject->Get('Storage::S3::Scheme'),
        Host           => $ConfigObject->Get('Storage::S3::Host'),
        Bucket         => $ConfigObject->Get('Storage::S3::Bucket'),
        HomePrefix     => $ConfigObject->Get('Storage::S3::HomePrefix'),
        MetadataPrefix => $ConfigObject->Get('Storage::S3::MetadataPrefix'),
        Delimiter      => $ConfigObject->Get('Storage::S3::Delimiter'),
        DeleteMulti    => $ConfigObject->Get('Storage::S3::DeleteMultipleObjectIsSupported'),
        UserAgent      => $UserAgent,
        S3Object       => $S3Object,
    };

    return bless $Self, $Class;
}

=head2 ListObjects()

return a hash with information about objects with a specific prefix.
The prefix will be removed from the keys of the returned hash.
Note the trailing slash.

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

    # get defaults, emptry string as delimiter is allowed
    my $Delimiter = exists $Param{Delimiter} ? $Param{Delimiter} : $Self->{Delimiter};

    my %Name2Properties;
    my $URL = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path( $Self->{Bucket} );
    my $CompletePrefix = join '/', $Self->{HomePrefix}, $Param{Prefix};
    $URL->query(
        [
            'list-type' => 2,
            prefix      => $CompletePrefix,
            delimiter   => $Delimiter,
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
            my $Name = $Key =~ s/^\Q$CompletePrefix\E//r;

            # TODO: maybe rename to FilesizeRaw
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

    my $KeyWithBucket = join '/', $Self->{Bucket}, $Self->{HomePrefix}, $Param{Key};
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
    my $KeyWithBucket = join '/', $Self->{Bucket}, $Self->{HomePrefix}, $Param{Key};
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

=head2 ProcessHeaders()

fetch headers in parallel and call the callback
to be documented

=cut

sub ProcessHeaders {
    my ( $Self, %Param ) = @_;

    # The HTTP headers give the metadata for the found keys
    my @Promises;
    for my $Filename ( $Param{Filenames}->@* ) {
        my $Path = join '/', $Self->{Bucket}, $Self->{HomePrefix}, $Param{Prefix}, $Filename;
        my $Now  = Mojo::Date->new(time)->to_datetime;
        my $URL  = Mojo::URL->new
            ->scheme( $Self->{Scheme} )
            ->host( $Self->{Host} )
            ->path($Path);

        my $Transaction = $Self->{S3Object}->signed_request(
            method   => 'HEAD',
            datetime => $Now,
            url      => $URL,
        );

        # run non-blocking requests
        push @Promises, $Self->{UserAgent}->start_p($Transaction)->then( $Param{Callback} );
    }

    # wait till all promises were kept or one rejected
    Mojo::Promise->all(@Promises)->wait if @Promises;

    return;
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
    my $KeyWithBucket = join '/', $Self->{Bucket}, $Self->{HomePrefix}, $Param{Key};
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

    if ( $Param{ContentMayBeFilehandle} && $Transaction->res->content->asset->is_file ) {

        # Mojo::UserAgent has written the response conten to a temporary file.
        # Move that file to the same location where ArticleStorageFS would put it.
        # Then proceed like in ArticleStorageFS.
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $Home         = $ConfigObject->Get('Home');
        my $Location     = $Param{Key} =~ s!^OTOBO/!$Home/!r;    # same location as in ArticleStorageFS
                                                                 # inject PID to avoid interaction between different processes
        $Location = join '/', dirname($Location), "pid-$$", basename($Location);
        unlink $Location;                                        # for now we don't want any caching,
        make_path( dirname($Location) );
        $Transaction->res->content->asset->move_to($Location);    # moved file won't be cleaned up

        ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen OTOBO::ProhibitLowPrecedenceOps)
        open my $ContentFH, '<:raw', $Location
            or return;

        Plack::Util::set_io_path( $ContentFH, realpath($Location) );

        $Data{Content} = $ContentFH;
    }
    else {
        $Data{Content} = $Transaction->res->body;
    }

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
    my $KeyWithBucket = join '/', $Self->{Bucket}, $Self->{HomePrefix}, $Param{Key};
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
    make_path( dirname( $Param{Location} ) );
    $Transaction->result->save_to( $Param{Location} );

    # Touch the downloaded file to the value of LastModified from S3, e.g. 'Sat, 23 Oct 2021 11:15:14 GMT'.
    # This is useful because the mtime is used in the comparison whether a new version of the file must be downloaded.
    # $Name2Properties{$EventFileName} can't be used here as the file could have changed since the last check.
    my $LastModified = $Transaction->result->headers->last_modified;
    my $Epoch        = Mojo::Date->new($LastModified)->epoch;
    utime $Epoch, $Epoch, $Param{Location};

    return 1;
}

=head2 DiscardObject()

Remove an object from the S3 storage.

=cut

sub DiscardObject {
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

    my $KeyWithBucket = join '/', $Self->{Bucket}, $Self->{HomePrefix}, $Param{Key};
    my $Now           = Mojo::Date->new(time)->to_datetime;
    my $URL           = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path($KeyWithBucket);
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'DELETE',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    return 1 if $Transaction->result->is_success;    # success is indicated even when no object was deleted
    return;
}

sub DiscardObjects {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(Prefix)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    # first get info about the objects with the relevant prefix
    my %Name2Properties = $Self->ListObjects(
        Prefix => $Param{Prefix},
        ( exists $Param{Delimiter} ? ( Delimiter => $Param{Delimiter} ) : () ),
    );

    # There have been problems with deleting multiple objects at once. Discard single object as a workaraóund.
    if ( !$Self->{DeleteMulti} ) {
        my $DiscardSuccess = 1;

        FILENAME:
        for my $Filename ( sort keys %Name2Properties ) {

            # keep files matching a regex
            next FILENAME if $Param{Keep}        && $Filename =~ $Param{Keep};
            next FILENAME if $Param{DiscardOnly} && $Filename !~ $Param{DiscardOnly};

            $DiscardSuccess = $Self->DiscardObject(
                Key => "$Param{Prefix}$Filename",
            );

            last FILENAME unless $DiscardSuccess;
        }

        return $DiscardSuccess;
    }

    # Create XML for deleting objects with the to be deleted prefix
    # See https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteObjects.html
    my $DOM = Mojo::DOM->new->xml(1);
    {
        # start with the the toplevel Delete tag
        $DOM->content( $DOM->new_tag( 'Delete', xmlns => 'http://s3.amazonaws.com/doc/2006-03-01/' ) );

        FILENAME:
        for my $Filename ( sort keys %Name2Properties ) {

            # keep files matching a regex
            next FILENAME if $Param{Keep}        && $Filename =~ $Param{Keep};
            next FILENAME if $Param{DiscardOnly} && $Filename !~ $Param{DiscardOnly};

            # the key which should be deleted, note that that prefix already has a trailing slash
            my $Key = join '/', $Self->{HomePrefix}, "$Param{Prefix}$Filename";

            $DOM->at('Delete')->append_content(
                $DOM->new_tag('Object')->at('Object')->append_content(
                    $DOM->new_tag( Key => $Key )
                )
            );
        }
    }

    my $SerialisedDOM = $DOM->to_string;
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeOutput( \$SerialisedDOM );

    # See https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteObjects.html
    # delete plain
    my $Now = Mojo::Date->new(time)->to_datetime;
    my $URL = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path( $Self->{Bucket} );
    $URL->query('delete=');
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'POST',
        datetime => $Now,
        url      => $URL,
        payload  => [$SerialisedDOM],
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # the S3 backend does not support storing articles in mixed backends
    # TODO: check success
    return 1;
}

1;
