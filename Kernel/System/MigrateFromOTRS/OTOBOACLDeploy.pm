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

package Kernel::System::MigrateFromOTRS::OTOBOACLDeploy;

use strict;
use warnings;
use namespace::autoclean;

use parent qw(Kernel::System::MigrateFromOTRS::Base);

# core modules

# CPAN modules

# OTOBO modules

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::ACL::DB::ACL',
    'Kernel::System::Cache',
    'Kernel::System::DateTime',
);

=head1 NAME

Kernel::System::MigrateFromOTRS::OTOBOACLDeploy - Deploy the acl configuration.

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

    $CacheObject->Set(
        Type  => 'OTRSMigration',
        Key   => 'MigrationState',
        Value => {
            Task      => 'OTOBOACLDeploy',
            SubTask   => "Deploy new ACL settings.",
            StartTime => $Epoch,
        },
    );

    my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZACL.pm';

    my $ACLDumpSuccess = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL')->ACLDump(
        ResultType => 'FILE',
        Location   => $Location,
        UserID     => 1,
    );

    if ( !$ACLDumpSuccess ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Deploy the ACL configuration.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("There was an error synchronizing the ACLs.");
        $Result{Successful} = 0;

        return \%Result;
    }

    my $Success = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL')->ACLsNeedSyncReset();

    # remove preselection cache TODO: rebuild the cache properly (a simple $FieldRestrictionsObject->SetACLPreselectionCache(); uses the old ACLs)
    $CacheObject->Delete(
        Type => 'TicketACL',
        Key  => 'Preselection',
    );

    if ( !$Success ) {
        my %Result;
        $Result{Message}    = $Self->{LanguageObject}->Translate("Deploy the ACL configuration.");
        $Result{Comment}    = $Self->{LanguageObject}->Translate("There was an error setting the entity sync status.");
        $Result{Successful} = 0;

        return \%Result;
    }

    my %Result;
    $Result{Message}    = $Self->{LanguageObject}->Translate("Deploy the ACL configuration.");
    $Result{Comment}    = $Self->{LanguageObject}->Translate("Deployment completed, perfect!");
    $Result{Successful} = 1;

    return \%Result;
}

1;
