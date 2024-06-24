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

package Kernel::Modules::MigrateFromOTRS;
## nofilter(TidyAll::Plugin::OTOBO::Perl::DBObject)

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules
use Kernel::Language              qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Class, %Param ) = @_;

    # Allocate new hash for object.
    return bless {%Param}, $Class;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $CacheTTL = 60 * 60 * 24 * 7;    # 1 week

    # get object manager singletons
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        $LayoutObject->FatalError(
            Message => Translatable('SecureMode active!'),
            Comment => Translatable('If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.'),
        );
    }

    # Check environment directories.
    {
        my $Home = $ConfigObject->Get('Home');

        if ( !-d $Home ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Directory "%s" doesn\'t exist!', $Home ),
                Comment => Translatable('Configure "Home" in Kernel/Config.pm first!'),
            );
        }

        if ( !-f "$Home/Kernel/Config.pm" ) {
            $LayoutObject->FatalError(
                Message => $LayoutObject->{LanguageObject}->Translate( 'File "%s/Kernel/Config.pm" not found!', $$Home ),
                Comment => Translatable('Please contact the administrator.'),
            );
        }
    }

    # start at the beginning per default
    $Self->{Subaction} ||= 'Intro';

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # perform the requested AJAX task
    my $AJAXTask = $ParamObject->GetParam( Param => 'Task' );
    if ($AJAXTask) {
        my $Return                = {};                                                    # the AJAX response that will be sent back to the browser
        my $MigrateFromOTRSObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS');

        if ( $Self->{Subaction} eq 'GetProgress' && $AJAXTask eq 'GetProgress' ) {

            my $Status = $CacheObject->Get(
                Type => 'OTRSMigration',
                Key  => 'MigrationState',
            );

            if ($Status) {
                my $Now     = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
                my $Seconds = $Now - $Status->{StartTime};
                my $TimeSpent;
                if ( $Seconds >= 3600 ) {
                    $TimeSpent = sprintf '%d h ', int( $Seconds / 3600 );
                    $Seconds %= 3600;
                }
                if ( $Seconds >= 60 || $TimeSpent ) {
                    $TimeSpent .= sprintf '%02d m ', int( $Seconds / 60 );
                    $Seconds %= 60;
                }
                $TimeSpent .= sprintf '%02d s', $Seconds;

                $Return = {
                    Task      => $Status->{Task},
                    SubTask   => $Status->{SubTask},
                    TimeSpent => $TimeSpent,
                    Continue  => 1,
                };
            }
        }
        elsif ( $Self->{Subaction} eq 'Intro' && $AJAXTask eq 'ClearCache' ) {
            for my $Step (qw/Intro OTRSFileSettings OTRSDBSettings Copy/) {
                $CacheObject->Delete(
                    Type => 'OTRSMigration',
                    Key  => $Step,
                );
            }
            $Return = { Successful => 1 };
        }
        elsif ( $Self->{Subaction} eq 'OTRSFileSettings' && $AJAXTask eq 'CheckSettings' ) {
            my %GetParam;
            for my $Key (qw/OTRSLocation FQDN SSHUser Password Port OTRSHome/) {
                $GetParam{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
                chomp( $GetParam{$Key} );
                $GetParam{$Key} =~ s/^\s+//;
                $GetParam{$Key} =~ s/\s+$//;
            }
            $GetParam{OTRSHome} =~ s/\/+$//;

            $CacheObject->Set(
                Type  => 'OTRSMigration',
                Key   => $Self->{Subaction},
                Value => \%GetParam,
                TTL   => $CacheTTL,
            );
            $Return = $MigrateFromOTRSObject->Run(
                Task     => 'OTOBOOTRSConnectionCheck',
                UserID   => 1,
                OTRSData => \%GetParam,
            );
        }
        elsif ( $Self->{Subaction} eq 'OTRSDBSettings' && $AJAXTask eq 'CheckSettings' ) {
            my %GetParam;
            for my $Key (qw/DBType DBHost DBUser DBPassword DBName DBDSN SkipDBMigration/) {
                $GetParam{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
                chomp $GetParam{$Key};
                $GetParam{$Key} =~ s/^\s+//;
                $GetParam{$Key} =~ s/\s+$//;
            }
            $GetParam{DBDSN} =
                $GetParam{DBType} eq 'mysql'      ? "DBI:mysql:database=;host=$GetParam{DBHost};" :
                $GetParam{DBType} eq 'postgresql' ? "DBI:Pg:host=$GetParam{DBHost};" :
                $GetParam{DBType} eq 'oracle'     ? $GetParam{DBDSN} :
                '';

            $CacheObject->Set(
                Type  => 'OTRSMigration',
                Key   => $Self->{Subaction},
                Value => \%GetParam,
                TTL   => $CacheTTL,
            );

            # skip if db migration is already done
            if ( $GetParam{SkipDBMigration} ) {
                $Return = { Successful => 1 };
            }

            # "normal" migration
            else {
                $Return = $MigrateFromOTRSObject->Run(
                    Task   => 'OTOBOOTRSDBCheck',
                    UserID => 1,
                    DBData => \%GetParam,
                );
            }
        }
        elsif ( $Self->{Subaction} eq 'PreChecks' || $Self->{Subaction} eq 'Copy' ) {

            my @Taskorder;
            if ( $Self->{Subaction} eq 'PreChecks' ) {
                @Taskorder = qw(
                    OTOBOFrameworkVersionCheck
                    OTOBOPerlModulesCheck
                );

                #                    OTOBOOTRSPackageCheck
            }
            elsif ( $Self->{Subaction} eq 'Copy' ) {
                @Taskorder = qw(
                    OTOBODatabaseMigrate
                    OTOBOCopyFilesFromOTRS
                    OTOBOMigrateConfigFromOTRS
                    OTOBONotificationMigrate
                    OTOBOStatsMigrate
                    OTOBOItsmTablesMigrate
                    OTOBOAutoResponseTemplatesMigrate
                    OTOBOResponseTemplatesMigrate
                    OTOBOSalutationsMigrate
                    OTOBOSignaturesMigrate
                    OTOBOPostmasterFilterMigrate
                    OTOBOACLDeploy
                    OTOBOMigrateWebServiceConfiguration
                    OTOBOProcessDeploy
                    OTOBOCacheCleanup
                    OTOBOPackageSpecifics
                );
            }

            my %NextTask = map { $Taskorder[$_] => $Taskorder[ $_ + 1 ] // '' } ( 0 .. $#Taskorder );

            # check task
            if ( !defined $NextTask{$AJAXTask} ) {
                $Return = $Self->_TaskError($AJAXTask);
            }

            # perform the task
            else {
                my $OTRSData = $CacheObject->Get(
                    Type => 'OTRSMigration',
                    Key  => 'OTRSFileSettings',
                );
                my $DBData = $CacheObject->Get(
                    Type => 'OTRSMigration',
                    Key  => 'OTRSDBSettings',
                );
                my $Resolve = $CacheObject->Get(
                    Type => 'OTRSMigration',
                    Key  => 'Copy',
                );

                my $PerlTask = $AJAXTask;
                $PerlTask =~ s/:.+$//;
                my $Result;
                eval {
                    $Result = $MigrateFromOTRSObject->Run(
                        Task           => $PerlTask,
                        UserID         => 1,
                        OTRSData       => $OTRSData // {},
                        DBData         => $DBData   // {},
                        PackageResolve => $Resolve  // {},
                    );
                };
                if ( !$Result || !defined $Result->{Successful} ) {
                    $Result->{Successful} = 0;
                    $Result->{Message}    = $AJAXTask;
                    $Result->{Comment}    = 'A fatal error occured.';

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Could not complete $AJAXTask! $@",
                    );
                }

                # check if progress update has to be stopped
                if ( $Self->{Subaction} eq 'Copy' && ( !$NextTask{$AJAXTask} || !$Result->{Successful} ) ) {
                    my $Status = $CacheObject->Delete(
                        Type => 'OTRSMigration',
                        Key  => 'MigrationState',
                    );
                }

                # store next task in cache in case of a restart
                if ( $Self->{Subaction} eq 'Copy' && $Result->{Successful} ) {
                    $CacheObject->Set(
                        Type  => 'OTRSMigration',
                        Key   => 'Copy',
                        Value => {
                            LastTask => $AJAXTask,
                            NextTask => $NextTask{$AJAXTask},
                        }
                    );
                }

                $Return = {
                    $Result->%*,
                    NextTask => $NextTask{$AJAXTask},
                };
            }
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Nothing to do for Subaction: '$Self->{Subaction}' and Task: '$AJAXTask'!",
            );
            $Return = {
                Message    => "Server error.",
                Comment    => "Cannot be resolved.",
                Successful => 0,
            };
        }

        # Return AJAX response content as as Perl string.
        # The output should not be encoded because the content
        # will be encoded in otobo.psgi. Double encoding is bad.
        my $OutputJSON = $LayoutObject->JSONEncode( Data => $Return );

        return $LayoutObject->Attachment(
            ContentType => 'application/json',
            Content     => $OutputJSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # if this is not an AJAX request, then build the HTML for the current subaction

    # generate current title
    my $Title     = $LayoutObject->{LanguageObject}->Translate('OTRS to OTOBO migration');
    my %Subtitles = (
        Intro            => 'Intro',
        OTRSFileSettings => 'OTRS server and path',
        OTRSDBSettings   => 'OTRS database settings',
        PreChecks        => 'Preliminary checks',
        Copy             => 'System migration',
        Finish           => 'Finish',
    );
    my $CurrentSubtitle = $LayoutObject->{LanguageObject}->Translate( $Subtitles{ $Self->{Subaction} } );

    # Build steps.
    my @Steps = qw(
        OTRSFileSettings
        OTRSDBSettings
        PreChecks
        Copy
        Finish
    );

    # Build header
    $LayoutObject->Block(
        Name => 'Steps',
        Data => {
            Steps => scalar @Steps,
        },
    );

    # for displaying progress
    my $StepCounter = '';

    # overview over the steps
    {
        # On the intro screen no steps should be highlighted.
        my $Highlight     = $Self->{Subaction} eq 'Intro' ? '' : 'Highlighted NoLink';
        my $TotalNumSteps = scalar @Steps;
        my $Counter       = 0;
        for my $Step (@Steps) {
            $Counter++;

            # Is the current step active?
            my $Active = $Self->{Subaction} eq $Step ? 'Active' : '';
            $LayoutObject->Block(
                Name => 'SingleStep',
                Data => {
                    Step        => $Counter,
                    Highlight   => $Highlight,
                    Active      => $Active,
                    Description => $LayoutObject->{LanguageObject}->Translate( $Subtitles{$Step} ),
                },
            );

            # If this is the actual step.
            if ( $Self->{Subaction} eq $Step ) {

                # No more highlights from now on.
                $Highlight = '';

                # Step calculation: 2/5 etc.
                $StepCounter = "$Counter/$TotalNumSteps";
            }
        }
    }

    # get previously cached data or default settings for the subaction
    my %FieldData;
    {
        my $CachedData = $CacheObject->Get(
            Type => 'OTRSMigration',
            Key  => $Self->{Subaction},
        ) // {};

        %FieldData = $CachedData->%*;

        # Use defaults for various settings, unless we have cached data
        if ( !IsHashRefWithData($CachedData) ) {

            # Under Docker we assume that /opt/otrs has been copied into the otobo_opt_otobo volume.
            my $DefaultOTRSHome = $ENV{OTOBO_RUNS_UNDER_DOCKER} ? '/opt/otobo/var/tmp/copied_otrs' : '/opt/otrs';
            my %Defaults        = (
                Intro => {
                    Subaction => 'OTRSFileSettings',
                },
                OTRSFileSettings => {
                    OTRSLocation => 'localhost',
                    OTRSHome     => $DefaultOTRSHome,
                },
                OTRSDBSettings => {
                    DBName => 'otrs',
                    DBUser => 'otrs',
                },
                PreChecks => {
                    NextTask => 'OTOBOFrameworkVersionCheck',
                },
                Copy => {
                    NextTask => 'OTOBODatabaseMigrate',
                },
            );

            if ( $Defaults{ $Self->{Subaction} } ) {
                %FieldData = $Defaults{ $Self->{Subaction} }->%*;
            }
        }
    }

    # prepare selections
    my %Selections = (
        OTRSFileSettings => {
            OTRSLocation => {
                localhost => 'localhost',
                remote    => 'remote',
            },
        },
        OTRSDBSettings => {
            DBType => {
                mysql      => 'MySQL',
                postgresql => 'PostgreSQL',
                oracle     => 'Oracle',
            },
        },
    );

    if ( $Selections{ $Self->{Subaction} } ) {
        for my $FieldID ( sort keys %{ $Selections{ $Self->{Subaction} } } ) {
            $FieldData{"Select$FieldID"} = $LayoutObject->BuildSelection(
                Data       => $Selections{ $Self->{Subaction} }{$FieldID},
                Name       => $FieldID,
                Class      => 'Modernize',
                Size       => scalar keys %{ $Selections{ $Self->{Subaction} }{$FieldID} },
                SelectedID => $FieldData{$FieldID} || '',
            );
        }
    }

    # automatic package resolve disabled
    #    # collect information for some steps
    #    if ( $Self->{Subaction} eq 'Copy' ) {
    #        # get incompatible packages resolve info
    #        my @ParamNames = $ParamObject->GetParamNames();
    #        my %Packages = ();
    #        for my $Name ( @ParamNames ) {
    #            if ( $Name =~ s/^Package_// ) {
    #                $Packages{ $Name } = $ParamObject->GetParam( Param => "Package_$Name" );
    #            }
    #        }
    #        $CacheObject->Set(
    #            Type  => 'OTRSMigration',
    #            Key   => 'Copy',
    #            Value => {
    #                PackageResolve => \%Packages,
    #            }
    #        );
    #    }

    if ( $Self->{Subaction} eq 'Intro' ) {

        # for the HTTP check in Intro.tt
        $FieldData{Scheme} = $ParamObject->HttpsIsOn ? 'https' : 'http';
    }
    else {
        # cache progress
        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'Intro',
            Value => {
                Cache     => 1,
                Subaction => $Self->{Subaction},
            }
        );
    }

    # clean up automatically in the end
    if ( $Self->{Subaction} eq 'Finish' ) {
        my $SystemInfo = $Self->_Finish(
            CacheObject  => $CacheObject,
            LayoutObject => $LayoutObject,
            ConfigObject => $ConfigObject,
        );
        %FieldData = (
            %{$SystemInfo},
            %FieldData,
        );
    }

    # generate HTML for the current step
    $LayoutObject->Block(
        Name => $Self->{Subaction},
        Data => {
            Item => $CurrentSubtitle,
            Step => $StepCounter // '',
            %FieldData,
        },
    );
    if ( $Self->{Subaction} eq 'Finish' && $FieldData{Webserver} ) {
        $LayoutObject->Block(
            Name => 'Restart',
            Data => {
                Webserver => $FieldData{Webserver},
            },
        );
    }

    return join '',
        $LayoutObject->Header(
            Title => "$Title - $CurrentSubtitle",
        ),
        $LayoutObject->Output(
            TemplateFile => 'MigrateFromOTRS',
            Data         => {},
        ),
        $LayoutObject->Footer();
}

sub _Finish {
    my ( $Self, %Param ) = @_;

    # Take care that default config is in the database.
    return $Param{LayoutObject}->FatalError() unless $Self->_CheckConfig();

    # Delete migration cache
    my $Status = $Param{CacheObject}->CleanUp(
        Type => 'OTRSMigration',
    );

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $SettingName = 'SecureMode';

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $SettingName,
        Force  => 1,
        UserID => 1,
    );

    # Update config item via SysConfig object.
    my %Result = $SysConfigObject->SettingUpdate(
        Name              => $SettingName,
        IsValid           => 1,
        EffectiveValue    => 1,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Result{Success} ) {
        return $Param{LayoutObject}->FatalError(
            Message => Translatable(q{Can't activate SecureMode: }) . $Result{Error}
        );
    }

    # There is no need to unlock the setting as it was already unlocked in the update.

    # 'Rebuild' the configuration.
    $SysConfigObject->ConfigurationDeploy(
        Comments    => "MigrateFromOTRS deployment",
        AllSettings => 1,
        Force       => 1,
        UserID      => 1,
    );

    # A restart should never be needed as otobo.psgi checks for changed modules.
    # But keep the old code for future reference.
    my $Webserver;
    if (0) {
        $Webserver = 'systemctl restart apache2';
        if ( -f '/etc/SuSE-release' ) {
            $Webserver = 'rcapache2 restart';
        }
        elsif ( -f '/etc/redhat-release' ) {
            $Webserver = 'service httpd restart';
        }
    }

    # get object manager singletons
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # index.pl is appended in the template
    my $OTOBOHandle = $ParamObject->ScriptName();
    $OTOBOHandle =~ s/\/(.*)\/migration\.pl/$1/;

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

    return {
        Webserver   => $Webserver,
        Scheme      => $Scheme,
        OTOBOHandle => $OTOBOHandle,
        Host        => $Host,
    };
}

sub _CheckConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @Result = $SysConfigObject->ConfigurationSearch(
        Search => 'ProductName',
    );

    return 1 if @Result;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # TODO: is this still needed? ConfigurationXML2DB is already called on OTOBOMigrateConfigFromOTRS
    return $SysConfigObject->ConfigurationXML2DB(
        UserID    => 1,
        Directory => "$Home/Kernel/Config/Files/XML",
        Force     => 1,
        CleanUp   => 1,
    );
}

sub _TaskError {
    my ( $Self, $Task ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "Task '$Task' not defined for $Self->{Subaction}!",
    );

    return {
        Message => "An error occured.",
        Comment => "Task '$Task' not defined for $Self->{Subaction}!",
        Success => 0,
    };
}

1;
