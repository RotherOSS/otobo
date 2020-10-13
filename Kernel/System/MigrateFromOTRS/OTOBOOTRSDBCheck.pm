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
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
    'Kernel::System::MigrateFromOTRS::CloneDB::Backend',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOOTRSDBCheck - Checks if connect to OTRS DB is possible.

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

Returns a hashref on success.

    my $Result = $OTOBOOTRSDBCheck->Run();

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Set cache object with taskinfo and starttime to show current state in frontend
    {
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
    }

    # check needed stuff
    if ( !$Param{DBData} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OTRSDBSettings!",
        );

        return;
    }

    # create OTRS DB connection
    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::CloneDB::Backend');
    my $SourceDBObject = $CloneDBBackendObject->CreateOTRSDBConnection(
        OTRSDBSettings => $Param{DBData},
    );

    return {
        Message    => $Self->{LanguageObject}->Translate("Try database connect and sanity checks."),
        Comment    => $Self->{LanguageObject}->Translate("System was unable to connect to OTRS database."),
        Successful => 0,

    } unless $SourceDBObject;

    # check whether the relevant tables exist
    my $IsSane = $CloneDBBackendObject->SanityChecks(
        OTRSDBObject => $SourceDBObject,
    );

    return {
        Message    => $Self->{LanguageObject}->Translate("Try database connect and sanity checks."),
        Comment    => $Self->{LanguageObject}->Translate("Connect to OTRS database or sanity checks failed."),
        Successful => 0,
    } unless $IsSane;

    # looks good
    return {
        Message    => $Self->{LanguageObject}->Translate("Try database connect and sanity checks."),
        Comment    => $Self->{LanguageObject}->Translate("Database connect and sanity checks completed."),
        Successful => 1,
    };
}

1;
