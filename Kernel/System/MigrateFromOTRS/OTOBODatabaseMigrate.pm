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

package Kernel::System::MigrateFromOTRS::OTOBODatabaseMigrate;    ## no critic

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
    'Kernel::System::MigrateFromOTRS::CloneDB::Backend',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBODatabaseMigrate - Copy Database

=head1 SYNOPSIS

    # to be called from L<Kernel::Modules::MigrateFromOTRS>.

=head1 PUBLIC INTERFACE

=head2 CheckPreviousRequirement()

check for initial conditions for running this migration step.

Returns 1 on success.

    my $RequirementIsMet = $MigrateFromOTRSObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my $Self = shift;
    my %Param = @_;

    return 1;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    # check needed stuff
    for my $Key (qw(DBData)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );

            return {
                Message    => $Self->{LanguageObject}->Translate("Check if OTOBO version is correct."),
                Comment    => $Self->{LanguageObject}->Translate( 'Need %s!', $Key ),
                Successful => 0,
            }
        }
    }

    # check needed stuff
    for my $Key (qw(DBDSN DBType DBHost DBUser DBPassword DBName)) {
        if ( !$Param{DBData}->{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need DBData->$Key!"
            );

            return {
                Message    => $Self->{LanguageObject}->Translate("Check if OTOBO version is correct."),
                Comment    => $Self->{LanguageObject}->Translate( 'Need %s!', $Key ),
                Successful => 0,
            }
        }
    }

    # TODO: why no ports for MySQL and PostgreSQL ?
    if ( $Param{DBData}->{DBType} =~ m/oracle/ ) {
        for my $Key (qw(DBSID DBPort)) {
            if ( !$Param{DBData}->{$Key} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need DBData->$Key!"
                );

                return {
                    Message    => $Self->{LanguageObject}->Translate("Check if OTOBO version is correct."),
                    Comment    => $Self->{LanguageObject}->Translate( 'Need %s for Oracle db!', $Key ),
                    Successful => 0,
                }
            }
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
            Task      => 'OTOBODatabaseMigrate',
            SubTask   => "Copy Database from type $Param{DBData}->{DBType} to OTOBO DB.",
            StartTime => $Epoch,
        },
    );

    # create CloneDB backend object
    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::MigrateFromOTRS::CloneDB::Backend');

    # create OTRS DB connection
    my $SourceDBObject = $CloneDBBackendObject->CreateOTRSDBConnection(
        OTRSDBSettings => $Param{DBData},
    );

    return {
        Message    => $Self->{LanguageObject}->Translate("Copy database."),
        Comment    => $Self->{LanguageObject}->Translate("System was unable to connect to OTRS database."),
        Successful => 0,
    } unless $SourceDBObject;

    my $IsSane = $CloneDBBackendObject->SanityChecks(
        OTRSDBObject => $SourceDBObject,
    );

    if ($IsSane) {
        my $TransferIsOK = $CloneDBBackendObject->DataTransfer(
            OTRSDBObject   => $SourceDBObject,
            OTRSDBSettings => $Param{DBData},
        );

        return {
            Message    => $Self->{LanguageObject}->Translate("Copy database."),
            Comment    => $Self->{LanguageObject}->Translate("System was unable to complete data transfer."),
            Successful => 0,
        } unless $TransferIsOK;
    }

    return {
        Message    => $Self->{LanguageObject}->Translate("Copy database."),
        Comment    => $Self->{LanguageObject}->Translate("Data transfer completed."),
        Successful => 1,
    }
}

1;
