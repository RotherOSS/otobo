# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::Loader;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules
use CSS::Minifier::XS        ();
use JavaScript::Minifier::XS ();

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Cache',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storage::S3',
);

=head1 NAME

Kernel::System::Loader - CSS/JavaScript loader backend

=head1 DESCRIPTION

All valid functions.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    my $LoaderObject = $Kernel::OM->Get('Kernel::System::Loader');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    $Self->{CacheType} = 'Loader';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    # find out whether loader files are stored in S3 or in the file system
    $Self->{S3Active}     = $Kernel::OM->Get('Kernel::Config')->Get('Storage::S3::Active') ? 1 : 0;
    $Self->{UseFSBackend} = !$Self->{S3Active};

    return $Self;
}

=head2 MinifyFiles()

takes a list of files and returns a filename in the target directory
which holds the minified and concatenated content of the files.
Uses caching internally.

With S3 support the returned value is the last part of the key of the object that is stored in S3.

It is expected that the TargetDirectory is a directory below the OTOBO home directory.

    my $TargetFilename = $LoaderObject->MinifyFiles(
        List  => [                                 # optional,  minify list of files
            $Filename,
            $Filename2,
        ],
        Checksum             => '...'              # optional, pass a checksum for the minified file
        Content              => '...'              # optional, pass direct (already minified) content instead of a file list
        Type                 => 'CSS',             # CSS | JavaScript
        TargetDirectory      => $TargetDirectory,
        TargetFilenamePrefix => 'CommonCSS',       # optional, prefix for the target filename
    );

=cut

sub MinifyFiles {
    my ( $Self, %Param ) = @_;

    # check needed params
    my $List    = $Param{List};
    my $Content = $Param{Content};

    if ( !$Content && ( ref $List ne 'ARRAY' || !@{$List} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need List or Content!',
        );

        return;
    }

    my $TargetDirectory = $Param{TargetDirectory};
    $TargetDirectory =~ s!/$!!;

    # create and check the target directory
    if ( $Self->{UseFSBackend} ) {
        if ( !-e $TargetDirectory ) {
            if ( !mkdir( $TargetDirectory, 0775 ) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't create directory '$TargetDirectory': $!",
                );

                return;
            }
        }

        if ( !$TargetDirectory || !-d $TargetDirectory ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need valid TargetDirectory, got '$TargetDirectory'!",
            );

            return;
        }
    }

    my $TargetFilenamePrefix = $Param{TargetFilenamePrefix} ? "$Param{TargetFilenamePrefix}_" : '';

    my %ValidTypeParams = (
        CSS        => 1,
        JavaScript => 1,
    );

    if ( !$Param{Type} || !$ValidTypeParams{ $Param{Type} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Filename;
    if ( $Param{Checksum} ) {
        $Filename = $TargetFilenamePrefix . $Param{Checksum};
    }
    else {
        my $FileString;

        if ( $Param{List} ) {
            LOCATION:
            for my $Location ( @{$List} ) {
                next LOCATION unless -e $Location;

                my $FileMTime = $MainObject->FileGetMTime(
                    Location => $Location
                );

                # For the caching, use both filename and mtime to make sure that
                #   caches are correctly regenerated on changes.
                $FileString .= "$Location:$FileMTime:";
            }
        }

        $Filename = $TargetFilenamePrefix . $MainObject->MD5sum(
            String => \$FileString,
        );
    }

    if ( $Param{Type} eq 'CSS' ) {
        $Filename .= '.css';
    }
    elsif ( $Param{Type} eq 'JavaScript' ) {
        $Filename .= '.js';
    }

    # Check whether the loader file already exists
    my $LoaderFileExists = 0;
    if ( $Self->{UseFSBackend} ) {
        $LoaderFileExists = -r "$TargetDirectory/$Filename";
    }
    else {
        my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');

        # the target directory is below the OTOBO home dir, adapt that to S3
        my $FilePath = join '/', $TargetDirectory, $Filename;
        my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');    # without trailing slash
        my $Key      = $FilePath =~ s!^$Home/!!r;                          # /opt/otobo/var/httpd becomes var/httpd

        $LoaderFileExists = $StorageS3Object->ObjectExists(
            Key => $Key,
        );
    }

    if ( !$LoaderFileExists ) {

        # no cache available, so loop through all files, get minified version and concatenate
        LOCATION:
        for my $Location ( $List->@* ) {

            next LOCATION unless -r $Location;

            # cut out the system specific parts for the comments (for easier testing)
            # for now, only keep filename
            my $Label = $Location;
            $Label =~ s{^.*/}{}smx;

            if ( $Param{Type} eq 'CSS' ) {

                eval {
                    $Content .= $Self->GetMinifiedFile(
                        Location => $Location,
                        Type     => $Param{Type},
                    );
                };

                if ($@) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Error during file minification: $@",
                    );
                }

                $Content .= "\n";
            }
            elsif ( $Param{Type} eq 'JavaScript' ) {

                eval {
                    $Content .= $Self->GetMinifiedFile(
                        Location => $Location,
                        Type     => $Param{Type},
                    );
                };

                if ($@) {
                    my $JSError = "Error during minification of file $Location: $@";
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => $JSError,
                    );
                    $JSError =~ s/'/\\'/gsmx;
                    $JSError =~ s/\r?\n/ /gsmx;
                    $Content .= "alert('$JSError');";
                }
                $Content .= "\n";
            }
        }

        # When the S3 backend is active the loader file is not written to the file system.
        # Daemons and web servers are responsible for syncing the file from S3 to the file system.
        # There is no check whether the file is actually written to the file system or to S3.
        # Write failures will lead to missing files, usually a 404 error, when these files are requested.
        # It is hoped that a reload of the page will alleviate the situation, as those lost files
        #  will be created with the next request.
        if ( $Self->{S3Active} ) {

            my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');

            # the target directory is below the OTOBO home dir, adapt that to S3
            my $FilePath = join '/', $TargetDirectory, $Filename;
            my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');    # without trailing slash
            my $Key      = $FilePath =~ s!^$Home/!!r;                          # /opt/otobo/var/httpd becomes var/httpd
            $StorageS3Object->StoreObject(
                Key     => $Key,
                Content => $Content,
            );
        }
        else {

            # FileWrite() tries to get an exclusive lock on the target file.
            # It is OK when the lock can't be obtained. In that case we assume
            # that another process writes the same content to that file.
            # Bad luck, when the file is requested before the other process has finished writing.
            $MainObject->FileWrite(
                Directory => $TargetDirectory,
                Filename  => $Filename,
                Content   => \$Content,
            );
        }
    }

    return $Filename;
}

=head2 GetMinifiedFile()

returns the minified contents of a given CSS or JavaScript file.
Uses caching internally.

    my $MinifiedCSS = $LoaderObject->GetMinifiedFile(
        Location => $Filename,
        Type     => 'CSS',      # CSS | JavaScript
    );

Warning: this function may cause a die() if there are errors in the file,
protect against that with eval().

=cut

sub GetMinifiedFile {
    my ( $Self, %Param ) = @_;

    # check needed params
    my $Location = $Param{Location};
    if ( !$Location ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Location!',
        );
        return;
    }

    my %ValidTypeParams = (
        CSS        => 1,
        JavaScript => 1,
    );

    if ( !$Param{Type} || !$ValidTypeParams{ $Param{Type} } ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Type! Must be one of '" . join( ', ', keys %ValidTypeParams ) . "'."
        );
        return;
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $FileMTime = $MainObject->FileGetMTime(
        Location => $Location,
    );

    # For the caching, use both filename and mtime to make sure that
    #   caches are correctly regenerated on changes.
    my $CacheKey = "$Location:$FileMTime";

    # check if a cached version exists
    my $CacheContent = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    return $CacheContent->$* if ref $CacheContent eq 'SCALAR';

    # no cache available, read and minify file
    my $FileContents = $MainObject->FileRead(
        Location => $Location,

        # It would be more correct to use UTF8 mode, but then the JavaScript::Minifier::XS
        #   will cause timeouts due to extreme slowness on some UT servers. Disable for now.
        #   Unicode in the files still works correctly.
        #Mode     => 'utf8',
    );

    return unless ref $FileContents eq 'SCALAR';

    my $Result;
    if ( $Param{Type} eq 'CSS' ) {
        $Result = $Self->MinifyCSS( Code => $$FileContents );
    }
    elsif ( $Param{Type} eq 'JavaScript' ) {
        $Result = $Self->MinifyJavaScript( Code => $$FileContents );
    }

    # and put it in the cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \$Result,
    );

    return $Result;
}

=head2 MinifyCSS()

returns a minified version of the given CSS Code

    my $MinifiedCSS = $LoaderObject->MinifyCSS( Code => $CSS );

Warning: this function may cause a die() if there are errors in the file,
protect against that with eval().

=cut

sub MinifyCSS {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Code} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Code Param!',
        );

        return;
    }

    return CSS::Minifier::XS::minify( $Param{Code} );
}

=head2 MinifyJavaScript()

returns a minified version of the given JavaScript Code.

    my $MinifiedJS = $LoaderObject->MinifyJavaScript( Code => $JavaScript );

Warning: this function may cause a die() if there are errors in the file,
protect against that with eval().

This function internally uses the CPAN module JavaScript::Minifier::XS.

=cut

sub MinifyJavaScript {
    my ( $Self, %Param ) = @_;

    # check needed params
    if ( !$Param{Code} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Code Param!',
        );

        return;
    }

    return JavaScript::Minifier::XS::minify( $Param{Code} );
}

=head2 CacheGenerate()

generates the loader cache files for all frontend modules.

    my %GeneratedFiles = $LoaderObject->CacheGenerate();

=cut

sub CacheGenerate {
    my ( $Self, %Param ) = @_;

    my @Result;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    ## nofilter(TidyAll::Plugin::OTOBO::Perl::LayoutObject)
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %AgentFrontends = %{ $ConfigObject->Get('Frontend::Module') // {} };

    for my $FrontendModule ( sort { $a cmp $b } keys %AgentFrontends ) {
        $LayoutObject->{Action} = $FrontendModule;
        $LayoutObject->LoaderCreateAgentCSSCalls();
        $LayoutObject->LoaderCreateAgentJSCalls();
        push @Result, $FrontendModule;
    }

    my %CustomerFrontends = (
        %{ $ConfigObject->Get('CustomerFrontend::Module') // {} },
        %{ $ConfigObject->Get('PublicFrontend::Module')   // {} },
    );

    for my $FrontendModule ( sort { $a cmp $b } keys %CustomerFrontends ) {
        $LayoutObject->{Action} = $FrontendModule;
        $LayoutObject->LoaderCreateCustomerCSSCalls();
        $LayoutObject->LoaderCreateCustomerJSCalls();
        push @Result, $FrontendModule;
    }

    # Now generate JavaScript translation content
    for my $UserLanguage ( sort keys %{ $ConfigObject->Get('DefaultUsedLanguages') // {} } ) {
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Language'] );
        my $LocalLayoutObject = Kernel::Output::HTML::Layout->new(
            Lang => $UserLanguage,
        );
        $LocalLayoutObject->LoaderCreateJavaScriptTranslationData();
    }

    # generate JS template cache
    $LayoutObject->LoaderCreateJavaScriptTemplateData();

    return @Result;
}

=head2 CacheDelete()

deletes all the loader cache files.

Returns a list of deleted files.

    my @DeletedFiles = $LoaderObject->CacheDelete();

=cut

sub CacheDelete {
    my ($Self) = @_;

    # the file system cache files are located below the OTOBO home dir
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # for JavaScript there is only one cache folder
    my @CacheFoldersList = ("$Home/var/httpd/htdocs/js/js-cache");

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Looking for all skin folders that may contain a cache folder
    my @SkinTypeDirectories = (
        "$Home/var/httpd/htdocs/skins/Agent",
        "$Home/var/httpd/htdocs/skins/Customer",
    );
    for my $Folder (@SkinTypeDirectories) {
        my @List = $MainObject->DirectoryRead(
            Directory => $Folder,
            Filter    => '*',
        );

        FOLDER:
        for my $Folder (@List) {

            next FOLDER unless -d $Folder;

            # there can be no more than one css-cache subfolder
            my ($CacheFolder) = $MainObject->DirectoryRead(
                Directory => $Folder,
                Filter    => 'css-cache',
            );

            if ( $CacheFolder && -d $CacheFolder ) {
                push @CacheFoldersList, $CacheFolder;
            }
        }
    }

    # now go through the cache folders and delete all .js and .css files
    my @Result;
    my @FileTypes = ( '*.js', '*.css' );
    FOLDERTODELETE:
    for my $FolderToDelete (@CacheFoldersList) {
        next FOLDERTODELETE unless -d $FolderToDelete;

        my @FilesList = $MainObject->DirectoryRead(
            Directory => $FolderToDelete,
            Filter    => \@FileTypes,
        );
        for my $File (@FilesList) {
            if ( $MainObject->FileDelete( Location => $File ) ) {
                push @Result, $File;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't remove: $File"
                );
            }
        }
    }

    if ( $Self->{S3Active} ) {
        $Self->_S3CacheDelete();
    }

    # finally, also clean up the internal perl cache files
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return @Result;
}

=head2 _S3CacheDelete()

deletes all the loader cache files. That is all files with the prefix I<var/httpd/htdocs>
where the key contains neither I</js-cache/> nor I</css-cache>.

Returns the success of the the discard operations.

    my $Success = $LoaderObject->_S3CacheDelete();

=cut

sub _S3CacheDelete {
    my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');

    return $StorageS3Object->DiscardObjects(
        Prefix      => 'var/httpd/htdocs/',
        Delimiter   => '',
        DiscardOnly => qr!/(?:css|js)-cache/!,
    );
}

1;
