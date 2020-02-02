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

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::FileTemp',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Create clean OTOBO source files from OTRS source code or an OTRS OPM package.');
    $Self->AddOption(
        Name => 'source',
        Description =>
            "Specify the directory containing the OTRS sources.",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddOption(
        Name => 'opmfile',
        Description =>
            "Specify the path to an OTRS based opm package.",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );
    $Self->AddArgument(
        Name        => 'target-directory',
        Description => "Specify the directory where the cleaned OTOBO code should be placed.",
        Required    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Source = $Self->GetOption('source');
    my $OPMSource = $Self->GetOption('opmfile');

    if ( !-r ($Source || $OPMSource) ) {
        die "File $Source or $OPMSource does not exist / cannot be read.\n";
    }

    my $TargetDirectory = $Self->GetArgument('target-directory');
    if ( !-d $TargetDirectory ) {
        die "Directory $TargetDirectory does not exist.\n";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<green>Read unclean code or opm package...</green>\n");

    my $Source = $Self->GetOption('source');
    my $OPMSource = $Self->GetOption('opmfile');

    my $TargetDirectory = $Self->GetArgument('target-directory');

    # Create tempdir if opm package given
    my $TmpDirectory =  $Kernel::OM->Get('Kernel::System::FileTemp')->TempDir();

    # List of all dir and files
    my @UncleanDirAndFileList;

    # List of only files to edit in the next step
    my @UncleanFileList;

    # Ignore path list
    my @ParserIgnoreDirAndFile = _IgnorePathList();

    # We need to check if a opm package is given
    if ( -f $OPMSource && -d $TargetDirectory) {

        # OPM package is given, so we need to extract it to a tmp dir
        # Add $TempDir path to $Source, so we can go on
        $Source = $Self->_ExtractOPMPackage(
            OPMSource     => $OPMSource,
            TmpDirectory  => $TmpDirectory,
        );
        $Self->Print("<green>Extract OPM package: Done.</green>\n");

        my $SOPMCreate = $Self->_CopyOPMtoSOPMAndClean(
            OPMSource     => $OPMSource,
            TmpDirectory  => $TmpDirectory,
        );
        $Self->Print("<green>Copy .opm file to Package.som: Done.</green>\n");
    }

    if ( -d $Source && -d $TargetDirectory) {
        @UncleanDirAndFileList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
            Directory => $Source,
            Filter    => '*',
            Recursive => 1,
        );

        for my $File (@UncleanDirAndFileList) {

            # IF $OPMSource we need to remove the tmppath
            my $RwPath = $File;
            if ($OPMSource) {
                $RwPath =~ s/$TmpDirectory//g;
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

            # Clean opm file
            $Self->_ChangeFiles(
                File     => $File,
            );

            # Clean header and license in files
            $Self->_ChangeLicenseHeader(#
                File     => $File,
            );
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

    my $SourcePath = $Param{OPMSource};
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

    my $SourcePath = $Param{OPMSource};
    my $TmpDirectory = $Param{TmpDirectory};

    # Export opm file to sopm file
    # Open open file again to get content
    my $ContentRefOPM = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $SourcePath,
#        Mode     => 'utf8',        # optional - binmode|utf8
        Type            => 'Local',   # optional - Local|Attachment|MD5
        Result          => 'SCALAR',  # optional - SCALAR|ARRAY
        Result   => 'SCALAR',      # optional - SCALAR|ARRAY
    );

    if ( !$ContentRefOPM || ref $ContentRefOPM ne 'SCALAR' ) {
        $Self->PrintError("File $SourcePath is empty / could not be read.\n");
        return $Self->ExitCodeError();
    }

    my $FileString = ${$ContentRefOPM};
    my $BaseName = basename($SourcePath);

    # Write opm content to new sopm file
    # TODO: Don't know why I can't use $BaseName? Please help!
    my $SOPMFile = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Directory   => $TmpDirectory,
        Filename    => "Package.sopm",
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
        $Self->PrintError("Package build failed.\n");
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
        return $Self->ExitCodeError();
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
        return;
    }

    my $Good = 1;
    BLOCK:
    for my $Block ( @{ $Parse->{Old} } ) {
        if ( $Block->{w} ) {
            $_ = <$FileHandle>;
            until ( /$Block->{u}/ ) {
                if ( !$_ || !/$Block->{w}/ ) {
                    $Good = 0;
                    last BLOCK;
                }

                $_ = <$FileHandle>;
            }
        }
        else {
            $_ = <$FileHandle>;
            if ( !$_ || !/$Block->{u}/ ) {
                $Good = 0;
                last BLOCK;
            }
        }
    }
    if ( !$Good ) {
        $Self->Print("<red>Don't find regexp for typ $FilePathAndName (for license change).</red>\n");
        return;
    }
if ( $Parse->{New} ) {
    $NewContent .= $Parse->{New};
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

    # Check if parse is build for this filetyp || All
    if ( $Suffix eq ('png' || 'pdf') ) {
        return;
    }

    my($Filename, $Dirs, $SuffixNotWork) = fileparse($FilePathAndName);

    # Read parse content from _ChangeLicenseHeaderRules
    my @ParserRegEx = _ChangeFileInfo();
    my @ParserRegExLicence = _ChangeLicenseHeaderRules();

    my $NewContent;
    open my $FileHandle, "< $FilePathAndName" or print "Error: $!";

    if ( !$FileHandle ) {
        $Self->PrintError("File $FilePathAndName is empty / could not be read.\n");
        return $Self->ExitCodeError();
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
                Search  => 'OTRS AG',
                Change  => 'Rother OSS GmbH'
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
                Search  => 'https:\/\/otrs.com',
                Change  => 'https://otobo.de'
            },
            {
                FileTyp => 'All',
                Search  => 'OTRS',
                Change  => 'OTOBO',
            },
            {
                FileTyp => 'All',
                Search  => 'otrs',
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
        u => qr/^#!\/usr\/bin\/perl\s*$/,
    },
    {
        u => qr/^# --/,
    },
    {
        u => qr/^#.+(otrs|otobo)/i,
    },
    {
        w => qr/^#.+(otrs|otobo)/,
        u => qr/^# --/,
    },
    {
        w => qr/^#( |$)/,
        u => qr/^# --/,
    },
],
New => "#!/usr/bin/perl
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
",
        },
        {
File => qr/\.(pm|tt|t)$/,
Old => [
    {
        u => qr/^# --/,
    },
    {
        u => qr/^#.+(otrs|otobo)/i,
    },
    {
        w => qr/^#.+(otrs|otobo)/i,
        u => qr/^# --/,
    },
    {
        w => qr/^# /,
        u => qr/^# --/,
    },
],
New => "# --
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
",
        },
        {
File => qr/\.(js|js\.save)$/,
Old => [
    {
        u => qr/^\/\/ --/,
    },
    {
        u => qr/^\/\/.+(otrs|otobo)/i,
    },
    {
        w => qr/^\/\/.+(otrs|otobo)/i,
        u => qr/^\/\/ --/,
    },
    {
        w => qr/^\/\/ /,
        u => qr/^\/\/ --/,
    },
],
New => "/* OTOBO is a web-based ticketing system for service organisations.

Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/

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
        },
        {
File => qr/\.(css|css\.save)$/,
Old => [
    {
        u => qr/^\/\*/,
    },
#    {
#        u => qr/^.*(otrs|otobo)/i,
#    },
    {
        w => qr/^.+(otrs|otobo)/i,
        u => qr/^\*\//,
    },
#    {
#        w => qr/^\*\//,
#        u => qr/^\*\//,
#    },
],
New => "/* OTOBO is a web-based ticketing system for service organisations.

Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/

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
