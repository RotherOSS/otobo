#!/usr/bin/env perl
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

use strict;
use warnings;
use v5.24;
use utf8;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

# core modules
use Getopt::Long qw(GetOptions);
use Cwd qw(getcwd abs_path);

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

# get options
my (
    $HelpFlag,
    $CompressOption,
    $RemoveDays,
    $MaxAllowedPacket,
    $OTRSHome,     # required for migratefromotrs
    $DatabaseHost,
    $DatabaseName,
    $DatabaseUser,
    $DatabasePw,
    $DatabaseType,
);
my $BackupDir  = getcwd();
my $BackupType = 'fullbackup';
GetOptions(
    'help|h'                 => \$HelpFlag,
    'backup-dir|d=s'         => \$BackupDir,
    'compress|c=s'           => \$CompressOption,
    'remove-old-backups|r=i' => \$RemoveDays,
    'backup-type|t=s'        => \$BackupType,
    'max-allowed-packet=i'   => \$MaxAllowedPacket, # no short option for that special case
    'db-host=s'              => \$DatabaseHost,
    'db-name=s'              => \$DatabaseName,
    'db-user=s'              => \$DatabaseUser,
    'db-password=s'          => \$DatabasePw,
    'db-type=s'              => \$DatabaseType,
) or PrintHelpAndExit();

PrintHelpAndExit() if $HelpFlag;

# check backup dir
if ( !$BackupDir ) {
    say STDERR "ERROR: Need -d for backup directory";

    exit 1;
}
if ( ! -d $BackupDir ) {
    say STDERR "ERROR: No such directory: $BackupDir";

    exit 1;
}

# check compress mode
my ($Compress, $CompressCMD, $CompressEXT) = ('z', 'gzip', 'gz');
if ( $CompressOption && $CompressOption =~ m/bzip2/i ) {
    $Compress    = 'j';
    $CompressCMD = 'bzip2';
    $CompressEXT = 'bz2';
}

# check backup type
my ($DBOnlyBackup, $FullBackup, $MigrateFromOTRSBackup) = (0, 0, 0);
{
    $BackupType //= '';
    $BackupType = lc $BackupType;
    if ( $BackupType eq 'dbonly' ) {
        $DBOnlyBackup = 1;
    }
    elsif ( $BackupType eq 'nofullbackup' ) {
        $FullBackup = 0;
    }
    elsif ( $BackupType eq 'fullbackup' ) {
        $FullBackup = 1;
    }
    elsif ( $BackupType eq 'migratefromotrs' ) {
        $MigrateFromOTRSBackup = 1;
        $DBOnlyBackup          = 1;
    }
    else {
        say STDERR "ERROR: please specify --backup-type.\nValid options are: fullbackup|nofullbackup|dbonly|migratefromotrs";

        exit 1;
    }
}

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-backup.pl',
    },
);

my $DatabaseDSN  = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN'); # for the database type
my $ArticleDir   = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::ArticleDataDir');

# database connection can be overridden on the command line
$DatabaseHost //= $Kernel::OM->Get('Kernel::Config')->Get('DatabaseHost');
$DatabaseName //= $Kernel::OM->Get('Kernel::Config')->Get('Database');
$DatabaseUser //= $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser');
$DatabasePw   //= $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw');
$DatabaseType //=
    $DatabaseDSN =~ m/:mysql/i ? 'mysql'      :
    $DatabaseDSN =~ m/:pg/i    ? 'postgresql' :
    'mysql';

# decrypt pw (if needed)
if ( $DatabasePw =~ m/^\{(.*)\}$/ ) {
    $DatabasePw = $Kernel::OM->Get('Kernel::System::DB')->_Decrypt($1);
}

# check db backup support
$DatabaseType = lc $DatabaseType;
my $DBDumpCmd = '';
my @DBDumpOptions;
if ( $DatabaseType eq 'mysql' ) {
    $DBDumpCmd = 'mysqldump';
    push @DBDumpOptions, '--no-tablespaces';
}
elsif ( $DatabaseType eq 'postgresql' ) {
    $DBDumpCmd = 'pg_dump';
    if ( $DatabaseDSN !~ m/host=/i ) {
        $DatabaseHost = '';
    }
}
else {
    say STDERR "ERROR: Can't backup, no database dump support!";

    exit(1);
}

# check needed system commands
{
    my @Cmds = ( 'cp', 'tar', 'sed', $DBDumpCmd );
    if ( $BackupType eq 'migratefromotrs' ) {
        push @Cmds, 'sed';
    }
    else {
        push @Cmds, $CompressCMD;
    }
    for my $Cmd ( @Cmds ) {
        my $IsInstalled = 0;
        open my $In, '-|', "which $Cmd";    ## no critic
        while (<$In>) {
            $IsInstalled = 1;
        }
        if ( !$IsInstalled ) {
            say STDERR "ERROR: Can't locate $Cmd!";

            exit 1;
        }
    }
}

# create new backup directory
my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

# append trailing slash to home directory, if it's missing
if ( $Home !~ m{\/\z} ) {
    $Home .= '/';
}

$BackupDir = abs_path( $BackupDir );
chdir($Home);

# current time needed for the backup-dir and for removing old backups
my $SystemDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

# create directory name - this looks like 2013-09-09_22-19'
my $Directory = join '/',
    $BackupDir,
    $SystemDTObject->Format( Format => '%Y-%m-%d_%H-%M' );

if ( !mkdir($Directory) ) {
    die "ERROR: Can't create directory: $Directory: $!";
}

# backup application
if ($DBOnlyBackup) {
    say "Backup of filesystem data disabled by parameter $BackupType ... ";
}
else {
    # backup Kernel/Config.pm
    print "Backup $Directory/Config.tar.$CompressEXT ... ";
    if ( !system("tar -c -$Compress -f $Directory/Config.tar.$CompressEXT Kernel/Config*") ) {
        say "done";
    }
    else {
        say "failed";
        RemoveIncompleteBackup($Directory);
        die "Backup failed";
    }

    if ($FullBackup) {
        print "Backup $Directory/Application.tar.$CompressEXT ... ";
        my $Excludes = "--exclude=var/tmp --exclude=js-cache --exclude=css-cache --exclude=.git";
        if ( !system("tar $Excludes -c -$Compress -f $Directory/Application.tar.$CompressEXT .") ) {
            say "done";
        }
        else {
            say "failed";
            RemoveIncompleteBackup($Directory);
            die "Backup failed";
        }
    }

    # backup vardir
    else {
        print "Backup $Directory/VarDir.tar.$CompressEXT ... ";
        if ( !system("tar -c -$Compress -f $Directory/VarDir.tar.$CompressEXT var/") ) {
            print "done\n";
        }
        else {
            print "failed\n";
            RemoveIncompleteBackup($Directory);
            die "Backup failed";
        }
    }

    # backup datadir
    if ( $ArticleDir !~ m/\A\Q$Home\E/ ) {
        print "Backup $Directory/DataDir.tar.$CompressEXT ... ";
        if ( !system("tar -c -$Compress -f $Directory/DataDir.tar.$CompressEXT $ArticleDir") ) {
            print "done\n";
        }
        else {
            print "failed\n";
            RemoveIncompleteBackup($Directory);
            die "Backup failed";
        }
    }
}

# backup database
my $ErrorIndicationFileName =
    $Kernel::OM->Get('Kernel::Config')->Get('Home')
    . '/var/tmp/'
    . $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString();
if ( $DatabaseType eq 'mysql' ) {
    print "Dump $DatabaseType data to $Directory/DatabaseBackup.sql.$CompressEXT ... ";

    if ($DatabasePw) {
        push @DBDumpOptions, "-p'$DatabasePw'";
    }

    if ( $MaxAllowedPacket ) {
        push @DBDumpOptions, "--max-allowed-packet=$MaxAllowedPacket";
    }

    if ( $MigrateFromOTRSBackup ) {

        # dump schema and data separately, no compression
        my @Commands = (
            qq{$DBDumpCmd -u $DatabaseUser @DBDumpOptions -h $DatabaseHost --databases $DatabaseName --no-data --dump-date -r $BackupDir/${DatabaseName}_schema.sql},
            qq{sed -i.bak -e 's/DEFAULT CHARACTER SET utf8/DEFAULT CHARACTER SET utf8mb4/' -e 's/DEFAULT CHARSET=utf8/DEFAULT CHARSET=utf8mb4/' $BackupDir/${DatabaseName}_schema.sql},
            qq{$DBDumpCmd -u $DatabaseUser @DBDumpOptions -h $DatabaseHost --databases $DatabaseName --no-create-info --no-create-db --dump-date -r $BackupDir/${DatabaseName}_data.sql},
        );

        # print only the count avoids printing a password into a logfile
        my $Cnt = 0;
        for my $Command ( @Commands ) {
            $Cnt++;
            if ( ! system( $Command ) ) {
                say "done command $Cnt";
            }
            else {
                say "done command $Cnt";
                die "Backup failed";
            }
        }
    }
    else {
        if (
            !system(
                "( $DBDumpCmd -u $DatabaseUser @DBDumpOptions -h $DatabaseHost $DatabaseName || touch $ErrorIndicationFileName ) | $CompressCMD > $Directory/DatabaseBackup.sql.$CompressEXT"
            )
            && !-f $ErrorIndicationFileName
            )
        {
            say 'done';
        }
        else {
            say 'failed';
            if ( -f $ErrorIndicationFileName ) {
                unlink $ErrorIndicationFileName;
            }
            RemoveIncompleteBackup($Directory);

            die "Backup failed";
        }
    }
}
else {
    print "Dump $DatabaseType data to $Directory/DatabaseBackup.sql ... ";

    # set password via environment variable if there is one
    if ($DatabasePw) {
        $ENV{PGPASSWORD} = $DatabasePw;    ## no critic
    }

    if ($DatabaseHost) {
        $DatabaseHost = "-h $DatabaseHost";
    }

    if (
        !system(
            "( $DBDumpCmd $DatabaseHost -U $DatabaseUser $DatabaseName || touch $ErrorIndicationFileName ) | $CompressCMD > $Directory/DatabaseBackup.sql.$CompressEXT"
        )
        && !-f $ErrorIndicationFileName
        )
    {
        say "done";
    }
    else {
        say "failed";
        if ( -f $ErrorIndicationFileName ) {
            unlink $ErrorIndicationFileName;
        }
        RemoveIncompleteBackup($Directory);
        die "Backup failed";
    }
}

# remove old backups only after everything worked well
if ( defined $RemoveDays ) {
    my %LeaveBackups;

    # we'll be substracting days to the current time
    # we don't want DST changes to affect our dates
    # if it is < 2:00 AM, add two hours so we're sure DST will not change our timestamp
    # to another day
    if ( $SystemDTObject->Get()->{Hour} < 2 ) {
        $SystemDTObject->Add( Hours => 2 );
    }

    for ( 0 .. $RemoveDays ) {

        # legacy, old directories could be in the format 2013-4-8
        my @LegacyDirFormats = (
            '%04d-%01d-%01d',
            '%04d-%02d-%01d',
            '%04d-%01d-%02d',
            '%04d-%02d-%02d',
        );

        my $SystemDTDetails = $SystemDTObject->Get();
        for my $LegacyFirFormat (@LegacyDirFormats) {
            my $Dir = sprintf(
                $LegacyFirFormat,
                $SystemDTDetails->{Year},
                $SystemDTDetails->{Month},
                $SystemDTDetails->{Day},
            );
            $LeaveBackups{$Dir} = 1;
        }

        # substract one day
        $SystemDTObject->Subtract( Days => 1 );
    }

    my @Directories = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $BackupDir,
        Filter    => '*',
    );

    DIRECTORY:
    for my $Directory (@Directories) {

        next DIRECTORY if !-d $Directory;

        for my $Data ( sort keys %LeaveBackups ) {
            next DIRECTORY if $Directory =~ m/$Data/;
        }

        {
            # remove files and directory
            print "deleting old backup in $Directory ... ";
            my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
                Directory => $Directory,
                Filter    => '*',
            );

            for my $File (@Files) {
                if ( -e $File ) {

                    #                    print "Notice: remove $File\n";
                    unlink $File;
                }
            }

            if ( rmdir($Directory) ) {
                say 'done';
            }
            else {
                die 'failed';
            }
        }
    }
}

# If error occurs this functions remove incomlete backup folder to avoid the impression
#   that the backup was ok (see http://bugs.otrs.org/show_bug.cgi?id=10665).
sub RemoveIncompleteBackup {

    # get parameters
    my $Directory = shift;

    # remove files and directory
    print STDERR "Deleting incomplete backup $Directory ... ";
    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $Directory,
        Filter    => '*',
    );
    for my $File (@Files) {
        if ( -e $File ) {
            unlink $File;
        }
    }
    if ( rmdir($Directory) ) {
        say STDERR "done";
    }
    else {
        say STDERR "failed";
    }

    return;
}

sub PrintHelpAndExit {
    print <<'END_HELP';

Backup an OTOBO system.

Usage:
 backup.pl -d /data_backup_dir [-c gzip|bzip2] [-r DAYS] [-t fullbackup|nofullbackup|dbonly]
 backup.pl --backup-dir /data_backup_dir [--compress gzip|bzip2] [--remove-old-backups DAYS] [--backup-type fullbackup|nofullbackup|dbonly|migratefromotrs]

Short options:
 [-h]                   - Display help for this command.
 -d                     - Directory where the backup files should be placed. Defauls to the current dir.
 [-c]                   - Select the compression method (gzip|bzip2). Defaults to gzip.
 [-r DAYS]              - Remove backups which are more than DAYS days old.
 [-t]                   - Specify which data will be saved (fullbackup|nofullbackup|dbonly|migratefromotrs). Default: fullbackup.

Long options:
 [--help]                     - same as -h
 --backup-dir                 - same as -d
 [--compress]                 - same as -c
 [--remove-old-backups DAYS]  - same as -r
 [--backup-type]              - same as -t
 [--max-allowed-packet SIZE]  - add the option "--max-allowed-packet=SIZE" to mysqldump
 [--db-host]                  - default taken from the current OTOBO config
 [--db-name]                  - default taken from the current OTOBO config
 [--db-user]                  - default taken from the current OTOBO config
 [--db-password]              - default taken from the current OTOBO config
 [--db-type]                  - default taken from the current OTOBO config

Help:
Using -t fullbackup saves the database and the whole OTOBO home directory (except /var/tmp and cache directories).
Using -t nofullbackup saves only the database, /Kernel/Config* and /var directories.
With -t dbonly only the database will be saved.
With -t migratefromotrs only the OTRS database will be saved and prepared for migration

Override the max allowed packet size:
When backing up a MySQL one might run into very large database fields. In this case the backup fails.
For making the backup succeed one can explicitly add the parameter --max-allowed-packet=<SIZE IN BYTES>.
This setting will be passed on to the command mysqldump.

Output:
 Config.tar.gz          - Backup of /Kernel/Config* configuration files.
 Application.tar.gz     - Backup of application file system (in case of full backup).
 VarDir.tar.gz          - Backup of /var directory (in case of no full backup).
 DataDir.tar.gz         - Backup of article files.
 DatabaseBackup.sql.gz  - Database dump.

END_HELP

    exit 1;
}
