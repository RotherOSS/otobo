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

package Kernel::System::FileTemp;

use strict;
use warnings;

use File::Temp qw( tempfile tempdir );

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

Kernel::System::FileTemp - tmp files

=head1 DESCRIPTION

This module is managing temporary files and directories.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{FileHandleList} = [];

    return $Self;
}

=head2 TempFile()

returns an opened temporary file handle and its file name.
Please note that you need to close the file handle for other processes to write to it.

    my ($FileHandle, $Filename) = $TempObject->TempFile(
        Suffix => '.png',   # optional, defaults to '.tmp'
    );

=cut

sub TempFile {
    my ( $Self, %Param ) = @_;

    my $TempDir = $Kernel::OM->Get('Kernel::Config')->Get('TempDir');

    my ( $FH, $Filename ) = tempfile(
        DIR    => $TempDir,
        SUFFIX => $Param{Suffix} // '.tmp',
        UNLINK => 1,
    );

    # remember created tmp files and handles
    push @{ $Self->{FileHandleList} }, $FH;

    return ( $FH, $Filename );
}

=head2 TempDir()

returns a temp directory. The directory and its contents will be removed
if the FileTemp object goes out of scope.

=cut

sub TempDir {
    my $Self = shift;

    my $TempDir = $Kernel::OM->Get('Kernel::Config')->Get('TempDir');

    my $DirName = tempdir(
        DIR     => $TempDir,
        CLEANUP => 1,
    );

    return $DirName;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    # close all existing file handles
    FILEHANDLE:
    for my $FileHandle ( @{ $Self->{FileHandleList} } ) {
        next FILEHANDLE if !$FileHandle;
        close $FileHandle;
    }

    File::Temp::cleanup();

    return 1;
}

1;
