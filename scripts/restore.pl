#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

use v5.24;
use strict;
use warnings;

# use ../ as lib location
use File::Basename qw(dirname);
use FindBin        qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

# core modules
use File::Spec  ();
use Getopt::Std qw(getopts);

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager ();

# get options
my %Opts;
getopts( 'b:d:ch', \%Opts );

if ( exists $Opts{h} ) {
    print <<'END_HELP';

Restore an OTOBO system from backup.

Usage:
 restore.pl [-c] -b /data_backup/<TIME>/ -d /opt/otobo/

Options:
 -b                     - Directory of the backup files.
 -d                     - Target OTOBO home directory.
 [-c]                   - Perform a pre-restore integrity check of bzip2/gzip files (increases restore time)
 [-h]                   - Display help for this command.

END_HELP

    exit 1;
}
if ( !$Opts{b} ) {
    say STDERR "ERROR: Need -b for backup directory";

    exit 1;
}
elsif ( !-d $Opts{b} ) {
    say STDERR "ERROR: No such directory: $Opts{b}";

    exit 1;
}
if ( !$Opts{d} ) {
    say STDERR "ERROR: Need -d for destination directory";

    exit 1;
}
elsif ( !-d $Opts{d} ) {
    say STDERR "ERROR: No such directory: $Opts{d}";

    exit 1;
}

my $DecompressCMD = '';
if ( -e File::Spec->catfile( $Opts{b}, 'DatabaseBackup.sql.bz2' ) ) {
    $DecompressCMD = 'bunzip2';
}
else {
    $DecompressCMD = 'gunzip';
}

# check needed programs
for my $CMD ( 'cp', 'tar', $DecompressCMD ) {
    my $IsInstalled = 0;
    open( my $Input, '-|', "which $CMD" );    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
    while ( my $s = <$Input> ) {
        $IsInstalled = 1;
    }
    if ( !$IsInstalled ) {
        say STDERR "ERROR: Can't locate $CMD!";

        exit 1;
    }
}

# restore config
chdir( $Opts{d} );

my $ConfigBackupGz  = File::Spec->catfile( $Opts{b}, 'Config.tar.gz' );
my $ConfigBackupBz2 = File::Spec->catfile( $Opts{b}, 'Config.tar.bz2' );
if ( -e $ConfigBackupGz ) {
    say "Restore $ConfigBackupGz ...";
    if ( system("tar -xzf $ConfigBackupGz") ) {    # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}
elsif ( -e $ConfigBackupBz2 ) {
    say "Restore $ConfigBackupBz2 ...";
    if ( system("tar -xjf $ConfigBackupBz2") ) {    # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTOBO-restore.pl',
    },
);

my $DatabaseHost = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseHost');
my $Database     = $Kernel::OM->Get('Kernel::Config')->Get('Database');
my $DatabaseUser = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser');
my $DatabasePw   = $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw');
my $DatabaseDSN  = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');

# decrypt pw (if needed)
if ( $DatabasePw =~ m/^\{(.*)\}$/ ) {
    $DatabasePw = $Kernel::OM->Get('Kernel::System::DB')->_Decrypt($1);
}

# check db backup support
my $DB     = '';
my $DBDump = '';
if ( $DatabaseDSN =~ m/:mysql/i ) {
    $DB     = 'MySQL';
    $DBDump = 'mysql';

    my $IsInstalled = 0;
    open( my $Input, '-|', "which $DBDump" );    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
    while ( my $s = <$Input> ) {
        $IsInstalled = 1;
    }
    if ( !$IsInstalled ) {
        say STDERR "ERROR: Can't locate $DBDump!";

        exit 1;
    }
}
elsif ( $DatabaseDSN =~ m/:pg/i ) {
    $DB     = 'PostgreSQL';
    $DBDump = 'psql';
    if ( $DatabaseDSN !~ m/host=/i ) {
        $DatabaseHost = '';
    }

    my $IsInstalled = 0;
    open( my $Input, '-|', "which $DBDump" );    ## no critic qw(OTOBO::ProhibitOpen)
    while ( my $s = <$Input> ) {
        $IsInstalled = 1;
    }
    close $Input;
    if ( !$IsInstalled ) {
        say STDERR "ERROR: Can't locate $DBDump!";

        exit 1;
    }
}
else {
    say STDERR "ERROR: Can't backup, no database dump support!";

    exit 1;
}

# check database env
if ( $DB =~ m/mysql/i ) {
    $Kernel::OM->Get('Kernel::System::DB')->Prepare( SQL => "SHOW TABLES" );
    if ( $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        say STDERR
            "ERROR: Already existing tables in this database. An empty database is required for restore!";

        exit 1;
    }
}
else {
    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL =>
            "SELECT table_name FROM information_schema.tables WHERE table_catalog = 'otobo' AND table_schema = 'public'",
    );
    if ( $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        say STDERR
            "ERROR: Already existing tables in this database. An empty database is required for restore!";

        exit 1;
    }
}

# restore
my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');
chdir($Home);

# extract application
my $ApplicationBackupGz  = File::Spec->catfile( $Opts{b}, 'Application.tar.gz' );
my $ApplicationBackupBz2 = File::Spec->catfile( $Opts{b}, 'Application.tar.bz2' );
if ( -e $ApplicationBackupGz ) {
    say "Restore $ApplicationBackupGz ...";
    if ( system("tar -xzf $ApplicationBackupGz") ) {    # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}
elsif ( -e $ApplicationBackupBz2 ) {
    say "Restore $ApplicationBackupBz2 ...";
    if ( system("tar -xjf $ApplicationBackupBz2") ) {    # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}

# extract vardir
my $VarDirBackupGz  = File::Spec->catfile( $Opts{b}, 'VarDir.tar.gz' );
my $VarDirBackupBz2 = File::Spec->catfile( $Opts{b}, 'VarDir.tar.bz2' );
if ( -e $VarDirBackupGz ) {
    say "Restore $VarDirBackupGz ...";
    if ( system("tar -xzf $VarDirBackupGz") ) {          # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}
elsif ( -e $VarDirBackupBz2 ) {
    say "Restore $VarDirBackupBz2 ...";
    if ( system("tar -xjf $VarDirBackupBz2") ) {         # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}

# extract datadir
my $DataDirBackupGz  = File::Spec->catfile( $Opts{b}, 'DataDir.tar.gz' );
my $DataDirBackupBz2 = File::Spec->catfile( $Opts{b}, 'DataDir.tar.bz2' );
if ( -e $DataDirBackupGz ) {
    say "Restore $DataDirBackupGz ...";
    if ( system("tar -xzf $DataDirBackupGz") ) {         # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}
if ( -e $DataDirBackupBz2 ) {
    say "Restore $DataDirBackupBz2 ...";
    if ( system("tar -xjf $DataDirBackupBz2") ) {        # returns non-zero if tar extraction fails
        say STDERR "ERROR: Invalid tar file!";

        exit 1;
    }
}

# TODO: after 'system("gunzip...' the output to STDERR does not work

# import database
my $DatabaseBackupGz  = File::Spec->catfile( $Opts{b}, 'DatabaseBackup.sql.gz' );
my $DatabaseBackupBz2 = File::Spec->catfile( $Opts{b}, 'DatabaseBackup.sql.bz2' );
if ( $DB =~ m/mysql/i ) {
    say "Create $DB";
    if ($DatabasePw) {
        $DatabasePw = "-p'$DatabasePw'";
    }
    if ( -e $DatabaseBackupGz ) {
        say "Restore database into $DB ...";
        if ( $Opts{c} && system("gunzip -t $DatabaseBackupGz") ) {    # returns non-zero if gunzip extraction fails
            say STDERR "ERROR: Invalid gz file!";

            exit 1;
        }
        system(
            "gunzip -c $DatabaseBackupGz | mysql -f -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database"
        );
    }
    elsif ( -e $DatabaseBackupBz2 ) {
        say "Restore database into $DB ...";
        if ( $Opts{c} && system("bunzip2 -t $DatabaseBackupGz") ) {    # returns non-zero if bunzip2 extraction fails
            say STDERR "ERROR: Invalid bz2 file!";

            exit 1;
        }
        system(
            "bunzip2 -c $DatabaseBackupBz2 | mysql -f -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database"
        );
    }
}
else {
    if ($DatabaseHost) {
        $DatabaseHost = "-h $DatabaseHost";
    }

    if ( -e $DatabaseBackupGz ) {

        # set password via environment variable if there is one
        if ($DatabasePw) {
            $ENV{PGPASSWORD} = $DatabasePw;    ## no critic qw(Variables::RequireLocalizedPunctuationVars)
        }
        say "Restore database into $DB ...";
        if ( $Opts{c} && system("gunzip -t $DatabaseBackupGz") ) {    # returns non-zero if gunzip extraction fails
            say STDERR "ERROR: Invalid gz file!";

            exit 1;
        }
        system(
            "gunzip -c $DatabaseBackupGz | psql -U$DatabaseUser $DatabaseHost $Database"
        );
    }
    elsif ( -e $DatabaseBackupBz2 ) {

        # set password via environment variable if there is one
        if ($DatabasePw) {
            $ENV{PGPASSWORD} = $DatabasePw;    ## no critic qw(Variables::RequireLocalizedPunctuationVars)
        }
        say "Restore database into $DB ...";
        if ( $Opts{c} && system("bunzip2 -t $DatabaseBackupGz") ) {    # returns non-zero if bunzip2 extraction fails
            say STDERR "ERROR: Invalid bz2 file!";

            exit 1;
        }
        system(
            "bunzip2 -c $DatabaseBackupBz2 | psql -U$DatabaseUser $DatabaseHost $Database"
        );
    }
}
say "Done.";
