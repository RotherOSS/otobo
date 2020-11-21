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

# use ../ and ../Kernel/cpan-lib as lib location
use FindBin qw($RealBin);
use lib "$RealBin/..";
use lib "$RealBin/../Kernel/cpan-lib";

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
    'backup-dir|d=s'         => \$BackupDir,        # current dir is the default
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
if ( ! $BackupDir ) {
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
$DatabaseType = lc $DatabaseType;

# decrypt pw (if needed)
if ( $DatabasePw =~ m/^\{(.*)\}$/ ) {
    $DatabasePw = $Kernel::OM->Get('Kernel::System::DB')->_Decrypt($1);
}

# check db backup support
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
    my @Cmds = ( 'tar', $DBDumpCmd );
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
mkdir $Directory or die "ERROR: Can't create directory: $Directory: $!";

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
    push @DBDumpOptions,
        '-u' => $DatabaseUser,
        '-h' => $DatabaseHost;
    if ($DatabasePw) {
        push @DBDumpOptions, qq{-p'$DatabasePw'};
    }

    if ( $MaxAllowedPacket ) {
        push @DBDumpOptions, "--max-allowed-packet=$MaxAllowedPacket";
    }

    if ( $MigrateFromOTRSBackup ) {

        BackupForMigrateFromOTRS(
            Directory     => $Directory,
            DBDumpCmd     => $DBDumpCmd,
            DBDumpOptions => \@DBDumpOptions,
            DatabaseName  => $DatabaseName,
        );
    }
    else {
        say "Dumping $DatabaseType data to $Directory/DatabaseBackup.sql.$CompressEXT ... ";
        if (
            !system(
                "( $DBDumpCmd @DBDumpOptions $DatabaseName || touch $ErrorIndicationFileName ) | $CompressCMD > $Directory/DatabaseBackup.sql.$CompressEXT"
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

        next DIRECTORY unless -d $Directory;

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

# a special MySQL dump for migrating from OTRS 6 to OTOBO 10
sub BackupForMigrateFromOTRS {
    my %Param = @_;

    # extract named params
    my $Directory     = $Param{Directory};
    my $DBDumpCmd     = $Param{DBDumpCmd};
    my @DBDumpOptions = $Param{DBDumpOptions}->@*;
    my $DatabaseName  = $Param{DatabaseName};

    # for getting skipped and renamed tables
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');
    my $MainObject          = $Kernel::OM->Get('Kernel::System::Main');

    # add more mysqldump options
    {
        # skipping tables
        my @SkippedTables = sort keys $MigrationBaseObject->DBSkipTables()->%*;
        push @DBDumpOptions,  map { ( '--ignore-table' => qq{'$DatabaseName.$_'} ) } @SkippedTables;

        # print a time stamp at the end of the dump
        push @DBDumpOptions, qq{--dump-date};
    }

    # output files
    my $SchemaDumpFile        = qq{$Directory/${DatabaseName}_schema.sql};
    my $DataDumpFile          = qq{$Directory/${DatabaseName}_data.sql};
    my $AdaptedSchemaDumpFile = qq{$Directory/${DatabaseName}_schema_varchar_191.sql};
    say "Dumping $DatabaseType schema to $SchemaDumpFile";
    say "Dumping $DatabaseType data to $DataDumpFile";

    # TODO: rename schema
    my $TargetDatabaseName    = $Kernel::OM->Get('Kernel::Config')->Get('Database');

    my @Substitutions = (
        q{-e 's/DEFAULT CHARACTER SET utf8/DEFAULT CHARACTER SET utf8mb4/'}, # for CREATE DATABASE
        q{-e 's/DEFAULT CHARACTER SET utf8/DEFAULT CHARACTER SET utf8mb4/'}, # for CREATE DATABASE
        q{-e 's/DEFAULT CHARSET=utf8/DEFAULT CHARSET=utf8mb4/'},             # for CREATE TABLE
        q{-e 's/utf8mb4mb4/utf8mb4/'},                                       # in case it already was utf8mb4
        q{-e 's/utf8mb3mb4/utf8mb4/'},                                       # in case of some mixup
        q{-e 's/utf8mb4mb3/utf8mb4/'},                                       # in case of some mixup
        q{-e 's/COLLATE=\\w\\+/ /'},                                         # for CREATE TABLE, remove customer specific collation
    );

    # create the commands that will actually be executed
    my @Commands = (
        qq{$DBDumpCmd @DBDumpOptions --databases $DatabaseName --no-data -r $SchemaDumpFile},
        qq{sed -i.bak @Substitutions $SchemaDumpFile},
        qq{$DBDumpCmd @DBDumpOptions --databases $DatabaseName --no-create-info --no-create-db -r $DataDumpFile},
    );

    # TODO: check key size

    # print only the count avoids printing a password into a logfile
    my $Cnt = 0;
    for my $Command ( @Commands ) {
        $Cnt++;
        if ( ! system( $Command ) ) {
            say "done command $Cnt";
        }
        else {
            say "failed executing command $Cnt";
            say $Command;
            die "Backup failed";
        }
    }

    # shorten columns because of utf8mb4 and innodb max key length
    {
        # find the changed columns per table
        my %IsShortened;
        for my $Short ( $MigrationBaseObject->DBShortenedColumns() ) {
             $IsShortened{ $Short->{Table} } //= {};
             $IsShortened{ $Short->{Table} }->{ $Short->{Column} } = 1;
        }

        my @Lines = $MainObject->FileRead(
            Location => $SchemaDumpFile,
            Result   => 'ARRAY',
        )->@*;

        # now adapt the relevant lines
        # TODO: make this less nasty. Make it nicety.
        open my $Adapted, '>', $AdaptedSchemaDumpFile
            or die "Can't open $AdaptedSchemaDumpFile for writing: $!";
        say $Adapted "-- adapted by $0";
        say $Adapted '';
        my $CurrentTable;
        LINE:
        for my $Line ( @Lines ) {

            # leaving a Table Create Block
            # e.g.: ") ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4  ;"
            if ( $Line =~ m/^\)/ ) {
                undef $CurrentTable;

                next LINE;
            }

            # entering a Table Create Block
            # e.g.: "CREATE TABLE `acl` ("
            if ( $Line =~ m/^CREATE TABLE `(\w+)` \(/ ) {
                $CurrentTable = $1;

                next LINE;
            }

            # check whether the current table has shortened columns
            next LINE unless $CurrentTable;
            next LINE unless $IsShortened{ $CurrentTable };
            next LINE unless keys $IsShortened{ $CurrentTable  }->%*;

            # are we in a column line ?
            # e.g.: "  `name` varchar(200) COLLATE utf8_bin NOT NULL,"
            next LINE unless my ($ColumnName, $ColumnLength ) = $Line =~ m/^ \s+ `(\w+)` \s+ varchar\( (\d+) \)/x;

            # does the column need to be shortened
            next LINE unless $IsShortened{ $CurrentTable }->{ $ColumnName };
            next LINE unless $ColumnLength > 191;

            # shorten
            # e.g.: "  `name` varchar(191) COLLATE utf8_bin NOT NULL,"
            $Line =~ s/varchar\(\d+\)/varchar(191)/;
        }
        continue {
            print $Adapted $Line;
        }


    }

    # create a script for fiddling with the generated database
    {
        my $SQLScript = <<"END_SQL";
-- SQL script generated by $0.
END_SQL

        # rename tables
        # foreign key relationsships are handled automatically
        my %RenameTables = $MigrationBaseObject->DBRenameTables()->%*;
        for my $SourceTable ( keys %RenameTables ) {
            $SQLScript .= <<"END_SQL";
RENAME TABLE `$TargetDatabaseName`.`$SourceTable` TO `$TargetDatabaseName`.`$RenameTables{$SourceTable}`;
END_SQL
        }

        $MainObject->FileWrite(
            Location => qq{$Directory/${DatabaseName}_fixup.sql},
            Content  => \$SQLScript,
        );
    }

    return;
}

# If error occurs this functions removes the incomplete backup folder to avoid the impression
#   that the backup was ok (see http://bugs.otrs.org/show_bug.cgi?id=10665).
sub RemoveIncompleteBackup {
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

    # print this help message
    otobo> cd /opt/otobo
    otobo> scripts/backup.pl --help

    # for regular backups, can also be used in a cron job
    otobo> cd /opt/otobo
    otobo> scripts/backup.pl -d /data_backup_dir [-c gzip|bzip2] [-r DAYS] [-t fullbackup|nofullbackup|dbonly]
    otobo> scripts/backup.pl --backup-dir /data_backup_dir [--compress gzip|bzip2] [--remove-old-backups DAYS] [--backup-type fullbackup|nofullbackup|dbonly|migratefromotrs]

    # backups for creating a dump for migrating an OTRS database OTOBO
    otobo> cd /opt/otobo
    otobo> scripts/backup.pl -t migratefromotrs --db-name otrs --db-host=127.0.0.1 --db-user otrs --db-password=secret_otrs_password

Short options:
 [-h]                   - Display help for this command.
 [-d]                   - Directory where the backup files should be placed. Defauls to the current dir.
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
