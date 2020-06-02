# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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

package Kernel::System::MigrateFromOTRS::Base;    ## no critic

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use File::Basename;
use File::Copy;
use File::Path qw(make_path);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Package',
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::Language',
    'Kernel::System::FileTemp',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::Base - migration lib

=head1 DESCRIPTION

All migration functions.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{LanguageObject} = $Kernel::OM->Get('Kernel::Language');

    return $Self;
}

=head2 CleanLicenseHeader()

clean given file license header to OTOBO style

    $OTRSToOTOBOObject->CleanLicenseHeader(
        File         => '/opt/otobo/Test.pm',
        UserID        => 123,
    );

=cut

sub CleanLicenseHeader {
    my ( $Self, %Param ) = @_;

    my $FilePathAndName = $Param{File};
    my $NewContent;

    # Open file
    open my $FileHandle, "< $FilePathAndName" or print STDERR "Error: $!";

    if ( !$FileHandle ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "File $FilePathAndName is empty / could not be read.",
        );
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

        print STDERR "File extension for file $FilePathAndName is not active - please check if you need to add a new regexp.\n";

        close $FileHandle;
        return 1;
    }

    # check whether the file is already in otobo style
    my $NewStyle = 1;
    LINE:
    for my $OTOBOLine ( split( "\n", $Parse->{New}[0] ) ) {
        my $FileLine = <$FileHandle>;
        chomp( $FileLine );
        if ( $OTOBOLine && $OTOBOLine ne $FileLine ) {
            $NewStyle = 0;
            last LINE;
        }
    }
    close $FileHandle;

    if ( $NewStyle ) {
        print STDERR "License of $FilePathAndName seems to already be formatted in otobo style - ignoring.\n";
        return 1;
    }

    # reopen file to reset to first line
    open my $FileHandle, "< $FilePathAndName" or print STDERR "Error: $!";

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not replace license header of $FilePathAndName.",
        );
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

=head2 CleanLicenseHeaderInDir()

clean given directory to OTOBO style

    $OTRSToOTOBOObject->CleanLicenseHeaderInDir(
        Path         => '/opt/otobo/',
        Filter       => '*',
        Recursive    => 1
        UserID       => 1,
    );

=cut

sub CleanLicenseHeaderInDir {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Path Filter UserID)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$_ not defined!"
            );
            return;
        }
    }
    for (qw(Path Filter UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my @UncleanDirAndFileList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Param{Path},
        Filter    => $Param{Filter},
        Recursive => $Param{Recursive},
    );

    for my $File (@UncleanDirAndFileList) {

        $Self->CleanLicenseHeader(
            File          => $File,
            UserID        => 1,
        );
    }

    return 1;
}

=head2 CleanOTRSFileToOTOBOStyle()

clean given file to OTOBO style

    $OTRSToOTOBOObject->CleanOTRSFileToOTOBOStyle(
        FilePath         => '/opt/otobo/Test.pm',
        UserID           => 1,
    );

=cut

sub CleanOTRSFileToOTOBOStyle {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(File UserID)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$_ not defined!"
            );
            return;
        }
    }
    for (qw(File UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $FilePathAndName = $Param{File};
    my $Suffix = $Param{File};
    $Suffix =~ s/^.*\.//g;

    my($Filename, $Dirs, $SuffixNotWork) = fileparse($FilePathAndName);

    # Read parse content from _ChangeLicenseHeaderRules
    my @ParserRegEx = _ChangeFileInfo();
    my @ParserRegExLicence = _ChangeLicenseHeaderRules();

    my $NewContent;
    open my $FileHandle, "< $FilePathAndName"  or print STDERR "Error: $!";

    if ( !$FileHandle ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "File $FilePathAndName is empty / could not be read.",
        );
        close $FileHandle;
        return;
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

=head2 CleanOTRSFilesToOTOBOStyleInDir()

clean given directory to OTOBO style

    $OTRSToOTOBOObject->CleanOTRSFilesToOTOBOStyleInDir(
        Path         => '/opt/otobo/',
        Filter       => '*',
        Recursive    => 1
        UserID       => 1,
    );

=cut

sub CleanOTRSFilesToOTOBOStyleInDir {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Path Filter UserID)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$_ not defined!"
            );
            return;
        }
    }
    for (qw(Path Filter UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my @UncleanDirAndFileList = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Param{Path},
        Filter    => $Param{Filter},
        Recursive => $Param{Recursive},
    );

    for my $File (@UncleanDirAndFileList) {

        $Self->CleanOTRSFileToOTOBOStyle(
            File          => $File,
            UserID        => 1,
        );
    }
    return 1;
}

=head2 ChangePathFileName()

change the path and filenames from otrs to otobo

    my $OK = $OTRSToOTOBOObject->ChangePathFileName(
        File => "/opt/otrs/tmp/otrs/"
    );

    returns 0 | 1;

=cut

sub ChangePathFileName {
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
        make_path($NewFileDirname) or
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can\'t create directory $NewFileDirname: $!",
            );
    }
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'notice',
        Message  => "Move file $File to $NewFile, cause cleanpath option is given.",
    );

    move($File, $NewFile) or
        $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "The move operation failed: $!",
        );
    return 1;
}

=head2 HandleFile()

TODO: HandleFile

    my $Return = $OTRSToOTOBOObject->HandleFile(
        Target          => "/tmp/test.opm",
        File            => "/opt/otrs/var/tmp/",
        RwPath          => "/opt/otrs/var/tmp/",
        UncleanFileList => "/opt/otrs/var/tmp/",
    );

    returns 0 | 1

=cut

sub HandleFile {
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
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "Create directory: $DirectoryCurrent.",
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't create directory: $DirectoryCurrent: $!",
                );
            }
        }

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
        # print STDERR "Can't work with file $Param{File}.\n";
        return;
    }
    my $File = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location   => $RwPath,
        Content    => \$Content,
#        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',                                                    # optional - Local|Attachment|MD5
        Permission => '660',                                                      # unix file permissions
    );

    if ( !$File ) {
        # print STDERR "File $RwPath could not be written.\n";
        return;
    }
    else {
        push @$UncleanFileList, $RwPath;
    }
    return 1;
}

=head2 CopyOPMtoSOPMAndClean()

create from .opm file a new clean .sopm file

    my $ReturnPath = $OTRSToOTOBOObject->CopyOPMtoSOPMAndClean(
        Source        => "/tmp/test.opm",
        TmpDirectory        => "/opt/otrs/var/tmp/",
    );

    returns
    $ReturnPath = /opt/otrs/var/tmp/

=cut

sub CopyOPMtoSOPMAndClean {
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "File $SourcePath is empty / could not be read."
        );
        return ;
    }

    my $BaseName = basename($SourcePath);
    $BaseName =~ s/-\d.*\.opm$/.sopm/;

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => ".sopm File $SOPMFile could not be written."
        );
        return;
    }

    return $TmpDirectory;
}

=head2 ExtractOPMPackage()

get a file or dir from remote system, save to tmp dir, return Path.

    my $ReturnPath = $OTRSToOTOBOObject->ExtractOPMPackage(
        Source        => "/opt/otrs/",
        TmpDirectory        => "/opt/otrs/var/tmp/",
    );

    returns
    $ReturnPath = /opt/otrs/var/tmp/*

=cut

sub ExtractOPMPackage {
    my ( $Self, %Param ) = @_;

    my $SourcePath = $Param{Source};
    my $TmpDirectory = $Param{TmpDirectory};

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Export failed of package $SourcePath to tempdir $TmpDirectory."
        );
        return;
    } else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Files export of package $SourcePath to $TmpDirectory done."
        );
    }

    return $TmpDirectory;
}


=head2 CopyFileAndSaveAsTmp()

get a file or dir from remote system, save to tmp dir, return Path.

    my $ReturnPath = $OTRSToOTOBOObject->CopyFileAndSaveAsTmp(
        FQDN        => "192.68.0.1",
        Path        => "opt/otrs/",
        SSHUser     => "root",
        Password       => "Pw",
        ExcludeDirs  => ["var/article"] # Optional
        Filename    => "RELEASE",       # Optional, if only one file to copy
        UserID      => 1,
    );

    returns
    $ReturnPath = /opt/otrs/var/tmp/*

=cut

sub CopyFileAndSaveAsTmp {
    my ( $Self, %Param ) = @_;

    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

    # check needed stuff
    for my $Key (qw(FQDN Path SSHUser Password Port UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }
    }

    # Create TMPDir to save the copyied content
    my $TempDir = $FileTempObject->TempDir();

    my $RsyncExec = 'rsync ';

    # We need to copy a directory if Filename not given
    if ( !$Param{Filename} ) {
        # $RsyncExec .= '-ar -e "ssh -p ' . $Param{Port} . '" ' . $Param{SSHUser} . '@' . $Param{FQDN} . ':' . $Param{Path} . ' ' .$TempDir;
        $RsyncExec .= "-a -v --exclude=\".*\" --exclude=\"var/tmp\" --exclude=\"var/run\" -e \"sshpass -p $Param{Password} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $Param{Port}\" $Param{SSHUser}\@$Param{FQDN}:$Param{Path}/* $TempDir/"
    } else {
        # $RsyncExec .= '-a -e "ssh -p ' . $Param{Port} . '" ' . $Param{SSHUser} . '@' . $Param{FQDN} . ':' . $Param{Path} . '/' . $Param{Filename} . ' ' .$TempDir;
        $RsyncExec .= "-a -v -e \"sshpass -p $Param{Password} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $Param{Port}\" $Param{SSHUser}\@$Param{FQDN}:$Param{Path}/$Param{Filename} $TempDir/"

    }

    # Execute rsync
    if ( my $System = system($RsyncExec) == 0 ) {
        print STDERR "System1: $System Filename: $Param{Filename}\n";
        # If filename exists, we need to return path + filename
        if ($Param{Filename}) {
            return $TempDir.'/'.$Param{Filename};
        } else {
            return $TempDir;
        }
    } else {
        print STDERR "System2: $System \n";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't copy per rsync: $RsyncExec!"
        );
        return;
    }
}

=head2 RebuildConfig()

Refreshes the configuration to make sure that a ZZZAAuto.pm is present after the upgrade.

    $DBUpdateTo6Object->RebuildConfig(
        UnitTestMode      => 1,         # (optional) Prevent discarding all objects at the end.
        CleanUpIfPossible => 1,         # (optional) Removes leftover settings that are not contained in XML files,
                                        #   but only if all XML files for installed packages are present.
    );

=cut

sub RebuildConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $Verbose         = $Param{CommandlineOptions}->{Verbose} || 0;

    my $CleanUp = $Param{CleanUpIfPossible} ? 1 : 0;

    if ($CleanUp) {
        my $PackageObject = $Kernel::OM->Get('Kernel::System::Package');

        PACKAGE:
        for my $Package ( $PackageObject->RepositoryList() ) {

            # Only check the deployment state of the XML configuration files for performance reasons.
            #   Otherwise, this would be too slow on systems with many packages.
            $CleanUp = $PackageObject->_ConfigurationFilesDeployCheck(
                Name    => $Package->{Name}->{Content},
                Version => $Package->{Version}->{Content},
            );

            # Stop if any package has its configuration wrong deployed, configuration cleanup should not
            #   take place in the lines below. Otherwise modified setting values can be lost.
            if ( !$CleanUp ) {
                if ($Verbose) {
                    # print STDERR "\n    Configuration cleanup was not possible as packages are not correctly deployed!\n";
                }
                last PACKAGE;
            }
        }
    }

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            Force   => 1,
            UserID  => 1,
            CleanUp => $CleanUp,
        )
        )
    {
        # print STDERR "\n\n    Error:There was a problem writing XML to DB.\n";
        return;
    }

    # Rebuild ZZZAAuto.pm with current values
    if (
        !$SysConfigObject->ConfigurationDeploy(
            Comments     => $Param{Comments} || "Configuration Rebuild",
            AllSettings  => 1,
            Force        => 1,
            NoValidation => 1,
            UserID       => 1,
        )
        )
    {
        # print STDERR "\n\n    Error:There was a problem writing ZZZAAuto.pm.\n";
        return;
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    if ($Verbose) {
        # print STDERR "\n    If you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";
    }

    return 1 if $Param{UnitTestMode};

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=head2 CacheCleanup()

Clean up the cache.

    $DBUpdateTo6Object->CacheCleanup();

=cut

sub CacheCleanup {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        KeepTypes => ['OTRSMigration'],
    );

    return 1;
}

=head2 CacheCleanup()

Disable secure mode after copying data.

    $DBUpdateTo6Object->DisableSecureMode();

=cut

sub DisableSecureMode {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %Setting = $SysConfigObject->SettingGet(
        Name            => 'SecureMode',  # (required) Setting name
        NoCache         => 1,                # (optional) Do not create cache.
        UserID          => 1,                # Required only if OverriddenInXML is set.
    );

    if ( $Setting{EffectiveValue} eq '0' ) {
        return 1;
    }

    my $Success = $SysConfigObject->SettingsSet(
        UserID   => 1,                                      # (required) UserID
        Comments => 'Disable SecureMode for migration.',                   # (optional) Comment
        Settings => [                                       # (required) List of settings to update.
            {
                Name                   => 'SecureMode',  # (required)
                EffectiveValue         => '0',          # (optional)
            },
        ],
    );
    return $Success;
}

=head2 TableExists()

Checks if the given table exists in the database.

    my $Result = $DBUpdateTo6Object->TableExists(
        Table => 'ticket',
    );

Returns true if the table exists, otherwise false.

=cut

sub TableExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Table} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Table!",
        );
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my %TableNames = map { lc $_ => 1 } $DBObject->ListTables();

    return if !$TableNames{ lc $Param{Table} };

    return 1;
}

=head2 ColumnExists()

Checks if the given column exists in the given table.

    my $Result = $DBUpdateTo6Object->ColumnExists(
        Table  => 'ticket',
        Column =>  'id',
    );

Returns true if the column exists, otherwise false.

=cut

sub ColumnExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Table Column)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    $DBObject->Prepare(
        SQL   => "SELECT * FROM $Param{Table}",
        Limit => 1,
    );

    my %ColumnNames = map { lc $_ => 1 } $DBObject->GetColumnNames();

    return if !$ColumnNames{ lc $Param{Column} };

    return 1;
}

=head2 IndexExists()

Checks if the given index exists in the given table.

    my $Result = $DBUpdateTo6Object->IndexExists(
        Table => 'ticket',
        Index =>  'id',
    );

Returns true if the index exists, otherwise false.

=cut

sub IndexExists {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(Table Index)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $DBType = $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('Type');

    my ( $SQL, @Bind );

    if ( $DBType eq 'mysql' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM information_schema.statistics
            WHERE table_schema = DATABASE() AND table_name = ? AND index_name = ?
        ';
        push @Bind, \$Param{Table}, \$Param{Index};
    }
    elsif ( $DBType eq 'postgresql' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM pg_indexes
            WHERE indexname = ?
        ';
        push @Bind, \$Param{Index};
    }
    elsif ( $DBType eq 'oracle' ) {
        $SQL = '
            SELECT COUNT(*)
            FROM user_indexes
            WHERE index_name = ?
        ';
        push @Bind, \$Param{Index};
    }
    else {
        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => \@Bind,
        Limit => 1,
    );

    my @Result = $DBObject->FetchrowArray();

    return if !$Result[0];

    return 1;
}

=head2 GetTaskConfig()

Clean up the cache.

    $DBUpdateTo6Object->GetTaskConfig( Module => "TaskModuleName");

=cut

sub GetTaskConfig {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Module} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Module!',
        );
        return;
    }

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $File = $Home . '/Kernel::System/DBUpdateTo6/TaskConfig/' . $Param{Module} . '.yml';

    if ( !-e $File ) {
        $File .= '.dist';

        if ( !-e $File ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Couldn't find $File!",
            );
            return;
        }
    }

    my $FileRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Location => $File,
    );

    # Convert configuration to Perl data structure for easier handling.
    my $ConfigData = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => ${$FileRef} );

    return $ConfigData;
}

=head2 SettingUpdate()

Update an existing SysConfig Setting in a migration context. It will skip updating both read-only and already modified
settings by default.

    $DBUpdateTo6Object->SettingUpdate(
        Name                   => 'Setting::Name',           # (required) setting name
        IsValid                => 1,                         # (optional) 1 or 0, modified 0
        EffectiveValue         => $SettingEffectiveValue,    # (optional)
        UserModificationActive => 0,                         # (optional) 1 or 0, modified 0
        TargetUserID           => 2,                         # (optional) ID of the user for which the modified setting is meant,
                                                             #   leave it undef for global changes.
        NoValidation           => 1,                         # (optional) no value type validation.
        ContinueOnModified     => 0,                         # (optional) Do not skip already modified settings.
                                                             #   1 or 0, default 0
        Verbose                => 0,                         # (optional) 1 or 0, default 0
    );

=cut

sub SettingUpdate {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );

        return;
    }

    my $SettingName = $Param{Name};

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Try to get the default setting from OTRS 6 for the new setting name.
    my %CurrentSetting = $SysConfigObject->SettingGet(
        Name  => $SettingName,
        NoLog => 1,
    );

    # Skip settings which already have been modified in the meantime.
    if ( $CurrentSetting{ModifiedID} && !$Param{ContinueOnModified} ) {
        if ( $Param{Verbose} ) {
            # print STDERR "\n        - Setting '$Param{Name}' is already modified in the system skipping...\n\n";
        }
        return 1;
    }

    # Skip this setting if it is a read-only setting.
    if ( $CurrentSetting{IsReadonly} ) {
        if ( $Param{Verbose} ) {
            # print STDERR "\n        - Setting '$Param{Name}' is is set to read-only skipping...\n\n";
        }
        return 1;
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $SettingName,
        Force  => 1,
        UserID => 1,
    );

    my %Result = $SysConfigObject->SettingUpdate(
        %Param,
        Name              => $SettingName,
        IsValid           => $Param{IsValid} || 1,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    return $Result{Success};
}

sub PackageMigrateIgnorePackages {

    return (
        (
            {
                PackageName => 'ShowDynamicField',
                IgnoreType  => 'Ignore',
                Comment     => 'HideShow package integrated in OTOBO standard is in a better version. We only migrate the config and database data.',
            },
            {
                PackageName => 'TicketForms',
                IgnoreType  => 'Ignore',
                Comment     => 'TicketForms package is integrated in OTOBO standard in a better version. We only migrate the config and database data.',
            },
            {
                PackageName => 'RotherOSS-LongEscalationPerformanceBoost',
                IgnoreType  => 'Ignore',
                Comment     => 'RotherOSS-LongEscalationPerformanceBoost package is integrated in OTOBO standard in a better version.',
            },
            {
                PackageName => 'Znuny4OTRS-AdvancedDynamicFields',
                IgnoreType  => 'Ignore',
                Comment     => 'Znuny4OTRS-AdvancedDynamicFields package is integrated in OTOBO standard.',
            },
            {
                PackageName => 'Znuny4OTRS-AutoSelect',
                IgnoreType  => 'Ignore',
                Comment     => 'Znuny4OTRS-AutoSelect package is integrated in OTOBO standard in a newer version.',
            },
            {
                PackageName => 'Znuny4OTRS-EscalationSuspend',
                IgnoreType  => 'Ignore',
                Comment     => 'Znuny4OTRS-EscalationSuspend package is integrated in OTOBO standard in a newer version.',
            },
            {
                PackageName => 'Znuny4OTRS-ExternalURLJump',
                IgnoreType  => 'Ignore',
                Comment     => 'Znuny4OTRS-ExternalURLJump package is integrated in OTOBO standard.',
            },
            {
                PackageName => 'Znuny4OTRS-QuickClose',
                IgnoreType  => 'Ignore',
                Comment     => 'Znuny4OTRS-QuickClose package is integrated in OTOBO standard.',
            },
            {
                PackageName => 'Znuny4OTRS-AutoCheckbox',
                IgnoreType  => 'Uninstall',
                Comment     => 'This pZnuny4OTRS-EscalationSuspendackage is not needed for OTOBO, we uninstall it',
            },
        )
    );
}

sub DBSkipTables {
    return {
        communication_log => 1,
        communication_log_obj_lookup => 1,
        communication_log_object => 1,
        communication_log_object_entry => 1,
        cloud_service_config => 1,
        article_data_otrs_chat => 1,
        web_upload_cache => 1,
        sessions => 1,
    };
}

sub CopyFileListfromOTRSToOTOBO {
    return (
        '/Kernel/Config.pm',
        '/Kernel/Config.po',
        '/var/cron',
        '/var/article',
    );
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

sub IgnorePathList {
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
                FileTyp => 'All',
                Search  => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d OTRS AG, https:\/\/))"otrs"',
                Change  => '"otobo"'
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
            {
                FileTyp => 'opm',
                Search  => '<File Permission\=.*Location\=\"(.*)\"\s.*\">.*<\/File>',
                Change  => '<File Location="OTOBO_XXX" Permission="660" ></File>'
            },
        ),

    )
}
sub _ChangeLicenseHeaderRules {

    ## nofilter(TidyAll::Plugin::OTOBO::Common::CustomizationMarkers)

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
    "#!/usr/bin/env perl
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

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
