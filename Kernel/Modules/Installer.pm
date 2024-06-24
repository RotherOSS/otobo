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

package Kernel::Modules::Installer;

## nofilter(TidyAll::Plugin::OTOBO::Perl::Print)

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules
use Net::Domain qw(hostfqdn);

# CPAN modules
use DBI                     ();
use DBI::Const::GetInfoType ();    # set up %DBI::Const::GetInfoType::GetInfoType

# OTOBO modules
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object and initialize with the passed params
    return bless {%Param}, $Type;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # installing is only possible when SecureMode is not active
    if ( $Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        $LayoutObject->FatalError(
            Message => Translatable('SecureMode active!'),
            Comment => Translatable('If you want to re-run the Installer, disable the SecureMode in the SysConfig.'),
        );
    }

    # Check environment directories.
    $Self->{Path} = $ConfigObject->Get('Home');
    if ( !-d $Self->{Path} ) {
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Directory "%s" doesn\'t exist!', $Self->{Path} ),
            Comment => Translatable('Configure "Home" in Kernel/Config.pm first!'),
        );
    }
    if ( !-f "$Self->{Path}/Kernel/Config.pm" ) {
        $LayoutObject->FatalError(
            Message =>
                $LayoutObject->{LanguageObject}->Translate( 'File "%s/Kernel/Config.pm" not found!', $Self->{Path} ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # Get and check the SQL schema directory
    my $DirOfSQLFiles = $Self->{Path} . '/scripts/database';
    if ( !-d $DirOfSQLFiles ) {

        # throw a Kernel::System::Web::Exception exception
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Directory "%s" not found!', $DirOfSQLFiles ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # There used to be support for setting installer option in var/tmp/installer.json
    # This approach is no longer supported. However we keep $Self->{Options} as
    # this functionality might be resurrected in future.
    $Self->{Options} //= {};

    # Check if License option needs to be skipped.
    if ( $Self->{Subaction} eq 'License' && $Self->{Options}->{SkipLicense} ) {
        $Self->{Subaction} = 'Start';
    }

    # Check if Database option needs to be skipped.
    if ( $Self->{Subaction} eq 'Start' && $Self->{Options}->{DBType} ) {
        $Self->{Subaction} = 'DBCreate';
    }

    $Self->{Subaction} ||= 'Intro';

    # Set up the build steps.
    # The license step is not needed when it is turned off in $Self->{Options}.
    my @Steps = qw(Database General Finish);
    unshift @Steps, 'License' unless $Self->{Options}->{SkipLicense};

    my $StepCounter;

    # Build header - but only if we're not in AJAX mode.
    if ( $Self->{Subaction} ne 'CheckRequirements' ) {
        $LayoutObject->Block(
            Name => 'Steps',
            Data => {
                Steps => scalar @Steps,
            },
        );

        # Mapping of sub-actions to steps.
        my %Steps = (
            Intro         => 'Intro',
            License       => 'License',
            Start         => 'Database',
            DB            => 'Database',
            DBCreate      => 'Database',
            ConfigureMail => 'General',
            System        => 'General',
            Finish        => 'Finish',
        );

        # On the intro screen no steps should be highlighted.
        my $Highlight = ( $Self->{Subaction} eq 'Intro' ) ? '' : 'Highlighted NoLink';

        my $Counter;

        for my $Step (@Steps) {
            $Counter++;

            # Is the current step active?
            my $Active = ( $Steps{ $Self->{Subaction} } eq $Step ) ? 'Active' : '';
            $LayoutObject->Block(
                Name => 'Step' . $Step,
                Data => {
                    Step      => $Counter,
                    Highlight => $Highlight,
                    Active    => $Active,
                },
            );

            # If this is the actual step.
            if ( $Steps{ $Self->{Subaction} } eq $Step ) {

                # No more highlights from now on.
                $Highlight = '';

                # Step calculation: 2/5 etc.
                $StepCounter = $Counter . "/" . scalar @Steps;
            }
        }
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Print intro form.
    my $Title = $LayoutObject->{LanguageObject}->Translate('Install OTOBO');
    if ( $Self->{Subaction} eq 'Intro' ) {

        # activate the Intro block
        $LayoutObject->Block(
            Name => 'Intro',
            Data => {}
        );

        return join '',
            $LayoutObject->Header(
                Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate('Intro')
            ),
            $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {},
            ),
            $LayoutObject->Footer;
    }

    # Print license from.
    elsif ( $Self->{Subaction} eq 'License' ) {
        $LayoutObject->Block(
            Name => 'License',
            Data => {
                Item => Translatable('License'),
                Step => $StepCounter,
            },
        );
        $LayoutObject->Block(
            Name => 'LicenseText',
            Data => {},
        );

        return join '',
            $LayoutObject->Header(
                Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate('License')
            ),
            $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {},
            ),
            $LayoutObject->Footer;
    }

    # Database selection screen.
    elsif ( $Self->{Subaction} eq 'Start' ) {
        if ( !-w "$Self->{Path}/Kernel/Config.pm" ) {
            return join '',
                $LayoutObject->Header(
                    Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate('Error')
                ),
                $LayoutObject->Warning(
                    Message => Translatable('Kernel/Config.pm isn\'t writable!'),
                    Comment => Translatable(
                        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!'
                    ),
                ),
                $LayoutObject->Footer;
        }

        my %Databases = (
            mysql      => 'MySQL',
            postgresql => 'PostgreSQL',
            oracle     => 'Oracle',
        );

        # Build the select field for the InstallerDBStart.tt.
        $Param{SelectDBType} = $LayoutObject->BuildSelection(
            Data       => \%Databases,
            Name       => 'DBType',
            Class      => 'Modernize',
            Size       => scalar keys %Databases,
            SelectedID => 'mysql',
        );

        $LayoutObject->Block(
            Name => 'DatabaseStart',
            Data => {
                Item         => Translatable('Database Selection'),
                Step         => $StepCounter,
                SelectDBType => $Param{SelectDBType},
            },
        );

        return join '',
            $LayoutObject->Header(
                Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate('Database Selection')
            ),
            $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {},
            ),
            $LayoutObject->Footer;
    }

    # Check different requirements (AJAX) and return the result as JSON.
    elsif ( $Self->{Subaction} eq 'CheckRequirements' ) {
        my $CheckMode = $ParamObject->GetParam( Param => 'CheckMode' );
        my %Result;

        # Check DB requirements.
        if ( $CheckMode eq 'DB' ) {
            my %DBCredentials;
            for my $Param (
                qw(DBUser DBPassword DBHost DBType DBPort DBSID DBName InstallType OTOBODBUser OTOBODBPassword)
                )
            {
                $DBCredentials{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
            }

            %Result = $Self->CheckDBRequirements(
                %DBCredentials,
            );
        }

        # Check mail configuration.
        elsif ( $CheckMode eq 'Mail' ) {
            %Result = $Self->CheckMailConfiguration;
        }

        # No adequate check method found.
        else {
            %Result = (
                Successful => 0,
                Message    => Translatable('Unknown Check!'),
                Comment    => $LayoutObject->{LanguageObject}->Translate( 'The check "%s" doesn\'t exist!', $CheckMode ),
            );
        }

        # Return JSON-String because of AJAX-Mode.
        my $OutputJSON = $LayoutObject->JSONEncode( Data => \%Result );

        return $LayoutObject->Attachment(
            ContentType => 'application/json',
            Content     => $OutputJSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    elsif ( $Self->{Subaction} eq 'DB' ) {

        my $DBType        = $ParamObject->GetParam( Param => 'DBType' );
        my $DBInstallType = $ParamObject->GetParam( Param => 'DBInstallType' );

        # generate a random password for OTOBODBUser
        my $GeneratedPassword = $MainObject->GenerateRandomString;

        if ( $DBType eq 'mysql' ) {
            my $PasswordExplanation = $DBInstallType eq 'CreateDB'
                ? $LayoutObject->{LanguageObject}->Translate(
                    'If you have set a root password for your database, it must be entered here. If not, leave this field empty.',
                )
                : $LayoutObject->{LanguageObject}->Translate('Enter the password for the database user.');
            $LayoutObject->Block(
                Name => 'DatabaseMySQL',
                Data => {
                    Item                => Translatable('Configure MySQL'),
                    Step                => $StepCounter,
                    InstallType         => $DBInstallType,
                    DefaultDBUser       => $DBInstallType eq 'CreateDB' ? 'root' : 'otobo',
                    PasswordExplanation => $PasswordExplanation,
                },
            );
            if ( $DBInstallType eq 'CreateDB' ) {
                $LayoutObject->Block(
                    Name => 'DatabaseMySQLCreate',
                    Data => {
                        Password => $GeneratedPassword,
                    },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'DatabaseMySQLUseExisting',
                );
            }

            return join '',
                $LayoutObject->Header(
                    Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate( 'Database %s', 'MySQL' )
                ),
                $LayoutObject->Output(
                    TemplateFile => 'Installer',
                    Data         => {
                        Item => Translatable('Configure MySQL'),
                        Step => $StepCounter,
                    },
                ),
                $LayoutObject->Footer;
        }
        elsif ( $DBType eq 'postgresql' ) {
            my $PasswordExplanation = $DBInstallType eq 'CreateDB'
                ? $LayoutObject->{LanguageObject}->Translate('Enter the password for the administrative database user.')
                : $LayoutObject->{LanguageObject}->Translate('Enter the password for the database user.');
            $LayoutObject->Block(
                Name => 'DatabasePostgreSQL',
                Data => {
                    Item          => Translatable('Database'),
                    Step          => $StepCounter,
                    InstallType   => $DBInstallType,
                    DefaultDBUser => $DBInstallType eq 'CreateDB' ? 'postgres' : 'otobo',
                },
            );
            if ( $DBInstallType eq 'CreateDB' ) {
                $LayoutObject->Block(
                    Name => 'DatabasePostgreSQLCreate',
                    Data => {
                        Password => $GeneratedPassword,
                    },
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'DatabasePostgreSQLUseExisting',
                );
            }

            return join '',
                $LayoutObject->Header(
                    Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate( 'Database %s', 'PostgreSQL' )
                ),
                $LayoutObject->Output(
                    TemplateFile => 'Installer',
                    Data         => {
                        Item => Translatable('Configure PostgreSQL'),
                        Step => $StepCounter,
                    },
                ),
                $LayoutObject->Footer;
        }
        elsif ( $DBType eq 'oracle' ) {
            $LayoutObject->Block(
                Name => 'DatabaseOracle',
                Data => {
                    Item => Translatable('Database'),
                    Step => $StepCounter,
                },
            );

            return join '',
                $LayoutObject->Header(
                    Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate( 'Database %s', 'Oracle' )
                ),
                $LayoutObject->Output(
                    TemplateFile => 'Installer',
                    Data         => {
                        Item => Translatable('Configure Oracle'),
                        Step => $StepCounter,
                    },
                ),
                $LayoutObject->Footer;
        }
        else {

            # throw a Kernel::System::Web::Exception exception
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Unknown database type "%s".', $DBType ),
                Comment => Translatable('Please go back.'),
            );
        }
    }

    # Do database settings.
    elsif ( $Self->{Subaction} eq 'DBCreate' ) {

        my %DBCredentials;
        for my $Param (
            qw(DBUser DBPassword DBHost DBType DBName DBSID DBPort InstallType OTOBODBUser OTOBODBPassword)
            )
        {
            $DBCredentials{$Param} = $ParamObject->GetParam( Param => $Param ) || '';
        }

        # Overriding DBCredentials is currently not used.
        %DBCredentials = %{ $Self->{Options} } if $Self->{Options}->{DBType};

        # Get and check params and connect to DB as database admin
        my %Result = $Self->ConnectToDB(%DBCredentials);

        my %DB;
        my $DBH;
        if ( ref $Result{DB} ne 'HASH' || !$Result{DBH} ) {
            $LayoutObject->FatalError(
                Message => $Result{Message},
                Comment => $Result{Comment},
            );
        }
        else {
            %DB  = %{ $Result{DB} };
            $DBH = $Result{DBH};
        }

        $LayoutObject->Block(
            Name => 'DatabaseResult',
            Data => {
                Item => Translatable('Create Database'),
                Step => $StepCounter,
            },
        );

        my @Statements;

        # Create database, add user.
        if ( $DB{DBType} eq 'mysql' ) {

            if ( $DB{InstallType} eq 'CreateDB' ) {

                # Determine current host for MySQL account.
                my $Host;
                if ( $ENV{OTOBO_RUNS_UNDER_DOCKER} ) {

                    # When running under Docker we assume that the database also runs in the subnet provided by Docker.
                    # This is the case when the standard docker-compose.yml is used.
                    # In this network the IP-addresses are not static therefore we can't use the same IP address
                    # as seen when installer.pl runs.
                    # Using 'db' does not work because 'skip-name-resolve' is set.
                    # For now allow the complete network.
                    $Host = '%';
                }
                else {
                    # In the non-Docker case we want the IP-address of the current connection as database host.
                    my ($ConnectionID) = $DBH->selectrow_array('select connection_id()');

                    my $StatementHandleProcessList = $DBH->prepare('show processlist');
                    $StatementHandleProcessList->execute;
                    PROCESSLIST:
                    while ( my ( $ProcessID, undef, $ProcessHost ) = $StatementHandleProcessList->fetchrow_array ) {
                        if ( $ProcessID eq $ConnectionID ) {
                            $Host = $ProcessHost;

                            last PROCESSLIST;
                        }
                    }

                    # Strip off port, i.e. 'localhost:14962' should become 'localhost'.
                    $Host =~ s{:\d*\z}{}xms;
                }

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
                    if ( $DBH->{mysql_serverinfo} =~ m/mariadb/i ) {
                        $CreateUserSQL
                            .= "CREATE USER `$DB{OTOBODBUser}`\@`$Host` IDENTIFIED BY '$DB{OTOBODBPassword}'";
                    }
                    else {
                        $CreateUserSQL
                            .= "CREATE USER `$DB{OTOBODBUser}`\@`$Host` IDENTIFIED WITH mysql_native_password BY '$DB{OTOBODBPassword}'";
                    }
                }

                @Statements = (
                    "CREATE DATABASE `$DB{DBName}` charset utf8mb4 DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci",
                    $CreateUserSQL,
                    "GRANT ALL PRIVILEGES ON `$DB{DBName}`.* TO `$DB{OTOBODBUser}`\@`$Host` WITH GRANT OPTION",
                );
            }

            # Set DSN for Config.pm.
            $DB{ConfigDSN} = 'DBI:mysql:database=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:mysql:database=$DB{DBName};host=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'postgresql' ) {

            if ( $DB{InstallType} eq 'CreateDB' ) {
                @Statements = (
                    "CREATE ROLE \"$DB{OTOBODBUser}\" WITH LOGIN PASSWORD '$DB{OTOBODBPassword}'",
                    "CREATE DATABASE \"$DB{DBName}\" OWNER=\"$DB{OTOBODBUser}\" ENCODING 'utf-8'",
                );
            }

            # Set DSN for Config.pm.
            $DB{ConfigDSN} = 'DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost}';
            $DB{DSN}       = "DBI:Pg:dbname=$DB{DBName};host=$DB{DBHost}";
        }
        elsif ( $DB{DBType} eq 'oracle' ) {

            # Set DSN for Config.pm.
            $DB{ConfigDSN} = 'DBI:Oracle://$Self->{DatabaseHost}:' . $DB{DBPort} . '/$Self->{Database}';
            $DB{DSN}       = "DBI:Oracle://$DB{DBHost}:$DB{DBPort}/$DB{DBSID}";
            $ConfigObject->Set(
                Key   => 'Database::Connect',
                Value => "ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS'",
            );
        }

        # Execute database statements.
        for my $Statement (@Statements) {

            # For better readabilty and for hiding sensitive info show only the first three words
            # in the description of the action.
            # Note that using a single space as the split pattern, introduces AWK compatible whitespace splitting.
            my $ThreeWordDescription = join ' ',
                map { $_ // '' }
                ( split ' ', $Statement, 4 )[ 0 .. 2 ];
            $LayoutObject->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => $ThreeWordDescription },
            );

            if ( !$DBH->do($Statement) ) {

                # report database error
                $LayoutObject->Block(
                    Name => 'DatabaseResultItemFalse',
                    Data => {},
                );
                $LayoutObject->Block(
                    Name => 'DatabaseResultItemMessage',
                    Data => {
                        Message => $DBI::errstr,
                    },
                );
                $LayoutObject->Block(
                    Name => 'DatabaseResultBack',
                    Data => {},
                );

                return join '',
                    $LayoutObject->Header(
                        Title => $Title . '-' . $LayoutObject->{LanguageObject}->Translate('Create Database'),
                    ),
                    $LayoutObject->Output(
                        TemplateFile => 'Installer',
                        Data         => {},
                    ),
                    $LayoutObject->Footer;
            }
            else {
                $LayoutObject->Block(
                    Name => 'DatabaseResultItemDone',
                    Data => {},
                );
            }
        }

        # ReConfigure Config.pm.
        my $ReConfigure;
        if ( $DB{DBType} eq 'oracle' ) {
            $ReConfigure = $Self->ReConfigure(
                DatabaseDSN  => $DB{ConfigDSN},
                DatabaseHost => $DB{DBHost},
                Database     => $DB{DBSID},
                DatabaseUser => $DB{OTOBODBUser},
                DatabasePw   => $DB{OTOBODBPassword},
            );
        }
        else {
            $ReConfigure = $Self->ReConfigure(
                DatabaseDSN  => $DB{ConfigDSN},
                DatabaseHost => $DB{DBHost},
                Database     => $DB{DBName},
                DatabaseUser => $DB{OTOBODBUser},
                DatabasePw   => $DB{OTOBODBPassword},
            );
        }

        if ($ReConfigure) {
            return join '',
                $LayoutObject->Header(
                    Title => Translatable('Install OTOBO - Error')
                ),
                $LayoutObject->Warning(
                    Message => Translatable('Kernel/Config.pm isn\'t writable!'),
                    Comment => Translatable(
                        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!'
                    ),
                ),
                $LayoutObject->Footer;
        }

        # We need a database connection as the user 'otobo' for handling the XML files.
        # Not relying on Kernel/Config.pm as that file was recently changed.
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::DB']
        );
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::DB' => {
                DatabaseDSN  => $DB{DSN},
                DatabaseUser => $DB{OTOBODBUser},
                DatabasePw   => $DB{OTOBODBPassword},
                Type         => $DB{DBType},
            },
        );
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Create database tables and insert initial values.
        my @SQLPost;
        for my $SchemaFile (qw(otobo-schema otobo-initial_insert)) {

            if ( !-f "$DirOfSQLFiles/$SchemaFile.xml" ) {
                $LayoutObject->FatalError(
                    Message => $LayoutObject->{LanguageObject}->Translate( 'File "%s/%s.xml" not found!', $DirOfSQLFiles, $SchemaFile ),
                    Comment => Translatable('Contact your Admin!'),
                );
            }

            $LayoutObject->Block(
                Name => 'DatabaseResultItem',
                Data => { Item => "Processing $SchemaFile" },
            );

            my $XML = $MainObject->FileRead(
                Directory => $DirOfSQLFiles,
                Filename  => $SchemaFile . '.xml',
            );
            my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse(
                String => $XML,
            );

            my @SQL = $DBObject->SQLProcessor(
                Database => \@XMLArray,
            );

            # If we parsed the schema, catch post instructions.
            @SQLPost = $DBObject->SQLProcessorPost if $SchemaFile eq 'otobo-schema';

            SQL:
            for my $SQL (@SQL) {
                my $Success = $DBObject->Do( SQL => $SQL );

                next SQL if $Success;

                # an statement was no correct, no idea how this could be handled
                $LayoutObject->FatalError(
                    Message => Translatable('Execution of SQL statement failed: ') . $DBI::errstr,
                    Comment => $SQL,
                );
            }

            # Situations can arise where the cache has been set with values
            # that stem from an incomplete database. A notorious example is a cached ValidList
            # that has an empty hashref as value. This leads to subsequent failures.
            # Clean up the cache completely as installer.pl does not use the cache for its operation.
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp;

            $LayoutObject->Block(
                Name => 'DatabaseResultItemDone',
            );
        }

        # Execute post SQL statements (indexes, constraints).

        $LayoutObject->Block(
            Name => 'DatabaseResultItem',
            Data => { Item => "Processing post statements" },
        );

        for my $SQL (@SQLPost) {
            $DBObject->Do( SQL => $SQL );
        }

        $LayoutObject->Block(
            Name => 'DatabaseResultItemDone',
        );

        $LayoutObject->Block(
            Name => 'DatabaseResultSuccess',
        );
        $LayoutObject->Block(
            Name => 'DatabaseResultNext',
        );

        return join '',
            $LayoutObject->Header(
                Title => $Title . '-' . $LayoutObject->{LanguageObject}->Translate('Create Database'),
            ),
            $LayoutObject->Output(
                TemplateFile => 'Installer',
            ),
            $LayoutObject->Footer;
    }

    # Show system settings page, pre-install packages.
    elsif ( $Self->{Subaction} eq 'System' ) {

        if ( !$Kernel::OM->Get('Kernel::System::DB') ) {
            $LayoutObject->FatalError;    # throw a Kernel::System::Web::Exception exception
        }

        # Take care that default config is in the database.
        $LayoutObject->FatalError unless $Self->_CheckConfig;    # throw a Kernel::System::Web::Exception exception

        # Install default files.
        if ( $MainObject->Require('Kernel::System::Package') ) {
            my $PackageObject = Kernel::System::Package->new( %{$Self} );
            if ($PackageObject) {
                $PackageObject->PackageInstallDefaultFiles;
            }
        }

        my @SystemIDs = map { sprintf '%02d', $_ } ( 0 .. 99 );

        $Param{SystemIDString} = $LayoutObject->BuildSelection(
            Data       => \@SystemIDs,
            Name       => 'SystemID',
            Class      => 'Modernize',
            SelectedID => $SystemIDs[ int( rand(100) ) ],    # random system ID
        );

        $Param{SSLSupportString} = $LayoutObject->BuildSelection(
            Data => {
                https => Translatable('https'),
                http  => Translatable('http'),
            },
            Name       => 'HttpType',
            Class      => 'Modernize',
            SelectedID => 'https',
        );

        $Param{LanguageString} = $LayoutObject->BuildSelection(
            Data       => $ConfigObject->Get('DefaultUsedLanguages'),
            Name       => 'DefaultLanguage',
            Class      => 'Modernize',
            HTMLQuote  => 0,
            SelectedID => $LayoutObject->{UserLanguage},
        );

        # Build the selection field for the MX check.
        $Param{SelectCheckMXRecord} = $LayoutObject->BuildSelection(
            Data => {
                1 => Translatable('Yes'),
                0 => Translatable('No'),
            },
            Name       => 'CheckMXRecord',
            Class      => 'Modernize',
            SelectedID => '1',
        );

        # Read FQDN using Net::Domain and pre-populate the field.
        $Param{FQDN} = hostfqdn();

        # try initializing Elasticsearch
        my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
        my $ESObject         = $Kernel::OM->Get('Kernel::System::Elasticsearch');

        my $ESWebservice = $WebserviceObject->WebserviceGet(
            Name => 'Elasticsearch',
        );
        my $Success = 0;

        # activate it
        if ($ESWebservice) {
            $Success = $WebserviceObject->WebserviceUpdate(
                %{$ESWebservice},
                ValidID => 1,
                UserID  => 1,
            );
        }

        # test the connection
        if ( $Success && !$ESObject->TestConnection ) {
            $Success = 0;
        }

        # try to set up Elasticsearch
        if ($Success) {
            ( $Success, my $FatalError ) = $ESObject->InitialSetup;

            $LayoutObject->FatalError if $FatalError;
        }

        # deactivate the webservice again in case of no success
        else {
            $WebserviceObject->WebserviceUpdate(
                %{$ESWebservice},
                ValidID => 2,
                UserID  => 1,
            );
        }

        # show the status in the GUI
        $Param{ESActive} = $Success;

        my $Output = $LayoutObject->Header(
            Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate('System Settings'),
        );
        $LayoutObject->Block(
            Name => 'System',
            Data => {
                Item => Translatable('System Settings'),
                Step => $StepCounter,
                %Param,
            },
        );

        if ( !$Self->{Options}->{SkipLog} ) {
            $Param{LogModuleString} = $LayoutObject->BuildSelection(
                Data => {
                    'Kernel::System::Log::SysLog' => Translatable('Syslog'),
                    'Kernel::System::Log::File'   => Translatable('File'),
                },
                Name       => 'LogModule',
                Class      => 'Modernize',
                HTMLQuote  => 0,
                SelectedID => $ConfigObject->Get('LogModule'),
            );
            $LayoutObject->Block(
                Name => 'LogModule',
                Data => \%Param,
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer;

        return $Output;
    }

    # Do system settings action.
    elsif ( $Self->{Subaction} eq 'ConfigureMail' ) {

        if ( !$Kernel::OM->Get('Kernel::System::DB') ) {
            $LayoutObject->FatalError;
        }

        # Take care that default config is in the database.
        $LayoutObject->FatalError unless $Self->_CheckConfig;    # throw a Kernel::System::Web::Exception exception

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            LockAll => 1,
            Force   => 1,
            UserID  => 1,
        );

        for my $SettingName (
            qw(SystemID HttpType FQDN AdminEmail Organization LogModule LogModule::LogFile
            DefaultLanguage CheckMXRecord)
            )
        {
            my $EffectiveValue = $ParamObject->GetParam( Param => $SettingName );

            # Update config item via sys config object.
            $SysConfigObject->SettingUpdate(
                Name              => $SettingName,
                IsValid           => 1,
                EffectiveValue    => $EffectiveValue,
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
        }

        my $Success = $SysConfigObject->SettingUnlock(
            UnlockAll => 1,
        );

        # Get mail account object and check available back-ends.
        my $MailAccount  = $Kernel::OM->Get('Kernel::System::MailAccount');
        my %MailBackends = $MailAccount->MailAccountBackendList;

        my $OutboundMailTypeSelection = $LayoutObject->BuildSelection(
            Data => {
                sendmail => 'Sendmail',
                smtp     => 'SMTP',
                smtps    => 'SMTPS',
                smtptls  => 'SMTPTLS',
            },
            Name         => 'OutboundMailType',
            Class        => 'Modernize',
            PossibleNone => 1,
        );
        my $OutboundMailDefaultPorts = $LayoutObject->BuildSelection(
            Class => 'Hidden',
            Data  => {
                sendmail => '25',
                smtp     => '25',
                smtps    => '465',
                smtptls  => '587',
            },
            Name => 'OutboundMailDefaultPorts',
        );

        my $InboundMailTypeSelection = $LayoutObject->BuildSelection(
            Data         => \%MailBackends,
            Name         => 'InboundMailType',
            Class        => 'Modernize',
            PossibleNone => 1,
        );

        my $Output = $LayoutObject->Header(
            Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate('Configure Mail')
        );
        $LayoutObject->Block(
            Name => 'ConfigureMail',
            Data => {
                Item             => $LayoutObject->{LanguageObject}->Translate('Mail Configuration'),
                Step             => $StepCounter,
                InboundMailType  => $InboundMailTypeSelection,
                OutboundMailType => $OutboundMailTypeSelection,
                OutboundPorts    => $OutboundMailDefaultPorts,
            },
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'Installer',
            Data         => {},
        );
        $Output .= $LayoutObject->Footer;

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'Finish' ) {

        # Take care that default config is in the database.
        $LayoutObject->FatalError unless $Self->_CheckConfig;    # throw a Kernel::System::Web::Exception exception

        my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $SettingName       = 'SecureMode';
        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => $SettingName,
            Force  => 1,
            UserID => 1,
        );

        # Update config item via SysConfig object.
        my $Result = $SysConfigObject->SettingUpdate(
            Name              => $SettingName,
            IsValid           => 1,
            EffectiveValue    => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result ) {
            $LayoutObject->FatalError(
                Message => Translatable(q{Can't write Config file!}),
            );
        }

        # There is no need to unlock the setting as it was already unlocked in the update.

        # 'Rebuild' the configuration.
        $SysConfigObject->ConfigurationDeploy(
            Comments    => "Installer deployment",
            AllSettings => 1,
            Force       => 1,
            UserID      => 1,
        );

        # Set a generated password for the 'root@localhost' account.
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my $Password   = $UserObject->GenerateRandomPassword( Size => 16 );
        $UserObject->SetPassword(
            UserLogin => 'root@localhost',
            PW        => $Password,
        );

        # TODO: This seems to be deprecated now.
        # Remove installer file with pre-configured options.
        if ( -f "$Self->{Path}/var/tmp/installer.json" ) {
            unlink "$Self->{Path}/var/tmp/installer.json";
        }

        # webserver restart is never necessary

        my $OTOBOHandle = $ParamObject->ScriptName;
        $OTOBOHandle =~ s/\/(.*)\/installer\.pl/$1/;

        # Under Docker the scheme is correctly recognised as there are only two relevant cases:
        #   a) HTTP should actually be used
        #   b) HTTPS should be used and it works because nginx sets HTTPS
        my $Scheme = $ParamObject->HttpsIsOn ? 'https' : 'http';

        # In the docker case $ENV{HTTP_HOST} is something like 'localhost:8443'.
        # This is not very helpful as port 8443 is not exposed on the Docker host.
        # So let's use the host that is provided by nginx
        # Another, maybe better, approach is to simple provide a relative link to '../index.pl'.
        # Fun fact: the FQDN can specified with a port.
        my $Host =
            $ParamObject->Header('X-Forwarded-Server')    # for the HTTPS case, the hostname that nginx sees
            || $ParamObject->Header('Host')               # should work in the HTTP case, in Docker or not in Docker
            || $ConfigObject->Get('FQDN');                # a fallback

        $LayoutObject->Block(
            Name => 'Finish',
            Data => {
                Item        => Translatable('Finished'),
                Step        => $StepCounter,
                Host        => $Host,
                Scheme      => $Scheme,
                OTOBOHandle => $OTOBOHandle,
                Password    => $Password,
            },
        );

        return join '',
            $LayoutObject->Header(
                Title => "$Title - " . $LayoutObject->{LanguageObject}->Translate('Finished')
            ),
            $LayoutObject->Output(
                TemplateFile => 'Installer',
                Data         => {},
            ),
            $LayoutObject->Footer;
    }

    # Else error!
    $LayoutObject->FatalError(
        Message => $LayoutObject->{LanguageObject}->Translate( 'Unknown Subaction %s!', $Self->{Subaction} ),
        Comment => Translatable('Please contact the administrator.'),
    );
}

sub ReConfigure {
    my ( $Self, %Param ) = @_;

    # Perl quote and set via ConfigObject.
    for my $Key ( sort keys %Param ) {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => $Key,
            Value => $Param{$Key},
        );
        if ( $Param{$Key} ) {
            $Param{$Key} =~ s/'/\\'/g;
        }
    }

    # Read config file.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigFile   = "$Self->{Path}/Kernel/Config.pm";
    open( my $In, '<', $ConfigFile )                                                ## no critic qw(InputOutput::RequireBriefOpen OTOBO::ProhibitOpen)
        or $LayoutObject->FatalError( Message => "Can't open $ConfigFile: $!" );    ## no critic qw(OTOBO::ProhibitLowPrecedenceOps)
    my $Config = '';
    while ( my $s = <$In> ) {

        # no need to adapt empty lines or comments.
        if ( !$s || $s =~ /^\s*#/ || $s =~ /^\s*$/ ) {
            $Config .= $s;
        }
        else {
            my $NewConfig = $s;

            # Replace config with %Param.
            for my $Key ( sort keys %Param ) {

                # Database passwords can contain characters like '@' or '$' and should be single-quoted
                #   same goes for database hosts which can be like 'myserver\instance name' for MS SQL.
                if ( $Key eq 'DatabasePw' || $Key eq 'DatabaseHost' ) {
                    $NewConfig =~ s/(\$Self->\{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = '$Param{$Key}';/g;
                }
                else {
                    $NewConfig =~ s/(\$Self->\{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = "$Param{$Key}";/g;
                }
            }
            $Config .= $NewConfig;
        }
    }
    close $In;

    # Write new config file.
    open my $Out, '>:utf8', $ConfigFile                                             ## no critic qw(InputOutput::RequireEncodingWithUTF8Layer OTOBO::ProhibitOpen)
        or $LayoutObject->FatalError( Message => "Can't open $ConfigFile: $!" );    ## no critic qw(OTOBO::ProhibitLowPrecedenceOps)
    print $Out $Config;
    close $Out;

    return;
}

sub ConnectToDB {
    my ( $Self, %Param ) = @_;

    # Check params.
    my @NeededKeys = qw(DBType DBHost DBUser DBPassword);

    if ( $Param{InstallType} eq 'CreateDB' ) {
        push @NeededKeys, qw(OTOBODBUser OTOBODBPassword);
    }

    # For Oracle we require DBSID and DBPort.
    if ( $Param{DBType} eq 'oracle' ) {
        push @NeededKeys, qw(DBSID DBPort);
    }

    # For existing databases we require the database name.
    if ( $Param{DBType} ne 'oracle' && $Param{InstallType} eq 'UseDB' ) {
        push @NeededKeys, 'DBName';
    }

    for my $Key (@NeededKeys) {
        if ( !$Param{$Key} && $Key !~ /^(DBPassword)$/ ) {
            return (
                Successful => 0,
                Message    => "You need '$Key'!!",
                DB         => undef,
                DBH        => undef,
            );
        }
    }

    # If we do not need to create a database for OTOBO OTOBODBuser equals DBUser.
    if ( $Param{InstallType} ne 'CreateDB' ) {
        $Param{OTOBODBUser}     = $Param{DBUser};
        $Param{OTOBODBPassword} = $Param{DBPassword};
    }

    # Create DSN string for backend.
    if ( $Param{DBType} eq 'mysql' && $Param{InstallType} eq 'CreateDB' ) {
        $Param{DSN} = "DBI:mysql:database=;host=$Param{DBHost};";
    }
    elsif ( $Param{DBType} eq 'mysql' && $Param{InstallType} eq 'UseDB' ) {
        $Param{DSN} = "DBI:mysql:database=;host=$Param{DBHost};database=$Param{DBName}";
    }
    elsif ( $Param{DBType} eq 'postgresql' && $Param{InstallType} eq 'CreateDB' ) {
        $Param{DSN} = "DBI:Pg:host=$Param{DBHost};";
    }
    elsif ( $Param{DBType} eq 'postgresql' && $Param{InstallType} eq 'UseDB' ) {
        $Param{DSN} = "DBI:Pg:host=$Param{DBHost};dbname=$Param{DBName}";
    }
    elsif ( $Param{DBType} eq 'oracle' ) {
        $Param{DSN} = "DBI:Oracle://$Param{DBHost}:$Param{DBPort}/$Param{DBSID}";
    }

    # Extract driver to load for install test.
    my ($Driver) = ( $Param{DSN} =~ /^DBI:(.*?):/ );
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'DBD::' . $Driver ) ) {
        return (
            Successful => 0,
            Message    =>
                $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate( "Can't connect to database, Perl module DBD::%s not installed!", $Driver ),
            Comment => "",
            DB      => undef,
            DBH     => undef,
        );
    }

    my $DBH = DBI->connect(
        $Param{DSN}, $Param{DBUser}, $Param{DBPassword},
    );

    if ( !$DBH ) {
        return (
            Successful => 0,
            Message    => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate("Can't connect to database, read comment!"),
            Comment    => "$DBI::errstr",
            DB         => undef,
            DBH        => undef,
        );
    }

    # If we use an existing database, check if it already contains tables.
    if ( $Param{InstallType} ne 'CreateDB' ) {

        my $Data = $DBH->selectall_arrayref('SELECT * FROM valid');
        if ($Data) {
            return (
                Successful => 0,
                Message    => $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate("Database already contains data - it should be empty!"),
                Comment    => "",
                DB         => undef,
                DBH        => undef,
            );
        }
    }

    return (
        Successful => 1,
        Message    => '',
        Comment    => '',
        DB         => \%Param,
        DBH        => $DBH,
    );
}

sub CheckDBRequirements {
    my ( $Self, %Param ) = @_;

    my %Result       = $Self->ConnectToDB(%Param);
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Version checks are only active for some database systems.
    # See https://doc.otobo.org/manual/installation/11.0/en/content/requirements.html#software-requirements
    my %RequiredVersion = (
        mysql   => '5.6',
        mariadb => '10.0',

        # postgresql => '9.2',   version check not implemented and tested yet
        # oracle     => '10g',   version check not implemented and tested yet
    );
    if ( $RequiredVersion{ $Param{DBType} } ) {

        # Compare versions with version.pm as this module is always available. It is a core module.
        # MariaDB reports version like 10.5.20-MariaDB-1:10.5.20+maria~ubu2004. That string needs to be normlized.
        my $ReportedVersion = $Result{DBH}->get_info( $DBI::Const::GetInfoType::GetInfoType{SQL_DBMS_VER} );
        my $DBType          = $Param{DBType};
        if ( $ReportedVersion =~ m/MariaDB/ ) {
            $DBType = 'mariadb';

            # In some environments the reported version is prefixed with the string '5.5.5-' so that we get
            # something like "5.5.5-10.6.12-MariaDB-0ubuntu0.22.04.1".
            # This prefix is meant for allowing replication between MariaDB and MySQL, see https://jira.mariadb.org/browse/MDEV-4088.
            # Remove it for the sake of this sanity check.
            $ReportedVersion =~ s/^\Q5.5.5-\E//;
        }
        my ($CleanedReportedVersion) = $ReportedVersion =~ m/([\d.]+)/;               # extract e.g. 10.5.20
        my $Have                     = version->parse($CleanedReportedVersion);
        my $Want                     = version->parse( $RequiredVersion{$DBType} );
        if ( $Have < $Want ) {
            $Result{Successful} = 0;
            $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                'Error: database version requirement not satisfied. Have version: %s Want version: %s',
                $Have,
                $Want
            );
        }
    }

    # Check max_allowed_packet for MySQL
    if ( $Param{DBType} eq 'mysql' && $Result{Successful} == 1 ) {

        # max_allowed_packet should be at least 64 MB
        my $MySQLMaxAllowedPacketRecommended = 64;
        my $Data                             = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'max_allowed_packet'");
        my $MySQLMaxAllowedPacket            = $Data->[0]->[1] / 1024 / 1024;
        if ( $MySQLMaxAllowedPacket < $MySQLMaxAllowedPacketRecommended ) {
            $Result{Successful} = 0;
            $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                "Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.",
                $MySQLMaxAllowedPacketRecommended, $MySQLMaxAllowedPacket
            );
        }
    }

    # Check innodb_log_file_size.
    if ( $Param{DBType} eq 'mysql' && $Result{Successful} == 1 ) {

        my $MySQLInnoDBLogFileSize            = 0;
        my $MySQLInnoDBLogFileSizeMinimum     = 256;
        my $MySQLInnoDBLogFileSizeRecommended = 512;

        # Default storage engine variable has changed its name in MySQL 5.5.3, we need to support both of them for now.
        #   <= 5.5.2 storage_engine
        #   >= 5.5.3 default_storage_engine
        my $DataOld              = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'storage_engine'");
        my $DataNew              = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'default_storage_engine'");
        my $DefaultStorageEngine = ( $DataOld->[0] && $DataOld->[0]->[1] ? $DataOld->[0]->[1] : undef )
            // ( $DataNew->[0] && $DataNew->[0]->[1] ? $DataNew->[0]->[1] : '' );

        if ( lc $DefaultStorageEngine eq 'innodb' ) {

            my $Data = $Result{DBH}->selectall_arrayref("SHOW variables WHERE Variable_name = 'innodb_log_file_size'");
            $MySQLInnoDBLogFileSize = $Data->[0]->[1] / 1024 / 1024;

            if ( $MySQLInnoDBLogFileSize < $MySQLInnoDBLogFileSizeMinimum ) {
                $Result{Successful} = 0;
                $Result{Message}    = $LayoutObject->{LanguageObject}->Translate(
                    "Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.",
                    $MySQLInnoDBLogFileSizeMinimum,
                    $MySQLInnoDBLogFileSize,
                    $MySQLInnoDBLogFileSizeRecommended,
                    'https://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html',
                );
            }
        }
    }

    # Delete not necessary key/value pairs.
    delete $Result{DB};
    delete $Result{DBH};

    return %Result;
}

sub CheckMailConfiguration {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Result;

    # First check outbound mail config.
    my $OutboundMailType =
        $ParamObject->GetParam( Param => 'OutboundMailType' );

    if ($OutboundMailType) {

        my $SMTPHost = $ParamObject->GetParam( Param => 'SMTPHost' );
        my $SMTPPort = $ParamObject->GetParam( Param => 'SMTPPort' );
        my $SMTPAuthUser =
            $ParamObject->GetParam( Param => 'SMTPAuthUser' );
        my $SMTPAuthPassword =
            $ParamObject->GetParam( Param => 'SMTPAuthPassword' );

        # If chosen config option is SMTP, set some Config params.
        if ( $OutboundMailType ne 'sendmail' ) {
            $ConfigObject->Set(
                Key   => 'SendmailModule',
                Value => 'Kernel::System::Email::' . uc($OutboundMailType),
            );
            $ConfigObject->Set(
                Key   => 'SendmailModule::Host',
                Value => $SMTPHost,
            );
            $ConfigObject->Set(
                Key   => 'SendmailModule::Port',
                Value => $SMTPPort,
            );
            if ($SMTPAuthUser) {
                $ConfigObject->Set(
                    Key   => 'SendmailModule::AuthUser',
                    Value => $SMTPAuthUser,
                );
            }
            if ($SMTPAuthPassword) {
                $ConfigObject->Set(
                    Key   => 'SendmailModule::AuthPassword',
                    Value => $SMTPAuthPassword,
                );
            }
        }

        # If sendmail, set config to sendmail.
        else {
            $ConfigObject->Set(
                Key   => 'SendmailModule',
                Value => 'Kernel::System::Email::Sendmail',
            );
        }

        # If config option SMTP and no SMTP host given, return with error.
        if ( $OutboundMailType ne 'sendmail' && !$SMTPHost ) {
            return (
                Successful => 0,
                Message    => 'No SMTP Host given!'
            );
        }

        # Create communication log object for passing it on to check functions
        my $CommunicationLogObject = $Kernel::OM->Create(
            'Kernel::System::CommunicationLog',
            ObjectParams => {
                Transport => 'Email',
                Direction => 'Outgoing',
            },
        );

        # Check outbound mail configuration.
        my $SendObject = $Kernel::OM->Get('Kernel::System::Email');

        my $Status = 'Successful';

        %Result = $SendObject->Check(
            CommunicationLogObject => $CommunicationLogObject,
        );

        if ( !$Result{Successful} ) {
            $Status = 'Failed';
        }

        my $CommunicationLogSuccess = $CommunicationLogObject->CommunicationStop(
            Status => $Status,
        );

        if ( !$CommunicationLogSuccess ) {
            return (
                Successful => 0,
                Message    => 'Communication log could not be closed!'
            );
        }

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            LockAll => 1,
            Force   => 1,
            UserID  => 1,
        );

        # If SMTP check was successful, write data into config.
        my $SendmailModule = $ConfigObject->Get('SendmailModule');
        if (
            $Result{Successful}
            && $SendmailModule ne 'Kernel::System::Email::Sendmail'
            )
        {
            my %NewConfigs = (
                'SendmailModule'       => $SendmailModule,
                'SendmailModule::Host' => $SMTPHost,
                'SendmailModule::Port' => $SMTPPort,
            );

            for my $SettingName ( sort keys %NewConfigs ) {
                $SysConfigObject->SettingUpdate(
                    Name              => $SettingName,
                    IsValid           => 1,
                    EffectiveValue    => $NewConfigs{$SettingName},
                    ExclusiveLockGUID => $ExclusiveLockGUID,
                    UserID            => 1,
                );
            }

            if ( $SMTPAuthUser && $SMTPAuthPassword ) {
                %NewConfigs = (
                    'SendmailModule::AuthUser'     => $SMTPAuthUser,
                    'SendmailModule::AuthPassword' => $SMTPAuthPassword,
                );

                for my $SettingName ( sort keys %NewConfigs ) {
                    $SysConfigObject->SettingUpdate(
                        Name              => $SettingName,
                        IsValid           => 1,
                        EffectiveValue    => $NewConfigs{$SettingName},
                        ExclusiveLockGUID => $ExclusiveLockGUID,
                        UserID            => 1,
                    );
                }
            }
        }

        # If sendmail check was successful, write data into config.
        elsif (
            $Result{Successful}
            && $SendmailModule eq 'Kernel::System::Email::Sendmail'
            )
        {
            $SysConfigObject->SettingUpdate(
                Name              => 'SendmailModule',
                IsValid           => 1,
                EffectiveValue    => $ConfigObject->Get('SendmailModule'),
                ExclusiveLockGUID => $ExclusiveLockGUID,
                UserID            => 1,
            );
        }

        # Now check inbound mail config. return if the outbound config threw an error.
        if ( !$Result{Successful} ) {
            return %Result;
        }

    }

    # Check inbound mail config.
    my $MailAccount = $Kernel::OM->Get('Kernel::System::MailAccount');

    my $InboundMailType =
        $ParamObject->GetParam( Param => 'InboundMailType' );

    if ($InboundMailType) {

        for (qw(InboundUser InboundPassword InboundHost)) {
            if ( !$ParamObject->GetParam( Param => $_ ) ) {
                return (
                    Successful => 0,
                    Message    => "Missing parameter: $_!"
                );
            }
        }

        my $InboundUser = $ParamObject->GetParam( Param => 'InboundUser' );
        my $InboundPassword =
            $ParamObject->GetParam( Param => 'InboundPassword' );
        my $InboundHost = $ParamObject->GetParam( Param => 'InboundHost' );

        %Result = $MailAccount->MailAccountCheck(
            Login    => $InboundUser,
            Password => $InboundPassword,
            Host     => $InboundHost,
            Type     => $InboundMailType,
            Timeout  => '60',
            Debug    => '0',
        );

        # If successful, add mail account to DB.
        if ( $Result{Successful} ) {
            my $ID = $MailAccount->MailAccountAdd(
                Login         => $InboundUser,
                Password      => $InboundPassword,
                Host          => $InboundHost,
                Type          => $InboundMailType,
                ValidID       => 1,
                Trusted       => 0,
                DispatchingBy => 'From',
                QueueID       => 1,
                UserID        => 1,
            );

            if ( !$ID ) {
                return (
                    Successful => 0,
                    Message    => 'Error while adding mail account!'
                );
            }
        }

    }

    return %Result;
}

sub _CheckConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @Result = $SysConfigObject->ConfigurationSearch(
        Search => 'ProductName',
    );

    return 1 if @Result;

    # read files in Kernel/Config/Files/XML
    return $SysConfigObject->ConfigurationXML2DB(
        UserID  => 1,
        Force   => 1,
        CleanUp => 1,
    );
}

1;
