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

package Kernel::System::MigrateFromOTRS::OTOBOCopyFilesFromOTRS;    ## no critic

use strict;
use warnings;
use File::Copy qw(copy);

use parent qw(Kernel::System::MigrateFromOTRS::Base);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::FileTemp',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $DBUpdateTo6Object->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

        return 1;
    }

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOMigrateConfigFromOTRS - Copy OTRS Data to OTOBO Server

=cut

# TODO: Use sub Reconfigure to reconfigure Database after copy

sub Run {
    my ( $Self, %Param ) = @_;

    my $OTRS6path;
    my $OTOBOHome    = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my %OTOBODBParam;
    my %Result;
    my $Success = 1;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create( 'Kernel::System::DateTime');
    my $Epoch = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task        => 'OTOBOCopyFilesFromOTRS',
            SubTask     => "Copy files from OTRS to OTOBO.",
            StartTime   => $Epoch,
        },
    );

    # check needed stuff
    for my $Key (qw( OTRSData )) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            $Result{Message}    = $Self->{LanguageObject}->Translate( "Check if OTOBO version is correct." );
            $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Need %s!', $Key );
            $Result{Successful} = 0;
            return \%Result;
        }
    }

    # check needed stuff
    for my $Key (qw(OTRSLocation OTRSHome)) {
        if ( !$Param{OTRSData}->{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need OTRSData->$Key!"
            );
            $Result{Message}    = $Self->{LanguageObject}->Translate( "Check if OTOBO and OTRS connect is possible." );
            $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Need %s!', $Key );
            $Result{Successful} = 0;
            return \%Result;
        }
    }

    if ($Param{OTRSData}->{OTRSLocation} eq 'localhost') {
        $OTRS6path = $Param{OTRSData}->{OTRSHome};
    } else {
        # Need to copy OTRS RELEASE file and get path to it back
        $OTRS6path = $Self->CopyFileAndSaveAsTmp (
            FQDN        => $Param{OTRSData}->{FQDN},
            SSHUser     => $Param{OTRSData}->{SSHUser},
            Password    => $Param{OTRSData}->{Password},
            Path        => $Param{OTRSData}->{OTRSHome},
            Port        => $Param{OTRSData}->{Port},
            Filename    => 'RELEASE',
            UserID      => 1,
        );
    }

    if ( !$OTRS6path ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't open RELEASE file from OTRSHome: $Param{OTRSData}->{OTRSHome}!",
        );
        $Result{Message}    = $Self->{LanguageObject}->Translate( "Check if OTOBO and OTRS connect is possible." );
        $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Can\'t open RELEASE file from OTRSHome: %s!', $Param{OTRSData}->{OTRSHome} );
        $Result{Successful} = 0;
        return \%Result;
    }

    # ------------------------------------------------
    # Copy files from OTRS to OTOBO and clean content
    # ------------------------------------------------

    # Get filelist with needed files for copy from OTRS
    my @FileList = $Self->CopyFileListfromOTRSToOTOBO();

    # Now we copy and clean the files in for{}
    FILE:
    for my $File ( @FileList ) {

        my $OTOBOPathFile = $OTOBOHome.$File;
        my $OTRSPathFile = $OTRS6path.$File;

        if ( $OTOBOPathFile =~ /Config\.pm/) {

            $OTOBODBParam{DatabaseHost} = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseHost');
            $OTOBODBParam{Database}     = $Kernel::OM->Get('Kernel::Config')->Get('Database');
            $OTOBODBParam{DatabaseUser} = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseUser');
            $OTOBODBParam{DatabasePw}   = $Kernel::OM->Get('Kernel::Config')->Get('DatabasePw');
            $OTOBODBParam{DatabaseDSN}  = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');
            $OTOBODBParam{Home}         = $Kernel::OM->Get('Kernel::Config')->Get('Home');
        }

        # First we copy the file from OTRS HOME to OTOBO HOME
        if ( -e $OTRSPathFile ) {
            my $ExitCode;
            # We copy only the content, if OTRS exists on localhost, otherwise we move the content from tmp
            if ( -f $OTRSPathFile ) {
                if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
                    $ExitCode = system( "cp $OTRSPathFile $OTOBOPathFile" );
                } else {
                    $ExitCode = system( "mv $OTRSPathFile $OTOBOPathFile" );
                }

            } elsif (-d $OTRSPathFile ) {
                if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
                    $ExitCode = system( "cp -r $OTRSPathFile/* $OTOBOPathFile" );
                } else {
                    $ExitCode = system( "mv $OTRSPathFile/* $OTOBOPathFile" );
                }
            }
            if ( $ExitCode && $ExitCode != 0 && $ExitCode != 256) {
                print STDERR "EXIT: $ExitCode \n OTRSPath: $OTRSPathFile\n OTOBO: $OTOBOPathFile\n ";
                $Result{Message}    = "Copy and migrate files from OTRS";
                $Result{Comment}    = "Can\'t copy or move files from OTRS!";
                $Result{Successful} = 0;
                return \%Result;
            }
        } else {
            next FILE;
        }

        # We need to clean files inside a directory
        if ( -d $OTOBOPathFile ) {

            # Clean license header
            $Self->CleanLicenseHeaderInDir(
                Path         => $OTOBOPathFile,
                Filter       => '*',
                Recursive    => 1,
                UserID       => 1,
            );

            $Self->CleanOTRSFilesToOTOBOStyleInDir(
                Path         => $OTOBOPathFile,
                Filter       => '*',
                Recursive    => 1,
                UserID       => 1,
            );
        }
        # We need to copy only a single file
        elsif ( -f $OTOBOPathFile ) {

            $Self->CleanLicenseHeader(
                File          => $OTOBOPathFile,
                UserID        => 1,
            );

            $Self->CleanOTRSFileToOTOBOStyle(
                File          => $OTOBOPathFile,
                UserID        => 1,
            );
        }

        # At least we need to reconfigure database settings in Kernel Config.pm.
        if ( $OTOBOPathFile =~ /Config\.pm/) {
            $Self->ReConfigure(%OTOBODBParam);
        }
    }

    $Result{Message}    = $Self->{LanguageObject}->Translate( "Copy and migrate files from OTRS" );
    $Result{Comment}    = $Self->{LanguageObject}->Translate( "All needed files copied and migrated, perfect!" );
    $Result{Successful} = 1;

    return \%Result;
}

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

    # Read config file.
    my $ConfigFile = $ConfigObject->Get("Home")."/Kernel/Config.pm";
    ## no critic
    open( my $In, '<', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    ## use critic
    my $Config = '';
    while (<$In>) {

        # Skip empty lines or comments.
        if ( !$_ || $_ =~ /^\s*#/ || $_ =~ /^\s*$/ ) {
            $Config .= $_;
        }
        else {
            my $NewConfig = $_;

            # Replace config with %Param.
            for my $Key ( sort keys %Param ) {

                # Database passwords can contain characters like '@' or '$' and should be single-quoted
                #   same goes for database hosts which can be like 'myserver\instance name' for MS SQL.
                if ( $Key eq 'DatabasePw' || $Key eq 'DatabaseHost' ) {
                    $NewConfig =~
                        s/(\$Self->\{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = '$Param{$Key}';/g;
                }
                else {
                    $NewConfig =~
                        s/(\$Self->\{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = "$Param{$Key}";/g;
                }
            }
            $Config .= $NewConfig;
        }
    }
    close $In;

    # Write new config file.
    ## no critic
    open( my $Out, '>:utf8', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    print $Out $Config;
    ## use critic
    close $Out;

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTOBO project (L<https://otobo.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
