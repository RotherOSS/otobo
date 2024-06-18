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

package Kernel::System::MigrateFromOTRS::OTOBOCopyFilesFromOTRS;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules
use File::Spec ();

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOCopyFilesFromOTRS - Copy and migrate OTRS files to OTOBO server

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

=head1 DESCRIPTION

License headers of the copied files are adapted.
The file F<Kernel/Config.pm> is also adapted for use with OTOBO.

=head1 PUBLIC INTERFACE

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success.

    my $RequirementIsMet = $MigrateFromOTRSObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    return 1;
}

=head2 Run()

Execute the migration task. Called by C<Kernel::System::MigrateFromOTRS::_ExecuteRun()>.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # For error and progress messages
    my $Message = 'Copy and migrate files from OTRS to OTOBO';

    # Set cache object with taskinfo and starttime to show current state in frontend
    {
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        my $StartTime   = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        $CacheObject->Set(
            Type  => 'OTRSMigration',
            Key   => 'MigrationState',
            Value => {
                Task      => 'OTOBOCopyFilesFromOTRS',
                SubTask   => $Message,
                StartTime => $StartTime,
            },
        );
    }

    # check needed parameters
    for my $Key (qw(OTRSData)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );

            return {
                Message    => $Self->{LanguageObject}->Translate($Message),
                Comment    => $Self->{LanguageObject}->Translate( 'Need %s!', $Key ),
                Successful => 0,
            };

        }
    }

    # check needed stuff in OTRSData
    for my $Key (qw(OTRSLocation OTRSHome)) {
        if ( !$Param{OTRSData}->{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need OTRSData->$Key!"
            );

            return {
                Message    => $Self->{LanguageObject}->Translate($Message),
                Comment    => $Self->{LanguageObject}->Translate( 'Need OTRSData->%s!', $Key ),
                Successful => 0,
            };

        }
    }

    my $OTRS6path;
    if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
        $OTRS6path = $Param{OTRSData}->{OTRSHome};
    }
    else {
        # copy the /opt/otrs tree, skipping some directories, using rsync
        $OTRS6path = $Self->CopyFileAndSaveAsTmp(
            FQDN     => $Param{OTRSData}->{FQDN},
            SSHUser  => $Param{OTRSData}->{SSHUser},
            Password => $Param{OTRSData}->{Password},
            Path     => $Param{OTRSData}->{OTRSHome},
            Port     => $Param{OTRSData}->{Port},
            UserID   => 1,
        );
    }

    if ( !$OTRS6path ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "directory $Param{OTRSData}->{OTRSHome} either missing or could not be copied",
        );

        return {
            Message    => $Self->{LanguageObject}->Translate($Message),
            Comment    => $Self->{LanguageObject}->Translate( "Can't access OTRS Home: %s!", $Param{OTRSData}->{OTRSHome} ),
            Successful => 0,
        };
    }

    # Get filelist with needed files for copy from OTRS, this includes Kernel/Config.pm
    my @FileList = $Self->CopyFileListfromOTRSToOTOBO();

    # Get filelist we only copy and not clean
    my %DoNotClean = map { $_ => 1 } $Self->DoNotCleanFileList();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Now we copy and clean the files in for{}
    my $OTOBOHome = $ConfigObject->Get('Home');
    FILE:
    for my $File (@FileList) {

        my $OTOBOPathFile = File::Spec->catfile( $OTOBOHome, $File );
        my $OTRSPathFile  = File::Spec->catfile( $OTRS6path, $File );

        # First we copy the file from OTRS HOME to OTOBO HOME
        next FILE unless -e $OTRSPathFile;

        {
            my $ExitCode;

            # We copy only the content, if OTRS exists on localhost, otherwise we move the content from tmp
            if ( -f $OTRSPathFile ) {
                if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
                    $ExitCode = system("cp $OTRSPathFile $OTOBOPathFile");
                }
                else {
                    $ExitCode = system("mv $OTRSPathFile $OTOBOPathFile");
                }

            }
            elsif ( -d $OTRSPathFile ) {
                if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
                    $ExitCode = system("cp -r $OTRSPathFile/* $OTOBOPathFile");
                }
                else {
                    $ExitCode = system("mv $OTRSPathFile/* $OTOBOPathFile");
                }
            }

            if ( $ExitCode && $ExitCode != 0 && $ExitCode != 256 ) {
                print STDERR "EXIT: $ExitCode \n OTRSPath: $OTRSPathFile\n OTOBO: $OTOBOPathFile\n ";

                return {
                    Message    => $Self->{LanguageObject}->Translate($Message),
                    Comment    => $Self->{LanguageObject}->Translate(q{Can't copy or move files from OTRS!}),
                    Successful => 0,
                };
            }
        }

        # check if we need to clean the file
        next FILE if $DoNotClean{$File};

        # We need to clean files inside a directory
        if ( -d $OTOBOPathFile ) {

            # Clean license header
            $Self->CleanLicenseHeaderInDir(
                Path      => $OTOBOPathFile,
                Filter    => '*',
                Recursive => 1,
                UserID    => 1,
            );

            $Self->CleanOTRSFilesToOTOBOStyleInDir(
                Path      => $OTOBOPathFile,
                Filter    => '*',
                Recursive => 1,
                UserID    => 1,
            );
        }

        # We need to copy only a single file
        elsif ( -f $OTOBOPathFile ) {

            $Self->CleanLicenseHeader(
                File   => $OTOBOPathFile,
                UserID => 1,
            );

            $Self->CleanOTRSFileToOTOBOStyle(
                File   => $OTOBOPathFile,
                UserID => 1,
            );
        }

        # At last we need to reconfigure basic settings in Kernel/Config.pm.
        # Some of the setting of the OTOBO Kernel/Config.pm should reinjected in the file copied from OTRS.
        # Note that the original setup with variables won't be preserved. E.g.
        #     $Self->{'DatabaseDSN'} = "DBI:Pg:dbname=$Self->{Database};host=$Self->{DatabaseHost}";
        # in the original OTOBO Kernel/Config.pm will end up as
        #     $Self->{'DatabaseDSN'} = "DBI:mysql:database=otobo;host=127.0.0.1;"; # from original OTOBO config
        # after the migration.
        if ( $OTOBOPathFile =~ m/Config\.pm/ ) {

            # remember the current basic settings, Database and installation dir
            my %OTOBOParams = map { $_ => $ConfigObject->Get($_) } qw(DatabaseHost Database DatabaseUser DatabasePw DatabaseDSN Home);

            # inject extra settings in the Docker case, see also Kernel/Config.pm.dist.docker
            my $DockerSpecificSettings = $ENV{OTOBO_RUNS_UNDER_DOCKER} ? <<'END_SETTINGS' : undef;

    # ---------------------------------------------------- #
    # setting for running OTOBO under Docker, injected by OTOBOCopyFilesFromOTRS
    # ---------------------------------------------------- #
    $Self->{'LogModule'}                   = 'Kernel::System::Log::File';
    $Self->{'LogModule::LogFile'}          = '/opt/otobo/var/log/otobo.log';
    $Self->{'Cache::Module'}               = 'Kernel::System::Cache::Redis';
    $Self->{'Cache::Redis'}->{'RedisFast'} = 1;
    $Self->{'Cache::Redis'}->{'Server'}    = 'redis:6379';
    $Self->{'Cache::Redis'}->{'Server'}    = 'redis:6379';
    $Self->{'TestHTTPHostname'}            = 'web:5000';

    # activate Selenium tests if the the host is available
    $Self->{'SeleniumTestsConfig'} = {
        remote_server_addr  => 'selenium-chrome',
        check_server_addr   => 1,                 # skip test when remote_server_addr can't be resolved via DNS
        port                => '4444',
        browser_name        => 'chrome',
        platform            => 'ANY',
    };

END_SETTINGS

            $Self->ReConfigure(
                %OTOBOParams,
                ExtraSettings => $DockerSpecificSettings
            );
        }
    }

    $Self->DisableSecureMode();

    return {
        Message    => $Self->{LanguageObject}->Translate($Message),
        Comment    => $Self->{LanguageObject}->Translate("All needed files copied and migrated, perfect!"),
        Successful => 1,
    };
}

# Fix up Kernel/Config.pm.
# Extra settings will be injected after the line that sets 'Home'.
sub ReConfigure {
    my ( $Self, %Param ) = @_;

    # extract special params
    my $ExtraSettings = delete $Param{ExtraSettings};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Perl quote and set via ConfigObject.
    for my $Key ( sort keys %Param ) {
        $ConfigObject->Set(
            Key   => $Key,
            Value => $Param{$Key},
        );

        if ( $Param{$Key} ) {
            $Param{$Key} =~ s/'/\\'/g;
        }
    }

    # Read config file that was copied from /opt/otrs
    my $ConfigFile = $ConfigObject->Get('Home') . '/Kernel/Config.pm';
    my $OTRSHomeFromConfigFile;

    # content of changed config file
    my $Config = '';
    {
        open my $In, '<:encoding(utf-8)', $ConfigFile    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
            or return "Can't open $ConfigFile: $!";      ## no critic qw(OTOBO::ProhibitLowPrecedenceOps)

        LINE:
        while ( my $Line = <$In> ) {

            # keep empty lines or comments.
            if ( !$Line || $Line =~ m/^\s*#/ || $Line =~ m/^\s*$/ ) {
                $Config .= $Line;

                next LINE;
            }

            # Other lines might be changed
            my $ChangedLine = $Line;

            # Extract the value for OTRSHomeFromConfig from the OTRS file Kernel/Config.pm from a line like:
            #   $Self->{Home} = '/opt/otrs';
            # Note that he value OTRSHome can't be used here, as the OTRS home directory might have been copied.
            if ( $ChangedLine =~ m/\$Self->\{\s*(?:"|'|)Home(?:"|'|)\s*\}\s+=\s+['"]([^'"]+)['"]/ ) {
                $OTRSHomeFromConfigFile = $1;
            }

            # Replace OTRS path with OTOBO path, usually /opt/otrs with /opt/otobo.
            # This can be useful when e.g.  LogModule::LogFile is set to '/opt/otrs/var/log/otrs.log'
            # Remember that CleanOTRSFileToOTOBOStyle() has an excemption for Config.pm, so that /opt/otrs is still in the file.
            # Attention: this assumes that custom settings come after the standard settings
            # Attention: this is an heuristic that won't give useful results for all installations.
            if ($OTRSHomeFromConfigFile) {
                $ChangedLine =~ s/$OTRSHomeFromConfigFile/$Param{Home}/;
            }

            # Need to comment out SecureMode, as it should be configured in the SysConfig
            if ( $ChangedLine =~ m/SecureMode/ ) {
                chomp $ChangedLine;
                $Config .= "# $ChangedLine  commented out by OTOBOCopyFilesFromOTRS\n";

                next LINE;
            }

            # Replace config with %Param.
            CONFIGKEY:
            for my $Key ( sort keys %Param ) {

                # Database passwords can contain characters like '@' or '$' and should be single-quoted
                #   same goes for database hosts which can be like 'myserver\instance name' for MS SQL.
                if ( $Key eq 'DatabasePw' || $Key eq 'DatabaseHost' ) {
                    $ChangedLine =~
                        s/(\$Self->\{\s*("|'|)$Key("|'|)\s*}\s+=.+?('|"));/\$Self->{'$Key'} = '$Param{$Key}'; # from original OTOBO config /g;

                    next CONFIGKEY;
                }

                # other setting double quoted
                $ChangedLine =~
                    s/(\$Self->\{\s*("|'|)$Key("|'|)\s*}\s+=.+?('|"));/\$Self->{'$Key'} = "$Param{$Key}"; # from original OTOBO config /g;
            }
            $Config .= $ChangedLine;

            # extra setting are injected after the line with 'Home'
            if ( $ExtraSettings && $ChangedLine =~ m/(\$Self->\{\s*("|'|)Home("|'|)\s*}\s+=.+?('|"));/ ) {
                $Config .= $ExtraSettings;
            }
        }
    }

    # Write new config file, the file handle is autoclosed as it is lexical to the block
    {
        open my $Out, '>:encoding(utf-8)', $ConfigFile    ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
            or return "Can't open $ConfigFile: $!";       ## no critic qw(OTOBO::ProhibitLowPrecedenceOps)
        print $Out $Config;
    }

    return;
}

1;
