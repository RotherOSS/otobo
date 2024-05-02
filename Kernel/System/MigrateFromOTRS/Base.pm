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

package Kernel::System::MigrateFromOTRS::Base;
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
use File::Basename qw(basename dirname fileparse);
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

    # Open file
    open my $FileHandle, '<:encoding(utf-8)', $FilePathAndName;    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
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
    my $Parse  = first { $FilePathAndName =~ m/$_->{File}/ } @Parser;

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

    my $NewContent;
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
    my ( $Self, %Param ) = @_;

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

    # sanity checks, simply return when there is nothing to do
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

    open my $FileHandle, '<:encoding(utf-8)', $FilePathAndName;    ## no critic qw(OTOBO::ProhibitOpen)
    if ( !$FileHandle ) {

        # Log info to apache error log and OTOBO log (syslog or file)
        $Self->MigrationLog(
            String   => "File $FilePathAndName is empty / could not be read.",
            Priority => 'error',
        );
        close $FileHandle;

        return;
    }

    # Read parse content from _ChangeLicenseHeaderRules
    my @Replacements = _ChangeFileInfo($FilePathAndName);

    my $NewContent;
    while ( my $Line = <$FileHandle> ) {

        REPLACEMENT:
        for my $Replacement (@Replacements) {

            my $Search = $Replacement->{Search};
            my $Change = $Replacement->{Change};

            $Line =~ s/$Search/$Change/g;

            # If $1 exist, we need to check if we change OTOBO_XXX from Replacements
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
    my @Replacements = $Self->_ChangeFilePath();

    REPLACEMENT:
    for my $Replacement (@Replacements) {

        # TODO: Check if work proper. Check if parse is build for this filetyp || All
        next REPLACEMENT if $Suffix !~ /$Replacement->{FileTyp}/ && $Replacement->{FileTyp} ne 'All';

        my $Search = $Replacement->{Search};
        my $Change = $Replacement->{Change};

        $NewFile =~ s/$Search/$Change/g;
    }

    # nothing to do when there are no changes
    return 1 if $NewFile eq $File;

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
        Password    => "Pw",
        ExcludeDirs => ["var/article"]    # Optional
        Filename    => "RELEASE",         # Optional, if only one file to copy
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

    return 1 if $TableNames{ lc $Param{Table} };
    return 0;
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

=head2 ReplaceSubstringsOfColumnValues()

Update the passed columns of all rows of the passed table. The substitutions are given as an
reference to an array of array references.

    my $Success = $MigrateFromOTRSObject->ReplaceSubstringsOfColumnValues(
        Table        => 'change_notification_message',
        Columns      => [ qw(text) ],
        Replacements =>
            [
                [ '<OTRS_', '<OTOBO_' ],
                [ '&lt;OTRS_', '&lt;OTOBO_' ]
            ],
    );

=cut

sub ReplaceSubstringsOfColumnValues {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Table Columns Replacements)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # the actual migration
    # The function REPLACE( string, find_string, replace_with_string) does a global replacement in the the first parameter
    # It exitst in MySQL, PostgreSQL, and Oracle
    my @SQLs     = map {"UPDATE $Param{Table} SET $_ = REPLACE( $_, ?, ? )"} $Param{Columns}->@*;
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    SQL:
    for my $SQL (@SQLs) {

        for my $Replacement ( $Param{Replacements}->@* ) {
            my ( $FindStr, $ReplacementStr ) = $Replacement->@*;

            # bail out at the first errro
            my $Success = $DBObject->Do(
                SQL  => $SQL,
                Bind => [ \$FindStr, \$ReplacementStr ],
            );

            return unless $Success;
        }
    }

    # all UPDATEs went well
    return 1;
}

=head2 SettingUpdate()

Update an existing SysConfig Setting in a migration context. It will skip updating both read-only and already modified
settings by default.

    my $Success = $MigrateFromOTRSObject->SettingUpdate(
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

# Note: looks like this method is currently unused
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
                Comment     =>
                    'HideShow package is in OTOBO standard integrated in a better version. We only migrate the config and database data.',
            },
            {
                PackageName => 'TicketForms',
                IgnoreType  => 'Ignore',
                Comment     =>
                    'TicketForms package is integrated in OTOBO standard in a better version. We only migrate the config and database data.',
            },
            {
                PackageName => 'RotherOSS-LongEscalationPerformanceBoost',
                IgnoreType  => 'Ignore',
                Comment     =>
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
        'Package::RepositoryRoot'                                     => '1',
    };
}

# The listed tables will be not  migrated.
# The table names must be in lower case.
# This list is also used for truncating tables in a SQL-script that is produced by scripts/backup.pl.
# Therefore is the order of the tables relevant. Truncating must be possible without violating
# foreign key constraints.
sub DBSkipTables {
    return qw(
        cloud_service_config
        communication_log_obj_lookup
        communication_log_object_entry
        communication_log_object
        communication_log
        gi_debugger_entry_content
        gi_debugger_entry
        mail_queue
        package_repository
        process_id
        scheduler_future_task
        scheduler_recurrent_task
        scheduler_task
        sessions
        system_data
        web_upload_cache
        access_token
        access_token_key
        acl_deployment
        article_customer_flag
        article_data_mime_send_error
        article_data_otrs_sms
        chat
        chat_channel
        chat_flag
        chat_invite
        chat_message
        chat_participant
        chat_video
        custom_page
        custom_page_content
        dtt
        dtt_attachment
        dtt_dynamic_field
        dtt_group
        dtt_service
        external_frontend_config
        notification_view
        queue_sms_template
        sc_category
        sc_item
        sc_item_content
        sc_item_content_category
        search_state
        sms_template
        ticket_customer_flag
        workflow_task_template
        workflow_template
    );
}

# OTRS table name => OTOBO table name
sub DBRenameTables {

    # the tables must be lower case
    return {
        article_data_otrs_chat => 'article_data_otobo_chat',
        groups                 => 'groups_table',              # OTRS 6.0, Znuny 6.0
        permission_groups      => 'groups_table',              # Znuny 6.1
        pm_sequence_flow       => 'pm_transition',                 # OTRS 7
        pm_sequence_flow_action       => 'pm_transition_action',   # OTRS 7
    };
}

# OTOBO VARCHAR attribute shortened to 191 chars, because of InnoDB max key length
# The values were determined by looking at the patches in scripts/database/otobo-schema.xml.
sub DBShortenedColumns {
    return
        {
            Table  => 'acl',
            Column => 'name'
        },
        {
            Table  => 'acl_sync',
            Column => 'acl_id'
        },
        {
            Table  => 'article_data_mime_send_error',
            Column => 'message_id'
        },
        {
            Table  => 'article_search_index',
            Column => 'article_key'
        },
        {
            Table  => 'article_sender_type',
            Column => 'name'
        },
        {
            Table  => 'auto_response',
            Column => 'name'
        },
        {
            Table  => 'auto_response_type',
            Column => 'name'
        },
        {
            Table  => 'calendar',
            Column => 'name'
        },
        {
            Table  => 'cloud_service_config',
            Column => 'name'
        },
        {
            Table  => 'communication_channel',
            Column => 'name'
        },
        {
            Table  => 'communication_log',
            Column => 'direction'
        },
        {
            Table  => 'communication_log',
            Column => 'status'
        },
        {
            Table  => 'communication_log',
            Column => 'transport'
        },
        {
            Table  => 'communication_log_obj_lookup',
            Column => 'object_type'
        },
        {
            Table  => 'communication_log_object',
            Column => 'status'
        },
        {
            Table  => 'communication_log_object_entry',
            Column => 'log_key'
        },
        {
            Table  => 'customer_company',
            Column => 'name'
        },
        {
            Table  => 'customer_preferences',
            Column => 'user_id'
        },
        {
            Table  => 'customer_user',
            Column => 'login'
        },
        {
            Table  => 'dynamic_field',
            Column => 'name'
        },
        {
            Table  => 'dynamic_field_obj_id_name',
            Column => 'object_name'
        },
        {
            Table  => 'follow_up_possible',
            Column => 'name'
        },
        {
            Table  => 'form_draft',
            Column => 'action'
        },
        {
            Table  => 'generic_agent_jobs',
            Column => 'job_name'
        },
        {
            Table  => 'gi_webservice_config',
            Column => 'name'
        },
        {
            Table  => 'groups_table',
            Column => 'name'
        },
        {
            Table  => 'notification_event',
            Column => 'name'
        },
        {
            Table  => 'notification_event_item',
            Column => 'event_key'
        },
        {
            Table  => 'notification_event_item',
            Column => 'event_value'
        },
        {
            Table  => 'postmaster_filter',
            Column => 'f_name'
        },
        {
            Table  => 'queue',
            Column => 'name'
        },
        {
            Table  => 'roles',
            Column => 'name'
        },
        {
            Table  => 'salutation',
            Column => 'name'
        },
        {
            Table  => 'search_profile',
            Column => 'login'
        },
        {
            Table  => 'search_profile',
            Column => 'profile_name'
        },
        {
            Table  => 'service',
            Column => 'name'
        },
        {
            Table  => 'service_customer_user',
            Column => 'customer_user_login'
        },
        {
            Table  => 'signature',
            Column => 'name'
        },
        {
            Table  => 'sla',
            Column => 'name'
        },
        {
            Table  => 'standard_attachment',
            Column => 'name'
        },
        {
            Table  => 'standard_template',
            Column => 'name'
        },
        {
            Table  => 'sysconfig_default',
            Column => 'name'
        },
        {
            Table  => 'sysconfig_default_version',
            Column => 'name'
        },
        {
            Table  => 'sysconfig_modified',
            Column => 'name'
        },
        {
            Table  => 'sysconfig_modified_version',
            Column => 'name'
        },
        {
            Table  => 'ticket',
            Column => 'customer_user_id'
        },
        {
            Table  => 'ticket',
            Column => 'title'
        },
        {
            Table  => 'ticket_history_type',
            Column => 'name'
        },
        {
            Table  => 'ticket_index',
            Column => 'queue'
        },
        {
            Table  => 'ticket_lock_type',
            Column => 'name'
        },
        {
            Table  => 'ticket_loop_protection',
            Column => 'sent_to'
        },
        {
            Table  => 'ticket_priority',
            Column => 'name'
        },
        {
            Table  => 'ticket_state',
            Column => 'name'
        },
        {
            Table  => 'ticket_state_type',
            Column => 'name'
        },
        {
            Table  => 'ticket_type',
            Column => 'name'
        },
        {
            Table  => 'users',
            Column => 'login'
        },
        {
            Table  => 'valid',
            Column => 'name'
        },
        {
            Table  => 'virtual_fs',
            Column => 'filename'
        },
        {
            Table  => 'virtual_fs_db',
            Column => 'filename'
        };
}

# DBDirectBlobColumns.
# Under MySQL binary data, often text in various encodings, is stored directly in LONGBLOB columns. This feature is called DirectBlob support.
# For other database the DirectBlob feature is not supported. Either because the database does not support it, or because the
# fitting data type is not used in the OTOBO schema. In these cases the data is base64 encoded.
# This is an issue during migration from PostgreSQL to MySQL, as columns that are BASE64 in PostgreSQL are not encoded in MySQL.
#
# Confusingly not all LONGBLOB columns are handled in this way. Some columns are LONGBLOB, even though it is known that the
# content is UTF-8 encoded text. It is not obvious how to distinguish these cases on the database level. Therefore an explicit list
# is provided.
sub DBDirectBlobColumns {
    return
        {
            Table  => 'article_data_mime_attachment',
            Column => 'content',
        },
        {
            Table  => 'article_data_mime_plain',
            Column => 'body',
        },
        {
            Table  => 'change_template',    # from the ITSM package
            Column => 'content',
        },
        {
            Table  => 'faq_attachment',     # from the FAQ package
            Column => 'content'
        },
        {
            Table  => 'form_draft',
            Column => 'content'
        },
        {
            Table  => 'mail_queue',
            Column => 'raw_message'
        },
        {
            Table  => 'package_repository',    # included here, even though package_repository is not migrated
            Column => 'content'
        },
        {
            Table  => 'standard_attachment',
            Column => 'content',
        },
        {
            Table  => 'virtual_fs_db',
            Column => 'content'
        },
        {
            Table  => 'web_upload_cache',
            Column => 'content',
        };
}

# list of files that need to be copied
sub CopyFileListfromOTRSToOTOBO {
    my @Files = (
        '/Kernel/Config.pm',
        '/Kernel/Config.po',               # what is that ?
        '/var/httpd/htdocs/index.html',    # why ?
        '/var/article',
        '/var/stats',
    );

    # Under Docker there is no var/cron
    if ( !$ENV{OTOBO_RUNS_UNDER_DOCKER} ) {
        push @Files, '/var/cron';
    }

    return @Files;
}

sub DoNotCleanFileList {
    return
        '/var/article',
        ;
}

sub _ChangeFilePath {

    return
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
        ;
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
    my ($FilePathAndName) = @_;

    # /opt/otrs/Kernel/Config.pm would result in '/opt/otrs/Kernel', 'Config', '.pm'
    my ( $Basename, $Dirs, $Suffix ) = fileparse( $FilePathAndName, qr/\.[^.]*/ );
    my $FileName = $Basename . $Suffix;

    # the actual replacement rules depend on the file
    my @Candidates = (
        {
            FileType => 'All',
            Search   => 'ContactWithData',
            Change   => 'ContactWD'
        },
        {
            FileType => 'All',
            Search   => 'DynamicFieldDatabase',
            Change   => 'DynamicFieldDB'
        },
        {
            FileType => 'All',
            Search   => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d ))OTRS AG',
            Change   => 'Rother OSS GmbH'
        },
        {
            FileType => 'All',
            Search   => 'OTOBO Community Edition',
            Change   => 'OTOBO Community'
        },
        {
            FileType => 'All',
            Search   => 'OTRSBusiness',
            Change   => 'OTOBOCommunity'
        },
        {
            FileType => 'All',
            Search   => '((OTRS)) Community Edition',
            Change   => 'OTOBO'
        },
        {
            FileType => 'All',
            Search   => 'OTRS 6',
            Change   => 'OTOBO 10'
        },
        {
            FileType => 'All',
            Search   => 'OTRS Team',
            Change   => 'OTOBO Team'
        },
        {
            FileType => 'All',
            Search   => 'OTRS Group',
            Change   => 'Rother OSS GmbH'
        },
        {
            FileType          => 'All',
            FileNameBlacklist => { 'Config.pm' => 1 },
            Search            => 'otrs-web',
            Change            => 'otobo-web'
        },
        {
            FileType => 'All',
            Search   => 'sales@otrs.com',
            Change   => 'hallo@otobo.de'
        },
        {
            FileType => 'All',
            Search   => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d OTRS AG, ))https:\/\/otrs\.com',
            Change   => 'https://otobo.de'
        },
        {
            FileType          => 'All',
            FileNameBlacklist => { 'Config.pm' => 1 },
            Search            => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d ))OTRS',
            Change            => 'OTOBO',
        },
        {
            FileType          => 'All',
            FileNameBlacklist => { 'Config.pm' => 1 },
            Search            => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d OTRS AG, https:\/\/))otrs',
            Change            => 'otobo'
        },
        {
            # TODO: remove this rule, as it already is included in the preceeding rule
            FileType          => 'All',
            FileNameBlacklist => { 'Config.pm' => 1 },
            Search            => '(?<!(Copyright \(\S\) \d\d\d\d-\d\d\d\d OTRS AG, https:\/\/))"otrs"',
            Change            => '"otobo"'
        },
        {
            # TODO: why is this included here
            FileType => 'All',
            Search   => '\$Self-\>\{\'SecureMode\'\} \=  \'1\'\;',
            Change   => '$Self->{\'SecureMode\'} =  \'0\';'
        },
        {
            FileType => 'opm',
            Search   => '\<Framework.*\>6\..*\<\/Framework\>',
            Change   => '<Framework>10.0.x</Framework>'
        },
        {
            FileType => 'opm',
            Search   => '<File Location\=\"(.*)\"\s.*\s.*\">.*<\/File>',
            Change   => '<File Location="OTOBO_XXX" Permission="644" ></File>'
        },
        {
            FileType => 'opm',
            Search   => '<File Permission\=.*Location\=\"(.*)\"\s.*\">.*<\/File>',
            Change   => '<File Location="OTOBO_XXX" Permission="660" ></File>'
        },
    );

    return grep
        {
            ( $Suffix =~ m/$_->{FileType}/ || $_->{FileType} eq 'All' )
            &&
            !( $_->{FileNameBlacklist} && $_->{FileNameBlacklist}->{$FileName} )
        }
        @Candidates;
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
                "# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
                "# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
                "// Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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
                "Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/

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
