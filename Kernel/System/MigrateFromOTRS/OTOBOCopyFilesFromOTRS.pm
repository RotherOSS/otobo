# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
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

Execute the migration task. Called by C<Kernel::System::Migrate::_ExecuteRun()>.

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

            my %Result;
            $Result{Message}    = $Self->{LanguageObject}->Translate($Message);
            $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Need OTRSData->%s!', $Key );
            $Result{Successful} = 0;

            return \%Result;
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

    # Some of the setting of the OTOBO Kernel/Config.pm should reinjected in the file copied from OTRS
    my %OTOBOParams;
    {
        # remember the current DB-Settings
        for my $Key (qw( DatabaseHost Database DatabaseUser DatabasePw DatabaseDSN Home )) {
            $OTOBOParams{$Key} = $ConfigObject->Get($Key);
        }

        # under Docker we also want to keep the log settings
        if ( $ENV{OTOBO_RUNS_UNDER_DOCKER} ) {
            for my $Key (qw( LogModule LogModule::LogFile )) {
                $OTOBOParams{$Key} = $ConfigObject->Get($Key);
            }
        }
    }

    # Now we copy and clean the files in for{}
    my $OTOBOHome = $ConfigObject->Get('Home');
    FILE:
    for my $File (@FileList) {

        my $OTOBOPathFile = $OTOBOHome . $File;
        my $OTRSPathFile  = $OTRS6path . $File;

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

        # At last we need to reconfigure database settings in Kernel Config.pm.
        if ( $OTOBOPathFile =~ m/Config\.pm/ ) {
            $Self->ReConfigure(%OTOBOParams);
        }
    }

    $Self->DisableSecureMode();

    return {
        Message    => $Self->{LanguageObject}->Translate($Message),
        Comment    => $Self->{LanguageObject}->Translate("All needed files copied and migrated, perfect!"),
        Successful => 1,
    };
}

# Fix up Kernel/Config.pm
sub ReConfigure {
    my ( $Self, %Param ) = @_;

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

            # Replace old path with OTOBO path
            $ChangedLine =~ s/$Param{Home}/$ConfigFile/;

            # Need to comment out SecureMode
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
