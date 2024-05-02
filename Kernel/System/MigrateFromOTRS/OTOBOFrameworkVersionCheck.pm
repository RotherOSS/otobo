# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2024 Rother OSS GmbH, https://otobo.de/
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

package Kernel::System::MigrateFromOTRS::OTOBOFrameworkVersionCheck;

use strict;
use warnings;
use v5.24;
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
    'Kernel::System::Main',
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
                Message    => $Self->{LanguageObject}->Translate("Check if OTOBO version is correct."),
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
                Message    => $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible."),
                Comment    => $Self->{LanguageObject}->Translate( 'Need %s!', $Key ),
                Successful => 0,
            };
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

    my $ReleasePath;
    if ( $Param{OTRSData}->{OTRSLocation} eq 'localhost' ) {
        $ReleasePath = $Param{OTRSData}->{OTRSHome} . '/RELEASE';
    }
    else {
        # Need to copy OTRS RELEASE file and get path to it back
        $ReleasePath = $Self->CopyFileAndSaveAsTmp(
            FQDN     => $Param{OTRSData}->{FQDN},
            SSHUser  => $Param{OTRSData}->{SSHUser},
            Password => $Param{OTRSData}->{Password},
            Path     => $Param{OTRSData}->{OTRSHome},
            Port     => $Param{OTRSData}->{Port},
            Filename => 'RELEASE',
            UserID   => 1,
        );
    }

    if ( !$ReleasePath || !-e $ReleasePath ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't open RELEASE file from OTRSHome: $Param{OTRSData}->{OTRSHome}!",
        );

        return {
            Message    => $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS connect is possible."),
            Comment    => $Self->{LanguageObject}->Translate( 'Can\'t open RELEASE file from OTRSHome: %s!', $Param{OTRSData}->{OTRSHome} ),
            Successful => 0,
        };
    }

    # Check OTOBO version
    my $ResultOTOBO = $Self->_CheckOTOBOVersion();

    return $ResultOTOBO unless $ResultOTOBO->{Successful};

    # Check OTRS version
    my $ResultOTRS = $Self->_CheckOTRSRelease(
        OTRSReleasePath => $ReleasePath,
    );

    return $ResultOTRS unless $ResultOTRS->{Successful};

    # Everything if correct, return success
    return {
        Message    => $Self->{LanguageObject}->Translate("Check if OTOBO and OTRS version is correct."),
        Comment    => join( ' ', $ResultOTOBO->{Comment}, $ResultOTRS->{Comment} ),
        Successful => 1,
    };
}

sub _CheckOTOBOVersion {
    my ( $Self, %Param ) = @_;

    my $OTOBOHome = $Kernel::OM->Get('Kernel::Config')->Get('Home');
    my $Message   = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
    my $Location  = "$OTOBOHome/RELEASE";

    # check existence of the RELEASE file
    if ( !-e $Location ) {
        return
            {
                Message    => $Message,
                Comment    => $Self->{LanguageObject}->Translate( '%s does not exist!', $Location ),
                Successful => 0,
            };
    }

    # parse RELEASE file
    my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');
    my $ReleaseInfo = $MainObject->GetReleaseInfo( Location => $Location );

    KEY:
    for my $Key (qw(Product Version)) {
        next KEY if $ReleaseInfo->{$Key};    # looks good

        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate( q{Can't find %s in OTOBO RELEASE file: %s}, $Key, $Location ),
            Successful => 0,
        };
    }

    if ( $ReleaseInfo->{Product} ne 'OTOBO' ) {
        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate("No OTOBO system found!"),
            Successful => 0,
        };
    }

    # Note: this version check must be updated for every major and minor version
    if ( $ReleaseInfo->{Version} !~ m/^10\.1/ ) {
        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate( 'You are trying to run this script on the wrong framework version %s!', $ReleaseInfo->{Version} ),
            Successful => 0,
        };
    }

    # Everything if correct, return 1
    return {
        Message    => $Message,
        Comment    => $Self->{LanguageObject}->Translate( 'OTOBO Version is correct: %s.', $ReleaseInfo->{Version} ),
        Successful => 1,
    };
}

# Znuny LTS is also accepted for migration
sub _CheckOTRSRelease {
    my ( $Self, %Param ) = @_;

    my $Message  = $Self->{LanguageObject}->Translate("Check if OTRS version is correct.");
    my $Location = $Param{OTRSReleasePath};

    # load RELEASE file
    if ( !-e $Location ) {
        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate( 'OTRS RELEASE file %s does not exist!', $Location ),
            Successful => 0,
        };
    }

    my $MainObject  = $Kernel::OM->Get('Kernel::System::Main');
    my $ReleaseInfo = $MainObject->GetReleaseInfo( Location => $Location );
    if ( !exists $ReleaseInfo->{Product} || !exists $ReleaseInfo->{Version} ) {
        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate( 'Can\'t read OTRS RELEASE file: %s', $Location ),
            Successful => 0,
        };
    }

    my %ProductNameIsValid = (
        '((OTRS)) Community Edition' => 'https://otrscommunityedition.com/',
        'OTRS'                       => 'https://otrs.com/',
        'Znuny LTS'                  => 'https://www.znuny.org/',
    );

    if ( !$ProductNameIsValid{ $ReleaseInfo->{Product} } ) {
        my $ExpectedNames = join ', ', map {"'$_'"} sort keys %ProductNameIsValid;

        return {
            Message => $Message,
            Comment => $Self->{LanguageObject}->Translate("No OTRS system found!"),
            Comment => $Self->{LanguageObject}->Translate(
                "Unknown PRODUCT found in OTRS RELASE file: %s. Expected values are %s.",
                $Location,
                $ExpectedNames
            ),
            Successful => 0,
        };
    }

    if ( $ReleaseInfo->{Version} !~ m/^6|7\.0(.*)$/ ) {
        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate( 'You are trying to run this script on the wrong framework version %s!', $ReleaseInfo->{Version} ),
            Successful => 0,
        };
    }

    # Everything if correct, return 1
    return {
        Message    => $Message,
        Comment    => $Self->{LanguageObject}->Translate( 'OTRS Version is correct: %s.', $ReleaseInfo->{Version} ),
        Successful => 1,
    };
}

1;
