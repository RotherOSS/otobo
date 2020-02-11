# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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


package Kernel::System::Console::Command::Dev::Tools::Migrate::OTRSToOTOBO;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);
use File::Basename;
use File::Copy;
use File::Path qw(make_path);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::FileTemp',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Create clean OTOBO source files from OTRS source code or an OTRS OPM package.');

    $Self->AddOption(
        Name => 'cleanpath',
        Description =>
            "Should we change the path and filename to OTOBO or otobo, if otrs or OTRS exists?",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'cleancontent',
        Description =>
            "Should we clean the file content from OTRS to OTOBO style?",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'cleanlicense',
        Description =>
            "Should we clean the file license information to OTOBO and Rother OSS?",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'cleanall',
        Description =>
            "Run all clean options together.",
        Required   => 0,
        HasValue   => 0,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'target',
        Description => "Specify the directory where the cleaned OTOBO code should be placed.",
        Required    => 1,
        HasValue   => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddArgument(
        Name => 'source',
        Description =>
            "Specify the directory containing the OTRS sources or the path to an OTRS based opm package.",
        Required   => 1,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->GetArgument('source');

    if ( !-r ( $Source ) ) {
        die "File $Source does not exist / cannot be read.\n";
    }

    my $TargetDirectory = $Self->GetOption('target');
    if ( !-d $TargetDirectory ) {
        die "Directory $TargetDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<green>Read unclean code or opm package...</green>\n");

    my $Source              = $Self->GetArgument('source');

    # If option cleanall is active, we execute all availible clean modules.
    my $CleanALL            = $Self->GetOption('cleanall');
    my $CleanPath           = $Self->GetOption('cleanpath')  || $CleanALL;
    my $CleanLicenseHeader  = $Self->GetOption('cleanlicense') || $CleanALL;
    my $CleanContent        = $Self->GetOption('cleancontent') || $CleanALL;
    my $TargetDirectory     = $Self->GetOption('target');
    my $SourceIsOPMOrDir    = 'Dir';
    my $TmpDirectory;

    if ( -f $Source ) {
        # Source is a file, hope opm (Need to check?)...
        $SourceIsOPMOrDir = 'OPM';

        # Create tempdir if opm package given
        $TmpDirectory =  $Kernel::OM->Get('Kernel::System::FileTemp')->TempDir();
    }

    # List of all dir and files
    my @UncleanDirAndFileList;

    # List of only files to edit in the next step
    my @UncleanFileList;

    # Ignore path list
    my @ParserIgnoreDirAndFile = _IgnorePathList();

    # We need to check if a opm package is given
    if ( $SourceIsOPMOrDir eq 'OPM' && -d $TargetDirectory) {

        # OPM package is given, so we need to extract it to a tmp dir
        my $SOPMCreate = $Self->_CopyOPMtoSOPMAndClean(
            Source     => $Source,
            TmpDirectory  => $TmpDirectory,
        );
        $Self->Print("<green>Copy .opm file to Package.sopm: Done.</green>\n");

        # Add $TempDir path to $Source, so we can go on
        $Source = $Self->_ExtractOPMPackage(
            Source     => $Source,
            TmpDirectory  => $TmpDirectory,
        );
        $Self->Print("<green>Extract OPM package: Done.</green>\n");
    }

    if ( $Source && -d $TargetDirectory) {
        @UncleanDirAndFileList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Source,
            Filter    => '*',
            Recursive => 1,
        );

        for my $File (@UncleanDirAndFileList) {

            # IF $Source we need to remove the tmppath
            my $RwPath = $File;
            if ( $SourceIsOPMOrDir eq 'OPM' ) {
                $RwPath =~ s/$TmpDirectory//g;
                $RwPath = $TargetDirectory . $RwPath;
            }
            # No TmpDirectory exists
            elsif ( $SourceIsOPMOrDir eq 'Dir' ) {
                $RwPath =~ s/$Source//g;
                $RwPath = $TargetDirectory . $RwPath;
            }

            # Write file to output directory
            $Self->_HandleFile(
                File     => $File,
                RwPath   => $RwPath,
                Target   => $TargetDirectory,
                UncleanFileList => \@UncleanFileList,
            );
            $Self->Print("<green>Write content to TargetDirectory $TargetDirectory: Done.</green>\n");
        }

        # Now we clean the existing files
        FILE:
        for my $File (@UncleanFileList) {

            # Check wich paths we should ignore
            my $ParseNot;
            TYPE:
            for my $Type ( @ParserIgnoreDirAndFile ) {
                if ( $File =~ $Type ) {
                    $ParseNot = 1;
                    last TYPE;
                }
            }

            if ( $ParseNot ) {
                $Self->Print("<yellow>Ignore directory setting for $File is active - please check if you need to add a new regexp.</yellow>\n");
                next FILE;

            }

            # Clean content of files if $CleanContent option is defined
            if ($CleanContent) {
                $Self->_ChangeFiles(
                    File     => $File,
                );
            }

            # Clean header and license in files
            if ($CleanLicenseHeader) {
                $Self->_ChangeLicenseHeader(
                    File     => $File,
                );
            }

            # If option cleanpath is given, clean path and filename
            if ($CleanPath) {
                $Self->_ChangePathFileName(
                    File     => $File,
                );
            }
        }
    }
    else {
        $Self->PrintError("No valid source or target dir given, exit!\n");
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Change file content in OTOBO style: Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub _ExtractOPMPackage {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Param{Source};
    my $TmpDirectory = $Param{TmpDirectory};

    $Self->Print("<yellow>Exporting package contents to $SourcePath...</yellow>\n");

    # Export package content
    my $FileString;
    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SourcePath,
#        Mode     => 'utf8',
    );
    $FileString = ${$ContentRef};

    my %Structure = $Kernel::OM->Get('Kernel::System::Package')->PackageParse(
        String => $FileString,
    );

    my $Success  = $Kernel::OM->Get('Kernel::System::Package')->PackageExport(
        String => $FileString,
        Home   => $TmpDirectory,
    );

    if (! $Success) {
        $Self->Print("<red>Export failed of package $SourcePath to tempdir $TmpDirectory.</red>\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Exported files of package $SourcePath to $TmpDirectory.</green>\n");

    return $TmpDirectory;
}

sub _CopyOPMtoSOPMAndClean {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Param{Source};
    my $TmpDirectory = $Param{TmpDirectory};

    # Export opm file to sopm file
    # Open open file again to get content
    my $ContentRefOPM = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SourcePath,
#        Mode     => 'utf8',        # optional - binmode|utf8
        #Type            => 'Local',   # optional - Local|Attachment|MD5
        #Result          => 'SCALAR',  # optional - SCALAR|ARRAY
    );

    if ( !$ContentRefOPM || ref $ContentRefOPM ne 'SCALAR' || !defined $$ContentRefOPM ) {
        $Self->PrintError("File $SourcePath is empty / could not be read.\n");
        return $Self->ExitCodeError();
    }

    my $BaseName = basename($SourcePath);
    $BaseName =~ s/\.opm$/.sopm/;

    # Write opm content to new sopm file
    my $SOPMFile = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Directory   => $TmpDirectory,
        Filename    => $BaseName,
        Content    => $ContentRefOPM,
#        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',                                                    # optional - Local|Attachment|MD5
        Permission => '660',                                                      # unix file permissions
    );

    if ( !$SOPMFile ) {
        $Self->PrintError("OPMS File $SOPMFile could not be written.\n");
        return $Self->ExitCodeError();
    }

    return $TmpDirectory;
}

sub _HandleFile {
    my ( $Self, %Param ) = @_;

    my $Target          = $Param{Target};
    my $DirOrFile       = $Param{File};
    my $RwPath          = $Param{RwPath};
    my $UncleanFileList = $Param{UncleanFileList};

    # First we need to check if we need to create a dir
    if ( -d $DirOrFile ) {

        my $Directory        = $RwPath;
        my @Directories      = split( /\//, $Directory );
        my $DirectoryCurrent = $Target;

        DIRECTORY:
        for my $Directory (@Directories) {

            $DirectoryCurrent = $RwPath;

            next DIRECTORY if -d $DirectoryCurrent;

            if ( mkdir $DirectoryCurrent ) {
                $Self->Print("<green>Notice: Create Directory $DirectoryCurrent!</green>\n");
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't create directory: $DirectoryCurrent: $!",
                );
            }
        }
        $Self->Print("<green>Done.</green>\n");

        return 1;
    }

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $Param{File},
    );

    if ( !ref $ContentRef ) {
        die "Can't open $Param{File}: $!";
    }

    my $Content = ${$ContentRef};

    # Perhaps we need to exclude files later?
#            $File =~ s{^.*/(.+?)\.tt}{$1}smx;

    # do translation

    if ( !$Content ) {
        $Self->PrintError("Can't work with file $Param{File}.\n");
        return $Self->ExitCodeError();
    }
    my $File = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $RwPath,
        Content    => \$Content,
#        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',                                                    # optional - Local|Attachment|MD5
        Permission => '660',                                                      # unix file permissions
    );

    if ( !$File ) {
        $Self->PrintError("File $RwPath could not be written.\n");
        return $Self->ExitCodeError();
    }
    else {
        push @$UncleanFileList, $RwPath;
    }
    return 1;
}

sub _ChangeLicenseHeader {
    my ( $Self, %Param ) = @_;

    my $FilePathAndName = $Param{File};
    my $NewContent;

    # Open file
    open my $FileHandle, "< $FilePathAndName" or print "Error: $!";

    if ( !$FileHandle ) {
        $Self->PrintError("File $FilePathAndName is empty / could not be read.\n");
        close $FileHandle;
        return 1;
    }
    # Read parse content from _ChangeLicenseHeaderRules
    my @Parser = $Self->_ChangeLicenseHeaderRules();

    my $Parse;
    TYPE:
    for my $Type ( @Parser ) {
        if ( $FilePathAndName =~ /$Type->{File}/ ) {
            $Parse = $Type;
            last TYPE;
        }
    }

    if (! $Parse ) {
        $Self->Print("<red>File extension for file $FilePathAndName is not active - please check if you need to add a new regexp.</red>\n");
        close $FileHandle;
        return 1;
    }

    my $Good = 1;
    my $ExtraLicenses;
    BLOCK:
    for my $Block ( @{ $Parse->{Old} } ) {
        if ( $Block->{while} ) {
            $_ = <$FileHandle>;
            until ( /$Block->{until}/ ) {
                if ( !$_ || !/$Block->{while}/ ) {
                    $Good = 0;
                    last BLOCK;
                }
                if ( $Block->{keep} && /$Block->{keep}/ ) {
                    $ExtraLicenses .= $_;
                }
                elsif ( $Block->{nkeep} && !/$Block->{nkeep}/ ) {
                    $ExtraLicenses .= $_;
                }

                $_ = <$FileHandle>;
            }
        }
        else {
            $_ = <$FileHandle>;
            if ( !$_ || !/$Block->{until}/ ) {
                $Good = 0;
                last BLOCK;
            }
        }
    }
    if ( !$Good ) {
        $Self->Print("<red>Could not replace license header of $FilePathAndName.</red>\n");
        close $FileHandle;
        return;
    }

    if ( $Parse->{New} ) {
        $NewContent = $Parse->{New}[0];
        if ( $ExtraLicenses ) {
            $NewContent .= $ExtraLicenses;
        }
        if ( $Parse->{New}[1] ) {
            $NewContent .= $Parse->{New}[1];
        }
    }
    while (<$FileHandle>) {
        $NewContent .= $_;
    }

    close $FileHandle;

    my $ContentRefNew = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $FilePathAndName,
        Content    => \$NewContent,
    #        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',                                                    # optional - Local|Attachment|MD5
        Permission => '660',                                                      # unix file permissions
    );

    return 1;
}

sub _ChangeFiles {
    my ( $Self, %Param ) = @_;

    my $FilePathAndName = $Param{File};
    my $Suffix = $Param{File};
    $Suffix =~ s/^.*\.//g;

    my($Filename, $Dirs, $SuffixNotWork) = fileparse($FilePathAndName);

    # Read parse content from _ChangeLicenseHeaderRules
    my @ParserRegEx = _ChangeFileInfo();
    my @ParserRegExLicence = _ChangeLicenseHeaderRules();

    my $NewContent;
    open my $FileHandle, "< $FilePathAndName" or print "Error: $!";

    if ( !$FileHandle ) {
        $Self->PrintError("File $FilePathAndName is empty / could not be read.\n");
        close $FileHandle;
        return 1;
    }

    while (my $Line = <$FileHandle>) {

        TYPE:
        for my $Type ( @ParserRegEx ) {
            # TODO: Check if work proper. Check if parse is build for this filetyp || All
            next TYPE if $Suffix !~ /$Type->{FileTyp}/ && $Type->{FileTyp} ne 'All';
            my $Search = $Type->{Search};
            my $Change = $Type->{Change};

            $Line =~ s/$Search/$Change/g;

            # If $1 exist, we need to check if we change OTOBO_XXX from ParserRegEx
            if (my $Tmp = $1) {
                $Line =~ s/OTOBO_XXX/$Tmp/g;
            }
        }
        $NewContent .= $Line;
    }

    close $FileHandle;

    my $ContentRefNew = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $FilePathAndName,
        Content    => \$NewContent,
#        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',                                                    # optional - Local|Attachment|MD5
        Permission => '660',                                                      # unix file permissions
    );
    return 1;
}

sub _ChangePathFileName {
    my ( $Self, %Param ) = @_;

    my $File = $Param{File};
    my $NewFile = $Param{File};
    my $Suffix = $Param{File};
    $Suffix =~ s/^.*\.//g;

    # Read parse content from _ChangeFilePath
    my @ParserRegEx = $Self->_ChangeFilePath();


    TYPE:
    for my $Type ( @ParserRegEx ) {
        # TODO: Check if work proper. Check if parse is build for this filetyp || All
        next TYPE if $Suffix !~ /$Type->{FileTyp}/ && $Type->{FileTyp} ne 'All';
        my $Search = $Type->{Search};
        my $Change = $Type->{Change};

        $NewFile =~ s/$Search/$Change/g;
    }

    if ($NewFile eq $File) {
        return 1;
    }

    # Check if new dir exists
    my $NewFileDirname  = dirname($NewFile);
    if (! -d $NewFileDirname ) {
#        mkdir $NewFileDirname or print "Can\'t create directory $NewFileDirname: $!\n";
        make_path($NewFileDirname);
    }
    $Self->Print("<green>Move file $File to $NewFile, cause cleanpath option is given.</green>\n");
    move($File, $NewFile) or print "The move operation failed: $!";;

    return 1;
}

sub _ChangeFilePath {

    return (
        (
            {
                FileTyp => 'All',
                Search  => 'OTRSBusiness',
                Change  => 'OTOBOCommunity',
            },
            {
                FileTyp => 'All',
                Search  => 'OTRS',
                Change  => 'OTOBO',
            },
            {
                FileTyp => 'All',
                Search  => 'otrs',
                Change  => 'otobo',
            },
            {
                FileTyp => 'All',
                Search  => 'ContactWithData',
                Change  => 'ContactWD',
            },
            {
                FileTyp => 'All',
                Search  => 'DynamicFieldDatabase',
                Change  => 'DynamicFieldDB',
            },
        ),
    )
}

sub _IgnorePathList {
    return (
        qr/^.+Kernel\/cpan-lib.+$/,
        qr/^.+var\/tmp\/CacheFileStorable.+$/,
        qr/^.+var\/httpd\/htdocs\/js\/thirdparty.+$/,
        qr/^.+var\/httpd\/htdocs\/skins\/Customer\/default\/css\/thirdparty.+$/,
        qr/^.+var\/httpd\/htdocs\/skins\/Agent\/default\/css\/thirdparty.+$/,
        qr/^.+var\/httpd\/htdocs\/js\/js-cache.+$/,
        qr/^.+var\/httpd\/htdocs\/common\/fonts.+$/,
        qr/^.+.pdf$/,
        qr/^.+.svg$/,
        qr/^.+.png$/,
        qr/^.+.gif$/,
        qr/^.+.psd$/,
        qr/^\.git$/,
    );
}

sub _ChangeFileInfo {

    return (
        (

            {
                FileTyp => 'All',
                Search  => 'ContactWithData',
                Change  => 'ContactWD'
            },
            {
                FileTyp => 'All',
                Search  => 'DynamicFieldDatabase',
                Change  => 'DynamicFieldDB'
            },
            {
                FileTyp => 'All',
                Search  => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d ))OTRS AG',
                Change  => 'Rother OSS GmbH'
            },
            {
                FileTyp => 'All',
                Search  => 'OTOBO Community Edition',
                Change  => 'OTOBO Community'
            },
            {
                FileTyp => 'All',
                Search  => 'OTRSBusiness',
                Change  => 'OTOBOCommunity'
            },
            {
                FileTyp => 'All',
                Search  => '((OTRS)) Community Edition',
                Change  => 'OTOBO'
            },
            {
                FileTyp => 'All',
                Search  => 'OTRS 6',
                Change  => 'OTOBO 10'
            },
            {
                FileTyp => 'All',
                Search  => 'OTRS Team',
                Change  => 'OTOBO Team'
            },
            {
                FileTyp => 'All',
                Search  => 'OTRS Group',
                Change  => 'Rother OSS GmbH'
            },
            {
                FileTyp => 'All',
                Search  => 'otrs-web',
                Change  => 'otobo-web'
            },
            {
                FileTyp => 'All',
                Search  => 'sales@otrs.com',
                Change  => 'hallo@otobo.de'
            },
            {
                FileTyp => 'All',
                Search  => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d OTRS AG, ))https:\/\/otrs\.com',
                Change  => 'https://otobo.de'
            },
            {
                FileTyp => 'All',
                Search  => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d ))OTRS',
                Change  => 'OTOBO',
            },
            {
                FileTyp => 'All',
                Search  => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d OTRS AG, https:\/\/))otrs',
                Change  => 'otobo'
            },
            {
                FileTyp => 'opm',
                Search  => '\<Framework.*\>6\..*\<\/Framework\>',
                Change  => '<Framework>10.0.x</Framework>'
            },
            {
                FileTyp => 'opm',
                Search  => '<File Location\=\"(.*)\"\s.*\s.*\">.*<\/File>',
                Change  => '<File Location="OTOBO_XXX" Permission="644" ></File>'
            },
        ),

    )
}
sub _ChangeLicenseHeaderRules {

    return (
        {
File => qr/\.pl$/,
Old => [
    {
        until => qr/^#!\/usr\/bin\/perl\s*$/,
    },
    {
        until => qr/^# --/,
    },
    {
        while => qr/^#.+/,
        nkeep  => qr/^#.+otobo/i,
        until => qr/^# --/,
    },
    {
        while => qr/^#( |$)/,
        until => qr/^# --/,
    },
],
New => [
    "#!/usr/bin/perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
",
"# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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
",
    ],
        },
        {
File => qr/\.(pm|tt|t)$/,
Old => [
    {
        until => qr/^# --/,
    },
    {
        while => qr/^#.+/,
        nkeep => qr/^#.+otobo/i,
        until => qr/^# --/,
    },
    {
        while => qr/^# /,
        until => qr/^# --/,
    },
],
New => [
    "# --
# OTOBO is a web-based ticketing system for service organisations.
# --
",
"# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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
",
    ],
        },
        {
File => qr/\.(js|js\.save)$/,
Old => [
    {
        until => qr/^\/\/ --/,
    },
    {
        while => qr/^\/\/ /,
        nkeep => qr/^\/\/.+otobo/i,
        until => qr/^\/\/ --/,
    },
    {
        while => qr/^\/\/ /,
        until => qr/^\/\/ --/,
    },
],
New => [
    "// --
// OTOBO is a web-based ticketing system for service organisations.
// --
",
"// Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
// --
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
",
    ],
        },
        {
File => qr/\.(css|css\.save)$/,
Old => [
    {
        until => qr/^\/\*/,
    },
    {
        while => qr/.?/,
        nkeep => qr/otobo/i,
        until => qr/^\s*$/,
    },
    {
        while => qr/.?/,
        until => qr/\*\//,
    },
],
New => [
    "/* OTOBO is a web-based ticketing system for service organisations.

",
"Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
*/
",
    ],
        },
    );
}

sub _ChangeXXXX {
    my ( $Self, %Param ) = @_;

    my $File = $Param{File};

    my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
#        Mode     => 'utf8',        # optional - binmode|utf8
        Type            => 'Local',   # optional - Local|Attachment|MD5
        Result          => 'SCALAR',  # optional - SCALAR|ARRAY
    );

    if ( !$ContentRef || ref $ContentRef ne 'SCALAR' ) {
        $Self->PrintError("File is empty / could not be read.\n");
        return $Self->ExitCodeError();
    }

    my $ContentString = \$ContentRef;

    my $ContentRefNew = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $File,
        Content    => \$ContentRef,
#        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',                                                    # optional - Local|Attachment|MD5
        Permission => '660',                                                      # unix file permissions
    );
    return $Self->ExitCodeOk();
}


# sub PostRun {
#     my ( $Self, %Param ) = @_;
#
#     # This will be called after Run() (even in case of exceptions). Perform any cleanups here.
#
#     return;
# }

1;
