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
use Const::Fast qw(const);

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

    # we can rely on Kernel::Config now
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    const my $DBName           => $ConfigObject->Get('Database');
    const my $OTOBODBUser      => $ConfigObject->Get('DatabaseUser');
    const my $OTOBODBPassword  => $ConfigObject->Get('DatabasePw');
    const my $DBType           => 'mysql';

    {
        # in the Docker use case we can safely assume tha we are dealing with MySQL
        my ( $Success, $Message ) = CheckDBRequirements(
            DBPassword => $DBPassword,
            DBName     => $DBName, # for checking that the database does not exist yet
        );

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    {
        my ( $Success, $Message ) = DBCreateUserAndDatabase(
            DBName           => $DBName,
            DBPassword       => $DBPassword,
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

    # create the XML-Schema, do the initial inserts, add constraints
    {
        my $Home = $ConfigObject->Get('Home');

        # the xml files contain the database name 'otobo' hardcoded
        my ( $Success, $Message ) = ExecuteSQL(
            XMLFiles => [
                "$Home/scripts/database/otobo-schema.xml",
                "$Home/scripts/database/otobo-initial_insert.xml",
            ],
        );

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    {
        my ( $Success, $Message ) = SetRootAtLocalhostPassword();

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    {
        # These setting are required for running the test suite
        my @NewSettings = (
            [ 'DefaultLanguage' => 'en' ],
            [ 'HttpType'        => 'http' ],
            [ 'SecureMode'      => 1 ],
        );

        my ( $Success, $Message ) = AdaptSettings( Settings => \@NewSettings);

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    {
        my ( $Success, $Message ) = DeactivateElasticsearch();

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    # looks good
    say 'For running the unit tests please stop the container otobo_daemon_1';
    say "Finished running $0";

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

sub DBConnectAsRoot {
    my %Param = @_;

    # check the params
    for my $Key ( grep { ! $Param{$_} } qw(DBPassword ) ) {
        my $SubName = (caller(0))[3];

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # verify that the connection to the DB is possible, password was passed on command line
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DatabaseHost = $ConfigObject->Get('DatabaseHost');
    my $DSN = "DBI:mysql:database=mysql;host=$DatabaseHost;";

    my $DBHandle = DBI->connect($DSN, 'root', $Param{DBPassword});
    if ( ! $DBHandle ) {
        return 0, $DBI::errstr;
    }

    return $DBHandle, "connected to '$DSN' as root";
}

sub CheckDBRequirements {
    my %Param = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # verify that some expected settings are available
    KEY:
    for my $Key ( qw(Database DatabaseUser DatabasePw DatabaseDSN DatabaseHost) ) {

        next KEY if $ConfigObject->Get($Key);

        return 0, qq{setting '$Key' is not configured};
    }

    # try to connect as root to mysql
    my ( $DBHandle, $Message ) = DBConnectAsRoot( %Param );

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
sub DBCreateUserAndDatabase {
    my %Param = @_;

    # check the params
    for my $Key ( grep { ! $Param{$_} } qw(DBPassword DBName OTOBODBUser OTOBODBPassword) ) {
        my $SubName = (caller(0))[3];

        return 0, "$SubName: the parameter '$Key' is required";
    }

    my ( $DBHandle, $Message ) = DBConnectAsRoot( %Param );

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
    for my $Key ( grep { ! $Param{$_} } qw(XMLFiles) ) {
        my $SubName = (caller(0))[3];

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # unfortunately we have some interdependencies here
    my @SQLPost;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $XMLFile ( $Param{XMLFiles}->@* ) {

        my $XML = $MainObject->FileRead(
            Location  => $XMLFile,
        );
        my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse(
            String => $XML,
        );

        my @SQL = $DBObject->SQLProcessor(
            Database => \@XMLArray,
        );

        SQL:
        for my $SQL (@SQL) {
            my $Success = $DBObject->Do( SQL => $SQL );

            next SQL if $Success;

            return 0, $DBI::errstr;
        }

        # If we parsed the schema, catch post instructions.
        # they will run after the initial insert
        push @SQLPost, $DBObject->SQLProcessorPost() if $XMLFile =~ m/otobo-schema/;
    }

    # now do the actions that must run after the initial insert
    SQL:
    for my $SQL (@SQLPost) {
        my $Success = $DBObject->Do( SQL => $SQL );

        next SQL if $Success;

        return 0, $DBI::errstr;
    }

    return 1;
}

sub SetRootAtLocalhostPassword {
    my %Param = @_;

    # check the params
    for my $Key ( grep { ! $Param{$_} } qw() ) {
        my $SubName = (caller(0))[3];

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # Set a generated password for the 'root@localhost' account.
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $Password   = $UserObject->GenerateRandomPassword( Size => 16 );
    my $Success    = $UserObject->SetPassword(
        UserLogin => 'root@localhost',
        PW        => $Password,
    );

    if ( ! $Success ) {
        return 0, 'Password for root@localhost could not be set';
    }

    # Protocol http is fine, as there is an automatic redirect
    # TODO: is there a way to find out the host and the port
    return 1, "URL: http://localhost/otobo/index.pl, user: root\@localhost, pw: $Password";

}

sub AdaptSettings {
    my %Param = @_;

    # check the params
    for my $Key ( grep { ! $Param{$_} } qw(Settings) ) {
        my $SubName = (caller(0))[3];

        return 0, "$SubName: the parameter '$Key' is required";
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # read files in Kernel/Config/Files/XML and store config in DB
    $SysConfigObject->ConfigurationXML2DB(
        UserID    => 1,
        Force     => 1,
        CleanUp   => 1,
    ) || return 0, 'Could not save config in DB';

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => 1,
    );

    for my $KeyValue ( $Param{Settings}->@* ) {

        my ( $Key, $Value ) = $KeyValue->@*;

        # Update config item via sys config object.
        $SysConfigObject->SettingUpdate(
            Name              => $Key,
            IsValid           => 1,
            EffectiveValue    => $Value,
            UserID            => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
        );
    }

    $SysConfigObject->SettingUnlock( UnlockAll => 1 );

    # 'Rebuild' the configuration.
    $SysConfigObject->ConfigurationDeploy(
        Comments    => "Quick setup deployment",
        AllSettings => 1,
        Force       => 1,
        UserID      => 1,
    );

    return 1;
}

sub DeactivateElasticsearch {

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $ESWebservice = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    # nothing to do when there is no Elasticsearch webservice
    return 1 if ! $ESWebservice;
    return 1 if $ESWebservice->{ValidID} != 1; # not valid

    # deactivate the Elasticsearch webservice
    my $Success = $WebserviceObject->WebserviceUpdate(
        $ESWebservice->%*,
        ValidID => 2, # invalid
        UserID  => 1,
    );

    if ( ! $Success ) {
        return 0, 'Could not deactivate Elasticsearch';
    }

    return 1;
}

# do it
my $RetCode = Main();

exit $RetCode;
