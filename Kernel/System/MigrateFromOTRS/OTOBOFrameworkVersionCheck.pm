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

package Kernel::System::MigrateFromOTRS::OTOBOFrameworkVersionCheck;    ## no critic

use strict;
use warnings;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOFrameworkVersionCheck - Checks required framework version for update.

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

    # check needed stuff in OTRSData
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
            Task      => 'OTOBOFrameworkVersionCheck',
            SubTask   => "Check required OTOBO and OTRS framework version.",
            StartTime => $Epoch,
        },
    );

    my $OTRSHome;
    if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
        $OTRSHome = $Param{OTRSData}->{OTRSHome} . '/RELEASE';
    }
    else {
        # Need to copy OTRS RELEASE file and get path to it back
        $OTRSHome = $Self->CopyFileAndSaveAsTmp(
            FQDN     => $Param{OTRSData}->{FQDN},
            SSHUser  => $Param{OTRSData}->{SSHUser},
            Password => $Param{OTRSData}->{Password},
            Path     => $Param{OTRSData}->{OTRSHome},
            Port     => $Param{OTRSData}->{Port},
            Filename => 'RELEASE',
            UserID   => 1,
        );
    }

    if ( !$OTRSHome ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't open RELEASE file from OTRSHome: $Param{OTRSData}->{OTRSHome}!",
        );
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible.");
        $Result{Comment} = $Self->{LanguageObject}
            ->Translate( 'Can\'t open RELEASE file from OTRSHome: %s!', $Param{OTRSData}->{OTRSHome} );
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

    # Everything if correct, return 1
    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS version is correct.");
    $Result{Comment}    = $ResultOTOBO->{Comment} . ' ' . $ResultOTRS->{Comment};
    $Result{Successful} = 1;

    return \%Result;
}

sub _CheckOTOBOVersion {
    my ( $Self, %Param ) = @_;

    my $OTOBOHome = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # load RELEASE file
    if ( !-e "$OTOBOHome/RELEASE" ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate( '%s does not exist!', "$OTOBOHome/RELEASE" );
        $Result{Successful} = 0;

        return \%Result;
    }

    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$OTOBOHome/RELEASE" ) ) {    ## no critic
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
        $Result{Comment}
            = $Self->{LanguageObject}->Translate( 'Can\'t read OTOBO RELEASE file: %s: %s!', "$OTOBOHome/RELEASE", $! );
        $Result{Successful} = 0;

        return \%Result;
    }

    if ( $ProductName ne 'OTOBO' ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("No OTOBO system found!");
        $Result{Successful} = 0;

        return \%Result;
    }

    if ( $Version !~ m/^10\.1(.*)$/ ) {
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
        $Result{Comment} = $Self->{LanguageObject}
            ->Translate( 'You are trying to run this script on the wrong framework version %s!', $Version );
        $Result{Successful} = 0;

        return \%Result;
    }

    # Everything if correct, return 1
    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate( 'OTOBO Version is correct: %s.', $Version );
    $Result{Successful} = 1;

    return \%Result;
}

sub _CheckOTRSVersion {
    my ( $Self, %Param ) = @_;

    my $OTRSHome = $Param{OTRSHome};

    # load RELEASE file
    if ( !-e "$OTRSHome" ) {
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if OTRS version is correct.");
        $Result{Comment}
            = $Self->{LanguageObject}->Translate( 'Can\'t read OTRS RELEASE file: %s: %s!', $OTRSHome, $! );
        $Result{Successful} = 0;
        return \%Result;
    }

    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$OTRSHome" ) ) {    ## no critic
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if OTRS version is correct.");
        $Result{Comment}
            = $Self->{LanguageObject}->Translate( 'Can\'t read OTRS RELEASE file: %s: %s!', $OTRSHome, $! );
        $Result{Successful} = 0;

        return \%Result;
    }

    if ( $ProductName ne 'OTRS' ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTRS version is correct.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("No OTRS system found!");
        $Result{Successful} = 0;

        return \%Result;
    }

    if ( $Version !~ /^6\.0(.*)$/ ) {
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if OTRS version is correct.");
        $Result{Comment} = $Self->{LanguageObject}
            ->Translate( 'You are trying to run this script on the wrong framework version %s!', $Version );
        $Result{Successful} = 0;

        return \%Result;
    }

    # Everything if correct, return %Result
    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTRS version is correct.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate( 'OTRS Version is correct: %s.', $Version );
    $Result{Successful} = 1;

    return \%Result;
}

1;
