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

package Kernel::System::MigrateFromOTRS::OTOBOItsmTablesMigrate;

use strict;
use warnings;
use v5.24;
use namespace::autoclean;
use utf8;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules
use List::Util qw(any);

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOItsmTablesMigrate - Migrate ITSM tables to OTOBO.

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

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Epoch          = $DateTimeObject->ToEpoch();
    my $Message        = $Self->{LanguageObject}->Translate("Migrate ITSM database tables.");

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOItsmTablesMigrate',
            SubTask   => "Migrate ITSM tables to OTOBO.",
            StartTime => $Epoch,
        },
    );

    my $Table = 'change_notification_message';

    if ( !$Self->TableExists( Table => $Table ) ) {
        return {
            Message    => $Message,
            Comment    => $Self->{LanguageObject}->Translate( "Nothing to do, as the the table '%s' does not exist.", $Table ),
            Successful => 1,
        };
    }

    my $Success = $Self->ReplaceSubstringsOfColumnValues(
        Table        => 'change_notification_message',
        Columns      => [qw(text)],
        Replacements =>
            [
                [ '<OTRS_',    '<OTOBO_' ],
                [ '&lt;OTRS_', '&lt;OTOBO_' ]
            ],
    );

    return {
        Message    => $Message,
        Comment    => $Self->{LanguageObject}->Translate( "UPDATE of the table '%s' failed.", $Table ),
        Successful => 0,
    } unless $Success;

    return {
        Message    => $Message,
        Comment    => $Self->{LanguageObject}->Translate("Migration completed."),
        Successful => 1,
    };
}

1;
