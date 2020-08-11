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

    {
        # in the Docker use case we can safely assume tha we are dealing with MySQL
        my ( $Success, $Message ) = CheckDBRequirements(
            DBUser     => 'root',
            DBPassword => $DBPassword,
        );

        say $Message if defined $Message;

        return 0 if !$Success;
    }

    return 1 if ! DbCreateUser();

    return 1 if ! DbCreateSchema();

    return 1 if ! DbInitialInsert();

    return 1 if ! AdaptConfig();

    return 1 if ! DeactivateElasticsearch();

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

sub CheckDBRequirements {
    my %Params = @_;

    # check the params
    for my $Key ( grep { ! $Params{$_} } qw(DBUser DBPassword ) ) {
        return 0, "CheckSystemRequirements: the parameter '$Key' is required";
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # verify that the connection to the DB is possible, password was passed on command line
    my $DSN = $ConfigObject->Get('DatabaseDSN');

    if ( ! $DSN ) {
        return 0, q{setting 'DatabaseDSN' is not configured};
    }

    my $DBSchema = $ConfigObject->Get('Database');

    if ( ! $DBSchema ) {
        return 0, q{setting 'Database' is not configured};
    }

    my $DBHandle = DBI->connect($DSN, $Params{DBUser}, $Params{DBPassword});
    if ( ! $DBHandle ) {
        return 0, $DBI::errstr;
    }

    # check whether the database is alive
    my $DBIsAlive = $DBHandle->ping;
    if ( ! $DBIsAlive ) {
        return 0, 'no pingback from the database';
    }

    # verify that the database does not exist yet
    my $TableInfoSth = $DBHandle->table_info( '%', $DBSchema, '%', 'TABLE' );
    my $Rows = $TableInfoSth->fetchall_arrayref;

    if ( $Rows->@* ) {
        return 0, "the schema '$DBSchema' already exists";
    }

    return 1, 'all database requirements are met';
}

sub DbCreateUser {
    return;
}

sub DbCreateSchema {
    return;
}

sub DbInitialInsert {
    return;
}

sub AdaptConfig {
    return;
}

sub DeactivateElasticsearch {
    return;
}

# do it
my $RetCode = Main();

exit $RetCode;
