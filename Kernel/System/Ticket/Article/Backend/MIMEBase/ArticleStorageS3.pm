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
use Mojo::UserAgent;
use Mojo::Date;
use Mojo::URL;
use Mojo::AWS::S3;

# OTOBO modules
use Kernel::System::VariableCheck qw(IsStringWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::XML::Simple',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageS3 - S3 based ticket article storage interface

=head1 DESCRIPTION

This class provides functions to manipulate ticket articles in a S3 compatible storage.
The methods are currently documented in L<Kernel::System::Ticket::Article::Backend::MIMEBase>.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase::Base>.

See also L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS> and
L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Call new() on Base.pm to execute the common code.
    my $Self = $Type->SUPER::new(%Param);

    # get values from SysConfig
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Region       = $ConfigObject->Get('Ticket::Article::Backend::MIMEBase::ArticleStorageS3::Region')
        || die 'Got no AWS Region!';

    # Bucket created on Docker host with:
    # docker_admin> export AWS_ACCESS_KEY_ID=test
    # docker_admin> export AWS_SECRET_ACCESS_KEY=test
    # docker_admin> aws --endpoint-url=http://localhost:4566 s3 mb s3://otobo-20211010a
    # make_bucket: otobo-20211010a

    # TODO: eliminate hardcoded values
    $Self->{Bucket}         = 'otobo-20211012d';
    $Self->{MetadataPrefix} = 'x-amz-meta-';
    $Self->{UserAgent}      = Mojo::UserAgent->new();
    $Self->{S3Object}       = Mojo::AWS::S3->new(
        transactor => $Self->{UserAgent}->transactor,
        service    => 's3',
        region     => $Region,
        access_key => 'test',
        secret_key => 'test',
    );

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
    my $FilePath    = $Self->_FilePath( $Param{ArticleID}, 'plain.txt' );
    my $Now         = Mojo::Date->new(time)->to_datetime;
    my $URL         = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
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

    # query all attachments so that they can be deleted
    my $XML4Delete;
    {
        my %AttachmentIndex = $Self->ArticleAttachmentIndexRaw(%Param);

        my $ArticlePrefix = $Self->_ArticlePrefix( $Param{ArticleID} );
        my @Keys;
        for my $FileID ( sort { $a <=> $b } keys %AttachmentIndex ) {
            push @Keys, $ArticlePrefix . $AttachmentIndex{$FileID}->{File};
        }

        # TODO: proper XML quoting
        my @ObjectNodes = map {
            sprintf <<'END_OBJECT_NODE', $_ } @Keys;
 <Object>
    <Key>%s</Key>
 </Object>
END_OBJECT_NODE
        $XML4Delete = sprintf <<'END_XML4DELETE', join "\n", @ObjectNodes;
<Delete xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
%s
  <Quiet>boolean</Quiet>
</Delete>
END_XML4DELETE
    }

    # See https://docs.aws.amazon.com/AmazonS3/latest/API/API_DeleteObjects.html
    # delete plain
    my $FilePath = $Self->_FilePath( $Param{ArticleID}, 'plain.txt' );
    my $Now      = Mojo::Date->new(time)->to_datetime;
    my $URL      = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
    $URL->query('delete=');
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'POST',
        datetime => $Now,
        url      => $URL,
        payload  => [$XML4Delete],
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

    # generate Mojo transaction for submitting plain to S3
    my $FilePath    = $Self->_FilePath( $Param{ArticleID}, 'plain.txt' );
    my $Now         = Mojo::Date->new(time)->to_datetime;
    my $URL         = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
    my %Headers     = ( 'Content-Type' => 'text/plain' );
    my $Transaction = $Self->{S3Object}->signed_request(
        method         => 'PUT',
        datetime       => $Now,
        url            => $URL,
        signed_headers => \%Headers,
        payload        => [ $Param{Email} ],
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # TODO: check success
    return 1;
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

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Perform FilenameCleanup here already to check for
    #   conflicting existing attachment files correctly
    my $NewFilename = $Kernel::OM->Get('Kernel::System::Main')->FilenameCleanUp(
        Filename  => delete $Param{Filename},
        Type      => 'Local',
        NoReplace => 1,
    );

    # find an unique file name, that is an unique S3 key
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );
    my %UsedFile = map { $_->{Filename} => 1 } values %Index;
    for ( my $i = 1; $i <= 50; $i++ ) {
        if ( exists $UsedFile{$NewFilename} ) {
            if ( $Param{Filename} =~ m/^(.*)\.(.+?)$/ ) {
                $NewFilename = "$1-$i.$2";
            }
            else {
                $NewFilename = "$Param{Filename}-$i";
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

    # TODO: collect the headers
    # generate Mojo transaction for submitting attachment to S3
    my $FilePath    = $Self->_FilePath( $Param{ArticleID}, $NewFilename );
    my $Now         = Mojo::Date->new(time)->to_datetime;
    my $URL         = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
    my $Transaction = $Self->{S3Object}->signed_request(
        method         => 'PUT',
        datetime       => $Now,
        url            => $URL,
        signed_headers => \%Headers,
        payload        => [ $Param{Content} ],
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # TODO: check success
    return 1;
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
    my $FilePath    = $Self->_FilePath( $Param{ArticleID}, 'plain.txt' );
    my $Now         = Mojo::Date->new(time)->to_datetime;
    my $URL         = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'GET',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # the S3 backend does not support storing articles in mixed backends
    # TODO: check success
    return $Transaction->res->body;
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
    my $URL = Mojo::URL->new->scheme('https')->host('localstack:4566')->path( $Self->{Bucket} );    # run within container

    # the parameters are passed in the Query-URL
    my $ArticlePrefix = $Self->_ArticlePrefix( $Param{ArticleID} );
    $URL->query(
        [
            prefix    => $ArticlePrefix,
            delimiter => '/'
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
    my $Content         = $Transaction->res->body;
    my $XMLSimpleObject = $Kernel::OM->Get('Kernel::System::XML::Simple');
    my $ParsedXML       = $XMLSimpleObject->XMLIn(
        XMLInput => $Content,
        Options  => {
            ForceArray   => 1,
            ForceContent => 1,
            ContentKey   => 'Content',
        },
    );

    my %Index;
    if ( ref $ParsedXML eq 'HASH' && $ParsedXML->{Contents} && ref $ParsedXML->{Contents} eq 'ARRAY' ) {
        my $Counter = 0;
        OBJECT:
        for my $Object ( $ParsedXML->{Contents}->@* ) {
            my $Filename = basename( $Object->{Key}->[0]->{Content} // '' );

            # plain.txt is written in ArticleWritePlain() and retrieved in ArticlePlain()
            next OBJECT if $Filename eq 'plain.txt';

            $Index{ ++$Counter } = {
                FilesizeRaw => ( $Object->{Size}->[0]->{Content} // 0 ),
                Filename    => $Filename,

            };
        }
    }

    # The HTTP headers give the metadata for the found keys
    my @Promises;
    for my $FileID ( sort { $a <=> $b } keys %Index ) {
        my $Item        = $Index{$FileID};
        my $FilePath    = $Self->_FilePath( $Param{ArticleID}, $Item->{Filename} );
        my $Now         = Mojo::Date->new(time)->to_datetime;
        my $URL         = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
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
    Mojo::Promise->all(@Promises)->wait if @Promises;

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

sub ArticleAttachment {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Item (qw(ArticleID FileID)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!"
            );

            return;
        }
    }

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get attachment index
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID => $Param{ArticleID},
    );

    return unless $Index{ $Param{FileID} };

    my %Data = %{ $Index{ $Param{FileID} } };

    # retrieve plain from S3
    my $FilePath    = $Self->_FilePath( $Param{ArticleID}, $Data{Filename} );
    my $Now         = Mojo::Date->new(time)->to_datetime;
    my $URL         = Mojo::URL->new->scheme('https')->host('localstack:4566')->path($FilePath);    # run within container
    my $Transaction = $Self->{S3Object}->signed_request(
        method   => 'GET',
        datetime => $Now,
        url      => $URL,
    );

    # run blocking request
    $Self->{UserAgent}->start($Transaction);

    # the S3 backend does not support storing articles in mixed backends
    $Data{ContentType} = $Transaction->res->headers->content_type;

    return unless $Data{ContentType};

    $Data{Content} = $Transaction->res->body;

    return unless $Data{Content};

    # ContentID and ContentAlternative are not regular HTTP Headers
    # They are stored as metadata.
    my $ContentID = $Transaction->res->headers->header("$Self->{MetadataPrefix}ContentID");
    $Data{ContentID} = $ContentID if $ContentID;
    my $ContentAlternative = $Transaction->res->headers->header("$Self->{MetadataPrefix}ContentAlternative");
    $Data{ContentAlternative} = $ContentAlternative if $ContentAlternative;

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

# the final delimiter is part of the prefix
sub _ArticlePrefix {
    my ( $Self, $ArticleID ) = @_;

    # Include the content path, something like 2021/10/08, in the S3 keys.
    # Note that '/' is used as the delimiter in S3, this simplifies queries by year, month, and day.
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $ArticleID,
    );

    return join '/', 'OTOBO', 'articles', $ContentPath, $ArticleID, '';
}

# the final delimiter is part of the prefix
sub _FilePath {
    my ( $Self, $ArticleID, $File ) = @_;

    return join( '/', $Self->{Bucket}, $Self->_ArticlePrefix($ArticleID) ) . $File;
}

1;
