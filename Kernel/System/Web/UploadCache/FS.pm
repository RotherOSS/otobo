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

package Kernel::System::Web::UploadCache::FS;

use strict;
use warnings;

use File::Basename qw(basename);
use List::Util qw(sum);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{TempDir} = $Kernel::OM->Get('Kernel::Config')->Get('TempDir') . '/upload_cache';

    if ( !-d $Self->{TempDir} ) {
        mkdir $Self->{TempDir};
    }

    return $Self;
}

sub FormIDRemove {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need FormID!'
        );
        return;
    }

    return if !$Self->_FormIDValidate( $Param{FormID} );

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return 1;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => "*",
    );

    my @Data;
    for my $File (@List) {
        $MainObject->FileDelete(
            Location => $File,
        );
    }

    if ( !rmdir($Directory) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't remove: $Directory: $!!",
        );
    }

    return 1;
}

sub FormIDAddFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID Filename ContentType)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    return if !$Self->_FormIDValidate( $Param{FormID} );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Filename = basename( $Param{Filename} );

    # perform file size check
    {
        my $WebMaxFileUpload = $ConfigObject->Get('WebMaxFileUpload');

        # get file size
        my $Filesize = bytes::length( $Param{Content} );

        # get size of already uploaded file
        my $Data = $Self->FormIDGetAllFilesMeta(
            FormID => $Param{FormID},
        );

        # calculate space used within this form
        my $SpaceTaken = ( sum( map { $_->{Filesize} } $Data->@* ) ) // 0;

        if ( ( $SpaceTaken + $Filesize ) > $WebMaxFileUpload ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Upload of file $Param{Filename} exceeds WebMaxFileUpload limit!"
            );
            return;
        }
    }

    $Param{Content} = '' if !defined( $Param{Content} );

    # create content id
    my $ContentID   = $Param{ContentID};
    my $Disposition = $Param{Disposition} || '';
    if ( !$ContentID && lc $Disposition eq 'inline' ) {

        my $Random = rand 999999;
        my $FQDN   = $ConfigObject->Get('FQDN');

        $ContentID = "$Disposition$Random.$Param{FormID}\@$FQDN";
    }

    # create cache subdirectory if not exist
    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};
    if ( !-d $Directory ) {

        # Create directory. This could fail if another process creates the
        #   same directory, so don't use the return value.
        File::Path::mkpath( $Directory, 0, 0770 );    ## no critic qw(ValuesAndExpressions::ProhibitLeadingZeros)

        if ( !-d $Directory ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create directory '$Directory': $!",
            );
            return;
        }
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # files must readable for creator
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Filename",
        Content    => \$Param{Content},
        Mode       => 'binmode',
        Permission => '640',
        NoReplace  => 1,
    );
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Filename.ContentType",
        Content    => \$Param{ContentType},
        Mode       => 'binmode',
        Permission => '640',
        NoReplace  => 1,
    );
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Filename.ContentID",
        Content    => \$ContentID,
        Mode       => 'binmode',
        Permission => '640',
        NoReplace  => 1,
    );
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Filename.Disposition",
        Content    => \$Disposition,
        Mode       => 'binmode',
        Permission => '644',
        NoReplace  => 1,
    );
    return 1;
}

sub FormIDRemoveFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID FileID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    return if !$Self->_FormIDValidate( $Param{FormID} );

    my @Index = @{ $Self->FormIDGetAllFilesMeta(%Param) };

    # finish if files have been already removed by other process
    return if !@Index;

    my $ID   = $Param{FileID} - 1;
    my %File = %{ $Index[$ID] };

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return 1;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}",
        NoReplace => 1,
    );
    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}.ContentType",
        NoReplace => 1,
    );
    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}.ContentID",
        NoReplace => 1,
    );
    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}.Disposition",
        NoReplace => 1,
    );

    return 1;
}

sub FormIDGetAllFilesData {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need FormID!'
        );
        return;
    }

    my @Data;

    return \@Data if !$Self->_FormIDValidate( $Param{FormID} );

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return \@Data;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => "*",
    );

    my $Counter = 0;

    FILE:
    for my $File (@List) {

        # ignore meta files
        next FILE if $File =~ /\.ContentType$/;
        next FILE if $File =~ /\.ContentID$/;
        next FILE if $File =~ /\.Disposition$/;

        $Counter++;
        my $FileSize = -s $File;

        # human readable file size
        if ( defined $FileSize ) {

            # remove meta data in files
            if ( $FileSize > 30 ) {
                $FileSize = $FileSize - 30;
            }
        }
        my $Content = $MainObject->FileRead(
            Location => $File,
            Mode     => 'binmode',    # optional - binmode|utf8
        );
        next FILE if !$Content;

        my $ContentType = $MainObject->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentType;

        my $ContentID = $MainObject->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        my $Disposition = $MainObject->FileRead(
            Location => "$File.Disposition",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$Disposition;

        # strip filename
        $File =~ s/^.*\/(.+?)$/$1/;
        push(
            @Data,
            {
                Content     => ${$Content},
                ContentID   => ${$ContentID},
                ContentType => ${$ContentType},
                Filename    => $File,
                Filesize    => $FileSize,
                FileID      => $Counter,
                Disposition => ${$Disposition},
            },
        );
    }
    return \@Data;

}

sub FormIDGetAllFilesMeta {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need FormID!'
        );
        return;
    }

    my @Data;

    return \@Data if !$Self->_FormIDValidate( $Param{FormID} );

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return \@Data;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => "*",
    );

    my $Counter = 0;

    FILE:
    for my $File (@List) {

        # ignore meta files
        next FILE if $File =~ /\.ContentType$/;
        next FILE if $File =~ /\.ContentID$/;
        next FILE if $File =~ /\.Disposition$/;

        $Counter++;
        my $FileSize = -s $File;

        # human readable file size
        if ( defined $FileSize ) {

            # remove meta data in files
            if ( $FileSize > 30 ) {
                $FileSize = $FileSize - 30;
            }
        }

        my $ContentType = $MainObject->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentType;

        my $ContentID = $MainObject->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        my $Disposition = $MainObject->FileRead(
            Location => "$File.Disposition",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$Disposition;

        # strip filename
        $File =~ s/^.*\/(.+?)$/$1/;
        push(
            @Data,
            {
                ContentID   => ${$ContentID},
                ContentType => ${$ContentType},
                Filename    => $File,
                Filesize    => $FileSize,
                FileID      => $Counter,
                Disposition => ${$Disposition},
            },
        );
    }
    return \@Data;
}

sub FormIDCleanUp {
    my ( $Self, %Param ) = @_;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $RetentionTime = int( time() - 86400 );        # remove subdirs older than 24h
    my @List          = $MainObject->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => '*'
    );

    SUBDIR:
    for my $Subdir (@List) {
        my $SubdirTime = $Subdir;

        if ( $SubdirTime =~ /^.*\/\d+\..+$/ ) {
            $SubdirTime =~ s/^.*\/(\d+?)\..+$/$1/;
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  =>
                    "Won't delete upload cache directory $Subdir: timestamp in directory name not found! Please fix it manually.",
            );
            next SUBDIR;
        }

        if ( $RetentionTime > $SubdirTime ) {
            my @Sublist = $MainObject->DirectoryRead(
                Directory => $Subdir,
                Filter    => "*",
            );

            for my $File (@Sublist) {
                $MainObject->FileDelete(
                    Location => $File,
                );
            }

            if ( !rmdir($Subdir) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't remove: $Subdir: $!!",
                );
                next SUBDIR;
            }
        }
    }

    return 1;
}

sub _FormIDValidate {
    my ( $Self, $FormID ) = @_;

    return if !$FormID;

    if ( $FormID !~ m{^ \d+ \. \d+ \. \d+ $}xms ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Invalid FormID!',
        );
        return;
    }

    return 1;
}

1;
