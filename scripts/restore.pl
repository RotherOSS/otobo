#!/usr/bin/env perl
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

use strict;
use warnings;
use v5.24;

# use ../ as lib location
use File::Basename;
use File::Spec qw(catfile);
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

# core modules
use Getopt::Std;

# CPAN modules

# OTOBO modules
use Kernel::System::ObjectManager;

# get options
my %Opts;
getopt( 'hbd', \%Opts );

if ( exists $Opts{h} ) {
    print <<'END_HELP';

Restore an OTOBO system from backup.

Usage:
 restore.pl -b /data_backup/<TIME>/ -d /opt/otobo/

Options:
 -b                     - Directory of the backup files.
 -d                     - Target OTOBO home directory.
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
    while (<$Input>) {
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
    system("tar -xzf $ConfigBackupGz");
}
elsif ( -e $ConfigBackupBz2 ) {
    say "Restore $ConfigBackupBz2 ...";
    system("tar -xjf $ConfigBackupBz2");
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
my $ArticleDir   = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Article::Backend::MIMEBase::ArticleDataDir');

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
    while (<$Input>) {
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
    while (<$Input>) {
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
    my $Check = 0;
    while ( my @RowTmp = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        $Check++;
    }
    if ($Check) {
        say STDERR
            "ERROR: Already existing tables in this database. A empty database is required for restore!";

        exit 1;
    }
}
else {
    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL =>
            "SELECT table_name FROM information_schema.tables WHERE table_catalog = 'otobo' AND table_schema = 'public'",
    );
    my $Check = 0;
    while ( my @RowTmp = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        $Check++;
    }
    if ($Check) {
        say STDERR
            "ERROR: Already existing tables in this database. A empty database is required for restore!";

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
    system("tar -xzf $ApplicationBackupGz");
}
elsif ( -e $ApplicationBackupBz2 ) {
    say "Restore $ApplicationBackupBz2 ...";
    system("tar -xjf $ApplicationBackupBz2");
}

# extract vardir
my $VarDirBackupGz  = File::Spec->catfile( $Opts{b}, 'VarDir.tar.gz' );
my $VarDirBackupBz2 = File::Spec->catfile( $Opts{b}, 'VarDir.tar.bz2' );
if ( -e $VarDirBackupGz ) {
    say "Restore $VarDirBackupGz ...";
    system("tar -xzf $VarDirBackupGz");
}
elsif ( -e $VarDirBackupBz2 ) {
    say "Restore $VarDirBackupBz2 ...";
    system("tar -xjf $VarDirBackupBz2");
}

# extract datadir
my $DataDirBackupGz  = File::Spec->catfile( $Opts{b}, 'DataDir.tar.gz' );
my $DataDirBackupBz2 = File::Spec->catfile( $Opts{b}, 'DataDir.tar.bz2' );
if ( -e $DataDirBackupGz ) {
    say "Restore $DataDirBackupGz ...";
    system("tar -xzf $DataDirBackupGz");
}
if ( -e $DataDirBackupBz2 ) {
    say "Restore $DataDirBackupBz2 ...";
    system("tar -xjf $DataDirBackupBz2");
}

# import database
my $DatabaseBackupGz  = File::Spec->catfile( $Opts{b}, 'DatabaseBackup.sql.gz' );
my $DatabaseBackupBz2 = File::Spec->catfile( $Opts{b}, 'DatabaseBackup.sql.bz2' );
if ( $DB =~ m/mysql/i ) {
    say "create $DB";
    if ($DatabasePw) {
        $DatabasePw = "-p'$DatabasePw'";
    }
    if ( -e $DatabaseBackupGz ) {
        say "Restore database into $DB ...";
        system(
            "gunzip -c $DatabaseBackupGz | mysql -f -u$DatabaseUser $DatabasePw -h$DatabaseHost $Database"
        );
    }
    elsif ( -e $DatabaseBackupBz2 ) {
        say "Restore database into $DB ...";
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
        system(
            "bunzip2 -c $DatabaseBackupBz2 | psql -U$DatabaseUser $DatabaseHost $Database"
        );
    }
}
