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

package Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageS3;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::Ticket::Article::Backend::MIMEBase::Base);

# core modules

# CPAN modules
use Mojo::Date;
use Mojo::URL;

# OTOBO modules
use Kernel::System::VariableCheck qw(IsStringWithData);
use Kernel::System::Storage::S3   ();

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

    $Self->{StorageS3Object} = Kernel::System::Storage::S3->new();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    $Self->{MetadataPrefix} = $ConfigObject->Get('Storage::S3::MetadataPrefix');

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

    return $Self->{StorageS3Object}->DiscardObject(
        Key => $FilePath,
    );
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

    my $ArticlePrefix = $Self->_ArticlePrefix( $Param{ArticleID} );

    return $Self->{StorageS3Object}->DiscardObjects(
        Prefix => "$ArticlePrefix/",
        Keep   => qr/^plain\.txt$/,
    );
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
    # conflicting existing attachment files correctly.
    # The type 'S3' also cleans up the chars '+' and '#'
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $OrigFilename = $MainObject->FilenameCleanUp(
        Filename => $Param{Filename},
        Type     => 'S3',
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

    # find the file names and initial properties
    # TODO: actually, we don't really need the properties, just the file list
    my $ArticlePrefix = $Self->_ArticlePrefix( $Param{ArticleID} );
    my @Filenames;
    {
        my %Name2Properties = $Self->{StorageS3Object}->ListObjects(
            Prefix => "$ArticlePrefix/",
        );
        @Filenames = grep { $_ ne 'plain.txt' } keys %Name2Properties;
    }

    # for collection the info gathered from the headers of the HEAD requests
    my %Name2Item;

    # enhance the properties returned by ListObjects() with information from the headers
    $Self->{StorageS3Object}->ProcessHeaders(
        Prefix    => $ArticlePrefix,    # this time without the trailing slash
        Filenames => \@Filenames,
        Callback  => sub {
            my ($FinishedTransaction) = @_;

            # make the findings available outside the sub
            my $Filename = $FinishedTransaction->req->url->path->parts->[-1];
            my $Item     = {};
            $Name2Item{$Filename} = $Item;

            # keep track of the file name
            $Item->{Filename} = $Filename;

            # TODO return early: Mojo::Promise->reject('got no content type');
            my $Headers = $FinishedTransaction->res->headers;
            $Item->{ContentType}        = $Headers->content_type;
            $Item->{FilesizeRaw}        = $Headers->content_length;
            $Item->{ContentID}          = $Headers->header("$Self->{MetadataPrefix}ContentID")          || '';
            $Item->{ContentAlternative} = $Headers->header("$Self->{MetadataPrefix}ContentAlternative") || '';

            my $FullDisposition = $Headers->content_disposition;
            if ($FullDisposition) {
                ( $Item->{Disposition} ) = split /;/, $FullDisposition, 2;    # ignore the filename part
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
        },
    );

    # the hash that is returned is indexed by integers starting at 1
    my %Index;
    {
        my $Counter = 0;
        for my $Filename ( sort keys %Name2Item ) {
            $Index{ ++$Counter } = $Name2Item{$Filename};
        }
    }

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

    my %DataFromIndex = $Index{ $Param{FileID} }->%*;

    # retrieve attachment from S3, including the metadata
    my $FilePath   = $Self->_FilePath( $Param{ArticleID}, $DataFromIndex{Filename} );
    my %Attachment = $Self->{StorageS3Object}->RetrieveObject(
        Key                    => $FilePath,
        ContentMayBeFilehandle => $Param{ContentMayBeFilehandle},
    );

    # set the UTF-8 flag for UTF-8 attachments
    if (
        $Attachment{ContentType} =~ m/plain\/text/i
        &&
        $Attachment{ContentType} =~ m/utf-?8/i    # match utf8, utf-8, UTF8, UTF-8
        )
    {
        $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$Attachment{Content} );
    }

    return %Attachment;
}

# Bucket is not included
# Home prefix is not included.
# No trailing slash.
sub _ArticlePrefix {
    my ( $Self, $ArticleID ) = @_;

    # Include the content path, something like 2021/10/08, in the S3 keys.
    # Note that '/' is used as the delimiter in S3, this simplifies queries by year, month, and day.
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $ArticleID,
    );

    return join '/', 'var', 'article', $ContentPath, $ArticleID;
}

# Bucket is not included
# Home prefix is not included.
# No trailing slash.
sub _FilePath {
    my ( $Self, $ArticleID, $File ) = @_;

    return join '/', $Self->_ArticlePrefix($ArticleID), $File;
}

1;
