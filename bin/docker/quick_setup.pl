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

=head1 NAME

quick_setup.pl - a quick OTOBO setup script that is meant for development

=head1 SYNOPSIS

    # get help
    bin/docker/quick_setup.pl --help

    # do it
    bin/docker/quick_setup.pl --db-password 'some-pass'

    # set HttpType to http, the default is https
    bin/docker/quick_setup.pl --db-password 'some-pass' --http-type http

    # do it when OTOBO runs on a special HTTP Port
    # note that this only affect the message printed by this script
    bin/docker/quick_setup.pl --db-password 'some-pass' --http-port 81

    # set FQDN, the default is yourhost.example.com
    bin/docker/quick_setup.pl --db-password 'some-pass' --fqdn 'localhost'

    # set the SystemID, the default is 10
    bin/docker/quick_setup.pl --db-password 'some-pass' --system-id 11

    # also activate Elasticsearch
    bin/docker/quick_setup.pl --db-password 'some-pass' --activate-elasticsearch

    # create an initial admin agent in addition to root@localhost
    bin/docker/quick_setup.pl --db-password 'some-pass' --add-admin-user

    # create an initial customer user
    bin/docker/quick_setup.pl --db-password 'some-pass' --add-customer-user

    # add a calendar
    bin/docker/quick_setup.pl --db-password 'some-pass' --add-calendar

It might be convenient the call this script via an alias.

    alias otobo_docker_quick_setup='docker exec -t otobo_web_1 bash -c "date ; hostname ; rm -f Kernel/Config/Files/ZZZAAuto.pm ; bin/docker/quick_setup.pl --db-password otobo_root --http-port 81 --activate-elasticsearch --add-user --add-admin-user --add-customer-user --add-calendar --http-type http" --fqdn localhost'

=head1 DESCRIPTION

Quickly create a running system that is useful for development and for continous integration.
But please note that this script is not meant as an replacement for the OTOBO installer.

The script allows to automatically create a sample customer user, admin user, and calendar.
It allows to set HttpType to http, which is the proven setting for the test suite.

=head1 OPTIONS

=over 4

=item help

Optional. Print out the usage.

=item db-password

The admin password of the database.

=item http-type

Set the SysConfig setting 'HttpType'. The value is either 'http' or 'https'. The default is 'https'.

=item http-port

Only used for the message where the newly configured system is available.
The default value is 80.

=item system-id

Allows to set the system id. This is useful for distinguishing between different installation
running on the same Docker host.
The default value is 10.

=item fqdn

Set the SysConfig setting 'FQDN'. The value is expected to be a string. The default is 'yourhost.example.com'.

=item activate-elasticsearch

Also set up the the Elasticsearch webservice.

=item add-admin-user

Add the admin I<admin> with the name I<Andy Admin>. This user will be a member
of the groups I<admin>, I<stats>, and I<users>.

=item add-customer-user

Add the customer user I<tina> of the non-existing customer company I<Quick Example Company>.

=item add-calendar

Add the customer user I<tina> of the non-existing customer company I<Quick Example Company>.

=back

=cut

use v5.24;
use strict;
use warnings;
use utf8;

use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# core modules
use Getopt::Long qw(GetOptions);
use Pod::Usage   qw(pod2usage);
use Sub::Util    qw(subname);

# CPAN modules
use Path::Class qw(dir);
use DBI         ();
use Const::Fast qw(const);

# OTOBO modules
use Kernel::System::ObjectManager ();

sub Main {
    my $HelpFlag;                                          # print help
    my $DBPassword;                                        # required
    my $HTTPPort              = 80;                        # only used for success message
    my $SystemID              = 10;                        # distinguish between different installations
    my $ActivateElasticsearch = 0;                         # must be explicitly enabled
    my $AddUser               = 0;                         # must be explicitly enabled
    my $AddAdminUser          = 0;                         # must be explicitly enabled
    my $AddCustomerUser       = 0;                         # must be explicitly enabled
    my $AddCalendar           = 0;                         # must be explicitly enabled
    my $HttpType              = 'https';                   # the SysConfig setting HttpType
    my $FQDN                  = 'yourhost.example.com';    # the SysConfig setting FQDN

    GetOptions(
        'help'                   => \$HelpFlag,
        'db-password=s'          => \$DBPassword,
        'http-port=i'            => \$HTTPPort,
        'http-type=s'            => \$HttpType,
        'system-id=i'            => \$SystemID,
        'fqdn=s'                 => \$FQDN,
        'activate-elasticsearch' => \$ActivateElasticsearch,
        'add-user'               => \$AddUser,
        'add-admin-user'         => \$AddAdminUser,
        'add-customer-user'      => \$AddCustomerUser,
        'add-calendar'           => \$AddCalendar,
        )
        || pod2usage(
            {
                -exitval => 1,
                -verbose => 1
            }
        );

    if ($HelpFlag) {
        pod2usage(
            {
                -exitval => 0,
                -verbose => 2
            }
        );
    }

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'quick_setup',
        },
    );

    {
        my ( $Success, $Message ) = CheckSystemRequirements();
        say $Message if defined $Message;

        return 0 unless $Success;
    }

    # we can rely on Kernel::Config now
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    const my $DBName          => $ConfigObject->Get('Database');
    const my $OTOBODBUser     => $ConfigObject->Get('DatabaseUser');
    const my $OTOBODBPassword => $ConfigObject->Get('DatabasePw');
    const my $DBType          => 'mysql';

    {
        # in the Docker use case we can safely assume tha we are dealing with MySQL
        my ( $Success, $Message ) = CheckDBRequirements(
            DBPassword => $DBPassword,
            DBName     => $DBName,       # for checking that the database does not exist yet
        );

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    {
        my ( $Success, $Message ) = DBCreateUserAndDatabase(
            DBName          => $DBName,
            DBPassword      => $DBPassword,
            OTOBODBUser     => $OTOBODBUser,
            OTOBODBPassword => $OTOBODBPassword,
        );

        say $Message if defined $Message;

        return 0 unless $Success;
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

        return 0 unless $Success;
    }

    {
        my ( $Success, $Message ) = SetRootAtLocalhostPassword(
            HTTPPort => $HTTPPort,
            FQDN     => $FQDN,
        );

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    # create SysConfig and adapt some settings in the SysConfig
    {
        # These setting are recommended for running the test suite.
        # HttpType should be set to 'http'.
        my @Settings = (
            [ DefaultLanguage        => 'en' ],
            [ HttpType               => $HttpType ],
            [ FQDN                   => $FQDN ],
            [ SystemID               => $SystemID ],
            [ SecureMode             => 1 ],
            [ CheckEmailValidAddress => '^(?:root@localhost|admin@localhost|tina@example.com)$' ],
        );

        # Unique names for session cookies. This allows to run distint instances on the same host.
        push @Settings, (
            [ SessionName              => join( '_', 'OTOBOAgentInterface',    $SystemID ) ],
            [ CustomerPanelSessionName => join( '_', 'OTOBOCustomerInterface', $SystemID ) ],
        );

        # These settings are useful for testing and development
        push @Settings, (
            [ MinimumLogLevel => 'info' ],    # more verbose log output
        );

        my ( $Success, $Message ) = AdaptSettings( Settings => \@Settings );

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    if ($ActivateElasticsearch) {
        my ( $Success, $Message ) = ActivateElasticsearch();

        say $Message if defined $Message;

        return 0 unless $Success;
    }
    else {
        my ( $Success, $Message ) = DeactivateElasticsearch();

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    if ($AddUser) {
        my ( $Success, $Message ) = AddUser(
            HTTPPort => $HTTPPort,
            FQDN     => $FQDN,
        );

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    if ($AddAdminUser) {
        my ( $Success, $Message ) = AddAdminUser(
            HTTPPort => $HTTPPort,
            FQDN     => $FQDN,
        );

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    if ($AddCustomerUser) {
        my ( $Success, $Message ) = AddCustomerUser(
            HTTPPort => $HTTPPort,
            FQDN     => $FQDN,
        );

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    if ($AddCalendar) {
        my ( $Success, $Message ) = AddCalendar();

        say $Message if defined $Message;

        return 0 unless $Success;
    }

    # add a blurb about MinIO

    # looks good
    say 'For running the unit tests please stop the OTOBO Daemon.';
    say "Finished running $0";

    return 0;
}

sub CheckSystemRequirements {

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Home         = $ConfigObject->Get('Home');

    # verify that Home exists
    if ( !$Home ) {
        return 0, q{setting 'Home' is not configured};
    }

    my $HomeDir = dir($Home);

    if ( !$HomeDir->is_absolute() ) {
        return 0, "'$HomeDir' is not an absolute path";
    }

    if ( !-d $HomeDir ) {
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

    if ( !-f $ConfigPmFile ) {
        return 0, "'$ConfigPmFile' does not exist";
    }

    if ( !-r $ConfigPmFile ) {
        return 0, "'$ConfigPmFile' is not readable";
    }

    if ( !-w $ConfigPmFile ) {
        return 0, "'$ConfigPmFile' is not writeable";
    }

    # verify the scripts/database and the relevant .xml files exits
    my $DatabaseDir = $HomeDir->subdir('scripts/database');

    if ( !-d $DatabaseDir ) {
        return 0, "'$DatabaseDir' does not exist";
    }

    for my $XmlFile ( map { $DatabaseDir->file($_) } ( 'otobo-schema.xml', 'otobo-initial_insert.xml' ) ) {
        if ( !-f $XmlFile ) {
            return 0, "'$XmlFile' does not exist";
        }

        if ( !-r $XmlFile ) {
            return 0, "'$XmlFile' is not readable";
        }
    }

    return 1, 'all system requirements are met';
}

sub DBConnectAsRoot {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw(DBPassword ) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # verify that the connection to the DB is possible, password was passed on command line
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DatabaseHost = $ConfigObject->Get('DatabaseHost');
    my $DSN          = "DBI:mysql:database=mysql;host=$DatabaseHost;";

    my $DBHandle = DBI->connect( $DSN, 'root', $Param{DBPassword} );
    if ( !$DBHandle ) {
        return 0, $DBI::errstr;
    }

    return $DBHandle, "connected to '$DSN' as root";
}

sub CheckDBRequirements {
    my %Param = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # verify that some expected settings are available
    KEY:
    for my $Key (qw(Database DatabaseUser DatabasePw DatabaseDSN DatabaseHost)) {

        next KEY if $ConfigObject->Get($Key);

        return 0, qq{setting '$Key' is not configured};
    }

    # try to connect as root to mysql
    my ( $DBHandle, $Message ) = DBConnectAsRoot(%Param);

    if ( !$DBHandle ) {
        return 0, $Message;
    }

    # check whether the database is alive
    my $DBIsAlive = $DBHandle->ping();
    if ( !$DBIsAlive ) {
        return 0, 'no pingback from the database';
    }

    # verify that the database does not exist yet
    my $TableInfoSth = $DBHandle->table_info( '%', $Param{DBName}, '%', 'TABLE' );
    my $Rows         = $TableInfoSth->fetchall_arrayref();

    if ( $Rows->@* ) {
        return 0, "the schema '$Param{DBName}' already exists";
    }

    return 1, 'all database requirements are met';
}

# specific for MySQL
sub DBCreateUserAndDatabase {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw(DBPassword DBName OTOBODBUser OTOBODBPassword) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    my ( $DBHandle, $Message ) = DBConnectAsRoot(%Param);

    if ( !$DBHandle ) {
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
            $CreateUserSQL .= "CREATE USER `$Param{OTOBODBUser}`\@`$Host` IDENTIFIED BY '$Param{OTOBODBPassword}'";
        }
        else {
            $CreateUserSQL .= "CREATE USER `$Param{OTOBODBUser}`\@`$Host` IDENTIFIED WITH mysql_native_password BY '$Param{OTOBODBPassword}'";
        }
    }

    my @Statements = (
        "CREATE DATABASE `$Param{DBName}` charset utf8mb4 DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci",
        $CreateUserSQL,
        "GRANT ALL PRIVILEGES ON `$Param{DBName}`.* TO `$Param{OTOBODBUser}`\@`$Host` WITH GRANT OPTION",
    );

    for my $Statement (@Statements) {

        # do() returns undef in the error case
        my $Success = defined $DBHandle->do($Statement);
        if ( !$Success ) {
            return 0, $DBHandle->errstr();
        }
    }

    return 1;
}

sub ExecuteSQL {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw(XMLFiles) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # unfortunately we have some interdependencies here
    my @SQLPost;

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');

    for my $XMLFile ( $Param{XMLFiles}->@* ) {

        my $XML = $MainObject->FileRead(
            Location => $XMLFile,
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
    for my $Key ( grep { !$Param{$_} } qw(HTTPPort) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # Set a generated password for the 'root@localhost' account.
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $Password   = 'root';
    my $Success    = $UserObject->SetPassword(
        UserLogin => 'root@localhost',
        PW        => $Password,
    );

    return 0, 'Password for root@localhost could not be set' unless $Success;

    # Protocol http is fine, as there is an automatic redirect
    return 1, "Agent: http://$Param{FQDN}:$Param{HTTPPort}/otobo/index.pl user: root\@localhost pw: $Password";
}

# update sysconfig settings in the database and deploy these settings
sub AdaptSettings {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw(Settings) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # read files in Kernel/Config/Files/XML and store config in DB
    $SysConfigObject->ConfigurationXML2DB(
        UserID  => 1,
        Force   => 1,
        CleanUp => 1,
    ) || return ( 0, 'Could not save config in DB' );

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        LockAll => 1,
        Force   => 1,
        UserID  => 1,
    );

    for my $KeyValue ( $Param{Settings}->@* ) {

        my ( $Key, $Value ) = $KeyValue->@*;

        # Update config item via sys config object.
        if ( defined $Value ) {
            $SysConfigObject->SettingUpdate(
                Name              => $Key,
                IsValid           => 1,
                EffectiveValue    => $Value,
                UserID            => 1,
                ExclusiveLockGUID => $ExclusiveLockGUID,
            );
        }
        else {
            # Get current setting value.
            my %Setting = $SysConfigObject->SettingGet(
                Name => $Key,
            );

            $SysConfigObject->SettingUpdate(
                Name              => $Key,
                IsValid           => 0,
                UserID            => 1,
                EffectiveValue    => $Setting{EffectiveValue},
                ExclusiveLockGUID => $ExclusiveLockGUID,
            );
        }
    }

    $SysConfigObject->SettingUnlock( UnlockAll => 1 );

    # Rebuild the configuration, writing a ZZZAAuto.pm file or a ZZZAAuto.pm S3 object
    $SysConfigObject->ConfigurationDeploy(
        Comments    => 'Quick setup deployment',
        AllSettings => 1,
        Force       => 1,
        UserID      => 1,
    );

    return 1;
}

sub DeactivateElasticsearch {

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $ESWebservice     = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    # nothing to do when there is no Elasticsearch webservice
    return 1 unless $ESWebservice;
    return 1 if $ESWebservice->{ValidID} != 1;    # not valid

    # deactivate the Elasticsearch webservice
    my $Success = $WebserviceObject->WebserviceUpdate(
        $ESWebservice->%*,
        ValidID => 2,                             # invalid
        UserID  => 1,
    );

    if ( !$Success ) {
        return 0, 'Could not deactivate Elasticsearch';
    }

    return 1;
}

# set up the ElasticSearch webservice, perform another SysConfig deployment
sub ActivateElasticsearch {

    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $ESWebservice     = $WebserviceObject->WebserviceGet(
        Name => 'Elasticsearch',
    );

    # nothing to do when there is no Elasticsearch webservice
    return 1 unless $ESWebservice;

    # ctivate the Elasticsearch webservice
    my $UpdateSuccess = $WebserviceObject->WebserviceUpdate(
        $ESWebservice->%*,
        ValidID => 1,    # valid
        UserID  => 1,
    );

    return 0, 'Could not activate the web service Elasticsearch' unless $UpdateSuccess;

    my $ESObject = $Kernel::OM->Get('Kernel::System::Elasticsearch');

    # test the connection
    if ( !$ESObject->TestConnection() ) {
        return 0, 'Elasticsearch is not available';
    }

    my ( $SetupSuccess, $FatalError ) = $ESObject->InitialSetup();

    return 0, 'Initial setup of Elasticsearch was not successful' unless $SetupSuccess;

    return $SetupSuccess;
}

sub AddUser {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw(HTTPPort) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # Disable email checks to create new user.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # create an user
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $Login      = 'toni';
    my $UserID     = $UserObject->UserAdd(
        UserFirstname => 'Toni',
        UserLastname  => 'Tester',
        UserLogin     => $Login,
        UserPw        => $Login,
        UserEmail     => 'Toni.Tester@example.com',
        UserComment   => 'sample user created by quick_setup.pl',
        UserLanguage  => 'en',
        UserTimeZone  => 'Europe/Berlin',
        UserMobile    => '1①๑໑༡༪၁',
        ValidID       => 1,
        ChangeUserID  => 1,
    );

    return 0, "Could not create the user '$Login'" unless $UserID;

    # do we have an admin group ?
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
    for my $Group (qw(users)) {
        my $GroupID = $GroupObject->GroupLookup(
            Group => $Group,
        );

        return 0, "Could not find the group '$Group'" unless $GroupID;

        # now set the permissions
        my $Success = $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID,
            UID        => $UserID,
            Permission => {
                ro        => 1,
                move_into => 1,
                create    => 1,
                owner     => 1,
                priority  => 1,
                rw        => 1,
            },
            UserID => 1,
        );

        return 0, "Could not give $Group privileges to the user '$Login'" unless $Success;
    }

    # looks good
    return 1, "Sample user: http://$Param{FQDN}:$Param{HTTPPort}/otobo/index.pl user: $Login pw: $Login";
}

sub AddAdminUser {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw(HTTPPort) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # Disable email checks to create new user.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # create an user
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $Login      = 'admin';
    my $UserID     = $UserObject->UserAdd(
        UserFirstname => 'Andy',
        UserLastname  => 'Admin',
        UserLogin     => $Login,
        UserPw        => $Login,
        UserEmail     => 'Andy.Admin@example.com',
        UserComment   => 'admin user created by quick_setup.pl',
        UserLanguage  => 'en',
        UserTimeZone  => 'Europe/Berlin',
        UserMobile    => '2②२২৵੨૨',
        ValidID       => 1,
        ChangeUserID  => 1,
    );

    return 0, "Could not create the user '$Login'" unless $UserID;

    # do we have an admin group ?
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
    for my $Group (qw(admin stats users)) {
        my $GroupID = $GroupObject->GroupLookup(
            Group => $Group,
        );

        return 0, "Could not find the group '$Group'" unless $GroupID;

        # now set the permissions
        my $Success = $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID,
            UID        => $UserID,
            Permission => {
                ro        => 1,
                move_into => 1,
                create    => 1,
                owner     => 1,
                priority  => 1,
                rw        => 1,
            },
            UserID => 1,
        );

        return 0, "Could not give $Group privileges to the user '$Login'" unless $Success;
    }

    # Looks like generic preferences can't be passed via AddUser(),
    # so call SetPreferences() explicitly
    $UserObject->SetPreferences(
        UserID => $UserID,
        Key    => 'AdminNavigationBarFavourites',
        Value  => qq{["AdminSystemConfiguration","AdminPackageManager","AdminLog","AdminSupportDataCollector"]},
    );

    # looks good
    return 1, "Admin user: http://$Param{FQDN}:$Param{HTTPPort}/otobo/index.pl user: $Login pw: $Login";
}

sub AddCustomerUser {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw(HTTPPort) ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    # read in the config again
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::Config'] );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    $ConfigObject->Set( 'CustomerAuthBackend', 'DB' );

    # no additional CustomerAuth backends
    for my $Count ( 1 .. 10 ) {
        $ConfigObject->Set( "CustomerAuthBackend$Count", '' );
    }

    # create a customer company
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my $CustomerID            = $CustomerCompanyObject->CustomerCompanyAdd(
        CustomerID             => 'Quick Example Company',
        CustomerCompanyName    => 'First Light 💡 Inc.',
        CustomerCompanyStreet  => 'Example Drive',
        CustomerCompanyZIP     => '00000',
        CustomerCompanyCity    => 'Ndumbakahehu',
        CustomerCompanyCountry => 'Zambia',
        CustomerCompanyURL     => 'http://example.com',
        CustomerCompanyComment => 'created by quick_setup.pl',
        ValidID                => 1,
        UserID                 => 1,
    );

    # Create test customer user.
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $Login              = 'tina';
    my $CustomerUserID     = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'Tina',
        UserLastname   => 'Tester',
        UserCustomerID => $CustomerID,
        UserLogin      => $Login,
        UserEmail      => "$Login\@example.com",
        ValidID        => 1,
        UserID         => 1,
    );

    return 0, "Could not create the customer user $Login" unless $CustomerUserID;

    my $PasswordSetSuccess = $CustomerUserObject->SetPassword(
        UserLogin => $Login,
        PW        => $Login,
    );

    return 0, "Could not set the password for $Login" unless $PasswordSetSuccess;

    # looks good
    return 1, "Customer: http://$Param{FQDN}:$Param{HTTPPort}/otobo/customer.pl user: $Login pw: $Login";
}

sub AddCalendar {
    my %Param = @_;

    # check the params
    for my $Key ( grep { !$Param{$_} } qw() ) {
        my $SubName = subname(__SUB__);

        return 0, "$SubName: the parameter '$Key' is required";
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # create a calendar
    my $CalendarObject = $Kernel::OM->Get('Kernel::System::Calendar');
    my $CalendarName   = 'Quick Setup Calendar 🚄';
    my $CalendarID     = $CalendarObject->CalendarCreate(
        CalendarName => $CalendarName,
        GroupID      => 1,               # group users
        Color        => '#007FFF',       # azure in hexadecimal RGB notation
        ValidID      => 1,               # activate
        UserID       => 1,               # root@localhost
    );

    return 0, "Could not create calendar $CalendarName" unless $CalendarID;

    # looks good
    return 1, "Calender $CalendarName created with ID=$CalendarID";
}

# do it
my $RetCode = Main();

exit $RetCode;
