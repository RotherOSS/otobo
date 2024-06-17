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

package Kernel::System::MigrateFromOTRS::OTOBODatabaseMigrate;

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
    return 1;
}

=head2 Run()

Execute the migration task. Called by C<Kernel::System::MigrateFromOTRS::Run()>.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # string used for progress and log messages
    my $Message = $Self->{LanguageObject}->Translate('Copy database.');

    # check needed stuff
    for my $Key (qw(DBData)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );

            return {
                Message    => $Message,
                Comment    => $Self->{LanguageObject}->Translate( 'Need %s!', $Key ),
                Successful => 0,
            };
        }
    }

    # skip for previously/manually finished DB migration
    if ( $Param{DBData}{SkipDBMigration} ) {
        return {
            Successful => 1,
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate("Skipped..."),
        };
    }

    # check needed stuff
    # TODO: why not simple work with the DSN only?
    KEY:
    for my $Key (qw(DBDSN DBType DBHost DBUser DBPassword DBName)) {

        # no complaints when the key has a value
        next KEY if $Param{DBData}->{$Key};

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DBData->$Key!"
        );

        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate( 'Need %s!', "DBData->$Key" ),
            Successful => 0,
        };
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

    # create OTRS DB connection, that is an instance of Kernel::System::DB
    my $SourceDBObject = $CloneDBBackendObject->CreateOTRSDBConnection(
        OTRSDBSettings => $Param{DBData},
    );

    return {
        Message    => $Message,
        Comment    => $Self->{LanguageObject}->Translate('System was unable to connect to OTRS database.'),
        Successful => 0,
    } unless $SourceDBObject;

    # TODO: what happens when SanityChecks() is not successful
    my $SanityCheck = $CloneDBBackendObject->SanityChecks(
        OTRSDBObject => $SourceDBObject,
        Message      => $Message,
    );

    if ( $SanityCheck->{Successful} ) {
        my $TransferIsOK = $CloneDBBackendObject->DataTransfer(
            OTRSDBObject   => $SourceDBObject,
            OTRSDBSettings => $Param{DBData},
        );

        # undef is returned when the DataTransfer bails out
        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate('System was unable to complete data transfer.'),
            Successful => 0,
        } unless $TransferIsOK;

        # in some cases there is an error with more informative messages
        if ( ref $TransferIsOK eq 'HASH' && exists $TransferIsOK->{Successful} && !$TransferIsOK->{Successful} ) {
            return {
                Message    => $Message,
                Comment    => join( "\n", ( $TransferIsOK->{Messages} // [] )->@* ),
                Successful => 0,
            };

        }
    }

    # Now that the data is transfered the cache might contain obsolete values.
    # Purge the cache, except the entries that concerns the migration directly.
    $Self->CacheCleanup();

    return {
        Message    => $Message,
        Comment    => $Self->{LanguageObject}->Translate('Data transfer completed.'),
        Successful => 1,
    };
}

1;
