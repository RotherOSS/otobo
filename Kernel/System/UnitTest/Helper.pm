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

package Kernel::System::UnitTest::Helper;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use File::Path qw(rmtree);

# CPAN modules
use Test2::V0;
use Test2::API qw/context run_subtest/;

# OTOBO modules
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CustomerUser',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storage::S3',
    'Kernel::System::User',
    'Kernel::System::XML',
);

=head1 NAME

Kernel::System::UnitTest::Helper - unit test helper functions

=head2 DESCRIPTION

To be used in test scripts. Cleanup will be triggered in the END block.

=head1 METHODS

=head2 new()

construct a helper object.

    use Kernel::System::UnitTest::RegisterOM;    # Set up $Kernel::OM

    # Do not call Kernel::System::UnitTest::Helper->new(),
    # instead pass params via the ObjectManager.
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::UnitTest::Helper' => {
            RestoreDatabase => 1,    # runs the test in a transaction,
                                     # and roll it back in the destructor
                                     #
                                     # NOTE: Rollback does not work for
                                     # changes in the database layout. If you
                                     # want to do this in your tests, you cannot
                                     # use this option and must handle the rollback
                                     # yourself.
        },
    );

    my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

Valid parameters are:

=over 4

=item SkipSSLVerify

Unset C<$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME}> while this instance exists.

=item UseTmpArticleDir

=item RestoreDatabase

=item DisableAsyncCalls

=back

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = bless {}, $Type;

    # find out whether loader files are stored in S3 or in the file system
    $Self->{S3Active} = $Kernel::OM->Get('Kernel::Config')->Get('Storage::S3::Active') ? 1 : 0;

    # Remove any leftover custom files from aborted previous runs.
    $Self->CustomFileCleanup();

    # set environment variable to skip SSL certificate verification if needed
    if ( $Param{SkipSSLVerify} ) {

        # remember original value, so that it can be reset in DESTROY()
        $Self->{PERL_LWP_SSL_VERIFY_HOSTNAME} = $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME};

        # set environment value to 0
        $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;    ## no critic qw(Variables::RequireLocalizedPunctuationVars)

        $Self->{RestoreSSLVerify} = 1;
    }

    # switch article dir to a temporary one to avoid collisions
    if ( $Param{UseTmpArticleDir} ) {
        $Self->UseTmpArticleDir();
    }

    if ( $Param{RestoreDatabase} ) {
        $Self->{RestoreDatabase} = 1;
        my $StartedTransaction = $Self->BeginWork();
    }

    if ( $Param{DisableAsyncCalls} ) {
        $Self->DisableAsyncCalls();
    }

    return $Self;
}

=head2 GetRandomID()

creates a random ID that can be used in tests as a unique identifier.

The random ID is 20 characters long and starts with I<test>. It is guaranteed that within a test script
this function will never return a duplicate.

Please note that these IDs are not really random and should only be used
to create test data.

=cut

sub GetRandomID {
    my ( $Self, %Param ) = @_;

    return 'test' . $Self->GetRandomNumber();
}

=head2 GetRandomNumber()

creates a random number that can be used in tests as a unique identifier.
The creates random number always has 16 digits.

It is guaranteed that within a test this function will never return a duplicate.

Please note that these numbers are not really random and should only be used
to create test data.

Returns:

    my $UniqueNumber = '8800007901000000';

=cut

sub GetRandomNumber {

    # Use a state variable here (instead of attributes in $Self)
    # to make it work across several unit tests that run during the same second.
    state %GetRandomNumberPrevious;

    # Note: this is a strange formatting that does not preserve sequence of process IDs
    # $$ = 99  gives $PID = '990000'
    # $$ = 100 gives $PID = '100000'
    my $PIDReversed = reverse $$;
    my $PID         = reverse sprintf '%.6d', $PIDReversed;

    my $Prefix = $PID . substr time(), -5, 5;

    return $Prefix . sprintf( '%.05d', ( $GetRandomNumberPrevious{$Prefix}++ || 0 ) );
}

=head2 GetSequentialTwoLetterString()

Give the next item in the sequence from C<AA> to C<ZZ>. The sequence is per process and can't be reset.
An exception is thrown when trying to count over C<ZZ>.

The major use case is to create parts of file names that must be sorted in ASCII order.

=cut

sub GetSequentialTwoLetterString {

    state $NextString = 'AA';

    die "The sequence can't proceed post 'ZZ'" if length $NextString > 2;

    return $NextString++;
}

=head2 TestUserCreate()

creates a test user that can be used in tests. The created user will
be set to invalid automatically during L</DESTROY()>.
The password of the test user is the same as the login name.

In scalar context the method returns the login name of the new user:

    my $TestUserLogin = $Helper->TestUserCreate(
        Groups => ['admin', 'users'],           # optional, list of groups to add this user to (rw rights)
        Language => 'de'                        # optional, defaults to 'en' if not set
    );

In list context the ID of the test user is created as well:

    my ($TestUserLogin, $TestUserID) = $Helper->TestUserCreate(
        Groups   => [users'],           # optional, list of groups to add this user to (rw rights)
        Language => 'fr'                # optional, defaults to 'en' if not set
    );

=cut

sub TestUserCreate {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    # Create test user.
    my $TestUserID;
    my $TestUserLogin;

    # code that emits test events for the subtest
    my $Code = sub {

        # Disable email checks to create new user.
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        local $ConfigObject->{CheckEmailAddresses} = 0;

        COUNT:
        for ( 1 .. 10 ) {

            $TestUserLogin = $Self->GetRandomID();

            $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserAdd(
                UserFirstname => $TestUserLogin,
                UserLastname  => $TestUserLogin,
                UserLogin     => $TestUserLogin,
                UserPw        => $TestUserLogin,
                UserEmail     => $TestUserLogin . '@localunittest.com',
                ValidID       => 1,
                ChangeUserID  => 1,
            );

            last COUNT if $TestUserID;
        }

        bail_out('Could not create test user login') unless $TestUserLogin;
        bail_out('Could not create test user')       unless $TestUserID;

        # looks good so far
        pass("Created test user $TestUserID");

        # Remember UserID of the test user to later set it to invalid
        #   in the destructor.
        $Self->{TestUsers} ||= [];
        push $Self->{TestUsers}->@*, $TestUserID;

        # Add user to groups.
        my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');
        for my $GroupName ( @{ $Param{Groups} || [] } ) {

            my $GroupID = $GroupObject->GroupLookup( Group => $GroupName );
            bail_out("Cannot find group $GroupName") unless $GroupID;

            $GroupObject->PermissionGroupUserAdd(
                GID        => $GroupID,
                UID        => $TestUserID,
                Permission => {
                    ro        => 1,
                    move_into => 1,
                    create    => 1,
                    owner     => 1,
                    priority  => 1,
                    rw        => 1,
                },
                UserID => 1,
            ) || bail_out("Could not add test user $TestUserLogin to group $GroupName");

            pass("Added test user $TestUserLogin to group $GroupName");
        }

        # Set user language.
        my $UserLanguage = $Param{Language} || 'en';
        $Kernel::OM->Get('Kernel::System::User')->SetPreferences(
            UserID => $TestUserID,
            Key    => 'UserLanguage',
            Value  => $UserLanguage,
        );

        note("Set user UserLanguage to $UserLanguage");
    };

    run_subtest(
        'TestUserCreate',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    $Context->release();

    return wantarray ? ( $TestUserLogin, $TestUserID ) : $TestUserLogin;
}

=head2 TestCustomerUserCreate()

creates a test customer user that can be used in tests. It will
be set to invalid automatically during L</DESTROY()>. Returns
the login name of the new customer user, the password is the same.

    my $TestUserLogin = $Helper->TestCustomerUserCreate(
        Language => 'de',   # optional, defaults to 'en' if not set
    );

=cut

sub TestCustomerUserCreate {
    my ( $Self, %Param ) = @_;

    my $Context = context();

    # Create test user.
    my $TestUser;

    my $Code = sub {

        # Disable email checks to create new user.
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        local $ConfigObject->{CheckEmailAddresses} = 0;

        COUNT:
        for ( 1 .. 10 ) {

            my $TestUserLogin = $Self->GetRandomID();

            $TestUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => $TestUserLogin,
                UserLastname   => $TestUserLogin,
                UserCustomerID => $TestUserLogin,
                UserLogin      => $TestUserLogin,
                UserPassword   => $TestUserLogin,
                UserEmail      => $TestUserLogin . '@localunittest.com',
                ValidID        => 1,
                UserID         => 1,
            );

            last COUNT if $TestUser;
        }

        bail_out('Could not create test user') unless $TestUser;
        pass("Created test customer user $TestUser");

        # Remember UserID of the test user to later set it to invalid
        #   in the destructor.
        $Self->{TestCustomerUsers} ||= [];
        push( @{ $Self->{TestCustomerUsers} }, $TestUser );

        # Set customer user language.
        my $UserLanguage = $Param{Language} || 'en';
        $Kernel::OM->Get('Kernel::System::CustomerUser')->SetPreferences(
            UserID => $TestUser,
            Key    => 'UserLanguage',
            Value  => $UserLanguage,
        );

        note("Set customer user UserLanguage to $UserLanguage");
    };

    run_subtest(
        'TestCustomerUsers',
        $Code,
        {
            buffered      => 1,
            inherit_trace => 1
        }
    );

    $Context->release();

    return $TestUser;
}

=head2 BeginWork()

    $Helper->BeginWork()

Starts a database transaction (in order to isolate the test from the static database).

=cut

sub BeginWork {
    my ($Self) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    $DBObject->Connect();

    return $DBObject->BeginWork();
}

=head2 Rollback()

    $Helper->Rollback()

Rolls back the current database transaction.
Should only be called when BeginWork() has been called before.

=cut

sub Rollback {
    my ($Self) = @_;

    return $Kernel::OM->Get('Kernel::System::DB')->Rollback();
}

=head2 GetTestHTTPHostname()

returns a host name for HTTP based tests, possibly including the port.

=cut

sub GetTestHTTPHostname {
    my ( $Self, %Param ) = @_;

    my $Host = $Kernel::OM->Get('Kernel::Config')->Get('TestHTTPHostname');
    return $Host if $Host;

    my $FQDN = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

    # try to resolve fqdn host
    if ( $FQDN ne 'yourhost.example.com' && gethostbyname($FQDN) ) {
        $Host = $FQDN;
    }

    # try to resolve localhost instead
    if ( !$Host && gethostbyname('localhost') ) {
        $Host = 'localhost';
    }

    # use hardcoded localhost ip address
    if ( !$Host ) {
        $Host = '127.0.0.1';
    }

    return $Host;
}

=head2 ConfigSettingChange()

temporarily change a configuration setting system wide to another value.
The setting is changed both in the current ConfigObject and also in the system configuration on disk.

This will be reset when the Helper object is destroyed.

Please note that this will not work correctly in clustered environments.

    $Helper->ConfigSettingChange(
        Valid => 1,            # (optional) enable or disable setting, the default is 1
        Key   => 'MySetting',  # (required) setting name
        Value => { ... } ,     # setting value, will be ignored when the parameter Valid is false
    );

=cut

sub ConfigSettingChange {
    my ( $Self, %Param ) = @_;

    my $Valid = $Param{Valid} // 1;
    my $Key   = $Param{Key};
    my $Value = $Param{Value};

    die "Need 'Key'" unless defined $Key;

    my $RandomNumber = $Self->GetRandomNumber();

    # Also set at runtime in the ConfigObject. This will be destroyed at the end of the unit test.
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => $Key,
        Value => $Valid ? $Value : undef,
    );

    # Generate Perl code that sets the config value
    my $ValueDump;
    {
        my $KeyDump = $Key;
        $KeyDump =~ s|'|\\'|smxg;
        $KeyDump = "\$Self->{'$KeyDump'}";
        $KeyDump =~ s|\#{3}|'}->{'|smxg;

        if ($Valid) {
            $ValueDump = $Kernel::OM->Get('Kernel::System::Main')->Dump($Value);
            $ValueDump //= '';
            $ValueDump =~ s/\$VAR1/$KeyDump/;
        }
        else {
            $ValueDump = "delete $KeyDump;";
        }
    }

    # Generate name like 'ZZZZUnitTestAA30251' and 'ZZZZUnitTestAB30251'.
    # The package names must be in ASCII order so that Kernel::Config::Defaults::new()
    # evaluates them in the same order as they are written.
    # This allows that a test script assigns different values to the same setting while it is running.
    # A pseudo random part is still needed as otherwise differnt processes would overwrite
    # their files.
    my $Identifier  = $Self->GetSequentialTwoLetterString() . $RandomNumber;
    my $PackageName = 'ZZZZUnitTest' . $Identifier;

    my $Code = <<"END_CODE";
# OTOBO config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::$PackageName;
use strict;
use warnings;
no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;
    $ValueDump
}
1;
END_CODE

    return $Self->CustomCodeActivate(
        Identifier => $Identifier,
        Code       => $Code,
    );
}

=head2 CustomCodeActivate()

Temporarily include custom code in the system. For example, you may use this to redefine a
subroutine from another class. This change will persist for remainder of the test.

All code will be removed when the Helper object is destroyed.

Please note that this will not work correctly in clustered environments. But it should
work when syncing via S3 is activated and does work.

Also note that the deployed custom code is only executed when a new instance of Kernel::Config
is created. This is done for every web request. But within a test script you must discard the
config object, so that the object manager has the recreate it.

It is advised that no fancy characters, like B<:>, are used in the identifier. Using B<:> in keys
has caused errors when running with an S3 compatible storage in the backend.

    $Helper->CustomCodeActivate(
        Code => q^
    sub Kernel::Config::Files::ZZZZUnitTestNews::Load {} # no-op, avoid warning logs
    use Kernel::System::WebUserAgent;
    package Kernel::System::WebUserAgent;
    use strict;
    use warnings;
    {
        no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
        sub Request {
            my $JSONString = '{"Results":{},"ErrorMessage":"","Success":1}';
            return (
                Content => \$JSONString,
                Status  => '200 OK',
            );
        }
    }
    1;
    ^,
        Identifier => 'News',   # (optional) Code identifier to include in file name
    );

=cut

sub CustomCodeActivate {
    my ( $Self, %Param ) = @_;

    my $Content    = $Param{Code};
    my $Identifier = $Param{Identifier} || $Self->GetRandomNumber();

    die "Need 'Code'" unless defined $Content;

    my $PackageName = join '', 'ZZZZUnitTest', $Identifier;

    if ( $Self->{S3Active} ) {

        # in the S3 case only write to the S3 compatible storage
        my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');

        my $Key = "Kernel/Config/Files/$PackageName.pm";
        $StorageS3Object->StoreObject(
            Key     => $Key,
            Content => $Content,
        ) || die "Could not write the key $Key to S3";
    }
    else {

        # write the files, expecting the relevant services use the same file system
        my $Home     = $Kernel::OM->Get('Kernel::Config')->Get('Home');
        my $FileName = "$Home/Kernel/Config/Files/$PackageName.pm";
        $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $FileName,
            Mode     => 'utf8',
            Content  => \$Content,
        ) || die "Could not write $FileName";
    }

    # There is no need to restart the webserver as the changed config
    # is picked up by Kernel::Config::new() for every request.
    # Often the test script is not even running on the same machine as the webserver.
    # Or there are multiple web server running on different /opt/otobo dirs.

    return 1;
}

=head2 CustomFileCleanup()

Remove all custom files generated by C<ConfigSettingChange()> and C<CustomCodeActivate()>.

=cut

sub CustomFileCleanup {
    my ( $Self, %Param ) = @_;

    # also delete in the Backend
    if ( $Self->{S3Active} ) {
        my $StorageS3Object = $Kernel::OM->Get('Kernel::System::Storage::S3');
        $StorageS3Object->DiscardObjects(
            Prefix      => 'Kernel/Config/Files/',
            Delimiter   => '',
            DiscardOnly => qr'ZZZZUnitTest.*\.pm$',
        );
    }

    my $Home  = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my @Files = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => "$Home/Kernel/Config/Files",
        Filter    => 'ZZZZUnitTest*.pm',
    );
    for my $File (@Files) {
        $Kernel::OM->Get('Kernel::System::Main')->FileDelete(
            Location => $File,
        ) || die "Could not delete $File";
    }

    return 1;
}

=head2 UseTmpArticleDir()

switch the article storage directory to a temporary one to prevent collisions;

=cut

sub UseTmpArticleDir {
    my ( $Self, %Param ) = @_;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my $TmpArticleDir;
    TRY:
    for my $Try ( 1 .. 100 ) {

        $TmpArticleDir = $Home . '/var/tmp/unittest-article-' . $Self->GetRandomNumber();

        next TRY if -e $TmpArticleDir;
        last TRY;
    }

    $Self->ConfigSettingChange(
        Valid => 1,
        Key   => 'Ticket::Article::Backend::MIMEBase::ArticleDataDir',
        Value => $TmpArticleDir,
    );

    $Self->{TmpArticleDir} = $TmpArticleDir;

    return 1;
}

=head2 DisableAsyncCalls()

Disable scheduling of asynchronous tasks using C<AsynchronousExecutor> component of OTOBO daemon.

=cut

sub DisableAsyncCalls {
    my ( $Self, %Param ) = @_;

    $Self->ConfigSettingChange(
        Valid => 1,
        Key   => 'DisableAsyncCalls',
        Value => 1,
    );

    return 1;
}

=head2 ProvideTestDatabase()

Provide temporary database for the test. Please first define test database settings in C<Config.pm>, i.e:

    $Self->{TestDatabase} = {
        DatabaseDSN  => 'DBI:mysql:database=otobo_test;host=127.0.0.1;',
        DatabaseUser => 'otobo_test',
        DatabasePw   => 'otobo_test',
    };

The method call will override global database configuration for duration of the test, i.e. temporary database will
receive all calls sent over system C<DBObject>.

All database contents will be automatically dropped when the Helper object is destroyed.

    $Helper->ProvideTestDatabase(
        DatabaseXMLString => $XML,      # (optional) OTOBO database XML schema to execute
                                        # or
        DatabaseXMLFiles => [           # (optional) List of XML files to load and execute
            '/opt/otobo/scripts/database/otobo-schema.xml',
            '/opt/otobo/scripts/database/otobo-initial_insert.xml',
        ],
    );

This method returns 'undef' in case the test database is not configured. If it is configured, but the supplied XML cannot be read or executed, this method will C<die()> to interrupt the test with an error.

=cut

sub ProvideTestDatabase {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TestDatabase = $ConfigObject->Get('TestDatabase');

    return unless $TestDatabase;

    for (qw(DatabaseDSN DatabaseUser DatabasePw)) {
        if ( !$TestDatabase->{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_ in TestDatabase!",
            );
            return;
        }
    }

    my %EscapedSettings;
    for my $Key (qw(DatabaseDSN DatabaseUser DatabasePw)) {

        # Override database connection settings in memory.
        $ConfigObject->Set(
            Key   => "Test$Key",
            Value => $TestDatabase->{$Key},
        );

        # Escape quotes in database settings.
        $EscapedSettings{$Key} = $TestDatabase->{$Key};
        $EscapedSettings{$Key} =~ s/'/\\'/g;
    }

    # Override database connection settings system wide.
    my $Identifier  = 'TestDatabase';
    my $PackageName = "ZZZZUnitTest$Identifier";
    $Self->CustomCodeActivate(
        Code => qq^
# OTOBO config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::$PackageName;
use strict;
use warnings;
no warnings 'redefine'; ## no critic qw(TestingAndDebugging::ProhibitNoWarnings)
use utf8;
sub Load {
    my (\$File, \$Self) = \@_;
    \$Self->{TestDatabaseDSN}  = '$EscapedSettings{DatabaseDSN}';
    \$Self->{TestDatabaseUser} = '$EscapedSettings{DatabaseUser}';
    \$Self->{TestDatabasePw}   = '$EscapedSettings{DatabasePw}';
}
1;^,
        Identifier => $Identifier,
    );

    # Discard already instanced database object.
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::DB'] );

    # Delete cache.
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

    $Self->{ProvideTestDatabase} = 1;

    # Clear test database.
    my $Success = $Self->TestDatabaseCleanup();
    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Error clearing temporary database!',
        );
        die 'Error clearing temporary database!';
    }

    # Load supplied XML files.
    if ( IsArrayRefWithData( $Param{DatabaseXMLFiles} ) ) {
        $Param{DatabaseXMLString} //= '';

        my $Index = 0;
        my $Count = scalar @{ $Param{DatabaseXMLFiles} };

        XMLFILE:
        for my $XMLFile ( @{ $Param{DatabaseXMLFiles} } ) {
            next XMLFILE if !$XMLFile;

            # Load XML contents.
            my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
                Location => $XMLFile,
            );
            if ( !$XML ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not load '$XMLFile'!",
                );
                die "Could not load '$XMLFile'!";
            }

            # Concatenate the file contents, but make sure to remove duplicated XML tags first.
            #   - First file should get only end tag removed.
            #   - Last file should get only start tags removed.
            #   - Any other file should get both start and end tags removed.
            $XML = ${$XML};
            if ( $Index != 0 ) {
                $XML =~ s/<\?xml .*? \?>//xm;
                $XML =~ s/<database .*? >//xm;
            }
            if ( $Index != $Count - 1 ) {
                $XML =~ s/<\/database .*? >//xm;
            }
            $Param{DatabaseXMLString} .= $XML;

            $Index++;
        }
    }

    # Execute supplied XML.
    if ( $Param{DatabaseXMLString} ) {
        my $Success = $Self->DatabaseXMLExecute( XML => $Param{DatabaseXMLString} );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Error executing supplied XML!',
            );
            die 'Error executing supplied XML!';
        }
    }

    return 1;
}

=head2 TestDatabaseCleanup()

Clears temporary database used in the test. Always call C<ProvideTestDatabase()> called first, in
order to set it up.

Please note that all database contents will be dropped, USE WITH CARE!

    $Helper->TestDatabaseCleanup();

=cut

sub TestDatabaseCleanup {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{ProvideTestDatabase} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Please call ProvideTestDatabase() first!',
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get a list of all tables in database.
    my @Tables = $DBObject->ListTables();

    if (@Tables) {
        my $TableList = join ', ', sort @Tables;
        my $DBType    = $DBObject->{'DB::Type'};

        if ( $DBType eq 'mysql' ) {

            # Turn off checking foreign key constraints temporarily.
            $DBObject->Do( SQL => 'SET foreign_key_checks = 0' );

            # Drop all found tables in the database in same statement.
            $DBObject->Do( SQL => "DROP TABLE $TableList" );

            # Turn back on checking foreign key constraints.
            $DBObject->Do( SQL => 'SET foreign_key_checks = 1' );
        }
        elsif ( $DBType eq 'postgresql' ) {

            # Drop all found tables in the database in same statement.
            $DBObject->Do( SQL => "DROP TABLE $TableList" );
        }
        elsif ( $DBType eq 'oracle' ) {

            # Drop each found table in the database in a separate statement.
            for my $Table (@Tables) {
                $DBObject->Do( SQL => "DROP TABLE $Table CASCADE CONSTRAINTS" );
            }

            # Get complete list of user sequences.
            my @Sequences;
            return if !$DBObject->Prepare(
                SQL => 'SELECT sequence_name FROM user_sequences ORDER BY sequence_name',
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @Sequences, $Row[0];
            }

            # Drop all found sequences as well.
            for my $Sequence (@Sequences) {
                $DBObject->Do( SQL => "DROP SEQUENCE $Sequence" );
            }

            # Check if all sequences have been dropped.
            @Sequences = ();
            return if !$DBObject->Prepare(
                SQL => 'SELECT sequence_name FROM user_sequences ORDER BY sequence_name',
            );
            while ( my @Row = $DBObject->FetchrowArray() ) {
                push @Sequences, $Row[0];
            }

            return if @Sequences;
        }

        # Check if all tables have been dropped.
        @Tables = $DBObject->ListTables();

        return if @Tables;
    }

    return 1;
}

=head2 DatabaseXMLExecute()

Execute supplied XML against current database. Content of supplied XML or XMLFilename parameter must be valid OTOBO
database XML schema.

    $Helper->DatabaseXMLExecute(
        XML => $XML,     # OTOBO database XML schema to execute
    );

Alternatively, it can also load an XML file to execute:

    $Helper->DatabaseXMLExecute(
        XMLFile => '/path/to/file',  # OTOBO database XML file to execute
    );

=cut

sub DatabaseXMLExecute {
    my ( $Self, %Param ) = @_;

    if ( !$Param{XML} && !$Param{XMLFile} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need XML or XMLFile!',
        );
        return;
    }

    my $XML = $Param{XML};

    if ( !$XML ) {

        $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Param{XMLFile},
        );
        if ( !$XML ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not load '$Param{XMLFile}'!",
            );
            die "Could not load '$Param{XMLFile}'!";
        }
        $XML = ${$XML};
    }

    my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );
    if ( !@XMLArray ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not parse XML!',
        );
        die 'Could not parse XML!';
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my @SQLPre = $DBObject->SQLProcessor(
        Database => \@XMLArray,
    );
    if ( !@SQLPre ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not generate SQL!',
        );
        die 'Could not generate SQL!';
    }

    my @SQLPost = $DBObject->SQLProcessorPost();

    for my $SQL ( @SQLPre, @SQLPost ) {
        my $Success = $DBObject->Do( SQL => $SQL );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Database action failed: ' . $DBObject->Error(),
            );
            die 'Database action failed: ' . $DBObject->Error();
        }
    }

    return 1;
}

=head2 DESTROY()

performs various clean-ups.

=cut

sub DESTROY {
    my $Self = shift;

    # Cleanup temporary database if it was set up.
    $Self->TestDatabaseCleanup() if $Self->{ProvideTestDatabase};

    # Remove any custom code files.
    $Self->CustomFileCleanup();

    # restore environment variable to skip SSL certificate verification if needed
    if ( $Self->{RestoreSSLVerify} ) {
        $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = $Self->{PERL_LWP_SSL_VERIFY_HOSTNAME};    ## no critic qw(Variables::RequireLocalizedPunctuationVars)
        $Self->{RestoreSSLVerify} = 0;
    }

    # restore database, clean caches
    if ( $Self->{RestoreDatabase} ) {
        my $RollbackSuccess = $Self->Rollback();
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }

    # disable email checks to invalidate test users
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    local $ConfigObject->{CheckEmailAddresses} = 0;

    # cleanup temporary article directory
    if ( $Self->{TmpArticleDir} && -d $Self->{TmpArticleDir} ) {
        rmtree( $Self->{TmpArticleDir} );
    }

    # invalidate test users
    if ( ref $Self->{TestUsers} eq 'ARRAY' && @{ $Self->{TestUsers} } ) {
        TESTUSERS:
        for my $TestUser ( @{ $Self->{TestUsers} } ) {

            my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $TestUser,
            );

            if ( !$User{UserID} ) {

                # if no such user exists, there is no need to set it to invalid;
                # happens when the test user is created inside a transaction
                # that is later rolled back.
                next TESTUSERS;
            }

            # make test user invalid
            my $Success = $Kernel::OM->Get('Kernel::System::User')->UserUpdate(
                %User,
                ValidID      => 2,
                ChangeUserID => 1,
            );
        }
    }

    # invalidate test customer users
    if ( ref $Self->{TestCustomerUsers} eq 'ARRAY' && @{ $Self->{TestCustomerUsers} } ) {
        TESTCUSTOMERUSERS:
        for my $TestCustomerUser ( @{ $Self->{TestCustomerUsers} } ) {

            my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
                User => $TestCustomerUser,
            );

            if ( !$CustomerUser{UserLogin} ) {

                # if no such customer user exists, there is no need to set it to invalid;
                # happens when the test customer user is created inside a transaction
                # that is later rolled back.
                next TESTCUSTOMERUSERS;
            }

            my $Success = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserUpdate(
                %CustomerUser,
                ID      => $CustomerUser{UserID},
                ValidID => 2,
                UserID  => 1,
            );
        }
    }

    return;
}

END {

    # trigger Kernel::System::UnitTest::Helper::DESTROY()
    # perform cleanup actions, including some tests, in Kernel::System::UnitTest::Helper::DESTROY()
    if ( defined $Kernel::OM ) {
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::UnitTest::Helper'],
        );
    }
}

1;
