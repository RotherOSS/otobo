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

package Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageS3;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Ticket::Article::Backend::MIMEBase::Base);

# core modules
use File::Basename qw(basename);

# CPAN modules
use Mojo::DOM;
use Mojo::Date;
use Mojo::URL;

# OTOBO modules
use Kernel::System::VariableCheck qw(IsStringWithData);
use Kernel::System::Storage::S3;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageS3 - S3 based ticket article storage interface

=head1 DESCRIPTION

This class provides functions to manipulate ticket articles
in a S3 compatible storage.
The methods are currently documented in L<Kernel::System::Ticket::Article::Backend::MIMEBase>.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase::Base>.

See also L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS> and
L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Call new() on Base.pm to execute the common code.
    my $Self = $Type->SUPER::new(%Param);

    # TODO: don't access attributes directly
    # TODO: eliminate hardcoded values
    my $StorageS3Object = Kernel::System::Storage::S3->new();
    $Self->{Bucket}          = $StorageS3Object->{Bucket};
    $Self->{Host}            = $StorageS3Object->{Host};
    $Self->{MetadataPrefix}  = 'x-amz-meta-';
    $Self->{S3Object}        = $StorageS3Object->{S3Object};
    $Self->{Scheme}          = $StorageS3Object->{Scheme};
    $Self->{StorageS3Object} = $StorageS3Object;
    $Self->{UserAgent}       = $StorageS3Object->{UserAgent};

    return $Self;
}

sub ArticleDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    # delete attachments
    $Self->ArticleDeleteAttachment(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    # delete plain message
    $Self->ArticleDeletePlain(
        ArticleID => $Param{ArticleID},
        UserID    => $Param{UserID},
    );

    return 1;
}

sub ArticleDeletePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    # delete plain
    my $FilePath = $Self->_FilePath( $Param{ArticleID}, 'plain.txt' );
    my $Now      = Mojo::Date->new(time)->to_datetime;
    my $URL      = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path( join '/', $Self->{Bucket}, $FilePath );
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'DELETE',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # the S3 backend does not support storing articles in mixed backends
    # TODO: check success
    return 1;
}

sub ArticleDeleteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    # Create XML for deleting all attachments besided 'plain.txt'.
    # See https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteObjects.html
    my $DOM = Mojo::DOM->new->xml(1);
    {
        # start with the the toplevel Delete tag
        $DOM->content( $DOM->new_tag( 'Delete', xmlns => 'http://s3.amazonaws.com/doc/2006-03-01/' ) );

        # first get info about the objects, plain.txt is already excluded
        my %AttachmentIndex = $Self->ArticleAttachmentIndexRaw(%Param);
        my $ArticlePrefix   = $Self->_ArticlePrefix( $Param{ArticleID} );

        for my $FileID ( sort { $a <=> $b } keys %AttachmentIndex ) {

            # the key which should be deleted
            my $Key = $ArticlePrefix . $AttachmentIndex{$FileID}->{Filename};

            $DOM->at('Delete')->append_content(
                $DOM->new_tag('Object')->at('Object')->append_content(
                    $DOM->new_tag( Key => $Key )
                )
            );
        }
    }

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
        payload  => [ $DOM->to_string ],
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # the S3 backend does not support storing articles in mixed backends
    # TODO: check success
    return 1;
}

# no metadata is added
sub ArticleWritePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID Email UserID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    # store plain message to S3
    my $FilePath = $Self->_FilePath( $Param{ArticleID}, 'plain.txt' );

    return $Self->{StorageS3Object}->StoreObject(
        Key     => $FilePath,
        Headers => { 'Content-Type' => 'text/plain' },
        Content => $Param{Email},
    );
}

sub ArticleWriteAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(Filename ContentType ArticleID UserID)) {
        if ( !IsStringWithData( $Param{$Item} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    # Perform FilenameCleanUp here already to check for
    #   conflicting existing attachment files correctly
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $OrigFilename = $MainObject->FilenameCleanUp(
        Filename  => $Param{Filename},
        Type      => 'Local',
        NoReplace => 1,
    );

    # check for conflicts in the attachment file names
    my $UniqueFilename = $OrigFilename;
    {
        my %Index = $Self->ArticleAttachmentIndex(
            ArticleID => $Param{ArticleID},
        );

        my %UsedFile = map
            { $_->{Filename} => 1 }
            values %Index;

        NAME_CHECK:
        for ( my $i = 1; $i <= 50; $i++ ) {
            next NAME_CHECK unless $UsedFile{$UniqueFilename};

            # keep the extension when renaming
            if ( $OrigFilename =~ m/^(.*)\.(.+?)$/ ) {
                $UniqueFilename = "$1-$i.$2";
            }
            else {
                $UniqueFilename = "$OrigFilename-$i";
            }
        }
    }

    # attachment size is handled by S3

    my %Headers = (
        'Content-Type' => $Param{ContentType},
    );

    # set content id in angle brackets
    if ( $Param{ContentID} ) {
        my $ContentID = $Param{ContentID};
        $ContentID =~ s/^([^<].*[^>])$/<$1>/;
        $Headers{"$Self->{MetadataPrefix}ContentID"} = $ContentID;
    }

    if ( $Param{ContentAlternative} ) {
        $Headers{"$Self->{MetadataPrefix}ContentAlternative"} = $Param{ContentAlternative};
    }

    # full disposition including the file name
    if ( $Param{Disposition} ) {
        $Headers{'Content-Disposition'} = $Param{Disposition};
    }

    my $FilePath = $Self->_FilePath( $Param{ArticleID}, $UniqueFilename );

    return $Self->{StorageS3Object}->StoreObject(
        Key     => $FilePath,
        Content => $Param{Content},
        Headers => \%Headers,
    );
}

sub ArticlePlain {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );

        return;
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # retrieve plain from S3
    my $FilePath = $Self->_FilePath( $Param{ArticleID}, 'plain.txt' );
    my %Data     = $Self->{StorageS3Object}->RetrieveObject(
        Key => $FilePath,
    );

    return unless defined $Data{Content};
    return $Data{Content};
}

sub ArticleAttachmentIndexRaw {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );

        return;
    }

    # retrieve file list from S3
    my $Now = Mojo::Date->new(time)->to_datetime;
    my $URL = Mojo::URL->new
        ->scheme( $Self->{Scheme} )
        ->host( $Self->{Host} )
        ->path( $Self->{Bucket} );

    # the parameters are passed in the Query-URL
    my $ArticlePrefix = $Self->_ArticlePrefix( $Param{ArticleID} );

    # For the params see https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectsV2.html.
    $URL->query(
        [
            'list-type' => 2,
            prefix      => $ArticlePrefix,
            delimiter   => '/'
        ]
    );

    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'GET',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # the S3 backend does not support storing articles in mixed backends
    # TODO: check success
    # parse the returned XML
    # look at the Contents nodes in the returned XML
    my %Index;
    my $Counter;
    $Transaction->res->dom->find('Contents')->map(
        sub {
            my ($ContentNode) = @_;

            my $Filename = basename( $ContentNode->at('Key')->text // 0 );

            # plain.txt is written in ArticleWritePlain() and retrieved in ArticlePlain()
            return if $Filename eq 'plain.txt';

            my $Size = $ContentNode->at('Size')->text;

            $Index{ ++$Counter } = {
                FilesizeRaw => ( $Size // 0 ),
                Filename    => $Filename,
            };
        }
    );

    # The HTTP headers give the metadata for the found keys
    my @Promises;
    for my $FileID ( sort { $a <=> $b } keys %Index ) {
        my $Item     = $Index{$FileID};
        my $FilePath = $Self->_FilePath( $Param{ArticleID}, $Item->{Filename} );
        my $Now      = Mojo::Date->new(time)->to_datetime;
        my $URL      = Mojo::URL->new
            ->scheme( $Self->{Scheme} )
            ->host( $Self->{Host} )
            ->path( join '/', $Self->{Bucket}, $FilePath );
        my $Transaction = $Self->{S3Object}->signed_request(
            method   => 'HEAD',
            datetime => $Now,
            url      => $URL,
        );

        # run non-blocking requests
        push @Promises, $Self->{UserAgent}->start_p($Transaction)->then(
            sub {
                my ($FinishedTransaction) = @_;

                my $Headers     = $Transaction->res->headers;
                my $ContentType = $Headers->content_type;

                # TODO return early: Mojo::Promise->reject('got no content type');
                $Item->{ContentType}        = $ContentType;
                $Item->{ContentID}          = $Headers->header("$Self->{MetadataPrefix}ContentID")          || '';
                $Item->{ContentAlternative} = $Headers->header("$Self->{MetadataPrefix}ContentAlternative") || '';

                my $FullDisposition = $Headers->content_disposition;
                if ($FullDisposition) {
                    ( $Item->{Disposition} ) = split ';', $FullDisposition, 2;    # ignore the filename part
                }

                # if no content disposition is set images with content id should be inline
                elsif ( $Item->{ContentID} && $Item->{ContentType} =~ m{image}i ) {
                    $Item->{Disposition} = 'inline';
                }

                # converted article body should be inline
                elsif ( $Item->{Filename} =~ m{file-[12]} ) {
                    $Item->{Disposition} = 'inline';
                }

                # all others including attachments with content id that are not images
                # should NOT be inline
                else {
                    $Item->{Disposition} = 'attachment';
                }
            }
        );    # TODO: finally
    }

    # wait till all promises were kept or one rejected
    my @Ret;
    @Ret = Mojo::Promise->all(@Promises)->wait if @Promises;

    # sanity check of the Index
    for my $FileID ( sort { $a <=> $b } keys %Index ) {
        my $Item = $Index{$FileID};

        return unless $Item->{ContentType};
    }

    # return existing index
    return %Index if %Index;

    # the S3 backend does not support storing articles in mixed backends
    return;
}

# TODO: optionally allow to pass in the file name
sub ArticleAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID FileID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta $Param{ArticleID};
    $Param{ArticleID} =~ s/\0//g;

    # get attachment index
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    return unless $Index{ $Param{FileID} };

    my %DataFromIndex = %{ $Index{ $Param{FileID} } };

    # retrieve attachment from S3, including the metadata
    my $FilePath   = $Self->_FilePath( $Param{ArticleID}, $DataFromIndex{Filename} );
    my %Attachment = $Self->{StorageS3Object}->RetrieveObject(
        Key => $FilePath,
    );
}

# the final delimiter is part of the prefix
sub _ArticlePrefix {
    my ( $Self, $ArticleID ) = @_;

    # Include the content path, something like 2021/10/08, in the S3 keys.
    # Note that '/' is used as the delimiter in S3, this simplifies queries by year, month, and day.
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $ArticleID,
    );

    return join '/', 'OTOBO', 'var', 'article', $ContentPath, $ArticleID, '';    # with trailing slash
}

# Bucket is not included
# the final delimiter is part of the prefix
sub _FilePath {
    my ( $Self, $ArticleID, $File ) = @_;

    return $Self->_ArticlePrefix($ArticleID) . $File;    # _ArticlePrefix() already has a trailing '/'
}

1;
