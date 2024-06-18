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

package Kernel::System::Web::UploadCache;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Web::FormCache',
);

=head1 NAME

Kernel::System::Web::UploadCache - an upload file system cache

=head1 DESCRIPTION

All upload cache functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $WebUploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    my $GenericModule = $Kernel::OM->Get('Kernel::Config')->Get('WebUploadCacheModule')
        || 'Kernel::System::Web::UploadCache::DB';

    # load generator auth module
    $Self->{Backend} = $Kernel::OM->Get($GenericModule);

    return $Self if $Self->{Backend};
    return;
}

=head2 FormIDCreate()

create a new Form ID - this method was moved to Web::FormCache

    my $FormID = $UploadCacheObject->FormIDCreate();

=cut

sub FormIDCreate {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Web::FormCache')->FormIDCreate(%Param);
}

=head2 FormIDRemove()

remove all data for a provided Form ID

    $UploadCacheObject->FormIDRemove( FormID => 123456 );

=cut

sub FormIDRemove {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->FormIDRemove(%Param);
}

=head2 FormIDAddFile()

add a file to a Form ID

    $UploadCacheObject->FormIDAddFile(
        FormID      => 12345,
        Filename    => 'somefile.html',
        Content     => $FileInString,
        ContentType => 'text/html',
        Disposition => 'inline', # optional
    );

ContentID is optional (automatically generated if not given on disposition = inline)

    $UploadCacheObject->FormIDAddFile(
        FormID      => 12345,
        Filename    => 'somefile.html',
        Content     => $FileInString,
        ContentID   => 'some_id@example.com',
        ContentType => 'text/html',
        Disposition => 'inline', # optional
    );

=cut

sub FormIDAddFile {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->FormIDAddFile(%Param);
}

=head2 FormIDRemoveFile()

removes a file from a form id

    $UploadCacheObject->FormIDRemoveFile(
        FormID => 12345,
        FileID => 1,
    );

=cut

sub FormIDRemoveFile {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->FormIDRemoveFile(%Param);
}

=head2 FormIDGetAllFilesData()

returns an array with a hash ref of all files for a Form ID

    my @Data = $UploadCacheObject->FormIDGetAllFilesData(
        FormID => 12345,
    );

    Return data of on hash is Content, ContentType, ContentID, Filename, Filesize, FileID;

=cut

sub FormIDGetAllFilesData {
    my ( $Self, %Param ) = @_;

    return @{ $Self->{Backend}->FormIDGetAllFilesData(%Param) };
}

=head2 FormIDGetAllFilesMeta()

returns an array with a hash ref of all files for a Form ID

Note: returns no content, only meta data.

    my @Data = $UploadCacheObject->FormIDGetAllFilesMeta(
        FormID => 12345,
    );

    Return data of hash is ContentType, ContentID, Filename, Filesize, FileID;

=cut

sub FormIDGetAllFilesMeta {
    my ( $Self, %Param ) = @_;

    return @{ $Self->{Backend}->FormIDGetAllFilesMeta(%Param) };
}

=head2 FormIDCleanUp()

Removed no longer needed temporary files.

Each file older than 1 day will be removed.

    $UploadCacheObject->FormIDCleanUp();

=cut

sub FormIDCleanUp {
    my ( $Self, %Param ) = @_;

    return $Self->{Backend}->FormIDCleanUp(%Param);
}

1;
