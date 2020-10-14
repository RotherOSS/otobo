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
## nofilter(TidyAll::Plugin::OTOBO::Perl::Dumper)
## nofilter(TidyAll::Plugin::OTOBO::Common::CustomizationMarkers)

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules
use List::Util qw(first);
use Data::Dumper;
use File::Basename;
use File::Copy qw(move);
use File::Path qw(make_path);

# CPAN modules

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Package',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::Language',
    'Kernel::System::FileTemp',
    'Kernel::System::DB',
    'Kernel::System::SysConfig',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::Base - migration lib

=head1 SYNOPSIS

    # TODO

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
    my $Self = bless {}, $Type;

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
    open( my $FileHandle, '<:encoding(utf-8)', $FilePathAndName );

    if ( !$FileHandle ) {

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "File $FilePathAndName is empty / could not be read.",
            Priority => "error",
        );

        return 1;
    }

    # Read parse content from _ChangeLicenseHeaderRules
    my @Parser = $Self->_ChangeLicenseHeaderRules();
    my $Parse = first { $FilePathAndName =~ m/$_->{File}/ } @Parser;

    if ( !$Parse ) {

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String =>
                "File extension for file $FilePathAndName is not active - please check if you need to add a new regexp.",
            Priority => "info",
        );

        return 1;
    }

    my $Good = 1;
    my $ExtraLicenses;
    BLOCK:
    for my $Block ( @{ $Parse->{Old} } ) {
        if ( $Block->{while} ) {
            $_ = <$FileHandle>;
            until (/$Block->{until}/) {
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

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "Could not replace license header of $FilePathAndName.",
            Priority => "error",
        );

        return;
    }

    if ( $Parse->{New} ) {
        $NewContent = $Parse->{New}[0];
        if ($ExtraLicenses) {
            $NewContent .= $ExtraLicenses;
        }
        if ( $Parse->{New}[1] ) {
            $NewContent .= $Parse->{New}[1];
        }
    }
    while (<$FileHandle>) {
        $NewContent .= $_;
    }

    my $ContentRefNew = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $FilePathAndName,
        Content  => \$NewContent,

        #        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',    # optional - Local|Attachment|MD5
        Permission => '660',      # unix file permissions
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
            File   => $File,
            UserID => 1,
        );
    }

    return 1;
}

=head2 MigrateXMLConfig()

replace the XML element I<otrs_config> to I<otobo_config>.

    $OTRSToOTOBOObject->MigrateXMLConfig(
        File         => '/opt/otobo/Test.pm',
    );

=cut

sub MigrateXMLConfig {
    my $Self = shift;
    my %Param = @_;

    my $File = $Param{File};

    # handle only .xml files
    return 1 unless $File =~ m/\.xml/;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Read XML file
    my $ContentRef = $MainObject->FileRead(
        Location => $File,
        Mode     => 'utf8',
    );
    my $Content = $ContentRef->$*;

    # sanity checks, simply return when there is noting to do
    return 1 unless $Content =~ m{<otrs_config};
    return 1 unless $Content =~ m{<otrs_config.*?init="(.+?)"};
    return 1 unless $Content =~ m{<otrs_config.*?version="2.0"};

    # now the actual transformation
    $Content =~ s{^<otrs_config}{<otobo_config}gsmx;
    $Content =~ s{^</otrs_config}{</otobo_config}gsmx;

    # Save result in the original file
    my $SaveSuccess = $MainObject->FileWrite(
        Location => $File,
        Content  => \$Content,
        Mode     => 'utf8',
    );

    return $SaveSuccess;
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
    my $Suffix          = $Param{File};
    $Suffix =~ s/^.*\.//g;

    my ( $Filename, $Dirs, $SuffixNotWork ) = fileparse($FilePathAndName);

    # Read parse content from _ChangeLicenseHeaderRules
    my @ParserRegEx        = _ChangeFileInfo();
    my @ParserRegExLicence = _ChangeLicenseHeaderRules();

    my $NewContent;
    open( my $FileHandle, '<:encoding(utf-8)', $FilePathAndName );

    if ( !$FileHandle ) {

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "File $FilePathAndName is empty / could not be read.",
            Priority => 'error',
        );
        close $FileHandle;
        return;
    }

    while ( my $Line = <$FileHandle> ) {

        TYPE:
        for my $Type (@ParserRegEx) {

            # TODO: Check if work proper. Check if parse is build for this filetyp || All
            next TYPE if $Suffix !~ /$Type->{FileTyp}/ && $Type->{FileTyp} ne 'All';
            my $Search = $Type->{Search};
            my $Change = $Type->{Change};

            $Line =~ s/$Search/$Change/g;

            # If $1 exist, we need to check if we change OTOBO_XXX from ParserRegEx
            if ( my $Tmp = $1 ) {
                $Line =~ s/OTOBO_XXX/$Tmp/g;
            }
        }
        $NewContent .= $Line;
    }

    close $FileHandle;

    my $ContentRefNew = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $FilePathAndName,
        Content  => \$NewContent,

        #        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',    # optional - Local|Attachment|MD5
        Permission => '660',      # unix file permissions
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
            File   => $File,
            UserID => 1,
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

    my $File    = $Param{File};
    my $NewFile = $Param{File};
    my $Suffix  = $Param{File};
    $Suffix =~ s/^.*\.//g;

    # Read parse content from _ChangeFilePath
    my @ParserRegEx = $Self->_ChangeFilePath();

    TYPE:
    for my $Type (@ParserRegEx) {

        # TODO: Check if work proper. Check if parse is build for this filetyp || All
        next TYPE if $Suffix !~ /$Type->{FileTyp}/ && $Type->{FileTyp} ne 'All';
        my $Search = $Type->{Search};
        my $Change = $Type->{Change};

        $NewFile =~ s/$Search/$Change/g;
    }

    if ( $NewFile eq $File ) {
        return 1;
    }

    # Check if new directory exists
    my $NewFileDirname = dirname($NewFile);
    if ( !-d $NewFileDirname ) {
        make_path($NewFileDirname) ||

            # Log info to apache error log and OTOBO log (syslog or file)
            $Self->MigrationLog(
            String   => "Can\'t create directory $NewFileDirname: $!",
            Priority => 'error',
            );
    }

    # Log info to apache error log and OTOBO log (syslog or file)
    $Self->MigrationLog(
        String   => 'Move file ' . $File . 'to' . $NewFile . ', cause cleanpath option is given.',
        Priority => 'notice',
    );

    move( $File, $NewFile ) ||

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
        String   => "The move operation failed: $!",
        Priority => 'error',
        );
    return 1;
}

=head2 HandleFile()

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

    # First we need to check if we need to create a directory
    if ( -d $DirOrFile ) {

        my $Directory        = $RwPath;
        my @Directories      = split( /\//, $Directory );
        my $DirectoryCurrent = $Target;

        DIRECTORY:
        for my $Directory (@Directories) {

            $DirectoryCurrent = $RwPath;

            next DIRECTORY if -d $DirectoryCurrent;

            if ( mkdir $DirectoryCurrent ) {

                # Log info to apache error log and OTOBO log (syslog or file)
                $Self->MigrationLog(
                    String   => "Create directory: $DirectoryCurrent.",
                    Priority => "notice",
                );
            }
            else {
                # Log info to apache error log and OTOBO log (syslog or file)
                $Self->MigrationLog(
                    String   => "Can't create directory: $DirectoryCurrent: $!",
                    Priority => "error",
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
        return;
    }
    my $File = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Location => $RwPath,
        Content  => \$Content,

        #        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',    # optional - Local|Attachment|MD5
        Permission => '660',      # unix file permissions
    );

    if ( !$File ) {
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

    my $SourcePath   = $Param{Source};
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

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "File $SourcePath is empty / could not be read.",
            Priority => "error",
        );
        return;
    }

    my $BaseName = basename($SourcePath);
    $BaseName =~ s/-\d.*\.opm$/.sopm/;

    # Write opm content to new sopm file
    my $SOPMFile = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
        Directory => $TmpDirectory,
        Filename  => $BaseName,
        Content   => $ContentRefOPM,

        #        Mode       => 'utf8',                                                     # binmode|utf8
        Type       => 'Local',    # optional - Local|Attachment|MD5
        Permission => '660',      # unix file permissions
    );

    if ( !$SOPMFile ) {

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => ".sopm File $SOPMFile could not be written.",
            Priority => "error",
        );
        return;
    }

    return $TmpDirectory;
}

=head2 ExtractOPMPackage()

get a file or directory from remote system, save to tmp directory, return Path.

    my $ReturnPath = $OTRSToOTOBOObject->ExtractOPMPackage(
        Source        => "/opt/otrs/",
        TmpDirectory        => "/opt/otrs/var/tmp/",
    );

    returns
    $ReturnPath = /opt/otrs/var/tmp/*

=cut

sub ExtractOPMPackage {
    my ( $Self, %Param ) = @_;

    my $SourcePath   = $Param{Source};
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

    my $Success = $Kernel::OM->Get('Kernel::System::Package')->PackageExport(
        String => $FileString,
        Home   => $TmpDirectory,
    );

    if ( !$Success ) {

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "Export failed of package $SourcePath to tempdir $TmpDirectory.",
            Priority => "error",
        );
        return;
    }
    else {
        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "Files export of package $SourcePath to $TmpDirectory done.",
            Priority => "error",
        );
    }

    return $TmpDirectory;
}

=head2 CopyFileAndSaveAsTmp()

get a file or directory from remote system, save to tmp directory, return Path.

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

        $RsyncExec
            .= "-a -v --exclude=\".*\" --exclude=\"var/tmp\" --exclude=\"var/run\" -e \"sshpass -p $Param{Password} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $Param{Port}\" $Param{SSHUser}\@$Param{FQDN}:$Param{Path}/* $TempDir/";
    }
    else {

        $RsyncExec
            .= "-a -v -e \"sshpass -p $Param{Password} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $Param{Port}\" $Param{SSHUser}\@$Param{FQDN}:$Param{Path}/$Param{Filename} $TempDir/";

    }

    # Execute rsync
    if ( my $System = system($RsyncExec) == 0 ) {

        # If filename exists, we need to return path + filename
        if ( $Param{Filename} ) {
            return $TempDir . '/' . $Param{Filename};
        }
        else {
            return $TempDir;
        }
    }
    else {
        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "Can't copy per rsync: $RsyncExec!",
            Priority => "error",
        );
        return;
    }
}

=head2 RebuildConfig()

Refreshes the configuration to make sure that a ZZZAAuto.pm is present after the upgrade.

    $MigrateFromOTRSObject->RebuildConfig(
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

    # Convert XML files to entries in the database
    if (
        !$SysConfigObject->ConfigurationXML2DB(
            Force   => 1,
            UserID  => 1,
            CleanUp => $CleanUp,
        )
        )
    {
        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "There was a problem writing XML to DB.",
            Priority => "error",
        );
        return;
    }

    # Rebuild ZZZAAuto.pm with current values
    if (
        !$SysConfigObject->ConfigurationDeploy(
            Comments    => $Param{Comments} || "Configuration Rebuild",
            AllSettings => 1,
            Force       => 1,

            #            NoValidation => 1,
            UserID => 1,
        )
        )
    {
        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "There was a problem writing XML to DB.",
            Priority => "error",
        );
        return;
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    return 1 if $Param{UnitTestMode};

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=head2 CacheCleanup()

Clean up the cache.

    $MigrateFromOTRSObject->CacheCleanup();

=cut

sub CacheCleanup {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        KeepTypes => ['OTRSMigration'],
    );

    return 1;
}

=head2 DisableSecureMode()

Disable secure mode after copying data.

    $MigrateFromOTRSObject->DisableSecureMode();

=cut

sub DisableSecureMode {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %Setting = $SysConfigObject->SettingGet(
        Name => 'SecureMode',    # (required) Setting name

        #        NoCache         => 1,                # (optional) Do not create cache.
        #        UserID          => 1,                # Required only if OverriddenInXML is set.
    );

    return 1 if $Setting{EffectiveValue} eq '0';

    return $SysConfigObject->SettingsSet(
        UserID   => 1,                                      # (required) UserID
        Comments => 'Disable SecureMode for migration.',    # (optional) Comment
        Settings => [                                       # (required) List of settings to update.
            {
                Name           => 'SecureMode',             # (required)
                EffectiveValue => '0',                      # (optional)
            },
        ],
    );
}

=head2 TableExists()

Checks if the given table exists in the database.

    my $Result = $MigrateFromOTRSObject->TableExists(
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

    my $Result = $MigrateFromOTRSObject->ColumnExists(
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

    my $Result = $MigrateFromOTRSObject->IndexExists(
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

=head2 SettingUpdate()

Update an existing SysConfig Setting in a migration context. It will skip updating both read-only and already modified
settings by default.

    $MigrateFromOTRSObject->SettingUpdate(
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
        return 1;
    }

    # Skip this setting if it is a read-only setting.
    if ( $CurrentSetting{IsReadonly} ) {
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

=head2 MigrationLog()

MigrationLog the given string to OTOBO AND Apache Log for debugging migration.

    my $Result = $MigrateFromOTRSObject->MigrationLog(
        String => 'Logentry...',
        Priority => notice, error, info, debug (See LogObject Priority)
        HashRef   => \%HashRef,     Optional
        ArrayRef  => \@ArrayRef,    Optional
    );

Returns 1 if ok, otherwise false.

=cut

sub MigrationLog {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(String Priority)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Log to OTRS system log (syslog or file)
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => $Param{Priority},
        Message  => $Param{String},
    );

    # Log to apache error log
    print STDERR $Param{Priority} . ": " . $Param{String} . "\n";

    if ( IsHashRefWithData( $Param{HashRef} ) ) {
        print STDERR Dumper( $Param{HashRef} ) . "\n";
    }

    if ( IsArrayRefWithData( $Param{ArrayRef} ) ) {
        print STDERR Dumper( $Param{ArrayRef} ) . "\n";
    }

    print STDERR "\n\n";

    return 1;
}

sub PackageMigrateIgnorePackages {

    return (
        (
            {
                PackageName => 'ShowDynamicField',
                IgnoreType  => 'Ignore',
                Comment =>
                    'HideShow package is in OTOBO standard integrated in a better version. We only migrate the config and database data.',
            },
            {
                PackageName => 'TicketForms',
                IgnoreType  => 'Ignore',
                Comment =>
                    'TicketForms package is integrated in OTOBO standard in a better version. We only migrate the config and database data.',
            },
            {
                PackageName => 'RotherOSS-LongEscalationPerformanceBoost',
                IgnoreType  => 'Ignore',
                Comment =>
                    'RotherOSS-LongEscalationPerformanceBoost package is integrated in OTOBO standard in a better version.',
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
                Comment => 'Znuny4OTRS-EscalationSuspend package is integrated in OTOBO standard in a newer version.',
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
                Comment     => 'Znuny4OTRS-AutoCheckbox is not needed for OTOBO, we uninstall it',
            },
            {
                PackageName => 'OTRSBruteForceAttackProtection',
                IgnoreType  => 'Ignore',
                Comment     => 'OTRSBruteForceAttackProtection package is integrated in OTOBO standard in a newer version.',
            },
            {
                PackageName => 'OTRSEscalationSuspend',
                IgnoreType  => 'Ignore',
                Comment     => 'OTRSEscalationSuspend package is integrated in OTOBO standard in a newer version.',
            },
            {
                PackageName => 'OTRSDynamicFieldDatabase',
                IgnoreType  => 'Ignore',
                Comment     => 'OTRSDynamicFieldDatabase package is integrated in OTOBO standard in a newer version.',
            },
            {
                PackageName => 'OTRSDynamicFieldAttachment',
                IgnoreType  => 'Ignore',
                Comment     => 'OTRSDynamicFieldAttachment package is integrated in OTOBO standard in a newer version.',
            },
            {
                PackageName => 'OTRSDynamicFieldWebService',
                IgnoreType  => 'Ignore',
                Comment     => 'OTRSDynamicFieldWebService package is integrated in OTOBO standard in a newer version.',
            },
            {
                PackageName => 'OTRSSystemConfigurationHistory',
                IgnoreType  => 'Ignore',
                Comment     => 'OTRSSystemConfigurationHistory is not needed for OTOBO. We only migrate the config and database data.',
            },
        )
    );
}

sub ResetConfigOption {
    return {
        'Frontend::ToolBarModule###110-Ticket::AgentTicketQueue'      => 1,
        'Frontend::ToolBarModule###120-Ticket::AgentTicketStatus'     => 1,
        'Frontend::ToolBarModule###130-Ticket::AgentTicketEscalation' => 1,
        'Frontend::ToolBarModule###140-Ticket::AgentTicketPhone'      => 1,
        'Frontend::ToolBarModule###150-Ticket::AgentTicketEmail'      => 1,
        'Frontend::ToolBarModule###160-Ticket::AgentTicketProcess'    => 1,
        'Frontend::ToolBarModule###170-Ticket::TicketResponsible'     => 1,
        'Frontend::ToolBarModule###180-Ticket::TicketWatcher'         => 1,
        'Frontend::ToolBarModule###200-Ticket::AgentTicketService'    => '1',
        'Frontend::ToolBarModule###210-Ticket::TicketSearchProfile'   => '1',
        'Frontend::ToolBarModule###220-Ticket::TicketSearchFulltext'  => '1',
        'Frontend::ToolBarModule###230-CICSearchCustomerID'           => '1',
        'Frontend::ToolBarModule###240-CICSearchCustomerUser'         => '1',
        'Frontend::ToolBarModule###90-FAQ::AgentFAQAdd'               => '1',
        'AgentLogo'                                                   => '1',
        'AgentLoginLogo'                                              => '1',
        'AgentLogoCustom###default'                                   => '1',
        'AgentLogoCustom###highcontrast'                              => '1',
        'AgentLogoCustom###ivory'                                     => '1',
        'AgentLogoCustom###ivory-slim'                                => '1',
        'CustomerLogo'                                                => '1',
        'PDF::LogoFile'                                               => '1',
        'Package::RepositoryList'                                     => '1',
    };
}

sub DBSkipTables {

    # the tables must be lower case
    return {
        communication_log              => 1,
        communication_log_obj_lookup   => 1,
        communication_log_object       => 1,
        communication_log_object_entry => 1,
        cloud_service_config           => 1,
        package_repository             => 1,
        web_upload_cache               => 1,
        sessions                       => 1,
        scheduler_recurrent_task       => '1',
        process_id                     => '1',
        cloud_service_config           => '1',
        gi_debugger_entry              => '1',
        gi_debugger_entry_content      => '1',
    };
}

# OTOBO Table Name => OTRS Table Name
sub DBRenameTables {

    # the tables must be lower case
    return {
        groups                 => 'groups_table',
        article_data_otrs_chat => 'article_data_otobo_chat',
    };
}

sub CopyFileListfromOTRSToOTOBO {
    return (
        '/Kernel/Config.pm',
        '/Kernel/Config.po',
        '/var/httpd/htdocs/index.html',
        '/var/cron',
        '/var/article',
        '/var/stats',
    );
}

sub DoNotCleanFileList {
    return (
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
    );
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
                FileTyp => 'All',
                Search  => '\$Self-\>\{\'SecureMode\'\} \=  \'1\'\;',
                Change  => '$Self->{\'SecureMode\'} =  \'0\';'
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

    );
}

sub _ChangeLicenseHeaderRules {

    return (
        {
            File => qr/\.pl$/,
            Old  => [
                {
                    until => qr/^#!\/usr\/bin\/perl\s*$/,
                },
                {
                    until => qr/^# --/,
                },
                {
                    while => qr/^#.+/,
                    nkeep => qr/^#.+otobo/i,
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
            Old  => [
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
            Old  => [
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
            Old  => [
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

sub TaskSecurityCheck {
    return
        {
            Message => 'Check filesystem connect',
            Module  => 'OTOBOOTRSConnectionCheck',
        },
        {
            Message => 'Check database connect',
            Module  => 'OTOBOOTRSDBCheck',
        },
        {
            Message => 'Check framework version',
            Module  => 'OTOBOFrameworkVersionCheck',
        },
        {
            Message => 'Check required Perl modules',
            Module  => 'OTOBOPerlModulesCheck',
        },
        {
            Message => 'Check installed CPAN modules for known vulnerabilities',
            Module  => 'OTOBOOTRSPackageCheck',
        },
        {
            Message => 'Copy needed files from OTRS',
            Module  => 'OTOBOCopyFilesFromOTRS',
        },
        {
            Message => 'Migrate database to OTOBO',
            Module  => 'OTOBODatabaseMigrate',
        },
        {
            Message => 'Migrate notification tags in Ticket notifications',
            Module  => 'OTOBONotificationMigrate',
        },
        {
            Message => 'Migrate salutations to OTOBO style',
            Module  => 'OTOBOSalutationsMigrate',
        },
        {
            Message => 'Migrate signatures to OTOBO style',
            Module  => 'OTOBOSignaturesMigrate',
        },
        {
            Message => 'Migrate response templates to OTOBO style',
            Module  => 'OTOBOResponseTemplatesMigrate',
        },
        {
            Message => 'Migrate auto response templates to OTOBO style',
            Module  => 'OTOBOAutoResponseTemplatesMigrate',
        },
        {
            Message => 'Migrate webservices and add OTOBO ElasticSearch services.',
            Module  => 'OTOBOMigrateWebServiceConfiguration',
        },
        {
            Message => 'Clean up the cache',
            Module  => 'OTOBOCacheCleanup',
        },
        {
            Message => 'Migrate OTRS configuration',
            Module  => 'OTOBOMigrateConfigFromOTRS',
        },
        {
            Message => 'Migrate stats from OTRS to OTOBO',
            Module  => 'OTOBOStatsMigrate',
        },
        {
            Message => 'Clean up the cache',
            Module  => 'OTOBOCacheCleanup',
        },
        {
            Message => 'Deploy ACLs',
            Module  => 'OTOBOACLDeploy',
        },
        {
            Message => 'Deploy processes',
            Module  => 'OTOBOProcessDeploy',
        },
        {
            Message => 'Migrate postmaster filter from OTRS to OTOBO',
            Module  => 'OTOBOPostmasterFilterMigrate',
        };
}

1;
