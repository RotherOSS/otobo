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

package Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;

use parent qw(Kernel::System::Ticket::Article::Backend::MIMEBase::Base);

# core modules
use File::Copy         qw(move);
use File::Path         qw(mkpath);
use Unicode::Normalize ();
use Cwd                qw(realpath);

# CPAN modules
use Plack::Util ();

# OTOBO modules
use Kernel::System::VariableCheck qw(IsStringWithData);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB',
);

=head1 NAME

Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageFS - FS based ticket article storage interface

=head1 DESCRIPTION

This class provides functions to manipulate ticket articles
in the file system.
The methods are currently documented in L<Kernel::System::Ticket::Article::Backend::MIMEBase>.

Inherits from L<Kernel::System::Ticket::Article::Backend::MIMEBase::Base>.

See also L<Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB>.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Call new() on Base.pm to execute the common code.
    my $Self = $Type->SUPER::new(%Param);

    # create a new directory every new day
    my $ArticleContentPath = $Self->BuildArticleContentPath();
    my $ArticleDir         = "$Self->{ArticleDataDir}/$ArticleContentPath/";

    mkpath( $ArticleDir, 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

    # Check write permissions.
    if ( !-w $ArticleDir ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Can't write $ArticleDir! try: \$OTOBO_HOME/bin/otobo.SetPermissions.pl!",
        );
        die "Can't write $ArticleDir! try: \$OTOBO_HOME/bin/otobo.SetPermissions.pl!";
    }

    # Get activated cache backend configuration.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    return $Self unless $ConfigObject->Get('Cache::ArticleStorageCache');

    my $CacheModule            = $ConfigObject->Get('Cache::Module') || '';
    my %CacheModuleIsSupported = (
        'Kernel::System::Cache::MemcachedFast' => 1,
        'Kernel::System::Cache::Redis'         => 1,
    );
    return $Self unless $CacheModuleIsSupported{$CacheModule};

    # Turn on special cache used for speeding up article storage methods in huge systems with many
    # nodes and slow FS access. It will be used only in environments
    # with configured Memcached or Redis.
    #   backend (see config above).
    $Self->{ArticleStorageCache}    = 1;
    $Self->{ArticleStorageCacheTTL} = $ConfigObject->Get('Cache::ArticleStorageCache::TTL') || 60 * 60 * 24;

    return $Self;
}

sub ArticleMoveFiles {
    my ( $Self, %Param ) = @_;

    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # check needed stuff
    for my $Item (qw(Location NewArticleVersion)) {
        if ( !$Param{$Item} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Item!",
            );

            return;
        }
    }

    #Search files for moving
    my @ArticleFiles = $MainObject->DirectoryRead(
        Directory => $Param{Location},
        Filter    => "*",
        Silent    => 1,
    );

    #Clean path from file list
    my @TempFiles;
    for my $File (@ArticleFiles) {
        $File =~ s{^.*/}{};
        push @TempFiles, $File;
    }

    @ArticleFiles = @TempFiles;

    if (@ArticleFiles) {
        mkdir("$Param{Location}/$Param{NewArticleVersion}");

        MOVE_FILES:
        for my $File (@ArticleFiles) {

            #Skip directories
            next MOVE_FILES if ( -d "$Param{Location}/$File" );

            $File = $EncodeObject->Convert2CharsetInternal(
                Text  => $File,
                From  => 'utf-8',
                Check => 1,
            );

            move( "$Param{Location}/$File", "$Param{Location}/$Param{NewArticleVersion}/$File" );

            $MainObject->FileDelete(
                Location        => "$Param{Location}/$File",
                Type            => 'Attachment',
                NoReplace       => 1,
                DisableWarnings => 1
            );
        }
    }

    return;
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
        ArticleID        => $Param{ArticleID},
        UserID           => $Param{UserID},
        DeletedVersionID => $Param{DeletedVersionID} || 0
    );

    # delete plain message
    $Self->ArticleDeletePlain(
        ArticleID        => $Param{ArticleID},
        UserID           => $Param{UserID},
        DeletedVersionID => $Param{DeletedVersionID} || 0
    );

    # delete storage directory
    $Self->_ArticleDeleteDirectory(
        ArticleID        => $Param{ArticleID},
        UserID           => $Param{UserID},
        DeletedVersionID => $Param{DeletedVersionID} || 0,
        VersionIDs       => $Param{VersionIDs}       || undef
    );

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
        );
    }

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

    # delete from fs
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $File = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt";
    if ( -f $File ) {
        if ( !unlink $File ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't remove: $File: $!!",
            );
            return;
        }
    }

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Delete(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
            Key  => 'ArticlePlain',
        );
    }

    # return if only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticleDeletePlain(
        %Param,
        OnlyMyBackend => 1,
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

    # delete from fs
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";

    if ( $Param{DeletedVersionID} ) {
        $Path .= "/$Param{DeletedVersionID}";
    }

    if ( -e $Path ) {

        my @List = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Path,
            Filter    => "*",
        );

        for my $File (@List) {

            if ( $File !~ /(\/|\\)plain.txt$/ && !( -d $File ) ) {

                if ( !unlink "$File" ) {

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Can't remove: $File: $!!",
                    );
                }
            }
        }

        #Check if version directory is empty to remove it
        if ( $Param{DeletedVersionID} ) {
            my @ListVersion = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $Path,
                Filter    => "*",
            );

            if ( !@ListVersion ) {
                my $Success = rmdir($Path);

                if ( !$Success ) {

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Can't remove version directory: $Path!!",
                    );
                }
            }
        }
    }

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
        );
    }

    # return if only delete in my backend
    return 1 if $Param{OnlyMyBackend};

    return $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticleDeleteAttachment(
        %Param,
        OnlyMyBackend => 1,
    );
}

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

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # define path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );
    my $Path = $Self->{ArticleDataDir} . '/' . $ContentPath . '/' . $Param{ArticleID};

    # debug
    if ( defined $Self->{Debug} && $Self->{Debug} > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log( Message => "->WriteArticle: $Path" );
    }

    # write article to fs 1:1
    mkpath( [$Path], 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

    # write article to fs
    my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => "$Path/plain.txt",
        Mode       => 'binmode',
        Content    => \$Param{Email},
        Permission => '660',
    );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticlePlain',
            Value          => $Param{Email},
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return if !$Success;

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

    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta $Param{ArticleID};
    $Param{ArticleID} =~ s/\0//g;

    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );

    # define path
    if ( !$Param{VersionID} ) {
        $Param{Path} = join '/', $Self->{ArticleDataDir}, $ContentPath, $Param{ArticleID};
    }
    else {
        $Param{Path} = join '/', $Self->{ArticleDataDir}, $ContentPath, $Param{SourceArticleID}, $Param{ArticleID};
    }

    # Perform FilenameCleanUp here already to check for
    #   conflicting existing attachment files correctly
    #   Special chars in file names are replaced only on ArticleStorageFS.
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $OrigFilename = $MainObject->FilenameCleanUp(
        Filename  => $Param{Filename},
        Type      => 'Local',
        NoReplace => 0,
    );

    # check for conflicts in the attachment file names
    my $UniqueFilename = $OrigFilename;
    {
        my %Index = $Self->ArticleAttachmentIndex(
            ArticleID => $Param{ArticleID},
        );

        # Normalize filenames to find file names which are identical but in a different unicode form.
        #   This is needed because Mac OS (HFS+) converts all filenames to NFD internally.
        #   Without this, the same file might be overwritten because the strings are not equal.
        my %UsedFile = map
            { Unicode::Normalize::NFC( $_->{Filename} ) => 1 }
            values %Index;

        NAME_CHECK:
        for ( my $i = 1; $i <= 50; $i++ ) {
            next NAME_CHECK unless $UsedFile{ Unicode::Normalize::NFC($UniqueFilename) };

            # keep the extension when renaming
            if ( $OrigFilename =~ m/^(.*)\.(.+?)$/ ) {
                $UniqueFilename = "$1-$i.$2";
            }
            else {
                $UniqueFilename = "$OrigFilename-$i";
            }
        }
    }

    # write attachment to backend
    if ( !-d $Param{Path} ) {
        if ( !mkpath( [ $Param{Path} ], 0, 0770 ) ) {    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create $Param{Path}: $!",
            );
            return;
        }
    }

    # write attachment content type to fs
    my $SuccessContentType = $MainObject->FileWrite(
        Directory       => $Param{Path},
        Filename        => "$UniqueFilename.content_type",
        Mode            => 'binmode',
        Content         => \$Param{ContentType},
        Permission      => 660,
        NoFilenameClean => 1,
    );

    return unless $SuccessContentType;

    # set content id in angle brackets
    if ( $Param{ContentID} ) {
        $Param{ContentID} =~ s/^([^<].*[^>])$/<$1>/;
    }

    # write attachment content id to fs
    if ( $Param{ContentID} ) {
        $MainObject->FileWrite(
            Directory       => $Param{Path},
            Filename        => "$UniqueFilename.content_id",
            Mode            => 'binmode',
            Content         => \$Param{ContentID},
            Permission      => 660,
            NoFilenameClean => 1,
        );
    }

    # write attachment content alternative to fs
    if ( $Param{ContentAlternative} ) {
        $MainObject->FileWrite(
            Directory       => $Param{Path},
            Filename        => "$UniqueFilename.content_alternative",
            Mode            => 'binmode',
            Content         => \$Param{ContentAlternative},
            Permission      => 660,
            NoFilenameClean => 1,
        );
    }

    # Remove the file name from the disposition
    # Write attachment disposition to the file system.
    if ( $Param{Disposition} ) {

        my ($Disposition) = split /;/, $Param{Disposition}, 2;

        $MainObject->FileWrite(
            Directory       => $Param{Path},
            Filename        => "$UniqueFilename.disposition",
            Mode            => 'binmode',
            Content         => \$Disposition || '',
            Permission      => 660,
            NoFilenameClean => 1,
        );
    }

    # write attachment content to fs
    my $SuccessContent = $MainObject->FileWrite(
        Directory  => $Param{Path},
        Filename   => $UniqueFilename,
        Mode       => 'binmode',
        Content    => \$Param{Content},
        Permission => 660,
    );

    return unless $SuccessContent;

    # Delete special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'ArticleStorageFS_' . $Param{ArticleID},
        );
    }

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

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Read from special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        my $Cache = $CacheObject->Get(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            Key            => 'ArticlePlain',
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        return $Cache if $Cache;
    }

    # get content path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID => $Param{ArticleID},
    );

    # open plain article
    if ( -f "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt" ) {

        # read whole article
        my $Data = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/",
            Filename  => 'plain.txt',
            Mode      => 'binmode',
        );

        return unless $Data;

        # Write to special article storage cache.
        if ( $Self->{ArticleStorageCache} ) {
            $CacheObject->Set(
                Type           => 'ArticleStorageFS_' . $Param{ArticleID},
                TTL            => $Self->{ArticleStorageCacheTTL},
                Key            => 'ArticlePlain',
                Value          => ${$Data},
                CacheInMemory  => 0,
                CacheInBackend => 1,
            );
        }

        return $Data->$*;
    }

    # return if we only need to check one backend
    return unless $Self->{CheckAllBackends};

    # return if only retrieve in my backend
    return if $Param{OnlyMyBackend};

    my $Data = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticlePlain(
        %Param,
        OnlyMyBackend => 1,
    );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticlePlain',
            Value          => $Data,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return $Data;
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

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Read from special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        my $Cache = $CacheObject->Get(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            Key            => 'ArticleAttachmentIndexRaw',
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        return %{$Cache} if $Cache;
    }

    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID       => $Param{ArticleID},
        VersionView     => $Param{VersionView}     || '',
        SourceArticleID => $Param{SourceArticleID} || ''
    );
    my %Index;
    my $Counter = 0;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my @List;

    # try fs
    if ( $Param{SourceArticleID} && !$Param{ArticleDeleted} ) {
        @List = $MainObject->DirectoryRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{SourceArticleID}/$Param{ArticleID}",
            Filter    => "*",
            Silent    => 1,
        );
    }
    else {

        if ( $Param{ArticleDeleted} ) {
            $Param{ArticleID} = $Param{SourceArticleID};
        }

        @List = $MainObject->DirectoryRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}",
            Filter    => "*",
            Silent    => 1,
        );
    }

    FILENAME:
    for my $Filename ( sort @List ) {
        my $FilesizeRaw = -s $Filename;

        # do not use control file
        next FILENAME if $Filename =~ /\.content_alternative$/;
        next FILENAME if $Filename =~ /\.content_id$/;
        next FILENAME if $Filename =~ /\.content_type$/;
        next FILENAME if $Filename =~ /\.disposition$/;
        next FILENAME if $Filename =~ /\/plain.txt$/;

        # read content type
        my $ContentType = '';
        my $ContentID   = '';
        my $Alternative = '';
        my $Disposition = '';
        if ( -e "$Filename.content_type" ) {
            my $Content = $MainObject->FileRead(
                Location => "$Filename.content_type",
            );
            return if !$Content;
            $ContentType = ${$Content};

            # content id (optional)
            if ( -e "$Filename.content_id" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.content_id",
                );
                if ($Content) {
                    $ContentID = ${$Content};
                }
            }

            # alternative (optional)
            if ( -e "$Filename.content_alternative" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.content_alternative",
                );
                if ($Content) {
                    $Alternative = ${$Content};
                }
            }

            # disposition
            if ( -e "$Filename.disposition" ) {
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.disposition",
                );
                if ($Content) {
                    $Disposition = ${$Content};
                }
            }

            # if no content disposition is set images with content id should be inline
            elsif ( $ContentID && $ContentType =~ m{image}i ) {
                $Disposition = 'inline';
            }

            # converted article body should be inline
            elsif ( $Filename =~ m{file-[12]} ) {
                $Disposition = 'inline';
            }

            # all others including attachments with content id that are not images
            #   should NOT be inline
            else {
                $Disposition = 'attachment';
            }
        }

        # read content type (old style)
        else {
            my $Content = $MainObject->FileRead(
                Location => $Filename,
                Result   => 'ARRAY',
            );

            return unless $Content;

            $ContentType = $Content->[0];
        }

        # strip filename
        $Filename =~ s!^.*/!!;

        # add the info the the hash
        $Counter++;
        $Index{$Counter} = {
            Filename           => $Filename,
            FilesizeRaw        => $FilesizeRaw,
            ContentType        => $ContentType,
            ContentID          => $ContentID,
            ContentAlternative => $Alternative,
            Disposition        => $Disposition,
        };
    }

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticleAttachmentIndexRaw',
            Value          => \%Index,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return %Index if %Index;

    # return if we only need to check one backend
    return unless $Self->{CheckAllBackends};

    # return if only delete in my backend
    return %Index if $Param{OnlyMyBackend};

    %Index = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticleAttachmentIndexRaw(
        %Param,
        OnlyMyBackend => 1,
    );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticleAttachmentIndexRaw',
            Value          => \%Index,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return %Index;
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
    $Param{ArticleID} = quotemeta( $Param{ArticleID} );
    $Param{ArticleID} =~ s/\0//g;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Read from special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        my $Cache = $CacheObject->Get(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            Key            => 'ArticleAttachment' . $Param{FileID},
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        return %{$Cache} if $Cache;
    }

    # get some data from the attachment index
    my %Index = $Self->ArticleAttachmentIndex(
        ArticleID       => $Param{ArticleID},
        VersionView     => $Param{VersionView},
        SourceArticleID => $Param{SourceArticleID},
        ArticleDeleted  => $Param{ArticleDeleted}
    );
    my %Data = %{ $Index{ $Param{FileID} } // {} };

    # get content path
    my $ContentPath = $Self->_ArticleContentPathGet(
        ArticleID   => $Param{ArticleID},
        VersionView => $Param{VersionView}
    );
    my $Counter = 0;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List;

    if ( $Param{SourceArticleID} && $Param{VersionView} ) {
        @List = $MainObject->DirectoryRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{SourceArticleID}/$Param{ArticleID}",
            Filter    => "*",
            Silent    => 1,
        );
    }
    else {
        @List = $MainObject->DirectoryRead(
            Directory => "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}",
            Filter    => "*",
            Silent    => 1,
        );
    }

    if (@List) {

        # get encode object
        my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

        FILENAME:
        for my $Filename (@List) {
            next FILENAME if $Filename =~ m/\.content_alternative$/;
            next FILENAME if $Filename =~ m/\.content_id$/;
            next FILENAME if $Filename =~ m/\.content_type$/;
            next FILENAME if $Filename =~ m/\/plain.txt$/;
            next FILENAME if $Filename =~ m/\.disposition$/;

            # we have a content file
            $Counter++;

            # handle only the relevant content file
            next FILENAME unless $Counter == $Param{FileID};

            if ( -e "$Filename.content_type" ) {

                # read content type
                my $Content = $MainObject->FileRead(
                    Location => "$Filename.content_type",
                );

                return unless $Content;

                $Data{ContentType} = $Content->$*;

                # The content does not necessarily have to be read into memory.
                # Returning an open file handle suffices for a Plack application.
                if ( $Param{ContentMayBeFilehandle} ) {

                    ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen OTOBO::ProhibitLowPrecedenceOps)
                    open my $ContentFH, '<:raw', $Filename
                        or return;
                    Plack::Util::set_io_path( $ContentFH, realpath($Filename) );
                    $Data{Content} = $ContentFH;
                }
                else {

                    # slurp in the bytes of the content
                    my $Content = $MainObject->FileRead(
                        Location => $Filename,
                        Mode     => 'binmode',
                    );

                    return unless $Content;

                    $Data{Content} = $Content->$*;
                }

                # content id (optional)
                if ( -e "$Filename.content_id" ) {
                    my $Content = $MainObject->FileRead(
                        Location => "$Filename.content_id",
                    );
                    if ($Content) {
                        $Data{ContentID} = $Content->$*;
                    }
                }

                # alternative (optional)
                if ( -e "$Filename.content_alternative" ) {
                    my $Content = $MainObject->FileRead(
                        Location => "$Filename.content_alternative",
                    );
                    if ($Content) {
                        $Data{Alternative} = $Content->$*;
                    }
                }

                # disposition
                if ( -e "$Filename.disposition" ) {
                    my $Content = $MainObject->FileRead(
                        Location => "$Filename.disposition",
                    );
                    if ($Content) {
                        $Data{Disposition} = $Content->$*;
                    }
                }

                # if no content disposition is set images with content id should be inline
                elsif ( $Data{ContentID} && $Data{ContentType} =~ m{image}i ) {
                    $Data{Disposition} = 'inline';
                }

                # converted article body should be inline
                elsif ( $Filename =~ m{file-[12]} ) {
                    $Data{Disposition} = 'inline';
                }

                # all others including attachments with content id that are not images
                #   should NOT be inline
                else {
                    $Data{Disposition} = 'attachment';
                }
            }
            else {

                # read content
                my $Content = $MainObject->FileRead(
                    Location => $Filename,
                    Mode     => 'binmode',
                    Result   => 'ARRAY',
                );

                return unless $Content;

                # The content type is in the first line of the content
                $Data{ContentType} = $Content->[0];

                # skip the first line when reading in the actual content
                my $Counter = 0;
                for my $Line ( $Content->@* ) {
                    if ($Counter) {
                        $Data{Content} .= $Line;
                    }
                    $Counter++;
                }
            }

            $Data{ContentType} ||= '';

            if (
                $Data{ContentType} =~ /plain\/text/i
                && $Data{ContentType} =~ /(utf\-8|utf8)/i
                )
            {
                $EncodeObject->EncodeInput( \$Data{Content} );
            }

            chomp $Data{ContentType};

            # Write to special article storage cache.
            if ( $Self->{ArticleStorageCache} ) {
                $CacheObject->Set(
                    Type           => 'ArticleStorageFS_' . $Param{ArticleID},
                    TTL            => $Self->{ArticleStorageCacheTTL},
                    Key            => 'ArticleAttachment' . $Param{FileID},
                    Value          => \%Data,
                    CacheInMemory  => 0,
                    CacheInBackend => 1,
                );
            }

            return %Data;
        }
    }

    # return if we only need to check one backend
    return unless $Self->{CheckAllBackends};

    # return if only delete in my backend
    return if $Param{OnlyMyBackend};

    %Data = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::MIMEBase::ArticleStorageDB')->ArticleAttachment(
        %Param,
        OnlyMyBackend => 1,
    );

    # Write to special article storage cache.
    if ( $Self->{ArticleStorageCache} ) {
        $CacheObject->Set(
            Type           => 'ArticleStorageFS_' . $Param{ArticleID},
            TTL            => $Self->{ArticleStorageCacheTTL},
            Key            => 'ArticleAttachment' . $Param{FileID},
            Value          => \%Data,
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );
    }

    return %Data;
}

1;
