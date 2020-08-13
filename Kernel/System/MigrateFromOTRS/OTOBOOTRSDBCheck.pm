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

package Kernel::System::MigrateFromOTRS::OTOBOOTRSDBCheck;    ## no critic

use strict;
use warnings;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

use version;

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::MigrateFromOTRS::CloneDB::Backend',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOOTRSDBCheck - Checks if connect to OTRS DB is possible.

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOOTRSDBCheck - Copy Database

=cut

=head2 Run()

Check for initial conditions for running this migration step.

Returns 1 on success:

    my $Result = $OTOBOOTRSDBCheck->Run();

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    my %Result;

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Epoch          = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOOTRSDBCheck',
            SubTask   => "Checks if connect to OTRS DB is possible.",
            StartTime => $Epoch,
        },
    );

    # check needed stuff
    if ( !$Param{DBData} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBSettings!",
        );
        return;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # create CloneDB backend object
    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::CloneDB::Backend');

    # create OTRS DB connection
    my $SourceDBObject = $CloneDBBackendObject->CreateOTRSDBConnection(
        OTRSDBSettings => $Param{DBData},
    );

    if ( !$SourceDBObject ) {
        $Result{Message}    = $Self->{LanguageObject}->Translate("Try database connect and sanity checks.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("System was unable to connect to OTRS database.");
        $Result{Successful} = 0;
        return \%Result;
    }

    my $SanityResult = $CloneDBBackendObject->SanityChecks(
        OTRSDBObject => $SourceDBObject,
    );

    if ( !$SanityResult ) {
        $Result{Message}    = $Self->{LanguageObject}->Translate("Try database connect and sanity checks.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("Connect to OTRS database or sanity checks failed.");
        $Result{Successful} = 0;
        return \%Result;
    }

    $Result{Message}    = $Self->{LanguageObject}->Translate("Try database connect and sanity checks.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Database connect and sanity checks completed.");
    $Result{Successful} = 1;
    return \%Result;

}

1;
