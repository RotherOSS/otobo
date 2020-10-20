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

package Kernel::System::MigrateFromOTRS::OTOBOOTRSConnectionCheck;    ## no critic

use strict;
use warnings;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOOTRSConnectionCheck - Checks required framework version for update.

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

=head1 PUBLIC INTERFACE

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success.

    my $RequirementIsMet = $MigrateFromOTRSObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 Run()

check for initial conditions for running this migration step.

Returns 1 on success

    my $Result = $MigrateFromOTRSObject->Run();

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(OTRSData)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            my %Result;
            $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
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
            my %Result;
            $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible.");
            $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Need %s!', $Key );
            $Result{Successful} = 0;

            return \%Result;
        }
    }

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Epoch          = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOOTRSConnectionCheck',
            SubTask   => "Check if a connection via ssh or local is possible.",
            StartTime => $Epoch,
        },
    );

    my $OTRSHome;
    if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
        $OTRSHome = $Param{OTRSData}->{OTRSHome} . '/Kernel/Config.pm';
    }
    else {
        # Need to copy OTRS Kernel/Config.pm file and get path to it back
        $OTRSHome = $Self->CopyFileAndSaveAsTmp(
            FQDN     => $Param{OTRSData}->{FQDN},
            SSHUser  => $Param{OTRSData}->{SSHUser},
            Password => $Param{OTRSData}->{Password},
            Path     => $Param{OTRSData}->{OTRSHome} . '/Kernel/',
            Port     => $Param{OTRSData}->{Port},
            Filename => 'Config.pm',
            UserID   => 1,
        );
    }

    if ( !$OTRSHome ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't open Kernel/Config.pm file from OTRSHome: $Param{OTRSData}->{OTRSHome}!",
        );
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible.");
        $Result{Comment} = $Self->{LanguageObject}
            ->Translate( 'Can\'t open Kernel/Config.pm file from OTRSHome: %s!', $Param{OTRSData}->{OTRSHome} );
        $Result{Successful} = 0;

        return \%Result;
    }

    # Check OTOBO version
    my $ResultOTOBO = $Self->_CheckOTOBOVersion();
    if ( $ResultOTOBO->{Successful} == 0 ) {
        return $ResultOTOBO;
    }

    # Check OTRS version
    my $ResultOTRS = $Self->_CheckOTRSVersion(
        OTRSHome => $OTRSHome,
    );
    if ( $ResultOTRS->{Successful} == 0 ) {
        return $ResultOTRS;
    }

    # Everything is correct, return that info
    return {
        Message    => $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible."),
        Comment    => "$ResultOTOBO->{Comment}  $ResultOTRS->{Comment}",
        Successful => 1,
    };
}

sub _CheckOTOBOVersion {
    my ( $Self, %Param ) = @_;

    my $OTOBOHome = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # load Kernel/Config.pm file
    if ( !-e "$OTOBOHome/Kernel/Config.pm" ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate( '%s does not exist!', "$OTOBOHome/Kernel/Config.pm" );
        $Result{Successful} = 0;

        return \%Result;
    }

    # Everything if correct, return 1
    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("OTOBO Home exists.");
    $Result{Successful} = 1;

    return \%Result;
}

sub _CheckOTRSVersion {
    my ( $Self, %Param ) = @_;

    my $OTRSHome = $Param{OTRSHome};

    # load Kernel/Config.pm file
    if ( !-e "$OTRSHome" ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if we are able to connect to OTRS Home.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("Can't connect to OTRS file directory.");
        $Result{Successful} = 0;

        return \%Result;
    }

    # load Kernel/Config.pm file
    if ( !$Self->_CheckConfigpmAndWriteCache( ConfigpmPath => $OTRSHome ) ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if we are able to connect to OTRS Home.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("Can't connect to OTRS file directory.");
        $Result{Successful} = 0;

        return \%Result;
    }

    # Everything is correct, return %Result
    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Check if we are able to connect to OTRS Home.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Connect to OTRS file directory is possible.");
    $Result{Successful} = 1;

    return \%Result;
}

sub _CheckConfigpmAndWriteCache {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigFile  = $Param{ConfigpmPath};

    # Build config options to save in cache.
    # ConfigOption => CacheKeyName
    my %COptions = (
        DatabaseHost => 'DBHost',
        Database     => 'DBName',
        DatabaseUser => 'DBUser',
        DatabasePw   => 'DBPassword',
        DatabaseDSN  => 'DBDSN',
    );

    my %CacheOptions;

    ## no critic
    {
        open( my $In, '<', $ConfigFile )
            or return "Can't open $ConfigFile: $!";

        CONFIGLINE:
        while (<$In>) {

            # Search config option value and save in %CacheOptions{CacheKey} => ConfigOption
            if ( m/^\s*\$Self->\{['"\s]*(\w+)['"\s]*\}\s*=\s*['"](.+)['"]\s*;/ ) {
                for my $Key ( sort keys %COptions ) {
                    if ( lc($1) eq lc($Key) ) {
                        $CacheOptions{ $COptions{$Key} } = $2;

                        next CONFIGLINE;
                    }
                }
            }
        }
    }

    # Extract driver to load for install test.
    my ($DBType) = $CacheOptions{DBDSN} =~ m/^DBI:(.*?):/;

    if ( $DBType =~ m/mysql/ ) {
        $CacheOptions{DBType} = 'mysql';
    }
    elsif ( $DBType =~ m/Pg/ ) {
        $CacheOptions{DBType} = 'postgresql';
    }
    elsif ( $DBType =~ /Oracle/ ) {
        $CacheOptions{DBType} = 'oracle';
        $CacheOptions{DBPort} = ( $CacheOptions{DBDSN} =~ m/^DBI:.*:(\d+)/ );
    }

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'OTRSDBSettings',
        Value => {
            DBType     => $CacheOptions{DBType},
            DBHost     => $CacheOptions{DBHost},   # usually needs to be adapted when running under Docker
            DBUser     => $CacheOptions{DBUser},
            DBPassword => $CacheOptions{DBPassword},
            DBName     => $CacheOptions{DBName},
            DBDSN      => $CacheOptions{DBDSN},
            DBSID      => $CacheOptions{DBSID} || '',
            DBPort     => $CacheOptions{DBPort} || '',
        },
    );

    return 1;
}

1;
