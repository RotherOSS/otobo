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

package Kernel::System::MigrateFromOTRS::OTOBOOTRSConnectionCheck;

use strict;
use warnings;
use v5.24;
use utf8;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules

# CPAN modules

# OTOBO modules

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
    return 1;
}

=head2 Run()

Execute the migration task. Called by C<Kernel::System::MigrateFromOTRS::_ExecuteRun()>.

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

            return {
                Message    => $Self->{LanguageObject}->Translate('Check if OTOBO version is correct.'),
                Comment    => $Self->{LanguageObject}->Translate( 'Need %s!', $Key ),
                Successful => 0.
            };
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

    my $OTRSConfigpmPath;
    if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
        $OTRSConfigpmPath = $Param{OTRSData}->{OTRSHome} . '/Kernel/Config.pm';
    }
    else {
        # Need to copy OTRS Kernel/Config.pm file and get path to it back
        $OTRSConfigpmPath = $Self->CopyFileAndSaveAsTmp(
            FQDN     => $Param{OTRSData}->{FQDN},
            SSHUser  => $Param{OTRSData}->{SSHUser},
            Password => $Param{OTRSData}->{Password},
            Path     => $Param{OTRSData}->{OTRSHome} . '/Kernel/',
            Port     => $Param{OTRSData}->{Port},
            Filename => 'Config.pm',
            UserID   => 1,
        );
    }

    if ( !$OTRSConfigpmPath || !-e $OTRSConfigpmPath ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't open Kernel/Config.pm file from OTRSHome: $Param{OTRSData}->{OTRSHome}!",
        );
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Can\'t open Kernel/Config.pm file from OTRSHome: %s!', $Param{OTRSData}->{OTRSHome} );
        $Result{Successful} = 0;

        return \%Result;
    }

    # Check OTOBO version
    my $ResultOTOBO = $Self->_CheckOTOBOConfigpmExists();

    return $ResultOTOBO unless $ResultOTOBO->{Successful};

    # Check OTRS version
    my $ResultOTRS = $Self->_CheckOTRSConfigpm(
        OTRSConfigpmPath => $OTRSConfigpmPath,
    );

    return $ResultOTRS if $ResultOTRS->{Successful} == 0;

    # Everything is correct, return that info
    return {
        Message    => $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible."),
        Comment    => "$ResultOTOBO->{Comment}  $ResultOTRS->{Comment}",
        Successful => 1,
    };
}

sub _CheckOTOBOConfigpmExists {
    my ( $Self, %Param ) = @_;

    my $OTOBOHome = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $Message   = $Self->{LanguageObject}->Translate("Check if Kernel/Config.pm exists in OTOBO home.");

    # load Kernel/Config.pm file
    if ( !-e "$OTOBOHome/Kernel/Config.pm" ) {
        my %Result;
        $Result{Message}    = $Message;
        $Result{Comment}    = $Self->{LanguageObject}->Translate( '%s does not exist!', "$OTOBOHome/Kernel/Config.pm" );
        $Result{Successful} = 0;

        return \%Result;
    }

    # Everything if correct, return 1
    my %Result;
    $Result{Message}    = $Message;
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Kernel/Config.pm exists in OTOBO home");
    $Result{Successful} = 1;

    return \%Result;
}

sub _CheckOTRSConfigpm {
    my ( $Self, %Param ) = @_;

    my $OTRSConfigpmPath = $Param{OTRSConfigpmPath};

    # load Kernel/Config.pm file
    if ( !-e "$OTRSConfigpmPath" ) {
        return {
            Message    => $Self->{LanguageObject}->Translate("Check if we are able to connect to OTRS Home."),
            Comment    => $Self->{LanguageObject}->Translate("Can't connect to OTRS file directory."),
            Successful => 0,
        };
    }

    # look at Kernel/Config.pm file and extract DB connection settings
    if ( !$Self->_CheckConfigpmAndWriteCache( ConfigpmPath => $OTRSConfigpmPath ) ) {
        return {
            Message    => $Self->{LanguageObject}->Translate("Check if we are able to connect to OTRS Home."),
            Comment    => $Self->{LanguageObject}->Translate("Can't connect to OTRS file directory."),
            Successful => 0,
        };
    }

    # Everything is correct, return %Result
    return {
        Message    => $Self->{LanguageObject}->Translate("Check if we are able to connect to OTRS Home."),
        Comment    => $Self->{LanguageObject}->Translate("Connect to OTRS file directory is possible."),
        Successful => 1,
    };
}

sub _CheckConfigpmAndWriteCache {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigFile  = $Param{ConfigpmPath};

    # Extract options from Config.pm to save in cache.
    my %CacheOptions;
    {
        my %ConfigKey2CacheKey = (
            DatabaseHost => 'DBHost',
            Database     => 'DBName',
            DatabaseUser => 'DBUser',
            DatabasePw   => 'DBPassword',
            DatabaseDSN  => 'DBDSN',
        );

        open my $In, '<', $ConfigFile                  ## no critic qw(OTOBO::ProhibitOpen InputOutput::RequireBriefOpen)
            or return "Can't open $ConfigFile: $!";    ## no critic qw(OTOBO::ProhibitLowPrecedenceOps)

        CONFIGLINE:
        while ( my $Line = <$In> ) {

            # Search config option value and save in %CacheOptions{CacheKey} => ConfigOption
            # e.g.:  $Self->{'DatabaseUser'} = "otrs";
            next CONFIGLINE unless $Line =~ m/^\s*\$Self->\{['"\s]*(\w+)['"\s]*\}\s*=\s*['"](.+)['"]\s*;/;

            KEY:
            for my $Key ( sort keys %ConfigKey2CacheKey ) {

                next KEY unless lc $1 eq lc $Key;

                $CacheOptions{ $ConfigKey2CacheKey{$Key} } = $2;

                next CONFIGLINE;
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

        # This utterly depends on the conventions used in the OTRS Config.pm.
        # But the sane approach is to simply use the DSN from Config.pm.
        # Avoid a string eval, but try to support the common cases.
        # e.g. $Self->{'DatabaseDSN'} = "DBI:Oracle://$Self->{DatabaseHost}:1521/$Self->{Database}";
        # TODO: q{DatabaseHost} is not supported
        if ( $CacheOptions{DBHost} ) {
            $CacheOptions{DBDSN} =~ s/\$Self->\{\s*['"]?DatabaseHost['"]?\s*\}/$CacheOptions{DBHost}/;
        }
        if ( $CacheOptions{DBName} ) {
            $CacheOptions{DBDSN} =~ s/\$Self->\{\s*['"]?Database['"]?\s*\}/$CacheOptions{DBName}/;
        }
    }

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'OTRSDBSettings',
        Value => {
            DBType     => $CacheOptions{DBType},
            DBHost     => $CacheOptions{DBHost},       # usually needs to be adapted when running under Docker
            DBUser     => $CacheOptions{DBUser},
            DBPassword => $CacheOptions{DBPassword},
            DBName     => $CacheOptions{DBName},
            DBDSN      => $CacheOptions{DBDSN},
        },
    );

    return 1;
}

1;
