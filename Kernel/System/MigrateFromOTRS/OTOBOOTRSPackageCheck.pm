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

package Kernel::System::MigrateFromOTRS::OTOBOOTRSPackageCheck;    ## no critic

use strict;
use warnings;

use parent qw(Kernel::System::MigrateFromOTRS::Base);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::MigrateFromOTRS::CloneDB::Backend',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOOTRSPackageCheck - Check which packages are installed on both systems.

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

=head1 DESCRIPTION

Currently not used.

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

sub Run {
    my ( $Self, %Param ) = @_;

    my %Result;

    # check needed stuff
    for my $Key (qw(DBData)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
            $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Need %s!', $Key );
            $Result{Successful} = 0;
            return \%Result;
        }
    }

    # check needed stuff
    for my $Key (qw(DBDSN DBType DBHost DBUser DBPassword DBName)) {
        if ( !$Param{DBData}->{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need DBData->$Key!"
            );
            $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
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
            Task      => 'OTOBOOTRSPackageCheck',
            SubTask   => "Check which packages are installed on both systems.",
            StartTime => $Epoch,
        },
    );

    if ( $Param{DBData}->{DBType} =~ /oracle/ ) {
        for my $Key (qw(DBSID DBPort)) {
            if ( !$Param{DBData}->{$Key} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need DBData->$Key!"
                );
                $Result{Message}    = $Self->{LanguageObject}->Translate("Check if OTOBO version is correct.");
                $Result{Comment}    = $Self->{LanguageObject}->Translate( 'Need %s for Oracle db!', $Key );
                $Result{Successful} = 0;
                return \%Result;
            }
        }
    }

    # Set cache object with taskinfo and starttime to show current state in frontend
    $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $Epoch          = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOOTRSPackageCheck',
            SubTask   => 'Check if OTOBO and OTRS versions are correct.',
            StartTime => $Epoch,
        },
    );

    my $OTRSPackRef = $Self->_GetPackages(
        %Param,
    );

    my $OTOBOPackRef = $Self->_GetPackages(
    );

    # Check OTOBO version
    my @OTRSPackages;
    push( @OTRSPackages, @{$OTRSPackRef} );
    my @OTOBOPackages;
    push( @OTOBOPackages, @{$OTOBOPackRef} );

    # Remove all packages which in both systems installed.
    # First we create a hash
    my %TmpOTRSHash  = map { $_ => 1 } @OTRSPackages;
    my %TmpOTOBOHash = map { $_ => 1 } @OTOBOPackages;

    # Remove if not exist in hash
    @OTOBOPackages = grep { !exists $TmpOTRSHash{$_} } @OTOBOPackages;
    @OTRSPackages  = grep { !exists $TmpOTOBOHash{$_} } @OTRSPackages;

    # Get ignore package list from Base.pm
    my @IgnorePackageList = $Self->PackageMigrateIgnorePackages();

    FILE:
    for my $PackageInfo (@IgnorePackageList) {
        my $Name = $PackageInfo->{PackageName};

        # If PackageName is in ignroe list, we remove the package. TODO: Check and return preselection
        @OTRSPackages = grep { $_ !~ /$Name/ } @OTRSPackages;

    }

    if ( IsArrayRefWithData( \@OTRSPackages ) ) {

        my $MessageString;
        for my $Pack (@OTRSPackages) {
            $MessageString .= $Pack . ', ';
        }

        $Result{Message} = $Self->{LanguageObject}->Translate("Check if all necessary packages are installed.");
        $Result{Comment}
            = $Self->{LanguageObject}->Translate("The following packages are only installed in OTRS:") . $MessageString
            . $Self->{LanguageObject}->Translate(
            "Please install (or uninstall) the packages before migration. If a package doesn't exist for OTOBO so far, please contact the OTOBO Team at bugs\@otobo.org. We will find a solution."
            );
        $Result{Successful} = 0;
        $Result{Content}    = \@OTRSPackages;
        return \%Result;
    }

    $Result{Message} = $Self->{LanguageObject}->Translate("Check if all necessary packages are installed.");
    $Result{Comment} = $Self->{LanguageObject}->Translate("The same packages are installed on both systems, perfect!");
    $Result{Successful} = 1;
    return \%Result;
}

=head2 _GetPackages()

Parse and execute an XML array.

    $Self->_GetPackages(
        DBDSN           => "DSN",               # optional (if not given Config.pm used)
        DatabaseUser    => "root",              # optional (if not given Config.pm used)
        DatabasePw      => 'Password',          # optional (if not given Config.pm used)
        Type            => 'mysql',             # optional (if not given Config.pm used)
        },
    );

=cut

sub _GetPackages {
    my ( $Self, %Param ) = @_;

    my $DBObject;
    my $DBData = $Param{DBData};

    # If DBDSN is given, we need a connection =! otobo database
    if ( defined $DBData ) {

        # create CloneDB backend object
        my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::CloneDB::Backend');

        # create DB connections
        $DBObject = $CloneDBBackendObject->CreateOTRSDBConnection(
            OTRSDBSettings => $DBData,
        );
    }
    else {
        $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    }

    # check if value exists already
    $DBObject->Prepare(
        SQL => "SELECT name FROM package_repository",
    );

    my @OTOBONames;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push( @OTOBONames, $Row[0] );
    }

    return \@OTOBONames;
}

1;
