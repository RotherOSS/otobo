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

package Kernel::System::DB;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Pod::FunctionPod)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use List::Util qw(shuffle);

# CPAN modules
use DBI             ();
use DBIx::Connector ();

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::DateTime',
    'Kernel::System::Storable',
);

# This package variable can temporarily be set to 1.
# The effect is that the mirror DB is used, which can
# shed some load for computing intensive tasks, like the generation of statistics.
our $UseMirrorDB = 0;

=head1 NAME

Kernel::System::DB - global database interface

=head1 DESCRIPTION

All database functions to connect/insert/update/delete/... to a database.

=head1 PUBLIC INTERFACE

=head2 new()

create a database object the allows to connect to a database.
Usually you do not use it directly, instead use:

    use Kernel::System::ObjectManager;

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::DB' => {
            # if you don't supply the following parameters, the ones found in
            # Kernel/Config.pm are used instead:
            DatabaseDSN                => 'DBI:odbc:database=123;host=localhost;',
            DatabaseUser               => 'user',
            DatabasePw                 => 'somepass',
            Type                       => 'mysql',
            DeactivateForeignKeyChecks => 1, # useful for database migration
            Attribute => {
                LongTruncOk => 1,
                LongReadLen => 100*1024,
            },
        },
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

There are cases when a second connection to a database is needed. In these cases
the constructor can also be called directly. In most of these cases it makes
sense to pass the argument C<DisconnectOnDestruction> too. In other cases
C<Finish()> can be called in order to clean up lingering database connections.

    {
        my $CustomerDBObject = Kernel::System::DB->new(
            DatabaseDSN             => $Self->{CustomerCompanyMap}->{Params}->{DSN},
            DatabaseUser            => $Self->{CustomerCompanyMap}->{Params}->{User},
            DatabasePw              => $Self->{CustomerCompanyMap}->{Params}->{Password},
            Type                    => $Self->{CustomerCompanyMap}->{Params}->{Type} || '',
            DisconnectOnDestruction => 1,
        ) || die('Can\'t connect to customer database!');

        # do something with the customer database

        # database is disconnected on destruction because DisconnectOnDestruction is set
    }

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # 0=off; 1=updates; 2=+selects; 3=+Connects;
    $Self->{Debug} = $Param{Debug} || 0;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get config data in following order of significance:
    #   1 - Parameters passed to constructor, i.e. parameters declared with ObjectParamAdd
    #   2 - Test database configuration
    #   3 - Main database configuration, usually from Kernel/Config.pm
    $Self->{DSN}  = $Param{DatabaseDSN}  || $ConfigObject->Get('TestDatabaseDSN')  || $ConfigObject->Get('DatabaseDSN');
    $Self->{USER} = $Param{DatabaseUser} || $ConfigObject->Get('TestDatabaseUser') || $ConfigObject->Get('DatabaseUser');
    $Self->{PW}   = $Param{DatabasePw}   || $ConfigObject->Get('TestDatabasePw')   || $ConfigObject->Get('DatabasePw');

    # mirror DB related
    $Self->{IsMirrorDB}    = $Param{IsMirrorDB};    # a guard that stops creation of a further mirror DB
    $Self->{_InitMirrorDB} = 0;                     # a guard that avoids reconnecting to a mirror DB

    # might be useful for database migrations
    $Self->{DeactivateForeignKeyChecks} = $Param{DeactivateForeignKeyChecks} // 0;

    # SlowLog can be activated globally
    $Self->{SlowLog} = $Param{'Database::SlowLog'} || $ConfigObject->Get('Database::SlowLog');

    # turn off persistent database connection, per default database connection is persistent
    $Self->{DisconnectOnDestruction} = $Param{DisconnectOnDestruction};

    # decrypt pw (if needed)
    if ( $Self->{PW} =~ /^\{(.*)\}$/ ) {
        $Self->{PW} = $Self->_Decrypt($1);
    }

    # get database type
    $Self->{'DB::Type'} = eval {

        # overwrite with an explicit param has highest priority
        return $Param{Type} if $Param{Type};

        # then overwrite with config setting
        return $ConfigObject->Get('Database::Type') if $ConfigObject->Get('Database::Type');

        # otherwise auto detection from the DSN
        return 'mysql'      if $Self->{DSN} =~ m/:mysql/i;
        return 'postgresql' if $Self->{DSN} =~ m/:pg/i;
        return 'oracle'     if $Self->{DSN} =~ m/:oracle/i;
        return 'db2'        if $Self->{DSN} =~ m/:db2/i;
        return 'mssql'      if $Self->{DSN} =~ m/(mssql|sybase|sql server)/i;
    };

    if ( !$Self->{'DB::Type'} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => 'Unknown database type! Set option Database::Type in '
                . 'Kernel/Config.pm to (mysql|postgresql|oracle|db2|mssql).',
        );

        return;
    }

    # normalize
    $Self->{'DB::Type'} = lc $Self->{'DB::Type'};

    # load backend module
    {
        my $GenericModule = 'Kernel::System::DB::' . $Self->{'DB::Type'};

        return unless $Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule);

        $Self->{Backend} = $GenericModule->new( %{$Self} );
    }

    # set database functions
    $Self->{Backend}->LoadPreferences();

    # check/get extra database configuration options
    # (overwrite auto-detection with config options)
    for my $Setting (
        qw(
            Type Limit DirectBlob Attribute QuoteSingle QuoteBack
            Connect Encode CaseSensitive LcaseLikeInLargeText
        )
        )
    {
        if ( defined $Param{$Setting} ) {
            $Self->{Backend}->{"DB::$Setting"} = $Param{$Setting};
        }
        elsif ( defined $ConfigObject->Get("Database::$Setting") ) {
            $Self->{Backend}->{"DB::$Setting"} = $ConfigObject->Get("Database::$Setting");
        }
    }

    return $Self;
}

=head2 Connect()

to connect to a database. Connections are managed with DBIx::Connector.

    my $ConnectSuccess = $DBObject->Connect();

Return an empty list when the connection fails.

When connection succeeds than a L<DBI> database handle is returned.

    my $DatabaseHandle = $DBObject->Connect();

This feature should be used only in exceptional cases, as usually all access to the database
should be handled by the instance on L<Kernel::System::DB>.

=cut

sub Connect {
    my $Self = shift;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  =>
                "DB.pm->Connect: DSN: $Self->{DSN}, User: $Self->{USER}, Pw: $Self->{PW}, DB Type: $Self->{'DB::Type'};",
        );
    }

    # db connect
    {

        # Attribute for callbacks. See https://metacpan.org/pod/DBI#Callbacks
        my %Callbacks;
        {
            if ( $Self->{Backend}->{'DB::Connect'} ) {

                # run a command for initializing a session
                my $DBConnectSQL = $Self->{Backend}->{'DB::Connect'};

                # maybe deactivate foreign key checks
                my $DeactivateSQL;
                if ( $Self->{DeactivateForeignKeyChecks} ) {
                    $DeactivateSQL = $Self->GetDatabaseFunction('DeactivateForeignKeyChecks');
                }

                $Callbacks{connected} = sub {
                    my $DatabaseHandle = shift;

                    if ($DBConnectSQL) {
                        $DatabaseHandle->do($DBConnectSQL);
                    }

                    if ($DeactivateSQL) {
                        $DatabaseHandle->do($DeactivateSQL);
                    }

                    return;
                };
            }

            # In OTOBO 10.0.x running with PostgreSQL the flag pg_enable_utf8 was set to 1.
            # According to https://metacpan.org/pod/DBD::Pg#pg_enable_utf8-(integer)
            # this is no longer necessary.
            #if ( $Self->{Backend}->{'DB::Type'} eq 'postgresql' ) {
            #    $ConnectAttributes{pg_enable_utf8} = 1;
            #}
        }

        # The defaults for the attributes RaiseError and AutoInactiveDestroy differ
        # between DBI and DBIx::Connector.
        # For DBI they are off per default, but for DBIx::Connector they are on per default.
        # RaiseError: explicitly turn it off as this was the previous setup in OTOBO.
        #             This is OK as the the methods run(), txn(), and svp() are not used in OTOBO.
        # AutoInactiveDestroy: Concerns only behavior on forks and such.
        #                      Keep it activated as it is important for DBIx::Connector.
        #
        # Kernel::System::DB::mysql also sets mysql_auto_reconnect = 0.
        # This is fine, as this is the same setting as enforced by DBIx::Connector::Driver::mysql
        my %ConnectAttributes = (
            RaiseError => 0,
            $Self->{Backend}->{'DB::Attribute'}->%*,
        );

        # Generation of the cache key is copied from DBI::connect_cached().
        # According to https://metacpan.org/pod/DBI#connect_cached it is OK to
        # have the callbacks with the attributes.
        # But for now, the Callbacks are not part of the cache key in order to avoid serialised code.
        my $CacheKey = do {
            no warnings;    ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)

            join
                "!\001",
                $Self->{DSN},
                $Self->{USER},
                $Self->{PW},
                DBI::_concat_hash_sorted(
                    {
                        %ConnectAttributes,
                        DeactivateForeignKeyChecks => $Self->{DeactivateForeignKeyChecks}
                    },
                    "=\001",
                    ",\001",
                    0,
                    0
                );
        };

        # Use the cached connector when available. Otherwise create a new connector.
        state %Cache;
        $Cache{$CacheKey} //= DBIx::Connector->new(
            $Self->{DSN},
            $Self->{USER},
            $Self->{PW},
            {
                Callbacks => \%Callbacks,
                %ConnectAttributes,
            }
        );

        # this method reuses an existing connection when it is still pinging
        $Self->{dbh} = $Cache{$CacheKey}->dbh;
    }

    if ( !$Self->{dbh} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => $DBI::errstr,
        );

        return;
    }

    if ( $Self->{MirrorDBObject} ) {
        $Self->{MirrorDBObject}->Connect();
    }

    return $Self->{dbh};
}

=head2 Disconnect()

to disconnect from a database

    $DBObject->Disconnect();

=cut

sub Disconnect {
    my $Self = shift;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => 'DB.pm->Disconnect',
        );
    }

    # do disconnect
    if ( $Self->{dbh} ) {
        $Self->{dbh}->disconnect;
        delete $Self->{dbh};
    }

    if ( $Self->{MirrorDBObject} ) {
        $Self->{MirrorDBObject}->Disconnect();
    }

    return 1;
}

=head2 Version()

to get the database version

    my $DBVersion = $DBObject->Version();

returns for example:

    "MySQL 5.1.1";

=cut

sub Version {
    my ( $Self, %Param ) = @_;

    my $Version = 'unknown';

    if ( $Self->{Backend}->{'DB::Version'} ) {
        $Self->Prepare( SQL => $Self->{Backend}->{'DB::Version'} );
        while ( my @Row = $Self->FetchrowArray ) {
            $Version = $Row[0];
        }
    }

    return $Version;
}

=head2 Quote()

to quote sql parameters

Quote strings, date and time:

    my $DBString = $DBObject->Quote( "This isn't a problem!" );
    my $DBString = $DBObject->Quote( "2005-10-27 20:15:01" );

Quote integers:

    my $DBString = $DBObject->Quote( 1234, 'Integer' );

Quote numbers (e. g. 1, 1.4, 42342.23424):

    my $DBString = $DBObject->Quote( 1234, 'Number' );

=cut

sub Quote {
    my ( $Self, $Text, $Type ) = @_;

    # return undef if undef
    return unless defined $Text;

    # quote strings
    if ( !defined $Type ) {
        return ${ $Self->{Backend}->Quote( \$Text ) };
    }

    # quote integers
    if ( $Type eq 'Integer' ) {
        if ( $Text !~ m{\A [+-]? \d{1,16} \z}xms ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Invalid integer in query '$Text'!",
            );

            return;
        }

        return $Text;
    }

    # quote numbers
    if ( $Type eq 'Number' ) {
        if ( $Text !~ m{ \A [+-]? \d{1,20} (?:\.\d{1,20})? \z}xms ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Invalid number in query '$Text'!",
            );

            return;
        }

        return $Text;
    }

    # quote like strings
    if ( $Type eq 'Like' ) {
        return ${ $Self->{Backend}->Quote( \$Text, $Type ) };
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Caller   => 1,
        Priority => 'error',
        Message  => "Invalid quote type '$Type'!",
    );

    return;
}

=head2 Error()

to retrieve database errors

    my $ErrorMessage = $DBObject->Error();

=cut

sub Error {
    my $Self = shift;

    return $DBI::errstr;
}

=head2 Do()

to insert, update or delete values

    my $InsertSuccess = $DBObject->Do( SQL => "INSERT INTO table (name) VALUES ('dog')" );

    my $DeleteSuccess = $DBObject->Do( SQL => "DELETE FROM table" );

you also can use DBI bind values (used for large strings):

    my $Var1 = 'dog1';
    my $Var2 = 'dog2';

    my $InsertSuccess = $DBObject->Do(
        SQL  => "INSERT INTO table (name1, name2) VALUES (?, ?)",
        Bind => [ \$Var1, \$Var2 ],
    );

The special value B<current_timestamp> is replaced by the current date and time.

Returns 1 in the case of success, an empty list in the case of failure.

=cut

sub Do {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{SQL} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SQL!',
        );

        return;
    }

    # check bind params
    my @Array;
    if ( $Param{Bind} ) {
        for my $Data ( $Param{Bind}->@* ) {
            if ( ref $Data eq 'SCALAR' ) {
                push @Array, $$Data;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Caller   => 1,
                    Priority => 'Error',
                    Message  => 'No SCALAR param in Bind!',
                );

                return;
            }
        }
    }

    # Replace current_timestamp with real time stamp.
    # - This avoids time inconsistencies of app and db server
    # - This avoids timestamp problems in Postgresql servers where
    #   the timestamp is sometimes 1 second off the perl timestamp.
    # - This might break server side caching of statements
    $Param{SQL} =~ s{
        (?<= \s | \( | , )  # lookbehind
        current_timestamp   # replace current_timestamp by 'yyyy-mm-dd hh:mm:ss'
        (?=  \s | \) | , )  # lookahead
    }
    {
        # Only calculate timestamp if it is really needed (on first invocation or if the system time changed)
        #   for performance reasons.
        my $Epoch = time;
        if (!$Self->{TimestampEpoch} || $Self->{TimestampEpoch} != $Epoch) {
            $Self->{TimestampEpoch} = $Epoch;
            $Self->{Timestamp}      = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();
        }
        "'$Self->{Timestamp}'";
    }exmsg;

    # debug
    if ( $Self->{Debug} > 0 ) {
        $Self->{DoCounter}++;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => "DB.pm->Do ($Self->{DoCounter}) SQL: '$Param{SQL}'",
        );
    }

    return unless $Self->Connect;

    # send sql to database
    if ( !$Self->{dbh}->do( $Param{SQL}, undef, @Array ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'error',
            Message  => "$DBI::errstr, SQL: '$Param{SQL}'",
        );

        return;
    }

    return 1;
}

=head2 DoArray()

to insert, update or delete multiple values. There are two variants. You can bind the column arrays.
For convenience, when a plain scalar is bound, then it is used for all rows.

    my @Dogs   = qw(Ferdinand Wastl Bello);
    my @Owners = qw(Madleine Ferdinand Jaques);

    my $NumInserts = $DBObject->DoArray(
        SQL  => "INSERT INTO dogs (name, relation, owner) VALUES (?, ?, ?)",
        Bind => [ \@Dogs, 'is owned by', \@Owners ],
    );

A subroutine that generates the rows can be passed.

    my $FetchTuple = sub {
        state $Index = -1;
        my @Dogs = (
            [ 'Maxl', 'loves', 'Michaela' ],
            [ 'Wussel', 'loves', 'Michaela' ],
        );

        $Index++;

        return if $Index >= 2;
        return $Dogs[$Index];
    };

    my $NumInserts = $DBObject->DoArray(
        SQL             => "INSERT INTO dogs (name, relation, owner) VALUES (?, ?, ?)",
        ArrayTupleFetch => $FetchTuple,
    );

=cut

sub DoArray {
    my ( $Self, %Param ) = @_;

    my $BindVariables = $Self->Prepare(
        %Param,
        DoArray => 1,
        Execute => 0,
    );

    return unless $BindVariables;                  # note that [] is also a true value
    return unless ref $BindVariables eq 'ARRAY';

    # the statement handle has been prepared in Prepare()

    # support the attribute ArrayTupleFetch
    my %Attributes = ( ArrayTupleStatus => \my @TupleStatus );
    if ( $Param{ArrayTupleFetch} ) {
        $Attributes{ArrayTupleFetch} = $Param{ArrayTupleFetch};
    }

    # return the number of handled tuples
    return scalar $Self->{Cursor}->execute_array(
        \%Attributes,
        $BindVariables->@*
    );
}

sub _InitMirrorDB {
    my ( $Self, %Param ) = @_;

    # Run only once!
    # Report whether a mirror DB could be created in the initial call.
    return ( $Self->{MirrorDBObject} ? 1 : 0 ) if $Self->{_InitMirrorDB}++;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MasterDSN    = $ConfigObject->Get('DatabaseDSN');

    # Don't create mirror if we are already in a mirror, or if we are not in the master,
    #   such as in an external customer user database handle.
    if ( $Self->{IsMirrorDB} || $MasterDSN ne $Self->{DSN} ) {
        return $Self->{MirrorDBObject};
    }

    my %MirrorDBConfiguration = (
        %{ $ConfigObject->Get('Core::MirrorDB::AdditionalMirrors') // {} },
        0 => {
            DSN      => $ConfigObject->Get('Core::MirrorDB::DSN'),
            User     => $ConfigObject->Get('Core::MirrorDB::User'),
            Password => $ConfigObject->Get('Core::MirrorDB::Password'),
        }
    );

    INDEX:
    for my $Index ( shuffle keys %MirrorDBConfiguration ) {

        my %MirrorDBConfig = %{ $MirrorDBConfiguration{$Index} // {} };

        # If a mirror is configured and it is not already used in the current object
        #   and we are actually in the master connection object: then create a mirror.
        next INDEX unless %MirrorDBConfig;
        next INDEX unless $MirrorDBConfig{DSN};
        next INDEX unless $MirrorDBConfig{User};
        next INDEX unless $MirrorDBConfig{Password};

        # Create a new DB object for the mirror.
        # Mark it as already being a mirror, so that no further mirror DB objects are created.
        my $MirrorDBObject = Kernel::System::DB->new(
            DatabaseDSN  => $MirrorDBConfig{DSN},
            DatabaseUser => $MirrorDBConfig{User},
            DatabasePw   => $MirrorDBConfig{Password},
            IsMirrorDB   => 1,
        );

        # work is done when connecting to the mirror DB worked
        # otherwise try the next mirror DB config
        if ( $MirrorDBObject->Connect ) {
            $Self->{MirrorDBObject} = $MirrorDBObject;

            return 1;
        }

        # try the next mirror DB configuration if there is one
    }

    # no mirror DB was configured or connect wasn't possible,
    # $Self->{MirrorDBObject} remains undefined
    return 0;
}

=head2 Prepare()

prepares and executes a SELECT statement.

    my $Success = $DBObject->Prepare(
        SQL   => 'SELECT id, name FROM table',
        Limit => 10,
    );

Or in case you want just to get row 10 until 30:

    my $Success = $DBObject->Prepare(
        SQL   => 'SELECT id, name FROM table',
        Start => 10,
        Limit => 20,
    );

In case you don't want utf-8 encoding for some columns, use this:

    my $Success = $DBObject->Prepare(
        SQL    => 'SELECT id, name, content FROM table',
        Encode => [ 1, 1, 0 ],
    );

Using bind variables is recommended:

    my $Var1 = 'dog1';
    my $Var2 = 'dog2';

    my $Success = $DBObject->Prepare(
        SQL    => 'SELECT id, name, content FROM table WHERE name_a = ? AND name_b = ?',
        Encode => [ 1, 1, 0 ],
        Bind   => [ \($Var1, $Var2) ],
    );

These are the regular use cases where C<1> is returned in the case of success. C<undef> is returned
when there was an error. The result of the SELECT can be retrieved with C<FetchrowArray()>.

This method is also used internally for methods that want to execute the prepared statement by themselves.
This case is triggered by passing the parameter C<Execute> with the value C<0>. The returned value
is C<undef> in case of error and an arrayref in case of success.
The returned arrayref contains the bind variables like they are used in C<DBI>.
Internally, the attribute C<Cursor> will be set to the prepared statement handle.

    my $Var1 = 'dog1';
    my $Var2 = 'dog2';

    my $BindVariables = $DBObject->Prepare(
        SQL    => 'SELECT id, name, content FROM table WHERE name_a = ? AND name_b = ?',
        Bind   => [ \($Var1, $Var2) ],
    );

will return

    my $BindVariables = ['dog1', 'dog2'];

In the case of an error:

    my $BindVariables = undef;

Another internally used parameter is C<DoArray>. That parameter indicates that the array bind values are used.

=cut

sub Prepare {
    my ( $Self, %Param ) = @_;

    # extract parameters and set defaults
    my $SQL     = $Param{SQL};
    my $Limit   = $Param{Limit} || '';
    my $Start   = $Param{Start} || '';
    my $Execute = $Param{Execute} // 1;    # executing the passed SQL is the default
    my $DoArray = $Param{DoArray} // 0;

    # check needed stuff
    if ( !$Param{SQL} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need SQL!',
        );

        return;
    }

    if ( $Param{Bind} && ref $Param{Bind} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Bind must be an array reference!',
        );
    }

    $Self->{_PreparedOnMirrorDB} = 0;

    # Route SELECT statements to the DB mirror if requested and a mirror is configured.
    if (
        $UseMirrorDB
        && !$Self->{IsMirrorDB}
        && $SQL =~ m{\A\s*SELECT}xms    # note that 'select' in lower case does not work
        && $Self->_InitMirrorDB         # this is very cheap after the first call (cached)
        )
    {
        $Self->{_PreparedOnMirrorDB} = 1;

        return $Self->{MirrorDBObject}->Prepare(%Param);
    }

    $Self->{Encode}       = $Param{Encode};
    $Self->{Limit}        = 0;
    $Self->{LimitStart}   = 0;
    $Self->{LimitCounter} = 0;

    # build final select query
    if ($Limit) {
        if ($Start) {
            $Limit = $Limit + $Start;
            $Self->{LimitStart} = $Start;            # for some reason "LIMIT  100, 10" is not supported
        }
        if ( $Self->{Backend}->{'DB::Limit'} eq 'limit' ) {
            $SQL .= " LIMIT $Limit";
        }
        elsif ( $Self->{Backend}->{'DB::Limit'} eq 'top' ) {
            $SQL =~ s{ \A \s* (SELECT ([ ]DISTINCT|)) }{$1 TOP $Limit}xmsi;
        }
        else {

            # workaround for Oracle
            $Self->{Limit} = $Limit;
        }
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Self->{PrepareCounter}++;
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => "DB.pm->Prepare ($Self->{PrepareCounter}/" . time() . ") SQL: '$SQL'",
        );
    }

    # slow log feature
    my $LogTime;
    if ( $Self->{SlowLog} ) {
        $LogTime = time();
    }

    # check bind params
    my @BindVariables;
    if ( $Param{Bind} ) {
        my %RefIsValid = map { $_ => 1 } $DoArray ? ( 'ARRAY', '' ) : ('SCALAR');
        for my $Data ( $Param{Bind}->@* ) {
            my $RefType = ref $Data;
            if ( $RefIsValid{$RefType} ) {
                push @BindVariables, $DoArray ? $Data : $Data->$*;
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Caller   => 1,
                    Priority => 'Error',
                    Message  => qq{Invalid reference type '$RefType' in Bind!},
                );

                return;
            }
        }
    }

    return unless $Self->Connect;

    # prepare a statement handle and store it in $Self->{Cursor}
    if ( !( $Self->{Cursor} = $Self->{dbh}->prepare($SQL) ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => "$DBI::errstr, SQL: '$SQL'",
        );

        return;
    }

    # This is only for internal use, like for SelectColArray(), SelectRowArray(), SelectMapping()
    if ( !$Execute ) {
        return \@BindVariables;    # always a true value
    }

    # execute the statement handle
    if ( !$Self->{Cursor}->execute(@BindVariables) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'Error',
            Message  => "$DBI::errstr, SQL: '$SQL'",
        );

        return;
    }

    # slow log feature
    if ( $Self->{SlowLog} ) {
        my $LogTimeTaken = time() - $LogTime;
        if ( $LogTimeTaken > 4 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Caller   => 1,
                Priority => 'error',
                Message  => "Slow ($LogTimeTaken s) SQL: '$SQL'",
            );
        }
    }

    return 1;
}

=head2 FetchrowArray()

to process the results of a SELECT statement.

    $DBObject->Prepare(
        SQL   => "SELECT id, name FROM table",
        Limit => 10
    );

    while (my ($ID, $Name) = $DBObject->FetchrowArray) {
        print "$ID:$Name\n";
    }

Note that while we are within a fetch loop, no other database interaction may take place.

=cut

sub FetchrowArray {
    my $Self = shift;

    if ( $Self->{_PreparedOnMirrorDB} ) {
        return $Self->{MirrorDBObject}->FetchrowArray();
    }

    # work with cursors if database don't support limit, e.g. Oracle prior to 12c
    if ( !$Self->{Backend}->{'DB::Limit'} && $Self->{Limit} ) {
        if ( $Self->{Limit} <= $Self->{LimitCounter} ) {
            $Self->{Cursor}->finish;

            return;
        }
        $Self->{LimitCounter}++;
    }

    # fetch first not used rows
    if ( $Self->{LimitStart} ) {
        for ( 1 .. $Self->{LimitStart} ) {
            if ( !$Self->{Cursor}->fetchrow_array() ) {
                $Self->{LimitStart} = 0;

                return ();
            }
            $Self->{LimitCounter}++;
        }
        $Self->{LimitStart} = 0;
    }

    # fetch the data from the DB
    my @Row = $Self->{Cursor}->fetchrow_array();

    # The fetched row might be tweaked here
    $Self->_EncodeInputList( \@Row );

    return @Row;
}

=head2 ListTables()

list all tables in the OTOBO database.

    my @Tables = $DBObject->ListTables();

On databases like Oracle it could happen that too many tables are listed (all belonging
to the current user), if the user also has permissions for other databases. So this list
should only be used for verification of the presence of expected OTOBO tables.

The table names are lower cased.

=cut

sub ListTables {
    my $Self = shift;

    my $SQL = $Self->GetDatabaseFunction('ListTables');

    if ( !$SQL ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => "Database driver $Self->{'DB::Type'} does not support ListTables.",
        );

        return;
    }

    my $Success = $Self->Prepare(
        SQL => $SQL,
    );

    return unless $Success;

    my @Tables;
    while ( my ($Table) = $Self->FetchrowArray ) {
        push @Tables, lc $Table;
    }

    return @Tables;
}

=head2 GetColumnNames()

to retrieve the column names of a database statement

    $DBObject->Prepare(
        SQL   => "SELECT * FROM table",
        Limit => 10
    );

    my @Names = $DBObject->GetColumnNames();

=cut

sub GetColumnNames {
    my $Self = shift;

    my $ColumnNames = $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( $Self->{Cursor}->{NAME} );

    my @Result;
    if ( IsArrayRefWithData($ColumnNames) ) {
        @Result = @{$ColumnNames};
    }

    return @Result;
}

=head2 SelectAll()

returns all available records returned by a SELECT statement.
You can pass the same arguments as to the Prepare() method.

The method uses the C<DBI> method C<selectall_arrayref>.
This is equivalent this calling C<Prepare()> and then C<FetchrowArray()> in a loop to get all records.

    my $ResultAsArrayRef = $DBObject->SelectAll(
        SQL   => "SELECT id, name FROM table",
        Limit => 4,
    );

Returns undef (if query failed), or a reference to an array of array references if the query was successful:

    my $ResultAsArrayRef = [
        [ 1, 'itemOne' ],
        [ 2, 'itemTwo' ],
        [ 3, 'itemThree' ],
        [ 4, 'itemFour' ],
    ];

=cut

sub SelectAll {
    my ( $Self, %Param ) = @_;

    my $BindVariables = $Self->Prepare(
        %Param,
        Execute => 0,
    );

    return unless $BindVariables;                  # note that [] is also a true value
    return unless ref $BindVariables eq 'ARRAY';

    # the statement handle has been prepared in Prepare()
    my $Matrix = $Self->{dbh}->selectall_arrayref(
        $Self->{Cursor},    # the prepared statement handle
        {},                 # no attributes
        $BindVariables->@*
    );

    return unless defined $Matrix;
    return unless ref $Matrix eq 'ARRAY';

    # The fetched rows might be tweaked here
    for my $Row ( $Matrix->@* ) {
        $Self->_EncodeInputList($Row);
    }

    return $Matrix;
}

=head2 SelectRowArray()

returns the first available record of a SELECT statement.
In essence, this calls C<Prepare()> and then C<FetchrowArray()> once to get the first record.
In all cases C<finish()> is called on the statement handle. This means that no
further rows can be retrieved with C<FetchrowArray>.

    my ($ID, $Name) = $DBObject->SelectRowArray(
        SQL   => "SELECT id, name FROM table",
    );

You can pass the same arguments as to the Prepare() method.

Returns undef if the query failed, or a list if the query was successful:

    my ($ID, $Name) = (1, 'first');

=cut

sub SelectRowArray {
    my ( $Self, %Param ) = @_;

    return unless $Self->Prepare(%Param);

    my @Row = $Self->FetchrowArray;

    # release resources from the current statement handle
    if ( $Self->{Cursor} ) {
        $Self->{Cursor}->finish;
    }

    return @Row;
}

=head2 SelectColArray()

returns the first column a SELECT statement.
In essence, this calls C<Prepare()> and then the DBI method C<selectcol_array()> to get the first column.

    my $MinID = 100;
    my @IDs = $DBObject->SelectColArray(
        SQL   => "SELECT id, name FROM table WHERE id >= ? ORDER BY id",
        Bind  => [ \$MinID ],
        Limit => 3,
    );

You can pass the same arguments as to the Prepare() method.

Returns undef if the query failed, or a list if the query was successful:

    my @IDs = (100, 101, 102);

=cut

sub SelectColArray {
    my ( $Self, %Param ) = @_;

    my $BindVariables = $Self->Prepare(
        %Param,
        Execute => 0,
    );

    return unless $BindVariables;                  # note that [] is also a true value
    return unless ref $BindVariables eq 'ARRAY';

    # the statement handle has been prepared in Prepare()
    my $Column = $Self->{dbh}->selectcol_arrayref(
        $Self->{Cursor},    # the prepared statement handle
        {},                 # no attributes
        $BindVariables->@*
    );

    return unless defined $Column;

    # The fetched column might be tweaked here
    $Self->_EncodeInputList($Column);

    return $Column->@*;
}

=head2 SelectMapping()

returns a mapping with the first column as a key for the second column of the SELECT statement.
In essence, this calls C<Prepare()> and then the DBI method C<selectcol_array()>
to get the first two columns.

    my $MinID    = 100;
    my %IDToName = $DBObject->SelectMapping(
        SQL   => "SELECT id, name FROM table WHERE id >= ? ORDER BY id",
        Bind  => [ \$MinID ],
        Limit => 3,
    );

You can pass the same arguments as to the Prepare() method.

Returns undef if the query failed, or a list if the query was successful.
The list can be used for initializing a hash.

    my %IDToName = (
        100 = 'one hundred',
        101 = 'one hundred and one',
        102 = 'one hundred and two',
    );

=cut

sub SelectMapping {
    my ( $Self, %Param ) = @_;

    my $BindVariables = $Self->Prepare(
        %Param,
        Execute => 0,
    );

    return unless $BindVariables;                  # note that [] is also a true value
    return unless ref $BindVariables eq 'ARRAY';

    # The statement handle has been prepared in Prepare().
    # selectcol_arrayref() returns the first column zipped with the second column,
    # that is exactly what we need here.
    my $List = $Self->{dbh}->selectcol_arrayref(
        $Self->{Cursor},    # the prepared statement handle
        {
            Columns => [ 1, 2 ],
        },
        $BindVariables->@*
    );

    return unless defined $List;

    # The fetched row might be tweaked here
    $Self->_EncodeInputList($List);

    return $List->@*;
}

=head2 GetDatabaseFunction()

to get database functions like

    - Attribute
    - CaseSensitive
    - Comment
    - Connect
    - CurrentTimestamp
    - DeactivateForeignKeyChecks
    - DirectBlob
    - Encode
    - LikeEscapeString
    - Limit
    - ListTables
    - PurgeTable
    - QuoteBack
    - QuoteSemicolon
    - QuoteSingle
    - QuoteUnderscoreEnd
    - QuoteUnderscoreStart
    - ShellCommit
    - ShellConnect
    - Substring
    - Version

    my $What = $DBObject->GetDatabaseFunction('DirectBlob');

Returns undef when the requested function is not available for the database driver.

=cut

sub GetDatabaseFunction {
    my ( $Self, $What ) = @_;

    return $Self->{Backend}->{ 'DB::' . $What };
}

=head2 SQLProcessor()

generate database-specific sql syntax (e. g. CREATE TABLE ...)

    my @SQL = $DBObject->SQLProcessor(
        Database => [
            {
                Tag  => 'TableCreate',
                Name => 'table_name',
            },
            {
                Tag  => 'Column',
                Name => 'col_name',
                Type => 'VARCHAR',
                Size => 150,
            },
            {
                Tag  => 'Column',
                Name => 'col_name2',
                Type => 'INTEGER',
            },
            {
                Tag => 'TableEnd',
            },
        ]
    );

=cut

sub SQLProcessor {
    my ( $Self, %Param ) = @_;

    my @SQL;
    if ( $Param{Database} && ref $Param{Database} eq 'ARRAY' ) {

        # make a deep copy in order to prevent modyfing the input data
        # see also Bug#12764 - Database function SQLProcessor() modifies given parameter data
        # https://bugs.otrs.org/show_bug.cgi?id=12764
        my @Database = @{
            $Kernel::OM->Get('Kernel::System::Storable')->Clone(
                Data => $Param{Database},
            )
        };

        my @Table;
        for my $Tag (@Database) {

            # create table
            if ( $Tag->{Tag} eq 'Table' || $Tag->{Tag} eq 'TableCreate' ) {
                if ( $Tag->{TagType} eq 'Start' ) {
                    $Self->_NameCheck($Tag);
                }
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @SQL, $Self->{Backend}->TableCreate(@Table);
                    @Table = ();
                }
            }

            # unique
            elsif (
                $Tag->{Tag} eq 'Unique'
                || $Tag->{Tag} eq 'UniqueCreate'
                || $Tag->{Tag} eq 'UniqueDrop'
                )
            {
                push @Table, $Tag;
            }

            elsif ( $Tag->{Tag} eq 'UniqueColumn' ) {
                push @Table, $Tag;
            }

            # index
            elsif (
                $Tag->{Tag} eq 'Index'
                || $Tag->{Tag} eq 'IndexCreate'
                || $Tag->{Tag} eq 'IndexDrop'
                )
            {
                push @Table, $Tag;
            }

            elsif ( $Tag->{Tag} eq 'IndexColumn' ) {
                push @Table, $Tag;
            }

            # foreign keys
            elsif (
                $Tag->{Tag} eq 'ForeignKey'
                || $Tag->{Tag} eq 'ForeignKeyCreate'
                || $Tag->{Tag} eq 'ForeignKeyDrop'
                )
            {
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'Reference' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
            }

            # alter table
            elsif ( $Tag->{Tag} eq 'TableAlter' ) {
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @SQL, $Self->{Backend}->TableAlter(@Table);
                    @Table = ();
                }
            }

            # column
            elsif ( $Tag->{Tag} eq 'Column' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnAdd' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnChange' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }
            elsif ( $Tag->{Tag} eq 'ColumnDrop' && $Tag->{TagType} eq 'Start' ) {

                # type check
                $Self->_TypeCheck($Tag);
                push @Table, $Tag;
            }

            # drop table
            elsif ( $Tag->{Tag} eq 'TableDrop' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
                push @SQL,   $Self->{Backend}->TableDrop(@Table);
                @Table = ();
            }

            # insert
            elsif ( $Tag->{Tag} eq 'Insert' ) {
                push @Table, $Tag;
                if ( $Tag->{TagType} eq 'End' ) {
                    push @Table, $Tag;
                    push @SQL,   $Self->{Backend}->Insert(@Table);
                    @Table = ();
                }
            }
            elsif ( $Tag->{Tag} eq 'Data' && $Tag->{TagType} eq 'Start' ) {
                push @Table, $Tag;
            }
        }
    }

    return @SQL;
}

=head2 SQLProcessorPost()

generate database-specific sql syntax, post data of SQLProcessor(),
e. g. foreign keys

    my @SQL = $DBObject->SQLProcessorPost();

=cut

sub SQLProcessorPost {
    my ( $Self, %Param ) = @_;

    if ( $Self->{Backend}->{Post} ) {
        my @Return = @{ $Self->{Backend}->{Post} };
        undef $Self->{Backend}->{Post};

        return @Return;
    }

    return ();
}

=head2 QueryCondition()

generate SQL condition query based on a search expression

    my $SQL = $DBObject->QueryCondition(
        Key   => 'some_col',
        Value => '(ABC+DEF)',
    );

add SearchPrefix and SearchSuffix to search, in this case
for "(ABC*+DEF*)"

    my $SQL = $DBObject->QueryCondition(
        Key          => 'some_col',
        Value        => '(ABC+DEF)',
        SearchPrefix => '',
        SearchSuffix => '*'
        Extended     => 1, # use also " " as "&&", e.g. "bob smith" -> "bob&&smith"
    );

example of a more complex search condition

    my $SQL = $DBObject->QueryCondition(
        Key   => 'some_col',
        Value => '((ABC&&DEF)&&!GHI)',
    );

for a search condition over more columns

    my $SQL = $DBObject->QueryCondition(
        Key   => [ 'some_col_a', 'some_col_b' ],
        Value => '((ABC&&DEF)&&!GHI)',
    );

Returns the SQL string or "1=0" if the query could not be parsed correctly.

    my $SQL = $DBObject->QueryCondition(
        Key      => [ 'some_col_a', 'some_col_b' ],
        Value    => '((ABC&&DEF)&&!GHI)',
        BindMode => 1,
    );

return the SQL String with ?-values and a array with values references:

    $BindModeResult = (
        'SQL'    => 'WHERE testa LIKE ? AND testb NOT LIKE ? AND testc = ?'
        'Values' => ['a', 'b', 'c'],
    )

Note that the comparisons are usually performed case insensitively.
Only C<VARCHAR> columns with a size less or equal 3998 are supported,
as for locator objects the functioning of SQL function C<LOWER()> can't
be guaranteed.

=cut

sub QueryCondition {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key Value)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );

            return;
        }
    }

    # get like escape string needed for some databases (e.g. oracle)
    my $LikeEscapeString = $Self->GetDatabaseFunction('LikeEscapeString');

    # search prefix/suffix check
    my $SearchPrefix  = $Param{SearchPrefix}  || '';
    my $SearchSuffix  = $Param{SearchSuffix}  || '';
    my $CaseSensitive = $Param{CaseSensitive} || 0;
    my $BindMode      = $Param{BindMode}      || 0;
    my @BindValues;

    # remove leading/trailing spaces
    $Param{Value} =~ s/^\s+//g;
    $Param{Value} =~ s/\s+$//g;

    # add base brackets
    if ( $Param{Value} !~ /^(?<!\\)\(/ || $Param{Value} !~ /(?<!\\)\)$/ ) {
        $Param{Value} = '(' . $Param{Value} . ')';
    }

    # quote ".+?" expressions
    # for example ("some and me" AND !some), so "some and me" is used for search 1:1
    my $Count = 0;
    my %Expression;
    $Param{Value} =~ s{
        "(.+?)"
    }
    {
        $Count++;
        my $Item = $1;
        $Expression{"###$Count###"} = $Item;
        "###$Count###";
    }egx;

    # remove empty parentheses
    $Param{Value} =~ s/(?<!\\)\(\s*(?<!\\)\)//g;

    # remove double spaces
    $Param{Value} =~ s/\s+/ /g;

    # replace + by &&
    $Param{Value} =~ s/\+/&&/g;

    # replace AND by &&
    $Param{Value} =~ s/(\s|(?<!\\)\)|(?<!\\)\()AND(\s|(?<!\\)\(|(?<!\\)\))/$1&&$2/g;

    # replace OR by ||
    $Param{Value} =~ s/(\s|(?<!\\)\)|(?<!\\)\()OR(\s|(?<!\\)\(|(?<!\\)\))/$1||$2/g;

    # replace * with % (for SQL)
    $Param{Value} =~ s/\*/%/g;

    # remove double %% (also if there is only whitespace in between)
    $Param{Value} =~ s/%\s*%/%/g;

    # replace '%!%' by '!%' (done if * is added by search frontend)
    $Param{Value} =~ s/\%!\%/!%/g;

    # replace '%!' by '!%' (done if * is added by search frontend)
    $Param{Value} =~ s/\%!/!%/g;

    # remove leading/trailing conditions
    $Param{Value} =~ s/(&&|\|\|)(?<!\\)\)$/)/g;
    $Param{Value} =~ s/^(?<!\\)\((&&|\|\|)/(/g;

    # clean up not needed spaces in condistions
    # removed spaces examples
    # [SPACE](, [SPACE]), [SPACE]|, [SPACE]&
    # example not removed spaces
    # [SPACE]\\(, [SPACE]\\), [SPACE]\\&
    $Param{Value} =~ s{(
        \s
        (
              (?<!\\) \(
            | (?<!\\) \)
            |         \|
            | (?<!\\) &
        )
    )}{$2}xg;

    # removed spaces examples
    # )[SPACE], )[SPACE], |[SPACE], &[SPACE]
    # example not removed spaces
    # \\([SPACE], \\)[SPACE], \\&[SPACE]
    $Param{Value} =~ s{(
        (
              (?<!\\) \(
            | (?<!\\) \)
            |         \|
            | (?<!\\) &
        )
        \s
    )}{$2}xg;

    # use extended condition mode
    # 1. replace " " by "&&"
    if ( $Param{Extended} ) {
        $Param{Value} =~ s/\s/&&/g;
    }

    # get col.
    my @Keys;
    if ( ref $Param{Key} eq 'ARRAY' ) {
        @Keys = @{ $Param{Key} };
    }
    else {
        @Keys = ( $Param{Key} );
    }

    # for syntax check
    my $Open  = 0;
    my $Close = 0;

    # for processing
    my @Array     = split //, $Param{Value};
    my $SQL       = '';
    my $Word      = '';
    my $Not       = 0;
    my $Backslash = 0;

    my $SpecialCharacters = $Self->_SpecialCharactersGet();

    POSITION:
    for my $Position ( 0 .. $#Array ) {

        # find word
        if ($Backslash) {
            $Word .= $Array[$Position];
            $Backslash = 0;
            next POSITION;
        }

        # remember if next token is a part of word
        elsif (
            $Array[$Position] eq '\\'
            && $Position < $#Array
            && (
                $SpecialCharacters->{ $Array[ $Position + 1 ] }
                || $Array[ $Position + 1 ] eq '\\'
            )
            )
        {
            $Backslash = 1;
            next POSITION;
        }

        # remember if it's a NOT condition
        elsif ( $Word eq '' && $Array[$Position] eq '!' ) {
            $Not = 1;
            next POSITION;
        }
        elsif ( $Array[$Position] eq '&' ) {
            if ( $Position >= 1 && $Array[ $Position - 1 ] eq '&' ) {
                next POSITION;
            }
            if ( $Position == $#Array || $Array[ $Position + 1 ] ne '&' ) {
                $Word .= $Array[$Position];
                next POSITION;
            }
        }
        elsif ( $Array[$Position] eq '|' ) {
            if ( $Position >= 1 && $Array[ $Position - 1 ] eq '|' ) {
                next POSITION;
            }
            if ( $Position == $#Array || $Array[ $Position + 1 ] ne '|' ) {
                $Word .= $Array[$Position];
                next POSITION;
            }
        }
        elsif ( !$SpecialCharacters->{ $Array[$Position] } ) {
            $Word .= $Array[$Position];
            next POSITION;
        }

        # if word exists, do something with it
        if ( $Word ne '' ) {

            # remove escape characters from $Word
            $Word =~ s{\\}{}smxg;

            # replace word if it's an "some expression" expression
            if ( $Expression{$Word} ) {
                $Word = $Expression{$Word};
            }

            # database quote
            $Word = $SearchPrefix . $Word . $SearchSuffix;
            $Word =~ s/\*/%/g;
            $Word =~ s/%%/%/g;
            $Word =~ s/%%/%/g;

            # perform quoting depending on query type (only if not in bind mode)
            if ( !$BindMode ) {
                if ( $Word =~ m/%/ ) {
                    $Word = $Self->Quote( $Word, 'Like' );
                }
                else {
                    $Word = $Self->Quote($Word);
                }
            }

            # if it's a NOT LIKE condition
            if ($Not) {
                $Not = 0;

                my $SQLA;
                for my $Key (@Keys) {
                    if ($SQLA) {
                        $SQLA .= ' AND ';
                    }

                    # check if like is used
                    my $Type = 'NOT LIKE';
                    if ( $Word !~ m/%/ ) {
                        $Type = '!=';
                    }

                    my $WordSQL = $Word;
                    if ($BindMode) {
                        $WordSQL = "?";
                    }
                    else {
                        $WordSQL = "'" . $WordSQL . "'";
                    }

                    # check if database supports LIKE in large text types
                    # the first condition is a little bit opaque
                    # CaseSensitive of the database defines, if the database handles case sensitivity or not
                    # and the parameter $CaseSensitive defines, if the customer database should do case sensitive statements or not.
                    # so if the database dont support case sensitivity or the configuration of the customer database want to do this
                    # then we prevent the LOWER() statements.
                    if ( !$Self->GetDatabaseFunction('CaseSensitive') || $CaseSensitive ) {
                        $SQLA .= "$Key $Type $WordSQL";
                    }
                    elsif ( $Self->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                        $SQLA .= "LCASE($Key) $Type LCASE($WordSQL)";
                    }
                    else {
                        $SQLA .= "LOWER($Key) $Type LOWER($WordSQL)";
                    }

                    if ( $Type eq 'NOT LIKE' ) {
                        $SQLA .= " $LikeEscapeString";
                    }

                    if ($BindMode) {
                        push @BindValues, $Word;
                    }
                }
                $SQL .= '(' . $SQLA . ') ';
            }

            # if it's a LIKE condition
            else {
                my $SQLA;
                for my $Key (@Keys) {
                    if ($SQLA) {
                        $SQLA .= ' OR ';
                    }

                    # check if like is used
                    my $Type = 'LIKE';
                    if ( $Word !~ m/%/ ) {
                        $Type = '=';
                    }

                    my $WordSQL = $Word;
                    if ($BindMode) {
                        $WordSQL = "?";
                    }
                    else {
                        $WordSQL = "'" . $WordSQL . "'";
                    }

                    # check if database supports LIKE in large text types
                    # the first condition is a little bit opaque
                    # CaseSensitive of the database defines, if the database handles case sensitivity or not
                    # and the parameter $CaseSensitive defines, if the customer database should do case sensitive statements or not.
                    # so if the database dont support case sensitivity or the configuration of the customer database want to do this
                    # then we prevent the LOWER() statements.
                    if ( !$Self->GetDatabaseFunction('CaseSensitive') || $CaseSensitive ) {
                        $SQLA .= "$Key $Type $WordSQL";
                    }
                    elsif ( $Self->GetDatabaseFunction('LcaseLikeInLargeText') ) {
                        $SQLA .= "LCASE($Key) $Type LCASE($WordSQL)";
                    }
                    else {
                        $SQLA .= "LOWER($Key) $Type LOWER($WordSQL)";
                    }

                    if ( $Type eq 'LIKE' ) {
                        $SQLA .= " $LikeEscapeString";
                    }

                    if ($BindMode) {
                        push @BindValues, $Word;
                    }
                }
                $SQL .= '(' . $SQLA . ') ';
            }

            # reset word
            $Word = '';
        }

        # check AND and OR conditions
        if ( $Array[ $Position + 1 ] ) {

            # if it's an AND condition
            if ( $Array[$Position] eq '&' && $Array[ $Position + 1 ] eq '&' ) {
                if ( $SQL =~ m/ OR $/ ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'notice',
                        Message  =>
                            "Invalid condition '$Param{Value}', simultaneous usage both AND and OR conditions!",
                    );

                    return "1=0";
                }
                elsif ( $SQL !~ m/ AND $/ ) {
                    $SQL .= ' AND ';
                }
            }

            # if it's an OR condition
            elsif ( $Array[$Position] eq '|' && $Array[ $Position + 1 ] eq '|' ) {
                if ( $SQL =~ m/ AND $/ ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'notice',
                        Message  =>
                            "Invalid condition '$Param{Value}', simultaneous usage both AND and OR conditions!",
                    );

                    return "1=0";
                }
                elsif ( $SQL !~ m/ OR $/ ) {
                    $SQL .= ' OR ';
                }
            }
        }

        # add ( or ) for query
        if ( $Array[$Position] eq '(' ) {
            if ( $SQL ne '' && $SQL !~ /(?: (?:AND|OR) |\(\s*)$/ ) {
                $SQL .= ' AND ';
            }
            $SQL .= $Array[$Position];

            # remember for syntax check
            $Open++;
        }
        if ( $Array[$Position] eq ')' ) {
            $SQL .= $Array[$Position];
            if (
                $Position < $#Array
                && ( $Position > $#Array - 1 || $Array[ $Position + 1 ] ne ')' )
                && (
                    $Position > $#Array - 2
                    || $Array[ $Position + 1 ] ne '&'
                    || $Array[ $Position + 2 ] ne '&'
                )
                && (
                    $Position > $#Array - 2
                    || $Array[ $Position + 1 ] ne '|'
                    || $Array[ $Position + 2 ] ne '|'
                )
                )
            {
                $SQL .= ' AND ';
            }

            # remember for syntax check
            $Close++;
        }
    }

    # check syntax
    if ( $Open != $Close ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Invalid condition '$Param{Value}', $Open open and $Close close!",
        );
        if ($BindMode) {
            return (
                'SQL'    => "1=0",
                'Values' => [],
            );
        }

        return "1=0";
    }

    if ($BindMode) {
        my $BindRefList = [ map { \$_ } @BindValues ];

        return (
            'SQL'    => $SQL,
            'Values' => $BindRefList,
        );
    }

    return $SQL;
}

=head2 QueryInCondition()

Generate a SQL IN condition query based on the given table key and values.

    my $SQL = $DBObject->QueryInCondition(
        Key       => 'table.column',
        Values    => [ 1, 2, 3, 4, 5, 6 ],
        QuoteType => '(undef|Integer|Number)',
        BindMode  => (0|1),
        Negate    => (0|1),
    );

Returns the SQL string:

    my $SQL = "ticket_id IN (1, 2, 3, 4, 5, 6)"

Return a separated IN condition for more then C<MaxParamCountForInCondition> values:

    my $SQL = "( ticket_id IN ( 1, 2, 3, 4, 5, 6 ... ) OR ticket_id IN ( ... ) )"

Return the SQL String with ?-values and a array with values references in bind mode:

    $BindModeResult = (
        'SQL'    => 'ticket_id IN (?, ?, ?, ?, ?, ?)',
        'Values' => [1, 2, 3, 4, 5, 6],
    );

or

    $BindModeResult = (
        'SQL'    => '( ticket_id IN (?, ?, ?, ?, ?, ?) OR ticket_id IN ( ?, ... ) )',
        'Values' => [1, 2, 3, 4, 5, 6, ... ],
    );

Returns the SQL string for a negated in condition:

    my $SQL = "ticket_id NOT IN (1, 2, 3, 4, 5, 6)"

or

    my $SQL = "( ticket_id NOT IN ( 1, 2, 3, 4, 5, 6 ... ) AND ticket_id NOT IN ( ... ) )"

=cut

sub QueryInCondition {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Key} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Key!",
        );

        return;
    }

    if ( !IsArrayRefWithData( $Param{Values} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Values!",
        );

        return;
    }

    if ( $Param{QuoteType} && $Param{QuoteType} eq 'Like' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "QuoteType 'Like' is not allowed for 'IN' conditions!",
        );

        return;
    }

    $Param{Negate}   //= 0;
    $Param{BindMode} //= 0;

    # Set the flag for string because of the other handling in the sql statement with strings.
    my $IsString = $Param{QuoteType} ? 0 : 1;

    my @Values = @{ $Param{Values} };

    # Perform quoting depending on given quote type (only if not in bind mode)
    if ( !$Param{BindMode} ) {

        # Sort the values to cache the SQL query.
        if ($IsString) {
            @Values = sort { $a cmp $b } @Values;
        }
        else {
            @Values = sort { $a <=> $b } @Values;
        }

        @Values = map { $Self->Quote( $_, $Param{QuoteType} ) } @Values;

        # Something went wrong during the quoting, if the count is not equal.

        return if scalar @Values != scalar @{ $Param{Values} };
    }

    # Set the correct operator and connector (only needed for splitted conditions).
    my $Operator  = 'IN';
    my $Connector = 'OR';

    if ( $Param{Negate} ) {
        $Operator  = 'NOT IN';
        $Connector = 'AND';
    }

    my @SQLStrings;
    my @BindValues;

    # Split IN statement with more than the defined 'MaxParamCountForInCondition' elements in more
    # then one statements combined with OR, because some databases e.g. oracle doesn't support more
    # than 1000 elements for one IN statement.
    while ( scalar @Values ) {

        my @ValuesPart;
        if ( $Self->GetDatabaseFunction('MaxParamCountForInCondition') ) {
            @ValuesPart = splice @Values, 0, $Self->GetDatabaseFunction('MaxParamCountForInCondition');
        }
        else {
            @ValuesPart = splice @Values;
        }

        my $ValueString;
        if ( $Param{BindMode} ) {
            $ValueString = join ', ', ('?') x scalar @ValuesPart;
            push @BindValues, @ValuesPart;
        }
        elsif ($IsString) {
            $ValueString = join ', ', map {"'$_'"} @ValuesPart;
        }
        else {
            $ValueString = join ', ', @ValuesPart;
        }

        push @SQLStrings, "$Param{Key} $Operator ($ValueString)";
    }

    my $SQL = join " $Connector ", @SQLStrings;

    if ( scalar @SQLStrings > 1 ) {
        $SQL = '( ' . $SQL . ' )';
    }

    if ( $Param{BindMode} ) {
        my $BindRefList = [ map { \$_ } @BindValues ];

        return (
            'SQL'    => $SQL,
            'Values' => $BindRefList,
        );
    }

    return $SQL;
}

=head2 QueryStringEscape()

escapes special characters within a query string

    my $QueryStringEscaped = $DBObject->QueryStringEscape(
        QueryString => 'customer with (brackets) and & and -',
    );

Result would be a string in which all special characters are escaped.
Special characters are those which are returned by _SpecialCharactersGet().

    $QueryStringEscaped = 'customer with \(brackets\) and \& and \-';

=cut

sub QueryStringEscape {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(QueryString)) {
        if ( !defined $Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );

            return;
        }
    }

    # Merge all special characters into one string, separated by \\
    my $SpecialCharacters = '\\' . join '\\', keys %{ $Self->_SpecialCharactersGet() };

    # Use above string of special characters as character class
    # note: already escaped special characters won't be escaped again
    $Param{QueryString} =~ s{(?<!\\)([$SpecialCharacters])}{\\$1}smxg;

    return $Param{QueryString};
}

=head2 Ping()

checks if the database is reachable

    my $Success = $DBObject->Ping(
        AutoConnect => 0,  # default 1
    );

=cut

sub Ping {
    my ( $Self, %Param ) = @_;

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Caller   => 1,
            Priority => 'debug',
            Message  => 'DB.pm->Ping',
        );
    }

    if ( !defined $Param{AutoConnect} || $Param{AutoConnect} ) {
        return if !$Self->Connect();
    }
    else {
        return if !$Self->{dbh};
    }

    return $Self->{dbh}->ping;
}

=head2 BeginWork()

start a transaction

    my $Success = $DBObject->BeginWork()

=cut

sub BeginWork {
    my ($Self) = @_;

    # exception when there is no database handle
    return $Self->{dbh}->begin_work;
}

=head2 Rollback()

roll back the current transaction.
Useful only when BeginWork() has been called before.

    my $Success = $DBObject->Rollback()

=cut

sub Rollback {
    my ($Self) = @_;

    my $DatabaseHandle = $Self->{dbh};

    return 1 if !$DatabaseHandle;    # no need to rollback
    return $DatabaseHandle->rollback();
}

=begin Internal:

=cut

# Attention: This method might be used outside this package, despite the prefix '_'
sub _Decrypt {
    my ( $Self, $CryptedPw ) = @_;

    my $Length = length($CryptedPw) * 4;
    my $Pw     = pack "h$Length", $CryptedPw;
    $Pw = unpack "B$Length", $Pw;
    $Pw =~ s/1/A/g;
    $Pw =~ s/0/1/g;
    $Pw =~ s/A/0/g;
    $Pw = pack "B$Length", $Pw;

    return $Pw;
}

# Attention: This method might be used outside this package, despite the prefix '_'
sub _Encrypt {
    my ( $Self, $Pw ) = @_;

    my $Length = length($Pw) * 8;
    chomp $Pw;

    # get bit code
    my $T = unpack( "B$Length", $Pw );

    # crypt bit code
    $T =~ s/1/A/g;
    $T =~ s/0/1/g;
    $T =~ s/A/0/g;

    # get ascii code
    $T = pack( "B$Length", $T );

    # get hex code
    my $H = unpack( "h$Length", $T );

    return $H;
}

sub _TypeCheck {
    my ( $Self, $Tag ) = @_;

    if (
        $Tag->{Type}
        && $Tag->{Type} !~ /^(DATE|SMALLINT|BIGINT|INTEGER|DECIMAL|VARCHAR|LONGBLOB)$/i
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => "Unknown data type '$Tag->{Type}'!",
        );
    }

    return 1;
}

sub _NameCheck {
    my ( $Self, $Tag ) = @_;

    if ( $Tag->{Name} && length $Tag->{Name} > 30 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Error',
            Message  => "Table names should not have more the 30 chars ($Tag->{Name})!",
        );
    }

    return 1;
}

sub _SpecialCharactersGet {
    my ( $Self, %Param ) = @_;

    my %SpecialCharacter = (
        '(' => 1,
        ')' => 1,
        '&' => 1,
        '|' => 1,
    );

    return \%SpecialCharacter;
}

sub _EncodeInputList {
    my ( $Self, $List ) = @_;

    return unless $Self->{Backend}->{'DB::Encode'};    # nothing to do

    # get encode object
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');

    # The values of the row will be changed in this method.
    # e. g. set utf-8 flag
    my $Counter = 0;
    ELEMENT:
    for my $Element ( $List->@* ) {

        next ELEMENT unless defined $Element;

        # $Self->{Encode} might have been set in Prepare()
        if ( !defined $Self->{Encode} || ( $Self->{Encode} && $Self->{Encode}->[$Counter] ) ) {
            $EncodeObject->EncodeInput( \$Element );
        }
    }
    continue {
        $Counter++;
    }

    return;
}

sub DESTROY {
    my $Self = shift;

    # cleanup open statement handle if there is one
    if ( $Self->{Cursor} ) {
        $Self->{Cursor}->finish;
    }

    # persistent connection per default
    if ( $Self->{DisconnectOnDestruction} ) {
        $Self->Disconnect;
    }

    return 1;
}

=end Internal:

=cut

1;
