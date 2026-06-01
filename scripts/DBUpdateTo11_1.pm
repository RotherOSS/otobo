# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
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

package scripts::DBUpdateTo11_1;

use v5.24;
use strict;
use warnings;
use namespace::autoclean;
use utf8;

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::System::Main',
);

=head1 NAME

scripts::DBUpdateTo11_1 - Perform system upgrade from OTOBO 11.0 to 11.1

=head1 PUBLIC INTERFACE

=head1 Run

This method is run without parameters from the driver script F<scripts/DBUpdateTo11_1.pl>.

    scripts::DBUpdateTo11_0::Run();

=cut

sub Run {
    say "\nMigration started ...";

    my $SuccessfulMigration = 1;

    my @Tasks = (
        {
            # Rebuilding the config affects the subsequent tasks.
            # It is essential for at least SysConfigMigrateArticleActions.
            Name   => 'Rebuild the configuration as files in Kernel/Config/Files/XML have changed',
            Module => 'RebuildConfig',
        },
        {
            Name   => 'Increase translation content length',
            Module => 'DBUpdateTranslationLength',
        },
        {
            Name   => 'Add OIDC/OAuth2 database tables and fields.',
            Module => 'DBUpdateOIDC',
        },
        {
            Name   => 'Update mail_account table to support OIDC/OAuth2.',
            Module => 'DBUpdateOIDCMail',
        },
        {
            Name   => 'Add columns for namespace and process entity id to process element tables.',
            Module => 'DBAddProcessColumns',
        },
        {
            Name   => 'Update the list of installed packages',
            Module => 'UninstallMergedPackages',
        },
        {
            Name   => 'Add valid_id to postmaster_filter.',
            Module => 'DBUpdatePostMasterFilter',
        },
        {
            Name   => 'Add process dynamic fields to ticket zoom dynamic field screen configs.',
            Module => 'SysConfigUpdateTicketZoomDFScreens',
        },
        {
            Name   => 'Add X-OTOBO-From to PostmasterX-Header.',
            Module => 'SysConfigUpdatePostmasterXHeader',
        },
        {
            Name   => 'Migrate Article::Actions system configurations to new structure.',
            Module => 'SysConfigMigrateArticleActions',
        },
        {
            Name   => 'Update MultiValue attribute of Lens dynamic fields.',
            Module => 'UpdateLensDynamicFieldsMultiValue',
        },
        {
            Name   => 'Deactivates the system configuration setting for CustomerTicketSearch per default.',
            Module => 'SysConfigDeactivateCustomerTicketSearch',
        },
        {
            Name   => 'Migrate DynamicField namespaces to new system configuration structure.',
            Module => 'SysConfigMigrateDynamicFieldNamespaces',
        },
    );
    my $NumTasks = @Tasks;
    my $Count    = 1;

    TASK:
    for my $Task (@Tasks) {
        say "\tExecuting task $Count/$NumTasks '$Task->{Name}' ...";

        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( 'scripts::DBUpdateTo11_1::' . $Task->{Module} ) ) {
            $SuccessfulMigration = 0;

            last TASK;
        }

        my $Success = $Kernel::OM->Create( 'scripts::DBUpdateTo11_1::' . $Task->{Module} )->Run;

        if ( !$Success ) {
            $SuccessfulMigration = 0;

            last TASK;
        }
    }
    continue {
        $Count++;
    }

    # say good bye
    say 'Migration ', ( $SuccessfulMigration ? 'finished' : 'failed' );

    return $SuccessfulMigration;
}

1;
