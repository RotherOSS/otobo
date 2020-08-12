#!/usr/bin/env perl
# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2020 Rother OSS GmbH, https://otobo.de/
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

=head1 NAME

quick_setup.pl - a quick OTOBO setup script

=head1 SYNOPSIS

    # get help
    bin/docker/quick_setup.pl --help

    # do it
    bin/docker/quick_setup.pl --db-password 'some-pass'

=head1 DESCRIPTION

Useful for continous integration.

=head1 OPTIONS

=over 4

=item help

Optional. Print out the usage.

=item db-password

The admin password of the database.

=back

=cut

use v5.24;
use warnings;
use utf8;

use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# core modules
use Getopt::Long;
use Pod::Usage qw(pod2usage);

# CPAN modules
use Path::Class qw(file dir);
use DBI;
use Readonly;

# OTOBO modules
use Kernel::System::ObjectManager;

sub Main {
    my ( $HelpFlag, $DBPassword );

    Getopt::Long::GetOptions(
        'help'          => \$HelpFlag,
        'db-password=s' => \$DBPassword,
    ) or pod2usage({ -exitval => 1, -verbose => 1 });

    if ( $HelpFlag ) {
        pod2usage({ -exitval => 0, -verbose => 2});
    }

    # TODO: get the relevant settings from Config.pm
    Readonly my $DBName           => 'otobo';
    Readonly my $OTOBODBUser      => 'otobo';
    Readonly my $OTOBODBPassword  => 'otobo';
    Readonly my $DBType           => 'mysql';

    $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'quick_setup',
        },
    );

    {
        my ( $Success, $Message ) = CheckSystemRequirements();
        say $Message if defined $Message;

        return 0 if !$Success;
    }

    {
        # in the Docker use case we can safely assume tha we are dealing with MySQL
        my ( $Success, $Message ) = CheckDBRequirements(
            DBUser     => 'root',
            DBPassword => $DBPassword,
            DBName     => $DBName,
        );

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    {
        my ( $Success, $Message ) = DBCreateUser(
            DBUser           => 'root',
            DBPassword       => $DBPassword,
            DBName           => $DBName,
            OTOBODBUser      => $OTOBODBUser,
            OTOBODBPassword  => $OTOBODBPassword,
        );

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::DB' => {
            DatabaseUser => $OTOBODBUser,
            DatabasePw   => $OTOBODBPassword,
            Type         => $DBType,
        },
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Home = $ConfigObject->Get('Home');

    for my $XMLFile (qw(otobo-schema otobo-initial_insert)) {
        # the xml file contains the database name 'otobo' hardcoded
        my ( $Success, $Message ) = ExecuteSQL(
            XMLFile          => "$Home/scripts/database/$XMLFile.xml",
        );

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    return 0 if ! AdaptConfig();

    return 0 if ! DeactivateElasticsearch();

    # looks good
    return 0;
}

sub CheckSystemRequirements {

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Home         = $ConfigObject->Get('Home');

    # verify that Home exists
    if ( ! $Home ) {
        return 0, q{setting 'Home' is not configured};
    }

    my $HomeDir = dir($Home);

    if ( ! $HomeDir->is_absolute ) {
        return 0, "'$HomeDir' is not an absolute path";
    }

    if ( ! -d $HomeDir ) {
        return 0, "'$HomeDir' is not a directory";
    }

    # verfiy that SecureMode is not active
    if ( $ConfigObject->Get('SecureMode') ) {
        return 0, "SecureMode is active";
    }

    # verify that ZZZAAuto.pm does not exist yet
    my $ZZZAAutoPmFile = $HomeDir->file('Kernel/Config/Files/ZZZAAuto.pm');
    if ( -e $ZZZAAutoPmFile ) {
        return 0, "'$ZZZAAutoPmFile' already exists";
    }

    # verify that Kernel/Config.pm exists and is readable and writeable
    my $ConfigPmFile = $HomeDir->file('Kernel/Config.pm');

    if ( ! -f $ConfigPmFile ) {
        return 0, "'$ConfigPmFile' does not exist";
    }

    if ( ! -r $ConfigPmFile ) {
        return 0, "'$ConfigPmFile' is not readable";
    }

    if ( ! -w $ConfigPmFile ) {
        return 0, "'$ConfigPmFile' is not writeable";
    }

    # verify the scripts/database and the relevant .xml files exits
    my $DatabaseDir = $HomeDir->subdir( 'scripts/database' );

    if ( ! -d $DatabaseDir ) {
        return 0, "'$DatabaseDir' does not exist";
    }

    for my $XmlFile ( map { $DatabaseDir->file($_) } ( 'otobo-schema.xml', 'otobo-initial_insert.xml' ) ) {
        if ( ! -f $XmlFile ) {
            return 0, "'$XmlFile' does not exist";
        }

        if ( ! -r $XmlFile ) {
            return 0, "'$XmlFile' is not readable";
        }
    }

    return 1, 'all system requirements are met';
}

sub DBConnect {
    my %Param = @_;

    # check the params
    for my $Key ( grep { ! $Param{$_} } qw(DBUser DBPassword ) ) {
        return 0, "CheckSystemRequirements: the parameter '$Key' is required";
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # verify that some expected settings are available
    KEY:
    for my $Key ( qw(Database DatabaseUser DatabasePw DatabaseDSN DatabaseHost) ) {

        next KEY if $ConfigObject->Get($Key);

        return 0, qq{setting '$Key' is not configured};
    }

    # verify that the connection to the DB is possible, password was passed on command line
    my $DatabaseHost = $ConfigObject->Get('DatabaseHost');
    my $DSN = "DBI:mysql:mysql;host=$DatabaseHost;";

    my $DBHandle = DBI->connect($DSN, $Param{DBUser}, $Param{DBPassword});
    if ( ! $DBHandle ) {
        return 0, $DBI::errstr;
    }

    return $DBHandle;
}

sub CheckDBRequirements {
    my %Param = @_;

    my ( $DBHandle, $Message ) = DBConnect( %Param );

    if ( ! $DBHandle ) {
        return 0, $Message;
    }

    # check whether the database is alive
    my $DBIsAlive = $DBHandle->ping;
    if ( ! $DBIsAlive ) {
        return 0, 'no pingback from the database';
    }

    # verify that the database does not exist yet
    my $TableInfoSth = $DBHandle->table_info( '%', $Param{DBName}, '%', 'TABLE' );
    my $Rows = $TableInfoSth->fetchall_arrayref;

    if ( $Rows->@* ) {
        return 0, "the schema '$Param{DBName}' already exists";
    }

    return 1, 'all database requirements are met';
}

# specific for MySQL
sub DBCreateUser {
    my %Param = @_;

    # check the params
    for my $Key ( grep { ! $Param{$_} } qw(DBUser DBPassword DBName OTOBODBUser OTOBODBPassword) ) {
        return 0, "CheckSystemRequirements: the parameter '$Key' is required";
    }

    my ( $DBHandle, $Message ) = DBConnect( %Param );

    if ( ! $DBHandle ) {
        return 0, $Message;
    }

    # As we are running under Docker we assume that the database also runs in the subnet provided by Docker.
    # This is the case when the standard docker-compose.yml is used.
    # In this network the IP-addresses are not static therefore we can't use the same IP address
    # as seen when installer.pl runs.
    # Using 'db' does not work because 'skip-name-resolve' is set.
    # For now allow the complete network.
    my $Host = '%';

    # SQL for creating the OTOBO user.
    # An explicit statement for user creation is needed because MySQL 8 no longer
    # supports implicit user creation via the 'GRANT PRIVILEGES' statement.
    # Also note that there are multiple authentication plugins for MySQL/MariaDB.
    # 'mysql_native_password' works without an encrypted DB connection and is used here.
    # The advantage is that no encryption keys have to be set up.
    # The syntax for CREATE USER is not completely the same between MySQL and MariaDB. Therfore
    # a case switch must be used here.
    my $CreateUserSQL;
    {
        if ( $DBHandle->{mysql_serverinfo} =~ m/mariadb/i ) {
            $CreateUserSQL .= "CREATE USER `$Param{OTOBODBUser}`\@`$Host` IDENTIFIED BY '$Param{OTOBODBPassword}'",
        }
        else {
            $CreateUserSQL .= "CREATE USER `$Param{OTOBODBUser}`\@`$Host` IDENTIFIED WITH mysql_native_password BY '$Param{OTOBODBPassword}'",
        }
    }

    my @Statements = (
        "CREATE DATABASE `$Param{DBName}` charset utf8mb4 DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci",
        $CreateUserSQL,
        "GRANT ALL PRIVILEGES ON `$Param{DBName}`.* TO `$Param{OTOBODBUser}`\@`$Host` WITH GRANT OPTION",
    );

    for my $Statement ( @Statements ) {
        # do() returns undef in the error case
        my $Success = defined $DBHandle->do($Statement);
        if ( ! $Success ) {
            return 0, $DBHandle->errstr;
        }
    }

    return 1;
}

sub ExecuteSQL {
    my %Param = @_;

    # check the params
    for my $Key ( grep { ! $Param{$_} } qw(XMLFile) ) {
        return 0, "CheckSystemRequirements: the parameter '$Key' is required";
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $XML = $MainObject->FileRead(
        Location  => $Param{XMLFile},
    );
    my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse(
        String => $XML,
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my @SQL = $DBObject->SQLProcessor(
        Database => \@XMLArray,
    );

    # If we parsed the schema, catch post instructions.
    push @SQL, $DBObject->SQLProcessorPost() if $Param{XMLFile} =~ m/otobo-schema/;

    SQL:
    for my $SQL (@SQL) {
        my $Success = $DBObject->Do( SQL => $SQL );

        next SQL if $Success;

        return 0, $DBI::errstr;
    }

    return 1;
}

sub AdaptConfig {
    return 1;
}

sub DeactivateElasticsearch {
    return 1;
}

# do it
my $RetCode = Main();

exit $RetCode;
