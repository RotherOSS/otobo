# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::Ticket::Article::Backend::MIMEBase::Base;

use strict;
use warnings;
use File::Path qw(remove_tree);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::Base - base class for article storage modules

=head1 DESCRIPTION

This is a base class for article storage backends and should not be instantiated directly.

=head1 PUBLIC INTERFACE

=cut

=head2 new()

Don't instantiate this class directly, get instances of the real storage backends instead:

    my $BackendObject = $Kernel::OM->Get('Kernel::System::Article::Backend::MIMEBase::ArticleStorageDB');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # attributes common to all backends
    $Self->{CacheType} = 'ArticleStorageBase';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    # only used in ArticleStorageFS
    $Self->{ArticleDataDir} = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::ArticleDataDir')
        || die 'Got no ArticleDataDir!';

    # do we need to check all backends, or just one?
    # only used in ArticleStorageFS and ArticleStorageDB
    $Self->{CheckAllBackends} = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::CheckAllStorageBackends')
        // 0;

    return $Self;
}

=head2 BuildArticleContentPath()

Generate a base article content path for article storage in the file system.

    my $ArticleContentPath = $BackendObject->BuildArticleContentPath();

This is useful in file system based storage backends because there should not be too many entries in a directory.
A different content path, in the form YYYY/MM/DD is generated for every day.

=cut

sub BuildArticleContentPath {
    my ( $Self, %Param ) = @_;

    return $Self->{ArticleContentPath} if $Self->{ArticleContentPath};

    $Self->{ArticleContentPath} = $Kernel::OM->Create('Kernel::System::DateTime')->Format(
        Format => '%Y/%m/%d',
    );

    return $Self->{ArticleContentPath};
}

=head2 ArticleAttachmentIndex()

Get article attachment index as hash.

    my %Index = $BackendObject->ArticleAttachmentIndex(
        ArticleID        => 123,
        ExcludePlainText => 1,       # (optional) Exclude plain text attachment
        ExcludeHTMLBody  => 1,       # (optional) Exclude HTML body attachment
        ExcludeInline    => 1,       # (optional) Exclude inline attachments
        OnlyHTMLBody     => 1,       # (optional) Return only HTML body attachment, return nothing if not found
        ShowDeletedArticles => 1,    # (optional) To deleted articles.
        VersionView   => 1,          # (optional) To get edited version info.
    );

Returns:

    my %Index = {
        '1' => {                                                # Attachment ID
            ContentAlternative => '',                           # (optional)
            ContentID          => '',                           # (optional)
            ContentType        => 'application/pdf',
            Filename           => 'StdAttachment-Test1.pdf',
            FilesizeRaw        => 4722,
            Disposition        => 'attachment',
        },
        '2' => {
            ContentAlternative => '',
            ContentID          => '',
            ContentType        => 'text/html; charset="utf-8"',
            Filename           => 'file-2',
            FilesizeRaw        => 183,
            Disposition        => 'attachment',
        },
        ...
    };

=cut

sub ArticleAttachmentIndex {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );
        return;
    }

    if ( $Param{ExcludeHTMLBody} && $Param{OnlyHTMLBody} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'ExcludeHTMLBody and OnlyHTMLBody cannot be used together!',
        );
        return;
    }

    if ( $Param{ArticleDeleted} ) {
        my $Temp = $Param{SourceArticleID};
        $Param{SourceArticleID} = $Param{ArticleID};
        $Param{ArticleID}       = $Temp;
    }

    # Get complete attachment index from backend.
    my %Attachments = $Self->ArticleAttachmentIndexRaw(%Param);

    # Iterate over attachments only if any of optional parameters is active.
    if ( $Param{ExcludePlainText} || $Param{ExcludeHTMLBody} || $Param{ExcludeInline} || $Param{OnlyHTMLBody} ) {

        my $AttachmentIDPlain = 0;
        my $AttachmentIDHTML  = 0;

        ATTACHMENT_ID:
        for my $AttachmentID ( sort keys %Attachments ) {
            my %File = %{ $Attachments{$AttachmentID} };

            #Discard directories
            if ( !$File{ContentType} && !$File{Disposition} ) {
                delete $Attachments{$AttachmentID};
                next ATTACHMENT_ID;
            }

            # Identify plain text attachment.
            if (
                !$AttachmentIDPlain
                &&
                $File{Filename} eq 'file-1'
                && $File{ContentType} =~ /text\/plain/i
                && $File{Disposition} eq 'inline'
                )
            {
                $AttachmentIDPlain = $AttachmentID;
                next ATTACHMENT_ID;
            }

            # Identify html body attachment:
            #   - file-[12] is plain+html attachment
            #   - file-1.html is html attachment only
            if (
                !$AttachmentIDHTML
                &&
                ( $File{Filename} =~ /^file-[12]$/ || $File{Filename} eq 'file-1.html' )
                && $File{ContentType} =~ /text\/html/i
                && $File{Disposition} eq 'inline'
                )
            {
                $AttachmentIDHTML = $AttachmentID;
                next ATTACHMENT_ID;
            }
        }

        # If neither plain text or html body were found, iterate again to try to identify plain text among regular
        #   non-inline attachments.
        if ( !$AttachmentIDPlain && !$AttachmentIDHTML ) {
            ATTACHMENT_ID:
            for my $AttachmentID ( sort keys %Attachments ) {
                my %File = %{ $Attachments{$AttachmentID} };

                # Remember, file-1 got defined by parsing if no filename was given.
                if (
                    $File{Filename} eq 'file-1'
                    && $File{ContentType} =~ /text\/plain/i
                    )
                {
                    $AttachmentIDPlain = $AttachmentID;
                    last ATTACHMENT_ID;
                }
            }
        }

        # Identify inline (image) attachments which are referenced in HTML body. Do not strip attachments based on their
        #   disposition, since this method of detection is unreliable. Please see bug#13353 for more information.
        my @AttachmentIDsInline;

        if ($AttachmentIDHTML) {

            # Get HTML article body.
            my %HTMLBody = $Self->ArticleAttachment(
                ArticleID       => $Param{ArticleID},
                FileID          => $AttachmentIDHTML,
                VersionView     => $Param{VersionView},
                SourceArticleID => $Param{SourceArticleID},
            );

            if ( %HTMLBody && $HTMLBody{Content} ) {

                ATTACHMENT_ID:
                for my $AttachmentID ( sort keys %Attachments ) {
                    my %File = %{ $Attachments{$AttachmentID} };

                    next ATTACHMENT_ID if $File{ContentType} !~ m{image}ixms;
                    next ATTACHMENT_ID if !$File{ContentID};

                    my ($ImageID) = ( $File{ContentID} =~ m{^<(.*)>$}ixms );

                    # Search in the article body if there is any reference to it.
                    if ( $HTMLBody{Content} =~ m{<img.+src=['|"]cid:\Q$ImageID\E['|"].*>}ixms ) {
                        push @AttachmentIDsInline, $AttachmentID;
                    }
                }
            }
        }

        if ( $AttachmentIDPlain && $Param{ExcludePlainText} ) {
            delete $Attachments{$AttachmentIDPlain};
        }

        if ( $AttachmentIDHTML && $Param{ExcludeHTMLBody} ) {
            delete $Attachments{$AttachmentIDHTML};
        }

        if ( $Param{ExcludeInline} ) {
            for my $AttachmentID (@AttachmentIDsInline) {
                delete $Attachments{$AttachmentID};
            }
        }

        if ( $Param{OnlyHTMLBody} ) {
            if ($AttachmentIDHTML) {
                %Attachments = (
                    $AttachmentIDHTML => $Attachments{$AttachmentIDHTML}
                );
            }
            else {
                %Attachments = ();
            }
        }
    }

    return %Attachments;
}

=head1 PRIVATE FUNCTIONS

=cut

sub _ArticleDeleteDirectory {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ArticleID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # delete directory from fs
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";
    if ( -d $Path ) {
        for my $VersionID ( @{ $Param{VersionIDs} } ) {
            remove_tree( $Path . '/' . $VersionID, { safe => 1 } );
        }

        if ( !rmdir($Path) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't remove '$Path': $!.",
            );
            return;
        }
    }
    return 1;
}

=head2 _ArticleContentPathGet()

Get the stored content path of an article.

    my $Path = $BackendObject->_ArticleContentPatGeth(
        ArticleID => 123,
        ShowDeletedArticles => 1, # (optional) To deleted articles.
        VersionView   => 1,       # (optional) To get edited version info.
    );

=cut

sub _ArticleContentPathGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ArticleID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ArticleID!',
        );
        return;
    }

    # check key
    my $CacheKey = '_ArticleContentPathGet::' . $Param{ArticleID};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $Cache = $CacheObject->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    if ( !$Param{VersionView} ) {
        return $Cache if $Cache;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $IsArticleDeleted = $Kernel::OM->Get('Kernel::System::Ticket::ArticleFeatures')->IsArticleDeleted(
        ArticleID => $Param{ArticleID}
    );

    if ( !$IsArticleDeleted && !$Param{VersionView} ) {

        # sql query for normal articles
        return if !$DBObject->Prepare(
            SQL  => 'SELECT content_path FROM article_data_mime WHERE article_id = ?',
            Bind => [ \$Param{ArticleID} ],
        );
    }
    elsif ( $Param{VersionView} && !$IsArticleDeleted ) {

        # sql query for Version View
        return if !$DBObject->Prepare(
            SQL  => 'SELECT content_path FROM article_data_mime_version WHERE article_id IN (SELECT id FROM article_version WHERE article_id = ?)',
            Bind => [ \$Param{ArticleID} ],
        );
    }
    else {
        # sql query for Deleted Articles
        return if !$DBObject->Prepare(
            SQL =>
                'SELECT content_path FROM article_data_mime_version WHERE article_id IN (SELECT id FROM article_version WHERE source_article_id = ? AND article_delete = 1)',
            Bind => [ \$Param{ArticleID} ],
        );
    }

    my $Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result = $Row[0];
    }

    # set cache
    $CacheObject->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => $Result,
    );

    # return
    return $Result;
}

1;
