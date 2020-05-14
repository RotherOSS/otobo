# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2020 Rother OSS GmbH, https://otobo.de/
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
## nofilter(TidyAll::Plugin::OTOBO::Perl::Print)

use strict;
use warnings;

use DBI;
use Net::Domain qw(hostfqdn);
use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

use vars qw(%INC);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $CacheTTL = 60 * 60 * 24 * 7;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        $LayoutObject->FatalError(
            Message => Translatable('SecureMode active!'),
            Comment => Translatable(
                'If you want to re-run the MigrateFromOTRS Tool, disable the SecureMode in the SysConfig.'
            ),
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

    # Check/get SQL schema directory
    my $DirOfSQLFiles = $Self->{Path} . '/scripts/database';
    if ( !-d $DirOfSQLFiles ) {
        $LayoutObject->FatalError(
            Message => $LayoutObject->{LanguageObject}->Translate( 'Directory "%s" not found!', $DirOfSQLFiles ),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    $Self->{Subaction} = 'Intro' if !$Self->{Subaction};

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $AJAXTask = $ParamObject->GetParam( Param => 'Task' );

    # perform various AJAX tasks
    if ( $AJAXTask ) {
        my $Return;
        my $MigrateFromOTRSObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS');

        if ( $Self->{Subaction} eq 'GetProgress' && $AJAXTask eq 'GetProgress' ) {
            my $Status = $CacheObject->Get(
                Type  => 'OTRSMigration',
                Key   => 'MigrationState',
            );

            if ( !$Status ) {
                $Return = {};
            }
            else {
                my $Now = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();
                my $Time = $Now - $Status->{StartTime};
                my $TimeSpent;
                if ( $Time >= 3600 ) {
                    $TimeSpent = sprintf "%d h ", int( $Time/3600 );
                    $Time = $Time % 3600;
                }
                if ( $Time >= 60 || $TimeSpent ) {
                    $TimeSpent .= sprintf "%02d m ", int( $Time/60 );
                    $Time = $Time % 60;
                }
                $TimeSpent .= sprintf "%02d s", $Time;

                $Return = {
                    Task      => $Status->{Task},
                    SubTask   => $Status->{SubTask},
                    TimeSpent => $TimeSpent,
                    Continue  => 1,
                };
            }

        }

        elsif ( $Self->{Subaction} eq 'Intro' && $AJAXTask eq 'ClearCache' ) {
            for my $Step ( qw/Intro OTRSFileSettings OTRSDBSettings Copy/ ) {
                $CacheObject->Delete(
                    Type  => 'OTRSMigration',
                    Key   => $Step,
                );
            }
            $Return = { Successful => 1 };
        }

        elsif ( $Self->{Subaction} eq 'OTRSFileSettings' && $AJAXTask eq 'CheckSettings' ) {
            my %GetParam;
            for my $Key ( qw/OTRSLocation FQDN SSHUser Password Port OTRSHome/ ) {
                $GetParam{ $Key } = $ParamObject->GetParam( Param => $Key ) // '';
                chomp( $GetParam{ $Key } );
                $GetParam{ $Key } =~ s/^\s+//;
                $GetParam{ $Key } =~ s/\s+$//;
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
            )->{ 'OTOBOOTRSConnectionCheck' };
        }

        elsif ( $Self->{Subaction} eq 'OTRSDBSettings' && $AJAXTask eq 'CheckSettings' ) {
            my %GetParam;
            for my $Key ( qw/DBType DBHost DBUser DBPassword DBName DBSID DBPort/ ) {
                $GetParam{ $Key } = $ParamObject->GetParam( Param => $Key ) // '';
                chomp( $GetParam{ $Key } );
                $GetParam{ $Key } =~ s/^\s+//;
                $GetParam{ $Key } =~ s/\s+$//;
            }
            $GetParam{DBDSN} =
                $GetParam{DBType} eq 'mysql'      ? "DBI:mysql:database=;host=$GetParam{DBHost};" :
                $GetParam{DBType} eq 'postgresql' ? "DBI:Pg:host=$GetParam{DBHost};" :
                $GetParam{DBType} eq 'oracle'     ? "DBI:Oracle://$GetParam{DBHost}:$GetParam{DBPort}/$GetParam{DBSID}" : '';

            $CacheObject->Set(
                Type  => 'OTRSMigration',
                Key   => $Self->{Subaction},
                Value => \%GetParam,
                TTL   => $CacheTTL,
            );
            $Return = $MigrateFromOTRSObject->Run(
                Task     => 'OTOBOOTRSDBCheck',
                UserID   => 1,
                DBData => \%GetParam,
            )->{ 'OTOBOOTRSDBCheck' };
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
                    OTOBOCacheCleanup
                    OTOBORebuildConfigCleanup
                    OTOBOMigrateConfigFromOTRS
                    OTOBOCacheCleanup:1
                    OTOBORebuildConfigCleanup:1
                    OTOBONotificationMigrate
                    OTOBOAutoResponseTemplatesMigrate
                    OTOBOResponseTemplatesMigrate
                    OTOBOSalutationsMigrate
                    OTOBOSignaturesMigrate
                    OTOBOACLDeploy
                    OTOBOMigrateWebServiceConfiguration
                    OTOBOProcessDeploy
                    OTOBOCacheCleanup:2
                    OTOBORebuildConfig
                    OTOBORebuildConfigCleanup:2
                    OTOBOCacheCleanup:3
                    OTOBOInvalidSettingsCheck
                );
            }
            my %NextTask = map { $Taskorder[$_] => $Taskorder[$_+1] // '' } (0..$#Taskorder);

            # check task
            if ( !defined $NextTask{ $AJAXTask } ) {
                $Return = $Self->_TaskError( $AJAXTask );
            }

            # perform the task
            else {
                my $OTRSData = $CacheObject->Get(
                    Type  => 'OTRSMigration',
                    Key   => 'OTRSFileSettings',
                );
                my $DBData = $CacheObject->Get(
                    Type  => 'OTRSMigration',
                    Key   => 'OTRSDBSettings',
                );
                my $Resolve = $CacheObject->Get(
                    Type  => 'OTRSMigration',
                    Key   => 'Copy',
                );

                my $PerlTask = $AJAXTask;
                $PerlTask =~ s/:.+$//;
                my $Result;
                eval {
                    $Result = $MigrateFromOTRSObject->Run(
                        Task           => $PerlTask,
                        UserID         => 1,
                        OTRSData       => $OTRSData // {},
                        DBData         => $DBData // {},
                        PackageResolve => $Resolve // {},
                    );
                };
                if ( !$Result || !defined $Result->{ $PerlTask }{Successful} ) {
                    $Result->{ $PerlTask }{Successful} = 0;
                    $Result->{ $PerlTask }{Message} = $AJAXTask;
                    $Result->{ $PerlTask }{Comment} = 'A fatal error occured.';

                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Could not complete $AJAXTask! $@",
                    );
                }

                # check if progress update has to be stopped
                if ( $Self->{Subaction} eq 'Copy' && ( !$NextTask{ $AJAXTask } || !$Result->{ $PerlTask }{Successful} ) ) {
                    my $Status = $CacheObject->Delete(
                        Type  => 'OTRSMigration',
                        Key   => 'MigrationState',
                    );
                }
                # store next task in cache in case of a restart
                if ( $Self->{Subaction} eq 'Copy' && $Result->{ $PerlTask }{Successful}  ) {
                    $CacheObject->Set(
                        Type  => 'OTRSMigration',
                        Key   => 'Copy',
                        Value => {
                            LastTask => $AJAXTask,
                            NextTask => $NextTask{ $AJAXTask },
                        }
                    );
                }

                $Return = {
                    %{ $Result->{ $PerlTask } },
                    NextTask => $NextTask{ $AJAXTask },
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

        # return AJAX response
        my $OutputJSON = $LayoutObject->JSONEncode( Data => $Return );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset='.$LayoutObject->{Charset},
            Content     => $OutputJSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # if this is not an AJAX request, build the html for the current subaction

    # generate current title
    my $Title = $LayoutObject->{LanguageObject}->Translate('OTRS to OTOBO migration');
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

    my $StepCounter;

    # Build header
    $LayoutObject->Block(
        Name => 'Steps',
        Data => {
            Steps => scalar @Steps,
        },
    );

    # On the intro screen no steps should be highlighted.
    my $Highlight = ( $Self->{Subaction} eq 'Intro' ) ? '' : 'Highlighted NoLink';

    my $Counter;

    for my $Step (@Steps) {
        $Counter++;

        # Is the current step active?
        my $Active = ( $Self->{Subaction} eq $Step ) ? 'Active' : '';
        $LayoutObject->Block(
            Name => 'SingleStep',
            Data => {
                Step        => $Counter,
                Highlight   => $Highlight,
                Active      => $Active,
                Description => $LayoutObject->{LanguageObject}->Translate( $Subtitles{ $Step } ),
            },
        );

        # If this is the actual step.
        if ( $Self->{Subaction} eq $Step ) {

            # No more highlights from now on.
            $Highlight = '';

            # Step calculation: 2/5 etc.
            $StepCounter = $Counter . "/" . scalar @Steps;
        }
    }

    # get previously cached data
    my $CachedData = $CacheObject->Get(
        Type  => 'OTRSMigration',
        Key   => $Self->{Subaction},
    ) // {};

    # define defaults for various settings
    my %FieldData = %{ $CachedData };
    if ( !IsHashRefWithData( $CachedData ) ) {
        my %Defaults = (
            Intro => {
                Subaction => 'OTRSFileSettings',
            },
            OTRSFileSettings => {
                OTRSLocation => 'localhost',
                OTRSHome     => '/opt/otrs/',
            },
            OTRSDBSettings => {
                DBName => 'otrs',
                DBUser => 'otrs',
                DBPort => 1521,
            },
            PreChecks => {
                NextTask => 'OTOBOFrameworkVersionCheck',
            },
            Copy => {
                NextTask => 'OTOBODatabaseMigrate',
            },
        );
        if ( $Defaults{ $Self->{Subaction} } ) {
            %FieldData = %{ $Defaults{ $Self->{Subaction} } };
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
        OTRSDBSettings   => {
            DBType => {
                mysql      => "MySQL",
                postgresql => "PostgreSQL",
                oracle     => "Oracle",
            },
        },
    );
    if ( $Selections{ $Self->{Subaction} } ) {
        for my $FieldID ( keys %{ $Selections{ $Self->{Subaction} } } ) {
            $FieldData{ "Select$FieldID" } = $LayoutObject->BuildSelection(
                Data       => $Selections{ $Self->{Subaction} }{ $FieldID },
                Name       => $FieldID,
                Class      => 'Modernize',
                Size       => scalar keys %{ $Selections{ $Self->{Subaction} }{ $FieldID } },
                SelectedID => $FieldData{ $FieldID } || '',
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

    # cache progress
    if ( $Self->{Subaction} ne 'Intro' ) {
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
            %{ $SystemInfo },
            %FieldData,
        );
    }

    # generate HTML for the current step
    my $Output = $LayoutObject->Header(
        Title => "$Title - $CurrentSubtitle",
    );
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
    $Output .= $LayoutObject->Output(
        TemplateFile => 'MigrateFromOTRS',
        Data         => {},
    );
    $Output .= $LayoutObject->Footer();

    return $Output;

}

sub _Finish {
    my ( $Self, %Param ) = @_;

    # Take care that default config is in the database.
    if ( !$Self->_CheckConfig() ) {
        return $Param{LayoutObject}->FatalError();
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $SettingName = 'SecureMode';

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
        $Param{LayoutObject}->FatalError(
            Message => Translatable('Can\'t write Config file!'),
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

    # check web server - is a restart needed?
    my $Webserver;

    # Only if we have mod_perl we have to restart.
    if ( exists $ENV{MOD_PERL} ) {
        eval 'require mod_perl';               ## no critic
        if ( defined $mod_perl::VERSION ) {    ## no critic
            $Webserver = 'systemctl restart apache2';
            if ( -f '/etc/SuSE-release' ) {
                $Webserver = 'rcapache2 restart';
            }
            elsif ( -f '/etc/redhat-release' ) {
                $Webserver = 'service httpd restart';
            }
        }
    }

    # Check if Apache::Reload is loaded.
    for my $Module ( sort keys %INC ) {
        $Module =~ s/\//::/g;
        $Module =~ s/\.pm$//g;

        if ( $Module eq 'Apache2::Reload' ) {
            $Webserver = '';
        }
    }

    # prepare link
    my $Host = $ENV{HTTP_HOST} || $Param{ConfigObject}->Get('FQDN');
    $Host =~ s/\/$//;
    my $OTOBOHandle = $ENV{SCRIPT_NAME};
    $OTOBOHandle =~ s/migration\.pl/index.pl/;

    return {
        Webserver   => $Webserver,
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
