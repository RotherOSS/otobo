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

package Kernel::System::MigrateFromOTRS::OTOBOPerlModulesCheck;

use strict;
use warnings;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOPerlModulesCheck - call otobo.CheckModules.pl

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

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # Set cache object with taskinfo and starttime to show current state in frontend
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');
    my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $Epoch          = $DateTimeObject->ToEpoch();

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOPerlModulesCheck',
            SubTask   => "Check if all needed Perl modules have been installed.",
            StartTime => $Epoch,
        },
    );

    my $ScriptPath = "$Home/bin/otobo.CheckModules.pl";

    # verify check modules script exist
    if ( !-e $ScriptPath ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Check if all needed Perl modules have been installed.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate( '%s script does not exist.', $ScriptPath );
        $Result{Successful} = 0;

        return \%Result;
    }

    # do never write anything on STDOUT here. It would break the following
    # AJAX scripts not expecting addtional information. We need the ExitCode
    # only. So redirect STDOUT to STDERR.
    my $ExitCode = system("$ScriptPath -list >&2");

    if ( $ExitCode != 0 ) {
        my %Result;
        $Result{Message} = $Self->{LanguageObject}->Translate("Check if all needed Perl modules have been installed.");
        $Result{Comment} = $Self->{LanguageObject}->Translate(
            "One or more required Perl modules are missing. Please install them as recommended, and run the migration script again."
        );
        $Result{Successful} = 0;

        return \%Result;
    }

    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Check if all needed Perl modules have been installed.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("All required Perl modules have been installed, perfect!");
    $Result{Successful} = 1;

    return \%Result;
}

1;
