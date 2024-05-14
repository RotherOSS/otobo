#!/usr/bin/env perl
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

use strict;
use warnings;
use v5.24;
use utf8;

# use ../ and ../Kernel/cpan-lib as lib location
use FindBin qw($RealBin);    ## no perlimports, not sure why perlimports wants $Dir
use lib "$RealBin/..";
use lib "$RealBin/../Kernel/cpan-lib";

# core modules
use Getopt::Long qw(GetOptions);
use Cwd          qw(abs_path getcwd);

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager ();

# file scoped option variables
my (
    $CompressOption,
    $RemoveDays,
    $DatabaseHost,
    $DatabaseName,
    $DatabaseUser,
    $DatabasePw,
    $DatabaseType,
    $DryRun,
    $ExtraDumpOptions,
);
my $MaxAllowedPacket = '64M';          # 64 Megabytes is fine as the default, as that is already required on the server side
my $BackupDir        = getcwd();
my $BackupType       = 'fullbackup';

sub Main {

    # options that used only within Main()
    my (
        $HelpFlag,    # indicate whether the usage message should be printed
    );

    GetOptions(
        'help|h'                 => \$HelpFlag,
        'backup-dir|d=s'         => \$BackupDir,                       # current dir is the default
        'compress|c=s'           => \$CompressOption,
        'remove-old-backups|r=i' => \$RemoveDays,
        'backup-type|t=s'        => \$BackupType,
        'max-allowed-packet=s'   => \&HandleMaxAllowedPacketOption,    # check the units, set $MaxAllowedPacket
        'extra-dump-options=s'   => \$ExtraDumpOptions,                # e.g. "--column-statistics=0"
        'dry-run'                => \$DryRun,                          # only print the database dump commands
        'db-host=s'              => \$DatabaseHost,
        'db-name=s'              => \$DatabaseName,
        'db-user=s'              => \$DatabaseUser,
        'db-password=s'          => \$DatabasePw,
        'db-type=s'              => \$DatabaseType,
    ) || PrintHelpAndExit();

    PrintHelpAndExit() if $HelpFlag;

    return;
}

Main();

# TODO: put the script code into the sub main, so that it is assured that file scoped variables
#       don't interfere with the subs.
#       Better still: refactor the next 400 lines into smaller subs

# check backup dir
if ( !$BackupDir ) {
    say STDERR "ERROR: Need -d for backup directory";

    exit 1;
}
if ( !-d $BackupDir ) {
    say STDERR "ERROR: No such directory: $BackupDir";

    exit 1;
}

# check compress mode
my ( $Compress, $CompressCMD, $CompressEXT ) = ( 'z', 'gzip', 'gz' );
if ( $CompressOption && $CompressOption =~ m/bzip2/i ) {
    $Compress    = 'j';
    $CompressCMD = 'bzip2';
    $CompressEXT = 'bz2';
}

# check backup type
my ( $DBOnlyBackup, $FullBackup, $MigrateFromOTRSBackup ) = ( 0, 0, 0 );
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

    # --dry-run is only concerned about the database dumps
    if ($DryRun) {
        $DBOnlyBackup = 1;
    }
}

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-backup.pl',
    },
);

my $DatabaseDSN = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');                                          # for the database type
my $ArticleDir  = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::ArticleDataDir');

# database connection can be overridden on the command line
$DatabaseHost //= $Kernel::OM->Get('Kernel::Config')->Get('DatabaseHost');
$DatabaseName //= $Kernel::OM->Get('Kernel::Config')->Get('Database');
$DatabaseUser //= $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser');
$DatabasePw   //= $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw');
$DatabaseType //=
    $DatabaseDSN =~ m/:mysql/i  ? 'mysql' :
    $DatabaseDSN =~ m/:pg/i     ? 'postgresql' :
    $DatabaseDSN =~ m/:oracle/i ? 'oracle' :
    'mysql';
$DatabaseType = lc $DatabaseType;

# decrypt pw (if needed)
if ( $DatabasePw =~ m/^\{(.*)\}$/ ) {
    $DatabasePw = $Kernel::OM->Get('Kernel::System::DB')->_Decrypt($1);
}

# set up support for dumping a database
my $DBDumpCmd = '';
my @DBDumpOptions;
if ($ExtraDumpOptions) {
    push @DBDumpOptions, $ExtraDumpOptions;
}

if ( $DatabaseType eq 'mysql' ) {
    $DBDumpCmd = 'mysqldump';
    push @DBDumpOptions, '--no-tablespaces';
}
elsif ( $DatabaseType eq 'postgresql' ) {
    if ($MigrateFromOTRSBackup) {
        say STDERR "ERROR: '--backup-type migratefromotrs' is not yet supported for 'postgresql'.";

        exit(1);
    }

    $DBDumpCmd = 'pg_dump';
    if ( $DatabaseDSN !~ m/host=/i ) {
        $DatabaseHost = '';
    }
}
elsif ( $DatabaseType eq 'oracle' ) {
    if ( !$MigrateFromOTRSBackup ) {
        say STDERR "ERROR: Can't backup an Oracle database. Only '--backup-type migratefromotrs' is supported.";

        exit(1);
    }

    # $DBDumpCmd is not supported yet for 'oracle'
}
else {
    say STDERR "ERROR: Can't backup a $DatabaseType database as no database dump support is implemented!";

    exit(1);
}

# check needed system commands
{
    my @Cmds = grep {$_} ( 'tar', $DBDumpCmd );
    push @Cmds, $CompressCMD unless $BackupType eq 'migratefromotrs';

    for my $Cmd (@Cmds) {
        my $IsInstalled = 0;
        open my $In, '-|', "which $Cmd";    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
        while ( my $s = <$In> ) {
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

$BackupDir = abs_path($BackupDir);
chdir($Home);

# current time needed for the backup-dir and for removing old backups
my $SystemDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

# create directory name - this looks like 2013-09-09_22-19'
my $Directory = join '/',
    $BackupDir,
    $SystemDTObject->Format( Format => '%Y-%m-%d_%H-%M-%S' );
mkdir $Directory or die "ERROR: Can't create directory: $Directory: $!";    ## no critic qw(OTOBO::ProhibitLowPrecedenceOps)

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

    if ($MaxAllowedPacket) {
        push @DBDumpOptions, "--max-allowed-packet=$MaxAllowedPacket";
    }

    if ($MigrateFromOTRSBackup) {
        MySQLBackupForMigrateFromOTRS(
            Directory     => $Directory,
            DBDumpCmd     => $DBDumpCmd,
            DBDumpOptions => \@DBDumpOptions,
            DatabaseName  => $DatabaseName,
            DryRun        => $DryRun,
        );
    }
    else {
        say "Dumping $DatabaseType data to $Directory/DatabaseBackup.sql.$CompressEXT ... ";
        my $Command = qq{( $DBDumpCmd @DBDumpOptions $DatabaseName || touch $ErrorIndicationFileName ) | $CompressCMD > $Directory/DatabaseBackup.sql.$CompressEXT};

        # only print out the dump commands in a dry run
        if ($DryRun) {
            say $Command;

            exit 0;
        }

        if ( !system($Command) && !-f $ErrorIndicationFileName ) {
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
elsif ( $DatabaseType eq 'oracle' ) {
    if ($MigrateFromOTRSBackup) {
        OracleBackupForMigrateFromOTRS();
    }
}
elsif ( $DatabaseType eq 'postgresql' ) {
    print "Dump $DatabaseType data to $Directory/DatabaseBackup.sql ... ";

    if ($MigrateFromOTRSBackup) {
        say "Sorry, dumping for database migration is not yet supported for $DatabaseType";
    }
    else {
        # set password via environment variable if there is one
        if ($DatabasePw) {
            $ENV{PGPASSWORD} = $DatabasePw;    ## no critic qw(Variables::RequireLocalizedPunctuationVars)
        }

        if ($DatabaseHost) {
            $DatabaseHost = "-h $DatabaseHost";
        }

        my $Command
            = qq{( $DBDumpCmd $DatabaseHost -U $DatabaseUser $DatabaseName || touch $ErrorIndicationFileName ) | $CompressCMD > $Directory/DatabaseBackup.sql.$CompressEXT};

        # only print out the dump commands in a dry run
        if ($DryRun) {
            say $Command;

            exit 0;
        }

        print "Dump $DatabaseType data to $Directory/DatabaseBackup.sql ... ";

        if ( !system($Command) && !-f $ErrorIndicationFileName ) {
            say 'done';
        }
        else {
            say 'failed';
            if ( -f $ErrorIndicationFileName ) {
                unlink $ErrorIndicationFileName;
            }
            RemoveIncompleteBackup($Directory);

            die 'Backup failed';
        }
    }
}
else {
    say STDERR "ERROR: the database type '$DatabaseType' is not supported.";

    exit 1;
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

# A special MySQL dump for migrating from OTRS 6 to OTOBO 10
# - skip tables that don't have to be migrated
# - change the character set to utf8mb4
# - remove COLLATE
# - shorten columns to 191 characters
# - rename tables
sub MySQLBackupForMigrateFromOTRS {
    my %Param = @_;

    # extract named params
    my $Directory     = $Param{Directory};
    my $DBDumpCmd     = $Param{DBDumpCmd};
    my @DBDumpOptions = $Param{DBDumpOptions}->@*;
    my $DatabaseName  = $Param{DatabaseName};
    my $DryRun        = $Param{DryRun};

    # print a time stamp at the end of the dump
    push @DBDumpOptions, qq{--dump-date};

    # for getting skipped and renamed tables
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');

    # add more mysqldump options for skipping tables that should not be migrated
    push @DBDumpOptions,
        map { ( '--ignore-table' => qq{'$DatabaseName.$_'} ) }
        $MigrationBaseObject->DBSkipTables;

    # output files
    my $PreprocessFile        = qq{$Directory/${DatabaseName}_pre.sql};
    my $SchemaDumpFile        = qq{$Directory/${DatabaseName}_schema.sql};
    my $AdaptedSchemaDumpFile = qq{$Directory/${DatabaseName}_schema_for_otobo.sql};
    my $DataDumpFile          = qq{$Directory/${DatabaseName}_data.sql};
    my $PostprocessFile       = qq{$Directory/${DatabaseName}_post.sql};

    # create the commands that will actually be executed
    # TODO: support for dumping elsewhere and only processing locally
    my @Commands = (
        qq{$DBDumpCmd @DBDumpOptions --no-data        --no-create-db -r $SchemaDumpFile $DatabaseName },
        qq{$DBDumpCmd @DBDumpOptions --no-create-info --no-create-db -r $DataDumpFile $DatabaseName },
    );

    # only print out the dump commands in a dry run
    if ($DryRun) {
        for my $Command (@Commands) {
            say $Command;
        }

        return;
    }

    say << "END_MESSAGE";
Execute the following SQL scripts in the given order:
    - $PreprocessFile
    - $AdaptedSchemaDumpFile
    - $DataDumpFile
    - $PostprocessFile
END_MESSAGE

    # print only the count avoids printing a password into a logfile
    my $Cnt = 0;
    for my $Command (@Commands) {
        $Cnt++;
        if ( !system($Command) ) {
            say "done command $Cnt";
        }
        else {
            say "failed executing command $Cnt";
            say $Command;
            die "Backup failed";
        }
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Shorten columns because of utf8mb4 and innodb max key length.
    # Change the character set to utf8mb4.
    # Remove COLLATE directives.
    {
        # find the changed columns per table
        my %IsShortened;
        for my $Short ( $MigrationBaseObject->DBShortenedColumns ) {
            $IsShortened{ $Short->{Table} } //= {};
            $IsShortened{ $Short->{Table} }->{ $Short->{Column} } = 1;
        }

        my @Lines = $MainObject->FileRead(
            Location => $SchemaDumpFile,
            Result   => 'ARRAY',
        )->@*;

        # now adapt the relevant lines
        # TODO: make this less nasty. Make it nicety.
        open my $Adapted, '>', $AdaptedSchemaDumpFile                      ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
            or die "Can't open $AdaptedSchemaDumpFile for writing: $!";    ## no critic qw(OTOBO::ProhibitLowPrecedenceOps)
        say $Adapted "-- adapted by $0";
        say $Adapted '';
        my $CurrentTable;
        LINE:
        for my $Line (@Lines) {

            # substitutions for changing the character set
            $Line =~ s/DEFAULT CHARSET=utf8/DEFAULT CHARSET=utf8mb4/;    # for CREATE TABLE
            $Line =~ s/CHARACTER SET .*?\s//;                            # for CREATE COLUMN
            $Line =~ s/utf8mb4mb4/utf8mb4/;                              # in case it already was utf8mb4
            $Line =~ s/utf8mb3mb4/utf8mb4/;                              # in case of some mixup
            $Line =~ s/utf8mb4mb3/utf8mb4/;                              # in case of some mixup

            # substitutions for removing COLLATE directives
            $Line =~ s/COLLATE\s+\w+/ /;                                 # for CREATE TABLE, remove customer specific collation
            $Line =~ s/COLLATE\s*=\s*\w+/ /;                             # for CREATE TABLE, remove customer specific collation

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
            next LINE unless $IsShortened{$CurrentTable};
            next LINE unless keys $IsShortened{$CurrentTable}->%*;

            # are we in a column line ?
            # e.g.: "  `name` varchar(200) COLLATE utf8_bin NOT NULL,"
            next LINE unless my ( $ColumnName, $ColumnLength ) = $Line =~ m/^ \s+ `(\w+)` \s+ varchar\( (\d+) \)/x;

            # does the column need to be shortened
            next LINE unless $IsShortened{$CurrentTable}->{$ColumnName};
            next LINE unless $ColumnLength > 191;

            # shorten
            # e.g.: "  `name` varchar(191) COLLATE utf8_bin NOT NULL,"
            $Line =~ s/varchar\(\d+\)/varchar(191)/;
        }
        continue {
            print $Adapted $Line;
        }
    }

    # create a SQL script for preprocessing
    {
        my @Lines = $MainObject->FileRead(
            Location => $SchemaDumpFile,
            Result   => 'ARRAY',
        )->@*;

        my @DropSQLs;

        LINE:
        for my $Line (@Lines) {

            next LINE unless $Line =~ m/^DROP TABLE /;

            push @DropSQLs, $Line;
        }

        my $Now       = $Kernel::OM->Create('Kernel::System::DateTime')->ToCTimeString;
        my $SQLScript = <<"END_SQL";
-- SQL script generated by $0 at $Now.

SET FOREIGN_KEY_CHECKS = 0;

 @DropSQLs

SET FOREIGN_KEY_CHECKS = 1;

END_SQL

        $MainObject->FileWrite(
            Location => $PreprocessFile,
            Content  => \$SQLScript,
        );
    }

    # create a SQL script for postprocessing the migrated database
    {
        # rename tables
        # foreign key relationsships are handled automatically
        # RENAME TABLE IF EXISTS is not available in all MySQL versions
        my %RenameTables = $MigrationBaseObject->DBRenameTables->%*;
        my @RenameSQLs;
        my $Cnt = 0;
        for my $SourceTable ( sort keys %RenameTables ) {
            $Cnt++;
            push @RenameSQLs, <<"END_SQL";
-- rename  ' $SourceTable` to `$RenameTables{$SourceTable}`
SELECT Count(*)
  INTO \@exists_$Cnt
  FROM information_schema.tables
    WHERE table_schema = DATABASE()
        AND table_name = '$SourceTable';

SET \@queryDrop_$Cnt = IF (
    \@exists_$Cnt > 0,
    'DROP TABLE IF EXISTS `$RenameTables{$SourceTable}`',
    'SELECT \\'$SourceTable does not exist. No need to drop $RenameTables{$SourceTable}\\' status'
);
SET \@queryRename_$Cnt = IF (
    \@exists_$Cnt > 0,
    'RENAME TABLE `$SourceTable` TO `$RenameTables{$SourceTable}`',
    'SELECT \\'$SourceTable does not exist. No need to rename $SourceTable\\' status'
);

PREPARE stmtDrop_$Cnt FROM \@queryDrop_$Cnt;
PREPARE stmtRename_$Cnt FROM \@queryRename_$Cnt;

EXECUTE stmtDrop_$Cnt;
EXECUTE stmtRename_$Cnt;

END_SQL
        }

        my $Now       = $Kernel::OM->Create('Kernel::System::DateTime')->ToCTimeString;
        my $SQLScript = <<"END_SQL";
-- SQL script generated by $0 at $Now.

SET FOREIGN_KEY_CHECKS = 0;

@RenameSQLs

SET FOREIGN_KEY_CHECKS = 1;

END_SQL

        $MainObject->FileWrite(
            Location => $PostprocessFile,
            Content  => \$SQLScript,
        );
    }

    return;
}

# a special MySQL dump for migrating from OTRS 6 to OTOBO 10
sub OracleBackupForMigrateFromOTRS {
    my %Param = @_;

    # extract named params
    #my $Directory     = $Param{Directory};
    #my $DBDumpCmd     = $Param{DBDumpCmd};
    #my @DBDumpOptions = $Param{DBDumpOptions}->@*;
    #my $DatabaseName  = $Param{DatabaseName};

    # for getting skipped and renamed tables
    my $MigrationBaseObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::Base');
    my $MainObject          = $Kernel::OM->Get('Kernel::System::Main');

    # output files
    my $PostprocessFile = qq{$Directory/${DatabaseName}_post.sql};

    say << "END_MESSAGE";
These instruction are preliminary.

Clear the user 'otobo':
  - DROP USER otobo CASCADE

Clone the schema 'otrs' into the schema 'otobo'. This can be done with DBA tools. Alternatively do:
  - mkdir /tmp/otrs_dump_dir     # on the database server
  - CREATE DIRECTORY OTRS_DUMP_DIR AS '/tmp/orts_dump_dir';   # sys as sysdba
  - GRANT READ, WRITE ON DIRECTORY OTRS_DUMP_DIR TO sys;      # sys as sysdba
  - expdp \"sys/SYS_PASSWORD@//127.0.0.1/SID as sysdba\"  schemas=otrs directory=OTRS_DUMP_DIR dumpfile=otrs.dmp logfile=expdp_otrs.log
  - impdp \"sys/SYS_PASSWORD@//127.0.0.1/SID as sysdba\" directory=OTRS_DUMP_DIR dumpfile=otrs.dmp logfile=impdpotobo.log  remap_schema=otrs:otobo
  - ALTER USER otobo IDENTIFIED BY [OTOBO_PASSWORD];

Adapt the schema otobo as the user otobo.
    - run $PostprocessFile
END_MESSAGE

    # create a SQL script for postprocessing the migrated database
    {
        # rename tables
        # foreign key relationsships are handled automatically
        # RENAME TABLE IF EXISTS is not available in all MySQL versions
        my %RenameTables = $MigrationBaseObject->DBRenameTables->%*;
        my @RenameSQLs;
        for my $SourceTable ( sort keys %RenameTables ) {
            push @RenameSQLs, <<"END_SQL";
-- rename  ' $SourceTable` to `$RenameTables{$SourceTable}`
RENAME $SourceTable TO $RenameTables{$SourceTable};

END_SQL
        }

        # truncate the tables that should not be migrated
        my @TruncateSQLs;
        for my $Table ( $MigrationBaseObject->DBSkipTables ) {
            push @TruncateSQLs, <<"END_SQL";
-- truncate  $Table
TRUNCATE TABLE $Table;

END_SQL
        }

        my $Now       = $Kernel::OM->Create('Kernel::System::DateTime')->ToCTimeString;
        my $SQLScript = <<"END_SQL";
-- SQL script generated by $0 at $Now.

@RenameSQLs
@TruncateSQLs

END_SQL

        $MainObject->FileWrite(
            Location => $PostprocessFile,
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

# Validate that the option max-allowed-packet is sane.
# The value must be one of these cases:
#   i.   an integer, indicating the size in bytes
#   ii.  an integer immediately followed by 'K', indicating the size in kilobytes
#   iii. an integer immediately followed by 'M', indicating the size in Megabytes
#   iv.  an integer immediately followed by 'G', indicating the size in Gigabytes
sub HandleMaxAllowedPacketOption {
    my ( $OptName, $OptValue ) = @_;

    # check the format
    if ( $OptValue !~ m/^\d+[KMG]?$/ ) {
        die "The value '$OptValue' is not allowed for $OptName. Please pass an integer or an integer followed by K, M, or G.";
    }

    $MaxAllowedPacket = $OptValue;

    return;
}

sub PrintHelpAndExit {
    print <<'END_HELP';
Back up an OTOBO system.

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
    otobo> scripts/backup.pl -t migratefromotrs --db-name otrs --db-host 127.0.0.1 --db-user otrs --db-password "secret_otrs_password"

    # in some special case extra parameters can be passed, note the required quotes
    otobo> scripts/backup.pl --max-allowed-packet 128M --extra-dump-options "--column-statistics=0"

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
 [--dry-run]                  - only print out the database dump command, implies '--backup-type dbonly'
 [--max-allowed-packet SIZE]  - add the option "--max-allowed-packet=SIZE" to mysqldump. The default setting is 64M.
 [--db-host]                  - default is the setting 'DatabaseHost' in the OTOBO config
 [--db-name]                  - default is the setting 'Database' in the OTOBO config
 [--db-user]                  - default is the setting 'DatabaseUser' in the OTOBO config
 [--db-password]              - default is the setting 'DatabasePw' in the OTOBO config
 [--db-type]                  - default is extracted from the setting 'DatabaseDSN' in the OTOBO config

Help:
Using -t fullbackup saves the database and the whole OTOBO home directory (except /var/tmp and cache directories).
Using -t nofullbackup saves only the database, /Kernel/Config* and /var directories.
With -t dbonly only the database will be saved.
With -t migratefromotrs only the OTRS database will be saved and prepared for migration.
For debugging database dumping pass --dry-run for only printing out the dump commands.

Output:
 Config.tar.gz          - Backup of /Kernel/Config* configuration files.
 Application.tar.gz     - Backup of application file system (in case of full backup).
 VarDir.tar.gz          - Backup of /var directory (in case of no full backup).
 DataDir.tar.gz         - Backup of article files.
 DatabaseBackup.sql.gz  - Database dump.

Troubleshooting:

Override the max allowed packet size:
When backing up a MySQL one might run into very large database fields. In this case the backup fails.
For making the backup succeed one can explicitly add the parameter --max-allowed-packet=<SIZE>.
The units K, M, and G are allowed, indicating kilobytes, Megabytes, and Gigabytes.
This setting will be passed on to the command mysqldump. The default setting is 64M.

Error when the table information_schema.COLUMN_STATISTICS is missing:
This error occures with some versions of mysqldump 8.0.x. The problem can be evaded
by passing the option --extra-dump-options="--column-statistics=0"

END_HELP

    exit 1;
}
